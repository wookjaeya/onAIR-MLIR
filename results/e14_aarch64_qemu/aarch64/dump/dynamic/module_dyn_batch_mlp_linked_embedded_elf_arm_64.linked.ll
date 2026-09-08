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
%iree_hal_executable_dispatch_state_v0_t = type { i32, i32, i16, i16, i32, i32, i16, i8, i8, ptr, ptr, ptr }
%iree_hal_executable_workgroup_state_v0_t = type { i32, i32, i16, i16, i32, ptr, i32 }

@0 = private constant [21 x i8] c"dyn_batch_mlp_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [2 x ptr] [ptr @infer_dispatch_0_matmul_Dx64x9_f32, ptr @infer_dispatch_1_matmul_Dx2x64_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [35 x i8] c"infer_dispatch_0_matmul_Dx64x9_f32\00", align 1
@2 = private constant [35 x i8] c"infer_dispatch_1_matmul_Dx2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [2 x ptr] [ptr @1, ptr @2]
@3 = private constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @4 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [2 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 2, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_matmul_Dx64x9_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !11 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !87
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !87
  %6 = load i32, ptr %5, align 4, !dbg !87
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !88
  %8 = load i32, ptr %7, align 4, !dbg !88
  %9 = zext i32 %6 to i64, !dbg !89
  %10 = zext i32 %8 to i64, !dbg !90
  %11 = shl i64 %10, 32, !dbg !91
  %12 = or i64 %9, %11, !dbg !92
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !93
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !93
  %15 = load ptr, ptr %14, align 8, !dbg !93
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !93
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !94
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !94
  %18 = load ptr, ptr %17, align 8, !dbg !94
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !94
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !95
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !95
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !95
  %22 = load ptr, ptr %21, align 8, !dbg !95
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !95
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !96
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !96
  %25 = zext i32 %24 to i64, !dbg !96
  %26 = sdiv i64 %25, 8, !dbg !96
  %27 = mul i64 %26, 8, !dbg !96
  %28 = icmp ne i64 %25, %27, !dbg !96
  %29 = icmp slt i64 %25, 0, !dbg !96
  %30 = and i1 %28, %29, !dbg !96
  %31 = add i64 %26, -1, !dbg !96
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !96
  %33 = srem i64 %25, 8, !dbg !96
  %34 = icmp slt i64 %33, 0, !dbg !96
  %35 = add nsw i64 %33, 8, !dbg !96
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !96
  %37 = mul nsw i64 %32, 64, !dbg !96
  %38 = mul nsw i64 %36, 8, !dbg !96
  %39 = mul nsw i64 %32, -64, !dbg !96
  %40 = add i64 %39, %12, !dbg !96
  %41 = icmp slt i64 %40, 64, !dbg !96
  %42 = select i1 %41, i64 %40, i64 64, !dbg !96
  %43 = icmp slt i64 %42, 0, !dbg !96
  %44 = sub i64 -1, %42, !dbg !96
  %45 = select i1 %43, i64 %44, i64 %42, !dbg !96
  %46 = sdiv i64 %45, 64, !dbg !96
  %47 = sub i64 -1, %46, !dbg !96
  %48 = select i1 %43, i64 %47, i64 %46, !dbg !96
  %49 = mul nsw i64 %48, 64, !dbg !96
  %50 = icmp sgt i64 %49, 0, !dbg !96
  br i1 %50, label %51, label %405, !dbg !96

51:                                               ; preds = %3
  %52 = add i64 512, %38, !dbg !96
  %53 = getelementptr float, ptr %15, i64 %52, !dbg !96
  %54 = load <8 x float>, ptr %53, align 4, !dbg !96
  br label %55, !dbg !96

55:                                               ; preds = %307, %51
  %56 = phi i64 [ %404, %307 ], [ 0, %51 ], !dbg !96
  %57 = icmp slt i64 %56, 64, !dbg !96
  br i1 %57, label %58, label %405, !dbg !96

58:                                               ; preds = %62, %55
  %59 = phi i64 [ %306, %62 ], [ 0, %55 ], !dbg !96
  %60 = phi [8 x <8 x float>] [ %305, %62 ], [ zeroinitializer, %55 ], !dbg !96
  %61 = icmp slt i64 %59, 8, !dbg !96
  br i1 %61, label %62, label %307, !dbg !96

62:                                               ; preds = %58
  %63 = mul i64 %59, 64, !dbg !96
  %64 = add i64 %63, %38, !dbg !96
  %65 = getelementptr float, ptr %15, i64 %64, !dbg !96
  %66 = load <8 x float>, ptr %65, align 4, !dbg !96
  %67 = add i64 %59, 1, !dbg !96
  %68 = mul i64 %67, 64, !dbg !96
  %69 = add i64 %68, %38, !dbg !96
  %70 = getelementptr float, ptr %15, i64 %69, !dbg !96
  %71 = load <8 x float>, ptr %70, align 4, !dbg !96
  %72 = add i64 %59, 2, !dbg !96
  %73 = mul i64 %72, 64, !dbg !96
  %74 = add i64 %73, %38, !dbg !96
  %75 = getelementptr float, ptr %15, i64 %74, !dbg !96
  %76 = load <8 x float>, ptr %75, align 4, !dbg !96
  %77 = add i64 %59, 3, !dbg !96
  %78 = mul i64 %77, 64, !dbg !96
  %79 = add i64 %78, %38, !dbg !96
  %80 = getelementptr float, ptr %15, i64 %79, !dbg !96
  %81 = load <8 x float>, ptr %80, align 4, !dbg !96
  %82 = add i64 %56, %37, !dbg !97
  %83 = mul nuw nsw i64 %82, 9, !dbg !97
  %84 = add nuw nsw i64 %83, %59, !dbg !97
  %85 = getelementptr inbounds nuw float, ptr %18, i64 %84, !dbg !97
  %86 = load float, ptr %85, align 4, !dbg !97
  %87 = insertelement <8 x float> poison, float %86, i32 0, !dbg !97
  %88 = shufflevector <8 x float> %87, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %89 = extractvalue [8 x <8 x float>] %60, 0, !dbg !97
  %90 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %88, <8 x float> %66, <8 x float> %89), !dbg !97
  %91 = add i64 %82, 1, !dbg !97
  %92 = mul nuw nsw i64 %91, 9, !dbg !97
  %93 = add nuw nsw i64 %92, %59, !dbg !97
  %94 = getelementptr inbounds nuw float, ptr %18, i64 %93, !dbg !97
  %95 = load float, ptr %94, align 4, !dbg !97
  %96 = insertelement <8 x float> poison, float %95, i32 0, !dbg !97
  %97 = shufflevector <8 x float> %96, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %98 = extractvalue [8 x <8 x float>] %60, 1, !dbg !97
  %99 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %97, <8 x float> %66, <8 x float> %98), !dbg !97
  %100 = add i64 %82, 2, !dbg !97
  %101 = mul nuw nsw i64 %100, 9, !dbg !97
  %102 = add nuw nsw i64 %101, %59, !dbg !97
  %103 = getelementptr inbounds nuw float, ptr %18, i64 %102, !dbg !97
  %104 = load float, ptr %103, align 4, !dbg !97
  %105 = insertelement <8 x float> poison, float %104, i32 0, !dbg !97
  %106 = shufflevector <8 x float> %105, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %107 = extractvalue [8 x <8 x float>] %60, 2, !dbg !97
  %108 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %106, <8 x float> %66, <8 x float> %107), !dbg !97
  %109 = add i64 %82, 3, !dbg !97
  %110 = mul nuw nsw i64 %109, 9, !dbg !97
  %111 = add nuw nsw i64 %110, %59, !dbg !97
  %112 = getelementptr inbounds nuw float, ptr %18, i64 %111, !dbg !97
  %113 = load float, ptr %112, align 4, !dbg !97
  %114 = insertelement <8 x float> poison, float %113, i32 0, !dbg !97
  %115 = shufflevector <8 x float> %114, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %116 = extractvalue [8 x <8 x float>] %60, 3, !dbg !97
  %117 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %115, <8 x float> %66, <8 x float> %116), !dbg !97
  %118 = add i64 %82, 4, !dbg !97
  %119 = mul nuw nsw i64 %118, 9, !dbg !97
  %120 = add nuw nsw i64 %119, %59, !dbg !97
  %121 = getelementptr inbounds nuw float, ptr %18, i64 %120, !dbg !97
  %122 = load float, ptr %121, align 4, !dbg !97
  %123 = insertelement <8 x float> poison, float %122, i32 0, !dbg !97
  %124 = shufflevector <8 x float> %123, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %125 = extractvalue [8 x <8 x float>] %60, 4, !dbg !97
  %126 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %124, <8 x float> %66, <8 x float> %125), !dbg !97
  %127 = add i64 %82, 5, !dbg !97
  %128 = mul nuw nsw i64 %127, 9, !dbg !97
  %129 = add nuw nsw i64 %128, %59, !dbg !97
  %130 = getelementptr inbounds nuw float, ptr %18, i64 %129, !dbg !97
  %131 = load float, ptr %130, align 4, !dbg !97
  %132 = insertelement <8 x float> poison, float %131, i32 0, !dbg !97
  %133 = shufflevector <8 x float> %132, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %134 = extractvalue [8 x <8 x float>] %60, 5, !dbg !97
  %135 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %133, <8 x float> %66, <8 x float> %134), !dbg !97
  %136 = add i64 %82, 6, !dbg !97
  %137 = mul nuw nsw i64 %136, 9, !dbg !97
  %138 = add nuw nsw i64 %137, %59, !dbg !97
  %139 = getelementptr inbounds nuw float, ptr %18, i64 %138, !dbg !97
  %140 = load float, ptr %139, align 4, !dbg !97
  %141 = insertelement <8 x float> poison, float %140, i32 0, !dbg !97
  %142 = shufflevector <8 x float> %141, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %143 = extractvalue [8 x <8 x float>] %60, 6, !dbg !97
  %144 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %66, <8 x float> %143), !dbg !97
  %145 = add i64 %82, 7, !dbg !97
  %146 = mul nuw nsw i64 %145, 9, !dbg !97
  %147 = add nuw nsw i64 %146, %59, !dbg !97
  %148 = getelementptr inbounds nuw float, ptr %18, i64 %147, !dbg !97
  %149 = load float, ptr %148, align 4, !dbg !97
  %150 = insertelement <8 x float> poison, float %149, i32 0, !dbg !97
  %151 = shufflevector <8 x float> %150, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %152 = extractvalue [8 x <8 x float>] %60, 7, !dbg !97
  %153 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %151, <8 x float> %66, <8 x float> %152), !dbg !97
  %154 = add nuw nsw i64 %83, %67, !dbg !97
  %155 = getelementptr inbounds nuw float, ptr %18, i64 %154, !dbg !97
  %156 = load float, ptr %155, align 4, !dbg !97
  %157 = insertelement <8 x float> poison, float %156, i32 0, !dbg !97
  %158 = shufflevector <8 x float> %157, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %159 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %158, <8 x float> %71, <8 x float> %90), !dbg !97
  %160 = add nuw nsw i64 %92, %67, !dbg !97
  %161 = getelementptr inbounds nuw float, ptr %18, i64 %160, !dbg !97
  %162 = load float, ptr %161, align 4, !dbg !97
  %163 = insertelement <8 x float> poison, float %162, i32 0, !dbg !97
  %164 = shufflevector <8 x float> %163, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %165 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %164, <8 x float> %71, <8 x float> %99), !dbg !97
  %166 = add nuw nsw i64 %101, %67, !dbg !97
  %167 = getelementptr inbounds nuw float, ptr %18, i64 %166, !dbg !97
  %168 = load float, ptr %167, align 4, !dbg !97
  %169 = insertelement <8 x float> poison, float %168, i32 0, !dbg !97
  %170 = shufflevector <8 x float> %169, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %171 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %170, <8 x float> %71, <8 x float> %108), !dbg !97
  %172 = add nuw nsw i64 %110, %67, !dbg !97
  %173 = getelementptr inbounds nuw float, ptr %18, i64 %172, !dbg !97
  %174 = load float, ptr %173, align 4, !dbg !97
  %175 = insertelement <8 x float> poison, float %174, i32 0, !dbg !97
  %176 = shufflevector <8 x float> %175, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %177 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %176, <8 x float> %71, <8 x float> %117), !dbg !97
  %178 = add nuw nsw i64 %119, %67, !dbg !97
  %179 = getelementptr inbounds nuw float, ptr %18, i64 %178, !dbg !97
  %180 = load float, ptr %179, align 4, !dbg !97
  %181 = insertelement <8 x float> poison, float %180, i32 0, !dbg !97
  %182 = shufflevector <8 x float> %181, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %183 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %182, <8 x float> %71, <8 x float> %126), !dbg !97
  %184 = add nuw nsw i64 %128, %67, !dbg !97
  %185 = getelementptr inbounds nuw float, ptr %18, i64 %184, !dbg !97
  %186 = load float, ptr %185, align 4, !dbg !97
  %187 = insertelement <8 x float> poison, float %186, i32 0, !dbg !97
  %188 = shufflevector <8 x float> %187, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %189 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %188, <8 x float> %71, <8 x float> %135), !dbg !97
  %190 = add nuw nsw i64 %137, %67, !dbg !97
  %191 = getelementptr inbounds nuw float, ptr %18, i64 %190, !dbg !97
  %192 = load float, ptr %191, align 4, !dbg !97
  %193 = insertelement <8 x float> poison, float %192, i32 0, !dbg !97
  %194 = shufflevector <8 x float> %193, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %195 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %194, <8 x float> %71, <8 x float> %144), !dbg !97
  %196 = add nuw nsw i64 %146, %67, !dbg !97
  %197 = getelementptr inbounds nuw float, ptr %18, i64 %196, !dbg !97
  %198 = load float, ptr %197, align 4, !dbg !97
  %199 = insertelement <8 x float> poison, float %198, i32 0, !dbg !97
  %200 = shufflevector <8 x float> %199, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %201 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %200, <8 x float> %71, <8 x float> %153), !dbg !97
  %202 = add nuw nsw i64 %83, %72, !dbg !97
  %203 = getelementptr inbounds nuw float, ptr %18, i64 %202, !dbg !97
  %204 = load float, ptr %203, align 4, !dbg !97
  %205 = insertelement <8 x float> poison, float %204, i32 0, !dbg !97
  %206 = shufflevector <8 x float> %205, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %207 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %206, <8 x float> %76, <8 x float> %159), !dbg !97
  %208 = add nuw nsw i64 %92, %72, !dbg !97
  %209 = getelementptr inbounds nuw float, ptr %18, i64 %208, !dbg !97
  %210 = load float, ptr %209, align 4, !dbg !97
  %211 = insertelement <8 x float> poison, float %210, i32 0, !dbg !97
  %212 = shufflevector <8 x float> %211, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %213 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %212, <8 x float> %76, <8 x float> %165), !dbg !97
  %214 = add nuw nsw i64 %101, %72, !dbg !97
  %215 = getelementptr inbounds nuw float, ptr %18, i64 %214, !dbg !97
  %216 = load float, ptr %215, align 4, !dbg !97
  %217 = insertelement <8 x float> poison, float %216, i32 0, !dbg !97
  %218 = shufflevector <8 x float> %217, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %219 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %218, <8 x float> %76, <8 x float> %171), !dbg !97
  %220 = add nuw nsw i64 %110, %72, !dbg !97
  %221 = getelementptr inbounds nuw float, ptr %18, i64 %220, !dbg !97
  %222 = load float, ptr %221, align 4, !dbg !97
  %223 = insertelement <8 x float> poison, float %222, i32 0, !dbg !97
  %224 = shufflevector <8 x float> %223, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %225 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %224, <8 x float> %76, <8 x float> %177), !dbg !97
  %226 = add nuw nsw i64 %119, %72, !dbg !97
  %227 = getelementptr inbounds nuw float, ptr %18, i64 %226, !dbg !97
  %228 = load float, ptr %227, align 4, !dbg !97
  %229 = insertelement <8 x float> poison, float %228, i32 0, !dbg !97
  %230 = shufflevector <8 x float> %229, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %231 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %230, <8 x float> %76, <8 x float> %183), !dbg !97
  %232 = add nuw nsw i64 %128, %72, !dbg !97
  %233 = getelementptr inbounds nuw float, ptr %18, i64 %232, !dbg !97
  %234 = load float, ptr %233, align 4, !dbg !97
  %235 = insertelement <8 x float> poison, float %234, i32 0, !dbg !97
  %236 = shufflevector <8 x float> %235, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %237 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %236, <8 x float> %76, <8 x float> %189), !dbg !97
  %238 = add nuw nsw i64 %137, %72, !dbg !97
  %239 = getelementptr inbounds nuw float, ptr %18, i64 %238, !dbg !97
  %240 = load float, ptr %239, align 4, !dbg !97
  %241 = insertelement <8 x float> poison, float %240, i32 0, !dbg !97
  %242 = shufflevector <8 x float> %241, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %243 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %242, <8 x float> %76, <8 x float> %195), !dbg !97
  %244 = add nuw nsw i64 %146, %72, !dbg !97
  %245 = getelementptr inbounds nuw float, ptr %18, i64 %244, !dbg !97
  %246 = load float, ptr %245, align 4, !dbg !97
  %247 = insertelement <8 x float> poison, float %246, i32 0, !dbg !97
  %248 = shufflevector <8 x float> %247, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %249 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %248, <8 x float> %76, <8 x float> %201), !dbg !97
  %250 = add nuw nsw i64 %83, %77, !dbg !97
  %251 = getelementptr inbounds nuw float, ptr %18, i64 %250, !dbg !97
  %252 = load float, ptr %251, align 4, !dbg !97
  %253 = insertelement <8 x float> poison, float %252, i32 0, !dbg !97
  %254 = shufflevector <8 x float> %253, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %255 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %254, <8 x float> %81, <8 x float> %207), !dbg !97
  %256 = add nuw nsw i64 %92, %77, !dbg !97
  %257 = getelementptr inbounds nuw float, ptr %18, i64 %256, !dbg !97
  %258 = load float, ptr %257, align 4, !dbg !97
  %259 = insertelement <8 x float> poison, float %258, i32 0, !dbg !97
  %260 = shufflevector <8 x float> %259, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %261 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %260, <8 x float> %81, <8 x float> %213), !dbg !97
  %262 = add nuw nsw i64 %101, %77, !dbg !97
  %263 = getelementptr inbounds nuw float, ptr %18, i64 %262, !dbg !97
  %264 = load float, ptr %263, align 4, !dbg !97
  %265 = insertelement <8 x float> poison, float %264, i32 0, !dbg !97
  %266 = shufflevector <8 x float> %265, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %267 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %266, <8 x float> %81, <8 x float> %219), !dbg !97
  %268 = add nuw nsw i64 %110, %77, !dbg !97
  %269 = getelementptr inbounds nuw float, ptr %18, i64 %268, !dbg !97
  %270 = load float, ptr %269, align 4, !dbg !97
  %271 = insertelement <8 x float> poison, float %270, i32 0, !dbg !97
  %272 = shufflevector <8 x float> %271, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %273 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %272, <8 x float> %81, <8 x float> %225), !dbg !97
  %274 = add nuw nsw i64 %119, %77, !dbg !97
  %275 = getelementptr inbounds nuw float, ptr %18, i64 %274, !dbg !97
  %276 = load float, ptr %275, align 4, !dbg !97
  %277 = insertelement <8 x float> poison, float %276, i32 0, !dbg !97
  %278 = shufflevector <8 x float> %277, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %279 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %278, <8 x float> %81, <8 x float> %231), !dbg !97
  %280 = add nuw nsw i64 %128, %77, !dbg !97
  %281 = getelementptr inbounds nuw float, ptr %18, i64 %280, !dbg !97
  %282 = load float, ptr %281, align 4, !dbg !97
  %283 = insertelement <8 x float> poison, float %282, i32 0, !dbg !97
  %284 = shufflevector <8 x float> %283, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %285 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %284, <8 x float> %81, <8 x float> %237), !dbg !97
  %286 = add nuw nsw i64 %137, %77, !dbg !97
  %287 = getelementptr inbounds nuw float, ptr %18, i64 %286, !dbg !97
  %288 = load float, ptr %287, align 4, !dbg !97
  %289 = insertelement <8 x float> poison, float %288, i32 0, !dbg !97
  %290 = shufflevector <8 x float> %289, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %291 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %290, <8 x float> %81, <8 x float> %243), !dbg !97
  %292 = add nuw nsw i64 %146, %77, !dbg !97
  %293 = getelementptr inbounds nuw float, ptr %18, i64 %292, !dbg !97
  %294 = load float, ptr %293, align 4, !dbg !97
  %295 = insertelement <8 x float> poison, float %294, i32 0, !dbg !97
  %296 = shufflevector <8 x float> %295, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %297 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %296, <8 x float> %81, <8 x float> %249), !dbg !97
  %298 = insertvalue [8 x <8 x float>] poison, <8 x float> %255, 0, !dbg !97
  %299 = insertvalue [8 x <8 x float>] %298, <8 x float> %261, 1, !dbg !97
  %300 = insertvalue [8 x <8 x float>] %299, <8 x float> %267, 2, !dbg !97
  %301 = insertvalue [8 x <8 x float>] %300, <8 x float> %273, 3, !dbg !97
  %302 = insertvalue [8 x <8 x float>] %301, <8 x float> %279, 4, !dbg !97
  %303 = insertvalue [8 x <8 x float>] %302, <8 x float> %285, 5, !dbg !97
  %304 = insertvalue [8 x <8 x float>] %303, <8 x float> %291, 6, !dbg !97
  %305 = insertvalue [8 x <8 x float>] %304, <8 x float> %297, 7, !dbg !97
  %306 = add i64 %59, 4, !dbg !96
  br label %58, !dbg !96

