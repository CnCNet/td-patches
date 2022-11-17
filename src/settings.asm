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

@CLEAR 0x0045853C, 0, 0x0045892F
@LJMP 0x0045853C, Spawn_Settings ; replaces Read_Game_Options

@CLEAR 0x00458210, 0, 0x0045853C
@LJMP 0x00458210, Spawn_Settings ; replaces Check_From_WChat

; quick hack so that MP_Scenario is set to 0 instead of -1, causes OOS
; issues with civilian buildings if left to -1
@SET 0x00478BC1, dd 0

cextern TunnelId
cextern TunnelIp
cextern TunnelPort
cextern PortHack
cextern AddressList
cextern P2Pheader
cextern NetKey
cextern GetCRC32

%define DDEServerClass__this    0x00562538
%define DDEServerClass__Get_MPlayer_Game_Info 0x004C6170

%define str_Settings            0x004FB3F0
%define str_Noname              0x004F4955
%define str_Color               0x004F496B
%define str_Name                0x004FB48A
%define str_Side                0x004F4979
%define str_Host                0x004F4937
%define str_Credits             0x004F4986
%define str_Bases               0x004F4996
%define str_Tiberium            0x004F49A4
%define str_Crates              0x004F49B5
%define str_AI                  0x004F49C4
%define str_BuildLevel          0x004F49CF
%define str_UnitCount           0x004F49E2
%define str_Seed                0x004F49F4
%define str_CaptureTheFlag      0x004F4A01
%define str_GameID              0x004F4A18
%define str_MaxPlayers          0x004F4A62
%define str_Scenario            0x004F4A76
%define str_Port                0x004F4929
%define str_Address             0x004F4918
%define str_GameID              0x004F4A18
%define str_StartTime           0x004F4A28
%define str_MCVUndeploy         0x00642023

%define INIClass__Get_String    0x004901F4
%define INIClass__Get_Int       0x00490180
%define INIClass__Get_Bool      0x005E0900
%define inet_addr               0x004E7930
%define htons                   0x004E795A
%define htonl                   0x004E7954

%define SP_Name                 0x00541A5C
%define MP_Name                 0x00540748
%define MP_Side                 0x0054172C
%define MP_Color1               0x00541728
%define MP_Color2               0x00541724
%define MP_Host                 0x005442E8
%define MP_Credits              0x00541738
%define MP_Bases                0x00541734
%define MP_Crates               0x00541740
%define MP_Tiberium             0x0054173C
%define MP_AI                   0x00541744
%define Scenario_BuildLevel     0x00505210
%define MP_UnitCount            0x00505264
%define MP_Seed                 0x00541AAC
%define mp_settings_seed        0x00541A80
%define BitField_Options1       0x0053E4A0
%define BitField_Options2       0x0053E4A1
%define BitField_Options3       0x0053E4A2
%define MP_GameID               0x005442EC
%define MP_MaxPlayers           0x005442FC
%define MP_NumPlayers           0x00505260
%define MP_MaxAhead1            0x00544300
%define MP_MaxAhead2            0x00505278
%define MP_SendRate1            0x00544304
%define MP_SendRate2            0x0054174C
%define MP_Scenario             0x0053E4B0
%define MP_Port                 0x00507B20
%define MP_GameID               0x005442EC
%define MP_StartTime            0x005442F0
%define MP_MCVUndeploy          0x00640009
%define str_format_ini          0x004F57F5


sstring MP_Scenario_ini, "", 64
sstring str_UseBalancePatch, "UseBalancePatch"

section .data

struc bcast
    .ip     RESD 1
    .port   RESD 1
endstruc

str_fmt_other   db "Other%d", 0
str_Tunnel      db "Tunnel", 0
str_Id          db "Id", 0
str_null        db 0
bcast_list: TIMES 48 db 0

%define _sprintf    0x004C672B

%macro sprintf 1-*
    %rep %0
        %rotate -1
        PUSH %1
    %endrep
    CALL _sprintf
    ADD ESP,(%0 * 4)
%endmacro

sint SpawnSeed, 1

hack 0x004D60E5 ; dirty srand hack
    call 0x004D60B4 ; initrandnext_
    cmp dword[spawn_enabled], 1
    jnz hackend
    mov edx, dword[SpawnSeed]
    jmp hackend

    
section .text
Spawn_Settings:
    PUSH ESI
    PUSH EDI
    PUSH ECX
    PUSH EBX
    PUSH EDX
    PUSH EBP

    MOV EBP,ESP

