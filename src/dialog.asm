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
    .label colorPtr = TMP6
    .label textPos = $00
    
    textLen: .byte $00
    currentText: .word $0000

    DrawChar: {
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        rts
    }

    ShowText: {
        jsr SetDialogStart

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

        jsr SpaceLine
    
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
        jmp !TextLine-
    !:
        add16im(textPtr, DEFAULT_TEXT_LEN - 1, textPtr)
        jsr SpaceLine

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
        rts
    }

    HideText: {
        ldx #$05
    !:
        ldy textLen
        iny
        iny
    !:
        dey
        lda #$00
        sta (screenPtr),y
        cpy #$00
        bne !-
        sub16im(screenPtr, 40, screenPtr)
        dex
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
    ShowGetReady: {
        lda #<textGetReady - 2
        sta textPtr
        lda #>textGetReady - 2 
        sta textPtr + 1

        lda #DEFAULT_TEXT_LEN
        sta textLen

        jsr ShowText
        jsr CONTROLS.WaitForFire        
        jsr HideText

        set16(textPtr, currentText)
        rts
    }

    ShowNext: {
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

