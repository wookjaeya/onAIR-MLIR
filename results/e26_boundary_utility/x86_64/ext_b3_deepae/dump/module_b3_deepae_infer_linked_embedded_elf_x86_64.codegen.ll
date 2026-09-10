; ModuleID = 'b3_deepae_infer_linked'
source_filename = "b3_deepae_infer_linked"
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

@__constant_1x8xf32 = private constant [1 x [8 x float]] [[8 x float] [float 0x40013F03A0000000, float 0x4003E6B640000000, float 0x40034DCDA0000000, float 0x400354D6A0000000, float 0x3FFF7649E0000000, float 0x4001DC7860000000, float 0x4005D58F00000000, float 0x40001FE060000000]], align 64
@0 = private constant [23 x i8] c"b3_deepae_infer_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [5 x ptr] [ptr @infer_dispatch_0_matmul_1x128x640_f32, ptr @infer_dispatch_1_matmul_1x128x128_f32, ptr @infer_dispatch_4_matmul_1x8x128_f32, ptr @infer_dispatch_5_matmul_1x128x8_f32, ptr @infer_dispatch_9_matmul_1x640x128_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [5 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [38 x i8] c"infer_dispatch_0_matmul_1x128x640_f32\00", align 1
@2 = private constant [38 x i8] c"infer_dispatch_1_matmul_1x128x128_f32\00", align 1
@3 = private constant [36 x i8] c"infer_dispatch_4_matmul_1x8x128_f32\00", align 1
@4 = private constant [36 x i8] c"infer_dispatch_5_matmul_1x128x8_f32\00", align 1
@5 = private constant [38 x i8] c"infer_dispatch_9_matmul_1x640x128_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [5 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5]
@6 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@7 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@8 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@9 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@10 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_9.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [5 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @6 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @7 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @8 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @9 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @10 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x128x640_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x128x640_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x128x128_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x128x128_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_1x8x128_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_1x8x128_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_matmul_1x128x8_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_matmul_1x128x8_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_1x640x128_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_1x640x128_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [5 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x128x640_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x128x640_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x128x128_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x128x128_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_1x8x128_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_1x8x128_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_matmul_1x128x8_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_matmul_1x128x8_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_1x640x128_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_1x640x128_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 5, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_matmul_1x128x640_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !11 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !87
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !87
  %6 = load ptr, ptr %5, align 8, !dbg !87
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !87
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !88
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !88
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !88
  %10 = load ptr, ptr %9, align 8, !dbg !88
  %11 = getelementptr float, ptr %10, i64 183936, !dbg !88
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !88
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !89
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !89
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !89
  %15 = load ptr, ptr %14, align 8, !dbg !89
  %16 = getelementptr float, ptr %15, i64 1536, !dbg !89
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !89
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !90
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !90
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !90
  %20 = load ptr, ptr %19, align 8, !dbg !90
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !90
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !91
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !91
  %23 = zext i32 %22 to i64, !dbg !91
  %24 = mul nsw i64 %23, 64, !dbg !91
  br label %25, !dbg !91

25:                                               ; preds = %71, %3
  %26 = phi i64 [ %81, %71 ], [ 0, %3 ], !dbg !91
  %27 = icmp slt i64 %26, 64, !dbg !91
  br i1 %27, label %28, label %82, !dbg !91

28:                                               ; preds = %25
  %29 = add i64 %26, %24, !dbg !91
  br label %30, !dbg !91

30:                                               ; preds = %34, %28
  %31 = phi i64 [ %70, %34 ], [ 0, %28 ], !dbg !91
  %32 = phi <1 x float> [ %69, %34 ], [ zeroinitializer, %28 ], !dbg !91
  %33 = icmp slt i64 %31, 640, !dbg !91
  br i1 %33, label %34, label %71, !dbg !91

34:                                               ; preds = %30
  %35 = mul i64 %29, 640, !dbg !91
  %36 = add i64 %35, %31, !dbg !91
  %37 = getelementptr float, ptr %11, i64 %36, !dbg !91
  %38 = load <4 x float>, ptr %37, align 4, !dbg !91
  %39 = extractelement <4 x float> %38, i64 0
  %40 = insertelement <1 x float> poison, float %39, i64 0
  %41 = extractelement <4 x float> %38, i64 1
  %42 = insertelement <1 x float> poison, float %41, i64 0
  %43 = extractelement <4 x float> %38, i64 2
  %44 = insertelement <1 x float> poison, float %43, i64 0
  %45 = extractelement <4 x float> %38, i64 3
  %46 = insertelement <1 x float> poison, float %45, i64 0
  %47 = add nuw nsw i64 0, %31
  %48 = getelementptr inbounds nuw float, ptr %6, i64 %47
  %49 = load float, ptr %48, align 4
  %50 = insertelement <1 x float> poison, float %49, i32 0
  %51 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %40, <1 x float> %50, <1 x float> %32)
  %52 = add i64 %31, 1
  %53 = add nuw nsw i64 0, %52
  %54 = getelementptr inbounds nuw float, ptr %6, i64 %53
  %55 = load float, ptr %54, align 4
  %56 = insertelement <1 x float> poison, float %55, i32 0
  %57 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %42, <1 x float> %56, <1 x float> %51)
  %58 = add i64 %31, 2
  %59 = add nuw nsw i64 0, %58
  %60 = getelementptr inbounds nuw float, ptr %6, i64 %59
  %61 = load float, ptr %60, align 4
  %62 = insertelement <1 x float> poison, float %61, i32 0
  %63 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %62, <1 x float> %57)
  %64 = add i64 %31, 3
  %65 = add nuw nsw i64 0, %64
  %66 = getelementptr inbounds nuw float, ptr %6, i64 %65
  %67 = load float, ptr %66, align 4
  %68 = insertelement <1 x float> poison, float %67, i32 0
  %69 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %46, <1 x float> %68, <1 x float> %63)
  %70 = add i64 %31, 4, !dbg !91
  br label %30, !dbg !91

