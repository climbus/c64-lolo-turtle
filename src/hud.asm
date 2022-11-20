HUD: {
    .const START_CHAR = 40 * 21
    .const CHAR_COUNT = 120

    .const POINTS_LINE = 22
    .const POINTS_START_ADDR = $378
    .const DIGITS_START_CHAR = $b0
    .const ENERGY_START_ADDR = $387
    .const HEART_CHAR = $ba
    .const LIVES_START_ADDR = $393
    .const LIVES_CHAR = $bb

    decPoints: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
    hexPoints: .byte 00, 00, 00, 00

    Draw: {
        jsr ShowPointsLabel
        jsr ShowPoints
        jsr ShowEnergy
        jsr ShowLives
        rts
    }

    ShowPointsLabel: {
        ldy #$00
    !:
        lda textPointsLabel,y
        cmp #$ff
        beq !+
        AtoChar()
        sta VIC.SCREEN_RAM + [POINTS_LINE * 40 + 1],y
        sta VIC.SCREEN_RAM2 + [POINTS_LINE * 40 + 1],y
        lda #$01
        sta VIC.COLOR_RAM + [POINTS_LINE * 40 + 1],y
        iny
        jmp !-
    !:
        rts
    }

    ShowPoints: {
        lda GAME.points
        sta hexPoints
        lda GAME.points + 1
        sta hexPoints + 1
        lda GAME.points + 2
        sta hexPoints + 2
        
        jsr Hex2Dec
        ldx #08
        ldy #00
!:
        lda decPoints,x
        clc
        adc #DIGITS_START_CHAR
        sta VIC.SCREEN_RAM + POINTS_START_ADDR,y
        sta VIC.SCREEN_RAM2 + POINTS_START_ADDR,y
        lda #01
        sta VIC.COLOR_RAM + POINTS_START_ADDR,y
        iny
        dex
        bpl !-
        rts
    }
    
    Hex2Dec: {
        ldx #0
    !: 
        jsr Div10
        sta decPoints,x
        inx
        cpx #10
        bne !-
        rts
    }

    Div10: {
        ldy #24 
        lda #0
        clc
    !Loop: 
        rol
        cmp #10
        bcc !+
        sbc #10
    !:
        rol hexPoints
        rol hexPoints + 1
        rol hexPoints + 2
        dey
        bpl !Loop-
        rts
    }

    ShowEnergy: { 
        ldx #$08
        ldy #$00
    !Loop:  
        lda #HEART_CHAR
        cpx GAME.energy
        bcc !+
        lda #$00
    !:  
        sta VIC.SCREEN_RAM + ENERGY_START_ADDR,y
        sta VIC.SCREEN_RAM2 + ENERGY_START_ADDR,y
        lda GAME.energy
        cmp #04
        bcs !+
        lda #RED
        jmp !++
    !:
        lda #WHITE
    !:
        sta VIC.COLOR_RAM + ENERGY_START_ADDR,y
        iny
        dex
        bpl !Loop-
        rts
    }

    ShowLives: {
        ldx #GAME.MAX_LIVES
        ldy #$00
    !Loop:
        lda #LIVES_CHAR
        cpx GAME.lives
        bcc !+
        lda #$00
    !:
        sta VIC.SCREEN_RAM + LIVES_START_ADDR,y
        sta VIC.SCREEN_RAM2 + LIVES_START_ADDR,y
        lda #RED
        sta VIC.COLOR_RAM + LIVES_START_ADDR,y
        iny 
        dex
        bpl !Loop-
        rts
    }
    
    #importif PL "txt/labels_pl.asm"
    #importif EN "txt/labels_en.asm"
}

HudMap:
    .import binary "./assets/hud.bin"
HudMapEnd:

HudColors:
    .import binary "./assets/hud_colors.bin"
HudColorsEnd:
