#include <windows.h>
#include <stdint.h>
#include "cnc95.h"
#include "patch.h"

typedef int (__stdcall *GETPRIVATEPROFILESTRINGAPROC)(LPCTSTR, LPCTSTR, LPCTSTR, LPTSTR, DWORD, LPCTSTR);

void EarlyIniLoad()
{
    GETPRIVATEPROFILESTRINGAPROC getPrivateProfileStringA = 
        (GETPRIVATEPROFILESTRINGAPROC)GetProcAddress(GetModuleHandleA("Kernel32.dll"), "GetPrivateProfileStringA");
    
    if (getPrivateProfileStringA)
    {
        char buf[8] = {0};
        
        getPrivateProfileStringA("Settings", "UseBalancePatch", "0", buf, sizeof(buf), ".\\spawn.ini");
        
        UseBalancePatch = buf[0] == '1';
    }
}
