; ModuleID = 'dyn_batch_mlp_linked'
source_filename = "dyn_batch_mlp_linked"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-unknown-eabi-elf"

%iree_hal_executable_library_header_t = type { i32, ptr, i32, i32 }
%iree_hal_executable_dispatch_attrs_v0_t = type { i64, i16, i8, i8, i32, i32, i16, i16, i64, i64, i64, i64, i64 }
%iree_hal_executable_source_location_v0_t = type { i32, i32, ptr }
%iree_hal_executable_stage_location_table_v0_t = type { i32, ptr, ptr }
%iree_hal_executable_library_v0_t = type { ptr, %iree_hal_executable_import_table_v0_t, %iree_hal_executable_export_table_v0_t, %iree_hal_executable_constant_table_v0_t, %iree_hal_executable_source_file_table_v0_t }
%iree_hal_executable_import_table_v0_t = type { i32, ptr }
%iree_hal_executable_export_table_v0_t = type { i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%iree_hal_executable_constant_table_v0_t = type { i32 }
%iree_hal_executable_source_file_table_v0_t = type { i32, ptr }
%struct.exp2f_data = type { [32 x i64], double, [3 x double], double, double, [3 x double] }
%struct.powf_log2_data = type { [16 x %struct.anon], [5 x double] }
%struct.anon = type { double, double }

@0 = internal constant [21 x i8] c"dyn_batch_mlp_linked\00", align 1
@iree_hal_executable_library_query_v0_header = internal constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = internal constant [2 x ptr] [ptr @infer_dispatch_0_matmul_Dx64x9_f32, ptr @infer_dispatch_1_matmul_Dx2x64_f32]
@iree_hal_executable_library_query_v0_attrs = internal constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = internal constant [35 x i8] c"infer_dispatch_0_matmul_Dx64x9_f32\00", align 1
@2 = internal constant [35 x i8] c"infer_dispatch_1_matmul_Dx2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = internal constant [2 x ptr] [ptr @1, ptr @2]
@3 = internal constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = internal constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = internal constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @4 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = internal constant [2 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = internal constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 2, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = internal local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = internal local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_0_matmul_Dx64x9_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !11 {
  %.elt25 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !87
  %.unpack26 = load ptr, ptr %.elt25, align 8, !dbg !87
  %.elt27 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !87
  %.unpack28 = load ptr, ptr %.elt27, align 16, !dbg !87
  %4 = load i64, ptr %.unpack26, align 4, !dbg !87
  %5 = getelementptr i8, ptr %.unpack28, i64 8, !dbg !88
  %6 = load ptr, ptr %5, align 8, !dbg !88
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !88
  %7 = load ptr, ptr %.unpack28, align 8, !dbg !89
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !89
  %8 = getelementptr i8, ptr %.unpack28, i64 16, !dbg !90
  %9 = load ptr, ptr %8, align 8, !dbg !90
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !90
  %10 = load i32, ptr %2, align 16, !dbg !91
  %11 = zext i32 %10 to i64, !dbg !91
  %12 = shl nuw nsw i64 %11, 3, !dbg !91
  %13 = and i64 %12, 34359738304, !dbg !91
  %14 = and i64 %12, 56, !dbg !91
  %15 = sub i64 %4, %13, !dbg !91
  %16 = tail call i64 @llvm.smin.i64(i64 %15, i64 64), !dbg !91
  %.lobit = ashr i64 %15, 63, !dbg !91
  %17 = xor i64 %16, %.lobit, !dbg !91
  %18 = sdiv i64 %17, 64, !dbg !91
  %19 = xor i64 %18, %.lobit, !dbg !91
  %20 = shl nsw i64 %19, 6, !dbg !91
  %21 = icmp sgt i64 %19, 0, !dbg !91
  br i1 %21, label %22, label %.preheader62, !dbg !91

22:                                               ; preds = %3
  %23 = getelementptr [4 x i8], ptr %6, i64 %14, !dbg !91
  %24 = getelementptr i8, ptr %23, i64 2048, !dbg !91
  %25 = load <8 x float>, ptr %24, align 32, !dbg !91
  %invariant.gep70 = getelementptr [4 x i8], ptr %9, i64 %14, !dbg !91
  br label %.preheader63, !dbg !91

.preheader63:                                     ; preds = %22, %225
  %26 = phi i64 [ 0, %22 ], [ %281, %225 ]
  %27 = add nuw nsw i64 %26, %13
  %.idx129 = mul nuw nsw i64 %27, 36
  %28 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx129
  %29 = getelementptr inbounds nuw i8, ptr %28, i64 36
  %30 = getelementptr inbounds nuw i8, ptr %28, i64 72
  %31 = getelementptr inbounds nuw i8, ptr %28, i64 108
  %32 = getelementptr inbounds nuw i8, ptr %28, i64 144
  %33 = getelementptr inbounds nuw i8, ptr %28, i64 180
  %34 = getelementptr inbounds nuw i8, ptr %28, i64 216
  %35 = getelementptr inbounds nuw i8, ptr %28, i64 252
  br label %38, !dbg !91

.preheader62:                                     ; preds = %225, %3
  %36 = icmp slt i64 %20, %16, !dbg !91
  br i1 %36, label %.lr.ph98, label %._crit_edge99, !dbg !91

.lr.ph98:                                         ; preds = %.preheader62
  %invariant.gep90 = getelementptr inbounds nuw [4 x i8], ptr %9, i64 %14
  %37 = sub i64 %16, %20, !dbg !91
  br label %283, !dbg !91

38:                                               ; preds = %.preheader63, %38
  %39 = phi [8 x <8 x float>] [ zeroinitializer, %.preheader63 ], [ %224, %38 ]
  %40 = phi i1 [ true, %.preheader63 ], [ false, %38 ]
  %41 = phi i64 [ 0, %.preheader63 ], [ 4, %38 ]
  %.idx53 = shl nuw nsw i64 %41, 8, !dbg !91
  %gep = getelementptr i8, ptr %23, i64 %.idx53, !dbg !91
  %42 = load <8 x float>, ptr %gep, align 32, !dbg !91
  %43 = or disjoint i64 %41, 1, !dbg !91
  %.idx54 = shl nuw nsw i64 %43, 8, !dbg !91
  %gep65 = getelementptr i8, ptr %23, i64 %.idx54, !dbg !91
  %44 = load <8 x float>, ptr %gep65, align 32, !dbg !91
  %45 = or disjoint i64 %41, 2, !dbg !91
  %.idx55 = shl nuw nsw i64 %45, 8, !dbg !91
  %gep67 = getelementptr i8, ptr %23, i64 %.idx55, !dbg !91
  %46 = load <8 x float>, ptr %gep67, align 32, !dbg !91
  %47 = or disjoint i64 %41, 3, !dbg !91
  %.idx56 = shl nuw nsw i64 %47, 8, !dbg !91
  %gep69 = getelementptr i8, ptr %23, i64 %.idx56, !dbg !91
  %48 = load <8 x float>, ptr %gep69, align 32, !dbg !91
  %49 = getelementptr inbounds nuw [4 x i8], ptr %28, i64 %41, !dbg !92
  %50 = load float, ptr %49, align 16, !dbg !92
  %51 = insertelement <8 x float> poison, float %50, i64 0, !dbg !92
  %52 = shufflevector <8 x float> %51, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %53 = extractvalue [8 x <8 x float>] %39, 0, !dbg !92
  %54 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %52, <8 x float> %42, <8 x float> %53), !dbg !92
  %55 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %41, !dbg !92
  %56 = load float, ptr %55, align 4, !dbg !92
  %57 = insertelement <8 x float> poison, float %56, i64 0, !dbg !92
  %58 = shufflevector <8 x float> %57, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %59 = extractvalue [8 x <8 x float>] %39, 1, !dbg !92
  %60 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %58, <8 x float> %42, <8 x float> %59), !dbg !92
  %61 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %41, !dbg !92
  %62 = load float, ptr %61, align 8, !dbg !92
  %63 = insertelement <8 x float> poison, float %62, i64 0, !dbg !92
  %64 = shufflevector <8 x float> %63, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %65 = extractvalue [8 x <8 x float>] %39, 2, !dbg !92
  %66 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %64, <8 x float> %42, <8 x float> %65), !dbg !92
  %67 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %41, !dbg !92
  %68 = load float, ptr %67, align 4, !dbg !92
  %69 = insertelement <8 x float> poison, float %68, i64 0, !dbg !92
  %70 = shufflevector <8 x float> %69, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %71 = extractvalue [8 x <8 x float>] %39, 3, !dbg !92
  %72 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %70, <8 x float> %42, <8 x float> %71), !dbg !92
  %73 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %41, !dbg !92
  %74 = load float, ptr %73, align 16, !dbg !92
  %75 = insertelement <8 x float> poison, float %74, i64 0, !dbg !92
  %76 = shufflevector <8 x float> %75, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %77 = extractvalue [8 x <8 x float>] %39, 4, !dbg !92
  %78 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %76, <8 x float> %42, <8 x float> %77), !dbg !92
  %79 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %41, !dbg !92
  %80 = load float, ptr %79, align 4, !dbg !92
  %81 = insertelement <8 x float> poison, float %80, i64 0, !dbg !92
  %82 = shufflevector <8 x float> %81, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %83 = extractvalue [8 x <8 x float>] %39, 5, !dbg !92
  %84 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %82, <8 x float> %42, <8 x float> %83), !dbg !92
  %85 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %41, !dbg !92
  %86 = load float, ptr %85, align 8, !dbg !92
  %87 = insertelement <8 x float> poison, float %86, i64 0, !dbg !92
  %88 = shufflevector <8 x float> %87, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %89 = extractvalue [8 x <8 x float>] %39, 6, !dbg !92
  %90 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %88, <8 x float> %42, <8 x float> %89), !dbg !92
  %91 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %41, !dbg !92
  %92 = load float, ptr %91, align 4, !dbg !92
  %93 = insertelement <8 x float> poison, float %92, i64 0, !dbg !92
  %94 = shufflevector <8 x float> %93, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %95 = extractvalue [8 x <8 x float>] %39, 7, !dbg !92
  %96 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %42, <8 x float> %95), !dbg !92
  %97 = getelementptr inbounds nuw [4 x i8], ptr %28, i64 %43, !dbg !92
  %98 = load float, ptr %97, align 4, !dbg !92
  %99 = insertelement <8 x float> poison, float %98, i64 0, !dbg !92
  %100 = shufflevector <8 x float> %99, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %101 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %100, <8 x float> %44, <8 x float> %54), !dbg !92
  %102 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %43, !dbg !92
  %103 = load float, ptr %102, align 8, !dbg !92
  %104 = insertelement <8 x float> poison, float %103, i64 0, !dbg !92
  %105 = shufflevector <8 x float> %104, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %106 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %105, <8 x float> %44, <8 x float> %60), !dbg !92
  %107 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %43, !dbg !92
  %108 = load float, ptr %107, align 4, !dbg !92
  %109 = insertelement <8 x float> poison, float %108, i64 0, !dbg !92
  %110 = shufflevector <8 x float> %109, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %111 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %110, <8 x float> %44, <8 x float> %66), !dbg !92
  %112 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %43, !dbg !92
  %113 = load float, ptr %112, align 16, !dbg !92
  %114 = insertelement <8 x float> poison, float %113, i64 0, !dbg !92
  %115 = shufflevector <8 x float> %114, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %116 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %115, <8 x float> %44, <8 x float> %72), !dbg !92
  %117 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %43, !dbg !92
  %118 = load float, ptr %117, align 4, !dbg !92
  %119 = insertelement <8 x float> poison, float %118, i64 0, !dbg !92
  %120 = shufflevector <8 x float> %119, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %121 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %120, <8 x float> %44, <8 x float> %78), !dbg !92
  %122 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %43, !dbg !92
  %123 = load float, ptr %122, align 8, !dbg !92
  %124 = insertelement <8 x float> poison, float %123, i64 0, !dbg !92
  %125 = shufflevector <8 x float> %124, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %126 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %125, <8 x float> %44, <8 x float> %84), !dbg !92
  %127 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %43, !dbg !92
  %128 = load float, ptr %127, align 4, !dbg !92
  %129 = insertelement <8 x float> poison, float %128, i64 0, !dbg !92
  %130 = shufflevector <8 x float> %129, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %131 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %130, <8 x float> %44, <8 x float> %90), !dbg !92
  %132 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %43, !dbg !92
  %133 = load float, ptr %132, align 16, !dbg !92
  %134 = insertelement <8 x float> poison, float %133, i64 0, !dbg !92
  %135 = shufflevector <8 x float> %134, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %136 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %135, <8 x float> %44, <8 x float> %96), !dbg !92
  %137 = getelementptr inbounds nuw [4 x i8], ptr %28, i64 %45, !dbg !92
  %138 = load float, ptr %137, align 8, !dbg !92
  %139 = insertelement <8 x float> poison, float %138, i64 0, !dbg !92
  %140 = shufflevector <8 x float> %139, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %141 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %140, <8 x float> %46, <8 x float> %101), !dbg !92
  %142 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %45, !dbg !92
  %143 = load float, ptr %142, align 4, !dbg !92
  %144 = insertelement <8 x float> poison, float %143, i64 0, !dbg !92
  %145 = shufflevector <8 x float> %144, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %146 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %145, <8 x float> %46, <8 x float> %106), !dbg !92
  %147 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %45, !dbg !92
  %148 = load float, ptr %147, align 16, !dbg !92
  %149 = insertelement <8 x float> poison, float %148, i64 0, !dbg !92
  %150 = shufflevector <8 x float> %149, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %151 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %150, <8 x float> %46, <8 x float> %111), !dbg !92
  %152 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %45, !dbg !92
  %153 = load float, ptr %152, align 4, !dbg !92
  %154 = insertelement <8 x float> poison, float %153, i64 0, !dbg !92
  %155 = shufflevector <8 x float> %154, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %156 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %155, <8 x float> %46, <8 x float> %116), !dbg !92
  %157 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %45, !dbg !92
  %158 = load float, ptr %157, align 8, !dbg !92
  %159 = insertelement <8 x float> poison, float %158, i64 0, !dbg !92
  %160 = shufflevector <8 x float> %159, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %161 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %160, <8 x float> %46, <8 x float> %121), !dbg !92
  %162 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %45, !dbg !92
  %163 = load float, ptr %162, align 4, !dbg !92
  %164 = insertelement <8 x float> poison, float %163, i64 0, !dbg !92
  %165 = shufflevector <8 x float> %164, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %166 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %165, <8 x float> %46, <8 x float> %126), !dbg !92
  %167 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %45, !dbg !92
  %168 = load float, ptr %167, align 16, !dbg !92
  %169 = insertelement <8 x float> poison, float %168, i64 0, !dbg !92
  %170 = shufflevector <8 x float> %169, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %171 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %170, <8 x float> %46, <8 x float> %131), !dbg !92
  %172 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %45, !dbg !92
  %173 = load float, ptr %172, align 4, !dbg !92
  %174 = insertelement <8 x float> poison, float %173, i64 0, !dbg !92
  %175 = shufflevector <8 x float> %174, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %176 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %175, <8 x float> %46, <8 x float> %136), !dbg !92
  %177 = getelementptr inbounds nuw [4 x i8], ptr %28, i64 %47, !dbg !92
  %178 = load float, ptr %177, align 4, !dbg !92
  %179 = insertelement <8 x float> poison, float %178, i64 0, !dbg !92
  %180 = shufflevector <8 x float> %179, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %181 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %180, <8 x float> %48, <8 x float> %141), !dbg !92
  %182 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %47, !dbg !92
  %183 = load float, ptr %182, align 16, !dbg !92
  %184 = insertelement <8 x float> poison, float %183, i64 0, !dbg !92
  %185 = shufflevector <8 x float> %184, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %186 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %185, <8 x float> %48, <8 x float> %146), !dbg !92
  %187 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %47, !dbg !92
  %188 = load float, ptr %187, align 4, !dbg !92
  %189 = insertelement <8 x float> poison, float %188, i64 0, !dbg !92
  %190 = shufflevector <8 x float> %189, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %191 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %190, <8 x float> %48, <8 x float> %151), !dbg !92
  %192 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %47, !dbg !92
  %193 = load float, ptr %192, align 8, !dbg !92
  %194 = insertelement <8 x float> poison, float %193, i64 0, !dbg !92
  %195 = shufflevector <8 x float> %194, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %196 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %195, <8 x float> %48, <8 x float> %156), !dbg !92
  %197 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %47, !dbg !92
  %198 = load float, ptr %197, align 4, !dbg !92
  %199 = insertelement <8 x float> poison, float %198, i64 0, !dbg !92
  %200 = shufflevector <8 x float> %199, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %201 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %200, <8 x float> %48, <8 x float> %161), !dbg !92
  %202 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %47, !dbg !92
  %203 = load float, ptr %202, align 16, !dbg !92
  %204 = insertelement <8 x float> poison, float %203, i64 0, !dbg !92
  %205 = shufflevector <8 x float> %204, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %206 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %205, <8 x float> %48, <8 x float> %166), !dbg !92
  %207 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %47, !dbg !92
  %208 = load float, ptr %207, align 4, !dbg !92
  %209 = insertelement <8 x float> poison, float %208, i64 0, !dbg !92
  %210 = shufflevector <8 x float> %209, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %211 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %210, <8 x float> %48, <8 x float> %171), !dbg !92
  %212 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %47, !dbg !92
  %213 = load float, ptr %212, align 8, !dbg !92
  %214 = insertelement <8 x float> poison, float %213, i64 0, !dbg !92
  %215 = shufflevector <8 x float> %214, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %216 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %215, <8 x float> %48, <8 x float> %176), !dbg !92
  %217 = insertvalue [8 x <8 x float>] poison, <8 x float> %181, 0, !dbg !92
  %218 = insertvalue [8 x <8 x float>] %217, <8 x float> %186, 1, !dbg !92
  %219 = insertvalue [8 x <8 x float>] %218, <8 x float> %191, 2, !dbg !92
  %220 = insertvalue [8 x <8 x float>] %219, <8 x float> %196, 3, !dbg !92
  %221 = insertvalue [8 x <8 x float>] %220, <8 x float> %201, 4, !dbg !92
  %222 = insertvalue [8 x <8 x float>] %221, <8 x float> %206, 5, !dbg !92
  %223 = insertvalue [8 x <8 x float>] %222, <8 x float> %211, 6, !dbg !92
  %224 = insertvalue [8 x <8 x float>] %223, <8 x float> %216, 7, !dbg !92
  br i1 %40, label %38, label %225, !dbg !91

