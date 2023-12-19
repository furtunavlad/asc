.data
	formatScanf: .asciz "%d"
	m: .space 4
	n: .space 4
	p: .space 4
	
.text

.global main

main:
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
	
et_exit:
	movl $1, %eax
	movl $1, %ebx
	int $0x80
