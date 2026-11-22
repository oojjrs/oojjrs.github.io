using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

class FrameReader
{
    [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr hwnd, out int processId);
    [DllImport("kernel32.dll", CharSet=CharSet.Unicode)] static extern int GetCurrentPackageFamilyName(ref uint length, StringBuilder name);
    static readonly object sync = new object();
    static readonly Dictionary<string, Chain> chains = new Dictionary<string, Chain>();
    static int tracked, lastForeground;
    static int pidIndex=-1, chainIndex=-1, timeIndex=-1, modeIndex=-1;
    static string folder, binary, session;
    static DateTime lastReport, inspectAgain;
    static string lastValue, lastSignal, targetSignal="";
    static string lastCandidate;
    static long targetStart;
    static bool ordinary=true, fullscreen;

    class Chain
    {
        internal readonly Queue<double> timestamps = new Queue<double>();
        internal double latest;
        internal long lastTick;
        internal bool direct;
    }

    static void UpdateTarget()
    {
        int pid;
        var hwnd=GetForegroundWindow();
        GetWindowThreadProcessId(hwnd, out pid);
        if (pid==tracked && pid>0) {
            fullscreen=!ordinary && GameWindow.CoversMonitor(hwnd);
        }
        if (pid==lastForeground && DateTime.UtcNow<inspectAgain) return;
        bool changed=pid!=lastForeground;
        lastForeground=pid;
        inspectAgain=DateTime.MaxValue;
        string signal="";
        long start=0;
        bool skip=true;
        if (pid>0) try {
            using (var process=Process.GetProcessById(pid)) {
                string name=process.ProcessName;
                if (name=="Widget" || name=="XboxGameBarWidgets" || name.StartsWith("GameBar",StringComparison.OrdinalIgnoreCase)) return;
                skip=GameWindow.IsOrdinaryApp(name);
                if (!skip) {
                    signal=GameWindow.Classify(process);
                    if (changed && signal.Length==0) inspectAgain=DateTime.UtcNow.AddSeconds(3);
                    if (!storeMode)
                        start=process.StartTime.ToUniversalTime().ToFileTimeUtc()/10000000L-11644473600L;
                }
            }
        } catch (ArgumentException) {} catch (InvalidOperationException) {} catch (System.ComponentModel.Win32Exception) {}
        ordinary=skip;
        targetStart=start;
        targetSignal=signal;
        fullscreen=!ordinary && GameWindow.CoversMonitor(hwnd);
        lock(sync) {
            if (tracked==pid) return;
            tracked=pid;
            chains.Clear();
        }
    }

    static void OnRow(object sender, DataReceivedEventArgs evt)
    {
        string line=evt.Data;
        if (String.IsNullOrEmpty(line)) return;
        var cols=line.Split(',');
        if (Array.IndexOf(cols,"ProcessID")>=0) {
            pidIndex=Array.IndexOf(cols,"ProcessID");
            chainIndex=Array.IndexOf(cols,"SwapChainAddress");
            timeIndex=Array.IndexOf(cols,"TimeInSeconds");
            modeIndex=Array.IndexOf(cols,"PresentMode");
            return;
        }
        if (pidIndex<0 || timeIndex<0 || chainIndex<0 || cols.Length<=Math.Max(pidIndex,Math.Max(timeIndex,chainIndex))) return;
        int pid;
        if (!Int32.TryParse(cols[pidIndex],out pid)) return;
        lock(sync) {
            if (pid!=tracked) return;
            double stamp;
            if (!Double.TryParse(cols[timeIndex],NumberStyles.Float,CultureInfo.InvariantCulture,out stamp)) return;
            Chain c;
            if (!chains.TryGetValue(cols[chainIndex],out c)) chains[cols[chainIndex]]=c=new Chain();
            if (stamp<c.latest) c.timestamps.Clear();
            c.latest=stamp;
            c.direct=modeIndex>=0 && modeIndex<cols.Length &&
                (cols[modeIndex].StartsWith("Hardware:",StringComparison.Ordinal) ||
                 cols[modeIndex].StartsWith("Hardware Composed:",StringComparison.Ordinal));
            c.lastTick=Stopwatch.GetTimestamp();
            c.timestamps.Enqueue(stamp);
            while (c.timestamps.Count>1 && stamp-c.timestamps.Peek()>1.1) c.timestamps.Dequeue();
        }
    }

    static string CurrentFps(out bool direct)
    {
        direct=false;
        lock(sync) {
            var now=Stopwatch.GetTimestamp();
            Chain best=null;
            foreach (var c in chains.Values) {
                if (now-c.lastTick>Stopwatch.Frequency*2 || c.timestamps.Count<2) continue;
                if (best==null || c.timestamps.Count>best.timestamps.Count) best=c;
            }
            if (best==null) return "";
            var seconds=best.latest-best.timestamps.Peek();
            if (seconds<0.25) return "";
            direct=best.direct && seconds>=0.75 && best.timestamps.Count>=8;
            return Math.Min(9999,Math.Max(1,Math.Round((best.timestamps.Count-1)/seconds))).ToString(CultureInfo.InvariantCulture);
        }
    }

    static void WriteState(string name,string value)
    {
        var target=Path.Combine(folder,name);
        var tmp=target+".tmp";
        File.WriteAllText(tmp,value,Encoding.ASCII);
        if (File.Exists(target)) File.Replace(tmp,target,null);
        else File.Move(tmp,target);
    }