307:                                              ; preds = %58
  %308 = add i64 %56, %37, !dbg !97
  %309 = mul nuw nsw i64 %308, 9, !dbg !97
  %310 = add nuw nsw i64 %309, 8, !dbg !97
  %311 = getelementptr inbounds nuw float, ptr %18, i64 %310, !dbg !97
  %312 = load float, ptr %311, align 4, !dbg !97
  %313 = insertelement <8 x float> poison, float %312, i32 0, !dbg !97
  %314 = shufflevector <8 x float> %313, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %315 = extractvalue [8 x <8 x float>] %60, 0, !dbg !97
  %316 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %314, <8 x float> %54, <8 x float> %315), !dbg !97
  %317 = add i64 %308, 1, !dbg !97
  %318 = mul nuw nsw i64 %317, 9, !dbg !97
  %319 = add nuw nsw i64 %318, 8, !dbg !97
  %320 = getelementptr inbounds nuw float, ptr %18, i64 %319, !dbg !97
  %321 = load float, ptr %320, align 4, !dbg !97
  %322 = insertelement <8 x float> poison, float %321, i32 0, !dbg !97
  %323 = shufflevector <8 x float> %322, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %324 = extractvalue [8 x <8 x float>] %60, 1, !dbg !97
  %325 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %323, <8 x float> %54, <8 x float> %324), !dbg !97
  %326 = add i64 %308, 2, !dbg !97
  %327 = mul nuw nsw i64 %326, 9, !dbg !97
  %328 = add nuw nsw i64 %327, 8, !dbg !97
  %329 = getelementptr inbounds nuw float, ptr %18, i64 %328, !dbg !97
  %330 = load float, ptr %329, align 4, !dbg !97
  %331 = insertelement <8 x float> poison, float %330, i32 0, !dbg !97
  %332 = shufflevector <8 x float> %331, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %333 = extractvalue [8 x <8 x float>] %60, 2, !dbg !97
  %334 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %332, <8 x float> %54, <8 x float> %333), !dbg !97
  %335 = add i64 %308, 3, !dbg !97
  %336 = mul nuw nsw i64 %335, 9, !dbg !97
  %337 = add nuw nsw i64 %336, 8, !dbg !97
  %338 = getelementptr inbounds nuw float, ptr %18, i64 %337, !dbg !97
  %339 = load float, ptr %338, align 4, !dbg !97
  %340 = insertelement <8 x float> poison, float %339, i32 0, !dbg !97
  %341 = shufflevector <8 x float> %340, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %342 = extractvalue [8 x <8 x float>] %60, 3, !dbg !97
  %343 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %341, <8 x float> %54, <8 x float> %342), !dbg !97
  %344 = add i64 %308, 4, !dbg !97
  %345 = mul nuw nsw i64 %344, 9, !dbg !97
  %346 = add nuw nsw i64 %345, 8, !dbg !97
  %347 = getelementptr inbounds nuw float, ptr %18, i64 %346, !dbg !97
  %348 = load float, ptr %347, align 4, !dbg !97
  %349 = insertelement <8 x float> poison, float %348, i32 0, !dbg !97
  %350 = shufflevector <8 x float> %349, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %351 = extractvalue [8 x <8 x float>] %60, 4, !dbg !97
  %352 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %350, <8 x float> %54, <8 x float> %351), !dbg !97
  %353 = add i64 %308, 5, !dbg !97
  %354 = mul nuw nsw i64 %353, 9, !dbg !97
  %355 = add nuw nsw i64 %354, 8, !dbg !97
  %356 = getelementptr inbounds nuw float, ptr %18, i64 %355, !dbg !97
  %357 = load float, ptr %356, align 4, !dbg !97
  %358 = insertelement <8 x float> poison, float %357, i32 0, !dbg !97
  %359 = shufflevector <8 x float> %358, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %360 = extractvalue [8 x <8 x float>] %60, 5, !dbg !97
  %361 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %359, <8 x float> %54, <8 x float> %360), !dbg !97
  %362 = add i64 %308, 6, !dbg !97
  %363 = mul nuw nsw i64 %362, 9, !dbg !97
  %364 = add nuw nsw i64 %363, 8, !dbg !97
  %365 = getelementptr inbounds nuw float, ptr %18, i64 %364, !dbg !97
  %366 = load float, ptr %365, align 4, !dbg !97
  %367 = insertelement <8 x float> poison, float %366, i32 0, !dbg !97
  %368 = shufflevector <8 x float> %367, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %369 = extractvalue [8 x <8 x float>] %60, 6, !dbg !97
  %370 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %368, <8 x float> %54, <8 x float> %369), !dbg !97
  %371 = add i64 %308, 7, !dbg !97
  %372 = mul nuw nsw i64 %371, 9, !dbg !97
  %373 = add nuw nsw i64 %372, 8, !dbg !97
  %374 = getelementptr inbounds nuw float, ptr %18, i64 %373, !dbg !97
  %375 = load float, ptr %374, align 4, !dbg !97
  %376 = insertelement <8 x float> poison, float %375, i32 0, !dbg !97
  %377 = shufflevector <8 x float> %376, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %378 = extractvalue [8 x <8 x float>] %60, 7, !dbg !97
  %379 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %377, <8 x float> %54, <8 x float> %378), !dbg !97
  %380 = mul i64 %308, 64, !dbg !96
  %381 = add i64 %380, %38, !dbg !96
  %382 = getelementptr float, ptr %22, i64 %381, !dbg !96
  store <8 x float> %316, ptr %382, align 4, !dbg !96
  %383 = mul i64 %317, 64, !dbg !96
  %384 = add i64 %383, %38, !dbg !96
  %385 = getelementptr float, ptr %22, i64 %384, !dbg !96
  store <8 x float> %325, ptr %385, align 4, !dbg !96
  %386 = mul i64 %326, 64, !dbg !96
  %387 = add i64 %386, %38, !dbg !96
  %388 = getelementptr float, ptr %22, i64 %387, !dbg !96
  store <8 x float> %334, ptr %388, align 4, !dbg !96
  %389 = mul i64 %335, 64, !dbg !96
  %390 = add i64 %389, %38, !dbg !96
  %391 = getelementptr float, ptr %22, i64 %390, !dbg !96
  store <8 x float> %343, ptr %391, align 4, !dbg !96
  %392 = mul i64 %344, 64, !dbg !96
  %393 = add i64 %392, %38, !dbg !96
  %394 = getelementptr float, ptr %22, i64 %393, !dbg !96
  store <8 x float> %352, ptr %394, align 4, !dbg !96
  %395 = mul i64 %353, 64, !dbg !96
  %396 = add i64 %395, %38, !dbg !96
  %397 = getelementptr float, ptr %22, i64 %396, !dbg !96
  store <8 x float> %361, ptr %397, align 4, !dbg !96
  %398 = mul i64 %362, 64, !dbg !96
  %399 = add i64 %398, %38, !dbg !96
  %400 = getelementptr float, ptr %22, i64 %399, !dbg !96
  store <8 x float> %370, ptr %400, align 4, !dbg !96
  %401 = mul i64 %371, 64, !dbg !96
  %402 = add i64 %401, %38, !dbg !96
  %403 = getelementptr float, ptr %22, i64 %402, !dbg !96
  store <8 x float> %379, ptr %403, align 4, !dbg !96
  %404 = add i64 %56, 8, !dbg !96
  br label %55, !dbg !96

