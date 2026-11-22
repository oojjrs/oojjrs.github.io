#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#undef GetCurrentTime
#include <winrt/Windows.ApplicationModel.Activation.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.Storage.h>
#include <winrt/Windows.UI.Core.h>
#include <winrt/Windows.Graphics.Display.h>
#include <winrt/Windows.UI.Text.h>
#include <winrt/Windows.UI.Xaml.h>
#include <winrt/Windows.UI.Xaml.Controls.h>
#include <winrt/Windows.UI.Xaml.Documents.h>
#include <winrt/Windows.UI.Xaml.Media.h>
#include <winrt/Microsoft.Gaming.XboxGameBar.h>
#ifdef STORE_PACKAGE
#include <winrt/Windows.ApplicationModel.h>
#include <winrt/Windows.ApplicationModel.DataTransfer.h>
#include <winrt/Windows.Storage.Streams.h>
#include <winrt/Windows.UI.Xaml.Controls.Primitives.h>
#endif
#include <chrono>
#include <cstdlib>
#include <string>
#include <array>
#include <cstdio>

using namespace winrt;
using namespace Windows::ApplicationModel::Activation;
using namespace Windows::UI::Xaml;
using namespace Windows::UI::Xaml::Controls;
using namespace Windows::UI::Xaml::Media;
using namespace Microsoft::Gaming::XboxGameBar;

std::wstring dataFolder()
{
    return std::wstring(Windows::Storage::ApplicationData::Current().LocalFolder().Path()) + L"\\";
}

void diagnostic(const std::string& message) noexcept
{
    try {
        const auto base = dataFolder();
        WIN32_FILE_ATTRIBUTE_DATA a{};
        if (!GetFileAttributesExW((base+L"verify.flag").c_str(),GetFileExInfoStandard,&a)) return;
        CREATEFILE2_EXTENDED_PARAMETERS p{sizeof(p)};
        auto raw = CreateFile2((base+L"activation.txt").c_str(),FILE_APPEND_DATA,
            FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE,OPEN_ALWAYS,&p);
        if (raw==INVALID_HANDLE_VALUE) return;
        winrt::handle file{raw};
        DWORD written{};
        const auto line=message+"\r\n";
        WriteFile(file.get(),line.data(),static_cast<DWORD>(line.size()),&written,nullptr);
    } catch (...) {}
}

std::string readFresh(const std::wstring& filename, unsigned long long maxAge)
{
    CREATEFILE2_EXTENDED_PARAMETERS parameters{sizeof(parameters)};
    auto handle = CreateFile2(filename.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
                              OPEN_EXISTING, &parameters);
    if (handle == INVALID_HANDLE_VALUE) return {};
    winrt::handle file{handle};
    FILE_BASIC_INFO info{};
    FILETIME now{};
    GetSystemTimeAsFileTime(&now);
    ULARGE_INTEGER stamp{};
    stamp.LowPart = now.dwLowDateTime;
    stamp.HighPart = now.dwHighDateTime;
    if (!GetFileInformationByHandleEx(file.get(), FileBasicInfo, &info, sizeof(info)) ||
        stamp.QuadPart - info.LastWriteTime.QuadPart > maxAge * 10000) return {};
    char buffer[48]{};
    DWORD count = 0;
    if (!ReadFile(file.get(), buffer, sizeof(buffer)-1, &count, nullptr)) return {};
    return std::string(buffer,count);
}

struct App : ApplicationT<App>
{
#ifdef STORE_PACKAGE
    TextBlock setupHint{nullptr};
    std::chrono::steady_clock::time_point nextPulse{}, nextReader{};

    static winrt::fire_and_forget launchReader(hstring statePath)
    {
        try {
            co_await Windows::ApplicationModel::FullTrustProcessLauncher::LaunchFullTrustProcessForCurrentAppWithArgumentsAsync(
                L"--store \""+statePath+L"\"");
        } catch (const hresult_error& e) {
            diagnostic("Frame reader launch error "+std::to_string(e.code().value));
        }
    }

