.import source "vic.asm"
.import source "player.asm"
.import source "apples.asm"
.import source "controls.asm"


GAME: {
    .label col=$11
    .label row=$12
    .label temp = $13
    points: .byte 00
    offset:	.byte 00

    Init: {
        sei
        // change foreground and background colors
        lda #$00
        sta $d020
        sta $d021

        // extended color mode
        lda VIC.SCROLL_REGISTER
        ora #%01001000
        sta VIC.SCROLL_REGISTER

        // set road background color
        lda #$0c
        sta $d022

        // //interupts
        lda #$7f
        sta $dc0d
        sta $dd0d

        // memory configuration
        lda $01
        and #%11111000
        ora #%11111101
        sta $01
        
        // enable vic bank 1
        lda $dd00
        and #%11111110
        sta $dd00

        // setup character memory and screen memory
        lda #%00001100
        sta $d018
        jsr PLAYER.Init
        jsr APPLES.init
        cli
        rts
    }

    DrawScreen: {   
        lda #$00
        sta row
        sta col

    !RowLoop:
        lda #$00
        sta col

    !ColLoop:
    TILE:
        lda Map
        sta VIC.SCREEN_RAM

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
        inx
        cpx #$28
        bne !-
        rts
    }

    CheckCollisions: {
        // ((playery - 50) / 8) * 40 +  ((playerx - 24) / 8)
        lda #$00
        sta PLAYER.playerScreenPosition
        lda #VIC.SCREEN_MSB
        sta PLAYER.playerScreenPosition + 1

        lda PLAYER.playerY
        sbc #50
        lsr
        lsr
        lsr
        sta temp

        ldx #40
    !:
        lda PLAYER.playerScreenPosition
        adc temp
        sta PLAYER.playerScreenPosition
        lda PLAYER.playerScreenPosition + 1
        adc #00
        sta PLAYER.playerScreenPosition + 1
        dex
        bne !-

        lda PLAYER.playerX
        sbc #24
        lsr
        lsr
        lsr
        sta temp

        lda PLAYER.playerScreenPosition
        adc temp
        sta PLAYER.playerScreenPosition
        lda PLAYER.playerScreenPosition + 1
        adc #00
        sta PLAYER.playerScreenPosition + 1

        ldx #00
        lda (PLAYER.playerScreenPosition, x)

        cmp #$4e
        bne !+
            lda PLAYER.playerScreenPosition + 1
            sbc #VIC.SCREEN_MSB
            tax
            lda PLAYER.playerScreenPosition
            jsr APPLES.remove
            jsr ShowPoints
            rts
    !:
        cmp #$03
        beq !+
        lda PLAYER.platerLastPosition
        sta PLAYER.playerX
        sta VIC.SPRITE_0_X
        rts
    !:
        rts
    }

    MainLoop: {
        ldy #$00
        jsr VIC.WaitForFrame
        jsr CONTROLS.ReadJoy
        jsr CheckCollisions
        jsr ScrollScreen
        jsr APPLES.draw
        jsr PLAYER.AnimateTurtle
        jsr HidePoints
    

        ldy #$ff
        jsr VIC.WaitForFrame
        jmp MainLoop
        rts
    }

    ShowPoints: {
        lda PLAYER.playerX
        adc #20
        sta VIC.SPRITE_1_X
        lda PLAYER.playerY
        sbc #15
        sta VIC.SPRITE_1_Y
        lda VIC.ENABLE_SPRITE_REGISTER
        ora #%00000010
        sta VIC.ENABLE_SPRITE_REGISTER
        lda #20
        sta points
        rts
    }

    HidePoints: {
        ldx points
        cpx #$00
        beq !+
            dex
            stx points
            rts
    !:
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }
    ScrollScreen: {
        // hardware scroll
        lda VIC.SCROLL_REGISTER
        and #%11110000
        ora offset
        sta VIC.SCROLL_REGISTER

        ldx offset
        cpx #$01
        bne !+
        jsr APPLES.check_last
        jsr APPLES.move
        jsr APPLES.GrabNew
    !:  
        ldx offset
        cpx #$07
        bne !+
        ldx #00
        inc APPLES.counter
    !:
        inx
        stx offset 
        rts
    }
    Map:
    .import binary "assets/map.bin"

    Colors:
    .import binary "assets/colors.bin"
}