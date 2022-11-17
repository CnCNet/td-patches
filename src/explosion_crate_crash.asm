%include "macros/patch.inc"
%include "macros/datatypes.inc"

; testing code to see if crash 004386b1 still happens when certain crates are replaced with case03_ion_blast

@LJMP 0x00428612, 0x004283C2 ; replace case0A_baddie_fireball with case03_ion_blast
@LJMP 0x00428588, 0x004283C2 ; replace case09_baddie_explode with case03_ion_blast