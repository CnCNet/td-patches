
%define LoadLibraryA 0x005B047C
%define GetProcAddress 0x005B0460
%define GetCurrentProcess 0x005B0260
%define INIClass_ReadBool 0x005E0900

sint SetProcessAffinityMask, 0
sstring kernel32Dll, "kernel32"
sstring SetProcessAffinityMaskFunction, "SetProcessAffinityMask"
sstring OptionsSection, "Options"
sstring SingleProcAffinityKey, "SingleProcAffinity"

hack 0x0048EB86
    pushad
    mov edx, SingleProcAffinityKey
    mov eax, OptionsSection
    mov ecx, esi
    mov ebx, 1
    call INIClass_ReadBool
    cmp al, 1
    jnz .out
    call SetSingleProcAffinity
    
.out:
    popad
    call INIClass_ReadBool
    jmp 0x0048EB8B

gfunction SetSingleProcAffinity
    pushad
    push kernel32Dll
    call [LoadLibraryA]
    test eax, eax
    jz .out
    push SetProcessAffinityMaskFunction
    push eax
    call [GetProcAddress]
    test eax, eax
    jz .out
    mov [SetProcessAffinityMask], eax
    push 1
    call [GetCurrentProcess]
    push eax
    call [SetProcessAffinityMask]

.out:
    popad
    retn