71:                                               ; preds = %30
  %72 = add i64 0, %29, !dbg !92
  %73 = getelementptr float, ptr %16, i64 %72, !dbg !92
  %74 = load <1 x float>, ptr %73, align 4, !dbg !92
  %75 = fadd contract <1 x float> %32, %74, !dbg !93
  %76 = fcmp ugt <1 x float> %75, zeroinitializer, !dbg !94
  %77 = select <1 x i1> %76, <1 x float> %75, <1 x float> zeroinitializer, !dbg !95
  %78 = extractelement <1 x float> %77, i64 0, !dbg !91
  %79 = add nuw nsw i64 0, %29, !dbg !91
  %80 = getelementptr inbounds nuw float, ptr %20, i64 %79, !dbg !91
  store float %78, ptr %80, align 4, !dbg !91
  %81 = add i64 %26, 1, !dbg !91
  br label %25, !dbg !91

82:                                               ; preds = %25
  ret i32 0, !dbg !96
}

define internal i32 @infer_dispatch_1_matmul_1x128x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !97 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !98
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !98
  %6 = load i32, ptr %5, align 4, !dbg !98
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !99
  %8 = load i32, ptr %7, align 4, !dbg !99
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !100
  %10 = load i32, ptr %9, align 4, !dbg !100
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !101
  %12 = load i32, ptr %11, align 4, !dbg !101
  %13 = zext i32 %6 to i64, !dbg !102
  %14 = zext i32 %8 to i64, !dbg !103
  %15 = zext i32 %10 to i64, !dbg !104
  %16 = zext i32 %12 to i64, !dbg !105
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !106
  %18 = load ptr, ptr %17, align 8, !dbg !106
  %19 = mul i64 %13, 8, !dbg !106
  %20 = udiv i64 %19, 32, !dbg !106
  %21 = getelementptr float, ptr %18, i64 %20, !dbg !106
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !106
  %22 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !107
  %23 = extractvalue %iree_hal_executable_dispatch_state_v0_t %22, 10, !dbg !107
  %24 = getelementptr ptr, ptr %23, i32 1, !dbg !107
  %25 = load ptr, ptr %24, align 8, !dbg !107
  %26 = mul i64 %14, 8, !dbg !107
  %27 = udiv i64 %26, 32, !dbg !107
  %28 = getelementptr float, ptr %25, i64 %27, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %28, i64 64) ], !dbg !107
  %29 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %30 = extractvalue %iree_hal_executable_dispatch_state_v0_t %29, 10, !dbg !108
  %31 = getelementptr ptr, ptr %30, i32 1, !dbg !108
  %32 = load ptr, ptr %31, align 8, !dbg !108
  %33 = mul i64 %15, 8, !dbg !108
  %34 = udiv i64 %33, 32, !dbg !108
  %35 = getelementptr float, ptr %32, i64 %34, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %35, i64 64) ], !dbg !108
  %36 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %37 = extractvalue %iree_hal_executable_dispatch_state_v0_t %36, 10, !dbg !109
  %38 = getelementptr ptr, ptr %37, i32 2, !dbg !109
  %39 = load ptr, ptr %38, align 8, !dbg !109
  %40 = mul i64 %16, 8, !dbg !109
  %41 = udiv i64 %40, 32, !dbg !109
  %42 = getelementptr float, ptr %39, i64 %41, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %42, i64 64) ], !dbg !109
  %43 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !110
  %44 = extractvalue %iree_hal_executable_workgroup_state_v0_t %43, 0, !dbg !110
  %45 = zext i32 %44 to i64, !dbg !110
  %46 = mul nsw i64 %45, 64, !dbg !110
  br label %47, !dbg !110

