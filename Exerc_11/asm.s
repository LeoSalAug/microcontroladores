        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
;        • Idealize uma sub-rotina que calcule o fatorial
;       de um número com resultado de 32 bits
;       – Parâmetro de entrada: R0
;       – Valor de retorno: R0
;       – Os valores de todos os demais registradores do
;       processador deverão ser preservados
;
;       • Idealize uma forma de retornar o valor -1 caso
;       o resultado do fatorial extrapole 32 bits
        
__iar_program_start
        
        ;; main program begins here
main    
 MOV R0, #5             ; in R0
 BL fact32b             ;start rotina
 B fim
fact32b                 ;rotina
 PUSH {R1, R2}          ; salva aux na pilha
 MOV R1, R0              ; r1=r0
 CMP R1, #0              ; compara
 ITTT EQ                  ; if true   
  MOVEQ R0, #1                ;mov
  POPEQ {R1, R2}                ;pop
  BXEQ LR               ;set destino
 SUB R1, #1              ; r1--
loop
 CMP R1, #1              ; compara
 ITT EQ                  ; Caso seja o ultimo, encerra o loop
  POPEQ {R1, R2}        ;pop
  BXEQ LR               ;set destino
 MULS R0, R1             ; Multiplicão do factorial
 ADDS R2, R0, R0         ; add 2*r0 em r2 com flag
 ITTT VS                 ; analisando flag V gerada
  MOVVS R0, #-1         ;overflow -1
  POPVS {R1, R2}        ;pop
  BXVS LR               ;set destino
 SUB R1, #1              ; r1--
 B loop
fim
 B fim

        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
