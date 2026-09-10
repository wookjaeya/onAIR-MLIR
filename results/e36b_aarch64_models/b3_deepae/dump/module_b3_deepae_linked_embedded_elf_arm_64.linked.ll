; ModuleID = 'b3_deepae_linked'
source_filename = "b3_deepae_linked"
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

@__constant_1x8xf32 = private constant [1 x [8 x float]] [[8 x float] [float 0x40013F03A0000000, float 0x4003E6B640000000, float 0x40034DCDA0000000, float 0x400354D6A0000000, float 0x3FFF7649E0000000, float 0x4001DC7860000000, float 0x4005D58F00000000, float 0x40001FE060000000]], align 64
@0 = private constant [17 x i8] c"b3_deepae_linked\00", align 1
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
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_matmul_1x128x640_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !17 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !93
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !93
  %6 = load ptr, ptr %5, align 8, !dbg !93
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !93
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !94
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !94
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !94
  %10 = load ptr, ptr %9, align 8, !dbg !94
  %11 = getelementptr float, ptr %10, i64 183936, !dbg !94
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !94
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !95
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !95
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !95
  %15 = load ptr, ptr %14, align 8, !dbg !95
  %16 = getelementptr float, ptr %15, i64 1536, !dbg !95
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !95
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !96
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !96
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !96
  %20 = load ptr, ptr %19, align 8, !dbg !96
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !96
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !97
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !97
  %23 = zext i32 %22 to i64, !dbg !97
  %24 = mul nsw i64 %23, 16, !dbg !97
  br label %25, !dbg !97

25:                                               ; preds = %170, %3
  %26 = phi i64 [ %179, %170 ], [ 0, %3 ], !dbg !97
  %27 = icmp slt i64 %26, 16, !dbg !97
  br i1 %27, label %28, label %180, !dbg !97

28:                                               ; preds = %32, %25
  %29 = phi i64 [ %169, %32 ], [ 0, %25 ], !dbg !97
  %30 = phi <8 x float> [ %168, %32 ], [ zeroinitializer, %25 ], !dbg !97
  %31 = icmp slt i64 %29, 640, !dbg !97
  br i1 %31, label %32, label %170, !dbg !97

32:                                               ; preds = %28
  %33 = add i64 %26, %24, !dbg !97
  %34 = mul i64 %33, 640, !dbg !97
  %35 = add i64 %34, %29, !dbg !97
  %36 = getelementptr float, ptr %11, i64 %35, !dbg !97
  %37 = load <4 x float>, ptr %36, align 4, !dbg !97
  %38 = add i64 %33, 1, !dbg !97
  %39 = mul i64 %38, 640, !dbg !97
  %40 = add i64 %39, %29, !dbg !97
  %41 = getelementptr float, ptr %11, i64 %40, !dbg !97
  %42 = load <4 x float>, ptr %41, align 4, !dbg !97
  %43 = add i64 %33, 2, !dbg !97
  %44 = mul i64 %43, 640, !dbg !97
  %45 = add i64 %44, %29, !dbg !97
  %46 = getelementptr float, ptr %11, i64 %45, !dbg !97
  %47 = load <4 x float>, ptr %46, align 4, !dbg !97
  %48 = add i64 %33, 3, !dbg !97
  %49 = mul i64 %48, 640, !dbg !97
  %50 = add i64 %49, %29, !dbg !97
  %51 = getelementptr float, ptr %11, i64 %50, !dbg !97
  %52 = load <4 x float>, ptr %51, align 4, !dbg !97
  %53 = add i64 %33, 4, !dbg !97
  %54 = mul i64 %53, 640, !dbg !97
  %55 = add i64 %54, %29, !dbg !97
  %56 = getelementptr float, ptr %11, i64 %55, !dbg !97
  %57 = load <4 x float>, ptr %56, align 4, !dbg !97
  %58 = add i64 %33, 5, !dbg !97
  %59 = mul i64 %58, 640, !dbg !97
  %60 = add i64 %59, %29, !dbg !97
  %61 = getelementptr float, ptr %11, i64 %60, !dbg !97
  %62 = load <4 x float>, ptr %61, align 4, !dbg !97
  %63 = add i64 %33, 6, !dbg !97
  %64 = mul i64 %63, 640, !dbg !97
  %65 = add i64 %64, %29, !dbg !97
  %66 = getelementptr float, ptr %11, i64 %65, !dbg !97
  %67 = load <4 x float>, ptr %66, align 4, !dbg !97
  %68 = add i64 %33, 7, !dbg !97
  %69 = mul i64 %68, 640, !dbg !97
  %70 = add i64 %69, %29, !dbg !97
  %71 = getelementptr float, ptr %11, i64 %70, !dbg !97
  %72 = load <4 x float>, ptr %71, align 4, !dbg !97
  %73 = extractelement <4 x float> %37, i64 0, !dbg !97
  %74 = extractelement <4 x float> %37, i64 1, !dbg !97
  %75 = extractelement <4 x float> %37, i64 2, !dbg !97
  %76 = extractelement <4 x float> %37, i64 3, !dbg !97
  %77 = extractelement <4 x float> %42, i64 0, !dbg !97
  %78 = extractelement <4 x float> %42, i64 1, !dbg !97
  %79 = extractelement <4 x float> %42, i64 2, !dbg !97
  %80 = extractelement <4 x float> %42, i64 3, !dbg !97
  %81 = extractelement <4 x float> %47, i64 0, !dbg !97
  %82 = extractelement <4 x float> %47, i64 1, !dbg !97
  %83 = extractelement <4 x float> %47, i64 2, !dbg !97
  %84 = extractelement <4 x float> %47, i64 3, !dbg !97
  %85 = extractelement <4 x float> %52, i64 0, !dbg !97
  %86 = extractelement <4 x float> %52, i64 1, !dbg !97
  %87 = extractelement <4 x float> %52, i64 2, !dbg !97
  %88 = extractelement <4 x float> %52, i64 3, !dbg !97
  %89 = extractelement <4 x float> %57, i64 0, !dbg !97
  %90 = extractelement <4 x float> %57, i64 1, !dbg !97
  %91 = extractelement <4 x float> %57, i64 2, !dbg !97
  %92 = extractelement <4 x float> %57, i64 3, !dbg !97
  %93 = extractelement <4 x float> %62, i64 0, !dbg !97
  %94 = extractelement <4 x float> %62, i64 1, !dbg !97
  %95 = extractelement <4 x float> %62, i64 2, !dbg !97
  %96 = extractelement <4 x float> %62, i64 3, !dbg !97
  %97 = extractelement <4 x float> %67, i64 0, !dbg !97
  %98 = extractelement <4 x float> %67, i64 1, !dbg !97
  %99 = extractelement <4 x float> %67, i64 2, !dbg !97
  %100 = extractelement <4 x float> %67, i64 3, !dbg !97
  %101 = extractelement <4 x float> %72, i64 0, !dbg !97
  %102 = extractelement <4 x float> %72, i64 1, !dbg !97
  %103 = extractelement <4 x float> %72, i64 2, !dbg !97
  %104 = extractelement <4 x float> %72, i64 3, !dbg !97
  %105 = insertelement <32 x float> poison, float %73, i64 0
  %106 = insertelement <32 x float> %105, float %74, i64 1
  %107 = insertelement <32 x float> %106, float %75, i64 2
  %108 = insertelement <32 x float> %107, float %76, i64 3
  %109 = insertelement <32 x float> %108, float %77, i64 4
  %110 = insertelement <32 x float> %109, float %78, i64 5
  %111 = insertelement <32 x float> %110, float %79, i64 6
  %112 = insertelement <32 x float> %111, float %80, i64 7
  %113 = insertelement <32 x float> %112, float %81, i64 8
  %114 = insertelement <32 x float> %113, float %82, i64 9
  %115 = insertelement <32 x float> %114, float %83, i64 10
  %116 = insertelement <32 x float> %115, float %84, i64 11
  %117 = insertelement <32 x float> %116, float %85, i64 12
  %118 = insertelement <32 x float> %117, float %86, i64 13
  %119 = insertelement <32 x float> %118, float %87, i64 14
  %120 = insertelement <32 x float> %119, float %88, i64 15
  %121 = insertelement <32 x float> %120, float %89, i64 16
  %122 = insertelement <32 x float> %121, float %90, i64 17
  %123 = insertelement <32 x float> %122, float %91, i64 18
  %124 = insertelement <32 x float> %123, float %92, i64 19
  %125 = insertelement <32 x float> %124, float %93, i64 20
  %126 = insertelement <32 x float> %125, float %94, i64 21
  %127 = insertelement <32 x float> %126, float %95, i64 22
  %128 = insertelement <32 x float> %127, float %96, i64 23
  %129 = insertelement <32 x float> %128, float %97, i64 24
  %130 = insertelement <32 x float> %129, float %98, i64 25
  %131 = insertelement <32 x float> %130, float %99, i64 26
  %132 = insertelement <32 x float> %131, float %100, i64 27
  %133 = insertelement <32 x float> %132, float %101, i64 28
  %134 = insertelement <32 x float> %133, float %102, i64 29
  %135 = insertelement <32 x float> %134, float %103, i64 30
  %136 = insertelement <32 x float> %135, float %104, i64 31
  %137 = shufflevector <32 x float> %136, <32 x float> %136, <32 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %138 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %139 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %140 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %141 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %142 = add nuw nsw i64 0, %29
  %143 = getelementptr inbounds nuw float, ptr %6, i64 %142
  %144 = load float, ptr %143, align 4
  %145 = insertelement <8 x float> poison, float %144, i32 0
  %146 = shufflevector <8 x float> %145, <8 x float> poison, <8 x i32> zeroinitializer
  %147 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %138, <8 x float> %146, <8 x float> %30)
  %148 = add i64 %29, 1
  %149 = add nuw nsw i64 0, %148
  %150 = getelementptr inbounds nuw float, ptr %6, i64 %149
  %151 = load float, ptr %150, align 4
  %152 = insertelement <8 x float> poison, float %151, i32 0
  %153 = shufflevector <8 x float> %152, <8 x float> poison, <8 x i32> zeroinitializer
  %154 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %139, <8 x float> %153, <8 x float> %147)
  %155 = add i64 %29, 2
  %156 = add nuw nsw i64 0, %155
  %157 = getelementptr inbounds nuw float, ptr %6, i64 %156
  %158 = load float, ptr %157, align 4
  %159 = insertelement <8 x float> poison, float %158, i32 0
  %160 = shufflevector <8 x float> %159, <8 x float> poison, <8 x i32> zeroinitializer
  %161 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %140, <8 x float> %160, <8 x float> %154)
  %162 = add i64 %29, 3
  %163 = add nuw nsw i64 0, %162
  %164 = getelementptr inbounds nuw float, ptr %6, i64 %163
  %165 = load float, ptr %164, align 4
  %166 = insertelement <8 x float> poison, float %165, i32 0
  %167 = shufflevector <8 x float> %166, <8 x float> poison, <8 x i32> zeroinitializer
  %168 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %141, <8 x float> %167, <8 x float> %161)
  %169 = add i64 %29, 4, !dbg !97
  br label %28, !dbg !97

