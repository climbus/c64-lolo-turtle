HUD: {
    Draw: {
        .label SCREEN = TMP6
        .label COLOR = TMP4
        .const START_CHAR = 40 * 21
        .const CHAR_COUNT = 120

        ldy #00
    !:
        lda HudMap,y
        sta VIC.SCREEN_RAM + START_CHAR,y
        sta VIC.SCREEN_RAM2 + START_CHAR,y
        tax
        lda HudColors,x
        sta VIC.COLOR_RAM + START_CHAR,y
        iny
        cpy #CHAR_COUNT
        bne !-
        rts
    }
}

HudMap:
    .import binary "./assets/hud.bin"
HudMapEnd:

HudColors:
    .import binary "./assets/hud_colors.bin"
HudColorsEnd:
