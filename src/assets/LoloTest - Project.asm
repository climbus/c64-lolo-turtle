
; Generated by CharPad - Subchrist Software, 2003-2022.
; Assemble with 64TASS or similar.


; Display mode : Text (Multi-colour).
; Matrix colouring method : Per Character.


; Colour values...

COLR_VIC_SCREEN = 8
COLR_VIC_CHAR_MC1 = 11
COLR_VIC_CHAR_MC2 = 7
COLR_CMLO_BASE = 8


; Quantities and dimensions...

CHAR_COUNT = 97
TILE_COUNT = 47
TILE_WID = 2
TILE_HEI = 2
MAP_WID = 20
MAP_HEI = 80
MAP_WID_CHRS = 40
MAP_HEI_CHRS = 160
MAP_WID_PXLS = 320
MAP_HEI_PXLS = 1280


; Data block sizes (in bytes)...

SZ_CHARSET_DATA = 776 ; ($308)
SZ_CHARSET_ATTRIB_DATA = 97 ; ($61)
SZ_TILESET_DATA = 188 ; ($BC)
SZ_MAP_DATA = 1600 ; ($640)


; Data block addresses (dummy values)...

addr_charset_data = $1000
addr_charset_attrib_L1_data = $1000
addr_chartileset_data = $1000
addr_chartileset_tag_data = $1000
addr_map_data = $1000




; * INSERT EXAMPLE PROGRAM HERE! * (or just include this file in your project).




; CharSet Data...
; 97 images, 8 bytes per image, total size is 776 ($308) bytes.

* = addr_charset_data
charset_data

.byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$29,$2F,$2F,$3F,$1F,$57
.byte $21,$BD,$BE,$FE,$FF,$FF,$AF,$BF,$2B,$AF,$BF,$BE,$FF,$1F,$3F,$BF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$08,$2D,$ED,$FF,$FF,$FF,$FF,$FF
.byte $31,$FD,$FF,$BF,$BF,$FD,$FF,$FF,$48,$7F,$FF,$FF,$FF,$FF,$FB,$FF
.byte $10,$50,$60,$BC,$BC,$FC,$F5,$D4,$FC,$BF,$FF,$FF,$FC,$F5,$ED,$FF
.byte $FF,$FF,$0B,$3F,$5F,$1D,$2F,$BF,$FF,$3F,$5F,$3F,$3F,$5F,$7F,$FF
.byte $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$EB,$EE,$EF,$FF,$FF,$BF
.byte $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF
.byte $FF,$FF,$FF,$F7,$D7,$FF,$FF,$FF,$1F,$3F,$FF,$FF,$FF,$FF,$FD,$3F
.byte $17,$5F,$3F,$3F,$3F,$3D,$05,$01,$FF,$DF,$FF,$FF,$FF,$FF,$FD,$75
.byte $FF,$FF,$7F,$FD,$F5,$FF,$7F,$5D,$FF,$FF,$FF,$FF,$FF,$77,$75,$55
.byte $F4,$DC,$D7,$DF,$FF,$FF,$7D,$FC,$FF,$FD,$75,$FD,$FF,$FF,$7F,$55
.byte $D4,$F5,$FC,$FC,$FC,$70,$50,$40,$00,$00,$00,$28,$2D,$2D,$3D,$05
.byte $50,$75,$7C,$5D,$1C,$41,$45,$51,$C0,$00,$00,$C0,$00,$00,$00,$00
.byte $47,$DF,$47,$D3,$07,$13,$47,$1F,$00,$C0,$00,$00,$00,$00,$00,$C0
.byte $03,$00,$00,$00,$00,$03,$00,$00,$5F,$DF,$FF,$FF,$DD,$47,$CD,$47
.byte $00,$00,$00,$00,$00,$00,$00,$03,$C1,$47,$C0,$47,$C0,$43,$C0,$40
.byte $D5,$F7,$FF,$FF,$FF,$DF,$FF,$DF,$77,$7F,$FF,$FF,$F7,$FF,$F7,$F3
.byte $4F,$DF,$47,$1F,$17,$1F,$47,$1F,$F3,$F1,$F7,$F1,$F5,$FD,$F5,$FD
.byte $77,$7F,$FF,$7F,$F7,$7F,$77,$73,$33,$71,$37,$71,$35,$7D,$F5,$3D
.byte $D5,$F7,$FF,$FF,$FF,$DF,$7F,$3F,$77,$7F,$FF,$FF,$F7,$FD,$FF,$FD
.byte $7F,$3F,$7F,$3D,$37,$1D,$44,$10,$FF,$FD,$FF,$DD,$75,$5D,$05,$01
.byte $D7,$F7,$FF,$FF,$F7,$DF,$F7,$DF,$03,$0F,$31,$05,$00,$00,$00,$00
.byte $00,$30,$77,$D5,$44,$00,$00,$00,$5C,$17,$01,$50,$01,$00,$00,$00
.byte $4F,$30,$04,$00,$00,$00,$00,$00,$0D,$1D,$07,$11,$00,$00,$00,$00
.byte $43,$0C,$44,$00,$00,$00,$00,$00,$C0,$70,$14,$00,$00,$00,$00,$00
.byte $03,$0D,$00,$00,$00,$00,$00,$00,$11,$1C,$0C,$07,$00,$00,$00,$00
.byte $D0,$F0,$14,$00,$40,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $51,$55,$F7,$0C,$F3,$FF,$FF,$FF,$04,$55,$5D,$F3,$0C,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$7D,$14,$FF,$FF,$FF,$FF,$FF,$FF,$D7,$41
.byte $00,$01,$01,$01,$05,$07,$17,$5C,$73,$CF,$FF,$FF,$FF,$3F,$FF,$FF
.byte $00,$40,$40,$40,$50,$D0,$D4,$35,$CD,$F3,$FF,$FF,$FF,$FC,$FF,$FF
.byte $7F,$1F,$07,$07,$01,$01,$01,$01,$FD,$F4,$D0,$D0,$40,$40,$40,$40
.byte $73,$CF,$FF,$FF,$FF,$FF,$FF,$FF,$CD,$F3,$FF,$FF,$FF,$FF,$FF,$FF
.byte $00,$00,$00,$10,$30,$00,$00,$00,$00,$00,$00,$10,$44,$10,$00,$00
.byte $01,$45,$01,$00,$00,$00,$00,$00,$10,$44,$10,$00,$00,$00,$00,$00
.byte $00,$00,$00,$11,$40,$91,$44,$91,$00,$00,$00,$10,$00,$13,$44,$13
.byte $51,$55,$F7,$0C,$FA,$FA,$F0,$F1,$44,$91,$44,$91,$44,$91,$44,$91
.byte $F5,$F1,$F5,$F5,$FF,$FC,$F3,$FC,$C4,$11,$44,$91,$44,$91,$44,$91
.byte $45,$13,$45,$13,$45,$13,$45,$13,$04,$55,$5D,$F3,$AC,$AF,$0F,$1F
.byte $5F,$1F,$5F,$5F,$FF,$CF,$3F,$CF,$FF,$FF,$FF,$FF,$FA,$FA,$F0,$F1
.byte $F5,$F1,$F5,$F5,$FF,$FC,$71,$14,$FF,$FF,$FF,$FF,$AF,$AF,$0F,$1F
.byte $5F,$1F,$5F,$5F,$FF,$CF,$17,$41,$44,$91,$44,$00,$04,$00,$00,$00
.byte $45,$13,$45,$01,$44,$00,$00,$00,$00,$00,$00,$01,$05,$05,$15,$15
.byte $00,$00,$40,$50,$50,$74,$74,$DC,$17,$15,$15,$15,$15,$37,$0F,$00
.byte $5C,$5D,$7D,$FD,$FD,$FD,$F4,$00,$51,$55,$F7,$0C,$F3,$FF,$FD,$F7
.byte $04,$55,$5D,$F3,$0C,$FF,$DF,$7F,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $DF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$00,$04,$17,$5D,$57,$5F,$3D,$00
.byte $00,$00,$00,$00,$40,$40,$00,$00



; CharSet Attribute Data (L1)...
; 97 attributes, 1 attribute per image, 8 bits per attribute, total size is 97 ($61) bytes.
; nb. Upper nybbles = material, lower nybbles = colour (colour matrix low).

* = addr_charset_attrib_L1_data
charset_attrib_L1_data

.byte $00,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
.byte $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$08,$08,$08,$08,$08
.byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
.byte $08,$08,$08,$08,$08,$08,$08,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
.byte $0B,$0B,$0B,$0B,$08,$0D,$0D,$0D,$08,$08,$0B,$08,$0B,$08,$08,$0B
.byte $0B,$0B,$0B,$0B,$0B,$08,$08,$08,$08,$08,$08,$0B,$0B,$0B,$0B,$08
.byte $08



; CharTileSet Data...
; 47 tiles, 2x2 (4) cells per tile, 8 bits per cell, total size is 188 ($BC) bytes.

* = addr_chartileset_data
chartileset_data

