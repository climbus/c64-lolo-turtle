BasicUpstart2($cc00)

    .label col=$11
    .label row=$12
    .label temp = $13
    .label playerScreenPosition = $15
    .label platerLastPosition = $17
    .label bufferAddress = $19

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
    counter:    .byte 00
    currentA:   .byte 00
    stack:      .byte 00
    appleslen:  .byte 00

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
    jsr APPLES.draw
    jsr AnimateTurtle

    ldy #$ff
    jsr WaitForFrame
    jmp MainLoop
    rts
  
GrabNew:
    // check if new apple available
    ldy counter
    lda WaitingApples,y
    cmp #$ff
    bne !+
    ldy #$ff
    sty counter
    jsr APPLES.shift
    rts
!:
    cmp #$00
    beq !+
        jsr APPLES.add
!:
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
    // hardware scroll
    lda $d011
    and #%11110000
    ora offset
    sta $d011

    ldx offset
    cpx #$01
    bne !+
    jsr APPLES.check_last
    jsr APPLES.move
    jsr GrabNew
!:  
    ldx offset
    cpx #$07
    bne !+
    ldx #00
    inc counter
!:
    inx
    stx offset 
    rts

SwitchBuffer:
    lda bufferAddress + 1
    cmp #$c0
    bne !+
    lda #%00001100                                                            
    sta $d018
  
    lda #$c4
    sta bufferAddress + 1
    rts
!:
    lda #%00011100 
    sta $d018
    
    lda #$c0
    sta bufferAddress + 1
    rts
    
MoveBuffer:
    lda #12
    sta row
    lda #20
    sta col

    sta BUFFER + 1
    adc #$28
    sta BUFFER + 4

    
    lda bufferAddress + 1 //c0, c4
    sta BUFFER + 5
    cmp #$c4
    beq !+
    lda #$c4
    jmp !++
!:
    lda #$c0
!:
    sta BUFFER + 2 //c4, c0

    
!RowLoop:
    lda #$00
    sta col

!ColLoop:
BUFFER:
    lda $c400
    sta $c428
    
    clc
    lda BUFFER + 1
    adc #$01
    sta BUFFER + 1

    lda BUFFER + 2
    adc #$00
    sta BUFFER + 2

    clc
    lda BUFFER + 4
    adc #$01
    sta BUFFER + 4

    lda BUFFER + 5
    adc #$00
    sta BUFFER + 5

    inc col
    ldx col
    cpx #40
    bne !ColLoop-
         
    inc row

    ldx row
    cpx #24
    bne !RowLoop-
    rts
    
WaitForFrame: 
    lda $d012
    sty temp
    cmp temp
    bne WaitForFrame
    rts


Init:
    sei
    // change foreground and background colors
    lda #$00
    sta $d020
    sta $d021

    // extended color mode
    lda $d011
    ora #%01000000
    sta $d011

    // set road background color
    lda #$0c
    sta $d022

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
    lda $dd00ff
    // setup character memory and screen memory
    lda #%00001100
    sta $d018

    // point sprite
    lda #$80
    sta $c3f8
    sta $c7f8

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

    lda #$00
    sta bufferAddress
    lda #$c4
    sta bufferAddress + 1
    cli
    jsr APPLES.init
    // lda #$0c
    // ldx #$00
    // jsr APPLES.add
    // lda #$11
    // ldx #$00
    // jsr APPLES.add
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

    ldx #$00
!:
    lda Map, x
    sta $c400,x
    inx
    cpx #$28
    bne !-
    rts
    
* = $1000
Map:
.import binary "assets/lolo/map.bin"
Colors:
.import binary "assets/lolo/colors.bin"

.import source "apples.asm"

Apples:
    .byte 00

WaitingApples:
    .byte 00, 00, $11, 00, $11, $00, $00, $00, $0c, $00, $00, $0d, $1a, $00, $00, $1c, $00, $00, $00, $12, $00, $10, $00, $ff, $0d, $11, 00, $10, $ff, 00, $11, 00, 00, 00, 00, 00, 00, $1a, 00, 00, 00, 00, $11, 00, 00, $0c, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, $ff
* = $f000 "Charset"
.import binary "assets/lolo/chars.bin"

* = $e000
.import binary "assets/sprites.bin"