%define sect    EBP-32
%define ipbuf   EBP-32-32

    SUB ESP,32+32

    MOV EAX,DDEServerClass__this
    CALL DDEServerClass__Get_MPlayer_Game_Info
    MOV ESI,EAX

    ; tunnel address
    PUSH ESI                    ; ini string
    PUSH 32                     ; buffer length
    LEA ECX,[ipbuf]             ; buffer
    MOV EBX,str_null            ; default
    MOV EDX,str_Address         ; key
    MOV EAX,str_Tunnel          ; section
    CALL INIClass__Get_String

    LEA EAX, [ipbuf]
    PUSH EAX
    CALL inet_addr
    MOV [TunnelIp], EAX

    ; tunnel port
    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Port            ; key
    MOV EAX,str_Tunnel          ; section
    CALL INIClass__Get_Int
    AND EAX, 0xFFFF
    PUSH EAX
    CALL htons
    MOV word[TunnelPort], ax

    ; tunnel id
    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Port            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    AND EAX, 0xFFFF
    PUSH EAX
    CALL htons
    MOV word[TunnelId], ax

    PUSH ESI                    ; ini string
    PUSH 12                     ; buffer length
    MOV ECX,MP_Name             ; buffer
    MOV EBX,str_Noname          ; default
    MOV EDX,str_Name            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_String

    ; HACK
    PUSH ESI                    ; ini string
    PUSH 12                     ; buffer length
    MOV ECX,SP_Name             ; buffer
    MOV EBX,str_Noname          ; default
    MOV EDX,str_Name            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_String

    PUSH ESI                    ; ini string
    PUSH 12                     ; buffer length
    MOV ECX,MP_Scenario         ; buffer
    MOV EBX,str_Noname          ; default
    MOV EDX,str_Scenario        ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_String

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Side            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV BYTE [MP_Side],AL

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Color           ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_Color1],EAX
    MOV DWORD [MP_Color2],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Host            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV DWORD [MP_Host],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Port            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int

    CMP word [TunnelPort],0
    JNE .nosetport
    MOV DWORD [MP_Port],EAX
    jmp .portset
.nosetport:
    mov DWORD [MP_Port], 0
.portset:

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Credits         ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_Credits],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Bases           ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV DWORD [MP_Bases],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Tiberium        ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV DWORD [MP_Tiberium],EAX

    ; enable tiberium and "whl" bitflag
    TEST EAX,EAX
    JE .notib
    OR Byte [BitField_Options3], 0x18
    JMP .didtib
.notib:
    AND BYTE [BitField_Options3], 0x0E7
.didtib:

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_CaptureTheFlag  ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool

    ; enable CTF bitflag
    AND EAX,1
    OR BYTE [BitField_Options2], AL

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX, 0x00642068         ; key (SeparateHelipad)
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool

    ; enable Separate Helipad
    TEST EAX,EAX
    JE .noSeparateHelipad
    mov byte[0x00640008], 1 ; bSeparateHelipad_global
.noSeparateHelipad:

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_UseBalancePatch ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV byte [UseBalancePatch], al

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Crates          ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV DWORD [MP_Crates],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_AI              ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV DWORD [MP_AI],EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_BuildLevel      ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [Scenario_BuildLevel], EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_UnitCount       ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_UnitCount], EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Seed            ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_Seed], EAX
    MOV DWORD [mp_settings_seed], EAX
    MOV DWORD [SpawnSeed], EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_GameID          ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_GameID], EAX
    ror eax, 8
    mov dword[P2Pheader], eax

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_MaxPlayers      ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV DWORD [MP_MaxPlayers], EAX
    MOV DWORD [MP_NumPlayers], EAX

    MOV EAX,15
    MOV DWORD [MP_MaxAhead1], EAX
    MOV DWORD [MP_MaxAhead2], EAX

    MOV EAX,5
    MOV DWORD [MP_SendRate1], EAX
    MOV DWORD [MP_SendRate2], EAX

    ; read OtherX sections
    XOR EDI,EDI
.next_other:

    ; create section name
    MOV EDX, EDI
    INC EDX
    LEA EAX, [sect]
    sprintf EAX, str_fmt_other, EDX

    PUSH ESI                    ; ini string
    PUSH 32                     ; buffer length
    LEA ECX,[ipbuf]             ; buffer
    MOV EBX,str_Noname          ; default
    MOV EDX,str_Address         ; key
    LEA EAX,[sect]              ; section
    CALL INIClass__Get_String

    LEA EAX, [ipbuf]
    PUSH EAX
    CALL inet_addr

    LEA EDX, [EDI * bcast_size]
    ADD EDX, bcast_list + bcast.ip
    
    inc edi
    MOV DWORD [EDX], EDI
    dec edi
    mov [edi * ListAddress_size + AddressList + ListAddress.ip], eax

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_Port            ; key
    LEA EAX,[sect]              ; section
    CALL INIClass__Get_Int
    
    PUSH EAX
    CALL htons
    AND EAX, 0xFFFF

    LEA EDX, [EDI * bcast_size]
    ADD EDX, bcast_list + bcast.port
    MOV DWORD [EDX], EAX
    
    mov [edi * ListAddress_size + AddressList + ListAddress.port], ax
    
    INC EDI
    CMP EDI,6
    JL .next_other

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_GameID          ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV [MP_GameID], EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_StartTime       ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Int
    MOV [MP_StartTime], EAX

    MOV ECX,ESI                 ; ini string
    XOR EBX,EBX                 ; default
    MOV EDX,str_MCVUndeploy     ; key
    MOV EAX,str_Settings        ; section
    CALL INIClass__Get_Bool
    MOV BYTE [MP_MCVUndeploy],AL
    SHL EAX,5
    OR BYTE [BitField_Options2],AL

    sprintf MP_Scenario_ini, str_format_ini, MP_Scenario
    
    push MP_Scenario_ini
    call GetCRC32
    add esp, 4 
    mov dword[NetKey], eax
    
    xor eax, eax
    mov ax, word[MP_GameID+2]
    add dword[NetKey], eax
    
    MOV EAX,1

    MOV ESP,EBP
    POP EBP
    POP EDX
    POP EBX
    POP ECX
    POP EDI
    POP ESI
    RETN
