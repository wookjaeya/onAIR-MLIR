; ModuleID = 'm16k_baked_linked'
source_filename = "m16k_baked_linked"
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
%iree_hal_executable_dispatch_state_v0_t = type { i32, i32, i16, i16, i32, i32, i16, i8, i8, ptr, ptr, ptr }
%iree_hal_executable_workgroup_state_v0_t = type { i32, i32, i16, i16, i32, ptr, i32 }

@0 = private constant [18 x i8] c"m16k_baked_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [2 x ptr] [ptr @infer_dispatch_0_matmul_1x16384x9_f32, ptr @infer_dispatch_1_matmul_1x2x16384_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [38 x i8] c"infer_dispatch_0_matmul_1x16384x9_f32\00", align 1
@2 = private constant [38 x i8] c"infer_dispatch_1_matmul_1x2x16384_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [2 x ptr] [ptr @1, ptr @2]
@3 = private constant [54 x i8] c"/tmp/e13/host/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [54 x i8] c"/tmp/e13/host/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 53, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 53, ptr @4 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x16384x9_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x16384x9_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x2x16384_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x2x16384_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [2 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x16384x9_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x16384x9_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x2x16384_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x2x16384_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 2, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_matmul_1x16384x9_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !5 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !81
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !81
  %6 = load ptr, ptr %5, align 8, !dbg !81
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !81
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !82
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !82
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !82
  %10 = load ptr, ptr %9, align 8, !dbg !82
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !82
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !83
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !83
  %13 = getelementptr ptr, ptr %12, i32 2, !dbg !83
  %14 = load ptr, ptr %13, align 8, !dbg !83
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !83
  %15 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !84
  %16 = extractvalue %iree_hal_executable_workgroup_state_v0_t %15, 0, !dbg !84
  %17 = zext i32 %16 to i64, !dbg !84
  %18 = mul nsw i64 %17, 64, !dbg !84
  br label %19, !dbg !84

19:                                               ; preds = %22, %3
  %20 = phi i64 [ %97, %22 ], [ 0, %3 ], !dbg !84
  %21 = icmp slt i64 %20, 64, !dbg !84
  br i1 %21, label %22, label %98, !dbg !84

22:                                               ; preds = %19
  %23 = add i64 %20, %18, !dbg !84
  %24 = add i64 0, %23, !dbg !84
  %25 = getelementptr float, ptr %10, i64 %24, !dbg !84
  %26 = load <32 x float>, ptr %25, align 4, !dbg !84
  %27 = add i64 16384, %23, !dbg !84
  %28 = getelementptr float, ptr %10, i64 %27, !dbg !84
  %29 = load <32 x float>, ptr %28, align 4, !dbg !84
  %30 = add i64 32768, %23, !dbg !84
  %31 = getelementptr float, ptr %10, i64 %30, !dbg !84
  %32 = load <32 x float>, ptr %31, align 4, !dbg !84
  %33 = add i64 49152, %23, !dbg !84
  %34 = getelementptr float, ptr %10, i64 %33, !dbg !84
  %35 = load <32 x float>, ptr %34, align 4, !dbg !84
  %36 = add i64 65536, %23, !dbg !84
  %37 = getelementptr float, ptr %10, i64 %36, !dbg !84
  %38 = load <32 x float>, ptr %37, align 4, !dbg !84
  %39 = add i64 81920, %23, !dbg !84
  %40 = getelementptr float, ptr %10, i64 %39, !dbg !84
  %41 = load <32 x float>, ptr %40, align 4, !dbg !84
  %42 = add i64 98304, %23, !dbg !84
  %43 = getelementptr float, ptr %10, i64 %42, !dbg !84
  %44 = load <32 x float>, ptr %43, align 4, !dbg !84
  %45 = add i64 114688, %23, !dbg !84
  %46 = getelementptr float, ptr %10, i64 %45, !dbg !84
  %47 = load <32 x float>, ptr %46, align 4, !dbg !84
  %48 = add i64 131072, %23, !dbg !84
  %49 = getelementptr float, ptr %10, i64 %48, !dbg !84
  %50 = load <32 x float>, ptr %49, align 4, !dbg !84
  %51 = getelementptr inbounds nuw float, ptr %6, i64 0, !dbg !85
  %52 = load float, ptr %51, align 4, !dbg !85
  %53 = insertelement <32 x float> poison, float %52, i32 0, !dbg !85
  %54 = shufflevector <32 x float> %53, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %55 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %26, <32 x float> %54, <32 x float> zeroinitializer), !dbg !85
  %56 = getelementptr inbounds nuw float, ptr %6, i64 1, !dbg !85
  %57 = load float, ptr %56, align 4, !dbg !85
  %58 = insertelement <32 x float> poison, float %57, i32 0, !dbg !85
  %59 = shufflevector <32 x float> %58, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %60 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %29, <32 x float> %59, <32 x float> %55), !dbg !85
  %61 = getelementptr inbounds nuw float, ptr %6, i64 2, !dbg !85
  %62 = load float, ptr %61, align 4, !dbg !85
  %63 = insertelement <32 x float> poison, float %62, i32 0, !dbg !85
  %64 = shufflevector <32 x float> %63, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %65 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %32, <32 x float> %64, <32 x float> %60), !dbg !85
  %66 = getelementptr inbounds nuw float, ptr %6, i64 3, !dbg !85
  %67 = load float, ptr %66, align 4, !dbg !85
  %68 = insertelement <32 x float> poison, float %67, i32 0, !dbg !85
  %69 = shufflevector <32 x float> %68, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %70 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %35, <32 x float> %69, <32 x float> %65), !dbg !85
  %71 = getelementptr inbounds nuw float, ptr %6, i64 4, !dbg !85
  %72 = load float, ptr %71, align 4, !dbg !85
  %73 = insertelement <32 x float> poison, float %72, i32 0, !dbg !85
  %74 = shufflevector <32 x float> %73, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %75 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %38, <32 x float> %74, <32 x float> %70), !dbg !85
  %76 = getelementptr inbounds nuw float, ptr %6, i64 5, !dbg !85
  %77 = load float, ptr %76, align 4, !dbg !85
  %78 = insertelement <32 x float> poison, float %77, i32 0, !dbg !85
  %79 = shufflevector <32 x float> %78, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %80 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %41, <32 x float> %79, <32 x float> %75), !dbg !85
  %81 = getelementptr inbounds nuw float, ptr %6, i64 6, !dbg !85
  %82 = load float, ptr %81, align 4, !dbg !85
  %83 = insertelement <32 x float> poison, float %82, i32 0, !dbg !85
  %84 = shufflevector <32 x float> %83, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %85 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %44, <32 x float> %84, <32 x float> %80), !dbg !85
  %86 = getelementptr inbounds nuw float, ptr %6, i64 7, !dbg !85
  %87 = load float, ptr %86, align 4, !dbg !85
  %88 = insertelement <32 x float> poison, float %87, i32 0, !dbg !85
  %89 = shufflevector <32 x float> %88, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %90 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %47, <32 x float> %89, <32 x float> %85), !dbg !85
  %91 = getelementptr inbounds nuw float, ptr %6, i64 8, !dbg !85
  %92 = load float, ptr %91, align 4, !dbg !85
  %93 = insertelement <32 x float> poison, float %92, i32 0, !dbg !85
  %94 = shufflevector <32 x float> %93, <32 x float> poison, <32 x i32> zeroinitializer, !dbg !85
  %95 = call <32 x float> @llvm.fmuladd.v32f32(<32 x float> %50, <32 x float> %94, <32 x float> %90), !dbg !85
  %96 = getelementptr float, ptr %14, i64 %24, !dbg !84
  store <32 x float> %95, ptr %96, align 4, !dbg !84
  %97 = add i64 %20, 32, !dbg !84
  br label %19, !dbg !84

