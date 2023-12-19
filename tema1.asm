.data
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	endl: .asciz "\n"
	m: .space 4
	n: .space 4
	lineIndex: .space 4
	columnIndex: .space 4
	p: .space 4
	k: .space 4
	count: .zero 4
	matrice: .zero 1600
	copy_matrice: .zero 1600
	
.text

.global main

main:

//citire pentru m - linii, n - coloane, p - nr celule vii, k - nr evolutii
	push $m
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	push $n
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	push $p
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	push $k
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	// incarcam matricile in edi si esi
	lea matrice, %edi
	lea copy_matrice, %esi

// de p ori citim celulele
citire_celule:
	movl count, %ecx
	cmp %ecx, p
	je afisare_matrice
	
	// daca < p , citim index-ul din stanga apoi cel din dreapta
	push $lineIndex
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	push $columnIndex
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	
	// vom modifica matrice[lineIndex][columnIndex] pt ambele matrici
	movl $0, %edx
	movl lineIndex, %eax
	mull m
	addl columnIndex, %eax
	movl $1, (%edi, %eax, 4)
	movl $1, (%esi, %eax, 4)
	
	incl count


afisare_matrice:
	movl $0, lineIndex

for_lines:
	movl lineIndex, %ecx 
	cmp %ecx, m
	je et_exit

	movl $0, columnIndex
	for_columns:
		movl columnIndex, %ecx
		cmp %ecx, n
		je cont_for_lines


	movl lineIndex, %eax
	
	mull m
	
	addl columnIndex, %eax

	movl (%edi, %eax, 4), %ebx

	pushl %ebx
	push $formatPrintf
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
	mov $endl, %ecx
	mov $2, %edx
	int $0x80

	addl $1, lineIndex
	jmp for_lines

et_exit:
	movl $1, %eax
	movl $1, %ebx
	int $0x80