47:                                               ; preds = %93, %3
  %48 = phi i64 [ %103, %93 ], [ 0, %3 ], !dbg !110
  %49 = icmp slt i64 %48, 64, !dbg !110
  br i1 %49, label %50, label %104, !dbg !110

50:                                               ; preds = %47
  %51 = add i64 %48, %46, !dbg !110
  br label %52, !dbg !110

52:                                               ; preds = %56, %50
  %53 = phi i64 [ %92, %56 ], [ 0, %50 ], !dbg !110
  %54 = phi <1 x float> [ %91, %56 ], [ zeroinitializer, %50 ], !dbg !110
  %55 = icmp slt i64 %53, 128, !dbg !110
  br i1 %55, label %56, label %93, !dbg !110

56:                                               ; preds = %52
  %57 = mul i64 %51, 128, !dbg !110
  %58 = add i64 %57, %53, !dbg !110
  %59 = getelementptr float, ptr %28, i64 %58, !dbg !110
  %60 = load <4 x float>, ptr %59, align 4, !dbg !110
  %61 = extractelement <4 x float> %60, i64 0
  %62 = insertelement <1 x float> poison, float %61, i64 0
  %63 = extractelement <4 x float> %60, i64 1
  %64 = insertelement <1 x float> poison, float %63, i64 0
  %65 = extractelement <4 x float> %60, i64 2
  %66 = insertelement <1 x float> poison, float %65, i64 0
  %67 = extractelement <4 x float> %60, i64 3
  %68 = insertelement <1 x float> poison, float %67, i64 0
  %69 = add nuw nsw i64 0, %53
  %70 = getelementptr inbounds nuw float, ptr %21, i64 %69
  %71 = load float, ptr %70, align 4
  %72 = insertelement <1 x float> poison, float %71, i32 0
  %73 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %72, <1 x float> %54)
  %74 = add i64 %53, 1
  %75 = add nuw nsw i64 0, %74
  %76 = getelementptr inbounds nuw float, ptr %21, i64 %75
  %77 = load float, ptr %76, align 4
  %78 = insertelement <1 x float> poison, float %77, i32 0
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %64, <1 x float> %78, <1 x float> %73)
  %80 = add i64 %53, 2
  %81 = add nuw nsw i64 0, %80
  %82 = getelementptr inbounds nuw float, ptr %21, i64 %81
  %83 = load float, ptr %82, align 4
  %84 = insertelement <1 x float> poison, float %83, i32 0
  %85 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %66, <1 x float> %84, <1 x float> %79)
  %86 = add i64 %53, 3
  %87 = add nuw nsw i64 0, %86
  %88 = getelementptr inbounds nuw float, ptr %21, i64 %87
  %89 = load float, ptr %88, align 4
  %90 = insertelement <1 x float> poison, float %89, i32 0
  %91 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %90, <1 x float> %85)
  %92 = add i64 %53, 4, !dbg !110
  br label %52, !dbg !110

