	.file	"conv2d_baked_linked"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI0_0:
	.word	0xbd85e773
	.word	0xbc545be6
	.word	0x3da08ee5
	.word	0x3e18ed67
	.section	.text.infer_dispatch_0_conv_6x6x4x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_0_conv_6x6x4x3x3_f32,@function
infer_dispatch_0_conv_6x6x4x3x3_f32:
.Lfunc_begin0:
	.file	1 "results/e14_aarch64_qemu/aarch64/dump/conv2d" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	sub	x9, sp, #112
	mov	x29, sp
	and	sp, x9, #0xffffffffffffffc0
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
.Ltmp10:
	.loc	1 13 8 prologue_end
	ldr	x10, [x1, #32]
	mov	w9, #3
	.loc	1 18 8
	ldr	w11, [x2]
	adrp	x15, .LCPI0_0
	mov	w13, #96
	mov	x8, xzr
	.loc	1 10 8
	stp	xzr, xzr, [sp]
	.loc	1 13 8
	ldp	x12, x14, [x10]
	.loc	1 18 8
	tst	w11, #0x1
	lsr	x10, x11, #1
	csel	x9, x9, xzr, ne
	ldr	q0, [x15, :lo12:.LCPI0_0]
	adrp	x15, __constant_3x3x4xf32
	add	x15, x15, :lo12:__constant_3x3x4xf32
	add	x11, x12, x9, lsl #2
	umaddl	x12, w10, w13, x14
	mov	x13, sp
	add	x14, sp, #64
	.loc	1 0 8 is_stmt 0
.Ltmp11:
	.p2align	4, , 8
.LBB0_1:
	mov	x16, xzr
	.p2align	4, , 8
.LBB0_2:
	.loc	1 18 8 is_stmt 1
	ldr	s1, [x13, x16]
	str	s1, [x14, x16]
	add	x16, x16, #4
	cmp	x16, #16
	b.ne	.LBB0_2
	.loc	1 0 8 is_stmt 0
	mov	x16, xzr
	.loc	1 18 8
	add	x17, x11, x8, lsl #2
	mov	x0, x15
	.loc	1 0 8
.Ltmp12:
	.p2align	4, , 8
.LBB0_4:
	.loc	1 18 8
	add	x2, x16, x10
	mov	x1, xzr
	mov	x3, x0
	add	x2, x17, x2, lsl #5
	.loc	1 0 8
.Ltmp13:
	.p2align	4, , 8
.LBB0_5:
	ldr	s1, [x2, x1, lsl #2]
	mov	x4, xzr
	.p2align	4, , 8
.LBB0_6:
	.loc	1 18 8 is_stmt 1
	ldr	s2, [x3, x4]
	ldr	s3, [x14, x4]
	.loc	1 21 10
	fmadd	s2, s1, s2, s3
	.loc	1 18 8
	str	s2, [x14, x4]
	add	x4, x4, #4
	cmp	x4, #16
	b.ne	.LBB0_6
	add	x1, x1, #1
	add	x3, x3, #16
	cmp	x1, #3
	b.ne	.LBB0_5
	add	x16, x16, #1
	add	x0, x0, #48
	cmp	x16, #3
	b.ne	.LBB0_4
	.loc	1 24 8
	ldr	q1, [sp, #64]
	.loc	1 18 8
	add	x16, x8, x9
	add	x8, x8, #1
	cmp	x8, #3
	.loc	1 26 10
	fadd	v1.4s, v1.4s, v0.4s
	.loc	1 27 10
	fcmle	v2.4s, v1.4s, #0.0
	bic	v1.16b, v1.16b, v2.16b
	.loc	1 18 8
	str	q1, [x12, x16, lsl #4]
	b.ne	.LBB0_1
	.loc	1 31 8
	mov	w0, wzr
	.loc	1 31 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
.Ltmp14:
.Lfunc_end0:
	.size	infer_dispatch_0_conv_6x6x4x3x3_f32, .Lfunc_end0-infer_dispatch_0_conv_6x6x4x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_conv_4x4x8x3x3x4_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_1_conv_4x4x8x3x3x4_f32,@function
infer_dispatch_1_conv_4x4x8x3x3x4_f32:
.Lfunc_begin1:
	.file	2 "results/e14_aarch64_qemu/aarch64/dump/conv2d" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	sub	x9, sp, #112
	mov	x29, sp
	and	sp, x9, #0xffffffffffffffc0
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
.Ltmp15:
	.loc	2 13 8 prologue_end
	ldr	x9, [x1, #32]
	mov	w12, #96
	.loc	2 20 8
	ldr	w10, [x2]
	mov	x8, xzr
	.loc	2 9 8
	stp	xzr, xzr, [sp]
	.loc	2 13 8
	ldr	x13, [x9]
	.loc	2 15 8
	ldp	x9, x11, [x9, #8]
	.loc	2 20 8
	and	x14, x10, #0x3
	lsr	x10, x10, #2
	lsl	x15, x14, #4
	umaddl	x12, w10, w12, x15
	mov	w15, #1
	.loc	2 15 8
	add	x10, x11, x10, lsl #7
	.loc	2 14 8
	add	x9, x9, #1024
	add	x11, x10, x14, lsl #5
	.loc	2 20 8
	add	x10, x13, x12
	add	x11, x11, #576
	mov	x12, sp
	add	x13, sp, #64
	.loc	2 0 8 is_stmt 0
.Ltmp16:
	.p2align	4, , 8
.LBB1_1:
	mov	x16, xzr
	mov	w14, w15
	.p2align	4, , 8
.LBB1_2:
	.loc	2 20 8 is_stmt 1
	ldr	s0, [x12, x16]
	str	s0, [x13, x16]
	add	x16, x16, #4
	cmp	x16, #16
	b.ne	.LBB1_2
	.loc	2 0 8 is_stmt 0
	mov	x15, xzr
	.loc	2 20 8
	add	x16, x9, x8, lsl #2
	mov	x17, x10
	.loc	2 0 8
.Ltmp17:
	.p2align	4, , 8
.LBB1_4:
	mov	x0, xzr
	mov	x1, x16
	mov	x2, x17
	.p2align	4, , 8
.LBB1_5:
	mov	x3, xzr
	mov	x4, x1
	.p2align	4, , 8
.LBB1_6:
	ldr	s0, [x13, x3, lsl #2]
	mov	x5, xzr
	mov	x6, xzr
	.p2align	4, , 8
.LBB1_7:
	.loc	2 20 8 is_stmt 1
	ldr	s1, [x2, x6]
	add	x6, x6, #4
	ldr	s2, [x4, x5]
	add	x5, x5, #32
	cmp	x6, #16
	.loc	2 23 10
	fmadd	s0, s1, s2, s0
	.loc	2 20 8
	b.ne	.LBB1_7
	str	s0, [x13, x3, lsl #2]
	add	x3, x3, #1
	add	x4, x4, #4
	cmp	x3, #4
	b.ne	.LBB1_6
	add	x0, x0, #1
	add	x2, x2, #16
	add	x1, x1, #128
	cmp	x0, #3
	b.ne	.LBB1_5
	add	x15, x15, #1
	add	x17, x17, #96
	add	x16, x16, #384
	cmp	x15, #3
	b.ne	.LBB1_4
	.loc	2 26 8
	ldr	q0, [sp, #64]
	mov	w15, wzr
	.loc	2 20 8
	lsl	x16, x8, #2
	mov	w8, #4
	.loc	2 28 10
	fcmle	v1.4s, v0.4s, #0.0
	bic	v0.16b, v0.16b, v1.16b
	.loc	2 20 8
	str	q0, [x11, x16]
	tbnz	w14, #0, .LBB1_1
	.loc	2 32 8
	mov	w0, wzr
	.loc	2 32 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
.Ltmp18:
.Lfunc_end1:
	.size	infer_dispatch_1_conv_4x4x8x3x3x4_f32, .Lfunc_end1-infer_dispatch_1_conv_4x4x8x3x3x4_f32
	.cfi_endproc

	.section	.text.infer_dispatch_2_matmul_1x2x128_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_2_matmul_1x2x128_f32,@function
infer_dispatch_2_matmul_1x2x128_f32:
.Lfunc_begin2:
	.file	3 "results/e14_aarch64_qemu/aarch64/dump/conv2d" "configured_module_infer_dispatch_2.mlir"
	.loc	3 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
.Ltmp19:
	.loc	3 12 8 prologue_end
	ldr	x8, [x1, #32]
	movi	d0, #0000000000000000
	mov	x11, #-4
	ldp	x9, x10, [x8]
	.loc	3 14 8
	ldr	x8, [x8, #16]
	.loc	3 19 8
	add	x9, x9, #588
	add	x10, x10, #16
	.loc	3 0 8 is_stmt 0
.Ltmp20:
	.p2align	4, , 8
.LBB2_1:
	.loc	3 1 1 is_stmt 1
	ldp	s1, s4, [x9, #-12]
	.loc	3 19 8
	add	x11, x11, #4
	ldp	d2, d3, [x10, #-16]
	cmp	x11, #124
	.loc	3 1 1
	fmla	v0.2s, v2.2s, v1.s[0]
	fmla	v0.2s, v3.2s, v4.s[0]
	ldp	s1, s4, [x9, #-4]
	.loc	3 19 8
	add	x9, x9, #16
	ldp	d2, d3, [x10], #32
	.loc	3 1 1
	fmla	v0.2s, v2.2s, v1.s[0]
	fmla	v0.2s, v3.2s, v4.s[0]
	.loc	3 19 8
	b.lo	.LBB2_1
	.loc	3 21 8
	mov	w0, wzr
	.loc	3 1 1
	str	d0, [x8]
	.loc	3 21 8 epilogue_begin
	ldp	x29, x30, [sp], #16
	ret
.Ltmp21:
.Lfunc_end2:
	.size	infer_dispatch_2_matmul_1x2x128_f32, .Lfunc_end2-infer_dispatch_2_matmul_1x2x128_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.p2align	2
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin3:
	.cfi_startproc
	adrp	x8, iree_hal_executable_library_query_v0
	add	x8, x8, :lo12:iree_hal_executable_library_query_v0
	cmp	w0, #6
	csel	x0, x8, xzr, eq
	ret
.Lfunc_end3:
	.size	iree_hal_executable_library_query, .Lfunc_end3-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end3-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin4:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB4_2
	orr	w11, w10, #0x7f800000
	orr	w12, w10, #0x7fc00000
	add	w13, w9, w8
	cmp	w8, #0
	fmov	s0, w11
	add	w10, w10, w13, lsl #13
	fmov	s1, w12
	mov	w11, #939524096
	add	w8, w10, w11
	fcsel	s0, s0, s1, eq
	fmov	s1, w8
	mov	w8, #31744
	cmp	w9, w8
	fcsel	s0, s1, s0, ne
	ret
.LBB4_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end4:
	.size	iree_h2f_ieee, .Lfunc_end4-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin5:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB5_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB5_4
	cbz	w10, .LBB5_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB5_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB5_7
	mov	w9, #31744
.LBB5_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB5_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB5_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB5_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB5_10:
	tst	w11, #0x2000
	mov	w11, #4095
	cinc	w11, w11, ne
	mov	w12, #15360
	add	w10, w11, w10
	lsr	w11, w10, #23
	cmp	w11, #0
	mov	w11, #-127
	add	w10, w12, w10, lsr #13
	cinc	w11, w11, ne
	csel	w10, w12, w10, ne
	add	w9, w11, w9
	add	w9, w10, w9, lsl #10
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.Lfunc_end5:
	.size	iree_f2h_ieee, .Lfunc_end5-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin6:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB6_2
	orr	w11, w10, #0x7f800000
	orr	w12, w10, #0x7fc00000
	add	w13, w9, w8
	cmp	w8, #0
	fmov	s0, w11
	add	w10, w10, w13, lsl #13
	fmov	s1, w12
	mov	w11, #939524096
	add	w8, w10, w11
	fcsel	s0, s0, s1, eq
	fmov	s1, w8
	mov	w8, #31744
	cmp	w9, w8
	fcsel	s0, s1, s0, ne
	ret
.LBB6_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end6:
	.size	__gnu_h2f_ieee, .Lfunc_end6-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin7:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB7_2
	orr	w12, w10, #0x7f800000
	orr	w13, w10, #0x7fc00000
	and	w11, w11, #0x7fff
	cmp	w8, #0
	fmov	s0, w12
	add	w10, w10, w11, lsl #13
	fmov	s1, w13
	mov	w11, #939524096
	add	w8, w10, w11
	fcsel	s0, s0, s1, eq
	fmov	s1, w8
	mov	w8, #31744
	cmp	w9, w8
	fcsel	s0, s1, s0, ne
	ret
.LBB7_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end7:
	.size	__extendhfsf2, .Lfunc_end7-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin8:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB8_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB8_4
	cbz	w10, .LBB8_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB8_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB8_7
	mov	w9, #31744
.LBB8_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB8_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB8_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB8_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB8_10:
	tst	w11, #0x2000
	mov	w11, #4095
	cinc	w11, w11, ne
	mov	w12, #15360
	add	w10, w11, w10
	lsr	w11, w10, #23
	cmp	w11, #0
	mov	w11, #-127
	add	w10, w12, w10, lsr #13
	cinc	w11, w11, ne
	csel	w10, w12, w10, ne
	add	w9, w11, w9
	add	w9, w10, w9, lsl #10
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.Lfunc_end8:
	.size	__gnu_f2h_ieee, .Lfunc_end8-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin9:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB9_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB9_4
	cbz	w10, .LBB9_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB9_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB9_6
.LBB9_5:
	mov	w9, #31744
	b	.LBB9_9
.LBB9_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB9_8
	mov	w9, wzr
	b	.LBB9_9
.LBB9_8:
	tst	w11, #0x2000
	mov	w11, #4095
	cinc	w11, w11, ne
	mov	w12, #15360
	add	w10, w11, w10
	lsr	w11, w10, #23
	cmp	w11, #0
	mov	w11, #-127
	add	w10, w12, w10, lsr #13
	cinc	w11, w11, ne
	csel	w10, w12, w10, ne
	add	w9, w11, w9
	add	w9, w10, w9, lsl #10
.LBB9_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end9:
	.size	__truncsfhf2, .Lfunc_end9-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin10:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB10_2
	orr	w12, w10, #0x7f800000
	orr	w13, w10, #0x7fc00000
	and	w11, w11, #0x7fff
	cmp	w8, #0
	fmov	s0, w12
	add	w10, w10, w11, lsl #13
	fmov	s1, w13
	mov	w11, #939524096
	add	w8, w10, w11
	fcsel	s0, s0, s1, eq
	fmov	s1, w8
	mov	w8, #31744
	cmp	w9, w8
	fcsel	s0, s1, s0, ne
	fcvt	d0, s0
	ret
.LBB10_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	fcvt	d0, s0
	ret
.Lfunc_end10:
	.size	__extendhfdf2, .Lfunc_end10-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin11:
	.cfi_startproc
	fcvt	s0, d0
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB11_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB11_4
	cbz	w10, .LBB11_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB11_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB11_6
.LBB11_5:
	mov	w9, #31744
	b	.LBB11_9
.LBB11_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB11_8
	mov	w9, wzr
	b	.LBB11_9
.LBB11_8:
	tst	w11, #0x2000
	mov	w11, #4095
	cinc	w11, w11, ne
	mov	w12, #15360
	add	w10, w11, w10
	lsr	w11, w10, #23
	cmp	w11, #0
	mov	w11, #-127
	add	w10, w12, w10, lsr #13
	cinc	w11, w11, ne
	csel	w10, w12, w10, ne
	add	w9, w11, w9
	add	w9, w10, w9, lsl #10
.LBB11_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end11:
	.size	__truncdfhf2, .Lfunc_end11-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin12:
	.cfi_startproc
	fmadd	d0, d0, d1, d2
	ret
.Lfunc_end12:
	.size	fma, .Lfunc_end12-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin13:
	.cfi_startproc
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	ret
.Lfunc_end13:
	.size	__math_invalidf, .Lfunc_end13-__math_invalidf
	.cfi_endproc

	.section	.text.__math_oflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin14:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	movi	v0.2s, #240, lsl #24
	cmp	w0, #0
	movi	v1.2s, #112, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #12]
	ldr	s0, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end14:
	.size	__math_oflowf, .Lfunc_end14-__math_oflowf
	.cfi_endproc

	.section	.text.__math_xflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin15:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fneg	s1, s0
	cmp	w0, #0
	fcsel	s1, s0, s1, eq
	str	s1, [sp, #12]
	ldr	s1, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end15:
	.size	__math_xflowf, .Lfunc_end15-__math_xflowf
	.cfi_endproc

	.section	.text.__math_uflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin16:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	movi	v0.2s, #144, lsl #24
	cmp	w0, #0
	movi	v1.2s, #16, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #12]
	ldr	s0, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end16:
	.size	__math_uflowf, .Lfunc_end16-__math_uflowf
	.cfi_endproc

	.section	.text.ceilf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin17:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB17_6
	cmp	w9, #127
	b.lo	.LBB17_4
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB17_6
	mov	w11, #2071986176
	cmp	w8, #0
	csel	w10, wzr, w10, mi
	add	w8, w10, w8
	fmov	s1, w11
	mov	w11, #-8388608
	asr	w9, w11, w9
	and	w8, w8, w9
	fadd	s1, s0, s1
	fmov	s0, w8
	str	s1, [sp, #8]
	add	sp, sp, #16
	ret
.LBB17_4:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s1, s0, s1
	str	s1, [sp, #12]
	tbnz	w8, #31, .LBB17_7
	fmov	s1, #1.00000000
	cmp	w8, #0
	fcsel	s0, s0, s1, eq
.LBB17_6:
	add	sp, sp, #16
	ret
.LBB17_7:
	movi	v0.2s, #128, lsl #24
	add	sp, sp, #16
	ret
.Lfunc_end17:
	.size	ceilf, .Lfunc_end17-ceilf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI18_0:
	.xword	0x40471547652b82fe
.LCPI18_1:
	.xword	0x3f2ebfce50fac4f3
.LCPI18_2:
	.xword	0x3ebc6af84b912394
.LCPI18_3:
	.xword	0x3f962e42ff0c52d6
	.section	.text.expf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin18:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w8, w8, #20, #11
	cmp	w8, #1067
	b.hs	.LBB18_3
.LBB18_1:
	adrp	x8, .LCPI18_0
	fcvt	d0, s0
	adrp	x9, .LCPI18_2
	adrp	x10, .LCPI18_3
	ldr	d1, [x8, :lo12:.LCPI18_0]
	mov	x8, #4843621399236968448
	ldr	d4, [x9, :lo12:.LCPI18_2]
	ldr	d5, [x10, :lo12:.LCPI18_3]
	adrp	x10, __exp2f_data
	add	x10, x10, :lo12:__exp2f_data
	fmul	d0, d0, d1
	fmov	d1, x8
	mov	x8, #-4379750637617807360
	fmov	d2, x8
	adrp	x8, .LCPI18_1
	fadd	d1, d0, d1
	ldr	d3, [x8, :lo12:.LCPI18_1]
	fadd	d2, d1, d2
	fmov	x8, d1
	fsub	d0, d0, d2
	fmov	d2, #1.00000000
	and	x9, x8, #0x1f
	ldr	x9, [x10, x9, lsl #3]
	fmadd	d3, d0, d4, d3
	fmadd	d7, d0, d5, d2
	fmul	d0, d0, d0
	add	x8, x9, x8, lsl #47
	fmov	d1, x8
	fmadd	d7, d3, d0, d7
	fmul	d0, d7, d1
	fcvt	s1, d0
.LBB18_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB18_3:
	mov	w9, #-8388608
	fmov	s1, w9
	fcmp	s0, s1
	movi	d1, #0000000000000000
	b.eq	.LBB18_2
	cmp	w8, #2040
	b.hs	.LBB18_7
	mov	w8, #29207
	movk	w8, #17073, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.le	.LBB18_8
	mov	w8, #1879048192
	movi	v0.2s, #112, lsl #24
	str	w8, [sp, #8]
	ldr	s1, [sp, #8]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB18_7:
	fadd	s1, s0, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB18_8:
	mov	w8, #61876
	movk	w8, #49871, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.pl	.LBB18_1
	mov	w8, #268435456
	movi	v0.2s, #16, lsl #24
	str	w8, [sp, #12]
	ldr	s1, [sp, #12]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end18:
	.size	expf, .Lfunc_end18-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin19:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end19:
	.size	feclearexcept, .Lfunc_end19-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin20:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end20:
	.size	feraiseexcept, .Lfunc_end20-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin21:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end21:
	.size	fetestexcept, .Lfunc_end21-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin22:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end22:
	.size	fegetround, .Lfunc_end22-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin23:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end23:
	.size	__fesetround, .Lfunc_end23-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin24:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end24:
	.size	fegetenv, .Lfunc_end24-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin25:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end25:
	.size	fesetenv, .Lfunc_end25-fesetenv
	.cfi_endproc

	.section	.text.floorf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin26:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.ls	.LBB26_3
	fmov	s1, s0
.LBB26_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB26_3:
	cmp	w9, #127
	b.lo	.LBB26_6
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB26_9
	mov	w11, #2071986176
	and	w10, w10, w8, asr #31
	add	w8, w10, w8
	fmov	s1, w11
	mov	w11, #-8388608
	asr	w9, w11, w9
	and	w8, w8, w9
	fadd	s0, s0, s1
	fmov	s1, w8
	str	s0, [sp, #8]
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB26_6:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s2, s0, s1
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	tbz	w8, #31, .LBB26_2
	fcmp	s0, #0.0
	fmov	s1, s0
	b.eq	.LBB26_2
	fmov	s1, #-1.00000000
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB26_9:
	fmov	s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end26:
	.size	floorf, .Lfunc_end26-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin27:
	.cfi_startproc
	fcvt	d1, s1
	mov	x9, #-9223372036854775808
	fcvt	d0, s0
	fcvt	d2, s2
	fmul	d1, d0, d1
	fadd	d0, d1, d2
	fmov	x8, d0
	and	x10, x8, #0x7ff0000000000000
	cmp	x9, x8, lsl #35
	mov	x9, #9218868437227405312
	ccmp	x10, x9, #4, eq
	b.eq	.LBB27_3
	fsub	d3, d0, d1
	fsub	d4, d0, d2
	fcmp	d3, d2
	fccmp	d4, d1, #0, eq
	b.eq	.LBB27_3
	fsub	d3, d1, d0
	cmp	x8, #0
	fsub	d0, d2, d0
	cset	w9, mi
	fcmp	d1, d2
	fadd	d2, d3, d2
	fadd	d0, d1, d0
	cset	w10, pl
	eor	w10, w10, w9
	cmp	w10, #0
	fcsel	d0, d2, d0, ne
	fcmp	d0, #0.0
	cset	w10, pl
	eor	w9, w9, w10
	sub	x10, x8, #1
	cmp	w9, #0
	csinc	x8, x10, x8, eq
	fmov	d0, x8
.LBB27_3:
	fcvt	s0, d0
	ret
.Lfunc_end27:
	.size	fmaf, .Lfunc_end27-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin28:
	.cfi_startproc
	fmov	w12, s1
	lsl	w10, w12, #1
	cbz	w10, .LBB28_8
	fmov	w8, s1
	mov	w9, #2139095040
	and	w8, w8, #0x7fffffff
	cmp	w8, w9
	b.hi	.LBB28_8
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB28_8
	lsl	w11, w9, #1
	cmp	w11, w10
	b.ls	.LBB28_9
	ubfx	w11, w12, #23, #8
	cbz	w8, .LBB28_10
	mov	w10, #8388608
	bfxil	w10, w9, #0, #23
	cbz	w11, .LBB28_13
.LBB28_6:
	mov	w13, #8388608
	bfxil	w13, w12, #0, #23
	cmp	w8, w11
	b.gt	.LBB28_17
.LBB28_7:
	subs	w11, w10, w13
	b.pl	.LBB28_20
	b	.LBB28_21
.LBB28_8:
	fmul	s0, s0, s1
	fdiv	s0, s0, s0
	ret
.LBB28_9:
	movi	d1, #0000000000000000
	fmul	s1, s0, s1
	fcsel	s0, s1, s0, eq
	ret
.LBB28_10:
	mov	w8, wzr
	lsl	w10, w9, #9
	tbnz	w10, #31, .LBB28_12
	.p2align	4, , 8
.LBB28_11:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	tbz	w10, #31, .LBB28_11
.LBB28_12:
	mov	w10, #1
	sub	w10, w10, w8
	lsl	w10, w9, w10
	cbnz	w11, .LBB28_6
.LBB28_13:
	mov	w11, wzr
	lsl	w13, w12, #9
	tbnz	w13, #31, .LBB28_15
	.p2align	4, , 8
.LBB28_14:
	sub	w11, w11, #1
	lsl	w13, w13, #1
	tbz	w13, #31, .LBB28_14
.LBB28_15:
	mov	w13, #1
	sub	w13, w13, w11
	lsl	w13, w12, w13
	cmp	w8, w11
	b.gt	.LBB28_17
	b	.LBB28_7
	.p2align	4, , 8
.LBB28_16:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	cmp	w8, w11
	b.le	.LBB28_19
.LBB28_17:
	subs	w12, w10, w13
	b.mi	.LBB28_16
	mov	w10, w12
	cbnz	w12, .LBB28_16
	b	.LBB28_24
.LBB28_19:
	mov	w8, w11
	subs	w11, w10, w13
	b.mi	.LBB28_21
.LBB28_20:
	mov	w10, w11
	cbz	w11, .LBB28_24
.LBB28_21:
	and	w9, w9, #0x80000000
	lsr	w11, w10, #23
	cbnz	w11, .LBB28_23
	.p2align	4, , 8
.LBB28_22:
	sub	w8, w8, #1
	cmp	w10, #1024, lsl #12
	lsl	w10, w10, #1
	b.lo	.LBB28_22
.LBB28_23:
	mov	w11, #1
	sub	w12, w10, #2048, lsl #12
	sub	w11, w11, w8
	orr	w12, w12, w8, lsl #23
	cmp	w8, #1
	lsr	w8, w10, w11
	csel	w8, w8, w12, lt
	orr	w8, w8, w9
	fmov	s0, w8
	ret
.LBB28_24:
	movi	d1, #0000000000000000
	fmul	s0, s0, s1
	ret
.Lfunc_end28:
	.size	fmodf, .Lfunc_end28-fmodf
	.cfi_endproc

	.section	.text.frexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin29:
	.cfi_startproc
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB29_7
	cbnz	w8, .LBB29_4
	fcmp	s0, #0.0
	b.eq	.LBB29_5
	stp	x30, x19, [sp, #-16]!
	.cfi_def_cfa_offset 16
	.cfi_offset w19, -8
	.cfi_offset w30, -16
	mov	w8, #1602224128
	mov	x19, x0
	fmov	s1, w8
	fmul	s0, s0, s1
	bl	frexpf
	ldr	w8, [x19]
	mov	x0, x19
	sub	w8, w8, #64
	ldp	x30, x19, [sp], #16
	b	.LBB29_6
.LBB29_4:
	and	w9, w9, #0x807fffff
	sub	w8, w8, #126
	orr	w9, w9, #0x3f000000
	fmov	s0, w9
	b	.LBB29_6
.LBB29_5:
	mov	w8, wzr
.LBB29_6:
	str	w8, [x0]
.LBB29_7:
	ret
.Lfunc_end29:
	.size	frexpf, .Lfunc_end29-frexpf
	.cfi_endproc

	.section	.text.ldexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin30:
	.cfi_startproc
	cmp	w0, #128
	b.lt	.LBB30_4
	movi	v1.2s, #127, lsl #24
	cmp	w0, #255
	fmul	s0, s0, s1
	b.lo	.LBB30_7
	cmp	w0, #381
	mov	w8, #381
	csel	w8, w0, w8, lo
	fmul	s0, s0, s1
	sub	w0, w8, #254
.LBB30_3:
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB30_4:
	cmn	w0, #127
	b.gt	.LBB30_3
	mov	w8, #209715200
	cmn	w0, #229
	fmov	s1, w8
	fmul	s0, s0, s1
	b.hi	.LBB30_8
	fmov	s1, w8
	cmn	w0, #330
	mov	w8, #-330
	csel	w8, w0, w8, hi
	add	w0, w8, #204
	fmul	s0, s0, s1
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB30_7:
	sub	w0, w0, #127
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB30_8:
	add	w0, w0, #102
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.Lfunc_end30:
	.size	ldexpf, .Lfunc_end30-ldexpf
	.cfi_endproc

	.section	.text.scalbnf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin31:
	.cfi_startproc
	cmp	w0, #128
	b.lt	.LBB31_4
	movi	v1.2s, #127, lsl #24
	cmp	w0, #255
	fmul	s0, s0, s1
	b.lo	.LBB31_7
	cmp	w0, #381
	mov	w8, #381
	csel	w8, w0, w8, lo
	fmul	s0, s0, s1
	sub	w0, w8, #254
.LBB31_3:
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB31_4:
	cmn	w0, #127
	b.gt	.LBB31_3
	mov	w8, #209715200
	cmn	w0, #229
	fmov	s1, w8
	fmul	s0, s0, s1
	b.hi	.LBB31_8
	fmov	s1, w8
	cmn	w0, #330
	mov	w8, #-330
	csel	w8, w0, w8, hi
	add	w0, w8, #204
	fmul	s0, s0, s1
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB31_7:
	sub	w0, w0, #127
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB31_8:
	add	w0, w0, #102
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.Lfunc_end31:
	.size	scalbnf, .Lfunc_end31-scalbnf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI32_0:
	.xword	0xbfd71969a075c67a
.LCPI32_1:
	.xword	0x3fd27616c9496e0b
.LCPI32_2:
	.xword	0xbfe7154748bef6c8
.LCPI32_3:
	.xword	0x3fdec70a6ca7badd
.LCPI32_4:
	.xword	0x3ff71547652ab82b
.LCPI32_5:
	.xword	0x405fffffffd1d571
.LCPI32_6:
	.xword	0x3fcebfce50fac4f3
.LCPI32_7:
	.xword	0x3fac6af84b912394
.LCPI32_8:
	.xword	0x3fe62e42ff0c52d6
	.section	.text.powf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin32:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w9, s0
	mov	w10, #-2139095040
	fmov	w8, s1
	add	w11, w10, #2048, lsl #12
	add	w12, w9, w10
	lsl	w10, w8, #1
	cmp	w12, w11
	b.lo	.LBB32_6
	mov	w11, #16777216
	add	w12, w10, w11
	cmp	w12, w11
	b.ls	.LBB32_6
	mov	w8, wzr
.LBB32_3:
	mov	w10, #-1060306944
	fmov	d2, #-1.00000000
	add	w10, w9, w10
	fcvt	d1, s1
	and	w11, w10, #0xff800000
	sub	w9, w9, w11
	adrp	x11, __powf_log2_data
	add	x11, x11, :lo12:__powf_log2_data
	fmov	s0, w9
	ubfx	w9, w10, #19, #4
	add	x9, x11, w9, uxtw #4
	asr	w10, w10, #23
	adrp	x11, .LCPI32_4
	scvtf	d4, w10
	adrp	x10, .LCPI32_3
	ldp	d3, d5, [x9]
	adrp	x9, .LCPI32_2
	fcvt	d0, s0
	fmadd	d0, d0, d3, d2
	fadd	d3, d5, d4
	ldr	d2, [x9, :lo12:.LCPI32_2]
	adrp	x9, .LCPI32_0
	ldr	d4, [x10, :lo12:.LCPI32_3]
	adrp	x10, .LCPI32_1
	ldr	d5, [x11, :lo12:.LCPI32_4]
	ldr	d6, [x10, :lo12:.LCPI32_1]
	mov	x10, #1
	movk	x10, #16479, lsl #48
	fmadd	d2, d0, d4, d2
	fmadd	d3, d0, d5, d3
	ldr	d5, [x9, :lo12:.LCPI32_0]
	fmul	d4, d0, d0
	fmadd	d0, d0, d6, d5
	fmadd	d7, d2, d4, d3
	fmul	d3, d4, d4
	fmadd	d7, d0, d3, d7
	fmul	d0, d7, d1
	fmov	x9, d0
	and	x9, x9, #0x7fff800000000000
	cmp	x9, x10
	b.hs	.LBB32_11
.LBB32_4:
	mov	x9, #4821103401100115968
	adrp	x10, .LCPI32_7
	adrp	x11, .LCPI32_8
	fmov	d1, x9
	mov	x9, #-4402268635754659840
	ldr	d4, [x10, :lo12:.LCPI32_7]
	ldr	d5, [x11, :lo12:.LCPI32_8]
	adrp	x11, __exp2f_data
	add	x11, x11, :lo12:__exp2f_data
	fmov	d2, x9
	adrp	x9, .LCPI32_6
	fadd	d1, d0, d1
	ldr	d3, [x9, :lo12:.LCPI32_6]
	fadd	d2, d1, d2
	fmov	x9, d1
	fsub	d0, d0, d2
	fmov	d2, #1.00000000
	and	x10, x9, #0x1f
	add	w8, w9, w8
	ldr	x10, [x11, x10, lsl #3]
	fmadd	d3, d0, d4, d3
	fmadd	d2, d0, d5, d2
	fmul	d5, d0, d0
	add	x8, x10, x8, lsl #47
	fmov	d1, x8
	fmadd	d0, d3, d5, d2
	fmul	d0, d0, d1
	fcvt	s0, d0
.LBB32_5:
	add	sp, sp, #16
	ret
.LBB32_6:
	mov	w11, #-16777217
	sub	w12, w10, #1
	cmp	w12, w11
	b.hs	.LBB32_22
	lsl	w10, w9, #1
	sub	w10, w10, #1
	cmp	w10, w11
	b.hs	.LBB32_28
	tbnz	w9, #31, .LBB32_13
	mov	w8, wzr
	lsr	w10, w9, #23
	cbnz	w10, .LBB32_3
.LBB32_10:
	movi	v2.2s, #75, lsl #24
	mov	w10, #-192937984
	fmul	s0, s0, s2
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	add	w9, w9, w10
	b	.LBB32_3
.LBB32_11:
	adrp	x9, .LCPI32_5
	ldr	d1, [x9, :lo12:.LCPI32_5]
	fcmp	d0, d1
	b.le	.LBB32_16
	movi	v0.2s, #240, lsl #24
	cmp	w8, #0
	movi	v1.2s, #112, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #8]
	ldr	s0, [sp, #8]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB32_13:
	ubfx	w9, w8, #23, #8
	cmp	w9, #127
	b.lo	.LBB32_19
	cmp	w9, #150
	b.ls	.LBB32_18
.LBB32_15:
	mov	w8, wzr
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB32_3
	b	.LBB32_10
.LBB32_16:
	mov	x9, #211106232532992
	movk	x9, #49250, lsl #48
	fmov	d1, x9
	fcmp	d0, d1
	b.hi	.LBB32_4
	movi	v0.2s, #144, lsl #24
	cmp	w8, #0
	movi	v1.2s, #16, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #12]
	ldr	s0, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB32_18:
	mov	w10, #150
	sub	w9, w10, w9
	mov	w10, #1
	lsl	w9, w10, w9
	sub	w10, w9, #1
	tst	w10, w8
	b.eq	.LBB32_20
.LBB32_19:
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	add	sp, sp, #16
	ret
.LBB32_20:
	tst	w9, w8
	b.eq	.LBB32_15
	mov	w8, #65536
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB32_3
	b	.LBB32_10
.LBB32_22:
	mov	w11, #1065353216
	cmp	w9, w11
	b.eq	.LBB32_33
	cbz	w10, .LBB32_33
	mov	w11, #-16777216
	lsl	w9, w9, #1
	cmp	w9, w11
	b.hi	.LBB32_34
	mov	w11, #-16777215
	cmp	w10, w11
	b.hs	.LBB32_34
	fmov	s0, #1.00000000
	mov	w10, #2130706432
	cmp	w9, w10
	b.eq	.LBB32_5
	fmul	s0, s1, s1
	movi	d1, #0000000000000000
	lsr	w9, w9, #24
	cmp	w9, #127
	cset	w9, lo
	cmp	w8, #0
	cset	w8, mi
	eor	w8, w9, w8
	cmp	w8, #0
	fcsel	s0, s1, s0, ne
	add	sp, sp, #16
	ret
.LBB32_28:
	fmul	s0, s0, s0
	tbz	w9, #31, .LBB32_31
	ubfx	w9, w8, #23, #8
	sub	w10, w9, #151
	cmn	w10, #24
	b.lo	.LBB32_31
	mov	w10, #150
	fneg	s1, s0
	sub	w9, w10, w9
	mov	w10, #1
	lsl	w9, w10, w9
	sub	w10, w9, #1
	tst	w10, w8
	and	w9, w9, w8
	ccmp	w9, #0, #4, eq
	fcsel	s0, s0, s1, eq
.LBB32_31:
	tbz	w8, #31, .LBB32_5
	fmov	s1, #1.00000000
	fdiv	s0, s1, s0
	str	s0, [sp, #4]
	ldr	s0, [sp, #4]
	add	sp, sp, #16
	ret
.LBB32_33:
	fmov	s0, #1.00000000
	add	sp, sp, #16
	ret
.LBB32_34:
	fadd	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end32:
	.size	powf, .Lfunc_end32-powf
	.cfi_endproc

	.section	.text.rintf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin33:
	.cfi_startproc
	fmov	w8, s0
	mov	w9, #1249902592
	and	w10, w8, #0x7f000000
	cmp	w10, w9
	b.hi	.LBB33_3
	movi	v1.2s, #203, lsl #24
	cmn	w8, #1
	movi	v2.2s, #75, lsl #24
	fadd	s3, s0, s1
	fadd	s0, s0, s2
	fadd	s2, s3, s2
	fadd	s0, s0, s1
	fcsel	s0, s0, s2, gt
	fcmp	s0, #0.0
	b.ne	.LBB33_3
	movi	v0.2s, #128, lsl #24
	cmn	w8, #1
	movi	d1, #0000000000000000
	fcsel	s0, s1, s0, gt
.LBB33_3:
	ret
.Lfunc_end33:
	.size	rintf, .Lfunc_end33-rintf
	.cfi_endproc

	.section	.text.roundf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin34:
	.cfi_startproc
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB34_9
	fabs	s1, s0
	cmp	w9, #125
	movi	v2.2s, #75, lsl #24
	fadd	s2, s1, s2
	b.hi	.LBB34_3
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB34_3:
	movi	v0.2s, #203, lsl #24
	fadd	s0, s2, s0
	fmov	s2, #0.50000000
	fsub	s0, s0, s1
	fcmp	s0, s2
	b.le	.LBB34_5
	fadd	s0, s1, s0
	fmov	s1, #-1.00000000
	b	.LBB34_7
.LBB34_5:
	fmov	s2, #-0.50000000
	fcmp	s0, s2
	fadd	s0, s1, s0
	b.hi	.LBB34_8
	fmov	s1, #1.00000000
.LBB34_7:
	fadd	s0, s0, s1
.LBB34_8:
	fneg	s1, s0
	cmp	w8, #0
	fcsel	s0, s1, s0, mi
.LBB34_9:
	ret
.Lfunc_end34:
	.size	roundf, .Lfunc_end34-roundf
	.cfi_endproc

	.type	__constant_3x3x4xf32,@object
	.section	.rodata.__constant_3x3x4xf32,"a",@progbits
	.p2align	6, 0x0
__constant_3x3x4xf32:
	.word	0x3c4dff14
	.word	0xbc5870cc
	.word	0x3d832897
	.word	0x3c2bde4c
	.word	0xbd5b6901
	.word	0x3d141bfd
	.word	0x3e058794
	.word	0x3dc1f652
	.word	0xbd901ffe
	.word	0xbe019444
	.word	0xbd7f4b10
	.word	0x3b876abe
	.word	0xbe6e1549
	.word	0xbcb33bf0
	.word	0xbdff299e
	.word	0xbd95f7e6
	.word	0xbd5eedb1
	.word	0xbd018e7a
	.word	0x3d289a97
	.word	0x3dd581ba
	.word	0xbc529758
	.word	0x3e0bed05
	.word	0xbd883b5c
	.word	0x3d0ffa81
	.word	0x3db907dc
	.word	0x3c1a079e
	.word	0xbd9844c6
	.word	0xbdbcc4f5
	.word	0xbd3b7c08
	.word	0x3cb46244
	.word	0xbdcec512
	.word	0xbcab5b4c
	.word	0xbc826fe8
	.word	0x3d5d87c5
	.word	0x3cafd948
	.word	0x3d118f88
	.size	__constant_3x3x4xf32, 144

	.type	__unnamed_1,@object
	.section	.rodata.__unnamed_1,"a",@progbits
__unnamed_1:
	.asciz	"conv2d_baked_linked"
	.size	__unnamed_1, 20

	.type	iree_hal_executable_library_query_v0_header,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_header,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_header:
	.word	6
	.zero	4
	.xword	__unnamed_1
	.word	0
	.word	0
	.size	iree_hal_executable_library_query_v0_header, 24

	.type	iree_hal_executable_library_query_v0_funcs,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_funcs,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_funcs:
	.xword	infer_dispatch_0_conv_6x6x4x3x3_f32
	.xword	infer_dispatch_1_conv_4x4x8x3x3x4_f32
	.xword	infer_dispatch_2_matmul_1x2x128_f32
	.size	iree_hal_executable_library_query_v0_funcs, 24

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
	.xword	0
	.hword	0
	.byte	0
	.byte	2
	.word	1
	.word	1
	.hword	1
	.hword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.hword	0
	.byte	0
	.byte	3
	.word	1
	.word	1
	.hword	1
	.hword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.hword	0
	.byte	0
	.byte	3
	.word	1
	.word	1
	.hword	1
	.hword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.size	iree_hal_executable_library_query_v0_attrs, 192

	.type	__unnamed_2,@object
	.section	.rodata.__unnamed_2,"a",@progbits
__unnamed_2:
	.asciz	"infer_dispatch_0_conv_6x6x4x3x3_f32"
	.size	__unnamed_2, 36

	.type	__unnamed_3,@object
	.section	.rodata.__unnamed_3,"a",@progbits
__unnamed_3:
	.asciz	"infer_dispatch_1_conv_4x4x8x3x3x4_f32"
	.size	__unnamed_3, 38

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"infer_dispatch_2_matmul_1x2x128_f32"
	.size	__unnamed_4, 36

	.type	iree_hal_executable_library_query_v0_names,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_names,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_names:
	.xword	__unnamed_2
	.xword	__unnamed_3
	.xword	__unnamed_4
	.size	iree_hal_executable_library_query_v0_names, 24

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_5, 85

	.type	__unnamed_6,@object
	.section	.rodata.__unnamed_6,"a",@progbits
__unnamed_6:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_6, 85

	.type	__unnamed_7,@object
	.section	.rodata.__unnamed_7,"a",@progbits
__unnamed_7:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_2.mlir"
	.size	__unnamed_7, 85

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.word	3
	.word	84
	.xword	__unnamed_5
	.word	3
	.word	84
	.xword	__unnamed_6
	.word	3
	.word	84
	.xword	__unnamed_7
	.size	iree_hal_executable_library_query_v0_source_locations, 48

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_stage_location_tables,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_stage_location_tables,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_stage_location_tables:
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 72

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.xword	iree_hal_executable_library_query_v0_header
	.zero	16
	.word	3
	.zero	4
	.xword	iree_hal_executable_library_query_v0_funcs
	.xword	iree_hal_executable_library_query_v0_attrs
	.xword	0
	.xword	0
	.xword	iree_hal_executable_library_query_v0_names
	.xword	0
	.xword	0
	.xword	iree_hal_executable_library_query_v0_source_locations
	.xword	iree_hal_executable_library_query_v0_stage_location_tables
	.zero	4
	.zero	4
	.zero	16
	.size	iree_hal_executable_library_query_v0, 128

	.type	__exp2f_data,@object
	.section	.rodata.__exp2f_data,"a",@progbits
	.p2align	3, 0x0
__exp2f_data:
	.xword	4607182418800017408
	.xword	4607140297302181236
	.xword	4607100335213349135
	.xword	4607062579818421073
	.xword	4607027079437701499
	.xword	4606993883449571754
	.xword	4606963042313658936
	.xword	4606934607594512097
	.xword	4606908631985796885
	.xword	4606885169335019979
	.xword	4606864274668794914
	.xword	4606846004218661165
	.xword	4606830415447468583
	.xword	4606817567076339586
	.xword	4606807519112221737
	.xword	4606800332876043653
	.xword	4606796071031487437
	.xword	4606794797614391156
	.xword	4606796578062795143
	.xword	4606801479247646227
	.xword	4606809569504174299
	.xword	4606820918663955941
	.xword	4606835598087680144
	.xword	4606853680698631517
	.xword	4606875241016906669
	.xword	4606900355194379847
	.xword	4606929101050434204
	.xword	4606961558108475497
	.xword	4606997807633245319
	.xword	4607037932668951391
	.xword	4607082018078232794
	.xword	4607130150581978432
	.xword	0x42e8000000000000
	.xword	0x3fac6af84b912394
	.xword	0x3fcebfce50fac4f3
	.xword	0x3fe62e42ff0c52d6
	.xword	0x4338000000000000
	.xword	0x40471547652b82fe
	.xword	0x3ebc6af84b912394
	.xword	0x3f2ebfce50fac4f3
	.xword	0x3f962e42ff0c52d6
	.size	__exp2f_data, 328

	.type	__powf_log2_data,@object
	.section	.rodata.__powf_log2_data,"a",@progbits
	.p2align	3, 0x0
__powf_log2_data:
	.xword	0x3ff661ec79f8f3be
	.xword	0xbfdefec65b963019
	.xword	0x3ff571ed4aaf883d
	.xword	0xbfdb0b6832d4fca4
	.xword	0x3ff49539f0f010b0
	.xword	0xbfd7418b0a1fb77b
	.xword	0x3ff3c995b0b80385
	.xword	0xbfd39de91a6dcf7b
	.xword	0x3ff30d190c8864a5
	.xword	0xbfd01d9bf3f2b631
	.xword	0x3ff25e227b0b8ea0
	.xword	0xbfc97c1d1b3b7af0
	.xword	0x3ff1bb4a4a1a343f
	.xword	0xbfc2f9e393af3c9f
	.xword	0x3ff12358f08ae5ba
	.xword	0xbfb960cbbf788d5c
	.xword	0x3ff0953f419900a7
	.xword	0xbfaa6f9db6475fce
	.xword	0x3ff0000000000000
	.xword	0x0000000000000000
	.xword	0x3fee608cfd9a47ac
	.xword	0x3fb338ca9f24f53d
	.xword	0x3feca4b31f026aa0
	.xword	0x3fc476a9543891ba
	.xword	0x3feb2036576afce6
	.xword	0x3fce840b4ac4e4d2
	.xword	0x3fe9c2d163a1aa2d
	.xword	0x3fd40645f0c6651c
	.xword	0x3fe886e6037841ed
	.xword	0x3fd88e9c2c1b9ff8
	.xword	0x3fe767dcf5534862
	.xword	0x3fdce0a44eb17bcc
	.xword	0x3fd27616c9496e0b
	.xword	0xbfd71969a075c67a
	.xword	0x3fdec70a6ca7badd
	.xword	0xbfe7154748bef6c8
	.xword	0x3ff71547652ab82b
	.size	__powf_log2_data, 296

	.section	.debug_abbrev,"",@progbits
	.byte	1
	.byte	17
	.byte	1
	.byte	37
	.byte	14
	.byte	19
	.byte	5
	.byte	3
	.byte	14
	.byte	16
	.byte	23
	.byte	27
	.byte	14
	.ascii	"\264B"
	.byte	25
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	0
	.byte	0
	.byte	2
	.byte	46
	.byte	0
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	3
	.byte	36
	.byte	0
	.byte	3
	.byte	14
	.byte	62
	.byte	11
	.byte	11
	.byte	11
	.byte	0
	.byte	0
	.byte	4
	.byte	46
	.byte	0
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	16
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.word	.Ldebug_info_end0-.Ldebug_info_start0
.Ldebug_info_start0:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string1
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin0
	.word	.Lfunc_end0-.Lfunc_begin0
	.byte	2
	.xword	.Lfunc_begin0
	.word	.Lfunc_end0-.Lfunc_begin0
	.byte	1
	.byte	109
	.word	.Linfo_string5
	.word	.Linfo_string5
	.byte	1
	.byte	1
	.word	71

	.byte	3
	.word	.Linfo_string6
	.byte	5
	.byte	4
	.byte	0
.Ldebug_info_end0:
.Lcu_begin1:
	.word	.Ldebug_info_end1-.Ldebug_info_start1
.Ldebug_info_start1:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string3
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin1
	.word	.Lfunc_end1-.Lfunc_begin1
	.byte	4
	.xword	.Lfunc_begin1
	.word	.Lfunc_end1-.Lfunc_begin1
	.byte	1
	.byte	109
	.word	.Linfo_string7
	.word	.Linfo_string7
	.byte	2
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end1:
.Lcu_begin2:
	.word	.Ldebug_info_end2-.Ldebug_info_start2
.Ldebug_info_start2:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string4
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin2
	.word	.Lfunc_end2-.Lfunc_begin2
	.byte	4
	.xword	.Lfunc_begin2
	.word	.Lfunc_end2-.Lfunc_begin2
	.byte	1
	.byte	109
	.word	.Linfo_string8
	.word	.Linfo_string8
	.byte	3
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end2:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"IREE"
.Linfo_string1:
	.asciz	"configured_module_infer_dispatch_0.mlir"
.Linfo_string2:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/conv2d"
.Linfo_string3:
	.asciz	"configured_module_infer_dispatch_1.mlir"
.Linfo_string4:
	.asciz	"configured_module_infer_dispatch_2.mlir"
.Linfo_string5:
	.asciz	"infer_dispatch_0_conv_6x6x4x3x3_f32"
.Linfo_string6:
	.asciz	"int"
.Linfo_string7:
	.asciz	"infer_dispatch_1_conv_4x4x8x3x3x4_f32"
.Linfo_string8:
	.asciz	"infer_dispatch_2_matmul_1x2x128_f32"
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.hword	2
	.word	.Lcu_begin0
	.word	79
	.word	42
	.asciz	"infer_dispatch_0_conv_6x6x4x3x3_f32"
	.word	0
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end0-.LpubTypes_start0
.LpubTypes_start0:
	.hword	2
	.word	.Lcu_begin0
	.word	79
	.word	71
	.asciz	"int"
	.word	0
.LpubTypes_end0:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end1-.LpubNames_start1
.LpubNames_start1:
	.hword	2
	.word	.Lcu_begin1
	.word	72
	.word	42
	.asciz	"infer_dispatch_1_conv_4x4x8x3x3x4_f32"
	.word	0
.LpubNames_end1:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end1-.LpubTypes_start1
.LpubTypes_start1:
	.hword	2
	.word	.Lcu_begin1
	.word	72
	.word	0
.LpubTypes_end1:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end2-.LpubNames_start2
.LpubNames_start2:
	.hword	2
	.word	.Lcu_begin2
	.word	72
	.word	42
	.asciz	"infer_dispatch_2_matmul_1x2x128_f32"
	.word	0
.LpubNames_end2:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end2-.LpubTypes_start2
.LpubTypes_start2:
	.hword	2
	.word	.Lcu_begin2
	.word	72
	.word	0
.LpubTypes_end2:
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