225:                                              ; preds = %38
  %.idx37 = mul nuw nsw i64 %27, 36, !dbg !92
  %226 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx37, !dbg !92
  %227 = getelementptr inbounds nuw i8, ptr %226, i64 32, !dbg !92
  %228 = load float, ptr %227, align 32, !dbg !92
  %229 = insertelement <8 x float> poison, float %228, i64 0, !dbg !92
  %230 = shufflevector <8 x float> %229, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %231 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %230, <8 x float> %25, <8 x float> %181), !dbg !92
  %232 = or disjoint i64 %27, 1, !dbg !92
  %.idx38 = mul nuw nsw i64 %232, 36, !dbg !92
  %233 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx38, !dbg !92
  %234 = getelementptr inbounds nuw i8, ptr %233, i64 32, !dbg !92
  %235 = load float, ptr %234, align 4, !dbg !92
  %236 = insertelement <8 x float> poison, float %235, i64 0, !dbg !92
  %237 = shufflevector <8 x float> %236, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %238 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %237, <8 x float> %25, <8 x float> %186), !dbg !92
  %239 = or disjoint i64 %27, 2, !dbg !92
  %.idx39 = mul nuw nsw i64 %239, 36, !dbg !92
  %240 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx39, !dbg !92
  %241 = getelementptr inbounds nuw i8, ptr %240, i64 32, !dbg !92
  %242 = load float, ptr %241, align 8, !dbg !92
  %243 = insertelement <8 x float> poison, float %242, i64 0, !dbg !92
  %244 = shufflevector <8 x float> %243, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %245 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %244, <8 x float> %25, <8 x float> %191), !dbg !92
  %246 = or disjoint i64 %27, 3, !dbg !92
  %.idx40 = mul nuw nsw i64 %246, 36, !dbg !92
  %247 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx40, !dbg !92
  %248 = getelementptr inbounds nuw i8, ptr %247, i64 32, !dbg !92
  %249 = load float, ptr %248, align 4, !dbg !92
  %250 = insertelement <8 x float> poison, float %249, i64 0, !dbg !92
  %251 = shufflevector <8 x float> %250, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %252 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %251, <8 x float> %25, <8 x float> %196), !dbg !92
  %253 = or disjoint i64 %27, 4, !dbg !92
  %.idx41 = mul nuw nsw i64 %253, 36, !dbg !92
  %254 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx41, !dbg !92
  %255 = getelementptr inbounds nuw i8, ptr %254, i64 32, !dbg !92
  %256 = load float, ptr %255, align 16, !dbg !92
  %257 = insertelement <8 x float> poison, float %256, i64 0, !dbg !92
  %258 = shufflevector <8 x float> %257, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %259 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %258, <8 x float> %25, <8 x float> %201), !dbg !92
  %260 = or disjoint i64 %27, 5, !dbg !92
  %.idx42 = mul nuw nsw i64 %260, 36, !dbg !92
  %261 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx42, !dbg !92
  %262 = getelementptr inbounds nuw i8, ptr %261, i64 32, !dbg !92
  %263 = load float, ptr %262, align 4, !dbg !92
  %264 = insertelement <8 x float> poison, float %263, i64 0, !dbg !92
  %265 = shufflevector <8 x float> %264, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %266 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %265, <8 x float> %25, <8 x float> %206), !dbg !92
  %267 = or disjoint i64 %27, 6, !dbg !92
  %.idx43 = mul nuw nsw i64 %267, 36, !dbg !92
  %268 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx43, !dbg !92
  %269 = getelementptr inbounds nuw i8, ptr %268, i64 32, !dbg !92
  %270 = load float, ptr %269, align 8, !dbg !92
  %271 = insertelement <8 x float> poison, float %270, i64 0, !dbg !92
  %272 = shufflevector <8 x float> %271, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %273 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %272, <8 x float> %25, <8 x float> %211), !dbg !92
  %274 = or disjoint i64 %27, 7, !dbg !92
  %.idx44 = mul nuw nsw i64 %274, 36, !dbg !92
  %275 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx44, !dbg !92
  %276 = getelementptr inbounds nuw i8, ptr %275, i64 32, !dbg !92
  %277 = load float, ptr %276, align 4, !dbg !92
  %278 = insertelement <8 x float> poison, float %277, i64 0, !dbg !92
  %279 = shufflevector <8 x float> %278, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !92
  %280 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %279, <8 x float> %25, <8 x float> %216), !dbg !92
  %.idx45 = shl i64 %27, 8, !dbg !91
  %gep71 = getelementptr i8, ptr %invariant.gep70, i64 %.idx45, !dbg !91
  store <8 x float> %231, ptr %gep71, align 32, !dbg !91
  %.idx46 = shl i64 %232, 8, !dbg !91
  %gep73 = getelementptr i8, ptr %invariant.gep70, i64 %.idx46, !dbg !91
  store <8 x float> %238, ptr %gep73, align 32, !dbg !91
  %.idx47 = shl i64 %239, 8, !dbg !91
  %gep75 = getelementptr i8, ptr %invariant.gep70, i64 %.idx47, !dbg !91
  store <8 x float> %245, ptr %gep75, align 32, !dbg !91
  %.idx48 = shl i64 %246, 8, !dbg !91
  %gep77 = getelementptr i8, ptr %invariant.gep70, i64 %.idx48, !dbg !91
  store <8 x float> %252, ptr %gep77, align 32, !dbg !91
  %.idx49 = shl i64 %253, 8, !dbg !91
  %gep79 = getelementptr i8, ptr %invariant.gep70, i64 %.idx49, !dbg !91
  store <8 x float> %259, ptr %gep79, align 32, !dbg !91
  %.idx50 = shl i64 %260, 8, !dbg !91
  %gep81 = getelementptr i8, ptr %invariant.gep70, i64 %.idx50, !dbg !91
  store <8 x float> %266, ptr %gep81, align 32, !dbg !91
  %.idx51 = shl i64 %267, 8, !dbg !91
  %gep83 = getelementptr i8, ptr %invariant.gep70, i64 %.idx51, !dbg !91
  store <8 x float> %273, ptr %gep83, align 32, !dbg !91
  %.idx52 = shl i64 %274, 8, !dbg !91
  %gep85 = getelementptr i8, ptr %invariant.gep70, i64 %.idx52, !dbg !91
  store <8 x float> %280, ptr %gep85, align 32, !dbg !91
  %281 = add nuw nsw i64 %26, 8, !dbg !91
  %282 = icmp samesign ult i64 %26, 56, !dbg !91
  br i1 %282, label %.preheader63, label %.preheader62, !dbg !91

283:                                              ; preds = %.lr.ph98, %._crit_edge97
  %indvars.iv = phi i64 [ %37, %.lr.ph98 ], [ %indvars.iv.next, %._crit_edge97 ]
  %284 = phi i64 [ %20, %.lr.ph98 ], [ %350, %._crit_edge97 ]
  %285 = sub i64 %16, %284, !dbg !91
  %286 = icmp sgt i64 %285, 0, !dbg !91
  br i1 %286, label %.lr.ph, label %._crit_edge97, !dbg !91

.lr.ph:                                           ; preds = %283
  %287 = add nsw i64 %284, %13
  br label %288, !dbg !91

288:                                              ; preds = %.lr.ph, %._crit_edge95
  %indvars.iv107 = phi i64 [ %indvars.iv, %.lr.ph ], [ %indvars.iv.next108, %._crit_edge95 ]
  %289 = phi i64 [ 0, %.lr.ph ], [ %348, %._crit_edge95 ]
  %290 = tail call i64 @llvm.smax.i64(i64 %indvars.iv107, i64 1), !dbg !91
  %291 = tail call i64 @llvm.umin.i64(i64 %290, i64 8), !dbg !91
  %292 = add i64 %289, %284, !dbg !91
  %293 = sub i64 %16, %292, !dbg !91
  %294 = icmp sgt i64 %293, 0, !dbg !93
  %295 = add i64 %287, %289
  br i1 %294, label %.preheader60, label %._crit_edge, !dbg !93

.preheader60:                                     ; preds = %288, %301
  %296 = phi i64 [ %302, %301 ], [ 0, %288 ]
  %297 = add i64 %295, %296
  %.idx36 = shl nuw nsw i64 %297, 8
  %gep91 = getelementptr inbounds nuw i8, ptr %invariant.gep90, i64 %.idx36, !dbg !93
  br label %298, !dbg !93

298:                                              ; preds = %.preheader60, %298
  %299 = phi i64 [ 0, %.preheader60 ], [ %300, %298 ]
  %gep89 = getelementptr inbounds nuw [4 x i8], ptr %gep91, i64 %299, !dbg !93
  store float 0.000000e+00, ptr %gep89, align 4, !dbg !93
  %300 = add nuw nsw i64 %299, 1, !dbg !93
  %exitcond.not = icmp eq i64 %300, 8, !dbg !93
  br i1 %exitcond.not, label %301, label %298, !dbg !93

301:                                              ; preds = %298
  %302 = add nuw nsw i64 %296, 1, !dbg !93
  %exitcond109.not = icmp eq i64 %302, %291, !dbg !93
  br i1 %exitcond109.not, label %._crit_edge, label %.preheader60, !dbg !93

._crit_edge:                                      ; preds = %301, %288
  %303 = add i64 %292, %13, !dbg !91
  br label %.preheader59, !dbg !91

.preheader59:                                     ; preds = %.preheader59.backedge, %._crit_edge
  %304 = phi i1 [ true, %._crit_edge ], [ false, %.preheader59.backedge ]
  %305 = phi i64 [ 0, %._crit_edge ], [ 4, %.preheader59.backedge ]
  br i1 %294, label %.preheader57, label %._crit_edge94.thread, !dbg !91

.preheader57:                                     ; preds = %.preheader59, %326
  %306 = phi i64 [ %327, %326 ], [ 0, %.preheader59 ]
  %307 = add i64 %306, %303
  %.idx33 = mul nuw nsw i64 %307, 36
  %308 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx33
  %309 = add i64 %295, %306
  %.idx35 = shl nuw nsw i64 %309, 8
  %310 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx35
  br label %.preheader, !dbg !91

.preheader:                                       ; preds = %.preheader57, %324
  %311 = phi i64 [ 0, %.preheader57 ], [ %325, %324 ]
  %312 = add nuw nsw i64 %311, %14
  %invariant.gep92 = getelementptr [4 x i8], ptr %6, i64 %312, !dbg !91
  %313 = getelementptr inbounds nuw [4 x i8], ptr %310, i64 %312
  %.promoted = load float, ptr %313, align 4
  br label %314, !dbg !91

314:                                              ; preds = %.preheader, %314
  %315 = phi i64 [ 0, %.preheader ], [ %323, %314 ]
  %316 = phi float [ %.promoted, %.preheader ], [ %322, %314 ]
  %317 = or disjoint i64 %315, %305, !dbg !91
  %318 = getelementptr inbounds nuw [4 x i8], ptr %308, i64 %317, !dbg !91
  %319 = load float, ptr %318, align 4, !dbg !91
  %.idx34 = shl nuw nsw i64 %317, 8, !dbg !91
  %gep93 = getelementptr i8, ptr %invariant.gep92, i64 %.idx34, !dbg !91
  %320 = load float, ptr %gep93, align 4, !dbg !91
  %321 = fmul contract float %319, %320, !dbg !92
  %322 = fadd contract float %316, %321, !dbg !92
  store float %322, ptr %313, align 4, !dbg !91
  %323 = add nuw nsw i64 %315, 1, !dbg !91
  %exitcond110.not = icmp eq i64 %323, 4, !dbg !91
  br i1 %exitcond110.not, label %324, label %314, !dbg !91

324:                                              ; preds = %314
  %325 = add nuw nsw i64 %311, 1, !dbg !91
  %exitcond111.not = icmp eq i64 %325, 8, !dbg !91
  br i1 %exitcond111.not, label %326, label %.preheader, !dbg !91

326:                                              ; preds = %324
  %327 = add nuw nsw i64 %306, 1, !dbg !91
  %exitcond114.not = icmp eq i64 %327, %291, !dbg !91
  br i1 %exitcond114.not, label %._crit_edge94, label %.preheader57, !dbg !91

._crit_edge94:                                    ; preds = %326
  br i1 %304, label %.preheader59.backedge, label %.preheader58, !dbg !91

.preheader59.backedge:                            ; preds = %._crit_edge94, %._crit_edge94.thread
  br label %.preheader59, !dbg !91

._crit_edge94.thread:                             ; preds = %.preheader59
  br i1 %304, label %.preheader59.backedge, label %._crit_edge95, !dbg !91

.preheader58:                                     ; preds = %._crit_edge94, %346
  %328 = phi i64 [ %347, %346 ], [ 0, %._crit_edge94 ]
  %329 = add i64 %328, %303
  %.idx = mul nuw nsw i64 %329, 36
  %330 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx
  %331 = getelementptr inbounds nuw i8, ptr %330, i64 32
  %332 = add i64 %295, %328
  %.idx32 = shl nuw nsw i64 %332, 8
  %333 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx32
  br label %334, !dbg !91

334:                                              ; preds = %.preheader58, %334
  %335 = phi i64 [ 0, %.preheader58 ], [ %345, %334 ]
  %336 = load float, ptr %331, align 4, !dbg !91
  %337 = or disjoint i64 %335, %14, !dbg !91
  %338 = getelementptr inbounds nuw [4 x i8], ptr %6, i64 %337, !dbg !91
  %339 = getelementptr inbounds nuw i8, ptr %338, i64 2048, !dbg !91
  %340 = load float, ptr %339, align 4, !dbg !91
  %341 = getelementptr inbounds nuw [4 x i8], ptr %333, i64 %337, !dbg !91
  %342 = load float, ptr %341, align 4, !dbg !91
  %343 = fmul contract float %336, %340, !dbg !92
  %344 = fadd contract float %342, %343, !dbg !92
  store float %344, ptr %341, align 4, !dbg !91
  %345 = add nuw nsw i64 %335, 1, !dbg !91
  %exitcond115.not = icmp eq i64 %345, 8, !dbg !91
  br i1 %exitcond115.not, label %346, label %334, !dbg !91

346:                                              ; preds = %334
  %347 = add nuw nsw i64 %328, 1, !dbg !91
  %exitcond118.not = icmp eq i64 %347, %291, !dbg !91
  br i1 %exitcond118.not, label %._crit_edge95, label %.preheader58, !dbg !91

._crit_edge95:                                    ; preds = %._crit_edge94.thread, %346
  %348 = add i64 %289, 8, !dbg !91
  %349 = icmp slt i64 %348, %285, !dbg !91
  %indvars.iv.next108 = add i64 %indvars.iv107, -8, !dbg !91
  br i1 %349, label %288, label %._crit_edge97, !dbg !91

._crit_edge97:                                    ; preds = %._crit_edge95, %283
  %350 = add nsw i64 %284, 64, !dbg !91
  %351 = icmp slt i64 %350, %16, !dbg !91
  %indvars.iv.next = add i64 %indvars.iv, -64, !dbg !91
  br i1 %351, label %283, label %._crit_edge99, !dbg !91

._crit_edge99:                                    ; preds = %._crit_edge97, %.preheader62
  ret i32 0, !dbg !94
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_1_matmul_Dx2x64_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !95 {
  %.elt24 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !96
  %.unpack25 = load ptr, ptr %.elt24, align 8, !dbg !96
  %.elt26 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !96
  %.unpack27 = load ptr, ptr %.elt26, align 16, !dbg !96
  %4 = load i64, ptr %.unpack25, align 4, !dbg !96
  %5 = getelementptr i8, ptr %.unpack27, i64 8, !dbg !97
  %6 = load ptr, ptr %5, align 8, !dbg !97
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !97
  %7 = load ptr, ptr %.unpack27, align 8, !dbg !98
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !98
  %8 = getelementptr i8, ptr %.unpack27, i64 16, !dbg !99
  %9 = load ptr, ptr %8, align 8, !dbg !99
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !99
  %10 = load i32, ptr %2, align 16, !dbg !100
  %11 = zext i32 %10 to i64, !dbg !100
  %12 = shl nuw nsw i64 %11, 6, !dbg !100
  %13 = sub i64 %4, %12, !dbg !100
  %14 = tail call i64 @llvm.smin.i64(i64 %13, i64 64), !dbg !100
  %.lobit = ashr i64 %13, 63, !dbg !100
  %15 = xor i64 %14, %.lobit, !dbg !100
  %16 = sdiv i64 %15, 64, !dbg !100
  %17 = xor i64 %16, %.lobit, !dbg !100
  %18 = shl nsw i64 %17, 6, !dbg !100
  %19 = icmp sgt i64 %17, 0, !dbg !100
  br i1 %19, label %.preheader51, label %.preheader49, !dbg !100

.preheader51:                                     ; preds = %3
  %20 = or disjoint i64 %12, 1
  %21 = or disjoint i64 %12, 2
  %22 = or disjoint i64 %12, 3
  %23 = or disjoint i64 %12, 4
  %24 = or disjoint i64 %12, 5
  %25 = or disjoint i64 %12, 6
  %26 = or disjoint i64 %12, 7
  br label %.preheader50, !dbg !100

.preheader50:                                     ; preds = %.preheader51, %231
  %27 = phi i64 [ 0, %.preheader51 ], [ %247, %231 ]
  %28 = add nuw nsw i64 %27, %12
  %.idx80 = shl nuw nsw i64 %28, 8
  %29 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx80
  %30 = getelementptr inbounds nuw i8, ptr %29, i64 256
  %31 = getelementptr inbounds nuw i8, ptr %29, i64 512
  %32 = getelementptr inbounds nuw i8, ptr %29, i64 768
  %33 = getelementptr inbounds nuw i8, ptr %29, i64 1024
  %34 = getelementptr inbounds nuw i8, ptr %29, i64 1280
  %35 = getelementptr inbounds nuw i8, ptr %29, i64 1536
  %36 = getelementptr inbounds nuw i8, ptr %29, i64 1792
  br label %39, !dbg !100

.preheader49:                                     ; preds = %231, %3
  %37 = icmp slt i64 %18, %14, !dbg !100
  br i1 %37, label %.lr.ph55.preheader, label %._crit_edge56, !dbg !100

.lr.ph55.preheader:                               ; preds = %.preheader49
  %38 = sub i64 %14, %18, !dbg !100
  br label %.lr.ph55, !dbg !100

39:                                               ; preds = %.preheader50, %39
  %40 = phi [8 x <2 x float>] [ zeroinitializer, %.preheader50 ], [ %228, %39 ]
  %41 = phi i64 [ 0, %.preheader50 ], [ %229, %39 ]
  %.idx42 = shl nuw nsw i64 %41, 3, !dbg !100
  %42 = getelementptr i8, ptr %6, i64 %.idx42, !dbg !100
  %43 = load <2 x float>, ptr %42, align 32, !dbg !100
  %44 = or disjoint i64 %41, 1, !dbg !100
  %.idx43 = shl nuw nsw i64 %44, 3, !dbg !100
  %45 = getelementptr i8, ptr %6, i64 %.idx43, !dbg !100
  %46 = load <2 x float>, ptr %45, align 8, !dbg !100
  %47 = or disjoint i64 %41, 2, !dbg !100
  %.idx44 = shl nuw nsw i64 %47, 3, !dbg !100
  %48 = getelementptr i8, ptr %6, i64 %.idx44, !dbg !100
  %49 = load <2 x float>, ptr %48, align 16, !dbg !100
  %50 = or disjoint i64 %41, 3, !dbg !100
  %.idx45 = shl nuw nsw i64 %50, 3, !dbg !100
  %51 = getelementptr i8, ptr %6, i64 %.idx45, !dbg !100
  %52 = load <2 x float>, ptr %51, align 8, !dbg !100
  %53 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %41, !dbg !101
  %54 = load float, ptr %53, align 16, !dbg !101
  %55 = insertelement <2 x float> poison, float %54, i64 0, !dbg !101
  %56 = shufflevector <2 x float> %55, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %57 = extractvalue [8 x <2 x float>] %40, 0, !dbg !101
  %58 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %56, <2 x float> %43, <2 x float> %57), !dbg !101
  %59 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %41, !dbg !101
  %60 = load float, ptr %59, align 16, !dbg !101
  %61 = insertelement <2 x float> poison, float %60, i64 0, !dbg !101
  %62 = shufflevector <2 x float> %61, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %63 = extractvalue [8 x <2 x float>] %40, 1, !dbg !101
  %64 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %62, <2 x float> %43, <2 x float> %63), !dbg !101
  %65 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %41, !dbg !101
  %66 = load float, ptr %65, align 16, !dbg !101
  %67 = insertelement <2 x float> poison, float %66, i64 0, !dbg !101
  %68 = shufflevector <2 x float> %67, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %69 = extractvalue [8 x <2 x float>] %40, 2, !dbg !101
  %70 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %68, <2 x float> %43, <2 x float> %69), !dbg !101
  %71 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %41, !dbg !101
  %72 = load float, ptr %71, align 16, !dbg !101
  %73 = insertelement <2 x float> poison, float %72, i64 0, !dbg !101
  %74 = shufflevector <2 x float> %73, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %75 = extractvalue [8 x <2 x float>] %40, 3, !dbg !101
  %76 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %74, <2 x float> %43, <2 x float> %75), !dbg !101
  %77 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %41, !dbg !101
  %78 = load float, ptr %77, align 16, !dbg !101
  %79 = insertelement <2 x float> poison, float %78, i64 0, !dbg !101
  %80 = shufflevector <2 x float> %79, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %81 = extractvalue [8 x <2 x float>] %40, 4, !dbg !101
  %82 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %80, <2 x float> %43, <2 x float> %81), !dbg !101
  %83 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %41, !dbg !101
  %84 = load float, ptr %83, align 16, !dbg !101
  %85 = insertelement <2 x float> poison, float %84, i64 0, !dbg !101
  %86 = shufflevector <2 x float> %85, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %87 = extractvalue [8 x <2 x float>] %40, 5, !dbg !101
  %88 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %86, <2 x float> %43, <2 x float> %87), !dbg !101
  %89 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %41, !dbg !101
  %90 = load float, ptr %89, align 16, !dbg !101
  %91 = insertelement <2 x float> poison, float %90, i64 0, !dbg !101
  %92 = shufflevector <2 x float> %91, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %93 = extractvalue [8 x <2 x float>] %40, 6, !dbg !101
  %94 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %92, <2 x float> %43, <2 x float> %93), !dbg !101
  %95 = getelementptr inbounds nuw [4 x i8], ptr %36, i64 %41, !dbg !101
  %96 = load float, ptr %95, align 16, !dbg !101
  %97 = insertelement <2 x float> poison, float %96, i64 0, !dbg !101
  %98 = shufflevector <2 x float> %97, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %99 = extractvalue [8 x <2 x float>] %40, 7, !dbg !101
  %100 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %98, <2 x float> %43, <2 x float> %99), !dbg !101
  %101 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %44, !dbg !101
  %102 = load float, ptr %101, align 4, !dbg !101
  %103 = insertelement <2 x float> poison, float %102, i64 0, !dbg !101
  %104 = shufflevector <2 x float> %103, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %105 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %104, <2 x float> %46, <2 x float> %58), !dbg !101
  %106 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %44, !dbg !101
  %107 = load float, ptr %106, align 4, !dbg !101
  %108 = insertelement <2 x float> poison, float %107, i64 0, !dbg !101
  %109 = shufflevector <2 x float> %108, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %110 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %109, <2 x float> %46, <2 x float> %64), !dbg !101
  %111 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %44, !dbg !101
  %112 = load float, ptr %111, align 4, !dbg !101
  %113 = insertelement <2 x float> poison, float %112, i64 0, !dbg !101
  %114 = shufflevector <2 x float> %113, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %115 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %114, <2 x float> %46, <2 x float> %70), !dbg !101
  %116 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %44, !dbg !101
  %117 = load float, ptr %116, align 4, !dbg !101
  %118 = insertelement <2 x float> poison, float %117, i64 0, !dbg !101
  %119 = shufflevector <2 x float> %118, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %120 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %119, <2 x float> %46, <2 x float> %76), !dbg !101
  %121 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %44, !dbg !101
  %122 = load float, ptr %121, align 4, !dbg !101
  %123 = insertelement <2 x float> poison, float %122, i64 0, !dbg !101
  %124 = shufflevector <2 x float> %123, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %125 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %124, <2 x float> %46, <2 x float> %82), !dbg !101
  %126 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %44, !dbg !101
  %127 = load float, ptr %126, align 4, !dbg !101
  %128 = insertelement <2 x float> poison, float %127, i64 0, !dbg !101
  %129 = shufflevector <2 x float> %128, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %130 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %129, <2 x float> %46, <2 x float> %88), !dbg !101
  %131 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %44, !dbg !101
  %132 = load float, ptr %131, align 4, !dbg !101
  %133 = insertelement <2 x float> poison, float %132, i64 0, !dbg !101
  %134 = shufflevector <2 x float> %133, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %135 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %134, <2 x float> %46, <2 x float> %94), !dbg !101
  %136 = getelementptr inbounds nuw [4 x i8], ptr %36, i64 %44, !dbg !101
  %137 = load float, ptr %136, align 4, !dbg !101
  %138 = insertelement <2 x float> poison, float %137, i64 0, !dbg !101
  %139 = shufflevector <2 x float> %138, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %140 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %139, <2 x float> %46, <2 x float> %100), !dbg !101
  %141 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %47, !dbg !101
  %142 = load float, ptr %141, align 8, !dbg !101
  %143 = insertelement <2 x float> poison, float %142, i64 0, !dbg !101
  %144 = shufflevector <2 x float> %143, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %145 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %144, <2 x float> %49, <2 x float> %105), !dbg !101
  %146 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %47, !dbg !101
  %147 = load float, ptr %146, align 8, !dbg !101
  %148 = insertelement <2 x float> poison, float %147, i64 0, !dbg !101
  %149 = shufflevector <2 x float> %148, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %150 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %149, <2 x float> %49, <2 x float> %110), !dbg !101
  %151 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %47, !dbg !101
  %152 = load float, ptr %151, align 8, !dbg !101
  %153 = insertelement <2 x float> poison, float %152, i64 0, !dbg !101
  %154 = shufflevector <2 x float> %153, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %155 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %154, <2 x float> %49, <2 x float> %115), !dbg !101
  %156 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %47, !dbg !101
  %157 = load float, ptr %156, align 8, !dbg !101
  %158 = insertelement <2 x float> poison, float %157, i64 0, !dbg !101
  %159 = shufflevector <2 x float> %158, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %160 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %159, <2 x float> %49, <2 x float> %120), !dbg !101
  %161 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %47, !dbg !101
  %162 = load float, ptr %161, align 8, !dbg !101
  %163 = insertelement <2 x float> poison, float %162, i64 0, !dbg !101
  %164 = shufflevector <2 x float> %163, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %165 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %164, <2 x float> %49, <2 x float> %125), !dbg !101
  %166 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %47, !dbg !101
  %167 = load float, ptr %166, align 8, !dbg !101
  %168 = insertelement <2 x float> poison, float %167, i64 0, !dbg !101
  %169 = shufflevector <2 x float> %168, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %170 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %169, <2 x float> %49, <2 x float> %130), !dbg !101
  %171 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %47, !dbg !101
  %172 = load float, ptr %171, align 8, !dbg !101
  %173 = insertelement <2 x float> poison, float %172, i64 0, !dbg !101
  %174 = shufflevector <2 x float> %173, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %175 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %174, <2 x float> %49, <2 x float> %135), !dbg !101
  %176 = getelementptr inbounds nuw [4 x i8], ptr %36, i64 %47, !dbg !101
  %177 = load float, ptr %176, align 8, !dbg !101
  %178 = insertelement <2 x float> poison, float %177, i64 0, !dbg !101
  %179 = shufflevector <2 x float> %178, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %180 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %179, <2 x float> %49, <2 x float> %140), !dbg !101
  %181 = getelementptr inbounds nuw [4 x i8], ptr %29, i64 %50, !dbg !101
  %182 = load float, ptr %181, align 4, !dbg !101
  %183 = insertelement <2 x float> poison, float %182, i64 0, !dbg !101
  %184 = shufflevector <2 x float> %183, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %185 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %184, <2 x float> %52, <2 x float> %145), !dbg !101
  %186 = getelementptr inbounds nuw [4 x i8], ptr %30, i64 %50, !dbg !101
  %187 = load float, ptr %186, align 4, !dbg !101
  %188 = insertelement <2 x float> poison, float %187, i64 0, !dbg !101
  %189 = shufflevector <2 x float> %188, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %190 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %189, <2 x float> %52, <2 x float> %150), !dbg !101
  %191 = getelementptr inbounds nuw [4 x i8], ptr %31, i64 %50, !dbg !101
  %192 = load float, ptr %191, align 4, !dbg !101
  %193 = insertelement <2 x float> poison, float %192, i64 0, !dbg !101
  %194 = shufflevector <2 x float> %193, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %195 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %194, <2 x float> %52, <2 x float> %155), !dbg !101
  %196 = getelementptr inbounds nuw [4 x i8], ptr %32, i64 %50, !dbg !101
  %197 = load float, ptr %196, align 4, !dbg !101
  %198 = insertelement <2 x float> poison, float %197, i64 0, !dbg !101
  %199 = shufflevector <2 x float> %198, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %200 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %199, <2 x float> %52, <2 x float> %160), !dbg !101
  %201 = getelementptr inbounds nuw [4 x i8], ptr %33, i64 %50, !dbg !101
  %202 = load float, ptr %201, align 4, !dbg !101
  %203 = insertelement <2 x float> poison, float %202, i64 0, !dbg !101
  %204 = shufflevector <2 x float> %203, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %205 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %204, <2 x float> %52, <2 x float> %165), !dbg !101
  %206 = getelementptr inbounds nuw [4 x i8], ptr %34, i64 %50, !dbg !101
  %207 = load float, ptr %206, align 4, !dbg !101
  %208 = insertelement <2 x float> poison, float %207, i64 0, !dbg !101
  %209 = shufflevector <2 x float> %208, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %210 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %209, <2 x float> %52, <2 x float> %170), !dbg !101
  %211 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %50, !dbg !101
  %212 = load float, ptr %211, align 4, !dbg !101
  %213 = insertelement <2 x float> poison, float %212, i64 0, !dbg !101
  %214 = shufflevector <2 x float> %213, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %215 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %214, <2 x float> %52, <2 x float> %175), !dbg !101
  %216 = getelementptr inbounds nuw [4 x i8], ptr %36, i64 %50, !dbg !101
  %217 = load float, ptr %216, align 4, !dbg !101
  %218 = insertelement <2 x float> poison, float %217, i64 0, !dbg !101
  %219 = shufflevector <2 x float> %218, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !101
  %220 = tail call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %219, <2 x float> %52, <2 x float> %180), !dbg !101
  %221 = insertvalue [8 x <2 x float>] poison, <2 x float> %185, 0, !dbg !101
  %222 = insertvalue [8 x <2 x float>] %221, <2 x float> %190, 1, !dbg !101
  %223 = insertvalue [8 x <2 x float>] %222, <2 x float> %195, 2, !dbg !101
  %224 = insertvalue [8 x <2 x float>] %223, <2 x float> %200, 3, !dbg !101
  %225 = insertvalue [8 x <2 x float>] %224, <2 x float> %205, 4, !dbg !101
  %226 = insertvalue [8 x <2 x float>] %225, <2 x float> %210, 5, !dbg !101
  %227 = insertvalue [8 x <2 x float>] %226, <2 x float> %215, 6, !dbg !101
  %228 = insertvalue [8 x <2 x float>] %227, <2 x float> %220, 7, !dbg !101
  %229 = add nuw nsw i64 %41, 4, !dbg !100
  %230 = icmp samesign ult i64 %41, 60, !dbg !100
  br i1 %230, label %39, label %231, !dbg !100

