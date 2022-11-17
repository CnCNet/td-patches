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

; Implement statistics packet as a file

cextern LANplayersGlobal

@CALL 0x004C5E3F, Write_Stats_File

%define CCFileClass__CCFileClass    0x00423780
%define CCFileClass__SetFileName    0x00426428
%define CCFileClass__OpenFile       0x00423A18
%define CCFileClass__WriteBytes     0x004237EC
%define CCFileClass__CloseHandle    0x004239F0

section .rdata

str_stats_dmp: db "stats.dmp",0

section .text

Write_Stats_File:

    PUSH EBP
    MOV EBP,ESP

%define buf     EBP-4
%define length  EBP-4-4
%define file    EBP-4-4-44
    SUB ESP,4+4+44

    LEA EBX,[buf]
    MOV [EBX],EAX
    LEA EBX,[length]
    MOV [EBX],EDX

    LEA EAX,[file]
    MOV EDX,str_stats_dmp
    CALL CCFileClass__CCFileClass

    MOV EDX,3
    LEA EAX,[file]
    CALL CCFileClass__OpenFile
    TEST EAX,EAX
    JE .exit

    LEA EBX,[length]
    MOV EBX,[EBX]
    LEA EDX,[buf]
    MOV EDX,[EDX]
    LEA EAX,[file]
    CALL CCFileClass__WriteBytes

    LEA EAX,[file]
    CALL CCFileClass__CloseHandle

.exit:
    MOV EAX,1

    MOV ESP,EBP
    POP EBP
    RETN


hack 0x004C59DC, 0x004C59E5 ; write stats for all players, not just for 2
    cmp eax, dword[LANplayersGlobal]
    jge 0x004C5C6E
    jmp hackend
    
    
hack 0x004C505F, 0x004C50BD ; reverting nyers changes to fix up bugs
    LEA EAX, [ESP+0x354]
    LEA EDX, [ESP+0x2D4]
    CALL 0x004237BC                                            ; [cnc95-v107.004237BC
    LEA EAX, [ESP+0x354]
    CALL 0x00426428                                            ; [cnc95-v107.00426428
    LEA EAX, [ESP+0x354]
    MOV EBX, DWORD[0x50B774]
    MOV EDX, ECX
    DEC EBX
    CALL 0x00423834                                            ; [cnc95-v107.00423834
    LEA EAX, [ESP+0x354]
    CALL 0x004239F0                                            ; [cnc95-v107.004239F0
    PUSH ECX                                                 ; /Arg2
    MOV EBX, 0x004F8CC6                                        ; |ASCII "Nulls-Ville"
    MOV EDX, 0x004F8CD2                                        ; |ASCII "Name"
    PUSH 0x28                                                  ; |Arg1 = 28
    MOV EAX, 0x004F8CD7                                        ; |ASCII "Basic"
    LEA ECX, [ESP+0x388]                                       ; |
    CALL 0x004901F4                                            ; \cnc95-v107.004901F4
    jmp hackend
