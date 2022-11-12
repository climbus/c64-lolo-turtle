#import "player.asm"


CONTROLS: {
        
    .label JOY_PORT_2 = $dc00
    .label JOY_LT = %00100
    .label JOY_RT = %01000
    .label JOY_UP = %000001
    .label JOY_DOWN = %00010
    
    ReadJoy: {
        lda JOY_PORT_2
        and #JOY_LT
        bne !+
        lda COLLISIONS.left_material
        cmp #01
        beq !+
        jsr PLAYER.MoveLeft
        jmp UpDown
    !:
    
        lda JOY_PORT_2
        and #JOY_RT
        bne !+
        lda COLLISIONS.right_material
        cmp #01
        beq !+
        jsr PLAYER.MoveRight
    !:
    UpDown:
        lda JOY_PORT_2
        and #JOY_UP
        bne !+
        lda COLLISIONS.front_material
        cmp #01
        beq !+
        jsr PLAYER.MoveUp
        rts
    !:
    
        lda JOY_PORT_2
        and #JOY_DOWN
        bne !+
        lda COUNTER
        and #$01
        bne !+
        jsr PLAYER.MoveDown
    !:
        rts
    }

    WaitForFire: {
    !:
        lda JOY_PORT_2
        and #$10 
        bne !-
    !:
        lda JOY_PORT_2
        and #$10 
        beq !-
        rts
    }

    CheckFire: {
        lda JOY_PORT_2
        and #$10 
        rts
    }
}
