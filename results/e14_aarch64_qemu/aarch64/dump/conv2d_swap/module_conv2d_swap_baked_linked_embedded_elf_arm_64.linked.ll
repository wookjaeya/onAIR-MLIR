; ModuleID = 'conv2d_swap_baked_linked'
source_filename = "conv2d_swap_baked_linked"
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
@4 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d_swap/configured_module_infer_dispatch_0.mlir\00", align 1
@5 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d_swap/configured_module_infer_dispatch_1.mlir\00", align 1
@6 = private constant [90 x i8] c"results/e14_aarch64_qemu/aarch64/dump/conv2d_swap/configured_module_infer_dispatch_2.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [3 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @4 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @5 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 89, ptr @6 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [3 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_conv_6x6x4x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_4x4x8x3x3x4_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_matmul_1x2x128_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 3, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_conv_6x6x4x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !13 {
  %4 = alloca float, i64 4, align 64, !dbg !89
  %5 = alloca float, i64 4, align 64, !dbg !90
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !91
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !91
  %8 = load ptr, ptr %7, align 8, !dbg !91
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !91
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !92
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !92
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !92
  %12 = load ptr, ptr %11, align 8, !dbg !92
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !92
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !89
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !89
  %15 = zext i32 %14 to i64, !dbg !89
  %16 = sdiv i64 %15, 2, !dbg !89
  %17 = mul i64 %16, 2, !dbg !89
  %18 = icmp ne i64 %15, %17, !dbg !89
  %19 = icmp slt i64 %15, 0, !dbg !89
  %20 = and i1 %18, %19, !dbg !89
  %21 = add i64 %16, -1, !dbg !89
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !89
  %23 = srem i64 %15, 2, !dbg !89
  %24 = icmp slt i64 %23, 0, !dbg !89
  %25 = add nsw i64 %23, 2, !dbg !89
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !89
  %27 = mul nsw i64 %26, 3, !dbg !89
  %28 = getelementptr float, ptr %5, i64 0, !dbg !93
  store <4 x float> zeroinitializer, ptr %28, align 4, !dbg !93
  %29 = load <4 x float>, ptr @__constant_4xf32, align 4, !dbg !94
  br label %30, !dbg !89

30:                                               ; preds = %77, %3
  %31 = phi i64 [ %90, %77 ], [ 0, %3 ], !dbg !89
  %32 = icmp slt i64 %31, 3, !dbg !89
  br i1 %32, label %33, label %91, !dbg !89

33:                                               ; preds = %36, %30
  %34 = phi i64 [ %41, %36 ], [ 0, %30 ], !dbg !89
  %35 = icmp slt i64 %34, 4, !dbg !89
  br i1 %35, label %36, label %42, !dbg !89

36:                                               ; preds = %33
  %37 = add nuw nsw i64 0, %34, !dbg !89
  %38 = getelementptr inbounds nuw float, ptr %5, i64 %37, !dbg !89
  %39 = load float, ptr %38, align 4, !dbg !89
  %40 = getelementptr inbounds nuw float, ptr %4, i64 %37, !dbg !89
  store float %39, ptr %40, align 4, !dbg !89
  %41 = add i64 %34, 1, !dbg !89
  br label %33, !dbg !89

42:                                               ; preds = %75, %33
  %43 = phi i64 [ %76, %75 ], [ 0, %33 ], !dbg !89
  %44 = icmp slt i64 %43, 3, !dbg !89
  br i1 %44, label %45, label %77, !dbg !89

45:                                               ; preds = %42
  %46 = add i64 %43, %22, !dbg !89
  br label %47, !dbg !89

47:                                               ; preds = %73, %45
  %48 = phi i64 [ %74, %73 ], [ 0, %45 ], !dbg !89
  %49 = icmp slt i64 %48, 3, !dbg !89
  br i1 %49, label %50, label %75, !dbg !89

50:                                               ; preds = %47
  %51 = add i64 %48, %31, !dbg !89
  %52 = add i64 %51, %27, !dbg !89
  br label %53, !dbg !89

53:                                               ; preds = %56, %50
  %54 = phi i64 [ %72, %56 ], [ 0, %50 ], !dbg !89
  %55 = icmp slt i64 %54, 4, !dbg !89
  br i1 %55, label %56, label %73, !dbg !89

