;Very hackish way to change the timeout, was too lazy to search for the root of the evil

@LJMP 0x00491B86, ChangeReconnectTimeout

section .text

ChangeReconnectTimeout:
    mov dword[esp], edx
    mov esi, ebx
    cmp dword[eax+9], 18000 ;Original value (WOL Timeout = 5minutes)
    jnz 0x00491B8B
    mov dword[eax+9], 1000
    jmp 0x00491B8B
