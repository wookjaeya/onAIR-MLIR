; ModuleID = 'conv2d_swap_baked_linked'
source_filename = "conv2d_swap_baked_linked"
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

@__constant_3x3x4xf32 = private constant [3 x [3 x [4 x float]]] [[3 x [4 x float]] [[4 x float] [float 0x3FA1B1A420000000, float 0x3FB5088E80000000, float 0x3FA0EB1AE0000000, float 0xBFC0AE2F80000000], [4 x float] [float 0x3FB72D5720000000, float 0x3FA6DAB880000000, float 0xBFAB7DF420000000, float 0x3FADC0D4C0000000], [4 x float] [float 0x3FA2AA8600000000, float 0x3F9E1E81C0000000, float 0x3F67489380000000, float 0x3FABFDE060000000]], [3 x [4 x float]] [[4 x float] [float 0xBFB2DA6CE0000000, float 0xBF90AE9620000000, float 0xBFA8AF3C00000000, float 0x3FAEA93280000000], [4 x float] [float 0x3F70452A40000000, float 0xBF9DF29400000000, float 0xBFB40450C0000000, float 0xBF9A5623E0000000], [4 x float] [float 0x3F4AAE2800000000, float 0xBF9C38C3C0000000, float 0x3FC0906360000000, float 0x3FB9C5AB20000000]], [3 x [4 x float]] [[4 x float] [float 0xBFD159F800000000, float 0xBFC82DEB20000000, float 0xBF91E58BA0000000, float 0xBFA59DBC00000000], [4 x float] [float 0x3F95E085E0000000, float 0x3F9640F6C0000000, float 0x3FCB1BBBE0000000, float 0xBFBC77BD40000000], [4 x float] [float 0xBFA3555820000000, float 0x3FCA25C100000000, float 0x3FB08E3BA0000000, float 0x3FB0F973C0000000]]], align 64
@__constant_4xf32 = private constant [4 x float] [float 0xBFAA512F20000000, float 0xBFC51869A0000000, float 0x3F9125FCE0000000, float 0x3F86537A60000000], align 64
@0 = private constant [25 x i8] c"conv2d_swap_baked_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [3 x ptr] [ptr @infer_dispatch_0_conv_6x6x4x3x3_f32, ptr @infer_dispatch_1_conv_4x4x8x3x3x4_f32, ptr @infer_dispatch_2_matmul_1x2x128_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [3 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [36 x i8] c"infer_dispatch_0_conv_6x6x4x3x3_f32\00", align 1
@2 = private constant [38 x i8] c"infer_dispatch_1_conv_4x4x8x3x3x4_f32\00", align 1
@3 = private constant [36 x i8] c"infer_dispatch_2_matmul_1x2x128_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [3 x ptr] [ptr @1, ptr @2, ptr @3]
@4 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/conv2d_swap/configured_module_infer_dispatch_0.mlir\00", align 1
@5 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/conv2d_swap/configured_module_infer_dispatch_1.mlir\00", align 1
@6 = private constant [89 x i8] c"results/e14_aarch64_qemu/x86_64/dump/conv2d_swap/configured_module_infer_dispatch_2.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [3 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @4 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 88, ptr @6 }]
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
  %4 = alloca float, i64 8, align 64, !dbg !95
  %5 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !96
  %6 = extractvalue %iree_hal_executable_dispatch_state_v0_t %5, 10, !dbg !96
  %7 = load ptr, ptr %6, align 8, !dbg !96
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !96
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !97
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !97
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !97
  %11 = load ptr, ptr %10, align 8, !dbg !97
  %12 = getelementptr float, ptr %11, i64 256, !dbg !97
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !97
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !98
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !98
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !98
  %16 = load ptr, ptr %15, align 8, !dbg !98
  %17 = getelementptr float, ptr %16, i64 144, !dbg !98
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !98
  %18 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !99
  %19 = extractvalue %iree_hal_executable_workgroup_state_v0_t %18, 0, !dbg !99
  %20 = zext i32 %19 to i64, !dbg !99
  %21 = sdiv i64 %20, 4, !dbg !99
  %22 = mul i64 %21, 4, !dbg !99
  %23 = icmp ne i64 %20, %22, !dbg !99
  %24 = icmp slt i64 %20, 0, !dbg !99
  %25 = and i1 %23, %24, !dbg !99
  %26 = add i64 %21, -1, !dbg !99
  %27 = select i1 %25, i64 %26, i64 %21, !dbg !99
  %28 = srem i64 %20, 4, !dbg !99
  %29 = icmp slt i64 %28, 0, !dbg !99
  %30 = add nsw i64 %28, 4, !dbg !99
  %31 = select i1 %29, i64 %30, i64 %28, !dbg !99
  %32 = getelementptr float, ptr %4, i64 0, !dbg !100
  store <8 x float> zeroinitializer, ptr %32, align 4, !dbg !100
  br label %33, !dbg !99

