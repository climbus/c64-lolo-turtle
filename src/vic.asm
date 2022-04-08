#importonce

VIC: {
    .label FOREGROUND_COLOR = $d020
    .label BACKGROUND_COLOR = $d021
    .label EXTRA_BACKGROUND_COLOR = $d022

    .label COLOR_RAM = $d800

    .label SCREEN_RAM = $4000
    .label SCREEN_MSB = $40

    .label ENABLE_SPRITE_REGISTER = $d015
    .label SCROLL_REGISTER = $d011

    .label SPRITE_0_X = $d000
    .label SPRITE_0_Y = $d001
    .label SPRITE_1_X = $d002
    .label SPRITE_1_Y = $d003
    
    .label temp = $13

    WaitForFrame: { 
        lda $d012
        sty temp
        cmp temp
        bne WaitForFrame
        rts
    }
}