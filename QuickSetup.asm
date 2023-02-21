;------------------------------------------------------------------------
;-  Written by: Neviksti
;-     If you use my code, please share your creations with me
;-     as I am always curious :)
;------------------------------------------------------------------------
      
.BANK 0 SLOT 0
.ORG HEADER_OFF
.SECTION "QuickCodeSection" SEMIFREE
		

VBlank:
	rep #$30		;A/Mem=16bits, X/Y=16bits
	phb
	pha
	phx
	phy
	phd

	sep #$20		; mem/A = 8 bit, X/Y = 16 bit


	;*********transfer BG3 data
	LDA #$00
	STA $2115		;set up VRAM write to write only the lower byte

	LDX #$0400
	STX $2116		;set VRAM address to BG3 tile map

	LDY #$1800
	STY $4300		; CPU -> PPU, auto increment, write 1 reg, $2118 (Lowbyte of VRAM write)
	LDY #$0000
	STY $4302		; source offset
	LDY #$0400
	STY $4305		; number of bytes to transfer
	LDA #$7F
	STA $4304		; bank address = $7F  (work RAM)
	LDA #$01
	STA $420B		;start DMA transfer

	;update the joypad data
	JSR GetInput

	lda $4210		;clear NMI Flag

	REP #$30		;A/Mem=16bits, X/Y=16bits
	
	inc $12

	PLD 
	PLY 
	PLX 
	PLA 
	PLB 
      RTI

;============================================================================

QuickSetup:
	php

	rep #$10		;A/mem = 8bit, X/Y=16bit
	sep #$20

	;Load palette to make our pictures look correct
	LoadPalette	BG_Palette

	;Load Tile and Character data to VRAM
	LoadBlockToVRAM	ASCIITiles, $0000, $0800	;128 tiles * (2bit color = 2 planes) --> 2048 bytes

	;Set the priority bit of all the BG3 tiles
	LDA #$80
	STA $2115		;set up the VRAM so we can write just to the high byte
	LDX #$0400
	STX $2116
	LDX #$0400		;32x32 tiles = 1024
	LDA #$20
__next_tile:
	STA $2119
	DEX
	BNE __next_tile

    
	lda #$01		;Set video mode 1, 8x8 tiles (16 color BG1 + BG2, 4 color BG3)
      sta $2105         

	lda #$08		;Set BG1's Tile Map VRAM offset to $0800 (word address)
      sta $2107		;   and the Tile Map size to 32 tiles x 32 tiles

	lda #$0C		;Set BG2's Tile Map VRAM offset to $0C00 (word address)
      sta $2108		;   and the Tile Map size to 32 tiles x 32 tiles

	lda #$04		;Set BG3's Tile Map VRAM offset to $0400 (word address)
      sta $2109		;   and the Tile Map size to 32 tiles x 32 tiles

	lda #$41		;Set BG1's Character VRAM offset to $1000 (word address)
      sta $210B		;Set BG2's Character VRAM offset to $4000 (word address)

	lda #$00		;Set BG3's Character VRAM offset to $0000 (word address)
      sta $210C		;


	lda #$07		;Turn on BG1 and BG2 and BG3
      sta $212C

	lda #$FF		;Scroll BG3 down 1 pixel
	sta $2112
	sta $2112         

      lda #$0F		;Turn on screen, full brightness
      sta $2100		

	plp
	rts

.ENDS

;==========================================================================================

.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

BG_Palette:
	.INCBIN ".\\Pictures\\ascii.clr"
	.REPT 128
	.DW 0
	.ENDR

ASCIITiles:
	.INCBIN ".\\Pictures\\ascii.pic"

.ENDS

;==========================================================================================
