%include "macros/setsym.inc"
%include "macros/watcall.inc"

setcglob 0x004D9C94, start
setcglob 0x00505570, int_Height
setcglob 0x0050556C, int_Width
setcglob 0x00541CCC, game_surface_0
setcglob 0x00541AB8, game_surface_1
setcglob 0x00541C00, game_surface_2
setcglob 0x00541B5C, game_surface_4
setcglob 0x004C97C8, GraphicViewPortClass__Attach
setcglob 0x00490180, INIClass__Get_Int
setcglob 0x00410E30, GameWindowProc
setcglob 0x005B02B0, _imp__Sleep@4

setcglob 0x00567848, hWnd
setcglob 0x004E7816, GetProcAddress
setcglob 0x005B0460, _imp__GetProcAddress
setcglob 0x004E781C, LoadLibraryA
setcglob 0x005B047C, _imp__LoadLibraryA@4
setcglob 0x005E65C0, FreeLibrary
setcglob 0x005B0260, GetCurrentProcess
setcglob 0x004E7846, GetCurrentProcessId
setcglob 0x004E7804, GetCurrentThreadId
setcglob 0x005B0240, CreateFile
setcglob 0x004A9720, WinMain
setcglob 0x005B0190, MessageBoxA
setcglob 0x004CF195, _exit

setcglob 0x004E797E, WSAStartup
setcglob 0x004E7960, socket
setcglob 0x004E7972, setsockopt
setcglob 0x004E794E, bind
setcglob 0x004E795A, htons
setcglob 0x004E7924, closesocket

setcglob 0x0045BFC0, IPXAddressClass__IPXAddressClass
setcglob 0x0055433C, ipx_socket
setcglob 0x00554340, ptr_wsock32
setcglob 0x00507B20, port

setcglob 0x00505260, LANplayersGlobal

; imports
setcglob 0x005B06AC, _imp__recvfrom
setcglob 0x005B06B0, _imp__sendto
setcglob 0x005B05DC, _imp__PostMessageA
setcglob 0x005B045C, _imp__GetModuleHandleA

; watcall functions
setwatglob 0x00423780, FileClass__FileClass, 2
setwatglob 0x004239A0, FileClass__Is_Available, 1
setwatglob 0x00423834, FileClass__Read, 3
setwatglob 0x0042398C, FileClass__Size, 1
setwatglob 0x00411B70, FileClass__dtor, 2

setwatglob 0x004C69B5, free, 1
setwatglob 0x004E33F3, calloc, 2


