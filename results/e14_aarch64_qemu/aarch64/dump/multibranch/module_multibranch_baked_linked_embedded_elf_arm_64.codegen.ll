; ModuleID = 'multibranch_baked_linked'
source_filename = "multibranch_baked_linked"
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
%iree_hal_executable_dispatch_state_v0_t = type { i32, i32, i16, i16, i32, i32, i16, i8, i8, ptr, ptr, ptr }
%iree_hal_executable_workgroup_state_v0_t = type { i32, i32, i16, i16, i32, ptr, i32 }

@0 = private constant [25 x i8] c"multibranch_baked_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [4 x ptr] [ptr @infer_dispatch_0_matmul_1x64x16_f32, ptr @infer_dispatch_1_matmul_1x64x64_f32, ptr @infer_dispatch_2_matmul_1x64x64_f32, ptr @infer_dispatch_3_matmul_1x2x64_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [4 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [36 x i8] c"infer_dispatch_0_matmul_1x64x16_f32\00", align 1
@2 = private constant [36 x i8] c"infer_dispatch_1_matmul_1x64x64_f32\00", align 1
@3 = private constant [36 x i8] c"infer_dispatch_2_matmul_1x64x64_f32\00", align 1
@4 = private constant [35 x i8] c"infer_dispatch_3_matmul_1x2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [4 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4]
@5 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/multibranch/configured_module_infer_dispatch_0.mlir\00", align 1
@6 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/multibranch/configured_module_infer_dispatch_1.mlir\00", align 1
@7 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/multibranch/configured_module_infer_dispatch_2.mlir\00", align 1
@8 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/multibranch/configured_module_infer_dispatch_3.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [4 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @6 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @7 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @8 }]
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

define internal i32 @infer_dispatch_0_matmul_1x64x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !9 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !85
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !85
  %6 = load ptr, ptr %5, align 8, !dbg !85
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !85
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !86
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !86
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !86
  %10 = load ptr, ptr %9, align 8, !dbg !86
  %11 = getelementptr float, ptr %10, i64 8320, !dbg !86
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !86
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !87
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !87
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !87
  %15 = load ptr, ptr %14, align 8, !dbg !87
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !87
  %16 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !88
  %17 = extractvalue %iree_hal_executable_workgroup_state_v0_t %16, 0, !dbg !88
  %18 = zext i32 %17 to i64, !dbg !88
  %19 = mul nsw i64 %18, 8, !dbg !88
  br label %20, !dbg !88

20:                                               ; preds = %24, %3
  %21 = phi i64 [ %68, %24 ], [ 0, %3 ], !dbg !88
  %22 = phi <8 x float> [ %67, %24 ], [ zeroinitializer, %3 ], !dbg !88
  %23 = icmp slt i64 %21, 16, !dbg !88
  br i1 %23, label %24, label %69, !dbg !88

24:                                               ; preds = %20
  %25 = mul i64 %21, 64, !dbg !88
  %26 = add i64 %25, %19, !dbg !88
  %27 = getelementptr float, ptr %11, i64 %26, !dbg !88
  %28 = load <8 x float>, ptr %27, align 4, !dbg !88
  %29 = add i64 %21, 1, !dbg !88
  %30 = mul i64 %29, 64, !dbg !88
  %31 = add i64 %30, %19, !dbg !88
  %32 = getelementptr float, ptr %11, i64 %31, !dbg !88
  %33 = load <8 x float>, ptr %32, align 4, !dbg !88
  %34 = add i64 %21, 2, !dbg !88
  %35 = mul i64 %34, 64, !dbg !88
  %36 = add i64 %35, %19, !dbg !88
  %37 = getelementptr float, ptr %11, i64 %36, !dbg !88
  %38 = load <8 x float>, ptr %37, align 4, !dbg !88
  %39 = add i64 %21, 3, !dbg !88
  %40 = mul i64 %39, 64, !dbg !88
  %41 = add i64 %40, %19, !dbg !88
  %42 = getelementptr float, ptr %11, i64 %41, !dbg !88
  %43 = load <8 x float>, ptr %42, align 4, !dbg !88
  %44 = add nuw nsw i64 0, %21, !dbg !89
  %45 = getelementptr inbounds nuw float, ptr %6, i64 %44, !dbg !89
  %46 = load float, ptr %45, align 4, !dbg !89
  %47 = insertelement <8 x float> poison, float %46, i32 0, !dbg !89
  %48 = shufflevector <8 x float> %47, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !89
  %49 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %28, <8 x float> %48, <8 x float> %22), !dbg !89
  %50 = add nuw nsw i64 0, %29, !dbg !89
  %51 = getelementptr inbounds nuw float, ptr %6, i64 %50, !dbg !89
  %52 = load float, ptr %51, align 4, !dbg !89
  %53 = insertelement <8 x float> poison, float %52, i32 0, !dbg !89
  %54 = shufflevector <8 x float> %53, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !89
  %55 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %33, <8 x float> %54, <8 x float> %49), !dbg !89
  %56 = add nuw nsw i64 0, %34, !dbg !89
  %57 = getelementptr inbounds nuw float, ptr %6, i64 %56, !dbg !89
  %58 = load float, ptr %57, align 4, !dbg !89
  %59 = insertelement <8 x float> poison, float %58, i32 0, !dbg !89
  %60 = shufflevector <8 x float> %59, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !89
  %61 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %38, <8 x float> %60, <8 x float> %55), !dbg !89
  %62 = add nuw nsw i64 0, %39, !dbg !89
  %63 = getelementptr inbounds nuw float, ptr %6, i64 %62, !dbg !89
  %64 = load float, ptr %63, align 4, !dbg !89
  %65 = insertelement <8 x float> poison, float %64, i32 0, !dbg !89
  %66 = shufflevector <8 x float> %65, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !89
  %67 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %43, <8 x float> %66, <8 x float> %61), !dbg !89
  %68 = add i64 %21, 4, !dbg !88
  br label %20, !dbg !88

69:                                               ; preds = %20
  %70 = fcmp ugt <8 x float> %22, zeroinitializer, !dbg !90
  %71 = select <8 x i1> %70, <8 x float> %22, <8 x float> zeroinitializer, !dbg !90
  %72 = select <8 x i1> zeroinitializer, <8 x float> zeroinitializer, <8 x float> %71, !dbg !90
  %73 = add i64 0, %19, !dbg !90
  %74 = getelementptr float, ptr %15, i64 %73, !dbg !90
  store <8 x float> %72, ptr %74, align 4, !dbg !90
  ret i32 0, !dbg !91
}

define internal i32 @infer_dispatch_1_matmul_1x64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !92 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !93
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !93
  %6 = load ptr, ptr %5, align 8, !dbg !93
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !93
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !94
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !94
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !94
  %10 = load ptr, ptr %9, align 8, !dbg !94
  %11 = getelementptr float, ptr %10, i64 128, !dbg !94
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !94
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !95
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !95
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !95
  %15 = load ptr, ptr %14, align 8, !dbg !95
  %16 = getelementptr float, ptr %15, i64 64, !dbg !95
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !95
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !96
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !96
  %19 = zext i32 %18 to i64, !dbg !96
  %20 = mul nsw i64 %19, 8, !dbg !96
  br label %21, !dbg !96

21:                                               ; preds = %25, %3
  %22 = phi i64 [ %69, %25 ], [ 0, %3 ], !dbg !96
  %23 = phi <8 x float> [ %68, %25 ], [ zeroinitializer, %3 ], !dbg !96
  %24 = icmp slt i64 %22, 64, !dbg !96
  br i1 %24, label %25, label %70, !dbg !96