98:                                               ; preds = %19
  ret i32 0, !dbg !86
}

define internal i32 @infer_dispatch_1_matmul_1x2x16384_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !87 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !88
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !88
  %6 = load ptr, ptr %5, align 8, !dbg !88
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !88
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !89
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !89
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !89
  %10 = load ptr, ptr %9, align 8, !dbg !89
  %11 = getelementptr float, ptr %10, i64 147456, !dbg !89
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !89
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !90
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !90
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !90
  %15 = load ptr, ptr %14, align 8, !dbg !90
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !90
  br label %16, !dbg !91

16:                                               ; preds = %20, %3
  %17 = phi i64 [ %196, %20 ], [ 0, %3 ], !dbg !91
  %18 = phi <2 x float> [ %195, %20 ], [ zeroinitializer, %3 ], !dbg !91
  %19 = icmp slt i64 %17, 16384, !dbg !91
  br i1 %19, label %20, label %197, !dbg !91

20:                                               ; preds = %16
  %21 = mul i64 %17, 2, !dbg !91
  %22 = add i64 %21, 0, !dbg !91
  %23 = getelementptr float, ptr %11, i64 %22, !dbg !91
  %24 = load <2 x float>, ptr %23, align 4, !dbg !91
  %25 = add i64 %17, 1, !dbg !91
  %26 = mul i64 %25, 2, !dbg !91
  %27 = add i64 %26, 0, !dbg !91
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !91
  %29 = load <2 x float>, ptr %28, align 4, !dbg !91
  %30 = add i64 %17, 2, !dbg !91
  %31 = mul i64 %30, 2, !dbg !91
  %32 = add i64 %31, 0, !dbg !91
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !91
  %34 = load <2 x float>, ptr %33, align 4, !dbg !91
  %35 = add i64 %17, 3, !dbg !91
  %36 = mul i64 %35, 2, !dbg !91
  %37 = add i64 %36, 0, !dbg !91
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !91
  %39 = load <2 x float>, ptr %38, align 4, !dbg !91
  %40 = add i64 %17, 4, !dbg !91
  %41 = mul i64 %40, 2, !dbg !91
  %42 = add i64 %41, 0, !dbg !91
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !91
  %44 = load <2 x float>, ptr %43, align 4, !dbg !91
  %45 = add i64 %17, 5, !dbg !91
  %46 = mul i64 %45, 2, !dbg !91
  %47 = add i64 %46, 0, !dbg !91
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !91
  %49 = load <2 x float>, ptr %48, align 4, !dbg !91
  %50 = add i64 %17, 6, !dbg !91
  %51 = mul i64 %50, 2, !dbg !91
  %52 = add i64 %51, 0, !dbg !91
  %53 = getelementptr float, ptr %11, i64 %52, !dbg !91
  %54 = load <2 x float>, ptr %53, align 4, !dbg !91
  %55 = add i64 %17, 7, !dbg !91
  %56 = mul i64 %55, 2, !dbg !91
  %57 = add i64 %56, 0, !dbg !91
  %58 = getelementptr float, ptr %11, i64 %57, !dbg !91
  %59 = load <2 x float>, ptr %58, align 4, !dbg !91
  %60 = add i64 %17, 8, !dbg !91
  %61 = mul i64 %60, 2, !dbg !91
  %62 = add i64 %61, 0, !dbg !91
  %63 = getelementptr float, ptr %11, i64 %62, !dbg !91
  %64 = load <2 x float>, ptr %63, align 4, !dbg !91
  %65 = add i64 %17, 9, !dbg !91
  %66 = mul i64 %65, 2, !dbg !91
  %67 = add i64 %66, 0, !dbg !91
  %68 = getelementptr float, ptr %11, i64 %67, !dbg !91
  %69 = load <2 x float>, ptr %68, align 4, !dbg !91
  %70 = add i64 %17, 10, !dbg !91
  %71 = mul i64 %70, 2, !dbg !91
  %72 = add i64 %71, 0, !dbg !91
  %73 = getelementptr float, ptr %11, i64 %72, !dbg !91
  %74 = load <2 x float>, ptr %73, align 4, !dbg !91
  %75 = add i64 %17, 11, !dbg !91
  %76 = mul i64 %75, 2, !dbg !91
  %77 = add i64 %76, 0, !dbg !91
  %78 = getelementptr float, ptr %11, i64 %77, !dbg !91
  %79 = load <2 x float>, ptr %78, align 4, !dbg !91
  %80 = add i64 %17, 12, !dbg !91
  %81 = mul i64 %80, 2, !dbg !91
  %82 = add i64 %81, 0, !dbg !91
  %83 = getelementptr float, ptr %11, i64 %82, !dbg !91
  %84 = load <2 x float>, ptr %83, align 4, !dbg !91
  %85 = add i64 %17, 13, !dbg !91
  %86 = mul i64 %85, 2, !dbg !91
  %87 = add i64 %86, 0, !dbg !91
  %88 = getelementptr float, ptr %11, i64 %87, !dbg !91
  %89 = load <2 x float>, ptr %88, align 4, !dbg !91
  %90 = add i64 %17, 14, !dbg !91
  %91 = mul i64 %90, 2, !dbg !91
  %92 = add i64 %91, 0, !dbg !91
  %93 = getelementptr float, ptr %11, i64 %92, !dbg !91
  %94 = load <2 x float>, ptr %93, align 4, !dbg !91
  %95 = add i64 %17, 15, !dbg !91
  %96 = mul i64 %95, 2, !dbg !91
  %97 = add i64 %96, 0, !dbg !91
  %98 = getelementptr float, ptr %11, i64 %97, !dbg !91
  %99 = load <2 x float>, ptr %98, align 4, !dbg !91
  %100 = add nuw nsw i64 0, %17, !dbg !92
  %101 = getelementptr inbounds nuw float, ptr %6, i64 %100, !dbg !92
  %102 = load float, ptr %101, align 4, !dbg !92
  %103 = insertelement <2 x float> poison, float %102, i32 0, !dbg !92
  %104 = shufflevector <2 x float> %103, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %105 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %24, <2 x float> %104, <2 x float> %18), !dbg !92
  %106 = add nuw nsw i64 0, %25, !dbg !92
  %107 = getelementptr inbounds nuw float, ptr %6, i64 %106, !dbg !92
  %108 = load float, ptr %107, align 4, !dbg !92
  %109 = insertelement <2 x float> poison, float %108, i32 0, !dbg !92
  %110 = shufflevector <2 x float> %109, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %111 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %29, <2 x float> %110, <2 x float> %105), !dbg !92
  %112 = add nuw nsw i64 0, %30, !dbg !92
  %113 = getelementptr inbounds nuw float, ptr %6, i64 %112, !dbg !92
  %114 = load float, ptr %113, align 4, !dbg !92
  %115 = insertelement <2 x float> poison, float %114, i32 0, !dbg !92
  %116 = shufflevector <2 x float> %115, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %117 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %34, <2 x float> %116, <2 x float> %111), !dbg !92
  %118 = add nuw nsw i64 0, %35, !dbg !92
  %119 = getelementptr inbounds nuw float, ptr %6, i64 %118, !dbg !92
  %120 = load float, ptr %119, align 4, !dbg !92
  %121 = insertelement <2 x float> poison, float %120, i32 0, !dbg !92
  %122 = shufflevector <2 x float> %121, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %123 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %39, <2 x float> %122, <2 x float> %117), !dbg !92
  %124 = add nuw nsw i64 0, %40, !dbg !92
  %125 = getelementptr inbounds nuw float, ptr %6, i64 %124, !dbg !92
  %126 = load float, ptr %125, align 4, !dbg !92
  %127 = insertelement <2 x float> poison, float %126, i32 0, !dbg !92
  %128 = shufflevector <2 x float> %127, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %129 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %44, <2 x float> %128, <2 x float> %123), !dbg !92
  %130 = add nuw nsw i64 0, %45, !dbg !92
  %131 = getelementptr inbounds nuw float, ptr %6, i64 %130, !dbg !92
  %132 = load float, ptr %131, align 4, !dbg !92
  %133 = insertelement <2 x float> poison, float %132, i32 0, !dbg !92
  %134 = shufflevector <2 x float> %133, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %135 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %49, <2 x float> %134, <2 x float> %129), !dbg !92
  %136 = add nuw nsw i64 0, %50, !dbg !92
  %137 = getelementptr inbounds nuw float, ptr %6, i64 %136, !dbg !92
  %138 = load float, ptr %137, align 4, !dbg !92
  %139 = insertelement <2 x float> poison, float %138, i32 0, !dbg !92
  %140 = shufflevector <2 x float> %139, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %141 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %54, <2 x float> %140, <2 x float> %135), !dbg !92
  %142 = add nuw nsw i64 0, %55, !dbg !92
  %143 = getelementptr inbounds nuw float, ptr %6, i64 %142, !dbg !92
  %144 = load float, ptr %143, align 4, !dbg !92
  %145 = insertelement <2 x float> poison, float %144, i32 0, !dbg !92
  %146 = shufflevector <2 x float> %145, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %147 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %59, <2 x float> %146, <2 x float> %141), !dbg !92
  %148 = add nuw nsw i64 0, %60, !dbg !92
  %149 = getelementptr inbounds nuw float, ptr %6, i64 %148, !dbg !92
  %150 = load float, ptr %149, align 4, !dbg !92
  %151 = insertelement <2 x float> poison, float %150, i32 0, !dbg !92
  %152 = shufflevector <2 x float> %151, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %153 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %64, <2 x float> %152, <2 x float> %147), !dbg !92
  %154 = add nuw nsw i64 0, %65, !dbg !92
  %155 = getelementptr inbounds nuw float, ptr %6, i64 %154, !dbg !92
  %156 = load float, ptr %155, align 4, !dbg !92
  %157 = insertelement <2 x float> poison, float %156, i32 0, !dbg !92
  %158 = shufflevector <2 x float> %157, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %159 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %69, <2 x float> %158, <2 x float> %153), !dbg !92
  %160 = add nuw nsw i64 0, %70, !dbg !92
  %161 = getelementptr inbounds nuw float, ptr %6, i64 %160, !dbg !92
  %162 = load float, ptr %161, align 4, !dbg !92
  %163 = insertelement <2 x float> poison, float %162, i32 0, !dbg !92
  %164 = shufflevector <2 x float> %163, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %165 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %74, <2 x float> %164, <2 x float> %159), !dbg !92
  %166 = add nuw nsw i64 0, %75, !dbg !92
  %167 = getelementptr inbounds nuw float, ptr %6, i64 %166, !dbg !92
  %168 = load float, ptr %167, align 4, !dbg !92
  %169 = insertelement <2 x float> poison, float %168, i32 0, !dbg !92
  %170 = shufflevector <2 x float> %169, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %171 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %79, <2 x float> %170, <2 x float> %165), !dbg !92
  %172 = add nuw nsw i64 0, %80, !dbg !92
  %173 = getelementptr inbounds nuw float, ptr %6, i64 %172, !dbg !92
  %174 = load float, ptr %173, align 4, !dbg !92
  %175 = insertelement <2 x float> poison, float %174, i32 0, !dbg !92
  %176 = shufflevector <2 x float> %175, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %177 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %84, <2 x float> %176, <2 x float> %171), !dbg !92
  %178 = add nuw nsw i64 0, %85, !dbg !92
  %179 = getelementptr inbounds nuw float, ptr %6, i64 %178, !dbg !92
  %180 = load float, ptr %179, align 4, !dbg !92
  %181 = insertelement <2 x float> poison, float %180, i32 0, !dbg !92
  %182 = shufflevector <2 x float> %181, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %183 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %89, <2 x float> %182, <2 x float> %177), !dbg !92
  %184 = add nuw nsw i64 0, %90, !dbg !92
  %185 = getelementptr inbounds nuw float, ptr %6, i64 %184, !dbg !92
  %186 = load float, ptr %185, align 4, !dbg !92
  %187 = insertelement <2 x float> poison, float %186, i32 0, !dbg !92
  %188 = shufflevector <2 x float> %187, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %189 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %94, <2 x float> %188, <2 x float> %183), !dbg !92
  %190 = add nuw nsw i64 0, %95, !dbg !92
  %191 = getelementptr inbounds nuw float, ptr %6, i64 %190, !dbg !92
  %192 = load float, ptr %191, align 4, !dbg !92
  %193 = insertelement <2 x float> poison, float %192, i32 0, !dbg !92
  %194 = shufflevector <2 x float> %193, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !92
  %195 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %99, <2 x float> %194, <2 x float> %189), !dbg !92
  %196 = add i64 %17, 16, !dbg !91
  br label %16, !dbg !91