170:                                              ; preds = %28
  %171 = add i64 %26, %24, !dbg !98
  %172 = add i64 0, %171, !dbg !98
  %173 = getelementptr float, ptr %16, i64 %172, !dbg !98
  %174 = load <8 x float>, ptr %173, align 4, !dbg !98
  %175 = fadd contract <8 x float> %30, %174, !dbg !99
  %176 = fcmp ugt <8 x float> %175, zeroinitializer, !dbg !100
  %177 = select <8 x i1> %176, <8 x float> %175, <8 x float> zeroinitializer, !dbg !101
  %178 = getelementptr float, ptr %20, i64 %172, !dbg !97
  store <8 x float> %177, ptr %178, align 4, !dbg !97
  %179 = add i64 %26, 8, !dbg !97
  br label %25, !dbg !97

180:                                              ; preds = %25
  ret i32 0, !dbg !102
}

define internal i32 @infer_dispatch_1_matmul_1x128x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !103 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !104
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !104
  %6 = load i32, ptr %5, align 4, !dbg !104
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !105
  %8 = load i32, ptr %7, align 4, !dbg !105
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !106
  %10 = load i32, ptr %9, align 4, !dbg !106
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !107
  %12 = load i32, ptr %11, align 4, !dbg !107
  %13 = zext i32 %6 to i64, !dbg !108
  %14 = zext i32 %8 to i64, !dbg !109
  %15 = zext i32 %10 to i64, !dbg !110
  %16 = zext i32 %12 to i64, !dbg !111
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !112
  %18 = load ptr, ptr %17, align 8, !dbg !112
  %19 = mul i64 %13, 8, !dbg !112
  %20 = udiv i64 %19, 32, !dbg !112
  %21 = getelementptr float, ptr %18, i64 %20, !dbg !112
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !112
  %22 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !113
  %23 = extractvalue %iree_hal_executable_dispatch_state_v0_t %22, 10, !dbg !113
  %24 = getelementptr ptr, ptr %23, i32 1, !dbg !113
  %25 = load ptr, ptr %24, align 8, !dbg !113
  %26 = mul i64 %14, 8, !dbg !113
  %27 = udiv i64 %26, 32, !dbg !113
  %28 = getelementptr float, ptr %25, i64 %27, !dbg !113
  call void @llvm.assume(i1 true) [ "align"(ptr %28, i64 64) ], !dbg !113
  %29 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !114
  %30 = extractvalue %iree_hal_executable_dispatch_state_v0_t %29, 10, !dbg !114
  %31 = getelementptr ptr, ptr %30, i32 1, !dbg !114
  %32 = load ptr, ptr %31, align 8, !dbg !114
  %33 = mul i64 %15, 8, !dbg !114
  %34 = udiv i64 %33, 32, !dbg !114
  %35 = getelementptr float, ptr %32, i64 %34, !dbg !114
  call void @llvm.assume(i1 true) [ "align"(ptr %35, i64 64) ], !dbg !114
  %36 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !115
  %37 = extractvalue %iree_hal_executable_dispatch_state_v0_t %36, 10, !dbg !115
  %38 = getelementptr ptr, ptr %37, i32 2, !dbg !115
  %39 = load ptr, ptr %38, align 8, !dbg !115
  %40 = mul i64 %16, 8, !dbg !115
  %41 = udiv i64 %40, 32, !dbg !115
  %42 = getelementptr float, ptr %39, i64 %41, !dbg !115
  call void @llvm.assume(i1 true) [ "align"(ptr %42, i64 64) ], !dbg !115
  %43 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !116
  %44 = extractvalue %iree_hal_executable_workgroup_state_v0_t %43, 0, !dbg !116
  %45 = zext i32 %44 to i64, !dbg !116
  %46 = mul nsw i64 %45, 16, !dbg !116
  br label %47, !dbg !116

47:                                               ; preds = %192, %3
  %48 = phi i64 [ %201, %192 ], [ 0, %3 ], !dbg !116
  %49 = icmp slt i64 %48, 16, !dbg !116
  br i1 %49, label %50, label %202, !dbg !116

50:                                               ; preds = %54, %47
  %51 = phi i64 [ %191, %54 ], [ 0, %47 ], !dbg !116
  %52 = phi <8 x float> [ %190, %54 ], [ zeroinitializer, %47 ], !dbg !116
  %53 = icmp slt i64 %51, 128, !dbg !116
  br i1 %53, label %54, label %192, !dbg !116