56:                                               ; preds = %53
  %57 = mul nuw nsw i64 %46, 8, !dbg !89
  %58 = add nuw nsw i64 %57, %52, !dbg !89
  %59 = getelementptr inbounds nuw float, ptr %8, i64 %58, !dbg !89
  %60 = load float, ptr %59, align 4, !dbg !89
  %61 = mul nuw nsw i64 %43, 12, !dbg !89
  %62 = mul nuw nsw i64 %48, 4, !dbg !89
  %63 = add nuw nsw i64 %61, %62, !dbg !89
  %64 = add nuw nsw i64 %63, %54, !dbg !89
  %65 = getelementptr inbounds nuw float, ptr @__constant_3x3x4xf32, i64 %64, !dbg !89
  %66 = load float, ptr %65, align 4, !dbg !89
  %67 = add nuw nsw i64 0, %54, !dbg !89
  %68 = getelementptr inbounds nuw float, ptr %4, i64 %67, !dbg !89
  %69 = load float, ptr %68, align 4, !dbg !89
  %70 = fmul contract float %60, %66, !dbg !95
  %71 = fadd contract float %69, %70, !dbg !96
  store float %71, ptr %68, align 4, !dbg !89
  %72 = add i64 %54, 1, !dbg !89
  br label %53, !dbg !89

73:                                               ; preds = %53
  %74 = add i64 %48, 1, !dbg !89
  br label %47, !dbg !89

75:                                               ; preds = %47
  %76 = add i64 %43, 1, !dbg !89
  br label %42, !dbg !89

77:                                               ; preds = %42
  %78 = getelementptr float, ptr %4, i64 0, !dbg !94
  %79 = load <4 x float>, ptr %78, align 4, !dbg !94
  %80 = fadd contract <4 x float> %79, %29, !dbg !97
  %81 = fcmp ugt <4 x float> %80, zeroinitializer, !dbg !98
  %82 = select <4 x i1> %81, <4 x float> %80, <4 x float> zeroinitializer, !dbg !98
  %83 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %82, !dbg !98
  %84 = add i64 %27, %31, !dbg !89
  %85 = mul i64 %22, 24, !dbg !89
  %86 = mul i64 %84, 4, !dbg !89
  %87 = add i64 %85, %86, !dbg !89
  %88 = add i64 %87, 0, !dbg !89
  %89 = getelementptr float, ptr %12, i64 %88, !dbg !89
  store <4 x float> %83, ptr %89, align 4, !dbg !89
  %90 = add i64 %31, 1, !dbg !89
  br label %30, !dbg !89

91:                                               ; preds = %30
  ret i32 0, !dbg !99
}

