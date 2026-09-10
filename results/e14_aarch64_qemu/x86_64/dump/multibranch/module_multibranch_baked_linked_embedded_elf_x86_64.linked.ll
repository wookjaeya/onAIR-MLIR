; ModuleID = 'multibranch_baked_linked'
source_filename = "multibranch_baked_linked"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-unknown-eabi-elf"

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

@0 = private constant [25 x i8] c"multibranch_baked_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [4 x ptr] [ptr @infer_dispatch_0_matmul_1x64x16_f32, ptr @infer_dispatch_1_matmul_1x64x64_f32, ptr @infer_dispatch_2_matmul_1x64x64_f32, ptr @infer_dispatch_3_matmul_1x2x64_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [4 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [36 x i8] c"infer_dispatch_0_matmul_1x64x16_f32\00", align 1
@2 = private constant [36 x i8] c"infer_dispatch_1_matmul_1x64x64_f32\00", align 1
@3 = private constant [36 x i8] c"infer_dispatch_2_matmul_1x64x64_f32\00", align 1
@4 = private constant [35 x i8] c"infer_dispatch_3_matmul_1x2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [4 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4]
@5 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/multibranch/configured_module_infer_dispatch_0.mlir\00", align 1
@6 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/multibranch/configured_module_infer_dispatch_1.mlir\00", align 1
@7 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/multibranch/configured_module_infer_dispatch_2.mlir\00", align 1
@8 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/multibranch/configured_module_infer_dispatch_3.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [4 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @6 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @7 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @8 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [4 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x64x16_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x64x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x64x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_1x2x64_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 4, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_matmul_1x64x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !15 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !91
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !91
  %6 = load ptr, ptr %5, align 8, !dbg !91
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !91
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !92
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !92
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !92
  %10 = load ptr, ptr %9, align 8, !dbg !92
  %11 = getelementptr float, ptr %10, i64 8320, !dbg !92
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !92
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !93
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !93
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !93
  %15 = load ptr, ptr %14, align 8, !dbg !93
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !93
  br label %16, !dbg !94

16:                                               ; preds = %19, %3
  %17 = phi i64 [ %152, %19 ], [ 0, %3 ], !dbg !94
  %18 = icmp slt i64 %17, 64, !dbg !94
  br i1 %18, label %19, label %153, !dbg !94

19:                                               ; preds = %16
  %20 = add i64 0, %17, !dbg !94
  %21 = getelementptr float, ptr %11, i64 %20, !dbg !94
  %22 = load <16 x float>, ptr %21, align 4, !dbg !94
  %23 = add i64 64, %17, !dbg !94
  %24 = getelementptr float, ptr %11, i64 %23, !dbg !94
  %25 = load <16 x float>, ptr %24, align 4, !dbg !94
  %26 = add i64 128, %17, !dbg !94
  %27 = getelementptr float, ptr %11, i64 %26, !dbg !94
  %28 = load <16 x float>, ptr %27, align 4, !dbg !94
  %29 = add i64 192, %17, !dbg !94
  %30 = getelementptr float, ptr %11, i64 %29, !dbg !94
  %31 = load <16 x float>, ptr %30, align 4, !dbg !94
  %32 = add i64 256, %17, !dbg !94
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !94
  %34 = load <16 x float>, ptr %33, align 4, !dbg !94
  %35 = add i64 320, %17, !dbg !94
  %36 = getelementptr float, ptr %11, i64 %35, !dbg !94
  %37 = load <16 x float>, ptr %36, align 4, !dbg !94
  %38 = add i64 384, %17, !dbg !94
  %39 = getelementptr float, ptr %11, i64 %38, !dbg !94
  %40 = load <16 x float>, ptr %39, align 4, !dbg !94
  %41 = add i64 448, %17, !dbg !94
  %42 = getelementptr float, ptr %11, i64 %41, !dbg !94
  %43 = load <16 x float>, ptr %42, align 4, !dbg !94
  %44 = add i64 512, %17, !dbg !94
  %45 = getelementptr float, ptr %11, i64 %44, !dbg !94
  %46 = load <16 x float>, ptr %45, align 4, !dbg !94
  %47 = add i64 576, %17, !dbg !94
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !94
  %49 = load <16 x float>, ptr %48, align 4, !dbg !94
  %50 = add i64 640, %17, !dbg !94
  %51 = getelementptr float, ptr %11, i64 %50, !dbg !94
  %52 = load <16 x float>, ptr %51, align 4, !dbg !94
  %53 = add i64 704, %17, !dbg !94
  %54 = getelementptr float, ptr %11, i64 %53, !dbg !94
  %55 = load <16 x float>, ptr %54, align 4, !dbg !94
  %56 = add i64 768, %17, !dbg !94
  %57 = getelementptr float, ptr %11, i64 %56, !dbg !94
  %58 = load <16 x float>, ptr %57, align 4, !dbg !94
  %59 = add i64 832, %17, !dbg !94
  %60 = getelementptr float, ptr %11, i64 %59, !dbg !94
  %61 = load <16 x float>, ptr %60, align 4, !dbg !94
  %62 = add i64 896, %17, !dbg !94
  %63 = getelementptr float, ptr %11, i64 %62, !dbg !94
  %64 = load <16 x float>, ptr %63, align 4, !dbg !94
  %65 = add i64 960, %17, !dbg !94
  %66 = getelementptr float, ptr %11, i64 %65, !dbg !94
  %67 = load <16 x float>, ptr %66, align 4, !dbg !94
  %68 = getelementptr inbounds nuw float, ptr %6, i64 0, !dbg !95
  %69 = load float, ptr %68, align 4, !dbg !95
  %70 = insertelement <16 x float> poison, float %69, i32 0, !dbg !95
  %71 = shufflevector <16 x float> %70, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %72 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %22, <16 x float> %71, <16 x float> zeroinitializer), !dbg !95
  %73 = getelementptr inbounds nuw float, ptr %6, i64 1, !dbg !95
  %74 = load float, ptr %73, align 4, !dbg !95
  %75 = insertelement <16 x float> poison, float %74, i32 0, !dbg !95
  %76 = shufflevector <16 x float> %75, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %77 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %25, <16 x float> %76, <16 x float> %72), !dbg !95
  %78 = getelementptr inbounds nuw float, ptr %6, i64 2, !dbg !95
  %79 = load float, ptr %78, align 4, !dbg !95
  %80 = insertelement <16 x float> poison, float %79, i32 0, !dbg !95
  %81 = shufflevector <16 x float> %80, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %82 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %28, <16 x float> %81, <16 x float> %77), !dbg !95
  %83 = getelementptr inbounds nuw float, ptr %6, i64 3, !dbg !95
  %84 = load float, ptr %83, align 4, !dbg !95
  %85 = insertelement <16 x float> poison, float %84, i32 0, !dbg !95
  %86 = shufflevector <16 x float> %85, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %87 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %31, <16 x float> %86, <16 x float> %82), !dbg !95
  %88 = getelementptr inbounds nuw float, ptr %6, i64 4, !dbg !95
  %89 = load float, ptr %88, align 4, !dbg !95
  %90 = insertelement <16 x float> poison, float %89, i32 0, !dbg !95
  %91 = shufflevector <16 x float> %90, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %92 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %34, <16 x float> %91, <16 x float> %87), !dbg !95
  %93 = getelementptr inbounds nuw float, ptr %6, i64 5, !dbg !95
  %94 = load float, ptr %93, align 4, !dbg !95
  %95 = insertelement <16 x float> poison, float %94, i32 0, !dbg !95
  %96 = shufflevector <16 x float> %95, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %97 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %37, <16 x float> %96, <16 x float> %92), !dbg !95
  %98 = getelementptr inbounds nuw float, ptr %6, i64 6, !dbg !95
  %99 = load float, ptr %98, align 4, !dbg !95
  %100 = insertelement <16 x float> poison, float %99, i32 0, !dbg !95
  %101 = shufflevector <16 x float> %100, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %102 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %40, <16 x float> %101, <16 x float> %97), !dbg !95
  %103 = getelementptr inbounds nuw float, ptr %6, i64 7, !dbg !95
  %104 = load float, ptr %103, align 4, !dbg !95
  %105 = insertelement <16 x float> poison, float %104, i32 0, !dbg !95
  %106 = shufflevector <16 x float> %105, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %107 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %43, <16 x float> %106, <16 x float> %102), !dbg !95
  %108 = getelementptr inbounds nuw float, ptr %6, i64 8, !dbg !95
  %109 = load float, ptr %108, align 4, !dbg !95
  %110 = insertelement <16 x float> poison, float %109, i32 0, !dbg !95
  %111 = shufflevector <16 x float> %110, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %112 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %46, <16 x float> %111, <16 x float> %107), !dbg !95
  %113 = getelementptr inbounds nuw float, ptr %6, i64 9, !dbg !95
  %114 = load float, ptr %113, align 4, !dbg !95
  %115 = insertelement <16 x float> poison, float %114, i32 0, !dbg !95
  %116 = shufflevector <16 x float> %115, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %117 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %49, <16 x float> %116, <16 x float> %112), !dbg !95
  %118 = getelementptr inbounds nuw float, ptr %6, i64 10, !dbg !95
  %119 = load float, ptr %118, align 4, !dbg !95
  %120 = insertelement <16 x float> poison, float %119, i32 0, !dbg !95
  %121 = shufflevector <16 x float> %120, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %122 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %52, <16 x float> %121, <16 x float> %117), !dbg !95
  %123 = getelementptr inbounds nuw float, ptr %6, i64 11, !dbg !95
  %124 = load float, ptr %123, align 4, !dbg !95
  %125 = insertelement <16 x float> poison, float %124, i32 0, !dbg !95
  %126 = shufflevector <16 x float> %125, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %127 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %55, <16 x float> %126, <16 x float> %122), !dbg !95
  %128 = getelementptr inbounds nuw float, ptr %6, i64 12, !dbg !95
  %129 = load float, ptr %128, align 4, !dbg !95
  %130 = insertelement <16 x float> poison, float %129, i32 0, !dbg !95
  %131 = shufflevector <16 x float> %130, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %132 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %58, <16 x float> %131, <16 x float> %127), !dbg !95
  %133 = getelementptr inbounds nuw float, ptr %6, i64 13, !dbg !95
  %134 = load float, ptr %133, align 4, !dbg !95
  %135 = insertelement <16 x float> poison, float %134, i32 0, !dbg !95
  %136 = shufflevector <16 x float> %135, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %137 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %61, <16 x float> %136, <16 x float> %132), !dbg !95
  %138 = getelementptr inbounds nuw float, ptr %6, i64 14, !dbg !95
  %139 = load float, ptr %138, align 4, !dbg !95
  %140 = insertelement <16 x float> poison, float %139, i32 0, !dbg !95
  %141 = shufflevector <16 x float> %140, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %142 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %64, <16 x float> %141, <16 x float> %137), !dbg !95
  %143 = getelementptr inbounds nuw float, ptr %6, i64 15, !dbg !95
  %144 = load float, ptr %143, align 4, !dbg !95
  %145 = insertelement <16 x float> poison, float %144, i32 0, !dbg !95
  %146 = shufflevector <16 x float> %145, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !95
  %147 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %67, <16 x float> %146, <16 x float> %142), !dbg !95
  %148 = fcmp ugt <16 x float> %147, zeroinitializer, !dbg !96
  %149 = select <16 x i1> %148, <16 x float> %147, <16 x float> zeroinitializer, !dbg !96
  %150 = select <16 x i1> zeroinitializer, <16 x float> zeroinitializer, <16 x float> %149, !dbg !96
  %151 = getelementptr float, ptr %15, i64 %20, !dbg !94
  store <16 x float> %150, ptr %151, align 4, !dbg !94
  %152 = add i64 %17, 16, !dbg !94
  br label %16, !dbg !94

