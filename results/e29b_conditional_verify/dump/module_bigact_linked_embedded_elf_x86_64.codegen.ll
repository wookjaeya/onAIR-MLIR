; ModuleID = 'bigact_linked'
source_filename = "bigact_linked"
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

@__constant_8xf32 = private constant [8 x float] [float 0x3FC45C35C0000000, float 0xBFBE7ED2C0000000, float 0x3FA226EBC0000000, float 0xBFBAD6D4A0000000, float 0x3FC1FF0F40000000, float 0xBF61BC9780000000, float 0xBFA30F29A0000000, float 0xBFC5FE2600000000], align 64
@0 = private constant [14 x i8] c"bigact_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [3 x ptr] [ptr @infer_dispatch_0_conv_30x30x8x3x3_f32, ptr @infer_dispatch_1_conv_28x28x4x3x3x8_f32, ptr @infer_dispatch_2_matmul_1x1x3136_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [3 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [38 x i8] c"infer_dispatch_0_conv_30x30x8x3x3_f32\00", align 1
@2 = private constant [40 x i8] c"infer_dispatch_1_conv_28x28x4x3x3x8_f32\00", align 1
@3 = private constant [37 x i8] c"infer_dispatch_2_matmul_1x1x3136_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [3 x ptr] [ptr @1, ptr @2, ptr @3]
@4 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@5 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@6 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [3 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @4 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @6 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_30x30x8x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_30x30x8x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_28x28x4x3x3x8_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_28x28x4x3x3x8_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x1x3136_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x1x3136_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [3 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_30x30x8x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_30x30x8x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_28x28x4x3x3x8_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_28x28x4x3x3x8_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x1x3136_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x1x3136_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 3, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_conv_30x30x8x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !7 {
  %4 = alloca float, i64 8, align 64, !dbg !83
  %5 = alloca float, i64 8, align 64, !dbg !84
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !85
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !85
  %8 = load ptr, ptr %7, align 8, !dbg !85
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !85
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !86
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !86
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !86
  %12 = load ptr, ptr %11, align 8, !dbg !86
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !86
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !87
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !87
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !87
  %16 = load ptr, ptr %15, align 8, !dbg !87
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !87
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !83
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !83
  %19 = zext i32 %18 to i64, !dbg !83
  %20 = mul nsw i64 %19, 2, !dbg !83
  %21 = getelementptr float, ptr %5, i64 0, !dbg !88
  store <8 x float> zeroinitializer, ptr %21, align 4, !dbg !88
  %22 = load <8 x float>, ptr @__constant_8xf32, align 4, !dbg !89
  br label %23, !dbg !83

23:                                               ; preds = %87, %3
  %24 = phi i64 [ %88, %87 ], [ 0, %3 ], !dbg !83
  %25 = icmp slt i64 %24, 2, !dbg !83
  br i1 %25, label %26, label %89, !dbg !83

26:                                               ; preds = %73, %23
  %27 = phi i64 [ %86, %73 ], [ 0, %23 ], !dbg !83
  %28 = icmp slt i64 %27, 30, !dbg !83
  br i1 %28, label %29, label %87, !dbg !83

29:                                               ; preds = %32, %26
  %30 = phi i64 [ %37, %32 ], [ 0, %26 ], !dbg !83
  %31 = icmp slt i64 %30, 8, !dbg !83
  br i1 %31, label %32, label %38, !dbg !83

32:                                               ; preds = %29
  %33 = add nuw nsw i64 0, %30, !dbg !83
  %34 = getelementptr inbounds nuw float, ptr %5, i64 %33, !dbg !83
  %35 = load float, ptr %34, align 4, !dbg !83
  %36 = getelementptr inbounds nuw float, ptr %4, i64 %33, !dbg !83
  store float %35, ptr %36, align 4, !dbg !83
  %37 = add i64 %30, 1, !dbg !83
  br label %29, !dbg !83

38:                                               ; preds = %71, %29
  %39 = phi i64 [ %72, %71 ], [ 0, %29 ], !dbg !83
  %40 = icmp slt i64 %39, 3, !dbg !83
  br i1 %40, label %41, label %73, !dbg !83

41:                                               ; preds = %38
  %42 = add i64 %39, %24, !dbg !83
  %43 = add i64 %42, %20, !dbg !83
  br label %44, !dbg !83

44:                                               ; preds = %69, %41
  %45 = phi i64 [ %70, %69 ], [ 0, %41 ], !dbg !83
  %46 = icmp slt i64 %45, 3, !dbg !83
  br i1 %46, label %47, label %71, !dbg !83

47:                                               ; preds = %44
  %48 = add i64 %45, %27, !dbg !83
  br label %49, !dbg !83

49:                                               ; preds = %52, %47
  %50 = phi i64 [ %68, %52 ], [ 0, %47 ], !dbg !83
  %51 = icmp slt i64 %50, 8, !dbg !83
  br i1 %51, label %52, label %69, !dbg !83

52:                                               ; preds = %49
  %53 = mul nuw nsw i64 %43, 32, !dbg !83
  %54 = add nuw nsw i64 %53, %48, !dbg !83
  %55 = getelementptr inbounds nuw float, ptr %8, i64 %54, !dbg !83
  %56 = load float, ptr %55, align 4, !dbg !83
  %57 = mul nuw nsw i64 %39, 24, !dbg !83
  %58 = mul nuw nsw i64 %45, 8, !dbg !83
  %59 = add nuw nsw i64 %57, %58, !dbg !83
  %60 = add nuw nsw i64 %59, %50, !dbg !83
  %61 = getelementptr inbounds nuw float, ptr %12, i64 %60, !dbg !83
  %62 = load float, ptr %61, align 4, !dbg !83
  %63 = add nuw nsw i64 0, %50, !dbg !83
  %64 = getelementptr inbounds nuw float, ptr %4, i64 %63, !dbg !83
  %65 = load float, ptr %64, align 4, !dbg !83
  %66 = fmul contract float %56, %62, !dbg !90
  %67 = fadd contract float %65, %66, !dbg !91
  store float %67, ptr %64, align 4, !dbg !83
  %68 = add i64 %50, 1, !dbg !83
  br label %49, !dbg !83

69:                                               ; preds = %49
  %70 = add i64 %45, 1, !dbg !83
  br label %44, !dbg !83

71:                                               ; preds = %44
  %72 = add i64 %39, 1, !dbg !83
  br label %38, !dbg !83

73:                                               ; preds = %38
  %74 = getelementptr float, ptr %4, i64 0, !dbg !89
  %75 = load <8 x float>, ptr %74, align 4, !dbg !89
  %76 = fadd contract <8 x float> %75, %22, !dbg !92
  %77 = fcmp ugt <8 x float> %76, zeroinitializer, !dbg !93
  %78 = select <8 x i1> %77, <8 x float> %76, <8 x float> zeroinitializer, !dbg !93
  %79 = select <8 x i1> zeroinitializer, <8 x float> zeroinitializer, <8 x float> %78, !dbg !93
  %80 = add i64 %20, %24, !dbg !83
  %81 = mul i64 %80, 240, !dbg !83
  %82 = mul i64 %27, 8, !dbg !83
  %83 = add i64 %81, %82, !dbg !83
  %84 = add i64 %83, 0, !dbg !83
  %85 = getelementptr float, ptr %16, i64 %84, !dbg !83
  store <8 x float> %79, ptr %85, align 4, !dbg !83
  %86 = add i64 %27, 1, !dbg !83
  br label %26, !dbg !83

87:                                               ; preds = %26
  %88 = add i64 %24, 1, !dbg !83
  br label %23, !dbg !83

89:                                               ; preds = %23
  ret i32 0, !dbg !94
}

define internal i32 @infer_dispatch_1_conv_28x28x4x3x3x8_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !95 {
  %4 = alloca float, i64 4, align 64, !dbg !96
  %5 = alloca float, i64 4, align 64, !dbg !97
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !98
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !98
  %8 = load ptr, ptr %7, align 8, !dbg !98
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !98
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !99
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !99
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !99
  %12 = load ptr, ptr %11, align 8, !dbg !99
  %13 = getelementptr float, ptr %12, i64 3216, !dbg !99
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !99
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !100
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !100
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !100
  %17 = load ptr, ptr %16, align 8, !dbg !100
  %18 = getelementptr float, ptr %17, i64 7200, !dbg !100
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !100
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !96
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !96
  %21 = zext i32 %20 to i64, !dbg !96
  %22 = mul nsw i64 %21, 2, !dbg !96
  %23 = getelementptr float, ptr %5, i64 0, !dbg !101
  store <4 x float> zeroinitializer, ptr %23, align 4, !dbg !101
  br label %24, !dbg !96

24:                                               ; preds = %96, %3
  %25 = phi i64 [ %97, %96 ], [ 0, %3 ], !dbg !96
  %26 = icmp slt i64 %25, 2, !dbg !96
  br i1 %26, label %27, label %98, !dbg !96

27:                                               ; preds = %83, %24
  %28 = phi i64 [ %95, %83 ], [ 0, %24 ], !dbg !96
  %29 = icmp slt i64 %28, 28, !dbg !96
  br i1 %29, label %30, label %96, !dbg !96

30:                                               ; preds = %33, %27
  %31 = phi i64 [ %38, %33 ], [ 0, %27 ], !dbg !96
  %32 = icmp slt i64 %31, 4, !dbg !96
  br i1 %32, label %33, label %39, !dbg !96

33:                                               ; preds = %30
  %34 = add nuw nsw i64 0, %31, !dbg !96
  %35 = getelementptr inbounds nuw float, ptr %5, i64 %34, !dbg !96
  %36 = load float, ptr %35, align 4, !dbg !96
  %37 = getelementptr inbounds nuw float, ptr %4, i64 %34, !dbg !96
  store float %36, ptr %37, align 4, !dbg !96
  %38 = add i64 %31, 1, !dbg !96
  br label %30, !dbg !96

39:                                               ; preds = %81, %30
  %40 = phi i64 [ %82, %81 ], [ 0, %30 ], !dbg !96
  %41 = icmp slt i64 %40, 3, !dbg !96
  br i1 %41, label %42, label %83, !dbg !96

42:                                               ; preds = %39
  %43 = add i64 %40, %25, !dbg !96
  %44 = add i64 %43, %22, !dbg !96
  br label %45, !dbg !96

45:                                               ; preds = %79, %42
  %46 = phi i64 [ %80, %79 ], [ 0, %42 ], !dbg !96
  %47 = icmp slt i64 %46, 3, !dbg !96
  br i1 %47, label %48, label %81, !dbg !96

48:                                               ; preds = %45
  %49 = add i64 %46, %28, !dbg !96
  br label %50, !dbg !96

50:                                               ; preds = %77, %48
  %51 = phi i64 [ %78, %77 ], [ 0, %48 ], !dbg !96
  %52 = icmp slt i64 %51, 4, !dbg !96
  br i1 %52, label %53, label %79, !dbg !96

53:                                               ; preds = %56, %50
  %54 = phi i64 [ %76, %56 ], [ 0, %50 ], !dbg !96
  %55 = icmp slt i64 %54, 8, !dbg !96
  br i1 %55, label %56, label %77, !dbg !96

56:                                               ; preds = %53
  %57 = mul nuw nsw i64 %44, 240, !dbg !96
  %58 = mul nuw nsw i64 %49, 8, !dbg !96
  %59 = add nuw nsw i64 %57, %58, !dbg !96
  %60 = add nuw nsw i64 %59, %54, !dbg !96
  %61 = getelementptr inbounds nuw float, ptr %8, i64 %60, !dbg !96
  %62 = load float, ptr %61, align 4, !dbg !96
  %63 = mul nuw nsw i64 %40, 96, !dbg !96
  %64 = mul nuw nsw i64 %46, 32, !dbg !96
  %65 = add nuw nsw i64 %63, %64, !dbg !96
  %66 = mul nuw nsw i64 %54, 4, !dbg !96
  %67 = add nuw nsw i64 %65, %66, !dbg !96
  %68 = add nuw nsw i64 %67, %51, !dbg !96
  %69 = getelementptr inbounds nuw float, ptr %13, i64 %68, !dbg !96
  %70 = load float, ptr %69, align 4, !dbg !96
  %71 = add nuw nsw i64 0, %51, !dbg !96
  %72 = getelementptr inbounds nuw float, ptr %4, i64 %71, !dbg !96
  %73 = load float, ptr %72, align 4, !dbg !96
  %74 = fmul contract float %62, %70, !dbg !102
  %75 = fadd contract float %73, %74, !dbg !103
  store float %75, ptr %72, align 4, !dbg !96
  %76 = add i64 %54, 1, !dbg !96
  br label %53, !dbg !96

77:                                               ; preds = %53
  %78 = add i64 %51, 1, !dbg !96
  br label %50, !dbg !96

79:                                               ; preds = %50
  %80 = add i64 %46, 1, !dbg !96
  br label %45, !dbg !96

81:                                               ; preds = %45
  %82 = add i64 %40, 1, !dbg !96
  br label %39, !dbg !96

83:                                               ; preds = %39
  %84 = getelementptr float, ptr %4, i64 0, !dbg !104
  %85 = load <4 x float>, ptr %84, align 4, !dbg !104
  %86 = fcmp ugt <4 x float> %85, zeroinitializer, !dbg !105
  %87 = select <4 x i1> %86, <4 x float> %85, <4 x float> zeroinitializer, !dbg !105
  %88 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %87, !dbg !105
  %89 = add i64 %22, %25, !dbg !96
  %90 = mul i64 %89, 112, !dbg !96
  %91 = mul i64 %28, 4, !dbg !96
  %92 = add i64 %90, %91, !dbg !96
  %93 = add i64 %92, 0, !dbg !96
  %94 = getelementptr float, ptr %18, i64 %93, !dbg !96
  store <4 x float> %88, ptr %94, align 4, !dbg !96
  %95 = add i64 %28, 1, !dbg !96
  br label %27, !dbg !96

96:                                               ; preds = %27
  %97 = add i64 %25, 1, !dbg !96
  br label %24, !dbg !96

98:                                               ; preds = %24
  ret i32 0, !dbg !106
}

define internal i32 @infer_dispatch_2_matmul_1x1x3136_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !107 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !108
  %6 = load ptr, ptr %5, align 8, !dbg !108
  %7 = getelementptr float, ptr %6, i64 7200, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !108
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !109
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !109
  %11 = load ptr, ptr %10, align 8, !dbg !109
  %12 = getelementptr float, ptr %11, i64 80, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !109
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !110
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !110
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !110
  %16 = load ptr, ptr %15, align 8, !dbg !110
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !110
  br label %17, !dbg !111

17:                                               ; preds = %21, %3
  %18 = phi i64 [ %152, %21 ], [ 0, %3 ], !dbg !111
  %19 = phi <1 x float> [ %151, %21 ], [ zeroinitializer, %3 ], !dbg !111
  %20 = icmp slt i64 %18, 3136, !dbg !111
  br i1 %20, label %21, label %153, !dbg !111

21:                                               ; preds = %17
  %22 = add i64 %18, 0, !dbg !111
  %23 = getelementptr float, ptr %12, i64 %22, !dbg !111
  %24 = load <16 x float>, ptr %23, align 4, !dbg !111
  %25 = extractelement <16 x float> %24, i64 0, !dbg !111
  %26 = insertelement <1 x float> poison, float %25, i64 0, !dbg !111
  %27 = extractelement <16 x float> %24, i64 1, !dbg !111
  %28 = insertelement <1 x float> poison, float %27, i64 0, !dbg !111
  %29 = extractelement <16 x float> %24, i64 2, !dbg !111
  %30 = insertelement <1 x float> poison, float %29, i64 0, !dbg !111
  %31 = extractelement <16 x float> %24, i64 3, !dbg !111
  %32 = insertelement <1 x float> poison, float %31, i64 0, !dbg !111
  %33 = extractelement <16 x float> %24, i64 4, !dbg !111
  %34 = insertelement <1 x float> poison, float %33, i64 0, !dbg !111
  %35 = extractelement <16 x float> %24, i64 5, !dbg !111
  %36 = insertelement <1 x float> poison, float %35, i64 0, !dbg !111
  %37 = extractelement <16 x float> %24, i64 6, !dbg !111
  %38 = insertelement <1 x float> poison, float %37, i64 0, !dbg !111
  %39 = extractelement <16 x float> %24, i64 7, !dbg !111
  %40 = insertelement <1 x float> poison, float %39, i64 0, !dbg !111
  %41 = extractelement <16 x float> %24, i64 8, !dbg !111
  %42 = insertelement <1 x float> poison, float %41, i64 0, !dbg !111
  %43 = extractelement <16 x float> %24, i64 9, !dbg !111
  %44 = insertelement <1 x float> poison, float %43, i64 0, !dbg !111
  %45 = extractelement <16 x float> %24, i64 10, !dbg !111
  %46 = insertelement <1 x float> poison, float %45, i64 0, !dbg !111
  %47 = extractelement <16 x float> %24, i64 11, !dbg !111
  %48 = insertelement <1 x float> poison, float %47, i64 0, !dbg !111
  %49 = extractelement <16 x float> %24, i64 12, !dbg !111
  %50 = insertelement <1 x float> poison, float %49, i64 0, !dbg !111
  %51 = extractelement <16 x float> %24, i64 13, !dbg !111
  %52 = insertelement <1 x float> poison, float %51, i64 0, !dbg !111
  %53 = extractelement <16 x float> %24, i64 14, !dbg !111
  %54 = insertelement <1 x float> poison, float %53, i64 0, !dbg !111
  %55 = extractelement <16 x float> %24, i64 15, !dbg !111
  %56 = insertelement <1 x float> poison, float %55, i64 0, !dbg !111
  %57 = add nuw nsw i64 0, %18, !dbg !112
  %58 = getelementptr inbounds nuw float, ptr %7, i64 %57, !dbg !112
  %59 = load float, ptr %58, align 4, !dbg !112
  %60 = insertelement <1 x float> poison, float %59, i32 0, !dbg !112
  %61 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %26, <1 x float> %60, <1 x float> %19), !dbg !112
  %62 = add i64 %18, 1, !dbg !112
  %63 = add nuw nsw i64 0, %62, !dbg !112
  %64 = getelementptr inbounds nuw float, ptr %7, i64 %63, !dbg !112
  %65 = load float, ptr %64, align 4, !dbg !112
  %66 = insertelement <1 x float> poison, float %65, i32 0, !dbg !112
  %67 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %28, <1 x float> %66, <1 x float> %61), !dbg !112
  %68 = add i64 %18, 2, !dbg !112
  %69 = add nuw nsw i64 0, %68, !dbg !112
  %70 = getelementptr inbounds nuw float, ptr %7, i64 %69, !dbg !112
  %71 = load float, ptr %70, align 4, !dbg !112
  %72 = insertelement <1 x float> poison, float %71, i32 0, !dbg !112
  %73 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %30, <1 x float> %72, <1 x float> %67), !dbg !112
  %74 = add i64 %18, 3, !dbg !112
  %75 = add nuw nsw i64 0, %74, !dbg !112
  %76 = getelementptr inbounds nuw float, ptr %7, i64 %75, !dbg !112
  %77 = load float, ptr %76, align 4, !dbg !112
  %78 = insertelement <1 x float> poison, float %77, i32 0, !dbg !112
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %32, <1 x float> %78, <1 x float> %73), !dbg !112
  %80 = add i64 %18, 4, !dbg !112
  %81 = add nuw nsw i64 0, %80, !dbg !112
  %82 = getelementptr inbounds nuw float, ptr %7, i64 %81, !dbg !112
  %83 = load float, ptr %82, align 4, !dbg !112
  %84 = insertelement <1 x float> poison, float %83, i32 0, !dbg !112
  %85 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %34, <1 x float> %84, <1 x float> %79), !dbg !112
  %86 = add i64 %18, 5, !dbg !112
  %87 = add nuw nsw i64 0, %86, !dbg !112
  %88 = getelementptr inbounds nuw float, ptr %7, i64 %87, !dbg !112
  %89 = load float, ptr %88, align 4, !dbg !112
  %90 = insertelement <1 x float> poison, float %89, i32 0, !dbg !112
  %91 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %36, <1 x float> %90, <1 x float> %85), !dbg !112
  %92 = add i64 %18, 6, !dbg !112
  %93 = add nuw nsw i64 0, %92, !dbg !112
  %94 = getelementptr inbounds nuw float, ptr %7, i64 %93, !dbg !112
  %95 = load float, ptr %94, align 4, !dbg !112
  %96 = insertelement <1 x float> poison, float %95, i32 0, !dbg !112
  %97 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %38, <1 x float> %96, <1 x float> %91), !dbg !112
  %98 = add i64 %18, 7, !dbg !112
  %99 = add nuw nsw i64 0, %98, !dbg !112
  %100 = getelementptr inbounds nuw float, ptr %7, i64 %99, !dbg !112
  %101 = load float, ptr %100, align 4, !dbg !112
  %102 = insertelement <1 x float> poison, float %101, i32 0, !dbg !112
  %103 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %40, <1 x float> %102, <1 x float> %97), !dbg !112
  %104 = add i64 %18, 8, !dbg !112
  %105 = add nuw nsw i64 0, %104, !dbg !112
  %106 = getelementptr inbounds nuw float, ptr %7, i64 %105, !dbg !112
  %107 = load float, ptr %106, align 4, !dbg !112
  %108 = insertelement <1 x float> poison, float %107, i32 0, !dbg !112
  %109 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %42, <1 x float> %108, <1 x float> %103), !dbg !112
  %110 = add i64 %18, 9, !dbg !112
  %111 = add nuw nsw i64 0, %110, !dbg !112
  %112 = getelementptr inbounds nuw float, ptr %7, i64 %111, !dbg !112
  %113 = load float, ptr %112, align 4, !dbg !112
  %114 = insertelement <1 x float> poison, float %113, i32 0, !dbg !112
  %115 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %114, <1 x float> %109), !dbg !112
  %116 = add i64 %18, 10, !dbg !112
  %117 = add nuw nsw i64 0, %116, !dbg !112
  %118 = getelementptr inbounds nuw float, ptr %7, i64 %117, !dbg !112
  %119 = load float, ptr %118, align 4, !dbg !112
  %120 = insertelement <1 x float> poison, float %119, i32 0, !dbg !112
  %121 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %46, <1 x float> %120, <1 x float> %115), !dbg !112
  %122 = add i64 %18, 11, !dbg !112
  %123 = add nuw nsw i64 0, %122, !dbg !112
  %124 = getelementptr inbounds nuw float, ptr %7, i64 %123, !dbg !112
  %125 = load float, ptr %124, align 4, !dbg !112
  %126 = insertelement <1 x float> poison, float %125, i32 0, !dbg !112
  %127 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %48, <1 x float> %126, <1 x float> %121), !dbg !112
  %128 = add i64 %18, 12, !dbg !112
  %129 = add nuw nsw i64 0, %128, !dbg !112
  %130 = getelementptr inbounds nuw float, ptr %7, i64 %129, !dbg !112
  %131 = load float, ptr %130, align 4, !dbg !112
  %132 = insertelement <1 x float> poison, float %131, i32 0, !dbg !112
  %133 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %50, <1 x float> %132, <1 x float> %127), !dbg !112
  %134 = add i64 %18, 13, !dbg !112
  %135 = add nuw nsw i64 0, %134, !dbg !112
  %136 = getelementptr inbounds nuw float, ptr %7, i64 %135, !dbg !112
  %137 = load float, ptr %136, align 4, !dbg !112
  %138 = insertelement <1 x float> poison, float %137, i32 0, !dbg !112
  %139 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %52, <1 x float> %138, <1 x float> %133), !dbg !112
  %140 = add i64 %18, 14, !dbg !112
  %141 = add nuw nsw i64 0, %140, !dbg !112
  %142 = getelementptr inbounds nuw float, ptr %7, i64 %141, !dbg !112
  %143 = load float, ptr %142, align 4, !dbg !112
  %144 = insertelement <1 x float> poison, float %143, i32 0, !dbg !112
  %145 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %54, <1 x float> %144, <1 x float> %139), !dbg !112
  %146 = add i64 %18, 15, !dbg !112
  %147 = add nuw nsw i64 0, %146, !dbg !112
  %148 = getelementptr inbounds nuw float, ptr %7, i64 %147, !dbg !112
  %149 = load float, ptr %148, align 4, !dbg !112
  %150 = insertelement <1 x float> poison, float %149, i32 0, !dbg !112
  %151 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %56, <1 x float> %150, <1 x float> %145), !dbg !112
  %152 = add i64 %18, 16, !dbg !111
  br label %17, !dbg !111

