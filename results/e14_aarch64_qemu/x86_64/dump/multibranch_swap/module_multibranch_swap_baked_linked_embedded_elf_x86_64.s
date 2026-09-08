	.att_syntax
	.file	"multibranch_swap_baked_linked"
	.section	.text.infer_dispatch_0_matmul_1x64x16_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_0_matmul_1x64x16_f32,@function
infer_dispatch_0_matmul_1x64x16_f32:
.Lfunc_begin0:
	.file	1 "results/e14_aarch64_qemu/x86_64/dump/multibranch_swap" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp0:
	.loc	1 12 8 prologue_end
	movq	32(%rsi), %rdx
	movq	(%rdx), %rax
	.loc	1 13 8
	movq	8(%rdx), %rcx
	.loc	1 14 8
	movq	16(%rdx), %rdx
	movq	$-16, %rsi
	vxorps	%xmm0, %xmm0, %xmm0
	.loc	1 0 8 is_stmt 0
.Ltmp1:
	.p2align	4
.LBB0_1:
	.loc	1 19 8 is_stmt 1
	vmovaps	33344(%rcx,%rsi,4), %zmm1
	vmovaps	33600(%rcx,%rsi,4), %zmm2
	vmovaps	33856(%rcx,%rsi,4), %zmm3
	vmovaps	34112(%rcx,%rsi,4), %zmm4
	vmovaps	34368(%rcx,%rsi,4), %zmm5
	vmovaps	34624(%rcx,%rsi,4), %zmm6
	vmovaps	34880(%rcx,%rsi,4), %zmm7
	vmovaps	35136(%rcx,%rsi,4), %zmm8
	vmovaps	35392(%rcx,%rsi,4), %zmm9
	vmovaps	35648(%rcx,%rsi,4), %zmm10
	vmovaps	35904(%rcx,%rsi,4), %zmm11
	vmovaps	36160(%rcx,%rsi,4), %zmm12
	vmovaps	36416(%rcx,%rsi,4), %zmm13
	vmovaps	36672(%rcx,%rsi,4), %zmm14
	vmovaps	36928(%rcx,%rsi,4), %zmm15
	vmovaps	37184(%rcx,%rsi,4), %zmm16
	.loc	1 1 1
	vfmadd132ps	(%rax){1to16}, %zmm0, %zmm1
	vfmadd231ps	4(%rax){1to16}, %zmm2, %zmm1
	vfmadd231ps	8(%rax){1to16}, %zmm3, %zmm1
	vfmadd231ps	12(%rax){1to16}, %zmm4, %zmm1
	vfmadd231ps	16(%rax){1to16}, %zmm5, %zmm1
	vfmadd231ps	20(%rax){1to16}, %zmm6, %zmm1
	vfmadd231ps	24(%rax){1to16}, %zmm7, %zmm1
	vfmadd231ps	28(%rax){1to16}, %zmm8, %zmm1
	vfmadd231ps	32(%rax){1to16}, %zmm9, %zmm1
	vfmadd231ps	36(%rax){1to16}, %zmm10, %zmm1
	vfmadd231ps	40(%rax){1to16}, %zmm11, %zmm1
	vfmadd231ps	44(%rax){1to16}, %zmm12, %zmm1
	vfmadd231ps	48(%rax){1to16}, %zmm13, %zmm1
	vfmadd231ps	52(%rax){1to16}, %zmm14, %zmm1
	vfmadd231ps	56(%rax){1to16}, %zmm15, %zmm1
	vfmadd231ps	60(%rax){1to16}, %zmm16, %zmm1
	.loc	1 22 10
	vcmpnleps	%zmm0, %zmm1, %k1
	vmovaps	%zmm1, %zmm1 {%k1} {z}
	.loc	1 19 8
	vmovaps	%zmm1, 64(%rdx,%rsi,4)
	addq	$16, %rsi
	cmpq	$48, %rsi
	jb	.LBB0_1
	.loc	1 26 8
	xorl	%eax, %eax
	.loc	1 26 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Ltmp2:
.Lfunc_end0:
	.size	infer_dispatch_0_matmul_1x64x16_f32, .Lfunc_end0-infer_dispatch_0_matmul_1x64x16_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_matmul_1x64x64_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_1_matmul_1x64x64_f32,@function
infer_dispatch_1_matmul_1x64x64_f32:
.Lfunc_begin1:
	.file	2 "results/e14_aarch64_qemu/x86_64/dump/multibranch_swap" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp3:
	.loc	2 13 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rax
	.loc	2 15 8
	movq	16(%rsi), %rcx
	movl	$4352, %edx
	.loc	2 20 8
	addq	8(%rsi), %rdx
	xorl	%esi, %esi
	.loc	2 0 8 is_stmt 0
.Ltmp4:
	.p2align	4
.LBB1_1:
	vxorps	%xmm0, %xmm0, %xmm0
	movq	$-16, %rdi
	movq	%rdx, %r8
	.p2align	4
.LBB1_2:
	.loc	2 20 8 is_stmt 1
	vmovaps	-3840(%r8), %zmm1
	vmovaps	-3584(%r8), %zmm2
	vmovaps	-3328(%r8), %zmm3
	vmovaps	-3072(%r8), %zmm4
	vmovaps	-2816(%r8), %zmm5
	vmovaps	-2560(%r8), %zmm6
	vmovaps	-2304(%r8), %zmm7
	vmovaps	-2048(%r8), %zmm8
	vmovaps	-1792(%r8), %zmm9
	vmovaps	-1536(%r8), %zmm10
	vmovaps	-1280(%r8), %zmm11
	vmovaps	-1024(%r8), %zmm12
	vmovaps	-768(%r8), %zmm13
	vmovaps	-512(%r8), %zmm14
	vmovaps	-256(%r8), %zmm15
	vmovaps	(%r8), %zmm16
	.loc	2 1 1
	vfmadd132ps	64(%rax,%rdi,4){1to16}, %zmm0, %zmm1
	vfmadd231ps	68(%rax,%rdi,4){1to16}, %zmm2, %zmm1
	vfmadd231ps	72(%rax,%rdi,4){1to16}, %zmm3, %zmm1
	vfmadd231ps	76(%rax,%rdi,4){1to16}, %zmm4, %zmm1
	vfmadd231ps	80(%rax,%rdi,4){1to16}, %zmm5, %zmm1
	vfmadd231ps	84(%rax,%rdi,4){1to16}, %zmm6, %zmm1
	vfmadd231ps	88(%rax,%rdi,4){1to16}, %zmm7, %zmm1
	vfmadd231ps	92(%rax,%rdi,4){1to16}, %zmm8, %zmm1
	vfmadd231ps	96(%rax,%rdi,4){1to16}, %zmm9, %zmm1
	vfmadd231ps	100(%rax,%rdi,4){1to16}, %zmm10, %zmm1
	vfmadd231ps	104(%rax,%rdi,4){1to16}, %zmm11, %zmm1
	vfmadd231ps	108(%rax,%rdi,4){1to16}, %zmm12, %zmm1
	vfmadd231ps	112(%rax,%rdi,4){1to16}, %zmm13, %zmm1
	vfmadd231ps	116(%rax,%rdi,4){1to16}, %zmm14, %zmm1
	vfmadd231ps	120(%rax,%rdi,4){1to16}, %zmm15, %zmm1
	vmovaps	%zmm1, %zmm0
	vfmadd231ps	124(%rax,%rdi,4){1to16}, %zmm16, %zmm0
	.loc	2 20 8
	addq	$16, %rdi
	addq	$4096, %r8
	cmpq	$48, %rdi
	jb	.LBB1_2
	vmovaps	%zmm0, 256(%rcx,%rsi,4)
	addq	$64, %rdx
	cmpq	$48, %rsi
	leaq	16(%rsi), %rsi
	jb	.LBB1_1
	.loc	2 22 8
	xorl	%eax, %eax
	.loc	2 22 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Ltmp5:
