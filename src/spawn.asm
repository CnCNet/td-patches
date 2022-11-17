;
; Copyright (c) 2013 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

; forces loading C&CSPAWN.INI aka WCHAT mode, still WIP

extern FileClass__FileClass
extern FileClass__Is_Available
extern FileClass__Read

%define strstr                              0x004D64C9

%define DDEServerClass__Delete_MPlayer_Game_Info 0x004C6174
%define operator__new                       0x004C6990


@CLEAR 0x004F3CE4, 0x41, 0x004F3CE5 ; Loads SA* mix files instead of SC* mix files (breaks SP)

@CLEAR 0x004C5F4C, 0, 0x004C5FBC
@LJMP 0x004C5F4C, DDEServerClass__DDEServerClass

@CLEAR 0x004C5FBC, 0, 0x004C5FE0
@LJMP 0x004C5FBC, DDEServerClass__Enable

@CLEAR 0x004C5FE0, 0, 0x004C6000
@LJMP 0x004C5FE0, DDEServerClass__Disable

@CLEAR 0x004C61A4, 0, 0x004C6260
@LJMP 0x004C61A4, DDEServerClass__Send

@CLEAR 0x0045799C, 0x90, 0x004579B6
@LJMP 0x0045799C, CheckSpawnArg


@SJMP 0x0047DEB9, 0x0047DE91 ; Connect dialog: do NOT remove names from listbox after X time without response - crash 0x004afbf4

; increase size of unknown array to fix the 6player crash
sbyte UnknownArray, 0, 6*4
@SET 0x00439A2A, { MOV DWORD[EAX*4+UnknownArray], EDX }
@SET 0x004755F6, { MOV EAX, DWORD[EBX+UnknownArray] }
@SET 0x0047F982, { MOV EAX, DWORD[ECX+UnknownArray] }
@SET 0x004913FF, { MOV ECX, DWORD[EAX+UnknownArray] }


section .data
str_spawn_ini db "spawn.ini",0
arg_spawn db "-SPAWN",0


; disable "Start new game" button to prevent freezing in the mini multiplayer version
hack 0x00470D95, 0x00470D9D
    JBE 0x00470E7A
    jmp hackend


hack 0x00490F8F ; show recon dialog faster
    call 0x004CAB50 ; WinTimerClass::Get_System_Tick_Count(void)
    cmp dword[spawn_enabled], 0
    jz hackend
    
    cmp eax, 1000
    jb 0x00490F98
    
    jmp hackend
    
    

section .text
CheckSpawnArg:
    MOV EDX,arg_spawn
    MOV EAX,ESI
    CALL strstr
    TEST EAX,EAX
    JE .nospawn

    MOV DWORD [spawn_enabled], 1

.nospawn:
    JMP 0x004579B6

DDEServerClass__DDEServerClass:
    MOV DWORD [EAX], 0
    RETN

DDEServerClass__Enable:
%push
    PUSH ESI
    PUSH EDI
    PUSH EDX
    PUSH EBP
    MOV EBP, ESP

%define file        EBP-52

    SUB ESP, 52

    MOV ESI, EAX

    MOV EAX, [spawn_enabled]
    TEST EAX,EAX
    JE .nospawn

    MOV EAX,ESI
    CALL DDEServerClass__Delete_MPlayer_Game_Info

    MOV EAX,1024
    CALL operator__new
    MOV EDI,EAX

    MOV EDX,str_spawn_ini
    LEA EAX,[file]
    CALL FileClass__FileClass

    XOR EDX,EDX
    LEA EAX,[file]
    CALL FileClass__Is_Available
    TEST EAX,EAX
    JE .nospawn

    MOV EBX,1024
    MOV EDX,EDI
    LEA EAX,[file]
    CALL FileClass__Read
    TEST EAX,EAX
    JE .nospawn

    MOV DWORD [ESI], EDI

.nospawn:
    MOV ESP,EBP
    POP EBP
    POP EDX
    POP EDI
    POP ESI
    RETN
%pop

DDEServerClass__Disable:
    RETN

DDEServerClass__Send:
    MOV EAX,1
    RETN
