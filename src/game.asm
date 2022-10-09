#import "vic.asm"
#import "level.asm"
#import "player.asm"
#import "collisions.asm"
#import "apples.asm"
#import "controls.asm"
#import "irq.asm"


GAME: {

    showPointsCounter: .byte 00
    points: .byte 00, 00, 00

    Init: {

        sei
        // change foreground and background colors
        lda #$00
        sta VIC.FOREGROUND_COLOR
        lda #$08
        sta VIC.BACKGROUND_COLOR

        lda $d011
        and #%10110111
        sta $d011
        // multicolor color mode
        lda $d016
        ora #%00010000
        sta $d016

        // set road background color
        lda #$0b
        sta VIC.EXTRA_BACKGROUND_COLOR
        lda #$07
        sta VIC.EXTRA_BACKGROUND_COLOR2


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

    AddPoints: {
        clc
        lda points
        adc #100
        sta points
        lda points + 1
        adc #00
        sta points + 1
        lda points + 2
        adc #00
        sta points + 2
        rts
    }

    MainLoop: {
        ldy #$00
        jsr VIC.WaitForFrame
        
        jsr CONTROLS.ReadJoy
        jsr COLLISIONS.CheckCollisions
        jsr COLLISIONS.ActFrontCollisions
        
        jsr PLAYER.AnimateTurtle
        jsr HidePoints
        
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
        sta showPointsCounter
        rts
    }

    HidePoints: {
        ldx showPointsCounter
        cpx #$00
        beq !+
            dex
            stx showPointsCounter
            rts
    !:
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }
}

