#import "vic.asm"
#import "player.asm"
#import "apples.asm"
#import "controls.asm"


GAME: {
    .label col=$11
    .label row=$12
    .label temp = $13

    .label ROAD_COLOR = $0c

    show_points_counter: .byte 00
    offset:	.byte 00
    points: .byte 00, 00, 00
    game_counter: .byte 00, 00

    ScreenRowLSB:
		.fill 40, <[VIC.SCREEN_RAM + i * $28]
	ScreenRowMSB:
		.fill 40, >[VIC.SCREEN_RAM + i * $28]



    Init: {
        sei
        // change foreground and background colors
        lda #$00
        sta VIC.FOREGROUND_COLOR
        sta VIC.BACKGROUND_COLOR

        // extended color mode
        lda VIC.SCROLL_REGISTER
        ora #%01001000
        sta VIC.SCROLL_REGISTER

        // set road background color
        lda #ROAD_COLOR
        sta VIC.EXTRA_BACKGROUND_COLOR

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

    DrawScreen: {   
        lda #$00
        sta row
        sta col

    !RowLoop:
        lda #$00
        sta col

    !ColLoop:
    TILE:
        lda Map
        sta VIC.SCREEN_RAM

    COLOR:
        lda Colors
        sta VIC.COLOR_RAM

        clc
        lda TILE + 1
        adc #$01
        sta TILE + 1

        lda TILE + 2
        adc #$00
        sta TILE + 2

        clc
        lda TILE + 4
        adc #$01
        sta TILE + 4

        lda TILE + 5
        adc #$00
        sta TILE + 5

        clc
        lda COLOR + 1
        adc #$01
        sta COLOR + 1

        lda COLOR + 2
        adc #$00
        sta COLOR + 2

        clc
        lda COLOR + 4
        adc #$01
        sta COLOR + 4

        lda COLOR + 5
        adc #$00
        sta COLOR + 5

        inc col

        ldx col
        cpx #40
        bne !ColLoop-
            
        inc row

        ldx row
        cpx #25
        bne !RowLoop-

        ldx #$00
    !:
        inx
        cpx #$28
        bne !-
        rts
    }

    GetCharPosition: {
        
        lda PLAYER.playerY
        sec
        sbc #50
        lsr
        lsr
        lsr
        tay
        
        lda PLAYER.playerX
        sec
        sbc #11
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
        .label ROW = temp
        .label COL = temp + 1

        jsr GetCharPosition
        
        stx ROW
        sty COL

        jsr GetCharacterAt

    
        // // debug ////
        // lda #00
        // sta (PLAYER.playerScreenPosition),y
        // iny
        // sta (PLAYER.playerScreenPosition),y
        // ////////////

        cmp #$4e
        bne !+
            ldx ROW
            ldy COL
            lda #$03
            jsr SetCharacterAt

            lda PLAYER.playerScreenPosition + 1
            sbc #VIC.SCREEN_MSB
            tax
            lda PLAYER.playerScreenPosition
            jsr APPLES.remove
            jsr ShowPoints
            jsr AddPoints
            rts
    !:
        
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
.break
        // x - row position
        // y - col position
        lda ScreenRowLSB,y
        sta PLAYER.playerScreenPosition
        lda ScreenRowMSB,y
        sta PLAYER.playerScreenPosition+1

        txa
        tay
        lda (PLAYER.playerScreenPosition),y
        // a - character
        rts
    }

    SetCharacterAt: {
        sta temp
        lda ScreenRowLSB,y
        sta PLAYER.playerScreenPosition
        lda ScreenRowMSB,y
        sta PLAYER.playerScreenPosition+1

        txa
        tay

        lda temp
        sta (PLAYER.playerScreenPosition),y
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

    MainLoop: {
        ldy #$00
        jsr VIC.WaitForFrame
        jsr CONTROLS.ReadJoy
        jsr CheckCollisions
        jsr ScrollScreen
        jsr APPLES.draw
        jsr PLAYER.AnimateTurtle
        jsr HidePoints
        jsr UpdateCounter
    

        ldy #$ff
        jsr VIC.WaitForFrame
        lda game_counter
        cmp #$05
        bne MainLoop
        rts
    }

    UpdateCounter: {
        clc
        lda game_counter + 1
        adc #$01
        sta game_counter + 1

        lda game_counter
        adc #00
        sta game_counter
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
        sta show_points_counter
        rts
    }

    HidePoints: {
        ldx show_points_counter
        cpx #$00
        beq !+
            dex
            stx show_points_counter
            rts
    !:
        lda VIC.ENABLE_SPRITE_REGISTER
        and #%11111101
        sta VIC.ENABLE_SPRITE_REGISTER
        rts
    }
    ScrollScreen: {
        // hardware scroll
        lda VIC.SCROLL_REGISTER
        and #%11110000
        ora offset
        sta VIC.SCROLL_REGISTER

        ldx offset
        cpx #$01
        bne !+
        jsr APPLES.check_last
        jsr APPLES.move
        jsr APPLES.GrabNew
    !:  
        ldx offset
        cpx #$07
        bne !+
        ldx #00
        inc APPLES.counter
    !:
        inx
        stx offset 
        rts
    }
    Map:
    .import binary "assets/map.bin"

    Colors:
    .import binary "assets/colors.bin"
}