        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
          ;Idealize uma sub-rotina que utilize o algoritmo
          ;de deslocamentos e adições sucessivas para
          ;computar o produto entre dois valores de 16
          ;bits
;        Sub-rotina Mul16b:
;        – Entrada: registradores R0 e R1
;        – Saída: registrador R2 (produto)


__iar_program_start
        
        ;; main program begins here
main     
 MOV R0, #4              ; in R0        
 MOV R1, #3              ; in R1
 BL Mul16b               ; start rotina
 B fim
Mul16b:
 MOV R2, R0              ; r2=r0
loop                     ; rotina ex 10
 CMP R1, #0              ; r1 compara com 0
 BEQ atualiza            ; se 0, vai para o loop de atualização
 LSRS R1, R1, #1         ; shift a dir com flag
  ITT CS                 ; caso de carry 
  LSLCS R4, R0, R3       ; shift
  ADDCS R2, R2, R4       ; add r4 no r2
 ADD R3, R3, #1          ; r3++
 B loop
atualiza
 SUBS R2, R0             ; atualiza o valor
 BX LR     
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