153:                                              ; preds = %16
  ret i32 0, !dbg !97
}

define internal i32 @infer_dispatch_1_matmul_1x64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !98 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !99
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !99
  %6 = load ptr, ptr %5, align 8, !dbg !99
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !99
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !100
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !100
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !100
  %10 = load ptr, ptr %9, align 8, !dbg !100
  %11 = getelementptr float, ptr %10, i64 128, !dbg !100
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !100
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !101
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !101
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !101
  %15 = load ptr, ptr %14, align 8, !dbg !101
  %16 = getelementptr float, ptr %15, i64 64, !dbg !101
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !101
  br label %17, !dbg !102

17:                                               ; preds = %201, %3
  %18 = phi i64 [ %204, %201 ], [ 0, %3 ], !dbg !102
  %19 = icmp slt i64 %18, 64, !dbg !102
  br i1 %19, label %20, label %205, !dbg !102

20:                                               ; preds = %24, %17
  %21 = phi i64 [ %200, %24 ], [ 0, %17 ], !dbg !102
  %22 = phi <16 x float> [ %199, %24 ], [ zeroinitializer, %17 ], !dbg !102
  %23 = icmp slt i64 %21, 64, !dbg !102
  br i1 %23, label %24, label %201, !dbg !102

24:                                               ; preds = %20
  %25 = mul i64 %21, 64, !dbg !102
  %26 = add i64 %25, %18, !dbg !102
  %27 = getelementptr float, ptr %11, i64 %26, !dbg !102
  %28 = load <16 x float>, ptr %27, align 4, !dbg !102
  %29 = add i64 %21, 1, !dbg !102
  %30 = mul i64 %29, 64, !dbg !102
  %31 = add i64 %30, %18, !dbg !102
  %32 = getelementptr float, ptr %11, i64 %31, !dbg !102
  %33 = load <16 x float>, ptr %32, align 4, !dbg !102
  %34 = add i64 %21, 2, !dbg !102
  %35 = mul i64 %34, 64, !dbg !102
  %36 = add i64 %35, %18, !dbg !102
  %37 = getelementptr float, ptr %11, i64 %36, !dbg !102
  %38 = load <16 x float>, ptr %37, align 4, !dbg !102
  %39 = add i64 %21, 3, !dbg !102
  %40 = mul i64 %39, 64, !dbg !102
  %41 = add i64 %40, %18, !dbg !102
  %42 = getelementptr float, ptr %11, i64 %41, !dbg !102
  %43 = load <16 x float>, ptr %42, align 4, !dbg !102
  %44 = add i64 %21, 4, !dbg !102
  %45 = mul i64 %44, 64, !dbg !102
  %46 = add i64 %45, %18, !dbg !102
  %47 = getelementptr float, ptr %11, i64 %46, !dbg !102
  %48 = load <16 x float>, ptr %47, align 4, !dbg !102
  %49 = add i64 %21, 5, !dbg !102
  %50 = mul i64 %49, 64, !dbg !102
  %51 = add i64 %50, %18, !dbg !102
  %52 = getelementptr float, ptr %11, i64 %51, !dbg !102
  %53 = load <16 x float>, ptr %52, align 4, !dbg !102
  %54 = add i64 %21, 6, !dbg !102
  %55 = mul i64 %54, 64, !dbg !102
  %56 = add i64 %55, %18, !dbg !102
  %57 = getelementptr float, ptr %11, i64 %56, !dbg !102
  %58 = load <16 x float>, ptr %57, align 4, !dbg !102
  %59 = add i64 %21, 7, !dbg !102
  %60 = mul i64 %59, 64, !dbg !102
  %61 = add i64 %60, %18, !dbg !102
  %62 = getelementptr float, ptr %11, i64 %61, !dbg !102
  %63 = load <16 x float>, ptr %62, align 4, !dbg !102
  %64 = add i64 %21, 8, !dbg !102
  %65 = mul i64 %64, 64, !dbg !102
  %66 = add i64 %65, %18, !dbg !102
  %67 = getelementptr float, ptr %11, i64 %66, !dbg !102
  %68 = load <16 x float>, ptr %67, align 4, !dbg !102
  %69 = add i64 %21, 9, !dbg !102
  %70 = mul i64 %69, 64, !dbg !102
  %71 = add i64 %70, %18, !dbg !102
  %72 = getelementptr float, ptr %11, i64 %71, !dbg !102
  %73 = load <16 x float>, ptr %72, align 4, !dbg !102
  %74 = add i64 %21, 10, !dbg !102
  %75 = mul i64 %74, 64, !dbg !102
  %76 = add i64 %75, %18, !dbg !102
  %77 = getelementptr float, ptr %11, i64 %76, !dbg !102
  %78 = load <16 x float>, ptr %77, align 4, !dbg !102
  %79 = add i64 %21, 11, !dbg !102
  %80 = mul i64 %79, 64, !dbg !102
  %81 = add i64 %80, %18, !dbg !102
  %82 = getelementptr float, ptr %11, i64 %81, !dbg !102
  %83 = load <16 x float>, ptr %82, align 4, !dbg !102
  %84 = add i64 %21, 12, !dbg !102
  %85 = mul i64 %84, 64, !dbg !102
  %86 = add i64 %85, %18, !dbg !102
  %87 = getelementptr float, ptr %11, i64 %86, !dbg !102
  %88 = load <16 x float>, ptr %87, align 4, !dbg !102
  %89 = add i64 %21, 13, !dbg !102
  %90 = mul i64 %89, 64, !dbg !102
  %91 = add i64 %90, %18, !dbg !102
  %92 = getelementptr float, ptr %11, i64 %91, !dbg !102
  %93 = load <16 x float>, ptr %92, align 4, !dbg !102
  %94 = add i64 %21, 14, !dbg !102
  %95 = mul i64 %94, 64, !dbg !102
  %96 = add i64 %95, %18, !dbg !102
  %97 = getelementptr float, ptr %11, i64 %96, !dbg !102
  %98 = load <16 x float>, ptr %97, align 4, !dbg !102
  %99 = add i64 %21, 15, !dbg !102
  %100 = mul i64 %99, 64, !dbg !102
  %101 = add i64 %100, %18, !dbg !102
  %102 = getelementptr float, ptr %11, i64 %101, !dbg !102
  %103 = load <16 x float>, ptr %102, align 4, !dbg !102
  %104 = add nuw nsw i64 0, %21, !dbg !103
  %105 = getelementptr inbounds nuw float, ptr %6, i64 %104, !dbg !103
  %106 = load float, ptr %105, align 4, !dbg !103
  %107 = insertelement <16 x float> poison, float %106, i32 0, !dbg !103
  %108 = shufflevector <16 x float> %107, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %109 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %28, <16 x float> %108, <16 x float> %22), !dbg !103
  %110 = add nuw nsw i64 0, %29, !dbg !103
  %111 = getelementptr inbounds nuw float, ptr %6, i64 %110, !dbg !103
  %112 = load float, ptr %111, align 4, !dbg !103
  %113 = insertelement <16 x float> poison, float %112, i32 0, !dbg !103
  %114 = shufflevector <16 x float> %113, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %115 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %33, <16 x float> %114, <16 x float> %109), !dbg !103
  %116 = add nuw nsw i64 0, %34, !dbg !103
  %117 = getelementptr inbounds nuw float, ptr %6, i64 %116, !dbg !103
  %118 = load float, ptr %117, align 4, !dbg !103
  %119 = insertelement <16 x float> poison, float %118, i32 0, !dbg !103
  %120 = shufflevector <16 x float> %119, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %121 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %38, <16 x float> %120, <16 x float> %115), !dbg !103
  %122 = add nuw nsw i64 0, %39, !dbg !103
  %123 = getelementptr inbounds nuw float, ptr %6, i64 %122, !dbg !103
  %124 = load float, ptr %123, align 4, !dbg !103
  %125 = insertelement <16 x float> poison, float %124, i32 0, !dbg !103
  %126 = shufflevector <16 x float> %125, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %127 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %43, <16 x float> %126, <16 x float> %121), !dbg !103
  %128 = add nuw nsw i64 0, %44, !dbg !103
  %129 = getelementptr inbounds nuw float, ptr %6, i64 %128, !dbg !103
  %130 = load float, ptr %129, align 4, !dbg !103
  %131 = insertelement <16 x float> poison, float %130, i32 0, !dbg !103
  %132 = shufflevector <16 x float> %131, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %133 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %48, <16 x float> %132, <16 x float> %127), !dbg !103
  %134 = add nuw nsw i64 0, %49, !dbg !103
  %135 = getelementptr inbounds nuw float, ptr %6, i64 %134, !dbg !103
  %136 = load float, ptr %135, align 4, !dbg !103
  %137 = insertelement <16 x float> poison, float %136, i32 0, !dbg !103
  %138 = shufflevector <16 x float> %137, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %139 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %53, <16 x float> %138, <16 x float> %133), !dbg !103
  %140 = add nuw nsw i64 0, %54, !dbg !103
  %141 = getelementptr inbounds nuw float, ptr %6, i64 %140, !dbg !103
  %142 = load float, ptr %141, align 4, !dbg !103
  %143 = insertelement <16 x float> poison, float %142, i32 0, !dbg !103
  %144 = shufflevector <16 x float> %143, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %145 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %58, <16 x float> %144, <16 x float> %139), !dbg !103
  %146 = add nuw nsw i64 0, %59, !dbg !103
  %147 = getelementptr inbounds nuw float, ptr %6, i64 %146, !dbg !103
  %148 = load float, ptr %147, align 4, !dbg !103
  %149 = insertelement <16 x float> poison, float %148, i32 0, !dbg !103
  %150 = shufflevector <16 x float> %149, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %151 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %63, <16 x float> %150, <16 x float> %145), !dbg !103
  %152 = add nuw nsw i64 0, %64, !dbg !103
  %153 = getelementptr inbounds nuw float, ptr %6, i64 %152, !dbg !103
  %154 = load float, ptr %153, align 4, !dbg !103
  %155 = insertelement <16 x float> poison, float %154, i32 0, !dbg !103
  %156 = shufflevector <16 x float> %155, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %157 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %68, <16 x float> %156, <16 x float> %151), !dbg !103
  %158 = add nuw nsw i64 0, %69, !dbg !103
  %159 = getelementptr inbounds nuw float, ptr %6, i64 %158, !dbg !103
  %160 = load float, ptr %159, align 4, !dbg !103
  %161 = insertelement <16 x float> poison, float %160, i32 0, !dbg !103
  %162 = shufflevector <16 x float> %161, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %163 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %73, <16 x float> %162, <16 x float> %157), !dbg !103
  %164 = add nuw nsw i64 0, %74, !dbg !103
  %165 = getelementptr inbounds nuw float, ptr %6, i64 %164, !dbg !103
  %166 = load float, ptr %165, align 4, !dbg !103
  %167 = insertelement <16 x float> poison, float %166, i32 0, !dbg !103
  %168 = shufflevector <16 x float> %167, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %169 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %78, <16 x float> %168, <16 x float> %163), !dbg !103
  %170 = add nuw nsw i64 0, %79, !dbg !103
  %171 = getelementptr inbounds nuw float, ptr %6, i64 %170, !dbg !103
  %172 = load float, ptr %171, align 4, !dbg !103
  %173 = insertelement <16 x float> poison, float %172, i32 0, !dbg !103
  %174 = shufflevector <16 x float> %173, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %175 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %83, <16 x float> %174, <16 x float> %169), !dbg !103
  %176 = add nuw nsw i64 0, %84, !dbg !103
  %177 = getelementptr inbounds nuw float, ptr %6, i64 %176, !dbg !103
  %178 = load float, ptr %177, align 4, !dbg !103
  %179 = insertelement <16 x float> poison, float %178, i32 0, !dbg !103
  %180 = shufflevector <16 x float> %179, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %181 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %88, <16 x float> %180, <16 x float> %175), !dbg !103
  %182 = add nuw nsw i64 0, %89, !dbg !103
  %183 = getelementptr inbounds nuw float, ptr %6, i64 %182, !dbg !103
  %184 = load float, ptr %183, align 4, !dbg !103
  %185 = insertelement <16 x float> poison, float %184, i32 0, !dbg !103
  %186 = shufflevector <16 x float> %185, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %187 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %93, <16 x float> %186, <16 x float> %181), !dbg !103
  %188 = add nuw nsw i64 0, %94, !dbg !103
  %189 = getelementptr inbounds nuw float, ptr %6, i64 %188, !dbg !103
  %190 = load float, ptr %189, align 4, !dbg !103
  %191 = insertelement <16 x float> poison, float %190, i32 0, !dbg !103
  %192 = shufflevector <16 x float> %191, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %193 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %98, <16 x float> %192, <16 x float> %187), !dbg !103
  %194 = add nuw nsw i64 0, %99, !dbg !103
  %195 = getelementptr inbounds nuw float, ptr %6, i64 %194, !dbg !103
  %196 = load float, ptr %195, align 4, !dbg !103
  %197 = insertelement <16 x float> poison, float %196, i32 0, !dbg !103
  %198 = shufflevector <16 x float> %197, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !103
  %199 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %103, <16 x float> %198, <16 x float> %193), !dbg !103
  %200 = add i64 %21, 16, !dbg !102
  br label %20, !dbg !102