93:                                               ; preds = %52
  %94 = add i64 0, %51, !dbg !111
  %95 = getelementptr float, ptr %35, i64 %94, !dbg !111
  %96 = load <1 x float>, ptr %95, align 4, !dbg !111
  %97 = fadd contract <1 x float> %54, %96, !dbg !112
  %98 = fcmp ugt <1 x float> %97, zeroinitializer, !dbg !113
  %99 = select <1 x i1> %98, <1 x float> %97, <1 x float> zeroinitializer, !dbg !114
  %100 = extractelement <1 x float> %99, i64 0, !dbg !110
  %101 = add nuw nsw i64 0, %51, !dbg !110
  %102 = getelementptr inbounds nuw float, ptr %42, i64 %101, !dbg !110
  store float %100, ptr %102, align 4, !dbg !110
  %103 = add i64 %48, 1, !dbg !110
  br label %47, !dbg !110

104:                                              ; preds = %47
  ret i32 0, !dbg !115
}

define internal i32 @infer_dispatch_4_matmul_1x8x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !116 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !117
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !117
  %6 = load ptr, ptr %5, align 8, !dbg !117
  %7 = getelementptr float, ptr %6, i64 128, !dbg !117
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !117
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !118
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !118
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !118
  %11 = load ptr, ptr %10, align 8, !dbg !118
  %12 = getelementptr float, ptr %11, i64 34432, !dbg !118
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !118
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !119
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !119
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !119
  %16 = load ptr, ptr %15, align 8, !dbg !119
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !119
  br label %17, !dbg !120

17:                                               ; preds = %61, %3
  %18 = phi i64 [ %71, %61 ], [ 0, %3 ], !dbg !120
  %19 = icmp slt i64 %18, 8, !dbg !120
  br i1 %19, label %20, label %72, !dbg !120

20:                                               ; preds = %24, %17
  %21 = phi i64 [ %60, %24 ], [ 0, %17 ], !dbg !120
  %22 = phi <1 x float> [ %59, %24 ], [ zeroinitializer, %17 ], !dbg !120
  %23 = icmp slt i64 %21, 128, !dbg !120
  br i1 %23, label %24, label %61, !dbg !120

24:                                               ; preds = %20
  %25 = mul i64 %18, 128, !dbg !120
  %26 = add i64 %25, %21, !dbg !120
  %27 = getelementptr float, ptr %12, i64 %26, !dbg !120
  %28 = load <4 x float>, ptr %27, align 4, !dbg !120
  %29 = extractelement <4 x float> %28, i64 0
  %30 = insertelement <1 x float> poison, float %29, i64 0
  %31 = extractelement <4 x float> %28, i64 1
  %32 = insertelement <1 x float> poison, float %31, i64 0
  %33 = extractelement <4 x float> %28, i64 2
  %34 = insertelement <1 x float> poison, float %33, i64 0
  %35 = extractelement <4 x float> %28, i64 3
  %36 = insertelement <1 x float> poison, float %35, i64 0
  %37 = add nuw nsw i64 0, %21
  %38 = getelementptr inbounds nuw float, ptr %7, i64 %37
  %39 = load float, ptr %38, align 4
  %40 = insertelement <1 x float> poison, float %39, i32 0
  %41 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %30, <1 x float> %40, <1 x float> %22)
  %42 = add i64 %21, 1
  %43 = add nuw nsw i64 0, %42
  %44 = getelementptr inbounds nuw float, ptr %7, i64 %43
  %45 = load float, ptr %44, align 4
  %46 = insertelement <1 x float> poison, float %45, i32 0
  %47 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %32, <1 x float> %46, <1 x float> %41)
  %48 = add i64 %21, 2
  %49 = add nuw nsw i64 0, %48
  %50 = getelementptr inbounds nuw float, ptr %7, i64 %49
  %51 = load float, ptr %50, align 4
  %52 = insertelement <1 x float> poison, float %51, i32 0
  %53 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %34, <1 x float> %52, <1 x float> %47)
  %54 = add i64 %21, 3
  %55 = add nuw nsw i64 0, %54
  %56 = getelementptr inbounds nuw float, ptr %7, i64 %55
  %57 = load float, ptr %56, align 4
  %58 = insertelement <1 x float> poison, float %57, i32 0
  %59 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %36, <1 x float> %58, <1 x float> %53)
  %60 = add i64 %21, 4, !dbg !120
  br label %20, !dbg !120