231:                                              ; preds = %39
  %.idx34 = shl i64 %28, 3, !dbg !100
  %232 = getelementptr i8, ptr %9, i64 %.idx34, !dbg !100
  store <2 x float> %185, ptr %232, align 64, !dbg !100
  %233 = add nuw nsw i64 %20, %27, !dbg !100
  %.idx35 = shl i64 %233, 3, !dbg !100
  %234 = getelementptr i8, ptr %9, i64 %.idx35, !dbg !100
  store <2 x float> %190, ptr %234, align 8, !dbg !100
  %235 = add nuw nsw i64 %21, %27, !dbg !100
  %.idx36 = shl i64 %235, 3, !dbg !100
  %236 = getelementptr i8, ptr %9, i64 %.idx36, !dbg !100
  store <2 x float> %195, ptr %236, align 16, !dbg !100
  %237 = add nuw nsw i64 %22, %27, !dbg !100
  %.idx37 = shl i64 %237, 3, !dbg !100
  %238 = getelementptr i8, ptr %9, i64 %.idx37, !dbg !100
  store <2 x float> %200, ptr %238, align 8, !dbg !100
  %239 = add nuw nsw i64 %23, %27, !dbg !100
  %.idx38 = shl i64 %239, 3, !dbg !100
  %240 = getelementptr i8, ptr %9, i64 %.idx38, !dbg !100
  store <2 x float> %205, ptr %240, align 32, !dbg !100
  %241 = add nuw nsw i64 %24, %27, !dbg !100
  %.idx39 = shl i64 %241, 3, !dbg !100
  %242 = getelementptr i8, ptr %9, i64 %.idx39, !dbg !100
  store <2 x float> %210, ptr %242, align 8, !dbg !100
  %243 = add nuw nsw i64 %25, %27, !dbg !100
  %.idx40 = shl i64 %243, 3, !dbg !100
  %244 = getelementptr i8, ptr %9, i64 %.idx40, !dbg !100
  store <2 x float> %215, ptr %244, align 16, !dbg !100
  %245 = add nuw nsw i64 %26, %27, !dbg !100
  %.idx41 = shl i64 %245, 3, !dbg !100
  %246 = getelementptr i8, ptr %9, i64 %.idx41, !dbg !100
  store <2 x float> %220, ptr %246, align 8, !dbg !100
  %247 = add nuw nsw i64 %27, 8, !dbg !100
  %248 = icmp samesign ult i64 %27, 56, !dbg !100
  br i1 %248, label %.preheader50, label %.preheader49, !dbg !100

.lr.ph55:                                         ; preds = %.lr.ph55.preheader, %._crit_edge54
  %indvars.iv = phi i64 [ %38, %.lr.ph55.preheader ], [ %indvars.iv.next, %._crit_edge54 ]
  %249 = phi i64 [ %18, %.lr.ph55.preheader ], [ %293, %._crit_edge54 ]
  %250 = sub i64 %14, %249, !dbg !100
  %251 = icmp sgt i64 %250, 0, !dbg !100
  br i1 %251, label %.lr.ph, label %._crit_edge54, !dbg !100

.lr.ph:                                           ; preds = %.lr.ph55
  %252 = add nsw i64 %249, %12
  br label %253, !dbg !100

253:                                              ; preds = %.lr.ph, %290
  %indvars.iv64 = phi i64 [ %indvars.iv, %.lr.ph ], [ %indvars.iv.next65, %290 ]
  %254 = phi i64 [ 0, %.lr.ph ], [ %291, %290 ]
  %255 = tail call i64 @llvm.smax.i64(i64 %indvars.iv64, i64 1), !dbg !100
  %256 = tail call i64 @llvm.umin.i64(i64 %255, i64 8), !dbg !100
  %257 = add i64 %254, %249, !dbg !100
  %258 = sub i64 %14, %257, !dbg !100
  %259 = icmp sgt i64 %258, 0, !dbg !102
  %260 = add i64 %252, %254
  br i1 %259, label %.preheader48, label %._crit_edge, !dbg !102

.preheader48:                                     ; preds = %253, %.preheader48
  %261 = phi i64 [ %265, %.preheader48 ], [ 0, %253 ]
  %262 = add i64 %260, %261
  %.idx33 = shl nuw nsw i64 %262, 3
  %263 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx33
  store float 0.000000e+00, ptr %263, align 8, !dbg !102
  %264 = getelementptr inbounds nuw i8, ptr %263, i64 4, !dbg !102
  store float 0.000000e+00, ptr %264, align 4, !dbg !102
  %265 = add nuw nsw i64 %261, 1, !dbg !102
  %exitcond.not = icmp eq i64 %265, %256, !dbg !102
  br i1 %exitcond.not, label %._crit_edge, label %.preheader48, !dbg !102

._crit_edge:                                      ; preds = %.preheader48, %253
  %266 = add i64 %257, %12, !dbg !100
  br label %.preheader47, !dbg !100

.preheader47:                                     ; preds = %._crit_edge, %._crit_edge52
  %267 = phi i64 [ 0, %._crit_edge ], [ %288, %._crit_edge52 ]
  br i1 %259, label %.preheader46, label %._crit_edge52, !dbg !100

.preheader46:                                     ; preds = %.preheader47, %286
  %268 = phi i64 [ %287, %286 ], [ 0, %.preheader47 ]
  %269 = add i64 %266, %268
  %.idx = shl nuw nsw i64 %269, 8
  %270 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx
  %271 = add i64 %260, %268
  %.idx32 = shl nuw nsw i64 %271, 3
  %272 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx32
  br label %.preheader, !dbg !100

