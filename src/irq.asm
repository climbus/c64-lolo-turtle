// consts 


// vars
yscroll:            .byte 0

IRQ: {
    .label irq_delay_default = 0
    .label FIRST_VIS_LINE = 50
    .label START_COPYING_UPPER_COLOR_RAM_LINE = 96
    .label BEGIN_VBLANK_LINE = 250
    .label SYSTEM_IRQ_HANDLER = $ea81

    Setup: {  
        sei           // disable interrupts
        ldy #$7f      // 01111111 
        sty $dc0d     // turn off CIA timer interrupt
        lda $dc0d     // cancel any pending IRQs
        lda #$01
        sta $d01a     // enable VIC-II Raster Beam IRQ
        lda $d011     // bit 7 of $d011 is the 9th bit of the raster line.
        and #$7f      // make sure it is set to 0
        sta $d011
        SetRasterInterrupt(START_COPYING_UPPER_COLOR_RAM_LINE, IRQMiddle)
        cli           // enable interupts
        rts
    }

    IRQMiddle: {
        IRQStart()
        
        lda Screen.vscroll                                  
        cmp #7
        bne !+          
        inc $d020
    upper:           
        jsr Screen.ColorShiftUpper
        .break
        dec $d020
    !:
        SetRasterInterrupt(216, IRQFooter)
        IRQEnd()
    }

    IRQFooter: {
        IRQStart()
        //ldy #218
        //jsr VIC.WaitForFrame
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

        
        lda #00
        sta $d021

        lda $d011
        and #%11111000
        sta $d011
        lda Screen.vscroll
        cmp #07
        bne !+
        //jsr Screen.ColorShiftMiddle
    !:
        SetRasterInterrupt(BEGIN_VBLANK_LINE, IRQBeginVBlank)
        IRQEnd()
    }
    IRQBeginVBlank: {
        IRQStart()

        lda #$08
        sta VIC.BACKGROUND_COLOR
        
        jsr Screen.ShiftBottom
        lda Screen.vscroll
        cmp #07
        bne !+
        jmp HandlerMiddle
    !:
        jmp HandlerFooter
    
                    
    SwapScreens:      
    //                lda #0                  
    //                sta yscroll
    //                update_y_scroll(yscroll)
    //                jsr screen_swap        
    //    lower:              
    //                jsr color_shift_lower  
    //

    //                jsr level_render_last_row     
    }

    HandlerMiddle: {    
        SetRasterInterrupt(START_COPYING_UPPER_COLOR_RAM_LINE, IRQMiddle)
        IRQEnd()
    }
    
    HandlerFooter: {    
        SetRasterInterrupt(216, IRQFooter)
        IRQEnd()
    }
}