61:                                               ; preds = %20
  %62 = add i64 0, %18, !dbg !121
  %63 = getelementptr float, ptr @__constant_1x8xf32, i64 %62, !dbg !121
  %64 = load <1 x float>, ptr %63, align 4, !dbg !121
  %65 = fadd contract <1 x float> %22, %64, !dbg !122
  %66 = fcmp ugt <1 x float> %65, zeroinitializer, !dbg !123
  %67 = select <1 x i1> %66, <1 x float> %65, <1 x float> zeroinitializer, !dbg !124
  %68 = extractelement <1 x float> %67, i64 0, !dbg !120
  %69 = add nuw nsw i64 0, %18, !dbg !120
  %70 = getelementptr inbounds nuw float, ptr %16, i64 %69, !dbg !120
  store float %68, ptr %70, align 4, !dbg !120
  %71 = add i64 %18, 1, !dbg !120
  br label %17, !dbg !120

72:                                               ; preds = %17
  ret i32 0, !dbg !125
}

define internal i32 @infer_dispatch_5_matmul_1x128x8_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !126 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !127
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !127
  %6 = load ptr, ptr %5, align 8, !dbg !127
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !127
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !128
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !128
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !128
  %10 = load ptr, ptr %9, align 8, !dbg !128
  %11 = getelementptr float, ptr %10, i64 51840, !dbg !128
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !128
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !129
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !129
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !129
  %15 = load ptr, ptr %14, align 8, !dbg !129
  %16 = getelementptr float, ptr %15, i64 1024, !dbg !129
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !129
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !130
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !130
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !130
  %20 = load ptr, ptr %19, align 8, !dbg !130
  %21 = getelementptr float, ptr %20, i64 16, !dbg !130
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !130
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !131
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !131
  %24 = zext i32 %23 to i64, !dbg !131
  %25 = mul nsw i64 %24, 64, !dbg !131
  br label %26, !dbg !131

26:                                               ; preds = %72, %3
  %27 = phi i64 [ %82, %72 ], [ 0, %3 ], !dbg !131
  %28 = icmp slt i64 %27, 64, !dbg !131
  br i1 %28, label %29, label %83, !dbg !131

29:                                               ; preds = %26
  %30 = add i64 %27, %25, !dbg !131
  br label %31, !dbg !131

31:                                               ; preds = %35, %29
  %32 = phi i64 [ %71, %35 ], [ 0, %29 ], !dbg !131
  %33 = phi <1 x float> [ %70, %35 ], [ zeroinitializer, %29 ], !dbg !131
  %34 = icmp slt i64 %32, 8, !dbg !131
  br i1 %34, label %35, label %72, !dbg !131

