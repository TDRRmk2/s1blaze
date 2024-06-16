; From Sonic 1 Squared (by Hivebrain)
WaterFilter:
		moveq	#0,d0
		move.b	(v_waterfilter_id).w,d0			; get filter id
		add.w	d0,d0					; multiply by 2
		move.w	Filter_Index(pc,d0.w),d0

		moveq	#0,d3
		move.w	#(4*16)-1,d1
		lea	(v_pal_dry_dup).w,a0
		lea	(v_pal_water).w,a1
		lea (v_pal_water_dup).w,a3
		lea	Filter_KeepList(pc),a2

	.loop:
		move.w	(a0)+,d2				; get colour
		tst.b	(a2,d3.w)				; check keeplist
		bne.s	.keepcolour				; branch if 1
		jsr	Filter_Index(pc,d0.w)
	.keepcolour:
		move.w	d2,(a1)+				; write colour
		move.w	d2,(a3)+				; write colour
		addq.w	#1,d3					; increment counter
		dbf	d1,.loop				; repeat for all colours
		rts

; ---------------------------------------------------------------------------
; Functions applied to each colour

; input:
;	d2 = single colour
; ---------------------------------------------------------------------------

Filter_Index:	dc.w Filter_LZ-Filter_Index
				dc.w Filter_SBZ3-Filter_Index

Filter_LZ:
		andi.w	#$CE2,d2				; remove most red & some blue
		rts

Filter_SBZ3:
		andi.w	#$E0E,d2				; remove green
		rts

; ---------------------------------------------------------------------------
; Array listing which colours are filtered and which are kept
; ---------------------------------------------------------------------------

Filter_KeepList:
		dc.b 1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1		; 0 = filter colour; 1 = keep colour
		dc.b 1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0
		dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		even
