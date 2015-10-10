extern void gdt_install();
extern void idt_install();

unsigned int i=0, j=0;
char * vidptr = (char*)0xb8000;	//video memory begins here.
int linecount=0;
void clear ()
{
	i=0;
	/* This loop clears the screen*/
	while (i < 80*25*2)
	{
		// insert blank character

		vidptr[i] = ' ';
		// attribute-byte : red on black screen
		vidptr[i+1]=0x04;
		i=i+2;	
	}
	i=0;
}

void printf (const char* words)
{
	//int linecount=0;
	while (words[j]!='\0')
	{
		if (words[j]=='\n')
		{
			linecount++;
			i=160*linecount;
			j++;
		}
		/* the character's ascii*/
		vidptr[i]=words[j];
		/* attribute-byte: give character black bg and light grey fg*/
		vidptr[i+1]=0x04;
		++j;
		i=i+2;
	}
	j=0;
}

void kernel_main()
{
	gdt_install();	
	/*const char *str = "Hello World \nWelcome to My First Kernel\n-Elix";
	const char *str2 = "\nThis is a new function call \nI love this!!";	
	
	clear();
	printf (str);
//	clear();
	printf (str2);
	
	int check[10];
	int i=0;
	for (i=0;i<10; i++)
	check[i]=i;		
	*/
	idt_install();
	return;
}
