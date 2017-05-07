/* Default linker script, for normal executables */
OUTPUT_FORMAT("elf32-sisa","elf32-sisa","elf32-sisa")
OUTPUT_ARCH(sisa:1)
MEMORY
{
	rom (rx) : ORIGIN = 0, LENGTH = 64K
	ram (rw!x) : ORIGIN = 0x80000000, LENGTH = 64K
}
SECTIONS
{                         
  .text : {
  	*(.text)
  	*(.rodata) }  > rom
  .data : {
  	*(.data)
  	*(.bss) }  > ram
}
