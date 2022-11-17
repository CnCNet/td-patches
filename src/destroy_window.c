#include <windows.h>
#include "macros/patch.h"
#include "patch.h"

CLEAR(0x004AA19F, 0x90, 0x004AA1A6);
CALL(0x004AA19F, _Destroy_Window);


BOOL WINAPI Destroy_Window(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam)
{
    typedef BOOL (WINAPI *DestroyWindow_)(HWND hWnd);
    
    DestroyWindow_ destroyWindow_ = (DestroyWindow_)GetProcAddress(GetModuleHandleA("User32.dll"), "DestroyWindow");
    
    if (destroyWindow_ && destroyWindow_(hWnd))
        return TRUE;
    
    return PostMessageA(hWnd, Msg, wParam, lParam);
}
