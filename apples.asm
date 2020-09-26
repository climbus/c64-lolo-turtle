
APPLES: {
    .label start = $20
    .label end = $22
    .label current = $24
    .label len = $26
    .label temp = $27

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
        adc #$c0
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
        adc #$c0
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
        cmp #$c0
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
        
    list: .fill 255, $00
}