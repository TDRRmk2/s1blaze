Blaze_HoverSpd: equ 32

Blaze_Abilities:
		btst   #1, obStatus(a0)
		beq	   .ret
		cmpi.b #id_Hover, obAnim(a0)
		beq    Blaze_HoverTick
		;cmpi.b #id_AxelT, obAnim(a0)
		;beq    Blaze_AxelTick
        move.b (v_jpadpress1).w, d0
        andi.b #btnABC, d0
        beq    .ret
        cmpi.b #id_Roll, obAnim(a0)
		beq	   .AirAbilities
		cmpi.b #id_Roll2, obAnim(a0)
		beq	   .AirAbilities
		move.b #id_Roll, obAnim(a0)
		bra	   .ret
.AirAbilities:
		move.b #id_Hover, obAnim(a0)
.ret:
		rts

Blaze_HoverTick:
		move.b (v_jpadhold1).w, d0
        andi.b #btnABC, d0
		beq    .StopHover
		cmpi.w #Blaze_HoverSpd, obVelY(a0)
		ble	   .NoSpeedSet
		move.w #Blaze_HoverSpd, obVelY(a0)
.NoSpeedSet:
		move.w	obX(a0), d0
		move.w	obY(a0), d1
		btst   #0, obStatus(a0)
		bne	   .FaceRight
.FaceLeft:
		subi.w  #16, d0
		bra		.DoneFace
.FaceRight:
		addi.w  #16, d0
.DoneFace:
		addi.w  #12, d1
		bsr		Blaze_SpawnFlame
		bra    .ret
.StopHover:
		move.b #id_Roll, obAnim(a0)
.ret:
		rts

; in: d0 = xpos, d1 = ypos
Blaze_SpawnFlame:
		addq.b #1, (v_blzflametimer).w
		cmpi.b #4, (v_blzflametimer).w
		bne		Blaze_SpawnFlame_Return
		move.b #0, (v_blzflametimer).w
Blaze_SpawnFlame_NoTimer:
		movem.w	d0-d1,-(sp)
		jsr	(FindFreeObj).l
		bne		Blaze_SpawnFlame_Return
		move.b	#0, $29(a1)
		btst    #6, obStatus(a0)
		beq		.NotUnderwater
		move.b	#1, $29(a1)
.NotUnderwater:
		movem.w	(sp)+,d0-d1
		_move.b	#$4F, obID(a1)
		move.w	d0, obX(a1)
		move.w	d1, obY(a1)
Blaze_SpawnFlame_Return:
		rts
