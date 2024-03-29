// Constants
.label SYSTEM_IRQ_VECTOR = $fffe

.macro AtoChar() {
    clc
    adc #[$96 - $41]
}

.macro set16im(value, dest) {                                   // store a 16bit constant to a memory location
    lda #<value
    sta dest
    lda #>value
    sta dest+1
}

.macro set16(value, dest) {        // copy a 16bit memory location to dest
    lda value
    sta dest
    lda value+1
    sta dest+1
}

.macro add16im(n1, n2, result) {         // add a 16bit constant to a memory location, store in result
    clc                                          // ensure carry is clear
    lda n1+0                                     // add the two least significant bytes
    adc #<n2
    sta result+0                                                
    lda n1+1                                     // add the two most significant bytes
    adc #>n2                                                    
    sta result+1                                                
}

.macro add16(n1, n2, result) {                   // add 2 16bit memory locations, store in result
    clc             
    lda n1       
    adc n2
    sta result+0       
    lda n1+1       
    adc n2+1       
    sta result+1
}

.macro sub16im(n1, n2, result) {         // add a 16bit constant to a memory location, store in result
    sec                                          // ensure carry is clear
    lda n1+0                                     // add the two least significant bytes
    sbc #<n2
    sta result+0                                                
    lda n1+1                                     // add the two most significant bytes
    sbc #>n2                                                    
    sta result+1                                                
}

.macro SetRasterInterrupt(line, handler) {
    sei                    // disable interrupts
    lda #line
    sta $d012              // this is the raster line register
    set16im(handler, SYSTEM_IRQ_VECTOR)     // set system IRQ vector to our handler
    cli                    // enable interrupts
}

.macro IRQStart() {
	dec $d019
	pha
	txa
	pha
	tya
	pha
}

.macro IRQEnd() {
    pla
	tay
	pla
	tax
	pla
	rti
}

.macro disable_x_scroll() {                                        // set horizontal softscroll value to 0
    lda $d016
    and #$F8
    sta $d016
}

.macro UpdateScrollRegister(value) {
    lda VIC.SCROLL_REGISTER
    and #$f8
    clc
    adc value
    sta VIC.SCROLL_REGISTER
}

.macro UpdateScrollRegisterNum(value) {
    lda VIC.SCROLL_REGISTER
    and #$f8
    clc
    adc #value
    sta VIC.SCROLL_REGISTER
}

.macro update_y_scroll(xvalue) {  // set horizontal softscroll value to xvalue
    lda $d011
    and #$F8
    clc
    adc xvalue
    sta $d011
}

.macro debug_print(value, column) {                             // put a char in the bottom line of the screen
    lda value
    clc
    adc #$30
    sta $0400+40*24+column
    sta $0800+40*24+column
    lda #1
    sta $d800+40*24+column
}

.macro LoadScreenMSB() {
        lda Screen.screen_buffer_nbr
        bne !+
        lda VIC.ScreenRowMSB,y
        jmp !++
    !:
        lda VIC.BufferRowMSB,y
        
    !:
}

.macro LoadBufferMSB() {
        lda Screen.screen_buffer_nbr
        bne !+
        lda VIC.BufferRowMSB,y
        jmp !++
    !:
        lda VIC.ScreenRowMSB,y
        
    !:
}
.macro EnableMulticolorMode() {
        lda $d016
        ora #%00010000
        sta $d016
}

.macro DisableMulticolorMode() {
        lda $d016
        and #%11101111
        sta $d016
}

.macro PrintDebugChar() {
    lda #$3a
    sta (PLAYER.playerScreenPosition),y
    clc 
    lda PLAYER.playerScreenPosition
    adc #40
    sta PLAYER.playerScreenPosition
    lda #00
    sta (PLAYER.playerScreenPosition),y

    //iny
    //sta (PLAYER.playerScreenPosition),y
}
