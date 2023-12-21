.data
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	endl: .asciz "\n"
	m: .space 4
	n: .space 4
	decm: .space 4
	decn: .space 4
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

// citire pentru m - linii, n - coloane, p - nr celule vii, k - nr evolutii
	push $m
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
// dupa citire pastram m + 2 - 1 in decm pt a putea parcurge matricea fara bordura
	incl m
	movl m, %eax
	movl %eax, decm
	incl m
		
	push $n
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
// analog si pt n
	incl n
	movl n, %eax
	movl %eax, decn
	incl n
	
	push $p
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
	je citire_k
	
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
	
// incrementam cei doi indexi abia cititi, pt a plasa 1 la adresa potrivita
	incl lineIndex
	incl columnIndex
	
// vom modifica matrice[lineIndex][columnIndex] pt ambele matrici
	movl $0, %edx
	movl lineIndex, %eax
	mull m
	addl columnIndex, %eax
	movl $1, (%edi, %eax, 4)
	movl $1, (%esi, %eax, 4)
	
	incl count
	jmp citire_celule


citire_k:
	push $k
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	jmp afisare_matrice

for_k:
	movl k, %ecx
	cmpl $0, %ecx
	je afisare_matrice
	
	movl $1, lineIndex
	parcurgere_linii:
		movl lineIndex, %ecx 
		cmp %ecx, decm
		je cont_for_k
		
		movl $1, columnIndex
		parcurgere_coloane:
			movl columnIndex, %ecx
			cmp %ecx, decn
			je cont_parcurgere_linii
			
			// parcurgere vecini pentru fiecare element
			// modificam elementul in copy_matrice
			
			incl columnIndex
			jmp parcurgere_coloane
			
	cont_parcurgere_linii:
		incl lineIndex
		jmp parcurgere_linii
		
cont_for_k:
	// trecem din copie in matrice
	decl k
	jmp for_k
	






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
	xor %ebx, %ebx
	int $0x80
