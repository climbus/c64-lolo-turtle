BasicUpstart2(Start)

    .label col=$11
    .label row=$12
    .label temp = $13
    .label playerScreenPosition = $15
    .label platerLastPosition = $17
    .label bufferAddress = $19

    .label SPRITE_0_X = $d000
    .label SPRITE_0_Y = $d001
    .label SPRITE_1_X = $d002
    .label SPRITE_1_Y = $d003
    
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
    points:     .byte 00
    
.import source "apples.asm"

Map:
.import binary "assets/map.bin"

Colors:
.import binary "assets/colors.bin"

Apples:
    .byte 00

WaitingApples:
    .byte 00, 00, 00, $11, 00, $00, $00, $00, $0c, $00, $00, $00, $00, $00, $0c, $0d, $12, $00, $00, $1c, $00, $00, $00, $12, $00, $10, $00, $ff

Start:
    jsr Init
    jsr DrawScreen
    jsr MainLoop
    rts
    

MainLoop:
    ldy #$00
    jsr WaitForFrame
    jsr ReadJoy
    jsr CheckCollisions
    jsr ScrollScreen
    jsr APPLES.draw
    jsr AnimateTurtle
    jsr HidePoints

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

    cmp #$4e
    bne !+
        lda playerScreenPosition + 1
        sbc #$c0
        tax
        lda playerScreenPosition
        jsr APPLES.remove
        jsr ShowPoints
        rts
!:
    cmp #$03
    beq !+
    lda platerLastPosition
    sta playerX
    sta SPRITE_0_X
    rts
!:
    rts

ShowPoints:
    lda playerX
    adc #20
    sta SPRITE_1_X
    lda playerY
    sbc #15
    sta SPRITE_1_Y
    lda $d015
    ora #%00000010
    sta $d015
    lda #20
    sta points
    rts

HidePoints:
    ldx points
    cpx #$00
    beq !+
        dex
        stx points
        rts
!:
    lda $d015
    and #%11111101
    sta $d015
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
    lda $dd00
    and #%111111100
    sta $dd00

    // setup character memory and screen memory
    lda #%00001100
    sta $d018

    // point sprites
    lda #$80
    sta $c3f8
    sta $c7f8

    lda #$88
    sta $c3f9
    sta $c7f9

    // enable sprites
    lda #%11111101
    sta $d015

    // sprite #1 colors
    lda #BROWN
    sta $d025

    lda #BLUE
    sta $d026

    lda #YELLOW
    sta $d028

    // multicolor sprites
    lda #%10000001
    sta $d01c

    // sprite coordinates
    lda playerX
    sta SPRITE_0_X

    lda playerY
    sta SPRITE_0_Y

    lda #200
    sta SPRITE_1_X
    sta SPRITE_1_Y

    jsr APPLES.init
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

* = $f000 "Charset"
.import binary "assets/chars.bin"

* = $e000
.import binary "assets/sprites.bin"
