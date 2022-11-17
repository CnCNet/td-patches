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

; this very awful hack forces the game to broadcast empty frames when host is waiting

@LJMP 0x0047CDCB, hack_host_broadcast

section .data

last_broadcast dd 0

section .text

hack_host_broadcast:

    CALL 0x004D03B8

    PUSH EBX
    PUSH EAX

    MOV EBX,[last_broadcast]
    CMP EBX,0
    JE .yas

    SUB EAX,EBX
    CMP EAX,200
    JLE .nope

.yas:
    MOV EAX, [ESP]
    MOV [last_broadcast], EAX

    PUSH EDX
    PUSH ECX

    PUSH 0x00541A48
    XOR EBX,EBX
    MOV EDX,0x00541A68
    MOV EAX,0x0054199C
    XOR ECX,ECX
    CALL 0x0045D0E8

    POP ECX
    POP EDX

.nope:

    POP EAX
    POP EBX

    JMP 0x0047CDD0
