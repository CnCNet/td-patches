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

@CLEAR 0x0045C57C, 0, 0x0045C5B8
@LJMP 0x0045C57C, IPXConnClass__Start_Listening

@CLEAR 0x0045C5B8, 0, 0x0045C608
@LJMP 0x0045C5B8, IPXConnClass__Stop_Listening

@CLEAR 0x0045C6C8, 0, 0x0045C7AC
@LJMP 0x0045C6C8, IPXConnClass__Send_To

@CLEAR 0x0045C7AC, 0, 0x0045C7E0
@LJMP 0x0045C7AC, IPXConnClass__Broadcast

@CLEAR 0x0045BFB0, 0, 0x0045BFBC
@LJMP 0x0045BFB0, IPX_Initialise

@CLEAR 0x0045DA24, 0, 0x0045DA4C
@LJMP 0x0045DA24, IPX_Get_Connection_Number

@CLEAR 0x0045DA3C, 0, 0x0045DA4C
@LJMP 0x0045DA3C, IPX_Get_Local_Target

@CALL 0x0045D45D, IPX_Select

cextern NetHack_SendTo
cextern NetHack_RecvFrom
cextern _imp__sendto
cextern _imp__recvfrom

struc sockaddr_in
    .sin_family     RESW 1
    .sin_port       RESW 1
    .sin_addr       RESD 1
    .sin_zero       RESB 8
endstruc

struc timeval
    .tv_sec         RESD 1
    .tv_usec        RESD 1
endstruc

struc fd_set
    .fd_count       RESD 1
    .fd_array       RESD 64
endstruc

struc ipx_address
    .zero:       RESD 1
    .ip:         RESD 1
    .port:       RESW 1
endstruc

section .rdata

str_wsock32_dll: db "wsock32.dll", 0
str_select: db "select", 0

section .data

select: dd 0

%define GetProcAddress                      0x004E7816
%define LoadLibraryA                        0x004E781C
%define IPXAddressClass__IPXAddressClass    0x0045BFC0

%define WSAStartup  0x004E797E
%define socket      0x004E7960
%define setsockopt  0x004E7972
%define bind        0x004E794E
%define htons       0x004E795A
%define closesocket 0x004E7924

%define ipx_socket  0x0055433C
%define ptr_wsock32 0x00554340
%define port        0x00507B20

section .text

; intentional stub
IPX_Initialise:
    MOV EAX,1
    RETN

; intentional stub
IPX_Get_Connection_Number:
    MOV EAX,1
    RETN

; intentional stub
IPX_Get_Local_Target:
    MOV EAX,1
    RETN

IPXConnClass__Start_Listening:
%push
    PUSH ESI
    PUSH EBP
    MOV EBP, ESP

%define buf         EBP-100

    SUB ESP, 100

    CMP DWORD [ptr_wsock32], 0
    JNE .have_winsock

    ; load wsock32 because we need select()
    PUSH str_wsock32_dll
    CALL LoadLibraryA
    TEST EAX,EAX 
    JE .error

    MOV [ptr_wsock32], EAX

    ; load select()
    PUSH str_select
    MOV EAX, [ptr_wsock32]
    PUSH EAX
    CALL GetProcAddress
    TEST EAX,EAX
    JE .error

    MOV ESI, select
    MOV [ESI], EAX

    ; initialize winsock
    LEA EAX, [buf]
    PUSH EAX
    PUSH 0x101
    CALL WSAStartup

.have_winsock:
    ; if we have an open socket, use it
    CMP DWORD [ipx_socket], 0
    JNE .loaded

    ; create socket
    PUSH 17 ; IPPROTO_UDP
    PUSH 2  ; SOCK_DGRAM
    PUSH 2  ; AF_INET
    CALL socket

    MOV [ipx_socket], EAX

    ; skip broadcast support if spawner enabled
    CMP DWORD [spawn_enabled], 1
    JE .nobroadcast
    ; enable broadcast
    LEA EAX, [buf]
    MOV BYTE [EAX], 1
    PUSH 1
    PUSH EAX
    PUSH 32 ; SO_BROADCAST
    PUSH 0xFFFF ; SOL_SOCKET
    MOV EAX, [ipx_socket]
    PUSH EAX
    CALL setsockopt
