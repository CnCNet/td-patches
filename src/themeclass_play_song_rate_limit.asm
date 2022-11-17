
; ThemeClass::Play_Song(ThemeType) causing high cpu load when no music was found

sint LastTick, 0

hack 0x004B48E8, 0x004B48F1
    pushad
    
    mov eax, 0x005A2864
    call 0x004D034C ; TimerClass::Get_Ticks(void)
    
    cmp dword[LastTick], 0
    jz .ok
    mov edx, eax
    sub edx, dword[LastTick]
    cmp edx, 300 ; 5seconds
    jbe .skip
   
.ok:
    mov dword[LastTick], eax
    popad
    jmp hackend

.skip:
    popad
    jmp 0x004B4934