.Lfunc_end1:
	.size	infer_dispatch_1_matmul_1x64x64_f32, .Lfunc_end1-infer_dispatch_1_matmul_1x64x64_f32
	.cfi_endproc

	.section	.text.infer_dispatch_2_matmul_1x64x64_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_2_matmul_1x64x64_f32,@function
infer_dispatch_2_matmul_1x64x64_f32:
.Lfunc_begin2:
	.file	3 "results/e14_aarch64_qemu/x86_64/dump/multibranch_swap" "configured_module_infer_dispatch_2.mlir"
	.loc	3 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp6:
	.loc	3 14 8 prologue_end
	movq	32(%rsi), %rsi
	movq	(%rsi), %rax
	.loc	3 17 8
	movq	16(%rsi), %rcx
	movl	$20736, %edx
	.loc	3 23 8
	addq	8(%rsi), %rdx
	xorl	%esi, %esi
	vxorps	%xmm0, %xmm0, %xmm0
	.loc	3 0 8 is_stmt 0
.Ltmp7:
	.p2align	4
.LBB2_1:
	movq	$-16, %rdi
	movq	%rdx, %r8
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align	4
.LBB2_2:
	.loc	3 23 8 is_stmt 1
	vmovaps	-3840(%r8), %zmm2
	vmovaps	-3584(%r8), %zmm3
	vmovaps	-3328(%r8), %zmm4
	vmovaps	-3072(%r8), %zmm5
	vmovaps	-2816(%r8), %zmm6
	vmovaps	-2560(%r8), %zmm7
	vmovaps	-2304(%r8), %zmm8
	vmovaps	-2048(%r8), %zmm9
	vmovaps	-1792(%r8), %zmm10
	vmovaps	-1536(%r8), %zmm11
	vmovaps	-1280(%r8), %zmm12
	vmovaps	-1024(%r8), %zmm13
	vmovaps	-768(%r8), %zmm14
	vmovaps	-512(%r8), %zmm15
	vmovaps	-256(%r8), %zmm16
	vmovaps	(%r8), %zmm17
	.loc	3 1 1
	vfmadd132ps	64(%rax,%rdi,4){1to16}, %zmm1, %zmm2
	vfmadd231ps	68(%rax,%rdi,4){1to16}, %zmm3, %zmm2
	vfmadd231ps	72(%rax,%rdi,4){1to16}, %zmm4, %zmm2
	vfmadd231ps	76(%rax,%rdi,4){1to16}, %zmm5, %zmm2
	vfmadd231ps	80(%rax,%rdi,4){1to16}, %zmm6, %zmm2
	vfmadd231ps	84(%rax,%rdi,4){1to16}, %zmm7, %zmm2
	vfmadd231ps	88(%rax,%rdi,4){1to16}, %zmm8, %zmm2
	vfmadd231ps	92(%rax,%rdi,4){1to16}, %zmm9, %zmm2
	vfmadd231ps	96(%rax,%rdi,4){1to16}, %zmm10, %zmm2
	vfmadd231ps	100(%rax,%rdi,4){1to16}, %zmm11, %zmm2
	vfmadd231ps	104(%rax,%rdi,4){1to16}, %zmm12, %zmm2
	vfmadd231ps	108(%rax,%rdi,4){1to16}, %zmm13, %zmm2
	vfmadd231ps	112(%rax,%rdi,4){1to16}, %zmm14, %zmm2
	vfmadd231ps	116(%rax,%rdi,4){1to16}, %zmm15, %zmm2
	vfmadd231ps	120(%rax,%rdi,4){1to16}, %zmm16, %zmm2
	vmovaps	%zmm2, %zmm1
	vfmadd231ps	124(%rax,%rdi,4){1to16}, %zmm17, %zmm1
	.loc	3 23 8
	addq	$16, %rdi
	addq	$4096, %r8
	cmpq	$48, %rdi
	jb	.LBB2_2
	.loc	3 24 8
	vmovaps	256(%rax,%rsi,4), %zmm2
	.loc	3 26 10
	vcmpnleps	%zmm0, %zmm2, %k1
	vmovaps	%zmm2, %zmm2 {%k1} {z}
	.loc	3 27 10
	vcmpnleps	%zmm0, %zmm1, %k1
	vmovaps	%zmm1, %zmm1 {%k1} {z}
	.loc	3 28 10
	vaddps	%zmm2, %zmm1, %zmm1
	.loc	3 29 10
	vaddps	(%rax,%rsi,4), %zmm1, %zmm1
	.loc	3 23 8
	vmovaps	%zmm1, 512(%rcx,%rsi,4)
	addq	$64, %rdx
	cmpq	$48, %rsi
	leaq	16(%rsi), %rsi
	jb	.LBB2_1
	.loc	3 33 8
	xorl	%eax, %eax
	.loc	3 33 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Ltmp8:
.Lfunc_end2:
	.size	infer_dispatch_2_matmul_1x64x64_f32, .Lfunc_end2-infer_dispatch_2_matmul_1x64x64_f32
	.cfi_endproc

	.section	.text.infer_dispatch_3_matmul_1x2x64_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_3_matmul_1x2x64_f32,@function
infer_dispatch_3_matmul_1x2x64_f32:
.Lfunc_begin3:
	.file	4 "results/e14_aarch64_qemu/x86_64/dump/multibranch_swap" "configured_module_infer_dispatch_3.mlir"
	.loc	4 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp9:
	.loc	4 12 8 prologue_end
	movq	32(%rsi), %rcx
	movq	(%rcx), %rax
	.loc	4 13 8
	movq	8(%rcx), %rdx
	.loc	4 14 8
	movq	16(%rcx), %rcx
	vxorps	%xmm0, %xmm0, %xmm0
	movq	$-16, %rsi
	.loc	4 0 8 is_stmt 0