197:                                              ; preds = %16
  %198 = getelementptr float, ptr %15, i64 0, !dbg !92
  store <2 x float> %18, ptr %198, align 4, !dbg !92
  ret i32 0, !dbg !93
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <32 x float> @llvm.fmuladd.v32f32(<32 x float>, <32 x float>, <32 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fmuladd.v2f32(<2 x float>, <2 x float>, <2 x float>) #2

; Function Attrs: uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr %1) #3 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { uwtable "nonlazybind" }

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!4}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "/tmp/e13/host")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "/tmp/e13/host")
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x16384x9_f32", linkageName: "infer_dispatch_0_matmul_1x16384x9_f32", scope: !1, file: !1, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!6 = !DISubroutineType(cc: DW_CC_normal, types: !7)
!7 = !{!8, !9, !40, !69}
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !12)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !13, file: !13, line: 246, size: 768, elements: !14)
!13 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!14 = !{!15, !23, !26, !29, !31}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !18)
!18 = !DICompositeType(tag: DW_TAG_array_type, scope: !13, file: !13, line: 227, baseType: !19, size: 2048, elements: !21)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !20)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !{!22}
!22 = !DISubrange(count: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !24, size: 64, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !27, size: 64, offset: 128)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !30, size: 64, offset: 192)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !32, offset: 256)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !13, file: !13, line: 227, size: 512, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_array_type, scope: !13, file: !13, line: 227, baseType: !36, size: 512, elements: !38)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !37)
!37 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!38 = !{!39}
!39 = !DISubrange(count: 8)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !43)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !13, file: !13, line: 275, size: 384, elements: !44)
!44 = !{!45, !46, !47, !50, !51, !52, !53, !54, !57, !58, !59, !64}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !19, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !19, size: 32, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !48, size: 16, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !49)
!49 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !48, size: 16, offset: 80)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !19, size: 32, offset: 96)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !19, size: 32, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !48, size: 16, offset: 160)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !55, size: 8, offset: 176)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !56)
!56 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !55, size: 8, offset: 184)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !16, size: 64, offset: 192)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !60, size: 64, offset: 256)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !62)
!62 = !DICompositeType(tag: DW_TAG_array_type, scope: !13, file: !13, line: 227, baseType: !63, size: 4096, elements: !21)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !65, size: 64, offset: 320)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !67)
!67 = !DICompositeType(tag: DW_TAG_array_type, scope: !13, file: !13, line: 227, baseType: !68, size: 4096, elements: !21)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !36)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !72)
!72 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !13, file: !13, line: 321, size: 256, elements: !73)
!73 = !{!74, !75, !76, !77, !78, !79, !80}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !19, size: 32)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !19, size: 32, offset: 32)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !48, size: 16, offset: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !48, size: 16, offset: 80)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !19, size: 32, offset: 96)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !24, size: 64, offset: 128)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !19, size: 32, offset: 192)
!81 = !DILocation(line: 11, column: 8, scope: !5)
!82 = !DILocation(line: 12, column: 8, scope: !5)
!83 = !DILocation(line: 13, column: 8, scope: !5)
!84 = !DILocation(line: 18, column: 8, scope: !5)
!85 = !DILocation(line: 1, column: 1, scope: !5)
!86 = !DILocation(line: 20, column: 8, scope: !5)
!87 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x2x16384_f32", linkageName: "infer_dispatch_1_matmul_1x2x16384_f32", scope: !3, file: !3, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!88 = !DILocation(line: 12, column: 8, scope: !87)
!89 = !DILocation(line: 13, column: 8, scope: !87)
!90 = !DILocation(line: 14, column: 8, scope: !87)
!91 = !DILocation(line: 19, column: 8, scope: !87)
!92 = !DILocation(line: 1, column: 1, scope: !87)
!93 = !DILocation(line: 21, column: 8, scope: !87)
