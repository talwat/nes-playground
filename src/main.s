.include "constants.inc"
.include "header.inc"

.segment "RODATA"
palettes:
.byte $29, $19, $09, $0f

sprites:
;     Y    Tile Attr X
.byte $70, $02, $00, $80
.byte $70, $04, $00, $88

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  ; Copy sprite data to OAM
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; Turn on the screen
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
  LDA #$29
  STA PPUDATA
  LDA #%00011110
  STA PPUMASK
  
  ; Write a palette
  ; Select $3f00 on the PPU
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR

load_palettes:
  ; Loop through all of the different palette colors and store them in PPUDATA.
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$04
  BNE load_palettes

  LDX #$00
load_sprites:
  ; Same for sprites
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$08
  BNE load_sprites
forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"
