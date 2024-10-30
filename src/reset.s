.include "constants.inc"

.segment "CODE"
.import main
.export reset_handler
.proc reset_handler
  SEI
  CLD
  LDX #$40
  STX $4017
  LDX #$FF
  TXS
  INX
  STX $2000
  STX $2001
  STX $4010
  BIT $2002
vblankwait:
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; Turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; Turn on screen
  STA PPUMASK
vblankwait2:
  BIT $2002
  BPL vblankwait2
  JMP main
.endproc