33:                                               ; preds = %74, %3
  %34 = phi i64 [ %75, %74 ], [ 0, %3 ], !dbg !99
  %35 = icmp slt i64 %34, 3, !dbg !99
  br i1 %35, label %36, label %76, !dbg !99

36:                                               ; preds = %33
  %37 = add i64 %34, %27, !dbg !99
  br label %38, !dbg !99

38:                                               ; preds = %72, %36
  %39 = phi i64 [ %73, %72 ], [ 0, %36 ], !dbg !99
  %40 = icmp slt i64 %39, 3, !dbg !99
  br i1 %40, label %41, label %74, !dbg !99

41:                                               ; preds = %38
  %42 = add i64 %39, %31, !dbg !99
  br label %43, !dbg !99

43:                                               ; preds = %70, %41
  %44 = phi i64 [ %71, %70 ], [ 0, %41 ], !dbg !99
  %45 = icmp slt i64 %44, 8, !dbg !99
  br i1 %45, label %46, label %72, !dbg !99

46:                                               ; preds = %49, %43
  %47 = phi i64 [ %69, %49 ], [ 0, %43 ], !dbg !99
  %48 = icmp slt i64 %47, 4, !dbg !99
  br i1 %48, label %49, label %70, !dbg !99

49:                                               ; preds = %46
  %50 = mul nuw nsw i64 %37, 24, !dbg !99
  %51 = mul nuw nsw i64 %42, 4, !dbg !99
  %52 = add nuw nsw i64 %50, %51, !dbg !99
  %53 = add nuw nsw i64 %52, %47, !dbg !99
  %54 = getelementptr inbounds nuw float, ptr %7, i64 %53, !dbg !99
  %55 = load float, ptr %54, align 4, !dbg !99
  %56 = mul nuw nsw i64 %34, 96, !dbg !99
  %57 = mul nuw nsw i64 %39, 32, !dbg !99
  %58 = add nuw nsw i64 %56, %57, !dbg !99
  %59 = mul nuw nsw i64 %47, 8, !dbg !99
  %60 = add nuw nsw i64 %58, %59, !dbg !99
  %61 = add nuw nsw i64 %60, %44, !dbg !99
  %62 = getelementptr inbounds nuw float, ptr %12, i64 %61, !dbg !99
  %63 = load float, ptr %62, align 4, !dbg !99
  %64 = add nuw nsw i64 0, %44, !dbg !99
  %65 = getelementptr inbounds nuw float, ptr %4, i64 %64, !dbg !99
  %66 = load float, ptr %65, align 4, !dbg !99
  %67 = fmul contract float %55, %63, !dbg !101
  %68 = fadd contract float %66, %67, !dbg !102
  store float %68, ptr %65, align 4, !dbg !99
  %69 = add i64 %47, 1, !dbg !99
  br label %46, !dbg !99

70:                                               ; preds = %46
  %71 = add i64 %44, 1, !dbg !99
  br label %43, !dbg !99

72:                                               ; preds = %43
  %73 = add i64 %39, 1, !dbg !99
  br label %38, !dbg !99

74:                                               ; preds = %38
  %75 = add i64 %34, 1, !dbg !99
  br label %33, !dbg !99