405:                                              ; preds = %509, %55, %3
  %406 = phi i64 [ %510, %509 ], [ %49, %55 ], [ %49, %3 ], !dbg !96
  %407 = icmp slt i64 %406, %42, !dbg !96
  br i1 %407, label %408, label %511, !dbg !96

408:                                              ; preds = %405
  %409 = sub i64 %42, %406, !dbg !96
  br label %410, !dbg !96

410:                                              ; preds = %507, %408
  %411 = phi i64 [ %508, %507 ], [ 0, %408 ], !dbg !96
  %412 = icmp slt i64 %411, %409, !dbg !96
  br i1 %412, label %413, label %509, !dbg !96

413:                                              ; preds = %410
  %414 = mul nsw i64 %411, -1, !dbg !96
  %415 = sub i64 %414, %406, !dbg !96
  %416 = add i64 %415, %42, !dbg !96
  %417 = icmp slt i64 %416, 8, !dbg !96
  %418 = select i1 %417, i64 %416, i64 8, !dbg !96
  br label %419, !dbg !98

419:                                              ; preds = %434, %413
  %420 = phi i64 [ %435, %434 ], [ 0, %413 ], !dbg !98
  %421 = icmp slt i64 %420, %418, !dbg !98
  br i1 %421, label %422, label %436, !dbg !98

422:                                              ; preds = %425, %419
  %423 = phi i64 [ %433, %425 ], [ 0, %419 ], !dbg !98
  %424 = icmp slt i64 %423, 8, !dbg !98
  br i1 %424, label %425, label %434, !dbg !98

425:                                              ; preds = %422
  %426 = add i64 %37, %406, !dbg !98
  %427 = add i64 %426, %411, !dbg !98
  %428 = add i64 %427, %420, !dbg !98
  %429 = add i64 %38, %423, !dbg !98
  %430 = mul nuw nsw i64 %428, 64, !dbg !98
  %431 = add nuw nsw i64 %430, %429, !dbg !98
  %432 = getelementptr inbounds nuw float, ptr %22, i64 %431, !dbg !98
  store float 0.000000e+00, ptr %432, align 4, !dbg !98
  %433 = add i64 %423, 1, !dbg !98
  br label %422, !dbg !98

434:                                              ; preds = %422
  %435 = add i64 %420, 1, !dbg !98
  br label %419, !dbg !98

436:                                              ; preds = %419
  %437 = add i64 %411, %406, !dbg !96
  %438 = add i64 %437, %37, !dbg !96
  br label %439, !dbg !96

439:                                              ; preds = %477, %436
  %440 = phi i64 [ %478, %477 ], [ 0, %436 ], !dbg !96
  %441 = icmp slt i64 %440, 8, !dbg !96
  br i1 %441, label %442, label %479, !dbg !96

442:                                              ; preds = %475, %439
  %443 = phi i64 [ %476, %475 ], [ 0, %439 ], !dbg !96
  %444 = icmp slt i64 %443, %418, !dbg !96
  br i1 %444, label %445, label %477, !dbg !96