25:                                               ; preds = %21
  %26 = mul i64 %22, 64, !dbg !96
  %27 = add i64 %26, %20, !dbg !96
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !96
  %29 = load <8 x float>, ptr %28, align 4, !dbg !96
  %30 = add i64 %22, 1, !dbg !96
  %31 = mul i64 %30, 64, !dbg !96
  %32 = add i64 %31, %20, !dbg !96
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !96
  %34 = load <8 x float>, ptr %33, align 4, !dbg !96
  %35 = add i64 %22, 2, !dbg !96
  %36 = mul i64 %35, 64, !dbg !96
  %37 = add i64 %36, %20, !dbg !96
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !96
  %39 = load <8 x float>, ptr %38, align 4, !dbg !96
  %40 = add i64 %22, 3, !dbg !96
  %41 = mul i64 %40, 64, !dbg !96
  %42 = add i64 %41, %20, !dbg !96
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !96
  %44 = load <8 x float>, ptr %43, align 4, !dbg !96
  %45 = add nuw nsw i64 0, %22, !dbg !97
  %46 = getelementptr inbounds nuw float, ptr %6, i64 %45, !dbg !97
  %47 = load float, ptr %46, align 4, !dbg !97
  %48 = insertelement <8 x float> poison, float %47, i32 0, !dbg !97
  %49 = shufflevector <8 x float> %48, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %50 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %29, <8 x float> %49, <8 x float> %23), !dbg !97
  %51 = add nuw nsw i64 0, %30, !dbg !97
  %52 = getelementptr inbounds nuw float, ptr %6, i64 %51, !dbg !97
  %53 = load float, ptr %52, align 4, !dbg !97
  %54 = insertelement <8 x float> poison, float %53, i32 0, !dbg !97
  %55 = shufflevector <8 x float> %54, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %56 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %34, <8 x float> %55, <8 x float> %50), !dbg !97
  %57 = add nuw nsw i64 0, %35, !dbg !97
  %58 = getelementptr inbounds nuw float, ptr %6, i64 %57, !dbg !97
  %59 = load float, ptr %58, align 4, !dbg !97
  %60 = insertelement <8 x float> poison, float %59, i32 0, !dbg !97
  %61 = shufflevector <8 x float> %60, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %62 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %39, <8 x float> %61, <8 x float> %56), !dbg !97
  %63 = add nuw nsw i64 0, %40, !dbg !97
  %64 = getelementptr inbounds nuw float, ptr %6, i64 %63, !dbg !97
  %65 = load float, ptr %64, align 4, !dbg !97
  %66 = insertelement <8 x float> poison, float %65, i32 0, !dbg !97
  %67 = shufflevector <8 x float> %66, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !97
  %68 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %44, <8 x float> %67, <8 x float> %62), !dbg !97
  %69 = add i64 %22, 4, !dbg !96
  br label %21, !dbg !96

70:                                               ; preds = %21
  %71 = add i64 0, %20, !dbg !97
  %72 = getelementptr float, ptr %16, i64 %71, !dbg !97
  store <8 x float> %23, ptr %72, align 4, !dbg !97
  ret i32 0, !dbg !98
}

define internal i32 @infer_dispatch_2_matmul_1x64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !99 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !100
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !100
  %6 = load ptr, ptr %5, align 8, !dbg !100
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !100
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !101
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !101
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !101
  %10 = load ptr, ptr %9, align 8, !dbg !101
  %11 = getelementptr float, ptr %10, i64 4224, !dbg !101
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !101
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !102
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !102
  %14 = load ptr, ptr %13, align 8, !dbg !102
  %15 = getelementptr float, ptr %14, i64 64, !dbg !102
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !102
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !103
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !103
  %18 = getelementptr ptr, ptr %17, i32 2, !dbg !103
  %19 = load ptr, ptr %18, align 8, !dbg !103
  %20 = getelementptr float, ptr %19, i64 128, !dbg !103
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !103
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !104
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !104
  %23 = zext i32 %22 to i64, !dbg !104
  %24 = mul nsw i64 %23, 8, !dbg !104
  br label %25, !dbg !104

25:                                               ; preds = %29, %3
  %26 = phi i64 [ %73, %29 ], [ 0, %3 ], !dbg !104
  %27 = phi <8 x float> [ %72, %29 ], [ zeroinitializer, %3 ], !dbg !104
  %28 = icmp slt i64 %26, 64, !dbg !104
  br i1 %28, label %29, label %74, !dbg !104