54:                                               ; preds = %50
  %55 = add i64 %48, %46, !dbg !116
  %56 = mul i64 %55, 128, !dbg !116
  %57 = add i64 %56, %51, !dbg !116
  %58 = getelementptr float, ptr %28, i64 %57, !dbg !116
  %59 = load <4 x float>, ptr %58, align 4, !dbg !116
  %60 = add i64 %55, 1, !dbg !116
  %61 = mul i64 %60, 128, !dbg !116
  %62 = add i64 %61, %51, !dbg !116
  %63 = getelementptr float, ptr %28, i64 %62, !dbg !116
  %64 = load <4 x float>, ptr %63, align 4, !dbg !116
  %65 = add i64 %55, 2, !dbg !116
  %66 = mul i64 %65, 128, !dbg !116
  %67 = add i64 %66, %51, !dbg !116
  %68 = getelementptr float, ptr %28, i64 %67, !dbg !116
  %69 = load <4 x float>, ptr %68, align 4, !dbg !116
  %70 = add i64 %55, 3, !dbg !116
  %71 = mul i64 %70, 128, !dbg !116
  %72 = add i64 %71, %51, !dbg !116
  %73 = getelementptr float, ptr %28, i64 %72, !dbg !116
  %74 = load <4 x float>, ptr %73, align 4, !dbg !116
  %75 = add i64 %55, 4, !dbg !116
  %76 = mul i64 %75, 128, !dbg !116
  %77 = add i64 %76, %51, !dbg !116
  %78 = getelementptr float, ptr %28, i64 %77, !dbg !116
  %79 = load <4 x float>, ptr %78, align 4, !dbg !116
  %80 = add i64 %55, 5, !dbg !116
  %81 = mul i64 %80, 128, !dbg !116
  %82 = add i64 %81, %51, !dbg !116
  %83 = getelementptr float, ptr %28, i64 %82, !dbg !116
  %84 = load <4 x float>, ptr %83, align 4, !dbg !116
  %85 = add i64 %55, 6, !dbg !116
  %86 = mul i64 %85, 128, !dbg !116
  %87 = add i64 %86, %51, !dbg !116
  %88 = getelementptr float, ptr %28, i64 %87, !dbg !116
  %89 = load <4 x float>, ptr %88, align 4, !dbg !116
  %90 = add i64 %55, 7, !dbg !116
  %91 = mul i64 %90, 128, !dbg !116
  %92 = add i64 %91, %51, !dbg !116
  %93 = getelementptr float, ptr %28, i64 %92, !dbg !116
  %94 = load <4 x float>, ptr %93, align 4, !dbg !116
  %95 = extractelement <4 x float> %59, i64 0, !dbg !116
  %96 = extractelement <4 x float> %59, i64 1, !dbg !116
  %97 = extractelement <4 x float> %59, i64 2, !dbg !116
  %98 = extractelement <4 x float> %59, i64 3, !dbg !116
  %99 = extractelement <4 x float> %64, i64 0, !dbg !116
  %100 = extractelement <4 x float> %64, i64 1, !dbg !116
  %101 = extractelement <4 x float> %64, i64 2, !dbg !116
  %102 = extractelement <4 x float> %64, i64 3, !dbg !116
  %103 = extractelement <4 x float> %69, i64 0, !dbg !116
  %104 = extractelement <4 x float> %69, i64 1, !dbg !116
  %105 = extractelement <4 x float> %69, i64 2, !dbg !116
  %106 = extractelement <4 x float> %69, i64 3, !dbg !116
  %107 = extractelement <4 x float> %74, i64 0, !dbg !116
  %108 = extractelement <4 x float> %74, i64 1, !dbg !116
  %109 = extractelement <4 x float> %74, i64 2, !dbg !116
  %110 = extractelement <4 x float> %74, i64 3, !dbg !116
  %111 = extractelement <4 x float> %79, i64 0, !dbg !116
  %112 = extractelement <4 x float> %79, i64 1, !dbg !116
  %113 = extractelement <4 x float> %79, i64 2, !dbg !116
  %114 = extractelement <4 x float> %79, i64 3, !dbg !116
  %115 = extractelement <4 x float> %84, i64 0, !dbg !116
  %116 = extractelement <4 x float> %84, i64 1, !dbg !116
  %117 = extractelement <4 x float> %84, i64 2, !dbg !116
  %118 = extractelement <4 x float> %84, i64 3, !dbg !116
  %119 = extractelement <4 x float> %89, i64 0, !dbg !116
  %120 = extractelement <4 x float> %89, i64 1, !dbg !116
  %121 = extractelement <4 x float> %89, i64 2, !dbg !116
  %122 = extractelement <4 x float> %89, i64 3, !dbg !116
  %123 = extractelement <4 x float> %94, i64 0, !dbg !116
  %124 = extractelement <4 x float> %94, i64 1, !dbg !116
  %125 = extractelement <4 x float> %94, i64 2, !dbg !116
  %126 = extractelement <4 x float> %94, i64 3, !dbg !116
  %127 = insertelement <32 x float> poison, float %95, i64 0
  %128 = insertelement <32 x float> %127, float %96, i64 1
  %129 = insertelement <32 x float> %128, float %97, i64 2
  %130 = insertelement <32 x float> %129, float %98, i64 3
  %131 = insertelement <32 x float> %130, float %99, i64 4
  %132 = insertelement <32 x float> %131, float %100, i64 5
  %133 = insertelement <32 x float> %132, float %101, i64 6
  %134 = insertelement <32 x float> %133, float %102, i64 7
  %135 = insertelement <32 x float> %134, float %103, i64 8
  %136 = insertelement <32 x float> %135, float %104, i64 9
  %137 = insertelement <32 x float> %136, float %105, i64 10
  %138 = insertelement <32 x float> %137, float %106, i64 11
  %139 = insertelement <32 x float> %138, float %107, i64 12
  %140 = insertelement <32 x float> %139, float %108, i64 13
  %141 = insertelement <32 x float> %140, float %109, i64 14
  %142 = insertelement <32 x float> %141, float %110, i64 15
  %143 = insertelement <32 x float> %142, float %111, i64 16
  %144 = insertelement <32 x float> %143, float %112, i64 17
  %145 = insertelement <32 x float> %144, float %113, i64 18
  %146 = insertelement <32 x float> %145, float %114, i64 19
  %147 = insertelement <32 x float> %146, float %115, i64 20
  %148 = insertelement <32 x float> %147, float %116, i64 21
  %149 = insertelement <32 x float> %148, float %117, i64 22
  %150 = insertelement <32 x float> %149, float %118, i64 23
  %151 = insertelement <32 x float> %150, float %119, i64 24
  %152 = insertelement <32 x float> %151, float %120, i64 25
  %153 = insertelement <32 x float> %152, float %121, i64 26
  %154 = insertelement <32 x float> %153, float %122, i64 27
  %155 = insertelement <32 x float> %154, float %123, i64 28
  %156 = insertelement <32 x float> %155, float %124, i64 29
  %157 = insertelement <32 x float> %156, float %125, i64 30
  %158 = insertelement <32 x float> %157, float %126, i64 31
  %159 = shufflevector <32 x float> %158, <32 x float> %158, <32 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %160 = shufflevector <32 x float> %159, <32 x float> %159, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %161 = shufflevector <32 x float> %159, <32 x float> %159, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %162 = shufflevector <32 x float> %159, <32 x float> %159, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %163 = shufflevector <32 x float> %159, <32 x float> %159, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %164 = add nuw nsw i64 0, %51
  %165 = getelementptr inbounds nuw float, ptr %21, i64 %164
  %166 = load float, ptr %165, align 4
  %167 = insertelement <8 x float> poison, float %166, i32 0
  %168 = shufflevector <8 x float> %167, <8 x float> poison, <8 x i32> zeroinitializer
  %169 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %160, <8 x float> %168, <8 x float> %52)
  %170 = add i64 %51, 1
  %171 = add nuw nsw i64 0, %170
  %172 = getelementptr inbounds nuw float, ptr %21, i64 %171
  %173 = load float, ptr %172, align 4
  %174 = insertelement <8 x float> poison, float %173, i32 0
  %175 = shufflevector <8 x float> %174, <8 x float> poison, <8 x i32> zeroinitializer
  %176 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %161, <8 x float> %175, <8 x float> %169)
  %177 = add i64 %51, 2
  %178 = add nuw nsw i64 0, %177
  %179 = getelementptr inbounds nuw float, ptr %21, i64 %178
  %180 = load float, ptr %179, align 4
  %181 = insertelement <8 x float> poison, float %180, i32 0
  %182 = shufflevector <8 x float> %181, <8 x float> poison, <8 x i32> zeroinitializer
  %183 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %162, <8 x float> %182, <8 x float> %176)
  %184 = add i64 %51, 3
  %185 = add nuw nsw i64 0, %184
  %186 = getelementptr inbounds nuw float, ptr %21, i64 %185
  %187 = load float, ptr %186, align 4
  %188 = insertelement <8 x float> poison, float %187, i32 0
  %189 = shufflevector <8 x float> %188, <8 x float> poison, <8 x i32> zeroinitializer
  %190 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %163, <8 x float> %189, <8 x float> %183)
  %191 = add i64 %51, 4, !dbg !116
  br label %50, !dbg !116

192:                                              ; preds = %50
  %193 = add i64 %48, %46, !dbg !117
  %194 = add i64 0, %193, !dbg !117
  %195 = getelementptr float, ptr %35, i64 %194, !dbg !117
  %196 = load <8 x float>, ptr %195, align 4, !dbg !117
  %197 = fadd contract <8 x float> %52, %196, !dbg !118
  %198 = fcmp ugt <8 x float> %197, zeroinitializer, !dbg !119
  %199 = select <8 x i1> %198, <8 x float> %197, <8 x float> zeroinitializer, !dbg !120
  %200 = getelementptr float, ptr %42, i64 %194, !dbg !116
  store <8 x float> %199, ptr %200, align 4, !dbg !116
  %201 = add i64 %48, 8, !dbg !116
  br label %47, !dbg !116

