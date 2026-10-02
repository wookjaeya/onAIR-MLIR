	.file	"wgan_linked"
	.section	.text.infer_dispatch_0_matmul_like_32x50176x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_0_matmul_like_32x50176x3_f32,@function
infer_dispatch_0_matmul_like_32x50176x3_f32:
.Lfunc_begin0:
	.file	1 "dump" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	stp	d15, d14, [sp, #-112]!
	stp	d13, d12, [sp, #16]
	stp	d11, d10, [sp, #32]
	stp	d9, d8, [sp, #48]
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	stp	x22, x21, [sp, #80]
	stp	x20, x19, [sp, #96]
	sub	sp, sp, #720
	.cfi_def_cfa w29, 48
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w30, -40
	.cfi_offset w29, -48
	.cfi_offset b8, -56
	.cfi_offset b9, -64
	.cfi_offset b10, -72
	.cfi_offset b11, -80
	.cfi_offset b12, -88
	.cfi_offset b13, -96
	.cfi_offset b14, -104
	.cfi_offset b15, -112
.Ltmp10:
	.loc	1 13 8 prologue_end
	ldr	x10, [x1, #32]
	mov	w8, #4096
	.loc	1 20 8
	ldr	w14, [x2]
	mov	w13, #52429
	mov	x9, xzr
	movk	w8, #3, lsl #16
	movk	w13, #15948, lsl #16
	adrp	x15, __constant_32xf32
	add	x15, x15, :lo12:__constant_32xf32
	.loc	1 13 8
	ldp	x11, x12, [x10]
	.loc	1 15 8
	ldr	x10, [x10, #16]
	.loc	1 20 8
	add	x11, x11, x14, lsl #8
	add	x12, x12, #48
	add	x11, x11, #32
	lsl	x14, x14, #6
	.loc	1 0 8 is_stmt 0
.Ltmp11:
	.p2align	4, , 8
.LBB0_1:
	.loc	1 26 8 is_stmt 1
	add	x17, x15, x9, lsl #2
	mov	x16, xzr
	mov	x7, x11
	ldp	q0, q1, [x17]
	madd	x17, x9, x8, x10
	add	x0, x17, #49, lsl #12
	add	x1, x17, #98, lsl #12
	dup	v3.4s, v0.s[0]
	add	x2, x17, #147, lsl #12
	dup	v2.4s, v0.s[1]
	add	x3, x17, #196, lsl #12
	add	x4, x17, #245, lsl #12
	add	x5, x17, #294, lsl #12
	add	x6, x17, #343, lsl #12
	stp	q2, q3, [sp, #96]
	dup	v2.4s, v0.s[2]
	dup	v0.4s, v0.s[3]
	stp	q0, q2, [sp, #64]
	dup	v2.4s, v1.s[0]
	dup	v0.4s, v1.s[1]
	stp	q0, q2, [sp, #32]
	dup	v2.4s, v1.s[2]
	dup	v0.4s, v1.s[3]
	stp	q0, q2, [sp]
	.loc	1 0 8 is_stmt 0
.Ltmp12:
	.p2align	4, , 8
.LBB0_2:
	movi	v0.2d, #0000000000000000
	mov	x20, xzr
	movi	v23.2d, #0000000000000000
	mov	x19, x12
	movi	v15.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	stp	q0, q0, [x29, #-208]
	movi	v31.2d, #0000000000000000
	stp	q0, q0, [x29, #-112]
	movi	v25.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v12.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	stp	q0, q2, [x29, #-144]
	movi	v21.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v14.2d, #0000000000000000
	stp	q0, q16, [x29, #-176]
	stur	q16, [x29, #-80]
	.p2align	4, , 8
.LBB0_3:
	str	q15, [sp, #416]
	.loc	1 23 10 is_stmt 1
	zip1	v13.4s, v23.4s, v4.4s
	.loc	1 20 8
	ldur	s17, [x19, #-24]
	.loc	1 23 10
	trn2	v19.4s, v23.4s, v4.4s
	.loc	1 20 8
	ldur	s15, [x19, #-12]
	mov	x21, x20
	ldr	s18, [x19]
	add	x20, x7, x20
	ldr	s30, [x19, #24]
	.loc	1 23 10
	add	x22, x7, x21
	.loc	1 20 8
	ldr	s29, [x19, #36]
	cmp	x21, #98, lsl #12
	.loc	1 23 10
	mov	v17.d[1], v15.d[0]
	.loc	1 20 8
	ldr	s15, [x19, #12]
	ldur	s16, [x19, #-48]
	.loc	1 23 10
	mov	v13.s[2], v1.s[0]
	.loc	1 20 8
	ldur	s9, [x19, #-36]
	.loc	1 23 10
	mov	v19.s[2], v1.s[1]
	mov	v30.d[1], v29.d[0]
	.loc	1 20 8
	add	x19, x19, #4
	.loc	1 23 10
	mov	v18.d[1], v15.d[0]
	zip2	v15.4s, v23.4s, v4.4s
	mov	v16.d[1], v9.d[0]
	uzp2	v9.4s, v23.4s, v4.4s
	uzp1	v4.4s, v18.4s, v30.4s
	mov	v15.s[2], v1.s[2]
	uzp1	v29.4s, v16.4s, v17.4s
	zip1	v17.4s, v5.4s, v3.4s
	dup	v16.4s, v5.s[2]
	uzp2	v23.4s, v9.4s, v23.4s
	stur	q4, [x29, #-224]
	dup	v4.4s, v5.s[1]
	dup	v5.4s, v5.s[3]
	mov	v17.s[2], v6.s[0]
	mov	v16.s[1], v3.s[2]
	mov	v23.s[2], v1.s[3]
	mov	v4.s[1], v3.s[1]
	mov	v5.s[1], v3.s[3]
	ldp	q1, q3, [x29, #-176]
	mov	v13.s[3], v1.s[0]
	mov	v19.s[3], v1.s[1]
	mov	v15.s[3], v1.s[2]
	mov	v4.s[2], v6.s[1]
	mov	v5.s[2], v6.s[3]
	mov	v23.s[3], v1.s[3]
	mov	v16.s[2], v6.s[2]
	mov	v17.s[3], v3.s[0]
	stp	q13, q15, [sp, #352]
	dup	v13.4s, v0.s[1]
	mov	v4.s[3], v3.s[1]
	ldr	q20, [sp, #352]
	mov	v5.s[3], v3.s[3]
	stur	q23, [x29, #-176]
	mov	v16.s[3], v3.s[2]
	str	q17, [sp, #512]
	zip1	v17.4s, v7.4s, v2.4s
	mov	v13.s[1], v12.s[1]
	stp	q4, q16, [x29, #-256]
	ldur	q4, [x29, #-192]
	stur	q5, [x29, #-160]
	dup	v16.4s, v7.s[1]
	mov	v17.s[2], v11.s[0]
	uzp2	v1.4s, v4.4s, v10.4s
	zip1	v30.4s, v4.4s, v10.4s
	trn2	v6.4s, v4.4s, v10.4s
	zip2	v5.4s, v4.4s, v10.4s
	mov	v16.s[1], v2.s[1]
	mov	v17.s[3], v22.s[0]
	uzp2	v3.4s, v1.4s, v4.4s
	dup	v4.4s, v7.s[2]
	dup	v1.4s, v7.s[3]
	mov	v13.s[2], v8.s[1]
	mov	v16.s[2], v11.s[1]
	mov	v30.s[2], v31.s[0]
	mov	v6.s[2], v31.s[1]
	mov	v4.s[1], v2.s[2]
	mov	v1.s[1], v2.s[3]
	ldur	q2, [x29, #-144]
	mov	v5.s[2], v31.s[2]
	mov	v16.s[3], v22.s[1]
	mov	v30.s[3], v28.s[0]
	mov	v6.s[3], v28.s[1]
	mov	v4.s[2], v11.s[2]
	mov	v1.s[2], v11.s[3]
	zip1	v11.4s, v2.4s, v27.4s
	stp	q17, q16, [sp, #432]
	mov	v3.s[2], v31.s[3]
	ldur	q17, [x29, #-208]
	mov	v5.s[3], v28.s[2]
	mov	v13.s[3], v14.s[1]
	mov	v7.16b, v4.16b
	mov	v4.16b, v1.16b
	uzp2	v1.4s, v2.4s, v27.4s
	mov	v11.s[2], v25.s[0]
	mov	v3.s[3], v28.s[3]
	mov	v7.s[3], v22.s[2]
	mov	v4.s[3], v22.s[3]
	trn2	v22.4s, v2.4s, v27.4s
	mov	v11.s[3], v24.s[0]
	stp	q7, q4, [sp, #480]
	zip2	v7.4s, v2.4s, v27.4s
	uzp2	v2.4s, v1.4s, v2.4s
	ldur	s27, [x20, #-8]
	dup	v1.4s, v0.s[2]
	zip1	v4.4s, v0.4s, v12.4s
	dup	v0.4s, v0.s[3]
	mov	v22.s[2], v25.s[1]
	fmla	v5.4s, v29.4s, v27.s[0]
	mov	v7.s[2], v25.s[2]
	mov	v2.s[2], v25.s[3]
	mov	v1.s[1], v12.s[2]
	mov	v4.s[2], v8.s[0]
	mov	v0.s[1], v12.s[3]
	mov	v22.s[3], v24.s[1]
	mov	v7.s[3], v24.s[2]
	mov	v2.s[3], v24.s[3]
	ldr	q24, [sp, #368]
	mov	v1.s[2], v8.s[2]
	mov	v4.s[3], v14.s[0]
	mov	v0.s[2], v8.s[3]
	mov	v16.16b, v1.16b
	str	q4, [sp, #464]
	ldr	q4, [sp, #416]
	mov	v0.s[3], v14.s[3]
	uzp2	v1.4s, v4.4s, v17.4s
	mov	v16.s[3], v14.s[2]
	zip1	v15.4s, v4.4s, v17.4s
	zip2	v12.4s, v4.4s, v17.4s
	uzp2	v8.4s, v1.4s, v4.4s
	stp	q16, q0, [sp, #384]
	trn2	v0.4s, v4.4s, v17.4s
	ldp	q4, q1, [x29, #-128]
	mov	v15.s[2], v1.s[0]
	zip1	v18.4s, v4.4s, v26.4s
	dup	v9.4s, v4.s[1]
	dup	v16.4s, v4.s[2]
	dup	v17.4s, v4.s[3]
	mov	v0.s[2], v1.s[1]
	mov	v12.s[2], v1.s[2]
	mov	v8.s[2], v1.s[3]
	ldp	s1, s4, [x20, #-32]
	mov	v9.s[1], v26.s[1]
	mov	v16.s[1], v26.s[2]
	mov	v17.s[1], v26.s[3]
	fmla	v20.4s, v29.4s, v1.s[0]
	stur	q4, [x29, #-144]
	fmla	v19.4s, v29.4s, v4.s[0]
	stur	q1, [x29, #-112]
	ldp	s4, s25, [x20, #-24]
	mov	v18.s[2], v21.s[0]
	ldur	q1, [x29, #-96]
	mov	v9.s[2], v21.s[1]
	ldp	s23, s26, [x20, #-16]
	fmla	v24.4s, v29.4s, v4.s[0]
	mov	v16.s[2], v21.s[2]
	mov	v17.s[2], v21.s[3]
	stur	q4, [x29, #-128]
	mov	v15.s[3], v1.s[0]
	str	q25, [sp, #416]
	mov	v0.s[3], v1.s[1]
	fmla	v30.4s, v29.4s, v23.s[0]
	mov	v12.s[3], v1.s[2]
	mov	v21.16b, v19.16b
	fmla	v6.4s, v29.4s, v26.s[0]
	uzp2	v19.4s, v20.4s, v19.4s
	mov	v8.s[3], v1.s[3]
	ldur	q1, [x29, #-80]
	stp	q23, q27, [x29, #-96]
	mov	v18.s[3], v1.s[0]
	mov	v9.s[3], v1.s[1]
	mov	v16.s[3], v1.s[2]
	mov	v17.s[3], v1.s[3]
	uzp2	v1.4s, v19.4s, v20.4s
	ldur	q19, [x29, #-176]
	zip1	v23.4s, v20.4s, v21.4s
	trn2	v4.4s, v20.4s, v21.4s
	zip2	v21.4s, v20.4s, v21.4s
	mov	v20.16b, v24.16b
	fmla	v19.4s, v29.4s, v25.s[0]
	dup	v10.4s, v30.s[1]
	dup	v31.4s, v30.s[2]
	dup	v28.4s, v30.s[3]
	mov	v23.s[2], v24.s[0]
	mov	v4.s[2], v24.s[1]
	ldur	s24, [x20, #-4]
	mov	v1.s[2], v20.s[3]
	mov	v21.s[2], v20.s[2]
	zip1	v20.4s, v30.4s, v6.4s
	str	q24, [sp, #352]
	mov	v10.s[1], v6.s[1]
	mov	v31.s[1], v6.s[2]
	fmla	v3.4s, v29.4s, v24.s[0]
	ld1r	{ v25.4s }, [x22], #4
	mov	v28.s[1], v6.s[3]
	ldr	s6, [x22]
	mov	v1.s[3], v19.s[3]
	ldur	q14, [x29, #-224]
	mov	v20.s[2], v5.s[0]
	fmla	v11.4s, v25.4s, v29.4s
	mov	v10.s[2], v5.s[1]
	fmla	v22.4s, v29.4s, v6.s[0]
	mov	v31.s[2], v5.s[2]
	mov	v23.s[3], v19.s[0]
	str	q25, [sp, #336]
	mov	v28.s[2], v5.s[3]
	str	q6, [sp, #368]
	ldp	s30, s5, [x20, #16]
	mov	v4.s[3], v19.s[1]
	mov	v21.s[3], v19.s[2]
	stur	q1, [x29, #-176]
	ldp	s1, s19, [x20, #8]
	fmla	v15.4s, v29.4s, v30.s[0]
	mov	v20.s[3], v3.s[0]
	fmla	v0.4s, v29.4s, v5.s[0]
	stp	q5, q1, [sp, #304]
	dup	v27.4s, v11.s[1]
	fmla	v7.4s, v29.4s, v1.s[0]
	dup	v25.4s, v11.s[2]
	dup	v24.4s, v11.s[3]
	fmla	v2.4s, v29.4s, v19.s[0]
	zip1	v6.4s, v11.4s, v22.4s
	stur	q20, [x29, #-192]
	mov	v10.s[3], v3.s[1]
	ldp	s11, s20, [x20, #24]
	mov	v31.s[3], v3.s[2]
	.loc	1 20 8
	add	x20, x21, x8
	.loc	1 23 10
	mov	v28.s[3], v3.s[3]
	mov	v27.s[1], v22.s[1]
	dup	v1.4s, v15.s[1]
	fmla	v12.4s, v29.4s, v11.s[0]
	dup	v5.4s, v15.s[2]
	fmla	v8.4s, v29.4s, v20.s[0]
	dup	v3.4s, v15.s[3]
	stp	q20, q19, [sp, #272]
	mov	v25.s[1], v22.s[2]
	ldur	q19, [x29, #-144]
	mov	v24.s[1], v22.s[3]
	mov	v6.s[2], v7.s[0]
	ldur	q20, [x29, #-80]
	zip1	v15.4s, v15.4s, v0.4s
	str	q11, [sp, #256]
	mov	v1.s[1], v0.s[1]
	mov	v5.s[1], v0.s[2]
	mov	v3.s[1], v0.s[3]
	ldur	q0, [x29, #-112]
	mov	v27.s[2], v7.s[1]
	mov	v25.s[2], v7.s[2]
	mov	v24.s[2], v7.s[3]
	ldr	q7, [sp, #512]
	mov	v6.s[3], v2.s[0]
	mov	v5.s[2], v12.s[2]
	mov	v3.s[2], v12.s[3]
	fmla	v7.4s, v14.4s, v0.s[0]
	ldur	q0, [x29, #-256]
	mov	v15.s[2], v12.s[0]
	mov	v1.s[2], v12.s[1]
	ldp	q29, q12, [sp, #432]
	stur	q6, [x29, #-144]
	mov	v27.s[3], v2.s[1]
	fmla	v0.4s, v14.4s, v19.s[0]
	ldur	q6, [x29, #-96]
	mov	v5.s[3], v8.s[2]
	mov	v3.s[3], v8.s[3]
	fmla	v12.4s, v14.4s, v26.s[0]
	mov	v25.s[3], v2.s[2]
	fmla	v29.4s, v14.4s, v6.s[0]
	mov	v24.s[3], v2.s[3]
	mov	v15.s[3], v8.s[0]
	ldur	q2, [x29, #-128]
	mov	v1.s[3], v8.s[1]
	ldur	q8, [x29, #-240]
	mov	v19.16b, v14.16b
	stp	q5, q3, [x29, #-112]
	zip1	v5.4s, v7.4s, v0.4s
	fmla	v8.4s, v14.4s, v2.s[0]
	mov	v6.16b, v0.16b
	ldr	q14, [sp, #480]
	uzp2	v0.4s, v7.4s, v0.4s
	stur	q1, [x29, #-208]
	mov	v1.16b, v21.16b
	fmla	v18.4s, v19.4s, v30.s[0]
	dup	v2.4s, v29.s[1]
	dup	v11.4s, v29.s[2]
	fmla	v14.4s, v19.4s, v20.s[0]
	dup	v22.4s, v29.s[3]
	ldr	q20, [sp, #416]
	trn2	v3.4s, v7.4s, v6.4s
	zip2	v6.4s, v7.4s, v6.4s
	uzp2	v0.4s, v0.4s, v7.4s
	zip1	v7.4s, v29.4s, v12.4s
	ldur	q29, [x29, #-160]
	mov	v2.s[1], v12.s[1]
	mov	v11.s[1], v12.s[2]
	mov	v22.s[1], v12.s[3]
	ldr	q12, [sp, #496]
	fmla	v29.4s, v19.4s, v20.s[0]
	mov	v5.s[2], v8.s[0]
	ldp	q26, q20, [sp, #336]
	mov	v0.s[2], v8.s[3]
	mov	v7.s[2], v14.s[0]
	mov	v11.s[2], v14.s[2]
	fmla	v12.4s, v19.4s, v20.s[0]
	ldr	q20, [sp, #464]
	mov	v22.s[2], v14.s[3]
	mov	v2.s[2], v14.s[1]
	mov	v3.s[2], v8.s[1]
	fmla	v20.4s, v26.4s, v19.4s
	ldr	q26, [sp, #368]
	mov	v0.s[3], v29.s[3]
	mov	v6.s[2], v8.s[2]
	mov	v5.s[3], v29.s[0]
	fmla	v13.4s, v19.4s, v26.s[0]
	ldp	q21, q26, [sp, #304]
	mov	v7.s[3], v12.s[0]
	stur	q0, [x29, #-160]
	mov	v0.16b, v12.16b
	mov	v2.s[3], v12.s[1]
	fmla	v9.4s, v19.4s, v21.s[0]
	mov	v3.s[3], v29.s[1]
	dup	v12.4s, v20.s[1]
	dup	v8.4s, v20.s[2]
	dup	v14.4s, v20.s[3]
	mov	v11.s[3], v0.s[2]
	mov	v21.16b, v13.16b
	mov	v22.s[3], v0.s[3]
	ldr	q0, [sp, #384]
	zip1	v13.4s, v20.4s, v13.4s
	ldr	q20, [sp, #256]
	mov	v6.s[3], v29.s[2]
	dup	v29.4s, v18.s[3]
	fmla	v0.4s, v19.4s, v26.s[0]
	dup	v26.4s, v18.s[1]
	mov	v30.16b, v21.16b
	fmla	v16.4s, v19.4s, v20.s[0]
	mov	v12.s[1], v21.s[1]
	ldr	q20, [sp, #288]
	dup	v21.4s, v18.s[2]
	zip1	v18.4s, v18.4s, v9.4s
	mov	v29.s[1], v9.s[3]
	mov	v26.s[1], v9.s[1]
	mov	v8.s[1], v30.s[2]
	mov	v14.s[1], v30.s[3]
	ldr	q30, [sp, #400]
	mov	v21.s[1], v9.s[2]
	mov	v13.s[2], v0.s[0]
	mov	v12.s[2], v0.s[1]
	fmla	v30.4s, v19.4s, v20.s[0]
	ldr	q20, [sp, #272]
	mov	v8.s[2], v0.s[2]
	mov	v14.s[2], v0.s[3]
	mov	v18.s[2], v16.s[0]
	fmla	v17.4s, v19.4s, v20.s[0]
	mov	v0.16b, v13.16b
	mov	v26.s[2], v16.s[1]
	mov	v21.s[2], v16.s[2]
	mov	v29.s[2], v16.s[3]
	mov	v0.s[3], v30.s[0]
	mov	v12.s[3], v30.s[1]
	mov	v8.s[3], v30.s[2]
	mov	v14.s[3], v30.s[3]
	mov	v18.s[3], v17.s[0]
	mov	v26.s[3], v17.s[1]
	mov	v21.s[3], v17.s[2]
	mov	v29.s[3], v17.s[3]
	stur	q18, [x29, #-128]
	stur	q29, [x29, #-80]
	.loc	1 20 8
	b.ne	.LBB0_3
	.loc	1 0 8 is_stmt 0
	ldp	q13, q9, [sp, #96]
	.loc	1 20 8
	add	x19, x16, x14
	ldur	q19, [x29, #-192]
	lsl	x19, x19, #2
	ldur	q29, [x29, #-144]
	add	x20, x17, x19
	add	x21, x0, x19
	.loc	1 28 10 is_stmt 1
	fadd	v16.4s, v9.4s, v23.4s
	ldr	q20, [sp, #80]
	fadd	v23.4s, v9.4s, v19.4s
	.loc	1 20 8
	cmp	x16, #48
	.loc	1 28 10
	fadd	v29.4s, v9.4s, v29.4s
	.loc	1 20 8
	add	x7, x7, #64
	.loc	1 28 10
	fadd	v9.4s, v9.4s, v15.4s
	fadd	v4.4s, v13.4s, v4.4s
	fadd	v27.4s, v13.4s, v27.4s
	.loc	1 30 10
	fcmgt	v17.4s, v16.4s, #0.0
	.loc	1 33 10
	fcmlt	v18.4s, v16.4s, #0.0
	fcmlt	v30.4s, v29.4s, #0.0
	.loc	1 28 10
	fadd	v1.4s, v20.4s, v1.4s
	.loc	1 30 10
	bic	v17.16b, v16.16b, v17.16b
	.loc	1 33 10
	bic	v16.16b, v16.16b, v18.16b
	.loc	1 30 10
	fcmgt	v18.4s, v29.4s, #0.0
	stur	q17, [x29, #-144]
	.loc	1 33 10
	fcmlt	v17.4s, v23.4s, #0.0
	stur	q16, [x29, #-192]
	.loc	1 30 10
	fcmgt	v16.4s, v23.4s, #0.0
	bic	v15.16b, v23.16b, v16.16b
	.loc	1 33 10
	bic	v16.16b, v23.16b, v17.16b
	.loc	1 30 10
	bic	v17.16b, v29.16b, v18.16b
	fcmgt	v18.4s, v4.4s, #0.0
	.loc	1 33 10
	fcmlt	v23.4s, v4.4s, #0.0
	stur	q16, [x29, #-256]
	bic	v16.16b, v29.16b, v30.16b
	.loc	1 28 10
	fadd	v29.4s, v13.4s, v10.4s
	stp	q16, q17, [sp, #496]
	.loc	1 30 10
	fcmgt	v16.4s, v9.4s, #0.0
	.loc	1 33 10
	fcmlt	v17.4s, v9.4s, #0.0
	.loc	1 30 10
	bic	v19.16b, v9.16b, v16.16b
	.loc	1 33 10
	bic	v16.16b, v9.16b, v17.16b
	.loc	1 30 10
	fcmgt	v17.4s, v27.4s, #0.0
	stp	q16, q19, [sp, #384]
	bic	v16.16b, v4.16b, v18.16b
	.loc	1 33 10
	bic	v4.16b, v4.16b, v23.16b
	ldur	q19, [x29, #-208]
	fcmlt	v18.4s, v27.4s, #0.0
	.loc	1 28 10
	fadd	v23.4s, v13.4s, v19.4s
	ldur	q19, [x29, #-176]
	stp	q4, q16, [x29, #-240]
	.loc	1 30 10
	fcmgt	v4.4s, v29.4s, #0.0
	.loc	1 33 10
	fcmlt	v16.4s, v29.4s, #0.0
	.loc	1 30 10
	bic	v4.16b, v29.16b, v4.16b
	str	q4, [sp, #464]
	.loc	1 33 10
	bic	v4.16b, v29.16b, v16.16b
	.loc	1 28 10
	fadd	v29.4s, v20.4s, v31.4s
	.loc	1 33 10
	fcmlt	v16.4s, v23.4s, #0.0
	.loc	1 28 10
	fadd	v31.4s, v20.4s, v25.4s
	str	q4, [sp, #448]
	.loc	1 30 10
	bic	v4.16b, v27.16b, v17.16b
	fcmgt	v17.4s, v1.4s, #0.0
	.loc	1 33 10
	bic	v25.16b, v23.16b, v16.16b
	.loc	1 30 10
	fcmgt	v16.4s, v31.4s, #0.0
	str	q4, [sp, #432]
	.loc	1 33 10
	bic	v4.16b, v27.16b, v18.16b
	fcmlt	v27.4s, v1.4s, #0.0
	ldur	q18, [x29, #-112]
	str	q4, [sp, #416]
	.loc	1 30 10
	fcmgt	v4.4s, v23.4s, #0.0
	bic	v4.16b, v23.16b, v4.16b
	.loc	1 28 10
	fadd	v23.4s, v20.4s, v18.4s
	ldr	q18, [sp, #64]
	ldur	q20, [x29, #-96]
	stur	q14, [x29, #-96]
	fadd	v9.4s, v18.4s, v19.4s
	str	q4, [sp, #304]
	.loc	1 30 10
	bic	v4.16b, v1.16b, v17.16b
	.loc	1 33 10
	bic	v1.16b, v1.16b, v27.16b
	fcmlt	v17.4s, v31.4s, #0.0
	.loc	1 28 10
	fadd	v10.4s, v18.4s, v24.4s
	stur	q4, [x29, #-208]
	.loc	1 33 10
	fcmlt	v4.4s, v29.4s, #0.0
	str	q1, [sp, #480]
	.loc	1 30 10
	fcmgt	v1.4s, v29.4s, #0.0
	bic	v1.16b, v29.16b, v1.16b
	stur	q1, [x29, #-176]
	.loc	1 33 10
	bic	v1.16b, v29.16b, v4.16b
	.loc	1 30 10
	bic	v4.16b, v31.16b, v16.16b
	fcmgt	v16.4s, v9.4s, #0.0
	str	q1, [sp, #368]
	.loc	1 33 10
	bic	v1.16b, v31.16b, v17.16b
	.loc	1 28 10
	fadd	v17.4s, v18.4s, v28.4s
	.loc	1 33 10
	fcmlt	v28.4s, v9.4s, #0.0
	stp	q1, q4, [sp, #320]
	.loc	1 30 10
	fcmgt	v1.4s, v23.4s, #0.0
	.loc	1 33 10
	fcmlt	v4.4s, v23.4s, #0.0
	.loc	1 30 10
	bic	v1.16b, v23.16b, v1.16b
	.loc	1 33 10
	bic	v27.16b, v23.16b, v4.16b
	fcmlt	v4.4s, v17.4s, #0.0
	fcmlt	v23.4s, v10.4s, #0.0
	str	q1, [sp, #208]
	.loc	1 30 10
	bic	v1.16b, v9.16b, v16.16b
	.loc	1 33 10
	bic	v16.16b, v9.16b, v28.16b
	.loc	1 28 10
	fadd	v9.4s, v18.4s, v20.4s
	ldr	q18, [sp, #48]
	.loc	1 33 10
	bic	v13.16b, v10.16b, v23.16b
	stur	q1, [x29, #-112]
	.loc	1 30 10
	fcmgt	v1.4s, v17.4s, #0.0
	str	q16, [sp, #352]
	fcmgt	v16.4s, v10.4s, #0.0
	.loc	1 28 10
	fadd	v23.4s, v18.4s, v7.4s
	fadd	v0.4s, v18.4s, v0.4s
	.loc	1 30 10
	bic	v1.16b, v17.16b, v1.16b
	str	q1, [sp, #288]
	.loc	1 33 10
	bic	v1.16b, v17.16b, v4.16b
	.loc	1 30 10
	fcmgt	v4.4s, v9.4s, #0.0
	.loc	1 33 10
	fcmlt	v17.4s, v9.4s, #0.0
	str	q1, [sp, #256]
	.loc	1 28 10
	fadd	v1.4s, v18.4s, v5.4s
	.loc	1 30 10
	bic	v5.16b, v10.16b, v16.16b
	bic	v29.16b, v9.16b, v4.16b
	.loc	1 33 10
	bic	v31.16b, v9.16b, v17.16b
	.loc	1 30 10
	fcmgt	v17.4s, v23.4s, #0.0
	.loc	1 33 10
	fcmlt	v9.4s, v23.4s, #0.0
	.loc	1 30 10
	fcmgt	v7.4s, v1.4s, #0.0
	.loc	1 33 10
	fcmlt	v10.4s, v1.4s, #0.0
	bic	v30.16b, v23.16b, v9.16b
	.loc	1 30 10
	bic	v4.16b, v1.16b, v7.16b
	.loc	1 33 10
	bic	v1.16b, v1.16b, v10.16b
	str	q4, [sp, #272]
	ldur	q4, [x29, #-128]
	stp	q5, q1, [sp, #224]
	.loc	1 30 10
	fcmgt	v1.4s, v0.4s, #0.0
	ldr	q5, [sp, #32]
	.loc	1 28 10
	fadd	v10.4s, v18.4s, v4.4s
	.loc	1 30 10
	bic	v4.16b, v23.16b, v17.16b
	ldur	q17, [x29, #-144]
	.loc	1 28 10
	fadd	v23.4s, v5.4s, v3.4s
	.loc	1 30 10
	bic	v1.16b, v0.16b, v1.16b
	.loc	1 28 10
	fadd	v12.4s, v5.4s, v12.4s
	.loc	1 30 10
	fcmgt	v3.4s, v10.4s, #0.0
	str	q4, [sp, #192]
	.loc	1 33 10
	fcmlt	v4.4s, v0.4s, #0.0
	fcmlt	v14.4s, v10.4s, #0.0
	str	q1, [sp, #144]
	fcmlt	v1.4s, v23.4s, #0.0
	fcmlt	v16.4s, v12.4s, #0.0
	.loc	1 30 10
	bic	v18.16b, v10.16b, v3.16b
	.loc	1 33 10
	bic	v20.16b, v0.16b, v4.16b
	.loc	1 28 10
	fadd	v0.4s, v5.4s, v2.4s
	.loc	1 30 10
	fcmgt	v2.4s, v23.4s, #0.0
	.loc	1 33 10
	bic	v1.16b, v23.16b, v1.16b
	bic	v7.16b, v10.16b, v14.16b
	bic	v14.16b, v12.16b, v16.16b
	ldr	q16, [sp, #304]
	.loc	1 30 10
	fcmgt	v3.4s, v0.4s, #0.0
	bic	v2.16b, v23.16b, v2.16b
	ldr	q23, [sp, #256]
	.loc	1 33 10
	fcmlt	v4.4s, v0.4s, #0.0
	.loc	1 30 10
	bic	v3.16b, v0.16b, v3.16b
	stp	q1, q2, [sp, #160]
	.loc	1 28 10
	fadd	v1.4s, v5.4s, v26.4s
	.loc	1 33 10
	bic	v19.16b, v0.16b, v4.16b
	ldur	q26, [x29, #-256]
	.loc	1 31 10
	dup	v2.4s, w13
	ldp	q28, q5, [sp, #496]
	str	q3, [sp, #128]
	.loc	1 30 10
	fcmgt	v3.4s, v12.4s, #0.0
	fcmgt	v0.4s, v1.4s, #0.0
	ldp	q9, q4, [sp, #384]
	.loc	1 34 10
	fmla	v26.4s, v15.4s, v2.4s
	fmla	v25.4s, v16.4s, v2.4s
	fmla	v28.4s, v5.4s, v2.4s
	ldr	q5, [sp, #16]
	.loc	1 30 10
	bic	v15.16b, v12.16b, v3.16b
	ldur	q3, [x29, #-192]
	bic	v0.16b, v1.16b, v0.16b
	.loc	1 34 10
	fmla	v7.4s, v18.4s, v2.4s
	ldp	q10, q16, [sp, #416]
	.loc	1 28 10
	fadd	v8.4s, v5.4s, v8.4s
	.loc	1 34 10
	fmla	v9.4s, v4.4s, v2.4s
	fmla	v3.4s, v17.4s, v2.4s
	.loc	1 28 10
	fadd	v12.4s, v5.4s, v21.4s
	fadd	v6.4s, v5.4s, v6.4s
	.loc	1 34 10
	fmla	v31.4s, v29.4s, v2.4s
	fmla	v10.4s, v16.4s, v2.4s
	ldur	q16, [x29, #-176]
	stur	q0, [x29, #-256]
	.loc	1 33 10
	fcmlt	v4.4s, v1.4s, #0.0
	ldp	q24, q0, [sp, #448]
	.loc	1 30 10
	fcmgt	v21.4s, v8.4s, #0.0
	.loc	1 34 10
	fmla	v14.4s, v15.4s, v2.4s
	stur	q25, [x29, #-128]
	.loc	1 33 10
	fcmlt	v29.4s, v12.4s, #0.0
	ldr	q25, [sp, #368]
	.loc	1 34 10
	fmla	v24.4s, v0.4s, v2.4s
	ldp	q17, q0, [x29, #-240]
	.loc	1 33 10
	bic	v1.16b, v1.16b, v4.16b
	.loc	1 34 10
	fmla	v25.4s, v16.4s, v2.4s
	ldr	q16, [sp, #480]
	.loc	1 33 10
	fcmlt	v4.4s, v8.4s, #0.0
	stur	q31, [x29, #-176]
	.loc	1 34 10
	fmla	v17.4s, v0.4s, v2.4s
	ldr	q0, [sp, #208]
	.loc	1 20 8
	stp	q3, q26, [x20]
	stp	q28, q9, [x20, #32]
	add	x20, x1, x19
	.loc	1 34 10
	fmla	v27.4s, v0.4s, v2.4s
	.loc	1 33 10
	bic	v31.16b, v8.16b, v4.16b
	ldr	q4, [sp, #352]
	.loc	1 20 8
	stp	q17, q24, [x21]
	ldur	q17, [x29, #-128]
	stur	q27, [x29, #-144]
	ldp	q27, q0, [sp, #320]
	stp	q10, q17, [x21, #32]
	add	x21, x2, x19
	.loc	1 34 10
	fmla	v27.4s, v0.4s, v2.4s
	.loc	1 28 10
	fadd	v0.4s, v5.4s, v11.4s
	ldur	q5, [x29, #-208]
	.loc	1 30 10
	fcmgt	v11.4s, v12.4s, #0.0
	.loc	1 34 10
	fmla	v16.4s, v5.4s, v2.4s
	ldr	q5, [sp, #224]
	.loc	1 33 10
	fcmlt	v18.4s, v0.4s, #0.0
	.loc	1 34 10
	fmla	v13.4s, v5.4s, v2.4s
	.loc	1 30 10
	bic	v5.16b, v8.16b, v21.16b
	ldr	q21, [sp, #288]
	bic	v8.16b, v12.16b, v11.16b
	.loc	1 33 10
	bic	v11.16b, v12.16b, v29.16b
	.loc	1 30 10
	fcmgt	v29.4s, v6.4s, #0.0
	.loc	1 33 10
	fcmlt	v12.4s, v6.4s, #0.0
	.loc	1 34 10
	fmla	v23.4s, v21.4s, v2.4s
	ldur	q21, [x29, #-112]
	stur	q7, [x29, #-112]
	fmla	v31.4s, v5.4s, v2.4s
	ldr	q7, [sp, #144]
	.loc	1 20 8
	stp	q16, q25, [x20]
	.loc	1 34 10
	fmla	v11.4s, v8.4s, v2.4s
	fmla	v4.4s, v21.4s, v2.4s
	ldr	q21, [sp, #240]
	stur	q13, [x29, #-192]
	.loc	1 30 10
	fcmgt	v13.4s, v0.4s, #0.0
	.loc	1 34 10
	fmla	v20.4s, v7.4s, v2.4s
	ldr	q7, [sp, #192]
	.loc	1 30 10
	bic	v29.16b, v6.16b, v29.16b
	ldur	q16, [x29, #-144]
	.loc	1 34 10
	fmla	v30.4s, v7.4s, v2.4s
	ldr	q7, [sp, #272]
	.loc	1 20 8
	stp	q27, q16, [x20, #32]
	add	x20, x3, x19
	.loc	1 34 10
	fmla	v21.4s, v7.4s, v2.4s
	ldur	q7, [x29, #-256]
	.loc	1 20 8
	stp	q4, q23, [x21]
	stp	q30, q20, [x29, #-240]
	.loc	1 30 10
	bic	v20.16b, v0.16b, v13.16b
	ldp	q3, q4, [x29, #-192]
	.loc	1 34 10
	fmla	v1.4s, v7.4s, v2.4s
	ldr	q30, [sp]
	.loc	1 20 8
	stp	q3, q4, [x21, #32]
	.loc	1 28 10
	fadd	v5.4s, v30.4s, v22.4s
	.loc	1 20 8
	add	x21, x4, x19
	stur	q1, [x29, #-208]
	ldr	q1, [sp, #128]
	ldur	q4, [x29, #-240]
	.loc	1 34 10
	fmla	v19.4s, v1.4s, v2.4s
	.loc	1 33 10
	bic	v1.16b, v0.16b, v18.16b
	ldp	q13, q0, [sp, #160]
	.loc	1 20 8
	stp	q21, q4, [x20]
	ldur	q4, [x29, #-112]
	.loc	1 34 10
	fmla	v13.4s, v0.4s, v2.4s
	ldur	q0, [x29, #-160]
	fmla	v1.4s, v20.4s, v2.4s
	.loc	1 28 10
	fadd	v18.4s, v30.4s, v0.4s
	mov	v15.16b, v19.16b
	ldp	q3, q19, [x29, #-96]
	.loc	1 33 10
	bic	v0.16b, v6.16b, v12.16b
	.loc	1 28 10
	fadd	v3.4s, v30.4s, v3.4s
	.loc	1 30 10
	fcmgt	v6.4s, v18.4s, #0.0
	.loc	1 20 8
	stp	q13, q15, [x21]
	.loc	1 33 10
	fcmlt	v7.4s, v18.4s, #0.0
	.loc	1 28 10
	fadd	v19.4s, v30.4s, v19.4s
	.loc	1 34 10
	fmla	v0.4s, v29.4s, v2.4s
	.loc	1 30 10
	fcmgt	v29.4s, v5.4s, #0.0
	.loc	1 33 10
	fcmlt	v30.4s, v5.4s, #0.0
	.loc	1 30 10
	fcmgt	v22.4s, v3.4s, #0.0
	bic	v6.16b, v18.16b, v6.16b
	.loc	1 33 10
	bic	v7.16b, v18.16b, v7.16b
	fcmlt	v18.4s, v3.4s, #0.0
	.loc	1 30 10
	fcmgt	v8.4s, v19.4s, #0.0
	.loc	1 33 10
	fcmlt	v27.4s, v19.4s, #0.0
	.loc	1 30 10
	bic	v28.16b, v5.16b, v29.16b
	.loc	1 33 10
	bic	v5.16b, v5.16b, v30.16b
	.loc	1 30 10
	bic	v22.16b, v3.16b, v22.16b
	.loc	1 34 10
	fmla	v7.4s, v6.4s, v2.4s
	.loc	1 33 10
	bic	v3.16b, v3.16b, v18.16b
	ldur	q6, [x29, #-224]
	.loc	1 30 10
	bic	v18.16b, v19.16b, v8.16b
	.loc	1 33 10
	bic	v19.16b, v19.16b, v27.16b
	.loc	1 34 10
	fmla	v5.4s, v28.4s, v2.4s
	.loc	1 20 8
	stp	q6, q4, [x20, #32]
	add	x20, x5, x19
	add	x19, x6, x19
	.loc	1 34 10
	fmla	v3.4s, v22.4s, v2.4s
	fmla	v19.4s, v18.4s, v2.4s
	ldur	q2, [x29, #-208]
	.loc	1 20 8
	stp	q0, q1, [x20]
	stp	q31, q11, [x20, #32]
	add	x20, x16, #16
	mov	x16, x20
	stp	q14, q2, [x21, #32]
	stp	q7, q5, [x19]
	stp	q3, q19, [x19, #32]
	b.lo	.LBB0_2
	add	x16, x9, #8
	cmp	x9, #24
	add	x12, x12, #96
	mov	x9, x16
	b.lo	.LBB0_1
	.loc	1 38 8
	mov	w0, wzr
	.loc	1 38 8 epilogue_begin is_stmt 0
	add	sp, sp, #720
	ldp	x20, x19, [sp, #96]
	ldp	x22, x21, [sp, #80]
	ldp	x29, x30, [sp, #64]
	ldp	d9, d8, [sp, #48]
	ldp	d11, d10, [sp, #32]
	ldp	d13, d12, [sp, #16]
	ldp	d15, d14, [sp], #112
	ret
.Ltmp13:
.Lfunc_end0:
	.size	infer_dispatch_0_matmul_like_32x50176x3_f32, .Lfunc_end0-infer_dispatch_0_matmul_like_32x50176x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_slow_memcpy,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_1_slow_memcpy,@function
infer_dispatch_1_slow_memcpy:
.Lfunc_begin1:
	.file	2 "dump" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
.Ltmp14:
	.loc	2 11 8 prologue_end
	ldr	x10, [x1, #32]
	mov	w13, #50176
	.loc	2 16 8
	ldr	w11, [x2]
	mov	w9, #50624
	mov	x8, xzr
	.loc	2 11 8
	ldp	x12, x10, [x10]
	.loc	2 16 8
	and	x14, x11, #0x3
	lsr	x11, x11, #2
	lsl	x15, x14, #8
	umull	x13, w11, w13
	sub	x14, x15, x14, lsl #5
	umaddl	x9, w11, w9, x14
	add	x10, x10, #1568, lsl #12
	add	x10, x10, #908
	orr	x11, x13, x14
	add	x9, x9, x10
	add	x10, x12, x11
	mov	w11, #7696
	movk	w11, #3, lsl #16
	.loc	2 0 8 is_stmt 0
.Ltmp15:
	.p2align	4, , 8
.LBB1_1:
	mov	x12, xzr
	mov	x13, x10
	mov	x14, x9
	.p2align	4, , 8
.LBB1_2:
	mov	x15, xzr
	mov	x16, #-4
	.p2align	4, , 8
.LBB1_3:
	.loc	2 16 8 is_stmt 1
	ldr	q0, [x13, x15]
	add	x16, x16, #4
	cmp	x16, #52
	str	q0, [x14, x15]
	add	x15, x15, #16
	b.lo	.LBB1_3
	add	x12, x12, #1
	add	x14, x14, #904
	add	x13, x13, #896
	cmp	x12, #56
	b.ne	.LBB1_2
	add	x8, x8, #1
	add	x9, x9, x11
	add	x10, x10, #49, lsl #12
	cmp	x8, #32
	b.ne	.LBB1_1
	.loc	2 20 8
	mov	w0, wzr
	.loc	2 20 8 epilogue_begin is_stmt 0
	ldp	x29, x30, [sp], #16
	ret
.Ltmp16:
.Lfunc_end1:
	.size	infer_dispatch_1_slow_memcpy, .Lfunc_end1-infer_dispatch_1_slow_memcpy
	.cfi_endproc

	.section	.text.infer_dispatch_2_conv_64x224x224x32x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_2_conv_64x224x224x32x3x3_f32,@function
infer_dispatch_2_conv_64x224x224x32x3x3_f32:
.Lfunc_begin2:
	.file	3 "dump" "configured_module_infer_dispatch_2.mlir"
	.loc	3 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp17:
	.loc	3 22 8 prologue_end
	ldr	w9, [x2]
	mov	w12, #33437
	movk	w12, #21399, lsl #16
	mov	w13, #49
	mov	w15, #52429
	mov	x14, #2684354560
	movk	w15, #15948, lsl #16
	mov	x0, #20063
	mov	w11, w9
	mov	w10, #37
	movk	x14, #18724, lsl #32
	.loc	3 15 8
	ldr	x16, [x1, #32]
	.loc	3 22 8
	umull	x12, w11, w12
	movk	x0, #52161, lsl #16
	dup	v0.4s, w15
	movk	x14, #9362, lsl #48
	lsr	x12, x12, #36
	movk	x0, #30761, lsl #32
	msub	w13, w12, w13, w9
	movk	x0, #1337, lsl #48
	umulh	x14, x9, x14
	mov	w17, #28928
	and	w15, w13, #0xff
	umulh	x0, x11, x0
	.loc	3 15 8
	ldp	x1, x2, [x16]
	.loc	3 22 8
	mul	w10, w15, w10
	mov	w15, #36864
	.loc	3 17 8
	ldr	x11, [x16, #16]
	.loc	3 22 8
	sub	w14, w14, w14, lsl #3
	lsr	w10, w10, #8
	sub	w13, w13, w10
	and	w13, w13, #0xfe
	add	w14, w9, w14
	mov	w9, #7696
	mov	x8, xzr
	add	w13, w10, w13, lsr #1
	.loc	3 17 8
	add	x16, x11, #3164, lsl #12
	.loc	3 22 8
	lsl	w11, w14, #5
	umaddl	x14, w0, w15, x2
	lsr	w0, w13, #2
	ubfiz	x13, x11, #2, #32
	umaddl	x15, w0, w17, x13
	add	x14, x14, #1027, lsl #12
	movk	w9, #3, lsl #16
	mov	w10, #904
	add	x15, x15, x1
	.loc	3 17 8
	add	x13, x16, #512
	.loc	3 22 8
	add	x14, x14, #3328
	add	x15, x15, #1568, lsl #12
	mov	x16, sp
	add	x17, sp, #64
	adrp	x1, __constant_64xf32
	add	x1, x1, :lo12:__constant_64xf32
	lsl	w12, w12, #5
	ubfiz	x0, x0, #5, #32
	.loc	3 9 8
	stp	xzr, xzr, [sp]
	.loc	3 0 8 is_stmt 0
.Ltmp18:
	.p2align	4, , 8
.LBB2_1:
	.loc	3 22 8 is_stmt 1
	orr	x3, x8, x12
	mov	x2, xzr
	.loc	3 28 8
	add	x4, x1, x3, lsl #2
	madd	x3, x3, x9, x13
	ld1r	{ v1.4s }, [x4]
	mov	x4, x15
	.loc	3 0 8 is_stmt 0
.Ltmp19:
	.p2align	4, , 8
.LBB2_2:
	add	x6, x2, x0
	mov	x5, xzr
	mov	x7, x4
	madd	x6, x6, x10, x3
	add	x6, x6, #908
	.p2align	4, , 8
.LBB2_3:
	mov	x19, xzr
	.p2align	4, , 8
.LBB2_4:
	.loc	3 22 8 is_stmt 1
	ldr	s2, [x16, x19]
	str	s2, [x17, x19]
	add	x19, x19, #4
	cmp	x19, #16
	b.ne	.LBB2_4
	.loc	3 0 8 is_stmt 0
	mov	x20, xzr
	.loc	3 22 8
	orr	x19, x5, x11
	mov	x21, x14
	mov	x22, x7
	.loc	3 0 8
.Ltmp20:
	.p2align	4, , 8
.LBB2_6:
	mov	x23, xzr
	mov	x24, x21
	mov	x25, x22
	.p2align	4, , 8
.LBB2_7:
	mov	x26, xzr
	mov	x27, x25
	.p2align	4, , 8
.LBB2_8:
	ldr	s2, [x17, x26, lsl #2]
	mov	x28, xzr
	.p2align	4, , 8
.LBB2_9:
	.loc	3 22 8 is_stmt 1
	ldr	s3, [x27, x28]
	ldr	s4, [x24, x28]
	add	x28, x28, #4
	cmp	x28, #12
	.loc	3 25 10
	fmadd	s2, s3, s4, s2
	.loc	3 22 8
	b.ne	.LBB2_9
	str	s2, [x17, x26, lsl #2]
	add	x26, x26, #1
	add	x27, x27, #4
	cmp	x26, #4
	b.ne	.LBB2_8
	add	x23, x23, #1
	add	x25, x25, #904
	add	x24, x24, #12
	cmp	x23, #3
	b.ne	.LBB2_7
	add	x20, x20, #1
	add	x22, x22, x9
	add	x21, x21, #36
	cmp	x20, #32
	b.ne	.LBB2_6
	.loc	3 28 8
	ldr	q2, [sp, #64]
	.loc	3 22 8
	add	x20, x5, #4
	cmp	x5, #28
	add	x7, x7, #16
	mov	x5, x20
	lsl	x19, x19, #2
	.loc	3 30 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	3 32 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	3 35 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	3 32 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	3 35 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	3 36 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	3 22 8
	str	q2, [x6, x19]
	b.lo	.LBB2_3
	add	x2, x2, #1
	add	x4, x4, #904
	cmp	x2, #32
	b.ne	.LBB2_2
	add	x8, x8, #1
	add	x14, x14, #1152
	cmp	x8, #32
	b.ne	.LBB2_1
	.loc	3 40 8
	mov	w0, wzr
	.loc	3 40 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp21:
.Lfunc_end2:
	.size	infer_dispatch_2_conv_64x224x224x32x3x3_f32, .Lfunc_end2-infer_dispatch_2_conv_64x224x224x32x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_3_conv_128x224x224x64x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_3_conv_128x224x224x64x3x3_f32,@function
infer_dispatch_3_conv_128x224x224x64x3x3_f32:
.Lfunc_begin3:
	.file	4 "dump" "configured_module_infer_dispatch_3.mlir"
	.loc	4 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp22:
	.loc	4 24 8 prologue_end
	ldr	w12, [x2]
	mov	w14, #33437
	movk	w14, #21399, lsl #16
	mov	x2, #20063
	mov	w15, #49
	.loc	4 15 8
	ldr	x13, [x1, #32]
	movk	x2, #52161, lsl #16
	mov	x17, #2684354560
	.loc	4 24 8
	mov	w16, w12
	movk	x2, #30761, lsl #32
	movk	x2, #1337, lsl #48
	mov	w11, #37
	umull	x14, w16, w14
	movk	x17, #18724, lsl #32
	.loc	4 18 8
	ldp	x3, x1, [x13, #8]
	.loc	4 24 8
	lsr	x14, x14, #36
	umulh	x16, x16, x2
	msub	w15, w14, w15, w12
	movk	x17, #9362, lsl #48
	mov	w10, #17920
	mov	w0, #52429
	and	w2, w15, #0xff
	movk	w10, #397, lsl #16
	umulh	x17, x12, x17
	movk	w0, #15948, lsl #16
	mul	w2, w2, w11
	.loc	4 18 8
	add	x10, x1, x10
	.loc	4 15 8
	ldr	x1, [x13]
	mov	w9, #8192
	.loc	4 24 8
	lsr	w13, w2, #8
	sub	w15, w15, w13
	and	w15, w15, #0xfe
	movk	w9, #1, lsl #16
	sub	w17, w17, w17, lsl #3
	dup	v0.4s, w0
	mov	w0, #28928
	add	w17, w12, w17
	add	w2, w13, w15, lsr #1
	.loc	4 17 8
	add	x15, x3, #1008, lsl #12
	.loc	4 24 8
	lsl	w13, w14, #5
	.loc	4 17 8
	add	x14, x15, #3456
	.loc	4 24 8
	lsl	w15, w17, #5
	umaddl	x16, w16, w9, x3
	lsr	w2, w2, #2
	ubfiz	x17, x15, #2, #32
	add	x1, x1, #3164, lsl #12
	umaddl	x17, w2, w0, x17
	add	x0, x1, #512
	add	x16, x16, #936, lsl #12
	mov	w1, #7696
	mov	x8, xzr
	mov	w11, #896
	mov	x12, sp
	add	x16, x16, #3456
	add	x17, x17, x0
	add	x0, sp, #64
	movk	w1, #3, lsl #16
	ubfiz	x2, x2, #5, #32
	.loc	4 9 8
	stp	xzr, xzr, [sp]
	.loc	4 0 8 is_stmt 0
.Ltmp23:
	.p2align	4, , 8
.LBB3_1:
	.loc	4 24 8 is_stmt 1
	orr	x4, x8, x13
	add	x6, x9, #31, lsl #12
	mov	x3, xzr
	.loc	4 30 8
	add	x5, x14, x4, lsl #2
	madd	x4, x4, x6, x10
	ld1r	{ v1.4s }, [x5]
	mov	x5, x17
	.loc	4 0 8 is_stmt 0
.Ltmp24:
	.p2align	4, , 8
.LBB3_2:
	add	x6, x3, x2
	mov	x7, xzr
	mov	x19, x5
	madd	x6, x6, x11, x4
	.p2align	4, , 8
.LBB3_3:
	mov	x20, xzr
	.p2align	4, , 8
.LBB3_4:
	.loc	4 24 8 is_stmt 1
	ldr	s2, [x12, x20]
	str	s2, [x0, x20]
	add	x20, x20, #4
	cmp	x20, #16
	b.ne	.LBB3_4
	.loc	4 0 8 is_stmt 0
	mov	x21, xzr
	.loc	4 24 8
	orr	x20, x7, x15
	mov	x22, x16
	mov	x23, x19
	.loc	4 0 8
.Ltmp25:
	.p2align	4, , 8
.LBB3_6:
	mov	x24, xzr
	mov	x25, x22
	mov	x26, x23
	.p2align	4, , 8
.LBB3_7:
	mov	x27, xzr
	mov	x28, x26
	.p2align	4, , 8
.LBB3_8:
	ldr	s2, [x0, x27, lsl #2]
	mov	x30, xzr
	.p2align	4, , 8
.LBB3_9:
	.loc	4 24 8 is_stmt 1
	ldr	s3, [x28, x30]
	ldr	s4, [x25, x30]
	add	x30, x30, #4
	cmp	x30, #12
	.loc	4 27 10
	fmadd	s2, s3, s4, s2
	.loc	4 24 8
	b.ne	.LBB3_9
	str	s2, [x0, x27, lsl #2]
	add	x27, x27, #1
	add	x28, x28, #4
	cmp	x27, #4
	b.ne	.LBB3_8
	add	x24, x24, #1
	add	x26, x26, #904
	add	x25, x25, #12
	cmp	x24, #3
	b.ne	.LBB3_7
	add	x21, x21, #1
	add	x23, x23, x1
	add	x22, x22, #36
	cmp	x21, #64
	b.ne	.LBB3_6
	.loc	4 30 8
	ldr	q2, [sp, #64]
	.loc	4 24 8
	add	x21, x7, #4
	cmp	x7, #28
	add	x19, x19, #16
	mov	x7, x21
	lsl	x20, x20, #2
	.loc	4 32 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	4 34 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	4 37 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	4 34 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	4 37 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	4 38 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	4 24 8
	str	q2, [x6, x20]
	b.lo	.LBB3_3
	add	x3, x3, #1
	add	x5, x5, #904
	cmp	x3, #32
	b.ne	.LBB3_2
	add	x8, x8, #1
	add	x16, x16, #2304
	cmp	x8, #32
	b.ne	.LBB3_1
	.loc	4 42 8
	mov	w0, wzr
	.loc	4 42 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp26:
.Lfunc_end3:
	.size	infer_dispatch_3_conv_128x224x224x64x3x3_f32, .Lfunc_end3-infer_dispatch_3_conv_128x224x224x64x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_4_slow_memcpy,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_4_slow_memcpy,@function
infer_dispatch_4_slow_memcpy:
.Lfunc_begin4:
	.file	5 "dump" "configured_module_infer_dispatch_4.mlir"
	.loc	5 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
.Ltmp27:
	.loc	5 22 8 prologue_end
	ldr	w10, [x2]
	mov	w9, #50624
	.loc	5 9 8
	ldp	x11, x14, [x1, #24]
	mov	w12, #33792
	mov	w15, #12845056
	movk	w12, #199, lsl #16
	mov	x8, xzr
	.loc	5 22 8
	ubfx	x13, x10, #2, #2
	lsr	x16, x10, #4
	umull	x9, w13, w9
	and	x10, x10, #0x3
	ldp	w17, w11, [x11]
	umaddl	x9, w16, w12, x9
	mov	w12, #50176
	umull	x15, w16, w15
	.loc	5 17 8
	ldp	x16, x14, [x14]
	.loc	5 22 8
	umull	x12, w13, w12
	lsl	x13, x10, #8
	sub	x10, x13, x10, lsl #5
	.loc	5 20 8
	and	x11, x11, #0xfffffffc
	.loc	5 22 8
	orr	x12, x15, x12
	add	x11, x10, x11
	.loc	5 18 8
	and	x13, x17, #0xfffffffc
	.loc	5 22 8
	add	x9, x9, x11
	orr	x10, x12, x10
	add	x11, x16, x13
	add	x9, x9, x14
	add	x10, x11, x10
	mov	w11, #7696
	add	x9, x9, #908
	movk	w11, #3, lsl #16
	.loc	5 0 8 is_stmt 0
.Ltmp28:
	.p2align	4, , 8
.LBB4_1:
	mov	x12, xzr
	mov	x13, x10
	mov	x14, x9
	.p2align	4, , 8
.LBB4_2:
	mov	x15, xzr
	mov	x16, #-4
	.p2align	4, , 8
.LBB4_3:
	.loc	5 22 8 is_stmt 1
	ldr	q0, [x13, x15]
	add	x16, x16, #4
	cmp	x16, #52
	str	q0, [x14, x15]
	add	x15, x15, #16
	b.lo	.LBB4_3
	add	x12, x12, #1
	add	x14, x14, #904
	add	x13, x13, #896
	cmp	x12, #56
	b.ne	.LBB4_2
	add	x8, x8, #1
	add	x9, x9, x11
	add	x10, x10, #49, lsl #12
	cmp	x8, #64
	b.ne	.LBB4_1
	.loc	5 26 8
	mov	w0, wzr
	.loc	5 26 8 epilogue_begin is_stmt 0
	ldp	x29, x30, [sp], #16
	ret
.Ltmp29:
.Lfunc_end4:
	.size	infer_dispatch_4_slow_memcpy, .Lfunc_end4-infer_dispatch_4_slow_memcpy
	.cfi_endproc

	.section	.text.infer_dispatch_5_conv_128x224x224x128x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_5_conv_128x224x224x128x3x3_f32,@function
infer_dispatch_5_conv_128x224x224x128x3x3_f32:
.Lfunc_begin5:
	.file	6 "dump" "configured_module_infer_dispatch_5.mlir"
	.loc	6 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp30:
	.loc	6 34 8 prologue_end
	ldr	w10, [x2]
	mov	w11, #33437
	movk	w11, #21399, lsl #16
	mov	x17, #2684354560
	.loc	6 11 8
	ldp	x9, x14, [x1, #24]
	movk	x17, #18724, lsl #32
	mov	w12, #49
	.loc	6 34 8
	mov	w16, w10
	movk	x17, #9362, lsl #48
	mov	x2, #20063
	mov	w13, #37
	umull	x11, w16, w11
	movk	x2, #52161, lsl #16
	umulh	x17, x10, x17
	movk	x2, #30761, lsl #32
	lsr	x11, x11, #36
	movk	x2, #1337, lsl #48
	ldp	w15, w0, [x9]
	msub	w3, w11, w12, w10
	sub	w12, w17, w17, lsl #3
	ldp	w1, w9, [x9, #8]
	and	w17, w3, #0xff
	umulh	x16, x16, x2
	.loc	6 25 8
	ldp	x4, x5, [x14]
	.loc	6 34 8
	mul	w13, w17, w13
	.loc	6 26 8
	and	x17, x0, #0xfffffffc
	.loc	6 28 8
	ldr	x14, [x14, #16]
	and	x0, x9, #0xfffffffc
	.loc	6 34 8
	lsl	w9, w11, #5
	lsr	w13, w13, #8
	.loc	6 25 8
	and	x15, x15, #0xfffffffc
	.loc	6 34 8
	add	w12, w10, w12
	lsl	w12, w12, #5
	.loc	6 27 8
	and	x10, x1, #0xfffffffc
	.loc	6 28 8
	add	x11, x14, x0
	mov	w0, #16384
	movk	w0, #2, lsl #16
	.loc	6 34 8
	sub	w14, w3, w13
	and	w14, w14, #0xfe
	mov	x8, xzr
	umaddl	x16, w16, w0, x17
	mov	w0, #52429
	movk	w0, #15948, lsl #16
	mov	w17, #28928
	add	w13, w13, w14, lsr #1
	add	x14, x5, x16
	lsr	w2, w13, #2
	mov	w13, #7696
	umaddl	x15, w2, w17, x15
	dup	v0.4s, w0
	.loc	6 27 8
	add	x10, x5, x10
	movk	w13, #3, lsl #16
	.loc	6 34 8
	add	x16, x15, w12, uxtw #2
	mov	w15, #904
	add	x16, x4, x16
	mov	x17, sp
	add	x0, sp, #64
	mov	w1, #4608
	ubfiz	x2, x2, #5, #32
	.loc	6 10 8
	stp	xzr, xzr, [sp]
	.loc	6 0 8 is_stmt 0
.Ltmp31:
	.p2align	4, , 8
.LBB5_1:
	.loc	6 34 8 is_stmt 1
	orr	x4, x8, x9
	mov	x3, xzr
	.loc	6 40 8
	add	x5, x10, x4, lsl #2
	madd	x4, x4, x13, x11
	ld1r	{ v1.4s }, [x5]
	mov	x5, x16
	.loc	6 0 8 is_stmt 0
.Ltmp32:
	.p2align	4, , 8
.LBB5_2:
	add	x7, x3, x2
	mov	x6, xzr
	mov	x19, x5
	madd	x7, x7, x15, x4
	add	x7, x7, #908
	.p2align	4, , 8
.LBB5_3:
	mov	x20, xzr
	.p2align	4, , 8
.LBB5_4:
	.loc	6 34 8 is_stmt 1
	ldr	s2, [x17, x20]
	str	s2, [x0, x20]
	add	x20, x20, #4
	cmp	x20, #16
	b.ne	.LBB5_4
	.loc	6 0 8 is_stmt 0
	mov	x21, xzr
	.loc	6 34 8
	orr	x20, x6, x12
	mov	x22, x14
	mov	x23, x19
	.loc	6 0 8
.Ltmp33:
	.p2align	4, , 8
.LBB5_6:
	mov	x24, xzr
	mov	x25, x22
	mov	x26, x23
	.p2align	4, , 8
.LBB5_7:
	mov	x27, xzr
	mov	x28, x26
	.p2align	4, , 8
.LBB5_8:
	ldr	s2, [x0, x27, lsl #2]
	mov	x30, xzr
	.p2align	4, , 8
.LBB5_9:
	.loc	6 34 8 is_stmt 1
	ldr	s3, [x28, x30]
	ldr	s4, [x25, x30]
	add	x30, x30, #4
	cmp	x30, #12
	.loc	6 37 10
	fmadd	s2, s3, s4, s2
	.loc	6 34 8
	b.ne	.LBB5_9
	str	s2, [x0, x27, lsl #2]
	add	x27, x27, #1
	add	x28, x28, #4
	cmp	x27, #4
	b.ne	.LBB5_8
	add	x24, x24, #1
	add	x26, x26, #904
	add	x25, x25, #12
	cmp	x24, #3
	b.ne	.LBB5_7
	add	x21, x21, #1
	add	x23, x23, x13
	add	x22, x22, #36
	cmp	x21, #128
	b.ne	.LBB5_6
	.loc	6 40 8
	ldr	q2, [sp, #64]
	.loc	6 34 8
	add	x21, x6, #4
	cmp	x6, #28
	add	x19, x19, #16
	mov	x6, x21
	lsl	x20, x20, #2
	.loc	6 42 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	6 44 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	6 47 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	6 44 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	6 47 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	6 48 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	6 34 8
	str	q2, [x7, x20]
	b.lo	.LBB5_3
	add	x3, x3, #1
	add	x5, x5, #904
	cmp	x3, #32
	b.ne	.LBB5_2
	add	x8, x8, #1
	add	x14, x14, x1
	cmp	x8, #32
	b.ne	.LBB5_1
	.loc	6 52 8
	mov	w0, wzr
	.loc	6 52 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp34:
.Lfunc_end5:
	.size	infer_dispatch_5_conv_128x224x224x128x3x3_f32, .Lfunc_end5-infer_dispatch_5_conv_128x224x224x128x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_6_conv_128x224x224x128x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_6_conv_128x224x224x128x3x3_f32,@function
infer_dispatch_6_conv_128x224x224x128x3x3_f32:
.Lfunc_begin6:
	.file	7 "dump" "configured_module_infer_dispatch_6.mlir"
	.loc	7 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp35:
	.loc	7 39 8 prologue_end
	ldr	w9, [x2]
	mov	w11, #33437
	movk	w11, #21399, lsl #16
	mov	w12, #49
	.loc	7 11 8
	ldp	x10, x16, [x1, #24]
	mov	w13, #37
	mov	x3, #20063
	.loc	7 39 8
	mov	w14, w9
	movk	x3, #52161, lsl #16
	movk	x3, #30761, lsl #32
	mov	x15, #2684354560
	umull	x11, w14, w11
	movk	x3, #1337, lsl #48
	ldp	w17, w0, [x10]
	lsr	x11, x11, #36
	movk	x15, #18724, lsl #32
	msub	w12, w11, w12, w9
	movk	x15, #9362, lsl #48
	ldp	w1, w2, [x10, #8]
	and	w4, w12, #0xff
	.loc	7 30 8
	and	x0, x0, #0xfffffffc
	ldr	w10, [x10, #16]
	.loc	7 39 8
	umulh	x14, x14, x3
	mul	w13, w4, w13
	.loc	7 28 8
	and	x17, x17, #0xfffffffc
	ldp	x5, x4, [x16]
	.loc	7 39 8
	lsr	w13, w13, #8
	sub	w12, w12, w13
	.loc	7 32 8
	ldr	x16, [x16, #16]
	and	x6, x10, #0xfffffffc
	.loc	7 29 8
	and	x1, x1, #0xfffffffc
	.loc	7 39 8
	umulh	x15, x9, x15
	.loc	7 30 8
	add	x10, x5, x0
	.loc	7 39 8
	and	w0, w12, #0xfe
	.loc	7 31 8
	and	x2, x2, #0xfffffffc
	mov	x8, xzr
	.loc	7 32 8
	add	x12, x16, x6
	mov	w16, #16384
	movk	w16, #2, lsl #16
	.loc	7 39 8
	add	w13, w13, w0, lsr #1
	mov	w0, #28928
	lsr	w3, w13, #2
	umaddl	x14, w14, w16, x1
	sub	w15, w15, w15, lsl #3
	umaddl	x16, w3, w0, x17
	mov	w17, #52429
	movk	w17, #15948, lsl #16
	add	w15, w9, w15
	lsl	w13, w15, #5
	lsl	w9, w11, #5
	.loc	7 31 8
	add	x11, x4, x2
	.loc	7 39 8
	add	x15, x16, w13, uxtw #2
	dup	v0.4s, w17
	mov	w2, #7696
	add	x14, x4, x14
	add	x16, x5, x15
	mov	w17, #224
	mov	x0, sp
	add	x1, sp, #64
	movk	w2, #3, lsl #16
	ubfiz	x4, x3, #5, #32
	.loc	7 10 8
	stp	xzr, xzr, [sp]
	.loc	7 0 8 is_stmt 0
.Ltmp36:
	.p2align	4, , 8
.LBB6_1:
	.loc	7 39 8 is_stmt 1
	orr	x15, x8, x9
	mov	w6, #50176
	mov	x5, xzr
	.loc	7 45 8
	add	x3, x11, x15, lsl #2
	mul	x6, x15, x6
	mov	x15, x16
	ld1r	{ v1.4s }, [x3]
	.loc	7 0 8 is_stmt 0
.Ltmp37:
	.p2align	4, , 8
.LBB6_2:
	add	x3, x5, x4
	mov	x19, xzr
	mov	x7, x15
	madd	x20, x3, x17, x6
	.p2align	4, , 8
.LBB6_3:
	mov	x3, xzr
	.p2align	4, , 8
.LBB6_4:
	.loc	7 39 8 is_stmt 1
	ldr	s2, [x0, x3]
	str	s2, [x1, x3]
	add	x3, x3, #4
	cmp	x3, #16
	b.ne	.LBB6_4
	.loc	7 0 8 is_stmt 0
	mov	x23, xzr
	.loc	7 39 8
	orr	x22, x19, x13
	mov	x24, x14
	mov	x21, x7
	.loc	7 0 8
.Ltmp38:
	.p2align	4, , 8
.LBB6_6:
	mov	x26, xzr
	mov	x27, x24
	mov	x25, x21
	.p2align	4, , 8
.LBB6_7:
	mov	x30, xzr
	mov	x28, x25
	.p2align	4, , 8
.LBB6_8:
	ldr	s2, [x1, x30, lsl #2]
	mov	x3, xzr
	.p2align	4, , 8
.LBB6_9:
	.loc	7 39 8 is_stmt 1
	ldr	s3, [x28, x3]
	ldr	s4, [x27, x3]
	add	x3, x3, #4
	cmp	x3, #12
	.loc	7 42 10
	fmadd	s2, s3, s4, s2
	.loc	7 39 8
	b.ne	.LBB6_9
	str	s2, [x1, x30, lsl #2]
	add	x30, x30, #1
	add	x28, x28, #4
	cmp	x30, #4
	b.ne	.LBB6_8
	add	x26, x26, #1
	add	x25, x25, #904
	add	x27, x27, #12
	cmp	x26, #3
	b.ne	.LBB6_7
	add	x23, x23, #1
	add	x21, x21, x2
	add	x24, x24, #36
	cmp	x23, #128
	b.ne	.LBB6_6
	.loc	7 45 8
	ldr	q2, [sp, #64]
	add	x3, x20, x22
	lsl	x3, x3, #2
	.loc	7 39 8
	add	x21, x19, #4
	cmp	x19, #28
	add	x7, x7, #16
	mov	x19, x21
	.loc	7 47 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	7 49 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	7 52 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	7 49 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	7 52 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	7 53 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	7 45 8
	ldr	q3, [x10, x3]
	.loc	7 54 10
	fadd	v2.4s, v3.4s, v2.4s
	.loc	7 39 8
	str	q2, [x12, x3]
	b.lo	.LBB6_3
	add	x5, x5, #1
	add	x15, x15, #904
	cmp	x5, #32
	b.ne	.LBB6_2
	mov	w15, #4608
	add	x8, x8, #1
	add	x14, x14, x15
	cmp	x8, #32
	b.ne	.LBB6_1
	.loc	7 58 8
	mov	w0, wzr
	.loc	7 58 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp39:
.Lfunc_end6:
	.size	infer_dispatch_6_conv_128x224x224x128x3x3_f32, .Lfunc_end6-infer_dispatch_6_conv_128x224x224x128x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI7_0:
	.xword	2
	.xword	3
.LCPI7_1:
	.xword	0
	.xword	1
	.section	.text.infer_dispatch_13_elementwise_broadcast_128x112x112_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_13_elementwise_broadcast_128x112x112_f32,@function
infer_dispatch_13_elementwise_broadcast_128x112x112_f32:
.Lfunc_begin7:
	.file	8 "dump" "configured_module_infer_dispatch_13.mlir"
	.loc	8 1 0 is_stmt 1
	.cfi_startproc
	sub	sp, sp, #336
	stp	d13, d12, [sp, #192]
	stp	d11, d10, [sp, #208]
	stp	d9, d8, [sp, #224]
	stp	x29, x30, [sp, #240]
	stp	x28, x27, [sp, #256]
	stp	x26, x25, [sp, #272]
	stp	x24, x23, [sp, #288]
	stp	x22, x21, [sp, #304]
	stp	x20, x19, [sp, #320]
	add	x29, sp, #240
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
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
.Ltmp40:
	.loc	8 19 8 prologue_end
	ldr	w12, [x2]
	mov	w11, #456
	.loc	8 15 8
	ldr	x13, [x1, #32]
	mov	w14, #25088
	movk	w14, #25, lsl #16
	mov	w10, #56
	mov	w15, #2508
	mov	w8, #2048
	.loc	8 19 8
	sbfx	x16, x12, #1, #1
	and	x0, x16, #0x38
	tst	w12, #0x1
	movk	w15, #1281, lsl #16
	umull	x11, w0, w11
	csel	x1, x10, xzr, ne
	str	x0, [sp, #40]
	lsr	x0, x12, #2
	.loc	8 15 8
	ldp	x17, x13, [x13]
	.loc	8 19 8
	umaddl	x10, w0, w14, x11
	lsl	x11, x12, #3
	and	x11, x11, #0x7ffffffe0
	mov	w16, #1130299392
	movk	w8, #889, lsl #16
	add	x10, x10, x1, lsl #2
	fmov	s0, #0.50000000
	mov	x20, #58849
	str	x11, [sp, #8]
	add	x11, x13, x15
	.loc	8 15 8
	add	x13, x17, x8
	.loc	8 19 8
	add	x11, x10, x11
	adrp	x8, .LCPI7_0
	adrp	x10, .LCPI7_1
	fmov	s1, #-0.50000000
	mov	x17, #18725
	movi	d2, #0000000000000000
	movk	x20, #48148, lsl #16
	fmov	s3, #1.00000000
	movk	x17, #9362, lsl #16
	dup	v4.4s, w16
	ldr	q7, [x8, :lo12:.LCPI7_0]
	fmov	s5, w16
	ldr	q17, [x10, :lo12:.LCPI7_1]
	movi	v6.4s, #63, lsl #24
	movk	x20, #33436, lsl #32
	movi	v16.4s, #191, lsl #24
	movk	x17, #37449, lsl #32
	fmov	v18.4s, #1.00000000
	mov	x9, xzr
	movk	x20, #21399, lsl #48
	mov	w16, #50176
	movk	x17, #18724, lsl #48
	mov	w7, #224
	str	x1, [sp, #32]
	.loc	8 0 8 is_stmt 0
.Ltmp41:
	.p2align	4, , 8
.LBB7_1:
	ldr	x8, [sp, #8]
	mov	x12, xzr
	mov	x14, x11
	stp	x11, x9, [sp, #16]
	.loc	8 21 10 is_stmt 1
	orr	x8, x9, x8
	.loc	8 54 10
	lsl	x10, x8, #8
	sub	x8, x10, x8, lsl #5
	str	x8, [sp, #48]
	.loc	8 0 10 is_stmt 0
.Ltmp42:
	.p2align	4, , 8
.LBB7_2:
	ldp	x8, x9, [sp, #40]
	mov	x15, xzr
	stp	x12, x14, [sp, #56]
	.loc	8 22 10 is_stmt 1
	add	x8, x12, x8
	.loc	8 25 10
	ucvtf	s19, x8
	.loc	8 26 10
	fadd	s19, s19, s0
	.loc	8 27 10
	fadd	s19, s19, s19
	.loc	8 28 10
	fadd	s19, s19, s1
	.loc	8 29 10
	fcmp	s19, #0.0
	fcsel	s19, s2, s19, ls
	.loc	8 30 10
	fcmp	s19, s5
	fcsel	s20, s5, s19, ge
	.loc	8 39 10
	fadd	s19, s20, s3
	.loc	8 41 10
	fcvtms	x8, s20
	.loc	8 43 10
	fcmp	s19, s5
	.loc	8 54 10
	add	x8, x9, x8
	lsl	x11, x8, #8
	sub	x8, x11, x8, lsl #5
	.loc	8 43 10
	fcsel	s21, s5, s19, ge
	.loc	8 40 10
	frintm	s19, s19
	.loc	8 44 10
	fcvtzs	x10, s21
	.loc	8 38 10
	frintm	s21, s20
	.loc	8 58 10
	fsub	s19, s19, s20
	.loc	8 56 10
	add	x10, x9, x10
	ldr	x9, [sp, #32]
	lsl	x11, x10, #8
	.loc	8 59 10
	fsub	s20, s20, s21
	.loc	8 56 10
	sub	x10, x11, x10, lsl #5
	dup	v21.2d, x8
	mov	x8, #-4
	dup	v22.2d, x10
	.loc	8 0 10 is_stmt 0
.Ltmp43:
	.p2align	4, , 8
.LBB7_3:
	.loc	8 19 8 is_stmt 1
	dup	v23.2d, x9
	stp	x9, x8, [x29, #-80]
	stur	x15, [x29, #-64]
	mov	x0, x20
	mov	w1, #224
	.loc	8 23 10
	orr	v24.16b, v23.16b, v17.16b
	orr	v23.16b, v23.16b, v7.16b
	.loc	8 32 10
	mov	x8, v24.d[1]
	fmov	x10, d24
	ucvtf	s25, x8
	ucvtf	s24, x10
	fmov	x8, d23
	mov	x10, v23.d[1]
	mov	v24.s[1], v25.s[0]
	ucvtf	s23, x8
	ucvtf	s25, x10
	mov	v24.s[2], v23.s[0]
	mov	v24.s[3], v25.s[0]
	.loc	8 33 10
	fadd	v23.4s, v24.4s, v6.4s
	.loc	8 34 10
	fadd	v23.4s, v23.4s, v23.4s
	.loc	8 35 10
	fadd	v23.4s, v23.4s, v16.4s
	.loc	8 36 10
	fcmle	v24.4s, v23.4s, #0.0
	bic	v23.16b, v23.16b, v24.16b
	.loc	8 37 10
	fcmge	v24.4s, v23.4s, v4.4s
	bit	v23.16b, v4.16b, v24.16b
	.loc	8 47 10
	fadd	v25.4s, v23.4s, v18.4s
	.loc	8 46 10
	frintm	v24.4s, v23.4s
	.loc	8 51 10
	fcmge	v26.4s, v25.4s, v4.4s
	.loc	8 49 10
	fcvtl	v27.2d, v24.2s
	fcvtl2	v28.2d, v24.4s
	.loc	8 61 10
	fsub	v24.4s, v23.4s, v24.4s
	.loc	8 51 10
	mov	v29.16b, v26.16b
	.loc	8 49 10
	fcvtzs	v26.2d, v27.2d
	fcvtzs	v27.2d, v28.2d
	.loc	8 51 10
	bsl	v29.16b, v4.16b, v25.16b
	.loc	8 54 10
	add	v8.2d, v21.2d, v26.2d
	add	v30.2d, v21.2d, v27.2d
	.loc	8 56 10
	add	v26.2d, v22.2d, v26.2d
	add	v27.2d, v22.2d, v27.2d
	.loc	8 48 10
	frintm	v25.4s, v25.4s
	.loc	8 52 10
	fcvtl	v28.2d, v29.2s
	.loc	8 54 10
	fmov	x12, d8
	fmov	x10, d30
	mov	x11, v8.d[1]
	.loc	8 56 10
	fmov	x3, d26
	.loc	8 54 10
	mov	x8, v30.d[1]
	.loc	8 52 10
	fcvtzs	v31.2d, v28.2d
	.loc	8 54 10
	smulh	x14, x12, x20
	.loc	8 52 10
	fcvtl2	v29.2d, v29.4s
	.loc	8 54 10
	smulh	x2, x12, x17
	cmp	x12, #0
	smulh	x6, x10, x17
	asr	x23, x14, #14
	add	x15, x23, x14, lsr #63
	asr	x25, x2, #6
	asr	x27, x6, #6
	smulh	x30, x11, x20
	add	x2, x25, x2, lsr #63
	add	x6, x27, x6, lsr #63
	mul	x25, x15, x16
	.loc	8 55 10
	add	v28.2d, v21.2d, v31.2d
	.loc	8 54 10
	smulh	x5, x10, x20
	cset	w20, mi
	.loc	8 56 10
	smulh	x21, x3, x0
	str	x15, [sp, #112]
	.loc	8 54 10
	smulh	x14, x11, x17
	asr	x26, x5, #14
	msub	x2, x2, x7, x12
	subs	x12, x12, x25
	msub	x22, x6, x7, x10
	asr	x6, x30, #14
	add	x27, x6, x30, lsr #63
	add	x6, x12, x16
	csel	w15, wzr, w20, eq
	csel	x12, x6, x12, mi
	.loc	8 56 10
	asr	x28, x21, #14
	.loc	8 54 10
	smulh	x23, x8, x0
	add	x9, x26, x5, lsr #63
	.loc	8 56 10
	add	x5, x28, x21, lsr #63
	.loc	8 54 10
	asr	x21, x14, #6
	add	x14, x21, x14, lsr #63
	add	x25, x2, #224
	mul	x20, x27, x16
	cmp	x2, #0
	.loc	8 52 10
	fcvtzs	v29.2d, v29.2d
	.loc	8 54 10
	asr	x24, x23, #14
	stp	x12, x15, [sp, #96]
	msub	x12, x14, x7, x11
	csel	x14, x25, x2, mi
	cmp	x11, #0
	add	x24, x24, x23, lsr #63
	.loc	8 55 10
	fmov	x2, d28
	.loc	8 54 10
	cset	w23, mi
	subs	x11, x11, x20
	smulh	x26, x8, x17
	add	x19, x11, x16
	stur	x9, [x29, #-112]
	csel	x11, x19, x11, mi
	mul	x28, x9, x16
	asr	x9, x26, #6
	add	x20, x12, #224
	add	x9, x9, x26, lsr #63
	csel	w15, wzr, w23, eq
	cmp	x12, #0
	.loc	8 56 10
	mov	x4, v26.d[1]
	.loc	8 55 10
	add	v26.2d, v21.2d, v29.2d
	str	x11, [sp, #80]
	.loc	8 54 10
	csel	x11, x20, x12, mi
	msub	x9, x9, x7, x8
	.loc	8 55 10
	smulh	x7, x2, x0
	.loc	8 54 10
	cmp	x10, #0
	.loc	8 55 10
	smulh	x23, x2, x17
	.loc	8 54 10
	cset	w19, mi
	stp	x11, x14, [x29, #-96]
	.loc	8 55 10
	asr	x11, x7, #14
	asr	x12, x23, #6
	.loc	8 54 10
	subs	x10, x10, x28
	.loc	8 55 10
	add	x7, x11, x7, lsr #63
	add	x11, x12, x23, lsr #63
	.loc	8 54 10
	csel	w12, wzr, w19, eq
	.loc	8 55 10
	fmov	x21, d26
	.loc	8 54 10
	add	x30, x22, #224
	.loc	8 55 10
	mov	x14, v28.d[1]
	msub	x28, x11, x1, x2
	str	x12, [sp, #72]
	.loc	8 54 10
	add	x12, x10, x16
	csel	x10, x12, x10, mi
	cmp	x22, #0
	csel	x11, x30, x22, mi
	mul	x26, x24, x16
	cmp	x8, #0
	str	x15, [sp, #88]
	.loc	8 55 10
	smulh	x15, x21, x0
	.loc	8 54 10
	add	x25, x9, #224
	stur	x11, [x29, #-104]
	cset	w11, mi
	subs	x8, x8, x26
	.loc	8 55 10
	asr	x20, x15, #14
	.loc	8 54 10
	csel	w12, wzr, w11, eq
	add	x11, x8, x16
	csel	x11, x11, x8, mi
	cmp	x9, #0
	.loc	8 55 10
	add	x23, x20, x15, lsr #63
	smulh	x15, x14, x0
	.loc	8 54 10
	csel	x9, x25, x9, mi
	.loc	8 55 10
	smulh	x19, x14, x17
	mul	x20, x7, x16
	asr	x8, x15, #14
	cmp	x2, #0
	add	x26, x8, x15, lsr #63
	str	x9, [sp, #120]
	asr	x9, x19, #6
	cset	w8, mi
	subs	x15, x2, x20
	add	x9, x9, x19, lsr #63
	add	x19, x15, x16
	add	x2, x28, #224
	csel	x20, x19, x15, mi
	mul	x15, x26, x16
	csel	w8, wzr, w8, eq
	cmp	x28, #0
	msub	x30, x9, x1, x14
	csel	x28, x2, x28, mi
	cmp	x14, #0
	cset	w2, mi
	subs	x15, x14, x15
	add	x9, x15, x16
	mov	w22, #4096
	csel	x14, x9, x15, mi
	smulh	x9, x20, x17
	movk	w22, #3, lsl #16
	sub	x7, x7, x8
	csel	w2, wzr, w2, eq
	smulh	x14, x14, x17
	mov	w25, #896
	madd	x15, x7, x22, x13
	sub	x2, x26, x2
	lsr	x7, x9, #6
	add	x9, x7, x9, lsr #63
	add	x7, x30, #224
	madd	x2, x2, x22, x13
	cmp	x30, #0
	madd	x9, x9, x25, x15
	lsr	x15, x14, #6
	add	x14, x15, x14, lsr #63
	csel	x7, x7, x30, mi
	cmp	x21, #0
	.loc	8 56 10
	fmov	x26, d27
	.loc	8 55 10
	madd	x14, x14, x25, x2
	cset	w19, mi
	mul	x2, x23, x16
	.loc	8 56 10
	mov	x8, v27.d[1]
	.loc	8 55 10
	mov	x6, v26.d[1]
	ldr	s26, [x9, x28, lsl #2]
	subs	x2, x21, x2
	smulh	x9, x21, x17
	ldr	s27, [x14, x7, lsl #2]
	add	x14, x2, x16
	csel	x14, x14, x2, mi
	csel	w19, wzr, w19, eq
	asr	x2, x9, #6
	add	x9, x2, x9, lsr #63
	smulh	x14, x14, x17
	sub	x19, x23, x19
	.loc	8 56 10
	smulh	x7, x26, x0
	.loc	8 57 10
	add	v31.2d, v22.2d, v31.2d
	.loc	8 56 10
	smulh	x15, x3, x17
	.loc	8 57 10
	add	v9.2d, v22.2d, v29.2d
	.loc	8 55 10
	msub	x9, x9, x1, x21
	lsr	x21, x14, #6
	add	x14, x21, x14, lsr #63
	madd	x19, x19, x22, x13
	smulh	x20, x6, x0
	.loc	8 56 10
	asr	x21, x7, #14
	asr	x2, x15, #6
	add	x21, x21, x7, lsr #63
	.loc	8 55 10
	madd	x14, x14, x25, x19
	add	x7, x9, #224
	cmp	x9, #0
	.loc	8 56 10
	add	x15, x2, x15, lsr #63
	.loc	8 55 10
	smulh	x2, x6, x17
	csel	x9, x7, x9, mi
	asr	x7, x20, #14
	cmp	x6, #0
	add	x7, x7, x20, lsr #63
	asr	x19, x2, #6
	add	x2, x19, x2, lsr #63
	ldr	s28, [x14, x9, lsl #2]
	mul	x9, x7, x16
	.loc	8 63 10
	mov	v26.d[1], v27.d[0]
	.loc	8 55 10
	msub	x14, x2, x1, x6
	cset	w2, mi
	subs	x9, x6, x9
	.loc	8 56 10
	msub	x15, x15, x1, x3
	.loc	8 55 10
	csel	w2, wzr, w2, eq
	add	x6, x14, #224
	sub	x2, x7, x2
	add	x7, x9, x16
	csel	x9, x7, x9, mi
	cmp	x14, #0
	.loc	8 56 10
	mul	x7, x5, x16
	.loc	8 55 10
	csel	x14, x6, x14, mi
	.loc	8 56 10
	cmp	x3, #0
	.loc	8 55 10
	smulh	x9, x9, x17
	.loc	8 56 10
	cset	w6, mi
	subs	x7, x3, x7
	add	x3, x7, x16
	.loc	8 55 10
	madd	x2, x2, x22, x13
	.loc	8 56 10
	csel	x3, x3, x7, mi
	.loc	8 55 10
	lsr	x7, x9, #6
	add	x9, x7, x9, lsr #63
	.loc	8 56 10
	csel	w6, wzr, w6, eq
	smulh	x3, x3, x17
	sub	x5, x5, x6
	.loc	8 55 10
	madd	x9, x9, x25, x2
	.loc	8 56 10
	cmp	x15, #0
	lsr	x6, x3, #6
	madd	x5, x5, x22, x13
	add	x3, x6, x3, lsr #63
	smulh	x2, x4, x0
	smulh	x6, x4, x17
	.loc	8 60 10
	fsub	v23.4s, v25.4s, v23.4s
	.loc	8 55 10
	ldr	s30, [x9, x14, lsl #2]
	.loc	8 56 10
	add	x14, x15, #224
	madd	x3, x3, x25, x5
	csel	x14, x14, x15, mi
	asr	x15, x2, #14
	smulh	x9, x8, x0
	add	x15, x15, x2, lsr #63
	asr	x2, x6, #6
	add	x2, x2, x6, lsr #63
	smulh	x19, x26, x17
	ldr	s8, [x3, x14, lsl #2]
	mul	x14, x15, x16
	cmp	x4, #0
	msub	x2, x2, x1, x4
	cset	w6, mi
	subs	x14, x4, x14
	asr	x3, x9, #14
	asr	x7, x19, #6
	smulh	x5, x8, x17
	add	x3, x3, x9, lsr #63
	add	x9, x14, x16
	add	x7, x7, x19, lsr #63
	mul	x19, x21, x16
	csel	x9, x9, x14, mi
	add	x14, x2, #224
	csel	w20, wzr, w6, eq
	cmp	x2, #0
	smulh	x9, x9, x17
	csel	x4, x14, x2, mi
	asr	x14, x5, #6
	cmp	x26, #0
	add	x23, x14, x5, lsr #63
	cset	w14, mi
	subs	x2, x26, x19
	add	x5, x2, x16
	sub	x15, x15, x20
	csel	x2, x5, x2, mi
	csel	w14, wzr, w14, eq
	msub	x6, x7, x1, x26
	sub	x14, x21, x14
	smulh	x2, x2, x17
	lsr	x7, x9, #6
	madd	x15, x15, x22, x13
	add	x9, x7, x9, lsr #63
	madd	x14, x14, x22, x13
	lsr	x7, x2, #6
	add	x2, x7, x2, lsr #63
	madd	x9, x9, x25, x15
	.loc	8 57 10
	mov	x20, v31.d[1]
	.loc	8 56 10
	add	x7, x6, #224
	.loc	8 57 10
	fmov	x15, d31
	.loc	8 56 10
	madd	x14, x2, x25, x14
	cmp	x6, #0
	mul	x5, x3, x16
	csel	x6, x7, x6, mi
	ldr	s31, [x9, x4, lsl #2]
	cmp	x8, #0
	msub	x2, x23, x1, x8
	.loc	8 54 10
	smulh	x10, x10, x17
	.loc	8 63 10
	mov	v28.d[1], v30.d[0]
	.loc	8 56 10
	ldr	s29, [x14, x6, lsl #2]
	.loc	8 57 10
	smulh	x6, x20, x0
	smulh	x7, x15, x0
	.loc	8 66 10
	mov	v8.d[1], v31.d[0]
	.loc	8 57 10
	smulh	x9, x15, x17
	asr	x4, x7, #14
	smulh	x19, x20, x17
	asr	x14, x9, #6
	add	x7, x4, x7, lsr #63
	add	x9, x14, x9, lsr #63
	asr	x14, x6, #14
	add	x4, x14, x6, lsr #63
	.loc	8 56 10
	cset	w6, mi
	subs	x8, x8, x5
	.loc	8 57 10
	asr	x14, x19, #6
	.loc	8 56 10
	csel	w6, wzr, w6, eq
	.loc	8 57 10
	add	x14, x14, x19, lsr #63
	.loc	8 56 10
	sub	x6, x3, x6
	add	x3, x8, x16
	add	x5, x2, #224
	csel	x3, x3, x8, mi
	.loc	8 57 10
	mul	x19, x7, x16
	.loc	8 56 10
	cmp	x2, #0
	csel	x8, x5, x2, mi
	.loc	8 57 10
	cmp	x15, #0
	msub	x9, x9, x1, x15
	cset	w2, mi
	subs	x15, x15, x19
	.loc	8 56 10
	smulh	x3, x3, x17
	.loc	8 57 10
	add	x5, x15, x16
	csel	w2, wzr, w2, eq
	csel	x15, x5, x15, mi
	sub	x2, x7, x2
	.loc	8 56 10
	lsr	x5, x3, #6
	add	x19, x5, x3, lsr #63
	.loc	8 57 10
	smulh	x15, x15, x17
	add	x5, x9, #224
	cmp	x9, #0
	madd	x2, x2, x22, x13
	csel	x9, x5, x9, mi
	lsr	x5, x15, #6
	add	x15, x5, x15, lsr #63
	mul	x7, x4, x16
	msub	x3, x14, x1, x20
	cmp	x20, #0
	madd	x15, x15, x25, x2
	fmov	x2, d9
	.loc	8 56 10
	madd	x14, x6, x22, x13
	.loc	8 57 10
	cset	w6, mi
	subs	x7, x20, x7
	mov	x5, v9.d[1]
	.loc	8 56 10
	madd	x14, x19, x25, x14
	.loc	8 57 10
	add	x19, x7, x16
	csel	x7, x19, x7, mi
	csel	w6, wzr, w6, eq
	ldr	s9, [x15, x9, lsl #2]
	add	x19, x3, #224
	smulh	x7, x7, x17
	cmp	x3, #0
	smulh	x9, x2, x0
	.loc	8 56 10
	ldr	s10, [x14, x8, lsl #2]
	.loc	8 57 10
	sub	x8, x4, x6
	lsr	x14, x7, #6
	add	x14, x14, x7, lsr #63
	asr	x15, x9, #14
	madd	x8, x8, x22, x13
	add	x9, x15, x9, lsr #63
	smulh	x15, x2, x17
	csel	x3, x19, x3, mi
	madd	x8, x14, x25, x8
	cmp	x2, #0
	mul	x14, x9, x16
	asr	x4, x15, #6
	add	x15, x4, x15, lsr #63
	cset	w4, mi
	subs	x14, x2, x14
	smulh	x6, x5, x0
	csel	w4, wzr, w4, eq
	msub	x15, x15, x1, x2
	add	x2, x14, x16
	sub	x9, x9, x4
	asr	x4, x6, #14
	csel	x14, x2, x14, mi
	add	x4, x4, x6, lsr #63
	add	x2, x15, #224
	cmp	x15, #0
	smulh	x14, x14, x17
	csel	x15, x2, x15, mi
	mul	x2, x4, x16
	cmp	x5, #0
	lsr	x6, x14, #6
	cset	w7, mi
	subs	x2, x5, x2
	add	x14, x6, x14, lsr #63
	add	x6, x2, x16
	smulh	x19, x5, x17
	csel	x2, x6, x2, mi
	madd	x9, x9, x22, x13
	csel	w7, wzr, w7, eq
	asr	x6, x19, #6
	smulh	x2, x2, x17
	add	x6, x6, x19, lsr #63
	madd	x9, x14, x25, x9
	sub	x14, x4, x7
	mov	w7, #224
	ldr	s12, [x8, x3, lsl #2]
	mov	x20, x0
	msub	x4, x6, x7, x5
	lsr	x5, x2, #6
	add	x2, x5, x2, lsr #63
	madd	x14, x14, x22, x13
	cmp	x4, #0
	ldr	s11, [x9, x15, lsl #2]
	madd	x14, x2, x25, x14
	add	x2, x4, #224
	csel	x2, x2, x4, mi
	ldur	x9, [x29, #-112]
	ldp	x8, x1, [sp, #96]
	.loc	8 54 10
	smulh	x11, x11, x17
	.loc	8 67 10
	mov	v9.d[1], v12.d[0]
	.loc	8 57 10
	ldr	s13, [x14, x2, lsl #2]
	.loc	8 54 10
	lsr	x2, x10, #6
	ldp	x14, x15, [sp, #72]
	add	x10, x2, x10, lsr #63
	smulh	x8, x8, x17
	ldr	x0, [sp, #112]
	.loc	8 66 10
	mov	v29.d[1], v10.d[0]
	.loc	8 54 10
	lsr	x4, x8, #6
	.loc	8 67 10
	mov	v11.d[1], v13.d[0]
	.loc	8 54 10
	sub	x9, x9, x14
	ldr	x14, [sp, #88]
	smulh	x15, x15, x17
	add	x8, x4, x8, lsr #63
	madd	x9, x9, x22, x13
	sub	x3, x0, x1
	lsr	x2, x15, #6
	.loc	8 63 10
	uzp1	v25.4s, v26.4s, v28.4s
	.loc	8 54 10
	sub	x14, x27, x14
	madd	x9, x10, x25, x9
	sub	x10, x24, x12
	lsr	x12, x11, #6
	madd	x3, x3, x22, x13
	add	x15, x2, x15, lsr #63
	add	x11, x12, x11, lsr #63
	madd	x10, x10, x22, x13
	madd	x12, x14, x22, x13
	.loc	8 67 10
	uzp1	v31.4s, v9.4s, v11.4s
	.loc	8 54 10
	madd	x8, x8, x25, x3
	.loc	8 66 10
	uzp1	v26.4s, v8.4s, v29.4s
	.loc	8 54 10
	madd	x10, x11, x25, x10
	ldr	x14, [sp, #64]
	madd	x11, x15, x25, x12
	ldur	x12, [x29, #-88]
	ldr	s12, [x8, x12, lsl #2]
	ldur	x12, [x29, #-104]
	ldp	x8, x15, [x29, #-72]
	ldr	s30, [x9, x12, lsl #2]
	ldr	x12, [sp, #120]
	.loc	8 19 8
	add	x8, x8, #4
	ldur	x9, [x29, #-80]
	cmp	x8, #52
	.loc	8 54 10
	ldr	s27, [x10, x12, lsl #2]
	ldur	x10, [x29, #-96]
	.loc	8 19 8
	add	x9, x9, #4
	.loc	8 62 10
	mov	v30.d[1], v27.d[0]
	.loc	8 54 10
	ldr	s10, [x11, x10, lsl #2]
	.loc	8 67 10
	fmul	v27.4s, v24.4s, v31.4s
	.loc	8 63 10
	fmul	v24.4s, v24.4s, v25.4s
	.loc	8 62 10
	mov	v12.d[1], v10.d[0]
	.loc	8 68 10
	fmla	v27.4s, v23.4s, v26.4s
	.loc	8 62 10
	uzp1	v28.4s, v12.4s, v30.4s
	.loc	8 64 10
	fmla	v24.4s, v23.4s, v28.4s
	.loc	8 69 10
	fmul	v23.4s, v27.4s, v20.s[0]
	.loc	8 70 10
	fmla	v23.4s, v24.4s, v19.s[0]
	.loc	8 19 8
	str	q23, [x14, x15]
	add	x15, x15, #16
	b.lo	.LBB7_3
	.loc	8 0 8 is_stmt 0
	ldr	x12, [sp, #56]
	.loc	8 19 8
	add	x14, x14, #456
	add	x12, x12, #1
	cmp	x12, #56
	b.ne	.LBB7_2
	.loc	8 0 8
	ldp	x11, x9, [sp, #16]
	.loc	8 19 8
	mov	w8, #51984
	add	x9, x9, #1
	add	x11, x11, x8
	cmp	x9, #32
	b.ne	.LBB7_1
	.loc	8 74 8 epilogue_begin is_stmt 1
	ldp	x20, x19, [sp, #320]
	mov	w0, wzr
	ldp	x22, x21, [sp, #304]
	ldp	x24, x23, [sp, #288]
	ldp	x26, x25, [sp, #272]
	ldp	x28, x27, [sp, #256]
	ldp	x29, x30, [sp, #240]
	ldp	d9, d8, [sp, #224]
	ldp	d11, d10, [sp, #208]
	ldp	d13, d12, [sp, #192]
	add	sp, sp, #336
	ret
.Ltmp44:
.Lfunc_end7:
	.size	infer_dispatch_13_elementwise_broadcast_128x112x112_f32, .Lfunc_end7-infer_dispatch_13_elementwise_broadcast_128x112x112_f32
	.cfi_endproc

	.section	.text.infer_dispatch_14_conv_64x112x112x128x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_14_conv_64x112x112x128x3x3_f32,@function
infer_dispatch_14_conv_64x112x112x128x3x3_f32:
.Lfunc_begin8:
	.file	9 "dump" "configured_module_infer_dispatch_14.mlir"
	.loc	9 1 0
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp45:
	.loc	9 15 8 prologue_end
	ldr	x9, [x1, #32]
	mov	w15, #16384
	.loc	9 22 8
	ldr	w10, [x2]
	movk	w15, #2, lsl #16
	mov	w11, #112
	mov	w12, #12768
	mov	w13, #2048
	mov	x8, xzr
	.loc	9 15 8
	ldp	x14, x16, [x9]
	.loc	9 22 8
	lsr	x3, x10, #4
	and	x1, x10, #0x3
	.loc	9 17 8
	ldr	x17, [x9, #16]
	.loc	9 22 8
	ubfx	x0, x10, #2, #2
	umull	x4, w1, w11
	movk	w13, #1281, lsl #16
	umaddl	x15, w3, w15, x16
	mov	w16, #52429
	movk	w16, #15948, lsl #16
	lsl	x9, x10, #1
	lsl	x2, x0, #5
	sub	x10, x2, x0, lsl #2
	umaddl	x0, w0, w12, x4
	lsl	x11, x1, #5
	dup	v0.4s, w16
	add	x13, x14, x13
	and	x9, x9, #0x1ffffffe0
	sub	x11, x11, x1, lsl #2
	.loc	9 17 8
	add	x12, x17, #1568, lsl #12
	.loc	9 22 8
	add	x13, x0, x13
	add	x14, x15, #384
	mov	w16, #448
	mov	x17, sp
	add	x0, sp, #64
	mov	w1, #51984
	mov	w2, #4608
	adrp	x3, __constant_64xf32_0
	add	x3, x3, :lo12:__constant_64xf32_0
	.loc	9 9 8
	stp	xzr, xzr, [sp]
	.loc	9 0 8 is_stmt 0
.Ltmp46:
	.p2align	4, , 8
.LBB8_1:
	.loc	9 22 8 is_stmt 1
	orr	x15, x8, x9
	mov	x4, xzr
	mov	x6, x13
	.loc	9 28 8
	add	x5, x3, x15, lsl #2
	ld1r	{ v1.4s }, [x5]
	mov	w5, #50176
	madd	x5, x15, x5, x12
	.loc	9 0 8 is_stmt 0
.Ltmp47:
	.p2align	4, , 8
.LBB8_2:
	add	x15, x4, x10
	mov	x19, xzr
	mov	x20, x6
	madd	x7, x15, x16, x5
	.p2align	4, , 8
.LBB8_3:
	mov	x15, xzr
	.p2align	4, , 8
.LBB8_4:
	.loc	9 22 8 is_stmt 1
	ldr	s2, [x17, x15]
	str	s2, [x0, x15]
	add	x15, x15, #4
	cmp	x15, #16
	b.ne	.LBB8_4
	.loc	9 0 8 is_stmt 0
	mov	x22, xzr
	.loc	9 22 8
	add	x21, x19, x11
	mov	x23, x14
	mov	x24, x20
	.loc	9 0 8
.Ltmp48:
	.p2align	4, , 8
.LBB8_6:
	mov	x25, xzr
	mov	x26, x23
	mov	x27, x24
	.p2align	4, , 8
.LBB8_7:
	mov	x28, xzr
	mov	x30, x27
	.p2align	4, , 8
.LBB8_8:
	ldr	s2, [x0, x28, lsl #2]
	mov	x15, xzr
	.p2align	4, , 8
.LBB8_9:
	.loc	9 22 8 is_stmt 1
	ldr	s3, [x30, x15]
	ldr	s4, [x26, x15]
	add	x15, x15, #4
	cmp	x15, #12
	.loc	9 25 10
	fmadd	s2, s3, s4, s2
	.loc	9 22 8
	b.ne	.LBB8_9
	str	s2, [x0, x28, lsl #2]
	add	x28, x28, #1
	add	x30, x30, #4
	cmp	x28, #4
	b.ne	.LBB8_8
	add	x25, x25, #1
	add	x27, x27, #456
	add	x26, x26, #12
	cmp	x25, #3
	b.ne	.LBB8_7
	add	x22, x22, #1
	add	x24, x24, x1
	add	x23, x23, #36
	cmp	x22, #128
	b.ne	.LBB8_6
	.loc	9 28 8
	ldr	q2, [sp, #64]
	.loc	9 22 8
	add	x15, x19, #4
	cmp	x19, #24
	add	x20, x20, #16
	mov	x19, x15
	lsl	x21, x21, #2
	.loc	9 30 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	9 32 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	9 35 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	9 32 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	9 35 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	9 36 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	9 22 8
	str	q2, [x7, x21]
	b.lo	.LBB8_3
	add	x4, x4, #1
	add	x6, x6, #456
	cmp	x4, #28
	b.ne	.LBB8_2
	add	x8, x8, #1
	add	x14, x14, x2
	cmp	x8, #32
	b.ne	.LBB8_1
	.loc	9 40 8
	mov	w0, wzr
	.loc	9 40 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp49:
.Lfunc_end8:
	.size	infer_dispatch_14_conv_64x112x112x128x3x3_f32, .Lfunc_end8-infer_dispatch_14_conv_64x112x112x128x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI9_0:
	.xword	2
	.xword	3
.LCPI9_1:
	.xword	0
	.xword	1
	.section	.text.infer_dispatch_15_elementwise_broadcast_64x224x224_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_15_elementwise_broadcast_64x224x224_f32,@function
infer_dispatch_15_elementwise_broadcast_64x224x224_f32:
.Lfunc_begin9:
	.file	10 "dump" "configured_module_infer_dispatch_15.mlir"
	.loc	10 1 0 is_stmt 1
	.cfi_startproc
	sub	sp, sp, #320
	str	d12, [sp, #176]
	stp	d11, d10, [sp, #192]
	stp	d9, d8, [sp, #208]
	stp	x29, x30, [sp, #224]
	stp	x28, x27, [sp, #240]
	stp	x26, x25, [sp, #256]
	stp	x24, x23, [sp, #272]
	stp	x22, x21, [sp, #288]
	stp	x20, x19, [sp, #304]
	add	x29, sp, #224
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
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -144
.Ltmp50:
	.loc	10 20 8 prologue_end
	ldr	w10, [x2]
	mov	w8, #224
	.loc	10 16 8
	ldr	x9, [x1, #32]
	mov	w12, #50624
	mov	w13, #1121845248
	adrp	x14, .LCPI9_0
	fmov	s0, #0.50000000
	mov	x20, #58849
	.loc	10 20 8
	and	x15, x10, #0x3
	lsr	x10, x10, #2
	lsl	x16, x10, #6
	fmov	s1, #-0.50000000
	sub	x17, x16, x10, lsl #3
	umull	x8, w15, w8
	.loc	10 16 8
	ldp	x11, x9, [x9]
	.loc	10 20 8
	umaddl	x8, w10, w12, x8
	adrp	x10, .LCPI9_1
	lsl	x16, x15, #6
	sub	x15, x16, x15, lsl #3
	movi	d2, #0000000000000000
	dup	v3.4s, w13
	add	x9, x9, #2352, lsl #12
	fmov	s4, w13
	movk	x20, #48148, lsl #16
	stp	x15, x17, [sp, #24]
	fmov	s5, #1.00000000
	movi	v16.4s, #63, lsl #24
	mov	x15, #18725
	fmov	v17.4s, #1.00000000
	movk	x15, #9362, lsl #16
	add	x9, x9, #908
	ldr	q6, [x14, :lo12:.LCPI9_0]
	ldr	q7, [x10, :lo12:.LCPI9_1]
	movk	x20, #33436, lsl #32
	movk	x15, #37449, lsl #32
	mov	x17, xzr
	.loc	10 16 8
	add	x11, x11, #1568, lsl #12
	.loc	10 20 8
	add	x9, x8, x9
	movk	x20, #21399, lsl #48
	movk	x15, #18724, lsl #48
	mov	w13, #112
	.loc	10 0 8 is_stmt 0
.Ltmp51:
	.p2align	4, , 8
.LBB9_1:
	.loc	10 55 10 is_stmt 1
	lsl	x8, x17, #7
	mov	x10, xzr
	sub	x8, x8, x17, lsl #4
	mov	x14, x9
	stp	x9, x17, [sp, #8]
	str	x8, [sp, #40]
	.loc	10 0 10 is_stmt 0
.Ltmp52:
	.p2align	4, , 8
.LBB9_2:
	ldp	x8, x12, [sp, #32]
	mov	x16, xzr
	stp	x10, x14, [sp, #48]
	.loc	10 23 10 is_stmt 1
	add	x8, x10, x8
	.loc	10 26 10
	ucvtf	s18, x8
	.loc	10 27 10
	fadd	s18, s18, s0
	.loc	10 29 10
	fmadd	s18, s18, s0, s1
	.loc	10 30 10
	fcmp	s18, #0.0
	fcsel	s18, s2, s18, ls
	.loc	10 31 10
	fcmp	s18, s4
	fcsel	s19, s4, s18, ge
	.loc	10 40 10
	fadd	s18, s19, s5
	.loc	10 42 10
	fcvtms	x8, s19
	.loc	10 44 10
	fcmp	s18, s4
	.loc	10 55 10
	add	x8, x12, x8
	lsl	x10, x8, #7
	sub	x8, x10, x8, lsl #4
	.loc	10 44 10
	fcsel	s20, s4, s18, ge
	.loc	10 41 10
	frintm	s18, s18
	.loc	10 45 10
	fcvtzs	x9, s20
	.loc	10 39 10
	frintm	s20, s19
	.loc	10 59 10
	fsub	s18, s18, s19
	.loc	10 57 10
	add	x9, x12, x9
	lsl	x10, x9, #7
	.loc	10 60 10
	fsub	s19, s19, s20
	.loc	10 57 10
	sub	x9, x10, x9, lsl #4
	dup	v20.2d, x8
	mov	x8, #-4
	dup	v21.2d, x9
	ldr	x9, [sp, #24]
	.loc	10 0 10 is_stmt 0
.Ltmp53:
	.p2align	4, , 8
.LBB9_3:
	.loc	10 20 8 is_stmt 1
	dup	v22.2d, x9
	stp	x9, x8, [x29, #-72]
	mov	x0, x20
	mov	w14, #12544
	stur	x16, [x29, #-40]
	.loc	10 24 10
	orr	v23.16b, v22.16b, v7.16b
	orr	v22.16b, v22.16b, v6.16b
	.loc	10 33 10
	mov	x8, v23.d[1]
	fmov	x9, d23
	ucvtf	s24, x8
	ucvtf	s23, x9
	fmov	x8, d22
	mov	x9, v22.d[1]
	mov	v23.s[1], v24.s[0]
	ucvtf	s22, x8
	ucvtf	s24, x9
	mov	v23.s[2], v22.s[0]
	.loc	10 36 10
	movi	v22.4s, #191, lsl #24
	.loc	10 33 10
	mov	v23.s[3], v24.s[0]
	.loc	10 34 10
	fadd	v23.4s, v23.4s, v16.4s
	.loc	10 36 10
	fmla	v22.4s, v23.4s, v16.4s
	.loc	10 37 10
	fcmle	v23.4s, v22.4s, #0.0
	bic	v22.16b, v22.16b, v23.16b
	.loc	10 38 10
	fcmge	v23.4s, v22.4s, v3.4s
	bit	v22.16b, v3.16b, v23.16b
	.loc	10 47 10
	frintm	v23.4s, v22.4s
	.loc	10 48 10
	fadd	v24.4s, v22.4s, v17.4s
	.loc	10 50 10
	fcvtl	v25.2d, v23.2s
	fcvtl2	v26.2d, v23.4s
	.loc	10 52 10
	fcmge	v27.4s, v24.4s, v3.4s
	.loc	10 62 10
	fsub	v23.4s, v22.4s, v23.4s
	.loc	10 50 10
	fcvtzs	v25.2d, v25.2d
	fcvtzs	v26.2d, v26.2d
	.loc	10 52 10
	bsl	v27.16b, v3.16b, v24.16b
	.loc	10 49 10
	frintm	v24.4s, v24.4s
	.loc	10 55 10
	add	v30.2d, v20.2d, v25.2d
	add	v29.2d, v20.2d, v26.2d
	.loc	10 57 10
	add	v31.2d, v21.2d, v25.2d
	add	v26.2d, v21.2d, v26.2d
	.loc	10 53 10
	fcvtl	v28.2d, v27.2s
	fcvtl2	v27.2d, v27.4s
	.loc	10 55 10
	fmov	x5, d30
	fmov	x12, d29
	.loc	10 57 10
	fmov	x4, d31
	fmov	x3, d26
	.loc	10 55 10
	mov	x10, v29.d[1]
	mov	x1, v30.d[1]
	smulh	x8, x5, x20
	.loc	10 53 10
	fcvtzs	v29.2d, v28.2d
	.loc	10 55 10
	smulh	x9, x5, x15
	.loc	10 53 10
	fcvtzs	v25.2d, v27.2d
	.loc	10 55 10
	smulh	x2, x12, x20
	asr	x23, x8, #12
	.loc	10 57 10
	smulh	x22, x4, x15
	.loc	10 55 10
	add	x17, x23, x8, lsr #63
	smulh	x20, x12, x15
	asr	x26, x9, #5
	.loc	10 57 10
	smulh	x19, x4, x0
	asr	x21, x22, #5
	smulh	x25, x3, x0
	.loc	10 55 10
	asr	x27, x2, #12
	add	x26, x26, x9, lsr #63
	add	x16, x27, x2, lsr #63
	.loc	10 57 10
	add	x9, x21, x22, lsr #63
	.loc	10 55 10
	mul	x21, x17, x14
	cmp	x5, #0
	.loc	10 57 10
	asr	x6, x25, #12
	.loc	10 55 10
	cset	w24, mi
	asr	x28, x20, #5
	.loc	10 57 10
	asr	x30, x19, #12
	.loc	10 55 10
	add	x20, x28, x20, lsr #63
	.loc	10 57 10
	add	x8, x30, x19, lsr #63
	.loc	10 55 10
	smulh	x19, x10, x15
	.loc	10 57 10
	add	x2, x6, x25, lsr #63
	.loc	10 55 10
	msub	x6, x26, x13, x5
	subs	x5, x5, x21
	smulh	x7, x1, x0
	stp	x17, x16, [sp, #104]
	.loc	10 56 10
	add	v27.2d, v20.2d, v25.2d
	.loc	10 55 10
	mul	x22, x16, x14
	.loc	10 56 10
	add	v28.2d, v20.2d, v29.2d
	.loc	10 55 10
	csel	w16, wzr, w24, eq
	msub	x20, x20, x13, x12
	mov	x14, x11
	mov	w11, #12544
	asr	x13, x19, #5
	smulh	x27, x1, x15
	smulh	x28, x10, x0
	add	x13, x13, x19, lsr #63
	add	x19, x5, x11
	asr	x25, x7, #12
	add	x7, x25, x7, lsr #63
	str	x16, [sp, #96]
	csel	x16, x19, x5, mi
	asr	x26, x28, #12
	asr	x30, x27, #5
	mov	w23, #112
	add	x21, x6, #112
	add	x27, x30, x27, lsr #63
	add	x25, x26, x28, lsr #63
	mul	x26, x7, x11
	cmp	x6, #0
	str	x16, [sp, #88]
	csel	x16, x21, x6, mi
	cmp	x1, #0
	.loc	10 56 10
	fmov	x6, d28
	.loc	10 55 10
	msub	x19, x27, x23, x1
	.loc	10 56 10
	fmov	x24, d27
	.loc	10 55 10
	cset	w21, mi
	subs	x1, x1, x26
	add	x26, x19, #112
	add	x27, x1, x11
	csel	w17, wzr, w21, eq
	csel	x1, x27, x1, mi
	cmp	x19, #0
	csel	x19, x26, x19, mi
	cmp	x12, #0
	.loc	10 56 10
	smulh	x21, x6, x0
	.loc	10 55 10
	cset	w26, mi
	str	x1, [sp, #72]
	.loc	10 56 10
	smulh	x1, x24, x0
	stur	x19, [x29, #-88]
	asr	x19, x21, #12
	.loc	10 55 10
	subs	x12, x12, x22
	.loc	10 56 10
	add	x19, x19, x21, lsr #63
	asr	x21, x1, #12
	add	x27, x21, x1, lsr #63
	.loc	10 55 10
	csel	w1, wzr, w26, eq
	add	x30, x20, #112
	mul	x28, x25, x11
	.loc	10 56 10
	mov	x5, v28.d[1]
	str	x17, [sp, #80]
	smulh	x17, x6, x15
	str	x1, [sp, #64]
	.loc	10 55 10
	add	x1, x12, x11
	csel	x12, x1, x12, mi
	cmp	x20, #0
	csel	x1, x30, x20, mi
	cmp	x10, #0
	msub	x13, x13, x23, x10
	.loc	10 56 10
	asr	x22, x17, #5
	add	x17, x22, x17, lsr #63
	stur	x16, [x29, #-80]
	stur	x1, [x29, #-96]
	.loc	10 55 10
	cset	w1, mi
	subs	x10, x10, x28
	add	x16, x13, #112
	add	x22, x10, x11
	csel	w1, wzr, w1, eq
	csel	x10, x22, x10, mi
	cmp	x13, #0
	csel	x13, x16, x13, mi
	.loc	10 56 10
	smulh	x21, x5, x0
	smulh	x20, x5, x15
	cmp	x6, #0
	mul	x22, x19, x11
	cset	w16, mi
	stur	x13, [x29, #-104]
	asr	x13, x21, #12
	msub	x17, x17, x23, x6
	add	x13, x13, x21, lsr #63
	subs	x6, x6, x22
	asr	x21, x20, #5
	add	x20, x21, x20, lsr #63
	add	x21, x6, x11
	csel	x6, x21, x6, mi
	add	x21, x17, #112
	csel	w16, wzr, w16, eq
	cmp	x17, #0
	csel	x17, x21, x17, mi
	mul	x21, x13, x11
	cmp	x5, #0
	msub	x20, x20, x23, x5
	sub	x16, x19, x16
	cset	w19, mi
	subs	x5, x5, x21
	smulh	x6, x6, x15
	csel	w19, wzr, w19, eq
	mov	w21, #50176
	sub	x13, x13, x19
	add	x19, x5, x11
	csel	x5, x19, x5, mi
	madd	x16, x16, x21, x14
	lsr	x19, x6, #5
	add	x6, x19, x6, lsr #63
	smulh	x21, x5, x15
	mov	w5, #448
	add	x19, x20, #112
	cmp	x20, #0
	madd	x16, x6, x5, x16
	csel	x6, x19, x20, mi
	lsr	x19, x21, #5
	mul	x20, x27, x11
	add	x19, x19, x21, lsr #63
	mov	w21, #50176
	cmp	x24, #0
	.loc	10 57 10
	mov	x5, v26.d[1]
	.loc	10 56 10
	madd	x13, x13, x21, x14
	mov	w21, #448
	ldr	s26, [x16, x17, lsl #2]
	cset	w16, mi
	subs	x17, x24, x20
	madd	x13, x19, x21, x13
	add	x20, x17, x11
	.loc	10 57 10
	mov	x22, v31.d[1]
	.loc	10 56 10
	csel	x17, x20, x17, mi
	smulh	x20, x24, x15
	mov	x21, v27.d[1]
	csel	w16, wzr, w16, eq
	ldr	s27, [x13, x6, lsl #2]
	asr	x6, x20, #5
	sub	x16, x27, x16
	smulh	x17, x17, x15
	add	x6, x6, x20, lsr #63
	mov	w20, #50176
	.loc	10 57 10
	smulh	x19, x3, x15
	.loc	10 58 10
	add	v29.2d, v21.2d, v29.2d
	.loc	10 56 10
	madd	x16, x16, x20, x14
	lsr	x20, x17, #5
	add	x17, x20, x17, lsr #63
	.loc	10 57 10
	asr	x20, x19, #5
	smulh	x13, x22, x0
	add	x27, x20, x19, lsr #63
	.loc	10 56 10
	msub	x6, x6, x23, x24
	mov	w20, #448
	.loc	10 57 10
	smulh	x26, x22, x15
	asr	x19, x13, #12
	.loc	10 56 10
	madd	x16, x17, x20, x16
	add	x17, x6, #112
	cmp	x6, #0
	.loc	10 57 10
	add	x30, x19, x13, lsr #63
	.loc	10 56 10
	csel	x17, x17, x6, mi
	smulh	x13, x21, x0
	.loc	10 57 10
	asr	x6, x26, #5
	add	x19, x6, x26, lsr #63
	smulh	x6, x5, x0
	.loc	10 56 10
	cmp	x21, #0
	ldr	s28, [x16, x17, lsl #2]
	asr	x17, x13, #12
	add	x13, x17, x13, lsr #63
	smulh	x16, x21, x15
	.loc	10 57 10
	asr	x17, x6, #12
	add	x24, x17, x6, lsr #63
	.loc	10 56 10
	mul	x6, x13, x11
	asr	x17, x16, #5
	add	x16, x17, x16, lsr #63
	cset	w17, mi
	subs	x6, x21, x6
	.loc	10 57 10
	msub	x9, x9, x23, x4
	.loc	10 56 10
	add	x20, x6, x11
	msub	x16, x16, x23, x21
	csel	x6, x20, x6, mi
	.loc	10 57 10
	smulh	x20, x5, x15
	.loc	10 56 10
	csel	w17, wzr, w17, eq
	cmp	x16, #0
	add	x26, x16, #112
	.loc	10 57 10
	asr	x21, x20, #5
	add	x28, x21, x20, lsr #63
	.loc	10 56 10
	csel	x20, x26, x16, mi
	.loc	10 57 10
	mul	x16, x8, x11
	cmp	x4, #0
	cset	w21, mi
	.loc	10 56 10
	sub	x13, x13, x17
	.loc	10 57 10
	subs	x16, x4, x16
	.loc	10 56 10
	smulh	x4, x6, x15
	.loc	10 57 10
	add	x17, x16, x11
	csel	w6, wzr, w21, eq
	csel	x16, x17, x16, mi
	.loc	10 56 10
	lsr	x17, x4, #5
	add	x17, x17, x4, lsr #63
	mov	w4, #50176
	.loc	10 57 10
	sub	x8, x8, x6
	.loc	10 56 10
	mov	w6, #448
	madd	x13, x13, x4, x14
	.loc	10 57 10
	cmp	x9, #0
	smulh	x16, x16, x15
	mov	w21, #50176
	.loc	10 56 10
	madd	x13, x17, x6, x13
	.loc	10 57 10
	mov	w6, #50176
	lsr	x17, x16, #5
	msub	x4, x19, x23, x22
	add	x16, x17, x16, lsr #63
	add	x17, x9, #112
	madd	x8, x8, x6, x14
	csel	x17, x17, x9, mi
	.loc	10 56 10
	ldr	s30, [x13, x20, lsl #2]
	.loc	10 58 10
	fmov	x20, d29
	.loc	10 57 10
	mov	w9, #448
	mul	x6, x30, x11
	cmp	x22, #0
	.loc	10 58 10
	add	v10.2d, v21.2d, v25.2d
	.loc	10 57 10
	madd	x8, x16, x9, x8
	cset	w13, mi
	subs	x16, x22, x6
	.loc	10 58 10
	mov	x9, v29.d[1]
	.loc	10 57 10
	csel	w13, wzr, w13, eq
	.loc	10 55 10
	smulh	x12, x12, x15
	.loc	10 58 10
	smulh	x6, x20, x0
	.loc	10 57 10
	sub	x13, x30, x13
	ldr	s29, [x8, x17, lsl #2]
	.loc	10 58 10
	smulh	x8, x20, x15
	.loc	10 57 10
	add	x17, x16, x11
	.loc	10 55 10
	smulh	x10, x10, x15
	.loc	10 57 10
	csel	x16, x17, x16, mi
	.loc	10 58 10
	asr	x17, x6, #12
	add	x22, x17, x6, lsr #63
	asr	x17, x8, #5
	add	x17, x17, x8, lsr #63
	.loc	10 57 10
	smulh	x8, x16, x15
	.loc	10 58 10
	smulh	x16, x9, x0
	.loc	10 57 10
	cmp	x4, #0
	lsr	x6, x8, #5
	.loc	10 58 10
	smulh	x19, x9, x15
	.loc	10 57 10
	add	x6, x6, x8, lsr #63
	mov	w8, #50176
	.loc	10 58 10
	msub	x17, x17, x23, x20
	.loc	10 64 10
	mov	v28.d[1], v30.d[0]
	.loc	10 57 10
	madd	x13, x13, x8, x14
	.loc	10 58 10
	asr	x8, x16, #12
	add	x8, x8, x16, lsr #63
	asr	x16, x19, #5
	add	x30, x16, x19, lsr #63
	.loc	10 57 10
	mov	w16, #448
	.loc	10 64 10
	mov	v26.d[1], v27.d[0]
	.loc	10 57 10
	madd	x13, x6, x16, x13
	add	x16, x4, #112
	csel	x16, x16, x4, mi
	mul	x4, x2, x11
	cmp	x3, #0
	msub	x6, x27, x23, x3
	cset	w19, mi
	subs	x3, x3, x4
	ldr	s31, [x13, x16, lsl #2]
	add	x13, x3, x11
	mul	x16, x24, x11
	csel	x13, x13, x3, mi
	add	x3, x6, #112
	csel	w19, wzr, w19, eq
	cmp	x6, #0
	msub	x4, x28, x23, x5
	csel	x3, x3, x6, mi
	cmp	x5, #0
	cset	w6, mi
	subs	x16, x5, x16
	csel	w5, wzr, w6, eq
	add	x6, x16, x11
	smulh	x13, x13, x15
	sub	x2, x2, x19
	.loc	10 58 10
	mul	x19, x22, x11
	.loc	10 57 10
	csel	x16, x6, x16, mi
	add	x6, x4, #112
	cmp	x4, #0
	csel	x4, x6, x4, mi
	lsr	x6, x13, #5
	.loc	10 58 10
	cmp	x20, #0
	.loc	10 57 10
	madd	x2, x2, x21, x14
	add	x13, x6, x13, lsr #63
	.loc	10 58 10
	cset	w6, mi
	subs	x19, x20, x19
	mov	x20, x0
	.loc	10 57 10
	mov	w0, #448
	smulh	x16, x16, x15
	sub	x5, x24, x5
	.loc	10 58 10
	csel	w6, wzr, w6, eq
	.loc	10 57 10
	madd	x13, x13, x0, x2
	.loc	10 58 10
	add	x2, x19, x11
	.loc	10 57 10
	mov	w0, #50176
	.loc	10 58 10
	csel	x2, x2, x19, mi
	.loc	10 57 10
	lsr	x19, x16, #5
	add	x16, x19, x16, lsr #63
	madd	x5, x5, x0, x14
	mov	w0, #448
	.loc	10 58 10
	smulh	x2, x2, x15
	sub	x6, x22, x6
	.loc	10 57 10
	madd	x16, x16, x0, x5
	.loc	10 58 10
	mov	w0, #50176
	lsr	x5, x2, #5
	cmp	x17, #0
	add	x2, x5, x2, lsr #63
	madd	x6, x6, x0, x14
	mov	w0, #448
	add	x5, x17, #112
	csel	x17, x5, x17, mi
	mul	x5, x8, x11
	madd	x2, x2, x0, x6
	cmp	x9, #0
	cset	w6, mi
	subs	x5, x9, x5
	add	x19, x5, x11
	.loc	10 57 10
	ldr	s25, [x13, x3, lsl #2]
	.loc	10 58 10
	csel	x13, x19, x5, mi
	csel	w3, wzr, w6, eq
	ldr	s9, [x2, x17, lsl #2]
	fmov	x17, d10
	smulh	x13, x13, x15
	sub	x8, x8, x3
	.loc	10 57 10
	ldr	s8, [x16, x4, lsl #2]
	.loc	10 58 10
	mov	x16, v10.d[1]
	mov	w0, #50176
	lsr	x4, x13, #5
	msub	x9, x30, x23, x9
	add	x13, x4, x13, lsr #63
	madd	x8, x8, x0, x14
	mov	w0, #448
	smulh	x3, x17, x20
	add	x2, x9, #112
	cmp	x9, #0
	madd	x8, x13, x0, x8
	asr	x4, x3, #12
	csel	x9, x2, x9, mi
	add	x3, x4, x3, lsr #63
	smulh	x4, x17, x15
	cmp	x17, #0
	smulh	x5, x16, x20
	mul	x13, x3, x11
	asr	x2, x4, #5
	add	x2, x2, x4, lsr #63
	cset	w4, mi
	subs	x13, x17, x13
	smulh	x19, x16, x15
	csel	w4, wzr, w4, eq
	msub	x17, x2, x23, x17
	add	x2, x13, x11
	sub	x3, x3, x4
	asr	x4, x5, #12
	csel	x13, x2, x13, mi
	add	x4, x4, x5, lsr #63
	add	x2, x17, #112
	cmp	x17, #0
	smulh	x13, x13, x15
	csel	x17, x2, x17, mi
	mul	x2, x4, x11
	cmp	x16, #0
	lsr	x5, x13, #5
	cset	w6, mi
	subs	x2, x16, x2
	add	x13, x5, x13, lsr #63
	add	x5, x2, x11
	mov	w11, #50176
	csel	x2, x5, x2, mi
	ldr	s11, [x8, x9, lsl #2]
	asr	x5, x19, #5
	madd	x3, x3, x11, x14
	mov	w11, #448
	ldp	x8, x0, [sp, #88]
	csel	w6, wzr, w6, eq
	smulh	x2, x2, x15
	ldr	x9, [sp, #104]
	add	x5, x5, x19, lsr #63
	madd	x13, x13, x11, x3
	sub	x3, x4, x6
	mov	x11, x14
	mov	w14, #50176
	msub	x16, x5, x23, x16
	lsr	x4, x2, #5
	add	x2, x4, x2, lsr #63
	madd	x3, x3, x14, x11
	.loc	10 55 10
	sub	x9, x9, x0
	.loc	10 58 10
	mov	w0, #448
	.loc	10 55 10
	smulh	x8, x8, x15
	.loc	10 58 10
	cmp	x16, #0
	madd	x2, x2, x0, x3
	add	x3, x16, #112
	csel	x16, x3, x16, mi
	.loc	10 55 10
	lsr	x3, x8, #5
	add	x8, x3, x8, lsr #63
	madd	x9, x9, x14, x11
	.loc	10 58 10
	ldr	s10, [x13, x17, lsl #2]
	.loc	10 55 10
	mov	w13, #448
	.loc	10 58 10
	ldr	s12, [x2, x16, lsl #2]
	.loc	10 55 10
	lsr	x17, x12, #5
	madd	x8, x8, x13, x9
	ldr	x9, [sp, #112]
	ldp	x13, x16, [sp, #64]
	add	x12, x17, x12, lsr #63
	.loc	10 68 10
	mov	v9.d[1], v11.d[0]
	mov	v10.d[1], v12.d[0]
	.loc	10 67 10
	mov	v25.d[1], v8.d[0]
	.loc	10 55 10
	smulh	x16, x16, x15
	sub	x9, x9, x13
	ldr	x13, [sp, #80]
	.loc	10 67 10
	mov	v29.d[1], v31.d[0]
	.loc	10 55 10
	lsr	x17, x16, #5
	madd	x9, x9, x14, x11
	add	x16, x17, x16, lsr #63
	mov	w17, #448
	.loc	10 68 10
	uzp1	v31.4s, v9.4s, v10.4s
	.loc	10 55 10
	madd	x9, x12, x17, x9
	lsr	x17, x10, #5
	add	x10, x17, x10, lsr #63
	ldur	x17, [x29, #-80]
	sub	x13, x7, x13
	sub	x12, x25, x1
	.loc	10 61 10
	fsub	v22.4s, v24.4s, v22.4s
	.loc	10 55 10
	madd	x12, x12, x14, x11
	.loc	10 64 10
	uzp1	v24.4s, v26.4s, v28.4s
	.loc	10 55 10
	ldr	s11, [x8, x17, lsl #2]
	madd	x13, x13, x14, x11
	ldur	x17, [x29, #-96]
	mov	w14, #448
	.loc	10 67 10
	uzp1	v25.4s, v29.4s, v25.4s
	.loc	10 55 10
	madd	x10, x10, x14, x12
	.loc	10 68 10
	fmul	v26.4s, v23.4s, v31.4s
	.loc	10 55 10
	madd	x12, x16, x14, x13
	ldur	x16, [x29, #-40]
	ldr	s30, [x9, x17, lsl #2]
	.loc	10 64 10
	fmul	v23.4s, v23.4s, v24.4s
	ldur	x17, [x29, #-104]
	mov	w13, #112
	ldr	x14, [sp, #56]
	ldp	x9, x8, [x29, #-72]
	.loc	10 69 10
	fmla	v26.4s, v22.4s, v25.4s
	.loc	10 55 10
	ldr	s27, [x10, x17, lsl #2]
	ldur	x10, [x29, #-88]
	.loc	10 20 8
	add	x8, x8, #4
	add	x9, x9, #4
	cmp	x8, #52
	.loc	10 63 10
	mov	v30.d[1], v27.d[0]
	.loc	10 55 10
	ldr	s8, [x12, x10, lsl #2]
	.loc	10 63 10
	mov	v11.d[1], v8.d[0]
	uzp1	v27.4s, v11.4s, v30.4s
	.loc	10 65 10
	fmla	v23.4s, v22.4s, v27.4s
	.loc	10 70 10
	fmul	v22.4s, v26.4s, v19.s[0]
	.loc	10 71 10
	fmla	v22.4s, v23.4s, v18.s[0]
	.loc	10 20 8
	str	q22, [x14, x16]
	add	x16, x16, #16
	b.lo	.LBB9_3
	.loc	10 0 8 is_stmt 0
	ldr	x10, [sp, #48]
	.loc	10 20 8
	add	x14, x14, #904
	add	x10, x10, #1
	cmp	x10, #56
	b.ne	.LBB9_2
	.loc	10 0 8
	ldp	x9, x17, [sp, #8]
	.loc	10 20 8
	mov	w8, #7696
	movk	w8, #3, lsl #16
	add	x17, x17, #1
	add	x9, x9, x8
	cmp	x17, #64
	b.ne	.LBB9_1
	.loc	10 75 8 epilogue_begin is_stmt 1
	ldp	x20, x19, [sp, #304]
	mov	w0, wzr
	ldp	x22, x21, [sp, #288]
	ldp	x24, x23, [sp, #272]
	ldp	x26, x25, [sp, #256]
	ldp	x28, x27, [sp, #240]
	ldp	x29, x30, [sp, #224]
	ldp	d9, d8, [sp, #208]
	ldp	d11, d10, [sp, #192]
	ldr	d12, [sp, #176]
	add	sp, sp, #320
	ret
.Ltmp54:
.Lfunc_end9:
	.size	infer_dispatch_15_elementwise_broadcast_64x224x224_f32, .Lfunc_end9-infer_dispatch_15_elementwise_broadcast_64x224x224_f32
	.cfi_endproc

	.section	.text.infer_dispatch_16_conv_32x224x224x64x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_16_conv_32x224x224x64x3x3_f32,@function
infer_dispatch_16_conv_32x224x224x64x3x3_f32:
.Lfunc_begin10:
	.file	11 "dump" "configured_module_infer_dispatch_16.mlir"
	.loc	11 1 0
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #160
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp55:
	.loc	11 25 8 prologue_end
	ldr	w9, [x2]
	mov	x12, #2684354560
	.loc	11 16 8
	ldr	x14, [x1, #32]
	movk	x12, #18724, lsl #32
	movk	x12, #9362, lsl #48
	mov	w16, #52429
	mov	w13, #33792
	mov	w15, #28928
	.loc	11 25 8
	umulh	x17, x9, x12
	movk	w16, #15948, lsl #16
	.loc	11 19 8
	ldr	x1, [x14, #16]
	movk	w13, #346, lsl #16
	.loc	11 16 8
	ldp	x2, x0, [x14]
	.loc	11 25 8
	sub	w14, w17, w17, lsl #3
	umull	x15, w17, w15
	add	w9, w9, w14
	dup	v0.4s, w16
	.loc	11 19 8
	add	x13, x1, x13
	.loc	11 25 8
	lsl	w14, w9, #5
	add	x16, x15, w14, uxtw #2
	.loc	11 17 8
	add	x9, x0, #1009, lsl #12
	mov	w1, #7696
	mov	x8, xzr
	stp	x13, xzr, [sp, #56]
	.loc	11 25 8
	add	x13, x16, x2
	mov	w10, #896
	mov	w11, #904
	add	x12, sp, #64
	mov	x15, x2
	.loc	11 17 8
	add	x16, x9, #3328
	.loc	11 25 8
	add	x9, x13, #2352, lsl #12
	add	x0, sp, #128
	movk	w1, #3, lsl #16
	lsl	x2, x17, #5
	.loc	11 9 8
	str	xzr, [sp, #72]
	.loc	11 0 8 is_stmt 0
.Ltmp56:
	.p2align	4, , 8
.LBB10_1:
	.loc	11 31 8 is_stmt 1
	adrp	x13, __constant_32xf32_0
	add	x13, x13, :lo12:__constant_32xf32_0
	add	x13, x13, x8, lsl #2
	mov	w3, #4096
	movk	w3, #3, lsl #16
	mov	x4, xzr
	add	x17, x3, #3600
	ld1r	{ v1.4s }, [x13]
	madd	x5, x8, x3, x15
	ldr	x13, [sp, #56]
	madd	x6, x8, x17, x13
	mov	x17, x9
	.loc	11 0 8 is_stmt 0
.Ltmp57:
	.p2align	4, , 8
.LBB10_2:
	add	x13, x4, x2
	mov	x19, xzr
	mov	x7, x17
	madd	x3, x13, x11, x6
	madd	x20, x13, x10, x5
	add	x21, x3, #908
	.p2align	4, , 8
.LBB10_3:
	mov	x13, xzr
	.p2align	4, , 8
.LBB10_4:
	.loc	11 25 8 is_stmt 1
	ldr	s2, [x12, x13]
	str	s2, [x0, x13]
	add	x13, x13, #4
	cmp	x13, #16
	b.ne	.LBB10_4
	.loc	11 0 8 is_stmt 0
	mov	x24, xzr
	.loc	11 25 8
	orr	x23, x19, x14
	mov	x25, x16
	mov	x22, x7
	.loc	11 0 8
.Ltmp58:
	.p2align	4, , 8
.LBB10_6:
	mov	x27, xzr
	mov	x28, x25
	mov	x26, x22
	.p2align	4, , 8
.LBB10_7:
	mov	x3, xzr
	mov	x30, x26
	.p2align	4, , 8
.LBB10_8:
	ldr	s2, [x0, x3, lsl #2]
	mov	x13, xzr
	.p2align	4, , 8
.LBB10_9:
	.loc	11 25 8 is_stmt 1
	ldr	s3, [x30, x13]
	ldr	s4, [x28, x13]
	add	x13, x13, #4
	cmp	x13, #12
	.loc	11 28 10
	fmadd	s2, s3, s4, s2
	.loc	11 25 8
	b.ne	.LBB10_9
	str	s2, [x0, x3, lsl #2]
	add	x3, x3, #1
	add	x30, x30, #4
	cmp	x3, #4
	b.ne	.LBB10_8
	add	x27, x27, #1
	add	x26, x26, #904
	add	x28, x28, #12
	cmp	x27, #3
	b.ne	.LBB10_7
	add	x24, x24, #1
	add	x22, x22, x1
	add	x25, x25, #36
	cmp	x24, #64
	b.ne	.LBB10_6
	.loc	11 31 8
	ldr	q2, [sp, #128]
	lsl	x13, x23, #2
	.loc	11 25 8
	add	x3, x19, #4
	cmp	x19, #28
	add	x7, x7, #16
	mov	x19, x3
	.loc	11 33 10
	fadd	v2.4s, v1.4s, v2.4s
	.loc	11 35 10
	fcmgt	v3.4s, v2.4s, #0.0
	.loc	11 38 10
	fcmlt	v4.4s, v2.4s, #0.0
	.loc	11 35 10
	bic	v3.16b, v2.16b, v3.16b
	.loc	11 38 10
	bic	v2.16b, v2.16b, v4.16b
	.loc	11 39 10
	fmla	v2.4s, v3.4s, v0.4s
	.loc	11 31 8
	ldr	q3, [x20, x13]
	.loc	11 40 10
	fmul	v2.4s, v3.4s, v2.4s
	.loc	11 25 8
	str	q2, [x21, x13]
	b.lo	.LBB10_3
	add	x4, x4, #1
	add	x17, x17, #904
	cmp	x4, #32
	b.ne	.LBB10_2
	add	x8, x8, #1
	add	x16, x16, #2304
	cmp	x8, #32
	b.ne	.LBB10_1
	.loc	11 44 8
	mov	w0, wzr
	.loc	11 44 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp59:
.Lfunc_end10:
	.size	infer_dispatch_16_conv_32x224x224x64x3x3_f32, .Lfunc_end10-infer_dispatch_16_conv_32x224x224x64x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_17_conv_3x224x224x32x3x3_f32,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	infer_dispatch_17_conv_3x224x224x32x3x3_f32,@function
infer_dispatch_17_conv_3x224x224x32x3x3_f32:
.Lfunc_begin11:
	.file	12 "dump" "configured_module_infer_dispatch_17.mlir"
	.loc	12 1 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-96]!
	sub	x9, sp, #96
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	and	sp, x9, #0xffffffffffffffc0
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
.Ltmp60:
	.loc	12 14 8 prologue_end
	ldr	x10, [x1, #32]
	mov	x9, #2684354560
	.loc	12 23 8
	ldr	w11, [x2]
	movk	x9, #18724, lsl #32
	movk	x9, #9362, lsl #48
	mov	w13, #63044
	movk	w13, #16639, lsl #16
	mov	w12, #28928
	.loc	12 14 8
	ldp	x16, x17, [x10]
	.loc	12 23 8
	umulh	x1, x11, x9
	mov	w14, #63044
	dup	v0.4s, w13
	mov	w15, #46871
	movk	w14, #49407, lsl #16
	movk	w15, #14801, lsl #16
	sub	w13, w1, w1, lsl #3
	umull	x2, w1, w12
	.loc	12 15 8
	add	x12, x17, #1008, lsl #12
	.loc	12 23 8
	add	w13, w11, w13
	.loc	12 15 8
	add	x11, x12, #3968
	.loc	12 23 8
	lsl	w12, w13, #5
	mov	w13, #13182
	dup	v1.4s, w14
	movk	w13, #10849, lsl #16
	dup	v2.4s, w15
	mov	w14, #14335
	mov	w15, #65
	movk	w14, #44733, lsl #16
	movk	w15, #13148, lsl #16
	dup	v4.4s, w13
	mov	w13, #17226
	movk	w13, #14201, lsl #16
	mov	w0, #9664
	dup	v5.4s, w14
	mov	w14, #3565
	dup	v6.4s, w15
	mov	w15, #23004
	dup	v7.4s, w13
	mov	w13, #54232
	movk	w14, #14887, lsl #16
	movk	w15, #15264, lsl #16
	movk	w13, #13728, lsl #16
	movk	w0, #42399, lsl #16
	.loc	12 16 8
	ldp	x9, x10, [x10, #16]
	dup	v16.4s, w14
	mov	w14, #38358
	dup	v17.4s, w15
	mov	w15, #43525
	dup	v18.4s, w13
	mov	w13, #23005
	movk	w14, #14584, lsl #16
	movk	w15, #15124, lsl #16
	movk	w13, #15264, lsl #16
	dup	v3.4s, w0
	.loc	12 23 8
	add	x17, x2, w12, uxtw #2
	mov	w0, #7696
	dup	v19.4s, w14
	mov	w14, #33792
	dup	v20.4s, w15
	movk	w14, #346, lsl #16
	dup	v21.4s, w13
	add	x14, x16, x14
	mov	x8, xzr
	add	x13, x17, x14
	mov	w14, #50176
	mov	w15, #224
	mov	x16, sp
	add	x17, sp, #64
	movk	w0, #3, lsl #16
	adrp	x2, __constant_3xf32
	add	x2, x2, :lo12:__constant_3xf32
	lsl	x1, x1, #5
	.loc	12 9 8
	stp	xzr, xzr, [sp]
	.loc	12 0 8 is_stmt 0
.Ltmp61:
	.p2align	4, , 8
.LBB11_1:
	.loc	12 29 8 is_stmt 1
	add	x5, x2, x8, lsl #2
	mul	x4, x8, x14
	mov	x3, xzr
	ld1r	{ v22.4s }, [x5]
	mov	x5, x13
	.loc	12 0 8 is_stmt 0
.Ltmp62:
	.p2align	4, , 8
.LBB11_2:
	add	x7, x3, x1
	mov	x6, xzr
	mov	x19, x5
	madd	x7, x7, x15, x4
	.p2align	4, , 8
.LBB11_3:
	mov	x20, xzr
	.p2align	4, , 8
.LBB11_4:
	.loc	12 23 8 is_stmt 1
	ldr	s23, [x16, x20]
	str	s23, [x17, x20]
	add	x20, x20, #4
	cmp	x20, #16
	b.ne	.LBB11_4
	.loc	12 0 8 is_stmt 0
	mov	x21, xzr
	.loc	12 23 8
	orr	x20, x6, x12
	mov	x22, x11
	mov	x23, x19
	.loc	12 0 8
.Ltmp63:
	.p2align	4, , 8
.LBB11_6:
	mov	x24, xzr
	mov	x25, x22
	mov	x26, x23
	.p2align	4, , 8
.LBB11_7:
	mov	x27, xzr
	mov	x28, x26
	.p2align	4, , 8
.LBB11_8:
	ldr	s23, [x17, x27, lsl #2]
	mov	x30, xzr
	.p2align	4, , 8
.LBB11_9:
	.loc	12 23 8 is_stmt 1
	ldr	s24, [x28, x30]
	ldr	s25, [x25, x30]
	add	x30, x30, #4
	cmp	x30, #12
	.loc	12 26 10
	fmadd	s23, s24, s25, s23
	.loc	12 23 8
	b.ne	.LBB11_9
	str	s23, [x17, x27, lsl #2]
	add	x27, x27, #1
	add	x28, x28, #4
	cmp	x27, #4
	b.ne	.LBB11_8
	add	x24, x24, #1
	add	x26, x26, #904
	add	x25, x25, #12
	cmp	x24, #3
	b.ne	.LBB11_7
	add	x21, x21, #1
	add	x23, x23, x0
	add	x22, x22, #36
	cmp	x21, #32
	b.ne	.LBB11_6
	.loc	12 29 8
	ldr	q23, [sp, #64]
	.loc	12 32 10
	mov	v26.16b, v4.16b
	mov	v27.16b, v5.16b
	.loc	12 29 8
	add	x20, x7, x20
	.loc	12 32 10
	mov	v28.16b, v16.16b
	.loc	12 29 8
	lsl	x20, x20, #2
	.loc	12 23 8
	add	x21, x6, #4
	cmp	x6, #28
	.loc	12 31 10
	fadd	v23.4s, v22.4s, v23.4s
	.loc	12 23 8
	add	x19, x19, #16
	mov	x6, x21
	.loc	12 32 10
	fcmge	v24.4s, v23.4s, v0.4s
	bsl	v24.16b, v0.16b, v23.16b
	fabs	v23.4s, v23.4s
	fcmge	v25.4s, v1.4s, v24.4s
	fcmgt	v23.4s, v2.4s, v23.4s
	bit	v24.16b, v1.16b, v25.16b
	fmul	v25.4s, v24.4s, v24.4s
	fmla	v26.4s, v3.4s, v25.4s
	fmla	v27.4s, v26.4s, v25.4s
	mov	v26.16b, v6.16b
	fmla	v26.4s, v27.4s, v25.4s
	mov	v27.16b, v7.16b
	fmla	v27.4s, v26.4s, v25.4s
	mov	v26.16b, v19.16b
	fmla	v26.4s, v18.4s, v25.4s
	fmla	v28.4s, v27.4s, v25.4s
	mov	v27.16b, v20.16b
	fmla	v27.4s, v26.4s, v25.4s
	mov	v26.16b, v17.16b
	fmla	v26.4s, v28.4s, v25.4s
	mov	v28.16b, v21.16b
	fmla	v28.4s, v27.4s, v25.4s
	fmul	v25.4s, v24.4s, v26.4s
	fdiv	v25.4s, v25.4s, v28.4s
	bsl	v23.16b, v24.16b, v25.16b
	.loc	12 29 8
	ldr	q24, [x9, x20]
	.loc	12 33 10
	fadd	v23.4s, v24.4s, v23.4s
	.loc	12 23 8
	str	q23, [x10, x20]
	b.lo	.LBB11_3
	add	x3, x3, #1
	add	x5, x5, #904
	cmp	x3, #32
	b.ne	.LBB11_2
	add	x8, x8, #1
	add	x11, x11, #1152
	cmp	x8, #3
	b.ne	.LBB11_1
	.loc	12 37 8
	mov	w0, wzr
	.loc	12 37 8 epilogue_begin is_stmt 0
	mov	sp, x29
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ret
.Ltmp64:
.Lfunc_end11:
	.size	infer_dispatch_17_conv_3x224x224x32x3x3_f32, .Lfunc_end11-infer_dispatch_17_conv_3x224x224x32x3x3_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.p2align	2
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin12:
	.cfi_startproc
	adrp	x8, iree_hal_executable_library_query_v0
	add	x8, x8, :lo12:iree_hal_executable_library_query_v0
	cmp	w0, #6
	csel	x0, x8, xzr, eq
	ret
.Lfunc_end12:
	.size	iree_hal_executable_library_query, .Lfunc_end12-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end12-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin13:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB13_2
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
.LBB13_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end13:
	.size	iree_h2f_ieee, .Lfunc_end13-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin14:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB14_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB14_4
	cbz	w10, .LBB14_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB14_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB14_7
	mov	w9, #31744
.LBB14_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB14_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB14_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB14_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB14_10:
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
.Lfunc_end14:
	.size	iree_f2h_ieee, .Lfunc_end14-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin15:
	.cfi_startproc
	and	w8, w0, #0x3ff
	and	w10, w0, #0x80000000
	ands	w9, w0, #0x7c00
	b.eq	.LBB15_2
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
.LBB15_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end15:
	.size	__gnu_h2f_ieee, .Lfunc_end15-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin16:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB16_2
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
.LBB16_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	ret
.Lfunc_end16:
	.size	__extendhfsf2, .Lfunc_end16-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin17:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB17_6
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB17_4
	cbz	w10, .LBB17_9
	orr	w8, w8, #0x7fff
	sxth	w0, w8
	ret
.LBB17_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB17_7
	mov	w9, #31744
.LBB17_6:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB17_7:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB17_10
	and	w8, w8, #0x8000
	mov	w8, w8
	sxth	w0, w8
	ret
.LBB17_9:
	mov	w9, #31744
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sxth	w0, w8
	ret
.LBB17_10:
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
.Lfunc_end17:
	.size	__gnu_f2h_ieee, .Lfunc_end17-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin18:
	.cfi_startproc
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB18_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB18_4
	cbz	w10, .LBB18_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB18_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB18_6
.LBB18_5:
	mov	w9, #31744
	b	.LBB18_9
.LBB18_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB18_8
	mov	w9, wzr
	b	.LBB18_9
.LBB18_8:
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
.LBB18_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end18:
	.size	__truncsfhf2, .Lfunc_end18-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin19:
	.cfi_startproc
	fmov	w11, s0
	lsl	w9, w11, #16
	and	w8, w11, #0x3ff
	and	w10, w9, #0x80000000
	ands	w9, w11, #0x7c00
	b.eq	.LBB19_2
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
.LBB19_2:
	mov	w9, #864026624
	ucvtf	s0, w8
	orr	w9, w10, w9
	fmov	s1, w9
	fmul	s0, s0, s1
	fcvt	d0, s0
	ret
.Lfunc_end19:
	.size	__extendhfdf2, .Lfunc_end19-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin20:
	.cfi_startproc
	fcvt	s0, d0
	fmov	w11, s0
	ands	w9, w11, #0x7f800000
	lsr	w8, w11, #16
	b.eq	.LBB20_9
	and	w10, w11, #0x7fffff
	mov	w12, #2139095040
	cmp	w9, w12
	b.ne	.LBB20_4
	cbz	w10, .LBB20_5
	orr	w8, w8, #0x7fff
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.LBB20_4:
	mov	w12, #1191182336
	cmp	w9, w12
	b.ls	.LBB20_6
.LBB20_5:
	mov	w9, #31744
	b	.LBB20_9
.LBB20_6:
	lsr	w9, w9, #23
	cmp	w9, #113
	b.hs	.LBB20_8
	mov	w9, wzr
	b	.LBB20_9
.LBB20_8:
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
.LBB20_9:
	and	w8, w8, #0x8000
	orr	w8, w9, w8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strh	w8, [sp, #12]
	ldr	s0, [sp, #12]
	add	sp, sp, #16
	ret
.Lfunc_end20:
	.size	__truncdfhf2, .Lfunc_end20-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin21:
	.cfi_startproc
	fmadd	d0, d0, d1, d2
	ret
.Lfunc_end21:
	.size	fma, .Lfunc_end21-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin22:
	.cfi_startproc
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	ret
.Lfunc_end22:
	.size	__math_invalidf, .Lfunc_end22-__math_invalidf
	.cfi_endproc

	.section	.text.__math_oflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin23:
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
.Lfunc_end23:
	.size	__math_oflowf, .Lfunc_end23-__math_oflowf
	.cfi_endproc

	.section	.text.__math_xflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin24:
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
.Lfunc_end24:
	.size	__math_xflowf, .Lfunc_end24-__math_xflowf
	.cfi_endproc

	.section	.text.__math_uflowf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin25:
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
.Lfunc_end25:
	.size	__math_uflowf, .Lfunc_end25-__math_uflowf
	.cfi_endproc

	.section	.text.ceilf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin26:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB26_6
	cmp	w9, #127
	b.lo	.LBB26_4
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB26_6
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
.LBB26_4:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s1, s0, s1
	str	s1, [sp, #12]
	tbnz	w8, #31, .LBB26_7
	fmov	s1, #1.00000000
	cmp	w8, #0
	fcsel	s0, s0, s1, eq
.LBB26_6:
	add	sp, sp, #16
	ret
.LBB26_7:
	movi	v0.2s, #128, lsl #24
	add	sp, sp, #16
	ret
.Lfunc_end26:
	.size	ceilf, .Lfunc_end26-ceilf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI27_0:
	.xword	0x40471547652b82fe
.LCPI27_1:
	.xword	0x3f2ebfce50fac4f3
.LCPI27_2:
	.xword	0x3ebc6af84b912394
.LCPI27_3:
	.xword	0x3f962e42ff0c52d6
	.section	.text.expf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin27:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w8, w8, #20, #11
	cmp	w8, #1067
	b.hs	.LBB27_3
.LBB27_1:
	adrp	x8, .LCPI27_0
	fcvt	d0, s0
	adrp	x9, .LCPI27_2
	adrp	x10, .LCPI27_3
	ldr	d1, [x8, :lo12:.LCPI27_0]
	mov	x8, #4843621399236968448
	ldr	d4, [x9, :lo12:.LCPI27_2]
	ldr	d5, [x10, :lo12:.LCPI27_3]
	adrp	x10, __exp2f_data
	add	x10, x10, :lo12:__exp2f_data
	fmul	d0, d0, d1
	fmov	d1, x8
	mov	x8, #-4379750637617807360
	fmov	d2, x8
	adrp	x8, .LCPI27_1
	fadd	d1, d0, d1
	ldr	d3, [x8, :lo12:.LCPI27_1]
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
.LBB27_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB27_3:
	mov	w9, #-8388608
	fmov	s1, w9
	fcmp	s0, s1
	movi	d1, #0000000000000000
	b.eq	.LBB27_2
	cmp	w8, #2040
	b.hs	.LBB27_7
	mov	w8, #29207
	movk	w8, #17073, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.le	.LBB27_8
	mov	w8, #1879048192
	movi	v0.2s, #112, lsl #24
	str	w8, [sp, #8]
	ldr	s1, [sp, #8]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB27_7:
	fadd	s1, s0, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB27_8:
	mov	w8, #61876
	movk	w8, #49871, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.pl	.LBB27_1
	mov	w8, #268435456
	movi	v0.2s, #16, lsl #24
	str	w8, [sp, #12]
	ldr	s1, [sp, #12]
	fmul	s1, s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end27:
	.size	expf, .Lfunc_end27-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin28:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end28:
	.size	feclearexcept, .Lfunc_end28-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin29:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end29:
	.size	feraiseexcept, .Lfunc_end29-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin30:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end30:
	.size	fetestexcept, .Lfunc_end30-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin31:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end31:
	.size	fegetround, .Lfunc_end31-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin32:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end32:
	.size	__fesetround, .Lfunc_end32-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin33:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end33:
	.size	fegetenv, .Lfunc_end33-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin34:
	.cfi_startproc
	mov	w0, wzr
	ret
.Lfunc_end34:
	.size	fesetenv, .Lfunc_end34-fesetenv
	.cfi_endproc

	.section	.text.floorf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin35:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.ls	.LBB35_3
	fmov	s1, s0
.LBB35_2:
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB35_3:
	cmp	w9, #127
	b.lo	.LBB35_6
	sub	w9, w9, #127
	mov	w10, #8388607
	lsr	w10, w10, w9
	tst	w10, w8
	b.eq	.LBB35_9
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
.LBB35_6:
	mov	w9, #2071986176
	fmov	s1, w9
	fadd	s2, s0, s1
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	tbz	w8, #31, .LBB35_2
	fcmp	s0, #0.0
	fmov	s1, s0
	b.eq	.LBB35_2
	fmov	s1, #-1.00000000
	fmov	s0, s1
	add	sp, sp, #16
	ret
.LBB35_9:
	fmov	s1, s0
	fmov	s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end35:
	.size	floorf, .Lfunc_end35-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin36:
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
	b.eq	.LBB36_3
	fsub	d3, d0, d1
	fsub	d4, d0, d2
	fcmp	d3, d2
	fccmp	d4, d1, #0, eq
	b.eq	.LBB36_3
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
.LBB36_3:
	fcvt	s0, d0
	ret
.Lfunc_end36:
	.size	fmaf, .Lfunc_end36-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin37:
	.cfi_startproc
	fmov	w12, s1
	lsl	w10, w12, #1
	cbz	w10, .LBB37_8
	fmov	w8, s1
	mov	w9, #2139095040
	and	w8, w8, #0x7fffffff
	cmp	w8, w9
	b.hi	.LBB37_8
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB37_8
	lsl	w11, w9, #1
	cmp	w11, w10
	b.ls	.LBB37_9
	ubfx	w11, w12, #23, #8
	cbz	w8, .LBB37_10
	mov	w10, #8388608
	bfxil	w10, w9, #0, #23
	cbz	w11, .LBB37_13
.LBB37_6:
	mov	w13, #8388608
	bfxil	w13, w12, #0, #23
	cmp	w8, w11
	b.gt	.LBB37_17
.LBB37_7:
	subs	w11, w10, w13
	b.pl	.LBB37_20
	b	.LBB37_21
.LBB37_8:
	fmul	s0, s0, s1
	fdiv	s0, s0, s0
	ret
.LBB37_9:
	movi	d1, #0000000000000000
	fmul	s1, s0, s1
	fcsel	s0, s1, s0, eq
	ret
.LBB37_10:
	mov	w8, wzr
	lsl	w10, w9, #9
	tbnz	w10, #31, .LBB37_12
	.p2align	4, , 8
.LBB37_11:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	tbz	w10, #31, .LBB37_11
.LBB37_12:
	mov	w10, #1
	sub	w10, w10, w8
	lsl	w10, w9, w10
	cbnz	w11, .LBB37_6
.LBB37_13:
	mov	w11, wzr
	lsl	w13, w12, #9
	tbnz	w13, #31, .LBB37_15
	.p2align	4, , 8
.LBB37_14:
	sub	w11, w11, #1
	lsl	w13, w13, #1
	tbz	w13, #31, .LBB37_14
.LBB37_15:
	mov	w13, #1
	sub	w13, w13, w11
	lsl	w13, w12, w13
	cmp	w8, w11
	b.gt	.LBB37_17
	b	.LBB37_7
	.p2align	4, , 8
.LBB37_16:
	sub	w8, w8, #1
	lsl	w10, w10, #1
	cmp	w8, w11
	b.le	.LBB37_19
.LBB37_17:
	subs	w12, w10, w13
	b.mi	.LBB37_16
	mov	w10, w12
	cbnz	w12, .LBB37_16
	b	.LBB37_24
.LBB37_19:
	mov	w8, w11
	subs	w11, w10, w13
	b.mi	.LBB37_21
.LBB37_20:
	mov	w10, w11
	cbz	w11, .LBB37_24
.LBB37_21:
	and	w9, w9, #0x80000000
	lsr	w11, w10, #23
	cbnz	w11, .LBB37_23
	.p2align	4, , 8
.LBB37_22:
	sub	w8, w8, #1
	cmp	w10, #1024, lsl #12
	lsl	w10, w10, #1
	b.lo	.LBB37_22
.LBB37_23:
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
.LBB37_24:
	movi	d1, #0000000000000000
	fmul	s0, s0, s1
	ret
.Lfunc_end37:
	.size	fmodf, .Lfunc_end37-fmodf
	.cfi_endproc

	.section	.text.frexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin38:
	.cfi_startproc
	fmov	w9, s0
	ubfx	w8, w9, #23, #8
	cmp	w8, #255
	b.eq	.LBB38_7
	cbnz	w8, .LBB38_4
	fcmp	s0, #0.0
	b.eq	.LBB38_5
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
	b	.LBB38_6
.LBB38_4:
	and	w9, w9, #0x807fffff
	sub	w8, w8, #126
	orr	w9, w9, #0x3f000000
	fmov	s0, w9
	b	.LBB38_6
.LBB38_5:
	mov	w8, wzr
.LBB38_6:
	str	w8, [x0]
.LBB38_7:
	ret
.Lfunc_end38:
	.size	frexpf, .Lfunc_end38-frexpf
	.cfi_endproc

	.section	.text.ldexpf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin39:
	.cfi_startproc
	cmp	w0, #128
	b.lt	.LBB39_4
	movi	v1.2s, #127, lsl #24
	cmp	w0, #255
	fmul	s0, s0, s1
	b.lo	.LBB39_7
	cmp	w0, #381
	mov	w8, #381
	csel	w8, w0, w8, lo
	fmul	s0, s0, s1
	sub	w0, w8, #254
.LBB39_3:
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB39_4:
	cmn	w0, #127
	b.gt	.LBB39_3
	mov	w8, #209715200
	cmn	w0, #229
	fmov	s1, w8
	fmul	s0, s0, s1
	b.hi	.LBB39_8
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
.LBB39_7:
	sub	w0, w0, #127
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB39_8:
	add	w0, w0, #102
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.Lfunc_end39:
	.size	ldexpf, .Lfunc_end39-ldexpf
	.cfi_endproc

	.section	.text.scalbnf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin40:
	.cfi_startproc
	cmp	w0, #128
	b.lt	.LBB40_4
	movi	v1.2s, #127, lsl #24
	cmp	w0, #255
	fmul	s0, s0, s1
	b.lo	.LBB40_7
	cmp	w0, #381
	mov	w8, #381
	csel	w8, w0, w8, lo
	fmul	s0, s0, s1
	sub	w0, w8, #254
.LBB40_3:
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB40_4:
	cmn	w0, #127
	b.gt	.LBB40_3
	mov	w8, #209715200
	cmn	w0, #229
	fmov	s1, w8
	fmul	s0, s0, s1
	b.hi	.LBB40_8
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
.LBB40_7:
	sub	w0, w0, #127
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.LBB40_8:
	add	w0, w0, #102
	mov	w8, #1065353216
	add	w8, w8, w0, lsl #23
	fmov	s1, w8
	fmul	s0, s0, s1
	ret
.Lfunc_end40:
	.size	scalbnf, .Lfunc_end40-scalbnf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI41_0:
	.xword	0xbfd71969a075c67a
.LCPI41_1:
	.xword	0x3fd27616c9496e0b
.LCPI41_2:
	.xword	0xbfe7154748bef6c8
.LCPI41_3:
	.xword	0x3fdec70a6ca7badd
.LCPI41_4:
	.xword	0x3ff71547652ab82b
.LCPI41_5:
	.xword	0x405fffffffd1d571
.LCPI41_6:
	.xword	0x3fcebfce50fac4f3
.LCPI41_7:
	.xword	0x3fac6af84b912394
.LCPI41_8:
	.xword	0x3fe62e42ff0c52d6
	.section	.text.powf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin41:
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
	b.lo	.LBB41_6
	mov	w11, #16777216
	add	w12, w10, w11
	cmp	w12, w11
	b.ls	.LBB41_6
	mov	w8, wzr
.LBB41_3:
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
	adrp	x11, .LCPI41_4
	scvtf	d4, w10
	adrp	x10, .LCPI41_3
	ldp	d3, d5, [x9]
	adrp	x9, .LCPI41_2
	fcvt	d0, s0
	fmadd	d0, d0, d3, d2
	fadd	d3, d5, d4
	ldr	d2, [x9, :lo12:.LCPI41_2]
	adrp	x9, .LCPI41_0
	ldr	d4, [x10, :lo12:.LCPI41_3]
	adrp	x10, .LCPI41_1
	ldr	d5, [x11, :lo12:.LCPI41_4]
	ldr	d6, [x10, :lo12:.LCPI41_1]
	mov	x10, #1
	movk	x10, #16479, lsl #48
	fmadd	d2, d0, d4, d2
	fmadd	d3, d0, d5, d3
	ldr	d5, [x9, :lo12:.LCPI41_0]
	fmul	d4, d0, d0
	fmadd	d0, d0, d6, d5
	fmadd	d7, d2, d4, d3
	fmul	d3, d4, d4
	fmadd	d7, d0, d3, d7
	fmul	d0, d7, d1
	fmov	x9, d0
	and	x9, x9, #0x7fff800000000000
	cmp	x9, x10
	b.hs	.LBB41_11
.LBB41_4:
	mov	x9, #4821103401100115968
	adrp	x10, .LCPI41_7
	adrp	x11, .LCPI41_8
	fmov	d1, x9
	mov	x9, #-4402268635754659840
	ldr	d4, [x10, :lo12:.LCPI41_7]
	ldr	d5, [x11, :lo12:.LCPI41_8]
	adrp	x11, __exp2f_data
	add	x11, x11, :lo12:__exp2f_data
	fmov	d2, x9
	adrp	x9, .LCPI41_6
	fadd	d1, d0, d1
	ldr	d3, [x9, :lo12:.LCPI41_6]
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
.LBB41_5:
	add	sp, sp, #16
	ret
.LBB41_6:
	mov	w11, #-16777217
	sub	w12, w10, #1
	cmp	w12, w11
	b.hs	.LBB41_22
	lsl	w10, w9, #1
	sub	w10, w10, #1
	cmp	w10, w11
	b.hs	.LBB41_28
	tbnz	w9, #31, .LBB41_13
	mov	w8, wzr
	lsr	w10, w9, #23
	cbnz	w10, .LBB41_3
.LBB41_10:
	movi	v2.2s, #75, lsl #24
	mov	w10, #-192937984
	fmul	s0, s0, s2
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	add	w9, w9, w10
	b	.LBB41_3
.LBB41_11:
	adrp	x9, .LCPI41_5
	ldr	d1, [x9, :lo12:.LCPI41_5]
	fcmp	d0, d1
	b.le	.LBB41_16
	movi	v0.2s, #240, lsl #24
	cmp	w8, #0
	movi	v1.2s, #112, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #8]
	ldr	s0, [sp, #8]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB41_13:
	ubfx	w9, w8, #23, #8
	cmp	w9, #127
	b.lo	.LBB41_19
	cmp	w9, #150
	b.ls	.LBB41_18
.LBB41_15:
	mov	w8, wzr
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB41_3
	b	.LBB41_10
.LBB41_16:
	mov	x9, #211106232532992
	movk	x9, #49250, lsl #48
	fmov	d1, x9
	fcmp	d0, d1
	b.hi	.LBB41_4
	movi	v0.2s, #144, lsl #24
	cmp	w8, #0
	movi	v1.2s, #16, lsl #24
	fcsel	s0, s1, s0, eq
	str	s0, [sp, #12]
	ldr	s0, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB41_18:
	mov	w10, #150
	sub	w9, w10, w9
	mov	w10, #1
	lsl	w9, w10, w9
	sub	w10, w9, #1
	tst	w10, w8
	b.eq	.LBB41_20
.LBB41_19:
	fsub	s0, s0, s0
	fdiv	s0, s0, s0
	add	sp, sp, #16
	ret
.LBB41_20:
	tst	w9, w8
	b.eq	.LBB41_15
	mov	w8, #65536
	fmov	w9, s0
	and	w9, w9, #0x7fffffff
	lsr	w10, w9, #23
	cbnz	w10, .LBB41_3
	b	.LBB41_10
.LBB41_22:
	mov	w11, #1065353216
	cmp	w9, w11
	b.eq	.LBB41_33
	cbz	w10, .LBB41_33
	mov	w11, #-16777216
	lsl	w9, w9, #1
	cmp	w9, w11
	b.hi	.LBB41_34
	mov	w11, #-16777215
	cmp	w10, w11
	b.hs	.LBB41_34
	fmov	s0, #1.00000000
	mov	w10, #2130706432
	cmp	w9, w10
	b.eq	.LBB41_5
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
.LBB41_28:
	fmul	s0, s0, s0
	tbz	w9, #31, .LBB41_31
	ubfx	w9, w8, #23, #8
	sub	w10, w9, #151
	cmn	w10, #24
	b.lo	.LBB41_31
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
.LBB41_31:
	tbz	w8, #31, .LBB41_5
	fmov	s1, #1.00000000
	fdiv	s0, s1, s0
	str	s0, [sp, #4]
	ldr	s0, [sp, #4]
	add	sp, sp, #16
	ret
.LBB41_33:
	fmov	s0, #1.00000000
	add	sp, sp, #16
	ret
.LBB41_34:
	fadd	s0, s0, s1
	add	sp, sp, #16
	ret
.Lfunc_end41:
	.size	powf, .Lfunc_end41-powf
	.cfi_endproc

	.section	.text.rintf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin42:
	.cfi_startproc
	fmov	w8, s0
	mov	w9, #1249902592
	and	w10, w8, #0x7f000000
	cmp	w10, w9
	b.hi	.LBB42_3
	movi	v1.2s, #203, lsl #24
	cmn	w8, #1
	movi	v2.2s, #75, lsl #24
	fadd	s3, s0, s1
	fadd	s0, s0, s2
	fadd	s2, s3, s2
	fadd	s0, s0, s1
	fcsel	s0, s0, s2, gt
	fcmp	s0, #0.0
	b.ne	.LBB42_3
	movi	v0.2s, #128, lsl #24
	cmn	w8, #1
	movi	d1, #0000000000000000
	fcsel	s0, s1, s0, gt
.LBB42_3:
	ret
.Lfunc_end42:
	.size	rintf, .Lfunc_end42-rintf
	.cfi_endproc

	.section	.text.roundf,"ax",@progbits
	.p2align	2
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin43:
	.cfi_startproc
	fmov	w8, s0
	ubfx	w9, w8, #23, #8
	cmp	w9, #149
	b.hi	.LBB43_9
	fabs	s1, s0
	cmp	w9, #125
	movi	v2.2s, #75, lsl #24
	fadd	s2, s1, s2
	b.hi	.LBB43_3
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	movi	d1, #0000000000000000
	str	s2, [sp, #12]
	fmul	s0, s0, s1
	add	sp, sp, #16
	ret
.LBB43_3:
	movi	v0.2s, #203, lsl #24
	fadd	s0, s2, s0
	fmov	s2, #0.50000000
	fsub	s0, s0, s1
	fcmp	s0, s2
	b.le	.LBB43_5
	fadd	s0, s1, s0
	fmov	s1, #-1.00000000
	b	.LBB43_7
.LBB43_5:
	fmov	s2, #-0.50000000
	fcmp	s0, s2
	fadd	s0, s1, s0
	b.hi	.LBB43_8
	fmov	s1, #1.00000000
.LBB43_7:
	fadd	s0, s0, s1
.LBB43_8:
	fneg	s1, s0
	cmp	w8, #0
	fcsel	s0, s1, s0, mi
.LBB43_9:
	ret
.Lfunc_end43:
	.size	roundf, .Lfunc_end43-roundf
	.cfi_endproc

	.type	__constant_32xf32,@object
	.section	.rodata.__constant_32xf32,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32:
	.word	0xbcd5fc58
	.word	0x3cf7803e
	.word	0x3ca1b2dd
	.word	0x3cf05d6e
	.word	0xbbff39d6
	.word	0x3de2eea7
	.word	0x3cb5f8b6
	.word	0x3d8b7cc4
	.word	0x3c5fa8ea
	.word	0xbbc946e0
	.word	0x3bfff70e
	.word	0xbc55e8c5
	.word	0xbc602bd2
	.word	0x3cd6a284
	.word	0x3c1bbfd6
	.word	0x3c0d70d4
	.word	0xbc1c477c
	.word	0x3d708a93
	.word	0xbc1887d2
	.word	0x3d59034a
	.word	0x3c1fc0e0
	.word	0x3c99f60e
	.word	0x3b52e569
	.word	0x3b03444c
	.word	0x3ca183ee
	.word	0xbaa71422
	.word	0x3c76d391
	.word	0x3d41344f
	.word	0xba3cdf21
	.word	0xbb6a9030
	.word	0x3e0d7bd8
	.word	0x3dc3d86f
	.size	__constant_32xf32, 128

	.type	__constant_64xf32,@object
	.section	.rodata.__constant_64xf32,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32:
	.word	0x3cc56444
	.word	0x3cecf3c4
	.word	0xbc040513
	.word	0x3cb61df6
	.word	0xbc088408
	.word	0x3d40f780
	.word	0x3cef0788
	.word	0x3bd73611
	.word	0x3c0d92dc
	.word	0x3b1baed3
	.word	0xbbb9a5a6
	.word	0x3d28683c
	.word	0x3d356ae5
	.word	0x3c164802
	.word	0xbb00d7fe
	.word	0x3d1b5434
	.word	0x3d3246e7
	.word	0x3bbe04cc
	.word	0xbba16c8e
	.word	0x3d416fc2
	.word	0xbcd15668
	.word	0xbbd37a60
	.word	0x3c85d687
	.word	0xbcaffc7e
	.word	0x3c654d0c
	.word	0xbc8e5f90
	.word	0x3d195424
	.word	0x3c08c452
	.word	0x3a8ddeb6
	.word	0xbcc44740
	.word	0x3c3b3df9
	.word	0x3c6360c6
	.word	0xbc19d162
	.word	0xbb4d8c2a
	.word	0x3affb942
	.word	0x3c916916
	.word	0x3d0f932e
	.word	0x3d0a1a57
	.word	0x3c96df06
	.word	0xbabdd684
	.word	0x3c8c4c9c
	.word	0x3bd4e388
	.word	0x38f20739
	.word	0x3b1f4456
	.word	0x3cd2fe07
	.word	0xbbb2e5b8
	.word	0x3d0c4136
	.word	0xbb53024e
	.word	0xbb269eba
	.word	0x3c69f488
	.word	0x3c91727c
	.word	0x3cd25be2
	.word	0x3d3006de
	.word	0x3b65f7b6
	.word	0x3c8f5580
	.word	0xbca7d635
	.word	0x3c721133
	.word	0x3c98f23c
	.word	0x3c4ba48e
	.word	0x3c7b6248
	.word	0x3c79d348
	.word	0x3c1938c6
	.word	0x3d247520
	.word	0xbb6bc48a
	.size	__constant_64xf32, 256

	.type	__constant_64xf32_0,@object
	.section	.rodata.__constant_64xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32_0:
	.word	0xbca7ae46
	.word	0x3c7557aa
	.word	0x3ccd6cac
	.word	0xbd0a7db5
	.word	0x3cfc2965
	.word	0x3c913f87
	.word	0xbb79da80
	.word	0xbd0d65ec
	.word	0x3d0011a5
	.word	0xbc6cdf0a
	.word	0xbc8a6f6d
	.word	0xbbc46261
	.word	0x3cd29564
	.word	0xbc6b96de
	.word	0x3c99cda8
	.word	0xbce17d84
	.word	0x3d01c31b
	.word	0xbb3b9b2a
	.word	0xbcf2b65b
	.word	0xbd084d19
	.word	0x3d0e370c
	.word	0xbb33413f
	.word	0x3d066095
	.word	0x3d0641fa
	.word	0xbcc9926d
	.word	0x3b9b147e
	.word	0xbbf22d78
	.word	0xbbd0efb5
	.word	0xbcfe3d8f
	.word	0xbbd8f8b2
	.word	0x3d07533a
	.word	0xbbbd08bc
	.word	0x3d33efee
	.word	0xbcd55d57
	.word	0xbc913cb7
	.word	0xbcd221b6
	.word	0x3cc47802
	.word	0xbd0c60cf
	.word	0x3ac6aa94
	.word	0x398d6338
	.word	0x3c1793b0
	.word	0x3cfce19e
	.word	0x3ca8b1e8
	.word	0x3cb47af2
	.word	0x3b324338
	.word	0x3d16c4ea
	.word	0xbd230818
	.word	0x3c6c7954
	.word	0x3d6d8660
	.word	0x3cae9eb1
	.word	0x3b5fcdf4
	.word	0xbc12c980
	.word	0xbc41a406
	.word	0x3cc1e168
	.word	0x3cdf6354
	.word	0xbd153f96
	.word	0x3c68314f
	.word	0x3ceb1d80
	.word	0xbc9ede3c
	.word	0x3c7f3072
	.word	0x3b9f7111
	.word	0xbc6f25f6
	.word	0x3b543e8d
	.word	0x3d2701b4
	.size	__constant_64xf32_0, 256

	.type	__constant_32xf32_0,@object
	.section	.rodata.__constant_32xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_0:
	.word	0x3c530d34
	.word	0x3d469476
	.word	0x3dd952da
	.word	0x3c81795a
	.word	0x3d293d1a
	.word	0xbdb79c36
	.word	0xbc8f621c
	.word	0xbb3f2364
	.word	0xbb8da74c
	.word	0xbbbdb070
	.word	0xbd83dfe3
	.word	0x3ced0832
	.word	0x3c5222f4
	.word	0x3c37a9fc
	.word	0x3c385fde
	.word	0x3cb0a448
	.word	0xbd794c44
	.word	0x3cad7182
	.word	0xbcba0ede
	.word	0xbd9d9ec2
	.word	0x3cde70a3
	.word	0xbda2d776
	.word	0x3d3f3f57
	.word	0x3d4d289a
	.word	0xbc9a873d
	.word	0xbc34c1ec
	.word	0x3ccd9eab
	.word	0xbd39cfd2
	.word	0x3ce82422
	.word	0xbd3504d3
	.word	0xbcc0b5ae
	.word	0x3cf9ffaf
	.size	__constant_32xf32_0, 128

	.type	__constant_3xf32,@object
	.section	.rodata.__constant_3xf32,"a",@progbits
	.p2align	6, 0x0
__constant_3xf32:
	.word	0xbd46f712
	.word	0xbcdc503b
	.word	0xbb1a7082
	.size	__constant_3xf32, 12

	.type	__unnamed_1,@object
	.section	.rodata.__unnamed_1,"a",@progbits
__unnamed_1:
	.asciz	"wgan_linked"
	.size	__unnamed_1, 12

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
	.xword	infer_dispatch_0_matmul_like_32x50176x3_f32
	.xword	infer_dispatch_1_slow_memcpy
	.xword	infer_dispatch_2_conv_64x224x224x32x3x3_f32
	.xword	infer_dispatch_3_conv_128x224x224x64x3x3_f32
	.xword	infer_dispatch_4_slow_memcpy
	.xword	infer_dispatch_5_conv_128x224x224x128x3x3_f32
	.xword	infer_dispatch_6_conv_128x224x224x128x3x3_f32
	.xword	infer_dispatch_13_elementwise_broadcast_128x112x112_f32
	.xword	infer_dispatch_14_conv_64x112x112x128x3x3_f32
	.xword	infer_dispatch_15_elementwise_broadcast_64x224x224_f32
	.xword	infer_dispatch_16_conv_32x224x224x64x3x3_f32
	.xword	infer_dispatch_17_conv_3x224x224x32x3x3_f32
	.size	iree_hal_executable_library_query_v0_funcs, 96

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
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
	.xword	0
	.hword	0
	.byte	2
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
	.byte	4
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
	.byte	5
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
	.byte	4
	.word	1
	.word	1
	.hword	1
	.hword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.size	iree_hal_executable_library_query_v0_attrs, 768

	.type	__unnamed_2,@object
	.section	.rodata.__unnamed_2,"a",@progbits
__unnamed_2:
	.asciz	"infer_dispatch_0_matmul_like_32x50176x3_f32"
	.size	__unnamed_2, 44

	.type	__unnamed_3,@object
	.section	.rodata.__unnamed_3,"a",@progbits
__unnamed_3:
	.asciz	"infer_dispatch_1_slow_memcpy"
	.size	__unnamed_3, 29

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"infer_dispatch_2_conv_64x224x224x32x3x3_f32"
	.size	__unnamed_4, 44

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"infer_dispatch_3_conv_128x224x224x64x3x3_f32"
	.size	__unnamed_5, 45

	.type	__unnamed_6,@object
	.section	.rodata.__unnamed_6,"a",@progbits
__unnamed_6:
	.asciz	"infer_dispatch_4_slow_memcpy"
	.size	__unnamed_6, 29

	.type	__unnamed_7,@object
	.section	.rodata.__unnamed_7,"a",@progbits
__unnamed_7:
	.asciz	"infer_dispatch_5_conv_128x224x224x128x3x3_f32"
	.size	__unnamed_7, 46

	.type	__unnamed_8,@object
	.section	.rodata.__unnamed_8,"a",@progbits
__unnamed_8:
	.asciz	"infer_dispatch_6_conv_128x224x224x128x3x3_f32"
	.size	__unnamed_8, 46

	.type	__unnamed_9,@object
	.section	.rodata.__unnamed_9,"a",@progbits
__unnamed_9:
	.asciz	"infer_dispatch_13_elementwise_broadcast_128x112x112_f32"
	.size	__unnamed_9, 56

	.type	__unnamed_10,@object
	.section	.rodata.__unnamed_10,"a",@progbits
__unnamed_10:
	.asciz	"infer_dispatch_14_conv_64x112x112x128x3x3_f32"
	.size	__unnamed_10, 46

	.type	__unnamed_11,@object
	.section	.rodata.__unnamed_11,"a",@progbits
__unnamed_11:
	.asciz	"infer_dispatch_15_elementwise_broadcast_64x224x224_f32"
	.size	__unnamed_11, 55

	.type	__unnamed_12,@object
	.section	.rodata.__unnamed_12,"a",@progbits
__unnamed_12:
	.asciz	"infer_dispatch_16_conv_32x224x224x64x3x3_f32"
	.size	__unnamed_12, 45

	.type	__unnamed_13,@object
	.section	.rodata.__unnamed_13,"a",@progbits
__unnamed_13:
	.asciz	"infer_dispatch_17_conv_3x224x224x32x3x3_f32"
	.size	__unnamed_13, 44

	.type	iree_hal_executable_library_query_v0_names,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_names,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_names:
	.xword	__unnamed_2
	.xword	__unnamed_3
	.xword	__unnamed_4
	.xword	__unnamed_5
	.xword	__unnamed_6
	.xword	__unnamed_7
	.xword	__unnamed_8
	.xword	__unnamed_9
	.xword	__unnamed_10
	.xword	__unnamed_11
	.xword	__unnamed_12
	.xword	__unnamed_13
	.size	iree_hal_executable_library_query_v0_names, 96

	.type	__unnamed_14,@object
	.section	.rodata.__unnamed_14,"a",@progbits
__unnamed_14:
	.asciz	"dump/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_14, 45

	.type	__unnamed_15,@object
	.section	.rodata.__unnamed_15,"a",@progbits
__unnamed_15:
	.asciz	"dump/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_15, 45

	.type	__unnamed_16,@object
	.section	.rodata.__unnamed_16,"a",@progbits
__unnamed_16:
	.asciz	"dump/configured_module_infer_dispatch_2.mlir"
	.size	__unnamed_16, 45

	.type	__unnamed_17,@object
	.section	.rodata.__unnamed_17,"a",@progbits
__unnamed_17:
	.asciz	"dump/configured_module_infer_dispatch_3.mlir"
	.size	__unnamed_17, 45

	.type	__unnamed_18,@object
	.section	.rodata.__unnamed_18,"a",@progbits
__unnamed_18:
	.asciz	"dump/configured_module_infer_dispatch_4.mlir"
	.size	__unnamed_18, 45

	.type	__unnamed_19,@object
	.section	.rodata.__unnamed_19,"a",@progbits
__unnamed_19:
	.asciz	"dump/configured_module_infer_dispatch_5.mlir"
	.size	__unnamed_19, 45

	.type	__unnamed_20,@object
	.section	.rodata.__unnamed_20,"a",@progbits
__unnamed_20:
	.asciz	"dump/configured_module_infer_dispatch_6.mlir"
	.size	__unnamed_20, 45

	.type	__unnamed_21,@object
	.section	.rodata.__unnamed_21,"a",@progbits
__unnamed_21:
	.asciz	"dump/configured_module_infer_dispatch_13.mlir"
	.size	__unnamed_21, 46

	.type	__unnamed_22,@object
	.section	.rodata.__unnamed_22,"a",@progbits
__unnamed_22:
	.asciz	"dump/configured_module_infer_dispatch_14.mlir"
	.size	__unnamed_22, 46

	.type	__unnamed_23,@object
	.section	.rodata.__unnamed_23,"a",@progbits
__unnamed_23:
	.asciz	"dump/configured_module_infer_dispatch_15.mlir"
	.size	__unnamed_23, 46

	.type	__unnamed_24,@object
	.section	.rodata.__unnamed_24,"a",@progbits
__unnamed_24:
	.asciz	"dump/configured_module_infer_dispatch_16.mlir"
	.size	__unnamed_24, 46

	.type	__unnamed_25,@object
	.section	.rodata.__unnamed_25,"a",@progbits
__unnamed_25:
	.asciz	"dump/configured_module_infer_dispatch_17.mlir"
	.size	__unnamed_25, 46

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.word	3
	.word	44
	.xword	__unnamed_14
	.word	3
	.word	44
	.xword	__unnamed_15
	.word	3
	.word	44
	.xword	__unnamed_16
	.word	3
	.word	44
	.xword	__unnamed_17
	.word	3
	.word	44
	.xword	__unnamed_18
	.word	3
	.word	44
	.xword	__unnamed_19
	.word	3
	.word	44
	.xword	__unnamed_20
	.word	3
	.word	45
	.xword	__unnamed_21
	.word	3
	.word	45
	.xword	__unnamed_22
	.word	3
	.word	45
	.xword	__unnamed_23
	.word	3
	.word	45
	.xword	__unnamed_24
	.word	3
	.word	45
	.xword	__unnamed_25
	.size	iree_hal_executable_library_query_v0_source_locations, 192

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_stage_location_tables,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_stage_location_tables,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_stage_location_tables:
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations
	.word	0
	.zero	4
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names
	.xword	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 288

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.xword	iree_hal_executable_library_query_v0_header
	.zero	16
	.word	12
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
	.word	.Linfo_string14
	.word	.Linfo_string14
	.byte	1
	.byte	1
	.word	71

	.byte	3
	.word	.Linfo_string15
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
	.word	.Linfo_string16
	.word	.Linfo_string16
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
	.word	.Linfo_string17
	.word	.Linfo_string17
	.byte	3
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end2:
.Lcu_begin3:
	.word	.Ldebug_info_end3-.Ldebug_info_start3
.Ldebug_info_start3:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string5
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin3
	.word	.Lfunc_end3-.Lfunc_begin3
	.byte	4
	.xword	.Lfunc_begin3
	.word	.Lfunc_end3-.Lfunc_begin3
	.byte	1
	.byte	109
	.word	.Linfo_string18
	.word	.Linfo_string18
	.byte	4
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end3:
.Lcu_begin4:
	.word	.Ldebug_info_end4-.Ldebug_info_start4
.Ldebug_info_start4:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string6
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin4
	.word	.Lfunc_end4-.Lfunc_begin4
	.byte	4
	.xword	.Lfunc_begin4
	.word	.Lfunc_end4-.Lfunc_begin4
	.byte	1
	.byte	109
	.word	.Linfo_string19
	.word	.Linfo_string19
	.byte	5
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end4:
.Lcu_begin5:
	.word	.Ldebug_info_end5-.Ldebug_info_start5
.Ldebug_info_start5:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string7
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin5
	.word	.Lfunc_end5-.Lfunc_begin5
	.byte	4
	.xword	.Lfunc_begin5
	.word	.Lfunc_end5-.Lfunc_begin5
	.byte	1
	.byte	109
	.word	.Linfo_string20
	.word	.Linfo_string20
	.byte	6
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end5:
.Lcu_begin6:
	.word	.Ldebug_info_end6-.Ldebug_info_start6
.Ldebug_info_start6:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string8
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin6
	.word	.Lfunc_end6-.Lfunc_begin6
	.byte	4
	.xword	.Lfunc_begin6
	.word	.Lfunc_end6-.Lfunc_begin6
	.byte	1
	.byte	109
	.word	.Linfo_string21
	.word	.Linfo_string21
	.byte	7
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end6:
.Lcu_begin7:
	.word	.Ldebug_info_end7-.Ldebug_info_start7
.Ldebug_info_start7:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string9
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin7
	.word	.Lfunc_end7-.Lfunc_begin7
	.byte	4
	.xword	.Lfunc_begin7
	.word	.Lfunc_end7-.Lfunc_begin7
	.byte	1
	.byte	109
	.word	.Linfo_string22
	.word	.Linfo_string22
	.byte	8
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end7:
.Lcu_begin8:
	.word	.Ldebug_info_end8-.Ldebug_info_start8
.Ldebug_info_start8:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string10
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin8
	.word	.Lfunc_end8-.Lfunc_begin8
	.byte	4
	.xword	.Lfunc_begin8
	.word	.Lfunc_end8-.Lfunc_begin8
	.byte	1
	.byte	109
	.word	.Linfo_string23
	.word	.Linfo_string23
	.byte	9
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end8:
.Lcu_begin9:
	.word	.Ldebug_info_end9-.Ldebug_info_start9
.Ldebug_info_start9:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string11
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin9
	.word	.Lfunc_end9-.Lfunc_begin9
	.byte	4
	.xword	.Lfunc_begin9
	.word	.Lfunc_end9-.Lfunc_begin9
	.byte	1
	.byte	109
	.word	.Linfo_string24
	.word	.Linfo_string24
	.byte	10
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end9:
.Lcu_begin10:
	.word	.Ldebug_info_end10-.Ldebug_info_start10
.Ldebug_info_start10:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string12
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin10
	.word	.Lfunc_end10-.Lfunc_begin10
	.byte	4
	.xword	.Lfunc_begin10
	.word	.Lfunc_end10-.Lfunc_begin10
	.byte	1
	.byte	109
	.word	.Linfo_string25
	.word	.Linfo_string25
	.byte	11
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end10:
.Lcu_begin11:
	.word	.Ldebug_info_end11-.Ldebug_info_start11
.Ldebug_info_start11:
	.hword	4
	.word	.debug_abbrev
	.byte	8
	.byte	1
	.word	.Linfo_string0
	.hword	44
	.word	.Linfo_string13
	.word	.Lline_table_start0
	.word	.Linfo_string2

	.xword	.Lfunc_begin11
	.word	.Lfunc_end11-.Lfunc_begin11
	.byte	4
	.xword	.Lfunc_begin11
	.word	.Lfunc_end11-.Lfunc_begin11
	.byte	1
	.byte	109
	.word	.Linfo_string26
	.word	.Linfo_string26
	.byte	12
	.byte	1
	.word	.debug_info+71

	.byte	0
.Ldebug_info_end11:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"IREE"
.Linfo_string1:
	.asciz	"configured_module_infer_dispatch_0.mlir"
.Linfo_string2:
	.asciz	"dump"
.Linfo_string3:
	.asciz	"configured_module_infer_dispatch_1.mlir"
.Linfo_string4:
	.asciz	"configured_module_infer_dispatch_2.mlir"
.Linfo_string5:
	.asciz	"configured_module_infer_dispatch_3.mlir"
.Linfo_string6:
	.asciz	"configured_module_infer_dispatch_4.mlir"
.Linfo_string7:
	.asciz	"configured_module_infer_dispatch_5.mlir"
.Linfo_string8:
	.asciz	"configured_module_infer_dispatch_6.mlir"
.Linfo_string9:
	.asciz	"configured_module_infer_dispatch_13.mlir"
.Linfo_string10:
	.asciz	"configured_module_infer_dispatch_14.mlir"
.Linfo_string11:
	.asciz	"configured_module_infer_dispatch_15.mlir"
.Linfo_string12:
	.asciz	"configured_module_infer_dispatch_16.mlir"
.Linfo_string13:
	.asciz	"configured_module_infer_dispatch_17.mlir"
.Linfo_string14:
	.asciz	"infer_dispatch_0_matmul_like_32x50176x3_f32"
.Linfo_string15:
	.asciz	"int"
.Linfo_string16:
	.asciz	"infer_dispatch_1_slow_memcpy"
.Linfo_string17:
	.asciz	"infer_dispatch_2_conv_64x224x224x32x3x3_f32"
.Linfo_string18:
	.asciz	"infer_dispatch_3_conv_128x224x224x64x3x3_f32"
.Linfo_string19:
	.asciz	"infer_dispatch_4_slow_memcpy"
.Linfo_string20:
	.asciz	"infer_dispatch_5_conv_128x224x224x128x3x3_f32"
.Linfo_string21:
	.asciz	"infer_dispatch_6_conv_128x224x224x128x3x3_f32"
.Linfo_string22:
	.asciz	"infer_dispatch_13_elementwise_broadcast_128x112x112_f32"
.Linfo_string23:
	.asciz	"infer_dispatch_14_conv_64x112x112x128x3x3_f32"
.Linfo_string24:
	.asciz	"infer_dispatch_15_elementwise_broadcast_64x224x224_f32"
.Linfo_string25:
	.asciz	"infer_dispatch_16_conv_32x224x224x64x3x3_f32"
.Linfo_string26:
	.asciz	"infer_dispatch_17_conv_3x224x224x32x3x3_f32"
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.hword	2
	.word	.Lcu_begin0
	.word	79
	.word	42
	.asciz	"infer_dispatch_0_matmul_like_32x50176x3_f32"
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
	.asciz	"infer_dispatch_1_slow_memcpy"
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
	.asciz	"infer_dispatch_2_conv_64x224x224x32x3x3_f32"
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
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end3-.LpubNames_start3
.LpubNames_start3:
	.hword	2
	.word	.Lcu_begin3
	.word	72
	.word	42
	.asciz	"infer_dispatch_3_conv_128x224x224x64x3x3_f32"
	.word	0
.LpubNames_end3:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end3-.LpubTypes_start3
.LpubTypes_start3:
	.hword	2
	.word	.Lcu_begin3
	.word	72
	.word	0
.LpubTypes_end3:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end4-.LpubNames_start4
.LpubNames_start4:
	.hword	2
	.word	.Lcu_begin4
	.word	72
	.word	42
	.asciz	"infer_dispatch_4_slow_memcpy"
	.word	0
.LpubNames_end4:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end4-.LpubTypes_start4
.LpubTypes_start4:
	.hword	2
	.word	.Lcu_begin4
	.word	72
	.word	0
.LpubTypes_end4:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end5-.LpubNames_start5
.LpubNames_start5:
	.hword	2
	.word	.Lcu_begin5
	.word	72
	.word	42
	.asciz	"infer_dispatch_5_conv_128x224x224x128x3x3_f32"
	.word	0
.LpubNames_end5:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end5-.LpubTypes_start5
.LpubTypes_start5:
	.hword	2
	.word	.Lcu_begin5
	.word	72
	.word	0
.LpubTypes_end5:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end6-.LpubNames_start6
.LpubNames_start6:
	.hword	2
	.word	.Lcu_begin6
	.word	72
	.word	42
	.asciz	"infer_dispatch_6_conv_128x224x224x128x3x3_f32"
	.word	0
.LpubNames_end6:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end6-.LpubTypes_start6
.LpubTypes_start6:
	.hword	2
	.word	.Lcu_begin6
	.word	72
	.word	0
.LpubTypes_end6:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end7-.LpubNames_start7
.LpubNames_start7:
	.hword	2
	.word	.Lcu_begin7
	.word	72
	.word	42
	.asciz	"infer_dispatch_13_elementwise_broadcast_128x112x112_f32"
	.word	0
.LpubNames_end7:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end7-.LpubTypes_start7
.LpubTypes_start7:
	.hword	2
	.word	.Lcu_begin7
	.word	72
	.word	0
.LpubTypes_end7:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end8-.LpubNames_start8
.LpubNames_start8:
	.hword	2
	.word	.Lcu_begin8
	.word	72
	.word	42
	.asciz	"infer_dispatch_14_conv_64x112x112x128x3x3_f32"
	.word	0
.LpubNames_end8:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end8-.LpubTypes_start8
.LpubTypes_start8:
	.hword	2
	.word	.Lcu_begin8
	.word	72
	.word	0
.LpubTypes_end8:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end9-.LpubNames_start9
.LpubNames_start9:
	.hword	2
	.word	.Lcu_begin9
	.word	72
	.word	42
	.asciz	"infer_dispatch_15_elementwise_broadcast_64x224x224_f32"
	.word	0
.LpubNames_end9:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end9-.LpubTypes_start9
.LpubTypes_start9:
	.hword	2
	.word	.Lcu_begin9
	.word	72
	.word	0
.LpubTypes_end9:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end10-.LpubNames_start10
.LpubNames_start10:
	.hword	2
	.word	.Lcu_begin10
	.word	72
	.word	42
	.asciz	"infer_dispatch_16_conv_32x224x224x64x3x3_f32"
	.word	0
.LpubNames_end10:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end10-.LpubTypes_start10
.LpubTypes_start10:
	.hword	2
	.word	.Lcu_begin10
	.word	72
	.word	0
.LpubTypes_end10:
	.section	.debug_pubnames,"",@progbits
	.word	.LpubNames_end11-.LpubNames_start11
.LpubNames_start11:
	.hword	2
	.word	.Lcu_begin11
	.word	72
	.word	42
	.asciz	"infer_dispatch_17_conv_3x224x224x32x3x3_f32"
	.word	0
.LpubNames_end11:
	.section	.debug_pubtypes,"",@progbits
	.word	.LpubTypes_end11-.LpubTypes_start11
.LpubTypes_start11:
	.hword	2
	.word	.Lcu_begin11
	.word	72
	.word	0
.LpubTypes_end11:
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
