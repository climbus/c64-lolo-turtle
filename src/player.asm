#importonce
#import "vic.asm"

PLAYER: {
    .label playerScreenPosition = $15
    .label platerLastPosition = $17
    
    sframe:     .byte 04
    playerX:    .byte $aa
    playerY:    .byte $d0
    
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
        lda playerX
        sta VIC.SPRITE_0_X

        lda playerY
        sta VIC.SPRITE_0_Y

        lda #200
        sta VIC.SPRITE_1_X
        sta VIC.SPRITE_1_Y
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


    AnimateTurtle: {
        ldy sframe
        dey
        bne !+
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