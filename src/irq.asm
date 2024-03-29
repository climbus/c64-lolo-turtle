IRQ: {
    .label MUSIC_LINE = 60
    .label START_COPYING_UPPER_COLOR_RAM_LINE = 115
    .label BEGIN_VBLANK_LINE = 250
    .label START_COPYING_LOWER_COLOR_RAM_LINE = 230
    .label START_FOOTER_RAM_LINE = 216

    Setup: {  
        lda #music.startSong - 1
        jsr music.init
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

    ScrollStop: {
        sei
        ldy #$7f      // 01111111 
        sty $dc0d     // turn off CIA timer interrupt
        lda $dc0d     // cancel any pending IRQs
        lda #$00
        sta $d01a     // enable VIC-II Raster Beam IRQ
        lda #$ff
        sta $fffe
        sta $ffff
        rts

    }

    IRQMiddle: {
        IRQStart()
        lda GAME.state
        and #[GAME.STATE_PAUSE + GAME.STATE_END]
        bne !End+
        lda Screen.vscroll                                  
        cmp #7
        bne !+          
        jsr Screen.ColorShiftUpper
    !:
    !End:
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

        DisableMulticolorMode()

        UpdateScrollRegisterNum(7)
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
        EnableMulticolorMode()
        lda GAME.state
        and #[GAME.STATE_PAUSE + GAME.STATE_END]
        bne !+
        jsr Screen.ShiftBottom
    !:
        UpdateScrollRegister(Screen.vscroll)
        lda #$08
        sta VIC.BACKGROUND_COLOR
        SetRasterInterrupt(MUSIC_LINE, IRQMusic)
        IRQEnd()
    }

    IRQMusic: {
        IRQStart()
        lda GAME.state
        and #[GAME.STATE_PAUSE + GAME.STATE_END]
        bne !+
        jsr music.play
    !:
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
