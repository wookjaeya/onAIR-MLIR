	.att_syntax
	.file	"dyn_batch_mlp_linked"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_0:
	.long	1
.LCPI0_1:
	.long	2
.LCPI0_2:
	.long	3
.LCPI0_3:
	.long	4
.LCPI0_4:
	.long	5
.LCPI0_5:
	.long	6
.LCPI0_6:
	.long	7
.LCPI0_7:
	.long	8
	.section	.text.infer_dispatch_0_matmul_Dx64x9_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_0_matmul_Dx64x9_f32,@function
infer_dispatch_0_matmul_Dx64x9_f32:
.Lfunc_begin0:
	.file	1 "results/e14_aarch64_qemu/x86_64/dump/dynamic" "configured_module_infer_dispatch_0.mlir"
	.loc	1 1 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp0:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$3328, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.loc	1 12 8 prologue_end
	movq	24(%rsi), %rax
	movq	(%rax), %rcx
	.loc	1 28 8
	movl	(%rdx), %eax
	movq	%rax, %rdx
	shlq	$6, %rdx
	movq	%rdx, 56(%rsp)
	subq	%rdx, %rcx
	cmpq	$64, %rcx
	movl	$64, %edx
	cmovlq	%rcx, %rdx
	testq	%rcx, %rcx
	jle	.LBB0_5
	.loc	1 0 0 is_stmt 0
	movq	32(%rsi), %rcx
	movq	(%rcx), %rsi
	movq	%rsi, 40(%rsp)
	movq	8(%rcx), %rsi
	movq	16(%rcx), %rcx
	.loc	1 28 8
	shlq	$14, %rax
	leaq	(%rax,%rcx), %rdi
	addq	$1792, %rdi
	xorl	%ecx, %ecx
	movw	$511, %ax
	kmovd	%eax, %k0
	vxorps	%xmm8, %xmm8, %xmm8
	movq	%rdx, 48(%rsp)
	movl	$511, %r9d
	.loc	1 0 8
.Ltmp1:
	.p2align	4
.LBB0_2:
	movq	%rcx, 32(%rsp)
	.loc	1 27 8 is_stmt 1
	movq	%rdx, %rax
	subq	%rcx, %rax
	.loc	1 28 8
	movl	$0, %ecx
	cmovgl	%r9d, %ecx
	movl	%ecx, 12(%rsp)
	.loc	1 27 8
	xorl	%ecx, %ecx
	testq	%rax, %rax
	setg	%cl
	negl	%ecx
	kmovd	%ecx, %k1
	kmovw	%k1, 10(%rsp)
	xorl	%r12d, %r12d
	cmpq	$8, %rax
	setge	%r12b
	.loc	1 28 8
	movl	$0, %ecx
	cmovgel	%r9d, %ecx
	movl	%ecx, 24(%rsp)
	.loc	1 27 8
	xorl	%r14d, %r14d
	cmpq	$7, %rax
	setge	%r14b
	.loc	1 28 8
	movl	$0, %ecx
	cmovgel	%r9d, %ecx
	movl	%ecx, 128(%rsp)
	.loc	1 27 8
	xorl	%edx, %edx
	cmpq	$6, %rax
	setge	%dl
	.loc	1 28 8
	movl	$0, %ecx
	cmovgel	%r9d, %ecx
	movl	%ecx, 64(%rsp)
	.loc	1 27 8
	xorl	%r8d, %r8d
	cmpq	$5, %rax
	setge	%r8b
	.loc	1 28 8
	movl	$0, %r13d
	cmovgel	%r9d, %r13d
	.loc	1 27 8
	xorl	%r11d, %r11d
	cmpq	$4, %rax
	setge	%r11b
	.loc	1 28 8
	movl	$0, %r10d
	cmovgel	%r9d, %r10d
	.loc	1 27 8
	xorl	%ebx, %ebx
	cmpq	$3, %rax
	setge	%bl
	.loc	1 28 8
	movl	$0, %ecx
	cmovgel	%r9d, %ecx
	.loc	1 27 8
	xorl	%r15d, %r15d
	cmpq	$2, %rax
	setge	%r15b
	.loc	1 28 8
	movl	$0, %eax
	cmovgel	%r9d, %eax
	.loc	1 27 8
	negl	%r15d
	kmovd	%r15d, %k1
	kmovw	%k1, 22(%rsp)
	negl	%ebx
	kmovd	%ebx, %k1
	kmovw	%k1, 30(%rsp)
	negl	%r11d
	kmovd	%r11d, %k1
	kmovw	%k1, 8(%rsp)
	negl	%r8d
	kmovd	%r8d, %k1
	kmovw	%k1, 20(%rsp)
	negl	%edx
	kmovd	%edx, %k1
	kmovw	%k1, 18(%rsp)
	movl	12(%rsp), %edx
	.loc	1 28 8
	kmovd	%edx, %k1
	kandw	%k0, %k1, %k1
	kmovd	%eax, %k7
	movq	56(%rsp), %rdx
	movq	32(%rsp), %rax
	addq	%rdx, %rax
	leaq	(%rax,%rax,8), %rax
	movq	40(%rsp), %r8
	vmovups	(%r8,%rax,4), %zmm2 {%k1} {z}
	kandw	%k0, %k7, %k1
	kmovd	%ecx, %k7
	movq	32(%rsp), %rax
	leaq	1(%rax,%rdx), %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm3 {%k1} {z}
	kandw	%k0, %k7, %k1
	kmovd	%r10d, %k7
	movq	32(%rsp), %rcx
	leaq	2(%rcx,%rdx), %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm5 {%k1} {z}
	kandw	%k0, %k7, %k1
	kmovd	%r13d, %k7
	kandw	%k0, %k7, %k7
	leaq	3(%rcx,%rdx), %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm4 {%k1} {z}
	leaq	(%rcx,%rdx), %rax
	addq	$4, %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm1 {%k7} {z}
	.loc	1 27 8
	negl	%r14d
	kmovd	%r14d, %k1
	kmovw	%k1, 12(%rsp)
	movl	64(%rsp), %eax
	.loc	1 28 8
	kmovd	%eax, %k1
	kandw	%k0, %k1, %k1
	leaq	5(%rcx,%rdx), %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm0 {%k1} {z}
	movl	128(%rsp), %eax
	kmovd	%eax, %k1
	kandw	%k0, %k1, %k1
	leaq	6(%rcx,%rdx), %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm9 {%k1} {z}
	movl	24(%rsp), %eax
	kmovd	%eax, %k1
	kandw	%k0, %k1, %k1
	leaq	(%rcx,%rdx), %rax
	addq	$7, %rax
	leaq	(%rax,%rax,8), %rax
	vmovups	(%r8,%rax,4), %zmm18 {%k1} {z}
	.loc	1 27 8
	negl	%r12d
	kmovd	%r12d, %k1
	kmovw	%k1, 24(%rsp)
	vbroadcastss	%xmm2, %zmm6
	vmovaps	%zmm6, 128(%rsp)
	vbroadcastss	%xmm3, %zmm6
	vmovaps	%zmm6, 64(%rsp)
	vbroadcastss	%xmm5, %zmm6
	vmovaps	%zmm6, 3200(%rsp)
	vbroadcastss	.LCPI0_0(%rip), %zmm11
	vpermps	%zmm2, %zmm11, %zmm6
	vmovaps	%zmm6, 3136(%rsp)
	vpermps	%zmm3, %zmm11, %zmm6
	vmovaps	%zmm6, 3072(%rsp)
	vpermps	%zmm5, %zmm11, %zmm6
	vmovaps	%zmm6, 3008(%rsp)
	vbroadcastss	.LCPI0_1(%rip), %zmm12
	vpermps	%zmm2, %zmm12, %zmm6
	vmovaps	%zmm6, 2944(%rsp)
	vpermps	%zmm3, %zmm12, %zmm6
	vmovaps	%zmm6, 2880(%rsp)
	vpermps	%zmm5, %zmm12, %zmm6
	vmovaps	%zmm6, 2816(%rsp)
	vbroadcastss	.LCPI0_2(%rip), %zmm13
	vpermps	%zmm2, %zmm13, %zmm6
	vmovaps	%zmm6, 2752(%rsp)
	vpermps	%zmm3, %zmm13, %zmm6
	vmovaps	%zmm6, 2688(%rsp)
	vpermps	%zmm5, %zmm13, %zmm6
	vmovaps	%zmm6, 2624(%rsp)
	vbroadcastss	.LCPI0_3(%rip), %zmm14
	vpermps	%zmm2, %zmm14, %zmm6
	vmovaps	%zmm6, 2560(%rsp)
	vpermps	%zmm3, %zmm14, %zmm6
	vmovaps	%zmm6, 2496(%rsp)
	vpermps	%zmm5, %zmm14, %zmm6
	vmovaps	%zmm6, 2432(%rsp)
	vbroadcastss	.LCPI0_4(%rip), %zmm15
	vpermps	%zmm2, %zmm15, %zmm6
	vmovaps	%zmm6, 2368(%rsp)
	vpermps	%zmm3, %zmm15, %zmm6
	vmovaps	%zmm6, 2304(%rsp)
	vpermps	%zmm5, %zmm15, %zmm6
	vmovaps	%zmm6, 2240(%rsp)
	vbroadcastss	.LCPI0_5(%rip), %zmm16
	vpermps	%zmm2, %zmm16, %zmm6
	vmovaps	%zmm6, 2176(%rsp)
	vpermps	%zmm3, %zmm16, %zmm6
	vmovaps	%zmm6, 2112(%rsp)
	vpermps	%zmm5, %zmm16, %zmm6
	vmovaps	%zmm6, 2048(%rsp)
	vbroadcastss	.LCPI0_6(%rip), %zmm17
	vpermps	%zmm2, %zmm17, %zmm6
	vmovaps	%zmm6, 1984(%rsp)
	vpermps	%zmm3, %zmm17, %zmm6
	vmovaps	%zmm6, 1920(%rsp)
	vpermps	%zmm5, %zmm17, %zmm6
	vmovaps	%zmm6, 1856(%rsp)
	vbroadcastss	.LCPI0_7(%rip), %zmm19
	vpermps	%zmm2, %zmm19, %zmm2
	vmovaps	%zmm2, 1792(%rsp)
	vpermps	%zmm3, %zmm19, %zmm2
	vmovaps	%zmm2, 1728(%rsp)
	vpermps	%zmm5, %zmm19, %zmm2
	vmovaps	%zmm2, 1664(%rsp)
	vbroadcastss	%xmm4, %zmm2
	vmovaps	%zmm2, 1600(%rsp)
	vpermps	%zmm4, %zmm11, %zmm2
	vmovaps	%zmm2, 1536(%rsp)
	vpermps	%zmm4, %zmm12, %zmm2
	vmovaps	%zmm2, 1472(%rsp)
	vpermps	%zmm4, %zmm13, %zmm2
	vmovaps	%zmm2, 1408(%rsp)
	vpermps	%zmm4, %zmm14, %zmm2
	vmovaps	%zmm2, 1344(%rsp)
	vpermps	%zmm4, %zmm15, %zmm2
	vmovaps	%zmm2, 1280(%rsp)
	vpermps	%zmm4, %zmm16, %zmm2
	vmovaps	%zmm2, 1216(%rsp)
	vpermps	%zmm4, %zmm17, %zmm2
	vmovaps	%zmm2, 1152(%rsp)
	vpermps	%zmm4, %zmm19, %zmm2
	vmovaps	%zmm2, 1088(%rsp)
	vbroadcastss	%xmm1, %zmm2
	vmovaps	%zmm2, 1024(%rsp)
	vpermps	%zmm1, %zmm11, %zmm2
	vmovaps	%zmm2, 960(%rsp)
	vpermps	%zmm1, %zmm12, %zmm2
	vmovaps	%zmm2, 896(%rsp)
	vpermps	%zmm1, %zmm13, %zmm2
	vmovaps	%zmm2, 832(%rsp)
	vpermps	%zmm1, %zmm14, %zmm2
	vmovaps	%zmm2, 768(%rsp)
	vpermps	%zmm1, %zmm15, %zmm2
	vmovaps	%zmm2, 704(%rsp)
	vpermps	%zmm1, %zmm16, %zmm2
	vmovaps	%zmm2, 640(%rsp)
	vpermps	%zmm1, %zmm17, %zmm2
	vmovaps	%zmm2, 576(%rsp)
	vpermps	%zmm1, %zmm19, %zmm1
	vmovaps	%zmm1, 512(%rsp)
	vbroadcastss	%xmm0, %zmm1
	vmovaps	%zmm1, 448(%rsp)
	vpermps	%zmm0, %zmm11, %zmm1
	vmovaps	%zmm1, 384(%rsp)
	vpermps	%zmm0, %zmm12, %zmm1
	vmovaps	%zmm1, 320(%rsp)
	vpermps	%zmm0, %zmm13, %zmm1
	vmovaps	%zmm1, 256(%rsp)
	vpermps	%zmm0, %zmm14, %zmm1
	vmovaps	%zmm1, 192(%rsp)
	vpermps	%zmm0, %zmm15, %zmm28
	vpermps	%zmm0, %zmm16, %zmm29
	vpermps	%zmm0, %zmm17, %zmm30
	vpermps	%zmm0, %zmm19, %zmm31
	vbroadcastss	%xmm9, %zmm0
	vpermps	%zmm9, %zmm11, %zmm1
	vpermps	%zmm9, %zmm12, %zmm2
	vpermps	%zmm9, %zmm13, %zmm3
	vpermps	%zmm9, %zmm14, %zmm4
	vpermps	%zmm9, %zmm15, %zmm5
	vpermps	%zmm9, %zmm16, %zmm6
	vpermps	%zmm9, %zmm17, %zmm7
	vpermps	%zmm9, %zmm19, %zmm9
	vbroadcastss	%xmm18, %zmm10
	vpermps	%zmm18, %zmm11, %zmm11
	vpermps	%zmm18, %zmm12, %zmm12
	vpermps	%zmm18, %zmm13, %zmm13
	vpermps	%zmm18, %zmm14, %zmm14
	vpermps	%zmm18, %zmm15, %zmm15
	vpermps	%zmm18, %zmm16, %zmm16
	vpermps	%zmm18, %zmm17, %zmm17
	vpermps	%zmm18, %zmm19, %zmm18
	movq	$-16, %r10
	.loc	1 0 8 is_stmt 0