.nobroadcast:

    ; enable reuseaddr
    LEA EAX, [buf]
    MOV BYTE [EAX], 1
    PUSH 1
    PUSH EAX
    PUSH 4 ; SO_REUSEADDR
    PUSH 0xFFFF ; SOL_SOCKET
    MOV EAX, [ipx_socket]
    PUSH EAX
    CALL setsockopt

    MOV WORD [buf + sockaddr_in.sin_family], 2 ; AF_INET
    MOV EAX, [port]
    PUSH EAX
    CALL htons
    MOV WORD [buf + sockaddr_in.sin_port], AX
    MOV DWORD [buf + sockaddr_in.sin_addr], 0 ; INADDR_ANY
    MOV DWORD [buf + sockaddr_in.sin_zero], 0
    MOV DWORD [buf + sockaddr_in.sin_zero + 4], 0

    PUSH 16
    LEA EAX, [buf]
    PUSH EAX
    MOV EAX, [ipx_socket]
    PUSH EAX
    CALL bind

.loaded:
    MOV EAX,1
.error:
    MOV ESP,EBP
    POP EBP
    POP ESI
    RETN
%pop

IPXConnClass__Stop_Listening:
    MOV EAX, [ipx_socket]
    CMP EAX,0
    JE .done

    PUSH EAX
    CALL closesocket
    XOR EAX,EAX
    MOV [ipx_socket], EAX

.done:
    RETN

IPXConnClass__Send_To:
    PUSH EBP
    MOV EBP,ESP
    SUB ESP, 16 ; one sockaddr_in

    MOV ESI,EAX

    MOV WORD [ESP + sockaddr_in.sin_family], 2 ; AF_INET
    MOV WORD AX, [EBX + ipx_address.port]
    MOV WORD [ESP + sockaddr_in.sin_port], AX
    MOV DWORD EAX, [EBX + ipx_address.ip]
    MOV DWORD [ESP + sockaddr_in.sin_addr], EAX
    MOV DWORD [ESP + sockaddr_in.sin_zero], 0
    MOV DWORD [ESP + sockaddr_in.sin_zero + 4], 0

    MOV EAX,ESP
    PUSH 16         ; socklen
    PUSH EAX        ; sockaddr
    PUSH 0          ; flags
    PUSH EDX        ; buflen
    PUSH ESI        ; buf
    MOV EAX, [ipx_socket]
    PUSH EAX        ; socket
    
    CMP DWORD [spawn_enabled], 0
    JE .nospawn
    
    CALL NetHack_SendTo
    jmp .done
    
.nospawn:
    CALL [_imp__sendto]

.done:

    MOV EAX,1

    MOV ESP,EBP
    POP EBP
    RETN

IPXConnClass__Broadcast:
    PUSH ESI
    PUSH EDI
    PUSH EBP
    MOV EBP,ESP
    SUB ESP, 16 ; one sockaddr_in

    MOV ESI,EAX

    MOV EAX, [ipx_socket]
    CMP EAX,0
    JE .exit

    CMP DWORD [spawn_enabled], 0
    JE .nospawn

    XOR EDI,EDI
.next_other:

    MOV WORD [ESP + sockaddr_in.sin_family], 2 ; AF_INET

    LEA EAX, [EDI * bcast_size]
    ADD EAX, bcast_list + bcast.port
    MOV EAX,[EAX]
    CMP EAX,0
    JE .exit
    MOV WORD [ESP + sockaddr_in.sin_port], AX

    LEA EAX, [EDI * bcast_size]
    ADD EAX, bcast_list + bcast.ip
    MOV EAX,[EAX]
    CMP EAX,-1
    JE .exit
    MOV DWORD [ESP + sockaddr_in.sin_addr], EAX

    MOV DWORD [ESP + sockaddr_in.sin_zero], 0
    MOV DWORD [ESP + sockaddr_in.sin_zero + 4], 0

    MOV EAX,ESP

    PUSH EDX

    PUSH 16         ; socklen
    PUSH EAX        ; sockaddr
    PUSH 0          ; flags
    PUSH EDX        ; buflen
    PUSH ESI        ; buf
    MOV EAX, [ipx_socket]
    PUSH EAX        ; socket
    CALL NetHack_SendTo

    POP EDX

    INC EDI
    CMP EDI,6
    JL .next_other

    JMP .exit