.Ltmp10:
	.p2align	4
.LBB3_1:
	.loc	4 19 8 is_stmt 1
	vmovsd	128(%rdx,%rsi,8), %xmm1
	vmovsd	136(%rdx,%rsi,8), %xmm2
	vmovsd	144(%rdx,%rsi,8), %xmm3
	vmovsd	152(%rdx,%rsi,8), %xmm4
	vmovsd	160(%rdx,%rsi,8), %xmm5
	vmovsd	168(%rdx,%rsi,8), %xmm6
	vmovsd	176(%rdx,%rsi,8), %xmm7
	vmovsd	184(%rdx,%rsi,8), %xmm8
	vmovsd	192(%rdx,%rsi,8), %xmm9
	vmovsd	200(%rdx,%rsi,8), %xmm10
	vmovsd	208(%rdx,%rsi,8), %xmm11
	vmovsd	216(%rdx,%rsi,8), %xmm12
	vmovsd	224(%rdx,%rsi,8), %xmm13
	vmovsd	232(%rdx,%rsi,8), %xmm14
	vmovsd	240(%rdx,%rsi,8), %xmm15
	vmovsd	248(%rdx,%rsi,8), %xmm16
	.loc	4 1 1
	vfmadd132ps	576(%rax,%rsi,4){1to4}, %xmm0, %xmm1
	vfmadd231ps	580(%rax,%rsi,4){1to4}, %xmm2, %xmm1
	vfmadd231ps	584(%rax,%rsi,4){1to4}, %xmm3, %xmm1
	vfmadd231ps	588(%rax,%rsi,4){1to4}, %xmm4, %xmm1
	vfmadd231ps	592(%rax,%rsi,4){1to4}, %xmm5, %xmm1
	vfmadd231ps	596(%rax,%rsi,4){1to4}, %xmm6, %xmm1
	vfmadd231ps	600(%rax,%rsi,4){1to4}, %xmm7, %xmm1
	vfmadd231ps	604(%rax,%rsi,4){1to4}, %xmm8, %xmm1
	vfmadd231ps	608(%rax,%rsi,4){1to4}, %xmm9, %xmm1
	vfmadd231ps	612(%rax,%rsi,4){1to4}, %xmm10, %xmm1
	vfmadd231ps	616(%rax,%rsi,4){1to4}, %xmm11, %xmm1
	vfmadd231ps	620(%rax,%rsi,4){1to4}, %xmm12, %xmm1
	vfmadd231ps	624(%rax,%rsi,4){1to4}, %xmm13, %xmm1
	vfmadd231ps	628(%rax,%rsi,4){1to4}, %xmm14, %xmm1
	vfmadd231ps	632(%rax,%rsi,4){1to4}, %xmm15, %xmm1
	vmovaps	%xmm1, %xmm0
	vfmadd231ps	636(%rax,%rsi,4){1to4}, %xmm16, %xmm0
	.loc	4 19 8
	addq	$16, %rsi
	cmpq	$48, %rsi
	jb	.LBB3_1
	.loc	4 1 1
	vmovlps	%xmm0, (%rcx)
	.loc	4 21 8
	xorl	%eax, %eax
	.loc	4 21 8 epilogue_begin is_stmt 0
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Ltmp11:
.Lfunc_end3:
	.size	infer_dispatch_3_matmul_1x2x64_f32, .Lfunc_end3-infer_dispatch_3_matmul_1x2x64_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin4:
	.cfi_startproc
	xorl	%eax, %eax
	cmpl	$6, %edi
	leaq	iree_hal_executable_library_query_v0(%rip), %rcx
	cmoveq	%rcx, %rax
	retq
.Lfunc_end4:
	.size	iree_hal_executable_library_query, .Lfunc_end4-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end4-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin5:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB5_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB5_5
	testw	%cx, %cx
	je	.LBB5_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	retq
.LBB5_6:
	orl	$864026624, %eax
	movzwl	%cx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB5_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	retq
.LBB5_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	retq
.Lfunc_end5:
	.size	iree_h2f_ieee, .Lfunc_end5-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin6:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB6_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB6_6
	testl	%edx, %edx
	je	.LBB6_4
	orl	$32767, %eax
	retq
.LBB6_1:
	movl	%ecx, %edi
.LBB6_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB6_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB6_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB6_9
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
.LBB6_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end6:
	.size	iree_f2h_ieee, .Lfunc_end6-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
.Lfunc_begin7:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB7_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB7_5
	testw	%cx, %cx
	je	.LBB7_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	retq
.LBB7_6:
	orl	$864026624, %eax
	movzwl	%cx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB7_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	retq
.LBB7_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	retq
.Lfunc_end7:
	.size	__gnu_h2f_ieee, .Lfunc_end7-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin8:
	.cfi_startproc
	vmovd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB8_6
	cmpl	$31744, %esi
	jne	.LBB8_5
	testw	%dx, %dx
	je	.LBB8_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	retq
.LBB8_6:
	orl	$864026624, %eax
	movzwl	%dx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB8_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	retq
.LBB8_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	retq
.Lfunc_end8:
	.size	__extendhfsf2, .Lfunc_end8-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin9:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB9_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB9_6
	testl	%edx, %edx
	je	.LBB9_4
	orl	$32767, %eax
	retq
.LBB9_1:
	movl	%ecx, %edi
.LBB9_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB9_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB9_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB9_9
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
.LBB9_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end9:
	.size	__gnu_f2h_ieee, .Lfunc_end9-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin10:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB10_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB10_6
	testl	%edx, %edx
	je	.LBB10_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.LBB10_1:
	movl	%ecx, %edi
	jmp	.LBB10_9
.LBB10_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB10_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB10_9
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
	jmp	.LBB10_9
.LBB10_4:
	movl	$31744, %edi
.LBB10_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.Lfunc_end10:
	.size	__truncsfhf2, .Lfunc_end10-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin11:
	.cfi_startproc
	vmovd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB11_6
	cmpl	$31744, %esi
	jne	.LBB11_5
	testw	%dx, %dx
	je	.LBB11_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB11_6:
	orl	$864026624, %eax
	movzwl	%dx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB11_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB11_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.Lfunc_end11:
	.size	__extendhfdf2, .Lfunc_end11-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin12:
	.cfi_startproc
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB12_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB12_6
	testl	%edx, %edx
	je	.LBB12_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.LBB12_1:
	movl	%ecx, %edi
	jmp	.LBB12_9
