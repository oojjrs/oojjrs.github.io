local obs = obslua
local ffi = require("ffi")
ffi.cdef[[
void * __stdcall GetForegroundWindow(void);
unsigned long __stdcall GetWindowThreadProcessId(void *, unsigned long *);
void * __stdcall OpenProcess(unsigned long, int, unsigned long);
int __stdcall QueryFullProcessImageNameW(void *, unsigned long, wchar_t *, unsigned long *);
int __stdcall WideCharToMultiByte(unsigned int, unsigned long, const wchar_t *, int, char *, int, const char *, int *);
unsigned long long __stdcall GetTickCount64(void);
void *obs_get_source_by_name(const char *);
void obs_source_release(void *);
void obs_enum_hotkeys(bool (*)(void *,size_t,void *),void *);
const char *obs_hotkey_get_name(const void *);
int obs_hotkey_get_registerer_type(const void *);
void *obs_hotkey_get_registerer(const void *);
bool obs_weak_source_references_source(void *,void *);
void obs_hotkey_trigger_routed_callback(size_t,bool);
]]
local windows = ffi.load("user32")
local core = ffi.load("obs")
local sourceName = "게임 화면과 소리"
local candidateFile, optionFile, session, warming
local enabled, nextOption, nextIdle = false, 0, 0
local launchers = {["steam.exe"]=true,["steamwebhelper.exe"]=true,["epicgameslauncher.exe"]=true,
    ["eadesktop.exe"]=true,["galaxyclient.exe"]=true,["battle.net.exe"]=true,
    ["ubisoftconnect.exe"]=true,["upc.exe"]=true,["xboxpcapp.exe"]=true}

local function now()
    return tonumber(ffi.C.GetTickCount64())
end

local function foreground()
    local pid = ffi.new("unsigned long[1]")
    local window = windows.GetForegroundWindow()
    windows.GetWindowThreadProcessId(window, pid)
    return tonumber(pid[0]), window
end

local function processPath(pid)
    local handle = ffi.C.OpenProcess(0x1000, 0, pid)
    if handle == nil then return "" end
    local path = ffi.new("wchar_t[32768]")
    local count = ffi.new("unsigned long[1]", 32768)
    local ok = ffi.C.QueryFullProcessImageNameW(handle, 0, path, count)
    ffi.C.CloseHandle(handle)
    if ok == 0 then return "" end
    local bytes = ffi.C.WideCharToMultiByte(65001, 0, path, count[0], nil, 0, nil, nil)
    if bytes == 0 then return "" end
    local out = ffi.new("char[?]", bytes)
    ffi.C.WideCharToMultiByte(65001, 0, path, count[0], out, bytes, nil, nil)
    return ffi.string(out, bytes):lower()
end

local function fileName(path)
    return path:match("[^/\\]+$") or ""
end

