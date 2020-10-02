.importonce
.import source "vic.asm"

APPLES: {
    .label start = $20
    .label end = $22
    .label current = $24
    .label len = $26
    .label temp = $27
    
    counter:    .byte 00
    
    // jsr init
    // lda #$0a
    // ldx #$00
    // jsr add
    // lda #$0b
    // ldx #$00
    // jsr add
    rts

    init:
        lda #<list
        sta start
        sta end
        lda #>list
        sta start + 1
        sta end + 1
        lda #$00
        sta len
        rts

    add: 
        ldx #$00
        ldy #00
        sta (end),y
        iny
        txa
        sta (end),y
        clc
        lda end
        adc #$02
        sta end
        lda end + 1
        adc #$00
        sta end + 1
        inc len
        inc len
        rts

    pop:
        clc
        lda start
        adc #$02
        sta start
        lda start + 1
        adc #$00
        sta start + 1
        dec len
        dec len
        rts
    
    draw:
        ldx #$00
        ldy #$00
    !Loop:
        cpy len
        beq !End+

        lda (start),y
        sta current
        iny
        lda (start),y
        clc
        adc #VIC.SCREEN_MSB
        sta current + 1
        lda #$0e
        ora #%01000000
        sta (current,x)

        lda (start),y
        clc
        adc #$d8
        sta current + 1
        lda #$02
        sta (current,x)
        iny
        jmp !Loop-
    !End:
        rts
    
    clear:
        sta current
        txa
        sta temp
        clc
        adc #$c0
        sta current + 1
        lda #$03
        ldx #$00
        sta (current,x)

        // clear color
        lda temp
        clc
        adc #$d8
        sta current + 1
        lda #$cc
        sta (current,x)
        rts
        
    move:
        ldx #$00
        ldy #$00
    !Loop:
        cpy len
        beq !End+
        // clear apple
        lda (start),y
        sta current
        iny
        lda (start),y
        clc
        adc #VIC.SCREEN_MSB
        sta current + 1
        lda #$03
        sta (current,x)

        // clear color
        lda (start),y
        clc
        adc #$d8
        sta current + 1
        lda #$cc
        sta (current,x)

        // move one row down
        dey
        clc
        lda (start),y
        adc #$28
        sta (start),y
        iny
        lda (start),y
        adc #00
        sta (start),y

        iny
        jmp !Loop-
    !End:
        rts
    
    check_last:
        ldy #$01
        lda (start),y
        tax
        // remove if out screen
        cmp #$03
        bne !+
        dey
        lda (start),y
        cmp #VIC.SCREEN_MSB
        bcc !+
            jsr clear
            jsr pop
    !:
        rts
    
    shift:
        ldy len
        iny
    !Loop:
        dey
        lda (start),y
        pha
        cpy #$00
        bne !Loop-

        lda #<list
        sta start
        lda #>list
        sta start + 1

        ldy #$ff
   !Loop:
        iny
        pla
        sta (start),y
        cpy len
        bne !Loop-
    
        clc
        lda start
        adc len
        sta end
        lda start + 1
        adc #$00
        sta end + 1
        rts
    
    remove:
        sta temp + 1
        stx temp + 2

        jsr clear

        ldy #00
    !Loop:
        lda (start), y
        cmp temp + 1
        bne !++
        iny
        lda (start),y
        cmp temp + 2
        bne !+
        jsr shift_left
        
        rts
    !:  dey 
    !:
        iny
        iny
        cpy len
        bne !Loop-
        rts
    
    shift_left:
    !Loop:
        cpy #$01
        beq !+
        dey
        dey
        lda (start),y
        iny
        iny
        sta (start),y
        dey
        bne !Loop-
    !:
        dec len
        dec len
        clc
        lda start
        adc #$02
        sta start
        lda start + 1
        adc #$00
        sta start + 1
        rts

    GrabNew: {
        // check if new apple available
        ldy counter
        lda WaitingApples,y
        cmp #$ff
        bne !+
        ldy #$ff
        sty counter
        jsr APPLES.shift
        rts
    !:
        cmp #$00
        beq !+
            jsr APPLES.add
    !:
        rts
    }

    WaitingApples:
        .byte 00, 00, 00, $11, 00, $00, $00, $00, $0c, $00, $00, $00, $00, $00, $0c, $0d, $12, $00, $00, $1c, $00, $00, $00, $12, $00, $10, $00, $ff
    list: .fill 100, $00
}