// as --32 tema1.asm -o tema1.o
// gcc -m32 tema1.o -o tema1 -no-pie
.data
	lines: .long 3
	columns: .long 4
	lineIndex: .space 4 
	columnIndex: .space 4 
	matrix: .long 10,20,30,40
		.long 50,60,70, 80
		.long 90,15,25, 35
	formatInt: .asciz "%d "
	newLine: .asciz "\n"

.text

.global main

main:
	lea matrix, %edi 
	movl $0, lineIndex

for_lines:
	movl lineIndex, %ecx 
	cmp %ecx, lines
	je et_exit

// incepe al doilea for
	movl $0, columnIndex
	for_columns:
		movl columnIndex, %ecx
		cmp %ecx, columns 
		je cont_for_lines

	// prelucrarea efectiva
	// elementul curent este la
	// lineIndex * columns + columnIndex
	// relativ la adresa de inceput a matricei
	// adica relativ la edi
	// toate elementele sunt .long = au dim. 4 bytes

	movl lineIndex, %eax
	// %eax = lineIndex
	
	mull columns
	// %eax = %eax * columns
	
	addl columnIndex, %eax
	// %eax := %eax (lineIndex * columns) + columnIndex

	movl (%edi, %eax, 4), %ebx

	// %ebx acum este elementul curent din matrice
	// %ebx = matrix[lineIndex] [columnIndex]
	// de la pozitia (lineIndex, columnIndex)
	// %ebx este elementul pe care vreau sa il afisez
	
	pushl %ebx
	push $formatInt
	call printf
	pop %ebx
	pop %ebx

	pushl $0
	call fflush
	pop %ebx

	addl $1, columnIndex
	jmp for_columns

cont_for_lines:
	mov $4, %eax
	mov $1, %ebx
	mov $newLine, %ecx
	mov $2, %edx
	int $0x80

	addl $1, lineIndex
	jmp for_lines

et_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
