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
    jsr DrawApples
    jsr AnimateTurtle

    ldy #$ff
    jsr WaitForFrame
    inc counter
    jmp MainLoop
    rts

MoveApples:
    ldx #00
    ldy #00
!Loop:
    lda Apples,x
    sta temp
    lda Apples+1,x
    clc
    adc #$c0
    sta temp + 1
    lda #$03
    sta (temp),y

    lda Apples+1,x
    clc
    adc #$d8
    sta temp + 1
    lda #$cc
    sta (temp),y

    clc
    lda Apples,x
    cmp #$ff
    beq !++
    adc #$28
    sta Apples,x
    lda Apples+1,x
    adc #00
    sta Apples+1,x
    cmp #$03
    bne !+
    lda Apples,x
    cmp #$e8
    bcc !+
    lda #$ff
    sta Apples,x
!:
    inx
    inx
    jmp !Loop-
!:
    rts
    
DrawApples:
    ldy #00
    ldx #00
!Loop:
    lda Apples,x
    sta temp
    lda Apples+1,x
    clc
    adc #$c0
    sta temp + 1
    lda #$0e
    ora #%01000000
    sta (temp),y
    lda Apples+1,x
    clc
    adc #$d8
    sta temp + 1
    lda #$02
    sta (temp),y
    inx
    inx
    lda Apples,x
    cmp #$ff
    bne !Loop-
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
    jsr MoveApples
!:  
    ldx offset
    cpx #$07
    bne !+
    ldx #00
    
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
    lda $dd00
    and #%111111100
    sta $dd00

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
Apples:
    .byte $b0, $00, $a5, $01, $ff, 00

* = $f000 "Charset"
.import binary "assets/lolo/chars.bin"

* = $e000
.import binary "assets/sprites.bin"
