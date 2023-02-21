;==================================================
; Definir nomes para os espelhamento de registros.
; Nada necessário, mas facilita a leitura do código.
;==================================================

.define XY_8BIT $10
.define A_8BIT  $20
.define Counter $13

.define BG1Hlow $1A
.define BG1Hhigh $1B
.define BG1Vlow $1C
.define BG1Vhigh $1D

.define BG2Hlow $10
.define BG2Hhigh $11
.define BG2Vlow $17
.define BG2Vhigh $18

.define BG3Hlow $1E
.define BG3Hhigh $1F
.define BG3Vlow $28
.define BG3Vhigh $29

.define ColorMath0 $15
.define ColorMath1 $16
.define Mosaico $E2
.define Brilho $E3

.define M7Rotation $36
.define M7ScallingX $38
.define M7ScallingY $3A
.define M7LayerX $44
.define M7LayerY $46

; DMA SPRITE 
;
; sta $60  = Qual frame carregar - 8 bits
.define SP1DMAframe $60
; sta $61 = Loop para carregar todas as tiles - 8 bits
.define SP1DMAloadingloop $61
; sty $62 = Offset de onde iniciar a leitura de tiles para enviar - 16 bits
.define SP1DMAsourceOffset $62
; stx $64 = Tamanho do DMA por passos (quantas tiles) - 16 bits
.define SP1DMAtilestotransfer $64
; stx $66 = Local do destino para os gráficos enviados - 16 bits
.define SP1DMAdestinoOffset $66