define internal i32 @infer_dispatch_1_conv_4x4x8x3x3x4_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !100 {
  %4 = alloca float, i64 4, align 64, !dbg !101
  %5 = alloca float, i64 4, align 64, !dbg !102
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !103
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !103
  %8 = load ptr, ptr %7, align 8, !dbg !103
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !103
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !104
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !104
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !104
  %12 = load ptr, ptr %11, align 8, !dbg !104
  %13 = getelementptr float, ptr %12, i64 256, !dbg !104
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !104
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !105
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !105
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !105
  %17 = load ptr, ptr %16, align 8, !dbg !105
  %18 = getelementptr float, ptr %17, i64 144, !dbg !105
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !105
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !101
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !101
  %21 = zext i32 %20 to i64, !dbg !101
  %22 = sdiv i64 %21, 4, !dbg !101
  %23 = mul i64 %22, 4, !dbg !101
  %24 = icmp ne i64 %21, %23, !dbg !101
  %25 = icmp slt i64 %21, 0, !dbg !101
  %26 = and i1 %24, %25, !dbg !101
  %27 = add i64 %22, -1, !dbg !101
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !101
  %29 = srem i64 %21, 4, !dbg !101
  %30 = icmp slt i64 %29, 0, !dbg !101
  %31 = add nsw i64 %29, 4, !dbg !101
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !101
  %33 = getelementptr float, ptr %5, i64 0, !dbg !106
  store <4 x float> zeroinitializer, ptr %33, align 4, !dbg !106
  br label %34, !dbg !101

34:                                               ; preds = %90, %3
  %35 = phi i64 [ %101, %90 ], [ 0, %3 ], !dbg !101
  %36 = icmp slt i64 %35, 8, !dbg !101
  br i1 %36, label %37, label %102, !dbg !101

37:                                               ; preds = %40, %34
  %38 = phi i64 [ %45, %40 ], [ 0, %34 ], !dbg !101
  %39 = icmp slt i64 %38, 4, !dbg !101
  br i1 %39, label %40, label %46, !dbg !101

40:                                               ; preds = %37
  %41 = add nuw nsw i64 0, %38, !dbg !101
  %42 = getelementptr inbounds nuw float, ptr %5, i64 %41, !dbg !101
  %43 = load float, ptr %42, align 4, !dbg !101
  %44 = getelementptr inbounds nuw float, ptr %4, i64 %41, !dbg !101
  store float %43, ptr %44, align 4, !dbg !101
  %45 = add i64 %38, 1, !dbg !101
  br label %37, !dbg !101

46:                                               ; preds = %88, %37
  %47 = phi i64 [ %89, %88 ], [ 0, %37 ], !dbg !101
  %48 = icmp slt i64 %47, 3, !dbg !101
  br i1 %48, label %49, label %90, !dbg !101

49:                                               ; preds = %46
  %50 = add i64 %47, %28, !dbg !101
  br label %51, !dbg !101

51:                                               ; preds = %86, %49
  %52 = phi i64 [ %87, %86 ], [ 0, %49 ], !dbg !101
  %53 = icmp slt i64 %52, 3, !dbg !101
  br i1 %53, label %54, label %88, !dbg !101

54:                                               ; preds = %51
  %55 = add i64 %52, %32, !dbg !101
  br label %56, !dbg !101

56:                                               ; preds = %84, %54
  %57 = phi i64 [ %85, %84 ], [ 0, %54 ], !dbg !101
  %58 = icmp slt i64 %57, 4, !dbg !101
  br i1 %58, label %59, label %86, !dbg !101

59:                                               ; preds = %62, %56
  %60 = phi i64 [ %83, %62 ], [ 0, %56 ], !dbg !101
  %61 = icmp slt i64 %60, 4, !dbg !101
  br i1 %61, label %62, label %84, !dbg !101

62:                                               ; preds = %59
  %63 = mul nuw nsw i64 %50, 24, !dbg !101
  %64 = mul nuw nsw i64 %55, 4, !dbg !101
  %65 = add nuw nsw i64 %63, %64, !dbg !101
  %66 = add nuw nsw i64 %65, %60, !dbg !101
  %67 = getelementptr inbounds nuw float, ptr %8, i64 %66, !dbg !101
  %68 = load float, ptr %67, align 4, !dbg !101
  %69 = add i64 %35, %57, !dbg !101
  %70 = mul nuw nsw i64 %47, 96, !dbg !101
  %71 = mul nuw nsw i64 %52, 32, !dbg !101
  %72 = add nuw nsw i64 %70, %71, !dbg !101
  %73 = mul nuw nsw i64 %60, 8, !dbg !101
  %74 = add nuw nsw i64 %72, %73, !dbg !101
  %75 = add nuw nsw i64 %74, %69, !dbg !101
  %76 = getelementptr inbounds nuw float, ptr %13, i64 %75, !dbg !101
  %77 = load float, ptr %76, align 4, !dbg !101
  %78 = add nuw nsw i64 0, %57, !dbg !101
  %79 = getelementptr inbounds nuw float, ptr %4, i64 %78, !dbg !101
  %80 = load float, ptr %79, align 4, !dbg !101
  %81 = fmul contract float %68, %77, !dbg !107
  %82 = fadd contract float %80, %81, !dbg !108
  store float %82, ptr %79, align 4, !dbg !101
  %83 = add i64 %60, 1, !dbg !101
  br label %59, !dbg !101

84:                                               ; preds = %59
  %85 = add i64 %57, 1, !dbg !101
  br label %56, !dbg !101

86:                                               ; preds = %56
  %87 = add i64 %52, 1, !dbg !101
  br label %51, !dbg !101

88:                                               ; preds = %51
  %89 = add i64 %47, 1, !dbg !101
  br label %46, !dbg !101

90:                                               ; preds = %46
  %91 = getelementptr float, ptr %4, i64 0, !dbg !109
  %92 = load <4 x float>, ptr %91, align 4, !dbg !109
  %93 = fcmp ugt <4 x float> %92, zeroinitializer, !dbg !110
  %94 = select <4 x i1> %93, <4 x float> %92, <4 x float> zeroinitializer, !dbg !110
  %95 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %94, !dbg !110
  %96 = mul i64 %28, 32, !dbg !101
  %97 = mul i64 %32, 8, !dbg !101
  %98 = add i64 %96, %97, !dbg !101
  %99 = add i64 %98, %35, !dbg !101
  %100 = getelementptr float, ptr %18, i64 %99, !dbg !101
  store <4 x float> %95, ptr %100, align 4, !dbg !101
  %101 = add i64 %35, 4, !dbg !101
  br label %34, !dbg !101

102:                                              ; preds = %34
  ret i32 0, !dbg !111
}