.Ltmp2:
	.p2align	4
.LBB0_3:
	kmovw	10(%rsp), %k2
	.loc	1 10 8 is_stmt 1
	vmovaps	%zmm8, -1728(%rdi,%r10,4) {%k2}
	kmovw	22(%rsp), %k7
	vmovaps	%zmm8, -1472(%rdi,%r10,4) {%k7}
	kmovw	30(%rsp), %k4
	vmovaps	%zmm8, -1216(%rdi,%r10,4) {%k4}
	kmovw	8(%rsp), %k3
	vmovaps	%zmm8, -960(%rdi,%r10,4) {%k3}
	kmovw	20(%rsp), %k5
	vmovaps	%zmm8, -704(%rdi,%r10,4) {%k5}
	kmovw	18(%rsp), %k6
	vmovaps	%zmm8, -448(%rdi,%r10,4) {%k6}
	kmovw	12(%rsp), %k1
	vmovaps	%zmm8, -192(%rdi,%r10,4) {%k1}
	kmovw	24(%rsp), %k1
	vmovaps	%zmm8, 64(%rdi,%r10,4) {%k1}
	.loc	1 28 8
	vmovaps	64(%rsi,%r10,4), %zmm19
	vmovaps	320(%rsi,%r10,4), %zmm27
	.loc	1 1 1
	vmovaps	%zmm19, %zmm20
	vfmadd132ps	128(%rsp), %zmm8, %zmm20 {%k2} {z}
	vmovaps	%zmm19, %zmm21
	vfmadd132ps	64(%rsp), %zmm8, %zmm21 {%k7} {z}
	vmovaps	%zmm19, %zmm22
	vfmadd132ps	3200(%rsp), %zmm8, %zmm22 {%k4} {z}
	vmovaps	%zmm19, %zmm23
	vfmadd132ps	1600(%rsp), %zmm8, %zmm23 {%k3} {z}
	vmovaps	%zmm19, %zmm24
	vfmadd132ps	1024(%rsp), %zmm8, %zmm24 {%k5} {z}
	vmovaps	%zmm19, %zmm25
	vfmadd132ps	448(%rsp), %zmm8, %zmm25 {%k6} {z}
	vmovaps	%zmm19, %zmm26
	kmovw	12(%rsp), %k1
	vfmadd213ps	%zmm8, %zmm0, %zmm26 {%k1} {z}
	kmovw	24(%rsp), %k3
	vfmadd213ps	%zmm8, %zmm10, %zmm19 {%k3} {z}
	vfmadd231ps	3136(%rsp), %zmm27, %zmm20 {%k2} {z}
	vfmadd231ps	3072(%rsp), %zmm27, %zmm21 {%k7} {z}
	vfmadd231ps	3008(%rsp), %zmm27, %zmm22 {%k4} {z}
	kmovq	%k4, %k7
	kmovw	8(%rsp), %k2
	vfmadd231ps	1536(%rsp), %zmm27, %zmm23 {%k2} {z}
	vfmadd231ps	960(%rsp), %zmm27, %zmm24 {%k5} {z}
	vfmadd231ps	384(%rsp), %zmm27, %zmm25 {%k6} {z}
	vfmadd231ps	%zmm27, %zmm1, %zmm26 {%k1} {z}
	kmovq	%k1, %k5
	kmovq	%k3, %k1
	vfmadd231ps	%zmm27, %zmm11, %zmm19 {%k3} {z}
	.loc	1 28 8
	vmovaps	576(%rsi,%r10,4), %zmm27
	kmovw	10(%rsp), %k4
	.loc	1 1 1
	vfmadd231ps	2944(%rsp), %zmm27, %zmm20 {%k4} {z}
	kmovw	22(%rsp), %k3
	vfmadd231ps	2880(%rsp), %zmm27, %zmm21 {%k3} {z}
	vfmadd231ps	2816(%rsp), %zmm27, %zmm22 {%k7} {z}
	vfmadd231ps	1472(%rsp), %zmm27, %zmm23 {%k2} {z}
	kmovq	%k2, %k6
	kmovw	20(%rsp), %k2
	vfmadd231ps	896(%rsp), %zmm27, %zmm24 {%k2} {z}
	kmovw	18(%rsp), %k7
	vfmadd231ps	320(%rsp), %zmm27, %zmm25 {%k7} {z}
	vfmadd231ps	%zmm27, %zmm2, %zmm26 {%k5} {z}
	vfmadd231ps	%zmm27, %zmm12, %zmm19 {%k1} {z}
	.loc	1 28 8
	vmovaps	832(%rsi,%r10,4), %zmm27
	.loc	1 1 1
	vfmadd231ps	2752(%rsp), %zmm27, %zmm20 {%k4} {z}
	vfmadd231ps	2688(%rsp), %zmm27, %zmm21 {%k3} {z}
	kmovq	%k3, %k5
	kmovw	30(%rsp), %k7
	vfmadd231ps	2624(%rsp), %zmm27, %zmm22 {%k7} {z}
	vfmadd231ps	1408(%rsp), %zmm27, %zmm23 {%k6} {z}
	vfmadd231ps	832(%rsp), %zmm27, %zmm24 {%k2} {z}
	kmovw	18(%rsp), %k2
	vfmadd231ps	256(%rsp), %zmm27, %zmm25 {%k2} {z}
	kmovw	12(%rsp), %k1
	vfmadd231ps	%zmm27, %zmm3, %zmm26 {%k1} {z}
	kmovw	24(%rsp), %k3
	vfmadd231ps	%zmm27, %zmm13, %zmm19 {%k3} {z}
	.loc	1 28 8
	vmovaps	1088(%rsi,%r10,4), %zmm27
	.loc	1 1 1
	vfmadd231ps	2560(%rsp), %zmm27, %zmm20 {%k4} {z}
	vfmadd231ps	2496(%rsp), %zmm27, %zmm21 {%k5} {z}
	vfmadd231ps	2432(%rsp), %zmm27, %zmm22 {%k7} {z}
	vfmadd231ps	1344(%rsp), %zmm27, %zmm23 {%k6} {z}
	kmovw	20(%rsp), %k6
	vfmadd231ps	768(%rsp), %zmm27, %zmm24 {%k6} {z}
	vfmadd231ps	192(%rsp), %zmm27, %zmm25 {%k2} {z}
	vfmadd231ps	%zmm27, %zmm4, %zmm26 {%k1} {z}
	kmovq	%k3, %k1
	vfmadd231ps	%zmm27, %zmm14, %zmm19 {%k3} {z}
	.loc	1 28 8
	vmovaps	1344(%rsi,%r10,4), %zmm27
	.loc	1 1 1
	vfmadd231ps	2368(%rsp), %zmm27, %zmm20 {%k4} {z}
	kmovq	%k5, %k3
	vfmadd231ps	2304(%rsp), %zmm27, %zmm21 {%k5} {z}
	vfmadd231ps	2240(%rsp), %zmm27, %zmm22 {%k7} {z}
	kmovw	8(%rsp), %k4
	vfmadd231ps	1280(%rsp), %zmm27, %zmm23 {%k4} {z}
	vfmadd231ps	704(%rsp), %zmm27, %zmm24 {%k6} {z}
	kmovq	%k2, %k4
	vfmadd231ps	%zmm27, %zmm28, %zmm25 {%k2} {z}
	kmovw	12(%rsp), %k2
	vfmadd231ps	%zmm27, %zmm5, %zmm26 {%k2} {z}
	vfmadd231ps	%zmm27, %zmm15, %zmm19 {%k1} {z}
	kmovq	%k1, %k5
	.loc	1 28 8
	vmovaps	1600(%rsi,%r10,4), %zmm27
	kmovw	10(%rsp), %k1
	.loc	1 1 1
	vfmadd231ps	2176(%rsp), %zmm27, %zmm20 {%k1} {z}
	vfmadd231ps	2112(%rsp), %zmm27, %zmm21 {%k3} {z}
	vfmadd231ps	2048(%rsp), %zmm27, %zmm22 {%k7} {z}
	kmovw	8(%rsp), %k1
	vfmadd231ps	1216(%rsp), %zmm27, %zmm23 {%k1} {z}
	vfmadd231ps	640(%rsp), %zmm27, %zmm24 {%k6} {z}
	vfmadd231ps	%zmm27, %zmm29, %zmm25 {%k4} {z}
	kmovq	%k2, %k1
	vfmadd231ps	%zmm27, %zmm6, %zmm26 {%k2} {z}
	vfmadd231ps	%zmm27, %zmm16, %zmm19 {%k5} {z}
	.loc	1 28 8
	vmovaps	1856(%rsi,%r10,4), %zmm27
	kmovw	10(%rsp), %k5
	.loc	1 1 1
	vfmadd231ps	1984(%rsp), %zmm27, %zmm20 {%k5} {z}
	vfmadd231ps	1920(%rsp), %zmm27, %zmm21 {%k3} {z}
	vfmadd231ps	1856(%rsp), %zmm27, %zmm22 {%k7} {z}
	kmovw	8(%rsp), %k2
	vfmadd231ps	1152(%rsp), %zmm27, %zmm23 {%k2} {z}
	vfmadd231ps	576(%rsp), %zmm27, %zmm24 {%k6} {z}
	vfmadd231ps	%zmm27, %zmm30, %zmm25 {%k4} {z}
	vfmadd231ps	%zmm27, %zmm7, %zmm26 {%k1} {z}
	kmovw	24(%rsp), %k1
	vfmadd231ps	%zmm27, %zmm17, %zmm19 {%k1} {z}
	.loc	1 28 8
	vmovaps	2112(%rsi,%r10,4), %zmm27
	.loc	1 1 1
	vfmadd231ps	1792(%rsp), %zmm27, %zmm20 {%k5} {z}
	vfmadd231ps	1728(%rsp), %zmm27, %zmm21 {%k3} {z}
	vfmadd231ps	1664(%rsp), %zmm27, %zmm22 {%k7} {z}
	vfmadd231ps	1088(%rsp), %zmm27, %zmm23 {%k2} {z}
	kmovq	%k2, %k3
	vfmadd231ps	512(%rsp), %zmm27, %zmm24 {%k6} {z}
	vfmadd231ps	%zmm27, %zmm31, %zmm25 {%k4} {z}
	kmovw	12(%rsp), %k2
	vfmadd231ps	%zmm27, %zmm9, %zmm26 {%k2} {z}
	vfmadd231ps	%zmm27, %zmm18, %zmm19 {%k1} {z}
	vmovaps	%zmm20, -1728(%rdi,%r10,4) {%k5}
	kmovw	22(%rsp), %k5
	vmovaps	%zmm21, -1472(%rdi,%r10,4) {%k5}
	vmovaps	%zmm22, -1216(%rdi,%r10,4) {%k7}
	vmovaps	%zmm23, -960(%rdi,%r10,4) {%k3}
	vmovaps	%zmm24, -704(%rdi,%r10,4) {%k6}
	vmovaps	%zmm25, -448(%rdi,%r10,4) {%k4}
	vmovaps	%zmm26, -192(%rdi,%r10,4) {%k2}
	vmovaps	%zmm19, 64(%rdi,%r10,4) {%k1}
	.loc	1 28 8
	addq	$16, %r10
	cmpq	$48, %r10
	jb	.LBB0_3
	addq	$8, %rcx
	addq	$2048, %rdi
	movq	48(%rsp), %rdx
	cmpq	%rdx, %rcx
	jl	.LBB0_2
.LBB0_5:
	.loc	1 30 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	1 30 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Ltmp3:
.Lfunc_end0:
	.size	infer_dispatch_0_matmul_Dx64x9_f32, .Lfunc_end0-infer_dispatch_0_matmul_Dx64x9_f32
	.cfi_endproc

	.section	.text.infer_dispatch_1_matmul_Dx2x64_f32,"ax",@progbits
	.prefalign	16
	.type	infer_dispatch_1_matmul_Dx2x64_f32,@function
infer_dispatch_1_matmul_Dx2x64_f32:
.Lfunc_begin1:
	.file	2 "results/e14_aarch64_qemu/x86_64/dump/dynamic" "configured_module_infer_dispatch_1.mlir"
	.loc	2 1 0 is_stmt 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
