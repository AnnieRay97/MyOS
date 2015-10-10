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
	
	global idt_load
extern idtp
idt_load:
	lidt[idtp]
	ret

;Service Routines (ISRs)
global _isr0
_isr0:
	cli
	push byte 0

	push byte 0
	jmp isr_common_stub

global _isr1
_isr0:
	cli
	push byte 0

	push byte 1
	jmp isr_common_stub

global _isr2
_isr0:
	cli
	push byte 0

	push byte 2
	jmp isr_common_stub

global _isr3
_isr0:
	cli
	push byte 0

	push byte 3
	jmp isr_common_stub

global _isr4
_isr0:
	cli
	push byte 0

	push byte 4
	jmp isr_common_stub

global _isr5
_isr0:
	cli
	push byte 0

	push byte 5
	jmp isr_common_stub

global _isr6
_isr0:
	cli
	push byte 0

	push byte 6
	jmp isr_common_stub

global _isr7
_isr0:
	cli
	push byte 0

	push byte 7
	jmp isr_common_stub

global _isr8
_isr0:
	cli
	push byte 8	; Note that we don't push a second value on the stack in this on!
			; It pushes one already! (Since this produces an error code!)
	jmp isr_common_stub

global _isr9
_isr0:
	cli
	push byte 0

	push byte 9
	jmp isr_common_stub

global _isr10
_isr0:
	cli
	push byte 10
	jmp isr_common_stub

global _isr11
_isr0:
	cli
	push byte 11
	jmp isr_common_stub

global _isr12
_isr0:
	cli
	push byte 12
	jmp isr_common_stub

global _isr13
_isr0:
	cli
	push byte 13
	jmp isr_common_stub

global _isr14
_isr0:
	cli
	push byte 14
	jmp isr_common_stub

global _isr15
_isr0:
	cli
	push byte 0

	push byte 15
	jmp isr_common_stub

global _isr16
_isr0:
	cli
	push byte 0

	push byte 16
	jmp isr_common_stub

global _isr17
_isr0:
	cli
	push byte 0

	push byte 17
	jmp isr_common_stub

global _isr18
_isr0:
	cli
	push byte 0

	push byte 18
	jmp isr_common_stub

global _isr19
_isr0:
	cli
	push byte 0

	push byte 19
	jmp isr_common_stub

global _isr20
_isr0:
	cli
	push byte 0

	push byte 20
	jmp isr_common_stub

global _isr21
_isr0:
	cli
	push byte 0

	push byte 21
	jmp isr_common_stub

global _isr22
_isr0:
	cli
	push byte 0

	push byte 22
	jmp isr_common_stub

global _isr23
_isr0:
	cli
	push byte 0

	push byte 23
	jmp isr_common_stub

global _isr24
_isr0:
	cli
	push byte 0

	push byte 24
	jmp isr_common_stub

global _isr25
_isr0:
	cli
	push byte 0

	push byte 25
	jmp isr_common_stub

global _isr26
_isr0:
	cli
	push byte 0

	push byte 26
	jmp isr_common_stub

global _isr27
_isr0:
	cli
	push byte 0

	push byte 27
	jmp isr_common_stub

global _isr28
_isr0:
	cli
	push byte 0

	push byte 28
	jmp isr_common_stub

global _isr29
_isr0:
	cli
	push byte 0

	push byte 29
	jmp isr_common_stub

global _isr30
_isr0:
	cli
	push byte 0

	push byte 30
	jmp isr_common_stub

global _isr31
_isr0:
	cli
	push byte 0

	push byte 31
	jmp isr_common_stub