local function sameGame(path, seed)
    if path == "" or seed == "" then return false end
    if path == seed then return true end
    local game = seed:match("^(.-\\steamapps\\common\\[^\\]+\\)")
    if game then return path:sub(1,#game) == game end
    local dir = seed:match("^(.*\\)")
    return dir ~= nil and path:sub(1,#dir) == dir and path:match("\\binaries\\win%d+\\") ~= nil
end

local function candidate()
    local f = io.open(candidateFile,"rb")
    if not f then return end
    local line = f:read(96) or ""
    f:close()
    local pid, born, kind, updated = line:match("^(%d+) (%d+) (%a+) (%d+)$")
    if not updated or math.abs(os.time()-tonumber(updated)) > 3 then return end
    return tonumber(pid), tonumber(born), kind
end

local function hooked(source)
    local data = obs.calldata_create()
    local ok = obs.proc_handler_call(obs.obs_source_get_proc_handler(source),"get_hooked",data)
    local ready = ok and obs.calldata_bool(data,"hooked")
    local exe = ready and obs.calldata_string(data,"executable") or ""
    obs.calldata_destroy(data)
    return ready, exe:lower()
end

local function sourceHotkey(name)
    local source = core.obs_get_source_by_name(sourceName)
    if source == nil then return end
    local selected
    local find = ffi.cast("bool (*)(void *,size_t,void *)",function(_,id,key)
        if core.obs_hotkey_get_registerer_type(key) == 1
            and ffi.string(core.obs_hotkey_get_name(key)) == name
            and core.obs_weak_source_references_source(core.obs_hotkey_get_registerer(key),source) then
            selected = tonumber(id)
            return false
        end
        return true
    end)
    core.obs_enum_hotkeys(find,nil)
    find:free()
    core.obs_source_release(source)
    return selected
end

local function selectWindow(pid, window)
    local key = sourceHotkey("hotkey_start")
    local currentPid, currentWindow = foreground()
    if not key or currentPid ~= pid or currentWindow ~= window then return false end
    core.obs_hotkey_trigger_routed_callback(key,true)
    core.obs_hotkey_trigger_routed_callback(key,false)
    return true
end

local function changeBinding(claim)
    local key = sourceHotkey("hotkey_start")
    if not key then return false end
    local keys = obs.obs_hotkey_save(key)
    if not keys then return false end
    local index
    for i=0,obs.obs_data_array_count(keys)-1 do
        local item = obs.obs_data_array_item(keys,i)
        local matches = obs.obs_data_get_string(item,"key")=="OBS_KEY_R"
            and obs.obs_data_get_bool(item,"control") and obs.obs_data_get_bool(item,"alt")
            and not obs.obs_data_get_bool(item,"shift") and not obs.obs_data_get_bool(item,"command")
        obs.obs_data_release(item)
        if matches then index=i; break end
    end
    if claim and index ~= nil then
        obs.obs_data_array_erase(keys,index)
        obs.obs_hotkey_load(key,keys)
    elseif not claim and index == nil then
        local item=obs.obs_data_create()
        obs.obs_data_set_string(item,"key","OBS_KEY_R")
        obs.obs_data_set_bool(item,"control",true)
        obs.obs_data_set_bool(item,"alt",true)
        obs.obs_data_array_push_back(keys,item)
        obs.obs_data_release(item)
        obs.obs_hotkey_load(key,keys)
    end
    obs.obs_data_array_release(keys)
    return true
end

local function releaseWindow()
    if warming then
        local key=sourceHotkey("hotkey_stop")
        if key then
            core.obs_hotkey_trigger_routed_callback(key,true)
            core.obs_hotkey_trigger_routed_callback(key,false)
        end
        warming=nil
    end
end

local function otherOutputActive()
    return obs.obs_frontend_streaming_active() or obs.obs_frontend_replay_buffer_active()
        or obs.obs_frontend_virtualcam_active()
end

local function idle(time)
    if time < nextIdle then return end
    nextIdle=time+500
    if otherOutputActive() then return end
    if time >= nextOption then
        nextOption=time+1500
        local f=io.open(optionFile,"rb")
        local requested=f~=nil
        if f then f:close() end
        if requested~=enabled and changeBinding(requested) then
            enabled=requested
            if not enabled then releaseWindow() end
        end
    end
    if not enabled then return end
    local pid,window=foreground()
    local seen,born,kind=candidate()
    if pid~=seen or kind~="game" then
        if warming and time-warming.lastSeen>=2500 then releaseWindow() end
        return
    end
    if warming and warming.pid==pid and warming.born==born and warming.window==window then
        warming.lastSeen=time
        if time < warming.nextTry then return end
    end
    local source=obs.obs_get_source_by_name(sourceName)
    if not source then return end
    local settings=obs.obs_source_get_settings(source)
    local valid=obs.obs_source_showing(source) and obs.obs_data_get_string(settings,"capture_mode")=="hotkey"
    obs.obs_data_release(settings)
    local ready,exe
    if valid then ready,exe=hooked(source) end
    obs.obs_source_release(source)
    if not valid then warming=nil; return end
    local path=processPath(pid)
    if path=="" then return end
    local same=warming and warming.pid==pid and warming.born==born and warming.window==window
    if not same then
        warming={pid=pid,born=born,window=window,lastSeen=time,nextTry=0,interval=4000}
    end
    if same and ready and exe==fileName(path) then
        warming.nextTry=time+1500
        warming.interval=4000
    elseif selectWindow(pid,window) then
        warming.nextTry=time+warming.interval
        warming.interval=math.min(32000,warming.interval*2)
    end
end

local function recordingEvent(event)
    if event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPING or event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        session = nil
    elseif (event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTING or event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED) and not session then
        local source = obs.obs_get_source_by_name(sourceName)
        if not source then return end
        local settings = obs.obs_source_get_settings(source)
        local applicable = obs.obs_source_showing(source) and obs.obs_data_get_string(settings,"capture_mode") == "hotkey"
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
        if not applicable then return end
        local pid,window = foreground()
        local path = processPath(pid)
        session = {pid=pid, path=path, launcher=launchers[fileName(path)] or pid==0,
            started=os.time(), nextCheck=now()+1800, nextRetry=now()+4000, interval=8000}
        if enabled and not (warming and warming.pid==pid and warming.window==window) then
            selectWindow(pid,window)
        end
    end
end

local function tick()
    local time = now()
    if not session then
        if not obs.obs_frontend_recording_active() then idle(time) end
        return
    end
    if not obs.obs_frontend_recording_active() then return end
    if time < session.nextCheck or obs.obs_frontend_recording_paused() then return end
    session.nextCheck = time+650
    local pid, window = foreground()
    local seen, born, kind = candidate()
    if pid == 0 or seen ~= pid then return end
    local path = pid == session.pid and born == session.born and session.path or processPath(pid)
    local same = pid == session.pid and path == session.path
    if not same then
        local startupGame = not session.locked and session.launcher and os.time()-session.started <= 30
            and born >= session.started-45 and born <= session.started+10
        if kind ~= "game" or not (sameGame(path,session.path) or startupGame) then return end
        session.pid,session.path,session.launcher = pid,path,false
    end
    session.born=born
    local source = obs.obs_get_source_by_name(sourceName)
    if not source then return end
    if not obs.obs_source_showing(source) then obs.obs_source_release(source); return end
    local ready, exe = hooked(source)
    obs.obs_source_release(source)
    if ready and (path == "" or exe == fileName(path)) then
        session.locked = true
        session.interval = 8000
        if session.retried then obs.script_log(obs.LOG_INFO,"GAME CAPTURE RECONNECTED"); session.retried=false end
        return
    end
    if time < session.nextRetry then return end
    if not selectWindow(pid,window) then return end
    session.nextRetry = time+session.interval
    session.interval = math.min(session.interval*2,32000)
    if not session.retried then obs.script_log(obs.LOG_INFO,"RETRYING GAME CAPTURE"); session.retried=true end
end

return {
    start=function(folder, base)
        candidateFile = folder.."/capture-candidate.txt"
        optionFile = base.."preconnect.enabled"
        obs.obs_frontend_add_event_callback(recordingEvent)
    end,
    tick=tick,
    stop=function()
        obs.obs_frontend_remove_event_callback(recordingEvent)
        if enabled then changeBinding(false) end
        warming=nil
        session=nil
    end
}