202:                                              ; preds = %47
  ret i32 0, !dbg !121
}

define internal i32 @infer_dispatch_4_matmul_1x8x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !122 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !123
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !123
  %6 = load ptr, ptr %5, align 8, !dbg !123
  %7 = getelementptr float, ptr %6, i64 128, !dbg !123
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !123
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !124
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !124
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !124
  %11 = load ptr, ptr %10, align 8, !dbg !124
  %12 = getelementptr float, ptr %11, i64 34432, !dbg !124
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !124
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !125
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !125
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !125
  %16 = load ptr, ptr %15, align 8, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !125
  br label %17, !dbg !126

17:                                               ; preds = %21, %3
  %18 = phi i64 [ %142, %21 ], [ 0, %3 ], !dbg !126
  %19 = phi <8 x float> [ %141, %21 ], [ zeroinitializer, %3 ], !dbg !126
  %20 = icmp slt i64 %18, 128, !dbg !126
  br i1 %20, label %21, label %143, !dbg !126

21:                                               ; preds = %17
  %22 = add i64 0, %18, !dbg !126
  %23 = getelementptr float, ptr %12, i64 %22, !dbg !126
  %24 = load <4 x float>, ptr %23, align 4, !dbg !126
  %25 = add i64 128, %18, !dbg !126
  %26 = getelementptr float, ptr %12, i64 %25, !dbg !126
  %27 = load <4 x float>, ptr %26, align 4, !dbg !126
  %28 = add i64 256, %18, !dbg !126
  %29 = getelementptr float, ptr %12, i64 %28, !dbg !126
  %30 = load <4 x float>, ptr %29, align 4, !dbg !126
  %31 = add i64 384, %18, !dbg !126
  %32 = getelementptr float, ptr %12, i64 %31, !dbg !126
  %33 = load <4 x float>, ptr %32, align 4, !dbg !126
  %34 = add i64 512, %18, !dbg !126
  %35 = getelementptr float, ptr %12, i64 %34, !dbg !126
  %36 = load <4 x float>, ptr %35, align 4, !dbg !126
  %37 = add i64 640, %18, !dbg !126
  %38 = getelementptr float, ptr %12, i64 %37, !dbg !126
  %39 = load <4 x float>, ptr %38, align 4, !dbg !126
  %40 = add i64 768, %18, !dbg !126
  %41 = getelementptr float, ptr %12, i64 %40, !dbg !126
  %42 = load <4 x float>, ptr %41, align 4, !dbg !126
  %43 = add i64 896, %18, !dbg !126
  %44 = getelementptr float, ptr %12, i64 %43, !dbg !126
  %45 = load <4 x float>, ptr %44, align 4, !dbg !126
  %46 = extractelement <4 x float> %24, i64 0, !dbg !126
  %47 = extractelement <4 x float> %24, i64 1, !dbg !126
  %48 = extractelement <4 x float> %24, i64 2, !dbg !126
  %49 = extractelement <4 x float> %24, i64 3, !dbg !126
  %50 = extractelement <4 x float> %27, i64 0, !dbg !126
  %51 = extractelement <4 x float> %27, i64 1, !dbg !126
  %52 = extractelement <4 x float> %27, i64 2, !dbg !126
  %53 = extractelement <4 x float> %27, i64 3, !dbg !126
  %54 = extractelement <4 x float> %30, i64 0, !dbg !126
  %55 = extractelement <4 x float> %30, i64 1, !dbg !126
  %56 = extractelement <4 x float> %30, i64 2, !dbg !126
  %57 = extractelement <4 x float> %30, i64 3, !dbg !126
  %58 = extractelement <4 x float> %33, i64 0, !dbg !126
  %59 = extractelement <4 x float> %33, i64 1, !dbg !126
  %60 = extractelement <4 x float> %33, i64 2, !dbg !126
  %61 = extractelement <4 x float> %33, i64 3, !dbg !126
  %62 = extractelement <4 x float> %36, i64 0, !dbg !126
  %63 = extractelement <4 x float> %36, i64 1, !dbg !126
  %64 = extractelement <4 x float> %36, i64 2, !dbg !126
  %65 = extractelement <4 x float> %36, i64 3, !dbg !126
  %66 = extractelement <4 x float> %39, i64 0, !dbg !126
  %67 = extractelement <4 x float> %39, i64 1, !dbg !126
  %68 = extractelement <4 x float> %39, i64 2, !dbg !126
  %69 = extractelement <4 x float> %39, i64 3, !dbg !126
  %70 = extractelement <4 x float> %42, i64 0, !dbg !126
  %71 = extractelement <4 x float> %42, i64 1, !dbg !126
  %72 = extractelement <4 x float> %42, i64 2, !dbg !126
  %73 = extractelement <4 x float> %42, i64 3, !dbg !126
  %74 = extractelement <4 x float> %45, i64 0, !dbg !126
  %75 = extractelement <4 x float> %45, i64 1, !dbg !126
  %76 = extractelement <4 x float> %45, i64 2, !dbg !126
  %77 = extractelement <4 x float> %45, i64 3, !dbg !126
  %78 = insertelement <32 x float> poison, float %46, i64 0
  %79 = insertelement <32 x float> %78, float %47, i64 1
  %80 = insertelement <32 x float> %79, float %48, i64 2
  %81 = insertelement <32 x float> %80, float %49, i64 3
  %82 = insertelement <32 x float> %81, float %50, i64 4
  %83 = insertelement <32 x float> %82, float %51, i64 5
  %84 = insertelement <32 x float> %83, float %52, i64 6
  %85 = insertelement <32 x float> %84, float %53, i64 7
  %86 = insertelement <32 x float> %85, float %54, i64 8
  %87 = insertelement <32 x float> %86, float %55, i64 9
  %88 = insertelement <32 x float> %87, float %56, i64 10
  %89 = insertelement <32 x float> %88, float %57, i64 11
  %90 = insertelement <32 x float> %89, float %58, i64 12
  %91 = insertelement <32 x float> %90, float %59, i64 13
  %92 = insertelement <32 x float> %91, float %60, i64 14
  %93 = insertelement <32 x float> %92, float %61, i64 15
  %94 = insertelement <32 x float> %93, float %62, i64 16
  %95 = insertelement <32 x float> %94, float %63, i64 17
  %96 = insertelement <32 x float> %95, float %64, i64 18
  %97 = insertelement <32 x float> %96, float %65, i64 19
  %98 = insertelement <32 x float> %97, float %66, i64 20
  %99 = insertelement <32 x float> %98, float %67, i64 21
  %100 = insertelement <32 x float> %99, float %68, i64 22
  %101 = insertelement <32 x float> %100, float %69, i64 23
  %102 = insertelement <32 x float> %101, float %70, i64 24
  %103 = insertelement <32 x float> %102, float %71, i64 25
  %104 = insertelement <32 x float> %103, float %72, i64 26
  %105 = insertelement <32 x float> %104, float %73, i64 27
  %106 = insertelement <32 x float> %105, float %74, i64 28
  %107 = insertelement <32 x float> %106, float %75, i64 29
  %108 = insertelement <32 x float> %107, float %76, i64 30
  %109 = insertelement <32 x float> %108, float %77, i64 31
  %110 = shufflevector <32 x float> %109, <32 x float> %109, <32 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %111 = shufflevector <32 x float> %110, <32 x float> %110, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %112 = shufflevector <32 x float> %110, <32 x float> %110, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %113 = shufflevector <32 x float> %110, <32 x float> %110, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %114 = shufflevector <32 x float> %110, <32 x float> %110, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %115 = add nuw nsw i64 0, %18
  %116 = getelementptr inbounds nuw float, ptr %7, i64 %115
  %117 = load float, ptr %116, align 4
  %118 = insertelement <8 x float> poison, float %117, i32 0
  %119 = shufflevector <8 x float> %118, <8 x float> poison, <8 x i32> zeroinitializer
  %120 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %111, <8 x float> %119, <8 x float> %19)
  %121 = add i64 %18, 1
  %122 = add nuw nsw i64 0, %121
  %123 = getelementptr inbounds nuw float, ptr %7, i64 %122
  %124 = load float, ptr %123, align 4
  %125 = insertelement <8 x float> poison, float %124, i32 0
  %126 = shufflevector <8 x float> %125, <8 x float> poison, <8 x i32> zeroinitializer
  %127 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %112, <8 x float> %126, <8 x float> %120)
  %128 = add i64 %18, 2
  %129 = add nuw nsw i64 0, %128
  %130 = getelementptr inbounds nuw float, ptr %7, i64 %129
  %131 = load float, ptr %130, align 4
  %132 = insertelement <8 x float> poison, float %131, i32 0
  %133 = shufflevector <8 x float> %132, <8 x float> poison, <8 x i32> zeroinitializer
  %134 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %113, <8 x float> %133, <8 x float> %127)
  %135 = add i64 %18, 3
  %136 = add nuw nsw i64 0, %135
  %137 = getelementptr inbounds nuw float, ptr %7, i64 %136
  %138 = load float, ptr %137, align 4
  %139 = insertelement <8 x float> poison, float %138, i32 0
  %140 = shufflevector <8 x float> %139, <8 x float> poison, <8 x i32> zeroinitializer
  %141 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %114, <8 x float> %140, <8 x float> %134)
  %142 = add i64 %18, 4, !dbg !126
  br label %17, !dbg !126

