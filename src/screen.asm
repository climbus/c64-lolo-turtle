
Screen: {
    vscroll: .byte 0
    change_scroll: .byte 0
    screen_buffer_nbr: .byte 0
    screen_base: .word 0      
    screen_back_buffer_base: .word 0
    
    tmp_row: .fill 40, 00

    .label ROWS_PER_COPY = 12
    .label screen_ptr = $04
    .label color_ptr = $06
    .label screen_row = $08
    .label screen_ptr_dest = $0a
    .label color_ptr_dest = $0c
        
    .const ROWS_COLOR_UPPER = 8
    .const ROWS_COLOR_LOWER = 11

    Init: {
        set16im(VIC.SCREEN_RAM, screen_base)
        set16im(VIC.SCREEN_RAM2, screen_back_buffer_base)
        set16(screen_base, screen_ptr)
        add16im(screen_ptr, 40*25, screen_ptr)
        set16im($d800, color_ptr)
        lda #0
        sta change_scroll
        rts
    }

    ShiftBottom: {
//        lda change_scroll
//        bne !+
            inc vscroll
//    !:
//        eor #1
//        sta change_scroll

        lda vscroll
        cmp #$08
        bne !+
        .break
        jsr ColorShiftLower
        lda #$08
        sta VIC.BACKGROUND_COLOR
        
        .break
        jmp SwapScreens
    after_swap:
        lda #$00
        sta vscroll
        UpdateScrollRegister(vscroll)
        jsr GAME.DrawNextRow
        .break
        rts
    !:
        cmp #$04
        bne !+
        jsr CharsShiftUpper
    !:
        lda vscroll
        cmp #$06
        bne !+
        jsr CharsShiftLower
    !:
        
        lda #$08
        sta VIC.BACKGROUND_COLOR
        
        UpdateScrollRegister(vscroll)
        rts
    }

    ColorShiftUpper: {
   //     lda change_scroll
   //     bne !+
   //     rts
   // !:
        set16im($d800 + 40 * ROWS_COLOR_UPPER, screen_ptr)
        set16im(tmp_row, screen_ptr_dest)
        ldy #0    
        ldx #1  
        jsr video_ram_copy_line


        set16im($d800 + 40 * [ROWS_COLOR_UPPER -1], screen_ptr)
        set16im($d800 + 40 * ROWS_COLOR_UPPER, screen_ptr_dest)
        ldy #0 
        ldx #ROWS_COLOR_UPPER
        jmp video_ram_copy_line
    }

    ColorShiftLower: {
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + ROWS_COLOR_LOWER - 1], screen_ptr)
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + ROWS_COLOR_LOWER], screen_ptr_dest)
        ldy #0    
        ldx #ROWS_COLOR_LOWER
        jsr video_ram_copy_line

        set16im(tmp_row, screen_ptr)
        set16im($d800 + 40 * [ROWS_COLOR_UPPER + 1], screen_ptr_dest)
        ldy #0               
        ldx #1    
        jmp video_ram_copy_line
    }

    CharsShiftUpper: {
        set16(screen_base, screen_ptr)
        set16(screen_back_buffer_base, screen_ptr_dest)
        add16im(screen_ptr, 40*9, screen_ptr)
        add16im(screen_ptr_dest, 40*10, screen_ptr_dest)
        ldy #0             
        ldx #10 
        jmp video_ram_copy_line
    }

    CharsShiftLower: {
        set16(screen_base, screen_ptr)
        set16(screen_back_buffer_base, screen_ptr_dest)
        add16im(screen_ptr, 40*18, screen_ptr)
        add16im(screen_ptr_dest, 40*19, screen_ptr_dest)
        ldy #0                
        ldx #10 
        jmp video_ram_copy_line
    }

    video_ram_copy_line:
                       
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
        bne video_ram_copy_line   

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
        beq video_ram_copy_done

        ldy #0                  
        sub16im(screen_ptr, 40, screen_ptr)
        sub16im(screen_ptr_dest, 40, screen_ptr_dest)
        jmp video_ram_copy_line 

    video_ram_copy_done:
        rts

    SwapScreens: {
            lda screen_buffer_nbr
            eor #$01 
            sta screen_buffer_nbr
            bne screen_swap_to_1
            lda VIC.MEMORY_SETUP_REGISTER
            and #$0f                  
            //ora #$01                  
            sta VIC.MEMORY_SETUP_REGISTER
            set16im(VIC.SCREEN_RAM, screen_base)
            set16im(VIC.SCREEN_RAM2, screen_back_buffer_base)
            jmp ShiftBottom.after_swap

        screen_swap_to_1: 
            lda VIC.MEMORY_SETUP_REGISTER      
            and #$0f      
            ora #$10     
            sta VIC.MEMORY_SETUP_REGISTER
            set16im(VIC.SCREEN_RAM2, screen_base)
            set16im(VIC.SCREEN_RAM, screen_back_buffer_base)
            jmp ShiftBottom.after_swap
    }
}