445:                                              ; preds = %473, %442
  %446 = phi i64 [ %474, %473 ], [ 0, %442 ], !dbg !96
  %447 = icmp slt i64 %446, 8, !dbg !96
  br i1 %447, label %448, label %475, !dbg !96

448:                                              ; preds = %451, %445
  %449 = phi i64 [ %472, %451 ], [ 0, %445 ], !dbg !96
  %450 = icmp slt i64 %449, 4, !dbg !96
  br i1 %450, label %451, label %473, !dbg !96

451:                                              ; preds = %448
  %452 = add i64 %438, %443, !dbg !96
  %453 = add i64 %440, %449, !dbg !96
  %454 = mul nuw nsw i64 %452, 9, !dbg !96
  %455 = add nuw nsw i64 %454, %453, !dbg !96
  %456 = getelementptr inbounds nuw float, ptr %18, i64 %455, !dbg !96
  %457 = load float, ptr %456, align 4, !dbg !96
  %458 = add i64 %38, %446, !dbg !96
  %459 = mul nuw nsw i64 %453, 64, !dbg !96
  %460 = add nuw nsw i64 %459, %458, !dbg !96
  %461 = getelementptr inbounds nuw float, ptr %15, i64 %460, !dbg !96
  %462 = load float, ptr %461, align 4, !dbg !96
  %463 = add i64 %37, %406, !dbg !96
  %464 = add i64 %463, %411, !dbg !96
  %465 = add i64 %464, %443, !dbg !96
  %466 = mul nuw nsw i64 %465, 64, !dbg !96
  %467 = add nuw nsw i64 %466, %458, !dbg !96
  %468 = getelementptr inbounds nuw float, ptr %22, i64 %467, !dbg !96
  %469 = load float, ptr %468, align 4, !dbg !96
  %470 = fmul contract float %457, %462, !dbg !97
  %471 = fadd contract float %469, %470, !dbg !97
  store float %471, ptr %468, align 4, !dbg !96
  %472 = add i64 %449, 1, !dbg !96
  br label %448, !dbg !96

473:                                              ; preds = %448
  %474 = add i64 %446, 1, !dbg !96
  br label %445, !dbg !96

475:                                              ; preds = %445
  %476 = add i64 %443, 1, !dbg !96
  br label %442, !dbg !96

477:                                              ; preds = %442
  %478 = add i64 %440, 4, !dbg !96
  br label %439, !dbg !96

479:                                              ; preds = %505, %439
  %480 = phi i64 [ %506, %505 ], [ 0, %439 ], !dbg !96
  %481 = icmp slt i64 %480, %418, !dbg !96
  br i1 %481, label %482, label %507, !dbg !96

482:                                              ; preds = %485, %479
  %483 = phi i64 [ %504, %485 ], [ 0, %479 ], !dbg !96
  %484 = icmp slt i64 %483, 8, !dbg !96
  br i1 %484, label %485, label %505, !dbg !96

485:                                              ; preds = %482
  %486 = add i64 %438, %480, !dbg !96
  %487 = mul nuw nsw i64 %486, 9, !dbg !96
  %488 = add nuw nsw i64 %487, 8, !dbg !96
  %489 = getelementptr inbounds nuw float, ptr %18, i64 %488, !dbg !96
  %490 = load float, ptr %489, align 4, !dbg !96
  %491 = add i64 %38, %483, !dbg !96
  %492 = add nuw nsw i64 512, %491, !dbg !96
  %493 = getelementptr inbounds nuw float, ptr %15, i64 %492, !dbg !96
  %494 = load float, ptr %493, align 4, !dbg !96
  %495 = add i64 %37, %406, !dbg !96
  %496 = add i64 %495, %411, !dbg !96
  %497 = add i64 %496, %480, !dbg !96
  %498 = mul nuw nsw i64 %497, 64, !dbg !96
  %499 = add nuw nsw i64 %498, %491, !dbg !96
  %500 = getelementptr inbounds nuw float, ptr %22, i64 %499, !dbg !96
  %501 = load float, ptr %500, align 4, !dbg !96
  %502 = fmul contract float %490, %494, !dbg !97
  %503 = fadd contract float %501, %502, !dbg !97
  store float %503, ptr %500, align 4, !dbg !96
  %504 = add i64 %483, 1, !dbg !96
  br label %482, !dbg !96

505:                                              ; preds = %482
  %506 = add i64 %480, 1, !dbg !96
  br label %479, !dbg !96

507:                                              ; preds = %479
  %508 = add i64 %411, 8, !dbg !96
  br label %410, !dbg !96

509:                                              ; preds = %410
  %510 = add i64 %406, 64, !dbg !96
  br label %405, !dbg !96

511:                                              ; preds = %405
  ret i32 0, !dbg !99
}

define internal i32 @infer_dispatch_1_matmul_Dx2x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !100 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !101
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !101
  %6 = load i32, ptr %5, align 4, !dbg !101
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !102
  %8 = load i32, ptr %7, align 4, !dbg !102
  %9 = zext i32 %6 to i64, !dbg !103
  %10 = zext i32 %8 to i64, !dbg !104
  %11 = shl i64 %10, 32, !dbg !105
  %12 = or i64 %9, %11, !dbg !106
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !107
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !107
  %15 = load ptr, ptr %14, align 8, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !107
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !108
  %18 = load ptr, ptr %17, align 8, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !108
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !109
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !109
  %22 = load ptr, ptr %21, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !109
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !110
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !110
  %25 = zext i32 %24 to i64, !dbg !110
  %26 = mul nsw i64 %25, 64, !dbg !110
  %27 = mul nsw i64 %25, -64, !dbg !110
  %28 = add i64 %27, %12, !dbg !110
  %29 = icmp slt i64 %28, 64, !dbg !110
  %30 = select i1 %29, i64 %28, i64 64, !dbg !110
  %31 = icmp slt i64 %30, 0, !dbg !110
  %32 = sub i64 -1, %30, !dbg !110
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !110
  %34 = sdiv i64 %33, 64, !dbg !110
  %35 = sub i64 -1, %34, !dbg !110
  %36 = select i1 %31, i64 %35, i64 %34, !dbg !110
  %37 = mul nsw i64 %36, 64, !dbg !110
  %38 = icmp sgt i64 %37, 0, !dbg !110
  br i1 %38, label %39, label %340, !dbg !110

39:                                               ; preds = %291, %3
  %40 = phi i64 [ %339, %291 ], [ 0, %3 ], !dbg !110
  %41 = icmp slt i64 %40, 64, !dbg !110
  br i1 %41, label %42, label %340, !dbg !110

42:                                               ; preds = %46, %39
  %43 = phi i64 [ %290, %46 ], [ 0, %39 ], !dbg !110
  %44 = phi [8 x <2 x float>] [ %289, %46 ], [ zeroinitializer, %39 ], !dbg !110
  %45 = icmp slt i64 %43, 64, !dbg !110
  br i1 %45, label %46, label %291, !dbg !110

