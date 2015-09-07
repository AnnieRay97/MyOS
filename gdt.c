//#include <system.h>

/* Defines a GDT entry. We say packed because it prevents the compiler from doing things that it thinks is best: Prevent compiler "optimization" by packing */

struct gdt_entry
{
	unsigned short limit_low;
	unsigned short base_low;
	unsigned char base_middle;
	unsigned char access;
	unsigned char granularity;
	unsigned char base_high;
} __attribute__((packed));

/* Special pointer which includes the limit: The max bytes taken up by the GDT, minus 1. Again this NEEDS to be packed */

struct gdt_ptr
{
	unsigned short limit;
	unsigned int base;
}__attribute__((packed));

/*Our GDT, with 3 entries, and finally our special GDT pointer*/

struct gdt_entry gdt[3];
struct gdt_ptr gp;

/* This will be a function in start.asm. We use this to properly reload the new segment registers. */

extern void gdt_flush() __asm__("gdt_flush");
/* Set up a descriptor in the Global Descriptor Table*/

void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran)
{
	/* Setup the descriptor base address*/
	gdt[num].base_low = (base & 0xFFFF);
	gdt[num].base_middle = (base >> 16) & 0xFF;
	gdt[num].base_high = (base >> 24) & 0xFF;

	/* Setup the descriptor base limits*/
	gdt[num].limit_low = (limit & 0xFFFF);
	gdt[num].granularity = ((limit >> 16) & 0x0F);

	/* Finally, setup the granularity and access flags*/
	gdt[num].granularity = (gran & 0x0F);
	gdt[num].access = access;
}

/* Should be called by main. This will setup special GDT pointer, set up the first 3 entries in our GDT, and then finally call gdt_flush() in our assembler file in order to tell the processor where the new GDT is and update the new segment registers*/

void gdt_install()
{
	/* Setup the GDT pointer and limt*/

	gp.limit = (sizeof(struct gdt_entry)*3) - 1;
	gp.base = (unsigned int) &gdt[0];

	/* Our  NULL descriptor*/
	gdt_set_gate(0,0,0,0,0);

	/* The second entry is our Code Segment. The base address is 0, the limit is 4GBytes, it uses 4KBytes granularity, uses 32-bit opcodes, and is a Code Segment Descriptor. Please check the table in order to see exactly what each value means*/

	gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0x0F);

	/* The third entry is our Data Segment. It's EXACTLY the same as our Code segment, but the Descriptor type in this entry's access byte says it is a data segment*/ 

	gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0x0F);

	/* Flush out the old GDT and install the new changes!*/

	gdt_flush();
}
