; Declare constants used for creating a multiboot header.
MBALIGN	equ 1<<0	;align loaded modules on page boundaries
MEMINFO	equ 1<<1	; provide memory map
FLAGS	equ MBALIGN | MEMINFO	;this is the Multiboot 'flag' field
MAGIC   equ 0x1BADB002	; 'magicnumber' lets bootloader find header 
CHECKSUM	equ	-(MAGIC + FLAGS)	; checksum of above, to prove we are multiboot

; Declare a header as in the Multiboot Standard. We put this into a special 
; section so we can force the header to be in start of the final program
; You don't need to understand all these details as it is just magic values that
; is documented in the multiboot standard. The bootloader will search for this
; magic sequence and recognize us as a multiboot kernel.
section multiboot
align 4
	dd MAGIC	;align constants in memory
	dd FLAGS	;define double word(4bytes)
	dd CHECKSUM

; Currently the stack pointer register (esp) points at anytihng and using it may; cause massive harm. Instead we'll provide our own  stack. We will allocate
; room for a small temporary stack by  creating a symbol at the bottom of it,
; then allocating 16384 bytes for it. and finally creating a symbol at the top.
section .bootstrap_stack, nobits
align 4
stack_bottom:
resb 16384
stack_top:

; The linker script specifies _start as the entry point to the kernel and the
; bootloader will jump to this position once the kernel has been loaded. It
; doesn't make sense to return from this function as the bootloader is gone
section .text
global _start
_start:
	;Welcome to kernel Mode!
	; To setup stack, we simply set the esp register to point to the top of
	; our stack (as it grows downwards).
	mov esp, stack_top

	; We are now ready to actually execute C code.
	; We'll create a kernel.c file. In that file,
	;we'll create a C entry point called kernel_main and  call it here.
	extern kernel_main
	call kernel_main
	jmp $	
	; In case the function returns, we'll  have to put the computer into an
	; infinite loop. 
	; This will set up our new segment registers.We need to do
	; something special in order to set CS. We do what is called a
	; far jump. A jump that includes a segment as well as an offset.
	; This is declared in C as 'extern void gdt_flush()'

global gdt_flush	; Allows the C Code to link to this
extern gp		; says that 'gp' is in another file
gdt_flush:
	lgdt [gp]	;Load the GDT with our 'gp' which is in another file
	mov ax, 0x10
	mov ds, ax	
	mov es, ax
	mov fs, ax;
	mov gs, ax;
	mov ss, ax;

	cli
	lgdt [gp]
	mov eax, cr0
	or al, 1
	mov cr0, eax

	jmp 0x08:flush2	;0x08 is the offset to our code segment: Far jump!!
flush2:
	ret	; Returns back to the C code!
