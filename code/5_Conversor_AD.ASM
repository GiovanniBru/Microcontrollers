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
	; FINALIZA A CONVERSAO = GERA INTERRUPCAO 
	BTFSC	PIR1, ADIF ; ADIF = 1 = INDICA QUE CONVERSAO A/D FOI CONCLUIDA	
	CALL	COMPARACOES
	RETURN
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

COMPARACOES
	; PRIMEIRO VERIFICA SE É MENOR QUE 0,5V 
	MOVLW	.26	
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_0	  ; ENTRA AQUI = TENSAO < 0,5V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 1V
	MOVLW	.52
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_1	  ; ENTRA AQUI = TENSAO < 1V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 1,5V	
	MOVLW	.77
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_2	  ; ENTRA AQUI = TENSAO < 1,5V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 2V	
	MOVLW	.103
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_3	  ; ENTRA AQUI = TENSAO < 2V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 2,5V
	MOVLW	.129
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_4	  ; ENTRA AQUI = TENSAO < 2,5V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 3V	
	MOVLW	.154
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_5	  ; ENTRA AQUI = TENSAO < 3V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 3,5V	
	MOVLW	.180
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_6	  ; ENTRA AQUI = TENSAO < 3,5V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 4V
	MOVLW	.205
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_7	  ; ENTRA AQUI = TENSAO < 4V
	; SE O RESULTADO DA SUBTRACAO FOR POSITIVO, CONTINUA
	
	; VERIFICA SE É MENOR QUE 4,5V	
	MOVLW	.231
	SUBWF	ADRESH, W ; SUBTRAI PELO VALOR OBTIDO
	BTFSS	STATUS, C ; SE O RESULTADO DA SUBTRACAO FOR NEGATIVO
	GOTO	VALOR_8	  ; ENTRA AQUI = TENSÃO < 4,5V
	GOTO	VALOR_9	  ; SENAO, ENTRA AQUI = TENSÃO > 4,5V 
	
	RETURN

VALOR_0	;   BCD = 0000
	BCF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 

VALOR_1	;   BCD = 0001
	BSF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 
	
VALOR_2 ;   BCD = 0010
	BCF	GPIO, GP0
	BSF	GPIO, GP2
	BCF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 
	
VALOR_3 ;   BCD = 0011
	BSF	GPIO, GP0
	BSF	GPIO, GP2
	BCF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 

VALOR_4	;   BCD = 0100
	BCF	GPIO, GP0
	BCF	GPIO, GP2
	BSF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 
	
VALOR_5 ;   BCD = 0101
	BSF	GPIO, GP0
	BCF	GPIO, GP2
	BSF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 
	
VALOR_6	;   BCD = 0110
	BCF	GPIO, GP0
	BSF	GPIO, GP2
	BSF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 

VALOR_7	;   BCD = 0111
	BSF	GPIO, GP0
	BSF	GPIO, GP2
	BSF	GPIO, GP4
	BCF	GPIO, GP5
	RETURN 

VALOR_8	;   BCD = 1000
	BCF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	BSF	GPIO, GP5
	RETURN 

VALOR_9	;   BCD = 1001
	BSF	GPIO, GP0
	BCF	GPIO, GP2
	BCF	GPIO, GP4
	BSF	GPIO, GP5
	RETURN 

	
	
	
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		
	MOVLW	B'00000000' ; 2 TOSC - ENTRADAS ANALOGICAS
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW	B'01000000' ; ADIE = 1 = HABILITA INTERRUPCOES DO MODULO A/D
	MOVWF	PIE1
	CALL	0x03FF
	MOVLW	OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'01000101' ; CANAL 1 (AN1) 
	MOVWF	ADCON0
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BCF	PIR1, ADIF  ; LIMPA A FLAG QUE INDICA SE CONVERSAO FOI CONCLUIDA
	; INUTIL NA PRIMEIRA EXECUCAO
	
	; NESSE MOMENTO SETAMOS O VALOR DA TENSÃO DE ENTRADA
	
	BSF	ADCON0, GO_DONE ; SETA O GO/DONE PRA INICIAR O CICLO DE CONVERSÃO
LOOP1
	BTFSC	ADCON0, GO_DONE ; LOOP ATÉ CONCLUIR A CONVERSÃO 
	GOTO	LOOP1
	CALL	COMPARACOES

	
	
	

FIM
	GOTO	MAIN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END