35:                                               ; preds = %31
  %36 = mul i64 %30, 8, !dbg !131
  %37 = add i64 %36, %32, !dbg !131
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !131
  %39 = load <4 x float>, ptr %38, align 4, !dbg !131
  %40 = extractelement <4 x float> %39, i64 0
  %41 = insertelement <1 x float> poison, float %40, i64 0
  %42 = extractelement <4 x float> %39, i64 1
  %43 = insertelement <1 x float> poison, float %42, i64 0
  %44 = extractelement <4 x float> %39, i64 2
  %45 = insertelement <1 x float> poison, float %44, i64 0
  %46 = extractelement <4 x float> %39, i64 3
  %47 = insertelement <1 x float> poison, float %46, i64 0
  %48 = add nuw nsw i64 0, %32
  %49 = getelementptr inbounds nuw float, ptr %6, i64 %48
  %50 = load float, ptr %49, align 4
  %51 = insertelement <1 x float> poison, float %50, i32 0
  %52 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %41, <1 x float> %51, <1 x float> %33)
  %53 = add i64 %32, 1
  %54 = add nuw nsw i64 0, %53
  %55 = getelementptr inbounds nuw float, ptr %6, i64 %54
  %56 = load float, ptr %55, align 4
  %57 = insertelement <1 x float> poison, float %56, i32 0
  %58 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %43, <1 x float> %57, <1 x float> %52)
  %59 = add i64 %32, 2
  %60 = add nuw nsw i64 0, %59
  %61 = getelementptr inbounds nuw float, ptr %6, i64 %60
  %62 = load float, ptr %61, align 4
  %63 = insertelement <1 x float> poison, float %62, i32 0
  %64 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %45, <1 x float> %63, <1 x float> %58)
  %65 = add i64 %32, 3
  %66 = add nuw nsw i64 0, %65
  %67 = getelementptr inbounds nuw float, ptr %6, i64 %66
  %68 = load float, ptr %67, align 4
  %69 = insertelement <1 x float> poison, float %68, i32 0
  %70 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %47, <1 x float> %69, <1 x float> %64)
  %71 = add i64 %32, 4, !dbg !131
  br label %31, !dbg !131

72:                                               ; preds = %31
  %73 = add i64 0, %30, !dbg !132
  %74 = getelementptr float, ptr %16, i64 %73, !dbg !132
  %75 = load <1 x float>, ptr %74, align 4, !dbg !132
  %76 = fadd contract <1 x float> %33, %75, !dbg !133
  %77 = fcmp ugt <1 x float> %76, zeroinitializer, !dbg !134
  %78 = select <1 x i1> %77, <1 x float> %76, <1 x float> zeroinitializer, !dbg !135
  %79 = extractelement <1 x float> %78, i64 0, !dbg !131
  %80 = add nuw nsw i64 0, %30, !dbg !131
  %81 = getelementptr inbounds nuw float, ptr %21, i64 %80, !dbg !131
  store float %79, ptr %81, align 4, !dbg !131
  %82 = add i64 %27, 1, !dbg !131
  br label %26, !dbg !131

83:                                               ; preds = %26
  ret i32 0, !dbg !136
}

define internal i32 @infer_dispatch_9_matmul_1x640x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !137 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !138
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !138
  %6 = load ptr, ptr %5, align 8, !dbg !138
  %7 = getelementptr float, ptr %6, i64 128, !dbg !138
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !138
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !139
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !139
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !139
  %11 = load ptr, ptr %10, align 8, !dbg !139
  %12 = getelementptr float, ptr %11, i64 102016, !dbg !139
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !139
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !140
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !140
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !140
  %16 = load ptr, ptr %15, align 8, !dbg !140
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !140
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !141
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !141
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !141
  %20 = load ptr, ptr %19, align 8, !dbg !141
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !141
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !142
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !142
  %23 = zext i32 %22 to i64, !dbg !142
  %24 = mul nsw i64 %23, 64, !dbg !142
  br label %25, !dbg !142

25:                                               ; preds = %71, %3
  %26 = phi i64 [ %80, %71 ], [ 0, %3 ], !dbg !142
  %27 = icmp slt i64 %26, 64, !dbg !142
  br i1 %27, label %28, label %81, !dbg !142

28:                                               ; preds = %25
  %29 = add i64 %26, %24, !dbg !142
  br label %30, !dbg !142

30:                                               ; preds = %34, %28
  %31 = phi i64 [ %70, %34 ], [ 0, %28 ], !dbg !142
  %32 = phi <1 x float> [ %69, %34 ], [ zeroinitializer, %28 ], !dbg !142
  %33 = icmp slt i64 %31, 128, !dbg !142
  br i1 %33, label %34, label %71, !dbg !142