.LBB12_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB12_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB12_9
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
	jmp	.LBB12_9
.LBB12_4:
	movl	$31744, %edi
.LBB12_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.Lfunc_end12:
	.size	__truncdfhf2, .Lfunc_end12-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin13:
	.cfi_startproc
	vfmadd213sd	%xmm2, %xmm1, %xmm0
	retq
.Lfunc_end13:
	.size	fma, .Lfunc_end13-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin14:
	.cfi_startproc
	vsubss	%xmm0, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.Lfunc_end14:
	.size	__math_invalidf, .Lfunc_end14-__math_invalidf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI15_0:
	.long	0xf0000000
	.long	0x70000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI15_1:
	.long	0x70000000
	.section	.text.__math_oflowf,"ax",@progbits
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin15:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI15_0(%rip), %rcx
	vmovss	(%rcx,%rax,4), %xmm0
	vmovss	%xmm0, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI15_1(%rip), %xmm0, %xmm0
	retq
.Lfunc_end15:
	.size	__math_oflowf, .Lfunc_end15-__math_oflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI16_0:
	.long	0x80000000
	.section	.text.__math_xflowf,"ax",@progbits
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin16:
	.cfi_startproc
	testl	%edi, %edi
	vxorps	.LCPI16_0(%rip){1to4}, %xmm0, %xmm1
	sete	%al
	kmovd	%eax, %k1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovss	%xmm1, -4(%rsp)
	vmulss	-4(%rsp), %xmm0, %xmm0
	retq
.Lfunc_end16:
	.size	__math_xflowf, .Lfunc_end16-__math_xflowf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI17_0:
	.long	0x90000000
	.long	0x10000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI17_1:
	.long	0x10000000
	.section	.text.__math_uflowf,"ax",@progbits
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
.Lfunc_begin17:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI17_0(%rip), %rcx
	vmovss	(%rcx,%rax,4), %xmm0
	vmovss	%xmm0, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI17_1(%rip), %xmm0, %xmm0
	retq
.Lfunc_end17:
	.size	__math_uflowf, .Lfunc_end17-__math_uflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI18_0:
	.long	0x7b800000
.LCPI18_1:
	.long	0x80000000
.LCPI18_2:
	.long	0x3f800000
	.section	.text.ceilf,"ax",@progbits
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin18:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB18_7
	cmpl	$127, %ecx
	jb	.LBB18_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrxl	%ecx, %edx, %edx
	testl	%eax, %edx
	je	.LBB18_7
	vaddss	.LCPI18_0(%rip), %xmm0, %xmm0
	vmovss	%xmm0, -8(%rsp)
	xorl	%esi, %esi
	testl	%eax, %eax
	movl	$-8388608, %edi
	sarxl	%ecx, %edi, %ecx
	cmovsl	%esi, %edx
	addl	%eax, %edx
	andl	%ecx, %edx
	vmovd	%edx, %xmm0
	retq
.LBB18_4:
	vaddss	.LCPI18_0(%rip), %xmm0, %xmm1
	vmovss	%xmm1, -4(%rsp)
	testl	%eax, %eax
	js	.LBB18_5
	sete	%al
	kmovd	%eax, %k1
	vmovss	.LCPI18_2(%rip), %xmm1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovaps	%xmm1, %xmm0
.LBB18_7:
	retq
.LBB18_5:
	vmovss	.LCPI18_1(%rip), %xmm0
	retq
.Lfunc_end18:
	.size	ceilf, .Lfunc_end18-ceilf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI19_0:
	.long	0xff800000
.LCPI19_1:
	.long	0x42b17217
.LCPI19_2:
	.long	0xc2cff1b4
.LCPI19_3:
	.long	0x10000000
.LCPI19_4:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI19_5:
	.quad	0x40471547652b82fe
.LCPI19_6:
	.quad	0x4338000000000000
.LCPI19_7:
	.quad	0xc338000000000000
.LCPI19_8:
	.quad	0x3ebc6af84b912394
.LCPI19_9:
	.quad	0x3f2ebfce50fac4f3
.LCPI19_10:
	.quad	0x3f962e42ff0c52d6
.LCPI19_11:
	.quad	0x3ff0000000000000
	.section	.text.expf,"ax",@progbits
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin19:
	.cfi_startproc
	vmovd	%xmm0, %eax
	shrl	$20, %eax
	andl	$2047, %eax
	cmpl	$1067, %eax
	jae	.LBB19_1
.LBB19_8:
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	vmulsd	.LCPI19_5(%rip), %xmm0, %xmm0
	vaddsd	.LCPI19_6(%rip), %xmm0, %xmm1
	vmovq	%xmm1, %rax
	vaddsd	.LCPI19_7(%rip), %xmm1, %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	movl	%eax, %ecx
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	vmovsd	.LCPI19_8(%rip), %xmm1
	vmovq	%rax, %xmm2
	vfmadd213sd	.LCPI19_9(%rip), %xmm0, %xmm1
	vmulsd	%xmm0, %xmm0, %xmm3
	vmovsd	.LCPI19_10(%rip), %xmm4
	vfmadd213sd	.LCPI19_11(%rip), %xmm0, %xmm4
	vfmadd231sd	%xmm3, %xmm1, %xmm4
	vmulsd	%xmm2, %xmm4, %xmm0
	vcvtsd2ss	%xmm0, %xmm0, %xmm1
.LBB19_9:
	vmovaps	%xmm1, %xmm0
	retq
.LBB19_1:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	.LCPI19_0(%rip), %xmm2
	vucomiss	%xmm0, %xmm2
	jae	.LBB19_9
	cmpl	$2040, %eax
	jae	.LBB19_3
	vucomiss	.LCPI19_1(%rip), %xmm0
	jbe	.LBB19_6
	movl	$1879048192, -8(%rsp)
	vmovss	-8(%rsp), %xmm0
	vmulss	.LCPI19_4(%rip), %xmm0, %xmm0
	retq
.LBB19_3:
	vaddss	%xmm0, %xmm0, %xmm0
	retq
.LBB19_6:
	vmovss	.LCPI19_2(%rip), %xmm1
	vucomiss	%xmm0, %xmm1
	jbe	.LBB19_8
	movl	$268435456, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI19_3(%rip), %xmm0, %xmm0
	retq
.Lfunc_end19:
	.size	expf, .Lfunc_end19-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin20:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end20:
	.size	feclearexcept, .Lfunc_end20-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin21:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end21:
	.size	feraiseexcept, .Lfunc_end21-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin22:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end22:
	.size	fetestexcept, .Lfunc_end22-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin23:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end23:
	.size	fegetround, .Lfunc_end23-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin24:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end24:
	.size	__fesetround, .Lfunc_end24-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin25:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end25:
	.size	fegetenv, .Lfunc_end25-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin26:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end26:
	.size	fesetenv, .Lfunc_end26-fesetenv
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI27_0:
	.long	0x7b800000