46:                                               ; preds = %42
  %47 = mul i64 %43, 2, !dbg !110
  %48 = add i64 %47, 0, !dbg !110
  %49 = getelementptr float, ptr %15, i64 %48, !dbg !110
  %50 = load <2 x float>, ptr %49, align 4, !dbg !110
  %51 = add i64 %43, 1, !dbg !110
  %52 = mul i64 %51, 2, !dbg !110
  %53 = add i64 %52, 0, !dbg !110
  %54 = getelementptr float, ptr %15, i64 %53, !dbg !110
  %55 = load <2 x float>, ptr %54, align 4, !dbg !110
  %56 = add i64 %43, 2, !dbg !110
  %57 = mul i64 %56, 2, !dbg !110
  %58 = add i64 %57, 0, !dbg !110
  %59 = getelementptr float, ptr %15, i64 %58, !dbg !110
  %60 = load <2 x float>, ptr %59, align 4, !dbg !110
  %61 = add i64 %43, 3, !dbg !110
  %62 = mul i64 %61, 2, !dbg !110
  %63 = add i64 %62, 0, !dbg !110
  %64 = getelementptr float, ptr %15, i64 %63, !dbg !110
  %65 = load <2 x float>, ptr %64, align 4, !dbg !110
  %66 = add i64 %40, %26, !dbg !111
  %67 = mul nuw nsw i64 %66, 64, !dbg !111
  %68 = add nuw nsw i64 %67, %43, !dbg !111
  %69 = getelementptr inbounds nuw float, ptr %18, i64 %68, !dbg !111
  %70 = load float, ptr %69, align 4, !dbg !111
  %71 = insertelement <2 x float> poison, float %70, i32 0, !dbg !111
  %72 = shufflevector <2 x float> %71, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %73 = extractvalue [8 x <2 x float>] %44, 0, !dbg !111
  %74 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %72, <2 x float> %50, <2 x float> %73), !dbg !111
  %75 = add i64 %66, 1, !dbg !111
  %76 = mul nuw nsw i64 %75, 64, !dbg !111
  %77 = add nuw nsw i64 %76, %43, !dbg !111
  %78 = getelementptr inbounds nuw float, ptr %18, i64 %77, !dbg !111
  %79 = load float, ptr %78, align 4, !dbg !111
  %80 = insertelement <2 x float> poison, float %79, i32 0, !dbg !111
  %81 = shufflevector <2 x float> %80, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %82 = extractvalue [8 x <2 x float>] %44, 1, !dbg !111
  %83 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %81, <2 x float> %50, <2 x float> %82), !dbg !111
  %84 = add i64 %66, 2, !dbg !111
  %85 = mul nuw nsw i64 %84, 64, !dbg !111
  %86 = add nuw nsw i64 %85, %43, !dbg !111
  %87 = getelementptr inbounds nuw float, ptr %18, i64 %86, !dbg !111
  %88 = load float, ptr %87, align 4, !dbg !111
  %89 = insertelement <2 x float> poison, float %88, i32 0, !dbg !111
  %90 = shufflevector <2 x float> %89, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %91 = extractvalue [8 x <2 x float>] %44, 2, !dbg !111
  %92 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %90, <2 x float> %50, <2 x float> %91), !dbg !111
  %93 = add i64 %66, 3, !dbg !111
  %94 = mul nuw nsw i64 %93, 64, !dbg !111
  %95 = add nuw nsw i64 %94, %43, !dbg !111
  %96 = getelementptr inbounds nuw float, ptr %18, i64 %95, !dbg !111
  %97 = load float, ptr %96, align 4, !dbg !111
  %98 = insertelement <2 x float> poison, float %97, i32 0, !dbg !111
  %99 = shufflevector <2 x float> %98, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %100 = extractvalue [8 x <2 x float>] %44, 3, !dbg !111
  %101 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %99, <2 x float> %50, <2 x float> %100), !dbg !111
  %102 = add i64 %66, 4, !dbg !111
  %103 = mul nuw nsw i64 %102, 64, !dbg !111
  %104 = add nuw nsw i64 %103, %43, !dbg !111
  %105 = getelementptr inbounds nuw float, ptr %18, i64 %104, !dbg !111
  %106 = load float, ptr %105, align 4, !dbg !111
  %107 = insertelement <2 x float> poison, float %106, i32 0, !dbg !111
  %108 = shufflevector <2 x float> %107, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %109 = extractvalue [8 x <2 x float>] %44, 4, !dbg !111
  %110 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %108, <2 x float> %50, <2 x float> %109), !dbg !111
  %111 = add i64 %66, 5, !dbg !111
  %112 = mul nuw nsw i64 %111, 64, !dbg !111
  %113 = add nuw nsw i64 %112, %43, !dbg !111
  %114 = getelementptr inbounds nuw float, ptr %18, i64 %113, !dbg !111
  %115 = load float, ptr %114, align 4, !dbg !111
  %116 = insertelement <2 x float> poison, float %115, i32 0, !dbg !111
  %117 = shufflevector <2 x float> %116, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %118 = extractvalue [8 x <2 x float>] %44, 5, !dbg !111
  %119 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %117, <2 x float> %50, <2 x float> %118), !dbg !111
  %120 = add i64 %66, 6, !dbg !111
  %121 = mul nuw nsw i64 %120, 64, !dbg !111
  %122 = add nuw nsw i64 %121, %43, !dbg !111
  %123 = getelementptr inbounds nuw float, ptr %18, i64 %122, !dbg !111
  %124 = load float, ptr %123, align 4, !dbg !111
  %125 = insertelement <2 x float> poison, float %124, i32 0, !dbg !111
  %126 = shufflevector <2 x float> %125, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %127 = extractvalue [8 x <2 x float>] %44, 6, !dbg !111
  %128 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %126, <2 x float> %50, <2 x float> %127), !dbg !111
  %129 = add i64 %66, 7, !dbg !111
  %130 = mul nuw nsw i64 %129, 64, !dbg !111
  %131 = add nuw nsw i64 %130, %43, !dbg !111
  %132 = getelementptr inbounds nuw float, ptr %18, i64 %131, !dbg !111
  %133 = load float, ptr %132, align 4, !dbg !111
  %134 = insertelement <2 x float> poison, float %133, i32 0, !dbg !111
  %135 = shufflevector <2 x float> %134, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %136 = extractvalue [8 x <2 x float>] %44, 7, !dbg !111
  %137 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %135, <2 x float> %50, <2 x float> %136), !dbg !111
  %138 = add nuw nsw i64 %67, %51, !dbg !111
  %139 = getelementptr inbounds nuw float, ptr %18, i64 %138, !dbg !111
  %140 = load float, ptr %139, align 4, !dbg !111
  %141 = insertelement <2 x float> poison, float %140, i32 0, !dbg !111
  %142 = shufflevector <2 x float> %141, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %143 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %142, <2 x float> %55, <2 x float> %74), !dbg !111
  %144 = add nuw nsw i64 %76, %51, !dbg !111
  %145 = getelementptr inbounds nuw float, ptr %18, i64 %144, !dbg !111
  %146 = load float, ptr %145, align 4, !dbg !111
  %147 = insertelement <2 x float> poison, float %146, i32 0, !dbg !111
  %148 = shufflevector <2 x float> %147, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %149 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %148, <2 x float> %55, <2 x float> %83), !dbg !111
  %150 = add nuw nsw i64 %85, %51, !dbg !111
  %151 = getelementptr inbounds nuw float, ptr %18, i64 %150, !dbg !111
  %152 = load float, ptr %151, align 4, !dbg !111
  %153 = insertelement <2 x float> poison, float %152, i32 0, !dbg !111
  %154 = shufflevector <2 x float> %153, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %155 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %154, <2 x float> %55, <2 x float> %92), !dbg !111
  %156 = add nuw nsw i64 %94, %51, !dbg !111
  %157 = getelementptr inbounds nuw float, ptr %18, i64 %156, !dbg !111
  %158 = load float, ptr %157, align 4, !dbg !111
  %159 = insertelement <2 x float> poison, float %158, i32 0, !dbg !111
  %160 = shufflevector <2 x float> %159, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %161 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %160, <2 x float> %55, <2 x float> %101), !dbg !111
  %162 = add nuw nsw i64 %103, %51, !dbg !111
  %163 = getelementptr inbounds nuw float, ptr %18, i64 %162, !dbg !111
  %164 = load float, ptr %163, align 4, !dbg !111
  %165 = insertelement <2 x float> poison, float %164, i32 0, !dbg !111
  %166 = shufflevector <2 x float> %165, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %167 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %166, <2 x float> %55, <2 x float> %110), !dbg !111
  %168 = add nuw nsw i64 %112, %51, !dbg !111
  %169 = getelementptr inbounds nuw float, ptr %18, i64 %168, !dbg !111
  %170 = load float, ptr %169, align 4, !dbg !111
  %171 = insertelement <2 x float> poison, float %170, i32 0, !dbg !111
  %172 = shufflevector <2 x float> %171, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %173 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %172, <2 x float> %55, <2 x float> %119), !dbg !111
  %174 = add nuw nsw i64 %121, %51, !dbg !111
  %175 = getelementptr inbounds nuw float, ptr %18, i64 %174, !dbg !111
  %176 = load float, ptr %175, align 4, !dbg !111
  %177 = insertelement <2 x float> poison, float %176, i32 0, !dbg !111
  %178 = shufflevector <2 x float> %177, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %179 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %178, <2 x float> %55, <2 x float> %128), !dbg !111
  %180 = add nuw nsw i64 %130, %51, !dbg !111
  %181 = getelementptr inbounds nuw float, ptr %18, i64 %180, !dbg !111
  %182 = load float, ptr %181, align 4, !dbg !111
  %183 = insertelement <2 x float> poison, float %182, i32 0, !dbg !111
  %184 = shufflevector <2 x float> %183, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %185 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %184, <2 x float> %55, <2 x float> %137), !dbg !111
  %186 = add nuw nsw i64 %67, %56, !dbg !111
  %187 = getelementptr inbounds nuw float, ptr %18, i64 %186, !dbg !111
  %188 = load float, ptr %187, align 4, !dbg !111
  %189 = insertelement <2 x float> poison, float %188, i32 0, !dbg !111
  %190 = shufflevector <2 x float> %189, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %191 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %190, <2 x float> %60, <2 x float> %143), !dbg !111
  %192 = add nuw nsw i64 %76, %56, !dbg !111
  %193 = getelementptr inbounds nuw float, ptr %18, i64 %192, !dbg !111
  %194 = load float, ptr %193, align 4, !dbg !111
  %195 = insertelement <2 x float> poison, float %194, i32 0, !dbg !111
  %196 = shufflevector <2 x float> %195, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %197 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %196, <2 x float> %60, <2 x float> %149), !dbg !111
  %198 = add nuw nsw i64 %85, %56, !dbg !111
  %199 = getelementptr inbounds nuw float, ptr %18, i64 %198, !dbg !111
  %200 = load float, ptr %199, align 4, !dbg !111
  %201 = insertelement <2 x float> poison, float %200, i32 0, !dbg !111
  %202 = shufflevector <2 x float> %201, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %203 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %202, <2 x float> %60, <2 x float> %155), !dbg !111
  %204 = add nuw nsw i64 %94, %56, !dbg !111
  %205 = getelementptr inbounds nuw float, ptr %18, i64 %204, !dbg !111
  %206 = load float, ptr %205, align 4, !dbg !111
  %207 = insertelement <2 x float> poison, float %206, i32 0, !dbg !111
  %208 = shufflevector <2 x float> %207, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %209 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %208, <2 x float> %60, <2 x float> %161), !dbg !111
  %210 = add nuw nsw i64 %103, %56, !dbg !111
  %211 = getelementptr inbounds nuw float, ptr %18, i64 %210, !dbg !111
  %212 = load float, ptr %211, align 4, !dbg !111
  %213 = insertelement <2 x float> poison, float %212, i32 0, !dbg !111
  %214 = shufflevector <2 x float> %213, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %215 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %214, <2 x float> %60, <2 x float> %167), !dbg !111
  %216 = add nuw nsw i64 %112, %56, !dbg !111
  %217 = getelementptr inbounds nuw float, ptr %18, i64 %216, !dbg !111
  %218 = load float, ptr %217, align 4, !dbg !111
  %219 = insertelement <2 x float> poison, float %218, i32 0, !dbg !111
  %220 = shufflevector <2 x float> %219, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %221 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %220, <2 x float> %60, <2 x float> %173), !dbg !111
  %222 = add nuw nsw i64 %121, %56, !dbg !111
  %223 = getelementptr inbounds nuw float, ptr %18, i64 %222, !dbg !111
  %224 = load float, ptr %223, align 4, !dbg !111
  %225 = insertelement <2 x float> poison, float %224, i32 0, !dbg !111
  %226 = shufflevector <2 x float> %225, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %227 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %226, <2 x float> %60, <2 x float> %179), !dbg !111
  %228 = add nuw nsw i64 %130, %56, !dbg !111
  %229 = getelementptr inbounds nuw float, ptr %18, i64 %228, !dbg !111
  %230 = load float, ptr %229, align 4, !dbg !111
  %231 = insertelement <2 x float> poison, float %230, i32 0, !dbg !111
  %232 = shufflevector <2 x float> %231, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %233 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %232, <2 x float> %60, <2 x float> %185), !dbg !111
  %234 = add nuw nsw i64 %67, %61, !dbg !111
  %235 = getelementptr inbounds nuw float, ptr %18, i64 %234, !dbg !111
  %236 = load float, ptr %235, align 4, !dbg !111
  %237 = insertelement <2 x float> poison, float %236, i32 0, !dbg !111
  %238 = shufflevector <2 x float> %237, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %239 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %238, <2 x float> %65, <2 x float> %191), !dbg !111
  %240 = add nuw nsw i64 %76, %61, !dbg !111
  %241 = getelementptr inbounds nuw float, ptr %18, i64 %240, !dbg !111
  %242 = load float, ptr %241, align 4, !dbg !111
  %243 = insertelement <2 x float> poison, float %242, i32 0, !dbg !111
  %244 = shufflevector <2 x float> %243, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %245 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %244, <2 x float> %65, <2 x float> %197), !dbg !111
  %246 = add nuw nsw i64 %85, %61, !dbg !111
  %247 = getelementptr inbounds nuw float, ptr %18, i64 %246, !dbg !111
  %248 = load float, ptr %247, align 4, !dbg !111
  %249 = insertelement <2 x float> poison, float %248, i32 0, !dbg !111
  %250 = shufflevector <2 x float> %249, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %251 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %250, <2 x float> %65, <2 x float> %203), !dbg !111
  %252 = add nuw nsw i64 %94, %61, !dbg !111
  %253 = getelementptr inbounds nuw float, ptr %18, i64 %252, !dbg !111
  %254 = load float, ptr %253, align 4, !dbg !111
  %255 = insertelement <2 x float> poison, float %254, i32 0, !dbg !111
  %256 = shufflevector <2 x float> %255, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %257 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %256, <2 x float> %65, <2 x float> %209), !dbg !111
  %258 = add nuw nsw i64 %103, %61, !dbg !111
  %259 = getelementptr inbounds nuw float, ptr %18, i64 %258, !dbg !111
  %260 = load float, ptr %259, align 4, !dbg !111
  %261 = insertelement <2 x float> poison, float %260, i32 0, !dbg !111
  %262 = shufflevector <2 x float> %261, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %263 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %262, <2 x float> %65, <2 x float> %215), !dbg !111
  %264 = add nuw nsw i64 %112, %61, !dbg !111
  %265 = getelementptr inbounds nuw float, ptr %18, i64 %264, !dbg !111
  %266 = load float, ptr %265, align 4, !dbg !111
  %267 = insertelement <2 x float> poison, float %266, i32 0, !dbg !111
  %268 = shufflevector <2 x float> %267, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %269 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %268, <2 x float> %65, <2 x float> %221), !dbg !111
  %270 = add nuw nsw i64 %121, %61, !dbg !111
  %271 = getelementptr inbounds nuw float, ptr %18, i64 %270, !dbg !111
  %272 = load float, ptr %271, align 4, !dbg !111
  %273 = insertelement <2 x float> poison, float %272, i32 0, !dbg !111
  %274 = shufflevector <2 x float> %273, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %275 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %274, <2 x float> %65, <2 x float> %227), !dbg !111
  %276 = add nuw nsw i64 %130, %61, !dbg !111
  %277 = getelementptr inbounds nuw float, ptr %18, i64 %276, !dbg !111
  %278 = load float, ptr %277, align 4, !dbg !111
  %279 = insertelement <2 x float> poison, float %278, i32 0, !dbg !111
  %280 = shufflevector <2 x float> %279, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %281 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %280, <2 x float> %65, <2 x float> %233), !dbg !111
  %282 = insertvalue [8 x <2 x float>] poison, <2 x float> %239, 0, !dbg !111
  %283 = insertvalue [8 x <2 x float>] %282, <2 x float> %245, 1, !dbg !111
  %284 = insertvalue [8 x <2 x float>] %283, <2 x float> %251, 2, !dbg !111
  %285 = insertvalue [8 x <2 x float>] %284, <2 x float> %257, 3, !dbg !111
  %286 = insertvalue [8 x <2 x float>] %285, <2 x float> %263, 4, !dbg !111
  %287 = insertvalue [8 x <2 x float>] %286, <2 x float> %269, 5, !dbg !111
  %288 = insertvalue [8 x <2 x float>] %287, <2 x float> %275, 6, !dbg !111
  %289 = insertvalue [8 x <2 x float>] %288, <2 x float> %281, 7, !dbg !111
  %290 = add i64 %43, 4, !dbg !110
  br label %42, !dbg !110

