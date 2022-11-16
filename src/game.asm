#import "level.asm"
* = $2000 "Program CD" 
#import "collisions.asm"
#import "controls.asm"
#import "sound.asm"
#import "irq.asm"


GAME: {
    .label MAX_ENERGY = $08
    .label MAX_LIVES = $03

    .label STATE_RUN = $01
    .label STATE_PAUSE = $02
    .label STATE_END = $04

    showPointsCounter: .byte 00
    points: .byte 00, 00, 00, 00
    energy: .byte $0f
    lives: .byte 00
    state: .byte 00

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
        EnableMulticolorMode()

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
 
        cli
        lda #MAX_ENERGY
        sta energy
        lda #MAX_LIVES
        sta lives

        lda #$00
        sta DIALOG.lastCounter 
        
        lda #$00
        sta points
        sta points + 1
        sta points + 2
        sta points + 3
        rts
    }

    MainLoop: {
        ldy #$00
        jsr VIC.WaitForFrame
        
        jsr CONTROLS.ReadJoy
        jsr COLLISIONS.CheckCollisions
        jsr COLLISIONS.ActFrontCollisions
        jsr COLLISIONS.PlayerBoundaries
        
        lda state
        cmp STATE_END
        bne !+
        rts
    !:
        jsr PLAYER.AnimateTurtle
        jsr HidePoints

        inc COUNTER
        lda COUNTER
        and #$3f
        bne !+
        dec energy
    !:

        lda COUNTER
        and #$03
        bne !+
        jsr PLAYER.ClearDamage
    !:
        jsr HUD.ShowPoints
        jsr HUD.ShowEnergy
        jsr HUD.ShowLives
       
        lda lives
        bne !+
        jsr Restart
    !:

        lda energy
        bne !+
        jsr PLAYER.Die
    !:
        lda COUNTER
        bne !+
        sta DIALOG.lastCounter
    !:
        jmp MainLoop
    
        rts
    }

    Restart: {
        //jsr IRQ.ScrollStop
        lda #$01
        sta $d01a     // enable VIC-II Raster Beam IRQ

        jsr CONTROLS.WaitForFire
        
        lda STATE_END
        sta state
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
        lda points + 3
        adc #00
        sta points + 3
        rts
    }

    ShowPoints: {
        lda PLAYER.playerX
        asl
        sta VIC.SPRITE_1_X
        bcc !+
        sec
        sbc #20
        sta VIC.SPRITE_1_X
        lda VIC.SPRITE_8_BIT
        ora #%00000010
        jmp !+++
    !:
        clc
        adc #20
        sta VIC.SPRITE_1_X
        bcc !+
        lda VIC.SPRITE_8_BIT
        ora #%00000010
        jmp !++
    !:
        lda VIC.SPRITE_8_BIT
        and #%11111101
    !:
        sta VIC.SPRITE_8_BIT

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
        beq !++
            txa
            and #$01
            bne !+
            inc $d028
        !:
            dex
            stx showPointsCounter
            rts
    !:
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    EndLevel: {
        jsr DIALOG.ShowEnd
        lda #GAME.STATE_PAUSE
        sta GAME.state
        
        jsr PLAYER.GoToEnd

        jsr CONTROLS.WaitForFire
        
        jsr Screen.Init
        jsr LEVEL.DrawNext     
        jsr PLAYER.Init
        
        jsr DIALOG.ShowGetReady
        rts
    }

}

EatSFX:
    .import binary "assets/test.bin"
PangSFX:
    .import binary "assets/pang.bin"

PauseSnd:
    .byte 00, 00