143:                                              ; preds = %17
  %144 = load <8 x float>, ptr @__constant_1x8xf32, align 4, !dbg !127
  %145 = fadd contract <8 x float> %19, %144, !dbg !128
  %146 = fcmp ugt <8 x float> %145, zeroinitializer, !dbg !129
  %147 = select <8 x i1> %146, <8 x float> %145, <8 x float> zeroinitializer, !dbg !130
  %148 = getelementptr float, ptr %16, i64 0, !dbg !130
  store <8 x float> %147, ptr %148, align 4, !dbg !130
  ret i32 0, !dbg !131
}

define internal i32 @infer_dispatch_5_matmul_1x128x8_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !132 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !133
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !133
  %6 = load ptr, ptr %5, align 8, !dbg !133
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !133
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !134
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !134
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !134
  %10 = load ptr, ptr %9, align 8, !dbg !134
  %11 = getelementptr float, ptr %10, i64 51840, !dbg !134
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !134
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !135
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !135
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !135
  %15 = load ptr, ptr %14, align 8, !dbg !135
  %16 = getelementptr float, ptr %15, i64 1024, !dbg !135
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !135
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !136
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !136
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !136
  %20 = load ptr, ptr %19, align 8, !dbg !136
  %21 = getelementptr float, ptr %20, i64 16, !dbg !136
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !136
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !137
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !137
  %24 = zext i32 %23 to i64, !dbg !137
  %25 = mul nsw i64 %24, 16, !dbg !137
  br label %26, !dbg !137

26:                                               ; preds = %171, %3
  %27 = phi i64 [ %180, %171 ], [ 0, %3 ], !dbg !137
  %28 = icmp slt i64 %27, 16, !dbg !137
  br i1 %28, label %29, label %181, !dbg !137

29:                                               ; preds = %33, %26
  %30 = phi i64 [ %170, %33 ], [ 0, %26 ], !dbg !137
  %31 = phi <8 x float> [ %169, %33 ], [ zeroinitializer, %26 ], !dbg !137
  %32 = icmp slt i64 %30, 8, !dbg !137
  br i1 %32, label %33, label %171, !dbg !137

33:                                               ; preds = %29
  %34 = add i64 %27, %25, !dbg !137
  %35 = mul i64 %34, 8, !dbg !137
  %36 = add i64 %35, %30, !dbg !137
  %37 = getelementptr float, ptr %11, i64 %36, !dbg !137
  %38 = load <4 x float>, ptr %37, align 4, !dbg !137
  %39 = add i64 %34, 1, !dbg !137
  %40 = mul i64 %39, 8, !dbg !137
  %41 = add i64 %40, %30, !dbg !137
  %42 = getelementptr float, ptr %11, i64 %41, !dbg !137
  %43 = load <4 x float>, ptr %42, align 4, !dbg !137
  %44 = add i64 %34, 2, !dbg !137
  %45 = mul i64 %44, 8, !dbg !137
  %46 = add i64 %45, %30, !dbg !137
  %47 = getelementptr float, ptr %11, i64 %46, !dbg !137
  %48 = load <4 x float>, ptr %47, align 4, !dbg !137
  %49 = add i64 %34, 3, !dbg !137
  %50 = mul i64 %49, 8, !dbg !137
  %51 = add i64 %50, %30, !dbg !137
  %52 = getelementptr float, ptr %11, i64 %51, !dbg !137
  %53 = load <4 x float>, ptr %52, align 4, !dbg !137
  %54 = add i64 %34, 4, !dbg !137
  %55 = mul i64 %54, 8, !dbg !137
  %56 = add i64 %55, %30, !dbg !137
  %57 = getelementptr float, ptr %11, i64 %56, !dbg !137
  %58 = load <4 x float>, ptr %57, align 4, !dbg !137
  %59 = add i64 %34, 5, !dbg !137
  %60 = mul i64 %59, 8, !dbg !137
  %61 = add i64 %60, %30, !dbg !137
  %62 = getelementptr float, ptr %11, i64 %61, !dbg !137
  %63 = load <4 x float>, ptr %62, align 4, !dbg !137
  %64 = add i64 %34, 6, !dbg !137
  %65 = mul i64 %64, 8, !dbg !137
  %66 = add i64 %65, %30, !dbg !137
  %67 = getelementptr float, ptr %11, i64 %66, !dbg !137
  %68 = load <4 x float>, ptr %67, align 4, !dbg !137
  %69 = add i64 %34, 7, !dbg !137
  %70 = mul i64 %69, 8, !dbg !137
  %71 = add i64 %70, %30, !dbg !137
  %72 = getelementptr float, ptr %11, i64 %71, !dbg !137
  %73 = load <4 x float>, ptr %72, align 4, !dbg !137
  %74 = extractelement <4 x float> %38, i64 0, !dbg !137
  %75 = extractelement <4 x float> %38, i64 1, !dbg !137
  %76 = extractelement <4 x float> %38, i64 2, !dbg !137
  %77 = extractelement <4 x float> %38, i64 3, !dbg !137
  %78 = extractelement <4 x float> %43, i64 0, !dbg !137
  %79 = extractelement <4 x float> %43, i64 1, !dbg !137
  %80 = extractelement <4 x float> %43, i64 2, !dbg !137
  %81 = extractelement <4 x float> %43, i64 3, !dbg !137
  %82 = extractelement <4 x float> %48, i64 0, !dbg !137
  %83 = extractelement <4 x float> %48, i64 1, !dbg !137
  %84 = extractelement <4 x float> %48, i64 2, !dbg !137
  %85 = extractelement <4 x float> %48, i64 3, !dbg !137
  %86 = extractelement <4 x float> %53, i64 0, !dbg !137
  %87 = extractelement <4 x float> %53, i64 1, !dbg !137
  %88 = extractelement <4 x float> %53, i64 2, !dbg !137
  %89 = extractelement <4 x float> %53, i64 3, !dbg !137
  %90 = extractelement <4 x float> %58, i64 0, !dbg !137
  %91 = extractelement <4 x float> %58, i64 1, !dbg !137
  %92 = extractelement <4 x float> %58, i64 2, !dbg !137
  %93 = extractelement <4 x float> %58, i64 3, !dbg !137
  %94 = extractelement <4 x float> %63, i64 0, !dbg !137
  %95 = extractelement <4 x float> %63, i64 1, !dbg !137
  %96 = extractelement <4 x float> %63, i64 2, !dbg !137
  %97 = extractelement <4 x float> %63, i64 3, !dbg !137
  %98 = extractelement <4 x float> %68, i64 0, !dbg !137
  %99 = extractelement <4 x float> %68, i64 1, !dbg !137
  %100 = extractelement <4 x float> %68, i64 2, !dbg !137
  %101 = extractelement <4 x float> %68, i64 3, !dbg !137
  %102 = extractelement <4 x float> %73, i64 0, !dbg !137
  %103 = extractelement <4 x float> %73, i64 1, !dbg !137
  %104 = extractelement <4 x float> %73, i64 2, !dbg !137
  %105 = extractelement <4 x float> %73, i64 3, !dbg !137
  %106 = insertelement <32 x float> poison, float %74, i64 0
  %107 = insertelement <32 x float> %106, float %75, i64 1
  %108 = insertelement <32 x float> %107, float %76, i64 2
  %109 = insertelement <32 x float> %108, float %77, i64 3
  %110 = insertelement <32 x float> %109, float %78, i64 4
  %111 = insertelement <32 x float> %110, float %79, i64 5
  %112 = insertelement <32 x float> %111, float %80, i64 6
  %113 = insertelement <32 x float> %112, float %81, i64 7
  %114 = insertelement <32 x float> %113, float %82, i64 8
  %115 = insertelement <32 x float> %114, float %83, i64 9
  %116 = insertelement <32 x float> %115, float %84, i64 10
  %117 = insertelement <32 x float> %116, float %85, i64 11
  %118 = insertelement <32 x float> %117, float %86, i64 12
  %119 = insertelement <32 x float> %118, float %87, i64 13
  %120 = insertelement <32 x float> %119, float %88, i64 14
  %121 = insertelement <32 x float> %120, float %89, i64 15
  %122 = insertelement <32 x float> %121, float %90, i64 16
  %123 = insertelement <32 x float> %122, float %91, i64 17
  %124 = insertelement <32 x float> %123, float %92, i64 18
  %125 = insertelement <32 x float> %124, float %93, i64 19
  %126 = insertelement <32 x float> %125, float %94, i64 20
  %127 = insertelement <32 x float> %126, float %95, i64 21
  %128 = insertelement <32 x float> %127, float %96, i64 22
  %129 = insertelement <32 x float> %128, float %97, i64 23
  %130 = insertelement <32 x float> %129, float %98, i64 24
  %131 = insertelement <32 x float> %130, float %99, i64 25
  %132 = insertelement <32 x float> %131, float %100, i64 26
  %133 = insertelement <32 x float> %132, float %101, i64 27
  %134 = insertelement <32 x float> %133, float %102, i64 28
  %135 = insertelement <32 x float> %134, float %103, i64 29
  %136 = insertelement <32 x float> %135, float %104, i64 30
  %137 = insertelement <32 x float> %136, float %105, i64 31
  %138 = shufflevector <32 x float> %137, <32 x float> %137, <32 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %139 = shufflevector <32 x float> %138, <32 x float> %138, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %140 = shufflevector <32 x float> %138, <32 x float> %138, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %141 = shufflevector <32 x float> %138, <32 x float> %138, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %142 = shufflevector <32 x float> %138, <32 x float> %138, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %143 = add nuw nsw i64 0, %30
  %144 = getelementptr inbounds nuw float, ptr %6, i64 %143
  %145 = load float, ptr %144, align 4
  %146 = insertelement <8 x float> poison, float %145, i32 0
  %147 = shufflevector <8 x float> %146, <8 x float> poison, <8 x i32> zeroinitializer
  %148 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %139, <8 x float> %147, <8 x float> %31)
  %149 = add i64 %30, 1
  %150 = add nuw nsw i64 0, %149
  %151 = getelementptr inbounds nuw float, ptr %6, i64 %150
  %152 = load float, ptr %151, align 4
  %153 = insertelement <8 x float> poison, float %152, i32 0
  %154 = shufflevector <8 x float> %153, <8 x float> poison, <8 x i32> zeroinitializer
  %155 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %140, <8 x float> %154, <8 x float> %148)
  %156 = add i64 %30, 2
  %157 = add nuw nsw i64 0, %156
  %158 = getelementptr inbounds nuw float, ptr %6, i64 %157
  %159 = load float, ptr %158, align 4
  %160 = insertelement <8 x float> poison, float %159, i32 0
  %161 = shufflevector <8 x float> %160, <8 x float> poison, <8 x i32> zeroinitializer
  %162 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %141, <8 x float> %161, <8 x float> %155)
  %163 = add i64 %30, 3
  %164 = add nuw nsw i64 0, %163
  %165 = getelementptr inbounds nuw float, ptr %6, i64 %164
  %166 = load float, ptr %165, align 4
  %167 = insertelement <8 x float> poison, float %166, i32 0
  %168 = shufflevector <8 x float> %167, <8 x float> poison, <8 x i32> zeroinitializer
  %169 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %168, <8 x float> %162)
  %170 = add i64 %30, 4, !dbg !137
  br label %29, !dbg !137

