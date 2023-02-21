
Inimigo1:

LDA $07C0   ; Não processa sprite 
CMP #$01
BNE +
RTS
+
LDA $07C0   ; Inicia processo de matar sprite 
CMP #$02
BNE +
BRL morreu
+

LDA #$C0
STA $03C0

LDA #$60
INC $03C1

lda #%00110111   ; vhoopppc    v: vertical flip h: horizontal flip  o: priority bits p: palette c:GFX page
STA $03C3          ; seta apenas o que for 1 em A para a RAM TSB

lda.b #%01010110  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
sta $050C

;Acompanha layer 1
LDA $03C0
rep #$20
sec 
sbc BG1Hlow
sep #$20
STA $03C0




;Animatione
LDA $13
and #%00000100
beq +
lda #$00
sta $03C2           ; Starting tile #
BRA ++
+
lda #$04
sta $03C2           ; Starting tile #
++

RTS

morreu:

; Chama explosão
LDX $03C0
JSR ExplosaoPos

; Exclui sprite
lda.b #%00000001  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
TSB $050C
LDA #$80
STA $03C0
LDA #$01
STA $07C0

RTS



;===================================
;Explosão
;===================================
; Posição
ExplosaoPos:

STX $03B0

LDA #$01
STA $07B0 ; Ativar rotina de animação da explosão 
-
RTS

;====================
;Animação da explosão
;====================
Explosao:

LDA $07B0
Beq -

LDA $13
AND #$01
Beq +
BRA -
+

INC $07B1  ; counter da animação

; frame 1
LDA $07B1
CMP #$02
bpl +

LDA #$C0
STA $03B2           ; Starting tile #
LDA #%00111000
STA $03B3   ; vhoopppc    v: vertical flip h: horizontal flip  o: priority bits p: palette c:GFX page
lda.b #%00000010  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
TSB $050B ; 1 32X32
lda.b #%00000001  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
TRB $050B ; 1 32X32

LDX #$0080  ; 32 pixels
STX $0720   ; Tamanho das transferências
LDX #$0000
STX $0722
jmp DyRAM1
+

; frame 2
LDA $07B1
CMP #$03
bpl +

LDX #$0080  ; 32 pixels
STX $0720   ; Tamanho das transferências
LDX #$0080
STX $0722
jmp DyRAM1
+

; frame 3
LDA $07B1
CMP #$04
bpl +

LDX #$0080  ; 32 pixels
STX $0720   ; Tamanho das transferências
LDX #$0100
STX $0722
jmp DyRAM1
+

; frame 4
LDA $07B1
CMP #$05
bpl +
LDA $03B0
SEC 
SBC #$10
STA $03B0

LDX #$0000
LDY #$0000
LDA #$C0
STA $436B

PHD
LDA #$03
XBA
LDA #$00
TCD        ; DP é 0300
-
LDA $B0
CLC 
ADC ExplosaoFrames4spritesH,y
STA $B0,x
LDA $B1
CLC 
ADC ExplosaoFrames4spritesV,y
STA $B1,x

LDA StartingTileANIME,Y
CLC 
ADC $436B
STA $B2,x           ; Starting tile #

LDA #%00111000
STA $B3,x   ; vhoopppc    v: vertical flip h: horizontal flip  o: priority bits p: palette c:GFX page
INX
INX
INX
INX
INY
CPY #$0004
BNE -
PLD      ; Volta o DP anterior

lda.b #%10101010  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
STA $050B ; 1 32X32

LDX #$0200  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$0800
STX $0722   ; Offset da source
jmp DyRAM1
+

; frame 5
LDA $07B1
CMP #$06
bpl +
LDX #$0200  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$1000
STX $0722   ; Offset da source
jmp DyRAM1
+

; frame 6
LDA $07B1
CMP #$07
bpl +
LDX #$0200  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$1800
STX $0722   ; Offset da source
jmp DyRAM1
+

; frame 7
LDA $07B1
CMP #$08
bpl +
LDX #$0200  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$2000
STX $0722   ; Offset da source
jmp DyRAM1
+

; frame 8
LDA $07B1
CMP #$09
bpl +
LDX #$0200  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$2800
STX $0722   ; Offset da source
jmp DyRAM1
+

; frame 9
LDA $07B1
CMP #$0A
bpl +
LDX #$01E0  ; 128 pixels
STX $0720   ; Tamanho das transferências
LDX #$3000
STX $0722   ; Offset da source
jmp DyRAM1
+

; FIM TESTE
LDA $07B1
CMP #$0B
bpl +

lda.b #%01010101  ; bit zero é o 9 bit (sprite fora da tela) e bit 1 é tamanho de sprite. 
TSB $050B
LDA #$80
STA $03B0
STA $03B4
STA $03B8
STA $03BC
LDX #$0000
STX $07B0  ;Não processar mais o sprite 
+

rts
;SourceOffsetExplosao1:
;.db $0180 $0800 $0880 $0900 

StartingTileANIME:
.db $00 $04 $08 $0C 

ExplosaoFrames4spritesH:
.db $00 $20 $00 $20 
ExplosaoFrames4spritesV:
.db $00 $00 $e0 $e0 

;======================
; Setup para DMA de sprite de 32 pixels verticais.
; Aqui há uma tabela que será mandada para a RAM e depois usada pelo DMA.
;======================
DyRAM1:

LDA #$07
XBA
LDA #$00
TCD        ; DP é 0700

LDA #$C2
STA $30  ; Banco de origem

lda #$08
sta $31  ; Quantas vezes repetir DMA 

REP #$20

LDY #$0000
LDX #$0008
-
LDA.w Sprite32dmaVRAM,x
clc
ADC #$6C00       ; Inserir local da VRAM para escrever
STA $00,x ; VRAM
INY
INY
DEX
DEX
BPL -

LDY #$0000
LDX #$0008
-
LDA.w Sprite32dmaORIGEM,x
CLC
ADC #DMAExplosao
CLC 
ADC $22
STA $10,x ; Adress where our data is.
INY
INY
DEX
DEX
BPL -
SEP #$20


;======================
; DMA em 4 passos para completar um sprite com 32 pixels verticais
;======================

REP #$20
LDA #$4300   ; Direct page agora são os registros de DMA  
TCD
SEP #$20

LDA #$80            ; \ Increase on $2119 write.
STA $2115           ; /
	
LDX $0731   ; Counter de repetições + número de offset dos endereços 
DEX
DEX 

LDA #$01
STA $00    ; ...2 regs write once. (4300)
LDA #$18
STA $01    ; Writing to $2118 AND $2119. (4301)
LDA $0730
STA $04      ; Bank where our data is. (4304)
-
LDY $0700,x
STY $2116    ; Local da VRAM
LDY $0710,x
STY $02      ; Adress where our data is. (4302)
LDY $0720
STY $05      ; Size of our data. (4305)
LDA #$01
STA $420B    ; Iniciar DMA canal 0
DEX
DEX
BPL -

REP #$20
LDA #$0000  
TCD
SEP #$20

RTS

