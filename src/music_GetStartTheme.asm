
@CALL 0x00455B9A, ThemeControlClass_GetStartTheme_2
@CALL 0x0049B1BD, ThemeControlClass_GetStartTheme_1

section .text

ThemeControlClass_CountPlaylist:
push    edx
push    edi
xor     edx, edx
mov     edi, edx
.countloop:
call    0x005DFB80 ; ThemeControlClass_AppearsInPlaylist_new
add     edi, eax
inc     edx
call    0x005E1A40 ; ThemeClass_GetNrOfThemes
cmp     edx, eax
jb     .countloop
mov     eax, edi
pop     edi
pop     edx
retn


ThemeControlClass_GetStartTheme_1:
mov     byte [0x00640000], 0 ; musicrepeat - this was removed from the actual music objects, and instead now depends on the game scene.
call    0x005DFCE0 ; ThemeControlClass_CountPlaylist
test    eax, eax
jz     load_no_theme

cmp     byte [0x005405C9], byte 0   ; check if game mode is single
jz     .check_theme_to_play

cmp     byte [0x00640002], byte 0   ; bMultiplayMusic
jz     load_no_theme

.check_theme_to_play:
cmp     byte [0x00505208], 0xFF ; theme_to_play
jz     getstarttheme_2b

mov     edx, [0x00505208]
movsx   edx, dl
retn

ThemeControlClass_GetStartTheme_2:
mov     byte [0x00640000], 0 ; musicrepeat
call    0x005DFCE0 ; ThemeControlClass_CountPlaylist
test    eax, eax
jz     load_no_theme

getstarttheme_2b:
; using one byte for the scenario, since it should be below 20 anyway
cmp     byte [0x005405C9], byte 0   ; check if game mode is single
jnz    .no_increment
cmp     dword[0x0053E4A8], 14h ; check if Scenario > 20
jge    .no_increment
test    byte [0x00640003], 2            ; StartMusic increment enabling status
jnz    .level_increment
.no_increment:
test    byte [0x00640003], 1            ; StartMusic shuffle enabling status
jz     .load_def_theme
mov     dh, byte [0x00541AAC] ; last generated random number
jmp    .shuffle_increment

; incrementMusic method: increases track number with existing themes
; until level is fully added. No further checks are needed since CountPlayList
; makes sure there is at least 1 existing theme at this point

.level_increment:
mov     dh, byte [0x0053E4A8] ; scenario_number
.shuffle_increment:
mov     dl, byte [0x00640022] ; DefaultTheme

.increase_loop:
cmp     dh, 1
jz     .increase_done
inc dl
call    0x005E1A40 ; ThemeClass_GetNrOfThemes
cmp     dl, al
jb     .continue_increase_check
sub     dl, al ; clear eax

.continue_increase_check:
call    0x005DFB80 ; theme_exists?
sub     dh, al ; only decreases if al = 1
jmp    .increase_loop
.increase_done:
mov     dh, 0    ; clear high byte
retn

.load_def_theme:
xor     edx, edx
mov     dl, byte [0x00640022]              ; default theme
retn

load_no_theme:
mov     edx, 0xFF                         ; no theme
retn