.preheader:                                       ; preds = %.preheader46, %285
  %exitcond67.not = phi i1 [ false, %.preheader46 ], [ true, %285 ]
  %273 = phi i64 [ 0, %.preheader46 ], [ 1, %285 ]
  %invariant.gep = getelementptr [4 x i8], ptr %6, i64 %273, !dbg !100
  %274 = getelementptr inbounds nuw [4 x i8], ptr %272, i64 %273
  %.promoted = load float, ptr %274, align 4
  br label %275, !dbg !100

275:                                              ; preds = %.preheader, %275
  %276 = phi i64 [ 0, %.preheader ], [ %284, %275 ]
  %277 = phi float [ %.promoted, %.preheader ], [ %283, %275 ]
  %278 = or disjoint i64 %276, %267, !dbg !100
  %279 = getelementptr inbounds nuw [4 x i8], ptr %270, i64 %278, !dbg !100
  %280 = load float, ptr %279, align 4, !dbg !100
  %.idx31 = shl nuw nsw i64 %278, 3, !dbg !100
  %gep = getelementptr i8, ptr %invariant.gep, i64 %.idx31, !dbg !100
  %281 = load float, ptr %gep, align 4, !dbg !100
  %282 = fmul contract float %280, %281, !dbg !101
  %283 = fadd contract float %277, %282, !dbg !101
  store float %283, ptr %274, align 4, !dbg !100
  %284 = add nuw nsw i64 %276, 1, !dbg !100
  %exitcond66.not = icmp eq i64 %284, 4, !dbg !100
  br i1 %exitcond66.not, label %285, label %275, !dbg !100

285:                                              ; preds = %275
  br i1 %exitcond67.not, label %286, label %.preheader, !dbg !100

286:                                              ; preds = %285
  %287 = add nuw nsw i64 %268, 1, !dbg !100
  %exitcond70.not = icmp eq i64 %287, %256, !dbg !100
  br i1 %exitcond70.not, label %._crit_edge52, label %.preheader46, !dbg !100

._crit_edge52:                                    ; preds = %286, %.preheader47
  %288 = add nuw nsw i64 %267, 4, !dbg !100
  %289 = icmp samesign ult i64 %267, 60, !dbg !100
  br i1 %289, label %.preheader47, label %290, !dbg !100

290:                                              ; preds = %._crit_edge52
  %291 = add i64 %254, 8, !dbg !100
  %292 = icmp slt i64 %291, %250, !dbg !100
  %indvars.iv.next65 = add i64 %indvars.iv64, -8, !dbg !100
  br i1 %292, label %253, label %._crit_edge54, !dbg !100

._crit_edge54:                                    ; preds = %290, %.lr.ph55
  %293 = add nsw i64 %249, 64, !dbg !100
  %294 = icmp slt i64 %293, %14, !dbg !100
  %indvars.iv.next = add i64 %indvars.iv, -64, !dbg !100
  br i1 %294, label %.lr.ph55, label %._crit_edge56, !dbg !100

._crit_edge56:                                    ; preds = %._crit_edge54, %.preheader49
  ret i32 0, !dbg !103
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fmuladd.v2f32(<2 x float>, <2 x float>, <2 x float>) #2

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr readnone captures(none) %1) local_unnamed_addr #3 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @iree_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
  %2 = and i16 %0, 31744
  %3 = and i16 %0, 1023
  %4 = and i16 %0, -32768
  %5 = zext i16 %4 to i32
  %6 = shl nuw i32 %5, 16
  switch i16 %2, label %15 [
    i16 31744, label %7
    i16 0, label %23
  ]

7:                                                ; preds = %1
  %8 = icmp eq i16 %3, 0
  br i1 %8, label %12, label %9

9:                                                ; preds = %7
  %10 = or disjoint i32 %6, 2143289344
  %11 = bitcast i32 %10 to float
  br label %28

12:                                               ; preds = %7
  %13 = or disjoint i32 %6, 2139095040
  %14 = bitcast i32 %13 to float
  br label %28

15:                                               ; preds = %1
  %16 = zext nneg i16 %3 to i32
  %17 = zext nneg i16 %2 to i32
  %18 = add nuw nsw i32 %17, 114688
  %19 = or disjoint i32 %18, %16
  %20 = shl nuw nsw i32 %19, 13
  %21 = or disjoint i32 %20, %6
  %22 = bitcast i32 %21 to float
  br label %28

23:                                               ; preds = %1
  %24 = or disjoint i32 %6, 864026624
  %25 = uitofp nneg i16 %3 to float
  %26 = bitcast i32 %24 to float
  %27 = fmul float %25, %26
  br label %28

28:                                               ; preds = %23, %15, %12, %9
  %29 = phi float [ %11, %9 ], [ %14, %12 ], [ %22, %15 ], [ %27, %23 ]
  ret float %29
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal signext i16 @iree_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
  %2 = bitcast float %0 to i32
  %3 = and i32 %2, 2139095040
  %4 = and i32 %2, 8388607
  %5 = lshr i32 %2, 16
  %6 = and i32 %5, 32768
  switch i32 %3, label %12 [
    i32 2139095040, label %7
    i32 0, label %30
  ]

7:                                                ; preds = %1
  %8 = icmp eq i32 %4, 0
  br i1 %8, label %30, label %9

9:                                                ; preds = %7
  %10 = trunc nuw i32 %5 to i16
  %11 = or i16 %10, 32767
  br label %34

12:                                               ; preds = %1
  %13 = lshr exact i32 %3, 23
  %14 = icmp samesign ugt i32 %3, 1191182336
  br i1 %14, label %30, label %15

15:                                               ; preds = %12
  %16 = icmp samesign ult i32 %3, 947912704
  br i1 %16, label %30, label %17

17:                                               ; preds = %15
  %18 = and i32 %2, 8192
  %19 = icmp eq i32 %18, 0
  %20 = select i1 %19, i32 4095, i32 4096
  %21 = add nuw nsw i32 %20, %4
  %22 = icmp samesign ugt i32 %21, 8388607
  %23 = select i1 %22, i32 -126, i32 -127
  %24 = add nsw i32 %23, %13
  %25 = shl nsw i32 %24, 10
  %26 = lshr i32 %21, 13
  %27 = add nuw nsw i32 %26, 15360
  %28 = select i1 %22, i32 15360, i32 %27
  %29 = add nsw i32 %28, %25
  br label %30

30:                                               ; preds = %17, %12, %15, %1, %7
  %31 = phi i32 [ 31744, %7 ], [ %3, %1 ], [ %29, %17 ], [ 31744, %12 ], [ 0, %15 ]
  %32 = or i32 %31, %6
  %33 = trunc i32 %32 to i16
  br label %34

34:                                               ; preds = %30, %9
  %35 = phi i16 [ %11, %9 ], [ %33, %30 ]
  ret i16 %35
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @__gnu_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
  %2 = and i16 %0, 31744
  %3 = and i16 %0, 1023
  %4 = and i16 %0, -32768
  %5 = zext i16 %4 to i32
  %6 = shl nuw i32 %5, 16
  switch i16 %2, label %15 [
    i16 31744, label %7
    i16 0, label %23
  ]

7:                                                ; preds = %1
  %8 = icmp eq i16 %3, 0
  br i1 %8, label %12, label %9

9:                                                ; preds = %7
  %10 = or disjoint i32 %6, 2143289344
  %11 = bitcast i32 %10 to float
  br label %28

12:                                               ; preds = %7
  %13 = or disjoint i32 %6, 2139095040
  %14 = bitcast i32 %13 to float
  br label %28

15:                                               ; preds = %1
  %16 = zext nneg i16 %3 to i32
  %17 = zext nneg i16 %2 to i32
  %18 = add nuw nsw i32 %17, 114688
  %19 = or disjoint i32 %18, %16
  %20 = shl nuw nsw i32 %19, 13
  %21 = or disjoint i32 %20, %6
  %22 = bitcast i32 %21 to float
  br label %28

23:                                               ; preds = %1
  %24 = or disjoint i32 %6, 864026624
  %25 = uitofp nneg i16 %3 to float
  %26 = bitcast i32 %24 to float
  %27 = fmul float %25, %26
  br label %28

28:                                               ; preds = %9, %12, %15, %23
  %29 = phi float [ %11, %9 ], [ %14, %12 ], [ %22, %15 ], [ %27, %23 ]
  ret float %29
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @__extendhfsf2(float noundef %0) local_unnamed_addr #4 {
  %2 = bitcast float %0 to i32
  %3 = trunc i32 %2 to i16
  %4 = and i16 %3, 31744
  %5 = and i16 %3, 1023
  %6 = shl i32 %2, 16
  %7 = and i32 %6, -2147483648
  switch i16 %4, label %16 [
    i16 31744, label %8
    i16 0, label %24
  ]

8:                                                ; preds = %1
  %9 = icmp eq i16 %5, 0
  br i1 %9, label %13, label %10

10:                                               ; preds = %8
  %11 = or disjoint i32 %7, 2143289344
  %12 = bitcast i32 %11 to float
  br label %29

13:                                               ; preds = %8
  %14 = or disjoint i32 %7, 2139095040
  %15 = bitcast i32 %14 to float
  br label %29

16:                                               ; preds = %1
  %17 = and i32 %2, 1023
  %18 = and i32 %2, 31744
  %19 = add nuw nsw i32 %18, 114688
  %20 = or disjoint i32 %19, %17
  %21 = shl nuw nsw i32 %20, 13
  %22 = or disjoint i32 %21, %7
  %23 = bitcast i32 %22 to float
  br label %29

24:                                               ; preds = %1
  %25 = or disjoint i32 %7, 864026624
  %26 = uitofp nneg i16 %5 to float
  %27 = bitcast i32 %25 to float
  %28 = fmul nnan float %26, %27
  br label %29

29:                                               ; preds = %10, %13, %16, %24
  %30 = phi float [ %12, %10 ], [ %15, %13 ], [ %23, %16 ], [ %28, %24 ]
  ret float %30
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal signext i16 @__gnu_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
  %2 = bitcast float %0 to i32
  %3 = and i32 %2, 2139095040
  %4 = and i32 %2, 8388607
  %5 = lshr i32 %2, 16
  %6 = and i32 %5, 32768
  switch i32 %3, label %12 [
    i32 2139095040, label %7
    i32 0, label %30
  ]

7:                                                ; preds = %1
  %8 = icmp eq i32 %4, 0
  br i1 %8, label %30, label %9

9:                                                ; preds = %7
  %10 = trunc nuw i32 %5 to i16
  %11 = or i16 %10, 32767
  br label %34

12:                                               ; preds = %1
  %13 = lshr exact i32 %3, 23
  %14 = icmp samesign ugt i32 %3, 1191182336
  br i1 %14, label %30, label %15

15:                                               ; preds = %12
  %16 = icmp samesign ult i32 %3, 947912704
  br i1 %16, label %30, label %17

17:                                               ; preds = %15
  %18 = and i32 %2, 8192
  %19 = icmp eq i32 %18, 0
  %20 = select i1 %19, i32 4095, i32 4096
  %21 = add nuw nsw i32 %20, %4
  %22 = icmp samesign ugt i32 %21, 8388607
  %23 = select i1 %22, i32 -126, i32 -127
  %24 = add nsw i32 %23, %13
  %25 = shl nsw i32 %24, 10
  %26 = lshr i32 %21, 13
  %27 = add nuw nsw i32 %26, 15360
  %28 = select i1 %22, i32 15360, i32 %27
  %29 = add nsw i32 %25, %28
  br label %30

30:                                               ; preds = %17, %15, %12, %7, %1
  %31 = phi i32 [ 31744, %7 ], [ %3, %1 ], [ %29, %17 ], [ 31744, %12 ], [ 0, %15 ]
  %32 = or i32 %31, %6
  %33 = trunc i32 %32 to i16
  br label %34

34:                                               ; preds = %9, %30
  %35 = phi i16 [ %11, %9 ], [ %33, %30 ]
  ret i16 %35
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @__truncsfhf2(float noundef %0) local_unnamed_addr #4 {
  %2 = alloca i16, align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  %3 = bitcast float %0 to i32
  %4 = and i32 %3, 2139095040
  %5 = and i32 %3, 8388607
  %6 = lshr i32 %3, 16
  %7 = and i32 %6, 32768
  switch i32 %4, label %13 [
    i32 2139095040, label %8
    i32 0, label %31
  ]

8:                                                ; preds = %1
  %9 = icmp eq i32 %5, 0
  br i1 %9, label %31, label %10

10:                                               ; preds = %8
  %11 = trunc nuw i32 %6 to i16
  %12 = or i16 %11, 32767
  br label %35

13:                                               ; preds = %1
  %14 = lshr exact i32 %4, 23
  %15 = icmp samesign ugt i32 %4, 1191182336
  br i1 %15, label %31, label %16

16:                                               ; preds = %13
  %17 = icmp samesign ult i32 %4, 947912704
  br i1 %17, label %31, label %18

18:                                               ; preds = %16
  %19 = and i32 %3, 8192
  %20 = icmp eq i32 %19, 0
  %21 = select i1 %20, i32 4095, i32 4096
  %22 = add nuw nsw i32 %21, %5
  %23 = icmp samesign ugt i32 %22, 8388607
  %24 = select i1 %23, i32 -126, i32 -127
  %25 = add nsw i32 %24, %14
  %26 = shl nsw i32 %25, 10
  %27 = lshr i32 %22, 13
  %28 = add nuw nsw i32 %27, 15360
  %29 = select i1 %23, i32 15360, i32 %28
  %30 = add nsw i32 %26, %29
  br label %31

31:                                               ; preds = %18, %16, %13, %8, %1
  %32 = phi i32 [ 31744, %8 ], [ %4, %1 ], [ %30, %18 ], [ 31744, %13 ], [ 0, %16 ]
  %33 = or i32 %32, %7
  %34 = trunc i32 %33 to i16
  br label %35

35:                                               ; preds = %10, %31
  %36 = phi i16 [ %12, %10 ], [ %34, %31 ]
  store i16 %36, ptr %2, align 4, !tbaa !104
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %.0..0..0..0.
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal double @__extendhfdf2(float noundef %0) local_unnamed_addr #4 {
  %2 = bitcast float %0 to i32
  %3 = trunc i32 %2 to i16
  %4 = and i16 %3, 31744
  %5 = and i16 %3, 1023
  %6 = shl i32 %2, 16
  %7 = and i32 %6, -2147483648
  switch i16 %4, label %16 [
    i16 31744, label %8
    i16 0, label %24
  ]

