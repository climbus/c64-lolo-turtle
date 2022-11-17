SOUND: {
    Pang: {
        lda #<PangSFX
        ldy #>PangSFX
        ldx #$07
        jsr music.init + 6
        rts
    }

    Dead: {
        lda #<DeadSFX
        ldy #>DeadSFX
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

    Water: {
        lda #<WaterSFX
        ldy #>WaterSFX 
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
        .import binary "assets/eat.bin"
    PangSFX:
        .import binary "assets/pang.bin"
    DeadSFX:
        .import binary "assets/dead.bin"
    WaterSFX:
        .import binary "assets/water.bin"

    PauseSnd:
        .byte 00, 00
}
