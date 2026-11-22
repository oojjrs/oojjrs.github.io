local obs = obslua
local ffi = require("ffi")
local base = script_path()
local folder, worker, lastState, captureRetry
local ticks, nextStart = 0, 0
ffi.cdef[[
typedef struct { unsigned long cb; void *reserved,*desktop,*title; unsigned long x,y,xsize,ysize,xc,yc,fill,flags; unsigned short show,reservedSize; void *reserved2,*inHandle,*outHandle,*errHandle; } FpsStartupInfo;
typedef struct { void *process,*thread; unsigned long pid,tid; } FpsProcessInfo;
unsigned long __stdcall GetCurrentProcessId(void);
int __stdcall MultiByteToWideChar(unsigned int,unsigned long,const char*,int,wchar_t*,int);
int __stdcall CreateProcessW(const wchar_t*,wchar_t*,void*,void*,int,unsigned long,void*,const wchar_t*,FpsStartupInfo*,FpsProcessInfo*);
int __stdcall CloseHandle(void*);
unsigned long __stdcall WaitForSingleObject(void*,unsigned long);
int __stdcall MoveFileExW(const wchar_t*,const wchar_t*,unsigned long);
]]
local function wide(s)
    local size = ffi.C.MultiByteToWideChar(65001,0,s,#s,nil,0)
    local buf = ffi.new("wchar_t[?]",size+1)
    ffi.C.MultiByteToWideChar(65001,0,s,#s,buf,size)
    return buf
end
local function update()
    ticks = ticks+1
    local state = "idle"
    if obs.obs_frontend_recording_active() then
        state = obs.obs_frontend_recording_paused() and "paused" or "recording"
    end
    if state ~= lastState or ticks % 5 == 0 then
        local path = folder.."/obs.txt"
        local file = io.open(path..".tmp","wb")
        if file then
            file:write(state)
            file:close()
            if ffi.C.MoveFileExW(wide(path..".tmp"),wide(path),1) ~= 0 then lastState = state end
        end
    end
    if worker ~= nil and ffi.C.WaitForSingleObject(worker,0) ~= 258 then
        ffi.C.CloseHandle(worker)
        worker = nil
    end
    if worker == nil and ticks >= nextStart then
        nextStart = ticks+25
        local exe = base.."FrameReader.exe"
        local command = '"'..exe..'" '..tonumber(ffi.C.GetCurrentProcessId())..' "'..folder..'"'
        local startup, process = ffi.new("FpsStartupInfo[1]"),ffi.new("FpsProcessInfo[1]")
        startup[0].cb = ffi.sizeof("FpsStartupInfo")
        if ffi.C.CreateProcessW(wide(exe),wide(command),nil,nil,0,0x08000000,nil,nil,startup,process) ~= 0 then
            ffi.C.CloseHandle(process[0].thread)
            worker = process[0].process
        else
            obs.script_log(obs.LOG_WARNING,"Could not start the FPS reader")
        end
    end
    if captureRetry then captureRetry.tick() end
end
function script_load(settings)
    local f = assert(io.open(base.."state-folder.txt","rb"))
    folder = f:read("*l")
    f:close()
    captureRetry = dofile(base.."capture-retry.lua")
    captureRetry.start(folder,base)
    update()
    obs.timer_add(update,250)
end
function script_unload()
    obs.timer_remove(update)
    if captureRetry then captureRetry.stop(); captureRetry=nil end
    if folder then os.remove(folder.."/obs.txt") end
    if worker ~= nil then ffi.C.CloseHandle(worker); worker=nil end
end
