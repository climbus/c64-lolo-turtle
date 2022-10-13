COLLISIONS: {
    .const MATERIAL_SOLID = $02
    .const MATERIAL_HURT = $03

    front_material: .byte 00
    left_material: .byte 00
    right_material: .byte 00
    front_row: .byte 00
    front_col: .byte 00

    GetCharPosition: {
        // x - x offset
        // y - y offset
        .label OFFSET_X = TMP2
        .label OFFSET_Y = TMP3
        stx OFFSET_X
        sty OFFSET_Y
        lda PLAYER.playerY
        sec
        sbc OFFSET_Y
        lsr
        lsr
        lsr
        tay
        
        lda PLAYER.playerX
        sec
        sbc OFFSET_X
        lsr
        lsr
        lsr
        tax

        // x - row number
        // y - col number
        rts
    }

    CheckCollisions: {
        // calculate row and col of player position
        .label ROW = TMP2
        .label COL = TMP3
        
        ldx #16
        ldy #44
        jsr GetCharPosition
        
        stx ROW
        stx front_row
        sty COL
        sty front_col

        jsr GetCharacterAt

        // debug ////
        // lda #$c0
        // sta (PLAYER.playerScreenPosition),y
        // iny
        // sta (PLAYER.playerScreenPosition),y
        // ////////////
        
        jsr GetMaterial
        sta front_material
       

        ldx #26
        ldy #43
        jsr GetCharPosition
        jsr GetCharacterAt

        jsr GetMaterial
        sta left_material

        ldx #00
        ldy #43
        jsr GetCharPosition
        jsr GetCharacterAt
        jsr GetMaterial
        sta right_material
        rts
    }

    GetCharacterAt: {
        // x - row position
        // y - col position
        lda VIC.ScreenRowLSB,y
        sta PLAYER.playerScreenPosition
        LoadScreenMSB()
        sta PLAYER.playerScreenPosition+1

        txa
        tay
        lda (PLAYER.playerScreenPosition),y
        // a - character
        rts
    }
    
    GetMaterial: {
        // a - character
        tax
        lda Colors,x
        and #%11110000
        lsr
        lsr
        lsr
        lsr
        // a - material number
        rts
    }

    ActFrontCollisions: {
        lda front_material
        cmp #MATERIAL_SOLID
        bne !+
        ldx front_row
        ldy front_col
        jsr LEVEL.SetTailAt

        lda PLAYER.playerScreenPosition + 1
        sbc #VIC.SCREEN_MSB
        tax
        lda PLAYER.playerScreenPosition
        jsr GAME.ShowPoints
        jsr GAME.AddPoints
        inc GAME.energy
        rts
    !:
        cmp #MATERIAL_HURT
        bne !+
        jsr PLAYER.ApplyDamage
        rts
    !:
        cmp #$01
        bne !+
        jsr PLAYER.GoBack
    !:
        jsr PLAYER.ClearDamage
        rts
    }
}