29:                                               ; preds = %25
  %30 = mul i64 %26, 64, !dbg !104
  %31 = add i64 %30, %24, !dbg !104
  %32 = getelementptr float, ptr %11, i64 %31, !dbg !104
  %33 = load <8 x float>, ptr %32, align 4, !dbg !104
  %34 = add i64 %26, 1, !dbg !104
  %35 = mul i64 %34, 64, !dbg !104
  %36 = add i64 %35, %24, !dbg !104
  %37 = getelementptr float, ptr %11, i64 %36, !dbg !104
  %38 = load <8 x float>, ptr %37, align 4, !dbg !104
  %39 = add i64 %26, 2, !dbg !104
  %40 = mul i64 %39, 64, !dbg !104
  %41 = add i64 %40, %24, !dbg !104
  %42 = getelementptr float, ptr %11, i64 %41, !dbg !104
  %43 = load <8 x float>, ptr %42, align 4, !dbg !104
  %44 = add i64 %26, 3, !dbg !104
  %45 = mul i64 %44, 64, !dbg !104
  %46 = add i64 %45, %24, !dbg !104
  %47 = getelementptr float, ptr %11, i64 %46, !dbg !104
  %48 = load <8 x float>, ptr %47, align 4, !dbg !104
  %49 = add nuw nsw i64 0, %26, !dbg !105
  %50 = getelementptr inbounds nuw float, ptr %6, i64 %49, !dbg !105
  %51 = load float, ptr %50, align 4, !dbg !105
  %52 = insertelement <8 x float> poison, float %51, i32 0, !dbg !105
  %53 = shufflevector <8 x float> %52, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !105
  %54 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %33, <8 x float> %53, <8 x float> %27), !dbg !105
  %55 = add nuw nsw i64 0, %34, !dbg !105
  %56 = getelementptr inbounds nuw float, ptr %6, i64 %55, !dbg !105
  %57 = load float, ptr %56, align 4, !dbg !105
  %58 = insertelement <8 x float> poison, float %57, i32 0, !dbg !105
  %59 = shufflevector <8 x float> %58, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !105
  %60 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %38, <8 x float> %59, <8 x float> %54), !dbg !105
  %61 = add nuw nsw i64 0, %39, !dbg !105
  %62 = getelementptr inbounds nuw float, ptr %6, i64 %61, !dbg !105
  %63 = load float, ptr %62, align 4, !dbg !105
  %64 = insertelement <8 x float> poison, float %63, i32 0, !dbg !105
  %65 = shufflevector <8 x float> %64, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !105
  %66 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %43, <8 x float> %65, <8 x float> %60), !dbg !105
  %67 = add nuw nsw i64 0, %44, !dbg !105
  %68 = getelementptr inbounds nuw float, ptr %6, i64 %67, !dbg !105
  %69 = load float, ptr %68, align 4, !dbg !105
  %70 = insertelement <8 x float> poison, float %69, i32 0, !dbg !105
  %71 = shufflevector <8 x float> %70, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !105
  %72 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %48, <8 x float> %71, <8 x float> %66), !dbg !105
  %73 = add i64 %26, 4, !dbg !104
  br label %25, !dbg !104

74:                                               ; preds = %25
  %75 = add i64 0, %24, !dbg !106
  %76 = getelementptr float, ptr %15, i64 %75, !dbg !106
  %77 = load <8 x float>, ptr %76, align 4, !dbg !106
  %78 = getelementptr float, ptr %6, i64 %75, !dbg !106
  %79 = load <8 x float>, ptr %78, align 4, !dbg !106
  %80 = fcmp ugt <8 x float> %77, zeroinitializer, !dbg !107
  %81 = select <8 x i1> %80, <8 x float> %77, <8 x float> zeroinitializer, !dbg !107
  %82 = select <8 x i1> zeroinitializer, <8 x float> zeroinitializer, <8 x float> %81, !dbg !107
  %83 = fcmp ugt <8 x float> %27, zeroinitializer, !dbg !108
  %84 = select <8 x i1> %83, <8 x float> %27, <8 x float> zeroinitializer, !dbg !108
  %85 = select <8 x i1> zeroinitializer, <8 x float> zeroinitializer, <8 x float> %84, !dbg !108
  %86 = fadd contract <8 x float> %85, %82, !dbg !109
  %87 = fadd contract <8 x float> %86, %79, !dbg !110
  %88 = getelementptr float, ptr %20, i64 %75, !dbg !110
  store <8 x float> %87, ptr %88, align 4, !dbg !110
  ret i32 0, !dbg !111
}

define internal i32 @infer_dispatch_3_matmul_1x2x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !112 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !113
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !113
  %6 = load ptr, ptr %5, align 8, !dbg !113
  %7 = getelementptr float, ptr %6, i64 128, !dbg !113
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !113
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !114
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !114
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !114
  %11 = load ptr, ptr %10, align 8, !dbg !114
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !114
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !115
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !115
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !115
  %15 = load ptr, ptr %14, align 8, !dbg !115
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !115
  br label %16, !dbg !116

16:                                               ; preds = %20, %3
  %17 = phi i64 [ %64, %20 ], [ 0, %3 ], !dbg !116
  %18 = phi <2 x float> [ %63, %20 ], [ zeroinitializer, %3 ], !dbg !116
  %19 = icmp slt i64 %17, 64, !dbg !116
  br i1 %19, label %20, label %65, !dbg !116

