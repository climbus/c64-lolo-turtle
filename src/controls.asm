#import "player.asm"


CONTROLS: {
        
    .label JOY_PORT_2 = $dc00
    .label JOY_LT = %00100
    .label JOY_RT = %01000
    
    ReadJoy: {
        lda JOY_PORT_2
        and #JOY_LT
        bne !+
        lda GAME.left_material
        cmp #01
        beq !+
        jsr PLAYER.MoveLeft
        rts
    !:
    
        lda JOY_PORT_2
        and #JOY_RT
        bne !+
        lda GAME.right_material
        cmp #01
        beq !+
        jsr PLAYER.MoveRight
    !:
        rts
    }
}