171:                                              ; preds = %29
  %172 = add i64 %27, %25, !dbg !138
  %173 = add i64 0, %172, !dbg !138
  %174 = getelementptr float, ptr %16, i64 %173, !dbg !138
  %175 = load <8 x float>, ptr %174, align 4, !dbg !138
  %176 = fadd contract <8 x float> %31, %175, !dbg !139
  %177 = fcmp ugt <8 x float> %176, zeroinitializer, !dbg !140
  %178 = select <8 x i1> %177, <8 x float> %176, <8 x float> zeroinitializer, !dbg !141
  %179 = getelementptr float, ptr %21, i64 %173, !dbg !137
  store <8 x float> %178, ptr %179, align 4, !dbg !137
  %180 = add i64 %27, 8, !dbg !137
  br label %26, !dbg !137

181:                                              ; preds = %26
  ret i32 0, !dbg !142
}

define internal i32 @infer_dispatch_9_matmul_1x640x128_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !143 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !144
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !144
  %6 = load ptr, ptr %5, align 8, !dbg !144
  %7 = getelementptr float, ptr %6, i64 128, !dbg !144
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !144
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !145
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !145
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !145
  %11 = load ptr, ptr %10, align 8, !dbg !145
  %12 = getelementptr float, ptr %11, i64 102016, !dbg !145
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !145
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !146
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !146
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !146
  %16 = load ptr, ptr %15, align 8, !dbg !146
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !146
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !147
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !147
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !147
  %20 = load ptr, ptr %19, align 8, !dbg !147
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !147
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !148
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !148
  %23 = zext i32 %22 to i64, !dbg !148
  %24 = mul nsw i64 %23, 64, !dbg !148
  br label %25, !dbg !148

25:                                               ; preds = %170, %3
  %26 = phi i64 [ %177, %170 ], [ 0, %3 ], !dbg !148
  %27 = icmp slt i64 %26, 64, !dbg !148
  br i1 %27, label %28, label %178, !dbg !148

28:                                               ; preds = %32, %25
  %29 = phi i64 [ %169, %32 ], [ 0, %25 ], !dbg !148
  %30 = phi <8 x float> [ %168, %32 ], [ zeroinitializer, %25 ], !dbg !148
  %31 = icmp slt i64 %29, 128, !dbg !148
  br i1 %31, label %32, label %170, !dbg !148