.LCPI27_1:
	.long	0xbf800000
	.section	.text.floorf,"ax",@progbits
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin27:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB27_1
	retq
.LBB27_1:
	cmpl	$127, %ecx
	jb	.LBB27_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrxl	%ecx, %edx, %edx
	testl	%eax, %edx
	je	.LBB27_6
	vaddss	.LCPI27_0(%rip), %xmm0, %xmm0
	vmovss	%xmm0, -8(%rsp)
	movl	$-8388608, %esi
	sarxl	%ecx, %esi, %ecx
	movl	%eax, %esi
	sarl	$31, %esi
	andl	%edx, %esi
	addl	%eax, %esi
	andl	%ecx, %esi
	vmovd	%esi, %xmm0
	retq
.LBB27_4:
	vaddss	.LCPI27_0(%rip), %xmm0, %xmm1
	vmovss	%xmm1, -4(%rsp)
	vxorps	%xmm1, %xmm1, %xmm1
	testl	%eax, %eax
	jns	.LBB27_5
	vucomiss	%xmm1, %xmm0
	vmovaps	%xmm0, %xmm1
	jne	.LBB27_8
	jp	.LBB27_8
.LBB27_5:
	vmovaps	%xmm1, %xmm0
.LBB27_6:
	retq
.LBB27_8:
	vmovss	.LCPI27_1(%rip), %xmm1
	vmovaps	%xmm1, %xmm0
	retq
.Lfunc_end27:
	.size	floorf, .Lfunc_end27-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin28:
	.cfi_startproc
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm1
	vcvtss2sd	%xmm2, %xmm2, %xmm2
	vaddsd	%xmm2, %xmm1, %xmm0
	vmovq	%xmm0, %rax
	movl	%eax, %ecx
	andl	$536870911, %ecx
	cmpl	$268435456, %ecx
	setne	%cl
	movabsq	$9218868437227405312, %rdx
	andnq	%rdx, %rax, %rdx
	sete	%dl
	orb	%cl, %dl
	jne	.LBB28_4
	vsubsd	%xmm1, %xmm0, %xmm3
	vucomisd	%xmm2, %xmm3
	jne	.LBB28_3
	jp	.LBB28_3
	vsubsd	%xmm2, %xmm0, %xmm3
	vucomisd	%xmm1, %xmm3
	jne	.LBB28_3
	jp	.LBB28_3
.LBB28_4:
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
	retq
.LBB28_3:
	testq	%rax, %rax
	sets	%cl
	vucomisd	%xmm1, %xmm2
	setbe	%dl
	xorb	%cl, %dl
	vsubsd	%xmm0, %xmm1, %xmm3
	vaddsd	%xmm2, %xmm3, %xmm3
	vsubsd	%xmm0, %xmm2, %xmm0
	vaddsd	%xmm0, %xmm1, %xmm0
	kmovd	%edx, %k1
	vmovsd	%xmm3, %xmm0, %xmm0 {%k1}
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm0, %xmm1
	setbe	%dl
	xorb	%cl, %dl
	movq	%rax, %rcx
	orq	$1, %rcx
	decq	%rax
	testb	%dl, %dl
	cmovneq	%rcx, %rax
	vmovq	%rax, %xmm0
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
	retq
.Lfunc_end28:
	.size	fmaf, .Lfunc_end28-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin29:
	.cfi_startproc
	vmovd	%xmm1, %edx
	movl	%edx, %esi
	addl	%edx, %esi
	je	.LBB29_2
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	movl	%edx, %edi
	andl	$2147483647, %edi
	cmpl	$2139095041, %edi
	setb	%dil
	cmpl	$255, %ecx
	setne	%r8b
	testb	%r8b, %dil
	jne	.LBB29_3
.LBB29_2:
	vmulss	%xmm1, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.LBB29_3:
	leal	(%rax,%rax), %edi
	cmpl	%esi, %edi
	jbe	.LBB29_4
	movl	%edx, %esi
	shrl	$23, %esi
	movzbl	%sil, %edi
	testl	%ecx, %ecx
	je	.LBB29_6
	movl	%eax, %esi
	andl	$8388607, %esi
	orl	$8388608, %esi
	testl	%edi, %edi
	je	.LBB29_11
.LBB29_14:
	andl	$8388607, %edx
	orl	$8388608, %edx
	cmpl	%edi, %ecx
	jg	.LBB29_16
.LBB29_21:
	movl	%esi, %edi
	subl	%edx, %edi
	jns	.LBB29_22
	jmp	.LBB29_23
.LBB29_4:
	sete	%al
	vpxor	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	kmovd	%eax, %k1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
	retq
.LBB29_6:
	movl	%eax, %esi
	xorl	%ecx, %ecx
	shll	$9, %esi
	js	.LBB29_8
	.p2align	4
.LBB29_7:
	decl	%ecx
	addl	%esi, %esi
	jns	.LBB29_7
.LBB29_8:
	movb	$1, %sil
	subb	%cl, %sil
	shlxl	%esi, %eax, %esi
	testl	%edi, %edi
	jne	.LBB29_14
.LBB29_11:
	movl	%edx, %r8d
	xorl	%edi, %edi
	shll	$9, %r8d
	js	.LBB29_13
	.p2align	4
.LBB29_12:
	decl	%edi
	addl	%r8d, %r8d
	jns	.LBB29_12
.LBB29_13:
	movb	$1, %r8b
	subb	%dil, %r8b
	shlxl	%r8d, %edx, %edx
	cmpl	%edi, %ecx
	jg	.LBB29_16
	jmp	.LBB29_21
	.p2align	4
.LBB29_19:
	addl	%esi, %esi
	decl	%ecx
	cmpl	%edi, %ecx
	jle	.LBB29_20
.LBB29_16:
	movl	%esi, %r8d
	subl	%edx, %r8d
	js	.LBB29_19
	movl	%r8d, %esi
	jne	.LBB29_19
	jmp	.LBB29_18
.LBB29_20:
	movl	%edi, %ecx
	movl	%esi, %edi
	subl	%edx, %edi
	js	.LBB29_23
.LBB29_22:
	movl	%edi, %esi
	je	.LBB29_18
.LBB29_23:
	cmpl	$8388607, %esi
	ja	.LBB29_24
	.p2align	4
.LBB29_25:
	leal	(%rsi,%rsi), %edx
	decl	%ecx
	cmpl	$4194304, %esi
	movl	%edx, %esi
	jb	.LBB29_25
	andl	$-2147483648, %eax
	testl	%ecx, %ecx
	jle	.LBB29_28
