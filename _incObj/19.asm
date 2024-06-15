; ---------------------------------------------------------------------------
; Object 19 - BLAZE THE CAT IN subtitle
; ---------------------------------------------------------------------------
BlazeEmb:
        moveq    #$00,d0                    ; clear d0
        move.b    $24(a0),d0                ; load routine counter
        move.w    Obj19_Index(pc,d0.w),d1            ; get correct routine to run
        jmp    Obj19_Index(pc,d1.w)            ; jump to that routine
        
; ===========================================================================
; ---------------------------------------------------------------------------
Obj19_Index:    dc.w    Obj19_Start-Obj19_Index
        dc.w    Obj19_Drop-Obj19_Index
        dc.w    Obj19_Stand-Obj19_Index
        
; ---------------------------------------------------------------------------
; ===========================================================================
Obj19_Start:
        addq.b    #$02,$24(a0)                ; increase routine counter
        move.w    #$00E8,$08(a0)                ; set X position
        move.w    #$0000,$0A(a0)                ; set Y position
        move.l    #Map_obj19,4(a0)            ; set mappings to use
        move.w    #$0545,$02(a0)                ; set VRam location read
        move.b    #$00,$18(a0)                ; set plane type

; ---------------------------------------------------------------------------
; Object being dropped
; ---------------------------------------------------------------------------

Obj19_Drop:
        cmp.w    #$00A0,$0A(a0)                ; has titlecard reached bounce point yet?
        blt.s    .NoBounce                ; if not, branch
        tst.b    $28(a0)                    ; has bounce flag already been set?
        beq.s    .NoFin                ; if not, branch
        addq.b    #$02,$24(a0)                ; increase routine counter
        bra.s    Obj19_Stand                ; continue to stand routine

.NoFin:
        neg.w    $12(a0)                    ; reverse Y speed
        add.w    #$0020,$12(a0)                ; increase Y speed to prevent bouncing too high
        move.b    #$01,$28(a0)                ; set flag already bounced
        add.w    #$0010,$12(a0)                ; increase Y speed
        bra.s    .NoExtra                ; skip extra speed increase for one turn

.NoBounce:
        add.w    #$0010,$12(a0)                ; increase Y speed
        tst.b    $28(a0)                    ; has bounce flag already been set?
        beq.s    .NoExtra                ; if not, branch
        add.w    #$0030,$12(a0)                ; increase Y speed extra (To drop down quicker

.NoExtra:
        bsr.s    SpeedToPos2                ; convert speed to position

Obj19_Stand:
        jmp    DisplaySprite                ; present sprite on screen

; ---------------------------------------------------------------------------
; Subroutine to convert speed to position for screen/hud Objects
; ---------------------------------------------------------------------------

SpeedToPos2:
        move.l    $08(a0),d2                ; load X pos
        move.l    $0A(a0),d3                ; load Y pos
        move.w    $10(a0),d0                ; load X speed to d0
        ext.l    d0                    ; clear first word of data in register
        asl.l    #$08,d0                    ; multiply speed by 100
        add.l    d0,d2                    ; add to X position
        move.w    $12(a0),d0                ; load Y speed to d0
        ext.l    d0                    ; clear first word of data in register
        asl.l    #$08,d0                    ; multiply speed by 100
        add.l    d0,d3                    ; add to Y position
        move.l    d2,$08(a0)                ; save new X position
        move.l    d3,$0A(a0)                ; save new Y position
        rts                        ; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Mappings for "SALLY ACORN IN"
; ---------------------------------------------------------------------------
Map_obj19:
		include "../_maps/Blaze Emblem.asm"
; ---------------------------------------------------------------------------
