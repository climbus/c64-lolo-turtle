#importonce
#import "vic.asm"

PLAYER: {
    .const PLAYER_START_X = $aa
    .const PLAYER_START_Y = $b0
    .const IMMORTALITY_TIME = $0f

    .label playerScreenPosition = $15
    
    sframe:     .byte 04
    playerX:    .byte PLAYER_START_X, 00
    playerY:    .byte PLAYER_START_Y
    onDamage:   .byte $00
    immCount:   .byte $00
    
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
        lda #IMMORTALITY_TIME
        sta immCount
        dec GAME.energy

        lda #01
        sta onDamage
        lda #01
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    ClearDamage: {
        dec immCount
        bpl !+
        lda #$00
        sta immCount
    !:
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
        sec
        sbc #$01
        sta playerX
        sta VIC.SPRITE_0_X
        lda playerX + 1
        sbc #$00
        sta playerX + 1
        bne !+
        lda #%00000000
        sta VIC.SPRITE_8_BIT
    !:
        rts
    }

    MoveRight: {
        lda playerX
        clc
        adc #$01
        sta playerX
        sta VIC.SPRITE_0_X
        lda playerX + 1
        adc #$00
        sta playerX + 1
        cmp #$01
        bne !+
        lda #%00000001
        sta VIC.SPRITE_8_BIT
    !:
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
    
    ShowToogle: {
        lda VIC.ENABLE_SPRITE_REGISTER
        eor #%00000001
        sta VIC.ENABLE_SPRITE_REGISTER
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
        ora #%00000001
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }

    AnimateTurtle: {
        ldy sframe
        dey
        bne !+++
        lda immCount
        beq !+
        .break
        jsr ShowToogle
        jmp !++
    !:
        jsr Show
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

    Die: {
        dec GAME.lives
        bpl !+
        lda #$00
        sta GAME.lives
        rts
    !:
        lda #IMMORTALITY_TIME
        sta immCount
        lda #GAME.MAX_ENERGY
        sta GAME.energy
        rts
    }
}
