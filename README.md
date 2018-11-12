INSTITUTO SUPERIOR DE ENGENHARIA DE LISBOA 
 
Engenharia de Eletrónica e Telecomunicações e de Computadores e Engenharia Informática e de Computadores 
 
2.º Trabalho Prático de Arquitetura de Computadores 
 
Introdução à programação em assembly 
 
 
19 de outubro de 2018 
Arquitetura de Computadores  2018/19-1 
 
 

 1. Objetivos Este trabalho tem como principais objetivos o exercício da programação em linguagem assembly do PDS16, incluindo a organização dos programas em funções e a introdução a um ambiente de programação em assembly. 
 
 2. Descrição do Trabalho O trabalho consiste na implementação e teste de programas em assembly para i) operação de números inteiros, ii) manipulação de arrays em memória e iii) invocação de funções. Os programas devem ser escritos em linguagem assembly do PDS16, podendo o seu teste ser realizado recorrendo ao simulador do PDS16 ou sobre o sistema SDP16. Para cada um dos exercícios propostos, deve ser escrito um programa de teste que permita verificar e demonstrar o comportamento da função realizada, em diversos cenários de utilização. 
 
 3. Convenções Na escrita dos programas, deve ter em conta as convenções seguintes, relativas a tipos, parâmetros, retorno de valores, preservação de registos e alojamento de memória. 
 
 3.1. Tipos Na especificação dos exercícios, os tipos definidos têm os significados seguintes: 
int8 - inteiro com sinal a 8 bits uint8 - inteiro sem sinal a 8 bits int16 - inteiro com sinal a 16 bits uint16 - inteiro sem sinal a 16 bits 

 3.2. Parâmetros Os parâmetros das funções são passados nos registos do processador, ocupando a quantidade necessária, por ordem: 1.º, R0; 2.º, R1; 3.º, R2; etc.. 
 
 3.3. Valor de retorno O valor de retorno de uma função, caso exista, é devolvido no registo R0.
 
 3.4. Preservação de registos Como consequência da chamada a uma função, podem ser modificados os registos seguintes: - R5 (link) e R6 (PSW); - Os registos usados para passar os parâmetros à função chamada. Os registos restantes devem ser preservados. Se a função os utilizar, deve armazená-los em memória e, no final, repor os respetivos conteúdos anteriores. 
 
 3.5. Alojamento de memória para variáveis das funções ou preservação de registos O espaço de memória para variáveis das funções ou preservação de registos deve: - Ser reservado na área acessível por load e store com endereçamento direto; - Identificar cada localização por um símbolo (label), com um prefixo que indique a respetiva função utilizadora. 
Arquitetura de Computadores  2018/19-1 
 
 
 4. Especificação dos exercícios 
 
 4.1. Implemente, em assembly do PDS16, a função multiply10 que retorna o décuplo do argumento. 
 
uint16 multiply10( uint16 val ) { 
  return (val << 3) + (val << 1); 
 }  
 
 4.2. Considere a função ascToUint que calcula e retorna o valor numérico representado pelos algarismos decimais contidos numa string, codificada em ASCII e terminada por 0. 
 
uint16 ascToUint( uint8 data[] ) {
  uint16 res = 0;
  for( int i = 0; data[i] != 0; ++i ) {
    res = multiply10(res) + data[i] - '0';  
  }  
  return res; 
}  

a) Implemente, em assembly do PDS16, a função ascToUint.  

b) Determine, em número de bytes, a quantidade de memória de código ocupada pela função ascToUint.  

c) Supondo que a função ascToUint tem como argumento "12345", indique o número de ciclos de relógio gastos na execução da função desenvolvida (excluindo a função multiply10).  

4.3. Implemente, em assembly do PDS16, as definições seguintes e a função ascToUintArr que calcula e armazena no array dst, com dimensão máxima dlen, a sequência de valores numéricos representados por grupos de algarismos separados por outros carateres, numa string codificada em ASCII e terminada por 0. 
 
#define TMP_SIZE 10 uint8 tmp[TMP_SIZE]; 
 
uint16 ascToUintArr( uint16 dst[], uint16 dlen, uint8 src[] ) {
  uint16 di = 0, si = 0;
  while( di < dlen ) {
    while( src[si] < '0' || src[si] > '9') {
      if( src[si++] == 0 ) {
        return di;    
      }   
    }   
    uint16 ti = 0;   
    while( src[si] >= '0' && src[si] <= '9' ) {   
      tmp[ ti++ ] = src[ si++ ];   
    }   
    tmp[ ti++ ] = 0;   
    dst[ di++ ] = ascToUint( tmp );  
  }  
  return di;
} 
 

4.4. Considere as definições seguintes e a função main. 
 
#define DEST_SIZE 5 
 
uint16 n1; uint16 n2; uint16 n3; 
 
uint16 d1[DEST_SIZE]; uint16 d2[DEST_SIZE]; uint16 d3[DEST_SIZE]; 
 
uint8 s1[] = "123 456 789"; 
uint8 s2[] = "  1234   76789   "; 
uint8 s3[] = "10,20,30,40,50,60,70,80";

void main( void ) {  
  n1 = ascToUintArr( d1, DEST_SIZE, s1 );
  n2 = ascToUintArr( d2, DEST_SIZE, s2 );
  n3 = ascToUintArr( d3, DEST_SIZE, s3 ); 
} 
 
 a) Implemente, em assembly do PDS16, as definições referias e a função main.
 
 b) Registe os valores produzidos pela execução nas variáveis n1, n2 e n3. 
 
 
 5. Avaliação 
O trabalho deve ser realizado em grupo e conta para a avaliação da disciplina, estando sujeito a discussão final. A sua apresentação decorrerá em data a combinar com o docente da turma. Cada grupo deverá entregar o trabalho desenvolvido, na forma de listagens dos programas realizados, devidamente indentadas e comentadas. As respostas às alíneas b) e c) do exercício 4.2 e da alínea b) do exercício 4.4 devem ser incluídas na própria listagem, sob a forma de comentários. 

 
 
2.º Trabalho Prático – Introdução à programação em assembly  5 
Anexo 
Recomendações para escrita de programas em linguagem assembly 

• O texto do programa é escrito em letra minúscula, exceto os identificadores de constantes. 

• Nos identificadores formados por várias palavras usa-se como separador o carácter ‘_’ (sublinhado). 

• O programa é disposto na folha, na forma de uma tabela de quatro colunas. Na primeira coluna insere-se apenas a label (se existir), na segunda coluna a mnemónica da instrução ou da diretiva, na terceira coluna os parâmetros da instrução ou da diretiva e na quarta coluna os comentários até ao fim da linha (começados por ‘;’). Cada linha contém apenas uma label, instrução ou diretiva.

• Para definir as colunas deve usar-se caracteres TAB. A largura mais conveniente é 8.

• As linhas com label não devem conter instrução ou diretiva. Isso permite usar labels compridas sem desalinhar a tabulação e cria separações na sequência de instruções. 