201:                                              ; preds = %20
  %202 = add i64 0, %18, !dbg !102
  %203 = getelementptr float, ptr %16, i64 %202, !dbg !102
  store <16 x float> %22, ptr %203, align 4, !dbg !102
  %204 = add i64 %18, 16, !dbg !102
  br label %17, !dbg !102

205:                                              ; preds = %17
  ret i32 0, !dbg !104
}

define internal i32 @infer_dispatch_2_matmul_1x64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !105 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !106
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !106
  %6 = load ptr, ptr %5, align 8, !dbg !106
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !106
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !107
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !107
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !107
  %10 = load ptr, ptr %9, align 8, !dbg !107
  %11 = getelementptr float, ptr %10, i64 4224, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !107
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !108
  %14 = load ptr, ptr %13, align 8, !dbg !108
  %15 = getelementptr float, ptr %14, i64 64, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !108
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !109
  %18 = getelementptr ptr, ptr %17, i32 2, !dbg !109
  %19 = load ptr, ptr %18, align 8, !dbg !109
  %20 = getelementptr float, ptr %19, i64 128, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !109
  br label %21, !dbg !110

21:                                               ; preds = %205, %3
  %22 = phi i64 [ %220, %205 ], [ 0, %3 ], !dbg !110
  %23 = icmp slt i64 %22, 64, !dbg !110
  br i1 %23, label %24, label %221, !dbg !110