8:                                                ; preds = %1
  %9 = icmp eq i16 %5, 0
  br i1 %9, label %13, label %10

10:                                               ; preds = %8
  %11 = or disjoint i32 %7, 2143289344
  %12 = bitcast i32 %11 to float
  br label %29

13:                                               ; preds = %8
  %14 = or disjoint i32 %7, 2139095040
  %15 = bitcast i32 %14 to float
  br label %29

16:                                               ; preds = %1
  %17 = and i32 %2, 1023
  %18 = and i32 %2, 31744
  %19 = add nuw nsw i32 %18, 114688
  %20 = or disjoint i32 %19, %17
  %21 = shl nuw nsw i32 %20, 13
  %22 = or disjoint i32 %21, %7
  %23 = bitcast i32 %22 to float
  br label %29

24:                                               ; preds = %1
  %25 = or disjoint i32 %7, 864026624
  %26 = uitofp nneg i16 %5 to float
  %27 = bitcast i32 %25 to float
  %28 = fmul nnan float %26, %27
  br label %29

29:                                               ; preds = %10, %13, %16, %24
  %30 = phi float [ %12, %10 ], [ %15, %13 ], [ %23, %16 ], [ %28, %24 ]
  %31 = fpext float %30 to double
  ret double %31
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @__truncdfhf2(double noundef %0) local_unnamed_addr #4 {
  %2 = alloca i16, align 4
  %3 = fptrunc double %0 to float
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  %4 = bitcast float %3 to i32
  %5 = and i32 %4, 2139095040
  %6 = and i32 %4, 8388607
  %7 = lshr i32 %4, 16
  %8 = and i32 %7, 32768
  switch i32 %5, label %14 [
    i32 2139095040, label %9
    i32 0, label %32
  ]

9:                                                ; preds = %1
  %10 = icmp eq i32 %6, 0
  br i1 %10, label %32, label %11

11:                                               ; preds = %9
  %12 = trunc nuw i32 %7 to i16
  %13 = or i16 %12, 32767
  br label %36

14:                                               ; preds = %1
  %15 = lshr exact i32 %5, 23
  %16 = icmp samesign ugt i32 %5, 1191182336
  br i1 %16, label %32, label %17

17:                                               ; preds = %14
  %18 = icmp samesign ult i32 %5, 947912704
  br i1 %18, label %32, label %19

19:                                               ; preds = %17
  %20 = and i32 %4, 8192
  %21 = icmp eq i32 %20, 0
  %22 = select i1 %21, i32 4095, i32 4096
  %23 = add nuw nsw i32 %22, %6
  %24 = icmp samesign ugt i32 %23, 8388607
  %25 = select i1 %24, i32 -126, i32 -127
  %26 = add nsw i32 %25, %15
  %27 = shl nsw i32 %26, 10
  %28 = lshr i32 %23, 13
  %29 = add nuw nsw i32 %28, 15360
  %30 = select i1 %24, i32 15360, i32 %29
  %31 = add nsw i32 %27, %30
  br label %32

32:                                               ; preds = %19, %17, %14, %9, %1
  %33 = phi i32 [ 31744, %9 ], [ %5, %1 ], [ %31, %19 ], [ 31744, %14 ], [ 0, %17 ]
  %34 = or i32 %33, %8
  %35 = trunc i32 %34 to i16
  br label %36

