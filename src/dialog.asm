DIALOG: {
    .const DEFAULT_ROW = 4
    .const DEFAULT_COL = 12
    .const DEFAULT_TEXT_LEN = 14
    
    .label FRAME_UL = $9a
    .label FRAME_DL = $9f
    .label FRAME_UR = $9d
    .label FRAME_DR = $a1
    .label FRAME_U = $9b
    .label FRAME_D = $a0
    .label FRAME_L = $9c
    .label FRAME_R = $9e
    .label DIALOG_COLOR = $01

    .label textPtr = TMP2 
    .label screenPtr = TMP4
    .label bufferPtr = TMP8
    .label colorPtr = TMP6
    .label textPos = $00
    
    textLen:     .byte $00
    currentText: .word $0000
    lastCounter: .byte 00
    lines:       .byte 00

    DrawChar: {
        sta (screenPtr),y

        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        rts
    }

    ShowText: {
        jsr SetDialogStart
        
        lda #$00 
        sta lines

        ldy #$00
        lda #FRAME_UL
        jsr DrawChar
        lda #FRAME_U
        jsr DrawChar
    !:
        lda #FRAME_U
        jsr DrawChar
        cpy textLen
        bne !-
        lda #FRAME_U
        jsr DrawChar
        lda #FRAME_UR
        jsr DrawChar

        inc lines

        jsr SpaceLine

        inc lines

        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)
    !TextLine:
        ldy #$00
        lda #FRAME_L
        jsr DrawChar
        lda #$00
        jsr DrawChar
    !:
        lda (textPtr),y
        cmp #$ff
        beq !+
        cmp #$cd
        beq !+
        clc
        adc #$33
        jsr DrawChar
        jmp !-
    !:
        tax
        lda #$00
        jsr DrawChar
        lda #FRAME_R
        jsr DrawChar
        cpx #$cd
        bne !+
        add16im(textPtr, DEFAULT_TEXT_LEN - 1, textPtr)
        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)
        inc lines
        jmp !TextLine-
    !:
        add16im(textPtr, DEFAULT_TEXT_LEN - 1, textPtr)
        jsr SpaceLine
        inc lines
        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)

        ldy #$00
        lda #FRAME_DL
        jsr DrawChar
        lda #FRAME_D
        jsr DrawChar
    !:
        lda #FRAME_D
        jsr DrawChar
        cpy textLen
        bne !-
        lda #FRAME_D
        jsr DrawChar
        lda #FRAME_DR
        jsr DrawChar
        inc lines
        inc lines
        rts
    }

    HideGetReady: {
        jsr SetDialogStart

        ldx #$00
    !:
        ldy #$00
    !:
        lda #$00
        sta (screenPtr),y
        iny
        cpy #18
        bne !-
        add16im(screenPtr, 40, screenPtr)
        inx
        cpx #DEFAULT_TEXT_LEN
        bne !--
        rts
    }

    HideText: {
        jsr SetDialogStart
        inc textLen
        inc textLen
        lda screenPtr
        sta bufferPtr

        lda Screen.screen_buffer_nbr
        bne !+
        lda screenPtr + 1
        clc
        adc #$04
        jmp !++
    !:
        lda screenPtr + 1
        sec
        sbc #$04
    !:
        sta bufferPtr + 1
        add16im(bufferPtr, 40, bufferPtr)

        ldx #$00
    !:
        txa
        pha
        ldy #$00
    !:
        lda (bufferPtr),y
        sta (screenPtr),y
        tax
        lda Colors,x
        sta (colorPtr),y

        iny
        cpy textLen
        bne !-
        
        pla
        tax
        add16im(screenPtr, 40, screenPtr)
        add16im(bufferPtr, 40, bufferPtr)
        add16im(colorPtr, 40, colorPtr)

        inx
        cpx lines
        bne !--
        rts
    }
    
    SetDialogStart: {
        lda Screen.screen_buffer_nbr
        beq !+
        lda #<[VIC.SCREEN_RAM2 + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr
        lda #>[VIC.SCREEN_RAM2 + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr + 1
        jmp !++
    !:
        lda #<[VIC.SCREEN_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr
        lda #>[VIC.SCREEN_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr + 1
    !:
        lda #<[VIC.COLOR_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta colorPtr
        lda #>[VIC.COLOR_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta colorPtr + 1
        rts
    }

    SpaceLine: {
        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)

        ldy #$00
        lda #FRAME_L
        jsr DrawChar

        lda #$00
        jsr DrawChar
    !:
        lda #$00
        jsr DrawChar
        cpy DIALOG.textLen
        bne !-
        lda #$00
        jsr DrawChar
        lda #FRAME_R
        jsr DrawChar
        rts
    }

    ShowEnd: {
    !:  // wait for stable scroll
        lda Screen.vscroll
        cmp #$06
        bne !-
        lda #GAME.STATE_PAUSE
        sta GAME.state
        
        lda #<textLevelComplete - 2
        sta textPtr
        lda #>textLevelComplete - 2 
        sta textPtr + 1

        lda #DEFAULT_TEXT_LEN
        sta textLen
        jsr ShowText
        jsr CONTROLS.WaitForFire        
        jsr HideText
        set16(textPtr, currentText)

        lda #GAME.STATE_RUN
        sta GAME.state
        rts
    }

    ShowGetReady: {
        lda #GAME.STATE_PAUSE
        sta GAME.state
        lda #<textGetReady - 2
        sta textPtr
        lda #>textGetReady - 2 
        sta textPtr + 1

        lda #DEFAULT_TEXT_LEN
        sta textLen

        jsr ShowText
        jsr CONTROLS.WaitForFire        
        jsr HideGetReady

        lda #<textEat - 2
        sta currentText
        lda #>textEat - 2 
        sta currentText + 1
        lda #GAME.STATE_RUN
        sta GAME.state
        rts
    }

    ShowNext: {
        lda COUNTER
        sta lastCounter
    !:  // wait for stable scroll
        lda Screen.vscroll
        cmp #$06
        bne !-
        lda #GAME.STATE_PAUSE
        sta GAME.state
        
        set16(currentText, textPtr)
        lda #DEFAULT_TEXT_LEN
        sta textLen
        jsr ShowText
        jsr CONTROLS.WaitForFire        
        jsr HideText
        set16(textPtr, currentText)

        lda #GAME.STATE_RUN
        sta GAME.state
        rts
    }

    textGetReady: .text @" GET READY  \$ff"
    textEat: .text @"MUSISZ JESC \n  ABY MIEC  \n    SILE    \$ff"
    textWater: .text @"   UWAZAJ   \n   NA WODE  \$ff"
    textLevelComplete: .text @"   POZIOM   \n UKONCZONY  \$ff"
}