76:                                               ; preds = %33
  %77 = load <8 x float>, ptr %32, align 4, !dbg !103
  %78 = fcmp ugt <8 x float> %77, zeroinitializer, !dbg !104
  %79 = select <8 x i1> %78, <8 x float> %77, <8 x float> zeroinitializer, !dbg !104
  %80 = select <8 x i1> zeroinitializer, <8 x float> zeroinitializer, <8 x float> %79, !dbg !104
  %81 = mul i64 %27, 32, !dbg !104
  %82 = mul i64 %31, 8, !dbg !104
  %83 = add i64 %81, %82, !dbg !104
  %84 = add i64 %83, 0, !dbg !104
  %85 = getelementptr float, ptr %17, i64 %84, !dbg !104
  store <8 x float> %80, ptr %85, align 4, !dbg !104
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
  %17 = phi i64 [ %196, %20 ], [ 0, %3 ], !dbg !110
  %18 = phi <2 x float> [ %195, %20 ], [ zeroinitializer, %3 ], !dbg !110
  %19 = icmp slt i64 %17, 128, !dbg !110
  br i1 %19, label %20, label %197, !dbg !110

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
  %40 = add i64 %17, 4, !dbg !110
  %41 = mul i64 %40, 2, !dbg !110
  %42 = add i64 %41, 0, !dbg !110
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !110
  %44 = load <2 x float>, ptr %43, align 4, !dbg !110
  %45 = add i64 %17, 5, !dbg !110
  %46 = mul i64 %45, 2, !dbg !110
  %47 = add i64 %46, 0, !dbg !110
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !110
  %49 = load <2 x float>, ptr %48, align 4, !dbg !110
  %50 = add i64 %17, 6, !dbg !110
  %51 = mul i64 %50, 2, !dbg !110
  %52 = add i64 %51, 0, !dbg !110
  %53 = getelementptr float, ptr %11, i64 %52, !dbg !110
  %54 = load <2 x float>, ptr %53, align 4, !dbg !110
  %55 = add i64 %17, 7, !dbg !110
  %56 = mul i64 %55, 2, !dbg !110
  %57 = add i64 %56, 0, !dbg !110
  %58 = getelementptr float, ptr %11, i64 %57, !dbg !110
  %59 = load <2 x float>, ptr %58, align 4, !dbg !110
  %60 = add i64 %17, 8, !dbg !110
  %61 = mul i64 %60, 2, !dbg !110
  %62 = add i64 %61, 0, !dbg !110
  %63 = getelementptr float, ptr %11, i64 %62, !dbg !110
  %64 = load <2 x float>, ptr %63, align 4, !dbg !110
  %65 = add i64 %17, 9, !dbg !110
  %66 = mul i64 %65, 2, !dbg !110
  %67 = add i64 %66, 0, !dbg !110
  %68 = getelementptr float, ptr %11, i64 %67, !dbg !110
  %69 = load <2 x float>, ptr %68, align 4, !dbg !110
  %70 = add i64 %17, 10, !dbg !110
  %71 = mul i64 %70, 2, !dbg !110
  %72 = add i64 %71, 0, !dbg !110
  %73 = getelementptr float, ptr %11, i64 %72, !dbg !110
  %74 = load <2 x float>, ptr %73, align 4, !dbg !110
  %75 = add i64 %17, 11, !dbg !110
  %76 = mul i64 %75, 2, !dbg !110
  %77 = add i64 %76, 0, !dbg !110
  %78 = getelementptr float, ptr %11, i64 %77, !dbg !110
  %79 = load <2 x float>, ptr %78, align 4, !dbg !110
  %80 = add i64 %17, 12, !dbg !110
  %81 = mul i64 %80, 2, !dbg !110
  %82 = add i64 %81, 0, !dbg !110
  %83 = getelementptr float, ptr %11, i64 %82, !dbg !110
  %84 = load <2 x float>, ptr %83, align 4, !dbg !110
  %85 = add i64 %17, 13, !dbg !110
  %86 = mul i64 %85, 2, !dbg !110
  %87 = add i64 %86, 0, !dbg !110
  %88 = getelementptr float, ptr %11, i64 %87, !dbg !110
  %89 = load <2 x float>, ptr %88, align 4, !dbg !110
  %90 = add i64 %17, 14, !dbg !110
  %91 = mul i64 %90, 2, !dbg !110
  %92 = add i64 %91, 0, !dbg !110
  %93 = getelementptr float, ptr %11, i64 %92, !dbg !110
  %94 = load <2 x float>, ptr %93, align 4, !dbg !110
  %95 = add i64 %17, 15, !dbg !110
  %96 = mul i64 %95, 2, !dbg !110
  %97 = add i64 %96, 0, !dbg !110
  %98 = getelementptr float, ptr %11, i64 %97, !dbg !110
  %99 = load <2 x float>, ptr %98, align 4, !dbg !110
  %100 = add nuw nsw i64 0, %17, !dbg !111
  %101 = getelementptr inbounds nuw float, ptr %7, i64 %100, !dbg !111
  %102 = load float, ptr %101, align 4, !dbg !111
  %103 = insertelement <2 x float> poison, float %102, i32 0, !dbg !111
  %104 = shufflevector <2 x float> %103, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %105 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %24, <2 x float> %104, <2 x float> %18), !dbg !111
  %106 = add nuw nsw i64 0, %25, !dbg !111
  %107 = getelementptr inbounds nuw float, ptr %7, i64 %106, !dbg !111
  %108 = load float, ptr %107, align 4, !dbg !111
  %109 = insertelement <2 x float> poison, float %108, i32 0, !dbg !111
  %110 = shufflevector <2 x float> %109, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %111 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %29, <2 x float> %110, <2 x float> %105), !dbg !111
  %112 = add nuw nsw i64 0, %30, !dbg !111
  %113 = getelementptr inbounds nuw float, ptr %7, i64 %112, !dbg !111
  %114 = load float, ptr %113, align 4, !dbg !111
  %115 = insertelement <2 x float> poison, float %114, i32 0, !dbg !111
  %116 = shufflevector <2 x float> %115, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %117 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %34, <2 x float> %116, <2 x float> %111), !dbg !111
  %118 = add nuw nsw i64 0, %35, !dbg !111
  %119 = getelementptr inbounds nuw float, ptr %7, i64 %118, !dbg !111
  %120 = load float, ptr %119, align 4, !dbg !111
  %121 = insertelement <2 x float> poison, float %120, i32 0, !dbg !111
  %122 = shufflevector <2 x float> %121, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %123 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %39, <2 x float> %122, <2 x float> %117), !dbg !111
  %124 = add nuw nsw i64 0, %40, !dbg !111
  %125 = getelementptr inbounds nuw float, ptr %7, i64 %124, !dbg !111
  %126 = load float, ptr %125, align 4, !dbg !111
  %127 = insertelement <2 x float> poison, float %126, i32 0, !dbg !111
  %128 = shufflevector <2 x float> %127, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %129 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %44, <2 x float> %128, <2 x float> %123), !dbg !111
  %130 = add nuw nsw i64 0, %45, !dbg !111
  %131 = getelementptr inbounds nuw float, ptr %7, i64 %130, !dbg !111
  %132 = load float, ptr %131, align 4, !dbg !111
  %133 = insertelement <2 x float> poison, float %132, i32 0, !dbg !111
  %134 = shufflevector <2 x float> %133, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %135 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %49, <2 x float> %134, <2 x float> %129), !dbg !111
  %136 = add nuw nsw i64 0, %50, !dbg !111
  %137 = getelementptr inbounds nuw float, ptr %7, i64 %136, !dbg !111
  %138 = load float, ptr %137, align 4, !dbg !111
  %139 = insertelement <2 x float> poison, float %138, i32 0, !dbg !111
  %140 = shufflevector <2 x float> %139, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %141 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %54, <2 x float> %140, <2 x float> %135), !dbg !111
  %142 = add nuw nsw i64 0, %55, !dbg !111
  %143 = getelementptr inbounds nuw float, ptr %7, i64 %142, !dbg !111
  %144 = load float, ptr %143, align 4, !dbg !111
  %145 = insertelement <2 x float> poison, float %144, i32 0, !dbg !111
  %146 = shufflevector <2 x float> %145, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %147 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %59, <2 x float> %146, <2 x float> %141), !dbg !111
  %148 = add nuw nsw i64 0, %60, !dbg !111
  %149 = getelementptr inbounds nuw float, ptr %7, i64 %148, !dbg !111
  %150 = load float, ptr %149, align 4, !dbg !111
  %151 = insertelement <2 x float> poison, float %150, i32 0, !dbg !111
  %152 = shufflevector <2 x float> %151, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %153 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %64, <2 x float> %152, <2 x float> %147), !dbg !111
  %154 = add nuw nsw i64 0, %65, !dbg !111
  %155 = getelementptr inbounds nuw float, ptr %7, i64 %154, !dbg !111
  %156 = load float, ptr %155, align 4, !dbg !111
  %157 = insertelement <2 x float> poison, float %156, i32 0, !dbg !111
  %158 = shufflevector <2 x float> %157, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %159 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %69, <2 x float> %158, <2 x float> %153), !dbg !111
  %160 = add nuw nsw i64 0, %70, !dbg !111
  %161 = getelementptr inbounds nuw float, ptr %7, i64 %160, !dbg !111
  %162 = load float, ptr %161, align 4, !dbg !111
  %163 = insertelement <2 x float> poison, float %162, i32 0, !dbg !111
  %164 = shufflevector <2 x float> %163, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %165 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %74, <2 x float> %164, <2 x float> %159), !dbg !111
  %166 = add nuw nsw i64 0, %75, !dbg !111
  %167 = getelementptr inbounds nuw float, ptr %7, i64 %166, !dbg !111
  %168 = load float, ptr %167, align 4, !dbg !111
  %169 = insertelement <2 x float> poison, float %168, i32 0, !dbg !111
  %170 = shufflevector <2 x float> %169, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %171 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %79, <2 x float> %170, <2 x float> %165), !dbg !111
  %172 = add nuw nsw i64 0, %80, !dbg !111
  %173 = getelementptr inbounds nuw float, ptr %7, i64 %172, !dbg !111
  %174 = load float, ptr %173, align 4, !dbg !111
  %175 = insertelement <2 x float> poison, float %174, i32 0, !dbg !111
  %176 = shufflevector <2 x float> %175, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %177 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %84, <2 x float> %176, <2 x float> %171), !dbg !111
  %178 = add nuw nsw i64 0, %85, !dbg !111
  %179 = getelementptr inbounds nuw float, ptr %7, i64 %178, !dbg !111
  %180 = load float, ptr %179, align 4, !dbg !111
  %181 = insertelement <2 x float> poison, float %180, i32 0, !dbg !111
  %182 = shufflevector <2 x float> %181, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %183 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %89, <2 x float> %182, <2 x float> %177), !dbg !111
  %184 = add nuw nsw i64 0, %90, !dbg !111
  %185 = getelementptr inbounds nuw float, ptr %7, i64 %184, !dbg !111
  %186 = load float, ptr %185, align 4, !dbg !111
  %187 = insertelement <2 x float> poison, float %186, i32 0, !dbg !111
  %188 = shufflevector <2 x float> %187, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %189 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %94, <2 x float> %188, <2 x float> %183), !dbg !111
  %190 = add nuw nsw i64 0, %95, !dbg !111
  %191 = getelementptr inbounds nuw float, ptr %7, i64 %190, !dbg !111
  %192 = load float, ptr %191, align 4, !dbg !111
  %193 = insertelement <2 x float> poison, float %192, i32 0, !dbg !111
  %194 = shufflevector <2 x float> %193, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !111
  %195 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %99, <2 x float> %194, <2 x float> %189), !dbg !111
  %196 = add i64 %17, 16, !dbg !110
  br label %16, !dbg !110

197:                                              ; preds = %16
  %198 = getelementptr float, ptr %15, i64 0, !dbg !111
  store <2 x float> %18, ptr %198, align 4, !dbg !111
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
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/conv2d_swap")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/conv2d_swap")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/conv2d_swap")
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
!95 = !DILocation(line: 19, column: 8, scope: !94)
!96 = !DILocation(line: 13, column: 8, scope: !94)
!97 = !DILocation(line: 14, column: 8, scope: !94)
!98 = !DILocation(line: 15, column: 8, scope: !94)
!99 = !DILocation(line: 20, column: 8, scope: !94)
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