;winapi
;Address  Ordinal Name                          Library 
;-------  ------- ----                          ------- 
;005B0108         RegCloseKey                   ADVAPI32
;005B010C         RegEnumKeyExA                 ADVAPI32
;005B0110         RegOpenKeyExA                 ADVAPI32
;005B0114         RegQueryInfoKeyA              ADVAPI32
;005B0118         RegQueryValueExA              ADVAPI32
;005B0134         timeBeginPeriod               WINMM   
;005B0138         timeEndPeriod                 WINMM   
;005B013C         timeKillEvent                 WINMM   
;005B0140         timeSetEvent                  WINMM   
;005B0178         ClipCursor                    USER32  
;005B017C         DispatchMessageA              USER32  
;005B0180         GetAsyncKeyState              USER32  
;005B0184         GetCursorPos                  USER32  
;005B0188         GetKeyState                   USER32  
;005B018C         GetMessageA                   USER32  
;005B0190         MessageBoxA                   USER32  
;005B0194         PeekMessageA                  USER32  
;005B0198         SetCursor                     USER32  
;005B019C         TranslateMessage              USER32  
;005B01A0         VkKeyScanA                    USER32  
;005B0234         ClearCommError                KERNEL32
;005B0238         CloseHandle                   KERNEL32
;005B023C         CreateEventA                  KERNEL32
;005B0240         CreateFileA                   KERNEL32
;005B0244         CreateThread                  KERNEL32
;005B0248         DeleteCriticalSection         KERNEL32
;005B024C         DuplicateHandle               KERNEL32
;005B0250         EnterCriticalSection          KERNEL32
;005B0254         EscapeCommFunction            KERNEL32
;005B0258         GetCommModemStatus            KERNEL32
;005B025C         GetCommState                  KERNEL32
;005B0260         GetCurrentProcess             KERNEL32
;005B0264         GetCurrentThread              KERNEL32
;005B0268         GetDriveTypeA                 KERNEL32
;005B026C         GetFileSize                   KERNEL32
;005B0270         GetLastError                  KERNEL32
;005B0274         GetOverlappedResult           KERNEL32
;005B0278         GetPriorityClass              KERNEL32
;005B027C         GetThreadContext              KERNEL32
;005B0280         InitializeCriticalSection     KERNEL32
;005B0284         LeaveCriticalSection          KERNEL32
;005B0288         OutputDebugStringA            KERNEL32
;005B028C         PurgeComm                     KERNEL32
;005B0290         ReadFile                      KERNEL32
;005B0294         ResetEvent                    KERNEL32
;005B0298         SetCommState                  KERNEL32
;005B029C         SetCommTimeouts               KERNEL32
;005B02A0         SetFilePointer                KERNEL32
;005B02A4         SetPriorityClass              KERNEL32
;005B02A8         SetThreadPriority             KERNEL32
;005B02AC         SetupComm                     KERNEL32
;005B02B0         Sleep                         KERNEL32
;005B02B4         TerminateThread               KERNEL32
;005B02B8         WriteFile                     KERNEL32
;005B02D0         RegCloseKey                   ADVAPI32
;005B02D4         RegQueryValueA                ADVAPI32
;005B02D8         RegQueryValueExA              ADVAPI32
;005B03E0         ClearCommBreak                KERNEL32
;005B03E4         CloseHandle                   KERNEL32
;005B03E8         CreateEventA                  KERNEL32
;005B03EC         CreateFileA                   KERNEL32
;005B03F0         CreateMutexA                  KERNEL32
;005B03F4         CreateProcessA                KERNEL32
;005B03F8         CreateThread                  KERNEL32
;005B03FC         DeleteFileA                   KERNEL32
;005B0400         DosDateTimeToFileTime         KERNEL32
;005B0404         EscapeCommFunction            KERNEL32
;005B0408         ExitProcess                   KERNEL32
;005B040C         ExitThread                    KERNEL32
;005B0410         FileTimeToDosDateTime         KERNEL32
;005B0414         FileTimeToLocalFileTime       KERNEL32
;005B0418         FindClose                     KERNEL32
;005B041C         FindFirstFileA                KERNEL32
;005B0420         FindNextFileA                 KERNEL32
;005B0424         GetCPInfo                     KERNEL32
;005B0428         GetCommandLineA               KERNEL32
;005B042C         GetConsoleMode                KERNEL32
;005B0430         GetCurrentDirectoryA          KERNEL32
;005B0434         GetCurrentProcessId           KERNEL32
;005B0438         GetCurrentThreadId            KERNEL32
;005B043C         GetCurrentThread              KERNEL32
;005B0440         GetDiskFreeSpaceA             KERNEL32
;005B0444         GetEnvironmentStrings         KERNEL32
;005B0448         GetFileTime                   KERNEL32
;005B044C         GetFileType                   KERNEL32
;005B0450         GetLastError                  KERNEL32
;005B0454         GetLocalTime                  KERNEL32
;005B0458         GetModuleFileNameA            KERNEL32
;005B045C         GetModuleHandleA              KERNEL32
;005B0460         GetProcAddress                KERNEL32
;005B0464         GetStdHandle                  KERNEL32
;005B0468         GetTimeZoneInformation        KERNEL32
;005B046C         GetVersion                    KERNEL32
;005B0470         GetVolumeInformationA         KERNEL32
;005B0474         GlobalMemoryStatus            KERNEL32
;005B0478         IsBadReadPtr                  KERNEL32
;005B047C         LoadLibraryA                  KERNEL32
;005B0480         LocalFileTimeToFileTime       KERNEL32
;005B0484         ReadConsoleInputA             KERNEL32
;005B0488         ReadFile                      KERNEL32
;005B048C         ReleaseMutex                  KERNEL32
;005B0490         RtlUnwind                     KERNEL32
;005B0494         SetCommBreak                  KERNEL32
;005B0498         SetConsoleCtrlHandler         KERNEL32
;005B049C         SetConsoleMode                KERNEL32
;005B04A0         SetCurrentDirectoryA          KERNEL32
;005B04A4         SetEvent                      KERNEL32
;005B04A8         SetFilePointer                KERNEL32
;005B04AC         SetStdHandle                  KERNEL32
;005B04B0         Sleep                         KERNEL32
;005B04B4         TlsAlloc                      KERNEL32
;005B04B8         TlsFree                       KERNEL32
;005B04BC         TlsGetValue                   KERNEL32
;005B04C0         TlsSetValue                   KERNEL32
;005B04C4         VirtualAlloc                  KERNEL32
;005B04C8         VirtualFree                   KERNEL32
;005B04CC         WaitForSingleObject           KERNEL32
;005B04D0         WriteConsoleA                 KERNEL32
;005B04D4         WriteFile                     KERNEL32
;005B04D8         lstrcpyA                      KERNEL32
;005B04E8         DirectDrawCreate              DDRAW   
;005B04F8         DirectSoundCreate             DSOUND  
;005B0588         CreateWindowExA               USER32  
;005B058C         DdeAccessData                 USER32  
;005B0590         DdeClientTransaction          USER32  
;005B0594         DdeConnect                    USER32  
;005B0598         DdeCreateStringHandleA        USER32  
;005B059C         DdeDisconnect                 USER32  
;005B05A0         DdeInitializeA                USER32  
;005B05A4         DdeNameService                USER32  
;005B05A8         DdeQueryStringA               USER32  
;005B05AC         DdeUnaccessData               USER32  
;005B05B0         DdeUninitialize               USER32  
;005B05B4         DefWindowProcA                USER32  
;005B05B8         DialogBoxParamA               USER32  
;005B05BC         DispatchMessageA              USER32  
;005B05C0         FindWindowA                   USER32  
;005B05C4         GetActiveWindow               USER32  
;005B05C8         GetMessageA                   USER32  
;005B05CC         IsWindow                      USER32  
;005B05D0         LoadIconA                     USER32  
;005B05D4         MessageBoxA                   USER32  
;005B05D8         PeekMessageA                  USER32  
;005B05DC         PostMessageA                  USER32  
;005B05E0         PostQuitMessage               USER32  
;005B05E4         RegisterClassA                USER32  
;005B05E8         RegisterWindowMessageA        USER32  
;005B05EC         SendMessageA                  USER32  
;005B05F0         SetFocus                      USER32  
;005B05F4         SetForegroundWindow           USER32  
;005B05F8         ShowCursor                    USER32  
;005B05FC         ShowWindow                    USER32  
;005B0600         TranslateMessage              USER32  
;005B0604         UpdateWindow                  USER32  
;005B0608         wsprintfA                     USER32  
;005B0668         WSAAsyncGetHostByAddr         WSOCK32 
;005B066C         WSAAsyncGetHostByName         WSOCK32 
;005B0670         WSAAsyncSelect                WSOCK32 
;005B0674         WSACancelAsyncRequest         WSOCK32 
;005B0678         WSACleanup                    WSOCK32 
;005B067C         WSAGetLastError               WSOCK32 
;005B0680         WSAStartup                    WSOCK32 
;005B0684         accept                        WSOCK32 
;005B0688         bind                          WSOCK32 
;005B068C         closesocket                   WSOCK32 
;005B0690         getsockopt                    WSOCK32 
;005B0694         htonl                         WSOCK32 
;005B0698         htons                         WSOCK32 
;005B069C         inet_addr                     WSOCK32 
;005B06A0         inet_ntoa                     WSOCK32 
;005B06A4         ntohl                         WSOCK32 
;005B06A8         ntohs                         WSOCK32 
;005B06B4         setsockopt                    WSOCK32 
;005B06B8         socket                        WSOCK32 
;005B06EC         _IPX_Broadcast_Packet95       thipx32 
;005B06F0         _IPX_Close_Socket95           thipx32 
;005B06F4         _IPX_Get_Connection_Number95  thipx32 
;005B06F8         _IPX_Get_Local_Target95       thipx32 
;005B06FC         _IPX_Get_Outstanding_Buffer95 thipx32 
;005B0700         _IPX_Initialise               thipx32 
;005B0704         _IPX_Open_Socket95            thipx32 
;005B0708         _IPX_Send_Packet95            thipx32 
;005B070C         _IPX_Shut_Down95              thipx32 
;005B0710         _IPX_Start_Listening95        thipx32 