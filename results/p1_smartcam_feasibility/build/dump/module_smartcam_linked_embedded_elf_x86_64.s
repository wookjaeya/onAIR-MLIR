	.att_syntax
	.file	"smartcam_linked"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI0_0:
	.long	0xbf800000
	.long	0xbf800000
	.long	0xbf800000
	.long	0xbf800000
	.section	.text.infer_dispatch_0_elementwise_3x224x224_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_0_elementwise_3x224x224_f32,@function
infer_dispatch_0_elementwise_3x224x224_f32:
.Lfunc_begin0:
	.file	1 "dump" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp0:
	.loc	1 12 8 prologue_end
	movq	32(%rsi), %rsi
	.loc	1 16 8
	movl	(%rdx), %ecx
	movl	%ecx, %edx
	shrl	$2, %edx
	andl	$3, %ecx
	imulq	$50400, %rdx, %rax
	imulq	$224, %rcx, %rdi
	addq	%rdi, %rax
	addq	8(%rsi), %rax
	imulq	$50176, %rdx, %rcx
	orq	%rdi, %rcx
	addq	(%rsi), %rcx
	xorl	%edx, %edx
	movaps	.LCPI0_0(%rip), %xmm0
	.loc	1 0 8 is_stmt 0
.Ltmp1:
	.p2align	4
.LBB0_1:
	movq	%rcx, %rsi
	movq	%rax, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB0_2:
	movq	$-4, %r9
	.p2align	4
.LBB0_3:
	.loc	1 16 8 is_stmt 1
	movaps	16(%rsi,%r9,4), %xmm1
	.loc	1 18 10
	addps	%xmm1, %xmm1
	.loc	1 19 10
	addps	%xmm0, %xmm1
	.loc	1 16 8
	movups	%xmm1, 16(%rdi,%r9,4)
	addq	$4, %r9
	cmpq	$52, %r9
	jb	.LBB0_3
	incq	%r8
	addq	$900, %rdi
	addq	$896, %rsi
	cmpq	$56, %r8
	jne	.LBB0_2
	incq	%rdx
	addq	$202500, %rax
	addq	$200704, %rcx
	cmpq	$3, %rdx
	jne	.LBB0_1
	.loc	1 23 8
	xorl	%eax, %eax
	.loc	1 23 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp2:
.Lfunc_end0:
	.size	infer_dispatch_0_elementwise_3x224x224_f32, .Lfunc_end0-infer_dispatch_0_elementwise_3x224x224_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI1_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_1_conv_32x112x112x3x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_1_conv_32x112x112x3x3x3_f32,@function
infer_dispatch_1_conv_32x112x112x3x3x3_f32:
.Lfunc_begin1:
	.file	2 "dump" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp3:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$256, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	2 15 8 prologue_end
	movq	32(%rsi), %rax
	movl	$8837248, %r9d
	.loc	2 16 8
	addq	8(%rax), %r9
	movl	$607552, %ecx
	.loc	2 17 8
	addq	16(%rax), %rcx
	movq	%rcx, 80(%rsp)
	.loc	2 22 8
	movl	(%rdx), %ecx
	movl	%ecx, %edx
	shrl	$2, %edx
	andl	$3, %ecx
	leaq	(%rdx,%rdx,8), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	addq	%rdx, %rsi
	movq	%rsi, 104(%rsp)
	.loc	2 9 8
	xorps	%xmm0, %xmm0
	imulq	$224, %rcx, %rsi
	.loc	2 22 8
	imulq	$50400, %rdx, %rdx
	addq	%rsi, %rdx
	addq	(%rax), %rdx
	movq	%rdx, 72(%rsp)
	.loc	2 9 8
	movaps	%xmm0, 128(%rsp)
	imulq	$112, %rcx, %rax
	movq	%rax, 96(%rsp)
	xorl	%eax, %eax
	movaps	.LCPI1_0(%rip), %xmm0
	.loc	2 0 8 is_stmt 0
.Ltmp4:
	.p2align	4
.LBB1_1:
	leaq	__constant_32xf32(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	movq	%rax, 88(%rsp)
	imulq	$51984, %rax, %rax
	addq	80(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	72(%rsp), %r8
	xorl	%ebx, %ebx
	.p2align	4
.LBB1_2:
	movq	104(%rsp), %rax
	addq	%rbx, %rax
	imulq	$456, %rax, %rax
	addq	112(%rsp), %rax
	movq	96(%rsp), %rcx
	leaq	(%rcx,%rax), %r14
	addq	$460, %r14
	movq	%r8, 120(%rsp)
	xorl	%r12d, %r12d
	.p2align	4
.LBB1_3:
	xorl	%eax, %eax
	.p2align	4
.LBB1_4:
	.loc	2 22 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB1_4
	.loc	2 0 8 is_stmt 0
	movq	%r9, %rax
	movq	%r8, %rsi
	xorl	%ecx, %ecx
	.p2align	4
.LBB1_6:
	movq	%rax, %r13
	movq	%rsi, %r11
	xorl	%edx, %edx
	.p2align	4
.LBB1_7:
	movq	%r11, %r15
	xorl	%r10d, %r10d
	.p2align	4
.LBB1_8:
	movss	(%rsp,%r10,4), %xmm2
	xorl	%edi, %edi
	.p2align	4
.LBB1_9:
	.loc	2 22 8 is_stmt 1
	movss	(%r15,%rdi,4), %xmm3
	.loc	2 24 10
	mulss	(%r13,%rdi,4), %xmm3
	.loc	2 25 10
	addss	%xmm3, %xmm2
	.loc	2 22 8
	incq	%rdi
	cmpq	$3, %rdi
	jne	.LBB1_9
	movss	%xmm2, (%rsp,%r10,4)
	incq	%r10
	addq	$8, %r15
	cmpq	$4, %r10
	jne	.LBB1_8
	incq	%rdx
	addq	$900, %r11
	addq	$12, %r13
	cmpq	$3, %rdx
	jne	.LBB1_7
	incq	%rcx
	addq	$202500, %rsi
	addq	$36, %rax
	cmpq	$3, %rcx
	jne	.LBB1_6
	.loc	2 0 8 is_stmt 0
	movaps	(%rsp), %xmm2
	.loc	2 30 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	2 32 10
	xorps	%xmm3, %xmm3
	cmpleps	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	.loc	2 34 10
	minps	%xmm0, %xmm3
	.loc	2 22 8
	movups	%xmm3, (%r14,%r12,4)
	addq	$32, %r8
	cmpq	$24, %r12
	leaq	4(%r12), %r12
	jb	.LBB1_3
	incq	%rbx
	movq	120(%rsp), %r8
	addq	$1800, %r8
	cmpq	$28, %rbx
	jne	.LBB1_2
	.loc	2 0 8 is_stmt 0
	movq	88(%rsp), %rax
	.loc	2 22 8
	incq	%rax
	addq	$108, %r9
	cmpq	$32, %rax
	jne	.LBB1_1
	.loc	2 38 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	2 38 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp5:
.Lfunc_end1:
	.size	infer_dispatch_1_conv_32x112x112x3x3x3_f32, .Lfunc_end1-infer_dispatch_1_conv_32x112x112x3x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI2_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_2_conv_112x112x32x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_2_conv_112x112x32x3x3_f32,@function
infer_dispatch_2_conv_112x112x32x3x3_f32:
.Lfunc_begin2:
	.file	3 "dump" "configured_module_infer_dispatch_2.mlir"
	.loc	3 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp6:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$192, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	3 15 8 prologue_end
	movq	32(%rsi), %rax
	movl	$8754432, %ecx
	.loc	3 16 8
	addq	8(%rax), %rcx
	movq	%rcx, 56(%rsp)
	movl	$2271040, %ecx
	.loc	3 17 8
	addq	16(%rax), %rcx
	movq	%rcx, 24(%rsp)
	.loc	3 15 8
	movq	(%rax), %rax
	.loc	3 22 8
	movl	(%rdx), %ecx
	movl	%ecx, %edx
	shrl	$2, %edx
	andl	$3, %ecx
	leaq	(%rdx,%rdx,8), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	addq	%rdx, %rsi
	movq	%rsi, 16(%rsp)
	leaq	(%rcx,%rcx,8), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	addq	%rcx, %rsi
	movq	%rsi, 48(%rsp)
	.loc	3 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 64(%rsp)
	.loc	3 22 8
	imulq	$12768, %rdx, %rdx
	imulq	$112, %rcx, %rcx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %r8
	addq	$607552, %r8
	xorl	%ecx, %ecx
	leaq	__constant_32xf32_0(%rip), %r9
	movaps	.LCPI2_0(%rip), %xmm0
	.loc	3 0 8 is_stmt 0
.Ltmp7:
	.p2align	4
.LBB2_1:
	movq	16(%rsp), %rax
	movq	%rcx, 32(%rsp)
	addq	%rcx, %rax
	imulq	$448, %rax, %r10
	addq	24(%rsp), %r10
	movq	%r8, 40(%rsp)
	xorl	%ebx, %ebx
	.p2align	4
.LBB2_2:
	movq	48(%rsp), %rax
	.loc	3 22 8 is_stmt 1
	addq	%rbx, %rax
	leaq	(%r10,%rax,4), %r14
	movq	56(%rsp), %rax
	movq	%r8, %rdi
	xorl	%r13d, %r13d
	.loc	3 0 8 is_stmt 0
.Ltmp8:
	.p2align	4
.LBB2_3:
	xorl	%ecx, %ecx
	.p2align	4
.LBB2_4:
	.loc	3 22 8 is_stmt 1
	movss	64(%rsp,%rcx,4), %xmm1
	movss	%xmm1, (%rsp,%rcx,4)
	incq	%rcx
	cmpq	$4, %rcx
	jne	.LBB2_4
	.loc	3 0 8 is_stmt 0
	movq	%rax, %r15
	movq	%rdi, %r11
	xorl	%edx, %edx
	.p2align	4
.LBB2_6:
	movq	%r11, %r12
	xorl	%ecx, %ecx
	.p2align	4
.LBB2_7:
	movss	(%rsp,%rcx,4), %xmm1
	xorl	%esi, %esi
	.p2align	4
.LBB2_8:
	.loc	3 22 8 is_stmt 1
	movss	(%r12,%rsi,4), %xmm2
	.loc	3 24 10
	mulss	(%r15,%rsi,4), %xmm2
	.loc	3 25 10
	addss	%xmm2, %xmm1
	.loc	3 22 8
	incq	%rsi
	cmpq	$3, %rsi
	jne	.LBB2_8
	movss	%xmm1, (%rsp,%rcx,4)
	incq	%rcx
	addq	$4, %r12
	cmpq	$4, %rcx
	jne	.LBB2_7
	incq	%rdx
	addq	$456, %r11
	addq	$12, %r15
	cmpq	$3, %rdx
	jne	.LBB2_6
	.loc	3 30 10
	movss	(%r9,%r13,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	addps	(%rsp), %xmm1
	.loc	3 32 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm1, %xmm2
	andps	%xmm1, %xmm2
	.loc	3 34 10
	minps	%xmm0, %xmm2
	.loc	3 22 8
	imulq	$50176, %r13, %rcx
	movaps	%xmm2, (%r14,%rcx)
	incq	%r13
	addq	$51984, %rdi
	addq	$36, %rax
	cmpq	$32, %r13
	jne	.LBB2_3
	addq	$16, %r8
	cmpq	$24, %rbx
	leaq	4(%rbx), %rbx
	jb	.LBB2_2
	.loc	3 0 8 is_stmt 0
	movq	32(%rsp), %rcx
	.loc	3 22 8
	incq	%rcx
	movq	40(%rsp), %r8
	addq	$456, %r8
	cmpq	$28, %rcx
	jne	.LBB2_1
	.loc	3 38 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	3 38 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp9:
.Lfunc_end2:
	.size	infer_dispatch_2_conv_112x112x32x3x3_f32, .Lfunc_end2-infer_dispatch_2_conv_112x112x32x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_3_matmul_like_16x12544x32_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_3_matmul_like_16x12544x32_f32,@function
infer_dispatch_3_matmul_like_16x12544x32_f32:
.Lfunc_begin3:
	.file	4 "dump" "configured_module_infer_dispatch_3.mlir"
	.loc	4 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp10:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	4 14 8 prologue_end
	movq	32(%rsi), %rdi
	movq	(%rdi), %rsi
	.loc	4 16 8
	movq	16(%rdi), %rax
	.loc	4 21 8
	movl	(%rdx), %edx
	movq	%rdx, %rcx
	shlq	$6, %rcx
	shlq	$8, %rdx
	addq	%rsi, %rdx
	addq	$2421568, %rdx
	movl	$8496652, %esi
	addq	8(%rdi), %rsi
	xorl	%edi, %edi
	leaq	__constant_16xf32(%rip), %r8
	.loc	4 0 8 is_stmt 0
.Ltmp11:
	.p2align	4
.LBB3_1:
	.loc	4 27 8 is_stmt 1
	movss	(%r8,%rdi,4), %xmm0
	imulq	$50176, %rdi, %r9
	addq	%rax, %r9
	movq	%rdx, %r10
	xorl	%r11d, %r11d
	.loc	4 0 8 is_stmt 0
.Ltmp12:
	.p2align	4
.LBB3_2:
	.loc	4 21 8 is_stmt 1
	leaq	(%r11,%rcx), %rbx
	xorps	%xmm1, %xmm1
	movq	$-4, %r14
	movq	%r10, %r15
	.loc	4 0 8 is_stmt 0
.Ltmp13:
	.p2align	4
.LBB3_3:
	.loc	4 21 8
	movss	-150528(%r15), %xmm2
	movss	-100352(%r15), %xmm3
	.loc	4 24 10 is_stmt 1
	mulss	4(%rsi,%r14,4), %xmm2
	.loc	4 21 8
	movss	-50176(%r15), %xmm4
	.loc	4 24 10
	addss	%xmm1, %xmm2
	mulss	8(%rsi,%r14,4), %xmm3
	.loc	4 21 8
	movss	(%r15), %xmm1
	.loc	4 24 10
	addss	%xmm2, %xmm3
	mulss	12(%rsi,%r14,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rsi,%r14,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	4 21 8
	addq	$4, %r14
	addq	$200704, %r15
	cmpq	$28, %r14
	jb	.LBB3_3
	.loc	4 29 10
	addss	%xmm0, %xmm1
	.loc	4 21 8
	movss	%xmm1, (%r9,%rbx,4)
	incq	%r11
	addq	$4, %r10
	cmpq	$64, %r11
	jne	.LBB3_2
	incq	%rdi
	subq	$-128, %rsi
	cmpq	$16, %rdi
	jne	.LBB3_1
	.loc	4 33 8
	xorl	%eax, %eax
	.loc	4 33 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp14:
.Lfunc_end3:
	.size	infer_dispatch_3_matmul_like_16x12544x32_f32, .Lfunc_end3-infer_dispatch_3_matmul_like_16x12544x32_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI4_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_4_matmul_like_96x112x112x16_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_4_matmul_like_96x112x112x16_f32,@function
infer_dispatch_4_matmul_like_96x112x112x16_f32:
.Lfunc_begin4:
	.file	5 "dump" "configured_module_infer_dispatch_4.mlir"
	.loc	5 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp15:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	5 15 8 prologue_end
	movq	32(%rsi), %rax
	movl	$3876672, %ecx
	.loc	5 18 8
	addq	16(%rax), %rcx
	movq	%rcx, -56(%rbp)
	.loc	5 24 8
	movl	(%rdx), %edi
	movl	%edi, %ecx
	andl	$-2, %ecx
	shlq	$3, %rcx
	xorl	%edx, %edx
	testb	$1, %dil
	movl	$56, %esi
	cmoveq	%rdx, %rsi
	.loc	5 16 8
	movq	8(%rax), %r8
	.loc	5 24 8
	shrl	%edi
	imulq	$7168, %rdi, %rdi
	leaq	(%rdi,%rsi,4), %rdi
	addq	(%rax), %rdi
	movq	%r8, -48(%rbp)
	leaq	8490508(%r8), %r9
	movss	.LCPI4_0(%rip), %xmm0
	.loc	5 0 8 is_stmt 0
.Ltmp16:
	.p2align	4
.LBB4_1:
	movq	-48(%rbp), %rax
	.loc	5 30 8 is_stmt 1
	movss	8831360(%rax,%rdx,4), %xmm1
	imulq	$51076, %rdx, %r10
	addq	-56(%rbp), %r10
	movq	%rdi, %r8
	xorl	%ebx, %ebx
	.loc	5 0 8 is_stmt 0
.Ltmp17:
	.p2align	4
.LBB4_2:
	leaq	(%rbx,%rcx), %rax
	imulq	$452, %rax, %r14
	addq	%r10, %r14
	movq	%r8, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB4_3:
	.loc	5 24 8 is_stmt 1
	leaq	(%r12,%rsi), %r13
	xorps	%xmm2, %xmm2
	movq	$-4, %rax
	movq	%r11, %r15
	.loc	5 0 8 is_stmt 0
.Ltmp18:
	.p2align	4
.LBB4_4:
	.loc	5 24 8
	movss	(%r15), %xmm3
	movss	50176(%r15), %xmm4
	.loc	5 27 10 is_stmt 1
	mulss	4(%r9,%rax,4), %xmm3
	.loc	5 24 8
	movss	100352(%r15), %xmm5
	.loc	5 27 10
	addss	%xmm2, %xmm3
	mulss	8(%r9,%rax,4), %xmm4
	.loc	5 24 8
	movss	150528(%r15), %xmm2
	.loc	5 27 10
	addss	%xmm3, %xmm4
	mulss	12(%r9,%rax,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r9,%rax,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	5 24 8
	addq	$4, %rax
	addq	$200704, %r15
	cmpq	$12, %rax
	jb	.LBB4_4
	.loc	5 32 10
	addss	%xmm1, %xmm2
	.loc	5 24 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, (%r14,%r13,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$56, %r12
	jne	.LBB4_3
	incq	%rbx
	addq	$448, %r8
	cmpq	$16, %rbx
	jne	.LBB4_2
	incq	%rdx
	addq	$64, %r9
	cmpq	$96, %rdx
	jne	.LBB4_1
	.loc	5 40 8
	xorl	%eax, %eax
	.loc	5 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp19:
.Lfunc_end4:
	.size	infer_dispatch_4_matmul_like_96x112x112x16_f32, .Lfunc_end4-infer_dispatch_4_matmul_like_96x112x112x16_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI5_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_5_conv_56x56x96x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_5_conv_56x56x96x3x3_f32,@function
infer_dispatch_5_conv_56x56x96x3x3_f32:
.Lfunc_begin5:
	.file	6 "dump" "configured_module_infer_dispatch_5.mlir"
	.loc	6 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp20:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$256, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	6 15 8 prologue_end
	movq	32(%rsi), %rdi
	movq	(%rdi), %rsi
	.loc	6 16 8
	movq	8(%rdi), %rax
	.loc	6 24 8
	movl	(%rdx), %ecx
	movl	$2863311531, %r8d
	imulq	%rcx, %r8
	movq	%r8, %rdx
	shrq	$34, %rdx
	leal	(%rdx,%rdx), %r9d
	leal	(%r9,%r9,2), %r9d
	movl	%ecx, %r10d
	subl	%r9d, %r10d
	shrq	$33, %r8
	leal	(%r8,%r8,2), %r8d
	subl	%r8d, %ecx
	leaq	(%rdx,%rdx,8), %r8
	leaq	(%r8,%r8,2), %r8
	addq	%rdx, %r8
	movq	%r8, 80(%rsp)
	shll	$5, %ecx
	imulq	$51076, %rcx, %r8
	leaq	224(%r8), %r9
	xorl	%r11d, %r11d
	cmpl	$3, %r10d
	movl	$112, %r10d
	cmovbq	%r11, %r10
	cmovbq	%r8, %r9
	addq	16(%rdi), %r10
	movq	%r10, 72(%rsp)
	.loc	6 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	6 24 8
	imulq	$25312, %rdx, %rdx
	addq	%r9, %rdx
	leaq	(%rsi,%rdx), %rdi
	addq	$3876672, %rdi
	leaq	(%rcx,%rcx,8), %rdx
	leaq	(%rax,%rdx,4), %rdx
	addq	$8750976, %rdx
	movq	%rdx, 104(%rsp)
	movaps	.LCPI5_0(%rip), %xmm0
	.loc	6 0 8 is_stmt 0
.Ltmp21:
	.p2align	4
.LBB5_1:
	movq	80(%rsp), %rdx
	movq	%r11, 96(%rsp)
	addq	%r11, %rdx
	imulq	$224, %rdx, %rdx
	addq	72(%rsp), %rdx
	movq	%rdx, 112(%rsp)
	movq	%rdi, 88(%rsp)
	xorl	%esi, %esi
	.p2align	4
.LBB5_2:
	movq	112(%rsp), %rdx
	movq	%rsi, 120(%rsp)
	.loc	6 24 8 is_stmt 1
	leaq	(%rdx,%rsi,4), %r14
	movq	104(%rsp), %r9
	movq	%rdi, %r8
	xorl	%r13d, %r13d
	.loc	6 0 8 is_stmt 0
.Ltmp22:
	.p2align	4
.LBB5_3:
	xorl	%edx, %edx
	.p2align	4
.LBB5_4:
	.loc	6 24 8 is_stmt 1
	movss	128(%rsp,%rdx,4), %xmm1
	movss	%xmm1, (%rsp,%rdx,4)
	incq	%rdx
	cmpq	$4, %rdx
	jne	.LBB5_4
	movq	%r13, %rdx
	orq	%rcx, %rdx
	movq	%r9, %r15
	movq	%r8, %r11
	xorl	%esi, %esi
	.loc	6 0 8 is_stmt 0
.Ltmp23:
	.p2align	4
.LBB5_6:
	movq	%r11, %r12
	xorl	%r10d, %r10d
	.p2align	4
.LBB5_7:
	movss	(%rsp,%r10,4), %xmm1
	xorl	%ebx, %ebx
	.p2align	4
.LBB5_8:
	.loc	6 24 8 is_stmt 1
	movss	(%r12,%rbx,4), %xmm2
	.loc	6 26 10
	mulss	(%r15,%rbx,4), %xmm2
	.loc	6 27 10
	addss	%xmm2, %xmm1
	.loc	6 24 8
	incq	%rbx
	cmpq	$3, %rbx
	jne	.LBB5_8
	movss	%xmm1, (%rsp,%r10,4)
	incq	%r10
	addq	$8, %r12
	cmpq	$4, %r10
	jne	.LBB5_7
	incq	%rsi
	addq	$452, %r11
	addq	$12, %r15
	cmpq	$3, %rsi
	jne	.LBB5_6
	.loc	6 32 10
	movss	8831744(%rax,%rdx,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	addps	(%rsp), %xmm1
	.loc	6 34 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm1, %xmm2
	andps	%xmm1, %xmm2
	.loc	6 36 10
	minps	%xmm0, %xmm2
	.loc	6 24 8
	imulq	$12544, %rdx, %rdx
	movaps	%xmm2, (%r14,%rdx)
	incq	%r13
	addq	$51076, %r8
	addq	$36, %r9
	cmpq	$32, %r13
	jne	.LBB5_3
	addq	$32, %rdi
	movq	120(%rsp), %rdx
	cmpq	$24, %rdx
	leaq	4(%rdx), %rsi
	jb	.LBB5_2
	.loc	6 0 8 is_stmt 0
	movq	96(%rsp), %r11
	.loc	6 24 8
	incq	%r11
	movq	88(%rsp), %rdi
	addq	$904, %rdi
	cmpq	$28, %r11
	jne	.LBB5_1
	.loc	6 40 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	6 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp24:
.Lfunc_end5:
	.size	infer_dispatch_5_conv_56x56x96x3x3_f32, .Lfunc_end5-infer_dispatch_5_conv_56x56x96x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_6_matmul_like_24x3136x96_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_6_matmul_like_24x3136x96_f32,@function
infer_dispatch_6_matmul_like_24x3136x96_f32:
.Lfunc_begin6:
	.file	7 "dump" "configured_module_infer_dispatch_6.mlir"
	.loc	7 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp25:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	7 14 8 prologue_end
	movq	32(%rsi), %rdi
	.loc	7 15 8
	movq	8(%rdi), %r8
	movl	$1204224, %eax
	.loc	7 16 8
	addq	16(%rdi), %rax
	.loc	7 21 8
	movl	(%rdx), %ecx
	imulq	$1402438301, %rcx, %r9
	shrq	$36, %r9
	imull	$49, %r9d, %edx
	subl	%edx, %ecx
	leal	(,%r9,8), %edx
	movl	%ecx, %esi
	shll	$6, %esi
	shll	$8, %ecx
	addq	(%rdi), %rcx
	leaq	(%r9,%r9,2), %rdi
	shlq	$10, %rdi
	addq	%r8, %rdi
	addq	$8481292, %rdi
	xorl	%r8d, %r8d
	leaq	__constant_24xf32(%rip), %r9
	.loc	7 0 8 is_stmt 0
.Ltmp26:
	.p2align	4
.LBB6_1:
	.loc	7 21 8
	movq	%r8, %r10
	orq	%rdx, %r10
	.loc	7 27 8 is_stmt 1
	movss	(%r9,%r10,4), %xmm0
	imulq	$12544, %r10, %r10
	addq	%rax, %r10
	movq	%rcx, %r11
	xorl	%ebx, %ebx
	.loc	7 0 8 is_stmt 0
.Ltmp27:
	.p2align	4
.LBB6_2:
	.loc	7 21 8 is_stmt 1
	movq	%rbx, %r14
	orq	%rsi, %r14
	xorps	%xmm1, %xmm1
	movq	$-4, %r15
	movq	%r11, %r12
	.loc	7 0 8 is_stmt 0
.Ltmp28:
	.p2align	4
.LBB6_3:
	.loc	7 21 8
	movss	(%r12), %xmm2
	movss	12544(%r12), %xmm3
	.loc	7 24 10 is_stmt 1
	mulss	4(%rdi,%r15,4), %xmm2
	.loc	7 21 8
	movss	25088(%r12), %xmm4
	.loc	7 24 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%r15,4), %xmm3
	.loc	7 21 8
	movss	37632(%r12), %xmm1
	.loc	7 24 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%r15,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%r15,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	7 21 8
	addq	$4, %r15
	addq	$50176, %r12
	cmpq	$92, %r15
	jb	.LBB6_3
	.loc	7 29 10
	addss	%xmm0, %xmm1
	.loc	7 21 8
	movss	%xmm1, (%r10,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$64, %rbx
	jne	.LBB6_2
	incq	%r8
	addq	$384, %rdi
	cmpq	$8, %r8
	jne	.LBB6_1
	.loc	7 33 8
	xorl	%eax, %eax
	.loc	7 33 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp29:
.Lfunc_end6:
	.size	infer_dispatch_6_matmul_like_24x3136x96_f32, .Lfunc_end6-infer_dispatch_6_matmul_like_24x3136x96_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI7_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_7_matmul_like_144x56x56x24_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_7_matmul_like_144x56x56x24_f32,@function
infer_dispatch_7_matmul_like_144x56x56x24_f32:
.Lfunc_begin7:
	.file	8 "dump" "configured_module_infer_dispatch_7.mlir"
	.loc	8 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp30:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	8 15 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rdi
	movl	$1505280, %ecx
	.loc	8 18 8
	addq	16(%rax), %rcx
	movq	%rcx, -48(%rbp)
	.loc	8 16 8
	movq	8(%rax), %r9
	.loc	8 24 8
	movl	(%rdx), %ecx
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	leal	(,%rdx,8), %r8d
	movl	%edx, %eax
	subl	%r8d, %eax
	addl	%ecx, %eax
	shll	$3, %eax
	imulq	$224, %rax, %rcx
	addq	%rcx, %rdi
	addq	$1241856, %rdi
	leaq	(%rdx,%rdx,2), %rcx
	shlq	$4, %rdx
	shlq	$9, %rcx
	movq	%r9, %rsi
	leaq	(%rcx,%r9), %r8
	addq	$8467468, %r8
	xorl	%r9d, %r9d
	movss	.LCPI7_0(%rip), %xmm0
	.loc	8 0 8 is_stmt 0
.Ltmp31:
	.p2align	4
.LBB7_1:
	.loc	8 24 8
	leaq	(%r9,%rdx), %rcx
	.loc	8 30 8 is_stmt 1
	movss	8785920(%rsi,%rcx,4), %xmm1
	imulq	$13456, %rcx, %r10
	addq	-48(%rbp), %r10
	movq	%rdi, %rcx
	xorl	%ebx, %ebx
	.loc	8 0 8 is_stmt 0
.Ltmp32:
	.p2align	4
.LBB7_2:
	leaq	(%rbx,%rax), %r11
	imulq	$232, %r11, %r11
	leaq	(%r10,%r11), %r14
	addq	$232, %r14
	movq	%rcx, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB7_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r13
	movq	%r11, %r15
	.p2align	4
.LBB7_4:
	.loc	8 24 8 is_stmt 1
	movss	-37632(%r15), %xmm3
	movss	-25088(%r15), %xmm4
	.loc	8 27 10
	mulss	4(%r8,%r13,4), %xmm3
	.loc	8 24 8
	movss	-12544(%r15), %xmm5
	.loc	8 27 10
	addss	%xmm2, %xmm3
	mulss	8(%r8,%r13,4), %xmm4
	.loc	8 24 8
	movss	(%r15), %xmm2
	.loc	8 27 10
	addss	%xmm3, %xmm4
	mulss	12(%r8,%r13,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r8,%r13,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	8 24 8
	addq	$4, %r13
	addq	$50176, %r15
	cmpq	$20, %r13
	jb	.LBB7_4
	.loc	8 32 10
	addss	%xmm1, %xmm2
	.loc	8 24 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, 4(%r14,%r12,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$56, %r12
	jne	.LBB7_3
	incq	%rbx
	addq	$224, %rcx
	cmpq	$8, %rbx
	jne	.LBB7_2
	incq	%r9
	addq	$96, %r8
	cmpq	$16, %r9
	jne	.LBB7_1
	.loc	8 40 8
	xorl	%eax, %eax
	.loc	8 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp33:
.Lfunc_end7:
	.size	infer_dispatch_7_matmul_like_144x56x56x24_f32, .Lfunc_end7-infer_dispatch_7_matmul_like_144x56x56x24_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI8_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_8_conv_56x56x144x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_8_conv_56x56x144x3x3_f32,@function
infer_dispatch_8_conv_56x56x144x3x3_f32:
.Lfunc_begin8:
	.file	9 "dump" "configured_module_infer_dispatch_8.mlir"
	.loc	9 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp34:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$256, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	9 15 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rcx
	.loc	9 16 8
	movq	8(%rsi), %rax
	movl	$3442944, %edi
	.loc	9 18 8
	addq	16(%rsi), %rdi
	movq	%rdi, 72(%rsp)
	.loc	9 24 8
	movl	(%rdx), %edx
	movl	$2863311531, %edi
	imulq	%rdx, %rdi
	movq	%rdi, %rsi
	shrq	$35, %rsi
	leal	(,%rsi,4), %r8d
	leal	(%r8,%r8,2), %r8d
	movl	%edx, %r9d
	subl	%r8d, %r9d
	shrq	$34, %rdi
	addl	%edi, %edi
	leal	(%rdi,%rdi,2), %edi
	subl	%edi, %edx
	leaq	(%rsi,%rsi,8), %rdi
	leaq	(%rdi,%rdi,2), %rdi
	addq	%rsi, %rdi
	movq	%rdi, 64(%rsp)
	xorl	%edi, %edi
	cmpl	$6, %r9d
	movl	$28, %r9d
	cmovbq	%rdi, %r9
	shll	$3, %edx
	leal	(%rdx,%rdx,2), %r8d
	.loc	9 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	9 24 8
	imulq	$13456, %r8, %rdx
	imulq	$6496, %rsi, %rsi
	addq	%rdx, %rsi
	movq	%r9, 104(%rsp)
	leaq	(%rsi,%r9,4), %rdx
	leaq	(%rcx,%rdx), %r9
	addq	$1505280, %r9
	leaq	(%r8,%r8,8), %rcx
	leaq	(%rax,%rcx,4), %rcx
	addq	$8745792, %rcx
	movq	%rcx, 96(%rsp)
	movaps	.LCPI8_0(%rip), %xmm0
	.loc	9 0 8 is_stmt 0
.Ltmp35:
	.p2align	4
.LBB8_1:
	movq	64(%rsp), %rcx
	movq	%rdi, 88(%rsp)
	addq	%rdi, %rcx
	imulq	$224, %rcx, %rcx
	addq	72(%rsp), %rcx
	movq	%rcx, 112(%rsp)
	movq	%r9, 80(%rsp)
	xorl	%edx, %edx
	.p2align	4
.LBB8_2:
	movq	104(%rsp), %rcx
	movq	%rdx, 120(%rsp)
	.loc	9 24 8 is_stmt 1
	addq	%rdx, %rcx
	movq	112(%rsp), %rdx
	leaq	(%rdx,%rcx,4), %r15
	movq	96(%rsp), %r10
	movq	%r9, %rsi
	xorl	%ecx, %ecx
	.loc	9 0 8 is_stmt 0
.Ltmp36:
	.p2align	4
.LBB8_3:
	xorl	%edx, %edx
	.p2align	4
.LBB8_4:
	.loc	9 24 8 is_stmt 1
	movss	128(%rsp,%rdx,4), %xmm1
	movss	%xmm1, (%rsp,%rdx,4)
	incq	%rdx
	cmpq	$4, %rdx
	jne	.LBB8_4
	leaq	(%rcx,%r8), %rdx
	movq	%r10, %r12
	movq	%rsi, %rbx
	xorl	%edi, %edi
	.loc	9 0 8 is_stmt 0
.Ltmp37:
	.p2align	4
.LBB8_6:
	movq	%rbx, %r13
	xorl	%r11d, %r11d
	.p2align	4
.LBB8_7:
	movss	(%rsp,%r11,4), %xmm1
	xorl	%r14d, %r14d
	.p2align	4
.LBB8_8:
	.loc	9 24 8 is_stmt 1
	movss	(%r13,%r14,4), %xmm2
	.loc	9 26 10
	mulss	(%r12,%r14,4), %xmm2
	.loc	9 27 10
	addss	%xmm2, %xmm1
	.loc	9 24 8
	incq	%r14
	cmpq	$3, %r14
	jne	.LBB8_8
	movss	%xmm1, (%rsp,%r11,4)
	incq	%r11
	addq	$4, %r13
	cmpq	$4, %r11
	jne	.LBB8_7
	incq	%rdi
	addq	$232, %rbx
	addq	$12, %r12
	cmpq	$3, %rdi
	jne	.LBB8_6
	.loc	9 32 10
	movss	8786496(%rax,%rdx,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	addps	(%rsp), %xmm1
	.loc	9 34 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm1, %xmm2
	andps	%xmm1, %xmm2
	.loc	9 36 10
	minps	%xmm0, %xmm2
	.loc	9 24 8
	imulq	$12544, %rdx, %rdx
	movaps	%xmm2, (%r15,%rdx)
	incq	%rcx
	addq	$13456, %rsi
	addq	$36, %r10
	cmpq	$24, %rcx
	jne	.LBB8_3
	addq	$16, %r9
	movq	120(%rsp), %rcx
	cmpq	$24, %rcx
	leaq	4(%rcx), %rdx
	jb	.LBB8_2
	.loc	9 0 8 is_stmt 0
	movq	88(%rsp), %rdi
	.loc	9 24 8
	incq	%rdi
	movq	80(%rsp), %r9
	addq	$232, %r9
	cmpq	$28, %rdi
	jne	.LBB8_1
	.loc	9 40 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	9 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp38:
.Lfunc_end8:
	.size	infer_dispatch_8_conv_56x56x144x3x3_f32, .Lfunc_end8-infer_dispatch_8_conv_56x56x144x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_9_matmul_like_24x3136x144_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_9_matmul_like_24x3136x144_f32,@function
infer_dispatch_9_matmul_like_24x3136x144_f32:
.Lfunc_begin9:
	.file	10 "dump" "configured_module_infer_dispatch_9.mlir"
	.loc	10 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp39:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	10 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rax
	.loc	10 16 8
	movq	8(%rcx), %r8
	.loc	10 18 8
	movq	16(%rcx), %rcx
	.loc	10 24 8
	movl	(%rdx), %edi
	imulq	$1402438301, %rdi, %r9
	shrq	$36, %r9
	imull	$49, %r9d, %edx
	subl	%edx, %edi
	leal	(,%r9,8), %edx
	movl	%edi, %esi
	shll	$6, %esi
	shll	$8, %edi
	addq	%rax, %rdi
	addq	$3480576, %rdi
	leaq	(%r9,%r9,8), %r9
	shlq	$9, %r9
	addq	%r9, %r8
	addq	$8453644, %r8
	xorl	%r9d, %r9d
	leaq	__constant_24xf32_0(%rip), %r10
	.loc	10 0 8 is_stmt 0
.Ltmp40:
	.p2align	4
.LBB9_1:
	.loc	10 24 8
	movq	%r9, %r11
	orq	%rdx, %r11
	.loc	10 30 8 is_stmt 1
	movss	(%r10,%r11,4), %xmm0
	imulq	$3136, %r11, %r11
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	.loc	10 0 8 is_stmt 0
.Ltmp41:
	.p2align	4
.LBB9_2:
	.loc	10 24 8 is_stmt 1
	movq	%r14, %r15
	orq	%rsi, %r15
	xorps	%xmm1, %xmm1
	movq	$-4, %r12
	movq	%rbx, %r13
	.loc	10 0 8 is_stmt 0
.Ltmp42:
	.p2align	4
.LBB9_3:
	.loc	10 24 8
	movss	-37632(%r13), %xmm2
	movss	-25088(%r13), %xmm3
	.loc	10 27 10 is_stmt 1
	mulss	4(%r8,%r12,4), %xmm2
	.loc	10 24 8
	movss	-12544(%r13), %xmm4
	.loc	10 27 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r12,4), %xmm3
	.loc	10 24 8
	movss	(%r13), %xmm1
	.loc	10 27 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r12,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r12,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	10 24 8
	addq	$4, %r12
	addq	$50176, %r13
	cmpq	$140, %r12
	jb	.LBB9_3
	.loc	10 30 8
	addq	%r11, %r15
	.loc	10 33 10
	addss	%xmm0, %xmm1
	addss	1204224(%rax,%r15,4), %xmm1
	.loc	10 24 8
	movss	%xmm1, (%rcx,%r15,4)
	incq	%r14
	addq	$4, %rbx
	cmpq	$64, %r14
	jne	.LBB9_2
	incq	%r9
	addq	$576, %r8
	cmpq	$8, %r9
	jne	.LBB9_1
	.loc	10 37 8
	xorl	%eax, %eax
	.loc	10 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp43:
.Lfunc_end9:
	.size	infer_dispatch_9_matmul_like_24x3136x144_f32, .Lfunc_end9-infer_dispatch_9_matmul_like_24x3136x144_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI10_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_10_matmul_like_144x56x56x24_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_10_matmul_like_144x56x56x24_f32,@function
infer_dispatch_10_matmul_like_144x56x56x24_f32:
.Lfunc_begin10:
	.file	11 "dump" "configured_module_infer_dispatch_10.mlir"
	.loc	11 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp44:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	11 15 8 prologue_end
	movq	32(%rsi), %r8
	movl	$1505280, %eax
	.loc	11 18 8
	addq	16(%r8), %rax
	movq	%rax, -48(%rbp)
	.loc	11 24 8
	movl	(%rdx), %ecx
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	.loc	11 16 8
	movq	8(%r8), %rax
	.loc	11 24 8
	leal	(,%rdx,8), %esi
	movl	%edx, %edi
	subl	%esi, %edi
	addl	%ecx, %edi
	shll	$3, %edi
	imulq	$224, %rdi, %rsi
	addq	(%r8), %rsi
	leaq	(%rdx,%rdx,2), %rcx
	shlq	$4, %rdx
	shlq	$9, %rcx
	leaq	(%rcx,%rax), %r8
	addq	$8439820, %r8
	xorl	%r9d, %r9d
	movss	.LCPI10_0(%rip), %xmm0
	.loc	11 0 8 is_stmt 0
.Ltmp45:
	.p2align	4
.LBB10_1:
	.loc	11 24 8
	leaq	(%r9,%rdx), %rcx
	.loc	11 30 8 is_stmt 1
	movss	8784768(%rax,%rcx,4), %xmm1
	imulq	$12996, %rcx, %r10
	addq	-48(%rbp), %r10
	movq	%rsi, %rcx
	xorl	%ebx, %ebx
	.loc	11 0 8 is_stmt 0
.Ltmp46:
	.p2align	4
.LBB10_2:
	leaq	(%rbx,%rdi), %r11
	imulq	$228, %r11, %r14
	addq	%r10, %r14
	movq	%rcx, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB10_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r13
	movq	%r11, %r15
	.p2align	4
.LBB10_4:
	.loc	11 24 8 is_stmt 1
	movss	(%r15), %xmm3
	movss	12544(%r15), %xmm4
	.loc	11 27 10
	mulss	4(%r8,%r13,4), %xmm3
	.loc	11 24 8
	movss	25088(%r15), %xmm5
	.loc	11 27 10
	addss	%xmm2, %xmm3
	mulss	8(%r8,%r13,4), %xmm4
	.loc	11 24 8
	movss	37632(%r15), %xmm2
	.loc	11 27 10
	addss	%xmm3, %xmm4
	mulss	12(%r8,%r13,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r8,%r13,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	11 24 8
	addq	$4, %r13
	addq	$50176, %r15
	cmpq	$20, %r13
	jb	.LBB10_4
	.loc	11 32 10
	addss	%xmm1, %xmm2
	.loc	11 24 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, (%r14,%r12,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$56, %r12
	jne	.LBB10_3
	incq	%rbx
	addq	$224, %rcx
	cmpq	$8, %rbx
	jne	.LBB10_2
	incq	%r9
	addq	$96, %r8
	cmpq	$16, %r9
	jne	.LBB10_1
	.loc	11 40 8
	xorl	%eax, %eax
	.loc	11 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp47:
.Lfunc_end10:
	.size	infer_dispatch_10_matmul_like_144x56x56x24_f32, .Lfunc_end10-infer_dispatch_10_matmul_like_144x56x56x24_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI11_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_11_conv_28x28x144x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_11_conv_28x28x144x3x3_f32,@function
infer_dispatch_11_conv_28x28x144x3x3_f32:
.Lfunc_begin11:
	.file	12 "dump" "configured_module_infer_dispatch_11.mlir"
	.loc	12 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp48:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$256, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	12 15 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rcx
	.loc	12 16 8
	movq	8(%rsi), %rax
	.loc	12 18 8
	movq	16(%rsi), %rsi
	movq	%rsi, 80(%rsp)
	.loc	12 24 8
	movl	(%rdx), %edx
	movl	$2863311531, %r8d
	imulq	%rdx, %r8
	shrq	$34, %r8
	leal	(%r8,%r8), %esi
	leal	(%rsi,%rsi,2), %esi
	subl	%esi, %edx
	leaq	(%r8,%r8), %rsi
	imulq	$6384, %r8, %rdi
	shlq	$4, %r8
	subq	%rsi, %r8
	movq	%r8, 72(%rsp)
	shll	$3, %edx
	leal	(%rdx,%rdx,2), %esi
	.loc	12 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	12 24 8
	imulq	$12996, %rsi, %rdx
	addq	%rdi, %rdx
	addq	%rcx, %rdx
	addq	$1505280, %rdx
	leaq	(%rsi,%rsi,8), %rcx
	leaq	(%rax,%rcx,4), %rcx
	addq	$8740608, %rcx
	movq	%rcx, 104(%rsp)
	xorl	%edi, %edi
	movaps	.LCPI11_0(%rip), %xmm0
	.loc	12 0 8 is_stmt 0
.Ltmp49:
	.p2align	4
.LBB11_1:
	movq	72(%rsp), %rcx
	movq	%rdi, 88(%rsp)
	addq	%rdi, %rcx
	imulq	$112, %rcx, %rcx
	addq	80(%rsp), %rcx
	movq	%rcx, 112(%rsp)
	movq	%rdx, 96(%rsp)
	xorl	%edi, %edi
	.p2align	4
.LBB11_2:
	movq	112(%rsp), %rcx
	movq	%rdi, 120(%rsp)
	.loc	12 24 8 is_stmt 1
	leaq	(%rcx,%rdi,4), %r14
	movq	104(%rsp), %r8
	movq	%rdx, %rdi
	xorl	%r13d, %r13d
	.loc	12 0 8 is_stmt 0
.Ltmp50:
	.p2align	4
.LBB11_3:
	xorl	%ecx, %ecx
	.p2align	4
.LBB11_4:
	.loc	12 24 8 is_stmt 1
	movss	128(%rsp,%rcx,4), %xmm1
	movss	%xmm1, (%rsp,%rcx,4)
	incq	%rcx
	cmpq	$4, %rcx
	jne	.LBB11_4
	leaq	(%rsi,%r13), %rcx
	movq	%r8, %r15
	movq	%rdi, %r11
	xorl	%r9d, %r9d
	.loc	12 0 8 is_stmt 0
.Ltmp51:
	.p2align	4
.LBB11_6:
	movq	%r11, %r12
	xorl	%r10d, %r10d
	.p2align	4
.LBB11_7:
	movss	(%rsp,%r10,4), %xmm1
	xorl	%ebx, %ebx
	.p2align	4
.LBB11_8:
	.loc	12 24 8 is_stmt 1
	movss	(%r12,%rbx,4), %xmm2
	.loc	12 26 10
	mulss	(%r15,%rbx,4), %xmm2
	.loc	12 27 10
	addss	%xmm2, %xmm1
	.loc	12 24 8
	incq	%rbx
	cmpq	$3, %rbx
	jne	.LBB11_8
	movss	%xmm1, (%rsp,%r10,4)
	incq	%r10
	addq	$8, %r12
	cmpq	$4, %r10
	jne	.LBB11_7
	incq	%r9
	addq	$228, %r11
	addq	$12, %r15
	cmpq	$3, %r9
	jne	.LBB11_6
	.loc	12 32 10
	movss	8785344(%rax,%rcx,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	addps	(%rsp), %xmm1
	.loc	12 34 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm1, %xmm2
	andps	%xmm1, %xmm2
	.loc	12 36 10
	minps	%xmm0, %xmm2
	.loc	12 24 8
	imulq	$3136, %rcx, %rcx
	movaps	%xmm2, (%r14,%rcx)
	incq	%r13
	addq	$12996, %rdi
	addq	$36, %r8
	cmpq	$24, %r13
	jne	.LBB11_3
	addq	$32, %rdx
	movq	120(%rsp), %rcx
	cmpq	$24, %rcx
	leaq	4(%rcx), %rdi
	jb	.LBB11_2
	.loc	12 0 8 is_stmt 0
	movq	88(%rsp), %rdi
	.loc	12 24 8
	incq	%rdi
	movq	96(%rsp), %rdx
	addq	$456, %rdx
	cmpq	$14, %rdi
	jne	.LBB11_1
	.loc	12 40 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	12 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp52:
.Lfunc_end11:
	.size	infer_dispatch_11_conv_28x28x144x3x3_f32, .Lfunc_end11-infer_dispatch_11_conv_28x28x144x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_12_matmul_like_32x784x144_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_12_matmul_like_32x784x144_f32,@function
infer_dispatch_12_matmul_like_32x784x144_f32:
.Lfunc_begin12:
	.file	13 "dump" "configured_module_infer_dispatch_12.mlir"
	.loc	13 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp53:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	13 14 8 prologue_end
	movq	32(%rsi), %rdi
	movl	$451584, %eax
	.loc	13 16 8
	addq	16(%rdi), %rax
	.loc	13 21 8
	movl	(%rdx), %edx
	imulq	$56, %rdx, %rcx
	imulq	$224, %rdx, %rdx
	addq	(%rdi), %rdx
	movl	$8421388, %esi
	addq	8(%rdi), %rsi
	xorl	%edi, %edi
	leaq	__constant_32xf32_1(%rip), %r8
	.loc	13 0 8 is_stmt 0
.Ltmp54:
	.p2align	4
.LBB12_1:
	.loc	13 27 8 is_stmt 1
	movss	(%r8,%rdi,4), %xmm0
	imulq	$3136, %rdi, %r9
	addq	%rax, %r9
	movq	%rdx, %r10
	xorl	%r11d, %r11d
	.loc	13 0 8 is_stmt 0
.Ltmp55:
	.p2align	4
.LBB12_2:
	.loc	13 21 8 is_stmt 1
	leaq	(%r11,%rcx), %rbx
	xorps	%xmm1, %xmm1
	movq	$-4, %r14
	movq	%r10, %r15
	.loc	13 0 8 is_stmt 0
.Ltmp56:
	.p2align	4
.LBB12_3:
	.loc	13 21 8
	movss	(%r15), %xmm2
	movss	3136(%r15), %xmm3
	.loc	13 24 10 is_stmt 1
	mulss	4(%rsi,%r14,4), %xmm2
	.loc	13 21 8
	movss	6272(%r15), %xmm4
	.loc	13 24 10
	addss	%xmm1, %xmm2
	mulss	8(%rsi,%r14,4), %xmm3
	.loc	13 21 8
	movss	9408(%r15), %xmm1
	.loc	13 24 10
	addss	%xmm2, %xmm3
	mulss	12(%rsi,%r14,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rsi,%r14,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	13 21 8
	addq	$4, %r14
	addq	$12544, %r15
	cmpq	$140, %r14
	jb	.LBB12_3
	.loc	13 29 10
	addss	%xmm0, %xmm1
	.loc	13 21 8
	movss	%xmm1, (%r9,%rbx,4)
	incq	%r11
	addq	$4, %r10
	cmpq	$56, %r11
	jne	.LBB12_2
	incq	%rdi
	addq	$576, %rsi
	cmpq	$32, %rdi
	jne	.LBB12_1
	.loc	13 33 8
	xorl	%eax, %eax
	.loc	13 33 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp57:
.Lfunc_end12:
	.size	infer_dispatch_12_matmul_like_32x784x144_f32, .Lfunc_end12-infer_dispatch_12_matmul_like_32x784x144_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI13_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_13_matmul_like_192x28x28x32_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_13_matmul_like_192x28x28x32_f32,@function
infer_dispatch_13_matmul_like_192x28x28x32_f32:
.Lfunc_begin13:
	.file	14 "dump" "configured_module_infer_dispatch_13.mlir"
	.loc	14 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp58:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	14 12 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %r8
	movl	(%rax), %r11d
	.loc	14 13 8
	movl	4(%rax), %r9d
	.loc	14 14 8
	movl	8(%rax), %eax
	.loc	14 23 8
	andl	$-4, %r11d
	.loc	14 24 8
	movq	8(%r8), %r10
	andl	$-4, %r9d
	.loc	14 25 8
	andl	$-4, %eax
	movl	$551936, %ecx
	.loc	14 26 8
	addq	16(%r8), %rcx
	.loc	14 25 8
	addq	%r10, %rax
	movq	%rax, -48(%rbp)
	.loc	14 32 8
	movl	(%rdx), %eax
	movl	%eax, %ebx
	shrl	%ebx
	leaq	(,%rbx,8), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%esi, %esi
	testb	$1, %al
	movl	$14, %edi
	cmoveq	%rsi, %rdi
	imulq	$112, %rdi, %rax
	addq	%r11, %rax
	addq	(%r8), %rax
	leaq	(%rbx,%rbx,2), %r8
	shlq	$10, %r8
	addq	%r9, %r8
	leaq	(%r10,%r8), %r9
	addq	$12, %r9
	movss	.LCPI13_0(%rip), %xmm0
	.loc	14 0 8 is_stmt 0
.Ltmp59:
	.p2align	4
.LBB13_1:
	.loc	14 32 8
	leaq	(%rsi,%rdx), %r8
	movq	-48(%rbp), %r10
	.loc	14 38 8 is_stmt 1
	movss	(%r10,%r8,4), %xmm1
	imulq	$3600, %r8, %r10
	addq	%rcx, %r10
	movq	%rax, %r8
	xorl	%ebx, %ebx
	.loc	14 0 8 is_stmt 0
.Ltmp60:
	.p2align	4
.LBB13_2:
	leaq	(%rbx,%rdi), %r11
	imulq	$120, %r11, %r11
	leaq	(%r10,%r11), %r14
	addq	$120, %r14
	movq	%r8, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB13_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r13
	movq	%r11, %r15
	.p2align	4
.LBB13_4:
	.loc	14 32 8 is_stmt 1
	movss	(%r15), %xmm3
	movss	3136(%r15), %xmm4
	.loc	14 35 10
	mulss	4(%r9,%r13,4), %xmm3
	.loc	14 32 8
	movss	6272(%r15), %xmm5
	.loc	14 35 10
	addss	%xmm2, %xmm3
	mulss	8(%r9,%r13,4), %xmm4
	.loc	14 32 8
	movss	9408(%r15), %xmm2
	.loc	14 35 10
	addss	%xmm3, %xmm4
	mulss	12(%r9,%r13,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r9,%r13,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	14 32 8
	addq	$4, %r13
	addq	$12544, %r15
	cmpq	$28, %r13
	jb	.LBB13_4
	.loc	14 40 10
	addss	%xmm1, %xmm2
	.loc	14 32 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, 4(%r14,%r12,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$28, %r12
	jne	.LBB13_3
	incq	%rbx
	addq	$112, %r8
	cmpq	$14, %rbx
	jne	.LBB13_2
	incq	%rsi
	subq	$-128, %r9
	cmpq	$24, %rsi
	jne	.LBB13_1
	.loc	14 48 8
	xorl	%eax, %eax
	.loc	14 48 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp61:
.Lfunc_end13:
	.size	infer_dispatch_13_matmul_like_192x28x28x32_f32, .Lfunc_end13-infer_dispatch_13_matmul_like_192x28x28x32_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI14_0:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_14_conv_28x28x192x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_14_conv_28x28x192x3x3_f32,@function
infer_dispatch_14_conv_28x28x192x3x3_f32:
.Lfunc_begin14:
	.file	15 "dump" "configured_module_infer_dispatch_14.mlir"
	.loc	15 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp62:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$256, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	15 13 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %r8
	movl	(%rax), %ecx
	.loc	15 14 8
	movl	4(%rax), %eax
	.loc	15 21 8
	movq	(%r8), %rsi
	.loc	15 22 8
	movq	8(%r8), %rdi
	andl	$-4, %ecx
	.loc	15 23 8
	andl	$-4, %eax
	addq	%rdi, %rax
	movl	$1243136, %r9d
	.loc	15 24 8
	addq	16(%r8), %r9
	movq	%r9, 80(%rsp)
	.loc	15 30 8
	movl	(%rdx), %edx
	movl	$2863311531, %r10d
	imulq	%rdx, %r10
	shrq	$34, %r10
	leal	(%r10,%r10), %r8d
	leal	(%r8,%r8,2), %r8d
	subl	%r8d, %edx
	leaq	(%r10,%r10), %r8
	imulq	$1680, %r10, %r9
	shlq	$4, %r10
	subq	%r8, %r10
	movq	%r10, 72(%rsp)
	shll	$5, %edx
	.loc	15 10 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	15 30 8
	imulq	$3600, %rdx, %r8
	addq	%r9, %r8
	addq	%rsi, %r8
	addq	$551936, %r8
	leaq	(%rdx,%rdx,8), %rsi
	leaq	(%rcx,%rsi,4), %rcx
	addq	%rdi, %rcx
	movq	%rcx, 104(%rsp)
	xorl	%esi, %esi
	movaps	.LCPI14_0(%rip), %xmm0
	.loc	15 0 8 is_stmt 0
.Ltmp63:
	.p2align	4
.LBB14_1:
	movq	72(%rsp), %rcx
	movq	%rsi, 88(%rsp)
	addq	%rsi, %rcx
	imulq	$112, %rcx, %rcx
	addq	80(%rsp), %rcx
	movq	%rcx, 112(%rsp)
	movq	%r8, 96(%rsp)
	movq	%r8, %rsi
	xorl	%edi, %edi
	.p2align	4
.LBB14_2:
	movq	112(%rsp), %rcx
	movq	%rdi, 120(%rsp)
	.loc	15 30 8 is_stmt 1
	leaq	(%rcx,%rdi,4), %r14
	movq	104(%rsp), %r8
	movq	%rsi, %rdi
	xorl	%r13d, %r13d
	.loc	15 0 8 is_stmt 0
.Ltmp64:
	.p2align	4
.LBB14_3:
	xorl	%ecx, %ecx
	.p2align	4
.LBB14_4:
	.loc	15 30 8 is_stmt 1
	movss	128(%rsp,%rcx,4), %xmm1
	movss	%xmm1, (%rsp,%rcx,4)
	incq	%rcx
	cmpq	$4, %rcx
	jne	.LBB14_4
	movq	%r13, %rcx
	orq	%rdx, %rcx
	movq	%r8, %r15
	movq	%rdi, %r11
	xorl	%r9d, %r9d
	.loc	15 0 8 is_stmt 0
.Ltmp65:
	.p2align	4
.LBB14_6:
	movq	%r11, %r12
	xorl	%r10d, %r10d
	.p2align	4
.LBB14_7:
	movss	(%rsp,%r10,4), %xmm1
	xorl	%ebx, %ebx
	.p2align	4
.LBB14_8:
	.loc	15 30 8 is_stmt 1
	movss	(%r12,%rbx,4), %xmm2
	.loc	15 32 10
	mulss	(%r15,%rbx,4), %xmm2
	.loc	15 33 10
	addss	%xmm2, %xmm1
	.loc	15 30 8
	incq	%rbx
	cmpq	$3, %rbx
	jne	.LBB14_8
	movss	%xmm1, (%rsp,%r10,4)
	incq	%r10
	addq	$4, %r12
	cmpq	$4, %r10
	jne	.LBB14_7
	incq	%r9
	addq	$120, %r11
	addq	$12, %r15
	cmpq	$3, %r9
	jne	.LBB14_6
	.loc	15 38 10
	movss	(%rax,%rcx,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	addps	(%rsp), %xmm1
	.loc	15 40 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm1, %xmm2
	andps	%xmm1, %xmm2
	.loc	15 42 10
	minps	%xmm0, %xmm2
	.loc	15 30 8
	imulq	$3136, %rcx, %rcx
	movaps	%xmm2, (%r14,%rcx)
	incq	%r13
	addq	$3600, %rdi
	addq	$36, %r8
	cmpq	$32, %r13
	jne	.LBB14_3
	addq	$16, %rsi
	movq	120(%rsp), %rcx
	cmpq	$24, %rcx
	leaq	4(%rcx), %rdi
	jb	.LBB14_2
	.loc	15 0 8 is_stmt 0
	movq	88(%rsp), %rsi
	.loc	15 30 8
	incq	%rsi
	movq	96(%rsp), %r8
	addq	$120, %r8
	cmpq	$14, %rsi
	jne	.LBB14_1
	.loc	15 46 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	15 46 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp66:
.Lfunc_end14:
	.size	infer_dispatch_14_conv_28x28x192x3x3_f32, .Lfunc_end14-infer_dispatch_14_conv_28x28x192x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_15_matmul_like_32x784x192_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_15_matmul_like_32x784x192_f32,@function
infer_dispatch_15_matmul_like_32x784x192_f32:
.Lfunc_begin15:
	.file	16 "dump" "configured_module_infer_dispatch_15.mlir"
	.loc	16 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp67:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	16 15 8 prologue_end
	movq	32(%rsi), %r8
	movq	(%r8), %rax
	.loc	16 18 8
	movq	16(%r8), %rcx
	.loc	16 24 8
	movl	(%rdx), %esi
	imulq	$56, %rsi, %rdx
	imulq	$224, %rsi, %rsi
	addq	%rax, %rsi
	addq	$1252544, %rsi
	movl	$8372236, %edi
	addq	8(%r8), %rdi
	xorl	%r8d, %r8d
	leaq	__constant_32xf32_2(%rip), %r9
	.loc	16 0 8 is_stmt 0
.Ltmp68:
	.p2align	4
.LBB15_1:
	.loc	16 30 8 is_stmt 1
	movss	(%r9,%r8,4), %xmm0
	imulq	$784, %r8, %r10
	movq	%rsi, %r11
	xorl	%ebx, %ebx
	.loc	16 0 8 is_stmt 0
.Ltmp69:
	.p2align	4
.LBB15_2:
	.loc	16 24 8 is_stmt 1
	leaq	(%rbx,%rdx), %r14
	xorps	%xmm1, %xmm1
	movq	$-4, %r15
	movq	%r11, %r12
	.loc	16 0 8 is_stmt 0
.Ltmp70:
	.p2align	4
.LBB15_3:
	.loc	16 24 8
	movss	-9408(%r12), %xmm2
	movss	-6272(%r12), %xmm3
	.loc	16 27 10 is_stmt 1
	mulss	4(%rdi,%r15,4), %xmm2
	.loc	16 24 8
	movss	-3136(%r12), %xmm4
	.loc	16 27 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%r15,4), %xmm3
	.loc	16 24 8
	movss	(%r12), %xmm1
	.loc	16 27 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%r15,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%r15,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	16 24 8
	addq	$4, %r15
	addq	$12544, %r12
	cmpq	$188, %r15
	jb	.LBB15_3
	.loc	16 30 8
	addq	%r10, %r14
	.loc	16 33 10
	addss	%xmm0, %xmm1
	addss	451584(%rax,%r14,4), %xmm1
	.loc	16 24 8
	movss	%xmm1, (%rcx,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$56, %rbx
	jne	.LBB15_2
	incq	%r8
	addq	$768, %rdi
	cmpq	$32, %r8
	jne	.LBB15_1
	.loc	16 37 8
	xorl	%eax, %eax
	.loc	16 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp71:
.Lfunc_end15:
	.size	infer_dispatch_15_matmul_like_32x784x192_f32, .Lfunc_end15-infer_dispatch_15_matmul_like_32x784x192_f32
	.cfi_endproc

	.section	.text.infer_dispatch_18_matmul_like_32x784x192_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_18_matmul_like_32x784x192_f32,@function
infer_dispatch_18_matmul_like_32x784x192_f32:
.Lfunc_begin16:
	.file	17 "dump" "configured_module_infer_dispatch_18.mlir"
	.loc	17 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp72:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	17 15 8 prologue_end
	movq	32(%rsi), %r8
	movq	(%r8), %rax
	.loc	17 18 8
	movq	16(%r8), %rcx
	.loc	17 24 8
	movl	(%rdx), %esi
	imulq	$56, %rsi, %rdx
	imulq	$224, %rsi, %rsi
	addq	%rax, %rsi
	addq	$1252544, %rsi
	movl	$8323084, %edi
	addq	8(%r8), %rdi
	xorl	%r8d, %r8d
	leaq	__constant_32xf32_3(%rip), %r9
	.loc	17 0 8 is_stmt 0
.Ltmp73:
	.p2align	4
.LBB16_1:
	.loc	17 30 8 is_stmt 1
	movss	(%r9,%r8,4), %xmm0
	imulq	$784, %r8, %r10
	movq	%rsi, %r11
	xorl	%ebx, %ebx
	.loc	17 0 8 is_stmt 0
.Ltmp74:
	.p2align	4
.LBB16_2:
	.loc	17 24 8 is_stmt 1
	leaq	(%rbx,%rdx), %r14
	xorps	%xmm1, %xmm1
	movq	$-4, %r15
	movq	%r11, %r12
	.loc	17 0 8 is_stmt 0
.Ltmp75:
	.p2align	4
.LBB16_3:
	.loc	17 24 8
	movss	-9408(%r12), %xmm2
	movss	-6272(%r12), %xmm3
	.loc	17 27 10 is_stmt 1
	mulss	4(%rdi,%r15,4), %xmm2
	.loc	17 24 8
	movss	-3136(%r12), %xmm4
	.loc	17 27 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%r15,4), %xmm3
	.loc	17 24 8
	movss	(%r12), %xmm1
	.loc	17 27 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%r15,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%r15,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	17 24 8
	addq	$4, %r15
	addq	$12544, %r12
	cmpq	$188, %r15
	jb	.LBB16_3
	.loc	17 30 8
	addq	%r10, %r14
	.loc	17 33 10
	addss	%xmm0, %xmm1
	addss	(%rax,%r14,4), %xmm1
	.loc	17 24 8
	movss	%xmm1, 100352(%rcx,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$56, %rbx
	jne	.LBB16_2
	incq	%r8
	addq	$768, %rdi
	cmpq	$32, %r8
	jne	.LBB16_1
	.loc	17 37 8
	xorl	%eax, %eax
	.loc	17 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp76:
.Lfunc_end16:
	.size	infer_dispatch_18_matmul_like_32x784x192_f32, .Lfunc_end16-infer_dispatch_18_matmul_like_32x784x192_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI17_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_19_matmul_like_192x28x28x32_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_19_matmul_like_192x28x28x32_f32,@function
infer_dispatch_19_matmul_like_192x28x28x32_f32:
.Lfunc_begin17:
	.file	18 "dump" "configured_module_infer_dispatch_19.mlir"
	.loc	18 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp77:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	18 15 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %r8
	.loc	18 16 8
	movq	8(%rax), %r10
	movl	$200704, %ecx
	.loc	18 18 8
	addq	16(%rax), %rcx
	.loc	18 24 8
	movl	(%rdx), %eax
	movl	%eax, %r9d
	shrl	%r9d
	leaq	(,%r9,8), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	movq	%rdx, -48(%rbp)
	xorl	%esi, %esi
	testb	$1, %al
	movl	$14, %edi
	cmoveq	%rsi, %rdi
	imulq	$112, %rdi, %rax
	addq	%r8, %rax
	addq	$109760, %rax
	leaq	(%r9,%r9,2), %r8
	shlq	$10, %r8
	movq	%r10, %rdx
	leaq	(%r8,%r10), %r9
	addq	$8298508, %r9
	movss	.LCPI17_0(%rip), %xmm0
	.loc	18 0 8 is_stmt 0
.Ltmp78:
	.p2align	4
.LBB17_1:
	movq	-48(%rbp), %r8
	.loc	18 24 8
	addq	%rsi, %r8
	.loc	18 30 8 is_stmt 1
	movss	8780160(%rdx,%r8,4), %xmm1
	imulq	$3364, %r8, %r10
	addq	%rcx, %r10
	movq	%rax, %r8
	xorl	%ebx, %ebx
	.loc	18 0 8 is_stmt 0
.Ltmp79:
	.p2align	4
.LBB17_2:
	leaq	(%rbx,%rdi), %r11
	imulq	$116, %r11, %r14
	addq	%r10, %r14
	movq	%r8, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB17_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r13
	movq	%r11, %r15
	.p2align	4
.LBB17_4:
	.loc	18 24 8 is_stmt 1
	movss	-9408(%r15), %xmm3
	movss	-6272(%r15), %xmm4
	.loc	18 27 10
	mulss	4(%r9,%r13,4), %xmm3
	.loc	18 24 8
	movss	-3136(%r15), %xmm5
	.loc	18 27 10
	addss	%xmm2, %xmm3
	mulss	8(%r9,%r13,4), %xmm4
	.loc	18 24 8
	movss	(%r15), %xmm2
	.loc	18 27 10
	addss	%xmm3, %xmm4
	mulss	12(%r9,%r13,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r9,%r13,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	18 24 8
	addq	$4, %r13
	addq	$12544, %r15
	cmpq	$28, %r13
	jb	.LBB17_4
	.loc	18 32 10
	addss	%xmm1, %xmm2
	.loc	18 24 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, (%r14,%r12,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$28, %r12
	jne	.LBB17_3
	incq	%rbx
	addq	$112, %r8
	cmpq	$14, %rbx
	jne	.LBB17_2
	incq	%rsi
	subq	$-128, %r9
	cmpq	$24, %rsi
	jne	.LBB17_1
	.loc	18 40 8
	xorl	%eax, %eax
	.loc	18 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp80:
.Lfunc_end17:
	.size	infer_dispatch_19_matmul_like_192x28x28x32_f32, .Lfunc_end17-infer_dispatch_19_matmul_like_192x28x28x32_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI18_0:
	.long	0
	.long	1
	.long	2
	.long	3
.LCPI18_1:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_20_conv_14x14x192x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_20_conv_14x14x192x3x3_f32,@function
infer_dispatch_20_conv_14x14x192x3x3_f32:
.Lfunc_begin18:
	.file	19 "dump" "configured_module_infer_dispatch_20.mlir"
	.loc	19 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp81:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	19 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rsi
	.loc	19 16 8
	movq	8(%rcx), %rax
	.loc	19 18 8
	movq	16(%rcx), %rcx
	movq	%rcx, 120(%rsp)
	.loc	19 24 8
	movl	(%rdx), %edx
	movl	$2863311531, %ecx
	imulq	%rdx, %rcx
	shrq	$34, %rcx
	leal	(%rcx,%rcx), %edi
	leal	(%rdi,%rdi,2), %edi
	subl	%edi, %edx
	leaq	(,%rcx,8), %rdi
	subq	%rcx, %rdi
	movq	%rdi, 112(%rsp)
	shll	$5, %edx
	imulq	$3364, %rdx, %rdi
	imulq	$1624, %rcx, %rcx
	addq	%rdi, %rcx
	leaq	(%rsi,%rcx), %r15
	addq	$200704, %r15
	leaq	(%rdx,%rdx,8), %rcx
	leaq	(%rax,%rcx,4), %rcx
	addq	$8719872, %rcx
	movq	%rcx, 144(%rsp)
	xorl	%edi, %edi
	movdqa	.LCPI18_0(%rip), %xmm0
	movaps	.LCPI18_1(%rip), %xmm1
	jmp	.LBB18_1
	.loc	19 0 8 is_stmt 0
.Ltmp82:
	.p2align	4
.LBB18_33:
	movq	128(%rsp), %rdi
	.loc	19 24 8
	incq	%rdi
	movq	136(%rsp), %r15
	addq	$232, %r15
	cmpq	$7, %rdi
	je	.LBB18_34
.LBB18_1:
	.loc	19 0 8
	movq	112(%rsp), %rcx
	movq	%rdi, 128(%rsp)
	addq	%rdi, %rcx
	imulq	$56, %rcx, %rcx
	addq	120(%rsp), %rcx
	movq	%rcx, 152(%rsp)
	movq	%r15, 136(%rsp)
	movl	$14, %esi
	xorl	%edi, %edi
	jmp	.LBB18_2
	.p2align	4
.LBB18_32:
	movq	168(%rsp), %rsi
	.loc	19 24 8
	addq	$-4, %rsi
	movq	176(%rsp), %r15
	addq	$32, %r15
	movq	160(%rsp), %rcx
	cmpq	$10, %rcx
	leaq	4(%rcx), %rdi
	jae	.LBB18_33
.LBB18_2:
	.loc	19 24 8 is_stmt 1
	cmpq	$4, %rsi
	movl	$4, %r12d
	movq	%rsi, 168(%rsp)
	cmovbq	%rsi, %r12
	movl	$14, %ecx
	subq	%rdi, %rcx
	cmpq	$4, %rcx
	movl	$4, %esi
	cmovaeq	%rsi, %rcx
	.loc	19 9 8
	movd	%ecx, %xmm2
	pshufd	$0, %xmm2, %xmm2
	pcmpgtd	%xmm0, %xmm2
	movmskps	%xmm2, %r13d
	testb	$1, %r13b
	jne	.LBB18_3
	testb	$2, %r13b
	jne	.LBB18_5
.LBB18_6:
	testb	$4, %r13b
	jne	.LBB18_7
.LBB18_8:
	testb	$8, %r13b
	je	.LBB18_10
.LBB18_9:
	movl	$0, 12(%rsp)
.LBB18_10:
	.loc	19 0 8 is_stmt 0
	movq	152(%rsp), %rcx
	movq	%rdi, 160(%rsp)
	.loc	19 24 8 is_stmt 1
	leaq	(%rcx,%rdi,4), %rcx
	movq	%rcx, 184(%rsp)
	movq	144(%rsp), %rsi
	movq	%r15, 176(%rsp)
	xorl	%r9d, %r9d
	jmp	.LBB18_11
	.loc	19 0 8 is_stmt 0
.Ltmp83:
	.p2align	4
.LBB18_31:
	.loc	19 24 8 is_stmt 1
	incq	%r9
	addq	$3364, %r15
	addq	$36, %rsi
	cmpq	$32, %r9
	je	.LBB18_32
.LBB18_11:
	.loc	19 0 8 is_stmt 0
	xorl	%ecx, %ecx
	.p2align	4
.LBB18_12:
	.loc	19 24 8 is_stmt 1
	movss	(%rsp,%rcx,4), %xmm2
	movss	%xmm2, 64(%rsp,%rcx,4)
	incq	%rcx
	cmpq	%rcx, %r12
	jne	.LBB18_12
	movq	%r9, %r10
	orq	%rdx, %r10
	movq	%rsi, %r8
	movq	%r15, %rdi
	xorl	%r11d, %r11d
	.loc	19 0 8 is_stmt 0
.Ltmp84:
	.p2align	4
.LBB18_14:
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	.p2align	4
.LBB18_15:
	movss	64(%rsp,%r14,4), %xmm2
	xorl	%ecx, %ecx
	.p2align	4
.LBB18_16:
	.loc	19 24 8 is_stmt 1
	movss	(%rbx,%rcx,4), %xmm3
	.loc	19 26 10
	mulss	(%r8,%rcx,4), %xmm3
	.loc	19 27 10
	addss	%xmm3, %xmm2
	.loc	19 24 8
	incq	%rcx
	cmpq	$3, %rcx
	jne	.LBB18_16
	movss	%xmm2, 64(%rsp,%r14,4)
	incq	%r14
	addq	$8, %rbx
	cmpq	%r12, %r14
	jne	.LBB18_15
	incq	%r11
	addq	$116, %rdi
	addq	$12, %r8
	cmpq	$3, %r11
	jne	.LBB18_14
	.loc	19 0 8 is_stmt 0
	xorl	%ecx, %ecx
	.p2align	4
.LBB18_20:
	.loc	19 24 8 is_stmt 1
	movss	(%rsp,%rcx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rcx,4)
	incq	%rcx
	cmpq	%rcx, %r12
	jne	.LBB18_20
	.loc	19 0 8 is_stmt 0
	xorl	%ecx, %ecx
	.p2align	4
.LBB18_22:
	.loc	19 24 8 is_stmt 1
	movss	64(%rsp,%rcx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rcx,4)
	incq	%rcx
	cmpq	%rcx, %r12
	jne	.LBB18_22
	.loc	19 32 10
	movss	8780928(%rax,%r10,4), %xmm3
	shufps	$0, %xmm3, %xmm3
	addps	192(%rsp), %xmm3
	.loc	19 34 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm3, %xmm2
	andps	%xmm3, %xmm2
	.loc	19 36 10
	minps	%xmm1, %xmm2
	imulq	$784, %r10, %r8
	addq	184(%rsp), %r8
	testb	$1, %r13b
	jne	.LBB18_24
	testb	$2, %r13b
	jne	.LBB18_26
.LBB18_27:
	testb	$4, %r13b
	jne	.LBB18_28
.LBB18_29:
	testb	$8, %r13b
	je	.LBB18_31
	jmp	.LBB18_30
	.loc	19 0 10 is_stmt 0
.Ltmp85:
	.p2align	4
.LBB18_24:
	.loc	19 36 10
	movss	%xmm2, (%r8)
	testb	$2, %r13b
	je	.LBB18_27
.LBB18_26:
	movaps	%xmm2, %xmm3
	shufps	$85, %xmm2, %xmm3
	movss	%xmm3, 4(%r8)
	testb	$4, %r13b
	je	.LBB18_29
.LBB18_28:
	movaps	%xmm2, %xmm3
	unpckhpd	%xmm2, %xmm3
	movss	%xmm3, 8(%r8)
	testb	$8, %r13b
	je	.LBB18_31
.LBB18_30:
	shufps	$255, %xmm2, %xmm2
	movss	%xmm2, 12(%r8)
	jmp	.LBB18_31
	.loc	19 0 10
.Ltmp86:
	.p2align	4
.LBB18_3:
	.loc	19 9 8 is_stmt 1
	movl	$0, (%rsp)
	testb	$2, %r13b
	je	.LBB18_6
.LBB18_5:
	movl	$0, 4(%rsp)
	testb	$4, %r13b
	je	.LBB18_8
.LBB18_7:
	movl	$0, 8(%rsp)
	testb	$8, %r13b
	jne	.LBB18_9
	jmp	.LBB18_10
.LBB18_34:
	.loc	19 40 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	19 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp87:
.Lfunc_end18:
	.size	infer_dispatch_20_conv_14x14x192x3x3_f32, .Lfunc_end18-infer_dispatch_20_conv_14x14x192x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_21_matmul_like_64x196x192_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_21_matmul_like_64x196x192_f32,@function
infer_dispatch_21_matmul_like_64x196x192_f32:
.Lfunc_begin19:
	.file	20 "dump" "configured_module_infer_dispatch_21.mlir"
	.loc	20 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp88:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	20 14 8 prologue_end
	movq	32(%rsi), %rdi
	.loc	20 15 8
	movq	8(%rdi), %r8
	movl	$150528, %eax
	.loc	20 16 8
	addq	16(%rdi), %rax
	.loc	20 21 8
	movl	(%rdx), %r9d
	movl	%r9d, %esi
	andl	$3, %esi
	movq	%r9, %rcx
	shlq	$2, %rcx
	andq	$-16, %rcx
	imulq	$49, %rsi, %rdx
	imulq	$196, %rsi, %rsi
	addq	(%rdi), %rsi
	shrl	$2, %r9d
	leaq	(%r9,%r9,2), %rdi
	shlq	$12, %rdi
	addq	%r8, %rdi
	addq	$8249356, %rdi
	xorl	%r8d, %r8d
	leaq	__constant_64xf32(%rip), %r9
	.loc	20 0 8 is_stmt 0
.Ltmp89:
	.p2align	4
.LBB19_1:
	.loc	20 21 8
	movq	%r8, %r10
	orq	%rcx, %r10
	.loc	20 27 8 is_stmt 1
	movss	(%r9,%r10,4), %xmm0
	imulq	$784, %r10, %r10
	addq	%rax, %r10
	movq	%rsi, %r11
	xorl	%ebx, %ebx
	.loc	20 0 8 is_stmt 0
.Ltmp90:
	.p2align	4
.LBB19_2:
	.loc	20 21 8 is_stmt 1
	leaq	(%rbx,%rdx), %r14
	xorps	%xmm1, %xmm1
	movq	$-4, %r15
	movq	%r11, %r12
	.loc	20 0 8 is_stmt 0
.Ltmp91:
	.p2align	4
.LBB19_3:
	.loc	20 21 8
	movss	(%r12), %xmm2
	movss	784(%r12), %xmm3
	.loc	20 24 10 is_stmt 1
	mulss	4(%rdi,%r15,4), %xmm2
	.loc	20 21 8
	movss	1568(%r12), %xmm4
	.loc	20 24 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%r15,4), %xmm3
	.loc	20 21 8
	movss	2352(%r12), %xmm1
	.loc	20 24 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%r15,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%r15,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	20 21 8
	addq	$4, %r15
	addq	$3136, %r12
	cmpq	$188, %r15
	jb	.LBB19_3
	.loc	20 29 10
	addss	%xmm0, %xmm1
	.loc	20 21 8
	movss	%xmm1, (%r10,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$49, %rbx
	jne	.LBB19_2
	incq	%r8
	addq	$768, %rdi
	cmpq	$16, %r8
	jne	.LBB19_1
	.loc	20 33 8
	xorl	%eax, %eax
	.loc	20 33 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp92:
.Lfunc_end19:
	.size	infer_dispatch_21_matmul_like_64x196x192_f32, .Lfunc_end19-infer_dispatch_21_matmul_like_64x196x192_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI20_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_22_matmul_like_384x14x14x64_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_22_matmul_like_384x14x14x64_f32,@function
infer_dispatch_22_matmul_like_384x14x14x64_f32:
.Lfunc_begin20:
	.file	21 "dump" "configured_module_infer_dispatch_22.mlir"
	.loc	21 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp93:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	21 11 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %r10
	movl	(%rax), %r11d
	.loc	21 12 8
	movl	4(%rax), %r9d
	.loc	21 13 8
	movl	8(%rax), %ecx
	.loc	21 14 8
	movl	12(%rax), %eax
	.loc	21 25 8
	andl	$-4, %r11d
	.loc	21 26 8
	movq	8(%r10), %rbx
	andl	$-4, %r9d
	.loc	21 27 8
	andl	$-4, %ecx
	.loc	21 28 8
	andl	$-4, %eax
	addq	16(%r10), %rax
	movq	%rax, -48(%rbp)
	.loc	21 27 8
	addq	%rbx, %rcx
	.loc	21 34 8
	movl	(%rdx), %eax
	movl	%eax, %edx
	shrl	%edx
	leaq	(%rdx,%rdx,2), %r8
	shlq	$4, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%esi, %esi
	testb	$1, %al
	movl	$7, %edi
	cmoveq	%rsi, %rdi
	imulq	$56, %rdi, %rax
	addq	%r11, %rax
	addq	(%r10), %rax
	shlq	$12, %r8
	addq	%r9, %r8
	leaq	(%rbx,%r8), %r9
	addq	$12, %r9
	movss	.LCPI20_0(%rip), %xmm0
	.loc	21 0 8 is_stmt 0
.Ltmp94:
	.p2align	4
.LBB20_1:
	.loc	21 34 8
	leaq	(%rsi,%rdx), %r10
	.loc	21 40 8 is_stmt 1
	movss	(%rcx,%r10,4), %xmm1
	shlq	$10, %r10
	addq	-48(%rbp), %r10
	movq	%rax, %r8
	xorl	%ebx, %ebx
	.loc	21 0 8 is_stmt 0
.Ltmp95:
	.p2align	4
.LBB20_2:
	leaq	(%rbx,%rdi), %r11
	shlq	$6, %r11
	leaq	(%r10,%r11), %r14
	addq	$64, %r14
	movq	%r8, %r11
	xorl	%r12d, %r12d
	.p2align	4
.LBB20_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r13
	movq	%r11, %r15
	.p2align	4
.LBB20_4:
	.loc	21 34 8 is_stmt 1
	movss	(%r15), %xmm3
	movss	784(%r15), %xmm4
	.loc	21 37 10
	mulss	4(%r9,%r13,4), %xmm3
	.loc	21 34 8
	movss	1568(%r15), %xmm5
	.loc	21 37 10
	addss	%xmm2, %xmm3
	mulss	8(%r9,%r13,4), %xmm4
	.loc	21 34 8
	movss	2352(%r15), %xmm2
	.loc	21 37 10
	addss	%xmm3, %xmm4
	mulss	12(%r9,%r13,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%r9,%r13,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	21 34 8
	addq	$4, %r13
	addq	$3136, %r15
	cmpq	$60, %r13
	jb	.LBB20_4
	.loc	21 42 10
	addss	%xmm1, %xmm2
	.loc	21 34 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, 4(%r14,%r12,4)
	incq	%r12
	addq	$4, %r11
	cmpq	$14, %r12
	jne	.LBB20_3
	incq	%rbx
	addq	$56, %r8
	cmpq	$7, %rbx
	jne	.LBB20_2
	incq	%rsi
	addq	$256, %r9
	cmpq	$48, %rsi
	jne	.LBB20_1
	.loc	21 50 8
	xorl	%eax, %eax
	.loc	21 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp96:
.Lfunc_end20:
	.size	infer_dispatch_22_matmul_like_384x14x14x64_f32, .Lfunc_end20-infer_dispatch_22_matmul_like_384x14x14x64_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI21_0:
	.long	0
	.long	1
	.long	2
	.long	3
.LCPI21_1:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_23_conv_14x14x384x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_23_conv_14x14x384x3x3_f32,@function
infer_dispatch_23_conv_14x14x384x3x3_f32:
.Lfunc_begin21:
	.file	22 "dump" "configured_module_infer_dispatch_23.mlir"
	.loc	22 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp97:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	22 11 8 prologue_end
	movq	24(%rsi), %r9
	movq	32(%rsi), %rdi
	movl	(%r9), %r8d
	.loc	22 12 8
	movl	4(%r9), %ecx
	.loc	22 13 8
	movl	8(%r9), %eax
	.loc	22 14 8
	movl	12(%r9), %esi
	.loc	22 25 8
	andl	$-4, %r8d
	.loc	22 26 8
	movq	8(%rdi), %r9
	andl	$-4, %ecx
	.loc	22 27 8
	andl	$-4, %eax
	.loc	22 28 8
	andl	$-4, %esi
	addq	16(%rdi), %rsi
	movq	%rsi, 120(%rsp)
	.loc	22 27 8
	addq	%r9, %rax
	.loc	22 34 8
	movl	(%rdx), %r14d
	movq	%r14, %rsi
	leaq	(%r14,%r14,8), %r10
	shlq	$15, %r14
	addq	%r8, %r14
	addq	(%rdi), %r14
	shlq	$5, %rsi
	shlq	$7, %r10
	addq	%r9, %r10
	addq	%rcx, %r10
	movq	%r10, 144(%rsp)
	xorl	%ecx, %ecx
	movdqa	.LCPI21_0(%rip), %xmm0
	movaps	.LCPI21_1(%rip), %xmm1
	jmp	.LBB21_1
	.loc	22 0 8 is_stmt 0
.Ltmp98:
	.p2align	4
.LBB21_33:
	movq	128(%rsp), %rcx
	.loc	22 34 8
	incq	%rcx
	movq	136(%rsp), %r14
	addq	$64, %r14
	cmpq	$14, %rcx
	je	.LBB21_34
.LBB21_1:
	.loc	22 0 8
	movq	%rcx, 128(%rsp)
	imulq	$56, %rcx, %rcx
	addq	120(%rsp), %rcx
	movq	%rcx, 152(%rsp)
	movq	%r14, 136(%rsp)
	movl	$14, %edi
	xorl	%r8d, %r8d
	jmp	.LBB21_2
	.p2align	4
.LBB21_32:
	movq	168(%rsp), %rdi
	.loc	22 34 8
	addq	$-4, %rdi
	movq	176(%rsp), %r14
	addq	$16, %r14
	movq	160(%rsp), %rcx
	cmpq	$10, %rcx
	leaq	4(%rcx), %r8
	jae	.LBB21_33
.LBB21_2:
	.loc	22 34 8 is_stmt 1
	cmpq	$4, %rdi
	movl	$4, %r15d
	cmovbq	%rdi, %r15
	movl	$14, %ecx
	subq	%r8, %rcx
	cmpq	$4, %rcx
	movl	$4, %edx
	cmovaeq	%rdx, %rcx
	.loc	22 10 8
	movd	%ecx, %xmm2
	pshufd	$0, %xmm2, %xmm2
	pcmpgtd	%xmm0, %xmm2
	movmskps	%xmm2, %r12d
	testb	$1, %r12b
	jne	.LBB21_3
	testb	$2, %r12b
	jne	.LBB21_5
.LBB21_6:
	testb	$4, %r12b
	jne	.LBB21_7
.LBB21_8:
	.loc	22 0 8 is_stmt 0
	movq	%rdi, 168(%rsp)
	.loc	22 10 8
	testb	$8, %r12b
	je	.LBB21_10
.LBB21_9:
	movl	$0, 12(%rsp)
.LBB21_10:
	.loc	22 0 8
	movq	152(%rsp), %rcx
	movq	%r8, 160(%rsp)
	.loc	22 34 8 is_stmt 1
	leaq	(%rcx,%r8,4), %rcx
	movq	%rcx, 184(%rsp)
	movq	144(%rsp), %rcx
	movq	%r14, 176(%rsp)
	xorl	%r8d, %r8d
	jmp	.LBB21_11
	.loc	22 0 8 is_stmt 0
.Ltmp99:
	.p2align	4
.LBB21_31:
	.loc	22 34 8 is_stmt 1
	incq	%r8
	addq	$1024, %r14
	addq	$36, %rcx
	cmpq	$32, %r8
	je	.LBB21_32
.LBB21_11:
	.loc	22 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB21_12:
	.loc	22 34 8 is_stmt 1
	movss	(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 64(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB21_12
	leaq	(%r8,%rsi), %r9
	movq	%rcx, %rdi
	movq	%r14, %rdx
	xorl	%r10d, %r10d
	.loc	22 0 8 is_stmt 0
.Ltmp100:
	.p2align	4
.LBB21_14:
	movq	%rdx, %r11
	xorl	%ebx, %ebx
	.p2align	4
.LBB21_15:
	movss	64(%rsp,%rbx,4), %xmm2
	xorl	%r13d, %r13d
	.p2align	4
.LBB21_16:
	.loc	22 34 8 is_stmt 1
	movss	(%r11,%r13,4), %xmm3
	.loc	22 36 10
	mulss	(%rdi,%r13,4), %xmm3
	.loc	22 37 10
	addss	%xmm3, %xmm2
	.loc	22 34 8
	incq	%r13
	cmpq	$3, %r13
	jne	.LBB21_16
	movss	%xmm2, 64(%rsp,%rbx,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	%r15, %rbx
	jne	.LBB21_15
	incq	%r10
	addq	$64, %rdx
	addq	$12, %rdi
	cmpq	$3, %r10
	jne	.LBB21_14
	.loc	22 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB21_20:
	.loc	22 34 8 is_stmt 1
	movss	(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB21_20
	.loc	22 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB21_22:
	.loc	22 34 8 is_stmt 1
	movss	64(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB21_22
	.loc	22 42 10
	movss	(%rax,%r9,4), %xmm3
	shufps	$0, %xmm3, %xmm3
	addps	192(%rsp), %xmm3
	.loc	22 44 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm3, %xmm2
	andps	%xmm3, %xmm2
	.loc	22 46 10
	minps	%xmm1, %xmm2
	imulq	$784, %r9, %rdi
	addq	184(%rsp), %rdi
	testb	$1, %r12b
	jne	.LBB21_24
	testb	$2, %r12b
	jne	.LBB21_26
.LBB21_27:
	testb	$4, %r12b
	jne	.LBB21_28
.LBB21_29:
	testb	$8, %r12b
	je	.LBB21_31
	jmp	.LBB21_30
	.loc	22 0 10 is_stmt 0
.Ltmp101:
	.p2align	4
.LBB21_24:
	.loc	22 46 10
	movss	%xmm2, (%rdi)
	testb	$2, %r12b
	je	.LBB21_27
.LBB21_26:
	movaps	%xmm2, %xmm3
	shufps	$85, %xmm2, %xmm3
	movss	%xmm3, 4(%rdi)
	testb	$4, %r12b
	je	.LBB21_29
.LBB21_28:
	movaps	%xmm2, %xmm3
	unpckhpd	%xmm2, %xmm3
	movss	%xmm3, 8(%rdi)
	testb	$8, %r12b
	je	.LBB21_31
.LBB21_30:
	shufps	$255, %xmm2, %xmm2
	movss	%xmm2, 12(%rdi)
	jmp	.LBB21_31
	.loc	22 0 10
.Ltmp102:
	.p2align	4
.LBB21_3:
	.loc	22 10 8 is_stmt 1
	movl	$0, (%rsp)
	testb	$2, %r12b
	je	.LBB21_6
.LBB21_5:
	movl	$0, 4(%rsp)
	testb	$4, %r12b
	je	.LBB21_8
.LBB21_7:
	movl	$0, 8(%rsp)
	movq	%rdi, 168(%rsp)
	testb	$8, %r12b
	jne	.LBB21_9
	jmp	.LBB21_10
.LBB21_34:
	.loc	22 50 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	22 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp103:
.Lfunc_end21:
	.size	infer_dispatch_23_conv_14x14x384x3x3_f32, .Lfunc_end21-infer_dispatch_23_conv_14x14x384x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_24_matmul_like_64x196x384_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_24_matmul_like_64x196x384_f32,@function
infer_dispatch_24_matmul_like_64x196x384_f32:
.Lfunc_begin22:
	.file	23 "dump" "configured_module_infer_dispatch_24.mlir"
	.loc	23 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp104:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	23 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rax
	.loc	23 16 8
	movq	8(%rcx), %r8
	.loc	23 18 8
	movq	16(%rcx), %rcx
	.loc	23 24 8
	movl	(%rdx), %r9d
	movl	%r9d, %edi
	andl	$3, %edi
	movq	%r9, %rdx
	shlq	$2, %rdx
	andq	$-16, %rdx
	imulq	$49, %rdi, %rsi
	imulq	$196, %rdi, %rdi
	addq	%rax, %rdi
	addq	$596272, %rdi
	shrl	$2, %r9d
	leaq	(%r9,%r9,2), %r9
	shlq	$13, %r9
	addq	%r9, %r8
	addq	$8052748, %r8
	xorl	%r9d, %r9d
	leaq	__constant_64xf32_0(%rip), %r10
	.loc	23 0 8 is_stmt 0
.Ltmp105:
	.p2align	4
.LBB22_1:
	.loc	23 24 8
	movq	%r9, %r11
	orq	%rdx, %r11
	.loc	23 30 8 is_stmt 1
	movss	(%r10,%r11,4), %xmm0
	imulq	$196, %r11, %r11
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	.loc	23 0 8 is_stmt 0
.Ltmp106:
	.p2align	4
.LBB22_2:
	.loc	23 24 8 is_stmt 1
	leaq	(%r14,%rsi), %r15
	xorps	%xmm1, %xmm1
	movq	$-4, %r12
	movq	%rbx, %r13
	.loc	23 0 8 is_stmt 0
.Ltmp107:
	.p2align	4
.LBB22_3:
	.loc	23 24 8
	movss	-2352(%r13), %xmm2
	movss	-1568(%r13), %xmm3
	.loc	23 27 10 is_stmt 1
	mulss	4(%r8,%r12,4), %xmm2
	.loc	23 24 8
	movss	-784(%r13), %xmm4
	.loc	23 27 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r12,4), %xmm3
	.loc	23 24 8
	movss	(%r13), %xmm1
	.loc	23 27 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r12,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r12,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	23 24 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$380, %r12
	jb	.LBB22_3
	.loc	23 30 8
	addq	%r11, %r15
	.loc	23 33 10
	addss	%xmm0, %xmm1
	addss	150528(%rax,%r15,4), %xmm1
	.loc	23 24 8
	movss	%xmm1, (%rcx,%r15,4)
	incq	%r14
	addq	$4, %rbx
	cmpq	$49, %r14
	jne	.LBB22_2
	incq	%r9
	addq	$1536, %r8
	cmpq	$16, %r9
	jne	.LBB22_1
	.loc	23 37 8
	xorl	%eax, %eax
	.loc	23 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp108:
.Lfunc_end22:
	.size	infer_dispatch_24_matmul_like_64x196x384_f32, .Lfunc_end22-infer_dispatch_24_matmul_like_64x196x384_f32
	.cfi_endproc

	.section	.text.infer_dispatch_27_matmul_like_64x196x384_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_27_matmul_like_64x196x384_f32,@function
infer_dispatch_27_matmul_like_64x196x384_f32:
.Lfunc_begin23:
	.file	24 "dump" "configured_module_infer_dispatch_27.mlir"
	.loc	24 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp109:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	24 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rax
	.loc	24 16 8
	movq	8(%rcx), %r8
	.loc	24 18 8
	movq	16(%rcx), %rcx
	.loc	24 24 8
	movl	(%rdx), %r9d
	movl	%r9d, %edi
	andl	$3, %edi
	movq	%r9, %rdx
	shlq	$2, %rdx
	andq	$-16, %rdx
	imulq	$49, %rdi, %rsi
	imulq	$196, %rdi, %rdi
	addq	%rax, %rdi
	addq	$596272, %rdi
	shrl	$2, %r9d
	leaq	(%r9,%r9,2), %r9
	shlq	$13, %r9
	addq	%r9, %r8
	addq	$7856140, %r8
	xorl	%r9d, %r9d
	leaq	__constant_64xf32_1(%rip), %r10
	.loc	24 0 8 is_stmt 0
.Ltmp110:
	.p2align	4
.LBB23_1:
	.loc	24 24 8
	movq	%r9, %r11
	orq	%rdx, %r11
	.loc	24 30 8 is_stmt 1
	movss	(%r10,%r11,4), %xmm0
	imulq	$196, %r11, %r11
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	.loc	24 0 8 is_stmt 0
.Ltmp111:
	.p2align	4
.LBB23_2:
	.loc	24 24 8 is_stmt 1
	leaq	(%r14,%rsi), %r15
	xorps	%xmm1, %xmm1
	movq	$-4, %r12
	movq	%rbx, %r13
	.loc	24 0 8 is_stmt 0
.Ltmp112:
	.p2align	4
.LBB23_3:
	.loc	24 24 8
	movss	-2352(%r13), %xmm2
	movss	-1568(%r13), %xmm3
	.loc	24 27 10 is_stmt 1
	mulss	4(%r8,%r12,4), %xmm2
	.loc	24 24 8
	movss	-784(%r13), %xmm4
	.loc	24 27 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r12,4), %xmm3
	.loc	24 24 8
	movss	(%r13), %xmm1
	.loc	24 27 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r12,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r12,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	24 24 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$380, %r12
	jb	.LBB23_3
	.loc	24 30 8
	addq	%r11, %r15
	.loc	24 33 10
	addss	%xmm0, %xmm1
	addss	(%rax,%r15,4), %xmm1
	.loc	24 24 8
	movss	%xmm1, 50176(%rcx,%r15,4)
	incq	%r14
	addq	$4, %rbx
	cmpq	$49, %r14
	jne	.LBB23_2
	incq	%r9
	addq	$1536, %r8
	cmpq	$16, %r9
	jne	.LBB23_1
	.loc	24 37 8
	xorl	%eax, %eax
	.loc	24 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp113:
.Lfunc_end23:
	.size	infer_dispatch_27_matmul_like_64x196x384_f32, .Lfunc_end23-infer_dispatch_27_matmul_like_64x196x384_f32
	.cfi_endproc

	.section	.text.infer_dispatch_30_matmul_like_64x196x384_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_30_matmul_like_64x196x384_f32,@function
infer_dispatch_30_matmul_like_64x196x384_f32:
.Lfunc_begin24:
	.file	25 "dump" "configured_module_infer_dispatch_30.mlir"
	.loc	25 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp114:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	25 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rax
	.loc	25 16 8
	movq	8(%rcx), %r8
	.loc	25 18 8
	movq	16(%rcx), %rcx
	.loc	25 24 8
	movl	(%rdx), %r9d
	movl	%r9d, %edi
	andl	$3, %edi
	movq	%r9, %rdx
	shlq	$2, %rdx
	andq	$-16, %rdx
	imulq	$49, %rdi, %rsi
	imulq	$196, %rdi, %rdi
	addq	%rax, %rdi
	addq	$495920, %rdi
	shrl	$2, %r9d
	leaq	(%r9,%r9,2), %r9
	shlq	$13, %r9
	addq	%r9, %r8
	addq	$7659532, %r8
	xorl	%r9d, %r9d
	leaq	__constant_64xf32_2(%rip), %r10
	.loc	25 0 8 is_stmt 0
.Ltmp115:
	.p2align	4
.LBB24_1:
	.loc	25 24 8
	movq	%r9, %r11
	orq	%rdx, %r11
	.loc	25 30 8 is_stmt 1
	movss	(%r10,%r11,4), %xmm0
	imulq	$196, %r11, %r11
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	.loc	25 0 8 is_stmt 0
.Ltmp116:
	.p2align	4
.LBB24_2:
	.loc	25 24 8 is_stmt 1
	leaq	(%r14,%rsi), %r15
	xorps	%xmm1, %xmm1
	movq	$-4, %r12
	movq	%rbx, %r13
	.loc	25 0 8 is_stmt 0
.Ltmp117:
	.p2align	4
.LBB24_3:
	.loc	25 24 8
	movss	-2352(%r13), %xmm2
	movss	-1568(%r13), %xmm3
	.loc	25 27 10 is_stmt 1
	mulss	4(%r8,%r12,4), %xmm2
	.loc	25 24 8
	movss	-784(%r13), %xmm4
	.loc	25 27 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r12,4), %xmm3
	.loc	25 24 8
	movss	(%r13), %xmm1
	.loc	25 27 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r12,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r12,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	25 24 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$380, %r12
	jb	.LBB24_3
	.loc	25 30 8
	addq	%r11, %r15
	.loc	25 33 10
	addss	%xmm0, %xmm1
	addss	50176(%rax,%r15,4), %xmm1
	.loc	25 24 8
	movss	%xmm1, (%rcx,%r15,4)
	incq	%r14
	addq	$4, %rbx
	cmpq	$49, %r14
	jne	.LBB24_2
	incq	%r9
	addq	$1536, %r8
	cmpq	$16, %r9
	jne	.LBB24_1
	.loc	25 37 8
	xorl	%eax, %eax
	.loc	25 37 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp118:
.Lfunc_end24:
	.size	infer_dispatch_30_matmul_like_64x196x384_f32, .Lfunc_end24-infer_dispatch_30_matmul_like_64x196x384_f32
	.cfi_endproc

	.section	.text.infer_dispatch_33_matmul_like_96x196x384_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_33_matmul_like_96x196x384_f32,@function
infer_dispatch_33_matmul_like_96x196x384_f32:
.Lfunc_begin25:
	.file	26 "dump" "configured_module_infer_dispatch_33.mlir"
	.loc	26 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp119:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	26 14 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rdi
	.loc	26 15 8
	movq	8(%rcx), %rax
	.loc	26 17 8
	movq	16(%rcx), %rcx
	.loc	26 23 8
	movl	(%rdx), %r8d
	movl	%r8d, %r9d
	shrl	$2, %r9d
	andl	$3, %r8d
	leaq	(,%r9,8), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	imulq	$49, %r8, %rsi
	imulq	$196, %r8, %r8
	addq	%r8, %rdi
	addq	$495920, %rdi
	leaq	(%r9,%r9,8), %r8
	shlq	$12, %r8
	addq	%rax, %r8
	addq	$7413772, %r8
	xorl	%r9d, %r9d
	.loc	26 0 8 is_stmt 0
.Ltmp120:
	.p2align	4
.LBB25_1:
	.loc	26 23 8
	leaq	(%r9,%rdx), %r10
	.loc	26 29 8 is_stmt 1
	movss	8827904(%rax,%r10,4), %xmm0
	imulq	$784, %r10, %r10
	addq	%rcx, %r10
	movq	%rdi, %r11
	xorl	%ebx, %ebx
	.loc	26 0 8 is_stmt 0
.Ltmp121:
	.p2align	4
.LBB25_2:
	.loc	26 23 8 is_stmt 1
	leaq	(%rbx,%rsi), %r14
	xorps	%xmm1, %xmm1
	movq	$-4, %r15
	movq	%r11, %r12
	.loc	26 0 8 is_stmt 0
.Ltmp122:
	.p2align	4
.LBB25_3:
	.loc	26 23 8
	movss	-2352(%r12), %xmm2
	movss	-1568(%r12), %xmm3
	.loc	26 26 10 is_stmt 1
	mulss	4(%r8,%r15,4), %xmm2
	.loc	26 23 8
	movss	-784(%r12), %xmm4
	.loc	26 26 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r15,4), %xmm3
	.loc	26 23 8
	movss	(%r12), %xmm1
	.loc	26 26 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r15,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r15,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	26 23 8
	addq	$4, %r15
	addq	$3136, %r12
	cmpq	$380, %r15
	jb	.LBB25_3
	.loc	26 31 10
	addss	%xmm0, %xmm1
	.loc	26 23 8
	movss	%xmm1, (%r10,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$49, %rbx
	jne	.LBB25_2
	incq	%r9
	addq	$1536, %r8
	cmpq	$24, %r9
	jne	.LBB25_1
	.loc	26 35 8
	xorl	%eax, %eax
	.loc	26 35 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp123:
.Lfunc_end25:
	.size	infer_dispatch_33_matmul_like_96x196x384_f32, .Lfunc_end25-infer_dispatch_33_matmul_like_96x196x384_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI26_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_34_matmul_like_576x14x14x96_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_34_matmul_like_576x14x14x96_f32,@function
infer_dispatch_34_matmul_like_576x14x14x96_f32:
.Lfunc_begin26:
	.file	27 "dump" "configured_module_infer_dispatch_34.mlir"
	.loc	27 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp124:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	27 11 8 prologue_end
	movq	24(%rsi), %r8
	movq	32(%rsi), %r9
	movl	(%r8), %eax
	.loc	27 12 8
	movl	4(%r8), %edi
	.loc	27 13 8
	movl	8(%r8), %ecx
	.loc	27 25 8
	andl	$-4, %eax
	addq	(%r9), %rax
	.loc	27 14 8
	movl	12(%r8), %esi
	.loc	27 26 8
	movq	8(%r9), %r8
	andl	$-4, %edi
	.loc	27 27 8
	andl	$-4, %ecx
	addq	%r8, %rcx
	.loc	27 28 8
	andl	$-4, %esi
	addq	16(%r9), %rsi
	.loc	27 34 8
	movl	(%rdx), %edx
	leaq	(%rdx,%rdx,2), %r9
	shlq	$6, %rdx
	shlq	$13, %r9
	addq	%rdi, %r9
	leaq	(%r8,%r9), %rdi
	addq	$12, %rdi
	xorl	%r8d, %r8d
	movss	.LCPI26_0(%rip), %xmm0
	.loc	27 0 8 is_stmt 0
.Ltmp125:
	.p2align	4
.LBB26_1:
	.loc	27 34 8
	leaq	(%r8,%rdx), %r9
	.loc	27 40 8 is_stmt 1
	movss	(%rcx,%r9,4), %xmm1
	shlq	$10, %r9
	addq	%rsi, %r9
	movq	%rax, %r10
	xorl	%r11d, %r11d
	.loc	27 0 8 is_stmt 0
.Ltmp126:
	.p2align	4
.LBB26_2:
	movq	%r11, %rbx
	shlq	$6, %rbx
	addq	%r9, %rbx
	addq	$64, %rbx
	movq	%r10, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB26_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r12
	movq	%r14, %r13
	.p2align	4
.LBB26_4:
	.loc	27 34 8 is_stmt 1
	movss	(%r13), %xmm3
	movss	784(%r13), %xmm4
	.loc	27 37 10
	mulss	4(%rdi,%r12,4), %xmm3
	.loc	27 34 8
	movss	1568(%r13), %xmm5
	.loc	27 37 10
	addss	%xmm2, %xmm3
	mulss	8(%rdi,%r12,4), %xmm4
	.loc	27 34 8
	movss	2352(%r13), %xmm2
	.loc	27 37 10
	addss	%xmm3, %xmm4
	mulss	12(%rdi,%r12,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%rdi,%r12,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	27 34 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$92, %r12
	jb	.LBB26_4
	.loc	27 42 10
	addss	%xmm1, %xmm2
	.loc	27 34 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, 4(%rbx,%r15,4)
	incq	%r15
	addq	$4, %r14
	cmpq	$14, %r15
	jne	.LBB26_3
	incq	%r11
	addq	$56, %r10
	cmpq	$14, %r11
	jne	.LBB26_2
	incq	%r8
	addq	$384, %rdi
	cmpq	$64, %r8
	jne	.LBB26_1
	.loc	27 50 8
	xorl	%eax, %eax
	.loc	27 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp127:
.Lfunc_end26:
	.size	infer_dispatch_34_matmul_like_576x14x14x96_f32, .Lfunc_end26-infer_dispatch_34_matmul_like_576x14x14x96_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI27_0:
	.long	0
	.long	1
	.long	2
	.long	3
.LCPI27_1:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_35_conv_14x14x576x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_35_conv_14x14x576x3x3_f32,@function
infer_dispatch_35_conv_14x14x576x3x3_f32:
.Lfunc_begin27:
	.file	28 "dump" "configured_module_infer_dispatch_35.mlir"
	.loc	28 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp128:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	28 11 8 prologue_end
	movq	24(%rsi), %r9
	movq	32(%rsi), %rdi
	movl	(%r9), %r8d
	.loc	28 12 8
	movl	4(%r9), %ecx
	.loc	28 13 8
	movl	8(%r9), %eax
	.loc	28 14 8
	movl	12(%r9), %esi
	.loc	28 25 8
	andl	$-4, %r8d
	.loc	28 26 8
	movq	8(%rdi), %r9
	andl	$-4, %ecx
	.loc	28 27 8
	andl	$-4, %eax
	.loc	28 28 8
	andl	$-4, %esi
	addq	16(%rdi), %rsi
	movq	%rsi, 120(%rsp)
	.loc	28 27 8
	addq	%r9, %rax
	.loc	28 34 8
	movl	(%rdx), %r14d
	movq	%r14, %rsi
	leaq	(%r14,%r14,8), %r10
	shlq	$15, %r14
	addq	%r8, %r14
	addq	(%rdi), %r14
	shlq	$5, %rsi
	shlq	$7, %r10
	addq	%r9, %r10
	addq	%rcx, %r10
	movq	%r10, 144(%rsp)
	xorl	%ecx, %ecx
	movdqa	.LCPI27_0(%rip), %xmm0
	movaps	.LCPI27_1(%rip), %xmm1
	jmp	.LBB27_1
	.loc	28 0 8 is_stmt 0
.Ltmp129:
	.p2align	4
.LBB27_33:
	movq	128(%rsp), %rcx
	.loc	28 34 8
	incq	%rcx
	movq	136(%rsp), %r14
	addq	$64, %r14
	cmpq	$14, %rcx
	je	.LBB27_34
.LBB27_1:
	.loc	28 0 8
	movq	%rcx, 128(%rsp)
	imulq	$56, %rcx, %rcx
	addq	120(%rsp), %rcx
	movq	%rcx, 152(%rsp)
	movq	%r14, 136(%rsp)
	movl	$14, %edi
	xorl	%r8d, %r8d
	jmp	.LBB27_2
	.p2align	4
.LBB27_32:
	movq	168(%rsp), %rdi
	.loc	28 34 8
	addq	$-4, %rdi
	movq	176(%rsp), %r14
	addq	$16, %r14
	movq	160(%rsp), %rcx
	cmpq	$10, %rcx
	leaq	4(%rcx), %r8
	jae	.LBB27_33
.LBB27_2:
	.loc	28 34 8 is_stmt 1
	cmpq	$4, %rdi
	movl	$4, %r15d
	cmovbq	%rdi, %r15
	movl	$14, %ecx
	subq	%r8, %rcx
	cmpq	$4, %rcx
	movl	$4, %edx
	cmovaeq	%rdx, %rcx
	.loc	28 10 8
	movd	%ecx, %xmm2
	pshufd	$0, %xmm2, %xmm2
	pcmpgtd	%xmm0, %xmm2
	movmskps	%xmm2, %r12d
	testb	$1, %r12b
	jne	.LBB27_3
	testb	$2, %r12b
	jne	.LBB27_5
.LBB27_6:
	testb	$4, %r12b
	jne	.LBB27_7
.LBB27_8:
	.loc	28 0 8 is_stmt 0
	movq	%rdi, 168(%rsp)
	.loc	28 10 8
	testb	$8, %r12b
	je	.LBB27_10
.LBB27_9:
	movl	$0, 12(%rsp)
.LBB27_10:
	.loc	28 0 8
	movq	152(%rsp), %rcx
	movq	%r8, 160(%rsp)
	.loc	28 34 8 is_stmt 1
	leaq	(%rcx,%r8,4), %rcx
	movq	%rcx, 184(%rsp)
	movq	144(%rsp), %rcx
	movq	%r14, 176(%rsp)
	xorl	%r8d, %r8d
	jmp	.LBB27_11
	.loc	28 0 8 is_stmt 0
.Ltmp130:
	.p2align	4
.LBB27_31:
	.loc	28 34 8 is_stmt 1
	incq	%r8
	addq	$1024, %r14
	addq	$36, %rcx
	cmpq	$32, %r8
	je	.LBB27_32
.LBB27_11:
	.loc	28 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB27_12:
	.loc	28 34 8 is_stmt 1
	movss	(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 64(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB27_12
	leaq	(%r8,%rsi), %r9
	movq	%rcx, %rdi
	movq	%r14, %rdx
	xorl	%r10d, %r10d
	.loc	28 0 8 is_stmt 0
.Ltmp131:
	.p2align	4
.LBB27_14:
	movq	%rdx, %r11
	xorl	%ebx, %ebx
	.p2align	4
.LBB27_15:
	movss	64(%rsp,%rbx,4), %xmm2
	xorl	%r13d, %r13d
	.p2align	4
.LBB27_16:
	.loc	28 34 8 is_stmt 1
	movss	(%r11,%r13,4), %xmm3
	.loc	28 36 10
	mulss	(%rdi,%r13,4), %xmm3
	.loc	28 37 10
	addss	%xmm3, %xmm2
	.loc	28 34 8
	incq	%r13
	cmpq	$3, %r13
	jne	.LBB27_16
	movss	%xmm2, 64(%rsp,%rbx,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	%r15, %rbx
	jne	.LBB27_15
	incq	%r10
	addq	$64, %rdx
	addq	$12, %rdi
	cmpq	$3, %r10
	jne	.LBB27_14
	.loc	28 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB27_20:
	.loc	28 34 8 is_stmt 1
	movss	(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB27_20
	.loc	28 0 8 is_stmt 0
	xorl	%edx, %edx
	.p2align	4
.LBB27_22:
	.loc	28 34 8 is_stmt 1
	movss	64(%rsp,%rdx,4), %xmm2
	movss	%xmm2, 192(%rsp,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r15
	jne	.LBB27_22
	.loc	28 42 10
	movss	(%rax,%r9,4), %xmm3
	shufps	$0, %xmm3, %xmm3
	addps	192(%rsp), %xmm3
	.loc	28 44 10
	xorps	%xmm2, %xmm2
	cmpleps	%xmm3, %xmm2
	andps	%xmm3, %xmm2
	.loc	28 46 10
	minps	%xmm1, %xmm2
	imulq	$784, %r9, %rdi
	addq	184(%rsp), %rdi
	testb	$1, %r12b
	jne	.LBB27_24
	testb	$2, %r12b
	jne	.LBB27_26
.LBB27_27:
	testb	$4, %r12b
	jne	.LBB27_28
.LBB27_29:
	testb	$8, %r12b
	je	.LBB27_31
	jmp	.LBB27_30
	.loc	28 0 10 is_stmt 0
.Ltmp132:
	.p2align	4
.LBB27_24:
	.loc	28 46 10
	movss	%xmm2, (%rdi)
	testb	$2, %r12b
	je	.LBB27_27
.LBB27_26:
	movaps	%xmm2, %xmm3
	shufps	$85, %xmm2, %xmm3
	movss	%xmm3, 4(%rdi)
	testb	$4, %r12b
	je	.LBB27_29
.LBB27_28:
	movaps	%xmm2, %xmm3
	unpckhpd	%xmm2, %xmm3
	movss	%xmm3, 8(%rdi)
	testb	$8, %r12b
	je	.LBB27_31
.LBB27_30:
	shufps	$255, %xmm2, %xmm2
	movss	%xmm2, 12(%rdi)
	jmp	.LBB27_31
	.loc	28 0 10
.Ltmp133:
	.p2align	4
.LBB27_3:
	.loc	28 10 8 is_stmt 1
	movl	$0, (%rsp)
	testb	$2, %r12b
	je	.LBB27_6
.LBB27_5:
	movl	$0, 4(%rsp)
	testb	$4, %r12b
	je	.LBB27_8
.LBB27_7:
	movl	$0, 8(%rsp)
	movq	%rdi, 168(%rsp)
	testb	$8, %r12b
	jne	.LBB27_9
	jmp	.LBB27_10
.LBB27_34:
	.loc	28 50 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	28 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp134:
.Lfunc_end27:
	.size	infer_dispatch_35_conv_14x14x576x3x3_f32, .Lfunc_end27-infer_dispatch_35_conv_14x14x576x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_36_matmul_like_96x196x576_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_36_matmul_like_96x196x576_f32,@function
infer_dispatch_36_matmul_like_96x196x576_f32:
.Lfunc_begin28:
	.file	29 "dump" "configured_module_infer_dispatch_36.mlir"
	.loc	29 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp135:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	29 10 8 prologue_end
	movq	24(%rsi), %rdi
	movq	32(%rsi), %r8
	movl	(%rdi), %r10d
	.loc	29 11 8
	movl	4(%rdi), %eax
	.loc	29 12 8
	movl	8(%rdi), %r9d
	.loc	29 13 8
	movl	12(%rdi), %ecx
	.loc	29 14 8
	movl	16(%rdi), %esi
	.loc	29 27 8
	andl	$-4, %r10d
	movq	(%r8), %rbx
	.loc	29 28 8
	movq	8(%r8), %r11
	andl	$-4, %r9d
	.loc	29 29 8
	andl	$-4, %ecx
	addq	%r11, %rcx
	.loc	29 30 8
	andl	$-4, %eax
	addq	%rbx, %rax
	.loc	29 31 8
	andl	$-4, %esi
	addq	16(%r8), %rsi
	.loc	29 38 8
	movl	(%rdx), %r8d
	movl	%r8d, %r14d
	shrl	$2, %r14d
	andl	$3, %r8d
	leaq	(,%r14,8), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	imulq	$49, %r8, %rdi
	imulq	$196, %r8, %r8
	addq	%rbx, %r8
	addq	%r10, %r8
	imulq	$55296, %r14, %r10
	addq	%r9, %r10
	leaq	(%r11,%r10), %r9
	addq	$12, %r9
	xorl	%r10d, %r10d
	.loc	29 0 8 is_stmt 0
.Ltmp136:
	.p2align	4
.LBB28_1:
	.loc	29 38 8
	leaq	(%r10,%rdx), %r11
	.loc	29 44 8 is_stmt 1
	movss	(%rcx,%r11,4), %xmm0
	imulq	$196, %r11, %r11
	movq	%r8, %rbx
	xorl	%r14d, %r14d
	.loc	29 0 8 is_stmt 0
.Ltmp137:
	.p2align	4
.LBB28_2:
	.loc	29 38 8 is_stmt 1
	leaq	(%r14,%rdi), %r15
	xorps	%xmm1, %xmm1
	movq	$-4, %r12
	movq	%rbx, %r13
	.loc	29 0 8 is_stmt 0
.Ltmp138:
	.p2align	4
.LBB28_3:
	.loc	29 38 8
	movss	(%r13), %xmm2
	movss	784(%r13), %xmm3
	.loc	29 41 10 is_stmt 1
	mulss	4(%r9,%r12,4), %xmm2
	.loc	29 38 8
	movss	1568(%r13), %xmm4
	.loc	29 41 10
	addss	%xmm1, %xmm2
	mulss	8(%r9,%r12,4), %xmm3
	.loc	29 38 8
	movss	2352(%r13), %xmm1
	.loc	29 41 10
	addss	%xmm2, %xmm3
	mulss	12(%r9,%r12,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r9,%r12,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	29 38 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$572, %r12
	jb	.LBB28_3
	.loc	29 44 8
	addq	%r11, %r15
	.loc	29 47 10
	addss	%xmm0, %xmm1
	addss	(%rax,%r15,4), %xmm1
	.loc	29 38 8
	movss	%xmm1, (%rsi,%r15,4)
	incq	%r14
	addq	$4, %rbx
	cmpq	$49, %r14
	jne	.LBB28_2
	incq	%r10
	addq	$2304, %r9
	cmpq	$24, %r10
	jne	.LBB28_1
	.loc	29 51 8
	xorl	%eax, %eax
	.loc	29 51 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp139:
.Lfunc_end28:
	.size	infer_dispatch_36_matmul_like_96x196x576_f32, .Lfunc_end28-infer_dispatch_36_matmul_like_96x196x576_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI29_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_40_matmul_like_576x14x14x96_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_40_matmul_like_576x14x14x96_f32,@function
infer_dispatch_40_matmul_like_576x14x14x96_f32:
.Lfunc_begin29:
	.file	30 "dump" "configured_module_infer_dispatch_40.mlir"
	.loc	30 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp140:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	30 15 8 prologue_end
	movq	32(%rsi), %rdi
	.loc	30 16 8
	movq	8(%rdi), %rax
	movl	$602112, %ecx
	.loc	30 18 8
	addq	16(%rdi), %rcx
	.loc	30 24 8
	movl	(%rdx), %edx
	movl	$453936, %esi
	addq	(%rdi), %rsi
	leaq	(%rdx,%rdx,2), %rdi
	shlq	$6, %rdx
	shlq	$13, %rdi
	addq	%rax, %rdi
	addq	$6307852, %rdi
	xorl	%r8d, %r8d
	movss	.LCPI29_0(%rip), %xmm0
	.loc	30 0 8 is_stmt 0
.Ltmp141:
	.p2align	4
.LBB29_1:
	.loc	30 24 8
	leaq	(%r8,%rdx), %r9
	.loc	30 30 8 is_stmt 1
	movss	8813312(%rax,%r9,4), %xmm1
	imulq	$900, %r9, %r9
	addq	%rcx, %r9
	movq	%rsi, %r10
	xorl	%r11d, %r11d
	.loc	30 0 8 is_stmt 0
.Ltmp142:
	.p2align	4
.LBB29_2:
	imulq	$60, %r11, %rbx
	addq	%r9, %rbx
	movq	%r10, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB29_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r12
	movq	%r14, %r13
	.p2align	4
.LBB29_4:
	.loc	30 24 8 is_stmt 1
	movss	-2352(%r13), %xmm3
	movss	-1568(%r13), %xmm4
	.loc	30 27 10
	mulss	4(%rdi,%r12,4), %xmm3
	.loc	30 24 8
	movss	-784(%r13), %xmm5
	.loc	30 27 10
	addss	%xmm2, %xmm3
	mulss	8(%rdi,%r12,4), %xmm4
	.loc	30 24 8
	movss	(%r13), %xmm2
	.loc	30 27 10
	addss	%xmm3, %xmm4
	mulss	12(%rdi,%r12,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%rdi,%r12,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	30 24 8
	addq	$4, %r12
	addq	$3136, %r13
	cmpq	$92, %r12
	jb	.LBB29_4
	.loc	30 32 10
	addss	%xmm1, %xmm2
	.loc	30 24 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, (%rbx,%r15,4)
	incq	%r15
	addq	$4, %r14
	cmpq	$14, %r15
	jne	.LBB29_3
	incq	%r11
	addq	$56, %r10
	cmpq	$14, %r11
	jne	.LBB29_2
	incq	%r8
	addq	$384, %rdi
	cmpq	$64, %r8
	jne	.LBB29_1
	.loc	30 40 8
	xorl	%eax, %eax
	.loc	30 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp143:
.Lfunc_end29:
	.size	infer_dispatch_40_matmul_like_576x14x14x96_f32, .Lfunc_end29-infer_dispatch_40_matmul_like_576x14x14x96_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI30_0:
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
.LCPI30_1:
	.long	2147483648
	.long	2147483649
	.long	2147483650
	.long	2147483651
.LCPI30_2:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_41_conv_7x7x576x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_41_conv_7x7x576x3x3_f32,@function
infer_dispatch_41_conv_7x7x576x3x3_f32:
.Lfunc_begin30:
	.file	31 "dump" "configured_module_infer_dispatch_41.mlir"
	.loc	31 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp144:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	31 15 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rcx
	.loc	31 16 8
	movq	8(%rax), %rdi
	.loc	31 18 8
	movq	16(%rax), %rax
	movq	%rax, 152(%rsp)
	.loc	31 24 8
	movl	(%rdx), %edx
	imulq	$28800, %rdx, %rax
	leaq	(%rdx,%rdx,8), %rsi
	shlq	$5, %rdx
	movq	%rdx, 184(%rsp)
	addq	%rcx, %rax
	addq	$602112, %rax
	movq	%rax, 120(%rsp)
	shlq	$7, %rsi
	movq	%rdi, %rdx
	leaq	(%rsi,%rdi), %rax
	addq	$8602368, %rax
	movq	%rax, 168(%rsp)
	xorl	%ecx, %ecx
	movdqa	.LCPI30_0(%rip), %xmm0
	movdqa	.LCPI30_1(%rip), %xmm1
	movaps	.LCPI30_2(%rip), %xmm2
	jmp	.LBB30_1
	.loc	31 0 8 is_stmt 0
.Ltmp145:
	.p2align	4
.LBB30_33:
	movq	160(%rsp), %rcx
	.loc	31 24 8
	incq	%rcx
	addq	$120, 120(%rsp)
	cmpq	$7, %rcx
	je	.LBB30_34
.LBB30_1:
	.loc	31 0 8
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rax
	movq	%rcx, 160(%rsp)
	addq	%rcx, %rax
	addq	152(%rsp), %rax
	movq	%rax, 176(%rsp)
	movb	$1, %al
	movl	$4, %r11d
	xorl	%ecx, %ecx
	jmp	.LBB30_2
	.p2align	4
.LBB30_32:
	movl	$4, %ecx
	movl	$3, %r11d
	.loc	31 24 8
	testb	$1, 60(%rsp)
	movl	$0, %eax
	je	.LBB30_33
.LBB30_2:
	.loc	31 9 8 is_stmt 1
	movd	%r11d, %xmm3
	pshufd	$0, %xmm3, %xmm3
	pxor	%xmm0, %xmm3
	pcmpgtd	%xmm1, %xmm3
	movmskps	%xmm3, %ebx
	testb	$1, %bl
	jne	.LBB30_3
	testb	$2, %bl
	jne	.LBB30_5
.LBB30_6:
	testb	$4, %bl
	jne	.LBB30_7
.LBB30_8:
	.loc	31 0 8 is_stmt 0
	movl	%eax, 60(%rsp)
	.loc	31 9 8
	testb	$8, %bl
	je	.LBB30_10
.LBB30_9:
	movl	$0, 76(%rsp)
.LBB30_10:
	.loc	31 0 8
	movq	176(%rsp), %rax
	.loc	31 24 8 is_stmt 1
	leaq	(%rax,%rcx,4), %r14
	movq	120(%rsp), %rax
	leaq	(%rax,%rcx,8), %r9
	movq	168(%rsp), %rdi
	xorl	%r13d, %r13d
	jmp	.LBB30_11
	.loc	31 0 8 is_stmt 0
.Ltmp146:
	.p2align	4
.LBB30_31:
	.loc	31 24 8 is_stmt 1
	incq	%r13
	addq	$900, %r9
	addq	$36, %rdi
	cmpq	$32, %r13
	je	.LBB30_32
.LBB30_11:
	.loc	31 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB30_12:
	.loc	31 24 8 is_stmt 1
	movss	64(%rsp,%rax,4), %xmm3
	movss	%xmm3, 128(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB30_12
	.loc	31 0 8 is_stmt 0
	movq	184(%rsp), %rax
	.loc	31 24 8
	leaq	(%rax,%r13), %rcx
	movq	%rdi, %r12
	movq	%r9, %r8
	xorl	%esi, %esi
	.loc	31 0 8
.Ltmp147:
	.p2align	4
.LBB30_14:
	movq	%r8, %r15
	xorl	%r10d, %r10d
	.p2align	4
.LBB30_15:
	movss	128(%rsp,%r10,4), %xmm3
	xorl	%eax, %eax
	.p2align	4
.LBB30_16:
	.loc	31 24 8 is_stmt 1
	movss	(%r15,%rax,4), %xmm4
	.loc	31 26 10
	mulss	(%r12,%rax,4), %xmm4
	.loc	31 27 10
	addss	%xmm4, %xmm3
	.loc	31 24 8
	incq	%rax
	cmpq	$3, %rax
	jne	.LBB30_16
	movss	%xmm3, 128(%rsp,%r10,4)
	incq	%r10
	addq	$8, %r15
	cmpq	%r11, %r10
	jne	.LBB30_15
	incq	%rsi
	addq	$60, %r8
	addq	$12, %r12
	cmpq	$3, %rsi
	jne	.LBB30_14
	.loc	31 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB30_20:
	.loc	31 24 8 is_stmt 1
	movss	64(%rsp,%rax,4), %xmm3
	movss	%xmm3, 192(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB30_20
	.loc	31 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB30_22:
	.loc	31 24 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm3
	movss	%xmm3, 192(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB30_22
	.loc	31 32 10
	movss	8815616(%rdx,%rcx,4), %xmm4
	shufps	$0, %xmm4, %xmm4
	addps	192(%rsp), %xmm4
	.loc	31 34 10
	xorps	%xmm3, %xmm3
	cmpleps	%xmm4, %xmm3
	andps	%xmm4, %xmm3
	.loc	31 36 10
	minps	%xmm2, %xmm3
	imulq	$196, %rcx, %rcx
	addq	%r14, %rcx
	testb	$1, %bl
	jne	.LBB30_24
	testb	$2, %bl
	jne	.LBB30_26
.LBB30_27:
	testb	$4, %bl
	jne	.LBB30_28
.LBB30_29:
	testb	$8, %bl
	je	.LBB30_31
	jmp	.LBB30_30
	.loc	31 0 10 is_stmt 0
.Ltmp148:
	.p2align	4
.LBB30_24:
	.loc	31 36 10
	movss	%xmm3, (%rcx)
	testb	$2, %bl
	je	.LBB30_27
.LBB30_26:
	movaps	%xmm3, %xmm4
	shufps	$85, %xmm3, %xmm4
	movss	%xmm4, 4(%rcx)
	testb	$4, %bl
	je	.LBB30_29
.LBB30_28:
	movaps	%xmm3, %xmm4
	unpckhpd	%xmm3, %xmm4
	movss	%xmm4, 8(%rcx)
	testb	$8, %bl
	je	.LBB30_31
.LBB30_30:
	shufps	$255, %xmm3, %xmm3
	movss	%xmm3, 12(%rcx)
	jmp	.LBB30_31
	.loc	31 0 10
.Ltmp149:
	.p2align	4
.LBB30_3:
	.loc	31 9 8 is_stmt 1
	movl	$0, 64(%rsp)
	testb	$2, %bl
	je	.LBB30_6
.LBB30_5:
	movl	$0, 68(%rsp)
	testb	$4, %bl
	je	.LBB30_8
.LBB30_7:
	movl	$0, 72(%rsp)
	movl	%eax, 60(%rsp)
	testb	$8, %bl
	jne	.LBB30_9
	jmp	.LBB30_10
.LBB30_34:
	.loc	31 40 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	31 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp150:
.Lfunc_end30:
	.size	infer_dispatch_41_conv_7x7x576x3x3_f32, .Lfunc_end30-infer_dispatch_41_conv_7x7x576x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_42_matmul_like_160x49x576_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_42_matmul_like_160x49x576_f32,@function
infer_dispatch_42_matmul_like_160x49x576_f32:
.Lfunc_begin31:
	.file	32 "dump" "configured_module_infer_dispatch_42.mlir"
	.loc	32 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp151:
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.loc	32 14 8 prologue_end
	movq	32(%rsi), %rdi
	movq	(%rdi), %rax
	.loc	32 15 8
	movq	8(%rdi), %rcx
	movl	$112896, %esi
	.loc	32 17 8
	addq	16(%rdi), %rsi
	.loc	32 23 8
	movl	(%rdx), %edx
	leaq	(%rdx,%rdx,8), %rdi
	shlq	$4, %rdx
	shlq	$12, %rdi
	addq	%rcx, %rdi
	addq	$5939212, %rdi
	xorl	%r8d, %r8d
	.loc	32 0 8 is_stmt 0
.Ltmp152:
	.p2align	4
.LBB31_1:
	.loc	32 23 8
	leaq	(%r8,%rdx), %r9
	.loc	32 29 8 is_stmt 1
	movss	8812672(%rcx,%r9,4), %xmm0
	imulq	$196, %r9, %r9
	addq	%rsi, %r9
	movq	%rax, %r10
	xorl	%r11d, %r11d
	.loc	32 0 8 is_stmt 0
.Ltmp153:
	.p2align	4
.LBB31_2:
	xorps	%xmm1, %xmm1
	movq	$-4, %rbx
	movq	%r10, %r14
	.p2align	4
.LBB31_3:
	.loc	32 23 8 is_stmt 1
	movss	(%r14), %xmm2
	movss	196(%r14), %xmm3
	.loc	32 26 10
	mulss	4(%rdi,%rbx,4), %xmm2
	.loc	32 23 8
	movss	392(%r14), %xmm4
	.loc	32 26 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%rbx,4), %xmm3
	.loc	32 23 8
	movss	588(%r14), %xmm1
	.loc	32 26 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%rbx,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%rbx,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	32 23 8
	addq	$4, %rbx
	addq	$784, %r14
	cmpq	$572, %rbx
	jb	.LBB31_3
	.loc	32 31 10
	addss	%xmm0, %xmm1
	.loc	32 23 8
	movss	%xmm1, (%r9,%r11,4)
	incq	%r11
	addq	$4, %r10
	cmpq	$49, %r11
	jne	.LBB31_2
	incq	%r8
	addq	$2304, %rdi
	cmpq	$16, %r8
	jne	.LBB31_1
	.loc	32 35 8
	xorl	%eax, %eax
	.loc	32 35 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r14
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp154:
.Lfunc_end31:
	.size	infer_dispatch_42_matmul_like_160x49x576_f32, .Lfunc_end31-infer_dispatch_42_matmul_like_160x49x576_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI32_0:
	.long	0x40c00000
	.section	.text.infer_dispatch_43_matmul_like_960x7x7x160_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_43_matmul_like_960x7x7x160_f32,@function
infer_dispatch_43_matmul_like_960x7x7x160_f32:
.Lfunc_begin32:
	.file	33 "dump" "configured_module_infer_dispatch_43.mlir"
	.loc	33 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp155:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	33 11 8 prologue_end
	movq	24(%rsi), %r8
	movq	32(%rsi), %r9
	movl	(%r8), %eax
	.loc	33 12 8
	movl	4(%r8), %edi
	.loc	33 13 8
	movl	8(%r8), %ecx
	.loc	33 25 8
	andl	$-4, %eax
	addq	(%r9), %rax
	.loc	33 14 8
	movl	12(%r8), %esi
	.loc	33 26 8
	movq	8(%r9), %r8
	andl	$-4, %edi
	.loc	33 27 8
	andl	$-4, %ecx
	addq	%r8, %rcx
	.loc	33 28 8
	andl	$-4, %esi
	addq	16(%r9), %rsi
	.loc	33 34 8
	movl	(%rdx), %edx
	leaq	(%rdx,%rdx,4), %r9
	shlq	$6, %rdx
	shlq	$13, %r9
	addq	%rdi, %r9
	leaq	(%r8,%r9), %rdi
	addq	$12, %rdi
	xorl	%r8d, %r8d
	movss	.LCPI32_0(%rip), %xmm0
	.loc	33 0 8 is_stmt 0
.Ltmp156:
	.p2align	4
.LBB32_1:
	.loc	33 34 8
	leaq	(%r8,%rdx), %r9
	.loc	33 40 8 is_stmt 1
	movss	(%rcx,%r9,4), %xmm1
	imulq	$324, %r9, %r9
	addq	%rsi, %r9
	movq	%rax, %r10
	xorl	%r11d, %r11d
	.loc	33 0 8 is_stmt 0
.Ltmp157:
	.p2align	4
.LBB32_2:
	leaq	(%r11,%r11,8), %rbx
	leaq	(%r9,%rbx,4), %rbx
	addq	$36, %rbx
	movq	%r10, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB32_3:
	xorps	%xmm2, %xmm2
	movq	$-4, %r12
	movq	%r14, %r13
	.p2align	4
.LBB32_4:
	.loc	33 34 8 is_stmt 1
	movss	(%r13), %xmm3
	movss	196(%r13), %xmm4
	.loc	33 37 10
	mulss	4(%rdi,%r12,4), %xmm3
	.loc	33 34 8
	movss	392(%r13), %xmm5
	.loc	33 37 10
	addss	%xmm2, %xmm3
	mulss	8(%rdi,%r12,4), %xmm4
	.loc	33 34 8
	movss	588(%r13), %xmm2
	.loc	33 37 10
	addss	%xmm3, %xmm4
	mulss	12(%rdi,%r12,4), %xmm5
	addss	%xmm4, %xmm5
	mulss	16(%rdi,%r12,4), %xmm2
	addss	%xmm5, %xmm2
	.loc	33 34 8
	addq	$4, %r12
	addq	$784, %r13
	cmpq	$156, %r12
	jb	.LBB32_4
	.loc	33 42 10
	addss	%xmm1, %xmm2
	.loc	33 34 8
	xorps	%xmm3, %xmm3
	cmpless	%xmm2, %xmm3
	andps	%xmm2, %xmm3
	minss	%xmm0, %xmm3
	movss	%xmm3, 4(%rbx,%r15,4)
	incq	%r15
	addq	$4, %r14
	cmpq	$7, %r15
	jne	.LBB32_3
	incq	%r11
	addq	$28, %r10
	cmpq	$7, %r11
	jne	.LBB32_2
	incq	%r8
	addq	$640, %rdi
	cmpq	$64, %r8
	jne	.LBB32_1
	.loc	33 50 8
	xorl	%eax, %eax
	.loc	33 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp158:
.Lfunc_end32:
	.size	infer_dispatch_43_matmul_like_960x7x7x160_f32, .Lfunc_end32-infer_dispatch_43_matmul_like_960x7x7x160_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI33_0:
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
.LCPI33_1:
	.long	2147483648
	.long	2147483649
	.long	2147483650
	.long	2147483651
.LCPI33_2:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.section	.text.infer_dispatch_44_conv_7x7x960x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_44_conv_7x7x960x3x3_f32,@function
infer_dispatch_44_conv_7x7x960x3x3_f32:
.Lfunc_begin33:
	.file	34 "dump" "configured_module_infer_dispatch_44.mlir"
	.loc	34 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp159:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	34 11 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %rsi
	movl	(%rax), %r8d
	.loc	34 12 8
	movl	4(%rax), %ecx
	.loc	34 13 8
	movl	8(%rax), %edi
	.loc	34 14 8
	movl	12(%rax), %eax
	.loc	34 25 8
	andl	$-4, %r8d
	.loc	34 26 8
	movq	8(%rsi), %r9
	andl	$-4, %ecx
	.loc	34 27 8
	andl	$-4, %edi
	.loc	34 28 8
	andl	$-4, %eax
	addq	16(%rsi), %rax
	movq	%rax, 152(%rsp)
	.loc	34 27 8
	addq	%r9, %rdi
	movq	%rdi, 184(%rsp)
	.loc	34 34 8
	movl	(%rdx), %edi
	imulq	$10368, %rdi, %rax
	leaq	(%rdi,%rdi,8), %rdx
	addq	%r8, %rax
	addq	(%rsi), %rax
	movq	%rax, 120(%rsp)
	shlq	$5, %rdi
	shlq	$7, %rdx
	addq	%r9, %rdx
	addq	%rcx, %rdx
	movq	%rdx, 168(%rsp)
	xorl	%ecx, %ecx
	movdqa	.LCPI33_0(%rip), %xmm0
	movdqa	.LCPI33_1(%rip), %xmm1
	movaps	.LCPI33_2(%rip), %xmm2
	jmp	.LBB33_1
	.loc	34 0 8 is_stmt 0
.Ltmp160:
	.p2align	4
.LBB33_33:
	movq	160(%rsp), %rcx
	.loc	34 34 8
	incq	%rcx
	addq	$36, 120(%rsp)
	cmpq	$7, %rcx
	je	.LBB33_34
.LBB33_1:
	.loc	34 0 8
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rax
	movq	%rcx, 160(%rsp)
	addq	%rcx, %rax
	addq	152(%rsp), %rax
	movq	%rax, 176(%rsp)
	movb	$1, %al
	movl	$4, %r11d
	xorl	%ecx, %ecx
	jmp	.LBB33_2
	.p2align	4
.LBB33_32:
	movl	$4, %ecx
	movl	$3, %r11d
	.loc	34 34 8
	testb	$1, 60(%rsp)
	movl	$0, %eax
	je	.LBB33_33
.LBB33_2:
	.loc	34 10 8 is_stmt 1
	movd	%r11d, %xmm3
	pshufd	$0, %xmm3, %xmm3
	pxor	%xmm0, %xmm3
	pcmpgtd	%xmm1, %xmm3
	movmskps	%xmm3, %ebx
	testb	$1, %bl
	jne	.LBB33_3
	testb	$2, %bl
	jne	.LBB33_5
.LBB33_6:
	testb	$4, %bl
	jne	.LBB33_7
.LBB33_8:
	.loc	34 0 8 is_stmt 0
	movl	%eax, 60(%rsp)
	.loc	34 10 8
	testb	$8, %bl
	je	.LBB33_10
.LBB33_9:
	movl	$0, 76(%rsp)
.LBB33_10:
	.loc	34 0 8
	movq	176(%rsp), %rax
	.loc	34 34 8 is_stmt 1
	leaq	(%rax,%rcx,4), %r14
	movq	120(%rsp), %rax
	leaq	(%rax,%rcx,4), %r9
	movq	168(%rsp), %rsi
	xorl	%r13d, %r13d
	jmp	.LBB33_11
	.loc	34 0 8 is_stmt 0
.Ltmp161:
	.p2align	4
.LBB33_31:
	.loc	34 34 8 is_stmt 1
	incq	%r13
	addq	$324, %r9
	addq	$36, %rsi
	cmpq	$32, %r13
	je	.LBB33_32
.LBB33_11:
	.loc	34 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB33_12:
	.loc	34 34 8 is_stmt 1
	movss	64(%rsp,%rax,4), %xmm3
	movss	%xmm3, 128(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB33_12
	leaq	(%rdi,%r13), %rcx
	movq	%rsi, %r12
	movq	%r9, %r8
	xorl	%edx, %edx
	.loc	34 0 8 is_stmt 0
.Ltmp162:
	.p2align	4
.LBB33_14:
	movq	%r8, %r15
	xorl	%r10d, %r10d
	.p2align	4
.LBB33_15:
	movss	128(%rsp,%r10,4), %xmm3
	xorl	%eax, %eax
	.p2align	4
.LBB33_16:
	.loc	34 34 8 is_stmt 1
	movss	(%r15,%rax,4), %xmm4
	.loc	34 36 10
	mulss	(%r12,%rax,4), %xmm4
	.loc	34 37 10
	addss	%xmm4, %xmm3
	.loc	34 34 8
	incq	%rax
	cmpq	$3, %rax
	jne	.LBB33_16
	movss	%xmm3, 128(%rsp,%r10,4)
	incq	%r10
	addq	$4, %r15
	cmpq	%r11, %r10
	jne	.LBB33_15
	incq	%rdx
	addq	$36, %r8
	addq	$12, %r12
	cmpq	$3, %rdx
	jne	.LBB33_14
	.loc	34 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB33_20:
	.loc	34 34 8 is_stmt 1
	movss	64(%rsp,%rax,4), %xmm3
	movss	%xmm3, 192(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB33_20
	.loc	34 0 8 is_stmt 0
	xorl	%eax, %eax
	.p2align	4
.LBB33_22:
	.loc	34 34 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm3
	movss	%xmm3, 192(%rsp,%rax,4)
	incq	%rax
	cmpq	%rax, %r11
	jne	.LBB33_22
	.loc	34 0 8 is_stmt 0
	movq	184(%rsp), %rax
	.loc	34 42 10 is_stmt 1
	movss	(%rax,%rcx,4), %xmm4
	shufps	$0, %xmm4, %xmm4
	addps	192(%rsp), %xmm4
	.loc	34 44 10
	xorps	%xmm3, %xmm3
	cmpleps	%xmm4, %xmm3
	andps	%xmm4, %xmm3
	.loc	34 46 10
	minps	%xmm2, %xmm3
	imulq	$196, %rcx, %rcx
	addq	%r14, %rcx
	testb	$1, %bl
	jne	.LBB33_24
	testb	$2, %bl
	jne	.LBB33_26
.LBB33_27:
	testb	$4, %bl
	jne	.LBB33_28
.LBB33_29:
	testb	$8, %bl
	je	.LBB33_31
	jmp	.LBB33_30
	.loc	34 0 10 is_stmt 0
.Ltmp163:
	.p2align	4
.LBB33_24:
	.loc	34 46 10
	movss	%xmm3, (%rcx)
	testb	$2, %bl
	je	.LBB33_27
.LBB33_26:
	movaps	%xmm3, %xmm4
	shufps	$85, %xmm3, %xmm4
	movss	%xmm4, 4(%rcx)
	testb	$4, %bl
	je	.LBB33_29
.LBB33_28:
	movaps	%xmm3, %xmm4
	unpckhpd	%xmm3, %xmm4
	movss	%xmm4, 8(%rcx)
	testb	$8, %bl
	je	.LBB33_31
.LBB33_30:
	shufps	$255, %xmm3, %xmm3
	movss	%xmm3, 12(%rcx)
	jmp	.LBB33_31
	.loc	34 0 10
.Ltmp164:
	.p2align	4
.LBB33_3:
	.loc	34 10 8 is_stmt 1
	movl	$0, 64(%rsp)
	testb	$2, %bl
	je	.LBB33_6
.LBB33_5:
	movl	$0, 68(%rsp)
	testb	$4, %bl
	je	.LBB33_8
.LBB33_7:
	movl	$0, 72(%rsp)
	movl	%eax, 60(%rsp)
	testb	$8, %bl
	jne	.LBB33_9
	jmp	.LBB33_10
.LBB33_34:
	.loc	34 50 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	34 50 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp165:
.Lfunc_end33:
	.size	infer_dispatch_44_conv_7x7x960x3x3_f32, .Lfunc_end33-infer_dispatch_44_conv_7x7x960x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_45_matmul_like_160x49x960_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_45_matmul_like_160x49x960_f32,@function
infer_dispatch_45_matmul_like_160x49x960_f32:
.Lfunc_begin34:
	.file	35 "dump" "configured_module_infer_dispatch_45.mlir"
	.loc	35 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp166:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	35 11 8 prologue_end
	movq	24(%rsi), %rdi
	movq	32(%rsi), %r10
	movl	(%rdi), %eax
	.loc	35 12 8
	movl	4(%rdi), %r8d
	.loc	35 13 8
	movl	8(%rdi), %ecx
	.loc	35 14 8
	movl	12(%rdi), %esi
	.loc	35 25 8
	movq	(%r10), %rdi
	.loc	35 26 8
	movq	8(%r10), %r9
	andl	$-4, %r8d
	.loc	35 27 8
	andl	$-4, %ecx
	addq	%r9, %rcx
	.loc	35 28 8
	andl	$-4, %eax
	.loc	35 29 8
	andl	$-4, %esi
	addq	16(%r10), %rsi
	.loc	35 28 8
	addq	%rdi, %rax
	.loc	35 36 8
	movl	(%rdx), %edx
	addq	$455884, %rdi
	imulq	$61440, %rdx, %r10
	shlq	$4, %rdx
	addq	%r8, %r10
	leaq	(%r9,%r10), %r8
	addq	$12, %r8
	xorl	%r9d, %r9d
	.loc	35 0 8 is_stmt 0
.Ltmp167:
	.p2align	4
.LBB34_1:
	.loc	35 36 8
	leaq	(%r9,%rdx), %r10
	.loc	35 42 8 is_stmt 1
	movss	(%rcx,%r10,4), %xmm0
	imulq	$49, %r10, %r10
	movq	%rdi, %r11
	xorl	%ebx, %ebx
	.loc	35 0 8 is_stmt 0
.Ltmp168:
	.p2align	4
.LBB34_2:
	xorps	%xmm1, %xmm1
	movq	$-4, %r14
	movq	%r11, %r15
	.p2align	4
.LBB34_3:
	.loc	35 36 8 is_stmt 1
	movss	-588(%r15), %xmm2
	movss	-392(%r15), %xmm3
	.loc	35 39 10
	mulss	4(%r8,%r14,4), %xmm2
	.loc	35 36 8
	movss	-196(%r15), %xmm4
	.loc	35 39 10
	addss	%xmm1, %xmm2
	mulss	8(%r8,%r14,4), %xmm3
	.loc	35 36 8
	movss	(%r15), %xmm1
	.loc	35 39 10
	addss	%xmm2, %xmm3
	mulss	12(%r8,%r14,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%r8,%r14,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	35 36 8
	addq	$4, %r14
	addq	$784, %r15
	cmpq	$956, %r14
	jb	.LBB34_3
	.loc	35 42 8
	leaq	(%rbx,%r10), %r14
	.loc	35 45 10
	addss	%xmm0, %xmm1
	addss	(%rax,%r14,4), %xmm1
	.loc	35 36 8
	movss	%xmm1, (%rsi,%r14,4)
	incq	%rbx
	addq	$4, %r11
	cmpq	$49, %rbx
	jne	.LBB34_2
	incq	%r9
	addq	$3840, %r8
	cmpq	$16, %r9
	jne	.LBB34_1
	.loc	35 49 8
	xorl	%eax, %eax
	.loc	35 49 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp169:
.Lfunc_end34:
	.size	infer_dispatch_45_matmul_like_160x49x960_f32, .Lfunc_end34-infer_dispatch_45_matmul_like_160x49x960_f32
	.cfi_endproc

	.section	.text.infer_dispatch_51_matmul_like_320x49x960_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_51_matmul_like_320x49x960_f32,@function
infer_dispatch_51_matmul_like_320x49x960_f32:
.Lfunc_begin35:
	.file	36 "dump" "configured_module_infer_dispatch_51.mlir"
	.loc	36 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp170:
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.loc	36 14 8 prologue_end
	movq	32(%rsi), %rsi
	.loc	36 15 8
	movq	8(%rsi), %rax
	.loc	36 17 8
	movq	16(%rsi), %rcx
	.loc	36 23 8
	movl	(%rdx), %edi
	leaq	(,%rdi,8), %r8
	movl	$374348, %edx
	addq	(%rsi), %rdx
	leaq	(%r8,%r8,4), %rsi
	imulq	$153600, %rdi, %rdi
	addq	%rax, %rdi
	addq	$1638412, %rdi
	xorl	%r8d, %r8d
	.loc	36 0 8 is_stmt 0
.Ltmp171:
	.p2align	4
.LBB35_1:
	.loc	36 23 8
	leaq	(%r8,%rsi), %r9
	.loc	36 29 8 is_stmt 1
	movss	8787072(%rax,%r9,4), %xmm0
	imulq	$196, %r9, %r9
	addq	%rcx, %r9
	movq	%rdx, %r10
	xorl	%r11d, %r11d
	.loc	36 0 8 is_stmt 0
.Ltmp172:
	.p2align	4
.LBB35_2:
	xorps	%xmm1, %xmm1
	movq	$-4, %rbx
	movq	%r10, %r14
	.p2align	4
.LBB35_3:
	.loc	36 23 8 is_stmt 1
	movss	-588(%r14), %xmm2
	movss	-392(%r14), %xmm3
	.loc	36 26 10
	mulss	4(%rdi,%rbx,4), %xmm2
	.loc	36 23 8
	movss	-196(%r14), %xmm4
	.loc	36 26 10
	addss	%xmm1, %xmm2
	mulss	8(%rdi,%rbx,4), %xmm3
	.loc	36 23 8
	movss	(%r14), %xmm1
	.loc	36 26 10
	addss	%xmm2, %xmm3
	mulss	12(%rdi,%rbx,4), %xmm4
	addss	%xmm3, %xmm4
	mulss	16(%rdi,%rbx,4), %xmm1
	addss	%xmm4, %xmm1
	.loc	36 23 8
	addq	$4, %rbx
	addq	$784, %r14
	cmpq	$956, %rbx
	jb	.LBB35_3
	.loc	36 31 10
	addss	%xmm0, %xmm1
	.loc	36 23 8
	movss	%xmm1, (%r9,%r11,4)
	incq	%r11
	addq	$4, %r10
	cmpq	$49, %r11
	jne	.LBB35_2
	incq	%r8
	addq	$3840, %rdi
	cmpq	$40, %r8
	jne	.LBB35_1
	.loc	36 35 8
	xorl	%eax, %eax
	.loc	36 35 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r14
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp173:
.Lfunc_end35:
	.size	infer_dispatch_51_matmul_like_320x49x960_f32, .Lfunc_end35-infer_dispatch_51_matmul_like_320x49x960_f32
	.cfi_endproc

	.section	.text.infer_dispatch_52_matmul_like_1280x49x320_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_52_matmul_like_1280x49x320_f32,@function
infer_dispatch_52_matmul_like_1280x49x320_f32:
.Lfunc_begin36:
	.file	37 "dump" "configured_module_infer_dispatch_52.mlir"
	.loc	37 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp174:
	pushq	%rbx
	.cfi_offset %rbx, -24
	.loc	37 12 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rax
	.loc	37 13 8
	movq	8(%rsi), %rdi
	movl	$62720, %ecx
	.loc	37 14 8
	addq	16(%rsi), %rcx
	.loc	37 19 8
	movl	(%rdx), %edx
	leaq	(%rdx,%rdx,4), %rsi
	shlq	$6, %rdx
	shlq	$14, %rsi
	addq	%rdi, %rsi
	addq	$12, %rsi
	xorl	%edi, %edi
	.loc	37 0 8 is_stmt 0
.Ltmp175:
	.p2align	4
.LBB36_1:
	.loc	37 19 8
	leaq	(%rdi,%rdx), %r8
	imulq	$196, %r8, %r8
	addq	%rcx, %r8
	movq	%rax, %r9
	xorl	%r10d, %r10d
	.loc	37 0 8
.Ltmp176:
	.p2align	4
.LBB36_2:
	xorps	%xmm0, %xmm0
	movq	$-4, %r11
	movq	%r9, %rbx
	.p2align	4
.LBB36_3:
	.loc	37 19 8 is_stmt 1
	movss	(%rbx), %xmm1
	movss	196(%rbx), %xmm2
	.loc	37 22 10
	mulss	4(%rsi,%r11,4), %xmm1
	.loc	37 19 8
	movss	392(%rbx), %xmm3
	.loc	37 22 10
	addss	%xmm0, %xmm1
	mulss	8(%rsi,%r11,4), %xmm2
	.loc	37 19 8
	movss	588(%rbx), %xmm0
	.loc	37 22 10
	addss	%xmm1, %xmm2
	mulss	12(%rsi,%r11,4), %xmm3
	addss	%xmm2, %xmm3
	mulss	16(%rsi,%r11,4), %xmm0
	addss	%xmm3, %xmm0
	.loc	37 19 8
	addq	$4, %r11
	addq	$784, %rbx
	cmpq	$316, %r11
	jb	.LBB36_3
	movss	%xmm0, (%r8,%r10,4)
	incq	%r10
	addq	$4, %r9
	cmpq	$49, %r10
	jne	.LBB36_2
	incq	%rdi
	addq	$1280, %rsi
	cmpq	$64, %rdi
	jne	.LBB36_1
	.loc	37 26 8
	xorl	%eax, %eax
	.loc	37 26 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp177:
.Lfunc_end36:
	.size	infer_dispatch_52_matmul_like_1280x49x320_f32, .Lfunc_end36-infer_dispatch_52_matmul_like_1280x49x320_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI37_0:
	.long	0
	.long	1
	.long	2
	.long	3
.LCPI37_1:
	.long	2147483648
	.long	2147483648
	.long	2147483648
	.long	2147483648
.LCPI37_2:
	.long	2147483648
	.long	2147483649
	.long	2147483650
	.long	2147483651
.LCPI37_3:
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
	.long	0x40c00000
.LCPI37_4:
	.long	0x42440000
	.long	0x42440000
	.long	0x42440000
	.long	0x42440000
	.section	.text.infer_dispatch_53_reduction_1280x49_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_53_reduction_1280x49_f32,@function
infer_dispatch_53_reduction_1280x49_f32:
.Lfunc_begin37:
	.file	38 "dump" "configured_module_infer_dispatch_53.mlir"
	.loc	38 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp178:
	.loc	38 15 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rsi
	.loc	38 16 8
	movq	8(%rcx), %rax
	.loc	38 17 8
	movq	16(%rcx), %rcx
	.loc	38 22 8
	movl	(%rdx), %edx
	imulq	$6272, %rdx, %rdi
	shlq	$5, %rdx
	addq	%rdi, %rsi
	addq	$63320, %rsi
	xorl	%edi, %edi
	movdqa	.LCPI37_1(%rip), %xmm1
	movaps	.LCPI37_3(%rip), %xmm3
	jmp	.LBB37_1
	.loc	38 0 8 is_stmt 0
.Ltmp179:
	.p2align	4
.LBB37_35:
	.loc	38 34 10 is_stmt 1
	divps	.LCPI37_4(%rip), %xmm9
	.loc	38 22 8
	movaps	%xmm9, (%rcx,%r8,4)
	addq	$784, %rsi
	cmpq	$28, %rdi
	leaq	4(%rdi), %rdi
	jae	.LBB37_36
.LBB37_1:
	leaq	(%rdi,%rdx), %r8
	movaps	8832128(%rax,%r8,4), %xmm5
	movaps	%xmm5, %xmm6
	shufps	$0, %xmm5, %xmm6
	movaps	%xmm5, %xmm7
	shufps	$85, %xmm5, %xmm7
	movaps	%xmm5, %xmm8
	shufps	$170, %xmm5, %xmm8
	shufps	$255, %xmm5, %xmm5
	movq	$-4, %r9
	movl	$49, %r10d
	xorps	%xmm9, %xmm9
	jmp	.LBB37_2
	.loc	38 0 8 is_stmt 0
.Ltmp180:
	.p2align	4
.LBB37_34:
	.loc	38 24 10 is_stmt 1
	addps	%xmm5, %xmm14
	addps	%xmm6, %xmm11
	addps	%xmm7, %xmm12
	addps	%xmm8, %xmm13
	.loc	38 26 10
	xorps	%xmm4, %xmm4
	cmpleps	%xmm11, %xmm4
	andps	%xmm11, %xmm4
	xorps	%xmm15, %xmm15
	cmpleps	%xmm12, %xmm15
	andps	%xmm12, %xmm15
	xorps	%xmm12, %xmm12
	cmpleps	%xmm13, %xmm12
	andps	%xmm13, %xmm12
	xorps	%xmm11, %xmm11
	cmpleps	%xmm14, %xmm11
	andps	%xmm14, %xmm11
	.loc	38 28 10
	minps	%xmm3, %xmm4
	minps	%xmm3, %xmm15
	minps	%xmm3, %xmm12
	minps	%xmm3, %xmm11
	.loc	38 29 10
	andps	%xmm10, %xmm4
	movdqa	%xmm10, %xmm14
	pandn	%xmm1, %xmm14
	orps	%xmm14, %xmm4
	movaps	%xmm9, %xmm13
	addss	%xmm4, %xmm13
	pshufd	$85, %xmm4, %xmm0
	addss	%xmm13, %xmm0
	pshufd	$238, %xmm4, %xmm2
	addss	%xmm0, %xmm2
	pshufd	$255, %xmm4, %xmm13
	addss	%xmm2, %xmm13
	movaps	%xmm9, %xmm0
	shufps	$85, %xmm9, %xmm0
	andps	%xmm10, %xmm15
	orps	%xmm14, %xmm15
	addss	%xmm15, %xmm0
	pshufd	$85, %xmm15, %xmm2
	addss	%xmm0, %xmm2
	pshufd	$238, %xmm15, %xmm0
	addss	%xmm2, %xmm0
	pshufd	$255, %xmm15, %xmm2
	addss	%xmm0, %xmm2
	unpcklps	%xmm2, %xmm13
	movaps	%xmm9, %xmm0
	unpckhpd	%xmm9, %xmm0
	andps	%xmm10, %xmm12
	orps	%xmm14, %xmm12
	addss	%xmm12, %xmm0
	pshufd	$85, %xmm12, %xmm2
	addss	%xmm0, %xmm2
	pshufd	$238, %xmm12, %xmm0
	addss	%xmm2, %xmm0
	pshufd	$255, %xmm12, %xmm2
	addss	%xmm0, %xmm2
	shufps	$255, %xmm9, %xmm9
	andps	%xmm10, %xmm11
	orps	%xmm14, %xmm11
	addss	%xmm11, %xmm9
	pshufd	$85, %xmm11, %xmm0
	addss	%xmm9, %xmm0
	pshufd	$238, %xmm11, %xmm4
	addss	%xmm0, %xmm4
	pshufd	$255, %xmm11, %xmm0
	addss	%xmm4, %xmm0
	unpcklps	%xmm0, %xmm2
	movaps	%xmm13, %xmm9
	movlhps	%xmm2, %xmm9
	.loc	38 22 8
	addq	$4, %r9
	addq	$-4, %r10
	cmpq	$45, %r9
	jae	.LBB37_35
.LBB37_2:
	cmpq	$4, %r10
	movl	$4, %r11d
	cmovbq	%r10, %r11
	movd	%r11d, %xmm4
	pshufd	$0, %xmm4, %xmm10
	movdqa	%xmm10, %xmm4
	pcmpgtd	.LCPI37_0(%rip), %xmm4
	movmskps	%xmm4, %r11d
	testb	$1, %r11b
	jne	.LBB37_3
	testb	$2, %r11b
	jne	.LBB37_5
.LBB37_6:
	testb	$4, %r11b
	jne	.LBB37_7
.LBB37_8:
	testb	$8, %r11b
	je	.LBB37_10
.LBB37_9:
	movss	-572(%rsi,%r9,4), %xmm4
	shufps	$228, %xmm11, %xmm4
	shufps	$36, %xmm4, %xmm11
.LBB37_10:
	pxor	%xmm1, %xmm10
	pcmpgtd	.LCPI37_2(%rip), %xmm10
	movmskps	%xmm10, %r11d
	testb	$1, %r11b
	jne	.LBB37_11
	testb	$2, %r11b
	jne	.LBB37_13
.LBB37_14:
	testb	$4, %r11b
	jne	.LBB37_15
.LBB37_16:
	testb	$8, %r11b
	jne	.LBB37_17
.LBB37_18:
	testb	$1, %r11b
	jne	.LBB37_19
.LBB37_20:
	testb	$2, %r11b
	jne	.LBB37_21
.LBB37_22:
	testb	$4, %r11b
	jne	.LBB37_23
.LBB37_24:
	testb	$8, %r11b
	jne	.LBB37_25
.LBB37_26:
	testb	$1, %r11b
	jne	.LBB37_27
.LBB37_28:
	testb	$2, %r11b
	jne	.LBB37_29
.LBB37_30:
	testb	$4, %r11b
	jne	.LBB37_31
.LBB37_32:
	testb	$8, %r11b
	je	.LBB37_34
	jmp	.LBB37_33
	.loc	38 0 8 is_stmt 0
.Ltmp181:
	.p2align	4
.LBB37_3:
	.loc	38 22 8
	movss	-584(%rsi,%r9,4), %xmm11
	testb	$2, %r11b
	je	.LBB37_6
.LBB37_5:
	movss	-580(%rsi,%r9,4), %xmm4
	movlhps	%xmm11, %xmm4
	shufps	$226, %xmm11, %xmm4
	movaps	%xmm4, %xmm11
	testb	$4, %r11b
	je	.LBB37_8
.LBB37_7:
	movss	-576(%rsi,%r9,4), %xmm4
	shufps	$48, %xmm11, %xmm4
	shufps	$132, %xmm4, %xmm11
	testb	$8, %r11b
	jne	.LBB37_9
	jmp	.LBB37_10
	.loc	38 0 8
.Ltmp182:
	.p2align	4
.LBB37_11:
	.loc	38 22 8
	movss	-388(%rsi,%r9,4), %xmm12
	testb	$2, %r11b
	je	.LBB37_14
.LBB37_13:
	movss	-384(%rsi,%r9,4), %xmm4
	movlhps	%xmm12, %xmm4
	shufps	$226, %xmm12, %xmm4
	movaps	%xmm4, %xmm12
	testb	$4, %r11b
	je	.LBB37_16
.LBB37_15:
	movss	-380(%rsi,%r9,4), %xmm4
	shufps	$48, %xmm12, %xmm4
	shufps	$132, %xmm4, %xmm12
	testb	$8, %r11b
	je	.LBB37_18
.LBB37_17:
	movss	-376(%rsi,%r9,4), %xmm4
	shufps	$228, %xmm12, %xmm4
	shufps	$36, %xmm4, %xmm12
	testb	$1, %r11b
	je	.LBB37_20
.LBB37_19:
	movss	-192(%rsi,%r9,4), %xmm13
	testb	$2, %r11b
	je	.LBB37_22
.LBB37_21:
	movss	-188(%rsi,%r9,4), %xmm4
	movlhps	%xmm13, %xmm4
	shufps	$226, %xmm13, %xmm4
	movaps	%xmm4, %xmm13
	testb	$4, %r11b
	je	.LBB37_24
.LBB37_23:
	movss	-184(%rsi,%r9,4), %xmm4
	shufps	$48, %xmm13, %xmm4
	shufps	$132, %xmm4, %xmm13
	testb	$8, %r11b
	je	.LBB37_26
.LBB37_25:
	movss	-180(%rsi,%r9,4), %xmm4
	shufps	$228, %xmm13, %xmm4
	shufps	$36, %xmm4, %xmm13
	testb	$1, %r11b
	je	.LBB37_28
.LBB37_27:
	movss	4(%rsi,%r9,4), %xmm14
	testb	$2, %r11b
	je	.LBB37_30
.LBB37_29:
	movss	8(%rsi,%r9,4), %xmm4
	movlhps	%xmm14, %xmm4
	shufps	$226, %xmm14, %xmm4
	movaps	%xmm4, %xmm14
	testb	$4, %r11b
	je	.LBB37_32
.LBB37_31:
	movss	12(%rsi,%r9,4), %xmm4
	shufps	$48, %xmm14, %xmm4
	shufps	$132, %xmm4, %xmm14
	testb	$8, %r11b
	je	.LBB37_34
.LBB37_33:
	movss	16(%rsi,%r9,4), %xmm4
	shufps	$228, %xmm14, %xmm4
	shufps	$36, %xmm4, %xmm14
	jmp	.LBB37_34
.LBB37_36:
	.loc	38 38 8 is_stmt 1
	xorl	%eax, %eax
	.loc	38 38 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp183:
.Lfunc_end37:
	.size	infer_dispatch_53_reduction_1280x49_f32, .Lfunc_end37-infer_dispatch_53_reduction_1280x49_f32
	.cfi_endproc

	.section	.text.infer_dispatch_54_matmul_1x3x1280_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_54_matmul_1x3x1280_f32,@function
infer_dispatch_54_matmul_1x3x1280_f32:
.Lfunc_begin38:
	.file	39 "dump" "configured_module_infer_dispatch_54.mlir"
	.loc	39 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp184:
	.loc	39 14 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rax
	.loc	39 16 8
	movq	16(%rsi), %rcx
	movl	$8755584, %edx
	.loc	39 15 8
	addq	8(%rsi), %rdx
	xorl	%esi, %esi
	leaq	__constant_1x3xf32(%rip), %rdi
	.loc	39 0 8 is_stmt 0
.Ltmp185:
	.p2align	4
.LBB38_1:
	xorps	%xmm0, %xmm0
	movq	$-4, %r8
	.p2align	4
.LBB38_2:
	.loc	39 21 8 is_stmt 1
	movaps	16(%rdx,%r8,4), %xmm1
	movaps	%xmm1, %xmm2
	movaps	%xmm1, %xmm3
	shufps	$85, %xmm1, %xmm3
	movaps	%xmm1, %xmm4
	unpckhpd	%xmm1, %xmm4
	shufps	$255, %xmm1, %xmm1
	movss	16(%rax,%r8,4), %xmm5
	mulss	%xmm2, %xmm5
	addss	%xmm0, %xmm5
	mulss	20(%rax,%r8,4), %xmm3
	mulss	24(%rax,%r8,4), %xmm4
	addss	%xmm5, %xmm3
	addss	%xmm3, %xmm4
	mulss	28(%rax,%r8,4), %xmm1
	movaps	%xmm1, %xmm0
	addss	%xmm4, %xmm0
	addq	$4, %r8
	cmpq	$1276, %r8
	jb	.LBB38_2
	.loc	39 24 10
	addss	(%rdi,%rsi,4), %xmm0
	.loc	39 21 8
	movss	%xmm0, 5120(%rcx,%rsi,4)
	incq	%rsi
	addq	$5120, %rdx
	cmpq	$3, %rsi
	jne	.LBB38_1
	.loc	39 28 8
	xorl	%eax, %eax
	.loc	39 28 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp186:
.Lfunc_end38:
	.size	infer_dispatch_54_matmul_1x3x1280_f32, .Lfunc_end38-infer_dispatch_54_matmul_1x3x1280_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI39_0:
	.long	0xc2af999a
	.long	0xc2af999a
	.long	0xc2af999a
	.zero	4
.LCPI39_1:
	.long	0x42b1999a
	.long	0x42b1999a
	.long	0x42b1999a
	.zero	4
.LCPI39_4:
	.long	0xc2fe0000
	.long	0xc2fe0000
	.long	0xc2fe0000
	.zero	4
.LCPI39_5:
	.long	0x42fe0000
	.long	0x42fe0000
	.long	0x42fe0000
	.zero	4
.LCPI39_13:
	.long	0x3f800000
	.long	0x3f800000
	.long	0x3f800000
	.zero	4
.LCPI39_14:
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.zero	4
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI39_2:
	.long	0x3fb8aa3b
.LCPI39_3:
	.long	0x3f000000
.LCPI39_6:
	.long	0xbf318000
.LCPI39_7:
	.long	0x395e8083
.LCPI39_8:
	.long	0x39506967
.LCPI39_9:
	.long	0x3ab743ce
.LCPI39_10:
	.long	0x3c088908
.LCPI39_11:
	.long	0x3d2aa9c1
.LCPI39_12:
	.long	0x3e2aaaaa
	.section	.text.infer_dispatch_55_softmax_3xf32_dispatch_tensor_store,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_55_softmax_3xf32_dispatch_tensor_store,@function
infer_dispatch_55_softmax_3xf32_dispatch_tensor_store:
.Lfunc_begin39:
	.file	40 "dump" "configured_module_infer_dispatch_55.mlir"
	.loc	40 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp187:
	pushq	%rbx
	subq	$152, %rsp
	.cfi_offset %rbx, -24
	.loc	40 13 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rcx
	.loc	40 14 8
	movq	8(%rax), %rbx
	.loc	40 19 8
	movaps	5120(%rcx), %xmm0
	.loc	40 21 10
	movaps	%xmm0, %xmm1
	shufps	$85, %xmm0, %xmm1
	movaps	%xmm0, %xmm2
	cmpunordss	%xmm0, %xmm2
	movaps	%xmm2, %xmm3
	andps	%xmm1, %xmm3
	maxss	%xmm0, %xmm1
	andnps	%xmm1, %xmm2
	orps	%xmm3, %xmm2
	movaps	%xmm0, %xmm1
	unpckhpd	%xmm0, %xmm1
	movaps	%xmm1, %xmm3
	maxss	%xmm2, %xmm3
	cmpunordss	%xmm2, %xmm2
	movaps	%xmm2, %xmm4
	andnps	%xmm3, %xmm4
	andps	%xmm1, %xmm2
	orps	%xmm4, %xmm2
	.loc	40 25 8
	shufps	$0, %xmm2, %xmm2
	.loc	40 27 10
	subps	%xmm2, %xmm0
	.loc	40 28 10
	movaps	.LCPI39_0(%rip), %xmm1
	maxps	%xmm0, %xmm1
	movaps	.LCPI39_1(%rip), %xmm0
	minps	%xmm1, %xmm0
	movaps	%xmm0, -64(%rbp)
	movhlps	%xmm0, %xmm0
	movaps	%xmm0, -80(%rbp)
	movss	.LCPI39_2(%rip), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -160(%rbp)
	movaps	-64(%rbp), %xmm0
	shufps	$85, %xmm0, %xmm0
	movaps	%xmm0, -128(%rbp)
	movss	.LCPI39_2(%rip), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -96(%rbp)
	movaps	-64(%rbp), %xmm0
	movss	.LCPI39_2(%rip), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movaps	-64(%rbp), %xmm1
	shufps	$255, %xmm1, %xmm1
	movaps	%xmm1, -144(%rbp)
	callq	floorf@PLT
	movaps	%xmm0, -48(%rbp)
	movss	-96(%rbp), %xmm0
	callq	floorf@PLT
	movaps	-48(%rbp), %xmm1
	unpcklps	%xmm0, %xmm1
	movaps	%xmm1, -48(%rbp)
	movss	-160(%rbp), %xmm0
	callq	floorf@PLT
	movaps	-48(%rbp), %xmm1
	movlhps	%xmm0, %xmm1
	movaps	.LCPI39_4(%rip), %xmm0
	maxps	%xmm1, %xmm0
	movaps	.LCPI39_5(%rip), %xmm1
	minps	%xmm0, %xmm1
	movaps	%xmm1, -160(%rbp)
	movaps	%xmm1, %xmm0
	shufps	$85, %xmm1, %xmm0
	movaps	%xmm0, -96(%rbp)
	movss	.LCPI39_6(%rip), %xmm1
	movaps	-128(%rbp), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -128(%rbp)
	movaps	-160(%rbp), %xmm0
	movss	.LCPI39_6(%rip), %xmm1
	movaps	-64(%rbp), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -64(%rbp)
	movaps	-160(%rbp), %xmm0
	movhlps	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movss	.LCPI39_6(%rip), %xmm1
	movaps	-80(%rbp), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -80(%rbp)
	movaps	-160(%rbp), %xmm0
	shufps	$255, %xmm0, %xmm0
	movaps	%xmm0, -48(%rbp)
	movaps	-144(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm2
	movaps	-48(%rbp), %xmm0
	callq	fmaf@PLT
	movaps	%xmm0, -48(%rbp)
	movss	.LCPI39_7(%rip), %xmm1
	movaps	-112(%rbp), %xmm0
	movss	-80(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, -80(%rbp)
	unpcklps	-48(%rbp), %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	-160(%rbp), %xmm0
	movss	.LCPI39_7(%rip), %xmm1
	movss	-64(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, -64(%rbp)
	movaps	-96(%rbp), %xmm0
	movss	.LCPI39_7(%rip), %xmm1
	movss	-128(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, -144(%rbp)
	movaps	-64(%rbp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	-112(%rbp), %xmm1
	movaps	%xmm1, -96(%rbp)
	movss	.LCPI39_8(%rip), %xmm1
	movss	.LCPI39_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -112(%rbp)
	movaps	-64(%rbp), %xmm0
	movss	.LCPI39_8(%rip), %xmm1
	movss	.LCPI39_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -20(%rbp)
	movaps	-80(%rbp), %xmm0
	movss	.LCPI39_8(%rip), %xmm1
	movss	.LCPI39_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -12(%rbp)
	movaps	-48(%rbp), %xmm0
	callq	fmaf@PLT
	movaps	-48(%rbp), %xmm1
	callq	fmaf@PLT
	movss	%xmm0, -128(%rbp)
	movss	.LCPI39_10(%rip), %xmm2
	movss	-12(%rbp), %xmm0
	movaps	-80(%rbp), %xmm1
	callq	fmaf@PLT
	movss	%xmm0, -12(%rbp)
	movss	-20(%rbp), %xmm0
	movaps	-64(%rbp), %xmm1
	movss	.LCPI39_10(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -16(%rbp)
	movss	-112(%rbp), %xmm0
	movaps	-144(%rbp), %xmm1
	movss	.LCPI39_10(%rip), %xmm2
	callq	fmaf@PLT
	movss	.LCPI39_11(%rip), %xmm2
	movaps	-144(%rbp), %xmm1
	callq	fmaf@PLT
	movss	%xmm0, -20(%rbp)
	movss	-16(%rbp), %xmm0
	movaps	-64(%rbp), %xmm1
	movss	.LCPI39_11(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -16(%rbp)
	movss	-12(%rbp), %xmm0
	movaps	-80(%rbp), %xmm1
	movss	.LCPI39_11(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -12(%rbp)
	movss	-128(%rbp), %xmm0
	movaps	-48(%rbp), %xmm1
	callq	fmaf@PLT
	movaps	-48(%rbp), %xmm1
	callq	fmaf@PLT
	movss	%xmm0, -112(%rbp)
	movss	.LCPI39_12(%rip), %xmm2
	movss	-12(%rbp), %xmm0
	movaps	-80(%rbp), %xmm1
	callq	fmaf@PLT
	movss	%xmm0, -12(%rbp)
	movss	-16(%rbp), %xmm0
	movaps	-64(%rbp), %xmm1
	movss	.LCPI39_12(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -16(%rbp)
	movss	-20(%rbp), %xmm0
	movaps	-144(%rbp), %xmm1
	movss	.LCPI39_12(%rip), %xmm2
	callq	fmaf@PLT
	movaps	-144(%rbp), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -128(%rbp)
	movss	-16(%rbp), %xmm0
	movaps	-64(%rbp), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -20(%rbp)
	movss	-12(%rbp), %xmm0
	movaps	-80(%rbp), %xmm1
	movss	.LCPI39_3(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, -12(%rbp)
	movss	-112(%rbp), %xmm0
	movaps	-48(%rbp), %xmm1
	callq	fmaf@PLT
	movaps	-96(%rbp), %xmm1
	mulps	%xmm1, %xmm1
	movaps	%xmm1, -96(%rbp)
	shufps	$255, %xmm1, %xmm1
	movaps	-48(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, -48(%rbp)
	movaps	-96(%rbp), %xmm1
	movhlps	%xmm1, %xmm1
	movss	-12(%rbp), %xmm0
	movaps	-80(%rbp), %xmm2
	callq	fmaf@PLT
	unpcklps	-48(%rbp), %xmm0
	movaps	%xmm0, -48(%rbp)
	movss	-20(%rbp), %xmm0
	movaps	-96(%rbp), %xmm1
	movaps	-64(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, -64(%rbp)
	movaps	-96(%rbp), %xmm1
	shufps	$85, %xmm1, %xmm1
	movss	-128(%rbp), %xmm0
	movaps	-144(%rbp), %xmm2
	callq	fmaf@PLT
	movaps	-64(%rbp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	-48(%rbp), %xmm1
	addps	.LCPI39_13(%rip), %xmm1
	cvttps2dq	-160(%rbp), %xmm0
	pslld	$23, %xmm0
	paddd	.LCPI39_14(%rip), %xmm0
	mulps	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	.loc	40 29 10
	addss	%xmm0, %xmm1
	movaps	%xmm0, %xmm2
	shufps	$85, %xmm0, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	unpckhpd	%xmm0, %xmm1
	addss	%xmm2, %xmm1
	.loc	40 32 8
	shufps	$0, %xmm1, %xmm1
	.loc	40 36 10
	divps	%xmm1, %xmm0
	movlps	%xmm0, (%rbx)
	movhlps	%xmm0, %xmm0
	movss	%xmm0, 8(%rbx)
	.loc	40 40 8
	xorl	%eax, %eax
	.loc	40 40 8 epilogue_begin is_stmt 0
	addq	$152, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp188:
.Lfunc_end39:
	.size	infer_dispatch_55_softmax_3xf32_dispatch_tensor_store, .Lfunc_end39-infer_dispatch_55_softmax_3xf32_dispatch_tensor_store
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin40:
	.cfi_startproc
	xorl	%eax, %eax
	cmpl	$6, %edi
	leaq	iree_hal_executable_library_query_v0(%rip), %rcx
	cmoveq	%rcx, %rax
	retq
.Lfunc_end40:
	.size	iree_hal_executable_library_query, .Lfunc_end40-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end40-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin41:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB41_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB41_5
	testw	%cx, %cx
	je	.LBB41_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB41_6:
	movzwl	%cx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB41_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB41_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end41:
	.size	iree_h2f_ieee, .Lfunc_end41-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin42:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB42_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB42_6
	testl	%edx, %edx
	je	.LBB42_4
	orl	$32767, %eax
	retq
.LBB42_1:
	movl	%ecx, %edi
.LBB42_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB42_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB42_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB42_9
	shrl	$23, %ecx
	andl	$8192, %esi
	cmpl	$1, %esi
	sbbl	$0, %edx
	addl	$4096, %edx
	cmpl	$8388608, %edx
	sbbl	$-1, %ecx
	movl	%edx, %esi
	shrl	$13, %esi
	addl	$15360, %esi
	cmpl	$8388608, %edx
	movl	$15360, %edx
	cmovbl	%esi, %edx
	shll	$10, %ecx
	leal	(%rcx,%rdx), %edi
	addl	$-130048, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB42_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end42:
	.size	iree_f2h_ieee, .Lfunc_end42-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin43:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB43_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB43_5
	testw	%cx, %cx
	je	.LBB43_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB43_6:
	movzwl	%cx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB43_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB43_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end43:
	.size	__gnu_h2f_ieee, .Lfunc_end43-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin44:
	.cfi_startproc
	movd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB44_6
	cmpl	$31744, %esi
	jne	.LBB44_5
	testw	%dx, %dx
	je	.LBB44_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB44_6:
	movzwl	%dx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB44_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB44_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end44:
	.size	__extendhfsf2, .Lfunc_end44-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin45:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB45_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB45_6
	testl	%edx, %edx
	je	.LBB45_4
	orl	$32767, %eax
	retq
.LBB45_1:
	movl	%ecx, %edi
.LBB45_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB45_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB45_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB45_9
	shrl	$23, %ecx
	andl	$8192, %esi
	cmpl	$1, %esi
	sbbl	$0, %edx
	addl	$4096, %edx
	cmpl	$8388608, %edx
	sbbl	$-1, %ecx
	movl	%edx, %esi
	shrl	$13, %esi
	addl	$15360, %esi
	cmpl	$8388608, %edx
	movl	$15360, %edx
	cmovbl	%esi, %edx
	shll	$10, %ecx
	leal	(%rcx,%rdx), %edi
	addl	$-130048, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB45_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end45:
	.size	__gnu_f2h_ieee, .Lfunc_end45-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin46:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB46_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB46_6
	testl	%edx, %edx
	je	.LBB46_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.LBB46_1:
	movl	%ecx, %edi
	jmp	.LBB46_9
.LBB46_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB46_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB46_9
	shrl	$23, %ecx
	andl	$8192, %esi
	cmpl	$1, %esi
	sbbl	$0, %edx
	addl	$4096, %edx
	cmpl	$8388608, %edx
	sbbl	$-1, %ecx
	movl	%edx, %esi
	shrl	$13, %esi
	addl	$15360, %esi
	cmpl	$8388608, %edx
	movl	$15360, %edx
	cmovbl	%esi, %edx
	shll	$10, %ecx
	leal	(%rcx,%rdx), %edi
	addl	$-130048, %edi
	jmp	.LBB46_9
.LBB46_4:
	movl	$31744, %edi
.LBB46_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.Lfunc_end46:
	.size	__truncsfhf2, .Lfunc_end46-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin47:
	.cfi_startproc
	movd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB47_6
	cmpl	$31744, %esi
	jne	.LBB47_5
	testw	%dx, %dx
	je	.LBB47_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB47_6:
	movzwl	%dx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB47_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB47_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.Lfunc_end47:
	.size	__extendhfdf2, .Lfunc_end47-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin48:
	.cfi_startproc
	cvtsd2ss	%xmm0, %xmm0
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB48_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB48_6
	testl	%edx, %edx
	je	.LBB48_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.LBB48_1:
	movl	%ecx, %edi
	jmp	.LBB48_9
.LBB48_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB48_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB48_9
	shrl	$23, %ecx
	andl	$8192, %esi
	cmpl	$1, %esi
	sbbl	$0, %edx
	addl	$4096, %edx
	cmpl	$8388608, %edx
	sbbl	$-1, %ecx
	movl	%edx, %esi
	shrl	$13, %esi
	addl	$15360, %esi
	cmpl	$8388608, %edx
	movl	$15360, %edx
	cmovbl	%esi, %edx
	shll	$10, %ecx
	leal	(%rcx,%rdx), %edi
	addl	$-130048, %edi
	jmp	.LBB48_9
.LBB48_4:
	movl	$31744, %edi
.LBB48_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.Lfunc_end48:
	.size	__truncdfhf2, .Lfunc_end48-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin49:
	.cfi_startproc
	mulsd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	retq
.Lfunc_end49:
	.size	fma, .Lfunc_end49-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin50:
	.cfi_startproc
	subss	%xmm0, %xmm0
	divss	%xmm0, %xmm0
	retq
.Lfunc_end50:
	.size	__math_invalidf, .Lfunc_end50-__math_invalidf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI51_0:
	.long	0xf0000000
	.long	0x70000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI51_1:
	.long	0x70000000
	.section	.text.__math_oflowf,"ax",@progbits
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin51:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI51_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI51_1(%rip), %xmm0
	retq
.Lfunc_end51:
	.size	__math_oflowf, .Lfunc_end51-__math_oflowf
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI52_0:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.text.__math_xflowf,"ax",@progbits
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin52:
	.cfi_startproc
	movaps	%xmm0, %xmm1
	testl	%edi, %edi
	je	.LBB52_2
	movaps	.LCPI52_0(%rip), %xmm1
	xorps	%xmm0, %xmm1
.LBB52_2:
	movss	%xmm1, -4(%rsp)
	mulss	-4(%rsp), %xmm0
	retq
.Lfunc_end52:
	.size	__math_xflowf, .Lfunc_end52-__math_xflowf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI53_0:
	.long	0x90000000
	.long	0x10000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI53_1:
	.long	0x10000000
	.section	.text.__math_uflowf,"ax",@progbits
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin53:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI53_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI53_1(%rip), %xmm0
	retq
.Lfunc_end53:
	.size	__math_uflowf, .Lfunc_end53-__math_uflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI54_0:
	.long	0x7b800000
.LCPI54_1:
	.long	0x80000000
.LCPI54_2:
	.long	0x3f800000
	.section	.text.ceilf,"ax",@progbits
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin54:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB54_1
.LBB54_8:
	retq
.LBB54_1:
	cmpl	$127, %ecx
	jb	.LBB54_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrl	%cl, %edx
	testl	%eax, %edx
	je	.LBB54_8
	addss	.LCPI54_0(%rip), %xmm0
	movl	$-8388608, %esi
	sarl	%cl, %esi
	xorl	%ecx, %ecx
	testl	%eax, %eax
	cmovsl	%ecx, %edx
	movss	%xmm0, -8(%rsp)
	addl	%eax, %edx
	andl	%esi, %edx
	movd	%edx, %xmm0
	retq
.LBB54_4:
	movss	.LCPI54_0(%rip), %xmm1
	addss	%xmm0, %xmm1
	movss	%xmm1, -4(%rsp)
	testl	%eax, %eax
	js	.LBB54_5
	je	.LBB54_8
	movss	.LCPI54_2(%rip), %xmm0
	retq
.LBB54_5:
	movss	.LCPI54_1(%rip), %xmm0
	retq
.Lfunc_end54:
	.size	ceilf, .Lfunc_end54-ceilf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI55_0:
	.long	0xff800000
.LCPI55_1:
	.long	0x42b17217
.LCPI55_2:
	.long	0xc2cff1b4
.LCPI55_3:
	.long	0x10000000
.LCPI55_4:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI55_5:
	.quad	0x40471547652b82fe
.LCPI55_6:
	.quad	0x4338000000000000
.LCPI55_7:
	.quad	0xc338000000000000
.LCPI55_8:
	.quad	0x3ebc6af84b912394
.LCPI55_9:
	.quad	0x3f2ebfce50fac4f3
.LCPI55_10:
	.quad	0x3f962e42ff0c52d6
.LCPI55_11:
	.quad	0x3ff0000000000000
	.section	.text.expf,"ax",@progbits
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin55:
	.cfi_startproc
	movd	%xmm0, %eax
	shrl	$20, %eax
	andl	$2047, %eax
	cmpl	$1067, %eax
	jae	.LBB55_1
.LBB55_8:
	cvtss2sd	%xmm0, %xmm0
	mulsd	.LCPI55_5(%rip), %xmm0
	movsd	.LCPI55_6(%rip), %xmm1
	addsd	%xmm0, %xmm1
	movq	%xmm1, %rax
	addsd	.LCPI55_7(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movl	%eax, %ecx
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	movsd	.LCPI55_8(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	addsd	.LCPI55_9(%rip), %xmm1
	movq	%rax, %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	mulsd	%xmm1, %xmm3
	mulsd	.LCPI55_10(%rip), %xmm0
	addsd	.LCPI55_11(%rip), %xmm0
	addsd	%xmm3, %xmm0
	mulsd	%xmm2, %xmm0
	xorps	%xmm1, %xmm1
	cvtsd2ss	%xmm0, %xmm1
.LBB55_9:
	movaps	%xmm1, %xmm0
	retq
.LBB55_1:
	xorps	%xmm1, %xmm1
	movss	.LCPI55_0(%rip), %xmm2
	ucomiss	%xmm0, %xmm2
	jae	.LBB55_9
	cmpl	$2040, %eax
	jae	.LBB55_3
	ucomiss	.LCPI55_1(%rip), %xmm0
	jbe	.LBB55_6
	movl	$1879048192, -8(%rsp)
	movss	-8(%rsp), %xmm1
	mulss	.LCPI55_4(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.LBB55_3:
	addss	%xmm0, %xmm0
	retq
.LBB55_6:
	movss	.LCPI55_2(%rip), %xmm1
	ucomiss	%xmm0, %xmm1
	jbe	.LBB55_8
	movl	$268435456, -4(%rsp)
	movss	-4(%rsp), %xmm1
	mulss	.LCPI55_3(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end55:
	.size	expf, .Lfunc_end55-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin56:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end56:
	.size	feclearexcept, .Lfunc_end56-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin57:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end57:
	.size	feraiseexcept, .Lfunc_end57-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin58:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end58:
	.size	fetestexcept, .Lfunc_end58-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin59:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end59:
	.size	fegetround, .Lfunc_end59-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin60:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end60:
	.size	__fesetround, .Lfunc_end60-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin61:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end61:
	.size	fegetenv, .Lfunc_end61-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin62:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end62:
	.size	fesetenv, .Lfunc_end62-fesetenv
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI63_0:
	.long	0x7b800000
.LCPI63_1:
	.long	0xbf800000
	.section	.text.floorf,"ax",@progbits
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin63:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB63_1
	retq
.LBB63_1:
	cmpl	$127, %ecx
	jb	.LBB63_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrl	%cl, %edx
	testl	%eax, %edx
	je	.LBB63_6
	addss	.LCPI63_0(%rip), %xmm0
	movl	$-8388608, %esi
	sarl	%cl, %esi
	movss	%xmm0, -8(%rsp)
	movl	%eax, %ecx
	sarl	$31, %ecx
	andl	%edx, %ecx
	addl	%eax, %ecx
	andl	%esi, %ecx
	movd	%ecx, %xmm0
	retq
.LBB63_4:
	movss	.LCPI63_0(%rip), %xmm1
	addss	%xmm0, %xmm1
	movss	%xmm1, -4(%rsp)
	xorps	%xmm1, %xmm1
	testl	%eax, %eax
	jns	.LBB63_5
	ucomiss	%xmm1, %xmm0
	movaps	%xmm0, %xmm1
	jne	.LBB63_8
	jp	.LBB63_8
.LBB63_5:
	movaps	%xmm1, %xmm0
.LBB63_6:
	retq
.LBB63_8:
	movss	.LCPI63_1(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end63:
	.size	floorf, .Lfunc_end63-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin64:
	.cfi_startproc
	cvtss2sd	%xmm0, %xmm3
	xorps	%xmm0, %xmm0
	cvtss2sd	%xmm1, %xmm0
	mulsd	%xmm3, %xmm0
	cvtss2sd	%xmm2, %xmm2
	movapd	%xmm0, %xmm1
	addsd	%xmm2, %xmm1
	movq	%xmm1, %rax
	movq	%rax, %rcx
	notq	%rcx
	movl	%eax, %edx
	andl	$536870911, %edx
	cmpl	$268435456, %edx
	setne	%dl
	movabsq	$9218868437227405312, %rsi
	testq	%rsi, %rcx
	sete	%cl
	orb	%dl, %cl
	jne	.LBB64_7
	movapd	%xmm1, %xmm3
	subsd	%xmm0, %xmm3
	ucomisd	%xmm2, %xmm3
	jne	.LBB64_3
	jp	.LBB64_3
	movapd	%xmm1, %xmm3
	subsd	%xmm2, %xmm3
	ucomisd	%xmm0, %xmm3
	jne	.LBB64_3
	jp	.LBB64_3
.LBB64_7:
	xorps	%xmm0, %xmm0
	cvtsd2ss	%xmm1, %xmm0
	retq
.LBB64_3:
	testq	%rax, %rax
	sets	%cl
	ucomisd	%xmm0, %xmm2
	setbe	%dl
	xorb	%cl, %dl
	jne	.LBB64_4
	subsd	%xmm1, %xmm2
	jmp	.LBB64_6
.LBB64_4:
	subsd	%xmm1, %xmm0
.LBB64_6:
	addsd	%xmm2, %xmm0
	xorpd	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	setbe	%dl
	xorb	%dl, %cl
	movq	%rax, %rdx
	orq	$1, %rdx
	decq	%rax
	testb	%cl, %cl
	cmovneq	%rdx, %rax
	movq	%rax, %xmm1
	xorps	%xmm0, %xmm0
	cvtsd2ss	%xmm1, %xmm0
	retq
.Lfunc_end64:
	.size	fmaf, .Lfunc_end64-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin65:
	.cfi_startproc
	movd	%xmm1, %esi
	movl	%esi, %ecx
	addl	%esi, %ecx
	je	.LBB65_2
	movd	%xmm0, %eax
	movl	%eax, %edx
	shrl	$23, %edx
	movzbl	%dl, %edx
	movl	%esi, %edi
	andl	$2147483647, %edi
	cmpl	$2139095041, %edi
	setb	%dil
	cmpl	$255, %edx
	setne	%r8b
	testb	%r8b, %dil
	jne	.LBB65_3
.LBB65_2:
	mulss	%xmm1, %xmm0
	divss	%xmm0, %xmm0
	retq
.LBB65_3:
	leal	(%rax,%rax), %edi
	cmpl	%ecx, %edi
	jbe	.LBB65_4
	movl	%esi, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %r8d
	testl	%edx, %edx
	je	.LBB65_7
	movl	%eax, %edi
	andl	$8388607, %edi
	orl	$8388608, %edi
	testl	%r8d, %r8d
	je	.LBB65_12
.LBB65_15:
	andl	$8388607, %esi
	orl	$8388608, %esi
	cmpl	%r8d, %edx
	jg	.LBB65_17
.LBB65_21:
	movl	%edi, %ecx
	subl	%esi, %ecx
	jns	.LBB65_22
	jmp	.LBB65_23
.LBB65_4:
	je	.LBB65_5
	retq
.LBB65_7:
	movl	%eax, %ecx
	xorl	%edx, %edx
	shll	$9, %ecx
	js	.LBB65_9
	.p2align	4
.LBB65_8:
	decl	%edx
	addl	%ecx, %ecx
	jns	.LBB65_8
.LBB65_9:
	movb	$1, %cl
	subb	%dl, %cl
	movl	%eax, %edi
	shll	%cl, %edi
	testl	%r8d, %r8d
	jne	.LBB65_15
.LBB65_12:
	movl	%esi, %ecx
	xorl	%r8d, %r8d
	shll	$9, %ecx
	js	.LBB65_14
	.p2align	4
.LBB65_13:
	decl	%r8d
	addl	%ecx, %ecx
	jns	.LBB65_13
.LBB65_14:
	movb	$1, %cl
	subb	%r8b, %cl
	shll	%cl, %esi
	cmpl	%r8d, %edx
	jg	.LBB65_17
	jmp	.LBB65_21
	.p2align	4
.LBB65_19:
	addl	%edi, %edi
	decl	%edx
	cmpl	%r8d, %edx
	jle	.LBB65_20
.LBB65_17:
	movl	%edi, %ecx
	subl	%esi, %ecx
	js	.LBB65_19
	movl	%ecx, %edi
	jne	.LBB65_19
	jmp	.LBB65_5
.LBB65_20:
	movl	%r8d, %edx
	movl	%edi, %ecx
	subl	%esi, %ecx
	js	.LBB65_23
.LBB65_22:
	movl	%ecx, %edi
	je	.LBB65_5
.LBB65_23:
	cmpl	$8388607, %edi
	ja	.LBB65_24
	.p2align	4
.LBB65_25:
	leal	(%rdi,%rdi), %esi
	decl	%edx
	cmpl	$4194304, %edi
	movl	%esi, %edi
	jb	.LBB65_25
	andl	$-2147483648, %eax
	testl	%edx, %edx
	jle	.LBB65_28
.LBB65_27:
	addl	$-8388608, %esi
	shll	$23, %edx
	orl	%esi, %edx
	orl	%eax, %edx
	movd	%edx, %xmm0
	retq
.LBB65_5:
	pxor	%xmm1, %xmm1
	mulss	%xmm1, %xmm0
	retq
.LBB65_24:
	movl	%edi, %esi
	andl	$-2147483648, %eax
	testl	%edx, %edx
	jg	.LBB65_27
.LBB65_28:
	movb	$1, %cl
	subb	%dl, %cl
	shrl	%cl, %esi
	movl	%esi, %edx
	orl	%eax, %edx
	movd	%edx, %xmm0
	retq
.Lfunc_end65:
	.size	fmodf, .Lfunc_end65-fmodf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI66_0:
	.long	0x5f800000
	.section	.text.frexpf,"ax",@progbits
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin66:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	cmpb	$-1, %cl
	je	.LBB66_7
	movzbl	%cl, %edx
	testl	%edx, %edx
	jne	.LBB66_6
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB66_4
	jnp	.LBB66_3
.LBB66_4:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	mulss	.LCPI66_0(%rip), %xmm0
	movq	%rdi, %rbx
	callq	frexpf
	movq	%rbx, %rdi
	movl	(%rbx), %eax
	addl	$-64, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	.cfi_restore %rbx
	movl	%eax, (%rdi)
	retq
.LBB66_6:
	movzbl	%cl, %ecx
	addl	$-126, %ecx
	movl	%ecx, (%rdi)
	andl	$-2139095041, %eax
	orl	$1056964608, %eax
	movd	%eax, %xmm0
.LBB66_7:
	retq
.LBB66_3:
	xorl	%eax, %eax
	movl	%eax, (%rdi)
	retq
.Lfunc_end66:
	.size	frexpf, .Lfunc_end66-frexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI67_0:
	.long	0x0c800000
.LCPI67_1:
	.long	0x7f000000
	.section	.text.ldexpf,"ax",@progbits
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin67:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB67_4
	mulss	.LCPI67_1(%rip), %xmm0
	cmpl	$255, %edi
	jb	.LBB67_2
	mulss	.LCPI67_1(%rip), %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB67_8
.LBB67_4:
	cmpl	$-127, %edi
	jg	.LBB67_9
	mulss	.LCPI67_0(%rip), %xmm0
	cmpl	$-229, %edi
	ja	.LBB67_6
	mulss	.LCPI67_0(%rip), %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB67_8:
	movl	%eax, %edi
	jmp	.LBB67_9
.LBB67_2:
	addl	$-127, %edi
	jmp	.LBB67_9
.LBB67_6:
	addl	$102, %edi
.LBB67_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	movd	%edi, %xmm1
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end67:
	.size	ldexpf, .Lfunc_end67-ldexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI68_0:
	.long	0x0c800000
.LCPI68_1:
	.long	0x7f000000
	.section	.text.scalbnf,"ax",@progbits
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin68:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB68_4
	mulss	.LCPI68_1(%rip), %xmm0
	cmpl	$255, %edi
	jb	.LBB68_2
	mulss	.LCPI68_1(%rip), %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB68_8
.LBB68_4:
	cmpl	$-127, %edi
	jg	.LBB68_9
	mulss	.LCPI68_0(%rip), %xmm0
	cmpl	$-229, %edi
	ja	.LBB68_6
	mulss	.LCPI68_0(%rip), %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB68_8:
	movl	%eax, %edi
	jmp	.LBB68_9
.LBB68_2:
	addl	$-127, %edi
	jmp	.LBB68_9
.LBB68_6:
	addl	$102, %edi
.LBB68_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	movd	%edi, %xmm1
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end68:
	.size	scalbnf, .Lfunc_end68-scalbnf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI69_0:
	.long	0x3f800000
.LCPI69_2:
	.long	0x4b000000
.LCPI69_12:
	.long	0x10000000
.LCPI69_20:
	.long	0x70000000
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI69_1:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI69_3:
	.quad	0xbff0000000000000
.LCPI69_4:
	.quad	0x3fd27616c9496e0b
.LCPI69_5:
	.quad	0xbfd71969a075c67a
.LCPI69_6:
	.quad	0x3fdec70a6ca7badd
.LCPI69_7:
	.quad	0xbfe7154748bef6c8
.LCPI69_8:
	.quad	0x3ff71547652ab82b
.LCPI69_9:
	.quad	0x405fffffffd1d571
.LCPI69_10:
	.quad	0xc062c00000000000
.LCPI69_11:
	.long	0x90000000
	.long	0x10000000
.LCPI69_13:
	.quad	0x42e8000000000000
.LCPI69_14:
	.quad	0xc2e8000000000000
.LCPI69_15:
	.quad	0x3fac6af84b912394
.LCPI69_16:
	.quad	0x3fcebfce50fac4f3
.LCPI69_17:
	.quad	0x3fe62e42ff0c52d6
.LCPI69_18:
	.quad	0x3ff0000000000000
.LCPI69_19:
	.long	0xf0000000
	.long	0x70000000
	.section	.text.powf,"ax",@progbits
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin69:
	.cfi_startproc
	movd	%xmm0, %ecx
	movd	%xmm1, %edx
	leal	-2139095040(%rcx), %eax
	cmpl	$-2130706432, %eax
	jb	.LBB69_5
	xorl	%eax, %eax
	leal	16777216(,%rdx,2), %esi
	cmpl	$16777216, %esi
	jbe	.LBB69_5
.LBB69_2:
	leal	-1060306944(%rcx), %edx
	movl	%edx, %esi
	andl	$-8388608, %esi
	subl	%esi, %ecx
	movl	%edx, %esi
	sarl	$23, %esi
	shrl	$15, %edx
	andl	$240, %edx
	leaq	__powf_log2_data(%rip), %rdi
	movd	%ecx, %xmm0
	cvtss2sd	%xmm0, %xmm0
	mulsd	(%rdx,%rdi), %xmm0
	addsd	.LCPI69_3(%rip), %xmm0
	cvtsi2sd	%esi, %xmm2
	addsd	8(%rdx,%rdi), %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	movsd	.LCPI69_4(%rip), %xmm4
	mulsd	%xmm0, %xmm4
	addsd	.LCPI69_5(%rip), %xmm4
	movsd	.LCPI69_6(%rip), %xmm5
	mulsd	%xmm0, %xmm5
	addsd	.LCPI69_7(%rip), %xmm5
	mulsd	%xmm3, %xmm5
	mulsd	%xmm3, %xmm3
	mulsd	.LCPI69_8(%rip), %xmm0
	mulsd	%xmm4, %xmm3
	addsd	%xmm2, %xmm0
	addsd	%xmm0, %xmm5
	addsd	%xmm3, %xmm5
	xorps	%xmm0, %xmm0
	cvtss2sd	%xmm1, %xmm0
	mulsd	%xmm5, %xmm0
	movq	%xmm0, %rcx
	movabsq	$9223231299366420480, %rdx
	andq	%rcx, %rdx
	movabsq	$4638426141214900225, %rcx
	cmpq	%rcx, %rdx
	jae	.LBB69_10
.LBB69_3:
	movsd	.LCPI69_13(%rip), %xmm1
	addsd	%xmm0, %xmm1
	movq	%xmm1, %rcx
	addsd	.LCPI69_14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	addl	%ecx, %eax
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	movsd	.LCPI69_15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	addsd	.LCPI69_16(%rip), %xmm1
	movq	%rax, %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	mulsd	%xmm1, %xmm3
	mulsd	.LCPI69_17(%rip), %xmm0
	addsd	.LCPI69_18(%rip), %xmm0
	addsd	%xmm3, %xmm0
	mulsd	%xmm2, %xmm0
	cvtsd2ss	%xmm0, %xmm0
.LBB69_4:
	retq
.LBB69_5:
	leal	(%rdx,%rdx), %eax
	leal	-1(%rax), %esi
	cmpl	$-16777217, %esi
	jae	.LBB69_21
	leal	-1(,%rcx,2), %eax
	cmpl	$-16777217, %eax
	jae	.LBB69_25
	xorl	%eax, %eax
	testl	%ecx, %ecx
	js	.LBB69_12
	cmpl	$8388607, %ecx
	ja	.LBB69_2
.LBB69_9:
	mulss	.LCPI69_2(%rip), %xmm0
	movd	%xmm0, %ecx
	andl	$2147483647, %ecx
	addl	$-192937984, %ecx
	jmp	.LBB69_2
.LBB69_10:
	ucomisd	.LCPI69_9(%rip), %xmm0
	jbe	.LBB69_16
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI69_19(%rip), %rax
	movss	(%rax,%rcx,4), %xmm0
	movss	%xmm0, -8(%rsp)
	movss	-8(%rsp), %xmm0
	mulss	.LCPI69_20(%rip), %xmm0
	retq
.LBB69_12:
	movl	%edx, %eax
	shrl	$23, %eax
	movzbl	%al, %ecx
	cmpl	$127, %ecx
	jb	.LBB69_19
	cmpl	$150, %ecx
	jbe	.LBB69_18
.LBB69_14:
	xorl	%eax, %eax
.LBB69_15:
	movd	%xmm0, %ecx
	andl	$2147483647, %ecx
	cmpl	$8388607, %ecx
	ja	.LBB69_2
	jmp	.LBB69_9
.LBB69_16:
	movsd	.LCPI69_10(%rip), %xmm1
	ucomisd	%xmm0, %xmm1
	jb	.LBB69_3
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI69_11(%rip), %rax
	movss	(%rax,%rcx,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI69_12(%rip), %xmm0
	retq
.LBB69_18:
	movb	$-106, %cl
	subb	%al, %cl
	movl	$1, %esi
	shll	%cl, %esi
	leal	-1(%rsi), %eax
	testl	%edx, %eax
	je	.LBB69_20
.LBB69_19:
	subss	%xmm0, %xmm0
	divss	%xmm0, %xmm0
	retq
.LBB69_20:
	movl	$65536, %eax
	testl	%edx, %esi
	jne	.LBB69_15
	jmp	.LBB69_14
.LBB69_21:
	movss	.LCPI69_0(%rip), %xmm2
	cmpl	$1065353216, %ecx
	je	.LBB69_34
	testl	%eax, %eax
	je	.LBB69_34
	addl	%ecx, %ecx
	cmpl	$-16777215, %ecx
	setb	%sil
	cmpl	$-16777215, %eax
	setb	%al
	testb	%al, %sil
	jne	.LBB69_35
	addss	%xmm1, %xmm0
	retq
.LBB69_25:
	mulss	%xmm0, %xmm0
	testl	%ecx, %ecx
	jns	.LBB69_31
	movl	%edx, %eax
	shrl	$23, %eax
	movzbl	%al, %ecx
	addl	$-151, %ecx
	cmpl	$-24, %ecx
	jb	.LBB69_31
	movb	$-106, %cl
	subb	%al, %cl
	movl	$1, %esi
	shll	%cl, %esi
	decl	%esi
	movzbl	%cl, %eax
	movaps	%xmm0, %xmm1
	testl	%edx, %esi
	jne	.LBB69_29
	movaps	.LCPI69_1(%rip), %xmm1
	xorps	%xmm0, %xmm1
.LBB69_29:
	btl	%eax, %edx
	jae	.LBB69_31
	movaps	%xmm1, %xmm0
.LBB69_31:
	testl	%edx, %edx
	jns	.LBB69_4
	movss	.LCPI69_0(%rip), %xmm1
	divss	%xmm0, %xmm1
	movss	%xmm1, -12(%rsp)
	movss	-12(%rsp), %xmm0
	retq
.LBB69_34:
	movaps	%xmm2, %xmm0
	retq
.LBB69_35:
	cmpl	$2130706432, %ecx
	movaps	%xmm2, %xmm0
	je	.LBB69_4
	setb	%al
	testl	%edx, %edx
	sets	%cl
	xorb	%al, %cl
	xorps	%xmm0, %xmm0
	jne	.LBB69_4
	mulss	%xmm1, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end69:
	.size	powf, .Lfunc_end69-powf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI70_0:
	.long	0xcb000000
.LCPI70_1:
	.long	0x4b000000
.LCPI70_2:
	.long	0x80000000
	.section	.text.rintf,"ax",@progbits
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin70:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	andl	$2130706432, %ecx
	cmpl	$1249902592, %ecx
	ja	.LBB70_8
	movss	.LCPI70_0(%rip), %xmm1
	movss	.LCPI70_1(%rip), %xmm2
	testl	%eax, %eax
	jns	.LBB70_2
	addss	%xmm1, %xmm0
	addss	%xmm2, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB70_8
	jnp	.LBB70_5
.LBB70_8:
	retq
.LBB70_2:
	addss	%xmm2, %xmm0
	addss	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB70_8
	jp	.LBB70_8
.LBB70_5:
	testl	%eax, %eax
	jns	.LBB70_7
	movss	.LCPI70_2(%rip), %xmm1
.LBB70_7:
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end70:
	.size	rintf, .Lfunc_end70-rintf
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI71_0:
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
.LCPI71_7:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI71_1:
	.long	0x4b000000
.LCPI71_2:
	.long	0xcb000000
.LCPI71_3:
	.long	0x3f000000
.LCPI71_4:
	.long	0xbf000000
.LCPI71_5:
	.long	0x3f800000
.LCPI71_6:
	.long	0xbf800000
	.section	.text.roundf,"ax",@progbits
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin71:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB71_10
	movdqa	.LCPI71_0(%rip), %xmm1
	pand	%xmm0, %xmm1
	movss	.LCPI71_1(%rip), %xmm2
	addss	%xmm1, %xmm2
	cmpl	$125, %ecx
	ja	.LBB71_3
	movss	%xmm2, -4(%rsp)
	xorps	%xmm1, %xmm1
	mulss	%xmm1, %xmm0
	retq
.LBB71_3:
	addss	.LCPI71_2(%rip), %xmm2
	subss	%xmm1, %xmm2
	ucomiss	.LCPI71_3(%rip), %xmm2
	jbe	.LBB71_5
	addss	%xmm2, %xmm1
	addss	.LCPI71_6(%rip), %xmm1
	jmp	.LBB71_7
.LBB71_5:
	movss	.LCPI71_4(%rip), %xmm0
	ucomiss	%xmm2, %xmm0
	addss	%xmm2, %xmm1
	jb	.LBB71_7
	addss	.LCPI71_5(%rip), %xmm1
.LBB71_7:
	testl	%eax, %eax
	jns	.LBB71_9
	xorps	.LCPI71_7(%rip), %xmm1
.LBB71_9:
	movaps	%xmm1, %xmm0
.LBB71_10:
	retq
.Lfunc_end71:
	.size	roundf, .Lfunc_end71-roundf
	.cfi_endproc

	.type	__constant_32xf32,@object
	.section	.rodata.__constant_32xf32,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32:
	.long	0x403690f8
	.long	0x408c87f2
	.long	0xbf71e8d9
	.long	0xbf9b9a84
	.long	0x407f1434
	.long	0x4023a7a4
	.long	0xc126a284
	.long	0xc022bcf8
	.long	0x406b5d02
	.long	0x4038d270
	.long	0xc0965806
	.long	0xbe98f3d3
	.long	0xbe481301
	.long	0xbfabfcf7
	.long	0x408185af
	.long	0x40754a8e
	.long	0x3ce859e0
	.long	0x4013aa94
	.long	0xc0c32f17
	.long	0xbfa77cb8
	.long	0x40171bb2
	.long	0x4045d48f
	.long	0x4022baa6
	.long	0x3ef7681c
	.long	0x4007a7e7
	.long	0x4094b81e
	.long	0x3f61c058
	.long	0x3f94b78a
	.long	0x3db36b95
	.long	0x3ff392ed
	.long	0xbef01768
	.long	0x409f11a6
	.size	__constant_32xf32, 128

	.type	__constant_32xf32_0,@object
	.section	.rodata.__constant_32xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_0:
	.long	0x3f2995f4
	.long	0x409beeb6
	.long	0xbe45e344
	.long	0xbe1acf3e
	.long	0x40475b24
	.long	0x4042b1a9
	.long	0x3f027237
	.long	0xbe666954
	.long	0x4077020c
	.long	0x3b229800
	.long	0x3e1e0c46
	.long	0xbeba18e6
	.long	0xbedf7d13
	.long	0xbf8619d7
	.long	0x40176bf3
	.long	0x40269c12
	.long	0xbe80de9a
	.long	0x3fb3731d
	.long	0x40240fa9
	.long	0xbfae0668
	.long	0x3eefff2e
	.long	0x40248e67
	.long	0x3ea2c7be
	.long	0xbfb93814
	.long	0x404eac44
	.long	0x403fcc2e
	.long	0xbdc1d848
	.long	0x40811faa
	.long	0xbf06afe1
	.long	0x40099b09
	.long	0xbf3aca7e
	.long	0xc09665a8
	.size	__constant_32xf32_0, 128

	.type	__constant_16xf32,@object
	.section	.rodata.__constant_16xf32,"a",@progbits
	.p2align	6, 0x0
__constant_16xf32:
	.long	0xc06fb1a8
	.long	0x4128991c
	.long	0x4189af9e
	.long	0x421511c3
	.long	0x41594c86
	.long	0x40037512
	.long	0x4067c3bd
	.long	0x4048a8bf
	.long	0xc19d2ff8
	.long	0x403644d7
	.long	0x408c334b
	.long	0x41fa815d
	.long	0xc1629c3c
	.long	0xc132d615
	.long	0x40cfffd8
	.long	0xbf634c8a
	.size	__constant_16xf32, 64

	.type	__constant_24xf32,@object
	.section	.rodata.__constant_24xf32,"a",@progbits
	.p2align	6, 0x0
__constant_24xf32:
	.long	0x410664b9
	.long	0xc100598e
	.long	0x415ca882
	.long	0xc0b7e632
	.long	0x3fbfed7a
	.long	0xbfad27df
	.long	0xc09c73ec
	.long	0x4028f07e
	.long	0xc09c697e
	.long	0x3e33c031
	.long	0x40b82618
	.long	0xc0989339
	.long	0x40d08136
	.long	0xc07b6fcb
	.long	0x41abd8b7
	.long	0xc0b28404
	.long	0x40d1241d
	.long	0xc08c5342
	.long	0xbe9c4598
	.long	0x3f59eec9
	.long	0xc1213d5c
	.long	0xc114415f
	.long	0xbf8e5138
	.long	0x41490723
	.size	__constant_24xf32, 96

	.type	__constant_24xf32_0,@object
	.section	.rodata.__constant_24xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_24xf32_0:
	.long	0x42031ca8
	.long	0xc09328a1
	.long	0x410e11dc
	.long	0xc02efb66
	.long	0x401aa030
	.long	0x3f5af15f
	.long	0x417fa4f3
	.long	0x41c03f03
	.long	0xc19481c1
	.long	0xc20b5a9a
	.long	0x3ec157b4
	.long	0x40315b45
	.long	0xc10dbdf9
	.long	0xbfbe31ed
	.long	0xc1366c95
	.long	0x41c4f634
	.long	0x40929b69
	.long	0x416cf65f
	.long	0x41413e39
	.long	0x400d6628
	.long	0xc08d5687
	.long	0xc10eae75
	.long	0xc084cf07
	.long	0xc128f795
	.size	__constant_24xf32_0, 96

	.type	__constant_32xf32_1,@object
	.section	.rodata.__constant_32xf32_1,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_1:
	.long	0xc0c69be0
	.long	0x4095287d
	.long	0x406e9e70
	.long	0xc0394a63
	.long	0x410c0a96
	.long	0xbf04da02
	.long	0x408ab1f5
	.long	0xc1541752
	.long	0xc18b2ee5
	.long	0xc09c56b7
	.long	0x406ffb70
	.long	0xc12452ac
	.long	0x408d99b1
	.long	0xc1246dca
	.long	0xc02bc2a6
	.long	0x40169037
	.long	0x3fea0e08
	.long	0xc0b5b2aa
	.long	0xc1055987
	.long	0xc0c92383
	.long	0xc0759730
	.long	0xc1adb839
	.long	0xc11a16ef
	.long	0x3ff5e3cb
	.long	0xbeffee04
	.long	0xc08298ab
	.long	0x412c5694
	.long	0xc09c4c6e
	.long	0xc04ffa33
	.long	0xc12f6e2e
	.long	0xc0c9d1f5
	.long	0xbe0ade44
	.size	__constant_32xf32_1, 128

	.type	__constant_32xf32_2,@object
	.section	.rodata.__constant_32xf32_2,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_2:
	.long	0x40a544ec
	.long	0xbf22c66d
	.long	0x3f390e4d
	.long	0x40bb3f98
	.long	0x410b5745
	.long	0xc0353eb2
	.long	0x3fe0f4f7
	.long	0x3f891658
	.long	0x3fd03c1c
	.long	0xc06778a5
	.long	0x405c2961
	.long	0x40ca2d4f
	.long	0x4000b544
	.long	0x3f5cd3d2
	.long	0x3fdfa968
	.long	0x40d009f1
	.long	0xc052e06a
	.long	0x414f90d5
	.long	0x3f9da357
	.long	0x403394dc
	.long	0xc006e2af
	.long	0xbf99dd33
	.long	0x4052d1de
	.long	0xc085e19e
	.long	0x40799dda
	.long	0xbfb9c643
	.long	0x4034689d
	.long	0x404e8701
	.long	0xc1513593
	.long	0xbfe097da
	.long	0x3da6a827
	.long	0x4078741e
	.size	__constant_32xf32_2, 128

	.type	__constant_32xf32_3,@object
	.section	.rodata.__constant_32xf32_3,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_3:
	.long	0x3fe94a76
	.long	0x3e8107a7
	.long	0x4051baad
	.long	0xc0676ae0
	.long	0x40002740
	.long	0x3e9e7fb1
	.long	0xbfc7a8be
	.long	0xbf952344
	.long	0xbf86feb3
	.long	0x406daf4d
	.long	0xc03214c7
	.long	0x3e7e688d
	.long	0xbf567eef
	.long	0xc00f6868
	.long	0xbf44e6d3
	.long	0xbe134efb
	.long	0x4091e670
	.long	0x401f3f35
	.long	0x403e9bde
	.long	0xc1038bf3
	.long	0xbe70a620
	.long	0xbff640b4
	.long	0xc101a9bf
	.long	0x3f263f67
	.long	0xc03fb1cc
	.long	0xc0ad1cd3
	.long	0x4029d647
	.long	0xc05df142
	.long	0xc1a1a835
	.long	0x40068c89
	.long	0x3e3e569a
	.long	0x3d317795
	.size	__constant_32xf32_3, 128

	.type	__constant_64xf32,@object
	.section	.rodata.__constant_64xf32,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32:
	.long	0xc132fe78
	.long	0x3fa403fa
	.long	0xc0986e63
	.long	0x411ee00e
	.long	0x3f43b082
	.long	0xc0e7bcc6
	.long	0x40f62aef
	.long	0x40a31f77
	.long	0x40323d67
	.long	0x412ef714
	.long	0x40c9199a
	.long	0x40ebed59
	.long	0xbfb5aa54
	.long	0xc0c70a5f
	.long	0x3fb38097
	.long	0xc04bf2fd
	.long	0x400ce401
	.long	0x400a9c08
	.long	0xc0507feb
	.long	0x40d741d6
	.long	0x41c58557
	.long	0x41513e69
	.long	0x40b8d46f
	.long	0x41447716
	.long	0x40b97a0a
	.long	0xc0da0c16
	.long	0xc0cb4c87
	.long	0xc0c53877
	.long	0xbf288e59
	.long	0x40a17e14
	.long	0xc0117285
	.long	0xc087eb35
	.long	0x41360fec
	.long	0x412e23a7
	.long	0xc0f2c4fc
	.long	0xbf4d9f7f
	.long	0x402af2f6
	.long	0x415c0cd4
	.long	0xc071677a
	.long	0x4095ebe7
	.long	0x3f71324b
	.long	0x3f028a3f
	.long	0x41928c41
	.long	0xbfac59bb
	.long	0xc1354311
	.long	0xc1040307
	.long	0x41047dd9
	.long	0xc0fa59a8
	.long	0x4034d0ac
	.long	0x400966b6
	.long	0xbfada469
	.long	0xc031bb4b
	.long	0x40c9f6e5
	.long	0xbf990f66
	.long	0x4163f57b
	.long	0xbf8eafe1
	.long	0xc011722f
	.long	0x3e5ca7ad
	.long	0x40b5d4a8
	.long	0x412072c8
	.long	0x40cdc77f
	.long	0xbf26158d
	.long	0x411f4e94
	.long	0x40424a46
	.size	__constant_64xf32, 256

	.type	__constant_64xf32_0,@object
	.section	.rodata.__constant_64xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32_0:
	.long	0x3f4e57da
	.long	0xbf642986
	.long	0xbeaa7cde
	.long	0x3f247905
	.long	0x3dc0ad29
	.long	0x3db8bbeb
	.long	0xbf038c2e
	.long	0x3f48016a
	.long	0x3ed8fbda
	.long	0xbf070757
	.long	0xbfdd5b68
	.long	0x3f18087d
	.long	0x3db01c58
	.long	0xbf690b14
	.long	0xbf575a71
	.long	0x404ac26a
	.long	0x3ee106c0
	.long	0xbf815d5e
	.long	0x404bbe51
	.long	0xc009b069
	.long	0x3eca6441
	.long	0xc01b1967
	.long	0x3fd27f69
	.long	0xbea48621
	.long	0x3ed2a4f6
	.long	0xbf41a5b4
	.long	0x3e4aa51b
	.long	0xbf38d801
	.long	0x4055fbe1
	.long	0x3f2b944d
	.long	0xc0a06275
	.long	0xc0755470
	.long	0x3f8e47ee
	.long	0x3e55d42a
	.long	0xbfcc05d0
	.long	0x4012da0d
	.long	0xbf48c021
	.long	0x3e7dd8a0
	.long	0x3f971b05
	.long	0xc08380aa
	.long	0x3d568cdc
	.long	0xc0483f63
	.long	0x3d57039f
	.long	0x3fab1f41
	.long	0x3f1f8642
	.long	0x3d853784
	.long	0xbfec795e
	.long	0xbd98ece3
	.long	0xc055ce3e
	.long	0xbe9aee07
	.long	0xbf3b8549
	.long	0xbfc40a4c
	.long	0xbf7479a4
	.long	0xbf832834
	.long	0x3f248f56
	.long	0xbf4e9ab6
	.long	0x3fb29ade
	.long	0x3e897ae8
	.long	0xc005a768
	.long	0x3f37f445
	.long	0x3fae94e3
	.long	0x4020a788
	.long	0xbe5a01d3
	.long	0x3ec9998d
	.size	__constant_64xf32_0, 256

	.type	__constant_64xf32_1,@object
	.section	.rodata.__constant_64xf32_1,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32_1:
	.long	0x3f87a43d
	.long	0x40b8fbb7
	.long	0x3f811c62
	.long	0xbdfe4ec5
	.long	0xbf859b77
	.long	0xbde0dc81
	.long	0xbefe6e91
	.long	0x3f4e7eb2
	.long	0x3fa91c82
	.long	0xbe491e47
	.long	0x4071df8f
	.long	0xbfc0ef5b
	.long	0xc008f374
	.long	0x3f637b40
	.long	0xc0264b9b
	.long	0xc0c6c4ff
	.long	0xbe2733cd
	.long	0x3dcdf313
	.long	0x4055c714
	.long	0xbe6a008e
	.long	0xbfe5a6e2
	.long	0x3fcdd4f1
	.long	0xbe8184ba
	.long	0xbe82305f
	.long	0x3fe9b4e5
	.long	0xbfd2699a
	.long	0x4080b66e
	.long	0x400d6b6a
	.long	0xbf4cf4d8
	.long	0x3fdb1092
	.long	0xc0207768
	.long	0xc04ae50c
	.long	0xbee3ed6b
	.long	0xbc97ae4b
	.long	0xc01ab980
	.long	0x401c7c36
	.long	0xbf938494
	.long	0xbfb59e4f
	.long	0xbef3c51f
	.long	0xc059e6ce
	.long	0x406b964b
	.long	0x4011d1b0
	.long	0xbfedcb5f
	.long	0x3f42905e
	.long	0x3e21b184
	.long	0x3fa71905
	.long	0x3edf16fd
	.long	0xbe5490cc
	.long	0xc0b3004b
	.long	0x3f08a1ae
	.long	0x3ed54cce
	.long	0xbd4f2209
	.long	0xbead699c
	.long	0xbf55f917
	.long	0x3e743ca0
	.long	0xbfd1eb52
	.long	0xbff1abd4
	.long	0x3ff12b3a
	.long	0x4002e834
	.long	0x3f3acdb0
	.long	0xc015d339
	.long	0x3fb10d58
	.long	0xbecc2832
	.long	0xbfd3d8ba
	.size	__constant_64xf32_1, 256

	.type	__constant_64xf32_2,@object
	.section	.rodata.__constant_64xf32_2,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32_2:
	.long	0xbd6a1a66
	.long	0xbf112c5f
	.long	0xbf44cedf
	.long	0x3f8f09f3
	.long	0x3f0bd4ce
	.long	0xbdf2fdc8
	.long	0xc00b4bff
	.long	0xbe8d7713
	.long	0xc08a620c
	.long	0xbf863a24
	.long	0xc06c3851
	.long	0x4108483a
	.long	0x4043658c
	.long	0xbfc77eef
	.long	0xc0424f84
	.long	0xc0974651
	.long	0xbf8303c8
	.long	0xbff55553
	.long	0x3fa3fc40
	.long	0x404b216f
	.long	0xbf0d4e2e
	.long	0xc0004d7d
	.long	0xbf109935
	.long	0x3ea6c681
	.long	0xbf3a77f1
	.long	0x3fd906c6
	.long	0xc073bb1d
	.long	0x3f9cc07b
	.long	0xbe5929eb
	.long	0xbf44148d
	.long	0x403a2097
	.long	0xc09df3bf
	.long	0xbd6abd20
	.long	0xbe3a30a7
	.long	0x3fd2f61f
	.long	0xc08cbcd5
	.long	0x3d45f8e1
	.long	0xc05cb8cf
	.long	0x3f8cc938
	.long	0xc07aff37
	.long	0xbe360972
	.long	0xbe45aac6
	.long	0x3f62fdb7
	.long	0x3f76234d
	.long	0xbeaf1e65
	.long	0x3e959a26
	.long	0xbef79163
	.long	0x401ca71e
	.long	0xbf967794
	.long	0xbf4fc004
	.long	0xc098aa8e
	.long	0x3f211aeb
	.long	0x3fad6a8d
	.long	0x4035d3c7
	.long	0xbe3061f3
	.long	0x3fd1d3a1
	.long	0xc02be9d3
	.long	0xc01fc4a8
	.long	0xbeda6be7
	.long	0x3f47db48
	.long	0x3f74fcb5
	.long	0xc005ca30
	.long	0x3df42dd6
	.long	0x40b78627
	.size	__constant_64xf32_2, 256

	.type	__constant_1x3xf32,@object
	.section	.rodata.__constant_1x3xf32,"a",@progbits
	.p2align	6, 0x0
__constant_1x3xf32:
	.long	0x3d797f69
	.long	0xbc21611f
	.long	0xbd5126ca
	.size	__constant_1x3xf32, 12

	.type	__unnamed_1,@object
	.section	.rodata.__unnamed_1,"a",@progbits
__unnamed_1:
	.asciz	"smartcam_linked"
	.size	__unnamed_1, 16

	.type	iree_hal_executable_library_query_v0_header,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_header,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_header:
	.long	6
	.zero	4
	.quad	__unnamed_1
	.long	0
	.long	0
	.size	iree_hal_executable_library_query_v0_header, 24

	.type	iree_hal_executable_library_query_v0_funcs,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_funcs,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_funcs:
	.quad	infer_dispatch_0_elementwise_3x224x224_f32
	.quad	infer_dispatch_1_conv_32x112x112x3x3x3_f32
	.quad	infer_dispatch_2_conv_112x112x32x3x3_f32
	.quad	infer_dispatch_3_matmul_like_16x12544x32_f32
	.quad	infer_dispatch_4_matmul_like_96x112x112x16_f32
	.quad	infer_dispatch_5_conv_56x56x96x3x3_f32
	.quad	infer_dispatch_6_matmul_like_24x3136x96_f32
	.quad	infer_dispatch_7_matmul_like_144x56x56x24_f32
	.quad	infer_dispatch_8_conv_56x56x144x3x3_f32
	.quad	infer_dispatch_9_matmul_like_24x3136x144_f32
	.quad	infer_dispatch_10_matmul_like_144x56x56x24_f32
	.quad	infer_dispatch_11_conv_28x28x144x3x3_f32
	.quad	infer_dispatch_12_matmul_like_32x784x144_f32
	.quad	infer_dispatch_13_matmul_like_192x28x28x32_f32
	.quad	infer_dispatch_14_conv_28x28x192x3x3_f32
	.quad	infer_dispatch_15_matmul_like_32x784x192_f32
	.quad	infer_dispatch_18_matmul_like_32x784x192_f32
	.quad	infer_dispatch_19_matmul_like_192x28x28x32_f32
	.quad	infer_dispatch_20_conv_14x14x192x3x3_f32
	.quad	infer_dispatch_21_matmul_like_64x196x192_f32
	.quad	infer_dispatch_22_matmul_like_384x14x14x64_f32
	.quad	infer_dispatch_23_conv_14x14x384x3x3_f32
	.quad	infer_dispatch_24_matmul_like_64x196x384_f32
	.quad	infer_dispatch_27_matmul_like_64x196x384_f32
	.quad	infer_dispatch_30_matmul_like_64x196x384_f32
	.quad	infer_dispatch_33_matmul_like_96x196x384_f32
	.quad	infer_dispatch_34_matmul_like_576x14x14x96_f32
	.quad	infer_dispatch_35_conv_14x14x576x3x3_f32
	.quad	infer_dispatch_36_matmul_like_96x196x576_f32
	.quad	infer_dispatch_40_matmul_like_576x14x14x96_f32
	.quad	infer_dispatch_41_conv_7x7x576x3x3_f32
	.quad	infer_dispatch_42_matmul_like_160x49x576_f32
	.quad	infer_dispatch_43_matmul_like_960x7x7x160_f32
	.quad	infer_dispatch_44_conv_7x7x960x3x3_f32
	.quad	infer_dispatch_45_matmul_like_160x49x960_f32
	.quad	infer_dispatch_51_matmul_like_320x49x960_f32
	.quad	infer_dispatch_52_matmul_like_1280x49x320_f32
	.quad	infer_dispatch_53_reduction_1280x49_f32
	.quad	infer_dispatch_54_matmul_1x3x1280_f32
	.quad	infer_dispatch_55_softmax_3xf32_dispatch_tensor_store
	.size	iree_hal_executable_library_query_v0_funcs, 320

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
	.quad	0
	.short	0
	.byte	0
	.byte	2
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	3
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	2
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	5
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	4
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	3
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.short	0
	.byte	0
	.byte	2
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.size	iree_hal_executable_library_query_v0_attrs, 2560

	.type	__unnamed_2,@object
	.section	.rodata.__unnamed_2,"a",@progbits
__unnamed_2:
	.asciz	"infer_dispatch_0_elementwise_3x224x224_f32"
	.size	__unnamed_2, 43

	.type	__unnamed_3,@object
	.section	.rodata.__unnamed_3,"a",@progbits
__unnamed_3:
	.asciz	"infer_dispatch_1_conv_32x112x112x3x3x3_f32"
	.size	__unnamed_3, 43

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"infer_dispatch_2_conv_112x112x32x3x3_f32"
	.size	__unnamed_4, 41

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"infer_dispatch_3_matmul_like_16x12544x32_f32"
	.size	__unnamed_5, 45

	.type	__unnamed_6,@object
	.section	.rodata.__unnamed_6,"a",@progbits
__unnamed_6:
	.asciz	"infer_dispatch_4_matmul_like_96x112x112x16_f32"
	.size	__unnamed_6, 47

	.type	__unnamed_7,@object
	.section	.rodata.__unnamed_7,"a",@progbits
__unnamed_7:
	.asciz	"infer_dispatch_5_conv_56x56x96x3x3_f32"
	.size	__unnamed_7, 39

	.type	__unnamed_8,@object
	.section	.rodata.__unnamed_8,"a",@progbits
__unnamed_8:
	.asciz	"infer_dispatch_6_matmul_like_24x3136x96_f32"
	.size	__unnamed_8, 44

	.type	__unnamed_9,@object
	.section	.rodata.__unnamed_9,"a",@progbits
__unnamed_9:
	.asciz	"infer_dispatch_7_matmul_like_144x56x56x24_f32"
	.size	__unnamed_9, 46

	.type	__unnamed_10,@object
	.section	.rodata.__unnamed_10,"a",@progbits
__unnamed_10:
	.asciz	"infer_dispatch_8_conv_56x56x144x3x3_f32"
	.size	__unnamed_10, 40

	.type	__unnamed_11,@object
	.section	.rodata.__unnamed_11,"a",@progbits
__unnamed_11:
	.asciz	"infer_dispatch_9_matmul_like_24x3136x144_f32"
	.size	__unnamed_11, 45

	.type	__unnamed_12,@object
	.section	.rodata.__unnamed_12,"a",@progbits
__unnamed_12:
	.asciz	"infer_dispatch_10_matmul_like_144x56x56x24_f32"
	.size	__unnamed_12, 47

	.type	__unnamed_13,@object
	.section	.rodata.__unnamed_13,"a",@progbits
__unnamed_13:
	.asciz	"infer_dispatch_11_conv_28x28x144x3x3_f32"
	.size	__unnamed_13, 41

	.type	__unnamed_14,@object
	.section	.rodata.__unnamed_14,"a",@progbits
__unnamed_14:
	.asciz	"infer_dispatch_12_matmul_like_32x784x144_f32"
	.size	__unnamed_14, 45

	.type	__unnamed_15,@object
	.section	.rodata.__unnamed_15,"a",@progbits
__unnamed_15:
	.asciz	"infer_dispatch_13_matmul_like_192x28x28x32_f32"
	.size	__unnamed_15, 47

	.type	__unnamed_16,@object
	.section	.rodata.__unnamed_16,"a",@progbits
__unnamed_16:
	.asciz	"infer_dispatch_14_conv_28x28x192x3x3_f32"
	.size	__unnamed_16, 41

	.type	__unnamed_17,@object
	.section	.rodata.__unnamed_17,"a",@progbits
__unnamed_17:
	.asciz	"infer_dispatch_15_matmul_like_32x784x192_f32"
	.size	__unnamed_17, 45

	.type	__unnamed_18,@object
	.section	.rodata.__unnamed_18,"a",@progbits
__unnamed_18:
	.asciz	"infer_dispatch_18_matmul_like_32x784x192_f32"
	.size	__unnamed_18, 45

	.type	__unnamed_19,@object
	.section	.rodata.__unnamed_19,"a",@progbits
__unnamed_19:
	.asciz	"infer_dispatch_19_matmul_like_192x28x28x32_f32"
	.size	__unnamed_19, 47

	.type	__unnamed_20,@object
	.section	.rodata.__unnamed_20,"a",@progbits
__unnamed_20:
	.asciz	"infer_dispatch_20_conv_14x14x192x3x3_f32"
	.size	__unnamed_20, 41

	.type	__unnamed_21,@object
	.section	.rodata.__unnamed_21,"a",@progbits
__unnamed_21:
	.asciz	"infer_dispatch_21_matmul_like_64x196x192_f32"
	.size	__unnamed_21, 45

	.type	__unnamed_22,@object
	.section	.rodata.__unnamed_22,"a",@progbits
__unnamed_22:
	.asciz	"infer_dispatch_22_matmul_like_384x14x14x64_f32"
	.size	__unnamed_22, 47

	.type	__unnamed_23,@object
	.section	.rodata.__unnamed_23,"a",@progbits
__unnamed_23:
	.asciz	"infer_dispatch_23_conv_14x14x384x3x3_f32"
	.size	__unnamed_23, 41

	.type	__unnamed_24,@object
	.section	.rodata.__unnamed_24,"a",@progbits
__unnamed_24:
	.asciz	"infer_dispatch_24_matmul_like_64x196x384_f32"
	.size	__unnamed_24, 45

	.type	__unnamed_25,@object
	.section	.rodata.__unnamed_25,"a",@progbits
__unnamed_25:
	.asciz	"infer_dispatch_27_matmul_like_64x196x384_f32"
	.size	__unnamed_25, 45

	.type	__unnamed_26,@object
	.section	.rodata.__unnamed_26,"a",@progbits
__unnamed_26:
	.asciz	"infer_dispatch_30_matmul_like_64x196x384_f32"
	.size	__unnamed_26, 45

	.type	__unnamed_27,@object
	.section	.rodata.__unnamed_27,"a",@progbits
__unnamed_27:
	.asciz	"infer_dispatch_33_matmul_like_96x196x384_f32"
	.size	__unnamed_27, 45

	.type	__unnamed_28,@object
	.section	.rodata.__unnamed_28,"a",@progbits
__unnamed_28:
	.asciz	"infer_dispatch_34_matmul_like_576x14x14x96_f32"
	.size	__unnamed_28, 47

	.type	__unnamed_29,@object
	.section	.rodata.__unnamed_29,"a",@progbits
__unnamed_29:
	.asciz	"infer_dispatch_35_conv_14x14x576x3x3_f32"
	.size	__unnamed_29, 41

	.type	__unnamed_30,@object
	.section	.rodata.__unnamed_30,"a",@progbits
__unnamed_30:
	.asciz	"infer_dispatch_36_matmul_like_96x196x576_f32"
	.size	__unnamed_30, 45

	.type	__unnamed_31,@object
	.section	.rodata.__unnamed_31,"a",@progbits
__unnamed_31:
	.asciz	"infer_dispatch_40_matmul_like_576x14x14x96_f32"
	.size	__unnamed_31, 47

	.type	__unnamed_32,@object
	.section	.rodata.__unnamed_32,"a",@progbits
__unnamed_32:
	.asciz	"infer_dispatch_41_conv_7x7x576x3x3_f32"
	.size	__unnamed_32, 39

	.type	__unnamed_33,@object
	.section	.rodata.__unnamed_33,"a",@progbits
__unnamed_33:
	.asciz	"infer_dispatch_42_matmul_like_160x49x576_f32"
	.size	__unnamed_33, 45

	.type	__unnamed_34,@object
	.section	.rodata.__unnamed_34,"a",@progbits
__unnamed_34:
	.asciz	"infer_dispatch_43_matmul_like_960x7x7x160_f32"
	.size	__unnamed_34, 46

	.type	__unnamed_35,@object
	.section	.rodata.__unnamed_35,"a",@progbits
__unnamed_35:
	.asciz	"infer_dispatch_44_conv_7x7x960x3x3_f32"
	.size	__unnamed_35, 39

	.type	__unnamed_36,@object
	.section	.rodata.__unnamed_36,"a",@progbits
__unnamed_36:
	.asciz	"infer_dispatch_45_matmul_like_160x49x960_f32"
	.size	__unnamed_36, 45

	.type	__unnamed_37,@object
	.section	.rodata.__unnamed_37,"a",@progbits
__unnamed_37:
	.asciz	"infer_dispatch_51_matmul_like_320x49x960_f32"
	.size	__unnamed_37, 45

	.type	__unnamed_38,@object
	.section	.rodata.__unnamed_38,"a",@progbits
__unnamed_38:
	.asciz	"infer_dispatch_52_matmul_like_1280x49x320_f32"
	.size	__unnamed_38, 46

	.type	__unnamed_39,@object
	.section	.rodata.__unnamed_39,"a",@progbits
__unnamed_39:
	.asciz	"infer_dispatch_53_reduction_1280x49_f32"
	.size	__unnamed_39, 40

	.type	__unnamed_40,@object
	.section	.rodata.__unnamed_40,"a",@progbits
__unnamed_40:
	.asciz	"infer_dispatch_54_matmul_1x3x1280_f32"
	.size	__unnamed_40, 38

	.type	__unnamed_41,@object
	.section	.rodata.__unnamed_41,"a",@progbits
__unnamed_41:
	.asciz	"infer_dispatch_55_softmax_3xf32_dispatch_tensor_store"
	.size	__unnamed_41, 54

	.type	iree_hal_executable_library_query_v0_names,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_names,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_names:
	.quad	__unnamed_2
	.quad	__unnamed_3
	.quad	__unnamed_4
	.quad	__unnamed_5
	.quad	__unnamed_6
	.quad	__unnamed_7
	.quad	__unnamed_8
	.quad	__unnamed_9
	.quad	__unnamed_10
	.quad	__unnamed_11
	.quad	__unnamed_12
	.quad	__unnamed_13
	.quad	__unnamed_14
	.quad	__unnamed_15
	.quad	__unnamed_16
	.quad	__unnamed_17
	.quad	__unnamed_18
	.quad	__unnamed_19
	.quad	__unnamed_20
	.quad	__unnamed_21
	.quad	__unnamed_22
	.quad	__unnamed_23
	.quad	__unnamed_24
	.quad	__unnamed_25
	.quad	__unnamed_26
	.quad	__unnamed_27
	.quad	__unnamed_28
	.quad	__unnamed_29
	.quad	__unnamed_30
	.quad	__unnamed_31
	.quad	__unnamed_32
	.quad	__unnamed_33
	.quad	__unnamed_34
	.quad	__unnamed_35
	.quad	__unnamed_36
	.quad	__unnamed_37
	.quad	__unnamed_38
	.quad	__unnamed_39
	.quad	__unnamed_40
	.quad	__unnamed_41
	.size	iree_hal_executable_library_query_v0_names, 320

	.type	__unnamed_42,@object
	.section	.rodata.__unnamed_42,"a",@progbits
__unnamed_42:
	.asciz	"dump/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_42, 45

	.type	__unnamed_43,@object
	.section	.rodata.__unnamed_43,"a",@progbits
__unnamed_43:
	.asciz	"dump/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_43, 45

	.type	__unnamed_44,@object
	.section	.rodata.__unnamed_44,"a",@progbits
__unnamed_44:
	.asciz	"dump/configured_module_infer_dispatch_2.mlir"
	.size	__unnamed_44, 45

	.type	__unnamed_45,@object
	.section	.rodata.__unnamed_45,"a",@progbits
__unnamed_45:
	.asciz	"dump/configured_module_infer_dispatch_3.mlir"
	.size	__unnamed_45, 45

	.type	__unnamed_46,@object
	.section	.rodata.__unnamed_46,"a",@progbits
__unnamed_46:
	.asciz	"dump/configured_module_infer_dispatch_4.mlir"
	.size	__unnamed_46, 45

	.type	__unnamed_47,@object
	.section	.rodata.__unnamed_47,"a",@progbits
__unnamed_47:
	.asciz	"dump/configured_module_infer_dispatch_5.mlir"
	.size	__unnamed_47, 45

	.type	__unnamed_48,@object
	.section	.rodata.__unnamed_48,"a",@progbits
__unnamed_48:
	.asciz	"dump/configured_module_infer_dispatch_6.mlir"
	.size	__unnamed_48, 45

	.type	__unnamed_49,@object
	.section	.rodata.__unnamed_49,"a",@progbits
__unnamed_49:
	.asciz	"dump/configured_module_infer_dispatch_7.mlir"
	.size	__unnamed_49, 45

	.type	__unnamed_50,@object
	.section	.rodata.__unnamed_50,"a",@progbits
__unnamed_50:
	.asciz	"dump/configured_module_infer_dispatch_8.mlir"
	.size	__unnamed_50, 45

	.type	__unnamed_51,@object
	.section	.rodata.__unnamed_51,"a",@progbits
__unnamed_51:
	.asciz	"dump/configured_module_infer_dispatch_9.mlir"
	.size	__unnamed_51, 45

	.type	__unnamed_52,@object
	.section	.rodata.__unnamed_52,"a",@progbits
__unnamed_52:
	.asciz	"dump/configured_module_infer_dispatch_10.mlir"
	.size	__unnamed_52, 46

	.type	__unnamed_53,@object
	.section	.rodata.__unnamed_53,"a",@progbits
__unnamed_53:
	.asciz	"dump/configured_module_infer_dispatch_11.mlir"
	.size	__unnamed_53, 46

	.type	__unnamed_54,@object
	.section	.rodata.__unnamed_54,"a",@progbits
__unnamed_54:
	.asciz	"dump/configured_module_infer_dispatch_12.mlir"
	.size	__unnamed_54, 46

	.type	__unnamed_55,@object
	.section	.rodata.__unnamed_55,"a",@progbits
__unnamed_55:
	.asciz	"dump/configured_module_infer_dispatch_13.mlir"
	.size	__unnamed_55, 46

	.type	__unnamed_56,@object
	.section	.rodata.__unnamed_56,"a",@progbits
__unnamed_56:
	.asciz	"dump/configured_module_infer_dispatch_14.mlir"
	.size	__unnamed_56, 46

	.type	__unnamed_57,@object
	.section	.rodata.__unnamed_57,"a",@progbits
__unnamed_57:
	.asciz	"dump/configured_module_infer_dispatch_15.mlir"
	.size	__unnamed_57, 46

	.type	__unnamed_58,@object
	.section	.rodata.__unnamed_58,"a",@progbits
__unnamed_58:
	.asciz	"dump/configured_module_infer_dispatch_18.mlir"
	.size	__unnamed_58, 46

	.type	__unnamed_59,@object
	.section	.rodata.__unnamed_59,"a",@progbits
__unnamed_59:
	.asciz	"dump/configured_module_infer_dispatch_19.mlir"
	.size	__unnamed_59, 46

	.type	__unnamed_60,@object
	.section	.rodata.__unnamed_60,"a",@progbits
__unnamed_60:
	.asciz	"dump/configured_module_infer_dispatch_20.mlir"
	.size	__unnamed_60, 46

	.type	__unnamed_61,@object
	.section	.rodata.__unnamed_61,"a",@progbits
__unnamed_61:
	.asciz	"dump/configured_module_infer_dispatch_21.mlir"
	.size	__unnamed_61, 46

	.type	__unnamed_62,@object
	.section	.rodata.__unnamed_62,"a",@progbits
__unnamed_62:
	.asciz	"dump/configured_module_infer_dispatch_22.mlir"
	.size	__unnamed_62, 46

	.type	__unnamed_63,@object
	.section	.rodata.__unnamed_63,"a",@progbits
__unnamed_63:
	.asciz	"dump/configured_module_infer_dispatch_23.mlir"
	.size	__unnamed_63, 46

	.type	__unnamed_64,@object
	.section	.rodata.__unnamed_64,"a",@progbits
__unnamed_64:
	.asciz	"dump/configured_module_infer_dispatch_24.mlir"
	.size	__unnamed_64, 46

	.type	__unnamed_65,@object
	.section	.rodata.__unnamed_65,"a",@progbits
__unnamed_65:
	.asciz	"dump/configured_module_infer_dispatch_27.mlir"
	.size	__unnamed_65, 46

	.type	__unnamed_66,@object
	.section	.rodata.__unnamed_66,"a",@progbits
__unnamed_66:
	.asciz	"dump/configured_module_infer_dispatch_30.mlir"
	.size	__unnamed_66, 46

	.type	__unnamed_67,@object
	.section	.rodata.__unnamed_67,"a",@progbits
__unnamed_67:
	.asciz	"dump/configured_module_infer_dispatch_33.mlir"
	.size	__unnamed_67, 46

	.type	__unnamed_68,@object
	.section	.rodata.__unnamed_68,"a",@progbits
__unnamed_68:
	.asciz	"dump/configured_module_infer_dispatch_34.mlir"
	.size	__unnamed_68, 46

	.type	__unnamed_69,@object
	.section	.rodata.__unnamed_69,"a",@progbits
__unnamed_69:
	.asciz	"dump/configured_module_infer_dispatch_35.mlir"
	.size	__unnamed_69, 46

	.type	__unnamed_70,@object
	.section	.rodata.__unnamed_70,"a",@progbits
__unnamed_70:
	.asciz	"dump/configured_module_infer_dispatch_36.mlir"
	.size	__unnamed_70, 46

	.type	__unnamed_71,@object
	.section	.rodata.__unnamed_71,"a",@progbits
__unnamed_71:
	.asciz	"dump/configured_module_infer_dispatch_40.mlir"
	.size	__unnamed_71, 46

	.type	__unnamed_72,@object
	.section	.rodata.__unnamed_72,"a",@progbits
__unnamed_72:
	.asciz	"dump/configured_module_infer_dispatch_41.mlir"
	.size	__unnamed_72, 46

	.type	__unnamed_73,@object
	.section	.rodata.__unnamed_73,"a",@progbits
__unnamed_73:
	.asciz	"dump/configured_module_infer_dispatch_42.mlir"
	.size	__unnamed_73, 46

	.type	__unnamed_74,@object
	.section	.rodata.__unnamed_74,"a",@progbits
__unnamed_74:
	.asciz	"dump/configured_module_infer_dispatch_43.mlir"
	.size	__unnamed_74, 46

	.type	__unnamed_75,@object
	.section	.rodata.__unnamed_75,"a",@progbits
__unnamed_75:
	.asciz	"dump/configured_module_infer_dispatch_44.mlir"
	.size	__unnamed_75, 46

	.type	__unnamed_76,@object
	.section	.rodata.__unnamed_76,"a",@progbits
__unnamed_76:
	.asciz	"dump/configured_module_infer_dispatch_45.mlir"
	.size	__unnamed_76, 46

	.type	__unnamed_77,@object
	.section	.rodata.__unnamed_77,"a",@progbits
__unnamed_77:
	.asciz	"dump/configured_module_infer_dispatch_51.mlir"
	.size	__unnamed_77, 46

	.type	__unnamed_78,@object
	.section	.rodata.__unnamed_78,"a",@progbits
__unnamed_78:
	.asciz	"dump/configured_module_infer_dispatch_52.mlir"
	.size	__unnamed_78, 46

	.type	__unnamed_79,@object
	.section	.rodata.__unnamed_79,"a",@progbits
__unnamed_79:
	.asciz	"dump/configured_module_infer_dispatch_53.mlir"
	.size	__unnamed_79, 46

	.type	__unnamed_80,@object
	.section	.rodata.__unnamed_80,"a",@progbits
__unnamed_80:
	.asciz	"dump/configured_module_infer_dispatch_54.mlir"
	.size	__unnamed_80, 46

	.type	__unnamed_81,@object
	.section	.rodata.__unnamed_81,"a",@progbits
__unnamed_81:
	.asciz	"dump/configured_module_infer_dispatch_55.mlir"
	.size	__unnamed_81, 46

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.long	3
	.long	44
	.quad	__unnamed_42
	.long	3
	.long	44
	.quad	__unnamed_43
	.long	3
	.long	44
	.quad	__unnamed_44
	.long	3
	.long	44
	.quad	__unnamed_45
	.long	3
	.long	44
	.quad	__unnamed_46
	.long	3
	.long	44
	.quad	__unnamed_47
	.long	3
	.long	44
	.quad	__unnamed_48
	.long	3
	.long	44
	.quad	__unnamed_49
	.long	3
	.long	44
	.quad	__unnamed_50
	.long	3
	.long	44
	.quad	__unnamed_51
	.long	3
	.long	45
	.quad	__unnamed_52
	.long	3
	.long	45
	.quad	__unnamed_53
	.long	3
	.long	45
	.quad	__unnamed_54
	.long	3
	.long	45
	.quad	__unnamed_55
	.long	3
	.long	45
	.quad	__unnamed_56
	.long	3
	.long	45
	.quad	__unnamed_57
	.long	3
	.long	45
	.quad	__unnamed_58
	.long	3
	.long	45
	.quad	__unnamed_59
	.long	3
	.long	45
	.quad	__unnamed_60
	.long	3
	.long	45
	.quad	__unnamed_61
	.long	3
	.long	45
	.quad	__unnamed_62
	.long	3
	.long	45
	.quad	__unnamed_63
	.long	3
	.long	45
	.quad	__unnamed_64
	.long	3
	.long	45
	.quad	__unnamed_65
	.long	3
	.long	45
	.quad	__unnamed_66
	.long	3
	.long	45
	.quad	__unnamed_67
	.long	3
	.long	45
	.quad	__unnamed_68
	.long	3
	.long	45
	.quad	__unnamed_69
	.long	3
	.long	45
	.quad	__unnamed_70
	.long	3
	.long	45
	.quad	__unnamed_71
	.long	3
	.long	45
	.quad	__unnamed_72
	.long	3
	.long	45
	.quad	__unnamed_73
	.long	3
	.long	45
	.quad	__unnamed_74
	.long	3
	.long	45
	.quad	__unnamed_75
	.long	3
	.long	45
	.quad	__unnamed_76
	.long	3
	.long	45
	.quad	__unnamed_77
	.long	3
	.long	45
	.quad	__unnamed_78
	.long	3
	.long	45
	.quad	__unnamed_79
	.long	3
	.long	45
	.quad	__unnamed_80
	.long	3
	.long	45
	.quad	__unnamed_81
	.size	iree_hal_executable_library_query_v0_source_locations, 640

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_stage_location_tables,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_stage_location_tables,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_stage_location_tables:
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 960

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.quad	iree_hal_executable_library_query_v0_header
	.zero	16
	.long	40
	.zero	4
	.quad	iree_hal_executable_library_query_v0_funcs
	.quad	iree_hal_executable_library_query_v0_attrs
	.quad	0
	.quad	0
	.quad	iree_hal_executable_library_query_v0_names
	.quad	0
	.quad	0
	.quad	iree_hal_executable_library_query_v0_source_locations
	.quad	iree_hal_executable_library_query_v0_stage_location_tables
	.zero	4
	.zero	4
	.zero	16
	.size	iree_hal_executable_library_query_v0, 128

	.type	__exp2f_data,@object
	.section	.rodata.__exp2f_data,"a",@progbits
	.p2align	3, 0x0
__exp2f_data:
	.quad	4607182418800017408
	.quad	4607140297302181236
	.quad	4607100335213349135
	.quad	4607062579818421073
	.quad	4607027079437701499
	.quad	4606993883449571754
	.quad	4606963042313658936
	.quad	4606934607594512097
	.quad	4606908631985796885
	.quad	4606885169335019979
	.quad	4606864274668794914
	.quad	4606846004218661165
	.quad	4606830415447468583
	.quad	4606817567076339586
	.quad	4606807519112221737
	.quad	4606800332876043653
	.quad	4606796071031487437
	.quad	4606794797614391156
	.quad	4606796578062795143
	.quad	4606801479247646227
	.quad	4606809569504174299
	.quad	4606820918663955941
	.quad	4606835598087680144
	.quad	4606853680698631517
	.quad	4606875241016906669
	.quad	4606900355194379847
	.quad	4606929101050434204
	.quad	4606961558108475497
	.quad	4606997807633245319
	.quad	4607037932668951391
	.quad	4607082018078232794
	.quad	4607130150581978432
	.quad	0x42e8000000000000
	.quad	0x3fac6af84b912394
	.quad	0x3fcebfce50fac4f3
	.quad	0x3fe62e42ff0c52d6
	.quad	0x4338000000000000
	.quad	0x40471547652b82fe
	.quad	0x3ebc6af84b912394
	.quad	0x3f2ebfce50fac4f3
	.quad	0x3f962e42ff0c52d6
	.size	__exp2f_data, 328

	.type	__powf_log2_data,@object
	.section	.rodata.__powf_log2_data,"a",@progbits
	.p2align	3, 0x0
__powf_log2_data:
	.quad	0x3ff661ec79f8f3be
	.quad	0xbfdefec65b963019
	.quad	0x3ff571ed4aaf883d
	.quad	0xbfdb0b6832d4fca4
	.quad	0x3ff49539f0f010b0
	.quad	0xbfd7418b0a1fb77b
	.quad	0x3ff3c995b0b80385
	.quad	0xbfd39de91a6dcf7b
	.quad	0x3ff30d190c8864a5
	.quad	0xbfd01d9bf3f2b631
	.quad	0x3ff25e227b0b8ea0
	.quad	0xbfc97c1d1b3b7af0
	.quad	0x3ff1bb4a4a1a343f
	.quad	0xbfc2f9e393af3c9f
	.quad	0x3ff12358f08ae5ba
	.quad	0xbfb960cbbf788d5c
	.quad	0x3ff0953f419900a7
	.quad	0xbfaa6f9db6475fce
	.quad	0x3ff0000000000000
	.quad	0x0000000000000000
	.quad	0x3fee608cfd9a47ac
	.quad	0x3fb338ca9f24f53d
	.quad	0x3feca4b31f026aa0
	.quad	0x3fc476a9543891ba
	.quad	0x3feb2036576afce6
	.quad	0x3fce840b4ac4e4d2
	.quad	0x3fe9c2d163a1aa2d
	.quad	0x3fd40645f0c6651c
	.quad	0x3fe886e6037841ed
	.quad	0x3fd88e9c2c1b9ff8
	.quad	0x3fe767dcf5534862
	.quad	0x3fdce0a44eb17bcc
	.quad	0x3fd27616c9496e0b
	.quad	0xbfd71969a075c67a
	.quad	0x3fdec70a6ca7badd
	.quad	0xbfe7154748bef6c8
	.quad	0x3ff71547652ab82b
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
	.long	.Ldebug_info_end0-.Ldebug_info_start0
.Ldebug_info_start0:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string1
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin0
	.long	.Lfunc_end0-.Lfunc_begin0
	.byte	2
	.quad	.Lfunc_begin0
	.long	.Lfunc_end0-.Lfunc_begin0
	.byte	1
	.byte	86
	.long	.Linfo_string42
	.long	.Linfo_string42
	.byte	1
	.byte	1
	.long	71

	.byte	3
	.long	.Linfo_string43
	.byte	5
	.byte	4
	.byte	0
.Ldebug_info_end0:
.Lcu_begin1:
	.long	.Ldebug_info_end1-.Ldebug_info_start1
.Ldebug_info_start1:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string3
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin1
	.long	.Lfunc_end1-.Lfunc_begin1
	.byte	4
	.quad	.Lfunc_begin1
	.long	.Lfunc_end1-.Lfunc_begin1
	.byte	1
	.byte	86
	.long	.Linfo_string44
	.long	.Linfo_string44
	.byte	2
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end1:
.Lcu_begin2:
	.long	.Ldebug_info_end2-.Ldebug_info_start2
.Ldebug_info_start2:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string4
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin2
	.long	.Lfunc_end2-.Lfunc_begin2
	.byte	4
	.quad	.Lfunc_begin2
	.long	.Lfunc_end2-.Lfunc_begin2
	.byte	1
	.byte	86
	.long	.Linfo_string45
	.long	.Linfo_string45
	.byte	3
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end2:
.Lcu_begin3:
	.long	.Ldebug_info_end3-.Ldebug_info_start3
.Ldebug_info_start3:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string5
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin3
	.long	.Lfunc_end3-.Lfunc_begin3
	.byte	4
	.quad	.Lfunc_begin3
	.long	.Lfunc_end3-.Lfunc_begin3
	.byte	1
	.byte	86
	.long	.Linfo_string46
	.long	.Linfo_string46
	.byte	4
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end3:
.Lcu_begin4:
	.long	.Ldebug_info_end4-.Ldebug_info_start4
.Ldebug_info_start4:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string6
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin4
	.long	.Lfunc_end4-.Lfunc_begin4
	.byte	4
	.quad	.Lfunc_begin4
	.long	.Lfunc_end4-.Lfunc_begin4
	.byte	1
	.byte	86
	.long	.Linfo_string47
	.long	.Linfo_string47
	.byte	5
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end4:
.Lcu_begin5:
	.long	.Ldebug_info_end5-.Ldebug_info_start5
.Ldebug_info_start5:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string7
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin5
	.long	.Lfunc_end5-.Lfunc_begin5
	.byte	4
	.quad	.Lfunc_begin5
	.long	.Lfunc_end5-.Lfunc_begin5
	.byte	1
	.byte	86
	.long	.Linfo_string48
	.long	.Linfo_string48
	.byte	6
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end5:
.Lcu_begin6:
	.long	.Ldebug_info_end6-.Ldebug_info_start6
.Ldebug_info_start6:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string8
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin6
	.long	.Lfunc_end6-.Lfunc_begin6
	.byte	4
	.quad	.Lfunc_begin6
	.long	.Lfunc_end6-.Lfunc_begin6
	.byte	1
	.byte	86
	.long	.Linfo_string49
	.long	.Linfo_string49
	.byte	7
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end6:
.Lcu_begin7:
	.long	.Ldebug_info_end7-.Ldebug_info_start7
.Ldebug_info_start7:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string9
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin7
	.long	.Lfunc_end7-.Lfunc_begin7
	.byte	4
	.quad	.Lfunc_begin7
	.long	.Lfunc_end7-.Lfunc_begin7
	.byte	1
	.byte	86
	.long	.Linfo_string50
	.long	.Linfo_string50
	.byte	8
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end7:
.Lcu_begin8:
	.long	.Ldebug_info_end8-.Ldebug_info_start8
.Ldebug_info_start8:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string10
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin8
	.long	.Lfunc_end8-.Lfunc_begin8
	.byte	4
	.quad	.Lfunc_begin8
	.long	.Lfunc_end8-.Lfunc_begin8
	.byte	1
	.byte	86
	.long	.Linfo_string51
	.long	.Linfo_string51
	.byte	9
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end8:
.Lcu_begin9:
	.long	.Ldebug_info_end9-.Ldebug_info_start9
.Ldebug_info_start9:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string11
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin9
	.long	.Lfunc_end9-.Lfunc_begin9
	.byte	4
	.quad	.Lfunc_begin9
	.long	.Lfunc_end9-.Lfunc_begin9
	.byte	1
	.byte	86
	.long	.Linfo_string52
	.long	.Linfo_string52
	.byte	10
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end9:
.Lcu_begin10:
	.long	.Ldebug_info_end10-.Ldebug_info_start10
.Ldebug_info_start10:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string12
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin10
	.long	.Lfunc_end10-.Lfunc_begin10
	.byte	4
	.quad	.Lfunc_begin10
	.long	.Lfunc_end10-.Lfunc_begin10
	.byte	1
	.byte	86
	.long	.Linfo_string53
	.long	.Linfo_string53
	.byte	11
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end10:
.Lcu_begin11:
	.long	.Ldebug_info_end11-.Ldebug_info_start11
.Ldebug_info_start11:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string13
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin11
	.long	.Lfunc_end11-.Lfunc_begin11
	.byte	4
	.quad	.Lfunc_begin11
	.long	.Lfunc_end11-.Lfunc_begin11
	.byte	1
	.byte	86
	.long	.Linfo_string54
	.long	.Linfo_string54
	.byte	12
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end11:
.Lcu_begin12:
	.long	.Ldebug_info_end12-.Ldebug_info_start12
.Ldebug_info_start12:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string14
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin12
	.long	.Lfunc_end12-.Lfunc_begin12
	.byte	4
	.quad	.Lfunc_begin12
	.long	.Lfunc_end12-.Lfunc_begin12
	.byte	1
	.byte	86
	.long	.Linfo_string55
	.long	.Linfo_string55
	.byte	13
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end12:
.Lcu_begin13:
	.long	.Ldebug_info_end13-.Ldebug_info_start13
.Ldebug_info_start13:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string15
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin13
	.long	.Lfunc_end13-.Lfunc_begin13
	.byte	4
	.quad	.Lfunc_begin13
	.long	.Lfunc_end13-.Lfunc_begin13
	.byte	1
	.byte	86
	.long	.Linfo_string56
	.long	.Linfo_string56
	.byte	14
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end13:
.Lcu_begin14:
	.long	.Ldebug_info_end14-.Ldebug_info_start14
.Ldebug_info_start14:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string16
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin14
	.long	.Lfunc_end14-.Lfunc_begin14
	.byte	4
	.quad	.Lfunc_begin14
	.long	.Lfunc_end14-.Lfunc_begin14
	.byte	1
	.byte	86
	.long	.Linfo_string57
	.long	.Linfo_string57
	.byte	15
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end14:
.Lcu_begin15:
	.long	.Ldebug_info_end15-.Ldebug_info_start15
.Ldebug_info_start15:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string17
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin15
	.long	.Lfunc_end15-.Lfunc_begin15
	.byte	4
	.quad	.Lfunc_begin15
	.long	.Lfunc_end15-.Lfunc_begin15
	.byte	1
	.byte	86
	.long	.Linfo_string58
	.long	.Linfo_string58
	.byte	16
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end15:
.Lcu_begin16:
	.long	.Ldebug_info_end16-.Ldebug_info_start16
.Ldebug_info_start16:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string18
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin16
	.long	.Lfunc_end16-.Lfunc_begin16
	.byte	4
	.quad	.Lfunc_begin16
	.long	.Lfunc_end16-.Lfunc_begin16
	.byte	1
	.byte	86
	.long	.Linfo_string59
	.long	.Linfo_string59
	.byte	17
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end16:
.Lcu_begin17:
	.long	.Ldebug_info_end17-.Ldebug_info_start17
.Ldebug_info_start17:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string19
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin17
	.long	.Lfunc_end17-.Lfunc_begin17
	.byte	4
	.quad	.Lfunc_begin17
	.long	.Lfunc_end17-.Lfunc_begin17
	.byte	1
	.byte	86
	.long	.Linfo_string60
	.long	.Linfo_string60
	.byte	18
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end17:
.Lcu_begin18:
	.long	.Ldebug_info_end18-.Ldebug_info_start18
.Ldebug_info_start18:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string20
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin18
	.long	.Lfunc_end18-.Lfunc_begin18
	.byte	4
	.quad	.Lfunc_begin18
	.long	.Lfunc_end18-.Lfunc_begin18
	.byte	1
	.byte	86
	.long	.Linfo_string61
	.long	.Linfo_string61
	.byte	19
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end18:
.Lcu_begin19:
	.long	.Ldebug_info_end19-.Ldebug_info_start19
.Ldebug_info_start19:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string21
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin19
	.long	.Lfunc_end19-.Lfunc_begin19
	.byte	4
	.quad	.Lfunc_begin19
	.long	.Lfunc_end19-.Lfunc_begin19
	.byte	1
	.byte	86
	.long	.Linfo_string62
	.long	.Linfo_string62
	.byte	20
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end19:
.Lcu_begin20:
	.long	.Ldebug_info_end20-.Ldebug_info_start20
.Ldebug_info_start20:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string22
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin20
	.long	.Lfunc_end20-.Lfunc_begin20
	.byte	4
	.quad	.Lfunc_begin20
	.long	.Lfunc_end20-.Lfunc_begin20
	.byte	1
	.byte	86
	.long	.Linfo_string63
	.long	.Linfo_string63
	.byte	21
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end20:
.Lcu_begin21:
	.long	.Ldebug_info_end21-.Ldebug_info_start21
.Ldebug_info_start21:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string23
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin21
	.long	.Lfunc_end21-.Lfunc_begin21
	.byte	4
	.quad	.Lfunc_begin21
	.long	.Lfunc_end21-.Lfunc_begin21
	.byte	1
	.byte	86
	.long	.Linfo_string64
	.long	.Linfo_string64
	.byte	22
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end21:
.Lcu_begin22:
	.long	.Ldebug_info_end22-.Ldebug_info_start22
.Ldebug_info_start22:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string24
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin22
	.long	.Lfunc_end22-.Lfunc_begin22
	.byte	4
	.quad	.Lfunc_begin22
	.long	.Lfunc_end22-.Lfunc_begin22
	.byte	1
	.byte	86
	.long	.Linfo_string65
	.long	.Linfo_string65
	.byte	23
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end22:
.Lcu_begin23:
	.long	.Ldebug_info_end23-.Ldebug_info_start23
.Ldebug_info_start23:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string25
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin23
	.long	.Lfunc_end23-.Lfunc_begin23
	.byte	4
	.quad	.Lfunc_begin23
	.long	.Lfunc_end23-.Lfunc_begin23
	.byte	1
	.byte	86
	.long	.Linfo_string66
	.long	.Linfo_string66
	.byte	24
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end23:
.Lcu_begin24:
	.long	.Ldebug_info_end24-.Ldebug_info_start24
.Ldebug_info_start24:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string26
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin24
	.long	.Lfunc_end24-.Lfunc_begin24
	.byte	4
	.quad	.Lfunc_begin24
	.long	.Lfunc_end24-.Lfunc_begin24
	.byte	1
	.byte	86
	.long	.Linfo_string67
	.long	.Linfo_string67
	.byte	25
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end24:
.Lcu_begin25:
	.long	.Ldebug_info_end25-.Ldebug_info_start25
.Ldebug_info_start25:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string27
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin25
	.long	.Lfunc_end25-.Lfunc_begin25
	.byte	4
	.quad	.Lfunc_begin25
	.long	.Lfunc_end25-.Lfunc_begin25
	.byte	1
	.byte	86
	.long	.Linfo_string68
	.long	.Linfo_string68
	.byte	26
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end25:
.Lcu_begin26:
	.long	.Ldebug_info_end26-.Ldebug_info_start26
.Ldebug_info_start26:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string28
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin26
	.long	.Lfunc_end26-.Lfunc_begin26
	.byte	4
	.quad	.Lfunc_begin26
	.long	.Lfunc_end26-.Lfunc_begin26
	.byte	1
	.byte	86
	.long	.Linfo_string69
	.long	.Linfo_string69
	.byte	27
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end26:
.Lcu_begin27:
	.long	.Ldebug_info_end27-.Ldebug_info_start27
.Ldebug_info_start27:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string29
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin27
	.long	.Lfunc_end27-.Lfunc_begin27
	.byte	4
	.quad	.Lfunc_begin27
	.long	.Lfunc_end27-.Lfunc_begin27
	.byte	1
	.byte	86
	.long	.Linfo_string70
	.long	.Linfo_string70
	.byte	28
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end27:
.Lcu_begin28:
	.long	.Ldebug_info_end28-.Ldebug_info_start28
.Ldebug_info_start28:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string30
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin28
	.long	.Lfunc_end28-.Lfunc_begin28
	.byte	4
	.quad	.Lfunc_begin28
	.long	.Lfunc_end28-.Lfunc_begin28
	.byte	1
	.byte	86
	.long	.Linfo_string71
	.long	.Linfo_string71
	.byte	29
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end28:
.Lcu_begin29:
	.long	.Ldebug_info_end29-.Ldebug_info_start29
.Ldebug_info_start29:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string31
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin29
	.long	.Lfunc_end29-.Lfunc_begin29
	.byte	4
	.quad	.Lfunc_begin29
	.long	.Lfunc_end29-.Lfunc_begin29
	.byte	1
	.byte	86
	.long	.Linfo_string72
	.long	.Linfo_string72
	.byte	30
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end29:
.Lcu_begin30:
	.long	.Ldebug_info_end30-.Ldebug_info_start30
.Ldebug_info_start30:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string32
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin30
	.long	.Lfunc_end30-.Lfunc_begin30
	.byte	4
	.quad	.Lfunc_begin30
	.long	.Lfunc_end30-.Lfunc_begin30
	.byte	1
	.byte	86
	.long	.Linfo_string73
	.long	.Linfo_string73
	.byte	31
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end30:
.Lcu_begin31:
	.long	.Ldebug_info_end31-.Ldebug_info_start31
.Ldebug_info_start31:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string33
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin31
	.long	.Lfunc_end31-.Lfunc_begin31
	.byte	4
	.quad	.Lfunc_begin31
	.long	.Lfunc_end31-.Lfunc_begin31
	.byte	1
	.byte	86
	.long	.Linfo_string74
	.long	.Linfo_string74
	.byte	32
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end31:
.Lcu_begin32:
	.long	.Ldebug_info_end32-.Ldebug_info_start32
.Ldebug_info_start32:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string34
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin32
	.long	.Lfunc_end32-.Lfunc_begin32
	.byte	4
	.quad	.Lfunc_begin32
	.long	.Lfunc_end32-.Lfunc_begin32
	.byte	1
	.byte	86
	.long	.Linfo_string75
	.long	.Linfo_string75
	.byte	33
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end32:
.Lcu_begin33:
	.long	.Ldebug_info_end33-.Ldebug_info_start33
.Ldebug_info_start33:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string35
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin33
	.long	.Lfunc_end33-.Lfunc_begin33
	.byte	4
	.quad	.Lfunc_begin33
	.long	.Lfunc_end33-.Lfunc_begin33
	.byte	1
	.byte	86
	.long	.Linfo_string76
	.long	.Linfo_string76
	.byte	34
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end33:
.Lcu_begin34:
	.long	.Ldebug_info_end34-.Ldebug_info_start34
.Ldebug_info_start34:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string36
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin34
	.long	.Lfunc_end34-.Lfunc_begin34
	.byte	4
	.quad	.Lfunc_begin34
	.long	.Lfunc_end34-.Lfunc_begin34
	.byte	1
	.byte	86
	.long	.Linfo_string77
	.long	.Linfo_string77
	.byte	35
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end34:
.Lcu_begin35:
	.long	.Ldebug_info_end35-.Ldebug_info_start35
.Ldebug_info_start35:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string37
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin35
	.long	.Lfunc_end35-.Lfunc_begin35
	.byte	4
	.quad	.Lfunc_begin35
	.long	.Lfunc_end35-.Lfunc_begin35
	.byte	1
	.byte	86
	.long	.Linfo_string78
	.long	.Linfo_string78
	.byte	36
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end35:
.Lcu_begin36:
	.long	.Ldebug_info_end36-.Ldebug_info_start36
.Ldebug_info_start36:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string38
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin36
	.long	.Lfunc_end36-.Lfunc_begin36
	.byte	4
	.quad	.Lfunc_begin36
	.long	.Lfunc_end36-.Lfunc_begin36
	.byte	1
	.byte	86
	.long	.Linfo_string79
	.long	.Linfo_string79
	.byte	37
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end36:
.Lcu_begin37:
	.long	.Ldebug_info_end37-.Ldebug_info_start37
.Ldebug_info_start37:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string39
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin37
	.long	.Lfunc_end37-.Lfunc_begin37
	.byte	4
	.quad	.Lfunc_begin37
	.long	.Lfunc_end37-.Lfunc_begin37
	.byte	1
	.byte	86
	.long	.Linfo_string80
	.long	.Linfo_string80
	.byte	38
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end37:
.Lcu_begin38:
	.long	.Ldebug_info_end38-.Ldebug_info_start38
.Ldebug_info_start38:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string40
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin38
	.long	.Lfunc_end38-.Lfunc_begin38
	.byte	4
	.quad	.Lfunc_begin38
	.long	.Lfunc_end38-.Lfunc_begin38
	.byte	1
	.byte	86
	.long	.Linfo_string81
	.long	.Linfo_string81
	.byte	39
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end38:
.Lcu_begin39:
	.long	.Ldebug_info_end39-.Ldebug_info_start39
.Ldebug_info_start39:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	44
	.long	.Linfo_string41
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	.Lfunc_begin39
	.long	.Lfunc_end39-.Lfunc_begin39
	.byte	4
	.quad	.Lfunc_begin39
	.long	.Lfunc_end39-.Lfunc_begin39
	.byte	1
	.byte	86
	.long	.Linfo_string82
	.long	.Linfo_string82
	.byte	40
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end39:
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
	.asciz	"configured_module_infer_dispatch_7.mlir"
.Linfo_string10:
	.asciz	"configured_module_infer_dispatch_8.mlir"
.Linfo_string11:
	.asciz	"configured_module_infer_dispatch_9.mlir"
.Linfo_string12:
	.asciz	"configured_module_infer_dispatch_10.mlir"
.Linfo_string13:
	.asciz	"configured_module_infer_dispatch_11.mlir"
.Linfo_string14:
	.asciz	"configured_module_infer_dispatch_12.mlir"
.Linfo_string15:
	.asciz	"configured_module_infer_dispatch_13.mlir"
.Linfo_string16:
	.asciz	"configured_module_infer_dispatch_14.mlir"
.Linfo_string17:
	.asciz	"configured_module_infer_dispatch_15.mlir"
.Linfo_string18:
	.asciz	"configured_module_infer_dispatch_18.mlir"
.Linfo_string19:
	.asciz	"configured_module_infer_dispatch_19.mlir"
.Linfo_string20:
	.asciz	"configured_module_infer_dispatch_20.mlir"
.Linfo_string21:
	.asciz	"configured_module_infer_dispatch_21.mlir"
.Linfo_string22:
	.asciz	"configured_module_infer_dispatch_22.mlir"
.Linfo_string23:
	.asciz	"configured_module_infer_dispatch_23.mlir"
.Linfo_string24:
	.asciz	"configured_module_infer_dispatch_24.mlir"
.Linfo_string25:
	.asciz	"configured_module_infer_dispatch_27.mlir"
.Linfo_string26:
	.asciz	"configured_module_infer_dispatch_30.mlir"
.Linfo_string27:
	.asciz	"configured_module_infer_dispatch_33.mlir"
.Linfo_string28:
	.asciz	"configured_module_infer_dispatch_34.mlir"
.Linfo_string29:
	.asciz	"configured_module_infer_dispatch_35.mlir"
.Linfo_string30:
	.asciz	"configured_module_infer_dispatch_36.mlir"
.Linfo_string31:
	.asciz	"configured_module_infer_dispatch_40.mlir"
.Linfo_string32:
	.asciz	"configured_module_infer_dispatch_41.mlir"
.Linfo_string33:
	.asciz	"configured_module_infer_dispatch_42.mlir"
.Linfo_string34:
	.asciz	"configured_module_infer_dispatch_43.mlir"
.Linfo_string35:
	.asciz	"configured_module_infer_dispatch_44.mlir"
.Linfo_string36:
	.asciz	"configured_module_infer_dispatch_45.mlir"
.Linfo_string37:
	.asciz	"configured_module_infer_dispatch_51.mlir"
.Linfo_string38:
	.asciz	"configured_module_infer_dispatch_52.mlir"
.Linfo_string39:
	.asciz	"configured_module_infer_dispatch_53.mlir"
.Linfo_string40:
	.asciz	"configured_module_infer_dispatch_54.mlir"
.Linfo_string41:
	.asciz	"configured_module_infer_dispatch_55.mlir"
.Linfo_string42:
	.asciz	"infer_dispatch_0_elementwise_3x224x224_f32"
.Linfo_string43:
	.asciz	"int"
.Linfo_string44:
	.asciz	"infer_dispatch_1_conv_32x112x112x3x3x3_f32"
.Linfo_string45:
	.asciz	"infer_dispatch_2_conv_112x112x32x3x3_f32"
.Linfo_string46:
	.asciz	"infer_dispatch_3_matmul_like_16x12544x32_f32"
.Linfo_string47:
	.asciz	"infer_dispatch_4_matmul_like_96x112x112x16_f32"
.Linfo_string48:
	.asciz	"infer_dispatch_5_conv_56x56x96x3x3_f32"
.Linfo_string49:
	.asciz	"infer_dispatch_6_matmul_like_24x3136x96_f32"
.Linfo_string50:
	.asciz	"infer_dispatch_7_matmul_like_144x56x56x24_f32"
.Linfo_string51:
	.asciz	"infer_dispatch_8_conv_56x56x144x3x3_f32"
.Linfo_string52:
	.asciz	"infer_dispatch_9_matmul_like_24x3136x144_f32"
.Linfo_string53:
	.asciz	"infer_dispatch_10_matmul_like_144x56x56x24_f32"
.Linfo_string54:
	.asciz	"infer_dispatch_11_conv_28x28x144x3x3_f32"
.Linfo_string55:
	.asciz	"infer_dispatch_12_matmul_like_32x784x144_f32"
.Linfo_string56:
	.asciz	"infer_dispatch_13_matmul_like_192x28x28x32_f32"
.Linfo_string57:
	.asciz	"infer_dispatch_14_conv_28x28x192x3x3_f32"
.Linfo_string58:
	.asciz	"infer_dispatch_15_matmul_like_32x784x192_f32"
.Linfo_string59:
	.asciz	"infer_dispatch_18_matmul_like_32x784x192_f32"
.Linfo_string60:
	.asciz	"infer_dispatch_19_matmul_like_192x28x28x32_f32"
.Linfo_string61:
	.asciz	"infer_dispatch_20_conv_14x14x192x3x3_f32"
.Linfo_string62:
	.asciz	"infer_dispatch_21_matmul_like_64x196x192_f32"
.Linfo_string63:
	.asciz	"infer_dispatch_22_matmul_like_384x14x14x64_f32"
.Linfo_string64:
	.asciz	"infer_dispatch_23_conv_14x14x384x3x3_f32"
.Linfo_string65:
	.asciz	"infer_dispatch_24_matmul_like_64x196x384_f32"
.Linfo_string66:
	.asciz	"infer_dispatch_27_matmul_like_64x196x384_f32"
.Linfo_string67:
	.asciz	"infer_dispatch_30_matmul_like_64x196x384_f32"
.Linfo_string68:
	.asciz	"infer_dispatch_33_matmul_like_96x196x384_f32"
.Linfo_string69:
	.asciz	"infer_dispatch_34_matmul_like_576x14x14x96_f32"
.Linfo_string70:
	.asciz	"infer_dispatch_35_conv_14x14x576x3x3_f32"
.Linfo_string71:
	.asciz	"infer_dispatch_36_matmul_like_96x196x576_f32"
.Linfo_string72:
	.asciz	"infer_dispatch_40_matmul_like_576x14x14x96_f32"
.Linfo_string73:
	.asciz	"infer_dispatch_41_conv_7x7x576x3x3_f32"
.Linfo_string74:
	.asciz	"infer_dispatch_42_matmul_like_160x49x576_f32"
.Linfo_string75:
	.asciz	"infer_dispatch_43_matmul_like_960x7x7x160_f32"
.Linfo_string76:
	.asciz	"infer_dispatch_44_conv_7x7x960x3x3_f32"
.Linfo_string77:
	.asciz	"infer_dispatch_45_matmul_like_160x49x960_f32"
.Linfo_string78:
	.asciz	"infer_dispatch_51_matmul_like_320x49x960_f32"
.Linfo_string79:
	.asciz	"infer_dispatch_52_matmul_like_1280x49x320_f32"
.Linfo_string80:
	.asciz	"infer_dispatch_53_reduction_1280x49_f32"
.Linfo_string81:
	.asciz	"infer_dispatch_54_matmul_1x3x1280_f32"
.Linfo_string82:
	.asciz	"infer_dispatch_55_softmax_3xf32_dispatch_tensor_store"
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.short	2
	.long	.Lcu_begin0
	.long	79
	.long	42
	.asciz	"infer_dispatch_0_elementwise_3x224x224_f32"
	.long	0
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_start0
.LpubTypes_start0:
	.short	2
	.long	.Lcu_begin0
	.long	79
	.long	71
	.asciz	"int"
	.long	0
.LpubTypes_end0:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end1-.LpubNames_start1
.LpubNames_start1:
	.short	2
	.long	.Lcu_begin1
	.long	72
	.long	42
	.asciz	"infer_dispatch_1_conv_32x112x112x3x3x3_f32"
	.long	0
.LpubNames_end1:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end1-.LpubTypes_start1
.LpubTypes_start1:
	.short	2
	.long	.Lcu_begin1
	.long	72
	.long	0
.LpubTypes_end1:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end2-.LpubNames_start2
.LpubNames_start2:
	.short	2
	.long	.Lcu_begin2
	.long	72
	.long	42
	.asciz	"infer_dispatch_2_conv_112x112x32x3x3_f32"
	.long	0
.LpubNames_end2:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end2-.LpubTypes_start2
.LpubTypes_start2:
	.short	2
	.long	.Lcu_begin2
	.long	72
	.long	0
.LpubTypes_end2:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end3-.LpubNames_start3
.LpubNames_start3:
	.short	2
	.long	.Lcu_begin3
	.long	72
	.long	42
	.asciz	"infer_dispatch_3_matmul_like_16x12544x32_f32"
	.long	0
.LpubNames_end3:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end3-.LpubTypes_start3
.LpubTypes_start3:
	.short	2
	.long	.Lcu_begin3
	.long	72
	.long	0
.LpubTypes_end3:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end4-.LpubNames_start4
.LpubNames_start4:
	.short	2
	.long	.Lcu_begin4
	.long	72
	.long	42
	.asciz	"infer_dispatch_4_matmul_like_96x112x112x16_f32"
	.long	0
.LpubNames_end4:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end4-.LpubTypes_start4
.LpubTypes_start4:
	.short	2
	.long	.Lcu_begin4
	.long	72
	.long	0
.LpubTypes_end4:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end5-.LpubNames_start5
.LpubNames_start5:
	.short	2
	.long	.Lcu_begin5
	.long	72
	.long	42
	.asciz	"infer_dispatch_5_conv_56x56x96x3x3_f32"
	.long	0
.LpubNames_end5:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end5-.LpubTypes_start5
.LpubTypes_start5:
	.short	2
	.long	.Lcu_begin5
	.long	72
	.long	0
.LpubTypes_end5:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end6-.LpubNames_start6
.LpubNames_start6:
	.short	2
	.long	.Lcu_begin6
	.long	72
	.long	42
	.asciz	"infer_dispatch_6_matmul_like_24x3136x96_f32"
	.long	0
.LpubNames_end6:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end6-.LpubTypes_start6
.LpubTypes_start6:
	.short	2
	.long	.Lcu_begin6
	.long	72
	.long	0
.LpubTypes_end6:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end7-.LpubNames_start7
.LpubNames_start7:
	.short	2
	.long	.Lcu_begin7
	.long	72
	.long	42
	.asciz	"infer_dispatch_7_matmul_like_144x56x56x24_f32"
	.long	0
.LpubNames_end7:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end7-.LpubTypes_start7
.LpubTypes_start7:
	.short	2
	.long	.Lcu_begin7
	.long	72
	.long	0
.LpubTypes_end7:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end8-.LpubNames_start8
.LpubNames_start8:
	.short	2
	.long	.Lcu_begin8
	.long	72
	.long	42
	.asciz	"infer_dispatch_8_conv_56x56x144x3x3_f32"
	.long	0
.LpubNames_end8:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end8-.LpubTypes_start8
.LpubTypes_start8:
	.short	2
	.long	.Lcu_begin8
	.long	72
	.long	0
.LpubTypes_end8:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end9-.LpubNames_start9
.LpubNames_start9:
	.short	2
	.long	.Lcu_begin9
	.long	72
	.long	42
	.asciz	"infer_dispatch_9_matmul_like_24x3136x144_f32"
	.long	0
.LpubNames_end9:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end9-.LpubTypes_start9
.LpubTypes_start9:
	.short	2
	.long	.Lcu_begin9
	.long	72
	.long	0
.LpubTypes_end9:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end10-.LpubNames_start10
.LpubNames_start10:
	.short	2
	.long	.Lcu_begin10
	.long	72
	.long	42
	.asciz	"infer_dispatch_10_matmul_like_144x56x56x24_f32"
	.long	0
.LpubNames_end10:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end10-.LpubTypes_start10
.LpubTypes_start10:
	.short	2
	.long	.Lcu_begin10
	.long	72
	.long	0
.LpubTypes_end10:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end11-.LpubNames_start11
.LpubNames_start11:
	.short	2
	.long	.Lcu_begin11
	.long	72
	.long	42
	.asciz	"infer_dispatch_11_conv_28x28x144x3x3_f32"
	.long	0
.LpubNames_end11:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end11-.LpubTypes_start11
.LpubTypes_start11:
	.short	2
	.long	.Lcu_begin11
	.long	72
	.long	0
.LpubTypes_end11:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end12-.LpubNames_start12
.LpubNames_start12:
	.short	2
	.long	.Lcu_begin12
	.long	72
	.long	42
	.asciz	"infer_dispatch_12_matmul_like_32x784x144_f32"
	.long	0
.LpubNames_end12:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end12-.LpubTypes_start12
.LpubTypes_start12:
	.short	2
	.long	.Lcu_begin12
	.long	72
	.long	0
.LpubTypes_end12:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end13-.LpubNames_start13
.LpubNames_start13:
	.short	2
	.long	.Lcu_begin13
	.long	72
	.long	42
	.asciz	"infer_dispatch_13_matmul_like_192x28x28x32_f32"
	.long	0
.LpubNames_end13:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end13-.LpubTypes_start13
.LpubTypes_start13:
	.short	2
	.long	.Lcu_begin13
	.long	72
	.long	0
.LpubTypes_end13:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end14-.LpubNames_start14
.LpubNames_start14:
	.short	2
	.long	.Lcu_begin14
	.long	72
	.long	42
	.asciz	"infer_dispatch_14_conv_28x28x192x3x3_f32"
	.long	0
.LpubNames_end14:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end14-.LpubTypes_start14
.LpubTypes_start14:
	.short	2
	.long	.Lcu_begin14
	.long	72
	.long	0
.LpubTypes_end14:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end15-.LpubNames_start15
.LpubNames_start15:
	.short	2
	.long	.Lcu_begin15
	.long	72
	.long	42
	.asciz	"infer_dispatch_15_matmul_like_32x784x192_f32"
	.long	0
.LpubNames_end15:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end15-.LpubTypes_start15
.LpubTypes_start15:
	.short	2
	.long	.Lcu_begin15
	.long	72
	.long	0
.LpubTypes_end15:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end16-.LpubNames_start16
.LpubNames_start16:
	.short	2
	.long	.Lcu_begin16
	.long	72
	.long	42
	.asciz	"infer_dispatch_18_matmul_like_32x784x192_f32"
	.long	0
.LpubNames_end16:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end16-.LpubTypes_start16
.LpubTypes_start16:
	.short	2
	.long	.Lcu_begin16
	.long	72
	.long	0
.LpubTypes_end16:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end17-.LpubNames_start17
.LpubNames_start17:
	.short	2
	.long	.Lcu_begin17
	.long	72
	.long	42
	.asciz	"infer_dispatch_19_matmul_like_192x28x28x32_f32"
	.long	0
.LpubNames_end17:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end17-.LpubTypes_start17
.LpubTypes_start17:
	.short	2
	.long	.Lcu_begin17
	.long	72
	.long	0
.LpubTypes_end17:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end18-.LpubNames_start18
.LpubNames_start18:
	.short	2
	.long	.Lcu_begin18
	.long	72
	.long	42
	.asciz	"infer_dispatch_20_conv_14x14x192x3x3_f32"
	.long	0
.LpubNames_end18:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end18-.LpubTypes_start18
.LpubTypes_start18:
	.short	2
	.long	.Lcu_begin18
	.long	72
	.long	0
.LpubTypes_end18:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end19-.LpubNames_start19
.LpubNames_start19:
	.short	2
	.long	.Lcu_begin19
	.long	72
	.long	42
	.asciz	"infer_dispatch_21_matmul_like_64x196x192_f32"
	.long	0
.LpubNames_end19:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end19-.LpubTypes_start19
.LpubTypes_start19:
	.short	2
	.long	.Lcu_begin19
	.long	72
	.long	0
.LpubTypes_end19:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end20-.LpubNames_start20
.LpubNames_start20:
	.short	2
	.long	.Lcu_begin20
	.long	72
	.long	42
	.asciz	"infer_dispatch_22_matmul_like_384x14x14x64_f32"
	.long	0
.LpubNames_end20:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end20-.LpubTypes_start20
.LpubTypes_start20:
	.short	2
	.long	.Lcu_begin20
	.long	72
	.long	0
.LpubTypes_end20:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end21-.LpubNames_start21
.LpubNames_start21:
	.short	2
	.long	.Lcu_begin21
	.long	72
	.long	42
	.asciz	"infer_dispatch_23_conv_14x14x384x3x3_f32"
	.long	0
.LpubNames_end21:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end21-.LpubTypes_start21
.LpubTypes_start21:
	.short	2
	.long	.Lcu_begin21
	.long	72
	.long	0
.LpubTypes_end21:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end22-.LpubNames_start22
.LpubNames_start22:
	.short	2
	.long	.Lcu_begin22
	.long	72
	.long	42
	.asciz	"infer_dispatch_24_matmul_like_64x196x384_f32"
	.long	0
.LpubNames_end22:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end22-.LpubTypes_start22
.LpubTypes_start22:
	.short	2
	.long	.Lcu_begin22
	.long	72
	.long	0
.LpubTypes_end22:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end23-.LpubNames_start23
.LpubNames_start23:
	.short	2
	.long	.Lcu_begin23
	.long	72
	.long	42
	.asciz	"infer_dispatch_27_matmul_like_64x196x384_f32"
	.long	0
.LpubNames_end23:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end23-.LpubTypes_start23
.LpubTypes_start23:
	.short	2
	.long	.Lcu_begin23
	.long	72
	.long	0
.LpubTypes_end23:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end24-.LpubNames_start24
.LpubNames_start24:
	.short	2
	.long	.Lcu_begin24
	.long	72
	.long	42
	.asciz	"infer_dispatch_30_matmul_like_64x196x384_f32"
	.long	0
.LpubNames_end24:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end24-.LpubTypes_start24
.LpubTypes_start24:
	.short	2
	.long	.Lcu_begin24
	.long	72
	.long	0
.LpubTypes_end24:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end25-.LpubNames_start25
.LpubNames_start25:
	.short	2
	.long	.Lcu_begin25
	.long	72
	.long	42
	.asciz	"infer_dispatch_33_matmul_like_96x196x384_f32"
	.long	0
.LpubNames_end25:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end25-.LpubTypes_start25
.LpubTypes_start25:
	.short	2
	.long	.Lcu_begin25
	.long	72
	.long	0
.LpubTypes_end25:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end26-.LpubNames_start26
.LpubNames_start26:
	.short	2
	.long	.Lcu_begin26
	.long	72
	.long	42
	.asciz	"infer_dispatch_34_matmul_like_576x14x14x96_f32"
	.long	0
.LpubNames_end26:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end26-.LpubTypes_start26
.LpubTypes_start26:
	.short	2
	.long	.Lcu_begin26
	.long	72
	.long	0
.LpubTypes_end26:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end27-.LpubNames_start27
.LpubNames_start27:
	.short	2
	.long	.Lcu_begin27
	.long	72
	.long	42
	.asciz	"infer_dispatch_35_conv_14x14x576x3x3_f32"
	.long	0
.LpubNames_end27:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end27-.LpubTypes_start27
.LpubTypes_start27:
	.short	2
	.long	.Lcu_begin27
	.long	72
	.long	0
.LpubTypes_end27:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end28-.LpubNames_start28
.LpubNames_start28:
	.short	2
	.long	.Lcu_begin28
	.long	72
	.long	42
	.asciz	"infer_dispatch_36_matmul_like_96x196x576_f32"
	.long	0
.LpubNames_end28:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end28-.LpubTypes_start28
.LpubTypes_start28:
	.short	2
	.long	.Lcu_begin28
	.long	72
	.long	0
.LpubTypes_end28:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end29-.LpubNames_start29
.LpubNames_start29:
	.short	2
	.long	.Lcu_begin29
	.long	72
	.long	42
	.asciz	"infer_dispatch_40_matmul_like_576x14x14x96_f32"
	.long	0
.LpubNames_end29:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end29-.LpubTypes_start29
.LpubTypes_start29:
	.short	2
	.long	.Lcu_begin29
	.long	72
	.long	0
.LpubTypes_end29:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end30-.LpubNames_start30
.LpubNames_start30:
	.short	2
	.long	.Lcu_begin30
	.long	72
	.long	42
	.asciz	"infer_dispatch_41_conv_7x7x576x3x3_f32"
	.long	0
.LpubNames_end30:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end30-.LpubTypes_start30
.LpubTypes_start30:
	.short	2
	.long	.Lcu_begin30
	.long	72
	.long	0
.LpubTypes_end30:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end31-.LpubNames_start31
.LpubNames_start31:
	.short	2
	.long	.Lcu_begin31
	.long	72
	.long	42
	.asciz	"infer_dispatch_42_matmul_like_160x49x576_f32"
	.long	0
.LpubNames_end31:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end31-.LpubTypes_start31
.LpubTypes_start31:
	.short	2
	.long	.Lcu_begin31
	.long	72
	.long	0
.LpubTypes_end31:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end32-.LpubNames_start32
.LpubNames_start32:
	.short	2
	.long	.Lcu_begin32
	.long	72
	.long	42
	.asciz	"infer_dispatch_43_matmul_like_960x7x7x160_f32"
	.long	0
.LpubNames_end32:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end32-.LpubTypes_start32
.LpubTypes_start32:
	.short	2
	.long	.Lcu_begin32
	.long	72
	.long	0
.LpubTypes_end32:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end33-.LpubNames_start33
.LpubNames_start33:
	.short	2
	.long	.Lcu_begin33
	.long	72
	.long	42
	.asciz	"infer_dispatch_44_conv_7x7x960x3x3_f32"
	.long	0
.LpubNames_end33:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end33-.LpubTypes_start33
.LpubTypes_start33:
	.short	2
	.long	.Lcu_begin33
	.long	72
	.long	0
.LpubTypes_end33:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end34-.LpubNames_start34
.LpubNames_start34:
	.short	2
	.long	.Lcu_begin34
	.long	72
	.long	42
	.asciz	"infer_dispatch_45_matmul_like_160x49x960_f32"
	.long	0
.LpubNames_end34:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end34-.LpubTypes_start34
.LpubTypes_start34:
	.short	2
	.long	.Lcu_begin34
	.long	72
	.long	0
.LpubTypes_end34:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end35-.LpubNames_start35
.LpubNames_start35:
	.short	2
	.long	.Lcu_begin35
	.long	72
	.long	42
	.asciz	"infer_dispatch_51_matmul_like_320x49x960_f32"
	.long	0
.LpubNames_end35:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end35-.LpubTypes_start35
.LpubTypes_start35:
	.short	2
	.long	.Lcu_begin35
	.long	72
	.long	0
.LpubTypes_end35:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end36-.LpubNames_start36
.LpubNames_start36:
	.short	2
	.long	.Lcu_begin36
	.long	72
	.long	42
	.asciz	"infer_dispatch_52_matmul_like_1280x49x320_f32"
	.long	0
.LpubNames_end36:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end36-.LpubTypes_start36
.LpubTypes_start36:
	.short	2
	.long	.Lcu_begin36
	.long	72
	.long	0
.LpubTypes_end36:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end37-.LpubNames_start37
.LpubNames_start37:
	.short	2
	.long	.Lcu_begin37
	.long	72
	.long	42
	.asciz	"infer_dispatch_53_reduction_1280x49_f32"
	.long	0
.LpubNames_end37:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end37-.LpubTypes_start37
.LpubTypes_start37:
	.short	2
	.long	.Lcu_begin37
	.long	72
	.long	0
.LpubTypes_end37:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end38-.LpubNames_start38
.LpubNames_start38:
	.short	2
	.long	.Lcu_begin38
	.long	72
	.long	42
	.asciz	"infer_dispatch_54_matmul_1x3x1280_f32"
	.long	0
.LpubNames_end38:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end38-.LpubTypes_start38
.LpubTypes_start38:
	.short	2
	.long	.Lcu_begin38
	.long	72
	.long	0
.LpubTypes_end38:
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end39-.LpubNames_start39
.LpubNames_start39:
	.short	2
	.long	.Lcu_begin39
	.long	72
	.long	42
	.asciz	"infer_dispatch_55_softmax_3xf32_dispatch_tensor_store"
	.long	0
.LpubNames_end39:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end39-.LpubTypes_start39
.LpubTypes_start39:
	.short	2
	.long	.Lcu_begin39
	.long	72
	.long	0
.LpubTypes_end39:
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
