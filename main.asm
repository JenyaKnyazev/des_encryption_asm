option casemap:none
ExitProcess proto
Sleep proto
GetStdHandle proto
WriteConsoleA proto
ReadConsoleA proto

.data
input_handle QWORD ?
output_handle QWORD ?
chars_written QWORD ?
user_string DB 1025 DUP(0)
result DB 1025 DUP(0)
hex_string DB 2050 DUP(0)
chunk DB 8 DUP(0)
chunk2 DB 8 DUP(0)
key_string DB 10 DUP(?)
keys DB 96 DUP(?)
key_48_bit DB 6 DUP(?)
key_56_bit DB 7 DUP(?)
filler_temp DB 0
bit DB ?
right DB 4 DUP(?)
right_save DB 4 DUP(?)
right_permuted DB 4 DUP(?)
left DB 4 DUP(?)
filler_temp3 DB 2 DUP(?)
expand_right DB 6 DUP(?)
filler_temp2 DB 2 DUP(?)
table1  DB	58,	50,	42,	34,	26,	18,	10,	2,	60,	52,	44,	36,	28,	20,	12,	4
		DB	62,	54,	46,	38,	30,	22,	14,	6,	64,	56,	48,	40,	32,	24,	16,	8
		DB	57,	49,	41,	33,	25,	17,	9,	1,	59,	51,	43,	35,	27,	19,	11,	3
		DB	61,	53,	45,	37,	29,	21,	13,	5,	63,	55,	47,	39,	31,	23,	15,	7


table2 DB		32,	1,	2,	3,	4,	5
	   DB		4,	5,	6,	7,	8,	9
	   DB		8,	9,	10,	11,	12,	13
	   DB		12,	13,	14,	15,	16,	17
	   DB		16,	17,	18,	19,	20,	21
	   DB		20,	21,	22,	23,	24,	25
	   DB		24,	25,	26,	27,	28,	29
	   DB		28,	29,	30,	31,	32,	1

table3  DB	14,	4,	13,	1,	2,	15,	11,	8,	3,	10,	6,	12,	5,	9,	0,	7	
		DB	0,	15,	7,	4,	14,	2,	13,	1,	10,	6,	12,	11,	9,	5,	3,	8	
		DB	4,	1,	14,	8,	13,	6,	2,	11,	15,	12,	9,	7,	3,	10,	5,	0	
		DB	15,	12,	8,	2,	4,	9,	1,	7,	5,	11,	3,	14,	10,	0,	6,	13
	
		DB	15,	1,	8,	14,	6,	11,	3,	4,	9,	7,	2,	13,	12,	0,	5,	10	
		DB	3,	13,	4,	7,	15,	2,	8,	14,	12,	0,	1,	10,	6,	9,	11,	5	
		DB	0,	14,	7,	11,	10,	4,	13,	1,	5,	8,	12,	6,	9,	3,	2,	15	
		DB	13,	8,	10,	1,	3,	15,	4,	2,	11,	6,	7,	12,	0,	5,	14,	9
	
		DB	10,	0,	9,	14,	6,	3,	15,	5,	1,	13,	12,	7,	11,	4,	2,	8	
		DB	13,	7,	0,	9,	3,	4,	6,	10,	2,	8,	5,	14,	12,	11,	15,	1	
		DB	13,	6,	4,	9,	8,	15,	3,	0,	11,	1,	2,	12,	5,	10,	14,	7	
		DB	1,	10,	13,	0,	6,	9,	8,	7,	4,	15,	14,	3,	11,	5,	2,	12
	
		DB	7,	13,	14,	3,	0,	6,	9,	10,	1,	2,	8,	5,	11,	12,	4,	15
		DB	13,	8,	11,	5,	6,	15,	0,	3,	4,	7,	2,	12,	1,	10,	14,	9	
		DB	10,	6,	9,	0,	12,	11,	7,	13,	15,	1,	3,	14,	5,	2,	8,	4	
		DB	3,	15,	0,	6,	10,	1,	13,	8,	9,	4,	5,	11,	12,	7,	2,	14
	
		DB	2,	12,	4,	1,	7,	10,	11,	6,	8,	5,	3,	15,	13,	0,	14,	9
		DB	14,	11,	2,	12,	4,	7,	13,	1,	5,	0,	15,	10,	3,	9,	8,	6	
		DB	4,	2,	1,	11,	10,	13,	7,	8,	15,	9,	12,	5,	6,	3,	0,	14	
		DB	11,	8,	12,	7,	1,	14,	2,	13,	6,	15,	0,	9,	10,	4,	5,	3
	
		DB	12,	1,	10,	15,	9,	2,	6,	8,	0,	13,	3,	4,	14,	7,	5,	11
		DB	10,	15,	4,	2,	7,	12,	9,	5,	6,	1,	13,	14,	0,	11,	3,	8	
		DB	9,	14,	15,	5,	2,	8,	12,	3,	7,	0,	4,	10,	1,	13,	11,	6	
		DB	4,	3,	2,	12,	9,	5,	15,	10,	11,	14,	1,	7,	6,	0,	8,	13
	
		DB	4,	11,	2,	14,	15,	0,	8,	13,	3,	12,	9,	7,	5,	10,	6,	1
		DB	13,	0,	11,	7,	4,	9,	1,	10,	14,	3,	5,	12,	2,	15,	8,	6	
		DB	1,	4,	11,	13,	12,	3,	7,	14,	10,	15,	6,	8,	0,	5,	9,	2	
		DB	6,	11,	13,	8,	1,	4,	10,	7,	9,	5,	0,	15,	14,	2,	3,	12
	
		DB	13,	2,	8,	4,	6,	15,	11,	1,	10,	9,	3,	14,	5,	0,	12,	7
		DB	1,	15,	13,	8,	10,	3,	7,	4,	12,	5,	6,	11,	0,	14,	9,	2
		DB	7,	11,	4,	1,	9,	12,	14,	2,	0,	6,	10,	13,	15,	3,	5,	8	
		DB	2,	1,	14,	7,	4,	10,	8,	13,	15,	12,	9,	0,	3,	5,	6,  11


table4 DB	16,	7,	20,	21,	29,	12,	28,	17
	   DB	1,	15,	23,	26,	5,	18,	31,	10
	   DB	2,	8,	24,	14,	32,	27,	3,	9
	   DB	19,	13,	30,	6,	22,	11,	4,	25





table5 DB       57,	49,	41,	33,	25,	17,	9,	1,	58,	50,	42,	34,	26,	18	
	   DB	    10,	2,	59,	51,	43,	35,	27,	19,	11,	3,	60,	52,	44,	36	
	   DB	    63,	55,	47,	39,	31,	23,	15,	7,	62,	54,	46,	38	,30,22	
	   DB	    14	,6	,61	,53	,45	,37	,29	,21	,13	,5,	28	,20,12,	4

table6 DB		1,	1,	2,	2,	2,	2,	2,	2,	1,	2,	2,	2,	2,	2,	2,	1
	   
table7 DB		14,	17,	11,	24,	1,	5,	3,	28,	15,	6,	21,	10,	23,	19,	12,	4
	   DB		26,	8,	16,	7,	27,	20,	13,	2,	41,	52,	31,	37,	47,	55,	30,	40
	   DB		51,	45,	33,	48,	44,	49,	39,	56,	34,	53,	46,	42,	50,	36,	29,	32

table8  DB	40,	8,	48,	16,	56,	24,	64,	32,	39,	7,	47,	15,	55,	23,	63,	31
		DB	38,	6,	46,	14,	54,	22,	62,	30,	37,	5,	45,	13,	53,	21,	61,	29
		DB	36,	4,	44,	12,	52,	20,	60,	28,	35,	3,	43,	11,	51,	19,	59,	27
		DB	34,	2,	42,	10,	50,	18,	58,	26,	33,	1,	41,	9,	49,	17,	57,	25

string1 DB 10,"DES",10,"1 = encrypt",10,"2 = decrypt",10,"other = exit",10
string2 DB 10,"enter line to encrypt: "
string3 DB 10,"enter line to decrypt: "
string4 DB 10,"enter a key: "
string5 DB 10,"encrypted: "
string6 DB 10,"decrypted: "
string7 DB 10,"Good Bay"
op DB 3 DUP(?)
.code
	main proc
		mov rcx,-10
		call GetStdHandle
		mov input_handle,rax
		mov rcx,-11
		call GetStdHandle
		mov output_handle,rax
		call play
		mov rcx,5000
		call Sleep
		mov rcx,0
		call ExitProcess
	main endp

	input_string proc
		push rbx
		clean_input:
			mov BYTE PTR[rsi],0
			inc rsi
			dec rbx
			jnz clean_input
		pop rbx
		mov rcx,input_handle
		mov rdx,rdi
		mov r8,rbx
		lea r9,chars_written
		push 0
		call ReadConsoleA
		pop rcx
		remove_enter:
			inc rdi
			cmp byte ptr[rdi],0
			jne remove_enter
		dec rdi
		mov byte ptr[rdi],0
		dec rdi
		mov byte ptr[rdi],0
		ret
	input_string endp

	print_string proc
		mov rcx,output_handle
		mov rdx,rsi
		mov r8,rbx
		mov r9,offset chars_written
		push 0h
		call WriteConsoleA
		pop rcx
		ret
	print_string endp

	to_hex proc
		lea rsi,result
		lea rdi,hex_string
		push r15
		run_to_hex1:
			mov bl,[rsi]
			mov cl,4
			shr bl,cl
			mov [rdi],bl
			inc rdi
			mov bl,[rsi]
			and bl,0FH
			mov [rdi],bl
			inc rdi
			inc rsi
			dec r15
			jnz run_to_hex1
		pop r15
		add r15,r15
		lea rdi,hex_string
		run_to_hex2:
			mov bl,[rdi]
			cmp bl,9
			jg letter_to_hex
			add bl,48
			jmp next_to_hex
			letter_to_hex:
			add bl,55
			next_to_hex:
			mov [rdi],bl
			inc rdi
			dec r15
			jnz run_to_hex2
		end_to_hex:
		mov byte ptr[rdi],0
		ret
	to_hex endp

	len_string proc
		xor r15,r15
		run_len_string:
			cmp byte ptr[rsi],0
			je end_len_string
			inc rsi
			inc r15
			jmp run_len_string
		end_len_string:
		ret
	len_string endp

	from_hex proc
		lea rdi,hex_string
		lea rsi,user_string
		run_from_hex1:
			cmp byte ptr[rdi],0
			je end_run_from_hex1
			mov bl,[rdi]
			cmp bl,9
			jg letter_from_hex
			sub bl,48
			jmp next_from_hex
			letter_from_hex:
			sub bl,55
			next_from_hex:
			mov [rdi],bl
			inc rdi
			jmp run_from_hex1
		end_run_from_hex1:
		lea rdi,hex_string
		push r15
		run_from_hex2:
			mov bl,[rdi]
			mov cl,4
			shl bl,cl
			inc rdi
			or bl,[rdi]
			mov [rsi],bl
			inc rdi
			inc rsi
			dec r15
			jnz run_from_hex2
		end_run_from_hex2:
		pop r15
		sub r15,1025
		neg r15
		run_clean_from_hex:
			mov byte ptr[rsi],0
			inc rsi
			dec r15
			jnz run_clean_from_hex
		ret
	from_hex endp

	play proc
		run_play:
			mov rbx,42
			lea rsi,string1
			call print_string
			mov rbx,3
			lea rsi,op
			lea rdi,op
			call input_string
			cmp op,'1'
			jne next_play
			lea rsi,string2
			mov rbx,24
			call print_string
			mov rbx,1025
			lea rsi,user_string
			lea rdi,user_string
			call input_string
			lea rsi,string4
			mov rbx,14
			call print_string
			lea rsi,key_string
			lea rdi,key_string
			mov rbx,10
			call input_string
			lea rsi,string5
			mov rbx,12
			call print_string
			call generate_keys
			call encrypt_des
			lea rsi,user_string
			call len_string
			call to_hex
			lea rsi,hex_string
			mov rbx,2050
			call print_string
			jmp run_play
			next_play:
			cmp op,'2'
			jne end_play
			lea rsi,string3
			mov rbx,24
			call print_string
			mov rbx,2050
			lea rsi,hex_string
			lea rdi,hex_string
			call input_string
			lea rsi,string4
			mov rbx,14
			call print_string
			lea rsi,key_string
			lea rdi,key_string
			mov rbx,10
			call input_string
			lea rsi,string6
			mov rbx,12
			call print_string
			lea rsi,hex_string
			call len_string
			call from_hex
			call generate_keys
			call reverse_keys
			call decrypt_des
			lea rsi,result
			mov rbx,1025
			call print_string
			jmp run_play
		end_play:
		lea rsi,string7
		mov rbx,9
		call print_string
		ret
	play endp

	reverse_keys proc
		lea rsi,keys
		lea rdi,keys
		add rsi,95
		add rdi,5
		run_reverse1:
			mov bl,6
			run_reverse2:
				mov al,[rsi]
				mov ah,[rdi]
				mov [rsi],ah
				mov [rdi],al
				dec rdi
				dec rsi
				dec bl
				jnz run_reverse2
			add rdi,12
			cmp rdi,rsi
			jl run_reverse1
		ret
	reverse_keys endp
	get_bit_from_key proc
		mov cl,[rsi]
		dec cl
		mov r13,1
		shl r13,cl
		and r13,[rdi]
		mov cl,[rsi]
		dec cl
		shr r13,cl
		mov bit,r13b
		ret
	get_bit_from_key endp

	permute_key_table5 proc
		lea rsi,key_56_bit
		mov rbx,7
		clean_key_56:
			mov QWORD PTR[rsi],0
			add rsi,8
			dec rbx
			jnz clean_key_56
		lea rsi,table5
		mov rdi,offset key_string
		lea rbx,key_56_bit
		add rbx,6
		mov r11b,0
		run_table5_2:
			mov r12b,0
			run_table5_1:
				call get_bit_from_key
				mov al,bit
				mov cl,r12b
				shl al,cl
				or [rbx],al
				inc rsi
				inc r12b
				cmp r12b,8
				jl run_table5_1
			dec rbx
			inc r11b
			cmp r11b,7
			jl run_table5_2
		ret
	permute_key_table5 endp

	permute_key_table7 proc
		push rsi
		push rdi
		push rbx
		lea rsi,key_48_bit
		mov rbx,6
		clean_key_48:
			mov QWORD PTR[rsi],0
			add rsi,8
			dec rbx
			jnz clean_key_48
		lea rdi,filler_temp
		mov BYTE PTR[rdi],0
		lea rsi,table7
		lea rbx,key_48_bit
		add rbx,5
		lea rdi,key_56_bit
		mov r11b,0
		run_table7_1:
			mov r12b,0
			run_table7_2:
				mov cl,[rsi]
				add cl,7
				mov r13,1
				shl r13,cl
				and r13,[rdi]
				mov cl,[rsi]
				add cl,7
				shr r13,cl
				mov cl,r12b
				shl r13b,cl
				or [rbx],r13b
				inc rsi
				inc r12b
				cmp r12b,8
				jl run_table7_2
			inc r11b
			dec rbx
			cmp r11b,6
			jl run_table7_1
		pop rbx
		pop rdi
		pop rsi
		ret
	permute_key_table7 endp

	rotate_key_56_table6 proc
		push rdi
		push r15
		push rbx
		mov rdi,offset key_56_bit
		mov r15d,[rdi]
		and r15d,0FFFFFFF0H
		rol r15d,1
		mov ebx,0
		mov bl,r15b
		and bl,1
		mov cl,4
		shl bl,cl
		and r15d,0FFFFFFF0H
		or r15d,ebx
		add rdi,3
		mov r14d,[rdi]
		and r14d,00FFFFFFFH
		mov ebx,8000000H
		and ebx,r14d
		shl r14d,1
		and r14d,00FFFFFFEH
		mov cl,27
		shr ebx,cl
		or r14d,ebx
		mov ebx,r14d
		mov cl,24
		shr ebx,cl
		or r15d,ebx
		mov cl,8
		shl r14d,cl
		mov rdi,offset key_56_bit
		mov [rdi],r15d
		add rdi,4
		mov [rdi],r14d
		pop rbx
		pop r15
		pop rdi
		ret
	rotate_key_56_table6 endp

	generate_keys proc
		call permute_key_table5
		mov r15,16
		lea rsi,table6
		lea rdi,keys
		lea rbx,key_48_bit
		run_generate_keys:
			call rotate_key_56_table6
			mov cl,[rsi]
			dec cl
			jz next_generate_keys
			call rotate_key_56_table6
			next_generate_keys:
			call permute_key_table7
			mov eax,[rbx]
			mov [rdi],eax
			add rdi,4
			add rbx,4
			mov ax,[rbx]
			mov [rdi],ax
			sub rbx,4
			add rdi,2
			inc rsi
			dec r15
			jnz run_generate_keys
		ret
	generate_keys endp

	E_expansion proc
		lea rsi,expand_right
		xor rax,rax
		mov [rsi],rax
		lea rsi,table2
		lea rdi,expand_right
		add rdi,5
		lea rbx,right
		mov r15b,0
		run_expansion_1:
			mov r14b,0
			run_expansion_2:
				mov r13d,[rbx]
				mov cl,[rsi]
				dec cl
				mov r12d,1
				shl r12d,cl
				and r12d,r13d
				mov cl,[rsi]
				dec cl
				shr r12d,cl
				mov cl,r14b
				shl r12d,cl
				or [rdi],r12b
				inc r14b
				cmp r14b,8
				jl run_expansion_2
			dec rdi
			inc r15b
			cmp r14b,6
			jl run_expansion_1
		ret
	E_expansion endp

	P_permutation proc
		lea rdi,right_permuted
		xor eax,eax
		mov [rdi],eax
		add rdi,3
		lea rsi,table4
		lea rbx,right
		mov r15b,0
		run_P_1:
			mov r14b,0
			run_P_2:
				mov cl,[rsi]
				dec cl
				mov r12d,1
				shl r12d,cl
				mov r11d,[rbx]
				and r12d,r11d
				mov cl,[rsi]
				dec cl
				shr r12d,cl
				mov cl,r14b
				shl r12d,cl
				or [rdi],r12d
				dec rdi
				inc rsi
				inc r14b
				cmp r14b,8
				jl run_P_2
			inc r15b
			cmp r15b,4
			jl run_P_1
		ret
	P_permutation endp

	S_subtitution proc
		lea rbx,filler_temp3
		mov r15,[rbx]
		mov r12b,8
		xor r11d,r11d
		mov DWORD PTR[right],r11d
		xor bl,bl
		mov rsi,offset table3
		add rsi,336
		xor di,di
		run_S:
			mov r14,21H
			mov cl,bl
			shl r14,cl
			and r14,r15
			mov r13,1EH
			mov cl,bl
			shl r13,cl
			and r13,r15
			mov rax,r14
			xor rdx,rdx
			mov ecx,14
			mul ecx
			add r13,rax
			add rsi,r13
			xor r11,r11
			mov r11b,[rsi]
			mov cx,di
			shl r11,cl
			or DWORD PTR[right],r11d
			sub rsi,r13
			sub rsi,48
			add di,4
			add bl,6
			dec r12b
			jnz run_S
		ret
	S_subtitution endp

	Feistel_function proc
		mov r15b,16
		lea rsi,keys
		run_feistel:
			mov eax,DWORD PTR[right]
			mov DWORD PTR[right_save],eax
			push r15
			push rsi
			call E_expansion
			pop rsi
			mov eax,DWORD PTR[right]
			xor eax,[rsi]
			mov DWORD PTR[right],eax
			push rsi
			call S_subtitution
			call P_permutation
			pop rsi
			pop r15
			mov eax,DWORD PTR[right]
			xor eax,DWORD PTR[left]
			mov DWORD PTR[right],eax
			mov eax,DWORD PTR[right_save]
			mov DWORD PTR[left],eax
			add rsi,6
			dec r15b
			jnz run_feistel
		ret
	Feistel_function endp

	IP_permutation proc
		lea rsi,table1
		xor rax,rax
		mov QWORD PTR[chunk],rax
		mov r15,[rdi]
		mov r14b,0
		xor r13,r13
		run_IP:
			mov cl,[rsi]
			dec cl
			mov r12,1
			shl r12,cl
			and r12,r15
			mov cl,[rsi]
			dec cl
			shr r12,cl
			mov cl,r14b
			shl r12,cl
			or r13,r12
			inc rsi
			inc r14b
			cmp r14b,64
			jl run_IP
		mov QWORD PTR[chunk],r13
		ret
	IP_permutation endp

	FP_permutation proc
		mov r15,QWORD PTR[chunk]
		xor rax,rax
		mov QWORD PTR[chunk],rax
		lea rsi,table8
		mov r14b,0
		xor r13,r13
		run_FP:
			mov cl,[rsi]
			dec cl
			mov r12,1
			shl r12,cl
			and r12,r15
			mov cl,[rsi]
			dec cl
			shr r12,cl
			mov cl,r14b
			shl r12,cl
			or r13,r12
			inc rsi
			inc r14b
			cmp r14b,64
			jl run_FP
		mov QWORD PTR[chunk],r13
		ret
	FP_permutation endp

	encrypt_des proc
		lea rdi,user_string
		lea rsi,result
		run_des:
			mov eax,[rdi]
			add rdi,4
			mov ebx,[rdi]
			mov DWORD PTR[left],eax
			mov DWORD PTR[right],ebx
			sub rdi,4
			push rsi
			push rdi
			call IP_permutation
			call Feistel_function
			mov ebx,DWORD PTR[right]
			mov cl,32
			shl rbx,cl
			or ebx,DWORD PTR[left]
			mov QWORD PTR [chunk],rbx
			call FP_permutation
			pop rdi
			pop rsi
			mov rax,QWORD PTR[chunk]
			mov [rsi],rax
			add rsi,8
			add rdi,8
			cmp BYTE PTR[rdi],0
			jne run_des
		ret
	encrypt_des endp

	decrypt_des proc
		lea rdi,user_string
		lea rsi,result
		run_des:
			mov eax,[rdi]
			add rdi,4
			mov ebx,[rdi]
			mov DWORD PTR[left],ebx
			mov DWORD PTR[right],eax
			sub rdi,4
			push rsi
			push rdi
			call IP_permutation
			call Feistel_function
			mov ebx,DWORD PTR[left]
			mov cl,32
			shl rbx,cl
			or ebx,DWORD PTR[right]
			mov QWORD PTR [chunk],rbx
			call FP_permutation
			pop rdi
			pop rsi
			mov rax,QWORD PTR[chunk]
			mov [rsi],rax
			add rsi,8
			add rdi,8
			cmp BYTE PTR[rdi],0
			jne run_des
		ret
	decrypt_des endp
end