.Ltmp4:
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
	.loc	2 12 8 prologue_end
	movq	24(%rsi), %rax
	movq	(%rax), %rcx
	.loc	2 28 8
	movl	(%rdx), %eax
	movq	%rax, %rdx
	shlq	$6, %rdx
	movq	%rdx, 120(%rsp)
	subq	%rdx, %rcx
	cmpq	$64, %rcx
	movl	$64, %r9d
	cmovlq	%rcx, %r9
	testq	%rcx, %rcx
	jle	.LBB1_5
	.loc	2 0 0 is_stmt 0
	movq	32(%rsi), %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rdx
	movq	16(%rcx), %rsi
	.loc	2 28 8
	shlq	$14, %rax
	addq	%rax, %rdi
	addq	$1792, %rdi
	xorl	%r8d, %r8d
	movq	%r9, 112(%rsp)
	.loc	2 0 8
.Ltmp5:
	.p2align	4
.LBB1_2:
	.loc	2 27 8 is_stmt 1
	xorl	%r11d, %r11d
	subq	%r8, %r9
	setg	%r11b
	movl	%r11d, %eax
	negb	%al
	kmovd	%eax, %k1
	kmovw	%k1, 34(%rsp)
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k5
	xorl	%ebx, %ebx
	cmpq	$2, %r9
	setge	%bl
	movl	%ebx, %eax
	negb	%al
	kmovd	%eax, %k1
	kmovw	%k1, 38(%rsp)
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k7
	xorl	%r14d, %r14d
	cmpq	$3, %r9
	setge	%r14b
	movl	%r14d, %eax
	negb	%al
	kmovd	%eax, %k1
	kmovw	%k1, 36(%rsp)
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k6
	xorl	%r15d, %r15d
	cmpq	$4, %r9
	setge	%r15b
	movl	%r15d, %eax
	negb	%al
	kmovd	%eax, %k1
	kmovw	%k1, 46(%rsp)
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k1
	xorl	%r12d, %r12d
	cmpq	$5, %r9
	setge	%r12b
	movl	%r12d, %eax
	negb	%al
	movq	120(%rsp), %rcx
	.loc	2 10 8
	leaq	(%r8,%rcx), %r10
	vxorps	%xmm29, %xmm29, %xmm29
	vmovaps	%xmm29, (%rsi,%r10,8) {%k5}
	.loc	2 27 8
	kmovd	%eax, %k2
	.loc	2 10 8
	vmovups	%xmm29, 8(%rsi,%r10,8) {%k7}
	kmovw	%k2, 44(%rsp)
	.loc	2 27 8
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k7
	xorl	%r13d, %r13d
	cmpq	$6, %r9
	setge	%r13b
	movl	%r13d, %eax
	negb	%al
	.loc	2 10 8
	vmovaps	%xmm29, 16(%rsi,%r10,8) {%k6}
	.loc	2 27 8
	kmovd	%eax, %k2
	.loc	2 10 8
	vmovups	%xmm29, 24(%rsi,%r10,8) {%k1}
	kmovw	%k2, 42(%rsp)
	.loc	2 27 8
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k1
	xorl	%eax, %eax
	cmpq	$7, %r9
	setge	%al
	movl	%eax, %ecx
	negb	%cl
	.loc	2 10 8
	vmovaps	%xmm29, 32(%rsi,%r10,8) {%k7}
	.loc	2 27 8
	kmovd	%ecx, %k2
	.loc	2 10 8
	vmovups	%xmm29, 40(%rsi,%r10,8) {%k1}
	kmovw	%k2, 40(%rsp)
	.loc	2 27 8
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k1
	xorl	%ecx, %ecx
	cmpq	$8, %r9
	setge	%cl
	movl	%ecx, %r9d
	negb	%r9b
	.loc	2 10 8
	vmovaps	%xmm29, 48(%rsi,%r10,8) {%k1}
	.loc	2 27 8
	kmovd	%r9d, %k1
	kmovw	%k1, 32(%rsp)
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k2
	.loc	2 10 8
	vmovups	%xmm29, 56(%rsi,%r10,8) {%k2}
	leaq	(%rsi,%r10,8), %r9
	.loc	2 28 8
	negl	%r11d
	negl	%ebx
	negl	%r14d
	negl	%r15d
	negl	%r12d
	negl	%r13d
	negl	%eax
	negl	%ecx
	movq	$-16, %r10
	vxorps	%xmm28, %xmm28, %xmm28
	vxorps	%xmm27, %xmm27, %xmm27
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	kmovd	%r11d, %k1
	kmovw	%k1, 62(%rsp)
	kmovd	%ebx, %k1
	kmovw	%k1, 60(%rsp)
	kmovd	%r14d, %k1
	kmovw	%k1, 58(%rsp)
	kmovd	%r15d, %k1
	kmovw	%k1, 56(%rsp)
	kmovd	%r12d, %k1
	kmovw	%k1, 54(%rsp)
	kmovd	%r13d, %k1
	kmovw	%k1, 52(%rsp)
	kmovd	%eax, %k1
	kmovw	%k1, 50(%rsp)
	kmovd	%ecx, %k1
	kmovw	%k1, 48(%rsp)
	.loc	2 0 8 is_stmt 0
.Ltmp6:
	.p2align	4