.LBB29_27:
	addl	$-8388608, %edx
	shll	$23, %ecx
	orl	%edx, %ecx
	orl	%eax, %ecx
	vmovd	%ecx, %xmm0
	retq
.LBB29_18:
	vpxor	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB29_24:
	movl	%esi, %edx
	andl	$-2147483648, %eax
	testl	%ecx, %ecx
	jg	.LBB29_27
.LBB29_28:
	movb	$1, %sil
	subb	%cl, %sil
	shrxl	%esi, %edx, %ecx
	orl	%eax, %ecx
	vmovd	%ecx, %xmm0
	retq
.Lfunc_end29:
	.size	fmodf, .Lfunc_end29-fmodf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI30_0:
	.long	0x5f800000
	.section	.text.frexpf,"ax",@progbits
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin30:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	cmpb	$-1, %cl
	je	.LBB30_7
	movzbl	%cl, %edx
	testl	%edx, %edx
	jne	.LBB30_6
	vxorps	%xmm1, %xmm1, %xmm1
	vucomiss	%xmm1, %xmm0
	jne	.LBB30_4
	jnp	.LBB30_3
.LBB30_4:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	vmulss	.LCPI30_0(%rip), %xmm0, %xmm0
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
.LBB30_6:
	movzbl	%cl, %ecx
	addl	$-126, %ecx
	movl	%ecx, (%rdi)
	andl	$-2139095041, %eax
	orl	$1056964608, %eax
	vmovd	%eax, %xmm0
.LBB30_7:
	retq
.LBB30_3:
	xorl	%eax, %eax
	movl	%eax, (%rdi)
	retq
.Lfunc_end30:
	.size	frexpf, .Lfunc_end30-frexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI31_0:
	.long	0x0c800000
.LCPI31_1:
	.long	0x7f000000
	.section	.text.ldexpf,"ax",@progbits
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin31:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB31_4
	vmulss	.LCPI31_1(%rip), %xmm0, %xmm0
	cmpl	$255, %edi
	jb	.LBB31_2
	vmulss	.LCPI31_1(%rip), %xmm0, %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB31_8
.LBB31_4:
	cmpl	$-127, %edi
	jg	.LBB31_9
	vmulss	.LCPI31_0(%rip), %xmm0, %xmm0
	cmpl	$-229, %edi
	ja	.LBB31_6
	vmulss	.LCPI31_0(%rip), %xmm0, %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB31_8:
	movl	%eax, %edi
	jmp	.LBB31_9
.LBB31_2:
	addl	$-127, %edi
	jmp	.LBB31_9
.LBB31_6:
	addl	$102, %edi
.LBB31_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	vmovd	%edi, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.Lfunc_end31:
	.size	ldexpf, .Lfunc_end31-ldexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI32_0:
	.long	0x0c800000
.LCPI32_1:
	.long	0x7f000000
	.section	.text.scalbnf,"ax",@progbits
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin32:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB32_4
	vmulss	.LCPI32_1(%rip), %xmm0, %xmm0
	cmpl	$255, %edi
	jb	.LBB32_2
	vmulss	.LCPI32_1(%rip), %xmm0, %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB32_8
.LBB32_4:
	cmpl	$-127, %edi
	jg	.LBB32_9
	vmulss	.LCPI32_0(%rip), %xmm0, %xmm0
	cmpl	$-229, %edi
	ja	.LBB32_6
	vmulss	.LCPI32_0(%rip), %xmm0, %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB32_8:
	movl	%eax, %edi
	jmp	.LBB32_9
.LBB32_2:
	addl	$-127, %edi
	jmp	.LBB32_9
.LBB32_6:
	addl	$102, %edi
.LBB32_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	vmovd	%edi, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.Lfunc_end32:
	.size	scalbnf, .Lfunc_end32-scalbnf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI33_0:
	.long	0x3f800000
.LCPI33_1:
	.long	0x80000000
.LCPI33_2:
	.long	0x4b000000
.LCPI33_12:
	.long	0x10000000
.LCPI33_20:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI33_3:
	.quad	0xbff0000000000000
.LCPI33_4:
	.quad	0x3fd27616c9496e0b
.LCPI33_5:
	.quad	0xbfd71969a075c67a
.LCPI33_6:
	.quad	0x3fdec70a6ca7badd
.LCPI33_7:
	.quad	0xbfe7154748bef6c8
.LCPI33_8:
	.quad	0x3ff71547652ab82b
.LCPI33_9:
	.quad	0x405fffffffd1d571
.LCPI33_10:
	.quad	0xc062c00000000000
.LCPI33_11:
	.long	0x90000000
	.long	0x10000000
.LCPI33_13:
	.quad	0x42e8000000000000
.LCPI33_14:
	.quad	0xc2e8000000000000
.LCPI33_15:
	.quad	0x3fac6af84b912394
.LCPI33_16:
	.quad	0x3fcebfce50fac4f3
.LCPI33_17:
	.quad	0x3fe62e42ff0c52d6
.LCPI33_18:
	.quad	0x3ff0000000000000
.LCPI33_19:
	.long	0xf0000000
	.long	0x70000000
	.section	.text.powf,"ax",@progbits
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin33:
	.cfi_startproc
	vmovd	%xmm0, %edx
	vmovd	%xmm1, %ecx
	leal	-2139095040(%rdx), %eax
	cmpl	$-2130706432, %eax
	jb	.LBB33_2
	xorl	%eax, %eax
	leal	16777216(,%rcx,2), %esi
	cmpl	$16777216, %esi
	jbe	.LBB33_2
.LBB33_24:
	leal	-1060306944(%rdx), %ecx
	movl	%ecx, %esi
	andl	$-8388608, %esi
	subl	%esi, %edx
	movl	%ecx, %esi
	sarl	$23, %esi
	shrl	$15, %ecx
	andl	$240, %ecx
	leaq	__powf_log2_data(%rip), %rdi
	vmovsd	(%rcx,%rdi), %xmm0
	vmovd	%edx, %xmm2
	vcvtss2sd	%xmm2, %xmm2, %xmm2
	vfmadd213sd	.LCPI33_3(%rip), %xmm0, %xmm2
	vcvtsi2sd	%esi, %xmm15, %xmm0
	vaddsd	8(%rcx,%rdi), %xmm0, %xmm0
	vmovsd	.LCPI33_4(%rip), %xmm3
	vfmadd213sd	.LCPI33_5(%rip), %xmm2, %xmm3
	vmulsd	%xmm2, %xmm2, %xmm4
	vmovsd	.LCPI33_6(%rip), %xmm5
	vfmadd213sd	.LCPI33_7(%rip), %xmm2, %xmm5
	vmulsd	%xmm4, %xmm4, %xmm6
	vfmadd231sd	.LCPI33_8(%rip), %xmm2, %xmm0
	vfmadd231sd	%xmm5, %xmm4, %xmm0
	vfmadd231sd	%xmm6, %xmm3, %xmm0
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm0
	vmovq	%xmm0, %rcx
	movabsq	$9223231299366420480, %rdx
	andq	%rcx, %rdx
	movabsq	$4638426141214900225, %rcx
	cmpq	%rcx, %rdx
	jae	.LBB33_25
.LBB33_29:
	vaddsd	.LCPI33_13(%rip), %xmm0, %xmm1
	vmovq	%xmm1, %rcx
	vaddsd	.LCPI33_14(%rip), %xmm1, %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	addl	%ecx, %eax
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	vmovsd	.LCPI33_15(%rip), %xmm1
	vmovq	%rax, %xmm2
	vfmadd213sd	.LCPI33_16(%rip), %xmm0, %xmm1
	vmulsd	%xmm0, %xmm0, %xmm3
	vmovsd	.LCPI33_17(%rip), %xmm4
	vfmadd213sd	.LCPI33_18(%rip), %xmm0, %xmm4
	vfmadd231sd	%xmm3, %xmm1, %xmm4
	vmulsd	%xmm2, %xmm4, %xmm0
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
.LBB33_30:
	retq
.LBB33_2:
	leal	(%rcx,%rcx), %eax
	leal	-1(%rax), %esi
	cmpl	$-16777217, %esi
	jae	.LBB33_3
	leal	-1(,%rdx,2), %eax
	cmpl	$-16777217, %eax
	jae	.LBB33_10
	xorl	%eax, %eax
	testl	%edx, %edx
	js	.LBB33_16
	cmpl	$8388607, %edx
	ja	.LBB33_24
.LBB33_23:
	vmulss	.LCPI33_2(%rip), %xmm0, %xmm0
	vmovd	%xmm0, %edx
	andl	$2147483647, %edx
	addl	$-192937984, %edx
	jmp	.LBB33_24
.LBB33_25:
	vucomisd	.LCPI33_9(%rip), %xmm0
	jbe	.LBB33_27
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI33_19(%rip), %rax
	vmovss	(%rax,%rcx,4), %xmm0
	vmovss	%xmm0, -8(%rsp)
	vmovss	-8(%rsp), %xmm0
	vmulss	.LCPI33_20(%rip), %xmm0, %xmm0
	retq
.LBB33_16:
	movl	%ecx, %eax
	shrl	$23, %eax
	movzbl	%al, %edx
	cmpl	$127, %edx
	jb	.LBB33_31
	cmpl	$150, %edx
	jbe	.LBB33_18
.LBB33_20:
	xorl	%eax, %eax
.LBB33_21:
	vmovd	%xmm0, %edx
	andl	$2147483647, %edx
	cmpl	$8388607, %edx
	ja	.LBB33_24
	jmp	.LBB33_23
.LBB33_27:
	vmovsd	.LCPI33_10(%rip), %xmm1
	vucomisd	%xmm0, %xmm1
	jb	.LBB33_29
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI33_11(%rip), %rax
	vmovss	(%rax,%rcx,4), %xmm0
	vmovss	%xmm0, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI33_12(%rip), %xmm0, %xmm0
	retq
.LBB33_18:
	movb	$-106, %dl
	subb	%al, %dl
	bzhil	%edx, %ecx, %eax
	je	.LBB33_19
.LBB33_31:
	vsubss	%xmm0, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.LBB33_19:
	movl	$1, %eax
	shlxl	%edx, %eax, %edx
	movl	$65536, %eax
	testl	%ecx, %edx
	jne	.LBB33_21
	jmp	.LBB33_20
.LBB33_3:
	vmovdqa	%xmm0, %xmm2
	vmovss	.LCPI33_0(%rip), %xmm0
	cmpl	$1065353216, %edx
	je	.LBB33_30
	testl	%eax, %eax
	je	.LBB33_30
	addl	%edx, %edx
	cmpl	$-16777215, %edx
	setb	%sil
	cmpl	$-16777215, %eax
	setb	%al
	testb	%al, %sil
	jne	.LBB33_7
	vaddss	%xmm1, %xmm2, %xmm0
	retq
.LBB33_10:
	vmulss	%xmm0, %xmm0, %xmm0
	testl	%edx, %edx
	jns	.LBB33_13
	movl	%ecx, %eax
	shrl	$23, %eax
	movzbl	%al, %edx
	addl	$-151, %edx
	cmpl	$-24, %edx
	jb	.LBB33_13
	movb	$-106, %dl
	subb	%al, %dl
	bzhil	%edx, %ecx, %eax
	setne	%al
	movzbl	%dl, %edx
	btl	%edx, %ecx
	setae	%dl
	vxorps	.LCPI33_1(%rip){1to4}, %xmm0, %xmm1
	kmovd	%edx, %k1
	kmovd	%eax, %k2
	vmovss	%xmm0, %xmm1, %xmm1 {%k2}
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovaps	%xmm1, %xmm0
.LBB33_13:
	testl	%ecx, %ecx
	jns	.LBB33_30
	vmovss	.LCPI33_0(%rip), %xmm1
	vdivss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, -12(%rsp)
	vmovss	-12(%rsp), %xmm0
	retq
.LBB33_7:
	cmpl	$2130706432, %edx
	je	.LBB33_30
	setb	%al
	testl	%ecx, %ecx
	sets	%cl
	xorb	%al, %cl
	vmulss	%xmm1, %xmm1, %xmm0
	kmovd	%ecx, %k1
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
	retq
.Lfunc_end33:
	.size	powf, .Lfunc_end33-powf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI34_0:
	.long	0xcb000000
.LCPI34_1:
	.long	0x4b000000
.LCPI34_2:
	.long	0x80000000
	.section	.text.rintf,"ax",@progbits
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin34:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	andl	$2130706432, %ecx
	cmpl	$1249902592, %ecx
	ja	.LBB34_4
	testl	%eax, %eax
	setns	%cl
	vmovss	.LCPI34_0(%rip), %xmm2
	vaddss	%xmm2, %xmm0, %xmm1
	vmovss	.LCPI34_1(%rip), %xmm3
	vaddss	%xmm3, %xmm1, %xmm1
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	kmovd	%ecx, %k1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vxorps	%xmm0, %xmm0, %xmm0
	vucomiss	%xmm0, %xmm1
	jne	.LBB34_2
	jp	.LBB34_2
	testl	%eax, %eax
	setns	%al
	kmovd	%eax, %k1
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	.LCPI34_2(%rip), %xmm0
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
.LBB34_4:
	retq
.LBB34_2:
	vmovaps	%xmm1, %xmm0
	retq
