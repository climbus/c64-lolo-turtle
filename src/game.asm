#import "vic.asm"
#import "player.asm"
#import "apples.asm"
#import "controls.asm"
#import "irq.asm"


GAME: {
    .const MATERIAL_SOLID = $02

    .label Col = $04
    .label Row = $05
    .label ScrollOffset = $06
    .label Counter = $07
    .label temp = $8

    TileScreenLocations2x2: 
        .byte 0,1,40,41

    TileScreenLocations2x2OneLine: 
        .byte 0,1,0,1

    .label ROAD_COLOR = $0c

    show_points_counter: .byte 00
    offset:	.byte 00
    points: .byte 00, 00, 00
    game_counter: .byte 00, 00
    rows_count: .byte $0b

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

    tmp_tile: .byte 00, 00 
    current_tile_row: .byte 2

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

    DrawNextRow: {   
        set16(Screen.screen_base, Scr + 1)
        lda #<VIC.COLOR_RAM
        sta Color + 1
        lda #>VIC.COLOR_RAM
        sta Color + 2
        add16im(Scr + 1, 38, Scr +1)
        add16im(Color + 1, 38, Color + 1)

        lda current_tile_row
        cmp #$00
        bne !+
        set16(tmp_tile, Tile +1)    
    !:
        lda current_tile_row
        cmp #02
        bne !+
        set16(Tile + 1, tmp_tile)
    !:
        lda #$00
        sta Col
    !ColLoop:
        ldy current_tile_row

        lda #$00
        sta TileLookup + 2

    Tile:
        lda $BEEF	
        sta TileLookup + 1		
        asl TileLookup + 1
        rol TileLookup + 2
        asl TileLookup + 1
        rol TileLookup + 2

        //Add the MAP_TILES address
        clc
        lda #<Tiles
        adc TileLookup + 1
        sta TileLookup + 1
        lda #>Tiles
        adc TileLookup + 2
        sta TileLookup + 2

    TileLookup:
        lda $beef,y
        ldx TileScreenLocations2x2OneLine,y
    Scr:
        sta $beef,x
        tax
        lda Colors,x
        ldx TileScreenLocations2x2OneLine,y 
    Color:
        sta $BEEF, x //Self modified color ram
        iny
        cpy #$02
        beq !+
        cpy #$04
        beq !+
        jmp TileLookup
!:
        sec 
        lda Tile + 1
        sbc #$01
        sta Tile + 1
        lda Tile + 2
        sbc #$00
        sta Tile + 2
        sec
        lda Scr + 1
        sbc #$02
        sta Scr + 1
        sta Color + 1
        bcs !+
        dec Scr + 2
        dec Color + 2
  !:

        inc Col
        ldx Col
        cpx #20
        beq !+
        jmp !ColLoop-
  !:

        lda current_tile_row
        eor #2
        sta current_tile_row
        rts
    }

    // screen draw start
    // color draw start
    // num rows
    // map position
    DrawScreen: {   

        lda #<VIC.SCREEN_RAM + $03e7 - [40 * 6] - 1
        sta DrawRows.Scr + 1
        sta DrawRows.Color + 1

        lda #>VIC.SCREEN_RAM + $03e7 - [40 * 6] - 1
        sta DrawRows.Scr + 2
        lda #>VIC.COLOR_RAM + $03e7 - [40 * 6] - 1
        sta DrawRows.Color + 2

        lda #<MapEnd - 1
        sta DrawRows.Tile + 1
        lda #>MapEnd - 1
        sta DrawRows.Tile + 2
    }

    DrawRows: { 
        
        lda #$00
        sta Row
    !RowLoop:
        lda #$00
        sta Col
    !ColLoop:
        ldy #$00

        lda #$00
        sta TileLookup + 2

    Tile:
        lda $BEEF	
        sta TileLookup + 1		
        asl TileLookup + 1
        rol TileLookup + 2
        asl TileLookup + 1
        rol TileLookup + 2

        //Add the MAP_TILES address
        clc
        lda #<Tiles
        adc TileLookup + 1
        sta TileLookup + 1
        lda #>Tiles
        adc TileLookup + 2
        sta TileLookup + 2

    TileLookup:
        lda $beef,y
        ldx TileScreenLocations2x2,y
    Scr:
        sta $beef,x
        tax
        lda Colors,x
        ldx TileScreenLocations2x2, y 
    Color:
        sta $BEEF, x //Self modified color ram

        iny
        cpy #$04
        bne TileLookup

        sec 
        lda Tile + 1
        sbc #$01
        sta Tile + 1
        lda Tile + 2
        sbc #$00
        sta Tile + 2

        sec
        lda Scr + 1
        sbc #$02
        sta Scr + 1
        sta Color + 1
        bcs !+
        dec Scr + 2
        dec Color + 2
  !:

        inc Col
        ldx Col
        cpx #20
        beq !+
        jmp !ColLoop-
  !:
        sec
        lda Scr + 1
        lda Color + 1
        sbc #$28
        sta Scr + 1
        sta Color + 1
        bcs !+
        dec Scr + 2
        dec Color + 2
  !:
        inc Row
        ldx Row
        cpx rows_count
        beq !+
        jmp !RowLoop-
!:
        lda Tile + 1
        sta DrawNextRow.Tile + 1
        lda Tile + 2
        sta DrawNextRow.Tile + 2
        rts
    }

    GetCharPosition: {
        
        lda PLAYER.playerY
        sec
        sbc #44
        lsr
        lsr
        lsr
        tay
        
        lda PLAYER.playerX
        sec
        sbc #16
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

        // debug ////
        // lda #$c0
        // sta (PLAYER.playerScreenPosition),y
        // iny
        // sta (PLAYER.playerScreenPosition),y
        // ////////////
        
        jsr GetMaterial
        cmp #MATERIAL_SOLID
        bne !+
        .break
        ldx ROW
        ldy COL
        jsr SetTailAt

        lda PLAYER.playerScreenPosition + 1
        sbc #VIC.SCREEN_MSB
        tax
        lda PLAYER.playerScreenPosition
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
        txa
        lsr
        asl
        tax
        lda ScreenRowLSB,y
        sta temp
        LoadScreenMSB()
        sta temp + 1
        txa
        tay
        lda #$00
        sta (temp),y
        iny
        sta (temp),y
        sub16im(temp, 40, temp)
        dey
        lda #$00
        sta (temp),y
        iny
        sta (temp),y

        rts
    }

    SetCharacterAt: {
        sta temp
        lda ColorRowLSB,y
        sta PLAYER.playerScreenPosition
        lda ColorRowMSB,y
        sta PLAYER.playerScreenPosition+1
        sty temp + 1
        txa
        tay

        lda #06
        sta (PLAYER.playerScreenPosition),y
        ldy temp + 1
        
        lda ScreenRowLSB,y
        sta PLAYER.playerScreenPosition
        LoadScreenMSB()
        sta PLAYER.playerScreenPosition+1
        sty temp + 1
        txa
        tay

        lda #$c0
        .break
        sta (PLAYER.playerScreenPosition),y
        ldy temp + 1
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
        //jsr ScrollScreen
        jsr PLAYER.AnimateTurtle
        jsr HidePoints
        //jsr UpdateCounter
    

        //ldy #$ff
        //jsr VIC.WaitForFrame
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
        //jsr APPLES.check_last
        //jsr APPLES.move
        //jsr APPLES.GrabNew
    !:  
        ldx offset
        cpx #$07
        bne !+
        ldx #00
        //inc APPLES.counter
    !:
        inx
        stx offset 
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