20:                                               ; preds = %16
  %21 = mul i64 %17, 2, !dbg !116
  %22 = add i64 %21, 0, !dbg !116
  %23 = getelementptr float, ptr %11, i64 %22, !dbg !116
  %24 = load <2 x float>, ptr %23, align 4, !dbg !116
  %25 = add i64 %17, 1, !dbg !116
  %26 = mul i64 %25, 2, !dbg !116
  %27 = add i64 %26, 0, !dbg !116
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !116
  %29 = load <2 x float>, ptr %28, align 4, !dbg !116
  %30 = add i64 %17, 2, !dbg !116
  %31 = mul i64 %30, 2, !dbg !116
  %32 = add i64 %31, 0, !dbg !116
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !116
  %34 = load <2 x float>, ptr %33, align 4, !dbg !116
  %35 = add i64 %17, 3, !dbg !116
  %36 = mul i64 %35, 2, !dbg !116
  %37 = add i64 %36, 0, !dbg !116
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !116
  %39 = load <2 x float>, ptr %38, align 4, !dbg !116
  %40 = add nuw nsw i64 0, %17, !dbg !117
  %41 = getelementptr inbounds nuw float, ptr %7, i64 %40, !dbg !117
  %42 = load float, ptr %41, align 4, !dbg !117
  %43 = insertelement <2 x float> poison, float %42, i32 0, !dbg !117
  %44 = shufflevector <2 x float> %43, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !117
  %45 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %24, <2 x float> %44, <2 x float> %18), !dbg !117
  %46 = add nuw nsw i64 0, %25, !dbg !117
  %47 = getelementptr inbounds nuw float, ptr %7, i64 %46, !dbg !117
  %48 = load float, ptr %47, align 4, !dbg !117
  %49 = insertelement <2 x float> poison, float %48, i32 0, !dbg !117
  %50 = shufflevector <2 x float> %49, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !117
  %51 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %29, <2 x float> %50, <2 x float> %45), !dbg !117
  %52 = add nuw nsw i64 0, %30, !dbg !117
  %53 = getelementptr inbounds nuw float, ptr %7, i64 %52, !dbg !117
  %54 = load float, ptr %53, align 4, !dbg !117
  %55 = insertelement <2 x float> poison, float %54, i32 0, !dbg !117
  %56 = shufflevector <2 x float> %55, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !117
  %57 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %34, <2 x float> %56, <2 x float> %51), !dbg !117
  %58 = add nuw nsw i64 0, %35, !dbg !117
  %59 = getelementptr inbounds nuw float, ptr %7, i64 %58, !dbg !117
  %60 = load float, ptr %59, align 4, !dbg !117
  %61 = insertelement <2 x float> poison, float %60, i32 0, !dbg !117
  %62 = shufflevector <2 x float> %61, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !117
  %63 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %39, <2 x float> %62, <2 x float> %57), !dbg !117
  %64 = add i64 %17, 4, !dbg !116
  br label %16, !dbg !116

65:                                               ; preds = %16
  %66 = getelementptr float, ptr %15, i64 0, !dbg !117
  store <2 x float> %18, ptr %66, align 4, !dbg !117
  ret i32 0, !dbg !118
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

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { uwtable "nonlazybind" }