32:                                               ; preds = %28
  %33 = add i64 %26, %24, !dbg !148
  %34 = mul i64 %33, 128, !dbg !148
  %35 = add i64 %34, %29, !dbg !148
  %36 = getelementptr float, ptr %12, i64 %35, !dbg !148
  %37 = load <4 x float>, ptr %36, align 4, !dbg !148
  %38 = add i64 %33, 1, !dbg !148
  %39 = mul i64 %38, 128, !dbg !148
  %40 = add i64 %39, %29, !dbg !148
  %41 = getelementptr float, ptr %12, i64 %40, !dbg !148
  %42 = load <4 x float>, ptr %41, align 4, !dbg !148
  %43 = add i64 %33, 2, !dbg !148
  %44 = mul i64 %43, 128, !dbg !148
  %45 = add i64 %44, %29, !dbg !148
  %46 = getelementptr float, ptr %12, i64 %45, !dbg !148
  %47 = load <4 x float>, ptr %46, align 4, !dbg !148
  %48 = add i64 %33, 3, !dbg !148
  %49 = mul i64 %48, 128, !dbg !148
  %50 = add i64 %49, %29, !dbg !148
  %51 = getelementptr float, ptr %12, i64 %50, !dbg !148
  %52 = load <4 x float>, ptr %51, align 4, !dbg !148
  %53 = add i64 %33, 4, !dbg !148
  %54 = mul i64 %53, 128, !dbg !148
  %55 = add i64 %54, %29, !dbg !148
  %56 = getelementptr float, ptr %12, i64 %55, !dbg !148
  %57 = load <4 x float>, ptr %56, align 4, !dbg !148
  %58 = add i64 %33, 5, !dbg !148
  %59 = mul i64 %58, 128, !dbg !148
  %60 = add i64 %59, %29, !dbg !148
  %61 = getelementptr float, ptr %12, i64 %60, !dbg !148
  %62 = load <4 x float>, ptr %61, align 4, !dbg !148
  %63 = add i64 %33, 6, !dbg !148
  %64 = mul i64 %63, 128, !dbg !148
  %65 = add i64 %64, %29, !dbg !148
  %66 = getelementptr float, ptr %12, i64 %65, !dbg !148
  %67 = load <4 x float>, ptr %66, align 4, !dbg !148
  %68 = add i64 %33, 7, !dbg !148
  %69 = mul i64 %68, 128, !dbg !148
  %70 = add i64 %69, %29, !dbg !148
  %71 = getelementptr float, ptr %12, i64 %70, !dbg !148
  %72 = load <4 x float>, ptr %71, align 4, !dbg !148
  %73 = extractelement <4 x float> %37, i64 0, !dbg !148
  %74 = extractelement <4 x float> %37, i64 1, !dbg !148
  %75 = extractelement <4 x float> %37, i64 2, !dbg !148
  %76 = extractelement <4 x float> %37, i64 3, !dbg !148
  %77 = extractelement <4 x float> %42, i64 0, !dbg !148
  %78 = extractelement <4 x float> %42, i64 1, !dbg !148
  %79 = extractelement <4 x float> %42, i64 2, !dbg !148
  %80 = extractelement <4 x float> %42, i64 3, !dbg !148
  %81 = extractelement <4 x float> %47, i64 0, !dbg !148
  %82 = extractelement <4 x float> %47, i64 1, !dbg !148
  %83 = extractelement <4 x float> %47, i64 2, !dbg !148
  %84 = extractelement <4 x float> %47, i64 3, !dbg !148
  %85 = extractelement <4 x float> %52, i64 0, !dbg !148
  %86 = extractelement <4 x float> %52, i64 1, !dbg !148
  %87 = extractelement <4 x float> %52, i64 2, !dbg !148
  %88 = extractelement <4 x float> %52, i64 3, !dbg !148
  %89 = extractelement <4 x float> %57, i64 0, !dbg !148
  %90 = extractelement <4 x float> %57, i64 1, !dbg !148
  %91 = extractelement <4 x float> %57, i64 2, !dbg !148
  %92 = extractelement <4 x float> %57, i64 3, !dbg !148
  %93 = extractelement <4 x float> %62, i64 0, !dbg !148
  %94 = extractelement <4 x float> %62, i64 1, !dbg !148
  %95 = extractelement <4 x float> %62, i64 2, !dbg !148
  %96 = extractelement <4 x float> %62, i64 3, !dbg !148
  %97 = extractelement <4 x float> %67, i64 0, !dbg !148
  %98 = extractelement <4 x float> %67, i64 1, !dbg !148
  %99 = extractelement <4 x float> %67, i64 2, !dbg !148
  %100 = extractelement <4 x float> %67, i64 3, !dbg !148
  %101 = extractelement <4 x float> %72, i64 0, !dbg !148
  %102 = extractelement <4 x float> %72, i64 1, !dbg !148
  %103 = extractelement <4 x float> %72, i64 2, !dbg !148
  %104 = extractelement <4 x float> %72, i64 3, !dbg !148
  %105 = insertelement <32 x float> poison, float %73, i64 0
  %106 = insertelement <32 x float> %105, float %74, i64 1
  %107 = insertelement <32 x float> %106, float %75, i64 2
  %108 = insertelement <32 x float> %107, float %76, i64 3
  %109 = insertelement <32 x float> %108, float %77, i64 4
  %110 = insertelement <32 x float> %109, float %78, i64 5
  %111 = insertelement <32 x float> %110, float %79, i64 6
  %112 = insertelement <32 x float> %111, float %80, i64 7
  %113 = insertelement <32 x float> %112, float %81, i64 8
  %114 = insertelement <32 x float> %113, float %82, i64 9
  %115 = insertelement <32 x float> %114, float %83, i64 10
  %116 = insertelement <32 x float> %115, float %84, i64 11
  %117 = insertelement <32 x float> %116, float %85, i64 12
  %118 = insertelement <32 x float> %117, float %86, i64 13
  %119 = insertelement <32 x float> %118, float %87, i64 14
  %120 = insertelement <32 x float> %119, float %88, i64 15
  %121 = insertelement <32 x float> %120, float %89, i64 16
  %122 = insertelement <32 x float> %121, float %90, i64 17
  %123 = insertelement <32 x float> %122, float %91, i64 18
  %124 = insertelement <32 x float> %123, float %92, i64 19
  %125 = insertelement <32 x float> %124, float %93, i64 20
  %126 = insertelement <32 x float> %125, float %94, i64 21
  %127 = insertelement <32 x float> %126, float %95, i64 22
  %128 = insertelement <32 x float> %127, float %96, i64 23
  %129 = insertelement <32 x float> %128, float %97, i64 24
  %130 = insertelement <32 x float> %129, float %98, i64 25
  %131 = insertelement <32 x float> %130, float %99, i64 26
  %132 = insertelement <32 x float> %131, float %100, i64 27
  %133 = insertelement <32 x float> %132, float %101, i64 28
  %134 = insertelement <32 x float> %133, float %102, i64 29
  %135 = insertelement <32 x float> %134, float %103, i64 30
  %136 = insertelement <32 x float> %135, float %104, i64 31
  %137 = shufflevector <32 x float> %136, <32 x float> %136, <32 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %138 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %139 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %140 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %141 = shufflevector <32 x float> %137, <32 x float> %137, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %142 = add nuw nsw i64 0, %29
  %143 = getelementptr inbounds nuw float, ptr %7, i64 %142
  %144 = load float, ptr %143, align 4
  %145 = insertelement <8 x float> poison, float %144, i32 0
  %146 = shufflevector <8 x float> %145, <8 x float> poison, <8 x i32> zeroinitializer
  %147 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %138, <8 x float> %146, <8 x float> %30)
  %148 = add i64 %29, 1
  %149 = add nuw nsw i64 0, %148
  %150 = getelementptr inbounds nuw float, ptr %7, i64 %149
  %151 = load float, ptr %150, align 4
  %152 = insertelement <8 x float> poison, float %151, i32 0
  %153 = shufflevector <8 x float> %152, <8 x float> poison, <8 x i32> zeroinitializer
  %154 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %139, <8 x float> %153, <8 x float> %147)
  %155 = add i64 %29, 2
  %156 = add nuw nsw i64 0, %155
  %157 = getelementptr inbounds nuw float, ptr %7, i64 %156
  %158 = load float, ptr %157, align 4
  %159 = insertelement <8 x float> poison, float %158, i32 0
  %160 = shufflevector <8 x float> %159, <8 x float> poison, <8 x i32> zeroinitializer
  %161 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %140, <8 x float> %160, <8 x float> %154)
  %162 = add i64 %29, 3
  %163 = add nuw nsw i64 0, %162
  %164 = getelementptr inbounds nuw float, ptr %7, i64 %163
  %165 = load float, ptr %164, align 4
  %166 = insertelement <8 x float> poison, float %165, i32 0
  %167 = shufflevector <8 x float> %166, <8 x float> poison, <8 x i32> zeroinitializer
  %168 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %141, <8 x float> %167, <8 x float> %161)
  %169 = add i64 %29, 4, !dbg !148
  br label %28, !dbg !148

170:                                              ; preds = %28
  %171 = add i64 %26, %24, !dbg !149
  %172 = add i64 0, %171, !dbg !149
  %173 = getelementptr float, ptr %16, i64 %172, !dbg !149
  %174 = load <8 x float>, ptr %173, align 4, !dbg !149
  %175 = fadd contract <8 x float> %30, %174, !dbg !150
  %176 = getelementptr float, ptr %20, i64 %172, !dbg !148
  store <8 x float> %175, ptr %176, align 4, !dbg !148
  %177 = add i64 %26, 8, !dbg !148
  br label %25, !dbg !148

178:                                              ; preds = %25
  ret i32 0, !dbg !151
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

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
  store i16 %36, ptr %2, align 4, !tbaa !152
  %37 = load float, ptr %2, align 4, !tbaa !154
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
  store i16 %37, ptr %2, align 4, !tbaa !152
  %38 = load float, ptr %2, align 4, !tbaa !154
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
  store volatile float %5, ptr %3, align 4, !tbaa !154
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !154
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
  store volatile float %16, ptr %3, align 4, !tbaa !154
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
  store volatile float %24, ptr %2, align 4, !tbaa !154
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
  br i1 %.not, label %19, label %6, !prof !156

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
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !157
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !160
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !161
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !163
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !163
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !163
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
  store volatile float %16, ptr %3, align 4, !tbaa !154
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
  store volatile float %23, ptr %2, align 4, !tbaa !154
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
  store volatile float %2, ptr %4, align 4, !tbaa !154
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !154
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
  %10 = load i32, ptr %1, align 4, !tbaa !13
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !13
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !13
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
  br i1 %or.cond99, label %.critedge, label %73, !prof !164

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !156

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
  br i1 %31, label %47, label %32, !prof !156

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
  store volatile float %46, ptr %3, align 4, !tbaa !154
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !154
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
  %82 = load double, ptr %81, align 8, !tbaa !165
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !167
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !163
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !163
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !163
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !163
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !163
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !168

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
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !169
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !161
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !163
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !163
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !163
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
  store volatile float %9, ptr %2, align 4, !tbaa !154
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

