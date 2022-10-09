#import "zero_page.asm"

BasicUpstart2(Start)

#import "macros.asm"
#import "vic.asm"
#import "player.asm"
#import "apples.asm"
#import "game.asm"
#import "screen.asm"

Start:
    jsr GAME.Init
    jsr LEVEL.DrawScreen
    jsr Screen.Init
    jsr IRQ.Setup
    jsr GAME.MainLoop
    rts

* = $6000 "Sprites"
.import binary "assets/sprites.bin"