24:                                               ; preds = %28, %21
  %25 = phi i64 [ %204, %28 ], [ 0, %21 ], !dbg !110
  %26 = phi <16 x float> [ %203, %28 ], [ zeroinitializer, %21 ], !dbg !110
  %27 = icmp slt i64 %25, 64, !dbg !110
  br i1 %27, label %28, label %205, !dbg !110

28:                                               ; preds = %24
  %29 = mul i64 %25, 64, !dbg !110
  %30 = add i64 %29, %22, !dbg !110
  %31 = getelementptr float, ptr %11, i64 %30, !dbg !110
  %32 = load <16 x float>, ptr %31, align 4, !dbg !110
  %33 = add i64 %25, 1, !dbg !110
  %34 = mul i64 %33, 64, !dbg !110
  %35 = add i64 %34, %22, !dbg !110
  %36 = getelementptr float, ptr %11, i64 %35, !dbg !110
  %37 = load <16 x float>, ptr %36, align 4, !dbg !110
  %38 = add i64 %25, 2, !dbg !110
  %39 = mul i64 %38, 64, !dbg !110
  %40 = add i64 %39, %22, !dbg !110
  %41 = getelementptr float, ptr %11, i64 %40, !dbg !110
  %42 = load <16 x float>, ptr %41, align 4, !dbg !110
  %43 = add i64 %25, 3, !dbg !110
  %44 = mul i64 %43, 64, !dbg !110
  %45 = add i64 %44, %22, !dbg !110
  %46 = getelementptr float, ptr %11, i64 %45, !dbg !110
  %47 = load <16 x float>, ptr %46, align 4, !dbg !110
  %48 = add i64 %25, 4, !dbg !110
  %49 = mul i64 %48, 64, !dbg !110
  %50 = add i64 %49, %22, !dbg !110
  %51 = getelementptr float, ptr %11, i64 %50, !dbg !110
  %52 = load <16 x float>, ptr %51, align 4, !dbg !110
  %53 = add i64 %25, 5, !dbg !110
  %54 = mul i64 %53, 64, !dbg !110
  %55 = add i64 %54, %22, !dbg !110
  %56 = getelementptr float, ptr %11, i64 %55, !dbg !110
  %57 = load <16 x float>, ptr %56, align 4, !dbg !110
  %58 = add i64 %25, 6, !dbg !110
  %59 = mul i64 %58, 64, !dbg !110
  %60 = add i64 %59, %22, !dbg !110
  %61 = getelementptr float, ptr %11, i64 %60, !dbg !110
  %62 = load <16 x float>, ptr %61, align 4, !dbg !110
  %63 = add i64 %25, 7, !dbg !110
  %64 = mul i64 %63, 64, !dbg !110
  %65 = add i64 %64, %22, !dbg !110
  %66 = getelementptr float, ptr %11, i64 %65, !dbg !110
  %67 = load <16 x float>, ptr %66, align 4, !dbg !110
  %68 = add i64 %25, 8, !dbg !110
  %69 = mul i64 %68, 64, !dbg !110
  %70 = add i64 %69, %22, !dbg !110
  %71 = getelementptr float, ptr %11, i64 %70, !dbg !110
  %72 = load <16 x float>, ptr %71, align 4, !dbg !110
  %73 = add i64 %25, 9, !dbg !110
  %74 = mul i64 %73, 64, !dbg !110
  %75 = add i64 %74, %22, !dbg !110
  %76 = getelementptr float, ptr %11, i64 %75, !dbg !110
  %77 = load <16 x float>, ptr %76, align 4, !dbg !110
  %78 = add i64 %25, 10, !dbg !110
  %79 = mul i64 %78, 64, !dbg !110
  %80 = add i64 %79, %22, !dbg !110
  %81 = getelementptr float, ptr %11, i64 %80, !dbg !110
  %82 = load <16 x float>, ptr %81, align 4, !dbg !110
  %83 = add i64 %25, 11, !dbg !110
  %84 = mul i64 %83, 64, !dbg !110
  %85 = add i64 %84, %22, !dbg !110
  %86 = getelementptr float, ptr %11, i64 %85, !dbg !110
  %87 = load <16 x float>, ptr %86, align 4, !dbg !110
  %88 = add i64 %25, 12, !dbg !110
  %89 = mul i64 %88, 64, !dbg !110
  %90 = add i64 %89, %22, !dbg !110
  %91 = getelementptr float, ptr %11, i64 %90, !dbg !110
  %92 = load <16 x float>, ptr %91, align 4, !dbg !110
  %93 = add i64 %25, 13, !dbg !110
  %94 = mul i64 %93, 64, !dbg !110
  %95 = add i64 %94, %22, !dbg !110
  %96 = getelementptr float, ptr %11, i64 %95, !dbg !110
  %97 = load <16 x float>, ptr %96, align 4, !dbg !110
  %98 = add i64 %25, 14, !dbg !110
  %99 = mul i64 %98, 64, !dbg !110
  %100 = add i64 %99, %22, !dbg !110
  %101 = getelementptr float, ptr %11, i64 %100, !dbg !110
  %102 = load <16 x float>, ptr %101, align 4, !dbg !110
  %103 = add i64 %25, 15, !dbg !110
  %104 = mul i64 %103, 64, !dbg !110
  %105 = add i64 %104, %22, !dbg !110
  %106 = getelementptr float, ptr %11, i64 %105, !dbg !110
  %107 = load <16 x float>, ptr %106, align 4, !dbg !110
  %108 = add nuw nsw i64 0, %25, !dbg !111
  %109 = getelementptr inbounds nuw float, ptr %6, i64 %108, !dbg !111
  %110 = load float, ptr %109, align 4, !dbg !111
  %111 = insertelement <16 x float> poison, float %110, i32 0, !dbg !111
  %112 = shufflevector <16 x float> %111, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %113 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %32, <16 x float> %112, <16 x float> %26), !dbg !111
  %114 = add nuw nsw i64 0, %33, !dbg !111
  %115 = getelementptr inbounds nuw float, ptr %6, i64 %114, !dbg !111
  %116 = load float, ptr %115, align 4, !dbg !111
  %117 = insertelement <16 x float> poison, float %116, i32 0, !dbg !111
  %118 = shufflevector <16 x float> %117, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %119 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %37, <16 x float> %118, <16 x float> %113), !dbg !111
  %120 = add nuw nsw i64 0, %38, !dbg !111
  %121 = getelementptr inbounds nuw float, ptr %6, i64 %120, !dbg !111
  %122 = load float, ptr %121, align 4, !dbg !111
  %123 = insertelement <16 x float> poison, float %122, i32 0, !dbg !111
  %124 = shufflevector <16 x float> %123, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %125 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %42, <16 x float> %124, <16 x float> %119), !dbg !111
  %126 = add nuw nsw i64 0, %43, !dbg !111
  %127 = getelementptr inbounds nuw float, ptr %6, i64 %126, !dbg !111
  %128 = load float, ptr %127, align 4, !dbg !111
  %129 = insertelement <16 x float> poison, float %128, i32 0, !dbg !111
  %130 = shufflevector <16 x float> %129, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %131 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %47, <16 x float> %130, <16 x float> %125), !dbg !111
  %132 = add nuw nsw i64 0, %48, !dbg !111
  %133 = getelementptr inbounds nuw float, ptr %6, i64 %132, !dbg !111
  %134 = load float, ptr %133, align 4, !dbg !111
  %135 = insertelement <16 x float> poison, float %134, i32 0, !dbg !111
  %136 = shufflevector <16 x float> %135, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %137 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %52, <16 x float> %136, <16 x float> %131), !dbg !111
  %138 = add nuw nsw i64 0, %53, !dbg !111
  %139 = getelementptr inbounds nuw float, ptr %6, i64 %138, !dbg !111
  %140 = load float, ptr %139, align 4, !dbg !111
  %141 = insertelement <16 x float> poison, float %140, i32 0, !dbg !111
  %142 = shufflevector <16 x float> %141, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %143 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %57, <16 x float> %142, <16 x float> %137), !dbg !111
  %144 = add nuw nsw i64 0, %58, !dbg !111
  %145 = getelementptr inbounds nuw float, ptr %6, i64 %144, !dbg !111
  %146 = load float, ptr %145, align 4, !dbg !111
  %147 = insertelement <16 x float> poison, float %146, i32 0, !dbg !111
  %148 = shufflevector <16 x float> %147, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %149 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %62, <16 x float> %148, <16 x float> %143), !dbg !111
  %150 = add nuw nsw i64 0, %63, !dbg !111
  %151 = getelementptr inbounds nuw float, ptr %6, i64 %150, !dbg !111
  %152 = load float, ptr %151, align 4, !dbg !111
  %153 = insertelement <16 x float> poison, float %152, i32 0, !dbg !111
  %154 = shufflevector <16 x float> %153, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %155 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %67, <16 x float> %154, <16 x float> %149), !dbg !111
  %156 = add nuw nsw i64 0, %68, !dbg !111
  %157 = getelementptr inbounds nuw float, ptr %6, i64 %156, !dbg !111
  %158 = load float, ptr %157, align 4, !dbg !111
  %159 = insertelement <16 x float> poison, float %158, i32 0, !dbg !111
  %160 = shufflevector <16 x float> %159, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %161 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %72, <16 x float> %160, <16 x float> %155), !dbg !111
  %162 = add nuw nsw i64 0, %73, !dbg !111
  %163 = getelementptr inbounds nuw float, ptr %6, i64 %162, !dbg !111
  %164 = load float, ptr %163, align 4, !dbg !111
  %165 = insertelement <16 x float> poison, float %164, i32 0, !dbg !111
  %166 = shufflevector <16 x float> %165, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %167 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %77, <16 x float> %166, <16 x float> %161), !dbg !111
  %168 = add nuw nsw i64 0, %78, !dbg !111
  %169 = getelementptr inbounds nuw float, ptr %6, i64 %168, !dbg !111
  %170 = load float, ptr %169, align 4, !dbg !111
  %171 = insertelement <16 x float> poison, float %170, i32 0, !dbg !111
  %172 = shufflevector <16 x float> %171, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %173 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %82, <16 x float> %172, <16 x float> %167), !dbg !111
  %174 = add nuw nsw i64 0, %83, !dbg !111
  %175 = getelementptr inbounds nuw float, ptr %6, i64 %174, !dbg !111
  %176 = load float, ptr %175, align 4, !dbg !111
  %177 = insertelement <16 x float> poison, float %176, i32 0, !dbg !111
  %178 = shufflevector <16 x float> %177, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %179 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %87, <16 x float> %178, <16 x float> %173), !dbg !111
  %180 = add nuw nsw i64 0, %88, !dbg !111
  %181 = getelementptr inbounds nuw float, ptr %6, i64 %180, !dbg !111
  %182 = load float, ptr %181, align 4, !dbg !111
  %183 = insertelement <16 x float> poison, float %182, i32 0, !dbg !111
  %184 = shufflevector <16 x float> %183, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %185 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %92, <16 x float> %184, <16 x float> %179), !dbg !111
  %186 = add nuw nsw i64 0, %93, !dbg !111
  %187 = getelementptr inbounds nuw float, ptr %6, i64 %186, !dbg !111
  %188 = load float, ptr %187, align 4, !dbg !111
  %189 = insertelement <16 x float> poison, float %188, i32 0, !dbg !111
  %190 = shufflevector <16 x float> %189, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %191 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %97, <16 x float> %190, <16 x float> %185), !dbg !111
  %192 = add nuw nsw i64 0, %98, !dbg !111
  %193 = getelementptr inbounds nuw float, ptr %6, i64 %192, !dbg !111
  %194 = load float, ptr %193, align 4, !dbg !111
  %195 = insertelement <16 x float> poison, float %194, i32 0, !dbg !111
  %196 = shufflevector <16 x float> %195, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %197 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %102, <16 x float> %196, <16 x float> %191), !dbg !111
  %198 = add nuw nsw i64 0, %103, !dbg !111
  %199 = getelementptr inbounds nuw float, ptr %6, i64 %198, !dbg !111
  %200 = load float, ptr %199, align 4, !dbg !111
  %201 = insertelement <16 x float> poison, float %200, i32 0, !dbg !111
  %202 = shufflevector <16 x float> %201, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %203 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %107, <16 x float> %202, <16 x float> %197), !dbg !111
  %204 = add i64 %25, 16, !dbg !110
  br label %24, !dbg !110

205:                                              ; preds = %24
  %206 = add i64 0, %22, !dbg !112
  %207 = getelementptr float, ptr %15, i64 %206, !dbg !112
  %208 = load <16 x float>, ptr %207, align 4, !dbg !112
  %209 = getelementptr float, ptr %6, i64 %206, !dbg !112
  %210 = load <16 x float>, ptr %209, align 4, !dbg !112
  %211 = fcmp ugt <16 x float> %208, zeroinitializer, !dbg !113
  %212 = select <16 x i1> %211, <16 x float> %208, <16 x float> zeroinitializer, !dbg !113
  %213 = select <16 x i1> zeroinitializer, <16 x float> zeroinitializer, <16 x float> %212, !dbg !113
  %214 = fcmp ugt <16 x float> %26, zeroinitializer, !dbg !114
  %215 = select <16 x i1> %214, <16 x float> %26, <16 x float> zeroinitializer, !dbg !114
  %216 = select <16 x i1> zeroinitializer, <16 x float> zeroinitializer, <16 x float> %215, !dbg !114
  %217 = fadd contract <16 x float> %216, %213, !dbg !115
  %218 = fadd contract <16 x float> %217, %210, !dbg !116
  %219 = getelementptr float, ptr %20, i64 %206, !dbg !110
  store <16 x float> %218, ptr %219, align 4, !dbg !110
  %220 = add i64 %22, 16, !dbg !110
  br label %21, !dbg !110

221:                                              ; preds = %21
  ret i32 0, !dbg !117
}

define internal i32 @infer_dispatch_3_matmul_1x2x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !118 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !119
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !119
  %6 = load ptr, ptr %5, align 8, !dbg !119
  %7 = getelementptr float, ptr %6, i64 128, !dbg !119
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !119
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !120
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !120
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !120
  %11 = load ptr, ptr %10, align 8, !dbg !120
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !120
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !121
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !121
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !121
  %15 = load ptr, ptr %14, align 8, !dbg !121
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !121
  br label %16, !dbg !122

16:                                               ; preds = %20, %3
  %17 = phi i64 [ %196, %20 ], [ 0, %3 ], !dbg !122
  %18 = phi <2 x float> [ %195, %20 ], [ zeroinitializer, %3 ], !dbg !122
  %19 = icmp slt i64 %17, 64, !dbg !122
  br i1 %19, label %20, label %197, !dbg !122

20:                                               ; preds = %16
  %21 = mul i64 %17, 2, !dbg !122
  %22 = add i64 %21, 0, !dbg !122
  %23 = getelementptr float, ptr %11, i64 %22, !dbg !122
  %24 = load <2 x float>, ptr %23, align 4, !dbg !122
  %25 = add i64 %17, 1, !dbg !122
  %26 = mul i64 %25, 2, !dbg !122
  %27 = add i64 %26, 0, !dbg !122
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !122
  %29 = load <2 x float>, ptr %28, align 4, !dbg !122
  %30 = add i64 %17, 2, !dbg !122
  %31 = mul i64 %30, 2, !dbg !122
  %32 = add i64 %31, 0, !dbg !122
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !122
  %34 = load <2 x float>, ptr %33, align 4, !dbg !122
  %35 = add i64 %17, 3, !dbg !122
  %36 = mul i64 %35, 2, !dbg !122
  %37 = add i64 %36, 0, !dbg !122
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !122
  %39 = load <2 x float>, ptr %38, align 4, !dbg !122
  %40 = add i64 %17, 4, !dbg !122
  %41 = mul i64 %40, 2, !dbg !122
  %42 = add i64 %41, 0, !dbg !122
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !122
  %44 = load <2 x float>, ptr %43, align 4, !dbg !122
  %45 = add i64 %17, 5, !dbg !122
  %46 = mul i64 %45, 2, !dbg !122
  %47 = add i64 %46, 0, !dbg !122
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !122
  %49 = load <2 x float>, ptr %48, align 4, !dbg !122
  %50 = add i64 %17, 6, !dbg !122
  %51 = mul i64 %50, 2, !dbg !122
  %52 = add i64 %51, 0, !dbg !122
  %53 = getelementptr float, ptr %11, i64 %52, !dbg !122
  %54 = load <2 x float>, ptr %53, align 4, !dbg !122
  %55 = add i64 %17, 7, !dbg !122
  %56 = mul i64 %55, 2, !dbg !122
  %57 = add i64 %56, 0, !dbg !122
  %58 = getelementptr float, ptr %11, i64 %57, !dbg !122
  %59 = load <2 x float>, ptr %58, align 4, !dbg !122
  %60 = add i64 %17, 8, !dbg !122
  %61 = mul i64 %60, 2, !dbg !122
  %62 = add i64 %61, 0, !dbg !122
  %63 = getelementptr float, ptr %11, i64 %62, !dbg !122
  %64 = load <2 x float>, ptr %63, align 4, !dbg !122
  %65 = add i64 %17, 9, !dbg !122
  %66 = mul i64 %65, 2, !dbg !122
  %67 = add i64 %66, 0, !dbg !122
  %68 = getelementptr float, ptr %11, i64 %67, !dbg !122
  %69 = load <2 x float>, ptr %68, align 4, !dbg !122
  %70 = add i64 %17, 10, !dbg !122
  %71 = mul i64 %70, 2, !dbg !122
  %72 = add i64 %71, 0, !dbg !122
  %73 = getelementptr float, ptr %11, i64 %72, !dbg !122
  %74 = load <2 x float>, ptr %73, align 4, !dbg !122
  %75 = add i64 %17, 11, !dbg !122
  %76 = mul i64 %75, 2, !dbg !122
  %77 = add i64 %76, 0, !dbg !122
  %78 = getelementptr float, ptr %11, i64 %77, !dbg !122
  %79 = load <2 x float>, ptr %78, align 4, !dbg !122
  %80 = add i64 %17, 12, !dbg !122
  %81 = mul i64 %80, 2, !dbg !122
  %82 = add i64 %81, 0, !dbg !122
  %83 = getelementptr float, ptr %11, i64 %82, !dbg !122
  %84 = load <2 x float>, ptr %83, align 4, !dbg !122
  %85 = add i64 %17, 13, !dbg !122
  %86 = mul i64 %85, 2, !dbg !122
  %87 = add i64 %86, 0, !dbg !122
  %88 = getelementptr float, ptr %11, i64 %87, !dbg !122
  %89 = load <2 x float>, ptr %88, align 4, !dbg !122
  %90 = add i64 %17, 14, !dbg !122
  %91 = mul i64 %90, 2, !dbg !122
  %92 = add i64 %91, 0, !dbg !122
  %93 = getelementptr float, ptr %11, i64 %92, !dbg !122
  %94 = load <2 x float>, ptr %93, align 4, !dbg !122
  %95 = add i64 %17, 15, !dbg !122
  %96 = mul i64 %95, 2, !dbg !122
  %97 = add i64 %96, 0, !dbg !122
  %98 = getelementptr float, ptr %11, i64 %97, !dbg !122
  %99 = load <2 x float>, ptr %98, align 4, !dbg !122
  %100 = add nuw nsw i64 0, %17, !dbg !123
  %101 = getelementptr inbounds nuw float, ptr %7, i64 %100, !dbg !123
  %102 = load float, ptr %101, align 4, !dbg !123
  %103 = insertelement <2 x float> poison, float %102, i32 0, !dbg !123
  %104 = shufflevector <2 x float> %103, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %105 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %24, <2 x float> %104, <2 x float> %18), !dbg !123
  %106 = add nuw nsw i64 0, %25, !dbg !123
  %107 = getelementptr inbounds nuw float, ptr %7, i64 %106, !dbg !123
  %108 = load float, ptr %107, align 4, !dbg !123
  %109 = insertelement <2 x float> poison, float %108, i32 0, !dbg !123
  %110 = shufflevector <2 x float> %109, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %111 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %29, <2 x float> %110, <2 x float> %105), !dbg !123
  %112 = add nuw nsw i64 0, %30, !dbg !123
  %113 = getelementptr inbounds nuw float, ptr %7, i64 %112, !dbg !123
  %114 = load float, ptr %113, align 4, !dbg !123
  %115 = insertelement <2 x float> poison, float %114, i32 0, !dbg !123
  %116 = shufflevector <2 x float> %115, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %117 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %34, <2 x float> %116, <2 x float> %111), !dbg !123
  %118 = add nuw nsw i64 0, %35, !dbg !123
  %119 = getelementptr inbounds nuw float, ptr %7, i64 %118, !dbg !123
  %120 = load float, ptr %119, align 4, !dbg !123
  %121 = insertelement <2 x float> poison, float %120, i32 0, !dbg !123
  %122 = shufflevector <2 x float> %121, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %123 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %39, <2 x float> %122, <2 x float> %117), !dbg !123
  %124 = add nuw nsw i64 0, %40, !dbg !123
  %125 = getelementptr inbounds nuw float, ptr %7, i64 %124, !dbg !123
  %126 = load float, ptr %125, align 4, !dbg !123
  %127 = insertelement <2 x float> poison, float %126, i32 0, !dbg !123
  %128 = shufflevector <2 x float> %127, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %129 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %44, <2 x float> %128, <2 x float> %123), !dbg !123
  %130 = add nuw nsw i64 0, %45, !dbg !123
  %131 = getelementptr inbounds nuw float, ptr %7, i64 %130, !dbg !123
  %132 = load float, ptr %131, align 4, !dbg !123
  %133 = insertelement <2 x float> poison, float %132, i32 0, !dbg !123
  %134 = shufflevector <2 x float> %133, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %135 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %49, <2 x float> %134, <2 x float> %129), !dbg !123
  %136 = add nuw nsw i64 0, %50, !dbg !123
  %137 = getelementptr inbounds nuw float, ptr %7, i64 %136, !dbg !123
  %138 = load float, ptr %137, align 4, !dbg !123
  %139 = insertelement <2 x float> poison, float %138, i32 0, !dbg !123
  %140 = shufflevector <2 x float> %139, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %141 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %54, <2 x float> %140, <2 x float> %135), !dbg !123
  %142 = add nuw nsw i64 0, %55, !dbg !123
  %143 = getelementptr inbounds nuw float, ptr %7, i64 %142, !dbg !123
  %144 = load float, ptr %143, align 4, !dbg !123
  %145 = insertelement <2 x float> poison, float %144, i32 0, !dbg !123
  %146 = shufflevector <2 x float> %145, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %147 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %59, <2 x float> %146, <2 x float> %141), !dbg !123
  %148 = add nuw nsw i64 0, %60, !dbg !123
  %149 = getelementptr inbounds nuw float, ptr %7, i64 %148, !dbg !123
  %150 = load float, ptr %149, align 4, !dbg !123
  %151 = insertelement <2 x float> poison, float %150, i32 0, !dbg !123
  %152 = shufflevector <2 x float> %151, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %153 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %64, <2 x float> %152, <2 x float> %147), !dbg !123
  %154 = add nuw nsw i64 0, %65, !dbg !123
  %155 = getelementptr inbounds nuw float, ptr %7, i64 %154, !dbg !123
  %156 = load float, ptr %155, align 4, !dbg !123
  %157 = insertelement <2 x float> poison, float %156, i32 0, !dbg !123
  %158 = shufflevector <2 x float> %157, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %159 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %69, <2 x float> %158, <2 x float> %153), !dbg !123
  %160 = add nuw nsw i64 0, %70, !dbg !123
  %161 = getelementptr inbounds nuw float, ptr %7, i64 %160, !dbg !123
  %162 = load float, ptr %161, align 4, !dbg !123
  %163 = insertelement <2 x float> poison, float %162, i32 0, !dbg !123
  %164 = shufflevector <2 x float> %163, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %165 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %74, <2 x float> %164, <2 x float> %159), !dbg !123
  %166 = add nuw nsw i64 0, %75, !dbg !123
  %167 = getelementptr inbounds nuw float, ptr %7, i64 %166, !dbg !123
  %168 = load float, ptr %167, align 4, !dbg !123
  %169 = insertelement <2 x float> poison, float %168, i32 0, !dbg !123
  %170 = shufflevector <2 x float> %169, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %171 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %79, <2 x float> %170, <2 x float> %165), !dbg !123
  %172 = add nuw nsw i64 0, %80, !dbg !123
  %173 = getelementptr inbounds nuw float, ptr %7, i64 %172, !dbg !123
  %174 = load float, ptr %173, align 4, !dbg !123
  %175 = insertelement <2 x float> poison, float %174, i32 0, !dbg !123
  %176 = shufflevector <2 x float> %175, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %177 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %84, <2 x float> %176, <2 x float> %171), !dbg !123
  %178 = add nuw nsw i64 0, %85, !dbg !123
  %179 = getelementptr inbounds nuw float, ptr %7, i64 %178, !dbg !123
  %180 = load float, ptr %179, align 4, !dbg !123
  %181 = insertelement <2 x float> poison, float %180, i32 0, !dbg !123
  %182 = shufflevector <2 x float> %181, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %183 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %89, <2 x float> %182, <2 x float> %177), !dbg !123
  %184 = add nuw nsw i64 0, %90, !dbg !123
  %185 = getelementptr inbounds nuw float, ptr %7, i64 %184, !dbg !123
  %186 = load float, ptr %185, align 4, !dbg !123
  %187 = insertelement <2 x float> poison, float %186, i32 0, !dbg !123
  %188 = shufflevector <2 x float> %187, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %189 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %94, <2 x float> %188, <2 x float> %183), !dbg !123
  %190 = add nuw nsw i64 0, %95, !dbg !123
  %191 = getelementptr inbounds nuw float, ptr %7, i64 %190, !dbg !123
  %192 = load float, ptr %191, align 4, !dbg !123
  %193 = insertelement <2 x float> poison, float %192, i32 0, !dbg !123
  %194 = shufflevector <2 x float> %193, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !123
  %195 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %99, <2 x float> %194, <2 x float> %189), !dbg !123
  %196 = add i64 %17, 16, !dbg !122
  br label %16, !dbg !122

