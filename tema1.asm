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
	i: .space 4
	j: .space 4
	iVecini: .space 4
	jVecini: .space 4
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
	
	incl count
	jmp citire_celule


citire_k:
	push $k
	push $formatScanf
	call scanf
	pop %ebx
	pop %ebx
	jmp for_k

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
// for ( i = lineIndex - 1; i < lineIndex + 2; i++ )
// 	for ( j = columnIndex - 1; j < columnIndex + 2; j++ )
// lineIndex + 2 si columnIndex + 2 vor fi iVecini respectiv jVecini

			movl lineIndex, %eax
			movl %eax, i
			decl i
			
			movl lineIndex, %eax 
			movl %eax, iVecini
			addl $2, iVecini
			
			movl columnIndex, %eax
			movl %eax, jVecini
			addl $2, jVecini
			
			movl $0, count
			for_lineIndex:				
				movl i, %ecx
				cmp %ecx, iVecini
				je modificare_copy_matrice
				
				movl columnIndex, %eax
				movl %eax, j
				decl j
				
				for_columnIndex:
					movl j, %ecx
					cmp %ecx, jVecini
					je cont_for_lineIndex
					
					movl i, %eax
					mull m
					addl j, %eax
					movl (%edi, %eax, 4), %ebx
					addl %ebx, count
					
					incl j
					jmp for_columnIndex
					
			cont_for_lineIndex:
				incl i
				jmp for_lineIndex					
			
			
			modificare_copy_matrice:
// verificam care este suma vecinilor si modificam elementul in copy_matrice
				
				movl lineIndex, %eax
				mull m
				addl columnIndex, %eax
				movl (%edi, %eax, 4), %ebx
				
				cmpl $1, %ebx
				je celula_in_viata
				jmp celula_moarta
				
				celula_in_viata:
//scadem 1 din nr de vecini
					 decl count
					 movl count, %ecx
					 cmpl $2, %ecx
					 je va_exista
					 cmpl $3, %ecx
					 je va_exista
					 
					 jmp nu_va_exista
					 
				celula_moarta:
					movl count, %ecx
					cmpl $3, %ecx
					je va_exista
					
					jmp nu_va_exista
					
				va_exista:
					movl $1, (%esi, %eax, 4)
					jmp cont_parcurgere_coloane
					
				nu_va_exista:
					movl $0, (%esi, %eax, 4)
					jmp cont_parcurgere_coloane
			
		cont_parcurgere_coloane:
			incl columnIndex
			jmp parcurgere_coloane
			
	cont_parcurgere_linii:
		incl lineIndex
		jmp parcurgere_linii
		
cont_for_k:
	decl k
	
// trecem din copie in matrice
	movl $0, lineIndex
	for_copiere_lines:
		movl lineIndex, %ecx
		cmp %ecx, m
		je for_k
		
		movl $0, columnIndex
		for_copiere_columns:
			movl columnIndex, %ecx
			cmp %ecx, n
			je cont_for_copiere_lines
		
			movl lineIndex, %eax
			mull m
			addl columnIndex, %eax
			movl (%esi, %eax, 4), %ebx
			movl %ebx, (%edi, %eax, 4)
			
			incl columnIndex
			jmp for_copiere_columns

	cont_for_copiere_lines:
		incl lineIndex
		jmp for_copiere_lines


afisare_matrice:
	movl $1, lineIndex

	for_lines:
		movl lineIndex, %ecx 
		cmp %ecx, decm
		je et_exit
	
		movl $1, columnIndex
		for_columns:
			movl columnIndex, %ecx
			cmp %ecx, decn
			je cont_for_lines
	
	
			movl lineIndex, %eax
		
			mull decm
		
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
