; ---------------------------------------------------------------------------
; Object 4F - flame from Blaze's abilities
; ---------------------------------------------------------------------------
Obj4F:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FlameB_Index(pc,d0.w),d1
		jsr	FlameB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
FlameB_Index:	dc.w FlameB_Main-FlameB_Index
				dc.w FlameB_Slower-FlameB_Index
; ===========================================================================

FlameB_Main:	; Routine 0
		move.b  #0,obFrame(a0)
		move.b	#0,obAnim(a0)
		addq.b	#2,obRoutine(a0)
		cmpi.b  #1, $29(a0)
		bne		.NotBubble
		move.l	#Map_Bub,obMap(a0)
		move.w	#make_art_tile(ArtTile_LZ_Bubbles,0,1),obGfx(a0)
		bra		.DoneArt
.NotBubble:
		move.l	#Map_FlameB,obMap(a0)
		move.w	#make_art_tile(ArtTile_Flame,0,0),obGfx(a0)
.DoneArt:
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$150,obVelY(a0) ; move object upwards

FlameB_Slower:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.w	DeleteObject	; if not, delete
		bsr.w	SpeedToPos
		addi.w	#$10,obVelY(a0)	; reduce object	speed
		lea	(Ani_FlameB).l,a1
		jsr	(AnimateSprite).l
		rts	