34:                                               ; preds = %30
  %35 = mul i64 %29, 128, !dbg !142
  %36 = add i64 %35, %31, !dbg !142
  %37 = getelementptr float, ptr %12, i64 %36, !dbg !142
  %38 = load <4 x float>, ptr %37, align 4, !dbg !142
  %39 = extractelement <4 x float> %38, i64 0
  %40 = insertelement <1 x float> poison, float %39, i64 0
  %41 = extractelement <4 x float> %38, i64 1
  %42 = insertelement <1 x float> poison, float %41, i64 0
  %43 = extractelement <4 x float> %38, i64 2
  %44 = insertelement <1 x float> poison, float %43, i64 0
  %45 = extractelement <4 x float> %38, i64 3
  %46 = insertelement <1 x float> poison, float %45, i64 0
  %47 = add nuw nsw i64 0, %31
  %48 = getelementptr inbounds nuw float, ptr %7, i64 %47
  %49 = load float, ptr %48, align 4
  %50 = insertelement <1 x float> poison, float %49, i32 0
  %51 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %40, <1 x float> %50, <1 x float> %32)
  %52 = add i64 %31, 1
  %53 = add nuw nsw i64 0, %52
  %54 = getelementptr inbounds nuw float, ptr %7, i64 %53
  %55 = load float, ptr %54, align 4
  %56 = insertelement <1 x float> poison, float %55, i32 0
  %57 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %42, <1 x float> %56, <1 x float> %51)
  %58 = add i64 %31, 2
  %59 = add nuw nsw i64 0, %58
  %60 = getelementptr inbounds nuw float, ptr %7, i64 %59
  %61 = load float, ptr %60, align 4
  %62 = insertelement <1 x float> poison, float %61, i32 0
  %63 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %62, <1 x float> %57)
  %64 = add i64 %31, 3
  %65 = add nuw nsw i64 0, %64
  %66 = getelementptr inbounds nuw float, ptr %7, i64 %65
  %67 = load float, ptr %66, align 4
  %68 = insertelement <1 x float> poison, float %67, i32 0
  %69 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %46, <1 x float> %68, <1 x float> %63)
  %70 = add i64 %31, 4, !dbg !142
  br label %30, !dbg !142

71:                                               ; preds = %30
  %72 = add i64 0, %29, !dbg !143
  %73 = getelementptr float, ptr %16, i64 %72, !dbg !143
  %74 = load <1 x float>, ptr %73, align 4, !dbg !143
  %75 = extractelement <1 x float> %32, i64 0, !dbg !144
  %76 = extractelement <1 x float> %74, i64 0, !dbg !144
  %77 = fadd contract float %75, %76, !dbg !144
  %78 = add nuw nsw i64 0, %29, !dbg !142
  %79 = getelementptr inbounds nuw float, ptr %20, i64 %78, !dbg !142
  store float %77, ptr %79, align 4, !dbg !142
  %80 = add i64 %26, 1, !dbg !142
  br label %25, !dbg !142

81:                                               ; preds = %25
  ret i32 0, !dbg !145
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <1 x float> @llvm.fmuladd.v1f32(<1 x float>, <1 x float>, <1 x float>) #2

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