!llvm.dbg.cu = !{!0, !2, !4, !6, !8}
!llvm.module.flags = !{!10, !11, !12}
!llvm.errno.tbaa = !{!13}

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
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"frame-pointer", i32 4}
!13 = !{!14, !14, i64 0}
!14 = !{!"int", !15, i64 0}
!15 = !{!"omnipotent char", !16, i64 0}
!16 = !{!"Simple C/C++ TBAA"}
!17 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x128x640_f32", linkageName: "infer_dispatch_0_matmul_1x128x640_f32", scope: !1, file: !1, line: 1, type: !18, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!18 = !DISubroutineType(cc: DW_CC_normal, types: !19)
!19 = !{!20, !21, !52, !81}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !24)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !25, file: !25, line: 246, size: 768, elements: !26)
!25 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!26 = !{!27, !35, !38, !41, !43}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !28, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!30 = !DICompositeType(tag: DW_TAG_array_type, scope: !25, file: !25, line: 227, baseType: !31, size: 2048, elements: !33)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !32)
!32 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!33 = !{!34}
!34 = !DISubrange(count: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !36, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !39, size: 64, offset: 128)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !36)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !42, size: 64, offset: 192)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !44, offset: 256)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !25, file: !25, line: 227, size: 512, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !47)
!47 = !DICompositeType(tag: DW_TAG_array_type, scope: !25, file: !25, line: 227, baseType: !48, size: 512, elements: !50)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !49)
!49 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!50 = !{!51}
!51 = !DISubrange(count: 8)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !54)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !25, file: !25, line: 275, size: 384, elements: !56)
!56 = !{!57, !58, !59, !62, !63, !64, !65, !66, !69, !70, !71, !76}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !31, size: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !31, size: 32, offset: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !60, size: 16, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !61)
!61 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !60, size: 16, offset: 80)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !31, size: 32, offset: 96)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !31, size: 32, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !60, size: 16, offset: 160)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !67, size: 8, offset: 176)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !68)
!68 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !67, size: 8, offset: 184)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !28, size: 64, offset: 192)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !72, size: 64, offset: 256)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !74)
!74 = !DICompositeType(tag: DW_TAG_array_type, scope: !25, file: !25, line: 227, baseType: !75, size: 4096, elements: !33)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !77, size: 64, offset: 320)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !79)
!79 = !DICompositeType(tag: DW_TAG_array_type, scope: !25, file: !25, line: 227, baseType: !80, size: 4096, elements: !33)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !48)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !84)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !25, file: !25, line: 321, size: 256, elements: !85)
!85 = !{!86, !87, !88, !89, !90, !91, !92}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !31, size: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !31, size: 32, offset: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !60, size: 16, offset: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !60, size: 16, offset: 80)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !31, size: 32, offset: 96)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !36, size: 64, offset: 128)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !31, size: 32, offset: 192)
!93 = !DILocation(line: 13, column: 8, scope: !17)
!94 = !DILocation(line: 14, column: 8, scope: !17)
!95 = !DILocation(line: 15, column: 8, scope: !17)
!96 = !DILocation(line: 16, column: 8, scope: !17)
!97 = !DILocation(line: 22, column: 8, scope: !17)
!98 = !DILocation(line: 23, column: 8, scope: !17)
!99 = !DILocation(line: 25, column: 10, scope: !17)
!100 = !DILocation(line: 26, column: 10, scope: !17)
!101 = !DILocation(line: 27, column: 10, scope: !17)
!102 = !DILocation(line: 31, column: 8, scope: !17)
!103 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x128x128_f32", linkageName: "infer_dispatch_1_matmul_1x128x128_f32", scope: !3, file: !3, line: 1, type: !18, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!104 = !DILocation(line: 10, column: 8, scope: !103)
!105 = !DILocation(line: 11, column: 8, scope: !103)
!106 = !DILocation(line: 12, column: 8, scope: !103)
!107 = !DILocation(line: 13, column: 8, scope: !103)
!108 = !DILocation(line: 14, column: 8, scope: !103)
!109 = !DILocation(line: 15, column: 8, scope: !103)
!110 = !DILocation(line: 16, column: 8, scope: !103)
!111 = !DILocation(line: 17, column: 8, scope: !103)
!112 = !DILocation(line: 24, column: 8, scope: !103)
!113 = !DILocation(line: 25, column: 8, scope: !103)
!114 = !DILocation(line: 26, column: 8, scope: !103)
!115 = !DILocation(line: 27, column: 8, scope: !103)
!116 = !DILocation(line: 33, column: 8, scope: !103)
!117 = !DILocation(line: 34, column: 8, scope: !103)
!118 = !DILocation(line: 36, column: 10, scope: !103)
!119 = !DILocation(line: 37, column: 10, scope: !103)
!120 = !DILocation(line: 38, column: 10, scope: !103)
!121 = !DILocation(line: 42, column: 8, scope: !103)
!122 = distinct !DISubprogram(name: "infer_dispatch_4_matmul_1x8x128_f32", linkageName: "infer_dispatch_4_matmul_1x8x128_f32", scope: !5, file: !5, line: 1, type: !18, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!123 = !DILocation(line: 14, column: 8, scope: !122)
!124 = !DILocation(line: 15, column: 8, scope: !122)
!125 = !DILocation(line: 16, column: 8, scope: !122)
!126 = !DILocation(line: 21, column: 8, scope: !122)
!127 = !DILocation(line: 22, column: 8, scope: !122)
!128 = !DILocation(line: 24, column: 10, scope: !122)
!129 = !DILocation(line: 25, column: 10, scope: !122)
!130 = !DILocation(line: 26, column: 10, scope: !122)
!131 = !DILocation(line: 30, column: 8, scope: !122)
!132 = distinct !DISubprogram(name: "infer_dispatch_5_matmul_1x128x8_f32", linkageName: "infer_dispatch_5_matmul_1x128x8_f32", scope: !7, file: !7, line: 1, type: !18, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!133 = !DILocation(line: 14, column: 8, scope: !132)
!134 = !DILocation(line: 15, column: 8, scope: !132)
!135 = !DILocation(line: 16, column: 8, scope: !132)
!136 = !DILocation(line: 17, column: 8, scope: !132)
!137 = !DILocation(line: 23, column: 8, scope: !132)
!138 = !DILocation(line: 24, column: 8, scope: !132)
!139 = !DILocation(line: 26, column: 10, scope: !132)
!140 = !DILocation(line: 27, column: 10, scope: !132)
!141 = !DILocation(line: 28, column: 10, scope: !132)
!142 = !DILocation(line: 32, column: 8, scope: !132)
!143 = distinct !DISubprogram(name: "infer_dispatch_9_matmul_1x640x128_f32", linkageName: "infer_dispatch_9_matmul_1x640x128_f32", scope: !9, file: !9, line: 1, type: !18, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!144 = !DILocation(line: 13, column: 8, scope: !143)
!145 = !DILocation(line: 14, column: 8, scope: !143)
!146 = !DILocation(line: 15, column: 8, scope: !143)
!147 = !DILocation(line: 16, column: 8, scope: !143)
!148 = !DILocation(line: 22, column: 8, scope: !143)
!149 = !DILocation(line: 23, column: 8, scope: !143)
!150 = !DILocation(line: 25, column: 10, scope: !143)
!151 = !DILocation(line: 29, column: 8, scope: !143)
!152 = !{!153, !153, i64 0}
!153 = !{!"short", !15, i64 0}
!154 = !{!155, !155, i64 0}
!155 = !{!"float", !15, i64 0}
!156 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!157 = !{!158, !159, i64 296}
!158 = !{!"exp2f_data", !15, i64 0, !159, i64 256, !15, i64 264, !159, i64 288, !159, i64 296, !15, i64 304}
!159 = !{!"double", !15, i64 0}
!160 = !{!158, !159, i64 288}
!161 = !{!162, !162, i64 0}
!162 = !{!"long", !15, i64 0}
!163 = !{!159, !159, i64 0}
!164 = !{!"branch_weights", i32 4001, i32 4000000}
!165 = !{!166, !159, i64 0}
!166 = !{!"", !159, i64 0, !159, i64 8}
!167 = !{!166, !159, i64 8}
!168 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!169 = !{!158, !159, i64 256}