    void keepReaderActive(bool knownGame)
    {
        const auto now=std::chrono::steady_clock::now();
        if (now < nextPulse) return;
        nextPulse=now+std::chrono::seconds(2);
        CREATEFILE2_EXTENDED_PARAMETERS options{sizeof(options)};
        auto file=CreateFile2((folder+L"widget-live.txt").c_str(),GENERIC_WRITE,
            FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE,CREATE_ALWAYS,&options);
        if (file==INVALID_HANDLE_VALUE) return;
        winrt::handle pulse{file};
        DWORD bytes{};
        WriteFile(file,knownGame?"g":"0",1,&bytes,nullptr);
        if (now>=nextReader && readFresh(folder+L"reader-live.txt",5000).empty()) {
            nextReader=now+std::chrono::seconds(20);
            launchReader(Windows::Storage::ApplicationData::Current().LocalFolder().Path());
        }
    }

    static winrt::fire_and_forget openSetup(Window window)
    {
        using namespace Windows::Storage;
        using namespace Windows::ApplicationModel;
        using namespace Windows::ApplicationModel::DataTransfer;
        StackPanel panel;
        panel.Margin({32,32,32,32});
        panel.MaxWidth(680);
        panel.Spacing(14);
        panel.HorizontalAlignment(HorizontalAlignment::Left);
        auto line=[&panel](hstring value,double size) {
            TextBlock text;
            text.Text(value);
            text.FontSize(size);
            text.TextWrapping(TextWrapping::Wrap);
            text.IsTextSelectionEnabled(true);
            panel.Children().Append(text);
            return text;
        };
        line(L"Recording FPS Widget",30);
        line(L"OBS 연결",22);
        line(L"아래 버튼으로 스크립트 경로를 복사하세요. OBS Studio의 도구 → 스크립트에서 +를 누르고, 파일 이름 칸에 경로를 붙여넣어 여세요.",16);
        Button copy;
        copy.Content(box_value(L"OBS 스크립트 경로 복사"));
        copy.IsEnabled(false);
        panel.Children().Append(copy);
        auto status=line(L"연결 파일을 준비하고 있어요.",15);
        line(L"게임을 열고 Win+G → 위젯 메뉴에서 Recording FPS Widget을 고정하세요. 숫자는 대기 중 녹색, 녹화 중 빨간색, 일시정지 중 회색으로 보입니다.",16);
        line(L"FPS를 읽으려면 Windows 계정에 성능 로그 사용자 권한이 필요합니다. 연결을 해제하려면 OBS의 스크립트 목록에서 recording-status.lua를 제거하세요.",14);
        ScrollViewer scroll;
        scroll.Content(panel);
        window.Content(scroll);
        window.Activate();
        try {
            auto source=co_await Package::Current().InstalledLocation().GetFileAsync(L"recording-status.lua");
            auto storage=ApplicationData::Current().LocalFolder();
            auto script=co_await source.CopyAsync(storage,L"recording-status.lua",NameCollisionOption::ReplaceExisting);
            const auto path=script.Path();
            status.Text(readFresh(dataFolder()+L"obs.txt",5000).empty()?L"OBS에서 스크립트를 추가해 주세요.":L"OBS가 연결되어 있어요.");
            copy.Click([path,status](auto const&,auto const&) {
                try {
                    DataPackage data;
                    data.SetText(path);
                    Clipboard::SetContent(data);
                    Clipboard::Flush();
                    status.Text(L"경로를 복사했어요. OBS의 스크립트 파일 선택 창에 붙여넣으세요.");
                } catch (const hresult_error&) {status.Text(path);}
            });
            copy.IsEnabled(true);
        } catch (const hresult_error& e) {status.Text(e.message());}
    }
#endif
    Grid digits{nullptr};
    TextBlock number{nullptr};
    SolidColorBrush ink{nullptr};
    std::array<TextBlock,8> outline{nullptr,nullptr,nullptr,nullptr,nullptr,nullptr,nullptr,nullptr};
    DispatcherTimer timer{nullptr};
    XboxGameBarWidget widget{nullptr};
    XboxGameBarAppTargetTracker targets{nullptr};
    std::wstring folder;
    std::string lastState, lastValue;
    unsigned int refreshes = 0;

    void reportView()
    {
        if (!widget) return;
        WIN32_FILE_ATTRIBUTE_DATA attributes{};
        if (!GetFileAttributesExW((folder+L"verify.flag").c_str(),GetFileExInfoStandard,&attributes)) return;
        auto bounds = widget.WindowBounds();
        auto scale = Windows::Graphics::Display::DisplayInformation::GetForCurrentView().RawPixelsPerViewPixel();
        auto position = number.TransformToVisual(Window::Current().Content()).TransformPoint({0,0});
        char text[192]{};
        auto count = std::snprintf(text,sizeof(text),"%d %d %.1f %.1f %.1f %.1f %.3f %s %s drawn=%d size=%.0f pixelOrigin=%.1f,%.1f",
            widget.Pinned(), widget.Visible(), bounds.X,bounds.Y,bounds.Width,bounds.Height,scale,
            lastState.c_str(),lastValue.c_str(),digits.Visibility()==Visibility::Visible,number.FontSize(),
            (bounds.X+position.X)*scale,(bounds.Y+position.Y)*scale);
        CREATEFILE2_EXTENDED_PARAMETERS options{sizeof(options)};
        auto raw = CreateFile2((folder+L"view.txt").c_str(),GENERIC_WRITE,FILE_SHARE_READ|FILE_SHARE_DELETE,CREATE_ALWAYS,&options);
        if (raw!=INVALID_HANDLE_VALUE) {
            winrt::handle output{raw};
            DWORD written{};
            WriteFile(output.get(),text,static_cast<DWORD>(count),&written,nullptr);
        }
    }

    void refresh()
    {
        const auto state = readFresh(folder + L"obs.txt", 5000);
        auto fps = readFresh(folder + L"fps.txt", 4000);
        if (fps.empty() || fps.size()>4 || fps.find_first_not_of("0123456789")!=std::string::npos) fps.clear();
        const bool checkTarget = refreshes++ % 3 == 0;
        if (checkTarget) {
            bool show = false;
            try {
                if (!state.empty() && targets && targets.Setting()==XboxGameBarAppTargetSetting::Enabled) {
                    auto target = targets.GetTarget();
                    show = target && target.IsGame();
                }
            } catch (const hresult_error&) {}
#ifdef STORE_PACKAGE
            if (!state.empty() && widget && (widget.Pinned() || widget.Visible())) keepReaderActive(show);
            bool hint=false;
            if (widget && state.empty()) {
                try {hint=widget.GameBarDisplayMode()==XboxGameBarDisplayMode::Foreground;}
                catch (const hresult_error&) {}
            }
            setupHint.Visibility(hint?Visibility::Visible:Visibility::Collapsed);
#endif
            if (!show && !state.empty()) show=!readFresh(folder+L"game-target.txt",2500).empty();
            const auto visibility = show ? Visibility::Visible : Visibility::Collapsed;
            if (digits.Visibility()!=visibility) digits.Visibility(visibility);
        }
        if (state != lastState) {
            auto color = Windows::UI::Color{255,55,235,93};
            if (state == "recording") color = {255,255,63,60};
            else if (state != "idle") color = {255,181,181,181};
            ink.Color(color);
            lastState = state;
        }
        if (fps != lastValue || number.Text().empty()) {
            auto value = fps.empty() ? hstring{L"\u2013"} : to_hstring(fps);
            number.Text(value);
            for (auto const& layer : outline) layer.Text(value);
            lastValue = fps;
        }
        if (checkTarget) {
            try { reportView(); } catch (const hresult_error&) {}
        }
    }