.nospawn:
    MOV WORD [ESP + sockaddr_in.sin_family], 2 ; AF_INET
    MOV EAX, [port]
    PUSH EAX
    CALL htons
    MOV WORD [ESP + sockaddr_in.sin_port], AX
    MOV DWORD [ESP + sockaddr_in.sin_addr], 0xFFFFFFFF
    MOV DWORD [ESP + sockaddr_in.sin_zero], 0
    MOV DWORD [ESP + sockaddr_in.sin_zero + 4], 0

    MOV EAX,ESP
    PUSH 16         ; socklen
    PUSH EAX        ; sockaddr
    PUSH 0          ; flags
    PUSH EDX        ; buflen
    PUSH ESI        ; buf
    MOV EAX, [ipx_socket]
    PUSH EAX        ; socket
    CALL [_imp__sendto]

.exit:
    MOV EAX,1

    MOV ESP,EBP
    POP EBP
    POP EDI
    POP ESI
    RETN

; _IPX_Get_Outstanding_Buffer95 implementation
IPX_Select:

    PUSH ESI
    MOV ESI, [ESP+8]

    PUSH EBP
    MOV EBP, ESP

%define tv          EBP-8
%define ipaddr      EBP-8-16
%define iplen       EBP-8-16-4
%define readfds     EBP-8-16-4-260

    SUB ESP, 8+16+4+260

    ; bail out immediately if no socket open
    MOV EAX, [ipx_socket]
    CMP EAX,0
    JE .error

    ; zero IPXHEADER 
    XOR EAX,EAX
%assign i 0
%rep 8
    LEA EDX, [ESI+i]
    MOV [EDX], EAX
%assign i i+4
%endrep

    ; set timeval to instant timeout
    MOV DWORD [tv], 0
    MOV DWORD [tv+4], 0

    ; create fd_set with our socket
    MOV DWORD [readfds], 1
    MOV EAX, [ipx_socket]
    MOV DWORD [readfds+4], EAX

    ; select() on our set
    LEA EAX, [tv]
    PUSH EAX        ; timeval
    PUSH 0          ; exceptfds
    PUSH 0          ; writefds
    LEA EAX, [readfds]
    PUSH EAX        ; readfds
    MOV EAX, [ipx_socket]
    INC EAX
    PUSH EAX        ; nfds
    CALL [select]
    TEST EAX,EAX
    JE .error

    ; set iplen
    LEA EAX, [iplen]
    MOV DWORD [EAX], 16

    ; read packet
    LEA EAX, [iplen]
    PUSH EAX    ; fromlen
    LEA EAX, [ipaddr]
    PUSH EAX    ; from
    PUSH 0      ; flags
    PUSH 1024   ; buflen
    LEA EAX, [ESI + 30]
    PUSH EAX    ; buf
    MOV EAX, [ipx_socket]
    PUSH EAX    ; socket
    
    CMP DWORD [spawn_enabled], 0
    je .nospawn
    
    CALL NetHack_RecvFrom
    jmp .done
    
.nospawn:
    CALL [_imp__recvfrom]

.done:
    
    CMP EAX,-1
    JE .error
    TEST EAX,EAX
    JE .error

.packet:
    ; set read length
    ADD EAX, 30
    PUSH EAX
    CALL htons
    LEA EDX, [ESI + 2]
    MOV WORD [EDX], AX

    ; set address
    LEA EDX, [ESI + 18],
    XOR EAX,EAX
    MOV [EDX], EAX
    LEA EDX, [ESI + 22]
    LEA EAX, [ipaddr + sockaddr_in.sin_addr]
    MOV EAX, [EAX]
    MOV [EDX], EAX
    LEA EDX, [ESI + 26]

    LEA EAX, [ipaddr + sockaddr_in.sin_port]
    MOV EAX, [EAX]
    MOV WORD [EDX], AX

    MOV EAX,1
    JMP .exit

.error:
    XOR EAX,EAX

.exit:
    MOV ESP,EBP
    POP EBP
    POP ESI

    RET 4
