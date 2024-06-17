Blaze_FlameFreq: equ 4
Blaze_HoverSpd: equ 32
Blaze_AxelSpd: equ -1750

Blaze_Abilities:
		btst    #1, obStatus(a0)
		beq	    .ret
		move.b  obAnim(a0), d0
		cmpi.b  #id_Hover, d0
		beq     Blaze_HoverTick
		cmpi.b  #id_AxelT, d0
		beq     Blaze_AxelTick
		cmpi.b  #id_Fall, d0
		beq     .ret
		cmpi.b  #id_AirDash, d0
		beq     .ret
        move.b  (v_jpadpress1).w, d1
        andi.b  #btnABC, d1
        beq     .ret
        cmpi.b  #id_Roll, d0
		beq	    .AirAbilities
		cmpi.b  #id_Roll2, d0
		beq	    .AirAbilities
		move.b  #id_Roll, obAnim(a0) ; do the air roll
		bra	    .ret
.AirAbilities:
		move.w	#sfx_Fireball,d0
		jsr	(PlaySound_Special).l
		move.b  (v_jpadhold1).w, d0
        andi.b  #btnDn, d0
        bne     .DoHover
		move.b  (v_jpadhold1).w, d0
        andi.b  #btnUp, d0
        bne     .DoAxel
        move.b  (v_jpadhold1).w, d0
        andi.b  #btnL|btnR, d0
        bne     .DoAirDash
.DoHover:
		move.b  #id_Hover, obAnim(a0)
		bra	    .ret
.DoAxel:
		move.b  #id_AxelT, obAnim(a0)
		move.w  #Blaze_AxelSpd, obVelY(a0)
		btst    #6, obStatus(a0)
		beq		.ret
		move.w  #Blaze_AxelSpd/2, obVelY(a0)
		bra     .ret
.DoAirDash:
		move.w  (v_sonspeedmax).w, obVelX(a0)
		move.w	obX(a0), d0
		move.b  (v_jpadhold1).w, d1
        andi.b  #btnR, d1
        bne     .FacingRight
        neg.w	obVelX(a0)
        bset	#0, obStatus(a0)
        addi.w  #16, d0
        bra		.DoneFacing
.FacingRight:
		subi.w  #16, d0
		bclr	#0, obStatus(a0)
.DoneFacing:
		move.w  obY(a0), d1
		addi.w  #12, d1
		bsr		Blaze_SpawnFlame_NoTimer
		move.b  #id_AirDash, obAnim(a0)
		move.w  #-256, obVelY(a0)
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

Blaze_AxelTick:
		cmpi.w  #0, obVelY(a0)
		blt	    .Rising
		move.b  #id_Fall, obAnim(a0)
		bra     .ret
.Rising:
		addq.b  #1, (v_blzflametimer).w
		cmpi.b  #Blaze_FlameFreq, (v_blzflametimer).w
		bne		.ret
		move.b  #0, (v_blzflametimer).w
		move.w  obX(a0), d0
		move.w  obY(a0), d1
		subi.w  #10, d0
		bsr     Blaze_SpawnFlame_NoTimer
		addi.w  #20, d0
		bsr     Blaze_SpawnFlame_NoTimer
.ret:
		rts

; in: d0 = xpos, d1 = ypos
Blaze_SpawnFlame:
		addq.b  #1, (v_blzflametimer).w
		cmpi.b  #Blaze_FlameFreq, (v_blzflametimer).w
		bne		Blaze_SpawnFlame_Return
		move.b  #0, (v_blzflametimer).w
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
