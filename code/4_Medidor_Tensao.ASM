;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MARÇO DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		
	MOVLW	B'00000010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100' ; COM REFERENCIA INTERNA E SEM SAIDA 
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	BCF	GPIO, GP5   ; GP5 = B3 DO BCD - NAO SERA USADO 
	
	; COMPARANDO A ENTRADA COM 0,5V 
	BANK1 
	MOVLW	B'10100010'	; VRR = LOW RANGE - VALOR 2
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON, COUT
	GOTO	VALOR_0		; COUT = 1 = MENOR QUE 0,5 
	
	; COMPARANDO A ENTRADA COM 1V 
	BANK1
	MOVLW	B'10100101'	; VRR = LOW RANGE - VALOR 5
	MOVWF	VRCON 
	BANK0
	BTFSC	CMCON, COUT	
	GOTO	VALOR_1		; COUT = 1 = MENOR QUE 1V
	
	; COMPARANDO A ENTRADA COM 1,5V
	BANK1
	MOVLW	B'10100111'	; VRR = LOW RANGE - VALOR 7
	MOVWF	VRCON 
	BANK0
	BTFSC	CMCON, COUT	
	GOTO	VALOR_2		; COUT = 1 = MENOR QUE 1,5V
	
	; COMPARANDO A ENTRADA COM 2V
	BANK1 
	MOVLW	B'10000101'	; VRR = HIGH RANGE - VALOR 5
	MOVWF	VRCON 
	BANK0
	BTFSC	CMCON, COUT 
	GOTO	VALOR_3		; COUT = 1 = MENOR QUE 2V
	
	; COMPARANDO A ENTRADA COM 2,5V 
	BANK1
	MOVLW	B'10101100'	; VRR = LOW RANGE - VALOR 12
	MOVWF	VRCON 
	BANK0
	BTFSC	CMCON, COUT 
	GOTO	VALOR_4		; COUT = 1 = MENOR QUE 2,5
	
	; COMPARANDO A ENTRADA COM 3V
	BANK1
	MOVLW	B'10001011'	; VRR = HIGH RANGE - VALOR 11
	MOVWF	VRCON 
	BANK0 
	BTFSC	CMCON, COUT 
	GOTO	VALOR_5		; COUT = 1 = MENOR QUE 3
	
	; COMPARANDO A ENTRADA COM 3,5V 
	BANK1 
	MOVLW	B'10001110'	; VRR = HIGH RANGE - VALOR 14
	MOVWF	VRCON 
	BANK0
	BTFSC	CMCON, COUT 
	GOTO	VALOR_6		; COUT = 1 = MENOR QUE 3,5
	GOTO	VALOR_7		; COUT = 0 = MAIOR QUE 3,5
	
	GOTO	MAIN 
	
VALOR_0	;   BCD = 0000
	BCF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	GOTO	MAIN 

VALOR_1	;   BCD = 0001
	BSF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	GOTO	MAIN 
	
VALOR_2 ;   BCD = 0010
	BCF	GPIO, GP0
	BSF	GPIO, GP2
	BCF	GPIO, GP4
	GOTO	MAIN 
	
VALOR_3 ;   BCD = 0011
	BSF	GPIO, GP0
	BSF	GPIO, GP2
	BCF	GPIO, GP4
	GOTO	MAIN 

VALOR_4	;   BCD = 0100
	BCF	GPIO, GP0
	BCF	GPIO, GP2
	BSF	GPIO, GP4
	GOTO	MAIN 
	
VALOR_5 ;   BCD = 0101
	BSF	GPIO, GP0
	BCF	GPIO, GP2
	BSF	GPIO, GP4
	GOTO	MAIN 
	
VALOR_6	;   BCD = 0110
	BCF	GPIO, GP0
	BSF	GPIO, GP2
	BSF	GPIO, GP4
	GOTO	MAIN 

VALOR_7	;   BCD = 0111
	BSF	GPIO, GP0
	BSF	GPIO, GP2
	BSF	GPIO, GP4
	GOTO	MAIN 

FIM
	GOTO	FIM
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
