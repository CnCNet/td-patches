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

@CLEAR 0x0047C22C, 0x90, 0x0047C333
@LJMP 0x0047C22C, AlignHostWaiting

@CLEAR 0x0047D2A8, 0x90, 0x0047D3BA
@LJMP 0x0047D2A8, AlignClientWaiting

%define Game_Width          0x00541C04
%define Game_Height         0x00541C08

section .text

AlignHostWaiting:
%push

%define int_dialog_width    240
%define int_dialog_height   230
%define int_list_width      220
%define int_list_height     80

%define int_button_width    80
%define int_button_height   18

%define dialog_width    EBP+0x1A
%define dialog_height   EBP+0x1E
%define dialog_x        EBP+0x22
%define dialog_y        EBP+0x26

%define content_width2  EBP+0x2A
%define button_height   EBP+0x3E
%define button_x        EBP+0x42
%define button_y        EBP+0x46

%define list_width      EBP+0x2E
%define list_height     EBP+0x32
%define list_x          EBP+0x36
%define list_y          EBP+0x3A

    MOV ESI, 2
    MOV DWORD [EBP+0x16], ESI

    MOV DWORD [dialog_width],int_dialog_width
    MOV DWORD [dialog_height],int_dialog_height
    MOV DWORD [list_width],int_list_width
    MOV DWORD [list_height],int_list_height

    MOV EAX,DWORD [Game_Width]
    SHR EAX,1
    MOV DWORD [content_width2], EAX

    MOV EDX,int_dialog_width
    SHR EDX,1
    SUB EAX,EDX

    MOV DWORD [dialog_x], EAX

    MOV EAX,DWORD [Game_Height]
    SHR EAX,1
    MOV EDX,int_dialog_height
    SHR EDX,1
    SUB EAX,EDX

    ; align with the list
    SUB EAX,int_list_height
    SUB EAX,5

    MOV DWORD [dialog_y], EAX

    MOV EAX,DWORD [Game_Width]
    SHR EAX,1
    MOV EDX,int_button_width
    SHR EDX,1
    SUB EAX,EDX
    MOV DWORD [button_x], EAX

    MOV EAX, [dialog_y]
    ADD EAX,int_dialog_height
    SUB EAX,int_button_height
    SUB EAX,12
    MOV DWORD [button_y], EAX
    MOV DWORD [button_height], int_button_height

    MOV EAX, DWORD [dialog_x]
    ADD EAX, 10
    MOV DWORD [list_x], EAX
    MOV EAX, DWORD [dialog_y]
    ADD EAX, 110
    MOV DWORD [list_y], EAX

    MOV DWORD [EBP+0x52], 0

    MOV EDI,0x5A
    XOR EDX,EDX

    JMP 0x0047C333
%pop

AlignClientWaiting:
%push

%define int_dialog_width    240
%define int_dialog_height   244
%define int_plist_width     220
%define int_plist_height    80

%define int_button_width    80
%define int_button_height   18

%define dialog_width    EBP+0x6
%define dialog_height   EBP+0xA
%define dialog_x        EBP+0xE
%define dialog_y        EBP+0x12

%define content_width2  EBP+0x16
%define button_height   EBP+0x36
%define button_x        EBP+0x3A
%define button_y        EBP+0x3E

%define glist_height    EBP+0x1E
%define glist_width     EBP+0x1A
%define glist_y         EBP+0x22
; glist_x is EDI

%define plist_width     EBP+0x26
%define plist_height    EBP+0x2A
; plist_x is EDI
%define plist_y         EBP+0x32

    MOV ESI, 2
    MOV DWORD [EBP+0x2], ESI

    MOV DWORD [dialog_width],int_dialog_width
    MOV DWORD [dialog_height],int_dialog_height
    MOV DWORD [glist_width],int_plist_width
    MOV DWORD [glist_height],15
    MOV DWORD [plist_width],int_plist_width
    MOV DWORD [plist_height],int_plist_height

    MOV EAX,DWORD [Game_Width]
    SHR EAX,1
    MOV DWORD [content_width2], EAX

    MOV EDX,int_dialog_width
    SHR EDX,1
    SUB EAX,EDX

    MOV DWORD [dialog_x], EAX

    MOV EAX,DWORD [Game_Height]
    SHR EAX,1
    MOV EDX,int_dialog_height
    SHR EDX,1
    SUB EAX,EDX

    MOV DWORD [dialog_y], EAX

    MOV EAX,DWORD [Game_Width]
    SHR EAX,1
    MOV EDX,int_button_width
    SHR EDX,1
    SUB EAX,EDX
    MOV DWORD [button_x], EAX

    MOV EAX, [dialog_y]
    ADD EAX,int_dialog_height
    SUB EAX,int_button_height
    SUB EAX,12
    MOV DWORD [button_y], EAX
    MOV DWORD [button_height], int_button_height

    MOV EAX, DWORD [dialog_y]
    ADD EAX, 110
    MOV DWORD [glist_y], EAX

    MOV EAX, DWORD [dialog_y]
    ADD EAX, 110
    ADD EAX, 14
    MOV DWORD [plist_y], EAX

    MOV EDI,[Game_Width]
    SHR EDI,1
    MOV EDX,int_dialog_width
    SHR EDX,1
    SUB EDI,EDX
    ADD EDI,12
    SHR EDI,2

    ; button something
    MOV ESI,0x50

    PUSH 16
    JMP 0x0047D3BA
%pop
