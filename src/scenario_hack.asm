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

; original code checks if WinsockClass has been initialised, we don't do that

%define DDEServerClass__Get_MPlayer_Game_Info 0x004C6170
%define DDEServerClass_this 0x00562538

; NOTE: Removes Debug_Map support
@CLEAR 0x004570DE, 0x90, 0x00457101
@LJMP 0x004570DE, SkipScenarioSet

; NOTE: after GO packet received, client does a useless check, disabling
;@CLEAR 0x0047DF80 0x90 0x0047E02E ; not sure about the clear here
@LJMP 0x0047DF80, 0x0047E143

section .text

SkipScenarioSet:
    PUSH EAX
    MOV EAX, DDEServerClass_this
    CALL DDEServerClass__Get_MPlayer_Game_Info
    TEST EAX,EAX
    POP EAX
    JE 0x00457101
    JMP 0x00457125
