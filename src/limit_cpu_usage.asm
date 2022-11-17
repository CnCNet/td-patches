;Inserting a sleep 1 into the Call_Back() function, this is a really cheesy way. Check red alert patches for a better solution

@CLEAR 0x0042C478, 0x90, 0x0042C47E
@LJMP 0x0042C478, SleepHack

section .text
SleepHack:
    push 1
    call 0x004E768A ; sleep
    
    mov ah, byte[0x005405C9]
    jmp 0x0042C47E
