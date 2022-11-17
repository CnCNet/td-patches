-include config.mk

INPUT       = cnc95.obj
OUTPUT      = game.exe
LDS         = cnc95.lds
IMPORTS     = 0x1B0000 5157
LDFLAGS     = --section-alignment=0x10000 --subsystem=windows --enable-stdcall-fixup
NFLAGS      = -f elf -Iinc/
CFLAGS      = -std=c99 -Iinc/

OBJS        = res/res.o \
              sym.o \
              watcall.o \
              src/explosion_crate_crash.o \
              src/crc32.o \
              src/crc32_fileclass.o \
              src/mouse_fixes.o \
              src/nethack.o \
              src/destroy_window.o \
              src/balance_patch-func.o \
              src/main.o

PETOOL     ?= petool
STRIP      ?= strip
NASM       ?= nasm
WINDRES    ?= windres

all: $(OUTPUT)


$(INPUT):
	$(PETOOL) pe2obj cnc95.dat $(INPUT)

rsrc.o: $(INPUT)
	$(PETOOL) re2obj $(INPUT) $@

%.o: %.asm
	$(NASM) $(NFLAGS) -o $@ $<
    
%.o: %.rc
	$(WINDRES) $(WINDRES_FLAGS) $< $@

$(OUTPUT): $(LDS) $(INPUT) $(OBJS)
	$(LD) $(LDFLAGS) -T $(LDS) -o $@ $(OBJS)
ifneq (,$(IMPORTS))
	$(PETOOL) setdd $@ 1 $(IMPORTS) || ($(RM) $@ && exit 1)
endif
	$(PETOOL) patch $@ || ($(RM) $@ && exit 1)
	$(STRIP) -R .patch $@ || ($(RM) $@ && exit 1)
	$(PETOOL) dump $@

clean:
	$(RM) $(OUTPUT) $(INPUT) $(OBJS)