define internal i32 @infer_dispatch_2_matmul_1x2x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !112 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !113
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !113
  %6 = load ptr, ptr %5, align 8, !dbg !113
  %7 = getelementptr float, ptr %6, i64 144, !dbg !113
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
  %19 = icmp slt i64 %17, 128, !dbg !116
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
  store i16 %36, ptr %2, align 4, !tbaa !119
  %37 = load float, ptr %2, align 4, !tbaa !121
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
  store i16 %37, ptr %2, align 4, !tbaa !119
  %38 = load float, ptr %2, align 4, !tbaa !121
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
  store volatile float %5, ptr %3, align 4, !tbaa !121
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !121
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
  store volatile float %16, ptr %3, align 4, !tbaa !121
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
  store volatile float %24, ptr %2, align 4, !tbaa !121
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
  br i1 %.not, label %19, label %6, !prof !123

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
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !124
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !127
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !128
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !130
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !130
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !130
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
  store volatile float %16, ptr %3, align 4, !tbaa !121
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
  store volatile float %23, ptr %2, align 4, !tbaa !121
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
  store volatile float %2, ptr %4, align 4, !tbaa !121
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !121
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
  %10 = load i32, ptr %1, align 4, !tbaa !9
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !9
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !9
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
  br i1 %or.cond99, label %.critedge, label %73, !prof !131

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !123

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
  br i1 %31, label %47, label %32, !prof !123

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
  store volatile float %46, ptr %3, align 4, !tbaa !121
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !121
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
  %82 = load double, ptr %81, align 8, !tbaa !132
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !134
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !130
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !130
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !130
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !130
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !130
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !135

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
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !136
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !128
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !130
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !130
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !130
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
  store volatile float %9, ptr %2, align 4, !tbaa !121
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