    void open(const XboxGameBarWidgetActivatedEventArgs& args)
    {
        const auto window = Window::Current();
        Frame frame;
        Canvas surface;
#ifdef STORE_PACKAGE
        setupHint=TextBlock();
        setupHint.Text(L"시작 메뉴에서 Recording FPS Widget을 열어 OBS를 연결하세요.");
        setupHint.Width(94);
        setupHint.FontSize(12);
        setupHint.TextWrapping(TextWrapping::Wrap);
        setupHint.Visibility(Visibility::Collapsed);
        surface.Children().Append(setupHint);
#endif
        digits = Grid();
        digits.Visibility(Visibility::Collapsed);
        auto display = Windows::Graphics::Display::DisplayInformation::GetForCurrentView();
        const double inset = 10.0 / display.RawPixelsPerViewPixel();
        Canvas::SetLeft(digits, 5.0 + inset);
        Canvas::SetTop(digits, 3.0 + inset);
        auto makeDigit = [] {
            TextBlock layer;
            layer.FontFamily(FontFamily(L"Segoe UI Black"));
            layer.FontWeight(Windows::UI::Text::FontWeights::Black());
            layer.FontSize(20);
            Windows::UI::Xaml::Documents::Typography::SetNumeralAlignment(layer,FontNumeralAlignment::Tabular);
            layer.HorizontalAlignment(HorizontalAlignment::Left);
            layer.IsHitTestVisible(false);
            return layer;
        };
        constexpr double offsets[8][2] = {{-2,0},{2,0},{0,-2},{0,2},{-1.4,-1.4},{-1.4,1.4},{1.4,-1.4},{1.4,1.4}};
        SolidColorBrush black(Windows::UI::Color{255,0,0,0});
        for (size_t i=0;i<outline.size();++i) {
            auto layer = makeDigit();
            TranslateTransform shift;
            shift.X(offsets[i][0]);
            shift.Y(offsets[i][1]);
            layer.RenderTransform(shift);
            layer.Foreground(black);
            digits.Children().Append(layer);
            outline[i]=layer;
        }
        number = makeDigit();
        ink = SolidColorBrush(Windows::UI::Color{255,181,181,181});
        number.Foreground(ink);
        digits.Children().Append(number);
        surface.Children().Append(digits);
        frame.Content(surface);
        window.Content(frame);
        if (args) {
            diagnostic("Connecting view to Game Bar");
            widget = XboxGameBarWidget(args,window.CoreWindow(),frame);
            diagnostic("Game Bar host connected");
            targets = XboxGameBarAppTargetTracker(widget);
        }
        folder = dataFolder();
        if (timer) timer.Stop();
        timer = DispatcherTimer();
        timer.Interval(std::chrono::milliseconds(230));
        timer.Tick([this](auto const&,auto const&){ refresh(); });
        refresh();
        timer.Start();
        window.Activate();
    }

    void OnActivated(const IActivatedEventArgs& args)
    {
        try {
            diagnostic("Game Bar activation");
            const auto activation = args.try_as<XboxGameBarWidgetActivatedEventArgs>();
            if (activation && activation.IsLaunchActivation()) {
                open(activation);
                diagnostic("Game Bar view ready");
            }
        } catch (const hresult_error& e) {
            diagnostic("Game Bar error "+std::to_string(e.code().value)+" "+to_string(e.message()));
            throw;
        }
    }

    void OnLaunched(const LaunchActivatedEventArgs& args)
    {
        diagnostic(args.PrelaunchActivated() ? "background prelaunch" : "app launch");
        if (!args.PrelaunchActivated()) {
#ifdef STORE_PACKAGE
            openSetup(Window::Current());
#else
            open(nullptr);
#endif
        }
    }
};

int __stdcall wWinMain(HINSTANCE,HINSTANCE,PWSTR,int)
{
    try {
        init_apartment(apartment_type::multi_threaded);
        diagnostic("MTA entry");
        Application::Start([](auto const&){
            make<App>();
            diagnostic("XAML application initialized");
        });
        return 0;
    } catch (const hresult_error& e) {
        diagnostic("Startup error "+std::to_string(e.code().value)+" "+to_string(e.message()));
        return e.code().value;
    }
}
