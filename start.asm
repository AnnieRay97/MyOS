MBALIGN	equ 1<<0
MEMINFO	equ 1<<1
FLAGS	equ MBALIGN | MEMINFO
MAGIC 	equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

section .bootstrap_stack, nobits
align 4
stack_bottom:
resb 16384
stack_top:


section .text
global _start
_start:
	mov esp, stack_top
	extern kernel_main
	cli
	call kernel_main

	cli
	jmp $

global gdt_flush
extern gp
gdt_flush:
	cli
	lgdt[gp]
	
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov eax, cr0
	or al, 1
	mov cr0, eax
	jmp 0x08:flush2
flush2:
	ret
