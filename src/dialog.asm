DIALOG: {
    .const DEFAULT_ROW = 8
    .const DEFAULT_COL = 13
    
    .label FRAME_UL = $9a
    .label FRAME_DL = $9f
    .label FRAME_UR = $9d
    .label FRAME_DR = $a1
    .label FRAME_U = $9b
    .label FRAME_D = $a0
    .label FRAME_L = $9c
    .label FRAME_R = $9e
    .label DIALOG_COLOR = $01

    .label textLSB = TMP2 
    .label textMSB = TMP3
    .label screenPtr = TMP4
    .label colorPtr = TMP6
    .label textPos = $00
    
    textLen: .byte $00

    ShowText: {
        ldy #$00
        lda #FRAME_UL
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        lda #FRAME_U
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
    !:
        lda #FRAME_U
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        cpy textLen
        bne !-
        lda #FRAME_U
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        lda #FRAME_UR
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y

        SPACE_LINE()
    
        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)
        
        ldy #$00
        lda #FRAME_L
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        lda #$00
        sta (screenPtr),y
        iny
    !:
        lda (textLSB),y
        cmp #$ff
        beq !+
        clc
        adc #$33
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        jmp !-
    !:
        lda #$00
        sta (screenPtr),y
        iny
        lda #FRAME_R
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y

        SPACE_LINE()
    
        add16im(screenPtr, 40, screenPtr)
        add16im(colorPtr, 40, colorPtr)

        ldy #$00
        lda #FRAME_DL
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        lda #FRAME_D
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
    !:
        lda #FRAME_D
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        cpy textLen
        bne !-
        lda #FRAME_D
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y
        iny
        lda #FRAME_DR
        sta (screenPtr),y
        lda #DIALOG_COLOR
        sta (colorPtr),y

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

    ShowGetReady: {
        lda #<[VIC.SCREEN_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr
        lda #>[VIC.SCREEN_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta screenPtr + 1

        lda #<[VIC.COLOR_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta colorPtr
        lda #>[VIC.COLOR_RAM + 40 * DEFAULT_ROW + DEFAULT_COL]
        sta colorPtr + 1
       
        lda #<textGetReady - 2
        sta textLSB
        lda #>textGetReady - 2 
        sta textMSB

        lda #[endTextGetReady - textGetReady + 2]
        sta textLen

        jsr ShowText
        jsr CONTROLS.WaitForFire        
        jsr HideText
        rts
    }

    textGetReady: .text "GET READY"
    endTextGetReady: .byte $ff
}

.macro SPACE_LINE() {
        add16im(DIALOG.screenPtr, 40, DIALOG.screenPtr)
        add16im(DIALOG.colorPtr, 40, DIALOG.colorPtr)

        ldy #$00
        lda #DIALOG.FRAME_L
        sta (DIALOG.screenPtr),y
        lda #DIALOG.DIALOG_COLOR
        sta (DIALOG.colorPtr),y
        iny
        lda #$00
        sta (DIALOG.screenPtr),y
        lda #DIALOG.DIALOG_COLOR
        sta (DIALOG.colorPtr),y
        iny
    !:
        lda #$00
        sta (DIALOG.screenPtr),y
        lda #DIALOG.DIALOG_COLOR
        sta (DIALOG.colorPtr),y
        iny
        cpy DIALOG.textLen
        bne !-
        lda #$00
        sta (DIALOG.screenPtr),y
        lda #DIALOG.DIALOG_COLOR
        sta (DIALOG.colorPtr),y
        iny
        lda #DIALOG.FRAME_R
        sta (DIALOG.screenPtr),y
        lda #DIALOG.DIALOG_COLOR
        sta (DIALOG.colorPtr),y
}