36:                                               ; preds = %11, %32
  %37 = phi i16 [ %13, %11 ], [ %35, %32 ]
  store i16 %37, ptr %2, align 4, !tbaa !104
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %.0..0..0..0.
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef double @fma(double noundef %0, double noundef %1, double noundef %2) local_unnamed_addr #4 {
  %4 = tail call double @llvm.fmuladd.f64(double %0, double %1, double %2)
  ret double %4
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef float @__math_invalidf(float noundef %0) local_unnamed_addr #7 {
  %2 = fsub float %0, %0
  %3 = fdiv float %2, %2
  ret float %3
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_oflowf(i32 noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %.not.i = icmp eq i32 %0, 0
  %3 = select i1 %.not.i, float 0x4600000000000000, float 0xC600000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %3, ptr %2, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %4 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..i.i, 0x4600000000000000
  ret float %4
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_xflowf(i32 noundef %0, float noundef %1) local_unnamed_addr #8 {
  %3 = alloca float, align 4
  %.not = icmp eq i32 %0, 0
  %4 = fneg float %1
  %5 = select i1 %.not, float %1, float %4
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %5, ptr %3, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %6 = fmul float %1, %.0..0..0..0..0..0..0..0..0..0..i
  ret float %6
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_uflowf(i32 noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %.not.i = icmp eq i32 %0, 0
  %3 = select i1 %.not.i, float 0x3A00000000000000, float 0xBA00000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %3, ptr %2, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %4 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..i.i, 0x3A00000000000000
  ret float %4
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @ceilf(float noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %3 = alloca float, align 4
  %4 = bitcast float %0 to i32
  %5 = lshr i32 %4, 23
  %6 = and i32 %5, 255
  %7 = add nsw i32 %6, -127
  %8 = icmp samesign ugt i32 %6, 149
  br i1 %8, label %26, label %9

9:                                                ; preds = %1
  %10 = icmp samesign ugt i32 %6, 126
  br i1 %10, label %11, label %23

11:                                               ; preds = %9
  %12 = lshr i32 8388607, %7
  %13 = and i32 %12, %4
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %26, label %15

15:                                               ; preds = %11
  %16 = fadd float %0, 0x4770000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %16, ptr %3, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %17 = icmp slt i32 %4, 0
  %18 = ashr i32 -8388608, %7
  %19 = select i1 %17, i32 0, i32 %12
  %20 = add nuw i32 %19, %4
  %21 = and i32 %20, %18
  %22 = bitcast i32 %21 to float
  br label %26

23:                                               ; preds = %9
  %24 = fadd float %0, 0x4770000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %24, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %.not = icmp sgt i32 %4, -1
  br i1 %.not, label %25, label %26

25:                                               ; preds = %23
  %.not18 = icmp eq i32 %4, 0
  %spec.select = select i1 %.not18, float %0, float 1.000000e+00
  br label %26

26:                                               ; preds = %25, %23, %15, %11, %1
  %.0 = phi float [ %0, %1 ], [ %0, %11 ], [ %22, %15 ], [ -0.000000e+00, %23 ], [ %spec.select, %25 ]
  ret float %.0
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @expf(float noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %3 = alloca float, align 4
  %4 = fpext float %0 to double
  %5 = bitcast float %0 to i32
  %6 = lshr i32 %5, 20
  %7 = and i32 %6, 2047
  %.not = icmp samesign ult i32 %7, 1067
  br i1 %.not, label %21, label %8, !prof !108

8:                                                ; preds = %1
  %9 = fcmp oeq float %0, 0xFFF0000000000000
  br i1 %9, label %39, label %10

10:                                               ; preds = %8
  %.not34 = icmp samesign ult i32 %7, 2040
  br i1 %.not34, label %13, label %11

11:                                               ; preds = %10
  %12 = fadd float %0, %0
  br label %39

13:                                               ; preds = %10
  %14 = fcmp ogt float %0, 0x40562E42E0000000
  br i1 %14, label %15, label %17

15:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float 0x4600000000000000, ptr %3, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %3, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %16 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i, 0x4600000000000000
  br label %39

17:                                               ; preds = %13
  %18 = fcmp olt float %0, 0xC059FE3680000000
  br i1 %18, label %19, label %21

19:                                               ; preds = %17
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float 0x3A00000000000000, ptr %2, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i3 = load volatile float, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %20 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i3, 0x3A00000000000000
  br label %39

21:                                               ; preds = %17, %1
  %22 = fmul double %4, 0x40471547652B82FE
  %23 = fadd double %22, 0x4338000000000000
  %24 = bitcast double %23 to i64
  %25 = fadd double %23, 0xC338000000000000
  %26 = fsub double %22, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw [8 x i8], ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !109
  %30 = shl i64 %24, 47
  %31 = add i64 %29, %30
  %32 = bitcast i64 %31 to double
  %33 = tail call double @llvm.fmuladd.f64(double %26, double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3)
  %34 = fmul double %26, %26
  %35 = tail call double @llvm.fmuladd.f64(double %26, double 0x3F962E42FF0C52D6, double 1.000000e+00)
  %36 = tail call double @llvm.fmuladd.f64(double %33, double %34, double %35)
  %37 = fmul double %36, %32
  %38 = fptrunc double %37 to float
  br label %39

39:                                               ; preds = %21, %19, %15, %11, %8
  %.0 = phi float [ %12, %11 ], [ %16, %15 ], [ %20, %19 ], [ %38, %21 ], [ 0.000000e+00, %8 ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @feclearexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @feraiseexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fetestexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fegetround() local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @__fesetround(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fegetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fesetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @floorf(float noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %3 = alloca float, align 4
  %4 = bitcast float %0 to i32
  %5 = lshr i32 %4, 23
  %6 = and i32 %5, 255
  %7 = add nsw i32 %6, -127
  %8 = icmp samesign ugt i32 %6, 149
  br i1 %8, label %27, label %9

9:                                                ; preds = %1
  %10 = icmp samesign ugt i32 %6, 126
  br i1 %10, label %11, label %22

11:                                               ; preds = %9
  %12 = lshr i32 8388607, %7
  %13 = and i32 %12, %4
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %27, label %15

15:                                               ; preds = %11
  %16 = fadd float %0, 0x4770000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %16, ptr %3, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %.not1819 = icmp slt i32 %4, 0
  %17 = ashr i32 -8388608, %7
  %18 = select i1 %.not1819, i32 %12, i32 0
  %19 = add nsw i32 %18, %4
  %20 = and i32 %19, %17
  %21 = bitcast i32 %20 to float
  br label %27

22:                                               ; preds = %9
  %23 = fadd float %0, 0x4770000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %23, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %24 = icmp sgt i32 %4, -1
  br i1 %24, label %27, label %25

25:                                               ; preds = %22
  %.not = fcmp oeq float %0, 0.000000e+00
  br i1 %.not, label %27, label %26

26:                                               ; preds = %25
  br label %27

27:                                               ; preds = %26, %25, %22, %15, %11, %1
  %.0 = phi float [ %0, %1 ], [ %0, %11 ], [ %21, %15 ], [ -1.000000e+00, %26 ], [ %0, %25 ], [ 0.000000e+00, %22 ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @fmaf(float noundef %0, float noundef %1, float noundef %2) local_unnamed_addr #7 {
  %4 = fpext float %0 to double
  %5 = fpext float %1 to double
  %6 = fmul double %4, %5
  %7 = fpext float %2 to double
  %8 = fadd double %6, %7
  %9 = bitcast double %8 to i64
  %10 = and i64 %9, 536870911
  %11 = icmp ne i64 %10, 268435456
  %12 = and i64 %9, 9218868437227405312
  %13 = icmp eq i64 %12, 9218868437227405312
  %or.cond = or i1 %11, %13
  br i1 %or.cond, label %31, label %14

14:                                               ; preds = %3
  %15 = fsub double %8, %6
  %16 = fcmp oeq double %15, %7
  %17 = fsub double %8, %7
  %18 = fcmp oeq double %17, %6
  %or.cond44 = and i1 %16, %18
  br i1 %or.cond44, label %31, label %19

19:                                               ; preds = %14
  %20 = icmp slt i64 %9, 0
  %21 = fcmp uge double %6, %7
  %22 = xor i1 %21, %20
  %23 = fsub double %6, %8
  %24 = fadd double %23, %7
  %25 = fsub double %7, %8
  %26 = fadd double %6, %25
  %.038 = select i1 %22, double %24, double %26
  %27 = fcmp uge double %.038, 0.000000e+00
  %28 = xor i1 %20, %27
  %29 = or disjoint i64 %9, 1
  %30 = add nsw i64 %9, -1
  %.sroa.0.0.in = select i1 %28, i64 %29, i64 %30
  %.sroa.0.0 = bitcast i64 %.sroa.0.0.in to double
  br label %31

31:                                               ; preds = %3, %14, %19
  %.0.in = phi double [ %.sroa.0.0, %19 ], [ %8, %14 ], [ %8, %3 ]
  %.0 = fptrunc double %.0.in to float
  ret float %.0
}

; Function Attrs: inlinehint nofree norecurse nosync nounwind memory(none)
define internal float @fmodf(float noundef %0, float noundef %1) local_unnamed_addr #9 {
  %3 = bitcast float %0 to i32
  %4 = lshr i32 %3, 23
  %5 = and i32 %4, 255
  %6 = bitcast float %1 to i32
  %7 = lshr i32 %6, 23
  %8 = and i32 %7, 255
  %9 = and i32 %3, -2147483648
  %10 = shl i32 %6, 1
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %17, label %12

12:                                               ; preds = %2
  %13 = tail call float @llvm.fabs.f32(float %1)
  %14 = bitcast float %13 to i32
  %15 = icmp samesign ugt i32 %14, 2139095040
  %16 = icmp eq i32 %5, 255
  %or.cond = or i1 %15, %16
  br i1 %or.cond, label %17, label %20

17:                                               ; preds = %12, %2
  %18 = fmul float %0, %1
  %19 = fdiv float %18, %18
  br label %83

20:                                               ; preds = %12
  %21 = shl i32 %3, 1
  %.not = icmp ugt i32 %21, %10
  br i1 %.not, label %25, label %22

22:                                               ; preds = %20
  %23 = icmp eq i32 %21, %10
  %24 = fmul float %0, 0.000000e+00
  %spec.select = select i1 %23, float %24, float %0
  br label %83

25:                                               ; preds = %20
  %.not81 = icmp eq i32 %5, 0
  br i1 %.not81, label %26, label %34

26:                                               ; preds = %25
  %27 = shl i32 %3, 9
  %28 = icmp sgt i32 %27, -1
  br i1 %28, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %26, %.lr.ph
  %.06586 = phi i32 [ %30, %.lr.ph ], [ %27, %26 ]
  %.07085 = phi i32 [ %29, %.lr.ph ], [ 0, %26 ]
  %29 = add nsw i32 %.07085, -1
  %30 = shl nuw i32 %.06586, 1
  %31 = icmp sgt i32 %30, -1
  br i1 %31, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %26
  %.070.lcssa = phi i32 [ 0, %26 ], [ %29, %.lr.ph ]
  %32 = sub i32 1, %.070.lcssa
  %33 = shl i32 %3, %32
  br label %37

34:                                               ; preds = %25
  %35 = and i32 %3, 8388607
  %36 = or disjoint i32 %35, 8388608
  br label %37

37:                                               ; preds = %34, %._crit_edge
  %.171 = phi i32 [ %5, %34 ], [ %.070.lcssa, %._crit_edge ]
  %.0 = phi i32 [ %36, %34 ], [ %33, %._crit_edge ]
  %.not82 = icmp eq i32 %8, 0
  br i1 %.not82, label %38, label %46

38:                                               ; preds = %37
  %39 = shl i32 %6, 9
  %40 = icmp sgt i32 %39, -1
  br i1 %40, label %.lr.ph90, label %._crit_edge91

.lr.ph90:                                         ; preds = %38, %.lr.ph90
  %.16688 = phi i32 [ %42, %.lr.ph90 ], [ %39, %38 ]
  %.06887 = phi i32 [ %41, %.lr.ph90 ], [ 0, %38 ]
  %41 = add nsw i32 %.06887, -1
  %42 = shl nuw i32 %.16688, 1
  %43 = icmp sgt i32 %42, -1
  br i1 %43, label %.lr.ph90, label %._crit_edge91

._crit_edge91:                                    ; preds = %.lr.ph90, %38
  %.068.lcssa = phi i32 [ 0, %38 ], [ %41, %.lr.ph90 ]
  %44 = sub i32 1, %.068.lcssa
  %45 = shl i32 %6, %44
  br label %49

46:                                               ; preds = %37
  %47 = and i32 %6, 8388607
  %48 = or disjoint i32 %47, 8388608
  br label %49

49:                                               ; preds = %46, %._crit_edge91
  %.sroa.0.0.in = phi i32 [ %48, %46 ], [ %45, %._crit_edge91 ]
  %.169 = phi i32 [ %8, %46 ], [ %.068.lcssa, %._crit_edge91 ]
  %50 = icmp sgt i32 %.171, %.169
  br i1 %50, label %.lr.ph96, label %._crit_edge97

.lr.ph96:                                         ; preds = %49, %57
  %.194 = phi i32 [ %58, %57 ], [ %.0, %49 ]
  %.27293 = phi i32 [ %59, %57 ], [ %.171, %49 ]
  %51 = sub i32 %.194, %.sroa.0.0.in
  %52 = icmp sgt i32 %51, -1
  br i1 %52, label %53, label %57

53:                                               ; preds = %.lr.ph96
  %54 = icmp eq i32 %51, 0
  br i1 %54, label %55, label %57

55:                                               ; preds = %53
  %56 = fmul float %0, 0.000000e+00
  br label %83

57:                                               ; preds = %53, %.lr.ph96
  %.2 = phi i32 [ %.194, %.lr.ph96 ], [ %51, %53 ]
  %58 = shl i32 %.2, 1
  %59 = add nsw i32 %.27293, -1
  %60 = icmp sgt i32 %59, %.169
  br i1 %60, label %.lr.ph96, label %._crit_edge97

._crit_edge97:                                    ; preds = %57, %49
  %.272.lcssa = phi i32 [ %.171, %49 ], [ %.169, %57 ]
  %.1.lcssa = phi i32 [ %.0, %49 ], [ %58, %57 ]
  %61 = sub i32 %.1.lcssa, %.sroa.0.0.in
  %62 = icmp sgt i32 %61, -1
  br i1 %62, label %63, label %67

63:                                               ; preds = %._crit_edge97
  %64 = icmp eq i32 %61, 0
  br i1 %64, label %65, label %67

65:                                               ; preds = %63
  %66 = fmul float %0, 0.000000e+00
  br label %83

67:                                               ; preds = %63, %._crit_edge97
  %.3 = phi i32 [ %.1.lcssa, %._crit_edge97 ], [ %61, %63 ]
  %68 = icmp ult i32 %.3, 8388608
  br i1 %68, label %.lr.ph103, label %._crit_edge104

.lr.ph103:                                        ; preds = %67, %.lr.ph103
  %.4101 = phi i32 [ %69, %.lr.ph103 ], [ %.3, %67 ]
  %.373100 = phi i32 [ %70, %.lr.ph103 ], [ %.272.lcssa, %67 ]
  %69 = shl nuw nsw i32 %.4101, 1
  %70 = add nsw i32 %.373100, -1
  %71 = icmp samesign ult i32 %.4101, 4194304
  br i1 %71, label %.lr.ph103, label %._crit_edge104

._crit_edge104:                                   ; preds = %.lr.ph103, %67
  %.373.lcssa = phi i32 [ %.272.lcssa, %67 ], [ %70, %.lr.ph103 ]
  %.4.lcssa = phi i32 [ %.3, %67 ], [ %69, %.lr.ph103 ]
  %72 = icmp sgt i32 %.373.lcssa, 0
  br i1 %72, label %73, label %77

73:                                               ; preds = %._crit_edge104
  %74 = add i32 %.4.lcssa, -8388608
  %75 = shl i32 %.373.lcssa, 23
  %76 = or i32 %74, %75
  br label %80

77:                                               ; preds = %._crit_edge104
  %78 = sub i32 1, %.373.lcssa
  %79 = lshr i32 %.4.lcssa, %78
  br label %80

80:                                               ; preds = %77, %73
  %.5 = phi i32 [ %76, %73 ], [ %79, %77 ]
  %81 = or i32 %.5, %9
  %82 = bitcast i32 %81 to float
  br label %83

83:                                               ; preds = %80, %65, %55, %22, %17
  %.067 = phi float [ %19, %17 ], [ %56, %55 ], [ %66, %65 ], [ %82, %80 ], [ %spec.select, %22 ]
  ret float %.067
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fabs.f32(float) #6

; Function Attrs: inlinehint nofree nosync nounwind memory(argmem: readwrite)
define internal float @frexpf(float noundef %0, ptr noundef captures(none) %1) local_unnamed_addr #10 {
  %3 = bitcast float %0 to i32
  %4 = lshr i32 %3, 23
  %trunc = trunc i32 %4 to i8
  switch i8 %trunc, label %13 [
    i8 0, label %5
    i8 -1, label %19
  ]

5:                                                ; preds = %2
  %6 = fcmp une float %0, 0.000000e+00
  br i1 %6, label %7, label %12

7:                                                ; preds = %5
  %8 = fmul float %0, 0x43F0000000000000
  %9 = tail call float @frexpf(float noundef %8, ptr noundef %1) #12
  %10 = load i32, ptr %1, align 4, !tbaa !7
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !7
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !7
  %16 = and i32 %3, -2139095041
  %17 = or disjoint i32 %16, 1056964608
  %18 = bitcast i32 %17 to float
  br label %19

19:                                               ; preds = %13, %12, %2
  %.0 = phi float [ %18, %13 ], [ %.014, %12 ], [ %0, %2 ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @ldexpf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = icmp sgt i32 %1, 127
  br i1 %3, label %4, label %11

4:                                                ; preds = %2
  %5 = fmul float %0, 0x47E0000000000000
  %6 = add nsw i32 %1, -127
  %7 = icmp samesign ugt i32 %1, 254
  br i1 %7, label %8, label %scalbnf.exit

8:                                                ; preds = %4
  %9 = fmul float %5, 0x47E0000000000000
  %10 = tail call i32 @llvm.umin.i32(i32 %1, i32 381)
  %spec.store.select.i = add nsw i32 %10, -254
  br label %scalbnf.exit

11:                                               ; preds = %2
  %12 = icmp slt i32 %1, -126
  br i1 %12, label %13, label %scalbnf.exit

13:                                               ; preds = %11
  %14 = fmul float %0, 0x3990000000000000
  %15 = add nuw nsw i32 %1, 102
  %16 = icmp samesign ult i32 %1, -228
  br i1 %16, label %17, label %scalbnf.exit

17:                                               ; preds = %13
  %18 = fmul float %14, 0x3990000000000000
  %19 = tail call i32 @llvm.umax.i32(i32 %1, i32 -330)
  %spec.store.select1.i = add nuw nsw i32 %19, 204
  br label %scalbnf.exit

scalbnf.exit:                                     ; preds = %4, %8, %11, %13, %17
  %.018.i = phi i32 [ %spec.store.select.i, %8 ], [ %6, %4 ], [ %spec.store.select1.i, %17 ], [ %15, %13 ], [ %1, %11 ]
  %.0.i = phi float [ %9, %8 ], [ %5, %4 ], [ %18, %17 ], [ %14, %13 ], [ %0, %11 ]
  %20 = shl nsw i32 %.018.i, 23
  %21 = add nsw i32 %20, 1065353216
  %22 = bitcast i32 %21 to float
  %23 = fmul float %.0.i, %22
  ret float %23
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @scalbnf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = icmp sgt i32 %1, 127
  br i1 %3, label %4, label %11

4:                                                ; preds = %2
  %5 = fmul float %0, 0x47E0000000000000
  %6 = add nsw i32 %1, -127
  %7 = icmp samesign ugt i32 %1, 254
  br i1 %7, label %8, label %20

8:                                                ; preds = %4
  %9 = fmul float %5, 0x47E0000000000000
  %10 = tail call i32 @llvm.umin.i32(i32 %1, i32 381)
  %spec.store.select = add nsw i32 %10, -254
  br label %20

11:                                               ; preds = %2
  %12 = icmp slt i32 %1, -126
  br i1 %12, label %13, label %20

13:                                               ; preds = %11
  %14 = fmul float %0, 0x3990000000000000
  %15 = add nuw nsw i32 %1, 102
  %16 = icmp samesign ult i32 %1, -228
  br i1 %16, label %17, label %20

17:                                               ; preds = %13
  %18 = fmul float %14, 0x3990000000000000
  %19 = tail call i32 @llvm.umax.i32(i32 %1, i32 -330)
  %spec.store.select1 = add nuw nsw i32 %19, 204
  br label %20

20:                                               ; preds = %17, %13, %11, %8, %4
  %.018 = phi i32 [ %spec.store.select, %8 ], [ %6, %4 ], [ %spec.store.select1, %17 ], [ %15, %13 ], [ %1, %11 ]
  %.0 = phi float [ %9, %8 ], [ %5, %4 ], [ %18, %17 ], [ %14, %13 ], [ %0, %11 ]
  %21 = shl nsw i32 %.018, 23
  %22 = add nsw i32 %21, 1065353216
  %23 = bitcast i32 %22 to float
  %24 = fmul float %.0, %23
  ret float %24
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #6

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #6

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @powf(float noundef %0, float noundef %1) local_unnamed_addr #8 {
  %3 = alloca float, align 4
  %4 = alloca float, align 4
  %5 = alloca float, align 4
  %6 = bitcast float %0 to i32
  %7 = bitcast float %1 to i32
  %8 = add i32 %6, -2139095040
  %9 = icmp ult i32 %8, -2130706432
  %.pre = shl i32 %7, 1
  %10 = add i32 %.pre, 16777216
  %11 = icmp ult i32 %10, 16777217
  %or.cond99 = or i1 %9, %11
  br i1 %or.cond99, label %.critedge, label %76, !prof !111

.critedge:                                        ; preds = %2
  %12 = add i32 %.pre, -1
  %13 = icmp ult i32 %12, -16777217
  br i1 %13, label %30, label %14, !prof !108

14:                                               ; preds = %.critedge
  %15 = icmp eq i32 %.pre, 0
  %16 = icmp eq i32 %6, 1065353216
  %or.cond70 = or i1 %16, %15
  br i1 %or.cond70, label %134, label %17

17:                                               ; preds = %14
  %18 = shl i32 %6, 1
  %19 = icmp ugt i32 %18, -16777216
  %20 = icmp samesign ugt i32 %.pre, -16777216
  %or.cond = or i1 %19, %20
  br i1 %or.cond, label %21, label %23

21:                                               ; preds = %17
  %22 = fadd float %0, %1
  br label %134

23:                                               ; preds = %17
  %24 = icmp eq i32 %18, 2130706432
  br i1 %24, label %134, label %25

25:                                               ; preds = %23
  %26 = icmp ult i32 %18, 2130706432
  %27 = icmp slt i32 %7, 0
  %28 = xor i1 %26, %27
  %29 = fmul float %1, %1
  %spec.select71 = select i1 %28, float 0.000000e+00, float %29
  br label %134

30:                                               ; preds = %.critedge
  %31 = shl i32 %6, 1
  %32 = add i32 %31, -1
  %33 = icmp ult i32 %32, -16777217
  br i1 %33, label %49, label %34, !prof !108

34:                                               ; preds = %30
  %35 = fmul float %0, %0
  %.not66 = icmp sgt i32 %6, -1
  br i1 %.not66, label %checkint.exit.thread, label %36

36:                                               ; preds = %34
  %37 = lshr i32 %7, 23
  %38 = and i32 %37, 255
  %39 = add nsw i32 %38, -151
  %or.cond92 = icmp ult i32 %39, -24
  br i1 %or.cond92, label %checkint.exit.thread, label %40

40:                                               ; preds = %36
  %41 = sub nuw nsw i32 150, %38
  %42 = shl nuw nsw i32 1, %41
  %43 = add nsw i32 %42, -1
  %44 = and i32 %43, %7
  %.not.i = icmp ne i32 %44, 0
  %45 = and i32 %42, %7
  %.not9.i = icmp eq i32 %45, 0
  %or.cond93 = or i1 %.not9.i, %.not.i
  %46 = fneg float %35
  %spec.select = select i1 %or.cond93, float %35, float %46
  br label %checkint.exit.thread

checkint.exit.thread:                             ; preds = %40, %36, %34
  %.057 = phi float [ %35, %34 ], [ %35, %36 ], [ %spec.select, %40 ]
  %.not67 = icmp sgt i32 %7, -1
  br i1 %.not67, label %134, label %47

47:                                               ; preds = %checkint.exit.thread
  %48 = fdiv float 1.000000e+00, %.057
  call void @llvm.lifetime.start.p0(ptr nonnull %5)
  store volatile float %48, ptr %5, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %5, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %5)
  br label %134

49:                                               ; preds = %30
  %.not64 = icmp sgt i32 %6, -1
  br i1 %.not64, label %69, label %50

50:                                               ; preds = %49
  %51 = lshr i32 %7, 23
  %52 = and i32 %51, 255
  %53 = icmp samesign ult i32 %52, 127
  br i1 %53, label %.thread, label %54

54:                                               ; preds = %50
  %55 = icmp samesign ugt i32 %52, 150
  br i1 %55, label %checkint.exit76.thread85, label %56

56:                                               ; preds = %54
  %57 = sub nuw nsw i32 150, %52
  %58 = shl nuw nsw i32 1, %57
  %59 = add nsw i32 %58, -1
  %60 = and i32 %59, %7
  %.not.i72 = icmp eq i32 %60, 0
  br i1 %.not.i72, label %61, label %.thread

61:                                               ; preds = %56
  %62 = and i32 %58, %7
  %.not9.i74 = icmp eq i32 %62, 0
  br i1 %.not9.i74, label %checkint.exit76.thread85, label %65

.thread:                                          ; preds = %56, %50
  %63 = fsub float %0, %0
  %64 = fdiv float %63, %63
  br label %134

checkint.exit76.thread85:                         ; preds = %61, %54
  br label %65

65:                                               ; preds = %checkint.exit76.thread85, %61
  %66 = phi i32 [ 0, %checkint.exit76.thread85 ], [ 65536, %61 ]
  %67 = tail call float @llvm.fabs.f32(float %0)
  %68 = bitcast float %67 to i32
  br label %69

69:                                               ; preds = %65, %49
  %.154 = phi i32 [ %68, %65 ], [ %6, %49 ]
  %.151 = phi i32 [ %66, %65 ], [ 0, %49 ]
  %70 = icmp ult i32 %.154, 8388608
  br i1 %70, label %71, label %76

71:                                               ; preds = %69
  %72 = fmul float %0, 0x4160000000000000
  %73 = tail call float @llvm.fabs.f32(float %72)
  %74 = bitcast float %73 to i32
  %75 = add nsw i32 %74, -192937984
  br label %76

76:                                               ; preds = %71, %69, %2
  %.053 = phi i32 [ %75, %71 ], [ %.154, %69 ], [ %6, %2 ]
  %.050 = phi i32 [ %.151, %71 ], [ %.151, %69 ], [ 0, %2 ]
  %77 = add i32 %.053, -1060306944
  %78 = lshr i32 %77, 19
  %79 = and i32 %78, 15
  %80 = and i32 %77, -8388608
  %81 = sub i32 %.053, %80
  %82 = ashr i32 %77, 23
  %83 = zext nneg i32 %79 to i64
  %84 = getelementptr inbounds nuw [16 x i8], ptr @__powf_log2_data, i64 %83
  %85 = load double, ptr %84, align 8, !tbaa !112
  %86 = getelementptr inbounds nuw i8, ptr %84, i64 8
  %87 = load double, ptr %86, align 8, !tbaa !115
  %88 = bitcast i32 %81 to float
  %89 = fpext float %88 to double
  %90 = tail call double @llvm.fmuladd.f64(double %89, double %85, double -1.000000e+00)
  %91 = sitofp i32 %82 to double
  %92 = fadd double %87, %91
  %93 = fmul double %90, %90
  %94 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A)
  %95 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8)
  %96 = fmul double %93, %93
  %97 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FF71547652AB82B, double %92)
  %98 = tail call double @llvm.fmuladd.f64(double %95, double %93, double %97)
  %99 = tail call double @llvm.fmuladd.f64(double %94, double %96, double %98)
  %100 = fpext float %1 to double
  %101 = fmul double %99, %100
  %102 = bitcast double %101 to i64
  %103 = and i64 %102, 9223231299366420480
  %104 = icmp samesign ugt i64 %103, 4638426141214900224
  br i1 %104, label %105, label %115, !prof !116

105:                                              ; preds = %76
  %106 = fcmp ogt double %101, 0x405FFFFFFFD1D571
  br i1 %106, label %107, label %110

107:                                              ; preds = %105
  %.not.i.i = icmp eq i32 %.050, 0
  %108 = select i1 %.not.i.i, float 0x4600000000000000, float 0xC600000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %4)
  store volatile float %108, ptr %4, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %4, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %4)
  %109 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i, 0x4600000000000000
  br label %134

110:                                              ; preds = %105
  %111 = fcmp ugt double %101, -1.500000e+02
  br i1 %111, label %115, label %112

112:                                              ; preds = %110
  %.not.i.i5 = icmp eq i32 %.050, 0
  %113 = select i1 %.not.i.i5, float 0x3A00000000000000, float 0xBA00000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %113, ptr %3, align 4, !tbaa !106
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i6 = load volatile float, ptr %3, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %114 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i6, 0x3A00000000000000
  br label %134

115:                                              ; preds = %110, %76
  %116 = fadd double %101, 0x42E8000000000000
  %117 = bitcast double %116 to i64
  %118 = fadd double %116, 0xC2E8000000000000
  %119 = fsub double %101, %118
  %120 = and i64 %117, 31
  %121 = getelementptr inbounds nuw [8 x i8], ptr @__exp2f_data, i64 %120
  %122 = load i64, ptr %121, align 8, !tbaa !109
  %123 = zext nneg i32 %.050 to i64
  %124 = add i64 %117, %123
  %125 = shl i64 %124, 47
  %126 = add i64 %122, %125
  %127 = bitcast i64 %126 to double
  %128 = tail call double @llvm.fmuladd.f64(double %119, double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3)
  %129 = fmul double %119, %119
  %130 = tail call double @llvm.fmuladd.f64(double %119, double 0x3FE62E42FF0C52D6, double 1.000000e+00)
  %131 = tail call double @llvm.fmuladd.f64(double %128, double %129, double %130)
  %132 = fmul double %131, %127
  %133 = fptrunc double %132 to float
  br label %134

134:                                              ; preds = %115, %112, %107, %.thread, %47, %checkint.exit.thread, %25, %23, %21, %14
  %.0 = phi float [ %22, %21 ], [ 1.000000e+00, %14 ], [ 1.000000e+00, %23 ], [ %.0..0..0..0..0..0..0..0..0..0..i, %47 ], [ %.057, %checkint.exit.thread ], [ %109, %107 ], [ %114, %112 ], [ %133, %115 ], [ %spec.select71, %25 ], [ %64, %.thread ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef float @rintf(float noundef %0) local_unnamed_addr #7 {
  %2 = bitcast float %0 to i32
  %3 = and i32 %2, 2130706432
  %4 = icmp samesign ugt i32 %3, 1249902592
  br i1 %4, label %13, label %5

5:                                                ; preds = %1
  %.not = icmp sgt i32 %2, -1
  %6 = fadd float %0, 0xC160000000000000
  %7 = fadd float %6, 0x4160000000000000
  %8 = fadd float %0, 0x4160000000000000
  %9 = fadd float %8, 0xC160000000000000
  %.0 = select i1 %.not, float %9, float %7
  %10 = fcmp oeq float %.0, 0.000000e+00
  br i1 %10, label %11, label %13

11:                                               ; preds = %5
  %12 = select i1 %.not, float 0.000000e+00, float -0.000000e+00
  br label %13

13:                                               ; preds = %11, %5, %1
  %.010 = phi float [ %12, %11 ], [ %0, %1 ], [ %.0, %5 ]
  ret float %.010
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @roundf(float noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %3 = bitcast float %0 to i32
  %4 = lshr i32 %3, 23
  %5 = and i32 %4, 255
  %6 = icmp samesign ugt i32 %5, 149
  br i1 %6, label %26, label %7

7:                                                ; preds = %1
  %spec.select = tail call float @llvm.fabs.f32(float %0)
  %8 = icmp samesign ult i32 %5, 126
  %9 = fadd float %spec.select, 0x4160000000000000
  br i1 %8, label %10, label %12

10:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %9, ptr %2, align 4, !tbaa !106
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %11 = fmul float %0, 0.000000e+00
  br label %26

12:                                               ; preds = %7
  %13 = fadd float %9, 0xC160000000000000
  %14 = fsub float %13, %spec.select
  %15 = fcmp ogt float %14, 5.000000e-01
  br i1 %15, label %16, label %19

16:                                               ; preds = %12
  %17 = fadd float %spec.select, %14
  %18 = fadd float %17, -1.000000e+00
  br label %24

19:                                               ; preds = %12
  %20 = fcmp ugt float %14, -5.000000e-01
  %21 = fadd float %spec.select, %14
  br i1 %20, label %24, label %22

22:                                               ; preds = %19
  %23 = fadd float %21, 1.000000e+00
  br label %24

24:                                               ; preds = %22, %19, %16
  %.0 = phi float [ %18, %16 ], [ %23, %22 ], [ %21, %19 ]
  %25 = fneg float %.0
  %.not26 = icmp slt i32 %3, 0
  %spec.select25 = select i1 %.not26, float %25, float %.0
  br label %26

26:                                               ; preds = %24, %10, %1
  %.020 = phi float [ %11, %10 ], [ %spec.select25, %24 ], [ %0, %1 ]
  ret float %.020
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #11

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #11

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #11

attributes #0 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "nonlazybind" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #5 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #8 = { inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite) }
attributes #9 = { inlinehint nofree norecurse nosync nounwind memory(none) }
attributes #10 = { inlinehint nofree nosync nounwind memory(argmem: readwrite) }
attributes #11 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { inlinehint }

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!4, !5, !6}
!llvm.errno.tbaa = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/dynamic")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/dynamic")
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"frame-pointer", i32 4}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_Dx64x9_f32", linkageName: "infer_dispatch_0_matmul_Dx64x9_f32", scope: !1, file: !1, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!12 = !DISubroutineType(cc: DW_CC_normal, types: !13)
!13 = !{!14, !15, !46, !75}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !19, file: !19, line: 246, size: 768, elements: !20)
!19 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!20 = !{!21, !29, !32, !35, !37}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!24 = !DICompositeType(tag: DW_TAG_array_type, scope: !19, file: !19, line: 227, baseType: !25, size: 2048, elements: !27)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !26)
!26 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!27 = !{!28}
!28 = !DISubrange(count: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !30, size: 64, offset: 64)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !33, size: 64, offset: 128)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !36, size: 64, offset: 192)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !38, offset: 256)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !19, file: !19, line: 227, size: 512, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !41)
!41 = !DICompositeType(tag: DW_TAG_array_type, scope: !19, file: !19, line: 227, baseType: !42, size: 512, elements: !44)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !43)
!43 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!44 = !{!45}
!45 = !DISubrange(count: 8)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !48)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !49)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !19, file: !19, line: 275, size: 384, elements: !50)
!50 = !{!51, !52, !53, !56, !57, !58, !59, !60, !63, !64, !65, !70}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !25, size: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !25, size: 32, offset: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !54, size: 16, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !55)
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !54, size: 16, offset: 80)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !25, size: 32, offset: 96)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !25, size: 32, offset: 128)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !54, size: 16, offset: 160)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !61, size: 8, offset: 176)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !62)
!62 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !61, size: 8, offset: 184)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !22, size: 64, offset: 192)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !66, size: 64, offset: 256)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !68)
!68 = !DICompositeType(tag: DW_TAG_array_type, scope: !19, file: !19, line: 227, baseType: !69, size: 4096, elements: !27)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !71, size: 64, offset: 320)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!73 = !DICompositeType(tag: DW_TAG_array_type, scope: !19, file: !19, line: 227, baseType: !74, size: 4096, elements: !27)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !42)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !78)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !19, file: !19, line: 321, size: 256, elements: !79)
!79 = !{!80, !81, !82, !83, !84, !85, !86}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !25, size: 32)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !25, size: 32, offset: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !54, size: 16, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !54, size: 16, offset: 80)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !25, size: 32, offset: 96)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !30, size: 64, offset: 128)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !25, size: 32, offset: 192)
!87 = !DILocation(line: 12, column: 8, scope: !11)
!88 = !DILocation(line: 20, column: 8, scope: !11)
!89 = !DILocation(line: 22, column: 8, scope: !11)
!90 = !DILocation(line: 23, column: 8, scope: !11)
!91 = !DILocation(line: 28, column: 8, scope: !11)
!92 = !DILocation(line: 1, column: 1, scope: !11)
!93 = !DILocation(line: 27, column: 8, scope: !11)
!94 = !DILocation(line: 30, column: 8, scope: !11)
!95 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_Dx2x64_f32", linkageName: "infer_dispatch_1_matmul_Dx2x64_f32", scope: !3, file: !3, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!96 = !DILocation(line: 12, column: 8, scope: !95)
!97 = !DILocation(line: 20, column: 8, scope: !95)
!98 = !DILocation(line: 22, column: 8, scope: !95)
!99 = !DILocation(line: 23, column: 8, scope: !95)
!100 = !DILocation(line: 28, column: 8, scope: !95)
!101 = !DILocation(line: 1, column: 1, scope: !95)
!102 = !DILocation(line: 27, column: 8, scope: !95)
!103 = !DILocation(line: 30, column: 8, scope: !95)
!104 = !{!105, !105, i64 0}
!105 = !{!"short", !9, i64 0}
!106 = !{!107, !107, i64 0}
!107 = !{!"float", !9, i64 0}
!108 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!109 = !{!110, !110, i64 0}
!110 = !{!"long", !9, i64 0}
!111 = !{!"branch_weights", i32 4001, i32 4000000}
!112 = !{!113, !114, i64 0}
!113 = !{!"", !114, i64 0, !114, i64 8}
!114 = !{!"double", !9, i64 0}
!115 = !{!113, !114, i64 8}
!116 = !{!"branch_weights", !"expected", i32 1, i32 2000}
