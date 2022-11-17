/* GNU ld linker script for cnc95.dat */
start = 0x4D9C94;
ENTRY(start);
SECTIONS
{
    .text             0x410000 : { cnc95.dat(.text); }
    .data             0x4F0000 : { cnc95.dat(.data); }
    /DISCARD/                  : { cnc95.dat(.var); }
    .var              0x530000 : { . = . + 0x73000; }
    .idata            0x5B0000 : { cnc95.dat(.idata); }
    .hp_text          0x5C0000 : { cnc95.dat(.hp_text); }
    .hp_data          0x640000 : { cnc95.dat(.hp_data); }
    /DISCARD/                  : { cnc95.dat(.hp_var); }
    .hp_var           0x6C0000 : { . = . + 0x80000; }
    /DISCARD/                  : { cnc95.dat(.rsrc); }

    /DISCARD/                  : { *(.drectve); }
    /DISCARD/                  : { *(.rdata$zzz) }
    .p_text     ALIGN(0x10000) : { *(.text); }
    .p_rdata    ALIGN(0x10000) : { *(.rdata); }
    .p_data     ALIGN(0x10000) : { *(.data); }
    .p_bss      ALIGN(0x10000) : { *(.bss) *(COMMON); }
    .rsrc       ALIGN(0x10000) : { *(.rsrc); }

    .patch      ALIGN(0x10000) : { *(.patch) }
}
