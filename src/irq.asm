IRQ: {
    .label START_COPYING_UPPER_COLOR_RAM_LINE = 115
    .label BEGIN_VBLANK_LINE = 250
    .label START_COPYING_LOWER_COLOR_RAM_LINE = 230
    .label START_FOOTER_RAM_LINE = 216

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
        jsr Screen.ColorShiftUpper
    !:
        jmp HandlerFooter
    }

    IRQFooter: {
        IRQStart()
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
        sta VIC.BACKGROUND_COLOR

        lda VIC.SCROLL_REGISTER
        and #%11111000
        sta VIC.SCROLL_REGISTER

        lda Screen.vscroll
        cmp #07
        bne !+
        SetRasterInterrupt(START_COPYING_LOWER_COLOR_RAM_LINE, IRQBeginVBlank)
        IRQEnd()
    !:
        SetRasterInterrupt(BEGIN_VBLANK_LINE, IRQBeginVBlank)
        IRQEnd()
    }

    IRQBeginVBlank: {
        IRQStart()

        jsr Screen.ShiftBottom

        lda Screen.vscroll
        cmp #07
        bne !+
        jmp HandlerMiddle
    !:
        jmp HandlerFooter
    }

    HandlerMiddle: {    
        SetRasterInterrupt(START_COPYING_UPPER_COLOR_RAM_LINE, IRQMiddle)
        IRQEnd()
    }
    
    HandlerFooter: {    
        SetRasterInterrupt(START_FOOTER_RAM_LINE, IRQFooter)
        IRQEnd()
    }
}