!llvm.dbg.cu = !{!0, !2, !4, !6}
!llvm.module.flags = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/multibranch")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/multibranch")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/multibranch")
!6 = distinct !DICompileUnit(language: DW_LANG_C17, file: !7, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!7 = !DIFile(filename: "configured_module_infer_dispatch_3.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/multibranch")
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x64x16_f32", linkageName: "infer_dispatch_0_matmul_1x64x16_f32", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!10 = !DISubroutineType(cc: DW_CC_normal, types: !11)
!11 = !{!12, !13, !44, !73}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !16)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !17, file: !17, line: 246, size: 768, elements: !18)
!17 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!18 = !{!19, !27, !30, !33, !35}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DICompositeType(tag: DW_TAG_array_type, scope: !17, file: !17, line: 227, baseType: !23, size: 2048, elements: !25)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !24)
!24 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!25 = !{!26}
!26 = !DISubrange(count: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !28, size: 64, offset: 64)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !31, size: 64, offset: 128)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !34, size: 64, offset: 192)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !36, offset: 256)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !17, file: !17, line: 227, size: 512, elements: !37)
!37 = !{!38}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !39)
!39 = !DICompositeType(tag: DW_TAG_array_type, scope: !17, file: !17, line: 227, baseType: !40, size: 512, elements: !42)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !41)
!41 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!42 = !{!43}
!43 = !DISubrange(count: 8)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !47)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !17, file: !17, line: 275, size: 384, elements: !48)
!48 = !{!49, !50, !51, !54, !55, !56, !57, !58, !61, !62, !63, !68}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !23, size: 32)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !23, size: 32, offset: 32)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !52, size: 16, offset: 64)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !53)
!53 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !52, size: 16, offset: 80)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !23, size: 32, offset: 96)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !23, size: 32, offset: 128)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !52, size: 16, offset: 160)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !59, size: 8, offset: 176)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !60)
!60 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !59, size: 8, offset: 184)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !20, size: 64, offset: 192)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !64, size: 64, offset: 256)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !66)
!66 = !DICompositeType(tag: DW_TAG_array_type, scope: !17, file: !17, line: 227, baseType: !67, size: 4096, elements: !25)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !69, size: 64, offset: 320)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !71)
!71 = !DICompositeType(tag: DW_TAG_array_type, scope: !17, file: !17, line: 227, baseType: !72, size: 4096, elements: !25)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !40)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !75)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !76)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !17, file: !17, line: 321, size: 256, elements: !77)
!77 = !{!78, !79, !80, !81, !82, !83, !84}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !23, size: 32)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !23, size: 32, offset: 32)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !52, size: 16, offset: 64)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !52, size: 16, offset: 80)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !23, size: 32, offset: 96)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !28, size: 64, offset: 128)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !23, size: 32, offset: 192)
!85 = !DILocation(line: 12, column: 8, scope: !9)
!86 = !DILocation(line: 13, column: 8, scope: !9)
!87 = !DILocation(line: 14, column: 8, scope: !9)
!88 = !DILocation(line: 19, column: 8, scope: !9)
!89 = !DILocation(line: 1, column: 1, scope: !9)
!90 = !DILocation(line: 22, column: 10, scope: !9)
!91 = !DILocation(line: 26, column: 8, scope: !9)
!92 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x64x64_f32", linkageName: "infer_dispatch_1_matmul_1x64x64_f32", scope: !3, file: !3, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!93 = !DILocation(line: 13, column: 8, scope: !92)
!94 = !DILocation(line: 14, column: 8, scope: !92)
!95 = !DILocation(line: 15, column: 8, scope: !92)
!96 = !DILocation(line: 20, column: 8, scope: !92)
!97 = !DILocation(line: 1, column: 1, scope: !92)
!98 = !DILocation(line: 22, column: 8, scope: !92)
!99 = distinct !DISubprogram(name: "infer_dispatch_2_matmul_1x64x64_f32", linkageName: "infer_dispatch_2_matmul_1x64x64_f32", scope: !5, file: !5, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!100 = !DILocation(line: 14, column: 8, scope: !99)
!101 = !DILocation(line: 15, column: 8, scope: !99)
!102 = !DILocation(line: 16, column: 8, scope: !99)
!103 = !DILocation(line: 17, column: 8, scope: !99)
!104 = !DILocation(line: 23, column: 8, scope: !99)
!105 = !DILocation(line: 1, column: 1, scope: !99)
!106 = !DILocation(line: 24, column: 8, scope: !99)
!107 = !DILocation(line: 26, column: 10, scope: !99)
!108 = !DILocation(line: 27, column: 10, scope: !99)
!109 = !DILocation(line: 28, column: 10, scope: !99)
!110 = !DILocation(line: 29, column: 10, scope: !99)
!111 = !DILocation(line: 33, column: 8, scope: !99)
!112 = distinct !DISubprogram(name: "infer_dispatch_3_matmul_1x2x64_f32", linkageName: "infer_dispatch_3_matmul_1x2x64_f32", scope: !7, file: !7, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!113 = !DILocation(line: 12, column: 8, scope: !112)
!114 = !DILocation(line: 13, column: 8, scope: !112)
!115 = !DILocation(line: 14, column: 8, scope: !112)
!116 = !DILocation(line: 19, column: 8, scope: !112)
!117 = !DILocation(line: 1, column: 1, scope: !112)
!118 = !DILocation(line: 21, column: 8, scope: !112)
