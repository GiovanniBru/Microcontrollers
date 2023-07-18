# Microcontrollers / Microcontroladores
Repositório de atividades da disciplina Introdução à Microcontroladores, cursada no período 2022.2 do curso de Engenharia da Computação na UFPB.
Repository of activities for the discipline Introduction to Microcontrollers, attended in the period 2022.2 of the Computer Engineering course at UFPB.

O _data sheet_ dos microcontroladores utilizados estão anexados, juntamente a outros materiais auxiliares, na pasta _'documentos auxiliares'_.

tags: micro, microcontrollers, microcontroladores, ufpb, assembly, dht11, pic12f675, pic16f628a, ultrassom, ultrasonic, hc-sr04.


## 1 - Produto de dois números em Assembly
_Objetivo:_ Exercício de familiarização com o conjunto de instruções do PIC.
_Especificações:_ 
- Dado dois valores em **hexadecimal**, armazenados nas variáveis X1 e X2 (1 byte cada), propor um programa na linguagem assembly (PIC12F675) para efetuar o produto desses números; 
- Como o resultado do produto pode ser um valor maior que FF, considera-se que os resultados devem ser apresentados em dois bytes (variáveis R1 e R2);
- A variável R2 será utilizada como byte mais significativo e a variável R1 como byte menos significativo;
- Se o resultado do produto for menor ou igual a 00FF, a variável R2 deverá conter zero.
- Veja os exemplos:

<p float="left">
 <img src="" width="200" />
 <img src="" width="200" /> 
</p>


## 2 - Controlador de intensidade de um LED
_Objetivo:_ Exercícios para gerenciamento de portas e de tempo.
_Especificações:_ 
- O microcontrolador utilizado deverá ser o PIC12F675;
- Duas chaves serão utilizadas para configurar a intensidade LED, alterando o _duty_ _cycle_, conforme tabela abaixo:
<p float="left">
 <img src="" width="200" />
</p>
- Quando houver _duty_ _cycle_ diferente de 100%, a frequência do sinal deve ser de 500Hz;
- GP0 deverá ser utilizado para o bit 0 da chave;
- GP1 deverá ser utilizado para o bit 1 da chave;
- GP5 deverá ser utilizado para ativar o LED;
- Pelo menos um TIMER deve ser utilizado.

## 3 - Controlador Automotivo: PISCA
_Objetivo:_ Exercícios para gerenciamento de portas e de tempo (com TIMERs e interrupção).
_Contexto:_ Sistema de sinalização automotiva, controlando o "pisca-pisca" lados direito e esquerdo, quando acionados. 
_Especificações:_ 
- O microcontrolador utilizado deverá ser o PIC12F675;
- O sistema contém um interruptor de 3 posições, para acender 2 LEDs (LED-E e LED-D):
  - Quando na posição central, o LED-E e o LED-D permanecem apagados;
  - Quando na posição E (esquerda), o LED-E piscará com frequência de 1 Hz;
  - Quando na posição D (direita), o LED-D piscará com frequência de 1 Hz;
- O sistema contém um interruptor (liga-desliga), para piscar os dois LEDs ao mesmo tempo (função alerta), com frequência de 1 Hz. Esse interruptor deve ter maior prioridade;
- GP0 deverá ser utilizado com o interruptor que comandará a função "alerta";
- GP1 e GP2 deverão ser utilizados para o interruptor de 3 posições;
- GP4 e GP5 deverão ser utilizados, respectivamente, para os LED-E e LED-D; 
- O uso de interrupção é obrigatório.


## 4 - Comparador: medindo de 0 a 3,5V em uma escala de 0 a 7 e indicação em BCD
_Objetivo:_ Exercício de familiarização com o comparador do PIC. 
_Contexto:_ Um valor de tensão entre 0 e 3,5V deve ser representado em uma escala discreta, indicando a escala de 0 a 7 em BCD, para representação em um display de 7 segmentos. 
_Especificações:_ 
- O microcontrolador utilizado deverá ser o PIC12F675;
- NÃO é permitida a utilização do conversor A/D;
- A tensão de entrada é de 0 a 3,5V;
- A conversão de tensão para a escala de 0 a 9 deve ser efetuada através do comparador;
- O valor da tensão deve ser convertido para codificação BCD para ser conectado ao display de 7 segmentos;
- A indicação deve ser efetuada, em modo cíclico e tão rápido quanto possível (limitado pela velocidade do microcontrolador);
- Os bits do display b3,b2,b1,b0 devem ser conectados às portas GP5,GP4,GP2,GP0, respectivamente;
- Os níveis de tensão e a escala correspondente está na descrito na tabela a seguir:

| Valor da Tensão (V) | Valor mostrado no display |
|---------------------|---------------------------|
| AD <= 0,5           | 0                         |
| 0,5 < AD <= 1       | 1                         |
| 1,0 < AD <= 1,5     | 2                         |
| 1,5 < AD <= 2       | 3                         |
| 2 < AD <= 2,5       | 4                         |
| 2,5 < AD <= 3       | 5                         |
| 3 < AD <= 3,5       | 6                         |
| 3,5 < AD            | 7                         |

