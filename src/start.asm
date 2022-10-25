#import "zero_page.asm"

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

* = $6000 "Sprites"
.import binary "assets/sprites.bin"

