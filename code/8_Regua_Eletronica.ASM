;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     FEVEREIRO DE 2023                           *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628a.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

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
		RESULTADO
		RES_H
		RES_L
		CONT1
		CONT2
		CONT3
		DIVISOR
		TRANSMITIDO
		ROTACIONA
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
	; TESTA SE A INTERRUPCAO FOI PELO RB0
	;BTFSS	TRISA, RB0
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

LIMPA_VAR   ; INICIALIZA TODAS AS VARIAVEIS 
	CLRF	RESULTADO
	CLRF	RES_H
	CLRF	RES_L
	CLRF	CONT1
	CLRF	CONT2
	CLRF	CONT3
	CLRF	DIVISOR
	BCF	PORTA, RA0
	RETURN 
	
DELAY_10    ; DELAY DE 10US
	NOP 
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN 
	
TESTAR_ECHO ; CONTANDO O TEMPO DE RESPOSTA DO SENSOR 
	BTFSC	PORTA, RA0 
	GOTO	TESTAR_ECHO 
	BCF	T1CON, TMR1ON	; PARA DE CONTAR O TMR1	
	RETURN
	
DIVIDIR_58
	MOVLW	.58
	MOVWF	DIVISOR  
	MOVFW	RES_L	; MOVE PARTE LOW DO TEMPO PRA WORK PRA DIVIDI-LA POR 58
DIVISAO_1
	BTFSS	STATUS, Z ; VERIFICA SE O BIT ZERO DO REGISTRADOR DE STATUS TA SETADO
			; O QUE INDICA QUE A DIVISAO ACABOU
	GOTO	DIVISAO_1  ; SE NAO ESTIVER SETADO = CONTINUA DIVISAO 
	RLF	W, DIVISOR ; DESLOCA O BIT MAIS SIGNIFICATIVO DA WORK PARA ESQUERDA E ARMAZENA NO BIT
		        ; MENOS SIGNIFICATIVO 
	RLF	RESULTADO, DIVISOR ; DESLOCA O BIT MAIS SIGNIFICATIVO DO RESULTADO PARA ESQUERDA E 
			; ARMAZENA O BIT MENOS SIGNIFICATIVO 
	SUBWF	W, DIVISOR ; SUBTRAI O VALOR NA WORK PELO DIVISOR (58) 
	BTFSS	STATUS, C ; VERIFICA SE O CARRY ESTA SETADO, OQ INDICARIA QUE A SUBTRACAO
			        ; RESULTOU EM VALOR NEGATIVO OU ZERO 
	GOTO	DIVISAO_1
	RETURN 
	
MULT_4	; MULTIPLICA A PARTE HIGH DO TEMPO POR 4 
	RLF	RES_H
	RLF	RES_H
	RETURN 
	
ENVIA_RESULT
	MOVLW	.8
	MOVWF	CONT2
LOOP	; ROTACIONA O DADO 8 VEZES PARA INVERTER SEUS BITS 
	RRF	RESULTADO
	DECFSZ	CONT2
	GOTO	LOOP
	MOVFW	RESULTADO   ; MOVE RESULTADO PRA WORK E CHAMA FUNCAO DE TRANSMISSAO
	MOVWF	TRANSMITIDO
	CALL	TRANSMISSAO
	RETURN
	
ENVIA_CM   ; ENVIAR ' cm' PRO DISPLAY
	; ENVIA ' ':
	MOVLW	B'00100000' ; = ESPAÇO EM ASCII 
	MOVWF	ROTACIONA
	CALL	ROTACIONAR
	MOVFW	ROTACIONA 
	MOVWF	TRANSMITIDO
	CALL	TRANSMISSAO 
	
	; ENVIA 'c': 
	MOVLW	B'01100011' ; = c EM ASCII
	MOVWF	ROTACIONA 
	CALL	ROTACIONAR 
	MOVFW	ROTACIONA 
	MOVWF	TRANSMITIDO
	CALL	TRANSMISSAO 
	
	; ENVIA 'm': 
	MOVLW	B'01101101' ; = m EM ASCII
	MOVWF	ROTACIONA 
	CALL	ROTACIONAR 
	MOVFW	ROTACIONA 
	MOVWF	TRANSMITIDO
	CALL	TRANSMISSAO 

	RETURN 

ROTACIONAR  ; ROTACIONA O DADO 8 VEZES PARA INVERTER SEUS BITS
	MOVLW	.8
	MOVWF	CONT3
LOOP_ROT
	RRF	ROTACIONA 
	DECFSZ	CONT3
	GOTO	LOOP_ROT	
	RETURN 
	