.LBB1_3:
	vmovaps	%xmm4, 64(%rsp)
	vmovaps	%xmm3, 80(%rsp)
	vmovaps	%xmm2, 96(%rsp)
	kmovw	62(%rsp), %k1
	.loc	2 28 8
	vmovaps	-1728(%rdi,%r10,4), %zmm15 {%k1} {z}
	kmovw	60(%rsp), %k1
	vmovaps	-1472(%rdi,%r10,4), %zmm14 {%k1} {z}
	kmovw	58(%rsp), %k1
	vmovaps	-1216(%rdi,%r10,4), %zmm13 {%k1} {z}
	kmovw	56(%rsp), %k1
	vmovaps	-960(%rdi,%r10,4), %zmm12 {%k1} {z}
	kmovw	54(%rsp), %k1
	vmovaps	-704(%rdi,%r10,4), %zmm5 {%k1} {z}
	kmovw	52(%rsp), %k1
	vmovaps	-448(%rdi,%r10,4), %zmm4 {%k1} {z}
	kmovw	50(%rsp), %k1
	vmovaps	-192(%rdi,%r10,4), %zmm2 {%k1} {z}
	kmovw	48(%rsp), %k1
	vmovaps	64(%rdi,%r10,4), %zmm1 {%k1} {z}
	vmovsd	128(%rdx,%r10,8), %xmm20
	vmovsd	136(%rdx,%r10,8), %xmm19
	vmovsd	144(%rdx,%r10,8), %xmm18
	vmovsd	152(%rdx,%r10,8), %xmm17
	vmovsd	160(%rdx,%r10,8), %xmm16
	.loc	2 1 1 is_stmt 1
	vbroadcastss	%xmm15, %xmm21
	vmovaps	%xmm7, %xmm22
	kmovw	34(%rsp), %k6
	vfmadd231ps	%xmm20, %xmm21, %xmm22 {%k6}
	vbroadcastss	%xmm14, %xmm21
	vmovaps	%xmm6, %xmm23
	kmovw	38(%rsp), %k2
	vfmadd231ps	%xmm20, %xmm21, %xmm23 {%k2}
	vbroadcastss	%xmm13, %xmm21
	vmovaps	64(%rsp), %xmm24
	kmovw	36(%rsp), %k1
	vfmadd231ps	%xmm20, %xmm21, %xmm24 {%k1}
	vbroadcastss	%xmm12, %xmm21
	vmovaps	80(%rsp), %xmm25
	kmovw	46(%rsp), %k1
	vfmadd231ps	%xmm20, %xmm21, %xmm25 {%k1}
	vbroadcastss	%xmm5, %xmm21
	vmovaps	96(%rsp), %xmm26
	kmovw	44(%rsp), %k5
	vfmadd231ps	%xmm20, %xmm21, %xmm26 {%k5}
	vbroadcastss	%xmm4, %xmm21
	vmovaps	%xmm27, %xmm9
	kmovw	42(%rsp), %k1
	vfmadd231ps	%xmm20, %xmm21, %xmm27 {%k1}
	vbroadcastss	%xmm2, %xmm21
	vmovaps	%xmm28, %xmm10
	kmovw	40(%rsp), %k7
	vfmadd231ps	%xmm20, %xmm21, %xmm28 {%k7}
	vbroadcastss	%xmm1, %xmm21
	vmovaps	%xmm29, %xmm11
	kmovw	32(%rsp), %k3
	vfmadd231ps	%xmm20, %xmm21, %xmm29 {%k3}
	vmovshdup	%xmm15, %xmm20
	vfmadd213ps	%xmm22, %xmm19, %xmm20
	vblendmps	%xmm20, %xmm7, %xmm20 {%k6}
	kmovq	%k6, %k1
	vmovshdup	%xmm14, %xmm21
	vfmadd213ps	%xmm23, %xmm19, %xmm21
	vmovshdup	%xmm13, %xmm22
	vfmadd213ps	%xmm24, %xmm19, %xmm22
	vblendmps	%xmm21, %xmm6, %xmm21 {%k2}
	vmovaps	64(%rsp), %xmm3
	kmovw	36(%rsp), %k4
	vblendmps	%xmm22, %xmm3, %xmm22 {%k4}
	vmovshdup	%xmm12, %xmm23
	vfmadd213ps	%xmm25, %xmm19, %xmm23
	vmovshdup	%xmm5, %xmm24
	vfmadd213ps	%xmm26, %xmm19, %xmm24
	vmovaps	80(%rsp), %xmm3
	kmovw	46(%rsp), %k4
	vblendmps	%xmm23, %xmm3, %xmm23 {%k4}
	vmovaps	96(%rsp), %xmm3
	vblendmps	%xmm24, %xmm3, %xmm24 {%k5}
	vmovshdup	%xmm4, %xmm25
	vfmadd213ps	%xmm27, %xmm19, %xmm25
	vmovshdup	%xmm2, %xmm26
	vfmadd213ps	%xmm28, %xmm19, %xmm26
	kmovw	42(%rsp), %k6
	vblendmps	%xmm25, %xmm9, %xmm25 {%k6}
	vblendmps	%xmm26, %xmm10, %xmm26 {%k7}
	vmovshdup	%xmm1, %xmm27
	vfmadd213ps	%xmm29, %xmm19, %xmm27
	vshufps	$255, %xmm15, %xmm15, %xmm19
	vshufps	$170, %xmm15, %xmm15, %xmm28
	vblendmps	%xmm27, %xmm11, %xmm27 {%k3}
	vfmadd213ps	%xmm20, %xmm18, %xmm28
	vblendmps	%xmm28, %xmm7, %xmm20 {%k1}
	vshufps	$255, %xmm14, %xmm14, %xmm28
	vshufps	$170, %xmm14, %xmm14, %xmm29
	vfmadd213ps	%xmm21, %xmm18, %xmm29
	vblendmps	%xmm29, %xmm6, %xmm21 {%k2}
	vshufps	$255, %xmm13, %xmm13, %xmm29
	vshufps	$170, %xmm13, %xmm13, %xmm30
	vfmadd213ps	%xmm22, %xmm18, %xmm30
	vshufps	$255, %xmm12, %xmm12, %xmm22
	vshufps	$170, %xmm12, %xmm12, %xmm31
	kmovw	36(%rsp), %k3
	vmovaps	64(%rsp), %xmm3
	vblendmps	%xmm30, %xmm3, %xmm30 {%k3}
	vfmadd213ps	%xmm23, %xmm18, %xmm31
	vmovaps	80(%rsp), %xmm3
	vblendmps	%xmm31, %xmm3, %xmm23 {%k4}
	vshufps	$255, %xmm5, %xmm5, %xmm31
	vshufps	$170, %xmm5, %xmm5, %xmm8
	vfmadd213ps	%xmm24, %xmm18, %xmm8
	vmovaps	96(%rsp), %xmm3
	vblendmps	%xmm8, %xmm3, %xmm8 {%k5}
	vshufps	$255, %xmm4, %xmm4, %xmm24
	vshufps	$170, %xmm4, %xmm4, %xmm3
	vfmadd213ps	%xmm25, %xmm18, %xmm3
	vshufps	$170, %xmm2, %xmm2, %xmm25
	vfmadd213ps	%xmm26, %xmm18, %xmm25
	kmovw	42(%rsp), %k6
	vblendmps	%xmm3, %xmm9, %xmm0 {%k6}
	vshufps	$170, %xmm1, %xmm1, %xmm26
	vfmadd213ps	%xmm27, %xmm18, %xmm26
	vshufps	$255, %xmm2, %xmm2, %xmm18
	vmovaps	%zmm2, %zmm3
	vmovaps	%zmm2, 192(%rsp)
	vblendmps	%xmm25, %xmm10, %xmm25 {%k7}
	vshufps	$255, %xmm1, %xmm1, %xmm27
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, 128(%rsp)
	kmovw	32(%rsp), %k2
	vblendmps	%xmm26, %xmm11, %xmm26 {%k2}
	vfmadd231ps	%xmm19, %xmm17, %xmm20
	kmovw	34(%rsp), %k1
	vblendmps	%xmm20, %xmm7, %xmm19 {%k1}
	vfmadd231ps	%xmm28, %xmm17, %xmm21
	kmovw	38(%rsp), %k1
	vblendmps	%xmm21, %xmm6, %xmm20 {%k1}
	vfmadd231ps	%xmm29, %xmm17, %xmm30
	vmovaps	64(%rsp), %xmm1
	vblendmps	%xmm30, %xmm1, %xmm21 {%k3}
	vfmadd231ps	%xmm22, %xmm17, %xmm23
	vmovaps	80(%rsp), %xmm1
	vblendmps	%xmm23, %xmm1, %xmm22 {%k4}
	vfmadd231ps	%xmm31, %xmm17, %xmm8
	vmovaps	96(%rsp), %xmm1
	vblendmps	%xmm8, %xmm1, %xmm8 {%k5}
	vfmadd231ps	%xmm24, %xmm17, %xmm0
	vblendmps	%xmm0, %xmm9, %xmm0 {%k6}
	vfmadd231ps	%xmm18, %xmm17, %xmm25
	vblendmps	%xmm25, %xmm10, %xmm24 {%k7}
	vfmadd231ps	%xmm27, %xmm17, %xmm26
	vextractf32x4	$1, %ymm15, %xmm17
	vmovsldup	%xmm17, %xmm25
	vblendmps	%xmm26, %xmm11, %xmm26 {%k2}
	vfmadd213ps	%xmm19, %xmm16, %xmm25
	vextractf32x4	$1, %ymm14, %xmm18
	vmovsldup	%xmm18, %xmm27
	vextractf32x4	$1, %ymm13, %xmm19
	vmovsldup	%xmm19, %xmm28
	vfmadd213ps	%xmm20, %xmm16, %xmm27
	vfmadd213ps	%xmm21, %xmm16, %xmm28
	vextractf32x4	$1, %ymm12, %xmm20
	vmovsldup	%xmm20, %xmm29
	vextractf32x4	$1, %ymm5, %xmm21
	vmovsldup	%xmm21, %xmm30
	vfmadd213ps	%xmm22, %xmm16, %xmm29
	vfmadd213ps	%xmm8, %xmm16, %xmm30
	vextractf32x4	$1, %ymm4, %xmm22
	vmovsldup	%xmm22, %xmm8
	vextractf32x4	$1, %ymm3, %xmm23
	vmovsldup	%xmm23, %xmm31
	vfmadd213ps	%xmm0, %xmm16, %xmm8
	vfmadd213ps	%xmm24, %xmm16, %xmm31
	vextractf32x4	$1, %ymm2, %xmm24
	vmovsldup	%xmm24, %xmm0
	vfmadd213ps	%xmm26, %xmm16, %xmm0
	.loc	2 28 8
	vmovsd	168(%rdx,%r10,8), %xmm16
	kmovw	34(%rsp), %k7
	.loc	2 1 1
	vblendmps	%xmm25, %xmm7, %xmm25 {%k7}
	kmovq	%k1, %k2
	vblendmps	%xmm27, %xmm6, %xmm26 {%k1}
	vmovaps	64(%rsp), %xmm1
	vblendmps	%xmm28, %xmm1, %xmm27 {%k3}
	vmovaps	80(%rsp), %xmm1
	vblendmps	%xmm29, %xmm1, %xmm28 {%k4}
	vmovaps	96(%rsp), %xmm1
	vblendmps	%xmm30, %xmm1, %xmm29 {%k5}
	vblendmps	%xmm8, %xmm9, %xmm8 {%k6}
	kmovw	40(%rsp), %k1
	vblendmps	%xmm31, %xmm10, %xmm30 {%k1}
	kmovw	32(%rsp), %k1
	vblendmps	%xmm0, %xmm11, %xmm0 {%k1}
	vmovshdup	%xmm17, %xmm31
	vfmadd213ps	%xmm25, %xmm16, %xmm31
	vmovshdup	%xmm18, %xmm25
	vfmadd213ps	%xmm26, %xmm16, %xmm25
	vmovshdup	%xmm19, %xmm26
	vfmadd213ps	%xmm27, %xmm16, %xmm26
	vmovshdup	%xmm20, %xmm27
	vfmadd213ps	%xmm28, %xmm16, %xmm27
	vmovshdup	%xmm21, %xmm28
	vfmadd213ps	%xmm29, %xmm16, %xmm28
	vmovshdup	%xmm22, %xmm29
	vfmadd213ps	%xmm8, %xmm16, %xmm29
	vmovshdup	%xmm23, %xmm8
	vfmadd213ps	%xmm30, %xmm16, %xmm8
	vmovshdup	%xmm24, %xmm30
	vfmadd213ps	%xmm0, %xmm16, %xmm30
	.loc	2 28 8
	vmovsd	176(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vblendmps	%xmm31, %xmm7, %xmm16 {%k7}
	kmovq	%k7, %k1
	vblendmps	%xmm25, %xmm6, %xmm25 {%k2}
	vmovaps	64(%rsp), %xmm1
	vblendmps	%xmm26, %xmm1, %xmm26 {%k3}
	vmovaps	80(%rsp), %xmm1
	vblendmps	%xmm27, %xmm1, %xmm27 {%k4}
	vmovaps	96(%rsp), %xmm1
	vblendmps	%xmm28, %xmm1, %xmm28 {%k5}
	vblendmps	%xmm29, %xmm9, %xmm29 {%k6}
	kmovq	%k6, %k7
	kmovw	40(%rsp), %k6
	vblendmps	%xmm8, %xmm10, %xmm8 {%k6}
	kmovw	32(%rsp), %k3
	vblendmps	%xmm30, %xmm11, %xmm30 {%k3}
	vshufps	$170, %xmm17, %xmm17, %xmm31
	vfmadd213ps	%xmm16, %xmm0, %xmm31
	vshufps	$170, %xmm18, %xmm18, %xmm1
	vfmadd213ps	%xmm25, %xmm0, %xmm1
	vshufps	$170, %xmm19, %xmm19, %xmm25
	vfmadd213ps	%xmm26, %xmm0, %xmm25
	vshufps	$170, %xmm20, %xmm20, %xmm26
	vfmadd213ps	%xmm27, %xmm0, %xmm26
	vshufps	$170, %xmm21, %xmm21, %xmm27
	vfmadd213ps	%xmm28, %xmm0, %xmm27
	vshufps	$170, %xmm22, %xmm22, %xmm28
	vfmadd213ps	%xmm29, %xmm0, %xmm28
	vshufps	$170, %xmm23, %xmm23, %xmm29
	vfmadd213ps	%xmm8, %xmm0, %xmm29
	vshufps	$170, %xmm24, %xmm24, %xmm8
	vfmadd213ps	%xmm30, %xmm0, %xmm8
	.loc	2 28 8
	vmovsd	184(%rdx,%r10,8), %xmm0
	vmovsd	192(%rdx,%r10,8), %xmm16
	.loc	2 1 1
	vshufps	$255, %xmm17, %xmm17, %xmm17
	vblendmps	%xmm31, %xmm7, %xmm30 {%k1}
	vshufps	$255, %xmm18, %xmm18, %xmm18
	vblendmps	%xmm1, %xmm6, %xmm1 {%k2}
	vshufps	$255, %xmm19, %xmm19, %xmm19
	vmovaps	64(%rsp), %xmm2
	kmovw	36(%rsp), %k3
	vblendmps	%xmm25, %xmm2, %xmm25 {%k3}
	vshufps	$255, %xmm20, %xmm20, %xmm20
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm26, %xmm2, %xmm26 {%k4}
	vshufps	$255, %xmm21, %xmm21, %xmm21
	vmovaps	96(%rsp), %xmm2
	vblendmps	%xmm27, %xmm2, %xmm27 {%k5}
	vshufps	$255, %xmm22, %xmm22, %xmm22
	vblendmps	%xmm28, %xmm9, %xmm28 {%k7}
	vshufps	$255, %xmm23, %xmm23, %xmm23
	vblendmps	%xmm29, %xmm10, %xmm29 {%k6}
	vshufps	$255, %xmm24, %xmm24, %xmm24
	kmovw	32(%rsp), %k6
	vblendmps	%xmm8, %xmm11, %xmm8 {%k6}
	vfmadd231ps	%xmm17, %xmm0, %xmm30
	vblendmps	%xmm30, %xmm7, %xmm17 {%k1}
	vfmadd231ps	%xmm18, %xmm0, %xmm1
	vblendmps	%xmm1, %xmm6, %xmm1 {%k2}
	vfmadd231ps	%xmm19, %xmm0, %xmm25
	vmovaps	64(%rsp), %xmm2
	vblendmps	%xmm25, %xmm2, %xmm18 {%k3}
	vfmadd231ps	%xmm20, %xmm0, %xmm26
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm26, %xmm2, %xmm19 {%k4}
	kmovq	%k4, %k1
	vfmadd231ps	%xmm21, %xmm0, %xmm27
	vmovaps	96(%rsp), %xmm2
	vblendmps	%xmm27, %xmm2, %xmm20 {%k5}
	vfmadd231ps	%xmm22, %xmm0, %xmm28
	kmovq	%k7, %k4
	vblendmps	%xmm28, %xmm9, %xmm21 {%k7}
	vfmadd231ps	%xmm23, %xmm0, %xmm29
	kmovw	40(%rsp), %k7
	vblendmps	%xmm29, %xmm10, %xmm22 {%k7}
	vfmadd231ps	%xmm24, %xmm0, %xmm8
	vblendmps	%xmm8, %xmm11, %xmm0 {%k6}
	vextractf32x4	$2, %zmm15, %xmm8
	vmovsldup	%xmm8, %xmm23
	vextractf32x4	$2, %zmm14, %xmm24
	vfmadd213ps	%xmm17, %xmm16, %xmm23
	vmovsldup	%xmm24, %xmm17
	vfmadd213ps	%xmm1, %xmm16, %xmm17
	vextractf32x4	$2, %zmm13, %xmm1
	vmovsldup	%xmm1, %xmm25
	vextractf32x4	$2, %zmm12, %xmm26
	vfmadd213ps	%xmm18, %xmm16, %xmm25
	vmovsldup	%xmm26, %xmm18
	vfmadd213ps	%xmm19, %xmm16, %xmm18
	vextractf32x4	$2, %zmm5, %xmm19
	vmovsldup	%xmm19, %xmm27
	vextractf32x4	$2, %zmm4, %xmm28
	vfmadd213ps	%xmm20, %xmm16, %xmm27
	vmovsldup	%xmm28, %xmm20
	vfmadd213ps	%xmm21, %xmm16, %xmm20
	vmovaps	192(%rsp), %zmm2
	vextractf32x4	$2, %zmm2, %xmm21
	vmovsldup	%xmm21, %xmm29
	vmovaps	128(%rsp), %zmm2
	vextractf32x4	$2, %zmm2, %xmm30
	vfmadd213ps	%xmm22, %xmm16, %xmm29
	vmovsldup	%xmm30, %xmm22
	vfmadd213ps	%xmm0, %xmm16, %xmm22
	.loc	2 28 8
	vmovsd	200(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vmovshdup	%xmm8, %xmm8
	kmovw	34(%rsp), %k3
	vblendmps	%xmm23, %xmm7, %xmm16 {%k3}
	vfmadd213ps	%xmm16, %xmm0, %xmm8
	vblendmps	%xmm17, %xmm6, %xmm16 {%k2}
	vmovshdup	%xmm24, %xmm17
	vfmadd213ps	%xmm16, %xmm0, %xmm17
	vmovshdup	%xmm1, %xmm1
	kmovw	36(%rsp), %k2
	vmovaps	64(%rsp), %xmm2
	vblendmps	%xmm25, %xmm2, %xmm16 {%k2}
	vfmadd213ps	%xmm16, %xmm0, %xmm1
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm18, %xmm2, %xmm16 {%k1}
	kmovq	%k1, %k5
	vmovshdup	%xmm26, %xmm18
	vfmadd213ps	%xmm16, %xmm0, %xmm18
	vmovshdup	%xmm19, %xmm16
	vmovaps	96(%rsp), %xmm2
	kmovw	44(%rsp), %k6
	vblendmps	%xmm27, %xmm2, %xmm19 {%k6}
	vmovaps	%xmm9, %xmm27
	vfmadd213ps	%xmm19, %xmm0, %xmm16
	vblendmps	%xmm20, %xmm9, %xmm19 {%k4}
	vmovshdup	%xmm28, %xmm20
	vmovaps	%xmm10, %xmm28
	vfmadd213ps	%xmm19, %xmm0, %xmm20
	vmovshdup	%xmm21, %xmm19
	vblendmps	%xmm29, %xmm10, %xmm21 {%k7}
	vmovaps	%xmm11, %xmm29
	vfmadd213ps	%xmm21, %xmm0, %xmm19
	kmovw	32(%rsp), %k1
	vblendmps	%xmm22, %xmm11, %xmm21 {%k1}
	vmovshdup	%xmm30, %xmm22
	vfmadd213ps	%xmm21, %xmm0, %xmm22
	.loc	2 28 8
	vmovsd	208(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vblendmps	%xmm8, %xmm7, %xmm8 {%k3}
	kmovw	38(%rsp), %k3
	vblendmps	%xmm17, %xmm6, %xmm17 {%k3}
	vmovaps	64(%rsp), %xmm2
	vblendmps	%xmm1, %xmm2, %xmm1 {%k2}
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm18, %xmm2, %xmm18 {%k5}
	vmovaps	96(%rsp), %xmm2
	vblendmps	%xmm16, %xmm2, %xmm21 {%k6}
	kmovq	%k6, %k2
	vblendmps	%xmm20, %xmm9, %xmm20 {%k4}
	vblendmps	%xmm19, %xmm10, %xmm19 {%k7}
	vblendmps	%xmm22, %xmm11, %xmm22 {%k1}
	vextractf64x4	$1, %zmm15, %ymm15
	vshufps	$170, %xmm15, %xmm15, %xmm23
	vextractf64x4	$1, %zmm14, %ymm14
	vfmadd213ps	%xmm8, %xmm0, %xmm23
	vshufps	$170, %xmm14, %xmm14, %xmm24
	vfmadd213ps	%xmm17, %xmm0, %xmm24
	vextractf64x4	$1, %zmm13, %ymm16
	vshufps	$170, %xmm16, %xmm16, %xmm13
	vextractf64x4	$1, %zmm12, %ymm12
	vfmadd213ps	%xmm1, %xmm0, %xmm13
	vshufps	$170, %xmm12, %xmm12, %xmm1
	vfmadd213ps	%xmm18, %xmm0, %xmm1
	vextractf64x4	$1, %zmm5, %ymm17
	vshufps	$170, %xmm17, %xmm17, %xmm11
	vextractf64x4	$1, %zmm4, %ymm10
	vfmadd213ps	%xmm21, %xmm0, %xmm11
	vshufps	$170, %xmm10, %xmm10, %xmm21
	vfmadd213ps	%xmm20, %xmm0, %xmm21
	vmovaps	192(%rsp), %zmm2
	vextractf64x4	$1, %zmm2, %ymm18
	vshufps	$170, %xmm18, %xmm18, %xmm9
	vmovaps	128(%rsp), %zmm2
	vextractf64x4	$1, %zmm2, %ymm8
	vfmadd213ps	%xmm19, %xmm0, %xmm9
	vshufps	$170, %xmm8, %xmm8, %xmm19
	vfmadd213ps	%xmm22, %xmm0, %xmm19
	.loc	2 28 8
	vmovsd	216(%rdx,%r10,8), %xmm0
	kmovw	34(%rsp), %k7
	.loc	2 1 1
	vblendmps	%xmm23, %xmm7, %xmm20 {%k7}
	kmovq	%k3, %k1
	vblendmps	%xmm24, %xmm6, %xmm22 {%k3}
	kmovw	36(%rsp), %k3
	vmovaps	64(%rsp), %xmm2
	vblendmps	%xmm13, %xmm2, %xmm13 {%k3}
	kmovq	%k5, %k6
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm1, %xmm2, %xmm1 {%k5}
	vmovaps	96(%rsp), %xmm2
	vblendmps	%xmm11, %xmm2, %xmm11 {%k2}
	vblendmps	%xmm21, %xmm27, %xmm21 {%k4}
	kmovw	40(%rsp), %k5
	vblendmps	%xmm9, %xmm28, %xmm9 {%k5}
	kmovw	32(%rsp), %k2
	vblendmps	%xmm19, %xmm29, %xmm19 {%k2}
	vshufps	$255, %xmm15, %xmm15, %xmm23
	vfmadd213ps	%xmm20, %xmm0, %xmm23
	vshufps	$255, %xmm14, %xmm14, %xmm20
	vfmadd213ps	%xmm22, %xmm0, %xmm20
	vshufps	$255, %xmm16, %xmm16, %xmm22
	vfmadd213ps	%xmm13, %xmm0, %xmm22
	vshufps	$255, %xmm12, %xmm12, %xmm13
	vfmadd213ps	%xmm1, %xmm0, %xmm13
	vshufps	$255, %xmm17, %xmm17, %xmm1
	vfmadd213ps	%xmm11, %xmm0, %xmm1
	vshufps	$255, %xmm10, %xmm10, %xmm11
	vfmadd213ps	%xmm21, %xmm0, %xmm11
	vshufps	$255, %xmm18, %xmm18, %xmm21
	vfmadd213ps	%xmm9, %xmm0, %xmm21
	vshufps	$255, %xmm8, %xmm8, %xmm9
	vfmadd213ps	%xmm19, %xmm0, %xmm9
	.loc	2 28 8
	vmovsd	224(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vblendmps	%xmm23, %xmm7, %xmm19 {%k7}
	vblendmps	%xmm20, %xmm6, %xmm20 {%k1}
	vmovaps	64(%rsp), %xmm2
	vblendmps	%xmm22, %xmm2, %xmm22 {%k3}
	kmovq	%k3, %k7
	vmovaps	80(%rsp), %xmm2
	vblendmps	%xmm13, %xmm2, %xmm23 {%k6}
	vmovaps	96(%rsp), %xmm2
	kmovw	44(%rsp), %k1
	vblendmps	%xmm1, %xmm2, %xmm1 {%k1}
	vblendmps	%xmm11, %xmm27, %xmm24 {%k4}
	vblendmps	%xmm21, %xmm28, %xmm21 {%k5}
	kmovq	%k2, %k3
	vblendmps	%xmm9, %xmm29, %xmm25 {%k2}
	vextractf128	$1, %ymm15, %xmm15
	vmovsldup	%xmm15, %xmm26
	vextractf128	$1, %ymm14, %xmm13
	vfmadd213ps	%xmm19, %xmm0, %xmm26
	vmovsldup	%xmm13, %xmm19
	vfmadd213ps	%xmm20, %xmm0, %xmm19
	vextractf32x4	$1, %ymm16, %xmm14
	vmovsldup	%xmm14, %xmm16
	vextractf128	$1, %ymm12, %xmm11
	vfmadd213ps	%xmm22, %xmm0, %xmm16
	vmovsldup	%xmm11, %xmm20
	vfmadd213ps	%xmm23, %xmm0, %xmm20
	vextractf32x4	$1, %ymm17, %xmm12
	vmovsldup	%xmm12, %xmm17
	vextractf128	$1, %ymm10, %xmm9
	vfmadd213ps	%xmm1, %xmm0, %xmm17
	vmovsldup	%xmm9, %xmm1
	vfmadd213ps	%xmm24, %xmm0, %xmm1
	vmovaps	64(%rsp), %xmm4
	vextractf32x4	$1, %ymm18, %xmm10
	vmovsldup	%xmm10, %xmm18
	vextractf128	$1, %ymm8, %xmm8
	vfmadd213ps	%xmm21, %xmm0, %xmm18
	vmovsldup	%xmm8, %xmm21
	vfmadd213ps	%xmm25, %xmm0, %xmm21
	vmovaps	80(%rsp), %xmm3
	.loc	2 28 8
	vmovsd	232(%rdx,%r10,8), %xmm0
	kmovw	34(%rsp), %k2
	.loc	2 1 1
	vblendmps	%xmm26, %xmm7, %xmm22 {%k2}
	vmovaps	96(%rsp), %xmm2
	kmovw	38(%rsp), %k4
	vblendmps	%xmm19, %xmm6, %xmm19 {%k4}
	vblendmps	%xmm16, %xmm4, %xmm16 {%k7}
	kmovq	%k7, %k6
	kmovw	46(%rsp), %k7
	vblendmps	%xmm20, %xmm3, %xmm20 {%k7}
	vblendmps	%xmm17, %xmm2, %xmm17 {%k1}
	kmovw	42(%rsp), %k1
	vblendmps	%xmm1, %xmm27, %xmm1 {%k1}
	vblendmps	%xmm18, %xmm28, %xmm18 {%k5}
	vblendmps	%xmm21, %xmm29, %xmm21 {%k3}
	vmovshdup	%xmm15, %xmm23
	vfmadd213ps	%xmm22, %xmm0, %xmm23
	vmovshdup	%xmm13, %xmm22
	vfmadd213ps	%xmm19, %xmm0, %xmm22
	vmovshdup	%xmm14, %xmm19
	vfmadd213ps	%xmm16, %xmm0, %xmm19
	vmovshdup	%xmm11, %xmm16
	vfmadd213ps	%xmm20, %xmm0, %xmm16
	vmovshdup	%xmm12, %xmm20
	vfmadd213ps	%xmm17, %xmm0, %xmm20
	vmovshdup	%xmm9, %xmm17
	vfmadd213ps	%xmm1, %xmm0, %xmm17
	vmovshdup	%xmm10, %xmm1
	vfmadd213ps	%xmm18, %xmm0, %xmm1
	vmovshdup	%xmm8, %xmm18
	vfmadd213ps	%xmm21, %xmm0, %xmm18
	.loc	2 28 8
	vmovsd	240(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vblendmps	%xmm23, %xmm7, %xmm21 {%k2}
	vblendmps	%xmm22, %xmm6, %xmm22 {%k4}
	vblendmps	%xmm19, %xmm4, %xmm19 {%k6}
	vblendmps	%xmm16, %xmm3, %xmm16 {%k7}
	kmovw	44(%rsp), %k4
	vblendmps	%xmm20, %xmm2, %xmm20 {%k4}
	vblendmps	%xmm17, %xmm27, %xmm17 {%k1}
	kmovq	%k5, %k1
	vblendmps	%xmm1, %xmm28, %xmm1 {%k5}
	vblendmps	%xmm18, %xmm29, %xmm18 {%k3}
	vshufps	$170, %xmm15, %xmm15, %xmm23
	vfmadd213ps	%xmm21, %xmm0, %xmm23
	vshufps	$170, %xmm13, %xmm13, %xmm21
	vfmadd213ps	%xmm22, %xmm0, %xmm21
	vshufps	$170, %xmm14, %xmm14, %xmm22
	vfmadd213ps	%xmm19, %xmm0, %xmm22
	vshufps	$170, %xmm11, %xmm11, %xmm19
	vfmadd213ps	%xmm16, %xmm0, %xmm19
	vshufps	$170, %xmm12, %xmm12, %xmm16
	vfmadd213ps	%xmm20, %xmm0, %xmm16
	vshufps	$170, %xmm9, %xmm9, %xmm20
	vfmadd213ps	%xmm17, %xmm0, %xmm20
	vshufps	$170, %xmm10, %xmm10, %xmm17
	vfmadd213ps	%xmm1, %xmm0, %xmm17
	vshufps	$170, %xmm8, %xmm8, %xmm1
	vfmadd213ps	%xmm18, %xmm0, %xmm1
	.loc	2 28 8
	vmovsd	248(%rdx,%r10,8), %xmm0
	.loc	2 1 1
	vblendmps	%xmm23, %xmm7, %xmm18 {%k2}
	vshufps	$255, %xmm15, %xmm15, %xmm15
	vfmadd213ps	%xmm18, %xmm0, %xmm15
	kmovw	38(%rsp), %k2
	vblendmps	%xmm21, %xmm6, %xmm18 {%k2}
	vshufps	$255, %xmm13, %xmm13, %xmm13
	vfmadd213ps	%xmm18, %xmm0, %xmm13
	vblendmps	%xmm22, %xmm4, %xmm18 {%k6}
	vshufps	$255, %xmm14, %xmm14, %xmm14
	vfmadd213ps	%xmm18, %xmm0, %xmm14
	kmovw	46(%rsp), %k3
	vblendmps	%xmm19, %xmm3, %xmm18 {%k3}
	vshufps	$255, %xmm11, %xmm11, %xmm11
	vfmadd213ps	%xmm18, %xmm0, %xmm11
	kmovq	%k4, %k2
	vblendmps	%xmm16, %xmm2, %xmm16 {%k4}
	vshufps	$255, %xmm12, %xmm12, %xmm12
	vfmadd213ps	%xmm16, %xmm0, %xmm12
	kmovw	42(%rsp), %k5
	vblendmps	%xmm20, %xmm27, %xmm16 {%k5}
	vshufps	$255, %xmm9, %xmm9, %xmm9
	vfmadd213ps	%xmm16, %xmm0, %xmm9
	vblendmps	%xmm17, %xmm28, %xmm16 {%k1}
	vshufps	$255, %xmm10, %xmm10, %xmm10
	vfmadd213ps	%xmm16, %xmm0, %xmm10
	kmovw	32(%rsp), %k4
	vblendmps	%xmm1, %xmm29, %xmm1 {%k4}
	vshufps	$255, %xmm8, %xmm8, %xmm8
	vfmadd213ps	%xmm1, %xmm0, %xmm8
	kmovw	34(%rsp), %k7
	vmovaps	%xmm15, %xmm7 {%k7}
	kmovw	38(%rsp), %k7
	vmovaps	%xmm13, %xmm6 {%k7}
	vmovaps	%xmm14, %xmm4 {%k6}
	vmovaps	%xmm11, %xmm3 {%k3}
	vmovaps	%xmm12, %xmm2 {%k2}
	vmovaps	%xmm9, %xmm27 {%k5}
	vmovaps	%xmm10, %xmm28 {%k1}
	vmovaps	%xmm8, %xmm29 {%k4}
	.loc	2 28 8
	addq	$16, %r10
	cmpq	$48, %r10
	jb	.LBB1_3
	.loc	2 0 8 is_stmt 0
	kmovw	34(%rsp), %k1
	.loc	2 1 1 is_stmt 1
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k2
	vmovaps	%xmm7, (%r9) {%k2}
	kmovw	38(%rsp), %k2
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k2
	vmovups	%xmm6, 8(%r9) {%k2}
	kmovw	36(%rsp), %k2
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k2
	vmovaps	%xmm4, 16(%r9) {%k2}
	kmovw	46(%rsp), %k2
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k2
	vmovups	%xmm3, 24(%r9) {%k2}
	kmovw	44(%rsp), %k2
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k2
	vmovaps	%xmm2, 32(%r9) {%k2}
	kmovw	42(%rsp), %k2
	kshiftlb	$6, %k2, %k0
	kshiftrb	$6, %k0, %k2
	vmovups	%xmm27, 40(%r9) {%k2}
	kmovw	40(%rsp), %k1
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k2
	vmovaps	%xmm28, 48(%r9) {%k2}
	kmovw	32(%rsp), %k1
	kshiftlb	$6, %k1, %k0
	kshiftrb	$6, %k0, %k1
	vmovups	%xmm29, 56(%r9) {%k1}
	.loc	2 28 8
	addq	$8, %r8
	addq	$2048, %rdi
	movq	112(%rsp), %r9
	cmpq	%r9, %r8
	jl	.LBB1_2
.LBB1_5:
	.loc	2 30 8
	xorl	%eax, %eax
	leaq	-40(%rbp), %rsp
	.loc	2 30 8 epilogue_begin is_stmt 0
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Ltmp7:
.Lfunc_end1:
	.size	infer_dispatch_1_matmul_Dx2x64_f32, .Lfunc_end1-infer_dispatch_1_matmul_Dx2x64_f32
	.cfi_endproc

	.section	.text.iree_hal_executable_library_query,"ax",@progbits
	.globl	iree_hal_executable_library_query
	.prefalign	16
	.type	iree_hal_executable_library_query,@function
iree_hal_executable_library_query:
.Liree_hal_executable_library_query$local:
	.type	.Liree_hal_executable_library_query$local,@function
.Lfunc_begin2:
	.cfi_startproc
	xorl	%eax, %eax
	cmpl	$6, %edi
	leaq	iree_hal_executable_library_query_v0(%rip), %rcx
	cmoveq	%rcx, %rax
	retq
.Lfunc_end2:
	.size	iree_hal_executable_library_query, .Lfunc_end2-iree_hal_executable_library_query
	.size	.Liree_hal_executable_library_query$local, .Lfunc_end2-iree_hal_executable_library_query
	.cfi_endproc

	.section	.text.iree_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_h2f_ieee,@function
iree_h2f_ieee:
.Lfunc_begin3:
	.cfi_startproc
	movl	%edi, %ecx
	andl	$1023, %ecx
	movl	%edi, %eax
	andl	$32768, %eax
	shll	$16, %eax
	movl	%edi, %edx
	andw	$31744, %dx
	je	.LBB3_6
	andl	$31744, %edi
	cmpl	$31744, %edi
	jne	.LBB3_5
	testw	%cx, %cx
	je	.LBB3_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	retq
.LBB3_6:
	orl	$864026624, %eax
	movzwl	%cx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB3_5:
	movzwl	%cx, %ecx
	movzwl	%dx, %edx
	addl	%ecx, %edx
	shll	$13, %edx
	addl	%edx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	retq
.LBB3_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	retq
.Lfunc_end3:
	.size	iree_h2f_ieee, .Lfunc_end3-iree_h2f_ieee
	.cfi_endproc

	.section	.text.iree_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	iree_f2h_ieee,@function
iree_f2h_ieee:
.Lfunc_begin4:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB4_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB4_6
	testl	%edx, %edx
	je	.LBB4_4
	orl	$32767, %eax
	retq
.LBB4_1:
	movl	%ecx, %edi
.LBB4_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB4_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB4_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB4_9
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
.LBB4_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end4:
	.size	iree_f2h_ieee, .Lfunc_end4-iree_f2h_ieee
	.cfi_endproc

	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:
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
	.size	__gnu_h2f_ieee, .Lfunc_end5-__gnu_h2f_ieee
	.cfi_endproc

	.section	.text.__extendhfsf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfsf2,@function
__extendhfsf2:
.Lfunc_begin6:
	.cfi_startproc
	vmovd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB6_6
	cmpl	$31744, %esi
	jne	.LBB6_5
	testw	%dx, %dx
	je	.LBB6_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	retq
.LBB6_6:
	orl	$864026624, %eax
	movzwl	%dx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB6_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	retq
.LBB6_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	retq
.Lfunc_end6:
	.size	__extendhfsf2, .Lfunc_end6-__extendhfsf2
	.cfi_endproc

	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.prefalign	16
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:
.Lfunc_begin7:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB7_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB7_6
	testl	%edx, %edx
	je	.LBB7_4
	orl	$32767, %eax
	retq
.LBB7_1:
	movl	%ecx, %edi
.LBB7_9:
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.LBB7_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB7_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB7_9
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
.LBB7_4:
	movl	$31744, %edi
	andl	$32768, %eax
	orl	%edi, %eax
	retq
.Lfunc_end7:
	.size	__gnu_f2h_ieee, .Lfunc_end7-__gnu_f2h_ieee
	.cfi_endproc

	.section	.text.__truncsfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncsfhf2,@function
__truncsfhf2:
.Lfunc_begin8:
	.cfi_startproc
	vmovd	%xmm0, %esi
	movl	%esi, %eax
	shrl	$16, %eax
	movl	%esi, %ecx
	andl	$2139095040, %ecx
	je	.LBB8_1
	movl	%esi, %edx
	andl	$8388607, %edx
	cmpl	$2139095040, %ecx
	jne	.LBB8_6
	testl	%edx, %edx
	je	.LBB8_4
	orl	$32767, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.LBB8_1:
	movl	%ecx, %edi
	jmp	.LBB8_9
.LBB8_6:
	movl	$31744, %edi
	cmpl	$1191182336, %ecx
	ja	.LBB8_9
	xorl	%edi, %edi
	cmpl	$947912704, %ecx
	jb	.LBB8_9
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
	jmp	.LBB8_9
.LBB8_4:
	movl	$31744, %edi
.LBB8_9:
	andl	$32768, %eax
	orl	%edi, %eax
	movw	%ax, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	retq
.Lfunc_end8:
	.size	__truncsfhf2, .Lfunc_end8-__truncsfhf2
	.cfi_endproc

	.section	.text.__extendhfdf2,"ax",@progbits
	.prefalign	16
	.type	__extendhfdf2,@function
__extendhfdf2:
.Lfunc_begin9:
	.cfi_startproc
	vmovd	%xmm0, %ecx
	movl	%ecx, %edx
	andl	$1023, %edx
	movl	%ecx, %eax
	shll	$16, %eax
	andl	$-2147483648, %eax
	movl	%ecx, %esi
	andl	$31744, %esi
	je	.LBB9_6
	cmpl	$31744, %esi
	jne	.LBB9_5
	testw	%dx, %dx
	je	.LBB9_4
	orl	$2143289344, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB9_6:
	orl	$864026624, %eax
	movzwl	%dx, %ecx
	vcvtsi2ss	%ecx, %xmm15, %xmm0
	vmovd	%eax, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB9_5:
	andl	$32767, %ecx
	shll	$13, %ecx
	addl	%ecx, %eax
	addl	$939524096, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.LBB9_4:
	orl	$2139095040, %eax
	vmovd	%eax, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	retq
.Lfunc_end9:
	.size	__extendhfdf2, .Lfunc_end9-__extendhfdf2
	.cfi_endproc

	.section	.text.__truncdfhf2,"ax",@progbits
	.prefalign	16
	.type	__truncdfhf2,@function
__truncdfhf2:
.Lfunc_begin10:
	.cfi_startproc
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
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
	.size	__truncdfhf2, .Lfunc_end10-__truncdfhf2
	.cfi_endproc

	.section	.text.fma,"ax",@progbits
	.prefalign	16
	.type	fma,@function
fma:
.Lfunc_begin11:
	.cfi_startproc
	vfmadd213sd	%xmm2, %xmm1, %xmm0
	retq
.Lfunc_end11:
	.size	fma, .Lfunc_end11-fma
	.cfi_endproc

	.section	.text.__math_invalidf,"ax",@progbits
	.prefalign	16
	.type	__math_invalidf,@function
__math_invalidf:
.Lfunc_begin12:
	.cfi_startproc
	vsubss	%xmm0, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.Lfunc_end12:
	.size	__math_invalidf, .Lfunc_end12-__math_invalidf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI13_0:
	.long	0xf0000000
	.long	0x70000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI13_1:
	.long	0x70000000
	.section	.text.__math_oflowf,"ax",@progbits
	.prefalign	16
	.type	__math_oflowf,@function
__math_oflowf:
.Lfunc_begin13:
	.cfi_startproc
	xorl	%eax, %eax
	testl	%edi, %edi
	sete	%al
	leaq	.LCPI13_0(%rip), %rcx
	vmovss	(%rcx,%rax,4), %xmm0
	vmovss	%xmm0, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI13_1(%rip), %xmm0, %xmm0
	retq
.Lfunc_end13:
	.size	__math_oflowf, .Lfunc_end13-__math_oflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI14_0:
	.long	0x80000000
	.section	.text.__math_xflowf,"ax",@progbits
	.prefalign	16
	.type	__math_xflowf,@function
__math_xflowf:
.Lfunc_begin14:
	.cfi_startproc
	testl	%edi, %edi
	vxorps	.LCPI14_0(%rip){1to4}, %xmm0, %xmm1
	sete	%al
	kmovd	%eax, %k1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovss	%xmm1, -4(%rsp)
	vmulss	-4(%rsp), %xmm0, %xmm0
	retq
.Lfunc_end14:
	.size	__math_xflowf, .Lfunc_end14-__math_xflowf
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.LCPI15_0:
	.long	0x90000000
	.long	0x10000000
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI15_1:
	.long	0x10000000
	.section	.text.__math_uflowf,"ax",@progbits
	.prefalign	16
	.type	__math_uflowf,@function
__math_uflowf:
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
	.size	__math_uflowf, .Lfunc_end15-__math_uflowf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI16_0:
	.long	0x7b800000
.LCPI16_1:
	.long	0x80000000
.LCPI16_2:
	.long	0x3f800000
	.section	.text.ceilf,"ax",@progbits
	.prefalign	16
	.type	ceilf,@function
ceilf:
.Lfunc_begin16:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB16_7
	cmpl	$127, %ecx
	jb	.LBB16_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrxl	%ecx, %edx, %edx
	testl	%eax, %edx
	je	.LBB16_7
	vaddss	.LCPI16_0(%rip), %xmm0, %xmm0
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
.LBB16_4:
	vaddss	.LCPI16_0(%rip), %xmm0, %xmm1
	vmovss	%xmm1, -4(%rsp)
	testl	%eax, %eax
	js	.LBB16_5
	sete	%al
	kmovd	%eax, %k1
	vmovss	.LCPI16_2(%rip), %xmm1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovaps	%xmm1, %xmm0
.LBB16_7:
	retq
.LBB16_5:
	vmovss	.LCPI16_1(%rip), %xmm0
	retq
.Lfunc_end16:
	.size	ceilf, .Lfunc_end16-ceilf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI17_0:
	.long	0xff800000
.LCPI17_1:
	.long	0x42b17217
.LCPI17_2:
	.long	0xc2cff1b4
.LCPI17_3:
	.long	0x10000000
.LCPI17_4:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI17_5:
	.quad	0x40471547652b82fe
.LCPI17_6:
	.quad	0x4338000000000000
.LCPI17_7:
	.quad	0xc338000000000000
.LCPI17_8:
	.quad	0x3ebc6af84b912394
.LCPI17_9:
	.quad	0x3f2ebfce50fac4f3
.LCPI17_10:
	.quad	0x3f962e42ff0c52d6
.LCPI17_11:
	.quad	0x3ff0000000000000
	.section	.text.expf,"ax",@progbits
	.prefalign	16
	.type	expf,@function
expf:
.Lfunc_begin17:
	.cfi_startproc
	vmovd	%xmm0, %eax
	shrl	$20, %eax
	andl	$2047, %eax
	cmpl	$1067, %eax
	jae	.LBB17_1
.LBB17_8:
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	vmulsd	.LCPI17_5(%rip), %xmm0, %xmm0
	vaddsd	.LCPI17_6(%rip), %xmm0, %xmm1
	vmovq	%xmm1, %rax
	vaddsd	.LCPI17_7(%rip), %xmm1, %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	movl	%eax, %ecx
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	vmovsd	.LCPI17_8(%rip), %xmm1
	vmovq	%rax, %xmm2
	vfmadd213sd	.LCPI17_9(%rip), %xmm0, %xmm1
	vmulsd	%xmm0, %xmm0, %xmm3
	vmovsd	.LCPI17_10(%rip), %xmm4
	vfmadd213sd	.LCPI17_11(%rip), %xmm0, %xmm4
	vfmadd231sd	%xmm3, %xmm1, %xmm4
	vmulsd	%xmm2, %xmm4, %xmm0
	vcvtsd2ss	%xmm0, %xmm0, %xmm1
.LBB17_9:
	vmovaps	%xmm1, %xmm0
	retq
.LBB17_1:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	.LCPI17_0(%rip), %xmm2
	vucomiss	%xmm0, %xmm2
	jae	.LBB17_9
	cmpl	$2040, %eax
	jae	.LBB17_3
	vucomiss	.LCPI17_1(%rip), %xmm0
	jbe	.LBB17_6
	movl	$1879048192, -8(%rsp)
	vmovss	-8(%rsp), %xmm0
	vmulss	.LCPI17_4(%rip), %xmm0, %xmm0
	retq
.LBB17_3:
	vaddss	%xmm0, %xmm0, %xmm0
	retq
.LBB17_6:
	vmovss	.LCPI17_2(%rip), %xmm1
	vucomiss	%xmm0, %xmm1
	jbe	.LBB17_8
	movl	$268435456, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI17_3(%rip), %xmm0, %xmm0
	retq
.Lfunc_end17:
	.size	expf, .Lfunc_end17-expf
	.cfi_endproc

	.section	.text.feclearexcept,"ax",@progbits
	.prefalign	16
	.type	feclearexcept,@function
feclearexcept:
.Lfunc_begin18:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end18:
	.size	feclearexcept, .Lfunc_end18-feclearexcept
	.cfi_endproc

	.section	.text.feraiseexcept,"ax",@progbits
	.prefalign	16
	.type	feraiseexcept,@function
feraiseexcept:
.Lfunc_begin19:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end19:
	.size	feraiseexcept, .Lfunc_end19-feraiseexcept
	.cfi_endproc

	.section	.text.fetestexcept,"ax",@progbits
	.prefalign	16
	.type	fetestexcept,@function
fetestexcept:
.Lfunc_begin20:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end20:
	.size	fetestexcept, .Lfunc_end20-fetestexcept
	.cfi_endproc

	.section	.text.fegetround,"ax",@progbits
	.prefalign	16
	.type	fegetround,@function
fegetround:
.Lfunc_begin21:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end21:
	.size	fegetround, .Lfunc_end21-fegetround
	.cfi_endproc

	.section	.text.__fesetround,"ax",@progbits
	.prefalign	16
	.type	__fesetround,@function
__fesetround:
.Lfunc_begin22:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end22:
	.size	__fesetround, .Lfunc_end22-__fesetround
	.cfi_endproc

	.section	.text.fegetenv,"ax",@progbits
	.prefalign	16
	.type	fegetenv,@function
fegetenv:
.Lfunc_begin23:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end23:
	.size	fegetenv, .Lfunc_end23-fegetenv
	.cfi_endproc

	.section	.text.fesetenv,"ax",@progbits
	.prefalign	16
	.type	fesetenv,@function
fesetenv:
.Lfunc_begin24:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end24:
	.size	fesetenv, .Lfunc_end24-fesetenv
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI25_0:
	.long	0x7b800000
.LCPI25_1:
	.long	0xbf800000
	.section	.text.floorf,"ax",@progbits
	.prefalign	16
	.type	floorf,@function
floorf:
.Lfunc_begin25:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	jbe	.LBB25_1
	retq
.LBB25_1:
	cmpl	$127, %ecx
	jb	.LBB25_4
	addl	$-127, %ecx
	movl	$8388607, %edx
	shrxl	%ecx, %edx, %edx
	testl	%eax, %edx
	je	.LBB25_6
	vaddss	.LCPI25_0(%rip), %xmm0, %xmm0
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
.LBB25_4:
	vaddss	.LCPI25_0(%rip), %xmm0, %xmm1
	vmovss	%xmm1, -4(%rsp)
	vxorps	%xmm1, %xmm1, %xmm1
	testl	%eax, %eax
	jns	.LBB25_5
	vucomiss	%xmm1, %xmm0
	vmovaps	%xmm0, %xmm1
	jne	.LBB25_8
	jp	.LBB25_8
.LBB25_5:
	vmovaps	%xmm1, %xmm0
.LBB25_6:
	retq
.LBB25_8:
	vmovss	.LCPI25_1(%rip), %xmm1
	vmovaps	%xmm1, %xmm0
	retq
.Lfunc_end25:
	.size	floorf, .Lfunc_end25-floorf
	.cfi_endproc

	.section	.text.fmaf,"ax",@progbits
	.prefalign	16
	.type	fmaf,@function
fmaf:
.Lfunc_begin26:
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
	jne	.LBB26_4
	vsubsd	%xmm1, %xmm0, %xmm3
	vucomisd	%xmm2, %xmm3
	jne	.LBB26_3
	jp	.LBB26_3
	vsubsd	%xmm2, %xmm0, %xmm3
	vucomisd	%xmm1, %xmm3
	jne	.LBB26_3
	jp	.LBB26_3
.LBB26_4:
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
	retq
.LBB26_3:
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
.Lfunc_end26:
	.size	fmaf, .Lfunc_end26-fmaf
	.cfi_endproc

	.section	.text.fmodf,"ax",@progbits
	.prefalign	16
	.type	fmodf,@function
fmodf:
.Lfunc_begin27:
	.cfi_startproc
	vmovd	%xmm1, %edx
	movl	%edx, %esi
	addl	%edx, %esi
	je	.LBB27_2
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
	jne	.LBB27_3
.LBB27_2:
	vmulss	%xmm1, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.LBB27_3:
	leal	(%rax,%rax), %edi
	cmpl	%esi, %edi
	jbe	.LBB27_4
	movl	%edx, %esi
	shrl	$23, %esi
	movzbl	%sil, %edi
	testl	%ecx, %ecx
	je	.LBB27_6
	movl	%eax, %esi
	andl	$8388607, %esi
	orl	$8388608, %esi
	testl	%edi, %edi
	je	.LBB27_11
.LBB27_14:
	andl	$8388607, %edx
	orl	$8388608, %edx
	cmpl	%edi, %ecx
	jg	.LBB27_16
.LBB27_21:
	movl	%esi, %edi
	subl	%edx, %edi
	jns	.LBB27_22
	jmp	.LBB27_23
.LBB27_4:
	sete	%al
	vpxor	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	kmovd	%eax, %k1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
	retq
.LBB27_6:
	movl	%eax, %esi
	xorl	%ecx, %ecx
	shll	$9, %esi
	js	.LBB27_8
	.p2align	4
.LBB27_7:
	decl	%ecx
	addl	%esi, %esi
	jns	.LBB27_7
.LBB27_8:
	movb	$1, %sil
	subb	%cl, %sil
	shlxl	%esi, %eax, %esi
	testl	%edi, %edi
	jne	.LBB27_14
.LBB27_11:
	movl	%edx, %r8d
	xorl	%edi, %edi
	shll	$9, %r8d
	js	.LBB27_13
	.p2align	4
.LBB27_12:
	decl	%edi
	addl	%r8d, %r8d
	jns	.LBB27_12
.LBB27_13:
	movb	$1, %r8b
	subb	%dil, %r8b
	shlxl	%r8d, %edx, %edx
	cmpl	%edi, %ecx
	jg	.LBB27_16
	jmp	.LBB27_21
	.p2align	4
.LBB27_19:
	addl	%esi, %esi
	decl	%ecx
	cmpl	%edi, %ecx
	jle	.LBB27_20
.LBB27_16:
	movl	%esi, %r8d
	subl	%edx, %r8d
	js	.LBB27_19
	movl	%r8d, %esi
	jne	.LBB27_19
	jmp	.LBB27_18
.LBB27_20:
	movl	%edi, %ecx
	movl	%esi, %edi
	subl	%edx, %edi
	js	.LBB27_23
.LBB27_22:
	movl	%edi, %esi
	je	.LBB27_18
.LBB27_23:
	cmpl	$8388607, %esi
	ja	.LBB27_24
	.p2align	4
.LBB27_25:
	leal	(%rsi,%rsi), %edx
	decl	%ecx
	cmpl	$4194304, %esi
	movl	%edx, %esi
	jb	.LBB27_25
	andl	$-2147483648, %eax
	testl	%ecx, %ecx
	jle	.LBB27_28
.LBB27_27:
	addl	$-8388608, %edx
	shll	$23, %ecx
	orl	%edx, %ecx
	orl	%eax, %ecx
	vmovd	%ecx, %xmm0
	retq
.LBB27_18:
	vpxor	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB27_24:
	movl	%esi, %edx
	andl	$-2147483648, %eax
	testl	%ecx, %ecx
	jg	.LBB27_27
.LBB27_28:
	movb	$1, %sil
	subb	%cl, %sil
	shrxl	%esi, %edx, %ecx
	orl	%eax, %ecx
	vmovd	%ecx, %xmm0
	retq
.Lfunc_end27:
	.size	fmodf, .Lfunc_end27-fmodf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI28_0:
	.long	0x5f800000
	.section	.text.frexpf,"ax",@progbits
	.prefalign	16
	.type	frexpf,@function
frexpf:
.Lfunc_begin28:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	cmpb	$-1, %cl
	je	.LBB28_7
	movzbl	%cl, %edx
	testl	%edx, %edx
	jne	.LBB28_6
	vxorps	%xmm1, %xmm1, %xmm1
	vucomiss	%xmm1, %xmm0
	jne	.LBB28_4
	jnp	.LBB28_3
.LBB28_4:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	vmulss	.LCPI28_0(%rip), %xmm0, %xmm0
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
.LBB28_6:
	movzbl	%cl, %ecx
	addl	$-126, %ecx
	movl	%ecx, (%rdi)
	andl	$-2139095041, %eax
	orl	$1056964608, %eax
	vmovd	%eax, %xmm0
.LBB28_7:
	retq
.LBB28_3:
	xorl	%eax, %eax
	movl	%eax, (%rdi)
	retq
.Lfunc_end28:
	.size	frexpf, .Lfunc_end28-frexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI29_0:
	.long	0x0c800000
.LCPI29_1:
	.long	0x7f000000
	.section	.text.ldexpf,"ax",@progbits
	.prefalign	16
	.type	ldexpf,@function
ldexpf:
.Lfunc_begin29:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB29_4
	vmulss	.LCPI29_1(%rip), %xmm0, %xmm0
	cmpl	$255, %edi
	jb	.LBB29_2
	vmulss	.LCPI29_1(%rip), %xmm0, %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB29_8
.LBB29_4:
	cmpl	$-127, %edi
	jg	.LBB29_9
	vmulss	.LCPI29_0(%rip), %xmm0, %xmm0
	cmpl	$-229, %edi
	ja	.LBB29_6
	vmulss	.LCPI29_0(%rip), %xmm0, %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB29_8:
	movl	%eax, %edi
	jmp	.LBB29_9
.LBB29_2:
	addl	$-127, %edi
	jmp	.LBB29_9
.LBB29_6:
	addl	$102, %edi
.LBB29_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	vmovd	%edi, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.Lfunc_end29:
	.size	ldexpf, .Lfunc_end29-ldexpf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI30_0:
	.long	0x0c800000
.LCPI30_1:
	.long	0x7f000000
	.section	.text.scalbnf,"ax",@progbits
	.prefalign	16
	.type	scalbnf,@function
scalbnf:
.Lfunc_begin30:
	.cfi_startproc
	cmpl	$128, %edi
	jl	.LBB30_4
	vmulss	.LCPI30_1(%rip), %xmm0, %xmm0
	cmpl	$255, %edi
	jb	.LBB30_2
	vmulss	.LCPI30_1(%rip), %xmm0, %xmm0
	cmpl	$381, %edi
	movl	$381, %eax
	cmovbl	%edi, %eax
	addl	$-254, %eax
	jmp	.LBB30_8
.LBB30_4:
	cmpl	$-127, %edi
	jg	.LBB30_9
	vmulss	.LCPI30_0(%rip), %xmm0, %xmm0
	cmpl	$-229, %edi
	ja	.LBB30_6
	vmulss	.LCPI30_0(%rip), %xmm0, %xmm0
	cmpl	$-329, %edi
	movl	$-330, %eax
	cmovael	%edi, %eax
	addl	$204, %eax
.LBB30_8:
	movl	%eax, %edi
	jmp	.LBB30_9
.LBB30_2:
	addl	$-127, %edi
	jmp	.LBB30_9
.LBB30_6:
	addl	$102, %edi
.LBB30_9:
	shll	$23, %edi
	addl	$1065353216, %edi
	vmovd	%edi, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.Lfunc_end30:
	.size	scalbnf, .Lfunc_end30-scalbnf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI31_0:
	.long	0x3f800000
.LCPI31_1:
	.long	0x80000000
.LCPI31_2:
	.long	0x4b000000
.LCPI31_12:
	.long	0x10000000
.LCPI31_20:
	.long	0x70000000
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI31_3:
	.quad	0xbff0000000000000
.LCPI31_4:
	.quad	0x3fd27616c9496e0b
.LCPI31_5:
	.quad	0xbfd71969a075c67a
.LCPI31_6:
	.quad	0x3fdec70a6ca7badd
.LCPI31_7:
	.quad	0xbfe7154748bef6c8
.LCPI31_8:
	.quad	0x3ff71547652ab82b
.LCPI31_9:
	.quad	0x405fffffffd1d571
.LCPI31_10:
	.quad	0xc062c00000000000
.LCPI31_11:
	.long	0x90000000
	.long	0x10000000
.LCPI31_13:
	.quad	0x42e8000000000000
.LCPI31_14:
	.quad	0xc2e8000000000000
.LCPI31_15:
	.quad	0x3fac6af84b912394
.LCPI31_16:
	.quad	0x3fcebfce50fac4f3
.LCPI31_17:
	.quad	0x3fe62e42ff0c52d6
.LCPI31_18:
	.quad	0x3ff0000000000000
.LCPI31_19:
	.long	0xf0000000
	.long	0x70000000
	.section	.text.powf,"ax",@progbits
	.prefalign	16
	.type	powf,@function
powf:
.Lfunc_begin31:
	.cfi_startproc
	vmovd	%xmm0, %edx
	vmovd	%xmm1, %ecx
	leal	-2139095040(%rdx), %eax
	cmpl	$-2130706432, %eax
	jb	.LBB31_2
	xorl	%eax, %eax
	leal	16777216(,%rcx,2), %esi
	cmpl	$16777216, %esi
	jbe	.LBB31_2
.LBB31_24:
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
	vfmadd213sd	.LCPI31_3(%rip), %xmm0, %xmm2
	vcvtsi2sd	%esi, %xmm15, %xmm0
	vaddsd	8(%rcx,%rdi), %xmm0, %xmm0
	vmovsd	.LCPI31_4(%rip), %xmm3
	vfmadd213sd	.LCPI31_5(%rip), %xmm2, %xmm3
	vmulsd	%xmm2, %xmm2, %xmm4
	vmovsd	.LCPI31_6(%rip), %xmm5
	vfmadd213sd	.LCPI31_7(%rip), %xmm2, %xmm5
	vmulsd	%xmm4, %xmm4, %xmm6
	vfmadd231sd	.LCPI31_8(%rip), %xmm2, %xmm0
	vfmadd231sd	%xmm5, %xmm4, %xmm0
	vfmadd231sd	%xmm6, %xmm3, %xmm0
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	vmulsd	%xmm1, %xmm0, %xmm0
	vmovq	%xmm0, %rcx
	movabsq	$9223231299366420480, %rdx
	andq	%rcx, %rdx
	movabsq	$4638426141214900225, %rcx
	cmpq	%rcx, %rdx
	jae	.LBB31_25
.LBB31_29:
	vaddsd	.LCPI31_13(%rip), %xmm0, %xmm1
	vmovq	%xmm1, %rcx
	vaddsd	.LCPI31_14(%rip), %xmm1, %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	addl	%ecx, %eax
	andl	$31, %ecx
	leaq	__exp2f_data(%rip), %rdx
	shlq	$47, %rax
	addq	(%rdx,%rcx,8), %rax
	vmovsd	.LCPI31_15(%rip), %xmm1
	vmovq	%rax, %xmm2
	vfmadd213sd	.LCPI31_16(%rip), %xmm0, %xmm1
	vmulsd	%xmm0, %xmm0, %xmm3
	vmovsd	.LCPI31_17(%rip), %xmm4
	vfmadd213sd	.LCPI31_18(%rip), %xmm0, %xmm4
	vfmadd231sd	%xmm3, %xmm1, %xmm4
	vmulsd	%xmm2, %xmm4, %xmm0
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
.LBB31_30:
	retq
.LBB31_2:
	leal	(%rcx,%rcx), %eax
	leal	-1(%rax), %esi
	cmpl	$-16777217, %esi
	jae	.LBB31_3
	leal	-1(,%rdx,2), %eax
	cmpl	$-16777217, %eax
	jae	.LBB31_10
	xorl	%eax, %eax
	testl	%edx, %edx
	js	.LBB31_16
	cmpl	$8388607, %edx
	ja	.LBB31_24
.LBB31_23:
	vmulss	.LCPI31_2(%rip), %xmm0, %xmm0
	vmovd	%xmm0, %edx
	andl	$2147483647, %edx
	addl	$-192937984, %edx
	jmp	.LBB31_24
.LBB31_25:
	vucomisd	.LCPI31_9(%rip), %xmm0
	jbe	.LBB31_27
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI31_19(%rip), %rax
	vmovss	(%rax,%rcx,4), %xmm0
	vmovss	%xmm0, -8(%rsp)
	vmovss	-8(%rsp), %xmm0
	vmulss	.LCPI31_20(%rip), %xmm0, %xmm0
	retq
.LBB31_16:
	movl	%ecx, %eax
	shrl	$23, %eax
	movzbl	%al, %edx
	cmpl	$127, %edx
	jb	.LBB31_31
	cmpl	$150, %edx
	jbe	.LBB31_18
.LBB31_20:
	xorl	%eax, %eax
.LBB31_21:
	vmovd	%xmm0, %edx
	andl	$2147483647, %edx
	cmpl	$8388607, %edx
	ja	.LBB31_24
	jmp	.LBB31_23
.LBB31_27:
	vmovsd	.LCPI31_10(%rip), %xmm1
	vucomisd	%xmm0, %xmm1
	jb	.LBB31_29
	xorl	%ecx, %ecx
	testl	%eax, %eax
	sete	%cl
	leaq	.LCPI31_11(%rip), %rax
	vmovss	(%rax,%rcx,4), %xmm0
	vmovss	%xmm0, -4(%rsp)
	vmovss	-4(%rsp), %xmm0
	vmulss	.LCPI31_12(%rip), %xmm0, %xmm0
	retq
.LBB31_18:
	movb	$-106, %dl
	subb	%al, %dl
	bzhil	%edx, %ecx, %eax
	je	.LBB31_19
.LBB31_31:
	vsubss	%xmm0, %xmm0, %xmm0
	vdivss	%xmm0, %xmm0, %xmm0
	retq
.LBB31_19:
	movl	$1, %eax
	shlxl	%edx, %eax, %edx
	movl	$65536, %eax
	testl	%ecx, %edx
	jne	.LBB31_21
	jmp	.LBB31_20
.LBB31_3:
	vmovdqa	%xmm0, %xmm2
	vmovss	.LCPI31_0(%rip), %xmm0
	cmpl	$1065353216, %edx
	je	.LBB31_30
	testl	%eax, %eax
	je	.LBB31_30
	addl	%edx, %edx
	cmpl	$-16777215, %edx
	setb	%sil
	cmpl	$-16777215, %eax
	setb	%al
	testb	%al, %sil
	jne	.LBB31_7
	vaddss	%xmm1, %xmm2, %xmm0
	retq
.LBB31_10:
	vmulss	%xmm0, %xmm0, %xmm0
	testl	%edx, %edx
	jns	.LBB31_13
	movl	%ecx, %eax
	shrl	$23, %eax
	movzbl	%al, %edx
	addl	$-151, %edx
	cmpl	$-24, %edx
	jb	.LBB31_13
	movb	$-106, %dl
	subb	%al, %dl
	bzhil	%edx, %ecx, %eax
	setne	%al
	movzbl	%dl, %edx
	btl	%edx, %ecx
	setae	%dl
	vxorps	.LCPI31_1(%rip){1to4}, %xmm0, %xmm1
	kmovd	%edx, %k1
	kmovd	%eax, %k2
	vmovss	%xmm0, %xmm1, %xmm1 {%k2}
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vmovaps	%xmm1, %xmm0
.LBB31_13:
	testl	%ecx, %ecx
	jns	.LBB31_30
	vmovss	.LCPI31_0(%rip), %xmm1
	vdivss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, -12(%rsp)
	vmovss	-12(%rsp), %xmm0
	retq
.LBB31_7:
	cmpl	$2130706432, %edx
	je	.LBB31_30
	setb	%al
	testl	%ecx, %ecx
	sets	%cl
	xorb	%al, %cl
	vmulss	%xmm1, %xmm1, %xmm0
	kmovd	%ecx, %k1
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
	retq
.Lfunc_end31:
	.size	powf, .Lfunc_end31-powf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI32_0:
	.long	0xcb000000
.LCPI32_1:
	.long	0x4b000000
.LCPI32_2:
	.long	0x80000000
	.section	.text.rintf,"ax",@progbits
	.prefalign	16
	.type	rintf,@function
rintf:
.Lfunc_begin32:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	andl	$2130706432, %ecx
	cmpl	$1249902592, %ecx
	ja	.LBB32_4
	testl	%eax, %eax
	setns	%cl
	vmovss	.LCPI32_0(%rip), %xmm2
	vaddss	%xmm2, %xmm0, %xmm1
	vmovss	.LCPI32_1(%rip), %xmm3
	vaddss	%xmm3, %xmm1, %xmm1
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	kmovd	%ecx, %k1
	vmovss	%xmm0, %xmm1, %xmm1 {%k1}
	vxorps	%xmm0, %xmm0, %xmm0
	vucomiss	%xmm0, %xmm1
	jne	.LBB32_2
	jp	.LBB32_2
	testl	%eax, %eax
	setns	%al
	kmovd	%eax, %k1
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	.LCPI32_2(%rip), %xmm0
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
.LBB32_4:
	retq
.LBB32_2:
	vmovaps	%xmm1, %xmm0
	retq
.Lfunc_end32:
	.size	rintf, .Lfunc_end32-rintf
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI33_0:
	.long	0x7fffffff
.LCPI33_1:
	.long	0x4b000000
.LCPI33_2:
	.long	0xcb000000
.LCPI33_3:
	.long	0x3f000000
.LCPI33_4:
	.long	0xbf000000
.LCPI33_5:
	.long	0x3f800000
.LCPI33_6:
	.long	0xbf800000
.LCPI33_7:
	.long	0x80000000
	.section	.text.roundf,"ax",@progbits
	.prefalign	16
	.type	roundf,@function
roundf:
.Lfunc_begin33:
	.cfi_startproc
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	shrl	$23, %ecx
	movzbl	%cl, %ecx
	cmpl	$149, %ecx
	ja	.LBB33_8
	vpandd	.LCPI33_0(%rip){1to4}, %xmm0, %xmm1
	vaddss	.LCPI33_1(%rip), %xmm1, %xmm2
	cmpl	$125, %ecx
	ja	.LBB33_3
	vmovss	%xmm2, -4(%rsp)
	vxorps	%xmm1, %xmm1, %xmm1
	vmulss	%xmm1, %xmm0, %xmm0
	retq
.LBB33_3:
	vaddss	.LCPI33_2(%rip), %xmm2, %xmm0
	vsubss	%xmm1, %xmm0, %xmm0
	vucomiss	.LCPI33_3(%rip), %xmm0
	jbe	.LBB33_5
	vaddss	%xmm0, %xmm1, %xmm0
	vaddss	.LCPI33_6(%rip), %xmm0, %xmm0
	jmp	.LBB33_7
.LBB33_5:
	vmovss	.LCPI33_4(%rip), %xmm2
	vucomiss	%xmm0, %xmm2
	vaddss	%xmm0, %xmm1, %xmm0
	jb	.LBB33_7
	vaddss	.LCPI33_5(%rip), %xmm0, %xmm0
.LBB33_7:
	vxorps	.LCPI33_7(%rip){1to4}, %xmm0, %xmm1
	testl	%eax, %eax
	sets	%al
	kmovd	%eax, %k1
	vmovss	%xmm1, %xmm0, %xmm0 {%k1}
.LBB33_8:
	retq
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
	.long	6
	.zero	4
	.quad	__unnamed_1
	.long	0
	.long	0
	.size	iree_hal_executable_library_query_v0_header, 24

	.type	iree_hal_executable_library_query_v0_funcs,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_funcs,"aw",@progbits
	.p2align	3, 0x0
iree_hal_executable_library_query_v0_funcs:
	.quad	infer_dispatch_0_matmul_Dx64x9_f32
	.quad	infer_dispatch_1_matmul_Dx2x64_f32
	.size	iree_hal_executable_library_query_v0_funcs, 16

	.type	iree_hal_executable_library_query_v0_attrs,@object
	.section	.rodata.iree_hal_executable_library_query_v0_attrs,"a",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_attrs:
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
	.quad	__unnamed_2
	.quad	__unnamed_3
	.size	iree_hal_executable_library_query_v0_names, 16

	.type	__unnamed_4,@object
	.section	.rodata.__unnamed_4,"a",@progbits
__unnamed_4:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/dynamic/configured_module_infer_dispatch_0.mlir"
	.size	__unnamed_4, 85

	.type	__unnamed_5,@object
	.section	.rodata.__unnamed_5,"a",@progbits
__unnamed_5:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/dynamic/configured_module_infer_dispatch_1.mlir"
	.size	__unnamed_5, 85

	.type	iree_hal_executable_library_query_v0_source_locations,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0_source_locations,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0_source_locations:
	.long	3
	.long	84
	.quad	__unnamed_4
	.long	3
	.long	84
	.quad	__unnamed_5
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
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations
	.long	0
	.zero	4
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names
	.quad	iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations
	.size	iree_hal_executable_library_query_v0_stage_location_tables, 48

	.type	iree_hal_executable_library_query_v0,@object
	.section	.data.rel.ro.iree_hal_executable_library_query_v0,"aw",@progbits
	.p2align	4, 0x0
iree_hal_executable_library_query_v0:
	.quad	iree_hal_executable_library_query_v0_header
	.zero	16
	.long	2
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
	.long	.Linfo_string4
	.long	.Linfo_string4
	.byte	1
	.byte	1
	.long	71

	.byte	3
	.long	.Linfo_string5
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
	.long	.Linfo_string6
	.long	.Linfo_string6
	.byte	2
	.byte	1
	.long	.debug_info+71

	.byte	0
.Ldebug_info_end1:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"IREE"
.Linfo_string1:
	.asciz	"configured_module_infer_dispatch_0.mlir"
.Linfo_string2:
	.asciz	"results/e14_aarch64_qemu/x86_64/dump/dynamic"
.Linfo_string3:
	.asciz	"configured_module_infer_dispatch_1.mlir"
.Linfo_string4:
	.asciz	"infer_dispatch_0_matmul_Dx64x9_f32"
.Linfo_string5:
	.asciz	"int"
.Linfo_string6:
	.asciz	"infer_dispatch_1_matmul_Dx2x64_f32"
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.short	2
	.long	.Lcu_begin0
	.long	79
	.long	42
	.asciz	"infer_dispatch_0_matmul_Dx64x9_f32"
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
	.asciz	"infer_dispatch_1_matmul_Dx2x64_f32"
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
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
