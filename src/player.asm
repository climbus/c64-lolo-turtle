#importonce
#import "vic.asm"

PLAYER: {
    .const PLAYER_START_X = $aa
    .const PLAYER_START_Y = $b0
    .label playerScreenPosition = $15
    .label platerLastPosition = $17
    
    sframe:     .byte 04
    playerX:    .byte PLAYER_START_X
    playerY:    .byte PLAYER_START_Y
    onDamage:   .byte $00
    
    Init: {
    // point sprites
        lda #$80
        sta VIC.SCREEN_RAM + $3f8
        sta VIC.SCREEN_RAM + $7f8

        lda #$88
        sta VIC.SCREEN_RAM + $3f9
        sta VIC.SCREEN_RAM + $7f9

        // enable sprites
        lda #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER

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
        
        lda #PLAYER_START_X
        sta playerX
        sta VIC.SPRITE_0_X

        lda #PLAYER_START_Y
        sta playerY
        sta VIC.SPRITE_0_Y

        lda #200
        sta VIC.SPRITE_1_X
        sta VIC.SPRITE_1_Y
        rts
    }
    
    ApplyDamage: {
        lda #01
        sta onDamage
        lda #01
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    ClearDamage: {
        lda #00
        sta onDamage
        rts
    
    }

    GoBack: {
        inc playerY
        lda playerY
        sta VIC.SPRITE_0_Y
        rts
    }

    MoveLeft: {
        lda playerX
        sta platerLastPosition
        dec playerX
        lda playerX
        sta VIC.SPRITE_0_X
        rts
    }

    MoveRight: {
        lda playerX
        sta platerLastPosition
        inc playerX
        lda playerX
        sta VIC.SPRITE_0_X
        rts
    }

    MoveUp: {
        dec playerY
        lda playerY
        sta VIC.SPRITE_0_Y
        rts
    }

    MoveDown: {
        inc playerY
        lda playerY
        sta VIC.SPRITE_0_Y
        rts
    }
    Hide: {
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111110
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    Show: {
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111111
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    AnimateTurtle: {
        ldy sframe
        dey
        bne !+++
        lda onDamage
        bne !+
        jsr Show
        jmp !++
    !:
        jsr Hide
    !:
        ldy #04
        ldx VIC.SCREEN_RAM + $3f8
        inx
        stx VIC.SCREEN_RAM + $3f8
        cpx #$83
        bne !+
        ldx #$80
        stx VIC.SCREEN_RAM + $3f8
    !:  sty sframe
        rts
    }
}