197:                                              ; preds = %16
  %198 = getelementptr float, ptr %15, i64 0, !dbg !123
  store <2 x float> %18, ptr %198, align 4, !dbg !123
  ret i32 0, !dbg !124
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <16 x float> @llvm.fmuladd.v16f32(<16 x float>, <16 x float>, <16 x float>) #2

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
  store i16 %36, ptr %2, align 4, !tbaa !125
  %37 = load float, ptr %2, align 4, !tbaa !127
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
  store i16 %37, ptr %2, align 4, !tbaa !125
  %38 = load float, ptr %2, align 4, !tbaa !127
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
  store volatile float %5, ptr %3, align 4, !tbaa !127
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !127
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
  store volatile float %16, ptr %3, align 4, !tbaa !127
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
  store volatile float %24, ptr %2, align 4, !tbaa !127
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
  br i1 %.not, label %19, label %6, !prof !129

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
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !130
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !133
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !134
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !136
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !136
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !136
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
  store volatile float %16, ptr %3, align 4, !tbaa !127
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
  store volatile float %23, ptr %2, align 4, !tbaa !127
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
  store volatile float %2, ptr %4, align 4, !tbaa !127
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !127
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
  %10 = load i32, ptr %1, align 4, !tbaa !11
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !11
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !11
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
  br i1 %or.cond99, label %.critedge, label %73, !prof !137

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !129

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
  br i1 %31, label %47, label %32, !prof !129

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
  store volatile float %46, ptr %3, align 4, !tbaa !127
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !127
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
  %82 = load double, ptr %81, align 8, !tbaa !138
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !140
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !136
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !136
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !136
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !136
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !136
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !141

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
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !142
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !134
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !136
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !136
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !136
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
  store volatile float %9, ptr %2, align 4, !tbaa !127
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