## 5 - Conversor A/D: medindo de 0 a 5V em uma escala de 0 a 9 e indicação em BCD
_Objetivo:_ Exercício de familiarização com o comparador do PIC.
_Contexto:_ Um valor de tensão entre 0 e 5V deve ser representado em uma escala discreta, indicando a escala de 0 a 9 em BCD, para representação em um display de 7 segmentos.
_Especificações:_ 
- O microcontrolador utilizado deverá ser o PIC12F675;
- **NÃO** é permitida a utilização do comparador;
- A tensão de entrada é de 0 a 5V;
- A conversão de tensão para a escala de 0 a 9 deve ser efetuada através do conversor A/D;
- O valor da tensão deve ser convertido para codificação BCD para ser conectado ao display de 7 segmentos;
- A indicação deve ser efetuada, em modo cíclico, com taxa de amostragem de 100ms;
- Os bits do display b3,b2,b1,b0 devem ser conectados às portas GP5,GP4,GP2,GP0, respectivamente; 
- Os níveis de tensão e a escala correspondente está na descrito na tabela a seguir:

| Valor da Tensão (V) | Valor mostrado no display |
|---------------------|---------------------------|
| AD <= 0,5           | 0                         |
| 0,5 < AD <= 1       | 1                         |
| 1,0 < AD <= 1,5     | 2                         |
| 1,5 < AD <= 2       | 3                         |
| 2 < AD <= 2,5       | 4                         |
| 2,5 < AD <= 3       | 5                         |
| 3 < AD <= 3,5       | 6                         |
| 3,5 < AD <= 4       | 7                         |
| 4 < AD <= 4,5       | 8                         |
| AD > 4,5            | 9                         |


## 6 - Conversor A/D e medição de tensão de 0 a 5v 
_Objetivo:_ Exercício de familiarização com o conversor A/D do PIC e desenvolvimento de rotinas aritméticas.
_Contexto:_ Medir uma tensão e indicar em um display LCD. 
_Especificações:_ 
- O microcontrolador utilizado deverá ser o PIC12F675;
- A conversão A/D deve ser feita em 8 bits pela porta GP2;
- Faça a aquisição 32 valores para calcular a média de cada medida;
- A conversão A/D deve ser efetuada, em modo cíclico e tão rápido quanto possível (limitado pela velocidade do microcontrolador);
- O valor da média conversão A/D deve ser transformado para o correspondente em tensão em volt, com uma casa decimal; 
- Crie um algoritmo para efetuar os cálculos da divisão com uma casa decimal de precisão;
- O valor mostrado no display deve ser atualizado a cada 200 ms;
- A documentação com a descrição do funcionamento do LCD Serial está anexada em _'documentos auxiliares'_. 


## 7 - Controle de periférico - Leitura do Sensor DHT11
_Objetivo:_ Comunicação do PIC12F675 com um periférico externo.
_Contexto:_ Implementar um _termohigrômetro_ com microcontrolador e sensor DHT11.
_Especificações:_ 
- A atividade deverá ser implementada com o kit LCD/PIC2F675 e com o sensor DHT11;
- Faça reuso (com os ajustes necessários) das rotinas desenvolvidas anteriormente para manipular o LCD;
- As especificações do protocolo de comunicação com o sensor DHT11 estão definidas no seu datasheet anexado em _'documentos auxiliares'_.
- O PIC deve utilizar a porta GP2 para comunicação com o DHT11;
- O PIC deve utilizar a porta GP1 para comunicação com o LCD;
- As medidas de temperatura e umidade relativa devem ser feitas a cada 1 segundo;
- No LCD, as informações devem ser apresentadas na forma do exemplo abaixo:
<p float="left">
 <img src="" width="200" />
</p>


## 8 - Detectando obstáculos ("Régua eletrônica") 
_Objetivo:_ Atividade integrada para familiarização do conjunto de instruções do **PIC16F628A** com periféricos externos e funcionalidades. 
_Especificações:_ 
- A aplicação deve utilizar a placa de desenvolvimento para o PIC16F628A;
- Módulo ultrassom **HC-SR04** será utilizado para ser acoplado à placa de desenvolvimento (documentação anexada em _'documentos auxiliares'_);
- O valor da medida da distância deve ser visualizado no display LCD;
- As portas para comunicação com o sensor ultrassom devem ser claramente identificadas no arquivo ".ASM";
- O ciclo de repetição deve obedecer às recomendações do data sheet do sensor ultrassom.





_Obs: Alguns códigos não foram testados pois passei uma parte do tempo sem acesso a IDE para compilar, por problemas no computador, então não posso garantir resultado. Qualquer dúvida em que possa ajudar um estudante, me contate no e-mail: giovannibrunocarvalho@gmail.com, seria um prazer repassar meu conhecimento adquirido nessa disciplina!_