.byte $00,$00,$00,$00,$01,$02,$03,$04,$05,$06,$04,$04,$07,$08,$04,$09
.byte $0A,$04,$0B,$0C,$04,$04,$04,$04,$0D,$04,$04,$04,$04,$0E,$0F,$10
.byte $11,$04,$12,$13,$04,$04,$14,$15,$04,$16,$17,$18,$00,$00,$00,$19
.byte $1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$22,$26,$24,$27
.byte $28,$29,$2A,$2B,$2C,$1B,$1C,$1D,$2D,$2E,$00,$00,$2F,$30,$00,$00
.byte $31,$32,$00,$00,$33,$34,$00,$00,$35,$36,$00,$00,$37,$37,$37,$37
.byte $38,$39,$37,$37,$37,$37,$3A,$3B,$00,$3C,$3C,$3D,$3E,$00,$3F,$3E
.byte $40,$37,$00,$40,$37,$41,$41,$00,$42,$37,$37,$37,$37,$43,$37,$37
.byte $44,$00,$00,$00,$00,$00,$00,$45,$00,$00,$46,$47,$00,$00,$00,$44
.byte $00,$00,$00,$48,$00,$00,$49,$00,$4A,$4B,$4C,$4D,$4E,$4F,$4E,$50
.byte $51,$4B,$52,$4D,$4E,$53,$4E,$54,$00,$55,$00,$00,$56,$00,$00,$00
.byte $57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,$60,$00,$00



; CharTileSet Tag Data...
; 47 tags, 1 per tile, 8 bits each, total size is 47 ($2F) bytes.

* = addr_chartileset_tag_data
chartileset_tag_data

.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00



; Map Data...
; 20x80 (1600) cells, 8 bits per cell, total size is 1600 ($640) bytes.

* = addr_map_data
map_data

.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$2E,$20,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$22,$00,$23,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$21,$00,$20,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $01,$02,$03,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$08,$09,$0A,$00,$2C,$22,$00,$23,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$0E,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$12,$13,$14,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$01,$02,$03,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$21,$00,$00,$00,$21,$00,$00,$00,$2C
.byte $08,$09,$0A,$00,$00,$2E,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$0E,$00,$00,$00,$00,$00,$00,$2C,$20,$00,$21
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$12,$13,$14,$00,$00,$00,$00,$00
.byte $2C,$22,$00,$23,$00,$00,$00,$20,$00,$00,$00,$2C,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$23,$00,$00,$00
.byte $23,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$21,$00,$00,$23,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $01,$02,$03,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$08,$09,$0A,$00,$2C,$00,$21,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$0E,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$12,$13,$14,$00
.byte $2C,$00,$00,$00,$23,$00,$00,$00,$21,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$2E,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$23,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$21,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$23,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$23,$21,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$01,$02,$03
.byte $00,$00,$00,$00,$2C,$00,$00,$21,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$08,$09,$0A,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$2C,$2C,$00,$00,$0E,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$2C,$2C,$00,$12,$13,$14,$00,$2E,$00,$00
.byte $2C,$00,$00,$23,$00,$00,$00,$00,$00,$00,$2C,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$21,$00,$00,$00,$00,$00,$00,$00,$2C,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$2C,$00,$00
.byte $00,$00,$00,$21,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$2C,$00,$00,$00,$00,$00,$21,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$2E,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$01,$02,$03,$2C,$00,$00,$21
.byte $00,$00,$00,$23,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$08,$09,$0A
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$21,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$0E,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$12,$13,$14,$2C,$00,$21,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$23,$00,$00,$00,$00,$21,$00,$00,$2C,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$23,$00,$21,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$2E,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$21,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$23,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$2E,$00,$01,$02,$03,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$08,$09,$0A,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$21,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$0E,$00,$00,$2C,$00,$00,$00,$21,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$12,$13,$14,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$01,$02,$03,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$21,$00,$00,$2C,$08,$09,$0A,$00,$00,$00,$00,$2C
.byte $2C,$00,$00,$23,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$0E,$00,$00
.byte $00,$00,$00,$2C,$2C,$00,$00,$00,$00,$00,$00,$00,$23,$00,$00,$2C
.byte $12,$13,$14,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$21,$00,$00,$00,$00,$00,$2C,$00,$2E,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$21,$00,$00,$00,$00,$21,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$23,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$2E,$00,$00,$2C,$00,$00,$21
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$23,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$2E,$00,$00,$00,$00,$00,$2C,$00,$00,$23,$00,$00,$00,$21
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$01,$02,$03,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$08,$09,$0A,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$0E,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$12,$13,$14,$00,$2C,$00,$00,$23,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$21
.byte $00,$00,$23,$00,$00,$21,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$01,$02,$03,$00
.byte $00,$00,$00,$00,$2C,$00,$00,$00,$21,$00,$00,$00,$00,$00,$00,$2C
.byte $08,$09,$0A,$00,$00,$00,$00,$00,$2C,$00,$23,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$0E,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00
.byte $00,$00,$00,$23,$00,$00,$00,$2C,$12,$13,$14,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$21,$00,$21,$00,$00,$00,$00,$2C,$00,$00,$00,$00
.byte $00,$2E,$00,$00,$2C,$00,$00,$23,$00,$00,$00,$00,$00,$00,$00,$2C
.byte $00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$21
.byte $00,$00,$00,$23,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00
.byte $2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00


