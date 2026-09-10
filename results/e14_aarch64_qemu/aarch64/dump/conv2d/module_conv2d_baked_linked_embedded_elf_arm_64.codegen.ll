; ModuleID = 'conv2d_baked_linked'
source_filename = "conv2d_baked_linked"
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

@__constant_3x3x4xf32 = private constant [3 x [3 x [4 x float]]] [[3 x [4 x float]] [[4 x float] [float 0x3F89BFE280000000, float 0xBF8B0E1980000000, float 0x3FB06512E0000000, float 0x3F857BC980000000], [4 x float] [float 0xBFAB6D2020000000, float 0x3FA2837FA0000000, float 0x3FC0B0F280000000, float 0x3FB83ECA40000000], [4 x float] [float 0xBFB203FFC0000000, float 0xBFC0328880000000, float 0xBFAFE96200000000, float 0x3F70ED57C0000000]], [3 x [4 x float]] [[4 x float] [float 0xBFCDC2A920000000, float 0xBF96677E00000000, float 0xBFBFE533C0000000, float 0xBFB2BEFCC0000000], [4 x float] [float 0xBFABDDB620000000, float 0xBFA031CF40000000, float 0x3FA51352E0000000, float 0x3FBAB03740000000], [4 x float] [float 0xBF8A52EB00000000, float 0x3FC17DA0A0000000, float 0xBFB1076B80000000, float 0x3FA1FF5020000000]], [3 x [4 x float]] [[4 x float] [float 0x3FB720FB80000000, float 0x3F8340F3C0000000, float 0xBFB30898C0000000, float 0xBFB7989EA0000000], [4 x float] [float 0xBFA76F8100000000, float 0x3F968C4880000000, float 0xBFB9D8A240000000, float 0xBF956B6980000000], [4 x float] [float 0xBF904DFD00000000, float 0x3FABB0F8A0000000, float 0x3F95FB2900000000, float 0x3FA231F100000000]]], align 64
@__constant_4xf32 = private constant [4 x float] [float 0xBFB0BCEE60000000, float 0xBF8A8B7CC0000000, float 0x3FB411DCA0000000, float 0x3FC31DACE0000000], align 64
@0 = private constant [20 x i8] c"conv2d_baked_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [3 x ptr] [ptr @infer_dispatch_0_conv_6x6x4x3x3_f32, ptr @infer_dispatch_1_conv_4x4x8x3x3x4_f32, ptr @infer_dispatch_2_matmul_1x2x128_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [3 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [36 x i8] c"infer_dispatch_0_conv_6x6x4x3x3_f32\00", align 1
@2 = private constant [38 x i8] c"infer_dispatch_1_conv_4x4x8x3x3x4_f32\00", align 1
@3 = private constant [36 x i8] c"infer_dispatch_2_matmul_1x2x128_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [3 x ptr] [ptr @1, ptr @2, ptr @3]
@4 = private constant [85 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_0.mlir\00", align 1
@5 = private constant [85 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_1.mlir\00", align 1
@6 = private constant [85 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d/configured_module_infer_dispatch_2.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [3 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 84, ptr @4 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 84, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 84, ptr @6 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [3 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 3, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_conv_6x6x4x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !7 {
  %4 = alloca float, i64 4, align 64, !dbg !83
  %5 = alloca float, i64 4, align 64, !dbg !84
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !85
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !85
  %8 = load ptr, ptr %7, align 8, !dbg !85
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !85
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !86
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !86
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !86
  %12 = load ptr, ptr %11, align 8, !dbg !86
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !86
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !83
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !83
  %15 = zext i32 %14 to i64, !dbg !83
  %16 = sdiv i64 %15, 2, !dbg !83
  %17 = mul i64 %16, 2, !dbg !83
  %18 = icmp ne i64 %15, %17, !dbg !83
  %19 = icmp slt i64 %15, 0, !dbg !83
  %20 = and i1 %18, %19, !dbg !83
  %21 = add i64 %16, -1, !dbg !83
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !83
  %23 = srem i64 %15, 2, !dbg !83
  %24 = icmp slt i64 %23, 0, !dbg !83
  %25 = add nsw i64 %23, 2, !dbg !83
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !83
  %27 = mul nsw i64 %26, 3, !dbg !83
  %28 = getelementptr float, ptr %5, i64 0, !dbg !87
  store <4 x float> zeroinitializer, ptr %28, align 4, !dbg !87
  %29 = load <4 x float>, ptr @__constant_4xf32, align 4, !dbg !88
  br label %30, !dbg !83

30:                                               ; preds = %77, %3
  %31 = phi i64 [ %90, %77 ], [ 0, %3 ], !dbg !83
  %32 = icmp slt i64 %31, 3, !dbg !83
  br i1 %32, label %33, label %91, !dbg !83

33:                                               ; preds = %36, %30
  %34 = phi i64 [ %41, %36 ], [ 0, %30 ], !dbg !83
  %35 = icmp slt i64 %34, 4, !dbg !83
  br i1 %35, label %36, label %42, !dbg !83

36:                                               ; preds = %33
  %37 = add nuw nsw i64 0, %34, !dbg !83
  %38 = getelementptr inbounds nuw float, ptr %5, i64 %37, !dbg !83
  %39 = load float, ptr %38, align 4, !dbg !83
  %40 = getelementptr inbounds nuw float, ptr %4, i64 %37, !dbg !83
  store float %39, ptr %40, align 4, !dbg !83
  %41 = add i64 %34, 1, !dbg !83
  br label %33, !dbg !83

42:                                               ; preds = %75, %33
  %43 = phi i64 [ %76, %75 ], [ 0, %33 ], !dbg !83
  %44 = icmp slt i64 %43, 3, !dbg !83
  br i1 %44, label %45, label %77, !dbg !83

45:                                               ; preds = %42
  %46 = add i64 %43, %22, !dbg !83
  br label %47, !dbg !83

47:                                               ; preds = %73, %45
  %48 = phi i64 [ %74, %73 ], [ 0, %45 ], !dbg !83
  %49 = icmp slt i64 %48, 3, !dbg !83
  br i1 %49, label %50, label %75, !dbg !83

50:                                               ; preds = %47
  %51 = add i64 %48, %31, !dbg !83
  %52 = add i64 %51, %27, !dbg !83
  br label %53, !dbg !83

53:                                               ; preds = %56, %50
  %54 = phi i64 [ %72, %56 ], [ 0, %50 ], !dbg !83
  %55 = icmp slt i64 %54, 4, !dbg !83
  br i1 %55, label %56, label %73, !dbg !83

56:                                               ; preds = %53
  %57 = mul nuw nsw i64 %46, 8, !dbg !83
  %58 = add nuw nsw i64 %57, %52, !dbg !83
  %59 = getelementptr inbounds nuw float, ptr %8, i64 %58, !dbg !83
  %60 = load float, ptr %59, align 4, !dbg !83
  %61 = mul nuw nsw i64 %43, 12, !dbg !83
  %62 = mul nuw nsw i64 %48, 4, !dbg !83
  %63 = add nuw nsw i64 %61, %62, !dbg !83
  %64 = add nuw nsw i64 %63, %54, !dbg !83
  %65 = getelementptr inbounds nuw float, ptr @__constant_3x3x4xf32, i64 %64, !dbg !83
  %66 = load float, ptr %65, align 4, !dbg !83
  %67 = add nuw nsw i64 0, %54, !dbg !83
  %68 = getelementptr inbounds nuw float, ptr %4, i64 %67, !dbg !83
  %69 = load float, ptr %68, align 4, !dbg !83
  %70 = fmul contract float %60, %66, !dbg !89
  %71 = fadd contract float %69, %70, !dbg !90
  store float %71, ptr %68, align 4, !dbg !83
  %72 = add i64 %54, 1, !dbg !83
  br label %53, !dbg !83

73:                                               ; preds = %53
  %74 = add i64 %48, 1, !dbg !83
  br label %47, !dbg !83

75:                                               ; preds = %47
  %76 = add i64 %43, 1, !dbg !83
  br label %42, !dbg !83

77:                                               ; preds = %42
  %78 = getelementptr float, ptr %4, i64 0, !dbg !88
  %79 = load <4 x float>, ptr %78, align 4, !dbg !88
  %80 = fadd contract <4 x float> %79, %29, !dbg !91
  %81 = fcmp ugt <4 x float> %80, zeroinitializer, !dbg !92
  %82 = select <4 x i1> %81, <4 x float> %80, <4 x float> zeroinitializer, !dbg !92
  %83 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %82, !dbg !92
  %84 = add i64 %27, %31, !dbg !83
  %85 = mul i64 %22, 24, !dbg !83
  %86 = mul i64 %84, 4, !dbg !83
  %87 = add i64 %85, %86, !dbg !83
  %88 = add i64 %87, 0, !dbg !83
  %89 = getelementptr float, ptr %12, i64 %88, !dbg !83
  store <4 x float> %83, ptr %89, align 4, !dbg !83
  %90 = add i64 %31, 1, !dbg !83
  br label %30, !dbg !83

91:                                               ; preds = %30
  ret i32 0, !dbg !93
}

define internal i32 @infer_dispatch_1_conv_4x4x8x3x3x4_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !94 {
  %4 = alloca float, i64 4, align 64, !dbg !95
  %5 = alloca float, i64 4, align 64, !dbg !96
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !97
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !97
  %8 = load ptr, ptr %7, align 8, !dbg !97
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !97
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !98
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !98
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !98
  %12 = load ptr, ptr %11, align 8, !dbg !98
  %13 = getelementptr float, ptr %12, i64 256, !dbg !98
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !98
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !99
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !99
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !99
  %17 = load ptr, ptr %16, align 8, !dbg !99
  %18 = getelementptr float, ptr %17, i64 144, !dbg !99
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !99
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !95
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !95
  %21 = zext i32 %20 to i64, !dbg !95
  %22 = sdiv i64 %21, 4, !dbg !95
  %23 = mul i64 %22, 4, !dbg !95
  %24 = icmp ne i64 %21, %23, !dbg !95
  %25 = icmp slt i64 %21, 0, !dbg !95
  %26 = and i1 %24, %25, !dbg !95
  %27 = add i64 %22, -1, !dbg !95
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !95
  %29 = srem i64 %21, 4, !dbg !95
  %30 = icmp slt i64 %29, 0, !dbg !95
  %31 = add nsw i64 %29, 4, !dbg !95
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !95
  %33 = getelementptr float, ptr %5, i64 0, !dbg !100
  store <4 x float> zeroinitializer, ptr %33, align 4, !dbg !100
  br label %34, !dbg !95

34:                                               ; preds = %90, %3
  %35 = phi i64 [ %101, %90 ], [ 0, %3 ], !dbg !95
  %36 = icmp slt i64 %35, 8, !dbg !95
  br i1 %36, label %37, label %102, !dbg !95

37:                                               ; preds = %40, %34
  %38 = phi i64 [ %45, %40 ], [ 0, %34 ], !dbg !95
  %39 = icmp slt i64 %38, 4, !dbg !95
  br i1 %39, label %40, label %46, !dbg !95

40:                                               ; preds = %37
  %41 = add nuw nsw i64 0, %38, !dbg !95
  %42 = getelementptr inbounds nuw float, ptr %5, i64 %41, !dbg !95
  %43 = load float, ptr %42, align 4, !dbg !95
  %44 = getelementptr inbounds nuw float, ptr %4, i64 %41, !dbg !95
  store float %43, ptr %44, align 4, !dbg !95
  %45 = add i64 %38, 1, !dbg !95
  br label %37, !dbg !95

46:                                               ; preds = %88, %37
  %47 = phi i64 [ %89, %88 ], [ 0, %37 ], !dbg !95
  %48 = icmp slt i64 %47, 3, !dbg !95
  br i1 %48, label %49, label %90, !dbg !95

49:                                               ; preds = %46
  %50 = add i64 %47, %28, !dbg !95
  br label %51, !dbg !95

51:                                               ; preds = %86, %49
  %52 = phi i64 [ %87, %86 ], [ 0, %49 ], !dbg !95
  %53 = icmp slt i64 %52, 3, !dbg !95
  br i1 %53, label %54, label %88, !dbg !95

54:                                               ; preds = %51
  %55 = add i64 %52, %32, !dbg !95
  br label %56, !dbg !95

56:                                               ; preds = %84, %54
  %57 = phi i64 [ %85, %84 ], [ 0, %54 ], !dbg !95
  %58 = icmp slt i64 %57, 4, !dbg !95
  br i1 %58, label %59, label %86, !dbg !95

59:                                               ; preds = %62, %56
  %60 = phi i64 [ %83, %62 ], [ 0, %56 ], !dbg !95
  %61 = icmp slt i64 %60, 4, !dbg !95
  br i1 %61, label %62, label %84, !dbg !95

62:                                               ; preds = %59
  %63 = mul nuw nsw i64 %50, 24, !dbg !95
  %64 = mul nuw nsw i64 %55, 4, !dbg !95
  %65 = add nuw nsw i64 %63, %64, !dbg !95
  %66 = add nuw nsw i64 %65, %60, !dbg !95
  %67 = getelementptr inbounds nuw float, ptr %8, i64 %66, !dbg !95
  %68 = load float, ptr %67, align 4, !dbg !95
  %69 = add i64 %35, %57, !dbg !95
  %70 = mul nuw nsw i64 %47, 96, !dbg !95
  %71 = mul nuw nsw i64 %52, 32, !dbg !95
  %72 = add nuw nsw i64 %70, %71, !dbg !95
  %73 = mul nuw nsw i64 %60, 8, !dbg !95
  %74 = add nuw nsw i64 %72, %73, !dbg !95
  %75 = add nuw nsw i64 %74, %69, !dbg !95
  %76 = getelementptr inbounds nuw float, ptr %13, i64 %75, !dbg !95
  %77 = load float, ptr %76, align 4, !dbg !95
  %78 = add nuw nsw i64 0, %57, !dbg !95
  %79 = getelementptr inbounds nuw float, ptr %4, i64 %78, !dbg !95
  %80 = load float, ptr %79, align 4, !dbg !95
  %81 = fmul contract float %68, %77, !dbg !101
  %82 = fadd contract float %80, %81, !dbg !102
  store float %82, ptr %79, align 4, !dbg !95
  %83 = add i64 %60, 1, !dbg !95
  br label %59, !dbg !95

84:                                               ; preds = %59
  %85 = add i64 %57, 1, !dbg !95
  br label %56, !dbg !95

86:                                               ; preds = %56
  %87 = add i64 %52, 1, !dbg !95
  br label %51, !dbg !95

88:                                               ; preds = %51
  %89 = add i64 %47, 1, !dbg !95
  br label %46, !dbg !95

90:                                               ; preds = %46
  %91 = getelementptr float, ptr %4, i64 0, !dbg !103
  %92 = load <4 x float>, ptr %91, align 4, !dbg !103
  %93 = fcmp ugt <4 x float> %92, zeroinitializer, !dbg !104
  %94 = select <4 x i1> %93, <4 x float> %92, <4 x float> zeroinitializer, !dbg !104
  %95 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %94, !dbg !104
  %96 = mul i64 %28, 32, !dbg !95
  %97 = mul i64 %32, 8, !dbg !95
  %98 = add i64 %96, %97, !dbg !95
  %99 = add i64 %98, %35, !dbg !95
  %100 = getelementptr float, ptr %18, i64 %99, !dbg !95
  store <4 x float> %95, ptr %100, align 4, !dbg !95
  %101 = add i64 %35, 4, !dbg !95
  br label %34, !dbg !95

102:                                              ; preds = %34
  ret i32 0, !dbg !105
}

define internal i32 @infer_dispatch_2_matmul_1x2x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !106 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !107
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !107
  %6 = load ptr, ptr %5, align 8, !dbg !107
  %7 = getelementptr float, ptr %6, i64 144, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !107
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !108
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !108
  %11 = load ptr, ptr %10, align 8, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !108
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !109
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !109
  %15 = load ptr, ptr %14, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !109
  br label %16, !dbg !110

16:                                               ; preds = %20, %3
  %17 = phi i64 [ %64, %20 ], [ 0, %3 ], !dbg !110
  %18 = phi <2 x float> [ %63, %20 ], [ zeroinitializer, %3 ], !dbg !110
  %19 = icmp slt i64 %17, 128, !dbg !110
  br i1 %19, label %20, label %65, !dbg !110

20:                                               ; preds = %16
  %21 = mul i64 %17, 2, !dbg !110
  %22 = add i64 %21, 0, !dbg !110
  %23 = getelementptr float, ptr %11, i64 %22, !dbg !110
  %24 = load <2 x float>, ptr %23, align 4, !dbg !110
  %25 = add i64 %17, 1, !dbg !110
  %26 = mul i64 %25, 2, !dbg !110
  %27 = add i64 %26, 0, !dbg !110
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !110
  %29 = load <2 x float>, ptr %28, align 4, !dbg !110
  %30 = add i64 %17, 2, !dbg !110
  %31 = mul i64 %30, 2, !dbg !110
  %32 = add i64 %31, 0, !dbg !110
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !110
  %34 = load <2 x float>, ptr %33, align 4, !dbg !110
  %35 = add i64 %17, 3, !dbg !110
  %36 = mul i64 %35, 2, !dbg !110
  %37 = add i64 %36, 0, !dbg !110
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !110
  %39 = load <2 x float>, ptr %38, align 4, !dbg !110
  %40 = add nuw nsw i64 0, %17, !dbg !111
  %41 = getelementptr inbounds nuw float, ptr %7, i64 %40, !dbg !111
  %42 = load float, ptr %41, align 4, !dbg !111
  %43 = insertelement <2 x float> poison, float %42, i32 0, !dbg !111
  %44 = shufflevector <2 x float> %43, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %45 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %24, <2 x float> %44, <2 x float> %18), !dbg !111
  %46 = add nuw nsw i64 0, %25, !dbg !111
  %47 = getelementptr inbounds nuw float, ptr %7, i64 %46, !dbg !111
  %48 = load float, ptr %47, align 4, !dbg !111
  %49 = insertelement <2 x float> poison, float %48, i32 0, !dbg !111
  %50 = shufflevector <2 x float> %49, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %51 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %29, <2 x float> %50, <2 x float> %45), !dbg !111
  %52 = add nuw nsw i64 0, %30, !dbg !111
  %53 = getelementptr inbounds nuw float, ptr %7, i64 %52, !dbg !111
  %54 = load float, ptr %53, align 4, !dbg !111
  %55 = insertelement <2 x float> poison, float %54, i32 0, !dbg !111
  %56 = shufflevector <2 x float> %55, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %57 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %34, <2 x float> %56, <2 x float> %51), !dbg !111
  %58 = add nuw nsw i64 0, %35, !dbg !111
  %59 = getelementptr inbounds nuw float, ptr %7, i64 %58, !dbg !111
  %60 = load float, ptr %59, align 4, !dbg !111
  %61 = insertelement <2 x float> poison, float %60, i32 0, !dbg !111
  %62 = shufflevector <2 x float> %61, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %63 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %39, <2 x float> %62, <2 x float> %57), !dbg !111
  %64 = add i64 %17, 4, !dbg !110
  br label %16, !dbg !110

65:                                               ; preds = %16
  %66 = getelementptr float, ptr %15, i64 0, !dbg !111
  store <2 x float> %18, ptr %66, align 4, !dbg !111
  ret i32 0, !dbg !112
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

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

!llvm.dbg.cu = !{!0, !2, !4}
!llvm.module.flags = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d")
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = distinct !DISubprogram(name: "infer_dispatch_0_conv_6x6x4x3x3_f32", linkageName: "infer_dispatch_0_conv_6x6x4x3x3_f32", scope: !1, file: !1, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!8 = !DISubroutineType(cc: DW_CC_normal, types: !9)
!9 = !{!10, !11, !42, !71}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !13)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !14)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !15, file: !15, line: 246, size: 768, elements: !16)
!15 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!16 = !{!17, !25, !28, !31, !33}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!20 = !DICompositeType(tag: DW_TAG_array_type, scope: !15, file: !15, line: 227, baseType: !21, size: 2048, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !22)
!22 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!23 = !{!24}
!24 = !DISubrange(count: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !26, size: 64, offset: 64)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !29, size: 64, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !32, size: 64, offset: 192)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !34, offset: 256)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !15, file: !15, line: 227, size: 512, elements: !35)
!35 = !{!36}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !37)
!37 = !DICompositeType(tag: DW_TAG_array_type, scope: !15, file: !15, line: 227, baseType: !38, size: 512, elements: !40)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !39)
!39 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!40 = !{!41}
!41 = !DISubrange(count: 8)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !45)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !15, file: !15, line: 275, size: 384, elements: !46)
!46 = !{!47, !48, !49, !52, !53, !54, !55, !56, !59, !60, !61, !66}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !21, size: 32)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !21, size: 32, offset: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !50, size: 16, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !51)
!51 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !50, size: 16, offset: 80)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !21, size: 32, offset: 96)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !21, size: 32, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !50, size: 16, offset: 160)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !57, size: 8, offset: 176)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !58)
!58 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !57, size: 8, offset: 184)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !18, size: 64, offset: 192)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !62, size: 64, offset: 256)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !64)
!64 = !DICompositeType(tag: DW_TAG_array_type, scope: !15, file: !15, line: 227, baseType: !65, size: 4096, elements: !23)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !67, size: 64, offset: 320)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !69)
!69 = !DICompositeType(tag: DW_TAG_array_type, scope: !15, file: !15, line: 227, baseType: !70, size: 4096, elements: !23)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !38)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !74)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !15, file: !15, line: 321, size: 256, elements: !75)
!75 = !{!76, !77, !78, !79, !80, !81, !82}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !21, size: 32)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !21, size: 32, offset: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !50, size: 16, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !50, size: 16, offset: 80)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !21, size: 32, offset: 96)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !26, size: 64, offset: 128)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !21, size: 32, offset: 192)
!83 = !DILocation(line: 18, column: 8, scope: !7)
!84 = !DILocation(line: 17, column: 8, scope: !7)
!85 = !DILocation(line: 13, column: 8, scope: !7)
!86 = !DILocation(line: 14, column: 8, scope: !7)
!87 = !DILocation(line: 10, column: 8, scope: !7)
!88 = !DILocation(line: 24, column: 8, scope: !7)
!89 = !DILocation(line: 20, column: 10, scope: !7)
!90 = !DILocation(line: 21, column: 10, scope: !7)
!91 = !DILocation(line: 26, column: 10, scope: !7)
!92 = !DILocation(line: 27, column: 10, scope: !7)
!93 = !DILocation(line: 31, column: 8, scope: !7)
!94 = distinct !DISubprogram(name: "infer_dispatch_1_conv_4x4x8x3x3x4_f32", linkageName: "infer_dispatch_1_conv_4x4x8x3x3x4_f32", scope: !3, file: !3, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!95 = !DILocation(line: 20, column: 8, scope: !94)
!96 = !DILocation(line: 19, column: 8, scope: !94)
!97 = !DILocation(line: 13, column: 8, scope: !94)
!98 = !DILocation(line: 14, column: 8, scope: !94)
!99 = !DILocation(line: 15, column: 8, scope: !94)
!100 = !DILocation(line: 9, column: 8, scope: !94)
!101 = !DILocation(line: 22, column: 10, scope: !94)
!102 = !DILocation(line: 23, column: 10, scope: !94)
!103 = !DILocation(line: 26, column: 8, scope: !94)
!104 = !DILocation(line: 28, column: 10, scope: !94)
!105 = !DILocation(line: 32, column: 8, scope: !94)
!106 = distinct !DISubprogram(name: "infer_dispatch_2_matmul_1x2x128_f32", linkageName: "infer_dispatch_2_matmul_1x2x128_f32", scope: !5, file: !5, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!107 = !DILocation(line: 12, column: 8, scope: !106)
!108 = !DILocation(line: 13, column: 8, scope: !106)
!109 = !DILocation(line: 14, column: 8, scope: !106)
!110 = !DILocation(line: 19, column: 8, scope: !106)
!111 = !DILocation(line: 1, column: 1, scope: !106)
!112 = !DILocation(line: 21, column: 8, scope: !106)
