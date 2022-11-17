#importonce
#import "vic.asm"

PLAYER: {
    .const PLAYER_START_X = $55
    .const PLAYER_START_Y = $b0
    .const IMMORTALITY_TIME = $0f

    .label playerScreenPosition = $15
    
    sframe:     .byte 04
    playerX:    .byte PLAYER_START_X, 00
    playerY:    .byte PLAYER_START_Y
    onDamage:   .byte $00
    immCount:   .byte $00
    onWall:     .byte $00
    onDownLimit:.byte $00
    
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
        asl
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
        lda #$01
        sta onWall
        rts
    }

    MoveLeft: {
        lda playerX
        sec
        sbc #$01
        sta playerX
        rts
    }

    MoveRight: {
        lda playerX
        clc
        adc #$01
        sta playerX
        rts
    }

    MoveUp: {
        lda onWall
        bne !+
        dec playerY
        lda playerY
        sta VIC.SPRITE_0_Y
    !:
        rts
    }

    MoveDown: {
        lda onDownLimit
        bne !+
        inc playerY
        lda playerY
        sta VIC.SPRITE_0_Y
    !:
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
        lda playerX
        asl
        sta VIC.SPRITE_0_X
        bcc !+
        lda VIC.SPRITE_8_BIT
        ora #%00000001
        jmp !++
    !:
        lda VIC.SPRITE_8_BIT
        and #%11111110
    !:
        sta VIC.SPRITE_8_BIT

        lda onWall
        beq !+
        inc playerY
        inc playerY
        inc playerY
        lda playerY
        sta VIC.SPRITE_0_Y
    !:

        ldy sframe
        dey
        bne !End+
        lda immCount
        beq !+
        jsr ShowToogle
        jmp !++
    !:
        jsr Show
    !:
        ldy #04
        ldx VIC.SCREEN_RAM + $3f8
        inx
        stx VIC.SCREEN_RAM + $3f8
        stx VIC.SCREEN_RAM2 + $3f8
        cpx #$83
        bne !End+
        ldx #$80
        stx VIC.SCREEN_RAM + $3f8
        stx VIC.SCREEN_RAM2 + $3f8
    !End:  
        sty sframe
        rts
    }

    Die: {
        jsr SOUND.Dead
        ldx #$83
    !:
        stx VIC.SCREEN_RAM + $3f8
        stx VIC.SCREEN_RAM2 + $3f8
        inx
    !:
        ldy #$00
        jsr VIC.WaitForFrame
        inc COUNTER
        lda COUNTER
        and #%00001111
        bne !-
        cpx #$86
        bne !--

    !:
        ldy #$00
        jsr VIC.WaitForFrame
        inc COUNTER
        lda COUNTER
        and #%00011111
        bne !-

        dec GAME.lives
        bpl !+
        lda #$00
        sta GAME.lives
        rts
    !:
        lda #$80
        sta VIC.SCREEN_RAM + $3f8
        sta VIC.SCREEN_RAM2 + $3f8
        lda #PLAYER_START_X
        sta playerX

        lda #$e0
        sta playerY
        sta VIC.SPRITE_0_Y
    !:
        jsr AnimateTurtle
        ldy #$00
        jsr VIC.WaitForFrame
        inc COUNTER
        lda COUNTER
        and #%00000011
        bne !-
        ldx playerY
        dex
        stx playerY
        stx VIC.SPRITE_0_Y
        cpx #PLAYER_START_Y
        bcs !-

        lda #IMMORTALITY_TIME
        sta immCount
        lda #GAME.MAX_ENERGY
        sta GAME.energy
        rts
    }

    GoToEnd: {
    !StartLoop:
        ldy #$00
        jsr VIC.WaitForFrame

        inc COUNTER
        lda COUNTER
        and #%00000011
        bne !EndLoop+
        jsr AnimateTurtle
        lda playerX
        cmp #PLAYER_START_X
        beq !SkipX+
        bcc !+
        jsr MoveLeft
    !:
        jsr MoveRight
    !SkipX:
        jsr MoveUp
    !EndLoop:
        bne !StartLoop-
        rts
    }
}