291:                                              ; preds = %42
  %292 = extractvalue [8 x <2 x float>] %44, 0, !dbg !110
  %293 = add i64 %26, %40, !dbg !110
  %294 = mul i64 %293, 2, !dbg !110
  %295 = add i64 %294, 0, !dbg !110
  %296 = getelementptr float, ptr %22, i64 %295, !dbg !110
  store <2 x float> %292, ptr %296, align 4, !dbg !110
  %297 = add i64 %40, 1, !dbg !110
  %298 = extractvalue [8 x <2 x float>] %44, 1, !dbg !110
  %299 = add i64 %26, %297, !dbg !110
  %300 = mul i64 %299, 2, !dbg !110
  %301 = add i64 %300, 0, !dbg !110
  %302 = getelementptr float, ptr %22, i64 %301, !dbg !110
  store <2 x float> %298, ptr %302, align 4, !dbg !110
  %303 = add i64 %40, 2, !dbg !110
  %304 = extractvalue [8 x <2 x float>] %44, 2, !dbg !110
  %305 = add i64 %26, %303, !dbg !110
  %306 = mul i64 %305, 2, !dbg !110
  %307 = add i64 %306, 0, !dbg !110
  %308 = getelementptr float, ptr %22, i64 %307, !dbg !110
  store <2 x float> %304, ptr %308, align 4, !dbg !110
  %309 = add i64 %40, 3, !dbg !110
  %310 = extractvalue [8 x <2 x float>] %44, 3, !dbg !110
  %311 = add i64 %26, %309, !dbg !110
  %312 = mul i64 %311, 2, !dbg !110
  %313 = add i64 %312, 0, !dbg !110
  %314 = getelementptr float, ptr %22, i64 %313, !dbg !110
  store <2 x float> %310, ptr %314, align 4, !dbg !110
  %315 = add i64 %40, 4, !dbg !110
  %316 = extractvalue [8 x <2 x float>] %44, 4, !dbg !110
  %317 = add i64 %26, %315, !dbg !110
  %318 = mul i64 %317, 2, !dbg !110
  %319 = add i64 %318, 0, !dbg !110
  %320 = getelementptr float, ptr %22, i64 %319, !dbg !110
  store <2 x float> %316, ptr %320, align 4, !dbg !110
  %321 = add i64 %40, 5, !dbg !110
  %322 = extractvalue [8 x <2 x float>] %44, 5, !dbg !110
  %323 = add i64 %26, %321, !dbg !110
  %324 = mul i64 %323, 2, !dbg !110
  %325 = add i64 %324, 0, !dbg !110
  %326 = getelementptr float, ptr %22, i64 %325, !dbg !110
  store <2 x float> %322, ptr %326, align 4, !dbg !110
  %327 = add i64 %40, 6, !dbg !110
  %328 = extractvalue [8 x <2 x float>] %44, 6, !dbg !110
  %329 = add i64 %26, %327, !dbg !110
  %330 = mul i64 %329, 2, !dbg !110
  %331 = add i64 %330, 0, !dbg !110
  %332 = getelementptr float, ptr %22, i64 %331, !dbg !110
  store <2 x float> %328, ptr %332, align 4, !dbg !110
  %333 = add i64 %40, 7, !dbg !110
  %334 = extractvalue [8 x <2 x float>] %44, 7, !dbg !110
  %335 = add i64 %26, %333, !dbg !110
  %336 = mul i64 %335, 2, !dbg !110
  %337 = add i64 %336, 0, !dbg !110
  %338 = getelementptr float, ptr %22, i64 %337, !dbg !110
  store <2 x float> %334, ptr %338, align 4, !dbg !110
  %339 = add i64 %40, 8, !dbg !110
  br label %39, !dbg !110

340:                                              ; preds = %414, %39, %3
  %341 = phi i64 [ %415, %414 ], [ %37, %39 ], [ %37, %3 ], !dbg !110
  %342 = icmp slt i64 %341, %30, !dbg !110
  br i1 %342, label %343, label %416, !dbg !110

343:                                              ; preds = %340
  %344 = sub i64 %30, %341, !dbg !110
  br label %345, !dbg !110

345:                                              ; preds = %412, %343
  %346 = phi i64 [ %413, %412 ], [ 0, %343 ], !dbg !110
  %347 = icmp slt i64 %346, %344, !dbg !110
  br i1 %347, label %348, label %414, !dbg !110

348:                                              ; preds = %345
  %349 = mul nsw i64 %346, -1, !dbg !110
  %350 = sub i64 %349, %341, !dbg !110
  %351 = add i64 %350, %30, !dbg !110
  %352 = icmp slt i64 %351, 8, !dbg !110
  %353 = select i1 %352, i64 %351, i64 8, !dbg !110
  br label %354, !dbg !112

354:                                              ; preds = %368, %348
  %355 = phi i64 [ %369, %368 ], [ 0, %348 ], !dbg !112
  %356 = icmp slt i64 %355, %353, !dbg !112
  br i1 %356, label %357, label %370, !dbg !112

357:                                              ; preds = %360, %354
  %358 = phi i64 [ %367, %360 ], [ 0, %354 ], !dbg !112
  %359 = icmp slt i64 %358, 2, !dbg !112
  br i1 %359, label %360, label %368, !dbg !112

360:                                              ; preds = %357
  %361 = add i64 %26, %341, !dbg !112
  %362 = add i64 %361, %346, !dbg !112
  %363 = add i64 %362, %355, !dbg !112
  %364 = mul nuw nsw i64 %363, 2, !dbg !112
  %365 = add nuw nsw i64 %364, %358, !dbg !112
  %366 = getelementptr inbounds nuw float, ptr %22, i64 %365, !dbg !112
  store float 0.000000e+00, ptr %366, align 4, !dbg !112
  %367 = add i64 %358, 1, !dbg !112
  br label %357, !dbg !112

368:                                              ; preds = %357
  %369 = add i64 %355, 1, !dbg !112
  br label %354, !dbg !112

370:                                              ; preds = %354
  %371 = add i64 %346, %341, !dbg !110
  %372 = add i64 %371, %26, !dbg !110
  br label %373, !dbg !110

373:                                              ; preds = %410, %370
  %374 = phi i64 [ %411, %410 ], [ 0, %370 ], !dbg !110
  %375 = icmp slt i64 %374, 64, !dbg !110
  br i1 %375, label %376, label %412, !dbg !110

376:                                              ; preds = %408, %373
  %377 = phi i64 [ %409, %408 ], [ 0, %373 ], !dbg !110
  %378 = icmp slt i64 %377, %353, !dbg !110
  br i1 %378, label %379, label %410, !dbg !110

379:                                              ; preds = %406, %376
  %380 = phi i64 [ %407, %406 ], [ 0, %376 ], !dbg !110
  %381 = icmp slt i64 %380, 2, !dbg !110
  br i1 %381, label %382, label %408, !dbg !110

382:                                              ; preds = %385, %379
  %383 = phi i64 [ %405, %385 ], [ 0, %379 ], !dbg !110
  %384 = icmp slt i64 %383, 4, !dbg !110
  br i1 %384, label %385, label %406, !dbg !110

385:                                              ; preds = %382
  %386 = add i64 %372, %377, !dbg !110
  %387 = add i64 %374, %383, !dbg !110
  %388 = mul nuw nsw i64 %386, 64, !dbg !110
  %389 = add nuw nsw i64 %388, %387, !dbg !110
  %390 = getelementptr inbounds nuw float, ptr %18, i64 %389, !dbg !110
  %391 = load float, ptr %390, align 4, !dbg !110
  %392 = mul nuw nsw i64 %387, 2, !dbg !110
  %393 = add nuw nsw i64 %392, %380, !dbg !110
  %394 = getelementptr inbounds nuw float, ptr %15, i64 %393, !dbg !110
  %395 = load float, ptr %394, align 4, !dbg !110
  %396 = add i64 %26, %341, !dbg !110
  %397 = add i64 %396, %346, !dbg !110
  %398 = add i64 %397, %377, !dbg !110
  %399 = mul nuw nsw i64 %398, 2, !dbg !110
  %400 = add nuw nsw i64 %399, %380, !dbg !110
  %401 = getelementptr inbounds nuw float, ptr %22, i64 %400, !dbg !110
  %402 = load float, ptr %401, align 4, !dbg !110
  %403 = fmul contract float %391, %395, !dbg !111
  %404 = fadd contract float %402, %403, !dbg !111
  store float %404, ptr %401, align 4, !dbg !110
  %405 = add i64 %383, 1, !dbg !110
  br label %382, !dbg !110

