SOUND: {
    Pang: {
        lda #<PangSFX
        ldy #>PangSFX
        ldx #$07
        jsr music.init + 6
        rts
    }

    Eat: {
        lda #<EatSFX
        ldy #>EatSFX 
        ldx #$07
        jsr music.init + 6
        rts
    }

    Pause: {
        lda #<PauseSnd
        ldy #>PauseSnd
        ldx #$00
        jsr music.init + 6
        rts
    }

    EatSFX:
        .import binary "assets/test.bin"
    PangSFX:
        .import binary "assets/pang.bin"

    PauseSnd:
        .byte 00, 00
}
