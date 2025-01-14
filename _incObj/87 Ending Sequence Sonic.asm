; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence
; ---------------------------------------------------------------------------

EndSonic:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	dc.w ESon_Main-ESon_Index, ESon_MakeEmeralds-ESon_Index
		dc.w Obj87_Animate-ESon_Index,	Obj87_LookUp-ESon_Index
		dc.w Obj87_ClrObjRam-ESon_Index, Obj87_Animate-ESon_Index
		dc.w Obj87_MakeLogo-ESon_Index, Obj87_Animate-ESon_Index
		dc.w Obj87_Leap-ESon_Index, Obj87_Animate-ESon_Index

eson_time = objoff_30	; time to wait between events
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	ESon_Main2	; if yes, branch
		addi.b	#$10,ob2ndRout(a0) ; else, skip emerald sequence
		move.w	#216,eson_time(a0)
		rts	
; ===========================================================================

ESon_Main2:
		addq.b	#2,ob2ndRout(a0)
		move.l	#Map_ESon,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ending_Sonic,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		clr.b	obStatus(a0)
		move.b	#2,obPriority(a0)
		move.b	#0,obFrame(a0)
		move.w	#80,eson_time(a0) ; set duration for Sonic to pause

ESon_MakeEmeralds:
		; Routine 2
		subq.w	#1,eson_time(a0) ; subtract 1 from duration
		bne.s	ESon_Wait
		addq.b	#2,ob2ndRout(a0)
		move.w	#1,obAnim(a0)
		move.b	#id_EndChaos,(v_endemeralds).w ; load chaos emeralds objects

ESon_Wait:
		rts	
; ===========================================================================

Obj87_LookUp:	; Routine 6
		cmpi.w	#$2000,((v_endemeralds+echa_radius)&$FFFFFF).l
		bne.s	locret_5480
		move.w	#1,(f_restart).w ; set level to	restart	(causes	flash)
		move.w	#90,eson_time(a0)
		addq.b	#2,ob2ndRout(a0)

locret_5480:
		rts	
; ===========================================================================

Obj87_ClrObjRam:
		; Routine 8
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait2
		lea	(v_endemeralds).w,a1
		move.w	#(v_endemeralds_end-v_endemeralds)/4-1,d1

Obj87_ClrLoop:
		clr.l	(a1)+
		dbf	d1,Obj87_ClrLoop ; clear the object RAM
		move.w	#1,(f_restart).w
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.w	#60,eson_time(a0)

ESon_Wait2:
		rts	
; ===========================================================================

Obj87_MakeLogo:	; Routine $C
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait3
		addq.b	#2,ob2ndRout(a0)
		move.w	#180,eson_time(a0)
		move.b	#2,obAnim(a0)
		move.b	#id_EndSTH,(v_endlogo).w ; load "SONIC THE HEDGEHOG" object

ESon_Wait3:
		rts	
; ===========================================================================

Obj87_Animate:	; Rountine 4, $A, $E, $12
		lea	(AniScript_ESon).l,a1
		jsr	(AnimateSprite).l
		cmpi.b #6, obFrame(a0)
		beq	.JumpFrame1
		cmpi.b #7, obFrame(a0)
		beq .JumpFrame2
		bra	.ret
.JumpFrame1:
		move.w #0, obVelY(a0)
		move.w #400, obY(a0)
		bra .ret
.JumpFrame2:
		move.w #0, obVelY(a0)
		move.w #360, obY(a0)
.ret:
		rts
; ===========================================================================

Obj87_Leap:	; Routine $10
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait4
		addq.b	#2,ob2ndRout(a0)
		move.l	#Map_ESon,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ending_Sonic,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		clr.b	obStatus(a0)
		move.b	#2,obPriority(a0)
		move.b	#5,obFrame(a0)
		move.b	#2,obAnim(a0)	; use "leaping"	animation
		move.b	#id_EndSTH,(v_endlogo).w ; load "SONIC THE HEDGEHOG" object
		bra		Obj87_Animate
; ===========================================================================

ESon_Wait4:
		rts	