!llvm.dbg.cu = !{!0, !2, !4, !6, !8}
!llvm.module.flags = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "dump")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "dump")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_4.mlir", directory: "dump")
!6 = distinct !DICompileUnit(language: DW_LANG_C17, file: !7, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!7 = !DIFile(filename: "configured_module_infer_dispatch_5.mlir", directory: "dump")
!8 = distinct !DICompileUnit(language: DW_LANG_C17, file: !9, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!9 = !DIFile(filename: "configured_module_infer_dispatch_9.mlir", directory: "dump")
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x128x640_f32", linkageName: "infer_dispatch_0_matmul_1x128x640_f32", scope: !1, file: !1, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
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
!87 = !DILocation(line: 13, column: 8, scope: !11)
!88 = !DILocation(line: 14, column: 8, scope: !11)
!89 = !DILocation(line: 15, column: 8, scope: !11)
!90 = !DILocation(line: 16, column: 8, scope: !11)
!91 = !DILocation(line: 22, column: 8, scope: !11)
!92 = !DILocation(line: 23, column: 8, scope: !11)
!93 = !DILocation(line: 25, column: 10, scope: !11)
!94 = !DILocation(line: 26, column: 10, scope: !11)
!95 = !DILocation(line: 27, column: 10, scope: !11)
!96 = !DILocation(line: 31, column: 8, scope: !11)
!97 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x128x128_f32", linkageName: "infer_dispatch_1_matmul_1x128x128_f32", scope: !3, file: !3, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!98 = !DILocation(line: 10, column: 8, scope: !97)
!99 = !DILocation(line: 11, column: 8, scope: !97)
!100 = !DILocation(line: 12, column: 8, scope: !97)
!101 = !DILocation(line: 13, column: 8, scope: !97)
!102 = !DILocation(line: 14, column: 8, scope: !97)
!103 = !DILocation(line: 15, column: 8, scope: !97)
!104 = !DILocation(line: 16, column: 8, scope: !97)
!105 = !DILocation(line: 17, column: 8, scope: !97)
!106 = !DILocation(line: 24, column: 8, scope: !97)
!107 = !DILocation(line: 25, column: 8, scope: !97)
!108 = !DILocation(line: 26, column: 8, scope: !97)
!109 = !DILocation(line: 27, column: 8, scope: !97)
!110 = !DILocation(line: 33, column: 8, scope: !97)
!111 = !DILocation(line: 34, column: 8, scope: !97)
!112 = !DILocation(line: 36, column: 10, scope: !97)
!113 = !DILocation(line: 37, column: 10, scope: !97)
!114 = !DILocation(line: 38, column: 10, scope: !97)
!115 = !DILocation(line: 42, column: 8, scope: !97)
!116 = distinct !DISubprogram(name: "infer_dispatch_4_matmul_1x8x128_f32", linkageName: "infer_dispatch_4_matmul_1x8x128_f32", scope: !5, file: !5, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!117 = !DILocation(line: 14, column: 8, scope: !116)
!118 = !DILocation(line: 15, column: 8, scope: !116)
!119 = !DILocation(line: 16, column: 8, scope: !116)
!120 = !DILocation(line: 21, column: 8, scope: !116)
!121 = !DILocation(line: 22, column: 8, scope: !116)
!122 = !DILocation(line: 24, column: 10, scope: !116)
!123 = !DILocation(line: 25, column: 10, scope: !116)
!124 = !DILocation(line: 26, column: 10, scope: !116)
!125 = !DILocation(line: 30, column: 8, scope: !116)
!126 = distinct !DISubprogram(name: "infer_dispatch_5_matmul_1x128x8_f32", linkageName: "infer_dispatch_5_matmul_1x128x8_f32", scope: !7, file: !7, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!127 = !DILocation(line: 14, column: 8, scope: !126)
!128 = !DILocation(line: 15, column: 8, scope: !126)
!129 = !DILocation(line: 16, column: 8, scope: !126)
!130 = !DILocation(line: 17, column: 8, scope: !126)
!131 = !DILocation(line: 23, column: 8, scope: !126)
!132 = !DILocation(line: 24, column: 8, scope: !126)
!133 = !DILocation(line: 26, column: 10, scope: !126)
!134 = !DILocation(line: 27, column: 10, scope: !126)
!135 = !DILocation(line: 28, column: 10, scope: !126)
!136 = !DILocation(line: 32, column: 8, scope: !126)
!137 = distinct !DISubprogram(name: "infer_dispatch_9_matmul_1x640x128_f32", linkageName: "infer_dispatch_9_matmul_1x640x128_f32", scope: !9, file: !9, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!138 = !DILocation(line: 13, column: 8, scope: !137)
!139 = !DILocation(line: 14, column: 8, scope: !137)
!140 = !DILocation(line: 15, column: 8, scope: !137)
!141 = !DILocation(line: 16, column: 8, scope: !137)
!142 = !DILocation(line: 22, column: 8, scope: !137)
!143 = !DILocation(line: 23, column: 8, scope: !137)
!144 = !DILocation(line: 25, column: 10, scope: !137)
!145 = !DILocation(line: 29, column: 8, scope: !137)