!llvm.dbg.cu = !{!0, !2, !4}
!llvm.module.flags = !{!6, !7, !8}
!llvm.errno.tbaa = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d_swap")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d_swap")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/conv2d_swap")
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 7, !"frame-pointer", i32 4}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !11, i64 0}
!11 = !{!"omnipotent char", !12, i64 0}
!12 = !{!"Simple C/C++ TBAA"}
!13 = distinct !DISubprogram(name: "infer_dispatch_0_conv_6x6x4x3x3_f32", linkageName: "infer_dispatch_0_conv_6x6x4x3x3_f32", scope: !1, file: !1, line: 1, type: !14, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!14 = !DISubroutineType(cc: DW_CC_normal, types: !15)
!15 = !{!16, !17, !48, !77}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !20)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !21, file: !21, line: 246, size: 768, elements: !22)
!21 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!22 = !{!23, !31, !34, !37, !39}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!26 = !DICompositeType(tag: DW_TAG_array_type, scope: !21, file: !21, line: 227, baseType: !27, size: 2048, elements: !29)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !28)
!28 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!29 = !{!30}
!30 = !DISubrange(count: 64)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !32, size: 64, offset: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !35, size: 64, offset: 128)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !38, size: 64, offset: 192)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !40, offset: 256)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !21, file: !21, line: 227, size: 512, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, scope: !21, file: !21, line: 227, baseType: !44, size: 512, elements: !46)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !45)
!45 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!46 = !{!47}
!47 = !DISubrange(count: 8)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !50)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !51)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !21, file: !21, line: 275, size: 384, elements: !52)
!52 = !{!53, !54, !55, !58, !59, !60, !61, !62, !65, !66, !67, !72}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !27, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !27, size: 32, offset: 32)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !56, size: 16, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !57)
!57 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !56, size: 16, offset: 80)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !27, size: 32, offset: 96)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !27, size: 32, offset: 128)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !56, size: 16, offset: 160)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !63, size: 8, offset: 176)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !64)
!64 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !63, size: 8, offset: 184)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !24, size: 64, offset: 192)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !68, size: 64, offset: 256)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, scope: !21, file: !21, line: 227, baseType: !71, size: 4096, elements: !29)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !73, size: 64, offset: 320)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !75)
!75 = !DICompositeType(tag: DW_TAG_array_type, scope: !21, file: !21, line: 227, baseType: !76, size: 4096, elements: !29)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !44)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !79)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !80)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !21, file: !21, line: 321, size: 256, elements: !81)
!81 = !{!82, !83, !84, !85, !86, !87, !88}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !27, size: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !27, size: 32, offset: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !56, size: 16, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !56, size: 16, offset: 80)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !27, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !32, size: 64, offset: 128)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !27, size: 32, offset: 192)
!89 = !DILocation(line: 18, column: 8, scope: !13)
!90 = !DILocation(line: 17, column: 8, scope: !13)
!91 = !DILocation(line: 13, column: 8, scope: !13)
!92 = !DILocation(line: 14, column: 8, scope: !13)
!93 = !DILocation(line: 10, column: 8, scope: !13)
!94 = !DILocation(line: 24, column: 8, scope: !13)
!95 = !DILocation(line: 20, column: 10, scope: !13)
!96 = !DILocation(line: 21, column: 10, scope: !13)
!97 = !DILocation(line: 26, column: 10, scope: !13)
!98 = !DILocation(line: 27, column: 10, scope: !13)
!99 = !DILocation(line: 31, column: 8, scope: !13)
!100 = distinct !DISubprogram(name: "infer_dispatch_1_conv_4x4x8x3x3x4_f32", linkageName: "infer_dispatch_1_conv_4x4x8x3x3x4_f32", scope: !3, file: !3, line: 1, type: !14, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!101 = !DILocation(line: 20, column: 8, scope: !100)
!102 = !DILocation(line: 19, column: 8, scope: !100)
!103 = !DILocation(line: 13, column: 8, scope: !100)
!104 = !DILocation(line: 14, column: 8, scope: !100)
!105 = !DILocation(line: 15, column: 8, scope: !100)
!106 = !DILocation(line: 9, column: 8, scope: !100)
!107 = !DILocation(line: 22, column: 10, scope: !100)
!108 = !DILocation(line: 23, column: 10, scope: !100)
!109 = !DILocation(line: 26, column: 8, scope: !100)
!110 = !DILocation(line: 28, column: 10, scope: !100)
!111 = !DILocation(line: 32, column: 8, scope: !100)
!112 = distinct !DISubprogram(name: "infer_dispatch_2_matmul_1x2x128_f32", linkageName: "infer_dispatch_2_matmul_1x2x128_f32", scope: !5, file: !5, line: 1, type: !14, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!113 = !DILocation(line: 12, column: 8, scope: !112)
!114 = !DILocation(line: 13, column: 8, scope: !112)
!115 = !DILocation(line: 14, column: 8, scope: !112)
!116 = !DILocation(line: 19, column: 8, scope: !112)
!117 = !DILocation(line: 1, column: 1, scope: !112)
!118 = !DILocation(line: 21, column: 8, scope: !112)
!119 = !{!120, !120, i64 0}
!120 = !{!"short", !11, i64 0}
!121 = !{!122, !122, i64 0}
!122 = !{!"float", !11, i64 0}
!123 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!124 = !{!125, !126, i64 296}
!125 = !{!"exp2f_data", !11, i64 0, !126, i64 256, !11, i64 264, !126, i64 288, !126, i64 296, !11, i64 304}
!126 = !{!"double", !11, i64 0}
!127 = !{!125, !126, i64 288}
!128 = !{!129, !129, i64 0}
!129 = !{!"long", !11, i64 0}
!130 = !{!126, !126, i64 0}
!131 = !{!"branch_weights", i32 4001, i32 4000000}
!132 = !{!133, !126, i64 0}
!133 = !{!"", !126, i64 0, !126, i64 8}
!134 = !{!133, !126, i64 8}
!135 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!136 = !{!125, !126, i64 256}
