;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     FEVEREIRO DE 2023                           *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos� de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;COLOQUE AQUI SUAS NOVAS VARI�VEIS
		CONT 
		CONT2
		UMIDADE
		TEMPERATURA
		;N�O ESQUE�A COMENT�RIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINI��O DE VARI�VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SINAL_ENVIADO
	; FOI ENVIADO O SINAL DE START PRO DHT11
	BANK1
	BSF	TRISIO, TR2 ; SETA GP2 COMO ENTRADA 
	MOVLW	B'00000000' ; PRESCALER = 1:2
	MOVWF	OPTION_REG
	BANK0 
	
	BCF	INTCON, T0IF 
	RETURN
	
	
	; AGUARDA RESPOSTA DO DHT11 (160US) - TEMPO DE PREPARACAO DO SENSOR
AGUARDA1
	MOVLW	.248
	MOVWF	TMR0
	BTFSS	INTCON, T0IF 
	GOTO	AGUARDA1
	
	RETURN
	
RH_INT
	CLRF	UMIDADE
	MOVWF	.8
	MOVFW	CONT
	; TESTA OS 8 BITS INTEIROS DE UMIDADE RELATIVA
	; AGUARDA 80US, SE O BARRAMENTO ESTIVER COM TENS�O ALTA APOS 
	; 80US SIGNIFICA QUE O SINAL � 1 
AGUARDA2
	MOVLW	.252
	MOVWF	TMR0 
	BTFSS	INTCON, T0IF 
	GOTO	AGUARDA2
	
	BTFSS	GPIO, GP2   ; SE TIVER SETADO O VALOR � 1 
	CALL	VALOR0
	; VALOR = 1
	MOVLW	.8
	SUBWF	CONT 
	BTFSC	STATUS, ZERO ; SE FOR A PRIMEIRA EXECUCAO E DER 1 = INCREMENTA
	INCF	UMIDADE 
	
	CALL	VALOR1
	
	DECFSZ	CONT	; IRA REPETIR O PROCESSO DE VERIFICAR O BIT A CADA 80US
	GOTO	AGUARDA2    ; 8 VEZES 
	
	RETURN 
	
VALOR0	
	RLF	UMIDADE	    ; ROTACIONA A UMIDADE = MANDA O BIT PRA CASA DO LADO
	RETURN
	
VALOR1 
	RLF	UMIDADE	    ; ROTACIONA DEPOIS INCREMENTA PRA COLOCAR 1 NO BIT
	INCF	UMIDADE 
	RETURN 

TEMP_INT 
	CLRF	TEMPERATURA
	MOVWF	.8
	MOVFW	CONT2
	; TESTA OS 8 BITS INTEIROS DE TEMPERATURA
	; AGUARDA 80US, SE O BARRAMENTO ESTIVER COM TENS�O ALTA APOS 
	; 80US SIGNIFICA QUE O SINAL � 1 
AGUARDA3
	MOVLW	.252
	MOVWF	TMR0 
	BTFSS	INTCON, T0IF 
	GOTO	AGUARDA3
	
	BTFSS	GPIO, GP2   ; SE TIVER SETADO O VALOR � 1 
	CALL	VALOR0T
	; VALOR = 1:
	MOVLW	.8
	SUBWF	CONT2 
	BTFSC	STATUS, ZERO ; SE FOR A PRIMEIRA EXECUCAO E DER 1 = INCREMENTA
	INCF	TEMPERATURA
	
	CALL	VALOR1T
	
	DECFSZ	CONT2	; IRA REPETIR O PROCESSO DE VERIFICAR O BIT A CADA 80US
	GOTO	AGUARDA3    ; 8 VEZES 
	RETURN 
	
VALOR0T
	RLF	TEMPERATURA 
	RETURN 

VALOR1T
	RLF	TEMPERATURA 
	INCF	TEMPERATURA
	RETURN 
	
	
SEND_GIOVANNI
	
	
	RETURN 
	
; ENVIA 'Temp=' PRO LCD: 
SEND_TEMP

	RETURN 
	
; ENVIA A TEMPERATURA PRO LCD: 
SEND_TEMP2

	RETURN 
	
; ENVIA 'C' DE CELCIUS PRO LCD: 
SEND_C
	
	RETURN 
	
; ENVIA 'UR=' PRO LCD: 
SEND_UR
	
	RETURN 
	
; ENVIA UMIDADE PRO LCD: 
SEND_UMID
	
	RETURN 
	
; ENVIA '%' PRO LCD: 
SEND_PCT
	
	
	RETURN 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000100' ; GP2 COMO ENTRADA
	MOVWF	TRISIO		
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000011' ; PRESCALER = 1:16
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	; PRIMEIRO ENVIA O SINAL DE INICIALIZA��O PRO DHT11 
	BANK1
	BCF	TRISIO, TR2 ; GP2 COMO SA�DA PARA ENVIAR O SINAL PRO DHT
	MOVLW	B'00000011' ; PRESCALER = 1:16
	MOVWF	OPTION_REG	
	BANK0 
	
	BCF	GPIO, GP2   ; ENVIA SINAL LOW EM GP2 
	
	BCF	INTCON, T0IF
	MOVWF	.245	; AGUARDA 18MS ENQUANTO ENVIA 
	MOVFW	TMR0
LOOP_START
	BTFSS	INTCON, T0IF
	GOTO	LOOP_START
	
	CALL	SINAL_ENVIADO
	CALL	AGUARDA1
	
	CALL	RH_INT 
	
	CALL	AGUARDA1
	CALL	AGUARDA1
	CALL	AGUARDA1
	CALL	AGUARDA1
	; AGUARDA O TEMPO QUE ESTA SENDO TRANSMITIDO A PARTE DECIMAL DA UMIDADE
	
	CALL	TEMP_INT

	; ENVIA MEU NOME PRO LCD: 
	CALL	SEND_GIOVANNI
	
	; ENVIA 'Temp=' PRO LCD: 
	CALL	SEND_TEMP
	
	; ENVIA A TEMPERATURA PRO LCD: 
	CALL	SEND_TEMP2
	
	; ENVIA 'C' DE CELCIUS PRO LCD: 
	CALL	SEND_C
	
	; ENVIA 'UR=' PRO LCD: 
	CALL	SEND_UR
	
	; ENVIA UMIDADE PRO LCD: 
	CALL	SEND_UMID
	
	; ENVIA '%' PRO LCD: 
	CALL	SEND_PCT
	
	; AGUARDA 2S PRA COME�AR TUDO NOVAMENTE 
	BCF	INTCON, T0IF 
	BANK1
	MOVLW	B'00000110' ; PRESCALER = 128
	MOVWF	OPTION_REG	
	MOVLW	.0
	MOVWF	TMR0
AGUARDA4
	BTFSS	INTCON, T0IF
	GOTO	AGUARDA4
	
	
	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
