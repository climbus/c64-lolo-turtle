#import "vic.asm"
#import "level.asm"
#import "player.asm"
#import "apples.asm"
#import "controls.asm"
#import "irq.asm"


GAME: {
    .const MATERIAL_SOLID = $02
    .const MATERIAL_HURT = $03


    showPointsCounter: .byte 00
    points: .byte 00, 00, 00
    front_material: .byte 00
    left_material: .byte 00
    right_material: .byte 00
    front_row: .byte 00
    front_col: .byte 00

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

    Init: {
        sei
        // change foreground and background colors
        lda #$00
        sta VIC.FOREGROUND_COLOR
        lda #$08
        sta VIC.BACKGROUND_COLOR

        lda $d011
        and #%10110111
        sta $d011
        // multicolor color mode
        lda $d016
        ora #%00010000
        sta $d016

        // set road background color
        lda #$0b
        sta VIC.EXTRA_BACKGROUND_COLOR
        lda #$07
        sta VIC.EXTRA_BACKGROUND_COLOR2


        // //interupts
        lda #$7f
        sta $dc0d
        sta $dd0d

        // memory configuration
        lda $01
        and #%11111000
        ora #%11111101
        sta $01
        
        // enable vic bank 1
        lda $dd00
        and #%11111110
        sta $dd00

        // setup character memory and screen memory
        lda #%00001100
        sta $d018
        jsr PLAYER.Init
        jsr APPLES.init
        cli
        rts
    }

    GetCharPosition: {
        // x - x offset
        // y - y offset
        .label OFFSET_X = TMP2
        .label OFFSET_Y = TMP3
        stx OFFSET_X
        sty OFFSET_Y
        lda PLAYER.playerY
        sec
        sbc OFFSET_Y
        lsr
        lsr
        lsr
        tay
        
        lda PLAYER.playerX
        sec
        sbc OFFSET_X
        lsr
        lsr
        lsr
        tax

        // x - row number
        // y - col number
        rts
    }

    CheckCollisions: {
        // calculate row and col of player position
        .label ROW = TMP2
        .label COL = TMP3
        
        ldx #16
        ldy #44
        jsr GetCharPosition
        
        stx ROW
        stx front_row
        sty COL
        sty front_col

        jsr GetCharacterAt

        // debug ////
        // lda #$c0
        // sta (PLAYER.playerScreenPosition),y
        // iny
        // sta (PLAYER.playerScreenPosition),y
        // ////////////
        
        jsr GetMaterial
        sta front_material
       

        ldx #26
        ldy #43
        jsr GetCharPosition
        jsr GetCharacterAt
        // debug ////
        jsr GetMaterial
        sta left_material

        ldx #00
        ldy #43
        jsr GetCharPosition
        jsr GetCharacterAt
        jsr GetMaterial
        sta right_material
    //     cmp #$03
    //     beq !+
    //     lda PLAYER.platerLastPosition
    //     sta PLAYER.playerX
    //     sta VIC.SPRITE_0_X
    //     rts
    // !:
        rts
    }

    GetCharacterAt: {
        // x - row position
        // y - col position
        lda ScreenRowLSB,y
        sta PLAYER.playerScreenPosition
        LoadScreenMSB()
        sta PLAYER.playerScreenPosition+1

        txa
        tay
        lda (PLAYER.playerScreenPosition),y
        // a - character
        rts
    }
    
    GetMaterial: {
        // a - character
        tax
        lda Colors,x
        and #%11110000
        lsr
        lsr
        lsr
        lsr
        // a - material number
        rts
    }

    SetTailAt: {
        .label SCREEN_POS = TMP2
        txa
        lsr
        asl
        tax
        lda ScreenRowLSB,y
        sta SCREEN_POS
        LoadScreenMSB()
        sta SCREEN_POS + 1
        txa
        tay
        lda #$00
        sta (SCREEN_POS),y
        iny
        sta (SCREEN_POS),y
        sub16im(SCREEN_POS, 40, SCREEN_POS)
        dey
        lda #$00
        sta (SCREEN_POS),y
        iny
        sta (SCREEN_POS),y
        rts
    }

    AddPoints: {
        clc
        lda points
        adc #100
        sta points
        lda points + 1
        adc #00
        sta points + 1
        lda points + 2
        adc #00
        sta points + 2
        rts
    }

    ActFrontCollisions: {
        lda front_material
        cmp #MATERIAL_SOLID
        bne !+
        ldx front_row
        ldy front_col
        jsr SetTailAt

        lda PLAYER.playerScreenPosition + 1
        sbc #VIC.SCREEN_MSB
        tax
        lda PLAYER.playerScreenPosition
        jsr ShowPoints
        jsr AddPoints
        rts
    !:
        cmp #MATERIAL_HURT
        bne !+
        .break
        jsr PLAYER.ApplyDamage
        rts
    !:
        cmp #$01
        bne !+
        jsr PLAYER.GoBack
    !:
        jsr PLAYER.ClearDamage
        rts
    }

    MainLoop: {
        ldy #$00
        jsr VIC.WaitForFrame
        
        jsr CONTROLS.ReadJoy
        jsr CheckCollisions
        jsr ActFrontCollisions
        
        jsr PLAYER.AnimateTurtle
        jsr HidePoints
        
        jmp MainLoop
        rts
    }

    ShowPoints: {
        lda PLAYER.playerX
        adc #20
        sta VIC.SPRITE_1_X
        lda PLAYER.playerY
        sbc #15
        sta VIC.SPRITE_1_Y
        lda VIC.ENABLE_SPRITE_REGISTER
        ora #%00000010
        sta VIC.ENABLE_SPRITE_REGISTER
        lda #20
        sta showPointsCounter
        rts
    }

    HidePoints: {
        ldx showPointsCounter
        cpx #$00
        beq !+
            dex
            stx showPointsCounter
            rts
    !:
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }
}

Map:
	.import binary "./assets/map.bin"
MapEnd:

Tiles:
	.import binary "./assets/tiles.bin"

Colors:
	.import binary "./assets/colors.bin"

LinesTable: .fillword 24, VIC.SCREEN_RAM + 40 * (24-i)
ColorTable: .fillword 24, VIC.COLOR_RAM + 40 * (24-i)

* = $7000 "Charset"
Chars:
	.import binary "./assets/chars.bin"
CharsEnd:
