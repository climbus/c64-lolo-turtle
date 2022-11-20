
Screen: {
    vscroll: .byte 0
    screen_buffer_nbr: .byte 0
    screen_base: .word 0      
    screen_back_buffer_base: .word 0
    
    tmp_row: .fill 40, 00

    .label screen_ptr = IRQ_TMP1
    .label color_ptr = IRQ_TMP3
    .label screen_ptr_dest = IRQ_TMP5
    .label color_ptr_dest = IRQ_TMP7
        
    .const ROWS_COLOR_UPPER = 8
    .const ROWS_COLOR_LOWER = 11
    .const ROWS_CHARS_PER_FRAME = 10

    Init: {
        set16im(VIC.SCREEN_RAM, screen_base)
        set16im(VIC.SCREEN_RAM2, screen_back_buffer_base)
        set16(screen_base, screen_ptr)
        add16im(screen_ptr, 40*25, screen_ptr)
        set16im($d800, color_ptr)
        lda #$00
        sta screen_buffer_nbr
        lda #$00
        sta vscroll
        UpdateScrollRegister(vscroll)
        lda VIC.MEMORY_SETUP_REGISTER
        and #$0f                  
        sta VIC.MEMORY_SETUP_REGISTER
        rts
    }

    ShiftBottom: {
        inc vscroll

        lda vscroll
        cmp #$08   // Shift screen frame
        bne !+
        jsr ColorShiftLower

        lda #$08
        sta VIC.BACKGROUND_COLOR
        
        jmp SwapScreens
    AfterSwap:

        // Reset scroll register
        lda #$00
        sta vscroll
        UpdateScrollRegister(vscroll)
        rts
    !:
        cmp #$01
        bne !+
        jsr LEVEL.DrawNextRow
    !:
        cmp #$04
        bne !+
        jsr CharsShiftUpper
    !:
        cmp #$06
        bne !+
        jsr CharsShiftLower
    !:
        rts
    }

    ColorShiftUpper: {
        set16im($d800 + 40 * ROWS_COLOR_UPPER, screen_ptr)
        set16im(tmp_row, screen_ptr_dest)
        ldy #0    
        ldx #1  
        jsr CopyLine

        set16im($d800 + 40 * [ROWS_COLOR_UPPER -1], screen_ptr)
        set16im($d800 + 40 * ROWS_COLOR_UPPER, screen_ptr_dest)
        ldy #0 
        ldx #ROWS_COLOR_UPPER
        jmp CopyLine
    }

    ColorShiftLower: {
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + ROWS_COLOR_LOWER - 1], screen_ptr)
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + ROWS_COLOR_LOWER], screen_ptr_dest)
        ldy #0    
        ldx #ROWS_COLOR_LOWER
        jsr CopyLine

        set16im(tmp_row, screen_ptr)
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + 1], screen_ptr_dest)
        ldy #0               
        ldx #1    
        jmp CopyLine
    }

    CharsShiftUpper: {
        set16(screen_base, screen_ptr)
        set16(screen_back_buffer_base, screen_ptr_dest)
        add16im(screen_ptr, 40 * [ROWS_CHARS_PER_FRAME - 1], screen_ptr)
        add16im(screen_ptr_dest, 40 * ROWS_CHARS_PER_FRAME, screen_ptr_dest)
        ldy #0             
        ldx #ROWS_CHARS_PER_FRAME
        jmp CopyLine
    }

    CharsShiftLower: {
        set16(screen_base, screen_ptr)
        set16(screen_back_buffer_base, screen_ptr_dest)
        add16im(screen_ptr, 40 * [ROWS_CHARS_PER_FRAME * 2 - 2], screen_ptr)
        add16im(screen_ptr_dest, 40 * [ROWS_CHARS_PER_FRAME * 2 -1], screen_ptr_dest)
        ldy #0                
        ldx #ROWS_CHARS_PER_FRAME
        jmp CopyLine
    }

    CopyLine:
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        
        cpy #36
        bne CopyLine   

        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y
        iny
        lda (screen_ptr), y
        sta (screen_ptr_dest), y

        dex                      
        beq CopyDone

        ldy #0                  
        sub16im(screen_ptr, 40, screen_ptr)
        sub16im(screen_ptr_dest, 40, screen_ptr_dest)
        jmp CopyLine 

    CopyDone:
        rts

    SwapScreens: {
        lda screen_buffer_nbr
        eor #$01 
        sta screen_buffer_nbr
        bne !+
        lda VIC.MEMORY_SETUP_REGISTER
        and #$0f                  
        sta VIC.MEMORY_SETUP_REGISTER

        set16im(VIC.SCREEN_RAM, screen_base)
        set16im(VIC.SCREEN_RAM2, screen_back_buffer_base)
        jmp ShiftBottom.AfterSwap
    !: 
        lda VIC.MEMORY_SETUP_REGISTER      
        and #$0f      
        ora #$10     
        sta VIC.MEMORY_SETUP_REGISTER

        set16im(VIC.SCREEN_RAM2, screen_base)
        set16im(VIC.SCREEN_RAM, screen_back_buffer_base)
        jmp ShiftBottom.AfterSwap
    }
}
