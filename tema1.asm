%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
	expr: resb MAX_INPUT_SIZE

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
        

	GET_STRING expr, MAX_INPUT_SIZE

	; your code goes here
        mov esi, expr ;save string in esi
        xor ebx,ebx 

readcharacter: ;read string character by character

        mov bl, byte [esi] ;save first character(byte) in bl
        cmp bl, '0'  ;verify if character is from '0' to '9' 
        jg number
        je number
        cmp bl, '+'
        je plus 
        cmp bl, '-'
        je verify_minus
        cmp bl, '*'
        je multiply
        cmp bl, '/'
        je divide
        cmp bl, 0x00
        je final
        inc esi
        jmp readcharacter   
        

verify_minus: ;verify if '-' is an operator
        
        inc esi
        mov bl, byte [esi]
        cmp bl, ' ' 
        je minus ;if next character is ' ',  
        cmp bl, 0x00
        je minus
        jmp number_neg   


number: ;string to integer
        xor eax, eax
digit:
        sub bl, '0'; char to digit
        imul eax, 10
        add eax, ebx
        inc esi
        mov bl, byte [esi]
        cmp bl, ' '
        je push_stack
        jmp digit
push_stack:
        push eax ;push operand
        xor eax, eax
        jmp readcharacter
        

number_neg: ;string to integer - signed
        xor eax, eax
digit_neg:
        sub bl, '0'; char to digit
        imul eax, 10
        add eax, ebx
        inc esi
        mov bl, byte [esi]
        cmp bl, ' '
        je push_stackNeg
        cmp bl, 0x00
        je push_stackNeg
        jmp digit_neg

push_stackNeg:
        neg eax
        push eax
        xor eax, eax
        jmp readcharacter
        

plus: 
        pop eax
        pop ecx
        add eax, ecx
        push eax
        xor eax, eax
        xor ecx, ecx
        inc esi
        jmp readcharacter
       

multiply: 
        
        pop eax
        pop ecx
        imul eax,ecx
        push eax
        xor eax, eax
        xor ecx, ecx
        inc esi
        jmp readcharacter
        

divide:

        pop ecx
        pop eax
        cdq 
        idiv ecx
        push eax
        xor eax, eax
        xor ecx, ecx
        inc esi
        jmp readcharacter


minus:

        pop ecx
        pop eax
        sub eax, ecx
        push eax
        xor ecx, ecx
        xor eax, eax
        inc esi
        jmp readcharacter
        

final:  
    pop eax ;extract result from stack
    PRINT_DEC 4, eax ;print result
    NEWLINE
        
    xor eax, eax ;set eax to 0
    xor ebx, ebx ;set ebx to 0
    xor ecx, ecx ;set ecx to 0
        
	pop ebp
	ret