TRANSMISSAO
	BCF	PIR1, TXIF  ; LIMPA A FLAG DE QUE FINILIZOU A TRANSMISSAO POR GARANTIA 
	; SETAR BIT TRISB<1> PARA CONFIGURAR O BIT RB1 COMO SAIDA 
	BANKSEL	TRISB	; VAI PRO BANK1 
	BSF	TRISB, TRISB1 
	CLRF	SPBRG	; AQUI PASSAMOS A TAXA DE TRANSMISSAO (NAO SOUBE DEFINIR)
	BCF	TXSTA, 4 ; GARANTE QUE TA NO MODO ASSINCRONO
	BSF	TXSTA, TXEN ; HABILITA A TRANSMISSAO 
	BANKSEL	OPTION_REG  ; VOLTA PRO BANK0
	MOVFW	TRANSMITIDO 
	MOVWF	TXREG	; MOVER O VALOR QUE SERÁ TRANSMITIDO PRO TXREG 
			; IRA DE FATO COMEÇAR A TRANSMISSAO 
LOOP_TR	; AGUARDA ATE O FIM DA TRANSMISSAO 
	BTFSS	PIR1, TXIF
	GOTO	LOOP_TR
	NOP
	RETURN 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
;	PORTAS PARA CONEXÃO COM SENSOR HC-SR04: 
;	RA0 = INPUT
;	RA4 = OUTPUT
	BANKSEL OPTION_REG  ; VAI PRO BANK1 
	MOVLW	B'00000001' ; TRISA4 = 0 = RA4 É OUTPUT
	MOVWF	TRISA	    ; TRISA0 = 1 = RA0 É INPUT 
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	
	; INTEDF(OPTION_REG<6>) = 1 = INTERRUPCAO NA SUBIDA DO RB0 
	MOVLW	B'00000000'
	MOVWF	INTCON		
	; REGISTRADOR DE TRANSMISSAO: 
	MOVLW	B'00000000'
	MOVWF	TXSTA
	; TX9 = 0 = 8-BIT 
	; TXEN = 0 -> VAI PRA 1 QUANDO FOR COMEÇAR A TRANSMISSAO
	; SYNC = 0 = MODO ASSINCRONO
	; BRGH = 0 = MODO LOW
	BANKSEL CMCON		; MUDA PRO BANK0	
	MOVLW	B'00000111'
	MOVWF	CMCON		;DESLIGA O COMPARADOR PARA ECONOMIZAR ENERGIA 
	; TIMER 1: 
	MOVLW	B'00000010'
	MOVWF	T1CON 
	; TMR1CS = 1 = MODO DE CONTADOR 
	; SEGUNDO O DATASHEET: ?IN COUNTER MODE, IT INCREMENTS ON EVERY RISING EDGE OF A
	; EXTERNAL CLOCK?. NAO SEI SE FUNCIONARA, MAS SEI QUE QUERO UM CONTADOR E NAO 
	; UM TIMER, POR ISSO HABILITEI O BIT 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	CALL	LIMPA_VAR
	
	; RA4 = TRIGGER
	; PRECISA PASSAR 10US EM HIGH PARA DAR START NO SENSOR 
	BSF	PORTA, RA4
	CALL	DELAY_10
	BCF	PORTA, RA4
	
TESTE_ECHO
	BTFSS	PORTA, RA0 
	GOTO	TESTE_ECHO
	
	BSF	T1CON, TMR1ON	; HABILITA O TMR1, COMEÇA A CONTAR 
	
	CALL	TESTAR_ECHO
	
	;TMR1 POSSUI O TEMPO, PRECISAMOS CALCULAR A DISTANCIA 
	;TMR1H = HIGH DO TMR1 = PRECISA SER MULTIPLICADO POR 4,4
	;TMR1L = LOW DO TMR1 = PRECISA SER DIVIDIDO POR 58 
	; PELA EQUAÇÃO D = V x T 
	MOVFW	TMR1H
	MOVWF	RES_H
	MOVFW	TMR1L 
	MOVWF	RES_L 
	
	CALL	MULT_4
	CALL	DIVIDIR_58
	; PARA OBTER A DISTANCIA EM CENTIMETROS, DADO O TEMPO EM MICROSSEGUNDOS
	; É PRECISO DIVIDIR O VALOR LOW POR 58, E MULTIPLICAR O VALOR HIGH POR 4  
	; AO SAIR DESSA FUNCAO O VALOR DA DISTANCIA ESTA EM ?RESULTADO? E ?RES_H? EM CM 
	MOVFW	RES_H
	ADDWF	RESULTADO 
	
	CALL	ENVIA_RESULT
	CALL	ENVIA_CM 
	
	GOTO	MAIN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
