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

; forward original WinsockManagerClass stuff to IPXConnClass

@CLEAR 0x004AB5F8, 0, 0x004AB66C
@LJMP 0x004AB5F8, WinsockManagerClass__Init

@CLEAR 0x004AC01C, 0, 0x004AC044
@LJMP 0x004AC01C, WinsockManagerClass__Set_Host_Address

@CLEAR 0x004AC044, 0, 0x004AC2D0
@LJMP 0x004AC044, WinsockManagerClass__Start_Client

@CLEAR 0x004AB700, 0, 0x004AB7B8
@LJMP 0x004AB700, WinsockManagerClass__Read

section .text

WinsockManagerClass__Init:
    MOV EAX,1
    RETN

WinsockManagerClass__Set_Host_Address:
    MOV EAX,1
    RETN

WinsockManagerClass__Start_Client:
    CALL IPXConnClass__Start_Listening
    MOV EAX,1
    RETN

; only used to clear input queue before waiting for players
WinsockManagerClass__Read:
    MOV EAX,0
    RETN
