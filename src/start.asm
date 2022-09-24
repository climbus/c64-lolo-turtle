BasicUpstart2(Start)

#import "vic.asm"
#import "player.asm"
#import "apples.asm"
#import "game.asm"

Start:
    jsr GAME.Init
    jsr GAME.DrawScreen
    jsr GAME.MainLoop
    rts

* = $6000
.import binary "assets/sprites.bin"
