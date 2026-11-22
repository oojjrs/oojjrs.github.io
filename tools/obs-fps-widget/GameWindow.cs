using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Security;
using Microsoft.Win32;

internal static class GameWindow
{
    static readonly HashSet<string> ordinaryApps = new HashSet<string>(StringComparer.OrdinalIgnoreCase) {
        "steam", "steamwebhelper", "EpicGamesLauncher", "EpicWebHelper", "EADesktop", "EALauncher",
        "GalaxyClient", "UbisoftConnect", "upc", "Battle.net", "XboxPcApp", "Playnite.DesktopApp",
        "Playnite.FullscreenApp", "Unity Hub", "Unity", "UnrealEditor", "UE4Editor",
        "UnityCrashHandler32", "UnityCrashHandler64", "CrashReportClient", "explorer", "dwm", "ApplicationFrameHost",
        "StartMenuExperienceHost", "SearchHost", "ShellExperienceHost", "LockApp", "TextInputHost",
        "chrome", "msedge", "msedgewebview2", "firefox", "brave", "opera", "vivaldi",
        "Discord", "DiscordCanary", "DiscordPTB", "Codex", "slack", "ms-teams", "obs64",
        "vlc", "mpv", "Video.UI", "Microsoft.Media.Player"
    };

    [StructLayout(LayoutKind.Sequential)]
    struct Rect { public int left, top, right, bottom; }
    [StructLayout(LayoutKind.Sequential)]
    struct Point { public int x, y; }
    [StructLayout(LayoutKind.Sequential)]
    struct MonitorInfo { public int size; public Rect monitor, work; public uint flags; }
    [DllImport("user32.dll")] static extern bool GetClientRect(IntPtr hwnd, out Rect rect);
    [DllImport("user32.dll")] static extern bool ClientToScreen(IntPtr hwnd, ref Point point);
    [DllImport("user32.dll")] static extern IntPtr MonitorFromWindow(IntPtr hwnd, uint flags);
    [DllImport("user32.dll")] static extern bool GetMonitorInfoW(IntPtr monitor, ref MonitorInfo info);

    internal static bool IsOrdinaryApp(string name) { return ordinaryApps.Contains(name); }

    internal static bool CoversMonitor(IntPtr hwnd)
    {
        Rect rect;
        var origin = new Point();
        var info = new MonitorInfo { size = Marshal.SizeOf(typeof(MonitorInfo)) };
        if (hwnd == IntPtr.Zero || !GetClientRect(hwnd, out rect) || !ClientToScreen(hwnd, ref origin) ||
            !GetMonitorInfoW(MonitorFromWindow(hwnd, 2), ref info)) return false;
        return Math.Abs(origin.x - info.monitor.left) <= 2 && Math.Abs(origin.y - info.monitor.top) <= 2 &&
               Math.Abs(origin.x + rect.right - info.monitor.right) <= 2 &&
               Math.Abs(origin.y + rect.bottom - info.monitor.bottom) <= 2;
    }

    internal static string Installation(string exe)
    {
        if (String.IsNullOrEmpty(exe)) return "";
        var folder = new DirectoryInfo(Path.GetDirectoryName(exe));
        string player = Path.GetFileNameWithoutExtension(exe);
        if (File.Exists(Path.Combine(folder.FullName, "UnityPlayer.dll")) &&
            Directory.Exists(Path.Combine(folder.FullName, player + "_Data"))) return "engine";
        if (File.Exists(Path.ChangeExtension(exe, ".pck"))) return "engine";
        for (var dir = folder; dir != null && dir.Parent != null; dir = dir.Parent) {
            if (dir.Name.Equals("common", StringComparison.OrdinalIgnoreCase) &&
                dir.Parent.Name.Equals("steamapps", StringComparison.OrdinalIgnoreCase)) return "steam";
            if (Directory.Exists(Path.Combine(dir.FullName, "Binaries")) &&
                Directory.Exists(Path.Combine(dir.FullName, "Content", "Paks"))) return "engine";
            if (Directory.Exists(Path.Combine(dir.FullName, ".egstore")) ||
                File.Exists(Path.Combine(dir.FullName, "__Installer", "installerdata.xml")) ||
                File.Exists(Path.Combine(dir.FullName, "MicrosoftGame.config"))) return "installation";
        }
        return "";
    }

    static string ModuleSignal(string file)
    {
        string name = file.ToLowerInvariant();
        if (name == "unityplayer.dll" || name == "unityplayer_s.dll" || name == "unrealeditor-engine.dll" ||
            name == "ue4editor-engine.dll" || name == "fna3d.dll" || name == "cryaction.dll") return "engine";
        if (name == "steam_api.dll" || name == "steam_api64.dll" ||
            name == "gameoverlayrenderer.dll" || name == "gameoverlayrenderer64.dll") return "steam";
        return "";
    }

    static bool SteamTracks(int pid, DateTime start)
    {
        var root = Registry.GetValue(@"HKEY_CURRENT_USER\Software\Valve\Steam", "SteamPath", null) as string;
        if (String.IsNullOrEmpty(root)) return false;
        var path = Path.Combine(root, "logs", "gameprocess_log.txt");
        if (!File.Exists(path)) return false;
        string id = pid.ToString(CultureInfo.InvariantCulture);
        string added = " adding PID " + id + " as a tracked process";
        string removed = " no longer tracking PID " + id + ",";
        bool tracked = false;
        using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete)) {
            stream.Seek(Math.Max(0L, stream.Length - 262144L), SeekOrigin.Begin);
            using (var reader = new StreamReader(stream)) {
                if (stream.Position != 0) reader.ReadLine();
                string line;
                while ((line = reader.ReadLine()) != null) {
                    if (line.IndexOf(removed, StringComparison.Ordinal) >= 0) { tracked = false; continue; }
                    if (line.Length < 22 || line[0] != '[' || line.IndexOf(added, StringComparison.Ordinal) < 0) continue;
                    DateTime stamp;
                    if (DateTime.TryParseExact(line.Substring(1,19), "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture,
                            DateTimeStyles.None, out stamp) && stamp >= start.AddSeconds(-2)) tracked = true;
                }
            }
        }
        return tracked;
    }

    internal static string Classify(Process process)
    {
        try {
            string pathSignal = Installation(process.MainModule.FileName);
            if (pathSignal.Length != 0) return pathSignal;
            foreach (ProcessModule module in process.Modules) {
                string signal = ModuleSignal(module.ModuleName);
                if (signal.Length != 0) return signal;
            }
        } catch (Win32Exception) {
        } catch (InvalidOperationException) {
        } catch (UnauthorizedAccessException) {
        } catch (SecurityException) {
        } catch (IOException) {}
        try {
            if (SteamTracks(process.Id, process.StartTime)) return "steam";
        } catch (Win32Exception) {
        } catch (InvalidOperationException) {
        } catch (UnauthorizedAccessException) {
        } catch (SecurityException) {
        } catch (IOException) {}
        return "";
    }
}