153:                                              ; preds = %17
  %154 = extractelement <1 x float> %19, i64 0, !dbg !112
  %155 = getelementptr inbounds nuw float, ptr %16, i64 0, !dbg !112
  store float %154, ptr %155, align 4, !dbg !112
  ret i32 0, !dbg !113
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

!llvm.dbg.cu = !{!0, !2, !4}
!llvm.module.flags = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "dump")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "dump")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "dump")
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = distinct !DISubprogram(name: "infer_dispatch_0_conv_30x30x8x3x3_f32", linkageName: "infer_dispatch_0_conv_30x30x8x3x3_f32", scope: !1, file: !1, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
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
!83 = !DILocation(line: 19, column: 8, scope: !7)
!84 = !DILocation(line: 18, column: 8, scope: !7)
!85 = !DILocation(line: 12, column: 8, scope: !7)
!86 = !DILocation(line: 13, column: 8, scope: !7)
!87 = !DILocation(line: 14, column: 8, scope: !7)
!88 = !DILocation(line: 9, column: 8, scope: !7)
!89 = !DILocation(line: 25, column: 8, scope: !7)
!90 = !DILocation(line: 21, column: 10, scope: !7)
!91 = !DILocation(line: 22, column: 10, scope: !7)
!92 = !DILocation(line: 27, column: 10, scope: !7)
!93 = !DILocation(line: 28, column: 10, scope: !7)
!94 = !DILocation(line: 32, column: 8, scope: !7)
!95 = distinct !DISubprogram(name: "infer_dispatch_1_conv_28x28x4x3x3x8_f32", linkageName: "infer_dispatch_1_conv_28x28x4x3x3x8_f32", scope: !3, file: !3, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!96 = !DILocation(line: 20, column: 8, scope: !95)
!97 = !DILocation(line: 19, column: 8, scope: !95)
!98 = !DILocation(line: 13, column: 8, scope: !95)
!99 = !DILocation(line: 14, column: 8, scope: !95)
!100 = !DILocation(line: 15, column: 8, scope: !95)
!101 = !DILocation(line: 9, column: 8, scope: !95)
!102 = !DILocation(line: 22, column: 10, scope: !95)
!103 = !DILocation(line: 23, column: 10, scope: !95)
!104 = !DILocation(line: 26, column: 8, scope: !95)
!105 = !DILocation(line: 28, column: 10, scope: !95)
!106 = !DILocation(line: 32, column: 8, scope: !95)
!107 = distinct !DISubprogram(name: "infer_dispatch_2_matmul_1x1x3136_f32", linkageName: "infer_dispatch_2_matmul_1x1x3136_f32", scope: !5, file: !5, line: 1, type: !8, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!108 = !DILocation(line: 13, column: 8, scope: !107)
!109 = !DILocation(line: 14, column: 8, scope: !107)
!110 = !DILocation(line: 15, column: 8, scope: !107)
!111 = !DILocation(line: 20, column: 8, scope: !107)
!112 = !DILocation(line: 1, column: 1, scope: !107)
!113 = !DILocation(line: 22, column: 8, scope: !107)
