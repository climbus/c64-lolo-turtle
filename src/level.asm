LEVEL: {
    TileScreenLocations2x2: 
        .byte 0,1,40,41

    TileScreenLocations2x2OneLine: 
        .byte 0,1,0,1
    
    rowsCount: .byte $0b
    currentTileRow: .byte 2

    DrawNextRow: {   
        .label COL = TMP4
        .label ROW = TMP5
        .label TMP_TILE = TMP6

        set16(Screen.screen_base, Scr + 1)
        lda #<VIC.COLOR_RAM
        sta Color + 1
        lda #>VIC.COLOR_RAM
        sta Color + 2
        add16im(Scr + 1, 38, Scr +1)
        add16im(Color + 1, 38, Color + 1)

        lda currentTileRow
        cmp #$00
        bne !+
        set16(TMP_TILE, Tile +1)    
    !:
        lda currentTileRow
        cmp #02
        bne !+
        set16(Tile + 1, TMP_TILE)
    !:
        lda #$00
        sta COL
    !ColLoop:
        ldy currentTileRow

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

        inc COL
        ldx COL
        cpx #20
        beq !+
        jmp !ColLoop-
  !:

        lda currentTileRow
        eor #2
        sta currentTileRow
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
        .label COL = TMP4
        .label ROW = TMP5
        .const ROWS_COUNT = $0b
        
        lda #$00
        sta ROW
    !RowLoop:
        lda #$00
        sta COL
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

        inc COL
        ldx COL
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
        inc ROW
        ldx ROW
        cpx rowsCount
        beq !+
        jmp !RowLoop-
!:
        lda Tile + 1
        sta DrawNextRow.Tile + 1
        lda Tile + 2
        sta DrawNextRow.Tile + 2
        rts
    }
}