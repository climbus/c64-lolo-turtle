#import "zero_page.asm"

.var music = LoadSid("assets/moving.sid")

BasicUpstart2(Start)

#import "macros.asm"
#import "vic.asm"
#import "player.asm"
#import "game.asm"
#import "screen.asm"
#import "hud.asm"
#import "dialog.asm"

Start:
    jsr GAME.Init
    jsr Screen.Init
    jsr LEVEL.DrawScreen
    jsr HUD.Draw
    jsr PLAYER.Init
    lda #GAME.STATE_PAUSE
    sta GAME.state
    jsr IRQ.Setup
    jsr DIALOG.ShowGetReady
    lda #$00
    sta COUNTER
    lda #GAME.STATE_RUN
    sta GAME.state
    jsr GAME.MainLoop
    jmp Start

* = music.location "Music"
    .fill music.size, music.getData(i)

* = $4000 "Screen RAM" virtual
    .fill $800, 0

* = $6000 "Sprites"
    .import binary "assets/sprites.bin"

* = $7000 "Charset"
Chars:
	.import binary "./assets/chars.bin"
CharsEnd:

* = $d800 "Color RAM" virtual
    .fill $400, 0

* = $8000
Map:
	.import binary "./assets/map1.bin"
MapEnd:
Map2:
    .import binary "./assets/map2.bin"
MapEnd2:
