%include "macros/patch.inc"
%include "macros/datatypes.inc"
%include "cnc95.inc"

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

; hifi's spawner

%define spawn_enabled                       0x00558804

%include "src/settings.asm"
%include "src/no_wchat.asm"
%include "src/no_windowtricks.asm"
%include "src/scenario_hack.asm"
%include "src/mplayer_hack.asm"
%include "src/spawn.asm"
%include "src/winsock.asm"
%include "src/udp.asm"
%include "src/endgame_quit.asm"
%include "src/align_waiting.asm"
%include "src/stats.asm"
%include "src/hack_cncnet5_tunneling.asm"
%include "src/no_wait.asm"

; iran's experimentation

;%include "src/exception.asm"
%include "src/hires.asm"
%include "src/mousewheel_scrolling.asm"
%include "src/custom_hotkeys.asm"

%include "src/reconnect_timeout.asm"
%include "src/music_GetStartTheme.asm"
%include "src/faster_cargo_plane.asm"
%include "src/single_proc_affinity.asm"
%include "src/limit_cpu_usage.asm"
%include "src/themeclass_play_song_rate_limit.asm"
%include "src/balance_patch.asm"

