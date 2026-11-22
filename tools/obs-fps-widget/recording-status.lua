local obs = obslua
local ffi = require("ffi")
ffi.cdef[[
int __stdcall MultiByteToWideChar(unsigned int,unsigned long,const char*,int,wchar_t*,int);
void * __stdcall CreateFileW(const wchar_t*,unsigned long,unsigned long,void*,unsigned long,unsigned long,void*);
int __stdcall WriteFile(void*,const void*,unsigned long,unsigned long*,void*);
int __stdcall CloseHandle(void*);
int __stdcall MoveFileExW(const wchar_t*,const wchar_t*,unsigned long);
int __stdcall DeleteFileW(const wchar_t*);
]]
local function wide(path)
    local size = ffi.C.MultiByteToWideChar(65001,0,path,#path,nil,0)
    local chars = ffi.new("wchar_t[?]",size+1)
    ffi.C.MultiByteToWideChar(65001,0,path,#path,chars,size)
    return chars
end
local path = wide(script_path().."obs.txt")
local temporary = wide(script_path().."obs-status.tmp")
local lastState, ticks = nil, 0
local function publish()
    local state = "idle"
    if obs.obs_frontend_recording_active() then
        state = obs.obs_frontend_recording_paused() and "paused" or "recording"
    end
    ticks = ticks+1
    if state==lastState and ticks%5~=0 then return end
    local file = ffi.C.CreateFileW(temporary,0x40000000,0,nil,2,0x80,nil)
    if file==ffi.cast("void*",-1) then return end
    local written = ffi.new("unsigned long[1]")
    local ok = ffi.C.WriteFile(file,state,#state,written,nil)
    ffi.C.CloseHandle(file)
    if ok~=0 and written[0]==#state and ffi.C.MoveFileExW(temporary,path,1)~=0 then lastState=state end
end
function script_description()
    return "게임 바 위젯에 OBS의 녹화 및 일시정지 상태를 전달합니다."
end
function script_load(settings)
    publish()
    obs.timer_add(publish,250)
end
function script_unload()
    obs.timer_remove(publish)
    ffi.C.DeleteFileW(path)
end
