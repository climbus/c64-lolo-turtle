COLLISIONS: {
    .const MATERIAL_SOLID = $02
    .const MATERIAL_HURT = $03

    front_material: .byte 00
    left_material: .byte 00
    last_material: .byte 00
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
        tax

        // x - row number
        // y - col number
        rts
    }

    CheckCollisions: {
        // calculate row and col of player position
        .label ROW = TMP4
        .label COL = TMP5
        
        ldx #06
        ldy #43
        jsr GetCharPosition
        
        stx ROW
        stx front_row
        sty COL
        sty front_col

        jsr GetCharacterAt
        
        jsr GetMaterial
        sta front_material

        ldx #12
        ldy #43
        jsr GetCharPosition
        jsr GetCharacterAt
        //PrintDebugChar()

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
    
    PlayerBoundaries: {
        lda #$00 
        sta PLAYER.onDownLimit

        lda PLAYER.playerY
        cmp #$c0
        bcc !++
        lda PLAYER.onWall
        beq !+
        lda PLAYER.onDamage
        bne !+
        jsr PLAYER.ApplyDamage
    !:
        lda #$01
        sta PLAYER.onDownLimit
        lda #$c0
        sta PLAYER.playerY
        jmp !++
    !:
        cmp #$4f
        bcs !+
        lda #$4f
        sta PLAYER.playerY
    !:
        rts
    }

    ActFrontCollisions: {
        lda front_material
        cmp last_material
        bne !+
        sta last_material
        rts
    !:
        sta last_material
        cmp #MATERIAL_SOLID
        bne !++
        ldx front_row
        ldy front_col
        jsr LEVEL.SetTailAt

        lda PLAYER.playerScreenPosition + 1
        sbc #VIC.SCREEN_MSB
        tax
        lda PLAYER.playerScreenPosition
        jsr SOUND.Eat
        jsr GAME.ShowPoints
        jsr GAME.AddPoints
        lda GAME.energy
        cmp #$08
        bcs !+
        inc GAME.energy
    !:
        rts
    !:
        cmp #MATERIAL_HURT
        bne !++
        jsr SOUND.Water
        lda PLAYER.immCount
        bne !+
        jsr PLAYER.ApplyDamage
    !:
        rts
    !:
        lda #$00
        sta PLAYER.onWall

        lda front_material
        cmp #$01
        bne !+
        jsr SOUND.Pang
        jsr PLAYER.GoBack
    !:
        lda front_material
        cmp #$0f
        bne !+
        jsr DIALOG.ShowEnd
        lda #GAME.STATE_PAUSE
        sta GAME.state
        
        jsr PLAYER.GoToEnd
        jsr GAME.Restart     
    !:
        jsr PLAYER.ClearDamage

        lda front_material
        cmp #$08
        bne !+
        lda COUNTER
        sec
        sbc #$0f
        cmp DIALOG.lastCounter
        bcc !+
        jsr SOUND.Pause
        jsr DIALOG.ShowNext 
    !:
        rts
    }
}
