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

    jsr DIALOG.ShowGetReady

    jsr IRQ.Setup
    lda #$00
    sta COUNTER
    jsr GAME.MainLoop
    rts

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
	.import binary "./assets/map.bin"
MapEnd:
