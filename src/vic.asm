#importonce

VIC: {
    .label FOREGROUND_COLOR = $d020
    .label BACKGROUND_COLOR = $d021
    .label EXTRA_BACKGROUND_COLOR = $d022
    .label EXTRA_BACKGROUND_COLOR2 = $d023

    .label COLOR_RAM = $d800

    .label SCREEN_RAM = $4000
    .label SCREEN_RAM2 = $4400
    .label SCREEN_MSB = $40

    .label ENABLE_SPRITE_REGISTER = $d015
    .label SCROLL_REGISTER = $d011
    .label MEMORY_SETUP_REGISTER = $d018

    .label SPRITE_0_X = $d000
    .label SPRITE_0_Y = $d001
    .label SPRITE_1_X = $d002
    .label SPRITE_1_Y = $d003

    .label SPRITE_8_BIT = $d010
    
    .label temp = $13

    WaitForFrame: { 
        lda $d012
        sty temp
        cmp temp
        bne WaitForFrame
        rts
    }

    ScreenRowLSB:
		.fill 40, <[VIC.SCREEN_RAM + i * $28]
    ScreenRowMSB:
		.fill 40, >[VIC.SCREEN_RAM + i * $28]

    BufferRowMSB:
		.fill 40, >[VIC.SCREEN_RAM2 + i * $28]

    ColorRowLSB:
		.fill 40, <[VIC.COLOR_RAM + i * $28]
    ColorRowMSB:
		.fill 40, >[VIC.COLOR_RAM + i * $28]

}