.Lfunc_end34:
	.size	rintf, .Lfunc_end34-rintf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI35_0:
	.long	0x7fffffff
.LCPI35_1:
	.long	0x4b000000
.LCPI35_2:
	.long	0xcb000000
.LCPI35_3:
	.long	0x3f000000
.LCPI35_4:
	.long	0xbf000000
.LCPI35_5:
	.long	0x3f800000
.LCPI35_6:
	.long	0xbf800000
.LCPI35_7:
	.long	0x80000000
	.section	.text.roundf,"ax",@progbits
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin35:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB35_8
	vpandd	.LCPI35_0(%rip){1to4}, %xmm0, %xmm1
	vaddss	.LCPI35_1(%rip), %xmm1, %xmm2
	cmpl	$125, %ecx
	ja	.LBB35_3
	vmovss	%xmm2, -4(%rsp)
	vxorps	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB35_3:
	vaddss	.LCPI35_2(%rip), %xmm2, %xmm0
	vsubss	%xmm1, %xmm0, %xmm0
	vucomiss	.LCPI35_3(%rip), %xmm0
	jbe	.LBB35_5
	vaddss	%xmm0, %xmm1, %xmm0
	vaddss	.LCPI35_6(%rip), %xmm0, %xmm0
	jmp	.LBB35_7
.LBB35_5:
	vmovss	.LCPI35_4(%rip), %xmm2
	vucomiss	%xmm0, %xmm2
	vaddss	%xmm0, %xmm1, %xmm0
	jb	.LBB35_7
	vaddss	.LCPI35_5(%rip), %xmm0, %xmm0
.LBB35_7:
	vxorps	.LCPI35_7(%rip){1to4}, %xmm0, %xmm1
	testl	%eax, %eax
	sets	%al
	kmovd	%eax, %k1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
.LBB35_8:
	retq
.Lfunc_end35:
	.size	roundf, .Lfunc_end35-roundf
	.cfi_endproc

	.type	__unnamed_1,@object
	.section	.rodata.__unnamed_1,"a",@progbits
__unnamed_1:
	.asciz	"multibranch_swap_baked_linked"
	.size	__unnamed_1, 30

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
	.quad	infer_dispatch_0_matmul_1x64x16_f32
	.quad	infer_dispatch_1_matmul_1x64x64_f32
	.quad	infer_dispatch_2_matmul_1x64x64_f32
	.quad	infer_dispatch_3_matmul_1x2x64_f32
	.size	iree_hal_executable_library_query_v0_funcs, 32

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
	.size	iree_hal_executable_library_query_v0_attrs, 256

	.type	__unnamed_2,@object
	.section	.rodata.__unnamed_2,"a",@progbits
__unnamed_2:
	.asciz	"infer_dispatch_0_matmul_1x64x16_f32"
	.size	__unnamed_2, 36

	.type	__unnamed_3,@object
	.section	.rodata.__unnamed_3,"a",@progbits
__unnamed_3:
	.asciz	"infer_dispatch_1_matmul_1x64x64_f32"
	.size	__unnamed_3, 36

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"infer_dispatch_2_matmul_1x64x64_f32"
	.size	__unnamed_4, 36

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"infer_dispatch_3_matmul_1x2x64_f32"
	.size	__unnamed_5, 35

	.type	iree_hal_executable_library_query_v0_names,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_names,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_names:
	.quad	__unnamed_2
	.quad	__unnamed_3
	.quad	__unnamed_4
	.quad	__unnamed_5
	.size	iree_hal_executable_library_query_v0_names, 32

	.type	__unnamed_6,@object
	.section	.rodata.__unnamed_6,"a",@progbits
__unnamed_6:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/multibranch_swap/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_6, 94

	.type	__unnamed_7,@object
	.section	.rodata.__unnamed_7,"a",@progbits
__unnamed_7:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/multibranch_swap/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_7, 94

	.type	__unnamed_8,@object
	.section	.rodata.__unnamed_8,"a",@progbits
__unnamed_8:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/multibranch_swap/configured_module_infer_dispatch_2.mlir"
	.size	__unnamed_8, 94

	.type	__unnamed_9,@object
	.section	.rodata.__unnamed_9,"a",@progbits
__unnamed_9:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/multibranch_swap/configured_module_infer_dispatch_3.mlir"
	.size	__unnamed_9, 94

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.long	3
	.long	93
	.quad	__unnamed_6
	.long	3
	.long	93
	.quad	__unnamed_7
	.long	3
	.long	93
	.quad	__unnamed_8
	.long	3
	.long	93
	.quad	__unnamed_9
	.size	iree_hal_executable_library_query_v0_source_locations, 64

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names, 0

	.type	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations,@object
	.section	.rodata.iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations,"a",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations:
	.size	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations, 0

	.type	iree_hal_executable_library_query_v0_stage_location_tables,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_stage_location_tables,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_stage_location_tables:
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 96

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.quad	iree_hal_executable_library_query_v0_header
	.zero	16
	.long	4
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
	.long	.Linfo_string6
	.long	.Linfo_string6
	.byte	1
	.byte	1
	.long	71

	.byte	3
	.long	.Linfo_string7
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
	.long	.Linfo_string8
	.long	.Linfo_string8
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
	.long	.Linfo_string9
	.long	.Linfo_string9
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
	.long	.Linfo_string10
	.long	.Linfo_string10
	.byte	4
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end3:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"IREE"
.Linfo_string1:
	.asciz	"configured_module_infer_dispatch_0.mlir"
.Linfo_string2:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/multibranch_swap"
.Linfo_string3:
	.asciz	"configured_module_infer_dispatch_1.mlir"
.Linfo_string4:
	.asciz	"configured_module_infer_dispatch_2.mlir"
.Linfo_string5:
	.asciz	"configured_module_infer_dispatch_3.mlir"
.Linfo_string6:
	.asciz	"infer_dispatch_0_matmul_1x64x16_f32"
.Linfo_string7:
	.asciz	"int"
.Linfo_string8:
	.asciz	"infer_dispatch_1_matmul_1x64x64_f32"
.Linfo_string9:
	.asciz	"infer_dispatch_2_matmul_1x64x64_f32"
.Linfo_string10:
	.asciz	"infer_dispatch_3_matmul_1x2x64_f32"
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.short	2
	.long	.Lcu_begin0
	.long	79
	.long	42
	.asciz	"infer_dispatch_0_matmul_1x64x16_f32"
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
	.asciz	"infer_dispatch_1_matmul_1x64x64_f32"
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
	.asciz	"infer_dispatch_2_matmul_1x64x64_f32"
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
	.asciz	"infer_dispatch_3_matmul_1x2x64_f32"
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
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