!llvm.dbg.cu = !{!0, !2, !4, !6}
!llvm.module.flags = !{!8, !9, !10}
!llvm.errno.tbaa = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/multibranch")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/multibranch")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/multibranch")
!6 = distinct !DICompileUnit(language: DW_LANG_C17, file: !7, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!7 = !DIFile(filename: "configured_module_infer_dispatch_3.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/multibranch")
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C/C++ TBAA"}
!15 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x64x16_f32", linkageName: "infer_dispatch_0_matmul_1x64x16_f32", scope: !1, file: !1, line: 1, type: !16, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!16 = !DISubroutineType(cc: DW_CC_normal, types: !17)
!17 = !{!18, !19, !50, !79}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !22)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !23, file: !23, line: 246, size: 768, elements: !24)
!23 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!24 = !{!25, !33, !36, !39, !41}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, scope: !23, file: !23, line: 227, baseType: !29, size: 2048, elements: !31)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !30)
!30 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!31 = !{!32}
!32 = !DISubrange(count: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !34, size: 64, offset: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !37, size: 64, offset: 128)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !40, size: 64, offset: 192)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !42, offset: 256)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !23, file: !23, line: 227, size: 512, elements: !43)
!43 = !{!44}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !45)
!45 = !DICompositeType(tag: DW_TAG_array_type, scope: !23, file: !23, line: 227, baseType: !46, size: 512, elements: !48)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !47)
!47 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!48 = !{!49}
!49 = !DISubrange(count: 8)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !23, file: !23, line: 275, size: 384, elements: !54)
!54 = !{!55, !56, !57, !60, !61, !62, !63, !64, !67, !68, !69, !74}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !29, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !29, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !58, size: 16, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !59)
!59 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !58, size: 16, offset: 80)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !29, size: 32, offset: 96)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !29, size: 32, offset: 128)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !58, size: 16, offset: 160)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !65, size: 8, offset: 176)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !66)
!66 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !65, size: 8, offset: 184)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !26, size: 64, offset: 192)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !70, size: 64, offset: 256)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !72)
!72 = !DICompositeType(tag: DW_TAG_array_type, scope: !23, file: !23, line: 227, baseType: !73, size: 4096, elements: !31)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !75, size: 64, offset: 320)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !77)
!77 = !DICompositeType(tag: DW_TAG_array_type, scope: !23, file: !23, line: 227, baseType: !78, size: 4096, elements: !31)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !46)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !81)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !82)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !23, file: !23, line: 321, size: 256, elements: !83)
!83 = !{!84, !85, !86, !87, !88, !89, !90}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !29, size: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !29, size: 32, offset: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !58, size: 16, offset: 64)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !58, size: 16, offset: 80)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !29, size: 32, offset: 96)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !34, size: 64, offset: 128)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !29, size: 32, offset: 192)
!91 = !DILocation(line: 12, column: 8, scope: !15)
!92 = !DILocation(line: 13, column: 8, scope: !15)
!93 = !DILocation(line: 14, column: 8, scope: !15)
!94 = !DILocation(line: 19, column: 8, scope: !15)
!95 = !DILocation(line: 1, column: 1, scope: !15)
!96 = !DILocation(line: 22, column: 10, scope: !15)
!97 = !DILocation(line: 26, column: 8, scope: !15)
!98 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x64x64_f32", linkageName: "infer_dispatch_1_matmul_1x64x64_f32", scope: !3, file: !3, line: 1, type: !16, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!99 = !DILocation(line: 13, column: 8, scope: !98)
!100 = !DILocation(line: 14, column: 8, scope: !98)
!101 = !DILocation(line: 15, column: 8, scope: !98)
!102 = !DILocation(line: 20, column: 8, scope: !98)
!103 = !DILocation(line: 1, column: 1, scope: !98)
!104 = !DILocation(line: 22, column: 8, scope: !98)
!105 = distinct !DISubprogram(name: "infer_dispatch_2_matmul_1x64x64_f32", linkageName: "infer_dispatch_2_matmul_1x64x64_f32", scope: !5, file: !5, line: 1, type: !16, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!106 = !DILocation(line: 14, column: 8, scope: !105)
!107 = !DILocation(line: 15, column: 8, scope: !105)
!108 = !DILocation(line: 16, column: 8, scope: !105)
!109 = !DILocation(line: 17, column: 8, scope: !105)
!110 = !DILocation(line: 23, column: 8, scope: !105)
!111 = !DILocation(line: 1, column: 1, scope: !105)
!112 = !DILocation(line: 24, column: 8, scope: !105)
!113 = !DILocation(line: 26, column: 10, scope: !105)
!114 = !DILocation(line: 27, column: 10, scope: !105)
!115 = !DILocation(line: 28, column: 10, scope: !105)
!116 = !DILocation(line: 29, column: 10, scope: !105)
!117 = !DILocation(line: 33, column: 8, scope: !105)
!118 = distinct !DISubprogram(name: "infer_dispatch_3_matmul_1x2x64_f32", linkageName: "infer_dispatch_3_matmul_1x2x64_f32", scope: !7, file: !7, line: 1, type: !16, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!119 = !DILocation(line: 12, column: 8, scope: !118)
!120 = !DILocation(line: 13, column: 8, scope: !118)
!121 = !DILocation(line: 14, column: 8, scope: !118)
!122 = !DILocation(line: 19, column: 8, scope: !118)
!123 = !DILocation(line: 1, column: 1, scope: !118)
!124 = !DILocation(line: 21, column: 8, scope: !118)
!125 = !{!126, !126, i64 0}
!126 = !{!"short", !13, i64 0}
!127 = !{!128, !128, i64 0}
!128 = !{!"float", !13, i64 0}
!129 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!130 = !{!131, !132, i64 296}
!131 = !{!"exp2f_data", !13, i64 0, !132, i64 256, !13, i64 264, !132, i64 288, !132, i64 296, !13, i64 304}
!132 = !{!"double", !13, i64 0}
!133 = !{!131, !132, i64 288}
!134 = !{!135, !135, i64 0}
!135 = !{!"long", !13, i64 0}
!136 = !{!132, !132, i64 0}
!137 = !{!"branch_weights", i32 4001, i32 4000000}
!138 = !{!139, !132, i64 0}
!139 = !{!"", !132, i64 0, !132, i64 8}
!140 = !{!139, !132, i64 8}
!141 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!142 = !{!131, !132, i64 256}