406:                                              ; preds = %382
  %407 = add i64 %380, 1, !dbg !110
  br label %379, !dbg !110

408:                                              ; preds = %379
  %409 = add i64 %377, 1, !dbg !110
  br label %376, !dbg !110

410:                                              ; preds = %376
  %411 = add i64 %374, 4, !dbg !110
  br label %373, !dbg !110

412:                                              ; preds = %373
  %413 = add i64 %346, 8, !dbg !110
  br label %345, !dbg !110

414:                                              ; preds = %345
  %415 = add i64 %341, 64, !dbg !110
  br label %340, !dbg !110

416:                                              ; preds = %340
  ret i32 0, !dbg !113
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fmuladd.v2f32(<2 x float>, <2 x float>, <2 x float>) #2

; Function Attrs: uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr %1) #3 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden float @iree_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
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
define hidden signext i16 @iree_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
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
  %26 = add nsw i32 %25, 15360
  %27 = lshr i32 %21, 13
  %28 = select i1 %22, i32 0, i32 %27
  %29 = add nuw nsw i32 %26, %28
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
define hidden float @__gnu_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
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
define hidden float @__extendhfsf2(float noundef %0) local_unnamed_addr #4 {
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
define hidden signext i16 @__gnu_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
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
define hidden float @__truncsfhf2(float noundef %0) local_unnamed_addr #4 {
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
  %30 = add nsw i32 %29, %26
  br label %31

31:                                               ; preds = %18, %16, %13, %8, %1
  %32 = phi i32 [ 31744, %8 ], [ %4, %1 ], [ %30, %18 ], [ 31744, %13 ], [ 0, %16 ]
  %33 = or i32 %32, %7
  %34 = trunc i32 %33 to i16
  br label %35

35:                                               ; preds = %10, %31
  %36 = phi i16 [ %12, %10 ], [ %34, %31 ]
  store i16 %36, ptr %2, align 4, !tbaa !114
  %37 = load float, ptr %2, align 4, !tbaa !116
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %37
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden double @__extendhfdf2(float noundef %0) local_unnamed_addr #4 {
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
define hidden float @__truncdfhf2(double noundef %0) local_unnamed_addr #4 {
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
  store i16 %37, ptr %2, align 4, !tbaa !114
  %38 = load float, ptr %2, align 4, !tbaa !116
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %38
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden noundef double @fma(double noundef %0, double noundef %1, double noundef %2) local_unnamed_addr #4 {
  %4 = tail call double @llvm.fmuladd.f64(double %0, double %1, double %2)
  ret double %4
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: inlinehint
define hidden noundef float @__math_invalidf(float noundef %0) local_unnamed_addr #7 {
  %2 = fsub float %0, %0
  %3 = fdiv float %2, %2
  ret float %3
}

; Function Attrs: inlinehint
define hidden float @__math_oflowf(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call float @__math_xflowf(i32 noundef %0, float noundef 0x4600000000000000) #7
  ret float %2
}

; Function Attrs: inlinehint
define hidden float @__math_xflowf(i32 noundef %0, float noundef %1) local_unnamed_addr #7 {
  %3 = alloca float, align 4
  %.not = icmp eq i32 %0, 0
  %4 = fneg float %1
  %5 = select i1 %.not, float %1, float %4
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %5, ptr %3, align 4, !tbaa !116
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !116
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %6 = fmul float %1, %.0..0..0..0..0..0..i
  ret float %6
}

; Function Attrs: inlinehint
define hidden float @__math_uflowf(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call float @__math_xflowf(i32 noundef %0, float noundef 0x3A00000000000000) #7
  ret float %2
}

; Function Attrs: inlinehint
define hidden float @ceilf(float noundef %0) local_unnamed_addr #7 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !116
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
  store volatile float %24, ptr %2, align 4, !tbaa !116
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

; Function Attrs: inlinehint
define hidden float @expf(float noundef %0) local_unnamed_addr #7 {
  %2 = fpext float %0 to double
  %3 = bitcast float %0 to i32
  %4 = lshr i32 %3, 20
  %5 = and i32 %4, 2047
  %.not = icmp samesign ult i32 %5, 1067
  br i1 %.not, label %19, label %6, !prof !118

6:                                                ; preds = %1
  %7 = fcmp oeq float %0, 0xFFF0000000000000
  br i1 %7, label %42, label %8

8:                                                ; preds = %6
  %.not34 = icmp samesign ult i32 %5, 2040
  br i1 %.not34, label %11, label %9

9:                                                ; preds = %8
  %10 = fadd float %0, %0
  br label %42

11:                                               ; preds = %8
  %12 = fcmp ogt float %0, 0x40562E42E0000000
  br i1 %12, label %13, label %15

13:                                               ; preds = %11
  %14 = tail call float @__math_oflowf(i32 noundef 0) #7
  br label %42

15:                                               ; preds = %11
  %16 = fcmp olt float %0, 0xC059FE3680000000
  br i1 %16, label %17, label %19

17:                                               ; preds = %15
  %18 = tail call float @__math_uflowf(i32 noundef 0) #7
  br label %42

19:                                               ; preds = %15, %1
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !119
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !122
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !123
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !125
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !125
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !125
  %38 = tail call double @llvm.fmuladd.f64(double %37, double %26, double 1.000000e+00)
  %39 = tail call double @llvm.fmuladd.f64(double %35, double %36, double %38)
  %40 = fmul double %39, %32
  %41 = fptrunc double %40 to float
  br label %42

42:                                               ; preds = %19, %17, %13, %9, %6
  %.0 = phi float [ %10, %9 ], [ %14, %13 ], [ %18, %17 ], [ %41, %19 ], [ 0.000000e+00, %6 ]
  ret float %.0
}

; Function Attrs: inlinehint
define hidden noundef i32 @feclearexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @feraiseexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fetestexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fegetround() local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @__fesetround(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fegetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fesetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden float @floorf(float noundef %0) local_unnamed_addr #7 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !116
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
  store volatile float %23, ptr %2, align 4, !tbaa !116
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

; Function Attrs: inlinehint
define hidden float @fmaf(float noundef %0, float noundef %1, float noundef %2) local_unnamed_addr #7 {
  %4 = alloca float, align 4
  %5 = fpext float %0 to double
  %6 = fpext float %1 to double
  %7 = fmul double %5, %6
  %8 = fpext float %2 to double
  %9 = fadd double %7, %8
  %10 = bitcast double %9 to i64
  %11 = lshr i64 %10, 52
  %12 = trunc nuw nsw i64 %11 to i32
  %13 = and i32 %12, 2047
  %14 = and i64 %10, 536870911
  %15 = icmp ne i64 %14, 268435456
  %16 = icmp eq i32 %13, 2047
  %or.cond = select i1 %15, i1 true, i1 %16
  br i1 %or.cond, label %24, label %17

17:                                               ; preds = %3
  %18 = fsub double %9, %7
  %19 = fcmp oeq double %18, %8
  %20 = fsub double %9, %8
  %21 = fcmp oeq double %20, %7
  %or.cond44 = and i1 %19, %21
  br i1 %or.cond44, label %24, label %22

22:                                               ; preds = %17
  %23 = tail call i32 @fegetround() #7
  %.not = icmp eq i32 %23, 0
  br i1 %.not, label %34, label %24

24:                                               ; preds = %22, %17, %3
  %25 = add nsw i32 %13, -874
  %or.cond3 = icmp ult i32 %25, 23
  br i1 %or.cond3, label %26, label %46

26:                                               ; preds = %24
  %27 = tail call i32 @fetestexcept(i32 noundef 32) #7
  %.not41 = icmp eq i32 %27, 0
  br i1 %.not41, label %46, label %28

28:                                               ; preds = %26
  %29 = tail call i32 @feclearexcept(i32 noundef 32) #7
  call void @llvm.lifetime.start.p0(ptr nonnull %4)
  store volatile float %2, ptr %4, align 4, !tbaa !116
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !116
  %30 = fpext float %.0..0..0..0.5 to double
  %31 = fadd double %7, %30
  %32 = tail call i32 @fetestexcept(i32 noundef 32) #7
  %.not42 = icmp eq i32 %32, 0
  %. = select i1 %.not42, i32 32, i32 16
  %33 = tail call i32 @feraiseexcept(i32 noundef %.) #7
  call void @llvm.lifetime.end.p0(ptr nonnull %4)
  br label %46

34:                                               ; preds = %22
  %35 = icmp slt i64 %10, 0
  %36 = fcmp uge double %7, %8
  %37 = xor i1 %36, %35
  %38 = fsub double %7, %9
  %39 = fadd double %38, %8
  %40 = fsub double %8, %9
  %41 = fadd double %7, %40
  %.038 = select i1 %37, double %39, double %41
  %42 = fcmp uge double %.038, 0.000000e+00
  %43 = xor i1 %35, %42
  %44 = or disjoint i64 %10, 1
  %45 = add nsw i64 %10, -1
  %.sroa.0.0.in = select i1 %43, i64 %44, i64 %45
  %.sroa.0.0 = bitcast i64 %.sroa.0.0.in to double
  br label %46

46:                                               ; preds = %34, %28, %26, %24
  %.0.in = phi double [ %.sroa.0.0, %34 ], [ %31, %28 ], [ %9, %26 ], [ %9, %24 ]
  %.0 = fptrunc double %.0.in to float
  ret float %.0
}

; Function Attrs: inlinehint
define hidden float @fmodf(float noundef %0, float noundef %1) local_unnamed_addr #7 {
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

.lr.ph:                                           ; preds = %.lr.ph, %26
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

.lr.ph90:                                         ; preds = %.lr.ph90, %38
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

.lr.ph96:                                         ; preds = %57, %49
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

.lr.ph103:                                        ; preds = %.lr.ph103, %67
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

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fabs.f32(float) #6

; Function Attrs: inlinehint
define hidden float @frexpf(float noundef %0, ptr noundef captures(none) %1) local_unnamed_addr #7 {
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
  %9 = tail call float @frexpf(float noundef %8, ptr noundef %1) #7
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

; Function Attrs: inlinehint
define hidden float @ldexpf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = tail call float @scalbnf(float noundef %0, i32 noundef %1) #7
  ret float %3
}

