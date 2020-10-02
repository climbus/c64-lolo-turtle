BasicUpstart2(Start)

.import source "vic.asm"

.import source "player.asm"

.import source "apples.asm"

.import source "game.asm"

Start:
    jsr GAME.Init
    jsr GAME.DrawScreen
    jsr GAME.MainLoop
    rts
    
* = $7000 "Charset"
.import binary "assets/chars.bin"

* = $6000
.import binary "assets/sprites.bin"
