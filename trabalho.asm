	.section startup
	jmp main

	.data
multiply10_aux:
	.space 2
multiply10_r1:
	.space 2
multiply10_r2:
	.space 2
val:
	.word	9


ascToUint_r1:
	.space 2
ascToUint_r2:
	.space 2
ascToUint_r3:
	.space 2
ascToUint_r4:
	.space 2
ascToUint_aux:
	.space 2
r5_backup:
	.space 2

	.equ DATA_DIM, 5
data:
	.asciiz "12345"


	.text

main:
	ldi r0, #data
	jmpl ascToUint
	jmp  $

/*	ex: 4.1
	uint16 multiply10( uint16 val ){
		return (val << 3) + (val << 1);
	}
*/
multiply10:
	st r1, multiply10_r1
	st r2, multiply10_r2
	shl r1, r0, #3, 0		; (val << 3)
	shl r2, r0, #1, 0		; (val << 1)
	add r0, r1, r2			; return r1 + r2
	ld r1, multiply10_r1
	ld r2, multiply10_r2
	ret


/*	ex: 4.2
	uint16 ascToUint( uint8 data[] ){
		uint16 res = 0;
		for( int i = 0; data[i] != 0; ++i ){
			res = multiply10(res) + data[i] - '0';
		}
		return res;
	}
*/

ascToUint:				;total => 126clk => 252ms
	st r1, ascToUint_r1		;6clk => 12ms
	st r2, ascToUint_r2		;6clk => 12ms
	st r3, ascToUint_r3		;6clk => 12ms
	st r4, ascToUint_r4		;6clk => 12ms
	add  r3, r0, #0			;4clk => 8ms
	ldi r0, #0			;6clk => 12ms
	ldi r1, #0			;6clk => 12ms		;int i = 0
	ldi r2, #0xF			;6clk => 12ms
	ldi r4, #'0'			;6clk => 12ms		;store 30 on r4

for:
	ldb r2, [r3, r1]		;6clk => 12ms		;data[i]
	sub r2, r2, #0			;4clk => 8ms		;data[i] != 0
	jz end_for			;4clk => 8ms
	st r5, r5_backup		;6clk => 12ms
	jmpl multiply10			;4clk => 8ms		;multiply10(res)
	ld r5, r5_backup		;6clk => 12ms
	sub r2, r2, r4			;4clk => 8ms		;data[i] - '0'
	add r0, r0, r2			;4clk => 8ms		;res = multiply10(res) + data[i] - '0'
	add r1, r1, #1			;4clk => 8ms		;++i
	jmp for				;4clk => 8ms

end_for:
	ld r1, ascToUint_r1		;6clk => 12ms
	ld r2, ascToUint_r2		;6clk => 12ms
	ld r3, ascToUint_r3		;6clk => 12ms
	ld r4, ascToUint_r4		;6clk => 12ms
	ret				;4clk => 8ms

	/*
	Resposta 4.2:
		724clk => 1448ms
	*/

/*
	#define TMP_SIZE 10
	uint8 tmp[TMP_SIZE];

	uint16 ascToUintArr( uint16 dst[], uint16 dlen, uint8 src[] ){
		uint16 di = 0, si = 0;
		while( di < dlen ){
			while( src[si] < '0' || src[si] > '9'){
				if( src[si++] == 0 ){
					return di;
				}
			}
			uint16 ti = 0;
			while( src[si] >= '0' && src[si] <= '9' ){
				tmp[ ti++ ] = src[ si++ ];
			}   tmp[ ti++ ] = 0;
			dst[ di++ ] = ascToUint( tmp );
		}
		return di;
	}
*/

.equ TMP_SIZE, 10
src:
	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

/*
	dst[] = r0
	dlen  = r1
	scr[] = r2
*/
ascToUintArr:
	st r3, ascToUintArr_r3
	st r4, ascToUintArr_r4
	ldi r3, #0								;di = 0
	ldi r4, #0								;si = 0

while1:
	subr r3, r3, r1						;di < dlen
	jc end_while1

while2:
	ldi r?, [r2,r4]						;src[si] < '0'
	subr r?, r?, #'0'						;...
end_while1:


.end
