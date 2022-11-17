%include "macros/patch.inc"
%include "macros/datatypes.inc"

cextern int_Width
cextern int_Height

hack 0x004DBB39, 0x004DBB3F ;_Mouse_Shadow_Buffer
	cmp dword eax, [int_Width]
	jg .Exit
	cmp dword ebx, [int_Height]
	jg .Exit
	mov [ebp-4h], eax ; y
	mov [ebp-8h], ebx ; x
	jmp hackend
	
.Exit:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	leave
	retn


; _Mouse_Shadow_Buffer (old name in the db: _ASM_Set_Mouse_Cursor)
; this patch is only for debugging to find out if there is a problem with "rep movsb" on some intel cpus
; http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/3rd-gen-core-desktop-specification-update.pdf
hack 0x004DBC08
    add eax, dword[ebp-4]
    mov edi, dword[edi]
    
    test edi, edi
    jz 0x004DBC59
    
    jmp hackend
