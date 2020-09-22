BasicUpstart2($cc00)

    .label col=$11
    .label row=$12
    .label temp = $13
    .label playerScreenPosition = $14
    .label platerLastPosition = $16

    .label SPRITE_0_X = $d000
    .label SPRITE_0_Y = $d001
    .label JOY_PORT_2 = $dc00
    .label JOY_LT = %00100
    .label JOY_RT = %01000
    


    offset:		.byte 00
    delay:		.byte 00
    sframe:     .byte 04
    playerX:    .byte $aa
    playerY:    .byte $d0

* = $cc00

Start:

    jsr Init
    jsr DrawScreen
    jsr MainLoop

MainLoop:
    ldy #$00
    jsr WaitForFrame
    jsr ReadJoy
    jsr CheckCollisions
    jsr ScrollScreen
    jsr AnimateTurtle

    ldy #$ff
    jsr WaitForFrame

    jmp MainLoop
    rts

CheckCollisions:
    // ((playery - 50) / 8) * 40 +  ((playerx - 24) / 8)
    lda #$00
    sta playerScreenPosition
    lda #$c0
    sta playerScreenPosition + 1

    lda playerY
    sbc #50
    lsr
    lsr
    lsr
    sta temp

    ldx #40
!:
    lda playerScreenPosition
    adc temp
    sta playerScreenPosition
    lda playerScreenPosition + 1
    adc #00
    sta playerScreenPosition + 1
    dex
    bne !-

    lda playerX
    sbc #24
    lsr
    lsr
    lsr
    sta temp

    lda playerScreenPosition
    adc temp
    sta playerScreenPosition
    lda playerScreenPosition + 1
    adc #00
    sta playerScreenPosition + 1

    ldx #00
    lda (playerScreenPosition, x)

    cmp #$03
    beq !+
    lda platerLastPosition
    sta playerX
    sta SPRITE_0_X
!:
    rts
    
ReadJoy:
!Left:
    lda JOY_PORT_2
    and #JOY_LT
    bne !+
    lda playerX
    sta platerLastPosition
    dec playerX
!:

!Right:
    lda JOY_PORT_2
    and #JOY_RT
    bne !+
    lda playerX
    sta platerLastPosition
    inc playerX
!:
    lda playerX
    sta SPRITE_0_X
    rts

AnimateTurtle:
    ldy sframe
    dey
    bne !+
    ldy #04
    ldx $c3f8
    inx
    stx $c3f8
    cpx #$83
    bne !+
    ldx #$80
    stx $c3f8
!:  sty sframe
    rts

ScrollScreen:
    lda $d011
    and #%11110000
    ora offset
    sta $d011

    ldx offset
    cpx #$07
    bne !+
    ldx #00
!: 
    inx
    stx offset
    rts
    
WaitForFrame: 
    lda $d012
    sty temp
    cmp temp
    bne WaitForFrame
    rts


Init:
    // change foreground and background colors
    lda #$00
    sta $d020
    sta $d021

    //interupts
    lda #$7f
    sta $dc0d
    sta $dd0d

    // memory configuration
    lda $01
    and #%11111000
    ora #%11111101
    sta $01
    
    // enable vic bank 3
    lda $dd00
    and #%111111100
    sta $dd00

    // setup character memory and screen memory
    lda #%00001100
    sta $d018

    // point sprite
    lda #$80
    sta $c3f8

    // enable sprites
    lda #%11111111
    sta $d015

    // sprite #1 colors
    lda #BROWN
    sta $d025

    lda #BLUE
    sta $d026

    // multicolor sprites
    lda #$FF
    sta $d01c

    // sprite coordinates
    lda playerX
    sta SPRITE_0_X

    lda playerY
    sta SPRITE_0_Y
    rts

DrawScreen:    
    lda #$00
    sta row
    sta col

!RowLoop:
    lda #$00
    sta col

!ColLoop:
TILE:
    lda Map
    sta $c000

COLOR:
    lda Colors
    sta $d800

    clc
    lda TILE + 1
    adc #$01
    sta TILE + 1

    lda TILE + 2
    adc #$00
    sta TILE + 2

    clc
    lda TILE + 4
    adc #$01
    sta TILE + 4

    lda TILE + 5
    adc #$00
    sta TILE + 5

    clc
    lda COLOR + 1
    adc #$01
    sta COLOR + 1

    lda COLOR + 2
    adc #$00
    sta COLOR + 2

    clc
    lda COLOR + 4
    adc #$01
    sta COLOR + 4

    lda COLOR + 5
    adc #$00
    sta COLOR + 5

    inc col

    ldx col
    cpx #40
    bne !ColLoop-
         
    inc row

    ldx row
    cpx #25
    bne !RowLoop-
    rts
    
* = $1000
Map:
.import binary "assets/lolo/map.bin"
Colors:
.import binary "assets/lolo/colors.bin"


* = $f000 "Charset"
.import binary "assets/lolo/chars.bin"

* = $e000
.import binary "assets/sprites.bin"
