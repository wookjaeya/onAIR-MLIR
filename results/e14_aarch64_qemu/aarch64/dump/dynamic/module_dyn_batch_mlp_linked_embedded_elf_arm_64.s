	.file	"dyn_batch_mlp_linked"
	.section	.text.infer_dispatch_0_matmul_Dx64x9_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_0_matmul_Dx64x9_f32,@function
infer_dispatch_0_matmul_Dx64x9_f32:
.Lfunc_begin0:
	.file	1 "results/e14_aarch64_qemu/aarch64/dump/dynamic" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	sub	sp, sp, #144
	stp	d9, d8, [sp, #32]
	stp	x29, x30, [sp, #48]
	stp	x28, x27, [sp, #64]
	stp	x26, x25, [sp, #80]
	stp	x24, x23, [sp, #96]
	stp	x22, x21, [sp, #112]
	stp	x20, x19, [sp, #128]
	add	x29, sp, #48
	.cfi_def_cfa w29, 96
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w23, -40
	.cfi_offset w24, -48
	.cfi_offset w25, -56
	.cfi_offset w26, -64
	.cfi_offset w27, -72
	.cfi_offset w28, -80
	.cfi_offset w30, -88
	.cfi_offset w29, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
.Ltmp10:
	.loc	1 12 8 prologue_end
	ldp	x9, x11, [x1, #24]
	mov	w8, #64
	.loc	1 28 8
	ldr	w14, [x2]
	.loc	1 12 8
	ldr	x9, [x9]
	.loc	1 28 8
	lsl	x12, x14, #3
	and	x10, x12, #0x7ffffffc0
	and	x13, x12, #0x7ffffffc0
	and	x12, x12, #0x38
	str	x10, [sp, #24]
	sub	x10, x9, x13
	cmp	x10, #64
	csel	x9, x10, x8, lt
	asr	x8, x10, #63
	eor	x13, x9, x8
	add	x16, x13, #63
	cmp	x13, #0
	csel	x13, x16, x13, mi
	.loc	1 20 8
	ldp	x10, x15, [x11]
	.loc	1 28 8
	eor	x16, x8, x13, asr #6
	.loc	1 23 8
	ldr	x11, [x11, #16]
	.loc	1 28 8
	lsl	x13, x16, #6
	cmp	x16, #1
	b.lt	.LBB0_5
	lsl	x8, x12, #2
	add	x17, x15, x8
	mov	x0, xzr
	add	x1, x11, x8
	mov	w2, #36
	mov	w3, #5
	ldr	q0, [x17, #2064]
	ldr	q1, [x17, #2048]
	.loc	1 0 8 is_stmt 0
.Ltmp11:
	.p2align	4, , 8
.LBB0_2:
	ldr	x8, [sp, #24]
	movi	v21.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	mov	x25, xzr
	movi	v23.2d, #0000000000000000
	mov	w24, #1
	movi	v24.2d, #0000000000000000
	add	x4, x0, x8
	movi	v20.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	madd	x5, x4, x2, x10
	movi	v19.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	add	x6, x5, #36
	movi	v17.2d, #0000000000000000
	add	x7, x5, #72
	movi	v4.2d, #0000000000000000
	add	x19, x5, #108
	movi	v7.2d, #0000000000000000
	add	x20, x5, #144
	movi	v2.2d, #0000000000000000
	add	x21, x5, #180
	movi	v5.2d, #0000000000000000
	add	x22, x5, #216
	movi	v3.2d, #0000000000000000
	add	x23, x5, #252
	movi	v6.2d, #0000000000000000
	.p2align	4, , 8
.LBB0_3:
	.loc	1 28 8 is_stmt 1
	add	x8, x17, x25, lsl #8
	.loc	1 1 1
	ldr	s29, [x6, x25, lsl #2]
	ldr	s26, [x5, x25, lsl #2]
	.loc	1 28 8
	orr	x26, x25, #0x1
	.loc	1 1 1
	ldr	s30, [x7, x25, lsl #2]
	.loc	1 28 8
	orr	x27, x25, #0x2
	ldp	q27, q28, [x8]
	add	x8, x17, x26, lsl #8
	.loc	1 1 1
	ldr	s31, [x22, x25, lsl #2]
	ldr	s8, [x23, x25, lsl #2]
	fmla	v24.4s, v28.4s, v29.s[0]
	ldr	s9, [x5, x26, lsl #2]
	fmla	v23.4s, v27.4s, v29.s[0]
	ldr	s29, [x20, x25, lsl #2]
	fmla	v21.4s, v27.4s, v26.s[0]
	fmla	v25.4s, v28.4s, v26.s[0]
	ldr	s26, [x19, x25, lsl #2]
	fmla	v22.4s, v28.4s, v30.s[0]
	fmla	v20.4s, v27.4s, v30.s[0]
	ldr	s30, [x21, x25, lsl #2]
	fmla	v17.4s, v28.4s, v29.s[0]
	.loc	1 28 8
	orr	x25, x25, #0x3
	.loc	1 1 1
	fmla	v16.4s, v27.4s, v29.s[0]
	fmla	v19.4s, v28.4s, v26.s[0]
	fmla	v18.4s, v27.4s, v26.s[0]
	fmla	v7.4s, v28.4s, v30.s[0]
	fmla	v4.4s, v27.4s, v30.s[0]
	ldr	s30, [x6, x26, lsl #2]
	.loc	1 28 8
	ldp	q29, q26, [x8]
	.loc	1 1 1
	fmla	v2.4s, v27.4s, v31.s[0]
	.loc	1 28 8
	add	x8, x17, x27, lsl #8
	.loc	1 1 1
	fmla	v3.4s, v27.4s, v8.s[0]
	ldr	s27, [x7, x26, lsl #2]
	fmla	v5.4s, v28.4s, v31.s[0]
	ldr	s31, [x22, x26, lsl #2]
	fmla	v6.4s, v28.4s, v8.s[0]
	ldr	s28, [x19, x26, lsl #2]
	fmla	v23.4s, v29.4s, v30.s[0]
	ldr	s8, [x5, x27, lsl #2]
	fmla	v24.4s, v26.4s, v30.s[0]
	ldr	s30, [x20, x26, lsl #2]
	fmla	v20.4s, v29.4s, v27.s[0]
	fmla	v22.4s, v26.4s, v27.s[0]
	ldr	s27, [x21, x26, lsl #2]
	fmla	v18.4s, v29.4s, v28.s[0]
	fmla	v16.4s, v29.4s, v30.s[0]
	fmla	v17.4s, v26.4s, v30.s[0]
	ldr	s30, [x23, x26, lsl #2]
	fmla	v19.4s, v26.4s, v28.s[0]
	fmla	v21.4s, v29.4s, v9.s[0]
	fmla	v4.4s, v29.4s, v27.s[0]
	fmla	v7.4s, v26.4s, v27.s[0]
	fmla	v2.4s, v29.4s, v31.s[0]
	.loc	1 28 8
	ldp	q27, q28, [x8]
	.loc	1 1 1
	fmla	v3.4s, v29.4s, v30.s[0]
	.loc	1 28 8
	add	x8, x17, x25, lsl #8
	.loc	1 1 1
	ldr	s29, [x6, x27, lsl #2]
	fmla	v25.4s, v26.4s, v9.s[0]
	fmla	v5.4s, v26.4s, v31.s[0]
	ldr	s31, [x5, x25, lsl #2]
	fmla	v6.4s, v26.4s, v30.s[0]
	ldr	s26, [x7, x27, lsl #2]
	ldr	s30, [x19, x27, lsl #2]
	fmla	v24.4s, v28.4s, v29.s[0]
	fmla	v23.4s, v27.4s, v29.s[0]
	ldr	s29, [x20, x27, lsl #2]
	fmla	v22.4s, v28.4s, v26.s[0]
	fmla	v20.4s, v27.4s, v26.s[0]
	ldr	s26, [x21, x27, lsl #2]
	fmla	v19.4s, v28.4s, v30.s[0]
	fmla	v18.4s, v27.4s, v30.s[0]
	ldr	s30, [x22, x27, lsl #2]
	fmla	v17.4s, v28.4s, v29.s[0]
	fmla	v16.4s, v27.4s, v29.s[0]
	ldr	s29, [x23, x27, lsl #2]
	fmla	v21.4s, v27.4s, v8.s[0]
	fmla	v25.4s, v28.4s, v8.s[0]
	fmla	v7.4s, v28.4s, v26.s[0]
	fmla	v4.4s, v27.4s, v26.s[0]
	fmla	v5.4s, v28.4s, v30.s[0]
	.loc	1 28 8
	ldp	q8, q26, [x8]
	.loc	1 1 1
	fmla	v6.4s, v28.4s, v29.s[0]
	mov	w8, w24
	ldr	s28, [x6, x25, lsl #2]
	fmla	v2.4s, v27.4s, v30.s[0]
	fmla	v3.4s, v27.4s, v29.s[0]
	ldr	s27, [x7, x25, lsl #2]
	ldr	s29, [x19, x25, lsl #2]
	mov	w24, wzr
	fmla	v21.4s, v8.4s, v31.s[0]
	fmla	v23.4s, v8.4s, v28.s[0]
	fmla	v24.4s, v26.4s, v28.s[0]
	ldr	s28, [x20, x25, lsl #2]
	fmla	v20.4s, v8.4s, v27.s[0]
	fmla	v22.4s, v26.4s, v27.s[0]
	ldr	s27, [x21, x25, lsl #2]
	fmla	v18.4s, v8.4s, v29.s[0]
	fmla	v19.4s, v26.4s, v29.s[0]
	ldr	s29, [x22, x25, lsl #2]
	fmla	v16.4s, v8.4s, v28.s[0]
	fmla	v17.4s, v26.4s, v28.s[0]
	ldr	s28, [x23, x25, lsl #2]
	fmla	v25.4s, v26.4s, v31.s[0]
	mov	w25, #4
	fmla	v4.4s, v8.4s, v27.s[0]
	fmla	v7.4s, v26.4s, v27.s[0]
	fmla	v2.4s, v8.4s, v29.s[0]
	fmla	v5.4s, v26.4s, v29.s[0]
	fmla	v3.4s, v8.4s, v28.s[0]
	fmla	v6.4s, v26.4s, v28.s[0]
	.loc	1 28 8
	tbnz	w8, #0, .LBB0_3
	.loc	1 1 1
	orr	x5, x4, #0x1
	madd	x8, x4, x2, x10
	orr	x6, x4, #0x2
	orr	x7, x4, #0x3
	madd	x21, x5, x2, x10
	orr	x19, x4, #0x4
	madd	x22, x6, x2, x10
	orr	x20, x4, x3
	ldr	s26, [x8, #32]
	madd	x8, x7, x2, x10
	madd	x23, x19, x2, x10
	.loc	1 28 8
	cmp	x0, #56
	.loc	1 1 1
	ldr	s27, [x21, #32]
	orr	x21, x4, #0x6
	ldr	s28, [x22, #32]
	madd	x22, x20, x2, x10
	fmla	v21.4s, v1.4s, v26.s[0]
	fmla	v25.4s, v0.4s, v26.s[0]
	ldr	s26, [x8, #32]
	fmla	v23.4s, v1.4s, v27.s[0]
	madd	x8, x21, x2, x10
	fmla	v24.4s, v0.4s, v27.s[0]
	ldr	s27, [x23, #32]
	orr	x23, x4, #0x7
	fmla	v20.4s, v1.4s, v28.s[0]
	fmla	v22.4s, v0.4s, v28.s[0]
	ldr	s28, [x22, #32]
	madd	x22, x23, x2, x10
	fmla	v18.4s, v1.4s, v26.s[0]
	fmla	v19.4s, v0.4s, v26.s[0]
	ldr	s26, [x8, #32]
	fmla	v16.4s, v1.4s, v27.s[0]
	.loc	1 28 8
	add	x8, x1, x4, lsl #8
	.loc	1 1 1
	fmla	v17.4s, v0.4s, v27.s[0]
	.loc	1 28 8
	add	x4, x1, x5, lsl #8
	.loc	1 1 1
	ldr	s27, [x22, #32]
	fmla	v4.4s, v1.4s, v28.s[0]
	fmla	v7.4s, v0.4s, v28.s[0]
	.loc	1 28 8
	stp	q21, q25, [x8]
	.loc	1 1 1
	fmla	v2.4s, v1.4s, v26.s[0]
	.loc	1 28 8
	add	x8, x1, x6, lsl #8
	.loc	1 1 1
	fmla	v5.4s, v0.4s, v26.s[0]
	.loc	1 28 8
	stp	q23, q24, [x4]
	.loc	1 1 1
	fmla	v3.4s, v1.4s, v27.s[0]
	.loc	1 28 8
	add	x4, x1, x7, lsl #8
	.loc	1 1 1
	fmla	v6.4s, v0.4s, v27.s[0]
	.loc	1 28 8
	stp	q20, q22, [x8]
	add	x8, x1, x19, lsl #8
	add	x5, x0, #8
	stp	q18, q19, [x4]
	add	x4, x1, x20, lsl #8
	mov	x0, x5
	stp	q16, q17, [x8]
	add	x8, x1, x21, lsl #8
	stp	q4, q7, [x4]
	add	x4, x1, x23, lsl #8
	stp	q2, q5, [x8]
	stp	q3, q6, [x4]
	b.lo	.LBB0_2
.LBB0_5:
	subs	x8, x9, x13
	str	x8, [sp, #16]
	b.le	.LBB0_30
	.loc	1 0 8 is_stmt 0
	mov	w8, #2304
	.loc	1 28 8
	lsl	x17, x16, #14
	lsr	x0, x14, #3
	ubfiz	x1, x14, #5, #3
	mul	x16, x16, x8
	add	x15, x15, x1
	add	x17, x17, x0, lsl #14
	mov	w1, #8
	umaddl	x8, w0, w8, x16
	add	x16, x15, #2048
	bfi	x17, x14, #5, #3
	add	x14, x11, x17
	add	x8, x10, x8
	mov	w2, #36
	stp	x8, x14, [sp]
	b	.LBB0_8
	.loc	1 0 8
.Ltmp12:
	.p2align	4, , 8
.LBB0_7:
	ldr	x8, [sp, #16]
	.loc	1 28 8
	add	x13, x13, #64
	cmp	x13, x9
	sub	x8, x8, #64
	str	x8, [sp, #16]
	ldr	x8, [sp, #8]
	add	x8, x8, #4, lsl #12
	str	x8, [sp, #8]
	ldr	x8, [sp]
	add	x8, x8, #2304
	str	x8, [sp]
	b.ge	.LBB0_30
.LBB0_8:
	sub	x3, x9, x13
	cmp	x3, #1
	b.lt	.LBB0_7
	.loc	1 0 8
	ldp	x19, x8, [sp, #16]
	mov	x4, xzr
	ldp	x6, x7, [sp]
	add	x5, x13, x8
	b	.LBB0_11
	.p2align	4, , 8
.LBB0_10:
	.loc	1 28 8
	add	x4, x4, #8
	sub	x19, x19, #8
	add	x7, x7, #2048
	add	x6, x6, #288
	cmp	x4, x3
	b.ge	.LBB0_7
.LBB0_11:
	.loc	1 28 8 is_stmt 1
	cmp	x19, #1
	add	x17, x4, x13
	csinc	x8, x19, xzr, gt
	sub	x21, x9, x17
	cmp	x8, #8
	csel	x20, x8, x1, lt
	.loc	1 27 8
	cmp	x21, #1
	b.lt	.LBB0_16
	.loc	1 0 8 is_stmt 0
	mov	x22, xzr
	mov	x14, x7
	.p2align	4, , 8
.LBB0_13:
	mov	x8, xzr
	.p2align	4, , 8
.LBB0_14:
	.loc	1 27 8 is_stmt 1
	str	wzr, [x14, x8]
	add	x8, x8, #4
	cmp	x8, #32
	b.ne	.LBB0_14
	add	x22, x22, #1
	add	x14, x14, #256
	cmp	x22, x20
	b.ne	.LBB0_13
.LBB0_16:
	.loc	1 0 8 is_stmt 0
	ldr	x8, [sp, #24]
	mov	x14, xzr
	add	x23, x5, x4
	.loc	1 28 8 is_stmt 1
	add	x22, x17, x8
	mov	w8, #1
	b	.LBB0_18
	.loc	1 0 8 is_stmt 0
.Ltmp13:
	.p2align	4, , 8
.LBB0_17:
	mov	w8, wzr
	mov	w14, #4
	.loc	1 28 8
	tbz	w24, #0, .LBB0_10
.LBB0_18:
	.loc	1 0 8
	mov	w24, w8
	.loc	1 28 8
	cmp	x21, #1
	b.lt	.LBB0_17
	.loc	1 0 8
	mov	x25, xzr
	.loc	1 28 8
	add	x17, x15, x14, lsl #8
	add	x27, x6, x14, lsl #2
	.loc	1 0 8
.Ltmp14:
	.p2align	4, , 8
.LBB0_20:
	add	x8, x23, x25
	mov	x28, xzr
	mov	x26, x17
	add	x30, x11, x8, lsl #8
	.p2align	4, , 8
.LBB0_21:
	add	x0, x28, x12
	mov	x14, xzr
	mov	x8, xzr
	ldr	s0, [x30, x0, lsl #2]
	.p2align	4, , 8
.LBB0_22:
	.loc	1 28 8 is_stmt 1
	ldr	s1, [x27, x8]
	add	x8, x8, #4
	ldr	s2, [x26, x14]
	add	x14, x14, #256
	cmp	x8, #16
	.loc	1 1 1
	fmadd	s0, s1, s2, s0
	.loc	1 28 8
	str	s0, [x30, x0, lsl #2]
	b.ne	.LBB0_22
	add	x28, x28, #1
	add	x26, x26, #4
	cmp	x28, #8
	b.ne	.LBB0_21
	add	x25, x25, #1
	add	x27, x27, #36
	cmp	x25, x20
	b.ne	.LBB0_20
	.loc	1 0 8 is_stmt 0
	mov	w8, wzr
	mov	w14, #4
	.loc	1 28 8
	tbnz	w24, #0, .LBB0_18
	.loc	1 0 8
	mov	x17, xzr
	mov	x21, x7
	.p2align	4, , 8
.LBB0_27:
	add	x8, x17, x22
	mov	x14, xzr
	madd	x8, x8, x2, x10
	.p2align	4, , 8
.LBB0_28:
	.loc	1 28 8 is_stmt 1
	ldr	s0, [x8, #32]
	ldr	s1, [x16, x14]
	ldr	s2, [x21, x14]
	.loc	1 1 1
	fmadd	s0, s0, s1, s2
	.loc	1 28 8
	str	s0, [x21, x14]
	add	x14, x14, #4
	cmp	x14, #32
	b.ne	.LBB0_28
	add	x17, x17, #1
	add	x21, x21, #256
	cmp	x17, x20
	b.ne	.LBB0_27
	b	.LBB0_10
.LBB0_30:
	.loc	1 30 8 epilogue_begin
	ldp	x20, x19, [sp, #128]
	mov	w0, wzr
	ldp	x22, x21, [sp, #112]
	ldp	x24, x23, [sp, #96]
	ldp	x26, x25, [sp, #80]
	ldp	x28, x27, [sp, #64]
	ldp	x29, x30, [sp, #48]
	ldp	d9, d8, [sp, #32]
	add	sp, sp, #144
	ret
.Ltmp15:
.Lfunc_end0:
	.size	infer_dispatch_0_matmul_Dx64x9_f32, .Lfunc_end0-infer_dispatch_0_matmul_Dx64x9_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_matmul_Dx2x64_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_1_matmul_Dx2x64_f32,@function
infer_dispatch_1_matmul_Dx2x64_f32:
.Lfunc_begin1:
	.file	2 "results/e14_aarch64_qemu/aarch64/dump/dynamic" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	mov	x29, sp
	.cfi_def_cfa w29, 96
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w23, -40
	.cfi_offset w24, -48
	.cfi_offset w25, -56
	.cfi_offset w26, -64
	.cfi_offset w27, -72
	.cfi_offset w28, -80
	.cfi_offset w30, -88
	.cfi_offset w29, -96
.Ltmp16:
	.loc	2 12 8 prologue_end
	ldp	x8, x11, [x1, #24]
	mov	w9, #64
	.loc	2 28 8
	ldr	w13, [x2]
	.loc	2 12 8
	ldr	x10, [x8]
	.loc	2 28 8
	lsl	x8, x13, #6
	sub	x10, x10, x8
	cmp	x10, #64
	asr	x12, x10, #63
	csel	x9, x10, x9, lt
	eor	x15, x9, x12
	add	x16, x15, #63
	cmp	x15, #0
	csel	x15, x16, x15, mi
	.loc	2 20 8
	ldp	x14, x10, [x11]
	.loc	2 28 8
	eor	x15, x12, x15, asr #6
	.loc	2 23 8
	ldr	x11, [x11, #16]
	.loc	2 28 8
	lsl	x12, x15, #6
	cmp	x15, #1
	b.lt	.LBB1_5
	.loc	2 0 8 is_stmt 0
	mov	w3, #5
	mov	x1, xzr
	orr	x16, x8, #0x1
	orr	x17, x8, #0x2
	orr	x0, x8, #0x3
	orr	x2, x8, #0x4
	orr	x3, x8, x3
	orr	x4, x8, #0x6
	orr	x5, x8, #0x7
	.loc	2 28 8
	add	x6, x14, x13, lsl #14
	.loc	2 0 8
.Ltmp17:
	.p2align	4, , 8
.LBB1_2:
	movi	d4, #0000000000000000
	mov	x21, xzr
	movi	d7, #0000000000000000
	add	x7, x1, x8
	movi	d5, #0000000000000000
	add	x19, x10, #16
	movi	d6, #0000000000000000
	movi	d3, #0000000000000000
	movi	d2, #0000000000000000
	movi	d0, #0000000000000000
	movi	d1, #0000000000000000
	.p2align	4, , 8
.LBB1_3:
	mov	x20, x21
	.loc	2 28 8 is_stmt 1
	add	x21, x6, x21, lsl #2
	ldp	d17, d16, [x19, #-16]
	cmp	x20, #60
	.loc	2 1 1
	ldp	s18, s22, [x21]
	ldr	s19, [x21, #256]
	ldr	s20, [x21, #512]
	ldr	s21, [x21, #768]
	fmla	v4.2s, v17.2s, v18.s[0]
	ldr	s18, [x21, #1024]
	fmla	v7.2s, v17.2s, v19.s[0]
	ldr	s19, [x21, #1280]
	fmla	v5.2s, v17.2s, v20.s[0]
	ldr	s20, [x21, #1536]
	fmla	v6.2s, v17.2s, v21.s[0]
	ldr	s21, [x21, #1792]
	fmla	v3.2s, v17.2s, v18.s[0]
	ldr	s18, [x21, #260]
	fmla	v2.2s, v17.2s, v19.s[0]
	ldr	s19, [x21, #516]
	fmla	v0.2s, v17.2s, v20.s[0]
	ldr	s20, [x21, #1028]
	fmla	v1.2s, v17.2s, v21.s[0]
	ldr	s17, [x21, #772]
	ldr	s21, [x21, #1284]
	fmla	v4.2s, v16.2s, v22.s[0]
	ldr	s22, [x21, #1540]
	fmla	v7.2s, v16.2s, v18.s[0]
	ldr	s18, [x21, #1796]
	fmla	v5.2s, v16.2s, v19.s[0]
	fmla	v6.2s, v16.2s, v17.s[0]
	fmla	v3.2s, v16.2s, v20.s[0]
	fmla	v2.2s, v16.2s, v21.s[0]
	ldr	s21, [x21, #264]
	fmla	v0.2s, v16.2s, v22.s[0]
	ldr	s22, [x21, #520]
	fmla	v1.2s, v16.2s, v18.s[0]
	ldr	s16, [x21, #776]
	.loc	2 28 8
	ldp	d19, d17, [x19], #32
	.loc	2 1 1
	ldp	s20, s18, [x21, #8]
	fmla	v7.2s, v19.2s, v21.s[0]
	ldr	s21, [x21, #1288]
	fmla	v5.2s, v19.2s, v22.s[0]
	ldr	s22, [x21, #1544]
	fmla	v4.2s, v19.2s, v20.s[0]
	ldr	s20, [x21, #1032]
	fmla	v6.2s, v19.2s, v16.s[0]
	ldr	s16, [x21, #1800]
	fmla	v2.2s, v19.2s, v21.s[0]
	fmla	v0.2s, v19.2s, v22.s[0]
	fmla	v3.2s, v19.2s, v20.s[0]
	ldr	s20, [x21, #268]
	fmla	v1.2s, v19.2s, v16.s[0]
	ldr	s16, [x21, #524]
	ldr	s19, [x21, #780]
	fmla	v7.2s, v17.2s, v20.s[0]
	ldr	s20, [x21, #1292]
	fmla	v5.2s, v17.2s, v16.s[0]
	ldr	s16, [x21, #1548]
	fmla	v4.2s, v17.2s, v18.s[0]
	ldr	s18, [x21, #1036]
	fmla	v6.2s, v17.2s, v19.s[0]
	ldr	s19, [x21, #1804]
	fmla	v2.2s, v17.2s, v20.s[0]
	.loc	2 28 8
	add	x21, x20, #4
	.loc	2 1 1
	fmla	v0.2s, v17.2s, v16.s[0]
	fmla	v3.2s, v17.2s, v18.s[0]
	fmla	v1.2s, v17.2s, v19.s[0]
	.loc	2 28 8
	b.lo	.LBB1_3
	add	x19, x16, x1
	add	x20, x17, x1
	str	d4, [x11, x7, lsl #3]
	add	x7, x0, x1
	add	x21, x1, #8
	cmp	x1, #56
	str	d7, [x11, x19, lsl #3]
	add	x19, x2, x1
	str	d5, [x11, x20, lsl #3]
	add	x20, x4, x1
	str	d6, [x11, x7, lsl #3]
	add	x7, x3, x1
	str	d3, [x11, x19, lsl #3]
	add	x19, x5, x1
	add	x6, x6, #2048
	mov	x1, x21
	str	d2, [x11, x7, lsl #3]
	str	d0, [x11, x20, lsl #3]
	str	d1, [x11, x19, lsl #3]
	b.lo	.LBB1_2
.LBB1_5:
	subs	x16, x9, x12
	b.le	.LBB1_23
	lsl	x17, x15, #9
	lsl	x15, x15, #14
	add	x17, x17, x13, lsl #9
	add	x15, x15, x13, lsl #14
	add	x17, x17, x11
	add	x14, x14, x15
	add	x13, x17, #4
	mov	w15, #8
	b	.LBB1_8
	.loc	2 0 8 is_stmt 0
.Ltmp18:
	.p2align	4, , 8
.LBB1_7:
	.loc	2 28 8
	add	x12, x12, #64
	sub	x16, x16, #64
	add	x13, x13, #512
	add	x14, x14, #4, lsl #12
	cmp	x12, x9
	b.ge	.LBB1_23
.LBB1_8:
	sub	x17, x9, x12
	cmp	x17, #1
	b.lt	.LBB1_7
	.loc	2 0 8
	mov	x0, xzr
	add	x1, x12, x8
	mov	x2, x14
	mov	x3, x13
	mov	x4, x16
	b	.LBB1_11
	.p2align	4, , 8
.LBB1_10:
	.loc	2 28 8
	add	x0, x0, #8
	sub	x4, x4, #8
	add	x3, x3, #64
	add	x2, x2, #2048
	cmp	x0, x17
	b.ge	.LBB1_7
.LBB1_11:
	.loc	2 28 8 is_stmt 1
	cmp	x4, #1
	add	x6, x0, x12
	csinc	x5, x4, xzr, gt
	sub	x6, x9, x6
	cmp	x5, #8
	csel	x5, x5, x15, lt
	.loc	2 27 8
	cmp	x6, #1
	b.lt	.LBB1_14
	.loc	2 0 8 is_stmt 0
	neg	x7, x5, lsl #3
	mov	x19, x3
	.p2align	4, , 8
.LBB1_13:
	.loc	2 27 8 is_stmt 1
	stur	xzr, [x19, #-4]
	add	x19, x19, #8
	adds	x7, x7, #8
	b.ne	.LBB1_13
.LBB1_14:
	.loc	2 0 8 is_stmt 0
	mov	x21, xzr
	add	x7, x1, x0
	mov	x19, x2
	mov	x20, x10
	b	.LBB1_16
	.p2align	4, , 8
.LBB1_15:
	.loc	2 28 8 is_stmt 1
	add	x22, x21, #4
	cmp	x21, #60
	add	x20, x20, #32
	add	x19, x19, #16
	mov	x21, x22
	b.hs	.LBB1_10
.LBB1_16:
	.loc	2 28 8
	cmp	x6, #1
	b.lt	.LBB1_15
	.loc	2 0 8 is_stmt 0
	mov	x22, xzr
	mov	x23, x19
	.p2align	4, , 8
.LBB1_18:
	add	x24, x7, x22
	mov	w30, wzr
	mov	x25, xzr
	add	x24, x11, x24, lsl #3
	.p2align	4, , 8
.LBB1_19:
	lsl	x28, x25, #2
	mov	x27, xzr
	mov	w26, w30
	ldr	s0, [x24, x28]
	.p2align	4, , 8
.LBB1_20:
	.loc	2 28 8 is_stmt 1
	ldr	s1, [x23, x27]
	add	x27, x27, #4
	ldr	s2, [x20, x28]
	add	x28, x28, #8
	cmp	x27, #16
	.loc	2 1 1
	fmadd	s0, s1, s2, s0
	.loc	2 28 8
	str	s0, [x24, x25, lsl #2]
	b.ne	.LBB1_20
	.loc	2 0 8 is_stmt 0
	mov	w30, #1
	mov	w25, #1
	.loc	2 28 8
	tbz	w26, #0, .LBB1_19
	add	x22, x22, #1
	add	x23, x23, #256
	cmp	x22, x5
	b.ne	.LBB1_18
	b	.LBB1_15
.LBB1_23:
	.loc	2 30 8 epilogue_begin is_stmt 1
	ldp	x20, x19, [sp, #80]
	mov	w0, wzr
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp19:
.Lfunc_end1:
	.size	infer_dispatch_1_matmul_Dx2x64_f32, .Lfunc_end1-infer_dispatch_1_matmul_Dx2x64_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.p2align	2
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin2:
	.cfi_startproc
	adrp	x8, iree_hal_executable_library_query_v0
	add	x8, x8, :lo12:iree_hal_executable_library_query_v0
	cmp	w0, #6
	csel	x0, x8, xzr, eq
	ret
.Lfunc_end2:
	.size	iree_hal_executable_library_query, .Lfunc_end2-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end2-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin3:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB3_2
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
.LBB3_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end3:
	.size	iree_h2f_ieee, .Lfunc_end3-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin4:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB4_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB4_4
	cbz	w10, .LBB4_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB4_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB4_7
	mov	w9, #31744
.LBB4_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB4_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB4_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB4_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB4_10:
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
.Lfunc_end4:
	.size	iree_f2h_ieee, .Lfunc_end4-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin5:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB5_2
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
.LBB5_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end5:
	.size	__gnu_h2f_ieee, .Lfunc_end5-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin6:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB6_2
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
.LBB6_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end6:
	.size	__extendhfsf2, .Lfunc_end6-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin7:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB7_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB7_4
	cbz	w10, .LBB7_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB7_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB7_7
	mov	w9, #31744
.LBB7_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB7_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB7_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB7_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB7_10:
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
.Lfunc_end7:
	.size	__gnu_f2h_ieee, .Lfunc_end7-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin8:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB8_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB8_4
	cbz	w10, .LBB8_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB8_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB8_6
.LBB8_5:
	mov	w9, #31744
	b	.LBB8_9
.LBB8_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB8_8
	mov	w9, wzr
	b	.LBB8_9
.LBB8_8:
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
.LBB8_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end8:
	.size	__truncsfhf2, .Lfunc_end8-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin9:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB9_2
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
.LBB9_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	fcvt	d0, s0
	ret
.Lfunc_end9:
	.size	__extendhfdf2, .Lfunc_end9-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin10:
	.cfi_startproc
	fcvt	s0, d0
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB10_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB10_4
	cbz	w10, .LBB10_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB10_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB10_6
.LBB10_5:
	mov	w9, #31744
	b	.LBB10_9
.LBB10_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB10_8
	mov	w9, wzr
	b	.LBB10_9
.LBB10_8:
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
.LBB10_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end10:
	.size	__truncdfhf2, .Lfunc_end10-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin11:
	.cfi_startproc
	fmadd	d0, d0, d1, d2
	ret
.Lfunc_end11:
	.size	fma, .Lfunc_end11-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin12:
	.cfi_startproc
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	ret
.Lfunc_end12:
	.size	__math_invalidf, .Lfunc_end12-__math_invalidf
	.cfi_endproc

	.section	.text.__math_oflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin13:
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
.Lfunc_end13:
	.size	__math_oflowf, .Lfunc_end13-__math_oflowf
	.cfi_endproc

	.section	.text.__math_xflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin14:
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
.Lfunc_end14:
	.size	__math_xflowf, .Lfunc_end14-__math_xflowf
	.cfi_endproc

	.section	.text.__math_uflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin15:
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
.Lfunc_end15:
	.size	__math_uflowf, .Lfunc_end15-__math_uflowf
	.cfi_endproc

	.section	.text.ceilf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin16:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB16_6
	cmp	w9, #127
	b.lo	.LBB16_4
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB16_6
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
.LBB16_4:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s1, s0, s1
	str	s1, [sp, #12]
	tbnz	w8, #31, .LBB16_7
	fmov	s1, #1.00000000
	cmp	w8, #0
	fcsel	s0, s0, s1, eq
.LBB16_6:
	add	sp, sp, #16
	ret
.LBB16_7:
	movi	v0.2s, #128, lsl #24
	add	sp, sp, #16
	ret
.Lfunc_end16:
	.size	ceilf, .Lfunc_end16-ceilf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI17_0:
	.xword	0x40471547652b82fe
.LCPI17_1:
	.xword	0x3f2ebfce50fac4f3
.LCPI17_2:
	.xword	0x3ebc6af84b912394
.LCPI17_3:
	.xword	0x3f962e42ff0c52d6
	.section	.text.expf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin17:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w8, w8, #20, #11
	cmp	w8, #1067
	b.hs	.LBB17_3
.LBB17_1:
	adrp	x8, .LCPI17_0
	fcvt	d0, s0
	adrp	x9, .LCPI17_2
	adrp	x10, .LCPI17_3
	ldr	d1, [x8, :lo12:.LCPI17_0]
	mov	x8, #4843621399236968448
	ldr	d4, [x9, :lo12:.LCPI17_2]
	ldr	d5, [x10, :lo12:.LCPI17_3]
	adrp	x10, __exp2f_data
	add	x10, x10, :lo12:__exp2f_data
	fmul	d0, d0, d1
	fmov	d1, x8
	mov	x8, #-4379750637617807360
	fmov	d2, x8
	adrp	x8, .LCPI17_1
	fadd	d1, d0, d1
	ldr	d3, [x8, :lo12:.LCPI17_1]
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
.LBB17_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB17_3:
	mov	w9, #-8388608
	fmov	s1, w9
	fcmp	s0, s1
	movi	d1, #0000000000000000
	b.eq	.LBB17_2
	cmp	w8, #2040
	b.hs	.LBB17_7
	mov	w8, #29207
	movk	w8, #17073, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.le	.LBB17_8
	mov	w8, #1879048192
	movi	v0.2s, #112, lsl #24
	str	w8, [sp, #8]
	ldr	s1, [sp, #8]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB17_7:
	fadd	s1, s0, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB17_8:
	mov	w8, #61876
	movk	w8, #49871, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.pl	.LBB17_1
	mov	w8, #268435456
	movi	v0.2s, #16, lsl #24
	str	w8, [sp, #12]
	ldr	s1, [sp, #12]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end17:
	.size	expf, .Lfunc_end17-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin18:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end18:
	.size	feclearexcept, .Lfunc_end18-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin19:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end19:
	.size	feraiseexcept, .Lfunc_end19-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin20:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end20:
	.size	fetestexcept, .Lfunc_end20-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin21:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end21:
	.size	fegetround, .Lfunc_end21-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin22:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end22:
	.size	__fesetround, .Lfunc_end22-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin23:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end23:
	.size	fegetenv, .Lfunc_end23-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin24:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end24:
	.size	fesetenv, .Lfunc_end24-fesetenv
	.cfi_endproc

	.section	.text.floorf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin25:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.ls	.LBB25_3
	fmov	s1, s0
.LBB25_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB25_3:
	cmp	w9, #127
	b.lo	.LBB25_6
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB25_9
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
.LBB25_6:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s2, s0, s1
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	tbz	w8, #31, .LBB25_2
	fcmp	s0, #0.0
	fmov	s1, s0
	b.eq	.LBB25_2
	fmov	s1, #-1.00000000
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB25_9:
	fmov	s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end25:
	.size	floorf, .Lfunc_end25-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin26:
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
	b.eq	.LBB26_3
	fsub	d3, d0, d1
	fsub	d4, d0, d2
	fcmp	d3, d2
	fccmp	d4, d1, #0, eq
	b.eq	.LBB26_3
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
.LBB26_3:
	fcvt	s0, d0
	ret
.Lfunc_end26:
	.size	fmaf, .Lfunc_end26-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin27:
	.cfi_startproc
	fmov	w12, s1
	lsl	w10, w12, #1
	cbz	w10, .LBB27_8
	fmov	w8, s1
	mov	w9, #2139095040
	and	w8, w8, #0x7fffffff
	cmp	w8, w9
	b.hi	.LBB27_8
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB27_8
	lsl	w11, w9, #1
	cmp	w11, w10
	b.ls	.LBB27_9
	ubfx	w11, w12, #23, #8
	cbz	w8, .LBB27_10
	mov	w10, #8388608
	bfxil	w10, w9, #0, #23
	cbz	w11, .LBB27_13
.LBB27_6:
	mov	w13, #8388608
	bfxil	w13, w12, #0, #23
	cmp	w8, w11
	b.gt	.LBB27_17
.LBB27_7:
	subs	w11, w10, w13
	b.pl	.LBB27_20
	b	.LBB27_21
.LBB27_8:
	fmul	s0, s0, s1
	fdiv	s0, s0, s0
	ret
.LBB27_9:
	movi	d1, #0000000000000000
	fmul	s1, s0, s1
	fcsel	s0, s1, s0, eq
	ret
.LBB27_10:
	mov	w8, wzr
	lsl	w10, w9, #9
	tbnz	w10, #31, .LBB27_12
	.p2align	4, , 8
.LBB27_11:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	tbz	w10, #31, .LBB27_11
.LBB27_12:
	mov	w10, #1
	sub	w10, w10, w8
	lsl	w10, w9, w10
	cbnz	w11, .LBB27_6
.LBB27_13:
	mov	w11, wzr
	lsl	w13, w12, #9
	tbnz	w13, #31, .LBB27_15
	.p2align	4, , 8
.LBB27_14:
	sub	w11, w11, #1
	lsl	w13, w13, #1
	tbz	w13, #31, .LBB27_14
.LBB27_15:
	mov	w13, #1
	sub	w13, w13, w11
	lsl	w13, w12, w13
	cmp	w8, w11
	b.gt	.LBB27_17
	b	.LBB27_7
	.p2align	4, , 8
.LBB27_16:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	cmp	w8, w11
	b.le	.LBB27_19
.LBB27_17:
	subs	w12, w10, w13
	b.mi	.LBB27_16
	mov	w10, w12
	cbnz	w12, .LBB27_16
	b	.LBB27_24
.LBB27_19:
	mov	w8, w11
	subs	w11, w10, w13
	b.mi	.LBB27_21
.LBB27_20:
	mov	w10, w11
	cbz	w11, .LBB27_24
.LBB27_21:
	and	w9, w9, #0x80000000
	lsr	w11, w10, #23
	cbnz	w11, .LBB27_23
	.p2align	4, , 8
.LBB27_22:
	sub	w8, w8, #1
	cmp	w10, #1024, lsl #12
	lsl	w10, w10, #1
	b.lo	.LBB27_22
.LBB27_23:
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
.LBB27_24:
	movi	d1, #0000000000000000
	fmul	s0, s0, s1
	ret
.Lfunc_end27:
	.size	fmodf, .Lfunc_end27-fmodf
	.cfi_endproc

	.section	.text.frexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin28:
	.cfi_startproc
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB28_7
	cbnz	w8, .LBB28_4
	fcmp	s0, #0.0
	b.eq	.LBB28_5
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
	b	.LBB28_6
.LBB28_4:
	and	w9, w9, #0x807fffff
	sub	w8, w8, #126
	orr	w9, w9, #0x3f000000
	fmov	s0, w9
	b	.LBB28_6
.LBB28_5:
	mov	w8, wzr
.LBB28_6:
	str	w8, [x0]
.LBB28_7:
	ret
.Lfunc_end28:
	.size	frexpf, .Lfunc_end28-frexpf
	.cfi_endproc

	.section	.text.ldexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin29:
	.cfi_startproc
	cmp	w0, #128
	b.lt	.LBB29_4
	movi	v1.2s, #127, lsl #24
	cmp	w0, #255
	fmul	s0, s0, s1
	b.lo	.LBB29_7
	cmp	w0, #381
	mov	w8, #381
	csel	w8, w0, w8, lo
	fmul	s0, s0, s1
	sub	w0, w8, #254
.LBB29_3:
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB29_4:
	cmn	w0, #127
	b.gt	.LBB29_3
	mov	w8, #209715200
	cmn	w0, #229
	fmov	s1, w8
	fmul	s0, s0, s1
	b.hi	.LBB29_8
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
.LBB29_7:
	sub	w0, w0, #127
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB29_8:
	add	w0, w0, #102
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.Lfunc_end29:
	.size	ldexpf, .Lfunc_end29-ldexpf
	.cfi_endproc

	.section	.text.scalbnf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
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
	.size	scalbnf, .Lfunc_end30-scalbnf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI31_0:
	.xword	0xbfd71969a075c67a
.LCPI31_1:
	.xword	0x3fd27616c9496e0b
.LCPI31_2:
	.xword	0xbfe7154748bef6c8
.LCPI31_3:
	.xword	0x3fdec70a6ca7badd
.LCPI31_4:
	.xword	0x3ff71547652ab82b
.LCPI31_5:
	.xword	0x405fffffffd1d571
.LCPI31_6:
	.xword	0x3fcebfce50fac4f3
.LCPI31_7:
	.xword	0x3fac6af84b912394
.LCPI31_8:
	.xword	0x3fe62e42ff0c52d6
	.section	.text.powf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin31:
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
	b.lo	.LBB31_6
	mov	w11, #16777216
	add	w12, w10, w11
	cmp	w12, w11
	b.ls	.LBB31_6
	mov	w8, wzr
.LBB31_3:
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
	adrp	x11, .LCPI31_4
	scvtf	d4, w10
	adrp	x10, .LCPI31_3
	ldp	d3, d5, [x9]
	adrp	x9, .LCPI31_2
	fcvt	d0, s0
	fmadd	d0, d0, d3, d2
	fadd	d3, d5, d4
	ldr	d2, [x9, :lo12:.LCPI31_2]
	adrp	x9, .LCPI31_0
	ldr	d4, [x10, :lo12:.LCPI31_3]
	adrp	x10, .LCPI31_1
	ldr	d5, [x11, :lo12:.LCPI31_4]
	ldr	d6, [x10, :lo12:.LCPI31_1]
	mov	x10, #1
	movk	x10, #16479, lsl #48
	fmadd	d2, d0, d4, d2
	fmadd	d3, d0, d5, d3
	ldr	d5, [x9, :lo12:.LCPI31_0]
	fmul	d4, d0, d0
	fmadd	d0, d0, d6, d5
	fmadd	d7, d2, d4, d3
	fmul	d3, d4, d4
	fmadd	d7, d0, d3, d7
	fmul	d0, d7, d1
	fmov	x9, d0
	and	x9, x9, #0x7fff800000000000
	cmp	x9, x10
	b.hs	.LBB31_11
.LBB31_4:
	mov	x9, #4821103401100115968
	adrp	x10, .LCPI31_7
	adrp	x11, .LCPI31_8
	fmov	d1, x9
	mov	x9, #-4402268635754659840
	ldr	d4, [x10, :lo12:.LCPI31_7]
	ldr	d5, [x11, :lo12:.LCPI31_8]
	adrp	x11, __exp2f_data
	add	x11, x11, :lo12:__exp2f_data
	fmov	d2, x9
	adrp	x9, .LCPI31_6
	fadd	d1, d0, d1
	ldr	d3, [x9, :lo12:.LCPI31_6]
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
.LBB31_5:
	add	sp, sp, #16
	ret
.LBB31_6:
	mov	w11, #-16777217
	sub	w12, w10, #1
	cmp	w12, w11
	b.hs	.LBB31_22
	lsl	w10, w9, #1
	sub	w10, w10, #1
	cmp	w10, w11
	b.hs	.LBB31_28
	tbnz	w9, #31, .LBB31_13
	mov	w8, wzr
	lsr	w10, w9, #23
	cbnz	w10, .LBB31_3
.LBB31_10:
	movi	v2.2s, #75, lsl #24
	mov	w10, #-192937984
	fmul	s0, s0, s2
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	add	w9, w9, w10
	b	.LBB31_3
.LBB31_11:
	adrp	x9, .LCPI31_5
	ldr	d1, [x9, :lo12:.LCPI31_5]
	fcmp	d0, d1
	b.le	.LBB31_16
	movi	v0.2s, #240, lsl #24
	cmp	w8, #0
	movi	v1.2s, #112, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #8]
	ldr	s0, [sp, #8]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB31_13:
	ubfx	w9, w8, #23, #8
	cmp	w9, #127
	b.lo	.LBB31_19
	cmp	w9, #150
	b.ls	.LBB31_18
.LBB31_15:
	mov	w8, wzr
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB31_3
	b	.LBB31_10
.LBB31_16:
	mov	x9, #211106232532992
	movk	x9, #49250, lsl #48
	fmov	d1, x9
	fcmp	d0, d1
	b.hi	.LBB31_4
	movi	v0.2s, #144, lsl #24
	cmp	w8, #0
	movi	v1.2s, #16, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #12]
	ldr	s0, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB31_18:
	mov	w10, #150
	sub	w9, w10, w9
	mov	w10, #1
	lsl	w9, w10, w9
	sub	w10, w9, #1
	tst	w10, w8
	b.eq	.LBB31_20
.LBB31_19:
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	add	sp, sp, #16
	ret
.LBB31_20:
	tst	w9, w8
	b.eq	.LBB31_15
	mov	w8, #65536
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB31_3
	b	.LBB31_10
.LBB31_22:
	mov	w11, #1065353216
	cmp	w9, w11
	b.eq	.LBB31_33
	cbz	w10, .LBB31_33
	mov	w11, #-16777216
	lsl	w9, w9, #1
	cmp	w9, w11
	b.hi	.LBB31_34
	mov	w11, #-16777215
	cmp	w10, w11
	b.hs	.LBB31_34
	fmov	s0, #1.00000000
	mov	w10, #2130706432
	cmp	w9, w10
	b.eq	.LBB31_5
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
.LBB31_28:
	fmul	s0, s0, s0
	tbz	w9, #31, .LBB31_31
	ubfx	w9, w8, #23, #8
	sub	w10, w9, #151
	cmn	w10, #24
	b.lo	.LBB31_31
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
.LBB31_31:
	tbz	w8, #31, .LBB31_5
	fmov	s1, #1.00000000
	fdiv	s0, s1, s0
	str	s0, [sp, #4]
	ldr	s0, [sp, #4]
	add	sp, sp, #16
	ret
.LBB31_33:
	fmov	s0, #1.00000000
	add	sp, sp, #16
	ret
.LBB31_34:
	fadd	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end31:
	.size	powf, .Lfunc_end31-powf
	.cfi_endproc

	.section	.text.rintf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin32:
	.cfi_startproc
	fmov	w8, s0
	mov	w9, #1249902592
	and	w10, w8, #0x7f000000
	cmp	w10, w9
	b.hi	.LBB32_3
	movi	v1.2s, #203, lsl #24
	cmn	w8, #1
	movi	v2.2s, #75, lsl #24
	fadd	s3, s0, s1
	fadd	s0, s0, s2
	fadd	s2, s3, s2
	fadd	s0, s0, s1
	fcsel	s0, s0, s2, gt
	fcmp	s0, #0.0
	b.ne	.LBB32_3
	movi	v0.2s, #128, lsl #24
	cmn	w8, #1
	movi	d1, #0000000000000000
	fcsel	s0, s1, s0, gt
.LBB32_3:
	ret
.Lfunc_end32:
	.size	rintf, .Lfunc_end32-rintf
	.cfi_endproc

	.section	.text.roundf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin33:
	.cfi_startproc
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB33_9
	fabs	s1, s0
	cmp	w9, #125
	movi	v2.2s, #75, lsl #24
	fadd	s2, s1, s2
	b.hi	.LBB33_3
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB33_3:
	movi	v0.2s, #203, lsl #24
	fadd	s0, s2, s0
	fmov	s2, #0.50000000
	fsub	s0, s0, s1
	fcmp	s0, s2
	b.le	.LBB33_5
	fadd	s0, s1, s0
	fmov	s1, #-1.00000000
	b	.LBB33_7
.LBB33_5:
	fmov	s2, #-0.50000000
	fcmp	s0, s2
	fadd	s0, s1, s0
	b.hi	.LBB33_8
	fmov	s1, #1.00000000
.LBB33_7:
	fadd	s0, s0, s1
.LBB33_8:
	fneg	s1, s0
	cmp	w8, #0
	fcsel	s0, s1, s0, mi
.LBB33_9:
	ret
.Lfunc_end33:
	.size	roundf, .Lfunc_end33-roundf
	.cfi_endproc

	.type	__unnamed_1,@object
	.section	.rodata.__unnamed_1,"a",@progbits
__unnamed_1:
	.asciz	"dyn_batch_mlp_linked"
	.size	__unnamed_1, 21

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
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_funcs:
	.xword	infer_dispatch_0_matmul_Dx64x9_f32
	.xword	infer_dispatch_1_matmul_Dx2x64_f32
	.size	iree_hal_executable_library_query_v0_funcs, 16

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
	.xword	0
	.hword	0
	.byte	2
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
	.byte	2
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
	.size	iree_hal_executable_library_query_v0_attrs, 128

	.type	__unnamed_2,@object
	.section	.rodata.__unnamed_2,"a",@progbits
__unnamed_2:
	.asciz	"infer_dispatch_0_matmul_Dx64x9_f32"
	.size	__unnamed_2, 35

	.type	__unnamed_3,@object
	.section	.rodata.__unnamed_3,"a",@progbits
__unnamed_3:
	.asciz	"infer_dispatch_1_matmul_Dx2x64_f32"
	.size	__unnamed_3, 35

	.type	iree_hal_executable_library_query_v0_names,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_names,"aw",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_names:
	.xword	__unnamed_2
	.xword	__unnamed_3
	.size	iree_hal_executable_library_query_v0_names, 16

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_4, 86

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_5, 86

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.word	3
	.word	85
	.xword	__unnamed_4
	.word	3
	.word	85
	.xword	__unnamed_5
	.size	iree_hal_executable_library_query_v0_source_locations, 32

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_stage_location_tables,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_stage_location_tables,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_stage_location_tables:
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 48

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.xword	iree_hal_executable_library_query_v0_header
	.zero	16
	.word	2
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
	.word	.Linfo_string4
	.word	.Linfo_string4
	.byte	1
	.byte	1
	.word	71

	.byte	3
	.word	.Linfo_string5
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
	.word	.Linfo_string6
	.word	.Linfo_string6
	.byte	2
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end1:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"IREE"
.Linfo_string1:
	.asciz	"configured_module_infer_dispatch_0.mlir"
.Linfo_string2:
	.asciz	"results/e14_aarch64_qemu/aarch64/dump/dynamic"
.Linfo_string3:
	.asciz	"configured_module_infer_dispatch_1.mlir"
.Linfo_string4:
	.asciz	"infer_dispatch_0_matmul_Dx64x9_f32"
.Linfo_string5:
	.asciz	"int"
.Linfo_string6:
	.asciz	"infer_dispatch_1_matmul_Dx2x64_f32"
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.hword	2
	.word	.Lcu_begin0
	.word	79
	.word	42
	.asciz	"infer_dispatch_0_matmul_Dx64x9_f32"
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
	.asciz	"infer_dispatch_1_matmul_Dx2x64_f32"
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
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
