
cextern EarlyIniLoad

gbool UseBalancePatch, false

hack 0x004DACD1 ; load ini setting
    call EarlyIniLoad
    mov eax, 0x0FF
    jmp hackend


hack 0x00419A3D ; Weapons Factory: Health increased from 400 to 480.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 240
    jmp hackend
    
.noBalance:
    push 200
    jmp hackend 
    
    
hack 0x00419CC4, 0x00419CCB ; Construction Yard: sight radius increased from 3 to 6.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 6
    jmp .out
     
.noBalance:
    push 3

.out:
    push 0x190
    jmp hackend 
    
    
hack 0x0044E539, 0x0044E53F ; Rocket Soldier: Health has been increased from 25 to 50.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 50
    jmp .out
     
.noBalance:
    push 25

.out:
    push 3
    push 3
    jmp hackend 
    
    
hack 0x0044E5FA ; Chem Warrior: Tech prerequisite has been changed to Communications Center (radar) to improve accessibility
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 0x10
    jmp hackend
    
.noBalance:
    push 0x200000
    jmp hackend 

    
hack 0x004B6921, 0x004B6928 ; Visceroid: it has been fully disarmed
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 0xFF
    jmp .out
     
.noBalance:
    push 7

.out:
    push 0x3FF
    jmp hackend 
    
    
hack 0x004B6935 ; Visceroid: Health has been lowered from 150 to 1
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 1
    jmp hackend
    
.noBalance:
    push 150
    jmp hackend 
    
    
hack 0x004B6962, 0x004B6968 ; Visceroid: its ability to crush infantry removed, and in turn, been made crushable itself.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 0
    push 1
    jmp .out
     
.noBalance:
    push 1
    push 0

.out:
    push 0
    jmp hackend 
    
    
hack 0x004B6A26 ; Stealth Tank: cost has been reduced from 900 to 700.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 700
    jmp hackend
    
.noBalance:
    push 900
    jmp hackend 
    

hack 0x004B6D6A, 0x004B6D70 ; Artillery: Turn rate has been increased from 2 to 5
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 5
    jmp .out
     
.noBalance:
    push 2

.out:
    push 0x0C
    push 1
    jmp hackend 
     
    
hack 0x004B6E7E, 0x004B6E85 ; MCV: Its sight radius has been increased from 2 to 4.
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 4
    jmp .out
     
.noBalance:
    push 2

.out:
    push 0x258
    jmp hackend 
     
    
hack 0x004B7061 ; MLRS: now a GDI-only unit
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 0x3F9
    jmp hackend
    
.noBalance:
    push 0x3FB
    jmp hackend 
    
    
hack 0x004B7073, 0x004B7079 ; MLRS: health increased from 100 to 120
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 120
    jmp .out
     
.noBalance:
    push 100

.out:
    push -1
    push 0
    jmp hackend 
    
    
hack 0x004B70AB ; MLRS: only requires a Communications Center (radar) to access now. 
    cmp byte[UseBalancePatch], 1
    jnz .noBalance
    
    push 0x10
    jmp hackend
    
.noBalance:
    push 0x200000
    jmp hackend 