; Function Attrs: inlinehint
define hidden float @scalbnf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
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

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #6

; Function Attrs: inlinehint
define hidden float @powf(float noundef %0, float noundef %1) local_unnamed_addr #7 {
  %3 = alloca float, align 4
  %4 = bitcast float %0 to i32
  %5 = bitcast float %1 to i32
  %6 = add i32 %4, -2139095040
  %7 = icmp ult i32 %6, -2130706432
  %.pre = shl i32 %5, 1
  %8 = add i32 %.pre, 16777216
  %9 = icmp ult i32 %8, 16777217
  %or.cond99 = or i1 %7, %9
  br i1 %or.cond99, label %.critedge, label %73, !prof !126

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !118

12:                                               ; preds = %.critedge
  %13 = icmp eq i32 %.pre, 0
  %14 = icmp eq i32 %4, 1065353216
  %or.cond70 = or i1 %14, %13
  br i1 %or.cond70, label %138, label %15

15:                                               ; preds = %12
  %16 = shl i32 %4, 1
  %17 = icmp ugt i32 %16, -16777216
  %18 = icmp samesign ugt i32 %.pre, -16777216
  %or.cond = or i1 %17, %18
  br i1 %or.cond, label %19, label %21

19:                                               ; preds = %15
  %20 = fadd float %0, %1
  br label %138

21:                                               ; preds = %15
  %22 = icmp eq i32 %16, 2130706432
  br i1 %22, label %138, label %23

23:                                               ; preds = %21
  %24 = icmp ult i32 %16, 2130706432
  %25 = icmp slt i32 %5, 0
  %26 = xor i1 %24, %25
  %27 = fmul float %1, %1
  %spec.select71 = select i1 %26, float 0.000000e+00, float %27
  br label %138

28:                                               ; preds = %.critedge
  %29 = shl i32 %4, 1
  %30 = add i32 %29, -1
  %31 = icmp ult i32 %30, -16777217
  br i1 %31, label %47, label %32, !prof !118

32:                                               ; preds = %28
  %33 = fmul float %0, %0
  %.not66 = icmp sgt i32 %4, -1
  br i1 %.not66, label %checkint.exit.thread, label %34

34:                                               ; preds = %32
  %35 = lshr i32 %5, 23
  %36 = and i32 %35, 255
  %37 = add nsw i32 %36, -151
  %or.cond92 = icmp ult i32 %37, -24
  br i1 %or.cond92, label %checkint.exit.thread, label %38

38:                                               ; preds = %34
  %39 = sub nuw nsw i32 150, %36
  %40 = shl nuw nsw i32 1, %39
  %41 = add nsw i32 %40, -1
  %42 = and i32 %41, %5
  %.not.i = icmp ne i32 %42, 0
  %43 = and i32 %40, %5
  %.not9.i = icmp eq i32 %43, 0
  %or.cond93 = or i1 %.not9.i, %.not.i
  %44 = fneg float %33
  %spec.select = select i1 %or.cond93, float %33, float %44
  br label %checkint.exit.thread

checkint.exit.thread:                             ; preds = %38, %34, %32
  %.057 = phi float [ %33, %32 ], [ %33, %34 ], [ %spec.select, %38 ]
  %.not67 = icmp sgt i32 %5, -1
  br i1 %.not67, label %138, label %45

45:                                               ; preds = %checkint.exit.thread
  %46 = fdiv float 1.000000e+00, %.057
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %46, ptr %3, align 4, !tbaa !116
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !116
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  br label %138

47:                                               ; preds = %28
  %.not64 = icmp sgt i32 %4, -1
  br i1 %.not64, label %66, label %48

48:                                               ; preds = %47
  %49 = lshr i32 %5, 23
  %50 = and i32 %49, 255
  %51 = icmp samesign ult i32 %50, 127
  br i1 %51, label %.thread, label %52

52:                                               ; preds = %48
  %53 = icmp samesign ugt i32 %50, 150
  br i1 %53, label %checkint.exit76.thread85, label %54

54:                                               ; preds = %52
  %55 = sub nuw nsw i32 150, %50
  %56 = shl nuw nsw i32 1, %55
  %57 = add nsw i32 %56, -1
  %58 = and i32 %57, %5
  %.not.i72 = icmp eq i32 %58, 0
  br i1 %.not.i72, label %59, label %.thread

59:                                               ; preds = %54
  %60 = and i32 %56, %5
  %.not9.i74 = icmp eq i32 %60, 0
  br i1 %.not9.i74, label %checkint.exit76.thread85, label %62

.thread:                                          ; preds = %54, %48
  %61 = tail call float @__math_invalidf(float noundef %0) #7
  br label %138

checkint.exit76.thread85:                         ; preds = %59, %52
  br label %62

62:                                               ; preds = %checkint.exit76.thread85, %59
  %63 = phi i32 [ 0, %checkint.exit76.thread85 ], [ 65536, %59 ]
  %64 = tail call float @llvm.fabs.f32(float %0)
  %65 = bitcast float %64 to i32
  br label %66

66:                                               ; preds = %62, %47
  %.154 = phi i32 [ %65, %62 ], [ %4, %47 ]
  %.151 = phi i32 [ %63, %62 ], [ 0, %47 ]
  %67 = icmp ult i32 %.154, 8388608
  br i1 %67, label %68, label %73

68:                                               ; preds = %66
  %69 = fmul float %0, 0x4160000000000000
  %70 = tail call float @llvm.fabs.f32(float %69)
  %71 = bitcast float %70 to i32
  %72 = add nsw i32 %71, -192937984
  br label %73

73:                                               ; preds = %68, %66, %2
  %.053 = phi i32 [ %72, %68 ], [ %.154, %66 ], [ %4, %2 ]
  %.050 = phi i32 [ %.151, %68 ], [ %.151, %66 ], [ 0, %2 ]
  %74 = add i32 %.053, -1060306944
  %75 = lshr i32 %74, 19
  %76 = and i32 %75, 15
  %77 = and i32 %74, -8388608
  %78 = sub i32 %.053, %77
  %79 = ashr i32 %74, 23
  %80 = zext nneg i32 %76 to i64
  %81 = getelementptr inbounds nuw %struct.anon, ptr @__powf_log2_data, i64 %80
  %82 = load double, ptr %81, align 8, !tbaa !127
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !129
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !125
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !125
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !125
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !125
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !125
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !130

107:                                              ; preds = %73
  %108 = fcmp ogt double %103, 0x405FFFFFFFD1D571
  br i1 %108, label %109, label %111

109:                                              ; preds = %107
  %110 = tail call float @__math_oflowf(i32 noundef %.050) #7
  br label %138

111:                                              ; preds = %107
  %112 = fcmp ugt double %103, -1.500000e+02
  br i1 %112, label %115, label %113

113:                                              ; preds = %111
  %114 = tail call float @__math_uflowf(i32 noundef %.050) #7
  br label %138

115:                                              ; preds = %111, %73
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !131
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !123
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !125
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !125
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !125
  %134 = tail call double @llvm.fmuladd.f64(double %133, double %120, double 1.000000e+00)
  %135 = tail call double @llvm.fmuladd.f64(double %131, double %132, double %134)
  %136 = fmul double %135, %128
  %137 = fptrunc double %136 to float
  br label %138

138:                                              ; preds = %115, %113, %109, %.thread, %45, %checkint.exit.thread, %23, %21, %19, %12
  %.0 = phi float [ %20, %19 ], [ 1.000000e+00, %12 ], [ 1.000000e+00, %21 ], [ %.0..0..0..0..0..0..i, %45 ], [ %.057, %checkint.exit.thread ], [ %110, %109 ], [ %114, %113 ], [ %137, %115 ], [ %spec.select71, %23 ], [ %61, %.thread ]
  ret float %.0
}

; Function Attrs: inlinehint
define hidden noundef float @rintf(float noundef %0) local_unnamed_addr #7 {
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

; Function Attrs: inlinehint
define hidden float @roundf(float noundef %0) local_unnamed_addr #7 {
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
  store volatile float %9, ptr %2, align 4, !tbaa !116
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

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { uwtable "nonlazybind" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { inlinehint }

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
!88 = !DILocation(line: 13, column: 8, scope: !11)
!89 = !DILocation(line: 14, column: 8, scope: !11)
!90 = !DILocation(line: 15, column: 8, scope: !11)
!91 = !DILocation(line: 16, column: 8, scope: !11)
!92 = !DILocation(line: 17, column: 8, scope: !11)
!93 = !DILocation(line: 20, column: 8, scope: !11)
!94 = !DILocation(line: 22, column: 8, scope: !11)
!95 = !DILocation(line: 23, column: 8, scope: !11)
!96 = !DILocation(line: 28, column: 8, scope: !11)
!97 = !DILocation(line: 1, column: 1, scope: !11)
!98 = !DILocation(line: 27, column: 8, scope: !11)
!99 = !DILocation(line: 30, column: 8, scope: !11)
!100 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_Dx2x64_f32", linkageName: "infer_dispatch_1_matmul_Dx2x64_f32", scope: !3, file: !3, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!101 = !DILocation(line: 12, column: 8, scope: !100)
!102 = !DILocation(line: 13, column: 8, scope: !100)
!103 = !DILocation(line: 14, column: 8, scope: !100)
!104 = !DILocation(line: 15, column: 8, scope: !100)
!105 = !DILocation(line: 16, column: 8, scope: !100)
!106 = !DILocation(line: 17, column: 8, scope: !100)
!107 = !DILocation(line: 20, column: 8, scope: !100)
!108 = !DILocation(line: 22, column: 8, scope: !100)
!109 = !DILocation(line: 23, column: 8, scope: !100)
!110 = !DILocation(line: 28, column: 8, scope: !100)
!111 = !DILocation(line: 1, column: 1, scope: !100)
!112 = !DILocation(line: 27, column: 8, scope: !100)
!113 = !DILocation(line: 30, column: 8, scope: !100)
!114 = !{!115, !115, i64 0}
!115 = !{!"short", !9, i64 0}
!116 = !{!117, !117, i64 0}
!117 = !{!"float", !9, i64 0}
!118 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!119 = !{!120, !121, i64 296}
!120 = !{!"exp2f_data", !9, i64 0, !121, i64 256, !9, i64 264, !121, i64 288, !121, i64 296, !9, i64 304}
!121 = !{!"double", !9, i64 0}
!122 = !{!120, !121, i64 288}
!123 = !{!124, !124, i64 0}
!124 = !{!"long", !9, i64 0}
!125 = !{!121, !121, i64 0}
!126 = !{!"branch_weights", i32 4001, i32 4000000}
!127 = !{!128, !121, i64 0}
!128 = !{!"", !121, i64 0, !121, i64 8}
!129 = !{!128, !121, i64 8}
!130 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!131 = !{!120, !121, i64 256}
