; ---------------------------------------------------------------------------
; Object 81 - Sonic on the continue screen
; ---------------------------------------------------------------------------

ContSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSon_Index(pc,d0.w),d1
		jsr	CSon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
CSon_Index:	dc.w CSon_Main-CSon_Index
		dc.w CSon_ChkLand-CSon_Index
		dc.w CSon_Animate-CSon_Index
		dc.w CSon_Run-CSon_Index
; ===========================================================================

CSon_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obX(a0)
		move.w	#$C0,obY(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#id_Fall,obAnim(a0) ; use "floating" animation
		move.w	#$400,obVelY(a0) ; make Sonic fall from above

CSon_ChkLand:	; Routine 2
		cmpi.w	#$1A0-8,obY(a0)	; has Sonic landed yet?
		bne.s	CSon_ShowFall	; if not, branch

		addq.b	#2,obRoutine(a0)
		clr.w	obVelY(a0)	; stop Sonic falling
		;move.l	#Map_ContScr,obMap(a0)
		;move.w	#make_art_tile(ArtTile_Continue_Sonic,0,1),obGfx(a0)
		move.b	#id_TapWait,obAnim(a0)
		bra.s	CSon_Animate

CSon_ShowFall:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
; ===========================================================================

CSon_Animate:	; Routine 4
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bmi.s	CSon_GetUp	; if yes, branch
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l

CSon_GetUp:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.b	#id_Walk,obAnim(a0)
		clr.w	obInertia(a0)
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special ; fade out music

CSon_Run:	; Routine 6
		cmpi.w	#$800,obInertia(a0) ; check Sonic's inertia
		bne.s	CSon_AddInertia	; if too low, branch
		move.w	#$1000,obVelX(a0) ; move Sonic to the right
		bra.s	CSon_ShowRun

CSon_AddInertia:
		addi.w	#$20,obInertia(a0) ; increase inertia

CSon_ShowRun:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