    static void Publish(string value,string signal)
    {
        string candidate="";
        if (!storeMode && !ordinary && targetStart>0 && (signal.Length!=0 || value.Length!=0))
            candidate=tracked.ToString(CultureInfo.InvariantCulture)+" "+targetStart.ToString(CultureInfo.InvariantCulture)+" "+(signal.Length==0 ? "frames" : "game");
        if (lastValue==value && lastSignal==signal && lastCandidate==candidate && DateTime.UtcNow-lastReport<TimeSpan.FromSeconds(1)) return;
        try {
            WriteState("fps.txt",value);
            WriteState("game-target.txt",signal);
            if (!storeMode) {
                long updated=DateTime.UtcNow.ToFileTimeUtc()/10000000L-11644473600L;
                WriteState("capture-candidate.txt",candidate.Length==0 ? "" : candidate+" "+updated.ToString(CultureInfo.InvariantCulture));
            }
            if (storeMode) WriteState("reader-live.txt","1");
            lastSignal=signal;
            lastCandidate=candidate;
            lastValue=value;
            lastReport=DateTime.UtcNow;
        } catch (IOException) {}
    }

    static ProcessStartInfo Command(string args)
    {
        return new ProcessStartInfo(binary,args) { UseShellExecute=false,CreateNoWindow=true };
    }

    static Process StartMonitor()
    {
        var info=Command("--output_stdout --no_console_stats --v1_metrics --no_track_input --no_track_gpu --session_name "+session);
        info.RedirectStandardOutput=true;
        info.RedirectStandardError=true;
        var monitor=new Process { StartInfo=info };
        monitor.OutputDataReceived+=OnRow;
        monitor.ErrorDataReceived+=delegate(object sender,DataReceivedEventArgs e) {
            if(e.Data!=null && e.Data.IndexOf("error",StringComparison.OrdinalIgnoreCase)>=0)
                File.WriteAllText(Path.Combine(folder,"fps-error.txt"),e.Data);
        };
        monitor.Start();
        monitor.BeginOutputReadLine();
        monitor.BeginErrorReadLine();
        return monitor;
    }

    static void StopMonitor(Process monitor)
    {
        using (monitor) {
            if (!monitor.HasExited) {
                using (var stop=Process.Start(Command("--terminate_existing_session --session_name "+session))) stop.WaitForExit(2500);
                if (!monitor.WaitForExit(2500)) monitor.Kill();
            }
        }
        lock(sync) { chains.Clear(); }
    }

    static void Run(Process parent)
    {
        Process monitor=null;
        var started=DateTime.UtcNow;
        var lastNeeded=started;
        var pulse=Path.Combine(folder,"widget-live.txt");
        try {
            while (parent==null || !parent.HasExited) {
                var now=DateTime.UtcNow;
                if ((now-started).TotalSeconds>7 && (now-File.GetLastWriteTimeUtc(Path.Combine(folder,"obs.txt"))).TotalSeconds>7) break;
                if (storeMode && (now-File.GetLastWriteTimeUtc(pulse)).TotalSeconds>8) break;
                UpdateTarget();
                bool needsFrames=!storeMode || targetSignal.Length!=0 || fullscreen;
                if (!needsFrames) {
                    try { needsFrames=File.ReadAllText(pulse)=="g"; } catch (IOException) {}
                }
                if (needsFrames) {
                    lastNeeded=now;
                    if (monitor==null) monitor=StartMonitor();
                } else if (monitor!=null && (now-lastNeeded).TotalSeconds>5) {
                    StopMonitor(monitor);
                    monitor=null;
                }
                if (monitor!=null && monitor.HasExited) break;
                bool direct;
                string fps=CurrentFps(out direct);
                string signal=targetSignal.Length==0 && fullscreen && direct ? "fullscreen" : targetSignal;
                Publish(fps,signal);
                Thread.Sleep(220);
            }
        } finally {
            if (monitor!=null) StopMonitor(monitor);
            Publish("","");
        }
    }

    static bool storeMode;

    static int Main(string[] args)
    {
        if (args.Length!=2) return 2;
        storeMode=args[0]=="--store";
        string identifier;
        if (storeMode) {
            uint length=0;
            if (GetCurrentPackageFamilyName(ref length,null)!=122) return 2;
            var family=new StringBuilder((int)length);
            if (GetCurrentPackageFamilyName(ref length,family)!=0) return 2;
            identifier=family.ToString();
            folder=Path.GetFullPath(args[1]);
            var directory=new DirectoryInfo(folder);
            if (!directory.Exists || directory.Parent==null || !directory.Name.Equals("LocalState",StringComparison.OrdinalIgnoreCase)
                || !directory.Parent.Name.Equals(identifier,StringComparison.OrdinalIgnoreCase)) return 2;
        } else {
            identifier=args[0];
            folder=args[1];
        }
        binary=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"PresentMon.exe");
        session="OojjrsObsFps-"+identifier+"-"+Process.GetCurrentProcess().SessionId;
        bool first;
        using (var gate=new Mutex(true,"Local\\OojjrsFpsReader-"+identifier,out first)) {
            if (!first) return 0;
            try {
                using (var parent=storeMode ? null : Process.GetProcessById(Int32.Parse(identifier))) Run(parent);
                return 0;
            } catch(Exception e) {
                File.WriteAllText(Path.Combine(folder,"fps-error.txt"),e.Message);
                return 1;
            }
        }
    }
}
