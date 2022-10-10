#import "zero_page.asm"

BasicUpstart2(Start)

#import "macros.asm"
#import "vic.asm"
#import "player.asm"
#import "game.asm"
#import "screen.asm"
#import "hud.asm"

Start:
    jsr GAME.Init
    jsr Screen.Init
    jsr LEVEL.DrawScreen
    jsr HUD.Draw
    jsr IRQ.Setup
    jsr GAME.MainLoop
    rts

* = $6000 "Sprites"
.import binary "assets/sprites.bin"

