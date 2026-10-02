	.att_syntax
	.file	"wgan_linked"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_0:
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_0_matmul_like_32x50176x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_0_matmul_like_32x50176x3_f32,@function
infer_dispatch_0_matmul_like_32x50176x3_f32:
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
	.loc	1 13 8 prologue_end
	movq	32(%rsi), %rsi
	.loc	1 20 8
	movl	(%rdx), %eax
	shlq	$8, %rax
	movq	(%rsi), %rcx
	addq	%rax, %rcx
	addq	16(%rsi), %rax
	.loc	1 14 8
	movq	8(%rsi), %rdx
	xorl	%esi, %esi
	leaq	__constant_32xf32(%rip), %rdi
	movss	.LCPI0_0(%rip), %xmm0
	.loc	1 0 8 is_stmt 0
.Ltmp1:
	.p2align	4
.LBB0_1:
	.loc	1 26 8 is_stmt 1
	leaq	(,%rsi,4), %r8
	movss	(%rdi,%rsi,4), %xmm1
	leaq	(%r8,%r8,2), %r8
	xorl	%r9d, %r9d
	.loc	1 0 8 is_stmt 0
.Ltmp2:
	.p2align	4
.LBB0_2:
	.loc	1 20 8 is_stmt 1
	movss	(%rcx,%r9,4), %xmm2
	movss	200704(%rcx,%r9,4), %xmm3
	movss	401408(%rcx,%r9,4), %xmm4
	.loc	1 31 10
	mulss	4(%rdx,%r8), %xmm3
	mulss	(%rdx,%r8), %xmm2
	addss	%xmm1, %xmm2
	addss	%xmm3, %xmm2
	mulss	8(%rdx,%r8), %xmm4
	addss	%xmm2, %xmm4
	xorps	%xmm2, %xmm2
	minss	%xmm4, %xmm2
	mulss	%xmm0, %xmm2
	.loc	1 34 10
	xorps	%xmm3, %xmm3
	maxss	%xmm4, %xmm3
	addss	%xmm2, %xmm3
	.loc	1 20 8
	movss	%xmm3, (%rax,%r9,4)
	incq	%r9
	cmpq	$64, %r9
	jne	.LBB0_2
	incq	%rsi
	addq	$200704, %rax
	cmpq	$32, %rsi
	jne	.LBB0_1
	.loc	1 38 8
	xorl	%eax, %eax
	.loc	1 38 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp3:
.Lfunc_end0:
	.size	infer_dispatch_0_matmul_like_32x50176x3_f32, .Lfunc_end0-infer_dispatch_0_matmul_like_32x50176x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_slow_memcpy,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_1_slow_memcpy,@function
infer_dispatch_1_slow_memcpy:
.Lfunc_begin1:
	.file	2 "dump" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp4:
	.loc	2 11 8 prologue_end
	movq	32(%rsi), %rsi
	.loc	2 13 8
	movq	8(%rsi), %rax
	.loc	2 16 8
	movl	(%rdx), %ecx
	movl	%ecx, %edx
	shrl	$2, %edx
	andl	$3, %ecx
	imulq	$50624, %rdx, %rdi
	imulq	$224, %rcx, %r8
	addq	%r8, %rdi
	addq	%rdi, %rax
	addq	$6423436, %rax
	imulq	$50176, %rdx, %rcx
	orq	%r8, %rcx
	addq	(%rsi), %rcx
	xorl	%edx, %edx
	.loc	2 0 8 is_stmt 0
.Ltmp5:
	.p2align	4
.LBB1_1:
	movq	%rcx, %rsi
	movq	%rax, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB1_2:
	movq	$-4, %r9
	.p2align	4
.LBB1_3:
	.loc	2 16 8 is_stmt 1
	movaps	16(%rsi,%r9,4), %xmm0
	movups	%xmm0, 16(%rdi,%r9,4)
	addq	$4, %r9
	cmpq	$52, %r9
	jb	.LBB1_3
	incq	%r8
	addq	$904, %rdi
	addq	$896, %rsi
	cmpq	$56, %r8
	jne	.LBB1_2
	incq	%rdx
	addq	$204304, %rax
	addq	$200704, %rcx
	cmpq	$32, %rdx
	jne	.LBB1_1
	.loc	2 20 8
	xorl	%eax, %eax
	.loc	2 20 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp6:
.Lfunc_end1:
	.size	infer_dispatch_1_slow_memcpy, .Lfunc_end1-infer_dispatch_1_slow_memcpy
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI2_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_2_conv_64x224x224x32x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_2_conv_64x224x224x32x3x3_f32,@function
infer_dispatch_2_conv_64x224x224x32x3x3_f32:
.Lfunc_begin2:
	.file	3 "dump" "configured_module_infer_dispatch_2.mlir"
	.loc	3 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp7:
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
	.loc	3 15 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rsi
	movl	$12960256, %ecx
	.loc	3 17 8
	addq	16(%rax), %rcx
	movq	%rcx, 72(%rsp)
	.loc	3 16 8
	movq	8(%rax), %r8
	.loc	3 22 8
	movl	(%rdx), %ecx
	imulq	$1402438301, %rcx, %rdi
	shrq	$36, %rdi
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	imull	$49, %edi, %eax
	leal	(,%rdx,8), %r9d
	subl	%r9d, %edx
	addl	%ecx, %edx
	subl	%eax, %ecx
	leal	(%rcx,%rcx,8), %eax
	leal	(%rcx,%rax,4), %eax
	movzbl	%ah, %eax
	leaq	(%rdi,%rdi,8), %rcx
	shll	$5, %edi
	movq	%rdi, 64(%rsp)
	imulq	$28928, %rax, %rdi
	shll	$5, %eax
	movq	%rax, 88(%rsp)
	movl	%edx, %eax
	shll	$5, %eax
	movq	%rax, 120(%rsp)
	.loc	3 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	3 22 8
	shll	$7, %edx
	addq	%rdi, %rdx
	leaq	(%rsi,%rdx), %rax
	addq	$6422528, %rax
	movq	%rax, 56(%rsp)
	shlq	$12, %rcx
	leaq	(%rcx,%r8), %r9
	addq	$4209920, %r9
	xorl	%eax, %eax
	movaps	.LCPI2_0(%rip), %xmm0
	.loc	3 0 8 is_stmt 0
.Ltmp8:
	.p2align	4
.LBB2_1:
	movq	%rax, 80(%rsp)
	.loc	3 22 8
	orq	64(%rsp), %rax
	leaq	__constant_64xf32(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	imulq	$204304, %rax, %rax
	addq	72(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	56(%rsp), %rdx
	xorl	%ecx, %ecx
	.loc	3 0 8
.Ltmp9:
	.p2align	4
.LBB2_2:
	movq	88(%rsp), %rax
	movq	%rcx, 104(%rsp)
	addq	%rcx, %rax
	imulq	$904, %rax, %rax
	movq	96(%rsp), %rcx
	leaq	(%rcx,%rax), %r15
	addq	$908, %r15
	movq	%rdx, 112(%rsp)
	movq	%rdx, %rcx
	xorl	%r13d, %r13d
	.p2align	4
.LBB2_3:
	xorl	%eax, %eax
	.p2align	4
.LBB2_4:
	.loc	3 22 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB2_4
	movq	%r13, %r10
	orq	120(%rsp), %r10
	movq	%r9, %rsi
	movq	%rcx, %rdx
	xorl	%eax, %eax
	.loc	3 0 8 is_stmt 0
.Ltmp10:
	.p2align	4
.LBB2_6:
	movq	%rsi, %r8
	movq	%rdx, %rbx
	xorl	%r11d, %r11d
	.p2align	4
.LBB2_7:
	movq	%rbx, %r12
	xorl	%r14d, %r14d
	.p2align	4
.LBB2_8:
	movss	(%rsp,%r14,4), %xmm2
	xorl	%edi, %edi
	.p2align	4
.LBB2_9:
	.loc	3 22 8 is_stmt 1
	movss	(%r12,%rdi,4), %xmm3
	.loc	3 24 10
	mulss	(%r8,%rdi,4), %xmm3
	.loc	3 25 10
	addss	%xmm3, %xmm2
	.loc	3 22 8
	incq	%rdi
	cmpq	$3, %rdi
	jne	.LBB2_9
	movss	%xmm2, (%rsp,%r14,4)
	incq	%r14
	addq	$4, %r12
	cmpq	$4, %r14
	jne	.LBB2_8
	incq	%r11
	addq	$904, %rbx
	addq	$12, %r8
	cmpq	$3, %r11
	jne	.LBB2_7
	incq	%rax
	addq	$204304, %rdx
	addq	$36, %rsi
	cmpq	$32, %rax
	jne	.LBB2_6
	.loc	3 0 8 is_stmt 0
	movaps	(%rsp), %xmm2
	.loc	3 30 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	3 32 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	3 33 10
	mulps	%xmm0, %xmm3
	.loc	3 35 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	3 36 10
	addps	%xmm3, %xmm4
	.loc	3 22 8
	movups	%xmm4, (%r15,%r10,4)
	addq	$16, %rcx
	cmpq	$28, %r13
	leaq	4(%r13), %r13
	jb	.LBB2_3
	.loc	3 0 8 is_stmt 0
	movq	104(%rsp), %rcx
	.loc	3 22 8
	incq	%rcx
	movq	112(%rsp), %rdx
	addq	$904, %rdx
	cmpq	$32, %rcx
	jne	.LBB2_2
	.loc	3 0 8
	movq	80(%rsp), %rax
	.loc	3 22 8
	incq	%rax
	addq	$1152, %r9
	cmpq	$32, %rax
	jne	.LBB2_1
	.loc	3 40 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	3 40 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp11:
.Lfunc_end2:
	.size	infer_dispatch_2_conv_64x224x224x32x3x3_f32, .Lfunc_end2-infer_dispatch_2_conv_64x224x224x32x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI3_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_3_conv_128x224x224x64x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_3_conv_128x224x224x64x3x3_f32,@function
infer_dispatch_3_conv_128x224x224x64x3x3_f32:
.Lfunc_begin3:
	.file	4 "dump" "configured_module_infer_dispatch_3.mlir"
	.loc	4 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp12:
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
	.loc	4 15 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rsi
	.loc	4 16 8
	movq	8(%rax), %r9
	movl	$26035712, %ecx
	.loc	4 18 8
	addq	16(%rax), %rcx
	movq	%rcx, 64(%rsp)
	.loc	4 24 8
	movl	(%rdx), %ecx
	imulq	$1402438301, %rcx, %rdi
	shrq	$36, %rdi
	imull	$49, %edi, %r8d
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	leal	(,%rdx,8), %eax
	subl	%eax, %edx
	addl	%ecx, %edx
	subl	%r8d, %ecx
	leal	(%rcx,%rcx,8), %eax
	leal	(%rcx,%rax,4), %eax
	movzbl	%ah, %eax
	leaq	(%rdi,%rdi,8), %rcx
	shll	$5, %edi
	movq	%rdi, 56(%rsp)
	imulq	$28928, %rax, %rdi
	shll	$5, %eax
	movq	%rax, 88(%rsp)
	movl	%edx, %eax
	shll	$5, %eax
	movq	%rax, 120(%rsp)
	.loc	4 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	4 24 8
	shll	$7, %edx
	addq	%rdi, %rdx
	leaq	(%rsi,%rdx), %rax
	addq	$12960256, %rax
	movq	%rax, 48(%rsp)
	shlq	$13, %rcx
	movq	%r9, 72(%rsp)
	leaq	(%rcx,%r9), %r10
	addq	$3837312, %r10
	xorl	%eax, %eax
	movaps	.LCPI3_0(%rip), %xmm0
	.loc	4 0 8 is_stmt 0
.Ltmp13:
	.p2align	4
.LBB3_1:
	movq	%rax, 80(%rsp)
	.loc	4 24 8
	orq	56(%rsp), %rax
	movq	72(%rsp), %rcx
	movss	4132224(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	imulq	$200704, %rax, %rax
	addq	64(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	48(%rsp), %rcx
	xorl	%edx, %edx
	.loc	4 0 8
.Ltmp14:
	.p2align	4
.LBB3_2:
	movq	88(%rsp), %rax
	movq	%rdx, 104(%rsp)
	addq	%rdx, %rax
	imulq	$896, %rax, %r15
	addq	96(%rsp), %r15
	movq	%rcx, 112(%rsp)
	xorl	%r13d, %r13d
	.p2align	4
.LBB3_3:
	xorl	%eax, %eax
	.p2align	4
.LBB3_4:
	.loc	4 24 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB3_4
	movq	%r13, %rsi
	orq	120(%rsp), %rsi
	movq	%r10, %rdi
	movq	%rcx, %rdx
	xorl	%eax, %eax
	.loc	4 0 8 is_stmt 0
.Ltmp15:
	.p2align	4
.LBB3_6:
	movq	%rdi, %r9
	movq	%rdx, %rbx
	xorl	%r11d, %r11d
	.p2align	4
.LBB3_7:
	movq	%rbx, %r12
	xorl	%r14d, %r14d
	.p2align	4
.LBB3_8:
	movss	(%rsp,%r14,4), %xmm2
	xorl	%r8d, %r8d
	.p2align	4
.LBB3_9:
	.loc	4 24 8 is_stmt 1
	movss	(%r12,%r8,4), %xmm3
	.loc	4 26 10
	mulss	(%r9,%r8,4), %xmm3
	.loc	4 27 10
	addss	%xmm3, %xmm2
	.loc	4 24 8
	incq	%r8
	cmpq	$3, %r8
	jne	.LBB3_9
	movss	%xmm2, (%rsp,%r14,4)
	incq	%r14
	addq	$4, %r12
	cmpq	$4, %r14
	jne	.LBB3_8
	incq	%r11
	addq	$904, %rbx
	addq	$12, %r9
	cmpq	$3, %r11
	jne	.LBB3_7
	incq	%rax
	addq	$204304, %rdx
	addq	$36, %rdi
	cmpq	$64, %rax
	jne	.LBB3_6
	.loc	4 0 8 is_stmt 0
	movaps	(%rsp), %xmm2
	.loc	4 32 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	4 34 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	4 35 10
	mulps	%xmm0, %xmm3
	.loc	4 37 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	4 38 10
	addps	%xmm3, %xmm4
	.loc	4 24 8
	movaps	%xmm4, (%r15,%rsi,4)
	addq	$16, %rcx
	cmpq	$28, %r13
	leaq	4(%r13), %r13
	jb	.LBB3_3
	.loc	4 0 8 is_stmt 0
	movq	104(%rsp), %rdx
	.loc	4 24 8
	incq	%rdx
	movq	112(%rsp), %rcx
	addq	$904, %rcx
	cmpq	$32, %rdx
	jne	.LBB3_2
	.loc	4 0 8
	movq	80(%rsp), %rax
	.loc	4 24 8
	incq	%rax
	addq	$2304, %r10
	cmpq	$32, %rax
	jne	.LBB3_1
	.loc	4 42 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	4 42 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp16:
.Lfunc_end3:
	.size	infer_dispatch_3_conv_128x224x224x64x3x3_f32, .Lfunc_end3-infer_dispatch_3_conv_128x224x224x64x3x3_f32
	.cfi_endproc

	.section	.text.infer_dispatch_4_slow_memcpy,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_4_slow_memcpy,@function
infer_dispatch_4_slow_memcpy:
.Lfunc_begin4:
	.file	5 "dump" "configured_module_infer_dispatch_4.mlir"
	.loc	5 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp17:
	.loc	5 9 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %rsi
	movl	(%rax), %edi
	.loc	5 10 8
	movl	4(%rax), %eax
	.loc	5 18 8
	andl	$-4, %edi
	.loc	5 19 8
	movq	8(%rsi), %rcx
	.loc	5 20 8
	andl	$-4, %eax
	.loc	5 22 8
	movl	(%rdx), %edx
	movl	%edx, %r8d
	shrl	$2, %r8d
	andl	$3, %r8d
	movl	%edx, %r9d
	andl	$3, %r9d
	shrl	$4, %edx
	imulq	$13075456, %rdx, %r10
	imulq	$50624, %r8, %r11
	imulq	$224, %r9, %r9
	addq	%r9, %r10
	addq	%r11, %r10
	addq	%rax, %r10
	leaq	(%rcx,%r10), %rax
	addq	$908, %rax
	imulq	$12845056, %rdx, %rdx
	imulq	$50176, %r8, %rcx
	orq	%rdx, %rcx
	orq	%r9, %rcx
	addq	%rdi, %rcx
	addq	(%rsi), %rcx
	xorl	%edx, %edx
	.loc	5 0 8 is_stmt 0
.Ltmp18:
	.p2align	4
.LBB4_1:
	movq	%rcx, %rsi
	movq	%rax, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB4_2:
	movq	$-4, %r9
	.p2align	4
.LBB4_3:
	.loc	5 22 8 is_stmt 1
	movaps	16(%rsi,%r9,4), %xmm0
	movups	%xmm0, 16(%rdi,%r9,4)
	addq	$4, %r9
	cmpq	$52, %r9
	jb	.LBB4_3
	incq	%r8
	addq	$904, %rdi
	addq	$896, %rsi
	cmpq	$56, %r8
	jne	.LBB4_2
	incq	%rdx
	addq	$204304, %rax
	addq	$200704, %rcx
	cmpq	$64, %rdx
	jne	.LBB4_1
	.loc	5 26 8
	xorl	%eax, %eax
	.loc	5 26 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp19:
.Lfunc_end4:
	.size	infer_dispatch_4_slow_memcpy, .Lfunc_end4-infer_dispatch_4_slow_memcpy
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI5_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_5_conv_128x224x224x128x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_5_conv_128x224x224x128x3x3_f32,@function
infer_dispatch_5_conv_128x224x224x128x3x3_f32:
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
	.loc	6 11 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %rcx
	movl	(%rax), %ebx
	.loc	6 12 8
	movl	4(%rax), %esi
	.loc	6 13 8
	movl	8(%rax), %edi
	.loc	6 14 8
	movl	12(%rax), %eax
	.loc	6 25 8
	andl	$-4, %ebx
	.loc	6 26 8
	movq	8(%rcx), %r11
	andl	$-4, %esi
	.loc	6 27 8
	andl	$-4, %edi
	addq	%r11, %rdi
	movq	%rdi, 72(%rsp)
	.loc	6 28 8
	andl	$-4, %eax
	addq	16(%rcx), %rax
	movq	%rax, 64(%rsp)
	.loc	6 34 8
	movl	(%rdx), %edi
	imulq	$1402438301, %rdi, %r8
	shrq	$36, %r8
	imull	$49, %r8d, %r9d
	movabsq	$2635249153617166336, %rdx
	movq	%rdi, %rax
	mulq	%rdx
	leal	(,%rdx,8), %eax
	subl	%eax, %edx
	addl	%edi, %edx
	subl	%r9d, %edi
	leal	(%rdi,%rdi,8), %eax
	leal	(%rdi,%rax,4), %eax
	movzbl	%ah, %eax
	leaq	(%r8,%r8,8), %r9
	shll	$5, %r8d
	movq	%r8, 48(%rsp)
	imulq	$28928, %rax, %rdi
	shll	$5, %eax
	movq	%rax, 88(%rsp)
	movl	%edx, %eax
	shll	$5, %eax
	movq	%rax, 120(%rsp)
	.loc	6 10 8
	xorps	%xmm0, %xmm0
	.loc	6 34 8
	shll	$7, %edx
	addq	%rbx, %rdx
	addq	%rdi, %rdx
	addq	(%rcx), %rdx
	movq	%rdx, 56(%rsp)
	.loc	6 10 8
	movaps	%xmm0, 128(%rsp)
	.loc	6 34 8
	shlq	$14, %r9
	addq	%rsi, %r9
	addq	%r11, %r9
	xorl	%eax, %eax
	movaps	.LCPI5_0(%rip), %xmm0
	.loc	6 0 8 is_stmt 0
.Ltmp21:
	.p2align	4
.LBB5_1:
	movq	%rax, 80(%rsp)
	.loc	6 34 8
	orq	48(%rsp), %rax
	movq	72(%rsp), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	imulq	$204304, %rax, %rax
	addq	64(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	56(%rsp), %r8
	xorl	%ecx, %ecx
	.loc	6 0 8
.Ltmp22:
	.p2align	4
.LBB5_2:
	movq	88(%rsp), %rax
	movq	%rcx, 104(%rsp)
	addq	%rcx, %rax
	imulq	$904, %rax, %rax
	movq	96(%rsp), %rcx
	leaq	(%rcx,%rax), %r15
	addq	$908, %r15
	movq	%r8, 112(%rsp)
	xorl	%r13d, %r13d
	.p2align	4
.LBB5_3:
	xorl	%eax, %eax
	.p2align	4
.LBB5_4:
	.loc	6 34 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB5_4
	movq	%r13, %rsi
	orq	120(%rsp), %rsi
	movq	%r9, %rdi
	movq	%r8, %rdx
	xorl	%ecx, %ecx
	.loc	6 0 8 is_stmt 0
.Ltmp23:
	.p2align	4
.LBB5_6:
	movq	%rdi, %rax
	movq	%rdx, %rbx
	xorl	%r11d, %r11d
	.p2align	4
.LBB5_7:
	movq	%rbx, %r12
	xorl	%r14d, %r14d
	.p2align	4
.LBB5_8:
	movss	(%rsp,%r14,4), %xmm2
	xorl	%r10d, %r10d
	.p2align	4
.LBB5_9:
	.loc	6 34 8 is_stmt 1
	movss	(%r12,%r10,4), %xmm3
	.loc	6 36 10
	mulss	(%rax,%r10,4), %xmm3
	.loc	6 37 10
	addss	%xmm3, %xmm2
	.loc	6 34 8
	incq	%r10
	cmpq	$3, %r10
	jne	.LBB5_9
	movss	%xmm2, (%rsp,%r14,4)
	incq	%r14
	addq	$4, %r12
	cmpq	$4, %r14
	jne	.LBB5_8
	incq	%r11
	addq	$904, %rbx
	addq	$12, %rax
	cmpq	$3, %r11
	jne	.LBB5_7
	incq	%rcx
	addq	$204304, %rdx
	addq	$36, %rdi
	cmpq	$128, %rcx
	jne	.LBB5_6
	.loc	6 0 8 is_stmt 0
	movaps	(%rsp), %xmm2
	.loc	6 42 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	6 44 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	6 45 10
	mulps	%xmm0, %xmm3
	.loc	6 47 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	6 48 10
	addps	%xmm3, %xmm4
	.loc	6 34 8
	movups	%xmm4, (%r15,%rsi,4)
	addq	$16, %r8
	cmpq	$28, %r13
	leaq	4(%r13), %r13
	jb	.LBB5_3
	.loc	6 0 8 is_stmt 0
	movq	104(%rsp), %rcx
	.loc	6 34 8
	incq	%rcx
	movq	112(%rsp), %r8
	addq	$904, %r8
	cmpq	$32, %rcx
	jne	.LBB5_2
	.loc	6 0 8
	movq	80(%rsp), %rax
	.loc	6 34 8
	incq	%rax
	addq	$4608, %r9
	cmpq	$32, %rax
	jne	.LBB5_1
	.loc	6 52 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	6 52 8 epilogue_begin is_stmt 0
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
	.size	infer_dispatch_5_conv_128x224x224x128x3x3_f32, .Lfunc_end5-infer_dispatch_5_conv_128x224x224x128x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI6_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_6_conv_128x224x224x128x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_6_conv_128x224x224x128x3x3_f32,@function
infer_dispatch_6_conv_128x224x224x128x3x3_f32:
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
	.loc	7 11 8 prologue_end
	movq	24(%rsi), %rax
	movq	32(%rsi), %rcx
	movl	(%rax), %r15d
	.loc	7 12 8
	movl	4(%rax), %esi
	.loc	7 13 8
	movl	8(%rax), %edi
	.loc	7 14 8
	movl	12(%rax), %r8d
	.loc	7 15 8
	movl	16(%rax), %eax
	.loc	7 28 8
	andl	$-4, %r15d
	movq	(%rcx), %r14
	.loc	7 29 8
	movq	8(%rcx), %r9
	andl	$-4, %edi
	.loc	7 30 8
	andl	$-4, %esi
	addq	%r14, %rsi
	movq	%rsi, 120(%rsp)
	.loc	7 31 8
	andl	$-4, %r8d
	addq	%r9, %r8
	movq	%r8, 56(%rsp)
	.loc	7 32 8
	andl	$-4, %eax
	addq	16(%rcx), %rax
	movq	%rax, 112(%rsp)
	.loc	7 39 8
	movl	(%rdx), %ecx
	imulq	$1402438301, %rcx, %r10
	shrq	$36, %r10
	imull	$49, %r10d, %esi
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	leal	(,%rdx,8), %eax
	subl	%eax, %edx
	addl	%ecx, %edx
	subl	%esi, %ecx
	leal	(%rcx,%rcx,8), %eax
	leal	(%rcx,%rax,4), %eax
	movzbl	%ah, %eax
	leaq	(%r10,%r10,8), %rsi
	shll	$5, %r10d
	movq	%r10, 40(%rsp)
	imulq	$28928, %rax, %rcx
	shll	$5, %eax
	movq	%rax, 72(%rsp)
	movl	%edx, %eax
	shll	$5, %eax
	movq	%rax, 104(%rsp)
	.loc	7 10 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	7 39 8
	shll	$7, %edx
	addq	%r15, %rdx
	addq	%r14, %rdx
	addq	%rcx, %rdx
	movq	%rdx, 48(%rsp)
	shlq	$14, %rsi
	addq	%rdi, %rsi
	addq	%r9, %rsi
	movq	%rsi, %r10
	xorl	%eax, %eax
	movaps	.LCPI6_0(%rip), %xmm0
	.loc	7 0 8 is_stmt 0
.Ltmp26:
	.p2align	4
.LBB6_1:
	movq	%rax, 64(%rsp)
	.loc	7 39 8
	orq	40(%rsp), %rax
	imulq	$50176, %rax, %rcx
	movq	%rcx, 80(%rsp)
	movq	56(%rsp), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	movq	48(%rsp), %rsi
	xorl	%ecx, %ecx
	.loc	7 0 8
.Ltmp27:
	.p2align	4
.LBB6_2:
	movq	72(%rsp), %rax
	movq	%rcx, 88(%rsp)
	addq	%rcx, %rax
	imulq	$224, %rax, %r12
	addq	80(%rsp), %r12
	movq	%rsi, 96(%rsp)
	xorl	%ecx, %ecx
	.p2align	4
.LBB6_3:
	xorl	%eax, %eax
	.p2align	4
.LBB6_4:
	.loc	7 39 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB6_4
	movq	%rcx, %rdi
	orq	104(%rsp), %rdi
	movq	%r10, %r11
	movq	%rsi, %rdx
	xorl	%r9d, %r9d
	.loc	7 0 8 is_stmt 0
.Ltmp28:
	.p2align	4
.LBB6_6:
	movq	%r11, %rax
	movq	%rdx, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB6_7:
	movq	%r14, %r13
	xorl	%r8d, %r8d
	.p2align	4
.LBB6_8:
	movss	(%rsp,%r8,4), %xmm2
	xorl	%ebx, %ebx
	.p2align	4
.LBB6_9:
	.loc	7 39 8 is_stmt 1
	movss	(%r13,%rbx,4), %xmm3
	.loc	7 41 10
	mulss	(%rax,%rbx,4), %xmm3
	.loc	7 42 10
	addss	%xmm3, %xmm2
	.loc	7 39 8
	incq	%rbx
	cmpq	$3, %rbx
	jne	.LBB6_9
	movss	%xmm2, (%rsp,%r8,4)
	incq	%r8
	addq	$4, %r13
	cmpq	$4, %r8
	jne	.LBB6_8
	incq	%r15
	addq	$904, %r14
	addq	$12, %rax
	cmpq	$3, %r15
	jne	.LBB6_7
	incq	%r9
	addq	$204304, %rdx
	addq	$36, %r11
	cmpq	$128, %r9
	jne	.LBB6_6
	.loc	7 45 8
	addq	%r12, %rdi
	movaps	(%rsp), %xmm2
	.loc	7 47 10
	addps	%xmm1, %xmm2
	.loc	7 49 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	7 50 10
	mulps	%xmm0, %xmm3
	.loc	7 52 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	7 53 10
	addps	%xmm3, %xmm4
	movq	120(%rsp), %rax
	.loc	7 54 10
	addps	(%rax,%rdi,4), %xmm4
	movq	112(%rsp), %rax
	.loc	7 39 8
	movaps	%xmm4, (%rax,%rdi,4)
	addq	$16, %rsi
	cmpq	$28, %rcx
	leaq	4(%rcx), %rcx
	jb	.LBB6_3
	.loc	7 0 8 is_stmt 0
	movq	88(%rsp), %rcx
	.loc	7 39 8
	incq	%rcx
	movq	96(%rsp), %rsi
	addq	$904, %rsi
	cmpq	$32, %rcx
	jne	.LBB6_2
	.loc	7 0 8
	movq	64(%rsp), %rax
	.loc	7 39 8
	incq	%rax
	addq	$4608, %r10
	cmpq	$32, %rax
	jne	.LBB6_1
	.loc	7 58 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	7 58 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp29:
.Lfunc_end6:
	.size	infer_dispatch_6_conv_128x224x224x128x3x3_f32, .Lfunc_end6-infer_dispatch_6_conv_128x224x224x128x3x3_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI7_0:
	.long	0x3f000000
.LCPI7_1:
	.long	0xbf000000
.LCPI7_2:
	.long	0x435f0000
.LCPI7_3:
	.long	0x3f800000
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI7_4:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
.LCPI7_5:
	.quad	2
	.quad	3
.LCPI7_6:
	.long	0x3f000000
	.long	0x3f000000
	.long	0x3f000000
	.long	0x3f000000
.LCPI7_7:
	.long	0xbf000000
	.long	0xbf000000
	.long	0xbf000000
	.long	0xbf000000
.LCPI7_8:
	.long	0x435f0000
	.long	0x435f0000
	.long	0x435f0000
	.long	0x435f0000
.LCPI7_9:
	.long	0x3f800000
	.long	0x3f800000
	.long	0x3f800000
	.long	0x3f800000
	.section	.text.infer_dispatch_13_elementwise_broadcast_128x112x112_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_13_elementwise_broadcast_128x112x112_f32,@function
infer_dispatch_13_elementwise_broadcast_128x112x112_f32:
.Lfunc_begin7:
	.file	8 "dump" "configured_module_infer_dispatch_13.mlir"
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
	subq	$344, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	8 15 8 prologue_end
	movq	32(%rsi), %rax
	movl	$58263552, %ebx
	addq	(%rax), %rbx
	.loc	8 16 8
	movq	8(%rax), %rax
	.loc	8 19 8
	movl	(%rdx), %ecx
	leaq	(,%rcx,8), %rdx
	andq	$-32, %rdx
	movq	%rdx, -216(%rbp)
	movq	%rcx, %rdx
	shlq	$62, %rdx
	sarq	$63, %rdx
	andl	$56, %edx
	xorl	%edi, %edi
	testb	$1, %cl
	movl	$56, %r8d
	cmoveq	%rdi, %r8
	shrl	$2, %ecx
	imulq	$1663488, %rcx, %rcx
	movq	%rdx, -248(%rbp)
	imulq	$456, %rdx, %rdx
	addq	%rcx, %rdx
	movq	%r8, -240(%rbp)
	leaq	(%rdx,%r8,4), %rcx
	addq	%rax, %rcx
	addq	$83954124, %rcx
	movabsq	$6023426636313322977, %r14
	movabsq	$5270498306774157605, %r12
	.loc	8 0 8 is_stmt 0
.Ltmp31:
	.p2align	4
.LBB7_1:
	movq	%rdi, -232(%rbp)
	.loc	8 21 10 is_stmt 1
	movq	%rdi, %rax
	orq	-216(%rbp), %rax
	.loc	8 54 10
	imulq	$224, %rax, %rax
	movq	%rax, -256(%rbp)
	movq	%rcx, -224(%rbp)
	movq	%rcx, %r15
	xorl	%ecx, %ecx
	.loc	8 0 10 is_stmt 0
.Ltmp32:
	.p2align	4
.LBB7_2:
	movq	-248(%rbp), %rax
	movq	%rcx, -264(%rbp)
	.loc	8 22 10 is_stmt 1
	addq	%rcx, %rax
	.loc	8 25 10
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	.loc	8 26 10
	addss	.LCPI7_0(%rip), %xmm0
	.loc	8 27 10
	addss	%xmm0, %xmm0
	.loc	8 28 10
	addss	.LCPI7_1(%rip), %xmm0
	.loc	8 29 10
	movaps	%xmm0, %xmm1
	xorps	%xmm2, %xmm2
	cmpless	%xmm2, %xmm1
	andnps	%xmm0, %xmm1
	movss	.LCPI7_2(%rip), %xmm0
	.loc	8 30 10
	minss	%xmm1, %xmm0
	movaps	%xmm0, -144(%rbp)
	.loc	8 38 10
	callq	floorf@PLT
	movss	%xmm0, -80(%rbp)
	movaps	-144(%rbp), %xmm0
	.loc	8 39 10
	addss	.LCPI7_3(%rip), %xmm0
	movss	%xmm0, -64(%rbp)
	.loc	8 40 10
	callq	floorf@PLT
	movaps	.LCPI7_8(%rip), %xmm14
	movss	-80(%rbp), %xmm3
	.loc	8 41 10
	cvttss2si	%xmm3, %rax
	.loc	8 43 10
	movss	.LCPI7_2(%rip), %xmm1
	minss	-64(%rbp), %xmm1
	.loc	8 44 10
	cvttss2si	%xmm1, %rcx
	movq	-256(%rbp), %rdx
	.loc	8 54 10
	addq	%rdx, %rax
	imulq	$224, %rax, %rax
	.loc	8 56 10
	addq	%rdx, %rcx
	imulq	$224, %rcx, %rcx
	movaps	-144(%rbp), %xmm2
	.loc	8 58 10
	subss	%xmm2, %xmm0
	.loc	8 59 10
	subss	%xmm3, %xmm2
	movq	%rax, %xmm1
	pshufd	$68, %xmm1, %xmm1
	movdqa	%xmm1, -352(%rbp)
	movq	%rcx, %xmm1
	pshufd	$68, %xmm1, %xmm1
	movdqa	%xmm1, -336(%rbp)
	shufps	$0, %xmm0, %xmm0
	movaps	%xmm0, -368(%rbp)
	shufps	$0, %xmm2, %xmm2
	movaps	%xmm2, -144(%rbp)
	movq	$-4, %rax
	movq	-240(%rbp), %rcx
	movq	%r15, -272(%rbp)
	.loc	8 0 10 is_stmt 0
.Ltmp33:
	.p2align	4
.LBB7_3:
	movq	%rcx, -312(%rbp)
	movq	%rax, -320(%rbp)
	.loc	8 19 8 is_stmt 1
	movq	%rcx, %xmm0
	pshufd	$68, %xmm0, %xmm0
	.loc	8 23 10
	movdqa	%xmm0, %xmm1
	por	.LCPI7_5(%rip), %xmm0
	.loc	8 32 10
	movq	%xmm0, %rax
	xorps	%xmm2, %xmm2
	cvtsi2ss	%rax, %xmm2
	pshufd	$238, %xmm0, %xmm0
	movq	%xmm0, %rax
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	.loc	8 23 10
	por	.LCPI7_4(%rip), %xmm1
	.loc	8 32 10
	unpcklps	%xmm0, %xmm2
	movq	%xmm1, %rax
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	pshufd	$238, %xmm1, %xmm1
	movq	%xmm1, %rax
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	unpcklps	%xmm1, %xmm0
	movlhps	%xmm2, %xmm0
	.loc	8 33 10
	addps	.LCPI7_6(%rip), %xmm0
	.loc	8 34 10
	addps	%xmm0, %xmm0
	.loc	8 35 10
	addps	.LCPI7_7(%rip), %xmm0
	.loc	8 36 10
	movaps	%xmm0, %xmm1
	xorps	%xmm2, %xmm2
	cmpnleps	%xmm2, %xmm1
	andps	%xmm0, %xmm1
	.loc	8 37 10
	movaps	%xmm14, %xmm0
	minps	%xmm1, %xmm0
	movaps	%xmm0, -80(%rbp)
	.loc	8 46 10
	shufps	$255, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -176(%rbp)
	movaps	-80(%rbp), %xmm0
	movhlps	%xmm0, %xmm0
	callq	floorf@PLT
	unpcklps	-176(%rbp), %xmm0
	movaps	%xmm0, -160(%rbp)
	movaps	-80(%rbp), %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -208(%rbp)
	movaps	-80(%rbp), %xmm0
	shufps	$85, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -128(%rbp)
	movaps	-208(%rbp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	-160(%rbp), %xmm1
	movaps	%xmm1, -208(%rbp)
	movaps	-80(%rbp), %xmm0
	.loc	8 47 10
	addps	.LCPI7_9(%rip), %xmm0
	movaps	%xmm0, -64(%rbp)
	.loc	8 48 10
	shufps	$255, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -192(%rbp)
	movaps	-64(%rbp), %xmm0
	movhlps	%xmm0, %xmm0
	callq	floorf@PLT
	unpcklps	-192(%rbp), %xmm0
	movaps	%xmm0, -192(%rbp)
	movaps	-64(%rbp), %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -384(%rbp)
	movaps	-64(%rbp), %xmm0
	shufps	$85, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	.LCPI7_8(%rip), %xmm14
	movaps	-208(%rbp), %xmm15
	.loc	8 49 10
	cvttss2si	%xmm15, %rax
	movq	%rax, %xmm1
	cvttss2si	-128(%rbp), %rax
	movq	%rax, %xmm2
	punpcklqdq	%xmm2, %xmm1
	movdqa	-352(%rbp), %xmm7
	.loc	8 54 10
	movdqa	%xmm7, %xmm2
	paddq	%xmm1, %xmm2
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	224(%rsi,%rax), %r15
	cmovnsq	%rdx, %r15
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rdi
	movq	%rdx, %r8
	shrq	$6, %rdi
	shrq	$63, %r8
	imulq	$200704, %rcx, %r9
	pshufd	$238, %xmm2, %xmm2
	movq	%xmm2, %rsi
	addq	%rbx, %r9
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	addq	%r8, %rdi
	movq	%rdx, %rax
	shrq	$63, %rax
	imulq	$896, %rdi, %rdx
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	addq	%r9, %rdx
	movq	%rdx, -112(%rbp)
	movq	%rsi, %rdx
	subq	%rax, %rdx
	.loc	8 49 10
	cvttss2si	-160(%rbp), %r8
	.loc	8 54 10
	setne	%al
	testq	%rsi, %rsi
	.loc	8 49 10
	cvttss2si	-176(%rbp), %r9
	.loc	8 54 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	.loc	8 49 10
	movq	%r8, %xmm2
	.loc	8 54 10
	movq	%rdx, %rax
	.loc	8 49 10
	movq	%r9, %xmm3
	.loc	8 54 10
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	.loc	8 49 10
	punpcklqdq	%xmm3, %xmm2
	.loc	8 54 10
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	224(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -128(%rbp)
	movdqa	%xmm7, %xmm4
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rdi
	paddq	%xmm2, %xmm4
	movq	%rdx, %r8
	shrq	$63, %r8
	shrq	$6, %rdi
	imulq	$200704, %rcx, %r9
	movq	%xmm4, %rsi
	addq	%rbx, %r9
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	addq	%r8, %rdi
	movq	%rdx, %rax
	shrq	$63, %rax
	imulq	$896, %rdi, %rdx
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	addq	%r9, %rdx
	movq	%rdx, -96(%rbp)
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	.loc	8 51 10
	movaps	%xmm14, %xmm3
	minps	-64(%rbp), %xmm3
	.loc	8 54 10
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	.loc	8 52 10
	cvttss2si	%xmm3, %r9
	.loc	8 54 10
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	224(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -104(%rbp)
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rdi
	.loc	8 52 10
	movaps	%xmm3, %xmm5
	.loc	8 54 10
	movq	%rdx, %r10
	shrq	$6, %rdi
	imulq	$200704, %rcx, %r11
	pshufd	$238, %xmm4, %xmm4
	movq	%xmm4, %rsi
	shrq	$63, %r10
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	addq	%r10, %rdi
	addq	%rbx, %r11
	movq	%rdx, %rax
	imulq	$896, %rdi, %r10
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	addq	%r11, %r10
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	.loc	8 52 10
	shufps	$85, %xmm3, %xmm5
	.loc	8 54 10
	setne	%al
	testq	%rsi, %rsi
	.loc	8 52 10
	cvttss2si	%xmm5, %r11
	.loc	8 54 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	.loc	8 52 10
	movq	%r9, %xmm4
	movaps	%xmm3, %xmm5
	.loc	8 54 10
	movq	%rdx, %rax
	.loc	8 52 10
	movq	%r11, %xmm6
	.loc	8 54 10
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	.loc	8 52 10
	punpcklqdq	%xmm6, %xmm4
	.loc	8 54 10
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	224(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -88(%rbp)
	.loc	8 52 10
	movhlps	%xmm3, %xmm3
	.loc	8 54 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rdi
	movq	%rdx, %r9
	imulq	$200704, %rcx, %r11
	shrq	$6, %rdi
	.loc	8 55 10
	movdqa	%xmm7, %xmm6
	paddq	%xmm4, %xmm6
	movq	%xmm6, %rsi
	.loc	8 54 10
	shrq	$63, %r9
	.loc	8 55 10
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	.loc	8 54 10
	addq	%r9, %rdi
	addq	%rbx, %r11
	.loc	8 55 10
	movq	%rdx, %rax
	.loc	8 54 10
	imulq	$896, %rdi, %r13
	.loc	8 55 10
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	.loc	8 54 10
	addq	%r11, %r13
	.loc	8 55 10
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	.loc	8 52 10
	cvttss2si	%xmm3, %rdi
	.loc	8 55 10
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	.loc	8 52 10
	movq	%rdi, %xmm3
	.loc	8 55 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	.loc	8 52 10
	shufps	$255, %xmm5, %xmm5
	.loc	8 55 10
	addq	%rax, %rdx
	.loc	8 52 10
	cvttss2si	%xmm5, %rax
	movq	%rax, %xmm5
	.loc	8 55 10
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	224(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -64(%rbp)
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rdi
	movq	%rdx, %rax
	shrq	$6, %rdi
	imulq	$200704, %rcx, %r9
	shrq	$63, %rax
	addq	%rbx, %r9
	pshufd	$238, %xmm6, %xmm6
	movq	%xmm6, %rsi
	addq	%rax, %rdi
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	imulq	$896, %rdi, %rax
	addq	%r9, %rax
	movq	%rax, -160(%rbp)
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -176(%rbp)
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	shrq	$6, %rdx
	addq	%rax, %rdx
	.loc	8 52 10
	punpcklqdq	%xmm5, %xmm3
	.loc	8 55 10
	movdqa	%xmm7, %xmm5
	paddq	%xmm3, %xmm5
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -304(%rbp)
	movq	%xmm5, %rdi
	movq	%rdi, %rax
	imulq	%r14
	movq	%r14, %r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rdi, %rdi
	sets	%sil
	andb	%al, %sil
	movzbl	%sil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rsi
	cmovnsq	%rdx, %rsi
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rdi,%rax), %r11
	addq	$224, %r11
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r11
	movq	-112(%rbp), %rax
	.loc	8 62 10
	movss	(%rax,%r15,4), %xmm6
	.loc	8 55 10
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %r8
	addq	%rax, %r8
	pshufd	$238, %xmm5, %xmm5
	movq	%xmm5, %rsi
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r15
	addq	$224, %r15
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r15
	movq	-128(%rbp), %rax
	movq	-96(%rbp), %rdx
	.loc	8 62 10
	movss	(%rdx,%rax,4), %xmm5
	.loc	8 55 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %r14
	addq	%rax, %r14
	movdqa	-336(%rbp), %xmm10
	.loc	8 56 10
	paddq	%xmm10, %xmm1
	movq	%xmm1, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -128(%rbp)
	movq	-104(%rbp), %rax
	.loc	8 62 10
	movss	(%r10,%rax,4), %xmm7
	.loc	8 56 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -112(%rbp)
	pshufd	$238, %xmm1, %xmm1
	movq	%xmm1, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -104(%rbp)
	movq	-88(%rbp), %rax
	.loc	8 62 10
	movss	(%r13,%rax,4), %xmm1
	.loc	8 56 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	paddq	%xmm10, %xmm2
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -96(%rbp)
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -88(%rbp)
	.loc	8 63 10
	movss	(%r8,%r11,4), %xmm8
	.loc	8 56 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -296(%rbp)
	pshufd	$238, %xmm2, %xmm2
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -288(%rbp)
	.loc	8 63 10
	movss	(%r14,%r15,4), %xmm14
	.loc	8 56 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %r15
	addq	%rax, %r15
	.loc	8 57 10
	paddq	%xmm10, %xmm4
	movq	%xmm4, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$224, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -280(%rbp)
	movq	-64(%rbp), %rax
	movq	-160(%rbp), %rdx
	.loc	8 63 10
	movss	(%rdx,%rax,4), %xmm9
	.loc	8 57 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %r11
	addq	%rax, %r11
	pshufd	$238, %xmm4, %xmm4
	movq	%xmm4, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r10
	addq	$224, %r10
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r10
	movq	-176(%rbp), %rax
	movq	-304(%rbp), %rdx
	.loc	8 63 10
	movss	(%rdx,%rax,4), %xmm4
	.loc	8 57 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$6, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	paddq	%xmm10, %xmm3
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %r13
	addq	%rax, %r13
	movq	%xmm3, %rsi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rcx
	addq	%rax, %rcx
	imulq	$50176, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	50176(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r14
	addq	$224, %r14
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r14
	movq	-128(%rbp), %rax
	movq	-112(%rbp), %rdx
	.loc	8 66 10
	movss	(%rdx,%rax,4), %xmm10
	.loc	8 57 10
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %r8
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rdx
	.loc	8 66 10
	movss	(%rdx,%rax,4), %xmm11
	.loc	8 57 10
	movq	%r8, %rax
	shrq	$63, %rax
	shrq	$6, %r8
	pshufd	$238, %xmm3, %xmm3
	movq	%xmm3, %rdi
	addq	%rax, %r8
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rsi
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$14, %rsi
	addq	%rax, %rsi
	imulq	$200704, %rcx, %rax
	addq	%rbx, %rax
	imulq	$896, %r8, %r8
	addq	%rax, %r8
	movq	-88(%rbp), %rax
	movq	-296(%rbp), %rcx
	.loc	8 66 10
	movss	(%rcx,%rax,4), %xmm3
	.loc	8 57 10
	imulq	$50176, %rsi, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rdi, %rdi
	sets	%cl
	andb	%al, %cl
	movzbl	%cl, %eax
	subq	%rax, %rsi
	movaps	-384(%rbp), %xmm12
	.loc	8 48 10
	unpcklps	%xmm0, %xmm12
	.loc	8 57 10
	testq	%rdx, %rdx
	movq	-288(%rbp), %rax
	.loc	8 66 10
	movss	(%r15,%rax,4), %xmm2
	movq	-272(%rbp), %r15
	.loc	8 57 10
	leaq	50176(%rdx), %rcx
	cmovnsq	%rdx, %rcx
	movq	%rdi, %rax
	imulq	%r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$6, %rdx
	addq	%rax, %rdx
	imulq	$224, %rdx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rax, %rdi
	addq	$224, %rdi
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rdi
	movq	%rcx, %rax
	imulq	%r12
	.loc	8 48 10
	unpcklpd	-192(%rbp), %xmm12
	movaps	%xmm12, %xmm0
	.loc	8 67 10
	movss	(%r8,%r14,4), %xmm12
	movq	%r9, %r14
	.loc	8 57 10
	movq	%rdx, %rax
	shrq	$63, %rax
	shrq	$6, %rdx
	addq	%rax, %rdx
	imulq	$200704, %rsi, %rax
	addq	%rbx, %rax
	imulq	$896, %rdx, %rcx
	addq	%rax, %rcx
	movq	-320(%rbp), %rax
	movaps	-80(%rbp), %xmm13
	.loc	8 60 10
	subps	%xmm13, %xmm0
	.loc	8 61 10
	subps	%xmm15, %xmm13
	movaps	%xmm13, %xmm15
	.loc	8 67 10
	movss	(%rcx,%rdi,4), %xmm13
	movq	-312(%rbp), %rcx
	.loc	8 62 10
	unpcklps	%xmm5, %xmm6
	movq	-280(%rbp), %rdx
	.loc	8 67 10
	movss	(%r11,%rdx,4), %xmm5
	.loc	8 62 10
	unpcklps	%xmm1, %xmm7
	.loc	8 67 10
	movss	(%r13,%r10,4), %xmm1
	.loc	8 62 10
	movlhps	%xmm7, %xmm6
	.loc	8 63 10
	unpcklps	%xmm4, %xmm9
	unpcklps	%xmm14, %xmm8
	movaps	.LCPI7_8(%rip), %xmm14
	movlhps	%xmm8, %xmm9
	.loc	8 62 10
	mulps	%xmm0, %xmm6
	.loc	8 63 10
	mulps	%xmm15, %xmm9
	.loc	8 64 10
	addps	%xmm6, %xmm9
	.loc	8 66 10
	unpcklps	%xmm11, %xmm10
	unpcklps	%xmm2, %xmm3
	.loc	8 65 10
	mulps	-368(%rbp), %xmm9
	.loc	8 66 10
	movlhps	%xmm3, %xmm10
	.loc	8 67 10
	unpcklps	%xmm13, %xmm12
	unpcklps	%xmm1, %xmm5
	movlhps	%xmm12, %xmm5
	.loc	8 66 10
	mulps	%xmm0, %xmm10
	.loc	8 67 10
	mulps	%xmm15, %xmm5
	.loc	8 68 10
	addps	%xmm10, %xmm5
	.loc	8 69 10
	mulps	-144(%rbp), %xmm5
	.loc	8 70 10
	addps	%xmm9, %xmm5
	.loc	8 19 8
	movups	%xmm5, 16(%r15,%rax,4)
	addq	$4, %rcx
	addq	$4, %rax
	cmpq	$52, %rax
	jb	.LBB7_3
	.loc	8 0 8 is_stmt 0
	movq	-264(%rbp), %rcx
	.loc	8 19 8
	incq	%rcx
	addq	$456, %r15
	cmpq	$56, %rcx
	jne	.LBB7_2
	.loc	8 0 8
	movq	-232(%rbp), %rdi
	.loc	8 19 8
	incq	%rdi
	movq	-224(%rbp), %rcx
	addq	$51984, %rcx
	cmpq	$32, %rdi
	jne	.LBB7_1
	.loc	8 74 8 is_stmt 1
	xorl	%eax, %eax
	.loc	8 74 8 epilogue_begin is_stmt 0
	addq	$344, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp34:
.Lfunc_end7:
	.size	infer_dispatch_13_elementwise_broadcast_128x112x112_f32, .Lfunc_end7-infer_dispatch_13_elementwise_broadcast_128x112x112_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI8_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_14_conv_64x112x112x128x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_14_conv_64x112x112x128x3x3_f32,@function
infer_dispatch_14_conv_64x112x112x128x3x3_f32:
.Lfunc_begin8:
	.file	9 "dump" "configured_module_infer_dispatch_14.mlir"
	.loc	9 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp35:
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
	movl	$6422528, %edi
	.loc	9 17 8
	addq	16(%rsi), %rdi
	movq	%rdi, 72(%rsp)
	.loc	9 22 8
	movl	(%rdx), %edx
	movl	%edx, %esi
	shrl	$2, %esi
	andl	$3, %esi
	movl	%edx, %edi
	andl	$3, %edi
	movq	%rdx, %r8
	addq	%rdx, %r8
	andq	$-32, %r8
	movq	%r8, 64(%rsp)
	leaq	(%rsi,%rsi,8), %r8
	leaq	(%r8,%r8,2), %r8
	addq	%rsi, %r8
	movq	%r8, 88(%rsp)
	leaq	(%rdi,%rdi,8), %r8
	leaq	(%r8,%r8,2), %r8
	addq	%rdi, %r8
	movq	%r8, 120(%rsp)
	.loc	9 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	.loc	9 22 8
	imulq	$12768, %rsi, %rsi
	imulq	$112, %rdi, %rdi
	addq	%rsi, %rdi
	addq	%rdi, %rcx
	addq	$83953664, %rcx
	movq	%rcx, 56(%rsp)
	shrl	$4, %edx
	leaq	(%rdx,%rdx,8), %rcx
	shlq	$14, %rcx
	leaq	(%rcx,%rax), %r9
	addq	$384, %r9
	xorl	%eax, %eax
	movaps	.LCPI8_0(%rip), %xmm0
	.loc	9 0 8 is_stmt 0
.Ltmp36:
	.p2align	4
.LBB8_1:
	movq	%rax, 80(%rsp)
	.loc	9 22 8
	orq	64(%rsp), %rax
	leaq	__constant_64xf32_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	imulq	$50176, %rax, %rax
	addq	72(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	56(%rsp), %rdx
	xorl	%ecx, %ecx
	.loc	9 0 8
.Ltmp37:
	.p2align	4
.LBB8_2:
	movq	88(%rsp), %rax
	movq	%rcx, 104(%rsp)
	addq	%rcx, %rax
	imulq	$448, %rax, %r15
	addq	96(%rsp), %r15
	movq	%rdx, 112(%rsp)
	xorl	%r13d, %r13d
	.p2align	4
.LBB8_3:
	xorl	%eax, %eax
	.p2align	4
.LBB8_4:
	.loc	9 22 8 is_stmt 1
	movss	128(%rsp,%rax,4), %xmm2
	movss	%xmm2, (%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB8_4
	.loc	9 0 8 is_stmt 0
	movq	120(%rsp), %rax
	.loc	9 22 8
	leaq	(%rax,%r13), %r10
	movq	%r9, %rax
	movq	%rdx, %rdi
	xorl	%ecx, %ecx
	.loc	9 0 8
.Ltmp38:
	.p2align	4
.LBB8_6:
	movq	%rax, %r8
	movq	%rdi, %rbx
	xorl	%r11d, %r11d
	.p2align	4
.LBB8_7:
	movq	%rbx, %r12
	xorl	%r14d, %r14d
	.p2align	4
.LBB8_8:
	movss	(%rsp,%r14,4), %xmm2
	xorl	%esi, %esi
	.p2align	4
.LBB8_9:
	.loc	9 22 8 is_stmt 1
	movss	(%r12,%rsi,4), %xmm3
	.loc	9 24 10
	mulss	(%r8,%rsi,4), %xmm3
	.loc	9 25 10
	addss	%xmm3, %xmm2
	.loc	9 22 8
	incq	%rsi
	cmpq	$3, %rsi
	jne	.LBB8_9
	movss	%xmm2, (%rsp,%r14,4)
	incq	%r14
	addq	$4, %r12
	cmpq	$4, %r14
	jne	.LBB8_8
	incq	%r11
	addq	$456, %rbx
	addq	$12, %r8
	cmpq	$3, %r11
	jne	.LBB8_7
	incq	%rcx
	addq	$51984, %rdi
	addq	$36, %rax
	cmpq	$128, %rcx
	jne	.LBB8_6
	.loc	9 0 8 is_stmt 0
	movaps	(%rsp), %xmm2
	.loc	9 30 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	9 32 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	9 33 10
	mulps	%xmm0, %xmm3
	.loc	9 35 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	9 36 10
	addps	%xmm3, %xmm4
	.loc	9 22 8
	movaps	%xmm4, (%r15,%r10,4)
	addq	$16, %rdx
	cmpq	$24, %r13
	leaq	4(%r13), %r13
	jb	.LBB8_3
	.loc	9 0 8 is_stmt 0
	movq	104(%rsp), %rcx
	.loc	9 22 8
	incq	%rcx
	movq	112(%rsp), %rdx
	addq	$456, %rdx
	cmpq	$28, %rcx
	jne	.LBB8_2
	.loc	9 0 8
	movq	80(%rsp), %rax
	.loc	9 22 8
	incq	%rax
	addq	$4608, %r9
	cmpq	$32, %rax
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
.Ltmp39:
.Lfunc_end8:
	.size	infer_dispatch_14_conv_64x112x112x128x3x3_f32, .Lfunc_end8-infer_dispatch_14_conv_64x112x112x128x3x3_f32
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI9_0:
	.long	0x3f000000
.LCPI9_1:
	.long	0xbf000000
.LCPI9_2:
	.long	0x42de0000
.LCPI9_3:
	.long	0x3f800000
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI9_4:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
.LCPI9_5:
	.quad	2
	.quad	3
.LCPI9_6:
	.long	0x3f000000
	.long	0x3f000000
	.long	0x3f000000
	.long	0x3f000000
.LCPI9_7:
	.long	0xbf000000
	.long	0xbf000000
	.long	0xbf000000
	.long	0xbf000000
.LCPI9_8:
	.long	0x42de0000
	.long	0x42de0000
	.long	0x42de0000
	.long	0x42de0000
.LCPI9_9:
	.long	0x3f800000
	.long	0x3f800000
	.long	0x3f800000
	.long	0x3f800000
	.section	.text.infer_dispatch_15_elementwise_broadcast_64x224x224_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_15_elementwise_broadcast_64x224x224_f32,@function
infer_dispatch_15_elementwise_broadcast_64x224x224_f32:
.Lfunc_begin9:
	.file	10 "dump" "configured_module_infer_dispatch_15.mlir"
	.loc	10 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp40:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$328, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	10 16 8 prologue_end
	movq	32(%rsi), %rax
	movl	$6422528, %ebx
	addq	(%rax), %rbx
	.loc	10 17 8
	movq	8(%rax), %rax
	.loc	10 20 8
	movl	(%rdx), %ecx
	movl	%ecx, %edx
	shrl	$2, %edx
	andl	$3, %ecx
	imulq	$56, %rdx, %rsi
	movq	%rsi, -224(%rbp)
	imulq	$56, %rcx, %rcx
	movq	%rcx, -216(%rbp)
	imulq	$50624, %rdx, %rcx
	addq	%rcx, %rax
	addq	$9634700, %rax
	xorl	%ecx, %ecx
	movabsq	$6023426636313322977, %r14
	movabsq	$5270498306774157605, %r15
	.loc	10 0 8 is_stmt 0
.Ltmp41:
	.p2align	4
.LBB9_1:
	movq	%rcx, -200(%rbp)
	.loc	10 55 10 is_stmt 1
	imulq	$112, %rcx, %rcx
	movq	%rcx, -232(%rbp)
	movq	%rax, -208(%rbp)
	movq	%rax, %r12
	xorl	%ecx, %ecx
	.loc	10 0 10 is_stmt 0
.Ltmp42:
	.p2align	4
.LBB9_2:
	movq	-224(%rbp), %rax
	movq	%rcx, -240(%rbp)
	.loc	10 23 10 is_stmt 1
	addq	%rcx, %rax
	.loc	10 26 10
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	movss	.LCPI9_0(%rip), %xmm1
	.loc	10 27 10
	addss	%xmm1, %xmm0
	.loc	10 28 10
	mulss	%xmm1, %xmm0
	.loc	10 29 10
	addss	.LCPI9_1(%rip), %xmm0
	.loc	10 30 10
	movaps	%xmm0, %xmm1
	xorps	%xmm2, %xmm2
	cmpless	%xmm2, %xmm1
	andnps	%xmm0, %xmm1
	movss	.LCPI9_2(%rip), %xmm0
	.loc	10 31 10
	minss	%xmm1, %xmm0
	movaps	%xmm0, -128(%rbp)
	.loc	10 39 10
	callq	floorf@PLT
	movss	%xmm0, -80(%rbp)
	movaps	-128(%rbp), %xmm0
	.loc	10 40 10
	addss	.LCPI9_3(%rip), %xmm0
	movss	%xmm0, -64(%rbp)
	.loc	10 41 10
	callq	floorf@PLT
	movaps	.LCPI9_8(%rip), %xmm14
	movss	-80(%rbp), %xmm3
	.loc	10 42 10
	cvttss2si	%xmm3, %rax
	.loc	10 44 10
	movss	.LCPI9_2(%rip), %xmm1
	minss	-64(%rbp), %xmm1
	.loc	10 45 10
	cvttss2si	%xmm1, %rcx
	movq	-232(%rbp), %rdx
	.loc	10 55 10
	addq	%rdx, %rax
	imulq	$112, %rax, %rax
	.loc	10 57 10
	addq	%rdx, %rcx
	imulq	$112, %rcx, %rcx
	movaps	-128(%rbp), %xmm2
	.loc	10 59 10
	subss	%xmm2, %xmm0
	.loc	10 60 10
	subss	%xmm3, %xmm2
	movq	%rax, %xmm1
	pshufd	$68, %xmm1, %xmm1
	movdqa	%xmm1, -336(%rbp)
	movq	%rcx, %xmm1
	pshufd	$68, %xmm1, %xmm1
	movdqa	%xmm1, -320(%rbp)
	shufps	$0, %xmm0, %xmm0
	movaps	%xmm0, -352(%rbp)
	shufps	$0, %xmm2, %xmm2
	movaps	%xmm2, -128(%rbp)
	movq	$-4, %rax
	movq	-216(%rbp), %rcx
	movq	%r12, -248(%rbp)
	.loc	10 0 10 is_stmt 0
.Ltmp43:
	.p2align	4
.LBB9_3:
	movq	%rcx, -296(%rbp)
	movq	%rax, -304(%rbp)
	.loc	10 20 8 is_stmt 1
	movq	%rcx, %xmm0
	pshufd	$68, %xmm0, %xmm0
	.loc	10 24 10
	movdqa	%xmm0, %xmm1
	por	.LCPI9_5(%rip), %xmm0
	.loc	10 33 10
	movq	%xmm0, %rax
	xorps	%xmm2, %xmm2
	cvtsi2ss	%rax, %xmm2
	pshufd	$238, %xmm0, %xmm0
	movq	%xmm0, %rax
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	.loc	10 24 10
	por	.LCPI9_4(%rip), %xmm1
	.loc	10 33 10
	unpcklps	%xmm0, %xmm2
	movq	%xmm1, %rax
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rax, %xmm0
	pshufd	$238, %xmm1, %xmm1
	movq	%xmm1, %rax
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	unpcklps	%xmm1, %xmm0
	movlhps	%xmm2, %xmm0
	movaps	.LCPI9_6(%rip), %xmm1
	.loc	10 34 10
	addps	%xmm1, %xmm0
	.loc	10 35 10
	mulps	%xmm1, %xmm0
	.loc	10 36 10
	addps	.LCPI9_7(%rip), %xmm0
	.loc	10 37 10
	movaps	%xmm0, %xmm1
	xorps	%xmm2, %xmm2
	cmpnleps	%xmm2, %xmm1
	andps	%xmm0, %xmm1
	.loc	10 38 10
	movaps	%xmm14, %xmm0
	minps	%xmm1, %xmm0
	movaps	%xmm0, -80(%rbp)
	.loc	10 47 10
	shufps	$255, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -160(%rbp)
	movaps	-80(%rbp), %xmm0
	movhlps	%xmm0, %xmm0
	callq	floorf@PLT
	unpcklps	-160(%rbp), %xmm0
	movaps	%xmm0, -144(%rbp)
	movaps	-80(%rbp), %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -192(%rbp)
	movaps	-80(%rbp), %xmm0
	shufps	$85, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -112(%rbp)
	movaps	-192(%rbp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	-144(%rbp), %xmm1
	movaps	%xmm1, -192(%rbp)
	movaps	-80(%rbp), %xmm0
	.loc	10 48 10
	addps	.LCPI9_9(%rip), %xmm0
	movaps	%xmm0, -64(%rbp)
	.loc	10 49 10
	shufps	$255, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -176(%rbp)
	movaps	-64(%rbp), %xmm0
	movhlps	%xmm0, %xmm0
	callq	floorf@PLT
	unpcklps	-176(%rbp), %xmm0
	movaps	%xmm0, -176(%rbp)
	movaps	-64(%rbp), %xmm0
	callq	floorf@PLT
	movaps	%xmm0, -368(%rbp)
	movaps	-64(%rbp), %xmm0
	shufps	$85, %xmm0, %xmm0
	callq	floorf@PLT
	movaps	.LCPI9_8(%rip), %xmm14
	movaps	-192(%rbp), %xmm15
	.loc	10 50 10
	cvttss2si	%xmm15, %rax
	movq	%rax, %xmm1
	cvttss2si	-112(%rbp), %rax
	movq	%rax, %xmm2
	punpcklqdq	%xmm2, %xmm1
	movdqa	-336(%rbp), %xmm7
	.loc	10 55 10
	movdqa	%xmm7, %xmm2
	paddq	%xmm1, %xmm2
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r15
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	112(%rsi,%rax), %r12
	cmovnsq	%rdx, %r12
	movq	%rdi, %rax
	imulq	%r15
	movq	%rdx, %rdi
	movq	%rdx, %r8
	shrq	$5, %rdi
	shrq	$63, %r8
	imulq	$50176, %rcx, %r9
	pshufd	$238, %xmm2, %xmm2
	movq	%xmm2, %rsi
	addq	%rbx, %r9
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	addq	%r8, %rdi
	movq	%rdx, %rax
	shrq	$63, %rax
	imulq	$448, %rdi, %rdx
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	addq	%r9, %rdx
	movq	%rdx, -96(%rbp)
	movq	%rsi, %rdx
	subq	%rax, %rdx
	.loc	10 50 10
	cvttss2si	-144(%rbp), %r8
	.loc	10 55 10
	setne	%al
	testq	%rsi, %rsi
	.loc	10 50 10
	cvttss2si	-160(%rbp), %r9
	.loc	10 55 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r15
	.loc	10 50 10
	movq	%r8, %xmm2
	.loc	10 55 10
	movq	%rdx, %rax
	.loc	10 50 10
	movq	%r9, %xmm3
	.loc	10 55 10
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	.loc	10 50 10
	punpcklqdq	%xmm3, %xmm2
	.loc	10 55 10
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	112(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -112(%rbp)
	movdqa	%xmm7, %xmm4
	movq	%rdi, %rax
	imulq	%r15
	movq	%rdx, %rdi
	paddq	%xmm2, %xmm4
	movq	%rdx, %r8
	shrq	$63, %r8
	shrq	$5, %rdi
	imulq	$50176, %rcx, %r9
	movq	%xmm4, %rsi
	addq	%rbx, %r9
	movq	%rsi, %rax
	imulq	%r14
	movq	%rdx, %rcx
	addq	%r8, %rdi
	movq	%rdx, %rax
	shrq	$63, %rax
	imulq	$448, %rdi, %r13
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	addq	%r9, %r13
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r15
	.loc	10 52 10
	movaps	%xmm14, %xmm3
	minps	-64(%rbp), %xmm3
	.loc	10 55 10
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	.loc	10 53 10
	cvttss2si	%xmm3, %r8
	.loc	10 55 10
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	112(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -88(%rbp)
	movq	%rdi, %rax
	imulq	%r15
	movq	%rdx, %rdi
	.loc	10 53 10
	movaps	%xmm3, %xmm5
	.loc	10 55 10
	movq	%rdx, %r9
	shrq	$5, %rdi
	imulq	$50176, %rcx, %r10
	pshufd	$238, %xmm4, %xmm4
	movq	%xmm4, %rsi
	shrq	$63, %r9
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	addq	%r9, %rdi
	addq	%rbx, %r10
	movq	%rdx, %rax
	imulq	$448, %rdi, %r14
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	addq	%r10, %r14
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	.loc	10 53 10
	shufps	$85, %xmm3, %xmm5
	.loc	10 55 10
	setne	%al
	testq	%rsi, %rsi
	.loc	10 53 10
	cvttss2si	%xmm5, %r10
	.loc	10 55 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r15
	.loc	10 53 10
	movq	%r8, %xmm4
	movaps	%xmm3, %xmm5
	.loc	10 55 10
	movq	%rdx, %rax
	.loc	10 53 10
	movq	%r10, %xmm6
	.loc	10 55 10
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	.loc	10 53 10
	punpcklqdq	%xmm6, %xmm4
	.loc	10 55 10
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	movq	%r15, %r9
	leaq	112(%rsi,%rax), %r15
	cmovnsq	%rdx, %r15
	.loc	10 53 10
	movhlps	%xmm3, %xmm3
	.loc	10 55 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rdi
	movq	%rdx, %r8
	imulq	$50176, %rcx, %r11
	shrq	$5, %rdi
	.loc	10 56 10
	movdqa	%xmm7, %xmm6
	paddq	%xmm4, %xmm6
	movq	%xmm6, %rsi
	.loc	10 55 10
	shrq	$63, %r8
	.loc	10 56 10
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	.loc	10 55 10
	addq	%r8, %rdi
	addq	%rbx, %r11
	.loc	10 56 10
	movq	%rdx, %rax
	.loc	10 55 10
	imulq	$448, %rdi, %r10
	.loc	10 56 10
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	.loc	10 55 10
	addq	%r11, %r10
	.loc	10 56 10
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	.loc	10 53 10
	cvttss2si	%xmm3, %rdi
	.loc	10 56 10
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	.loc	10 53 10
	movq	%rdi, %xmm3
	.loc	10 56 10
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	.loc	10 53 10
	shufps	$255, %xmm5, %xmm5
	.loc	10 56 10
	addq	%rax, %rdx
	.loc	10 53 10
	cvttss2si	%xmm5, %rax
	movq	%rax, %xmm5
	.loc	10 56 10
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	testq	%rdx, %rdx
	leaq	112(%rsi,%rax), %rax
	cmovnsq	%rdx, %rax
	movq	%rax, -64(%rbp)
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rdi
	movq	%rdx, %rax
	shrq	$5, %rdi
	imulq	$50176, %rcx, %r8
	shrq	$63, %rax
	addq	%rbx, %r8
	pshufd	$238, %xmm6, %xmm6
	movq	%xmm6, %rsi
	addq	%rax, %rdi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	imulq	$448, %rdi, %rax
	addq	%r8, %rax
	movq	%rax, -144(%rbp)
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$112, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -160(%rbp)
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	shrq	$5, %rdx
	addq	%rax, %rdx
	.loc	10 53 10
	punpcklqdq	%xmm5, %xmm3
	.loc	10 56 10
	movdqa	%xmm7, %xmm5
	paddq	%xmm3, %xmm5
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -288(%rbp)
	movq	%xmm5, %rdi
	movq	%rdi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rdi, %rdi
	sets	%sil
	andb	%al, %sil
	movzbl	%sil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rsi
	cmovnsq	%rdx, %rsi
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rdi,%rax), %r11
	addq	$112, %r11
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r11
	movq	-96(%rbp), %rax
	.loc	10 63 10
	movss	(%rax,%r12,4), %xmm6
	.loc	10 56 10
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %r12
	addq	%rax, %r12
	pshufd	$238, %xmm5, %xmm5
	movq	%xmm5, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r8
	addq	$112, %r8
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r8
	movq	-112(%rbp), %rax
	.loc	10 63 10
	movss	(%r13,%rax,4), %xmm5
	.loc	10 56 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %r13
	addq	%rax, %r13
	movdqa	-320(%rbp), %xmm10
	.loc	10 57 10
	paddq	%xmm10, %xmm1
	movq	%xmm1, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$112, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -112(%rbp)
	movq	-88(%rbp), %rax
	.loc	10 63 10
	movss	(%r14,%rax,4), %xmm7
	.loc	10 57 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -96(%rbp)
	pshufd	$238, %xmm1, %xmm1
	movq	%xmm1, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$112, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -88(%rbp)
	.loc	10 63 10
	movss	(%r10,%r15,4), %xmm1
	.loc	10 57 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	paddq	%xmm10, %xmm2
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -280(%rbp)
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$112, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -272(%rbp)
	.loc	10 64 10
	movss	(%r12,%r11,4), %xmm8
	.loc	10 57 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %rcx
	addq	%rax, %rcx
	movq	%rcx, -264(%rbp)
	pshufd	$238, %xmm2, %xmm2
	movq	%xmm2, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rsi, %rax
	addq	$112, %rax
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rax
	movq	%rax, -256(%rbp)
	.loc	10 64 10
	movss	(%r13,%r8,4), %xmm14
	.loc	10 57 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %r14
	addq	%rax, %r14
	.loc	10 58 10
	paddq	%xmm10, %xmm4
	movq	%xmm4, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r13
	addq	$112, %r13
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r13
	movq	-64(%rbp), %rax
	movq	-144(%rbp), %rdx
	.loc	10 64 10
	movss	(%rdx,%rax,4), %xmm9
	.loc	10 58 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %r11
	addq	%rax, %r11
	pshufd	$238, %xmm4, %xmm4
	movq	%xmm4, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r12
	addq	$112, %r12
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r12
	movq	-160(%rbp), %rax
	movq	-288(%rbp), %rdx
	.loc	10 64 10
	movss	(%rdx,%rax,4), %xmm4
	.loc	10 58 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$5, %rdx
	shrq	$63, %rax
	addq	%rax, %rdx
	paddq	%xmm10, %xmm3
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %r10
	addq	%rax, %r10
	movq	%xmm3, %rsi
	movq	%rsi, %rax
	movabsq	$6023426636313322977, %rcx
	imulq	%rcx
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rcx
	addq	%rax, %rcx
	imulq	$12544, %rcx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rsi, %rsi
	sets	%dil
	andb	%al, %dil
	movzbl	%dil, %eax
	subq	%rax, %rcx
	testq	%rdx, %rdx
	leaq	12544(%rdx), %rdi
	cmovnsq	%rdx, %rdi
	movq	%rsi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rsi, %rdx
	subq	%rax, %rdx
	negq	%rax
	leaq	(%rsi,%rax), %r15
	addq	$112, %r15
	testq	%rdx, %rdx
	cmovnsq	%rdx, %r15
	movq	-112(%rbp), %rax
	movq	-96(%rbp), %rdx
	.loc	10 67 10
	movss	(%rdx,%rax,4), %xmm10
	.loc	10 58 10
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %r8
	movq	-88(%rbp), %rax
	movq	-280(%rbp), %rdx
	.loc	10 67 10
	movss	(%rdx,%rax,4), %xmm11
	.loc	10 58 10
	movq	%r8, %rax
	shrq	$63, %rax
	shrq	$5, %r8
	pshufd	$238, %xmm3, %xmm3
	movq	%xmm3, %rdi
	addq	%rax, %r8
	movq	%rdi, %rax
	movabsq	$6023426636313322977, %rdx
	imulq	%rdx
	movq	%rdx, %rsi
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$12, %rsi
	addq	%rax, %rsi
	imulq	$50176, %rcx, %rax
	addq	%rbx, %rax
	imulq	$448, %r8, %r8
	addq	%rax, %r8
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rcx
	.loc	10 67 10
	movss	(%rcx,%rax,4), %xmm3
	.loc	10 58 10
	imulq	$12544, %rsi, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	setne	%al
	testq	%rdi, %rdi
	sets	%cl
	andb	%al, %cl
	movzbl	%cl, %eax
	subq	%rax, %rsi
	movaps	-368(%rbp), %xmm12
	.loc	10 49 10
	unpcklps	%xmm0, %xmm12
	.loc	10 58 10
	testq	%rdx, %rdx
	movq	-256(%rbp), %rax
	.loc	10 67 10
	movss	(%r14,%rax,4), %xmm2
	movabsq	$6023426636313322977, %r14
	.loc	10 58 10
	leaq	12544(%rdx), %rcx
	cmovnsq	%rdx, %rcx
	movq	%rdi, %rax
	imulq	%r9
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$5, %rdx
	addq	%rax, %rdx
	imulq	$112, %rdx, %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	negq	%rax
	addq	%rax, %rdi
	addq	$112, %rdi
	testq	%rdx, %rdx
	cmovnsq	%rdx, %rdi
	movq	%rcx, %rax
	imulq	%r9
	.loc	10 49 10
	unpcklpd	-176(%rbp), %xmm12
	movaps	%xmm12, %xmm0
	.loc	10 68 10
	movss	(%r8,%r15,4), %xmm12
	movq	%r9, %r15
	.loc	10 58 10
	movq	%rdx, %rax
	shrq	$63, %rax
	shrq	$5, %rdx
	addq	%rax, %rdx
	imulq	$50176, %rsi, %rax
	addq	%rbx, %rax
	imulq	$448, %rdx, %rcx
	addq	%rax, %rcx
	movq	-304(%rbp), %rax
	movaps	-80(%rbp), %xmm13
	.loc	10 61 10
	subps	%xmm13, %xmm0
	.loc	10 62 10
	subps	%xmm15, %xmm13
	movaps	%xmm13, %xmm15
	.loc	10 68 10
	movss	(%rcx,%rdi,4), %xmm13
	movq	-296(%rbp), %rcx
	.loc	10 63 10
	unpcklps	%xmm5, %xmm6
	.loc	10 68 10
	movss	(%r11,%r13,4), %xmm5
	.loc	10 63 10
	unpcklps	%xmm1, %xmm7
	.loc	10 68 10
	movss	(%r10,%r12,4), %xmm1
	movq	-248(%rbp), %r12
	.loc	10 63 10
	movlhps	%xmm7, %xmm6
	.loc	10 64 10
	unpcklps	%xmm4, %xmm9
	unpcklps	%xmm14, %xmm8
	movaps	.LCPI9_8(%rip), %xmm14
	movlhps	%xmm8, %xmm9
	.loc	10 63 10
	mulps	%xmm0, %xmm6
	.loc	10 64 10
	mulps	%xmm15, %xmm9
	.loc	10 65 10
	addps	%xmm6, %xmm9
	.loc	10 67 10
	unpcklps	%xmm11, %xmm10
	unpcklps	%xmm2, %xmm3
	.loc	10 66 10
	mulps	-352(%rbp), %xmm9
	.loc	10 67 10
	movlhps	%xmm3, %xmm10
	.loc	10 68 10
	unpcklps	%xmm13, %xmm12
	unpcklps	%xmm1, %xmm5
	movlhps	%xmm12, %xmm5
	.loc	10 67 10
	mulps	%xmm0, %xmm10
	.loc	10 68 10
	mulps	%xmm15, %xmm5
	.loc	10 69 10
	addps	%xmm10, %xmm5
	.loc	10 70 10
	mulps	-128(%rbp), %xmm5
	.loc	10 71 10
	addps	%xmm9, %xmm5
	.loc	10 20 8
	movups	%xmm5, (%r12,%rcx,4)
	addq	$4, %rcx
	addq	$4, %rax
	cmpq	$52, %rax
	jb	.LBB9_3
	.loc	10 0 8 is_stmt 0
	movq	-240(%rbp), %rcx
	.loc	10 20 8
	incq	%rcx
	addq	$904, %r12
	cmpq	$56, %rcx
	jne	.LBB9_2
	.loc	10 0 8
	movq	-200(%rbp), %rcx
	.loc	10 20 8
	incq	%rcx
	movq	-208(%rbp), %rax
	addq	$204304, %rax
	cmpq	$64, %rcx
	jne	.LBB9_1
	.loc	10 75 8 is_stmt 1
	xorl	%eax, %eax
	.loc	10 75 8 epilogue_begin is_stmt 0
	addq	$328, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp44:
.Lfunc_end9:
	.size	infer_dispatch_15_elementwise_broadcast_64x224x224_f32, .Lfunc_end9-infer_dispatch_15_elementwise_broadcast_64x224x224_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI10_0:
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.long	0x3e4ccccd
	.section	.text.infer_dispatch_16_conv_32x224x224x64x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_16_conv_32x224x224x64x3x3_f32,@function
infer_dispatch_16_conv_32x224x224x64x3x3_f32:
.Lfunc_begin10:
	.file	11 "dump" "configured_module_infer_dispatch_16.mlir"
	.loc	11 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp45:
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
	.loc	11 16 8 prologue_end
	movq	32(%rsi), %rax
	movq	(%rax), %rsi
	movl	$4136192, %ecx
	.loc	11 17 8
	addq	8(%rax), %rcx
	movq	%rcx, 56(%rsp)
	movl	$22709248, %ecx
	.loc	11 19 8
	addq	16(%rax), %rcx
	movq	%rcx, 120(%rsp)
	.loc	11 25 8
	movl	(%rdx), %ecx
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	leal	(,%rdx,8), %eax
	movl	%edx, %edi
	subl	%eax, %edi
	addl	%ecx, %edi
	movl	%edi, %eax
	shll	$5, %eax
	movq	%rax, 184(%rsp)
	.loc	11 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 192(%rsp)
	.loc	11 25 8
	imulq	$28928, %rdx, %rax
	shlq	$5, %rdx
	movq	%rdx, 144(%rsp)
	shll	$7, %edi
	addq	%rax, %rdi
	movq	%rsi, 128(%rsp)
	leaq	(%rsi,%rdi), %rax
	addq	$9633792, %rax
	movq	%rax, 112(%rsp)
	xorl	%eax, %eax
	movaps	.LCPI10_0(%rip), %xmm0
	.loc	11 0 8 is_stmt 0
.Ltmp46:
	.p2align	4
.LBB10_1:
	imulq	$200704, %rax, %rcx
	addq	128(%rsp), %rcx
	movq	%rcx, 160(%rsp)
	leaq	__constant_32xf32_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm1
	shufps	$0, %xmm1, %xmm1
	movq	%rax, 136(%rsp)
	imulq	$204304, %rax, %rax
	addq	120(%rsp), %rax
	movq	%rax, 152(%rsp)
	movq	112(%rsp), %r15
	xorl	%ecx, %ecx
	.p2align	4
.LBB10_2:
	movq	144(%rsp), %rax
	movq	%rcx, 168(%rsp)
	addq	%rcx, %rax
	imulq	$896, %rax, %r12
	addq	160(%rsp), %r12
	imulq	$904, %rax, %rax
	movq	152(%rsp), %rcx
	leaq	(%rcx,%rax), %r13
	addq	$908, %r13
	movq	%r15, 176(%rsp)
	xorl	%r8d, %r8d
	.p2align	4
.LBB10_3:
	xorl	%eax, %eax
	.p2align	4
.LBB10_4:
	.loc	11 25 8 is_stmt 1
	movss	192(%rsp,%rax,4), %xmm2
	movss	%xmm2, 64(%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB10_4
	movq	%r8, %rsi
	orq	184(%rsp), %rsi
	movq	56(%rsp), %r10
	movq	%r15, %r9
	xorl	%r11d, %r11d
	.loc	11 0 8 is_stmt 0
.Ltmp47:
	.p2align	4
.LBB10_6:
	movq	%r10, %rdi
	movq	%r9, %rcx
	xorl	%edx, %edx
	.p2align	4
.LBB10_7:
	movq	%rcx, %r14
	xorl	%ebx, %ebx
	.p2align	4
.LBB10_8:
	movss	64(%rsp,%rbx,4), %xmm2
	xorl	%eax, %eax
	.p2align	4
.LBB10_9:
	.loc	11 25 8 is_stmt 1
	movss	(%r14,%rax,4), %xmm3
	.loc	11 27 10
	mulss	(%rdi,%rax,4), %xmm3
	.loc	11 28 10
	addss	%xmm3, %xmm2
	.loc	11 25 8
	incq	%rax
	cmpq	$3, %rax
	jne	.LBB10_9
	movss	%xmm2, 64(%rsp,%rbx,4)
	incq	%rbx
	addq	$4, %r14
	cmpq	$4, %rbx
	jne	.LBB10_8
	incq	%rdx
	addq	$904, %rcx
	addq	$12, %rdi
	cmpq	$3, %rdx
	jne	.LBB10_7
	incq	%r11
	addq	$204304, %r9
	addq	$36, %r10
	cmpq	$64, %r11
	jne	.LBB10_6
	.loc	11 0 8 is_stmt 0
	movaps	64(%rsp), %xmm2
	.loc	11 33 10 is_stmt 1
	addps	%xmm1, %xmm2
	.loc	11 35 10
	xorps	%xmm3, %xmm3
	minps	%xmm2, %xmm3
	.loc	11 36 10
	mulps	%xmm0, %xmm3
	.loc	11 38 10
	xorps	%xmm4, %xmm4
	maxps	%xmm2, %xmm4
	.loc	11 39 10
	addps	%xmm3, %xmm4
	.loc	11 40 10
	mulps	(%r12,%rsi,4), %xmm4
	.loc	11 25 8
	movups	%xmm4, (%r13,%rsi,4)
	addq	$16, %r15
	cmpq	$28, %r8
	leaq	4(%r8), %r8
	jb	.LBB10_3
	.loc	11 0 8 is_stmt 0
	movq	168(%rsp), %rcx
	.loc	11 25 8
	incq	%rcx
	movq	176(%rsp), %r15
	addq	$904, %r15
	cmpq	$32, %rcx
	jne	.LBB10_2
	.loc	11 0 8
	movq	136(%rsp), %rax
	.loc	11 25 8
	incq	%rax
	addq	$2304, 56(%rsp)
	cmpq	$32, %rax
	jne	.LBB10_1
	.loc	11 44 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	11 44 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp48:
.Lfunc_end10:
	.size	infer_dispatch_16_conv_32x224x224x64x3x3_f32, .Lfunc_end10-infer_dispatch_16_conv_32x224x224x64x3x3_f32
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI11_0:
	.long	0x40fff644
	.long	0x40fff644
	.long	0x40fff644
	.long	0x40fff644
.LCPI11_1:
	.long	0xc0fff644
	.long	0xc0fff644
	.long	0xc0fff644
	.long	0xc0fff644
.LCPI11_2:
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
.LCPI11_3:
	.long	0x39d1b717
	.long	0x39d1b717
	.long	0x39d1b717
	.long	0x39d1b717
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI11_4:
	.long	0xa59f25c0
.LCPI11_5:
	.long	0x2a61337e
.LCPI11_6:
	.long	0xaebd37ff
.LCPI11_7:
	.long	0x335c0041
.LCPI11_8:
	.long	0x3779434a
.LCPI11_9:
	.long	0x3a270ded
.LCPI11_10:
	.long	0x3ba059dc
.LCPI11_11:
	.long	0x35a0d3d8
.LCPI11_12:
	.long	0x38f895d6
.LCPI11_13:
	.long	0x3b14aa05
.LCPI11_14:
	.long	0x3ba059dd
	.section	.text.infer_dispatch_17_conv_3x224x224x32x3x3_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_17_conv_3x224x224x32x3x3_f32,@function
infer_dispatch_17_conv_3x224x224x32x3x3_f32:
.Lfunc_begin11:
	.file	12 "dump" "configured_module_infer_dispatch_17.mlir"
	.loc	12 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp49:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$384, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	12 14 8 prologue_end
	movq	32(%rsi), %rdi
	movl	$4132736, %eax
	.loc	12 15 8
	addq	8(%rdi), %rax
	movq	%rax, 120(%rsp)
	.loc	12 14 8
	movq	(%rdi), %rsi
	.loc	12 16 8
	movq	16(%rdi), %rax
	movq	%rax, 232(%rsp)
	.loc	12 23 8
	movl	(%rdx), %ecx
	movabsq	$2635249153617166336, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	.loc	12 17 8
	movq	24(%rdi), %rax
	movq	%rax, 224(%rsp)
	.loc	12 23 8
	leal	(,%rdx,8), %eax
	movl	%edx, %edi
	subl	%eax, %edi
	addl	%ecx, %edi
	movl	%edi, %r13d
	shll	$5, %r13d
	.loc	12 9 8
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 256(%rsp)
	.loc	12 23 8
	imulq	$28928, %rdx, %rax
	shlq	$5, %rdx
	movq	%rdx, 192(%rsp)
	shll	$7, %edi
	addq	%rax, %rdi
	leaq	(%rsi,%rdi), %rax
	addq	$22709248, %rax
	movq	%rax, 176(%rsp)
	xorl	%eax, %eax
	.loc	12 0 8 is_stmt 0
.Ltmp50:
	.p2align	4
.LBB11_1:
	imulq	$50176, %rax, %rcx
	movq	%rcx, 200(%rsp)
	movq	%rax, 184(%rsp)
	leaq	__constant_3xf32(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm0
	shufps	$0, %xmm0, %xmm0
	movaps	%xmm0, 288(%rsp)
	movq	176(%rsp), %r15
	xorl	%ecx, %ecx
	.p2align	4
.LBB11_2:
	movq	192(%rsp), %rax
	movq	%rcx, 208(%rsp)
	addq	%rcx, %rax
	imulq	$224, %rax, %rbx
	addq	200(%rsp), %rbx
	movq	%r15, 216(%rsp)
	xorl	%r12d, %r12d
	.p2align	4
.LBB11_3:
	xorl	%eax, %eax
	.p2align	4
.LBB11_4:
	.loc	12 23 8 is_stmt 1
	movss	256(%rsp,%rax,4), %xmm0
	movss	%xmm0, 128(%rsp,%rax,4)
	incq	%rax
	cmpq	$4, %rax
	jne	.LBB11_4
	movq	%r12, %r14
	orq	%r13, %r14
	movq	120(%rsp), %rax
	movq	%r15, %rcx
	xorl	%edx, %edx
	.loc	12 0 8 is_stmt 0
.Ltmp51:
	.p2align	4
.LBB11_6:
	movq	%rax, %rsi
	movq	%rcx, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB11_7:
	movq	%rdi, %r9
	xorl	%r10d, %r10d
	.p2align	4
.LBB11_8:
	movss	128(%rsp,%r10,4), %xmm0
	xorl	%r11d, %r11d
	.p2align	4
.LBB11_9:
	.loc	12 23 8 is_stmt 1
	movss	(%r9,%r11,4), %xmm1
	.loc	12 25 10
	mulss	(%rsi,%r11,4), %xmm1
	.loc	12 26 10
	addss	%xmm1, %xmm0
	.loc	12 23 8
	incq	%r11
	cmpq	$3, %r11
	jne	.LBB11_9
	movss	%xmm0, 128(%rsp,%r10,4)
	incq	%r10
	addq	$4, %r9
	cmpq	$4, %r10
	jne	.LBB11_8
	incq	%r8
	addq	$904, %rdi
	addq	$12, %rsi
	cmpq	$3, %r8
	jne	.LBB11_7
	incq	%rdx
	addq	$204304, %rcx
	addq	$36, %rax
	cmpq	$32, %rdx
	jne	.LBB11_6
	.loc	12 29 8
	addq	%rbx, %r14
	movaps	128(%rsp), %xmm2
	.loc	12 31 10
	addps	288(%rsp), %xmm2
	.loc	12 32 10
	movaps	.LCPI11_0(%rip), %xmm0
	minps	%xmm2, %xmm0
	movaps	.LCPI11_1(%rip), %xmm1
	maxps	%xmm0, %xmm1
	movaps	%xmm1, 240(%rsp)
	andps	.LCPI11_2(%rip), %xmm2
	cmpltps	.LCPI11_3(%rip), %xmm2
	movaps	%xmm2, 304(%rsp)
	mulps	%xmm1, %xmm1
	movaps	%xmm1, 16(%rsp)
	movaps	%xmm1, %xmm0
	shufps	$85, %xmm1, %xmm0
	movaps	%xmm0, 96(%rsp)
	movss	.LCPI11_4(%rip), %xmm1
	movss	.LCPI11_5(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 80(%rsp)
	movaps	16(%rsp), %xmm0
	movss	.LCPI11_4(%rip), %xmm1
	movss	.LCPI11_5(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 32(%rsp)
	movaps	16(%rsp), %xmm0
	movhlps	%xmm0, %xmm0
	movaps	%xmm0, 64(%rsp)
	movss	.LCPI11_4(%rip), %xmm1
	movss	.LCPI11_5(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	16(%rsp), %xmm0
	shufps	$255, %xmm0, %xmm0
	movaps	%xmm0, 48(%rsp)
	movss	.LCPI11_4(%rip), %xmm1
	movss	.LCPI11_5(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	48(%rsp), %xmm0
	movss	.LCPI11_6(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 12(%rsp)
	movaps	64(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_6(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	16(%rsp), %xmm0
	movss	32(%rsp), %xmm1
	movss	.LCPI11_6(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 32(%rsp)
	movaps	96(%rsp), %xmm0
	movss	80(%rsp), %xmm1
	movss	.LCPI11_6(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	96(%rsp), %xmm0
	movss	.LCPI11_7(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 80(%rsp)
	movaps	16(%rsp), %xmm0
	movss	32(%rsp), %xmm1
	movss	.LCPI11_7(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 8(%rsp)
	movaps	64(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_7(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	48(%rsp), %xmm0
	movss	12(%rsp), %xmm1
	movss	.LCPI11_7(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	48(%rsp), %xmm0
	movss	.LCPI11_8(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 32(%rsp)
	movaps	64(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_8(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	16(%rsp), %xmm0
	movss	8(%rsp), %xmm1
	movss	.LCPI11_8(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 8(%rsp)
	movaps	96(%rsp), %xmm0
	movss	80(%rsp), %xmm1
	movss	.LCPI11_8(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	96(%rsp), %xmm0
	movss	.LCPI11_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 12(%rsp)
	movaps	16(%rsp), %xmm0
	movss	8(%rsp), %xmm1
	movss	.LCPI11_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 80(%rsp)
	movaps	64(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_9(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	48(%rsp), %xmm0
	movss	32(%rsp), %xmm1
	movss	.LCPI11_9(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	48(%rsp), %xmm0
	movss	.LCPI11_10(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, 32(%rsp)
	movaps	64(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_10(%rip), %xmm2
	callq	fmaf@PLT
	unpcklps	32(%rsp), %xmm0
	movaps	%xmm0, 32(%rsp)
	movaps	16(%rsp), %xmm0
	movss	80(%rsp), %xmm1
	movss	.LCPI11_10(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, 80(%rsp)
	movaps	96(%rsp), %xmm0
	movss	12(%rsp), %xmm1
	movss	.LCPI11_10(%rip), %xmm2
	callq	fmaf@PLT
	movaps	80(%rsp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	32(%rsp), %xmm1
	mulps	240(%rsp), %xmm1
	movaps	%xmm1, 80(%rsp)
	movaps	48(%rsp), %xmm0
	movss	.LCPI11_11(%rip), %xmm1
	movss	.LCPI11_12(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 32(%rsp)
	movaps	64(%rsp), %xmm0
	movss	.LCPI11_11(%rip), %xmm1
	movss	.LCPI11_12(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 8(%rsp)
	movaps	16(%rsp), %xmm0
	movss	.LCPI11_11(%rip), %xmm1
	movss	.LCPI11_12(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	96(%rsp), %xmm0
	movss	.LCPI11_11(%rip), %xmm1
	movss	.LCPI11_12(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	96(%rsp), %xmm0
	movss	.LCPI11_13(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 12(%rsp)
	movaps	16(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_13(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 4(%rsp)
	movaps	64(%rsp), %xmm0
	movss	8(%rsp), %xmm1
	movss	.LCPI11_13(%rip), %xmm2
	callq	fmaf@PLT
	movss	%xmm0, 8(%rsp)
	movaps	48(%rsp), %xmm0
	movss	32(%rsp), %xmm1
	movss	.LCPI11_13(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, %xmm1
	movaps	48(%rsp), %xmm0
	movss	.LCPI11_14(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, 48(%rsp)
	movaps	64(%rsp), %xmm0
	movss	8(%rsp), %xmm1
	movss	.LCPI11_14(%rip), %xmm2
	callq	fmaf@PLT
	unpcklps	48(%rsp), %xmm0
	movaps	%xmm0, 64(%rsp)
	movaps	16(%rsp), %xmm0
	movss	4(%rsp), %xmm1
	movss	.LCPI11_14(%rip), %xmm2
	callq	fmaf@PLT
	movaps	%xmm0, 16(%rsp)
	movaps	96(%rsp), %xmm0
	movss	12(%rsp), %xmm1
	movss	.LCPI11_14(%rip), %xmm2
	callq	fmaf@PLT
	movaps	16(%rsp), %xmm1
	unpcklps	%xmm0, %xmm1
	unpcklpd	64(%rsp), %xmm1
	movaps	80(%rsp), %xmm2
	divps	%xmm1, %xmm2
	movaps	304(%rsp), %xmm0
	movaps	240(%rsp), %xmm1
	andps	%xmm0, %xmm1
	andnps	%xmm2, %xmm0
	orps	%xmm1, %xmm0
	movq	232(%rsp), %rax
	.loc	12 33 10
	addps	(%rax,%r14,4), %xmm0
	movq	224(%rsp), %rax
	.loc	12 23 8
	movaps	%xmm0, (%rax,%r14,4)
	addq	$16, %r15
	cmpq	$28, %r12
	leaq	4(%r12), %r12
	jb	.LBB11_3
	.loc	12 0 8 is_stmt 0
	movq	208(%rsp), %rcx
	.loc	12 23 8
	incq	%rcx
	movq	216(%rsp), %r15
	addq	$904, %r15
	cmpq	$32, %rcx
	jne	.LBB11_2
	.loc	12 0 8
	movq	184(%rsp), %rax
	.loc	12 23 8
	incq	%rax
	addq	$1152, 120(%rsp)
	cmpq	$3, %rax
	jne	.LBB11_1
	.loc	12 37 8 is_stmt 1
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	12 37 8 epilogue_begin is_stmt 0
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
	.size	infer_dispatch_17_conv_3x224x224x32x3x3_f32, .Lfunc_end11-infer_dispatch_17_conv_3x224x224x32x3x3_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin12:
	.cfi_startproc
	xorl	%eax, %eax
	cmpl	$6, %edi
	leaq	iree_hal_executable_library_query_v0(%rip), %rcx
	cmoveq	%rcx, %rax
	retq
.Lfunc_end12:
	.size	iree_hal_executable_library_query, .Lfunc_end12-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end12-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin13:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB13_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB13_5
	testw	%cx, %cx
	je	.LBB13_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB13_6:
	movzwl	%cx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB13_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB13_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end13:
	.size	iree_h2f_ieee, .Lfunc_end13-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin14:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB14_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB14_6
	testl	%edx, %edx
	je	.LBB14_4
	orl	$32767, %eax
	retq
.LBB14_1:
	movl	%ecx, %edi
.LBB14_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB14_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB14_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB14_9
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
.LBB14_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end14:
	.size	iree_f2h_ieee, .Lfunc_end14-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin15:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB15_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB15_5
	testw	%cx, %cx
	je	.LBB15_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB15_6:
	movzwl	%cx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB15_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB15_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end15:
	.size	__gnu_h2f_ieee, .Lfunc_end15-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin16:
	.cfi_startproc
	movd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB16_6
	cmpl	$31744, %esi
	jne	.LBB16_5
	testw	%dx, %dx
	je	.LBB16_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	retq
.LBB16_6:
	movzwl	%dx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	retq
.LBB16_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	retq
.LBB16_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end16:
	.size	__extendhfsf2, .Lfunc_end16-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin17:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB17_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB17_6
	testl	%edx, %edx
	je	.LBB17_4
	orl	$32767, %eax
	retq
.LBB17_1:
	movl	%ecx, %edi
.LBB17_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB17_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB17_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB17_9
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
.LBB17_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end17:
	.size	__gnu_f2h_ieee, .Lfunc_end17-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin18:
	.cfi_startproc
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB18_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB18_6
	testl	%edx, %edx
	je	.LBB18_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.LBB18_1:
	movl	%ecx, %edi
	jmp	.LBB18_9
.LBB18_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB18_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB18_9
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
	jmp	.LBB18_9
.LBB18_4:
	movl	$31744, %edi
.LBB18_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.Lfunc_end18:
	.size	__truncsfhf2, .Lfunc_end18-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin19:
	.cfi_startproc
	movd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB19_6
	cmpl	$31744, %esi
	jne	.LBB19_5
	testw	%dx, %dx
	je	.LBB19_4
	orl	$2143289344, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB19_6:
	movzwl	%dx, %ecx
	cvtsi2ss	%ecx, %xmm1
	orl	$864026624, %eax
	movd	%eax, %xmm0
	mulss	%xmm1, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB19_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.LBB19_4:
	orl	$2139095040, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	retq
.Lfunc_end19:
	.size	__extendhfdf2, .Lfunc_end19-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin20:
	.cfi_startproc
	cvtsd2ss	%xmm0, %xmm0
	movd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB20_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB20_6
	testl	%edx, %edx
	je	.LBB20_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.LBB20_1:
	movl	%ecx, %edi
	jmp	.LBB20_9
.LBB20_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB20_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB20_9
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
	jmp	.LBB20_9
.LBB20_4:
	movl	$31744, %edi
.LBB20_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	movss	-4(%rsp), %xmm0
	retq
.Lfunc_end20:
	.size	__truncdfhf2, .Lfunc_end20-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin21:
	.cfi_startproc
	mulsd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	retq
.Lfunc_end21:
	.size	fma, .Lfunc_end21-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin22:
	.cfi_startproc
	subss	%xmm0, %xmm0
	divss	%xmm0, %xmm0
	retq
.Lfunc_end22:
	.size	__math_invalidf, .Lfunc_end22-__math_invalidf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI23_0:
	.long	0xf0000000
	.long	0x70000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI23_1:
	.long	0x70000000
	.section	.text.__math_oflowf,"ax",@progbits
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin23:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI23_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI23_1(%rip), %xmm0
	retq
.Lfunc_end23:
	.size	__math_oflowf, .Lfunc_end23-__math_oflowf
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI24_0:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.text.__math_xflowf,"ax",@progbits
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin24:
	.cfi_startproc
	movaps	%xmm0, %xmm1
	testl	%edi, %edi
	je	.LBB24_2
	movaps	.LCPI24_0(%rip), %xmm1
	xorps	%xmm0, %xmm1
.LBB24_2:
	movss	%xmm1, -4(%rsp)
	mulss	-4(%rsp), %xmm0
	retq
.Lfunc_end24:
	.size	__math_xflowf, .Lfunc_end24-__math_xflowf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI25_0:
	.long	0x90000000
	.long	0x10000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI25_1:
	.long	0x10000000
	.section	.text.__math_uflowf,"ax",@progbits
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin25:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI25_0(%rip), %rcx
	movss	(%rcx,%rax,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI25_1(%rip), %xmm0
	retq
.Lfunc_end25:
	.size	__math_uflowf, .Lfunc_end25-__math_uflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI26_0:
	.long	0x7b800000
.LCPI26_1:
	.long	0x80000000
.LCPI26_2:
	.long	0x3f800000
	.section	.text.ceilf,"ax",@progbits
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin26:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB26_1
.LBB26_8:
	retq
.LBB26_1:
	cmpl	$127, %ecx
	jb	.LBB26_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrl	%cl, %edx
	testl	%eax, %edx
	je	.LBB26_8
	addss	.LCPI26_0(%rip), %xmm0
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
.LBB26_4:
	movss	.LCPI26_0(%rip), %xmm1
	addss	%xmm0, %xmm1
	movss	%xmm1, -4(%rsp)
	testl	%eax, %eax
	js	.LBB26_5
	je	.LBB26_8
	movss	.LCPI26_2(%rip), %xmm0
	retq
.LBB26_5:
	movss	.LCPI26_1(%rip), %xmm0
	retq
.Lfunc_end26:
	.size	ceilf, .Lfunc_end26-ceilf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI27_0:
	.long	0xff800000
.LCPI27_1:
	.long	0x42b17217
.LCPI27_2:
	.long	0xc2cff1b4
.LCPI27_3:
	.long	0x10000000
.LCPI27_4:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI27_5:
	.quad	0x40471547652b82fe
.LCPI27_6:
	.quad	0x4338000000000000
.LCPI27_7:
	.quad	0xc338000000000000
.LCPI27_8:
	.quad	0x3ebc6af84b912394
.LCPI27_9:
	.quad	0x3f2ebfce50fac4f3
.LCPI27_10:
	.quad	0x3f962e42ff0c52d6
.LCPI27_11:
	.quad	0x3ff0000000000000
	.section	.text.expf,"ax",@progbits
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin27:
	.cfi_startproc
	movd	%xmm0, %eax
	shrl	$20, %eax
	andl	$2047, %eax
	cmpl	$1067, %eax
	jae	.LBB27_1
.LBB27_8:
	cvtss2sd	%xmm0, %xmm0
	mulsd	.LCPI27_5(%rip), %xmm0
	movsd	.LCPI27_6(%rip), %xmm1
	addsd	%xmm0, %xmm1
	movq	%xmm1, %rax
	addsd	.LCPI27_7(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movl	%eax, %ecx
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	movsd	.LCPI27_8(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	addsd	.LCPI27_9(%rip), %xmm1
	movq	%rax, %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	mulsd	%xmm1, %xmm3
	mulsd	.LCPI27_10(%rip), %xmm0
	addsd	.LCPI27_11(%rip), %xmm0
	addsd	%xmm3, %xmm0
	mulsd	%xmm2, %xmm0
	xorps	%xmm1, %xmm1
	cvtsd2ss	%xmm0, %xmm1
.LBB27_9:
	movaps	%xmm1, %xmm0
	retq
.LBB27_1:
	xorps	%xmm1, %xmm1
	movss	.LCPI27_0(%rip), %xmm2
	ucomiss	%xmm0, %xmm2
	jae	.LBB27_9
	cmpl	$2040, %eax
	jae	.LBB27_3
	ucomiss	.LCPI27_1(%rip), %xmm0
	jbe	.LBB27_6
	movl	$1879048192, -8(%rsp)
	movss	-8(%rsp), %xmm1
	mulss	.LCPI27_4(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.LBB27_3:
	addss	%xmm0, %xmm0
	retq
.LBB27_6:
	movss	.LCPI27_2(%rip), %xmm1
	ucomiss	%xmm0, %xmm1
	jbe	.LBB27_8
	movl	$268435456, -4(%rsp)
	movss	-4(%rsp), %xmm1
	mulss	.LCPI27_3(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end27:
	.size	expf, .Lfunc_end27-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin28:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end28:
	.size	feclearexcept, .Lfunc_end28-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin29:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end29:
	.size	feraiseexcept, .Lfunc_end29-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin30:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end30:
	.size	fetestexcept, .Lfunc_end30-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin31:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end31:
	.size	fegetround, .Lfunc_end31-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin32:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end32:
	.size	__fesetround, .Lfunc_end32-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin33:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end33:
	.size	fegetenv, .Lfunc_end33-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin34:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end34:
	.size	fesetenv, .Lfunc_end34-fesetenv
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI35_0:
	.long	0x7b800000
.LCPI35_1:
	.long	0xbf800000
	.section	.text.floorf,"ax",@progbits
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin35:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB35_1
	retq
.LBB35_1:
	cmpl	$127, %ecx
	jb	.LBB35_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrl	%cl, %edx
	testl	%eax, %edx
	je	.LBB35_6
	addss	.LCPI35_0(%rip), %xmm0
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
.LBB35_4:
	movss	.LCPI35_0(%rip), %xmm1
	addss	%xmm0, %xmm1
	movss	%xmm1, -4(%rsp)
	xorps	%xmm1, %xmm1
	testl	%eax, %eax
	jns	.LBB35_5
	ucomiss	%xmm1, %xmm0
	movaps	%xmm0, %xmm1
	jne	.LBB35_8
	jp	.LBB35_8
.LBB35_5:
	movaps	%xmm1, %xmm0
.LBB35_6:
	retq
.LBB35_8:
	movss	.LCPI35_1(%rip), %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end35:
	.size	floorf, .Lfunc_end35-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin36:
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
	jne	.LBB36_7
	movapd	%xmm1, %xmm3
	subsd	%xmm0, %xmm3
	ucomisd	%xmm2, %xmm3
	jne	.LBB36_3
	jp	.LBB36_3
	movapd	%xmm1, %xmm3
	subsd	%xmm2, %xmm3
	ucomisd	%xmm0, %xmm3
	jne	.LBB36_3
	jp	.LBB36_3
.LBB36_7:
	xorps	%xmm0, %xmm0
	cvtsd2ss	%xmm1, %xmm0
	retq
.LBB36_3:
	testq	%rax, %rax
	sets	%cl
	ucomisd	%xmm0, %xmm2
	setbe	%dl
	xorb	%cl, %dl
	jne	.LBB36_4
	subsd	%xmm1, %xmm2
	jmp	.LBB36_6
.LBB36_4:
	subsd	%xmm1, %xmm0
.LBB36_6:
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
.Lfunc_end36:
	.size	fmaf, .Lfunc_end36-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin37:
	.cfi_startproc
	movd	%xmm1, %esi
	movl	%esi, %ecx
	addl	%esi, %ecx
	je	.LBB37_2
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
	jne	.LBB37_3
.LBB37_2:
	mulss	%xmm1, %xmm0
	divss	%xmm0, %xmm0
	retq
.LBB37_3:
	leal	(%rax,%rax), %edi
	cmpl	%ecx, %edi
	jbe	.LBB37_4
	movl	%esi, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %r8d
	testl	%edx, %edx
	je	.LBB37_7
	movl	%eax, %edi
	andl	$8388607, %edi
	orl	$8388608, %edi
	testl	%r8d, %r8d
	je	.LBB37_12
.LBB37_15:
	andl	$8388607, %esi
	orl	$8388608, %esi
	cmpl	%r8d, %edx
	jg	.LBB37_17
.LBB37_21:
	movl	%edi, %ecx
	subl	%esi, %ecx
	jns	.LBB37_22
	jmp	.LBB37_23
.LBB37_4:
	je	.LBB37_5
	retq
.LBB37_7:
	movl	%eax, %ecx
	xorl	%edx, %edx
	shll	$9, %ecx
	js	.LBB37_9
	.p2align	4
.LBB37_8:
	decl	%edx
	addl	%ecx, %ecx
	jns	.LBB37_8
.LBB37_9:
	movb	$1, %cl
	subb	%dl, %cl
	movl	%eax, %edi
	shll	%cl, %edi
	testl	%r8d, %r8d
	jne	.LBB37_15
.LBB37_12:
	movl	%esi, %ecx
	xorl	%r8d, %r8d
	shll	$9, %ecx
	js	.LBB37_14
	.p2align	4
.LBB37_13:
	decl	%r8d
	addl	%ecx, %ecx
	jns	.LBB37_13
.LBB37_14:
	movb	$1, %cl
	subb	%r8b, %cl
	shll	%cl, %esi
	cmpl	%r8d, %edx
	jg	.LBB37_17
	jmp	.LBB37_21
	.p2align	4
.LBB37_19:
	addl	%edi, %edi
	decl	%edx
	cmpl	%r8d, %edx
	jle	.LBB37_20
.LBB37_17:
	movl	%edi, %ecx
	subl	%esi, %ecx
	js	.LBB37_19
	movl	%ecx, %edi
	jne	.LBB37_19
	jmp	.LBB37_5
.LBB37_20:
	movl	%r8d, %edx
	movl	%edi, %ecx
	subl	%esi, %ecx
	js	.LBB37_23
.LBB37_22:
	movl	%ecx, %edi
	je	.LBB37_5
.LBB37_23:
	cmpl	$8388607, %edi
	ja	.LBB37_24
	.p2align	4
.LBB37_25:
	leal	(%rdi,%rdi), %esi
	decl	%edx
	cmpl	$4194304, %edi
	movl	%esi, %edi
	jb	.LBB37_25
	andl	$-2147483648, %eax
	testl	%edx, %edx
	jle	.LBB37_28
.LBB37_27:
	addl	$-8388608, %esi
	shll	$23, %edx
	orl	%esi, %edx
	orl	%eax, %edx
	movd	%edx, %xmm0
	retq
.LBB37_5:
	pxor	%xmm1, %xmm1
	mulss	%xmm1, %xmm0
	retq
.LBB37_24:
	movl	%edi, %esi
	andl	$-2147483648, %eax
	testl	%edx, %edx
	jg	.LBB37_27
.LBB37_28:
	movb	$1, %cl
	subb	%dl, %cl
	shrl	%cl, %esi
	movl	%esi, %edx
	orl	%eax, %edx
	movd	%edx, %xmm0
	retq
.Lfunc_end37:
	.size	fmodf, .Lfunc_end37-fmodf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI38_0:
	.long	0x5f800000
	.section	.text.frexpf,"ax",@progbits
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin38:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	cmpb	$-1, %cl
	je	.LBB38_7
	movzbl	%cl, %edx
	testl	%edx, %edx
	jne	.LBB38_6
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB38_4
	jnp	.LBB38_3
.LBB38_4:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	mulss	.LCPI38_0(%rip), %xmm0
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
.LBB38_6:
	movzbl	%cl, %ecx
	addl	$-126, %ecx
	movl	%ecx, (%rdi)
	andl	$-2139095041, %eax
	orl	$1056964608, %eax
	movd	%eax, %xmm0
.LBB38_7:
	retq
.LBB38_3:
	xorl	%eax, %eax
	movl	%eax, (%rdi)
	retq
.Lfunc_end38:
	.size	frexpf, .Lfunc_end38-frexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI39_0:
	.long	0x0c800000
.LCPI39_1:
	.long	0x7f000000
	.section	.text.ldexpf,"ax",@progbits
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin39:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB39_4
	mulss	.LCPI39_1(%rip), %xmm0
	cmpl	$255, %edi
	jb	.LBB39_2
	mulss	.LCPI39_1(%rip), %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB39_8
.LBB39_4:
	cmpl	$-127, %edi
	jg	.LBB39_9
	mulss	.LCPI39_0(%rip), %xmm0
	cmpl	$-229, %edi
	ja	.LBB39_6
	mulss	.LCPI39_0(%rip), %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB39_8:
	movl	%eax, %edi
	jmp	.LBB39_9
.LBB39_2:
	addl	$-127, %edi
	jmp	.LBB39_9
.LBB39_6:
	addl	$102, %edi
.LBB39_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	movd	%edi, %xmm1
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end39:
	.size	ldexpf, .Lfunc_end39-ldexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI40_0:
	.long	0x0c800000
.LCPI40_1:
	.long	0x7f000000
	.section	.text.scalbnf,"ax",@progbits
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin40:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB40_4
	mulss	.LCPI40_1(%rip), %xmm0
	cmpl	$255, %edi
	jb	.LBB40_2
	mulss	.LCPI40_1(%rip), %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB40_8
.LBB40_4:
	cmpl	$-127, %edi
	jg	.LBB40_9
	mulss	.LCPI40_0(%rip), %xmm0
	cmpl	$-229, %edi
	ja	.LBB40_6
	mulss	.LCPI40_0(%rip), %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB40_8:
	movl	%eax, %edi
	jmp	.LBB40_9
.LBB40_2:
	addl	$-127, %edi
	jmp	.LBB40_9
.LBB40_6:
	addl	$102, %edi
.LBB40_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	movd	%edi, %xmm1
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end40:
	.size	scalbnf, .Lfunc_end40-scalbnf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI41_0:
	.long	0x3f800000
.LCPI41_2:
	.long	0x4b000000
.LCPI41_12:
	.long	0x10000000
.LCPI41_20:
	.long	0x70000000
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI41_1:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI41_3:
	.quad	0xbff0000000000000
.LCPI41_4:
	.quad	0x3fd27616c9496e0b
.LCPI41_5:
	.quad	0xbfd71969a075c67a
.LCPI41_6:
	.quad	0x3fdec70a6ca7badd
.LCPI41_7:
	.quad	0xbfe7154748bef6c8
.LCPI41_8:
	.quad	0x3ff71547652ab82b
.LCPI41_9:
	.quad	0x405fffffffd1d571
.LCPI41_10:
	.quad	0xc062c00000000000
.LCPI41_11:
	.long	0x90000000
	.long	0x10000000
.LCPI41_13:
	.quad	0x42e8000000000000
.LCPI41_14:
	.quad	0xc2e8000000000000
.LCPI41_15:
	.quad	0x3fac6af84b912394
.LCPI41_16:
	.quad	0x3fcebfce50fac4f3
.LCPI41_17:
	.quad	0x3fe62e42ff0c52d6
.LCPI41_18:
	.quad	0x3ff0000000000000
.LCPI41_19:
	.long	0xf0000000
	.long	0x70000000
	.section	.text.powf,"ax",@progbits
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin41:
	.cfi_startproc
	movd	%xmm0, %ecx
	movd	%xmm1, %edx
	leal	-2139095040(%rcx), %eax
	cmpl	$-2130706432, %eax
	jb	.LBB41_5
	xorl	%eax, %eax
	leal	16777216(,%rdx,2), %esi
	cmpl	$16777216, %esi
	jbe	.LBB41_5
.LBB41_2:
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
	addsd	.LCPI41_3(%rip), %xmm0
	cvtsi2sd	%esi, %xmm2
	addsd	8(%rdx,%rdi), %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	movsd	.LCPI41_4(%rip), %xmm4
	mulsd	%xmm0, %xmm4
	addsd	.LCPI41_5(%rip), %xmm4
	movsd	.LCPI41_6(%rip), %xmm5
	mulsd	%xmm0, %xmm5
	addsd	.LCPI41_7(%rip), %xmm5
	mulsd	%xmm3, %xmm5
	mulsd	%xmm3, %xmm3
	mulsd	.LCPI41_8(%rip), %xmm0
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
	jae	.LBB41_10
.LBB41_3:
	movsd	.LCPI41_13(%rip), %xmm1
	addsd	%xmm0, %xmm1
	movq	%xmm1, %rcx
	addsd	.LCPI41_14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	addl	%ecx, %eax
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	movsd	.LCPI41_15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	addsd	.LCPI41_16(%rip), %xmm1
	movq	%rax, %xmm2
	movapd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm3
	mulsd	%xmm1, %xmm3
	mulsd	.LCPI41_17(%rip), %xmm0
	addsd	.LCPI41_18(%rip), %xmm0
	addsd	%xmm3, %xmm0
	mulsd	%xmm2, %xmm0
	cvtsd2ss	%xmm0, %xmm0
.LBB41_4:
	retq
.LBB41_5:
	leal	(%rdx,%rdx), %eax
	leal	-1(%rax), %esi
	cmpl	$-16777217, %esi
	jae	.LBB41_21
	leal	-1(,%rcx,2), %eax
	cmpl	$-16777217, %eax
	jae	.LBB41_25
	xorl	%eax, %eax
	testl	%ecx, %ecx
	js	.LBB41_12
	cmpl	$8388607, %ecx
	ja	.LBB41_2
.LBB41_9:
	mulss	.LCPI41_2(%rip), %xmm0
	movd	%xmm0, %ecx
	andl	$2147483647, %ecx
	addl	$-192937984, %ecx
	jmp	.LBB41_2
.LBB41_10:
	ucomisd	.LCPI41_9(%rip), %xmm0
	jbe	.LBB41_16
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI41_19(%rip), %rax
	movss	(%rax,%rcx,4), %xmm0
	movss	%xmm0, -8(%rsp)
	movss	-8(%rsp), %xmm0
	mulss	.LCPI41_20(%rip), %xmm0
	retq
.LBB41_12:
	movl	%edx, %eax
	shrl	$23, %eax
	movzbl	%al, %ecx
	cmpl	$127, %ecx
	jb	.LBB41_19
	cmpl	$150, %ecx
	jbe	.LBB41_18
.LBB41_14:
	xorl	%eax, %eax
.LBB41_15:
	movd	%xmm0, %ecx
	andl	$2147483647, %ecx
	cmpl	$8388607, %ecx
	ja	.LBB41_2
	jmp	.LBB41_9
.LBB41_16:
	movsd	.LCPI41_10(%rip), %xmm1
	ucomisd	%xmm0, %xmm1
	jb	.LBB41_3
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI41_11(%rip), %rax
	movss	(%rax,%rcx,4), %xmm0
	movss	%xmm0, -4(%rsp)
	movss	-4(%rsp), %xmm0
	mulss	.LCPI41_12(%rip), %xmm0
	retq
.LBB41_18:
	movb	$-106, %cl
	subb	%al, %cl
	movl	$1, %esi
	shll	%cl, %esi
	leal	-1(%rsi), %eax
	testl	%edx, %eax
	je	.LBB41_20
.LBB41_19:
	subss	%xmm0, %xmm0
	divss	%xmm0, %xmm0
	retq
.LBB41_20:
	movl	$65536, %eax
	testl	%edx, %esi
	jne	.LBB41_15
	jmp	.LBB41_14
.LBB41_21:
	movss	.LCPI41_0(%rip), %xmm2
	cmpl	$1065353216, %ecx
	je	.LBB41_34
	testl	%eax, %eax
	je	.LBB41_34
	addl	%ecx, %ecx
	cmpl	$-16777215, %ecx
	setb	%sil
	cmpl	$-16777215, %eax
	setb	%al
	testb	%al, %sil
	jne	.LBB41_35
	addss	%xmm1, %xmm0
	retq
.LBB41_25:
	mulss	%xmm0, %xmm0
	testl	%ecx, %ecx
	jns	.LBB41_31
	movl	%edx, %eax
	shrl	$23, %eax
	movzbl	%al, %ecx
	addl	$-151, %ecx
	cmpl	$-24, %ecx
	jb	.LBB41_31
	movb	$-106, %cl
	subb	%al, %cl
	movl	$1, %esi
	shll	%cl, %esi
	decl	%esi
	movzbl	%cl, %eax
	movaps	%xmm0, %xmm1
	testl	%edx, %esi
	jne	.LBB41_29
	movaps	.LCPI41_1(%rip), %xmm1
	xorps	%xmm0, %xmm1
.LBB41_29:
	btl	%eax, %edx
	jae	.LBB41_31
	movaps	%xmm1, %xmm0
.LBB41_31:
	testl	%edx, %edx
	jns	.LBB41_4
	movss	.LCPI41_0(%rip), %xmm1
	divss	%xmm0, %xmm1
	movss	%xmm1, -12(%rsp)
	movss	-12(%rsp), %xmm0
	retq
.LBB41_34:
	movaps	%xmm2, %xmm0
	retq
.LBB41_35:
	cmpl	$2130706432, %ecx
	movaps	%xmm2, %xmm0
	je	.LBB41_4
	setb	%al
	testl	%edx, %edx
	sets	%cl
	xorb	%al, %cl
	xorps	%xmm0, %xmm0
	jne	.LBB41_4
	mulss	%xmm1, %xmm1
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end41:
	.size	powf, .Lfunc_end41-powf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI42_0:
	.long	0xcb000000
.LCPI42_1:
	.long	0x4b000000
.LCPI42_2:
	.long	0x80000000
	.section	.text.rintf,"ax",@progbits
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin42:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	andl	$2130706432, %ecx
	cmpl	$1249902592, %ecx
	ja	.LBB42_8
	movss	.LCPI42_0(%rip), %xmm1
	movss	.LCPI42_1(%rip), %xmm2
	testl	%eax, %eax
	jns	.LBB42_2
	addss	%xmm1, %xmm0
	addss	%xmm2, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB42_8
	jnp	.LBB42_5
.LBB42_8:
	retq
.LBB42_2:
	addss	%xmm2, %xmm0
	addss	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB42_8
	jp	.LBB42_8
.LBB42_5:
	testl	%eax, %eax
	jns	.LBB42_7
	movss	.LCPI42_2(%rip), %xmm1
.LBB42_7:
	movaps	%xmm1, %xmm0
	retq
.Lfunc_end42:
	.size	rintf, .Lfunc_end42-rintf
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI43_0:
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
	.long	0x7fffffff
.LCPI43_7:
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.long	0x80000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI43_1:
	.long	0x4b000000
.LCPI43_2:
	.long	0xcb000000
.LCPI43_3:
	.long	0x3f000000
.LCPI43_4:
	.long	0xbf000000
.LCPI43_5:
	.long	0x3f800000
.LCPI43_6:
	.long	0xbf800000
	.section	.text.roundf,"ax",@progbits
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin43:
	.cfi_startproc
	movd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB43_10
	movdqa	.LCPI43_0(%rip), %xmm1
	pand	%xmm0, %xmm1
	movss	.LCPI43_1(%rip), %xmm2
	addss	%xmm1, %xmm2
	cmpl	$125, %ecx
	ja	.LBB43_3
	movss	%xmm2, -4(%rsp)
	xorps	%xmm1, %xmm1
	mulss	%xmm1, %xmm0
	retq
.LBB43_3:
	addss	.LCPI43_2(%rip), %xmm2
	subss	%xmm1, %xmm2
	ucomiss	.LCPI43_3(%rip), %xmm2
	jbe	.LBB43_5
	addss	%xmm2, %xmm1
	addss	.LCPI43_6(%rip), %xmm1
	jmp	.LBB43_7
.LBB43_5:
	movss	.LCPI43_4(%rip), %xmm0
	ucomiss	%xmm2, %xmm0
	addss	%xmm2, %xmm1
	jb	.LBB43_7
	addss	.LCPI43_5(%rip), %xmm1
.LBB43_7:
	testl	%eax, %eax
	jns	.LBB43_9
	xorps	.LCPI43_7(%rip), %xmm1
.LBB43_9:
	movaps	%xmm1, %xmm0
.LBB43_10:
	retq
.Lfunc_end43:
	.size	roundf, .Lfunc_end43-roundf
	.cfi_endproc

	.type	__constant_32xf32,@object
	.section	.rodata.__constant_32xf32,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32:
	.long	0xbcd5fc58
	.long	0x3cf7803e
	.long	0x3ca1b2dd
	.long	0x3cf05d6e
	.long	0xbbff39d6
	.long	0x3de2eea7
	.long	0x3cb5f8b6
	.long	0x3d8b7cc4
	.long	0x3c5fa8ea
	.long	0xbbc946e0
	.long	0x3bfff70e
	.long	0xbc55e8c5
	.long	0xbc602bd2
	.long	0x3cd6a284
	.long	0x3c1bbfd6
	.long	0x3c0d70d4
	.long	0xbc1c477c
	.long	0x3d708a93
	.long	0xbc1887d2
	.long	0x3d59034a
	.long	0x3c1fc0e0
	.long	0x3c99f60e
	.long	0x3b52e569
	.long	0x3b03444c
	.long	0x3ca183ee
	.long	0xbaa71422
	.long	0x3c76d391
	.long	0x3d41344f
	.long	0xba3cdf21
	.long	0xbb6a9030
	.long	0x3e0d7bd8
	.long	0x3dc3d86f
	.size	__constant_32xf32, 128

	.type	__constant_64xf32,@object
	.section	.rodata.__constant_64xf32,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32:
	.long	0x3cc56444
	.long	0x3cecf3c4
	.long	0xbc040513
	.long	0x3cb61df6
	.long	0xbc088408
	.long	0x3d40f780
	.long	0x3cef0788
	.long	0x3bd73611
	.long	0x3c0d92dc
	.long	0x3b1baed3
	.long	0xbbb9a5a6
	.long	0x3d28683c
	.long	0x3d356ae5
	.long	0x3c164802
	.long	0xbb00d7fe
	.long	0x3d1b5434
	.long	0x3d3246e7
	.long	0x3bbe04cc
	.long	0xbba16c8e
	.long	0x3d416fc2
	.long	0xbcd15668
	.long	0xbbd37a60
	.long	0x3c85d687
	.long	0xbcaffc7e
	.long	0x3c654d0c
	.long	0xbc8e5f90
	.long	0x3d195424
	.long	0x3c08c452
	.long	0x3a8ddeb6
	.long	0xbcc44740
	.long	0x3c3b3df9
	.long	0x3c6360c6
	.long	0xbc19d162
	.long	0xbb4d8c2a
	.long	0x3affb942
	.long	0x3c916916
	.long	0x3d0f932e
	.long	0x3d0a1a57
	.long	0x3c96df06
	.long	0xbabdd684
	.long	0x3c8c4c9c
	.long	0x3bd4e388
	.long	0x38f20739
	.long	0x3b1f4456
	.long	0x3cd2fe07
	.long	0xbbb2e5b8
	.long	0x3d0c4136
	.long	0xbb53024e
	.long	0xbb269eba
	.long	0x3c69f488
	.long	0x3c91727c
	.long	0x3cd25be2
	.long	0x3d3006de
	.long	0x3b65f7b6
	.long	0x3c8f5580
	.long	0xbca7d635
	.long	0x3c721133
	.long	0x3c98f23c
	.long	0x3c4ba48e
	.long	0x3c7b6248
	.long	0x3c79d348
	.long	0x3c1938c6
	.long	0x3d247520
	.long	0xbb6bc48a
	.size	__constant_64xf32, 256

	.type	__constant_64xf32_0,@object
	.section	.rodata.__constant_64xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_64xf32_0:
	.long	0xbca7ae46
	.long	0x3c7557aa
	.long	0x3ccd6cac
	.long	0xbd0a7db5
	.long	0x3cfc2965
	.long	0x3c913f87
	.long	0xbb79da80
	.long	0xbd0d65ec
	.long	0x3d0011a5
	.long	0xbc6cdf0a
	.long	0xbc8a6f6d
	.long	0xbbc46261
	.long	0x3cd29564
	.long	0xbc6b96de
	.long	0x3c99cda8
	.long	0xbce17d84
	.long	0x3d01c31b
	.long	0xbb3b9b2a
	.long	0xbcf2b65b
	.long	0xbd084d19
	.long	0x3d0e370c
	.long	0xbb33413f
	.long	0x3d066095
	.long	0x3d0641fa
	.long	0xbcc9926d
	.long	0x3b9b147e
	.long	0xbbf22d78
	.long	0xbbd0efb5
	.long	0xbcfe3d8f
	.long	0xbbd8f8b2
	.long	0x3d07533a
	.long	0xbbbd08bc
	.long	0x3d33efee
	.long	0xbcd55d57
	.long	0xbc913cb7
	.long	0xbcd221b6
	.long	0x3cc47802
	.long	0xbd0c60cf
	.long	0x3ac6aa94
	.long	0x398d6338
	.long	0x3c1793b0
	.long	0x3cfce19e
	.long	0x3ca8b1e8
	.long	0x3cb47af2
	.long	0x3b324338
	.long	0x3d16c4ea
	.long	0xbd230818
	.long	0x3c6c7954
	.long	0x3d6d8660
	.long	0x3cae9eb1
	.long	0x3b5fcdf4
	.long	0xbc12c980
	.long	0xbc41a406
	.long	0x3cc1e168
	.long	0x3cdf6354
	.long	0xbd153f96
	.long	0x3c68314f
	.long	0x3ceb1d80
	.long	0xbc9ede3c
	.long	0x3c7f3072
	.long	0x3b9f7111
	.long	0xbc6f25f6
	.long	0x3b543e8d
	.long	0x3d2701b4
	.size	__constant_64xf32_0, 256

	.type	__constant_32xf32_0,@object
	.section	.rodata.__constant_32xf32_0,"a",@progbits
	.p2align	6, 0x0
__constant_32xf32_0:
	.long	0x3c530d34
	.long	0x3d469476
	.long	0x3dd952da
	.long	0x3c81795a
	.long	0x3d293d1a
	.long	0xbdb79c36
	.long	0xbc8f621c
	.long	0xbb3f2364
	.long	0xbb8da74c
	.long	0xbbbdb070
	.long	0xbd83dfe3
	.long	0x3ced0832
	.long	0x3c5222f4
	.long	0x3c37a9fc
	.long	0x3c385fde
	.long	0x3cb0a448
	.long	0xbd794c44
	.long	0x3cad7182
	.long	0xbcba0ede
	.long	0xbd9d9ec2
	.long	0x3cde70a3
	.long	0xbda2d776
	.long	0x3d3f3f57
	.long	0x3d4d289a
	.long	0xbc9a873d
	.long	0xbc34c1ec
	.long	0x3ccd9eab
	.long	0xbd39cfd2
	.long	0x3ce82422
	.long	0xbd3504d3
	.long	0xbcc0b5ae
	.long	0x3cf9ffaf
	.size	__constant_32xf32_0, 128

	.type	__constant_3xf32,@object
	.section	.rodata.__constant_3xf32,"a",@progbits
	.p2align	6, 0x0
__constant_3xf32:
	.long	0xbd46f712
	.long	0xbcdc503b
	.long	0xbb1a7082
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
	.quad	infer_dispatch_0_matmul_like_32x50176x3_f32
	.quad	infer_dispatch_1_slow_memcpy
	.quad	infer_dispatch_2_conv_64x224x224x32x3x3_f32
	.quad	infer_dispatch_3_conv_128x224x224x64x3x3_f32
	.quad	infer_dispatch_4_slow_memcpy
	.quad	infer_dispatch_5_conv_128x224x224x128x3x3_f32
	.quad	infer_dispatch_6_conv_128x224x224x128x3x3_f32
	.quad	infer_dispatch_13_elementwise_broadcast_128x112x112_f32
	.quad	infer_dispatch_14_conv_64x112x112x128x3x3_f32
	.quad	infer_dispatch_15_elementwise_broadcast_64x224x224_f32
	.quad	infer_dispatch_16_conv_32x224x224x64x3x3_f32
	.quad	infer_dispatch_17_conv_3x224x224x32x3x3_f32
	.size	iree_hal_executable_library_query_v0_funcs, 96

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
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
	.byte	2
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
	.byte	4
	.long	1
	.long	1
	.short	1
	.short	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
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
	.long	3
	.long	44
	.quad	__unnamed_14
	.long	3
	.long	44
	.quad	__unnamed_15
	.long	3
	.long	44
	.quad	__unnamed_16
	.long	3
	.long	44
	.quad	__unnamed_17
	.long	3
	.long	44
	.quad	__unnamed_18
	.long	3
	.long	44
	.quad	__unnamed_19
	.long	3
	.long	44
	.quad	__unnamed_20
	.long	3
	.long	45
	.quad	__unnamed_21
	.long	3
	.long	45
	.quad	__unnamed_22
	.long	3
	.long	45
	.quad	__unnamed_23
	.long	3
	.long	45
	.quad	__unnamed_24
	.long	3
	.long	45
	.quad	__unnamed_25
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
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 288

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.quad	iree_hal_executable_library_query_v0_header
	.zero	16
	.long	12
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
	.long	.Linfo_string14
	.long	.Linfo_string14
	.byte	1
	.byte	1
	.long	71

	.byte	3
	.long	.Linfo_string15
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
	.long	.Linfo_string16
	.long	.Linfo_string16
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
	.long	.Linfo_string17
	.long	.Linfo_string17
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
	.long	.Linfo_string18
	.long	.Linfo_string18
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
	.long	.Linfo_string19
	.long	.Linfo_string19
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
	.long	.Linfo_string20
	.long	.Linfo_string20
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
	.long	.Linfo_string21
	.long	.Linfo_string21
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
	.long	.Linfo_string22
	.long	.Linfo_string22
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
	.long	.Linfo_string23
	.long	.Linfo_string23
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
	.long	.Linfo_string24
	.long	.Linfo_string24
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
	.long	.Linfo_string25
	.long	.Linfo_string25
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
	.long	.Linfo_string26
	.long	.Linfo_string26
	.byte	12
	.byte	1
	.long	.debug_info+71

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
	.long	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.short	2
	.long	.Lcu_begin0
	.long	79
	.long	42
	.asciz	"infer_dispatch_0_matmul_like_32x50176x3_f32"
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
	.asciz	"infer_dispatch_1_slow_memcpy"
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
	.asciz	"infer_dispatch_2_conv_64x224x224x32x3x3_f32"
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
	.asciz	"infer_dispatch_3_conv_128x224x224x64x3x3_f32"
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
	.asciz	"infer_dispatch_4_slow_memcpy"
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
	.asciz	"infer_dispatch_5_conv_128x224x224x128x3x3_f32"
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
	.asciz	"infer_dispatch_6_conv_128x224x224x128x3x3_f32"
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
	.asciz	"infer_dispatch_13_elementwise_broadcast_128x112x112_f32"
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
	.asciz	"infer_dispatch_14_conv_64x112x112x128x3x3_f32"
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
	.asciz	"infer_dispatch_15_elementwise_broadcast_64x224x224_f32"
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
	.asciz	"infer_dispatch_16_conv_32x224x224x64x3x3_f32"
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
	.asciz	"infer_dispatch_17_conv_3x224x224x32x3x3_f32"
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
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
