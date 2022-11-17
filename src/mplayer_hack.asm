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

; honor MaxPlayers value in C&CSPAWN.INI, Westwood didn't use it

%define WOL_MaxPlayers 0x005442FC

@CLEAR 0x0047CB7C, 0x90, 0x0047CB84
@LJMP 0x0047CB7C, CheckPlayers

sint counter, 0

section .text
CheckPlayers:
    MOV EDX, [WOL_MaxPlayers]
    DEC EDX
    CMP EAX,EDX
    JL 0x0047CC5B
    
    ; temporary workaround - the host is sending the GO packet too quick, some players might not be connected yet. 
    ; We are going to waste some time here!
    inc dword[counter] 
    cmp dword[counter], 1000
    jb .wait
    
    JMP 0x0047CB84

.wait:
    pushad
    push 1
    call 0x004E768A ; sleep
    popad
    jmp 0x0047CC5B
