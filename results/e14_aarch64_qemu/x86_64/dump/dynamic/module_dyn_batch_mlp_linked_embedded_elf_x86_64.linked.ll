; ModuleID = 'dyn_batch_mlp_linked'
source_filename = "dyn_batch_mlp_linked"
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
%iree_hal_executable_workgroup_state_v0_t = type { i32, i32, i16, i16, i32, ptr, i32 }

@0 = private constant [21 x i8] c"dyn_batch_mlp_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [2 x ptr] [ptr @infer_dispatch_0_matmul_Dx64x9_f32, ptr @infer_dispatch_1_matmul_Dx2x64_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [35 x i8] c"infer_dispatch_0_matmul_Dx64x9_f32\00", align 1
@2 = private constant [35 x i8] c"infer_dispatch_1_matmul_Dx2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [2 x ptr] [ptr @1, ptr @2]
@3 = private constant [85 x i8] c"results/e14_aarch64_qemu/x86_64/dump/dynamic/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [85 x i8] c"results/e14_aarch64_qemu/x86_64/dump/dynamic/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 84, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 84, ptr @4 }]
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
  %26 = mul nsw i64 %25, 64, !dbg !96
  %27 = mul nsw i64 %25, -64, !dbg !96
  %28 = add i64 %27, %12, !dbg !96
  %29 = icmp slt i64 %28, 64, !dbg !96
  %30 = select i1 %29, i64 %28, i64 64, !dbg !96
  br label %31, !dbg !96

31:                                               ; preds = %526, %3
  %32 = phi i64 [ %527, %526 ], [ 0, %3 ], !dbg !96
  %33 = icmp slt i64 %32, %30, !dbg !96
  br i1 %33, label %34, label %528, !dbg !96

34:                                               ; preds = %31
  %35 = sub i64 %30, %32, !dbg !96
  %36 = icmp slt i64 %35, 8, !dbg !96
  %37 = select i1 %36, i64 %35, i64 8, !dbg !96
  %38 = icmp sgt i64 %37, 0, !dbg !97
  %39 = select i1 %38, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %40 = icmp sgt i64 %37, 1, !dbg !97
  %41 = select i1 %40, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %42 = icmp sgt i64 %37, 2, !dbg !97
  %43 = select i1 %42, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %44 = icmp sgt i64 %37, 3, !dbg !97
  %45 = select i1 %44, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %46 = icmp sgt i64 %37, 4, !dbg !97
  %47 = select i1 %46, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %48 = icmp sgt i64 %37, 5, !dbg !97
  %49 = select i1 %48, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %50 = icmp sgt i64 %37, 6, !dbg !97
  %51 = select i1 %50, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %52 = icmp sgt i64 %37, 7, !dbg !97
  %53 = select i1 %52, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !97
  %54 = add i64 %32, %26, !dbg !96
  %55 = select i1 %38, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %56 = select i1 %40, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %57 = select i1 %42, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %58 = select i1 %44, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %59 = select i1 %46, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %60 = select i1 %48, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %61 = select i1 %50, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %62 = select i1 %52, <9 x i1> splat (i1 true), <9 x i1> zeroinitializer, !dbg !96
  %63 = mul i64 %54, 9, !dbg !96
  %64 = add i64 %63, 0, !dbg !96
  %65 = getelementptr float, ptr %18, i64 %64, !dbg !96
  %66 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %65, <9 x i1> %55, <9 x float> poison), !dbg !96
  %67 = add i64 %54, 1, !dbg !96
  %68 = mul i64 %67, 9, !dbg !96
  %69 = add i64 %68, 0, !dbg !96
  %70 = getelementptr float, ptr %18, i64 %69, !dbg !96
  %71 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %70, <9 x i1> %56, <9 x float> poison), !dbg !96
  %72 = add i64 %54, 2, !dbg !96
  %73 = mul i64 %72, 9, !dbg !96
  %74 = add i64 %73, 0, !dbg !96
  %75 = getelementptr float, ptr %18, i64 %74, !dbg !96
  %76 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %75, <9 x i1> %57, <9 x float> poison), !dbg !96
  %77 = add i64 %54, 3, !dbg !96
  %78 = mul i64 %77, 9, !dbg !96
  %79 = add i64 %78, 0, !dbg !96
  %80 = getelementptr float, ptr %18, i64 %79, !dbg !96
  %81 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %80, <9 x i1> %58, <9 x float> poison), !dbg !96
  %82 = add i64 %54, 4, !dbg !96
  %83 = mul i64 %82, 9, !dbg !96
  %84 = add i64 %83, 0, !dbg !96
  %85 = getelementptr float, ptr %18, i64 %84, !dbg !96
  %86 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %85, <9 x i1> %59, <9 x float> poison), !dbg !96
  %87 = add i64 %54, 5, !dbg !96
  %88 = mul i64 %87, 9, !dbg !96
  %89 = add i64 %88, 0, !dbg !96
  %90 = getelementptr float, ptr %18, i64 %89, !dbg !96
  %91 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %90, <9 x i1> %60, <9 x float> poison), !dbg !96
  %92 = add i64 %54, 6, !dbg !96
  %93 = mul i64 %92, 9, !dbg !96
  %94 = add i64 %93, 0, !dbg !96
  %95 = getelementptr float, ptr %18, i64 %94, !dbg !96
  %96 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %95, <9 x i1> %61, <9 x float> poison), !dbg !96
  %97 = add i64 %54, 7, !dbg !96
  %98 = mul i64 %97, 9, !dbg !96
  %99 = add i64 %98, 0, !dbg !96
  %100 = getelementptr float, ptr %18, i64 %99, !dbg !96
  %101 = call <9 x float> @llvm.masked.load.v9f32.p0(ptr align 4 %100, <9 x i1> %62, <9 x float> poison), !dbg !96
  br label %102, !dbg !96

102:                                              ; preds = %105, %34
  %103 = phi i64 [ %525, %105 ], [ 0, %34 ], !dbg !96
  %104 = icmp slt i64 %103, 64, !dbg !96
  br i1 %104, label %105, label %526, !dbg !96

105:                                              ; preds = %102
  %106 = mul i64 %54, 64, !dbg !98
  %107 = add i64 %106, %103, !dbg !98
  %108 = getelementptr float, ptr %22, i64 %107, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %108, <16 x i1> %39), !dbg !98
  %109 = mul i64 %67, 64, !dbg !98
  %110 = add i64 %109, %103, !dbg !98
  %111 = getelementptr float, ptr %22, i64 %110, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %111, <16 x i1> %41), !dbg !98
  %112 = mul i64 %72, 64, !dbg !98
  %113 = add i64 %112, %103, !dbg !98
  %114 = getelementptr float, ptr %22, i64 %113, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %114, <16 x i1> %43), !dbg !98
  %115 = mul i64 %77, 64, !dbg !98
  %116 = add i64 %115, %103, !dbg !98
  %117 = getelementptr float, ptr %22, i64 %116, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %117, <16 x i1> %45), !dbg !98
  %118 = mul i64 %82, 64, !dbg !98
  %119 = add i64 %118, %103, !dbg !98
  %120 = getelementptr float, ptr %22, i64 %119, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %120, <16 x i1> %47), !dbg !98
  %121 = mul i64 %87, 64, !dbg !98
  %122 = add i64 %121, %103, !dbg !98
  %123 = getelementptr float, ptr %22, i64 %122, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %123, <16 x i1> %49), !dbg !98
  %124 = mul i64 %92, 64, !dbg !98
  %125 = add i64 %124, %103, !dbg !98
  %126 = getelementptr float, ptr %22, i64 %125, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %126, <16 x i1> %51), !dbg !98
  %127 = mul i64 %97, 64, !dbg !98
  %128 = add i64 %127, %103, !dbg !98
  %129 = getelementptr float, ptr %22, i64 %128, !dbg !98
  call void @llvm.masked.store.v16f32.p0(<16 x float> zeroinitializer, ptr align 4 %129, <16 x i1> %53), !dbg !98
  %130 = add i64 0, %103, !dbg !96
  %131 = getelementptr float, ptr %15, i64 %130, !dbg !96
  %132 = load <16 x float>, ptr %131, align 4, !dbg !96
  %133 = add i64 64, %103, !dbg !96
  %134 = getelementptr float, ptr %15, i64 %133, !dbg !96
  %135 = load <16 x float>, ptr %134, align 4, !dbg !96
  %136 = add i64 128, %103, !dbg !96
  %137 = getelementptr float, ptr %15, i64 %136, !dbg !96
  %138 = load <16 x float>, ptr %137, align 4, !dbg !96
  %139 = add i64 192, %103, !dbg !96
  %140 = getelementptr float, ptr %15, i64 %139, !dbg !96
  %141 = load <16 x float>, ptr %140, align 4, !dbg !96
  %142 = add i64 256, %103, !dbg !96
  %143 = getelementptr float, ptr %15, i64 %142, !dbg !96
  %144 = load <16 x float>, ptr %143, align 4, !dbg !96
  %145 = add i64 320, %103, !dbg !96
  %146 = getelementptr float, ptr %15, i64 %145, !dbg !96
  %147 = load <16 x float>, ptr %146, align 4, !dbg !96
  %148 = add i64 384, %103, !dbg !96
  %149 = getelementptr float, ptr %15, i64 %148, !dbg !96
  %150 = load <16 x float>, ptr %149, align 4, !dbg !96
  %151 = add i64 448, %103, !dbg !96
  %152 = getelementptr float, ptr %15, i64 %151, !dbg !96
  %153 = load <16 x float>, ptr %152, align 4, !dbg !96
  %154 = add i64 512, %103, !dbg !96
  %155 = getelementptr float, ptr %15, i64 %154, !dbg !96
  %156 = load <16 x float>, ptr %155, align 4, !dbg !96
  %157 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %108, <16 x i1> %39, <16 x float> poison), !dbg !96
  %158 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %111, <16 x i1> %41, <16 x float> poison), !dbg !96
  %159 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %114, <16 x i1> %43, <16 x float> poison), !dbg !96
  %160 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %117, <16 x i1> %45, <16 x float> poison), !dbg !96
  %161 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %120, <16 x i1> %47, <16 x float> poison), !dbg !96
  %162 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %123, <16 x i1> %49, <16 x float> poison), !dbg !96
  %163 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %126, <16 x i1> %51, <16 x float> poison), !dbg !96
  %164 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %129, <16 x i1> %53, <16 x float> poison), !dbg !96
  %165 = extractelement <9 x float> %66, i64 0, !dbg !99
  %166 = insertelement <16 x float> poison, float %165, i32 0, !dbg !99
  %167 = shufflevector <16 x float> %166, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %168 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %167, <16 x float> %132, <16 x float> %157), !dbg !99
  %169 = select <16 x i1> %39, <16 x float> %168, <16 x float> %157, !dbg !99
  %170 = extractelement <9 x float> %71, i64 0, !dbg !99
  %171 = insertelement <16 x float> poison, float %170, i32 0, !dbg !99
  %172 = shufflevector <16 x float> %171, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %173 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %172, <16 x float> %132, <16 x float> %158), !dbg !99
  %174 = select <16 x i1> %41, <16 x float> %173, <16 x float> %158, !dbg !99
  %175 = extractelement <9 x float> %76, i64 0, !dbg !99
  %176 = insertelement <16 x float> poison, float %175, i32 0, !dbg !99
  %177 = shufflevector <16 x float> %176, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %178 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %177, <16 x float> %132, <16 x float> %159), !dbg !99
  %179 = select <16 x i1> %43, <16 x float> %178, <16 x float> %159, !dbg !99
  %180 = extractelement <9 x float> %81, i64 0, !dbg !99
  %181 = insertelement <16 x float> poison, float %180, i32 0, !dbg !99
  %182 = shufflevector <16 x float> %181, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %183 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %182, <16 x float> %132, <16 x float> %160), !dbg !99
  %184 = select <16 x i1> %45, <16 x float> %183, <16 x float> %160, !dbg !99
  %185 = extractelement <9 x float> %86, i64 0, !dbg !99
  %186 = insertelement <16 x float> poison, float %185, i32 0, !dbg !99
  %187 = shufflevector <16 x float> %186, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %188 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %187, <16 x float> %132, <16 x float> %161), !dbg !99
  %189 = select <16 x i1> %47, <16 x float> %188, <16 x float> %161, !dbg !99
  %190 = extractelement <9 x float> %91, i64 0, !dbg !99
  %191 = insertelement <16 x float> poison, float %190, i32 0, !dbg !99
  %192 = shufflevector <16 x float> %191, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %193 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %192, <16 x float> %132, <16 x float> %162), !dbg !99
  %194 = select <16 x i1> %49, <16 x float> %193, <16 x float> %162, !dbg !99
  %195 = extractelement <9 x float> %96, i64 0, !dbg !99
  %196 = insertelement <16 x float> poison, float %195, i32 0, !dbg !99
  %197 = shufflevector <16 x float> %196, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %198 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %197, <16 x float> %132, <16 x float> %163), !dbg !99
  %199 = select <16 x i1> %51, <16 x float> %198, <16 x float> %163, !dbg !99
  %200 = extractelement <9 x float> %101, i64 0, !dbg !99
  %201 = insertelement <16 x float> poison, float %200, i32 0, !dbg !99
  %202 = shufflevector <16 x float> %201, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %203 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %202, <16 x float> %132, <16 x float> %164), !dbg !99
  %204 = select <16 x i1> %53, <16 x float> %203, <16 x float> %164, !dbg !99
  %205 = extractelement <9 x float> %66, i64 1, !dbg !99
  %206 = insertelement <16 x float> poison, float %205, i32 0, !dbg !99
  %207 = shufflevector <16 x float> %206, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %208 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %207, <16 x float> %135, <16 x float> %169), !dbg !99
  %209 = select <16 x i1> %39, <16 x float> %208, <16 x float> %169, !dbg !99
  %210 = extractelement <9 x float> %71, i64 1, !dbg !99
  %211 = insertelement <16 x float> poison, float %210, i32 0, !dbg !99
  %212 = shufflevector <16 x float> %211, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %213 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %212, <16 x float> %135, <16 x float> %174), !dbg !99
  %214 = select <16 x i1> %41, <16 x float> %213, <16 x float> %174, !dbg !99
  %215 = extractelement <9 x float> %76, i64 1, !dbg !99
  %216 = insertelement <16 x float> poison, float %215, i32 0, !dbg !99
  %217 = shufflevector <16 x float> %216, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %218 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %217, <16 x float> %135, <16 x float> %179), !dbg !99
  %219 = select <16 x i1> %43, <16 x float> %218, <16 x float> %179, !dbg !99
  %220 = extractelement <9 x float> %81, i64 1, !dbg !99
  %221 = insertelement <16 x float> poison, float %220, i32 0, !dbg !99
  %222 = shufflevector <16 x float> %221, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %223 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %222, <16 x float> %135, <16 x float> %184), !dbg !99
  %224 = select <16 x i1> %45, <16 x float> %223, <16 x float> %184, !dbg !99
  %225 = extractelement <9 x float> %86, i64 1, !dbg !99
  %226 = insertelement <16 x float> poison, float %225, i32 0, !dbg !99
  %227 = shufflevector <16 x float> %226, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %228 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %227, <16 x float> %135, <16 x float> %189), !dbg !99
  %229 = select <16 x i1> %47, <16 x float> %228, <16 x float> %189, !dbg !99
  %230 = extractelement <9 x float> %91, i64 1, !dbg !99
  %231 = insertelement <16 x float> poison, float %230, i32 0, !dbg !99
  %232 = shufflevector <16 x float> %231, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %233 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %232, <16 x float> %135, <16 x float> %194), !dbg !99
  %234 = select <16 x i1> %49, <16 x float> %233, <16 x float> %194, !dbg !99
  %235 = extractelement <9 x float> %96, i64 1, !dbg !99
  %236 = insertelement <16 x float> poison, float %235, i32 0, !dbg !99
  %237 = shufflevector <16 x float> %236, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %238 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %237, <16 x float> %135, <16 x float> %199), !dbg !99
  %239 = select <16 x i1> %51, <16 x float> %238, <16 x float> %199, !dbg !99
  %240 = extractelement <9 x float> %101, i64 1, !dbg !99
  %241 = insertelement <16 x float> poison, float %240, i32 0, !dbg !99
  %242 = shufflevector <16 x float> %241, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %243 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %242, <16 x float> %135, <16 x float> %204), !dbg !99
  %244 = select <16 x i1> %53, <16 x float> %243, <16 x float> %204, !dbg !99
  %245 = extractelement <9 x float> %66, i64 2, !dbg !99
  %246 = insertelement <16 x float> poison, float %245, i32 0, !dbg !99
  %247 = shufflevector <16 x float> %246, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %248 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %247, <16 x float> %138, <16 x float> %209), !dbg !99
  %249 = select <16 x i1> %39, <16 x float> %248, <16 x float> %209, !dbg !99
  %250 = extractelement <9 x float> %71, i64 2, !dbg !99
  %251 = insertelement <16 x float> poison, float %250, i32 0, !dbg !99
  %252 = shufflevector <16 x float> %251, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %253 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %252, <16 x float> %138, <16 x float> %214), !dbg !99
  %254 = select <16 x i1> %41, <16 x float> %253, <16 x float> %214, !dbg !99
  %255 = extractelement <9 x float> %76, i64 2, !dbg !99
  %256 = insertelement <16 x float> poison, float %255, i32 0, !dbg !99
  %257 = shufflevector <16 x float> %256, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %258 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %257, <16 x float> %138, <16 x float> %219), !dbg !99
  %259 = select <16 x i1> %43, <16 x float> %258, <16 x float> %219, !dbg !99
  %260 = extractelement <9 x float> %81, i64 2, !dbg !99
  %261 = insertelement <16 x float> poison, float %260, i32 0, !dbg !99
  %262 = shufflevector <16 x float> %261, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %263 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %262, <16 x float> %138, <16 x float> %224), !dbg !99
  %264 = select <16 x i1> %45, <16 x float> %263, <16 x float> %224, !dbg !99
  %265 = extractelement <9 x float> %86, i64 2, !dbg !99
  %266 = insertelement <16 x float> poison, float %265, i32 0, !dbg !99
  %267 = shufflevector <16 x float> %266, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %268 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %267, <16 x float> %138, <16 x float> %229), !dbg !99
  %269 = select <16 x i1> %47, <16 x float> %268, <16 x float> %229, !dbg !99
  %270 = extractelement <9 x float> %91, i64 2, !dbg !99
  %271 = insertelement <16 x float> poison, float %270, i32 0, !dbg !99
  %272 = shufflevector <16 x float> %271, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %273 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %272, <16 x float> %138, <16 x float> %234), !dbg !99
  %274 = select <16 x i1> %49, <16 x float> %273, <16 x float> %234, !dbg !99
  %275 = extractelement <9 x float> %96, i64 2, !dbg !99
  %276 = insertelement <16 x float> poison, float %275, i32 0, !dbg !99
  %277 = shufflevector <16 x float> %276, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %278 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %277, <16 x float> %138, <16 x float> %239), !dbg !99
  %279 = select <16 x i1> %51, <16 x float> %278, <16 x float> %239, !dbg !99
  %280 = extractelement <9 x float> %101, i64 2, !dbg !99
  %281 = insertelement <16 x float> poison, float %280, i32 0, !dbg !99
  %282 = shufflevector <16 x float> %281, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %283 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %282, <16 x float> %138, <16 x float> %244), !dbg !99
  %284 = select <16 x i1> %53, <16 x float> %283, <16 x float> %244, !dbg !99
  %285 = extractelement <9 x float> %66, i64 3, !dbg !99
  %286 = insertelement <16 x float> poison, float %285, i32 0, !dbg !99
  %287 = shufflevector <16 x float> %286, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %288 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %287, <16 x float> %141, <16 x float> %249), !dbg !99
  %289 = select <16 x i1> %39, <16 x float> %288, <16 x float> %249, !dbg !99
  %290 = extractelement <9 x float> %71, i64 3, !dbg !99
  %291 = insertelement <16 x float> poison, float %290, i32 0, !dbg !99
  %292 = shufflevector <16 x float> %291, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %293 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %292, <16 x float> %141, <16 x float> %254), !dbg !99
  %294 = select <16 x i1> %41, <16 x float> %293, <16 x float> %254, !dbg !99
  %295 = extractelement <9 x float> %76, i64 3, !dbg !99
  %296 = insertelement <16 x float> poison, float %295, i32 0, !dbg !99
  %297 = shufflevector <16 x float> %296, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %298 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %297, <16 x float> %141, <16 x float> %259), !dbg !99
  %299 = select <16 x i1> %43, <16 x float> %298, <16 x float> %259, !dbg !99
  %300 = extractelement <9 x float> %81, i64 3, !dbg !99
  %301 = insertelement <16 x float> poison, float %300, i32 0, !dbg !99
  %302 = shufflevector <16 x float> %301, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %303 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %302, <16 x float> %141, <16 x float> %264), !dbg !99
  %304 = select <16 x i1> %45, <16 x float> %303, <16 x float> %264, !dbg !99
  %305 = extractelement <9 x float> %86, i64 3, !dbg !99
  %306 = insertelement <16 x float> poison, float %305, i32 0, !dbg !99
  %307 = shufflevector <16 x float> %306, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %308 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %307, <16 x float> %141, <16 x float> %269), !dbg !99
  %309 = select <16 x i1> %47, <16 x float> %308, <16 x float> %269, !dbg !99
  %310 = extractelement <9 x float> %91, i64 3, !dbg !99
  %311 = insertelement <16 x float> poison, float %310, i32 0, !dbg !99
  %312 = shufflevector <16 x float> %311, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %313 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %312, <16 x float> %141, <16 x float> %274), !dbg !99
  %314 = select <16 x i1> %49, <16 x float> %313, <16 x float> %274, !dbg !99
  %315 = extractelement <9 x float> %96, i64 3, !dbg !99
  %316 = insertelement <16 x float> poison, float %315, i32 0, !dbg !99
  %317 = shufflevector <16 x float> %316, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %318 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %317, <16 x float> %141, <16 x float> %279), !dbg !99
  %319 = select <16 x i1> %51, <16 x float> %318, <16 x float> %279, !dbg !99
  %320 = extractelement <9 x float> %101, i64 3, !dbg !99
  %321 = insertelement <16 x float> poison, float %320, i32 0, !dbg !99
  %322 = shufflevector <16 x float> %321, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %323 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %322, <16 x float> %141, <16 x float> %284), !dbg !99
  %324 = select <16 x i1> %53, <16 x float> %323, <16 x float> %284, !dbg !99
  %325 = extractelement <9 x float> %66, i64 4, !dbg !99
  %326 = insertelement <16 x float> poison, float %325, i32 0, !dbg !99
  %327 = shufflevector <16 x float> %326, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %328 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %327, <16 x float> %144, <16 x float> %289), !dbg !99
  %329 = select <16 x i1> %39, <16 x float> %328, <16 x float> %289, !dbg !99
  %330 = extractelement <9 x float> %71, i64 4, !dbg !99
  %331 = insertelement <16 x float> poison, float %330, i32 0, !dbg !99
  %332 = shufflevector <16 x float> %331, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %333 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %332, <16 x float> %144, <16 x float> %294), !dbg !99
  %334 = select <16 x i1> %41, <16 x float> %333, <16 x float> %294, !dbg !99
  %335 = extractelement <9 x float> %76, i64 4, !dbg !99
  %336 = insertelement <16 x float> poison, float %335, i32 0, !dbg !99
  %337 = shufflevector <16 x float> %336, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %338 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %337, <16 x float> %144, <16 x float> %299), !dbg !99
  %339 = select <16 x i1> %43, <16 x float> %338, <16 x float> %299, !dbg !99
  %340 = extractelement <9 x float> %81, i64 4, !dbg !99
  %341 = insertelement <16 x float> poison, float %340, i32 0, !dbg !99
  %342 = shufflevector <16 x float> %341, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %343 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %342, <16 x float> %144, <16 x float> %304), !dbg !99
  %344 = select <16 x i1> %45, <16 x float> %343, <16 x float> %304, !dbg !99
  %345 = extractelement <9 x float> %86, i64 4, !dbg !99
  %346 = insertelement <16 x float> poison, float %345, i32 0, !dbg !99
  %347 = shufflevector <16 x float> %346, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %348 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %347, <16 x float> %144, <16 x float> %309), !dbg !99
  %349 = select <16 x i1> %47, <16 x float> %348, <16 x float> %309, !dbg !99
  %350 = extractelement <9 x float> %91, i64 4, !dbg !99
  %351 = insertelement <16 x float> poison, float %350, i32 0, !dbg !99
  %352 = shufflevector <16 x float> %351, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %353 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %352, <16 x float> %144, <16 x float> %314), !dbg !99
  %354 = select <16 x i1> %49, <16 x float> %353, <16 x float> %314, !dbg !99
  %355 = extractelement <9 x float> %96, i64 4, !dbg !99
  %356 = insertelement <16 x float> poison, float %355, i32 0, !dbg !99
  %357 = shufflevector <16 x float> %356, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %358 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %357, <16 x float> %144, <16 x float> %319), !dbg !99
  %359 = select <16 x i1> %51, <16 x float> %358, <16 x float> %319, !dbg !99
  %360 = extractelement <9 x float> %101, i64 4, !dbg !99
  %361 = insertelement <16 x float> poison, float %360, i32 0, !dbg !99
  %362 = shufflevector <16 x float> %361, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %363 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %362, <16 x float> %144, <16 x float> %324), !dbg !99
  %364 = select <16 x i1> %53, <16 x float> %363, <16 x float> %324, !dbg !99
  %365 = extractelement <9 x float> %66, i64 5, !dbg !99
  %366 = insertelement <16 x float> poison, float %365, i32 0, !dbg !99
  %367 = shufflevector <16 x float> %366, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %368 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %367, <16 x float> %147, <16 x float> %329), !dbg !99
  %369 = select <16 x i1> %39, <16 x float> %368, <16 x float> %329, !dbg !99
  %370 = extractelement <9 x float> %71, i64 5, !dbg !99
  %371 = insertelement <16 x float> poison, float %370, i32 0, !dbg !99
  %372 = shufflevector <16 x float> %371, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %373 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %372, <16 x float> %147, <16 x float> %334), !dbg !99
  %374 = select <16 x i1> %41, <16 x float> %373, <16 x float> %334, !dbg !99
  %375 = extractelement <9 x float> %76, i64 5, !dbg !99
  %376 = insertelement <16 x float> poison, float %375, i32 0, !dbg !99
  %377 = shufflevector <16 x float> %376, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %378 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %377, <16 x float> %147, <16 x float> %339), !dbg !99
  %379 = select <16 x i1> %43, <16 x float> %378, <16 x float> %339, !dbg !99
  %380 = extractelement <9 x float> %81, i64 5, !dbg !99
  %381 = insertelement <16 x float> poison, float %380, i32 0, !dbg !99
  %382 = shufflevector <16 x float> %381, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %383 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %382, <16 x float> %147, <16 x float> %344), !dbg !99
  %384 = select <16 x i1> %45, <16 x float> %383, <16 x float> %344, !dbg !99
  %385 = extractelement <9 x float> %86, i64 5, !dbg !99
  %386 = insertelement <16 x float> poison, float %385, i32 0, !dbg !99
  %387 = shufflevector <16 x float> %386, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %388 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %387, <16 x float> %147, <16 x float> %349), !dbg !99
  %389 = select <16 x i1> %47, <16 x float> %388, <16 x float> %349, !dbg !99
  %390 = extractelement <9 x float> %91, i64 5, !dbg !99
  %391 = insertelement <16 x float> poison, float %390, i32 0, !dbg !99
  %392 = shufflevector <16 x float> %391, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %393 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %392, <16 x float> %147, <16 x float> %354), !dbg !99
  %394 = select <16 x i1> %49, <16 x float> %393, <16 x float> %354, !dbg !99
  %395 = extractelement <9 x float> %96, i64 5, !dbg !99
  %396 = insertelement <16 x float> poison, float %395, i32 0, !dbg !99
  %397 = shufflevector <16 x float> %396, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %398 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %397, <16 x float> %147, <16 x float> %359), !dbg !99
  %399 = select <16 x i1> %51, <16 x float> %398, <16 x float> %359, !dbg !99
  %400 = extractelement <9 x float> %101, i64 5, !dbg !99
  %401 = insertelement <16 x float> poison, float %400, i32 0, !dbg !99
  %402 = shufflevector <16 x float> %401, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %403 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %402, <16 x float> %147, <16 x float> %364), !dbg !99
  %404 = select <16 x i1> %53, <16 x float> %403, <16 x float> %364, !dbg !99
  %405 = extractelement <9 x float> %66, i64 6, !dbg !99
  %406 = insertelement <16 x float> poison, float %405, i32 0, !dbg !99
  %407 = shufflevector <16 x float> %406, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %408 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %407, <16 x float> %150, <16 x float> %369), !dbg !99
  %409 = select <16 x i1> %39, <16 x float> %408, <16 x float> %369, !dbg !99
  %410 = extractelement <9 x float> %71, i64 6, !dbg !99
  %411 = insertelement <16 x float> poison, float %410, i32 0, !dbg !99
  %412 = shufflevector <16 x float> %411, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %413 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %412, <16 x float> %150, <16 x float> %374), !dbg !99
  %414 = select <16 x i1> %41, <16 x float> %413, <16 x float> %374, !dbg !99
  %415 = extractelement <9 x float> %76, i64 6, !dbg !99
  %416 = insertelement <16 x float> poison, float %415, i32 0, !dbg !99
  %417 = shufflevector <16 x float> %416, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %418 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %417, <16 x float> %150, <16 x float> %379), !dbg !99
  %419 = select <16 x i1> %43, <16 x float> %418, <16 x float> %379, !dbg !99
  %420 = extractelement <9 x float> %81, i64 6, !dbg !99
  %421 = insertelement <16 x float> poison, float %420, i32 0, !dbg !99
  %422 = shufflevector <16 x float> %421, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %423 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %422, <16 x float> %150, <16 x float> %384), !dbg !99
  %424 = select <16 x i1> %45, <16 x float> %423, <16 x float> %384, !dbg !99
  %425 = extractelement <9 x float> %86, i64 6, !dbg !99
  %426 = insertelement <16 x float> poison, float %425, i32 0, !dbg !99
  %427 = shufflevector <16 x float> %426, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %428 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %427, <16 x float> %150, <16 x float> %389), !dbg !99
  %429 = select <16 x i1> %47, <16 x float> %428, <16 x float> %389, !dbg !99
  %430 = extractelement <9 x float> %91, i64 6, !dbg !99
  %431 = insertelement <16 x float> poison, float %430, i32 0, !dbg !99
  %432 = shufflevector <16 x float> %431, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %433 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %432, <16 x float> %150, <16 x float> %394), !dbg !99
  %434 = select <16 x i1> %49, <16 x float> %433, <16 x float> %394, !dbg !99
  %435 = extractelement <9 x float> %96, i64 6, !dbg !99
  %436 = insertelement <16 x float> poison, float %435, i32 0, !dbg !99
  %437 = shufflevector <16 x float> %436, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %438 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %437, <16 x float> %150, <16 x float> %399), !dbg !99
  %439 = select <16 x i1> %51, <16 x float> %438, <16 x float> %399, !dbg !99
  %440 = extractelement <9 x float> %101, i64 6, !dbg !99
  %441 = insertelement <16 x float> poison, float %440, i32 0, !dbg !99
  %442 = shufflevector <16 x float> %441, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %443 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %442, <16 x float> %150, <16 x float> %404), !dbg !99
  %444 = select <16 x i1> %53, <16 x float> %443, <16 x float> %404, !dbg !99
  %445 = extractelement <9 x float> %66, i64 7, !dbg !99
  %446 = insertelement <16 x float> poison, float %445, i32 0, !dbg !99
  %447 = shufflevector <16 x float> %446, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %448 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %447, <16 x float> %153, <16 x float> %409), !dbg !99
  %449 = select <16 x i1> %39, <16 x float> %448, <16 x float> %409, !dbg !99
  %450 = extractelement <9 x float> %71, i64 7, !dbg !99
  %451 = insertelement <16 x float> poison, float %450, i32 0, !dbg !99
  %452 = shufflevector <16 x float> %451, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %453 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %452, <16 x float> %153, <16 x float> %414), !dbg !99
  %454 = select <16 x i1> %41, <16 x float> %453, <16 x float> %414, !dbg !99
  %455 = extractelement <9 x float> %76, i64 7, !dbg !99
  %456 = insertelement <16 x float> poison, float %455, i32 0, !dbg !99
  %457 = shufflevector <16 x float> %456, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %458 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %457, <16 x float> %153, <16 x float> %419), !dbg !99
  %459 = select <16 x i1> %43, <16 x float> %458, <16 x float> %419, !dbg !99
  %460 = extractelement <9 x float> %81, i64 7, !dbg !99
  %461 = insertelement <16 x float> poison, float %460, i32 0, !dbg !99
  %462 = shufflevector <16 x float> %461, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %463 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %462, <16 x float> %153, <16 x float> %424), !dbg !99
  %464 = select <16 x i1> %45, <16 x float> %463, <16 x float> %424, !dbg !99
  %465 = extractelement <9 x float> %86, i64 7, !dbg !99
  %466 = insertelement <16 x float> poison, float %465, i32 0, !dbg !99
  %467 = shufflevector <16 x float> %466, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %468 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %467, <16 x float> %153, <16 x float> %429), !dbg !99
  %469 = select <16 x i1> %47, <16 x float> %468, <16 x float> %429, !dbg !99
  %470 = extractelement <9 x float> %91, i64 7, !dbg !99
  %471 = insertelement <16 x float> poison, float %470, i32 0, !dbg !99
  %472 = shufflevector <16 x float> %471, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %473 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %472, <16 x float> %153, <16 x float> %434), !dbg !99
  %474 = select <16 x i1> %49, <16 x float> %473, <16 x float> %434, !dbg !99
  %475 = extractelement <9 x float> %96, i64 7, !dbg !99
  %476 = insertelement <16 x float> poison, float %475, i32 0, !dbg !99
  %477 = shufflevector <16 x float> %476, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %478 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %477, <16 x float> %153, <16 x float> %439), !dbg !99
  %479 = select <16 x i1> %51, <16 x float> %478, <16 x float> %439, !dbg !99
  %480 = extractelement <9 x float> %101, i64 7, !dbg !99
  %481 = insertelement <16 x float> poison, float %480, i32 0, !dbg !99
  %482 = shufflevector <16 x float> %481, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %483 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %482, <16 x float> %153, <16 x float> %444), !dbg !99
  %484 = select <16 x i1> %53, <16 x float> %483, <16 x float> %444, !dbg !99
  %485 = extractelement <9 x float> %66, i64 8, !dbg !99
  %486 = insertelement <16 x float> poison, float %485, i32 0, !dbg !99
  %487 = shufflevector <16 x float> %486, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %488 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %487, <16 x float> %156, <16 x float> %449), !dbg !99
  %489 = select <16 x i1> %39, <16 x float> %488, <16 x float> %449, !dbg !99
  %490 = extractelement <9 x float> %71, i64 8, !dbg !99
  %491 = insertelement <16 x float> poison, float %490, i32 0, !dbg !99
  %492 = shufflevector <16 x float> %491, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %493 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %492, <16 x float> %156, <16 x float> %454), !dbg !99
  %494 = select <16 x i1> %41, <16 x float> %493, <16 x float> %454, !dbg !99
  %495 = extractelement <9 x float> %76, i64 8, !dbg !99
  %496 = insertelement <16 x float> poison, float %495, i32 0, !dbg !99
  %497 = shufflevector <16 x float> %496, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %498 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %497, <16 x float> %156, <16 x float> %459), !dbg !99
  %499 = select <16 x i1> %43, <16 x float> %498, <16 x float> %459, !dbg !99
  %500 = extractelement <9 x float> %81, i64 8, !dbg !99
  %501 = insertelement <16 x float> poison, float %500, i32 0, !dbg !99
  %502 = shufflevector <16 x float> %501, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %503 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %502, <16 x float> %156, <16 x float> %464), !dbg !99
  %504 = select <16 x i1> %45, <16 x float> %503, <16 x float> %464, !dbg !99
  %505 = extractelement <9 x float> %86, i64 8, !dbg !99
  %506 = insertelement <16 x float> poison, float %505, i32 0, !dbg !99
  %507 = shufflevector <16 x float> %506, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %508 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %507, <16 x float> %156, <16 x float> %469), !dbg !99
  %509 = select <16 x i1> %47, <16 x float> %508, <16 x float> %469, !dbg !99
  %510 = extractelement <9 x float> %91, i64 8, !dbg !99
  %511 = insertelement <16 x float> poison, float %510, i32 0, !dbg !99
  %512 = shufflevector <16 x float> %511, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %513 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %512, <16 x float> %156, <16 x float> %474), !dbg !99
  %514 = select <16 x i1> %49, <16 x float> %513, <16 x float> %474, !dbg !99
  %515 = extractelement <9 x float> %96, i64 8, !dbg !99
  %516 = insertelement <16 x float> poison, float %515, i32 0, !dbg !99
  %517 = shufflevector <16 x float> %516, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %518 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %517, <16 x float> %156, <16 x float> %479), !dbg !99
  %519 = select <16 x i1> %51, <16 x float> %518, <16 x float> %479, !dbg !99
  %520 = extractelement <9 x float> %101, i64 8, !dbg !99
  %521 = insertelement <16 x float> poison, float %520, i32 0, !dbg !99
  %522 = shufflevector <16 x float> %521, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !99
  %523 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %522, <16 x float> %156, <16 x float> %484), !dbg !99
  %524 = select <16 x i1> %53, <16 x float> %523, <16 x float> %484, !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %489, ptr align 4 %108, <16 x i1> %39), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %494, ptr align 4 %111, <16 x i1> %41), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %499, ptr align 4 %114, <16 x i1> %43), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %504, ptr align 4 %117, <16 x i1> %45), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %509, ptr align 4 %120, <16 x i1> %47), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %514, ptr align 4 %123, <16 x i1> %49), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %519, ptr align 4 %126, <16 x i1> %51), !dbg !99
  call void @llvm.masked.store.v16f32.p0(<16 x float> %524, ptr align 4 %129, <16 x i1> %53), !dbg !99
  %525 = add i64 %103, 16, !dbg !96
  br label %102, !dbg !96

526:                                              ; preds = %102
  %527 = add i64 %32, 8, !dbg !96
  br label %31, !dbg !96

528:                                              ; preds = %31
  ret i32 0, !dbg !100
}

define internal i32 @infer_dispatch_1_matmul_Dx2x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !101 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !102
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !102
  %6 = load i32, ptr %5, align 4, !dbg !102
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !103
  %8 = load i32, ptr %7, align 4, !dbg !103
  %9 = zext i32 %6 to i64, !dbg !104
  %10 = zext i32 %8 to i64, !dbg !105
  %11 = shl i64 %10, 32, !dbg !106
  %12 = or i64 %9, %11, !dbg !107
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !108
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !108
  %15 = load ptr, ptr %14, align 8, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !108
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !109
  %18 = load ptr, ptr %17, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !109
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !110
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !110
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !110
  %22 = load ptr, ptr %21, align 8, !dbg !110
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !110
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !111
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !111
  %25 = zext i32 %24 to i64, !dbg !111
  %26 = mul nsw i64 %25, 64, !dbg !111
  %27 = mul nsw i64 %25, -64, !dbg !111
  %28 = add i64 %27, %12, !dbg !111
  %29 = icmp slt i64 %28, 64, !dbg !111
  %30 = select i1 %29, i64 %28, i64 64, !dbg !111
  br label %31, !dbg !111

31:                                               ; preds = %883, %3
  %32 = phi i64 [ %892, %883 ], [ 0, %3 ], !dbg !111
  %33 = icmp slt i64 %32, %30, !dbg !111
  br i1 %33, label %34, label %893, !dbg !111

34:                                               ; preds = %31
  %35 = sub i64 %30, %32, !dbg !111
  %36 = icmp slt i64 %35, 8, !dbg !111
  %37 = select i1 %36, i64 %35, i64 8, !dbg !111
  %38 = icmp sgt i64 %37, 0, !dbg !112
  %39 = select i1 %38, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %40 = icmp sgt i64 %37, 1, !dbg !112
  %41 = select i1 %40, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %42 = icmp sgt i64 %37, 2, !dbg !112
  %43 = select i1 %42, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %44 = icmp sgt i64 %37, 3, !dbg !112
  %45 = select i1 %44, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %46 = icmp sgt i64 %37, 4, !dbg !112
  %47 = select i1 %46, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %48 = icmp sgt i64 %37, 5, !dbg !112
  %49 = select i1 %48, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %50 = icmp sgt i64 %37, 6, !dbg !112
  %51 = select i1 %50, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %52 = icmp sgt i64 %37, 7, !dbg !112
  %53 = select i1 %52, <2 x i1> splat (i1 true), <2 x i1> zeroinitializer, !dbg !112
  %54 = add i64 %26, %32, !dbg !113
  %55 = mul i64 %54, 2, !dbg !113
  %56 = add i64 %55, 0, !dbg !113
  %57 = getelementptr float, ptr %22, i64 %56, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %57, <2 x i1> %39), !dbg !113
  %58 = add i64 %54, 1, !dbg !113
  %59 = mul i64 %58, 2, !dbg !113
  %60 = add i64 %59, 0, !dbg !113
  %61 = getelementptr float, ptr %22, i64 %60, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %61, <2 x i1> %41), !dbg !113
  %62 = add i64 %54, 2, !dbg !113
  %63 = mul i64 %62, 2, !dbg !113
  %64 = add i64 %63, 0, !dbg !113
  %65 = getelementptr float, ptr %22, i64 %64, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %65, <2 x i1> %43), !dbg !113
  %66 = add i64 %54, 3, !dbg !113
  %67 = mul i64 %66, 2, !dbg !113
  %68 = add i64 %67, 0, !dbg !113
  %69 = getelementptr float, ptr %22, i64 %68, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %69, <2 x i1> %45), !dbg !113
  %70 = add i64 %54, 4, !dbg !113
  %71 = mul i64 %70, 2, !dbg !113
  %72 = add i64 %71, 0, !dbg !113
  %73 = getelementptr float, ptr %22, i64 %72, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %73, <2 x i1> %47), !dbg !113
  %74 = add i64 %54, 5, !dbg !113
  %75 = mul i64 %74, 2, !dbg !113
  %76 = add i64 %75, 0, !dbg !113
  %77 = getelementptr float, ptr %22, i64 %76, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %77, <2 x i1> %49), !dbg !113
  %78 = add i64 %54, 6, !dbg !113
  %79 = mul i64 %78, 2, !dbg !113
  %80 = add i64 %79, 0, !dbg !113
  %81 = getelementptr float, ptr %22, i64 %80, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %81, <2 x i1> %51), !dbg !113
  %82 = add i64 %54, 7, !dbg !113
  %83 = mul i64 %82, 2, !dbg !113
  %84 = add i64 %83, 0, !dbg !113
  %85 = getelementptr float, ptr %22, i64 %84, !dbg !113
  call void @llvm.masked.store.v2f32.p0(<2 x float> zeroinitializer, ptr align 4 %85, <2 x i1> %53), !dbg !113
  %86 = select i1 %38, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %87 = select i1 %40, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %88 = select i1 %42, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %89 = select i1 %44, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %90 = select i1 %46, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %91 = select i1 %48, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %92 = select i1 %50, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %93 = select i1 %52, <16 x i1> splat (i1 true), <16 x i1> zeroinitializer, !dbg !111
  %94 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %57, <2 x i1> %39, <2 x float> poison), !dbg !111
  %95 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %61, <2 x i1> %41, <2 x float> poison), !dbg !111
  %96 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %65, <2 x i1> %43, <2 x float> poison), !dbg !111
  %97 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %69, <2 x i1> %45, <2 x float> poison), !dbg !111
  %98 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %73, <2 x i1> %47, <2 x float> poison), !dbg !111
  %99 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %77, <2 x i1> %49, <2 x float> poison), !dbg !111
  %100 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %81, <2 x i1> %51, <2 x float> poison), !dbg !111
  %101 = call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %85, <2 x i1> %53, <2 x float> poison), !dbg !111
  %102 = insertvalue [8 x <2 x float>] poison, <2 x float> %94, 0, !dbg !111
  %103 = insertvalue [8 x <2 x float>] %102, <2 x float> %95, 1, !dbg !111
  %104 = insertvalue [8 x <2 x float>] %103, <2 x float> %96, 2, !dbg !111
  %105 = insertvalue [8 x <2 x float>] %104, <2 x float> %97, 3, !dbg !111
  %106 = insertvalue [8 x <2 x float>] %105, <2 x float> %98, 4, !dbg !111
  %107 = insertvalue [8 x <2 x float>] %106, <2 x float> %99, 5, !dbg !111
  %108 = insertvalue [8 x <2 x float>] %107, <2 x float> %100, 6, !dbg !111
  %109 = insertvalue [8 x <2 x float>] %108, <2 x float> %101, 7, !dbg !111
  br label %110, !dbg !111

110:                                              ; preds = %114, %34
  %111 = phi i64 [ %882, %114 ], [ 0, %34 ], !dbg !111
  %112 = phi [8 x <2 x float>] [ %881, %114 ], [ %109, %34 ], !dbg !111
  %113 = icmp slt i64 %111, 64, !dbg !111
  br i1 %113, label %114, label %883, !dbg !111

114:                                              ; preds = %110
  %115 = mul i64 %54, 64, !dbg !111
  %116 = add i64 %115, %111, !dbg !111
  %117 = getelementptr float, ptr %18, i64 %116, !dbg !111
  %118 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %117, <16 x i1> %86, <16 x float> poison), !dbg !111
  %119 = mul i64 %58, 64, !dbg !111
  %120 = add i64 %119, %111, !dbg !111
  %121 = getelementptr float, ptr %18, i64 %120, !dbg !111
  %122 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %121, <16 x i1> %87, <16 x float> poison), !dbg !111
  %123 = mul i64 %62, 64, !dbg !111
  %124 = add i64 %123, %111, !dbg !111
  %125 = getelementptr float, ptr %18, i64 %124, !dbg !111
  %126 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %125, <16 x i1> %88, <16 x float> poison), !dbg !111
  %127 = mul i64 %66, 64, !dbg !111
  %128 = add i64 %127, %111, !dbg !111
  %129 = getelementptr float, ptr %18, i64 %128, !dbg !111
  %130 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %129, <16 x i1> %89, <16 x float> poison), !dbg !111
  %131 = mul i64 %70, 64, !dbg !111
  %132 = add i64 %131, %111, !dbg !111
  %133 = getelementptr float, ptr %18, i64 %132, !dbg !111
  %134 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %133, <16 x i1> %90, <16 x float> poison), !dbg !111
  %135 = mul i64 %74, 64, !dbg !111
  %136 = add i64 %135, %111, !dbg !111
  %137 = getelementptr float, ptr %18, i64 %136, !dbg !111
  %138 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %137, <16 x i1> %91, <16 x float> poison), !dbg !111
  %139 = mul i64 %78, 64, !dbg !111
  %140 = add i64 %139, %111, !dbg !111
  %141 = getelementptr float, ptr %18, i64 %140, !dbg !111
  %142 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %141, <16 x i1> %92, <16 x float> poison), !dbg !111
  %143 = mul i64 %82, 64, !dbg !111
  %144 = add i64 %143, %111, !dbg !111
  %145 = getelementptr float, ptr %18, i64 %144, !dbg !111
  %146 = call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %145, <16 x i1> %93, <16 x float> poison), !dbg !111
  %147 = mul i64 %111, 2, !dbg !111
  %148 = add i64 %147, 0, !dbg !111
  %149 = getelementptr float, ptr %15, i64 %148, !dbg !111
  %150 = load <2 x float>, ptr %149, align 4, !dbg !111
  %151 = add i64 %111, 1, !dbg !111
  %152 = mul i64 %151, 2, !dbg !111
  %153 = add i64 %152, 0, !dbg !111
  %154 = getelementptr float, ptr %15, i64 %153, !dbg !111
  %155 = load <2 x float>, ptr %154, align 4, !dbg !111
  %156 = add i64 %111, 2, !dbg !111
  %157 = mul i64 %156, 2, !dbg !111
  %158 = add i64 %157, 0, !dbg !111
  %159 = getelementptr float, ptr %15, i64 %158, !dbg !111
  %160 = load <2 x float>, ptr %159, align 4, !dbg !111
  %161 = add i64 %111, 3, !dbg !111
  %162 = mul i64 %161, 2, !dbg !111
  %163 = add i64 %162, 0, !dbg !111
  %164 = getelementptr float, ptr %15, i64 %163, !dbg !111
  %165 = load <2 x float>, ptr %164, align 4, !dbg !111
  %166 = add i64 %111, 4, !dbg !111
  %167 = mul i64 %166, 2, !dbg !111
  %168 = add i64 %167, 0, !dbg !111
  %169 = getelementptr float, ptr %15, i64 %168, !dbg !111
  %170 = load <2 x float>, ptr %169, align 4, !dbg !111
  %171 = add i64 %111, 5, !dbg !111
  %172 = mul i64 %171, 2, !dbg !111
  %173 = add i64 %172, 0, !dbg !111
  %174 = getelementptr float, ptr %15, i64 %173, !dbg !111
  %175 = load <2 x float>, ptr %174, align 4, !dbg !111
  %176 = add i64 %111, 6, !dbg !111
  %177 = mul i64 %176, 2, !dbg !111
  %178 = add i64 %177, 0, !dbg !111
  %179 = getelementptr float, ptr %15, i64 %178, !dbg !111
  %180 = load <2 x float>, ptr %179, align 4, !dbg !111
  %181 = add i64 %111, 7, !dbg !111
  %182 = mul i64 %181, 2, !dbg !111
  %183 = add i64 %182, 0, !dbg !111
  %184 = getelementptr float, ptr %15, i64 %183, !dbg !111
  %185 = load <2 x float>, ptr %184, align 4, !dbg !111
  %186 = add i64 %111, 8, !dbg !111
  %187 = mul i64 %186, 2, !dbg !111
  %188 = add i64 %187, 0, !dbg !111
  %189 = getelementptr float, ptr %15, i64 %188, !dbg !111
  %190 = load <2 x float>, ptr %189, align 4, !dbg !111
  %191 = add i64 %111, 9, !dbg !111
  %192 = mul i64 %191, 2, !dbg !111
  %193 = add i64 %192, 0, !dbg !111
  %194 = getelementptr float, ptr %15, i64 %193, !dbg !111
  %195 = load <2 x float>, ptr %194, align 4, !dbg !111
  %196 = add i64 %111, 10, !dbg !111
  %197 = mul i64 %196, 2, !dbg !111
  %198 = add i64 %197, 0, !dbg !111
  %199 = getelementptr float, ptr %15, i64 %198, !dbg !111
  %200 = load <2 x float>, ptr %199, align 4, !dbg !111
  %201 = add i64 %111, 11, !dbg !111
  %202 = mul i64 %201, 2, !dbg !111
  %203 = add i64 %202, 0, !dbg !111
  %204 = getelementptr float, ptr %15, i64 %203, !dbg !111
  %205 = load <2 x float>, ptr %204, align 4, !dbg !111
  %206 = add i64 %111, 12, !dbg !111
  %207 = mul i64 %206, 2, !dbg !111
  %208 = add i64 %207, 0, !dbg !111
  %209 = getelementptr float, ptr %15, i64 %208, !dbg !111
  %210 = load <2 x float>, ptr %209, align 4, !dbg !111
  %211 = add i64 %111, 13, !dbg !111
  %212 = mul i64 %211, 2, !dbg !111
  %213 = add i64 %212, 0, !dbg !111
  %214 = getelementptr float, ptr %15, i64 %213, !dbg !111
  %215 = load <2 x float>, ptr %214, align 4, !dbg !111
  %216 = add i64 %111, 14, !dbg !111
  %217 = mul i64 %216, 2, !dbg !111
  %218 = add i64 %217, 0, !dbg !111
  %219 = getelementptr float, ptr %15, i64 %218, !dbg !111
  %220 = load <2 x float>, ptr %219, align 4, !dbg !111
  %221 = add i64 %111, 15, !dbg !111
  %222 = mul i64 %221, 2, !dbg !111
  %223 = add i64 %222, 0, !dbg !111
  %224 = getelementptr float, ptr %15, i64 %223, !dbg !111
  %225 = load <2 x float>, ptr %224, align 4, !dbg !111
  %226 = extractelement <16 x float> %118, i64 0, !dbg !114
  %227 = insertelement <2 x float> poison, float %226, i32 0, !dbg !114
  %228 = shufflevector <2 x float> %227, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %229 = extractvalue [8 x <2 x float>] %112, 0, !dbg !114
  %230 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %228, <2 x float> %150, <2 x float> %229), !dbg !114
  %231 = select <2 x i1> %39, <2 x float> %230, <2 x float> %229, !dbg !114
  %232 = extractelement <16 x float> %122, i64 0, !dbg !114
  %233 = insertelement <2 x float> poison, float %232, i32 0, !dbg !114
  %234 = shufflevector <2 x float> %233, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %235 = extractvalue [8 x <2 x float>] %112, 1, !dbg !114
  %236 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %234, <2 x float> %150, <2 x float> %235), !dbg !114
  %237 = select <2 x i1> %41, <2 x float> %236, <2 x float> %235, !dbg !114
  %238 = extractelement <16 x float> %126, i64 0, !dbg !114
  %239 = insertelement <2 x float> poison, float %238, i32 0, !dbg !114
  %240 = shufflevector <2 x float> %239, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %241 = extractvalue [8 x <2 x float>] %112, 2, !dbg !114
  %242 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %240, <2 x float> %150, <2 x float> %241), !dbg !114
  %243 = select <2 x i1> %43, <2 x float> %242, <2 x float> %241, !dbg !114
  %244 = extractelement <16 x float> %130, i64 0, !dbg !114
  %245 = insertelement <2 x float> poison, float %244, i32 0, !dbg !114
  %246 = shufflevector <2 x float> %245, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %247 = extractvalue [8 x <2 x float>] %112, 3, !dbg !114
  %248 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %246, <2 x float> %150, <2 x float> %247), !dbg !114
  %249 = select <2 x i1> %45, <2 x float> %248, <2 x float> %247, !dbg !114
  %250 = extractelement <16 x float> %134, i64 0, !dbg !114
  %251 = insertelement <2 x float> poison, float %250, i32 0, !dbg !114
  %252 = shufflevector <2 x float> %251, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %253 = extractvalue [8 x <2 x float>] %112, 4, !dbg !114
  %254 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %252, <2 x float> %150, <2 x float> %253), !dbg !114
  %255 = select <2 x i1> %47, <2 x float> %254, <2 x float> %253, !dbg !114
  %256 = extractelement <16 x float> %138, i64 0, !dbg !114
  %257 = insertelement <2 x float> poison, float %256, i32 0, !dbg !114
  %258 = shufflevector <2 x float> %257, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %259 = extractvalue [8 x <2 x float>] %112, 5, !dbg !114
  %260 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %258, <2 x float> %150, <2 x float> %259), !dbg !114
  %261 = select <2 x i1> %49, <2 x float> %260, <2 x float> %259, !dbg !114
  %262 = extractelement <16 x float> %142, i64 0, !dbg !114
  %263 = insertelement <2 x float> poison, float %262, i32 0, !dbg !114
  %264 = shufflevector <2 x float> %263, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %265 = extractvalue [8 x <2 x float>] %112, 6, !dbg !114
  %266 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %264, <2 x float> %150, <2 x float> %265), !dbg !114
  %267 = select <2 x i1> %51, <2 x float> %266, <2 x float> %265, !dbg !114
  %268 = extractelement <16 x float> %146, i64 0, !dbg !114
  %269 = insertelement <2 x float> poison, float %268, i32 0, !dbg !114
  %270 = shufflevector <2 x float> %269, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %271 = extractvalue [8 x <2 x float>] %112, 7, !dbg !114
  %272 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %270, <2 x float> %150, <2 x float> %271), !dbg !114
  %273 = select <2 x i1> %53, <2 x float> %272, <2 x float> %271, !dbg !114
  %274 = extractelement <16 x float> %118, i64 1, !dbg !114
  %275 = insertelement <2 x float> poison, float %274, i32 0, !dbg !114
  %276 = shufflevector <2 x float> %275, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %277 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %276, <2 x float> %155, <2 x float> %231), !dbg !114
  %278 = select <2 x i1> %39, <2 x float> %277, <2 x float> %231, !dbg !114
  %279 = extractelement <16 x float> %122, i64 1, !dbg !114
  %280 = insertelement <2 x float> poison, float %279, i32 0, !dbg !114
  %281 = shufflevector <2 x float> %280, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %282 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %281, <2 x float> %155, <2 x float> %237), !dbg !114
  %283 = select <2 x i1> %41, <2 x float> %282, <2 x float> %237, !dbg !114
  %284 = extractelement <16 x float> %126, i64 1, !dbg !114
  %285 = insertelement <2 x float> poison, float %284, i32 0, !dbg !114
  %286 = shufflevector <2 x float> %285, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %287 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %286, <2 x float> %155, <2 x float> %243), !dbg !114
  %288 = select <2 x i1> %43, <2 x float> %287, <2 x float> %243, !dbg !114
  %289 = extractelement <16 x float> %130, i64 1, !dbg !114
  %290 = insertelement <2 x float> poison, float %289, i32 0, !dbg !114
  %291 = shufflevector <2 x float> %290, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %292 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %291, <2 x float> %155, <2 x float> %249), !dbg !114
  %293 = select <2 x i1> %45, <2 x float> %292, <2 x float> %249, !dbg !114
  %294 = extractelement <16 x float> %134, i64 1, !dbg !114
  %295 = insertelement <2 x float> poison, float %294, i32 0, !dbg !114
  %296 = shufflevector <2 x float> %295, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %297 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %296, <2 x float> %155, <2 x float> %255), !dbg !114
  %298 = select <2 x i1> %47, <2 x float> %297, <2 x float> %255, !dbg !114
  %299 = extractelement <16 x float> %138, i64 1, !dbg !114
  %300 = insertelement <2 x float> poison, float %299, i32 0, !dbg !114
  %301 = shufflevector <2 x float> %300, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %302 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %301, <2 x float> %155, <2 x float> %261), !dbg !114
  %303 = select <2 x i1> %49, <2 x float> %302, <2 x float> %261, !dbg !114
  %304 = extractelement <16 x float> %142, i64 1, !dbg !114
  %305 = insertelement <2 x float> poison, float %304, i32 0, !dbg !114
  %306 = shufflevector <2 x float> %305, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %307 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %306, <2 x float> %155, <2 x float> %267), !dbg !114
  %308 = select <2 x i1> %51, <2 x float> %307, <2 x float> %267, !dbg !114
  %309 = extractelement <16 x float> %146, i64 1, !dbg !114
  %310 = insertelement <2 x float> poison, float %309, i32 0, !dbg !114
  %311 = shufflevector <2 x float> %310, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %312 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %311, <2 x float> %155, <2 x float> %273), !dbg !114
  %313 = select <2 x i1> %53, <2 x float> %312, <2 x float> %273, !dbg !114
  %314 = extractelement <16 x float> %118, i64 2, !dbg !114
  %315 = insertelement <2 x float> poison, float %314, i32 0, !dbg !114
  %316 = shufflevector <2 x float> %315, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %317 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %316, <2 x float> %160, <2 x float> %278), !dbg !114
  %318 = select <2 x i1> %39, <2 x float> %317, <2 x float> %278, !dbg !114
  %319 = extractelement <16 x float> %122, i64 2, !dbg !114
  %320 = insertelement <2 x float> poison, float %319, i32 0, !dbg !114
  %321 = shufflevector <2 x float> %320, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %322 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %321, <2 x float> %160, <2 x float> %283), !dbg !114
  %323 = select <2 x i1> %41, <2 x float> %322, <2 x float> %283, !dbg !114
  %324 = extractelement <16 x float> %126, i64 2, !dbg !114
  %325 = insertelement <2 x float> poison, float %324, i32 0, !dbg !114
  %326 = shufflevector <2 x float> %325, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %327 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %326, <2 x float> %160, <2 x float> %288), !dbg !114
  %328 = select <2 x i1> %43, <2 x float> %327, <2 x float> %288, !dbg !114
  %329 = extractelement <16 x float> %130, i64 2, !dbg !114
  %330 = insertelement <2 x float> poison, float %329, i32 0, !dbg !114
  %331 = shufflevector <2 x float> %330, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %332 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %331, <2 x float> %160, <2 x float> %293), !dbg !114
  %333 = select <2 x i1> %45, <2 x float> %332, <2 x float> %293, !dbg !114
  %334 = extractelement <16 x float> %134, i64 2, !dbg !114
  %335 = insertelement <2 x float> poison, float %334, i32 0, !dbg !114
  %336 = shufflevector <2 x float> %335, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %337 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %336, <2 x float> %160, <2 x float> %298), !dbg !114
  %338 = select <2 x i1> %47, <2 x float> %337, <2 x float> %298, !dbg !114
  %339 = extractelement <16 x float> %138, i64 2, !dbg !114
  %340 = insertelement <2 x float> poison, float %339, i32 0, !dbg !114
  %341 = shufflevector <2 x float> %340, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %342 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %341, <2 x float> %160, <2 x float> %303), !dbg !114
  %343 = select <2 x i1> %49, <2 x float> %342, <2 x float> %303, !dbg !114
  %344 = extractelement <16 x float> %142, i64 2, !dbg !114
  %345 = insertelement <2 x float> poison, float %344, i32 0, !dbg !114
  %346 = shufflevector <2 x float> %345, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %347 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %346, <2 x float> %160, <2 x float> %308), !dbg !114
  %348 = select <2 x i1> %51, <2 x float> %347, <2 x float> %308, !dbg !114
  %349 = extractelement <16 x float> %146, i64 2, !dbg !114
  %350 = insertelement <2 x float> poison, float %349, i32 0, !dbg !114
  %351 = shufflevector <2 x float> %350, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %352 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %351, <2 x float> %160, <2 x float> %313), !dbg !114
  %353 = select <2 x i1> %53, <2 x float> %352, <2 x float> %313, !dbg !114
  %354 = extractelement <16 x float> %118, i64 3, !dbg !114
  %355 = insertelement <2 x float> poison, float %354, i32 0, !dbg !114
  %356 = shufflevector <2 x float> %355, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %357 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %356, <2 x float> %165, <2 x float> %318), !dbg !114
  %358 = select <2 x i1> %39, <2 x float> %357, <2 x float> %318, !dbg !114
  %359 = extractelement <16 x float> %122, i64 3, !dbg !114
  %360 = insertelement <2 x float> poison, float %359, i32 0, !dbg !114
  %361 = shufflevector <2 x float> %360, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %362 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %361, <2 x float> %165, <2 x float> %323), !dbg !114
  %363 = select <2 x i1> %41, <2 x float> %362, <2 x float> %323, !dbg !114
  %364 = extractelement <16 x float> %126, i64 3, !dbg !114
  %365 = insertelement <2 x float> poison, float %364, i32 0, !dbg !114
  %366 = shufflevector <2 x float> %365, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %367 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %366, <2 x float> %165, <2 x float> %328), !dbg !114
  %368 = select <2 x i1> %43, <2 x float> %367, <2 x float> %328, !dbg !114
  %369 = extractelement <16 x float> %130, i64 3, !dbg !114
  %370 = insertelement <2 x float> poison, float %369, i32 0, !dbg !114
  %371 = shufflevector <2 x float> %370, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %372 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %371, <2 x float> %165, <2 x float> %333), !dbg !114
  %373 = select <2 x i1> %45, <2 x float> %372, <2 x float> %333, !dbg !114
  %374 = extractelement <16 x float> %134, i64 3, !dbg !114
  %375 = insertelement <2 x float> poison, float %374, i32 0, !dbg !114
  %376 = shufflevector <2 x float> %375, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %377 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %376, <2 x float> %165, <2 x float> %338), !dbg !114
  %378 = select <2 x i1> %47, <2 x float> %377, <2 x float> %338, !dbg !114
  %379 = extractelement <16 x float> %138, i64 3, !dbg !114
  %380 = insertelement <2 x float> poison, float %379, i32 0, !dbg !114
  %381 = shufflevector <2 x float> %380, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %382 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %381, <2 x float> %165, <2 x float> %343), !dbg !114
  %383 = select <2 x i1> %49, <2 x float> %382, <2 x float> %343, !dbg !114
  %384 = extractelement <16 x float> %142, i64 3, !dbg !114
  %385 = insertelement <2 x float> poison, float %384, i32 0, !dbg !114
  %386 = shufflevector <2 x float> %385, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %387 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %386, <2 x float> %165, <2 x float> %348), !dbg !114
  %388 = select <2 x i1> %51, <2 x float> %387, <2 x float> %348, !dbg !114
  %389 = extractelement <16 x float> %146, i64 3, !dbg !114
  %390 = insertelement <2 x float> poison, float %389, i32 0, !dbg !114
  %391 = shufflevector <2 x float> %390, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %392 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %391, <2 x float> %165, <2 x float> %353), !dbg !114
  %393 = select <2 x i1> %53, <2 x float> %392, <2 x float> %353, !dbg !114
  %394 = extractelement <16 x float> %118, i64 4, !dbg !114
  %395 = insertelement <2 x float> poison, float %394, i32 0, !dbg !114
  %396 = shufflevector <2 x float> %395, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %397 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %396, <2 x float> %170, <2 x float> %358), !dbg !114
  %398 = select <2 x i1> %39, <2 x float> %397, <2 x float> %358, !dbg !114
  %399 = extractelement <16 x float> %122, i64 4, !dbg !114
  %400 = insertelement <2 x float> poison, float %399, i32 0, !dbg !114
  %401 = shufflevector <2 x float> %400, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %402 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %401, <2 x float> %170, <2 x float> %363), !dbg !114
  %403 = select <2 x i1> %41, <2 x float> %402, <2 x float> %363, !dbg !114
  %404 = extractelement <16 x float> %126, i64 4, !dbg !114
  %405 = insertelement <2 x float> poison, float %404, i32 0, !dbg !114
  %406 = shufflevector <2 x float> %405, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %407 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %406, <2 x float> %170, <2 x float> %368), !dbg !114
  %408 = select <2 x i1> %43, <2 x float> %407, <2 x float> %368, !dbg !114
  %409 = extractelement <16 x float> %130, i64 4, !dbg !114
  %410 = insertelement <2 x float> poison, float %409, i32 0, !dbg !114
  %411 = shufflevector <2 x float> %410, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %412 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %411, <2 x float> %170, <2 x float> %373), !dbg !114
  %413 = select <2 x i1> %45, <2 x float> %412, <2 x float> %373, !dbg !114
  %414 = extractelement <16 x float> %134, i64 4, !dbg !114
  %415 = insertelement <2 x float> poison, float %414, i32 0, !dbg !114
  %416 = shufflevector <2 x float> %415, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %417 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %416, <2 x float> %170, <2 x float> %378), !dbg !114
  %418 = select <2 x i1> %47, <2 x float> %417, <2 x float> %378, !dbg !114
  %419 = extractelement <16 x float> %138, i64 4, !dbg !114
  %420 = insertelement <2 x float> poison, float %419, i32 0, !dbg !114
  %421 = shufflevector <2 x float> %420, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %422 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %421, <2 x float> %170, <2 x float> %383), !dbg !114
  %423 = select <2 x i1> %49, <2 x float> %422, <2 x float> %383, !dbg !114
  %424 = extractelement <16 x float> %142, i64 4, !dbg !114
  %425 = insertelement <2 x float> poison, float %424, i32 0, !dbg !114
  %426 = shufflevector <2 x float> %425, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %427 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %426, <2 x float> %170, <2 x float> %388), !dbg !114
  %428 = select <2 x i1> %51, <2 x float> %427, <2 x float> %388, !dbg !114
  %429 = extractelement <16 x float> %146, i64 4, !dbg !114
  %430 = insertelement <2 x float> poison, float %429, i32 0, !dbg !114
  %431 = shufflevector <2 x float> %430, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %432 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %431, <2 x float> %170, <2 x float> %393), !dbg !114
  %433 = select <2 x i1> %53, <2 x float> %432, <2 x float> %393, !dbg !114
  %434 = extractelement <16 x float> %118, i64 5, !dbg !114
  %435 = insertelement <2 x float> poison, float %434, i32 0, !dbg !114
  %436 = shufflevector <2 x float> %435, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %437 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %436, <2 x float> %175, <2 x float> %398), !dbg !114
  %438 = select <2 x i1> %39, <2 x float> %437, <2 x float> %398, !dbg !114
  %439 = extractelement <16 x float> %122, i64 5, !dbg !114
  %440 = insertelement <2 x float> poison, float %439, i32 0, !dbg !114
  %441 = shufflevector <2 x float> %440, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %442 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %441, <2 x float> %175, <2 x float> %403), !dbg !114
  %443 = select <2 x i1> %41, <2 x float> %442, <2 x float> %403, !dbg !114
  %444 = extractelement <16 x float> %126, i64 5, !dbg !114
  %445 = insertelement <2 x float> poison, float %444, i32 0, !dbg !114
  %446 = shufflevector <2 x float> %445, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %447 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %446, <2 x float> %175, <2 x float> %408), !dbg !114
  %448 = select <2 x i1> %43, <2 x float> %447, <2 x float> %408, !dbg !114
  %449 = extractelement <16 x float> %130, i64 5, !dbg !114
  %450 = insertelement <2 x float> poison, float %449, i32 0, !dbg !114
  %451 = shufflevector <2 x float> %450, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %452 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %451, <2 x float> %175, <2 x float> %413), !dbg !114
  %453 = select <2 x i1> %45, <2 x float> %452, <2 x float> %413, !dbg !114
  %454 = extractelement <16 x float> %134, i64 5, !dbg !114
  %455 = insertelement <2 x float> poison, float %454, i32 0, !dbg !114
  %456 = shufflevector <2 x float> %455, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %457 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %456, <2 x float> %175, <2 x float> %418), !dbg !114
  %458 = select <2 x i1> %47, <2 x float> %457, <2 x float> %418, !dbg !114
  %459 = extractelement <16 x float> %138, i64 5, !dbg !114
  %460 = insertelement <2 x float> poison, float %459, i32 0, !dbg !114
  %461 = shufflevector <2 x float> %460, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %462 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %461, <2 x float> %175, <2 x float> %423), !dbg !114
  %463 = select <2 x i1> %49, <2 x float> %462, <2 x float> %423, !dbg !114
  %464 = extractelement <16 x float> %142, i64 5, !dbg !114
  %465 = insertelement <2 x float> poison, float %464, i32 0, !dbg !114
  %466 = shufflevector <2 x float> %465, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %467 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %466, <2 x float> %175, <2 x float> %428), !dbg !114
  %468 = select <2 x i1> %51, <2 x float> %467, <2 x float> %428, !dbg !114
  %469 = extractelement <16 x float> %146, i64 5, !dbg !114
  %470 = insertelement <2 x float> poison, float %469, i32 0, !dbg !114
  %471 = shufflevector <2 x float> %470, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %472 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %471, <2 x float> %175, <2 x float> %433), !dbg !114
  %473 = select <2 x i1> %53, <2 x float> %472, <2 x float> %433, !dbg !114
  %474 = extractelement <16 x float> %118, i64 6, !dbg !114
  %475 = insertelement <2 x float> poison, float %474, i32 0, !dbg !114
  %476 = shufflevector <2 x float> %475, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %477 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %476, <2 x float> %180, <2 x float> %438), !dbg !114
  %478 = select <2 x i1> %39, <2 x float> %477, <2 x float> %438, !dbg !114
  %479 = extractelement <16 x float> %122, i64 6, !dbg !114
  %480 = insertelement <2 x float> poison, float %479, i32 0, !dbg !114
  %481 = shufflevector <2 x float> %480, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %482 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %481, <2 x float> %180, <2 x float> %443), !dbg !114
  %483 = select <2 x i1> %41, <2 x float> %482, <2 x float> %443, !dbg !114
  %484 = extractelement <16 x float> %126, i64 6, !dbg !114
  %485 = insertelement <2 x float> poison, float %484, i32 0, !dbg !114
  %486 = shufflevector <2 x float> %485, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %487 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %486, <2 x float> %180, <2 x float> %448), !dbg !114
  %488 = select <2 x i1> %43, <2 x float> %487, <2 x float> %448, !dbg !114
  %489 = extractelement <16 x float> %130, i64 6, !dbg !114
  %490 = insertelement <2 x float> poison, float %489, i32 0, !dbg !114
  %491 = shufflevector <2 x float> %490, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %492 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %491, <2 x float> %180, <2 x float> %453), !dbg !114
  %493 = select <2 x i1> %45, <2 x float> %492, <2 x float> %453, !dbg !114
  %494 = extractelement <16 x float> %134, i64 6, !dbg !114
  %495 = insertelement <2 x float> poison, float %494, i32 0, !dbg !114
  %496 = shufflevector <2 x float> %495, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %497 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %496, <2 x float> %180, <2 x float> %458), !dbg !114
  %498 = select <2 x i1> %47, <2 x float> %497, <2 x float> %458, !dbg !114
  %499 = extractelement <16 x float> %138, i64 6, !dbg !114
  %500 = insertelement <2 x float> poison, float %499, i32 0, !dbg !114
  %501 = shufflevector <2 x float> %500, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %502 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %501, <2 x float> %180, <2 x float> %463), !dbg !114
  %503 = select <2 x i1> %49, <2 x float> %502, <2 x float> %463, !dbg !114
  %504 = extractelement <16 x float> %142, i64 6, !dbg !114
  %505 = insertelement <2 x float> poison, float %504, i32 0, !dbg !114
  %506 = shufflevector <2 x float> %505, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %507 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %506, <2 x float> %180, <2 x float> %468), !dbg !114
  %508 = select <2 x i1> %51, <2 x float> %507, <2 x float> %468, !dbg !114
  %509 = extractelement <16 x float> %146, i64 6, !dbg !114
  %510 = insertelement <2 x float> poison, float %509, i32 0, !dbg !114
  %511 = shufflevector <2 x float> %510, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %512 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %511, <2 x float> %180, <2 x float> %473), !dbg !114
  %513 = select <2 x i1> %53, <2 x float> %512, <2 x float> %473, !dbg !114
  %514 = extractelement <16 x float> %118, i64 7, !dbg !114
  %515 = insertelement <2 x float> poison, float %514, i32 0, !dbg !114
  %516 = shufflevector <2 x float> %515, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %517 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %516, <2 x float> %185, <2 x float> %478), !dbg !114
  %518 = select <2 x i1> %39, <2 x float> %517, <2 x float> %478, !dbg !114
  %519 = extractelement <16 x float> %122, i64 7, !dbg !114
  %520 = insertelement <2 x float> poison, float %519, i32 0, !dbg !114
  %521 = shufflevector <2 x float> %520, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %522 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %521, <2 x float> %185, <2 x float> %483), !dbg !114
  %523 = select <2 x i1> %41, <2 x float> %522, <2 x float> %483, !dbg !114
  %524 = extractelement <16 x float> %126, i64 7, !dbg !114
  %525 = insertelement <2 x float> poison, float %524, i32 0, !dbg !114
  %526 = shufflevector <2 x float> %525, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %527 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %526, <2 x float> %185, <2 x float> %488), !dbg !114
  %528 = select <2 x i1> %43, <2 x float> %527, <2 x float> %488, !dbg !114
  %529 = extractelement <16 x float> %130, i64 7, !dbg !114
  %530 = insertelement <2 x float> poison, float %529, i32 0, !dbg !114
  %531 = shufflevector <2 x float> %530, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %532 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %531, <2 x float> %185, <2 x float> %493), !dbg !114
  %533 = select <2 x i1> %45, <2 x float> %532, <2 x float> %493, !dbg !114
  %534 = extractelement <16 x float> %134, i64 7, !dbg !114
  %535 = insertelement <2 x float> poison, float %534, i32 0, !dbg !114
  %536 = shufflevector <2 x float> %535, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %537 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %536, <2 x float> %185, <2 x float> %498), !dbg !114
  %538 = select <2 x i1> %47, <2 x float> %537, <2 x float> %498, !dbg !114
  %539 = extractelement <16 x float> %138, i64 7, !dbg !114
  %540 = insertelement <2 x float> poison, float %539, i32 0, !dbg !114
  %541 = shufflevector <2 x float> %540, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %542 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %541, <2 x float> %185, <2 x float> %503), !dbg !114
  %543 = select <2 x i1> %49, <2 x float> %542, <2 x float> %503, !dbg !114
  %544 = extractelement <16 x float> %142, i64 7, !dbg !114
  %545 = insertelement <2 x float> poison, float %544, i32 0, !dbg !114
  %546 = shufflevector <2 x float> %545, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %547 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %546, <2 x float> %185, <2 x float> %508), !dbg !114
  %548 = select <2 x i1> %51, <2 x float> %547, <2 x float> %508, !dbg !114
  %549 = extractelement <16 x float> %146, i64 7, !dbg !114
  %550 = insertelement <2 x float> poison, float %549, i32 0, !dbg !114
  %551 = shufflevector <2 x float> %550, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %552 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %551, <2 x float> %185, <2 x float> %513), !dbg !114
  %553 = select <2 x i1> %53, <2 x float> %552, <2 x float> %513, !dbg !114
  %554 = extractelement <16 x float> %118, i64 8, !dbg !114
  %555 = insertelement <2 x float> poison, float %554, i32 0, !dbg !114
  %556 = shufflevector <2 x float> %555, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %557 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %556, <2 x float> %190, <2 x float> %518), !dbg !114
  %558 = select <2 x i1> %39, <2 x float> %557, <2 x float> %518, !dbg !114
  %559 = extractelement <16 x float> %122, i64 8, !dbg !114
  %560 = insertelement <2 x float> poison, float %559, i32 0, !dbg !114
  %561 = shufflevector <2 x float> %560, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %562 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %561, <2 x float> %190, <2 x float> %523), !dbg !114
  %563 = select <2 x i1> %41, <2 x float> %562, <2 x float> %523, !dbg !114
  %564 = extractelement <16 x float> %126, i64 8, !dbg !114
  %565 = insertelement <2 x float> poison, float %564, i32 0, !dbg !114
  %566 = shufflevector <2 x float> %565, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %567 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %566, <2 x float> %190, <2 x float> %528), !dbg !114
  %568 = select <2 x i1> %43, <2 x float> %567, <2 x float> %528, !dbg !114
  %569 = extractelement <16 x float> %130, i64 8, !dbg !114
  %570 = insertelement <2 x float> poison, float %569, i32 0, !dbg !114
  %571 = shufflevector <2 x float> %570, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %572 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %571, <2 x float> %190, <2 x float> %533), !dbg !114
  %573 = select <2 x i1> %45, <2 x float> %572, <2 x float> %533, !dbg !114
  %574 = extractelement <16 x float> %134, i64 8, !dbg !114
  %575 = insertelement <2 x float> poison, float %574, i32 0, !dbg !114
  %576 = shufflevector <2 x float> %575, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %577 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %576, <2 x float> %190, <2 x float> %538), !dbg !114
  %578 = select <2 x i1> %47, <2 x float> %577, <2 x float> %538, !dbg !114
  %579 = extractelement <16 x float> %138, i64 8, !dbg !114
  %580 = insertelement <2 x float> poison, float %579, i32 0, !dbg !114
  %581 = shufflevector <2 x float> %580, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %582 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %581, <2 x float> %190, <2 x float> %543), !dbg !114
  %583 = select <2 x i1> %49, <2 x float> %582, <2 x float> %543, !dbg !114
  %584 = extractelement <16 x float> %142, i64 8, !dbg !114
  %585 = insertelement <2 x float> poison, float %584, i32 0, !dbg !114
  %586 = shufflevector <2 x float> %585, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %587 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %586, <2 x float> %190, <2 x float> %548), !dbg !114
  %588 = select <2 x i1> %51, <2 x float> %587, <2 x float> %548, !dbg !114
  %589 = extractelement <16 x float> %146, i64 8, !dbg !114
  %590 = insertelement <2 x float> poison, float %589, i32 0, !dbg !114
  %591 = shufflevector <2 x float> %590, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %592 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %591, <2 x float> %190, <2 x float> %553), !dbg !114
  %593 = select <2 x i1> %53, <2 x float> %592, <2 x float> %553, !dbg !114
  %594 = extractelement <16 x float> %118, i64 9, !dbg !114
  %595 = insertelement <2 x float> poison, float %594, i32 0, !dbg !114
  %596 = shufflevector <2 x float> %595, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %597 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %596, <2 x float> %195, <2 x float> %558), !dbg !114
  %598 = select <2 x i1> %39, <2 x float> %597, <2 x float> %558, !dbg !114
  %599 = extractelement <16 x float> %122, i64 9, !dbg !114
  %600 = insertelement <2 x float> poison, float %599, i32 0, !dbg !114
  %601 = shufflevector <2 x float> %600, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %602 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %601, <2 x float> %195, <2 x float> %563), !dbg !114
  %603 = select <2 x i1> %41, <2 x float> %602, <2 x float> %563, !dbg !114
  %604 = extractelement <16 x float> %126, i64 9, !dbg !114
  %605 = insertelement <2 x float> poison, float %604, i32 0, !dbg !114
  %606 = shufflevector <2 x float> %605, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %607 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %606, <2 x float> %195, <2 x float> %568), !dbg !114
  %608 = select <2 x i1> %43, <2 x float> %607, <2 x float> %568, !dbg !114
  %609 = extractelement <16 x float> %130, i64 9, !dbg !114
  %610 = insertelement <2 x float> poison, float %609, i32 0, !dbg !114
  %611 = shufflevector <2 x float> %610, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %612 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %611, <2 x float> %195, <2 x float> %573), !dbg !114
  %613 = select <2 x i1> %45, <2 x float> %612, <2 x float> %573, !dbg !114
  %614 = extractelement <16 x float> %134, i64 9, !dbg !114
  %615 = insertelement <2 x float> poison, float %614, i32 0, !dbg !114
  %616 = shufflevector <2 x float> %615, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %617 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %616, <2 x float> %195, <2 x float> %578), !dbg !114
  %618 = select <2 x i1> %47, <2 x float> %617, <2 x float> %578, !dbg !114
  %619 = extractelement <16 x float> %138, i64 9, !dbg !114
  %620 = insertelement <2 x float> poison, float %619, i32 0, !dbg !114
  %621 = shufflevector <2 x float> %620, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %622 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %621, <2 x float> %195, <2 x float> %583), !dbg !114
  %623 = select <2 x i1> %49, <2 x float> %622, <2 x float> %583, !dbg !114
  %624 = extractelement <16 x float> %142, i64 9, !dbg !114
  %625 = insertelement <2 x float> poison, float %624, i32 0, !dbg !114
  %626 = shufflevector <2 x float> %625, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %627 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %626, <2 x float> %195, <2 x float> %588), !dbg !114
  %628 = select <2 x i1> %51, <2 x float> %627, <2 x float> %588, !dbg !114
  %629 = extractelement <16 x float> %146, i64 9, !dbg !114
  %630 = insertelement <2 x float> poison, float %629, i32 0, !dbg !114
  %631 = shufflevector <2 x float> %630, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %632 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %631, <2 x float> %195, <2 x float> %593), !dbg !114
  %633 = select <2 x i1> %53, <2 x float> %632, <2 x float> %593, !dbg !114
  %634 = extractelement <16 x float> %118, i64 10, !dbg !114
  %635 = insertelement <2 x float> poison, float %634, i32 0, !dbg !114
  %636 = shufflevector <2 x float> %635, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %637 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %636, <2 x float> %200, <2 x float> %598), !dbg !114
  %638 = select <2 x i1> %39, <2 x float> %637, <2 x float> %598, !dbg !114
  %639 = extractelement <16 x float> %122, i64 10, !dbg !114
  %640 = insertelement <2 x float> poison, float %639, i32 0, !dbg !114
  %641 = shufflevector <2 x float> %640, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %642 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %641, <2 x float> %200, <2 x float> %603), !dbg !114
  %643 = select <2 x i1> %41, <2 x float> %642, <2 x float> %603, !dbg !114
  %644 = extractelement <16 x float> %126, i64 10, !dbg !114
  %645 = insertelement <2 x float> poison, float %644, i32 0, !dbg !114
  %646 = shufflevector <2 x float> %645, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %647 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %646, <2 x float> %200, <2 x float> %608), !dbg !114
  %648 = select <2 x i1> %43, <2 x float> %647, <2 x float> %608, !dbg !114
  %649 = extractelement <16 x float> %130, i64 10, !dbg !114
  %650 = insertelement <2 x float> poison, float %649, i32 0, !dbg !114
  %651 = shufflevector <2 x float> %650, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %652 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %651, <2 x float> %200, <2 x float> %613), !dbg !114
  %653 = select <2 x i1> %45, <2 x float> %652, <2 x float> %613, !dbg !114
  %654 = extractelement <16 x float> %134, i64 10, !dbg !114
  %655 = insertelement <2 x float> poison, float %654, i32 0, !dbg !114
  %656 = shufflevector <2 x float> %655, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %657 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %656, <2 x float> %200, <2 x float> %618), !dbg !114
  %658 = select <2 x i1> %47, <2 x float> %657, <2 x float> %618, !dbg !114
  %659 = extractelement <16 x float> %138, i64 10, !dbg !114
  %660 = insertelement <2 x float> poison, float %659, i32 0, !dbg !114
  %661 = shufflevector <2 x float> %660, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %662 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %661, <2 x float> %200, <2 x float> %623), !dbg !114
  %663 = select <2 x i1> %49, <2 x float> %662, <2 x float> %623, !dbg !114
  %664 = extractelement <16 x float> %142, i64 10, !dbg !114
  %665 = insertelement <2 x float> poison, float %664, i32 0, !dbg !114
  %666 = shufflevector <2 x float> %665, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %667 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %666, <2 x float> %200, <2 x float> %628), !dbg !114
  %668 = select <2 x i1> %51, <2 x float> %667, <2 x float> %628, !dbg !114
  %669 = extractelement <16 x float> %146, i64 10, !dbg !114
  %670 = insertelement <2 x float> poison, float %669, i32 0, !dbg !114
  %671 = shufflevector <2 x float> %670, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %672 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %671, <2 x float> %200, <2 x float> %633), !dbg !114
  %673 = select <2 x i1> %53, <2 x float> %672, <2 x float> %633, !dbg !114
  %674 = extractelement <16 x float> %118, i64 11, !dbg !114
  %675 = insertelement <2 x float> poison, float %674, i32 0, !dbg !114
  %676 = shufflevector <2 x float> %675, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %677 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %676, <2 x float> %205, <2 x float> %638), !dbg !114
  %678 = select <2 x i1> %39, <2 x float> %677, <2 x float> %638, !dbg !114
  %679 = extractelement <16 x float> %122, i64 11, !dbg !114
  %680 = insertelement <2 x float> poison, float %679, i32 0, !dbg !114
  %681 = shufflevector <2 x float> %680, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %682 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %681, <2 x float> %205, <2 x float> %643), !dbg !114
  %683 = select <2 x i1> %41, <2 x float> %682, <2 x float> %643, !dbg !114
  %684 = extractelement <16 x float> %126, i64 11, !dbg !114
  %685 = insertelement <2 x float> poison, float %684, i32 0, !dbg !114
  %686 = shufflevector <2 x float> %685, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %687 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %686, <2 x float> %205, <2 x float> %648), !dbg !114
  %688 = select <2 x i1> %43, <2 x float> %687, <2 x float> %648, !dbg !114
  %689 = extractelement <16 x float> %130, i64 11, !dbg !114
  %690 = insertelement <2 x float> poison, float %689, i32 0, !dbg !114
  %691 = shufflevector <2 x float> %690, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %692 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %691, <2 x float> %205, <2 x float> %653), !dbg !114
  %693 = select <2 x i1> %45, <2 x float> %692, <2 x float> %653, !dbg !114
  %694 = extractelement <16 x float> %134, i64 11, !dbg !114
  %695 = insertelement <2 x float> poison, float %694, i32 0, !dbg !114
  %696 = shufflevector <2 x float> %695, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %697 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %696, <2 x float> %205, <2 x float> %658), !dbg !114
  %698 = select <2 x i1> %47, <2 x float> %697, <2 x float> %658, !dbg !114
  %699 = extractelement <16 x float> %138, i64 11, !dbg !114
  %700 = insertelement <2 x float> poison, float %699, i32 0, !dbg !114
  %701 = shufflevector <2 x float> %700, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %702 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %701, <2 x float> %205, <2 x float> %663), !dbg !114
  %703 = select <2 x i1> %49, <2 x float> %702, <2 x float> %663, !dbg !114
  %704 = extractelement <16 x float> %142, i64 11, !dbg !114
  %705 = insertelement <2 x float> poison, float %704, i32 0, !dbg !114
  %706 = shufflevector <2 x float> %705, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %707 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %706, <2 x float> %205, <2 x float> %668), !dbg !114
  %708 = select <2 x i1> %51, <2 x float> %707, <2 x float> %668, !dbg !114
  %709 = extractelement <16 x float> %146, i64 11, !dbg !114
  %710 = insertelement <2 x float> poison, float %709, i32 0, !dbg !114
  %711 = shufflevector <2 x float> %710, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %712 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %711, <2 x float> %205, <2 x float> %673), !dbg !114
  %713 = select <2 x i1> %53, <2 x float> %712, <2 x float> %673, !dbg !114
  %714 = extractelement <16 x float> %118, i64 12, !dbg !114
  %715 = insertelement <2 x float> poison, float %714, i32 0, !dbg !114
  %716 = shufflevector <2 x float> %715, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %717 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %716, <2 x float> %210, <2 x float> %678), !dbg !114
  %718 = select <2 x i1> %39, <2 x float> %717, <2 x float> %678, !dbg !114
  %719 = extractelement <16 x float> %122, i64 12, !dbg !114
  %720 = insertelement <2 x float> poison, float %719, i32 0, !dbg !114
  %721 = shufflevector <2 x float> %720, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %722 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %721, <2 x float> %210, <2 x float> %683), !dbg !114
  %723 = select <2 x i1> %41, <2 x float> %722, <2 x float> %683, !dbg !114
  %724 = extractelement <16 x float> %126, i64 12, !dbg !114
  %725 = insertelement <2 x float> poison, float %724, i32 0, !dbg !114
  %726 = shufflevector <2 x float> %725, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %727 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %726, <2 x float> %210, <2 x float> %688), !dbg !114
  %728 = select <2 x i1> %43, <2 x float> %727, <2 x float> %688, !dbg !114
  %729 = extractelement <16 x float> %130, i64 12, !dbg !114
  %730 = insertelement <2 x float> poison, float %729, i32 0, !dbg !114
  %731 = shufflevector <2 x float> %730, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %732 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %731, <2 x float> %210, <2 x float> %693), !dbg !114
  %733 = select <2 x i1> %45, <2 x float> %732, <2 x float> %693, !dbg !114
  %734 = extractelement <16 x float> %134, i64 12, !dbg !114
  %735 = insertelement <2 x float> poison, float %734, i32 0, !dbg !114
  %736 = shufflevector <2 x float> %735, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %737 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %736, <2 x float> %210, <2 x float> %698), !dbg !114
  %738 = select <2 x i1> %47, <2 x float> %737, <2 x float> %698, !dbg !114
  %739 = extractelement <16 x float> %138, i64 12, !dbg !114
  %740 = insertelement <2 x float> poison, float %739, i32 0, !dbg !114
  %741 = shufflevector <2 x float> %740, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %742 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %741, <2 x float> %210, <2 x float> %703), !dbg !114
  %743 = select <2 x i1> %49, <2 x float> %742, <2 x float> %703, !dbg !114
  %744 = extractelement <16 x float> %142, i64 12, !dbg !114
  %745 = insertelement <2 x float> poison, float %744, i32 0, !dbg !114
  %746 = shufflevector <2 x float> %745, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %747 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %746, <2 x float> %210, <2 x float> %708), !dbg !114
  %748 = select <2 x i1> %51, <2 x float> %747, <2 x float> %708, !dbg !114
  %749 = extractelement <16 x float> %146, i64 12, !dbg !114
  %750 = insertelement <2 x float> poison, float %749, i32 0, !dbg !114
  %751 = shufflevector <2 x float> %750, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %752 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %751, <2 x float> %210, <2 x float> %713), !dbg !114
  %753 = select <2 x i1> %53, <2 x float> %752, <2 x float> %713, !dbg !114
  %754 = extractelement <16 x float> %118, i64 13, !dbg !114
  %755 = insertelement <2 x float> poison, float %754, i32 0, !dbg !114
  %756 = shufflevector <2 x float> %755, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %757 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %756, <2 x float> %215, <2 x float> %718), !dbg !114
  %758 = select <2 x i1> %39, <2 x float> %757, <2 x float> %718, !dbg !114
  %759 = extractelement <16 x float> %122, i64 13, !dbg !114
  %760 = insertelement <2 x float> poison, float %759, i32 0, !dbg !114
  %761 = shufflevector <2 x float> %760, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %762 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %761, <2 x float> %215, <2 x float> %723), !dbg !114
  %763 = select <2 x i1> %41, <2 x float> %762, <2 x float> %723, !dbg !114
  %764 = extractelement <16 x float> %126, i64 13, !dbg !114
  %765 = insertelement <2 x float> poison, float %764, i32 0, !dbg !114
  %766 = shufflevector <2 x float> %765, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %767 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %766, <2 x float> %215, <2 x float> %728), !dbg !114
  %768 = select <2 x i1> %43, <2 x float> %767, <2 x float> %728, !dbg !114
  %769 = extractelement <16 x float> %130, i64 13, !dbg !114
  %770 = insertelement <2 x float> poison, float %769, i32 0, !dbg !114
  %771 = shufflevector <2 x float> %770, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %772 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %771, <2 x float> %215, <2 x float> %733), !dbg !114
  %773 = select <2 x i1> %45, <2 x float> %772, <2 x float> %733, !dbg !114
  %774 = extractelement <16 x float> %134, i64 13, !dbg !114
  %775 = insertelement <2 x float> poison, float %774, i32 0, !dbg !114
  %776 = shufflevector <2 x float> %775, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %777 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %776, <2 x float> %215, <2 x float> %738), !dbg !114
  %778 = select <2 x i1> %47, <2 x float> %777, <2 x float> %738, !dbg !114
  %779 = extractelement <16 x float> %138, i64 13, !dbg !114
  %780 = insertelement <2 x float> poison, float %779, i32 0, !dbg !114
  %781 = shufflevector <2 x float> %780, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %782 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %781, <2 x float> %215, <2 x float> %743), !dbg !114
  %783 = select <2 x i1> %49, <2 x float> %782, <2 x float> %743, !dbg !114
  %784 = extractelement <16 x float> %142, i64 13, !dbg !114
  %785 = insertelement <2 x float> poison, float %784, i32 0, !dbg !114
  %786 = shufflevector <2 x float> %785, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %787 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %786, <2 x float> %215, <2 x float> %748), !dbg !114
  %788 = select <2 x i1> %51, <2 x float> %787, <2 x float> %748, !dbg !114
  %789 = extractelement <16 x float> %146, i64 13, !dbg !114
  %790 = insertelement <2 x float> poison, float %789, i32 0, !dbg !114
  %791 = shufflevector <2 x float> %790, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %792 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %791, <2 x float> %215, <2 x float> %753), !dbg !114
  %793 = select <2 x i1> %53, <2 x float> %792, <2 x float> %753, !dbg !114
  %794 = extractelement <16 x float> %118, i64 14, !dbg !114
  %795 = insertelement <2 x float> poison, float %794, i32 0, !dbg !114
  %796 = shufflevector <2 x float> %795, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %797 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %796, <2 x float> %220, <2 x float> %758), !dbg !114
  %798 = select <2 x i1> %39, <2 x float> %797, <2 x float> %758, !dbg !114
  %799 = extractelement <16 x float> %122, i64 14, !dbg !114
  %800 = insertelement <2 x float> poison, float %799, i32 0, !dbg !114
  %801 = shufflevector <2 x float> %800, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %802 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %801, <2 x float> %220, <2 x float> %763), !dbg !114
  %803 = select <2 x i1> %41, <2 x float> %802, <2 x float> %763, !dbg !114
  %804 = extractelement <16 x float> %126, i64 14, !dbg !114
  %805 = insertelement <2 x float> poison, float %804, i32 0, !dbg !114
  %806 = shufflevector <2 x float> %805, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %807 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %806, <2 x float> %220, <2 x float> %768), !dbg !114
  %808 = select <2 x i1> %43, <2 x float> %807, <2 x float> %768, !dbg !114
  %809 = extractelement <16 x float> %130, i64 14, !dbg !114
  %810 = insertelement <2 x float> poison, float %809, i32 0, !dbg !114
  %811 = shufflevector <2 x float> %810, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %812 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %811, <2 x float> %220, <2 x float> %773), !dbg !114
  %813 = select <2 x i1> %45, <2 x float> %812, <2 x float> %773, !dbg !114
  %814 = extractelement <16 x float> %134, i64 14, !dbg !114
  %815 = insertelement <2 x float> poison, float %814, i32 0, !dbg !114
  %816 = shufflevector <2 x float> %815, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %817 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %816, <2 x float> %220, <2 x float> %778), !dbg !114
  %818 = select <2 x i1> %47, <2 x float> %817, <2 x float> %778, !dbg !114
  %819 = extractelement <16 x float> %138, i64 14, !dbg !114
  %820 = insertelement <2 x float> poison, float %819, i32 0, !dbg !114
  %821 = shufflevector <2 x float> %820, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %822 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %821, <2 x float> %220, <2 x float> %783), !dbg !114
  %823 = select <2 x i1> %49, <2 x float> %822, <2 x float> %783, !dbg !114
  %824 = extractelement <16 x float> %142, i64 14, !dbg !114
  %825 = insertelement <2 x float> poison, float %824, i32 0, !dbg !114
  %826 = shufflevector <2 x float> %825, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %827 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %826, <2 x float> %220, <2 x float> %788), !dbg !114
  %828 = select <2 x i1> %51, <2 x float> %827, <2 x float> %788, !dbg !114
  %829 = extractelement <16 x float> %146, i64 14, !dbg !114
  %830 = insertelement <2 x float> poison, float %829, i32 0, !dbg !114
  %831 = shufflevector <2 x float> %830, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %832 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %831, <2 x float> %220, <2 x float> %793), !dbg !114
  %833 = select <2 x i1> %53, <2 x float> %832, <2 x float> %793, !dbg !114
  %834 = extractelement <16 x float> %118, i64 15, !dbg !114
  %835 = insertelement <2 x float> poison, float %834, i32 0, !dbg !114
  %836 = shufflevector <2 x float> %835, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %837 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %836, <2 x float> %225, <2 x float> %798), !dbg !114
  %838 = select <2 x i1> %39, <2 x float> %837, <2 x float> %798, !dbg !114
  %839 = extractelement <16 x float> %122, i64 15, !dbg !114
  %840 = insertelement <2 x float> poison, float %839, i32 0, !dbg !114
  %841 = shufflevector <2 x float> %840, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %842 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %841, <2 x float> %225, <2 x float> %803), !dbg !114
  %843 = select <2 x i1> %41, <2 x float> %842, <2 x float> %803, !dbg !114
  %844 = extractelement <16 x float> %126, i64 15, !dbg !114
  %845 = insertelement <2 x float> poison, float %844, i32 0, !dbg !114
  %846 = shufflevector <2 x float> %845, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %847 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %846, <2 x float> %225, <2 x float> %808), !dbg !114
  %848 = select <2 x i1> %43, <2 x float> %847, <2 x float> %808, !dbg !114
  %849 = extractelement <16 x float> %130, i64 15, !dbg !114
  %850 = insertelement <2 x float> poison, float %849, i32 0, !dbg !114
  %851 = shufflevector <2 x float> %850, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %852 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %851, <2 x float> %225, <2 x float> %813), !dbg !114
  %853 = select <2 x i1> %45, <2 x float> %852, <2 x float> %813, !dbg !114
  %854 = extractelement <16 x float> %134, i64 15, !dbg !114
  %855 = insertelement <2 x float> poison, float %854, i32 0, !dbg !114
  %856 = shufflevector <2 x float> %855, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %857 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %856, <2 x float> %225, <2 x float> %818), !dbg !114
  %858 = select <2 x i1> %47, <2 x float> %857, <2 x float> %818, !dbg !114
  %859 = extractelement <16 x float> %138, i64 15, !dbg !114
  %860 = insertelement <2 x float> poison, float %859, i32 0, !dbg !114
  %861 = shufflevector <2 x float> %860, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %862 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %861, <2 x float> %225, <2 x float> %823), !dbg !114
  %863 = select <2 x i1> %49, <2 x float> %862, <2 x float> %823, !dbg !114
  %864 = extractelement <16 x float> %142, i64 15, !dbg !114
  %865 = insertelement <2 x float> poison, float %864, i32 0, !dbg !114
  %866 = shufflevector <2 x float> %865, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %867 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %866, <2 x float> %225, <2 x float> %828), !dbg !114
  %868 = select <2 x i1> %51, <2 x float> %867, <2 x float> %828, !dbg !114
  %869 = extractelement <16 x float> %146, i64 15, !dbg !114
  %870 = insertelement <2 x float> poison, float %869, i32 0, !dbg !114
  %871 = shufflevector <2 x float> %870, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !114
  %872 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %871, <2 x float> %225, <2 x float> %833), !dbg !114
  %873 = select <2 x i1> %53, <2 x float> %872, <2 x float> %833, !dbg !114
  %874 = insertvalue [8 x <2 x float>] poison, <2 x float> %838, 0, !dbg !114
  %875 = insertvalue [8 x <2 x float>] %874, <2 x float> %843, 1, !dbg !114
  %876 = insertvalue [8 x <2 x float>] %875, <2 x float> %848, 2, !dbg !114
  %877 = insertvalue [8 x <2 x float>] %876, <2 x float> %853, 3, !dbg !114
  %878 = insertvalue [8 x <2 x float>] %877, <2 x float> %858, 4, !dbg !114
  %879 = insertvalue [8 x <2 x float>] %878, <2 x float> %863, 5, !dbg !114
  %880 = insertvalue [8 x <2 x float>] %879, <2 x float> %868, 6, !dbg !114
  %881 = insertvalue [8 x <2 x float>] %880, <2 x float> %873, 7, !dbg !114
  %882 = add i64 %111, 16, !dbg !111
  br label %110, !dbg !111

883:                                              ; preds = %110
  %884 = extractvalue [8 x <2 x float>] %112, 0, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %884, ptr align 4 %57, <2 x i1> %39), !dbg !114
  %885 = extractvalue [8 x <2 x float>] %112, 1, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %885, ptr align 4 %61, <2 x i1> %41), !dbg !114
  %886 = extractvalue [8 x <2 x float>] %112, 2, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %886, ptr align 4 %65, <2 x i1> %43), !dbg !114
  %887 = extractvalue [8 x <2 x float>] %112, 3, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %887, ptr align 4 %69, <2 x i1> %45), !dbg !114
  %888 = extractvalue [8 x <2 x float>] %112, 4, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %888, ptr align 4 %73, <2 x i1> %47), !dbg !114
  %889 = extractvalue [8 x <2 x float>] %112, 5, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %889, ptr align 4 %77, <2 x i1> %49), !dbg !114
  %890 = extractvalue [8 x <2 x float>] %112, 6, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %890, ptr align 4 %81, <2 x i1> %51), !dbg !114
  %891 = extractvalue [8 x <2 x float>] %112, 7, !dbg !114
  call void @llvm.masked.store.v2f32.p0(<2 x float> %891, ptr align 4 %85, <2 x i1> %53), !dbg !114
  %892 = add i64 %32, 8, !dbg !111
  br label %31, !dbg !111

893:                                              ; preds = %31
  ret i32 0, !dbg !115
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <9 x float> @llvm.masked.load.v9f32.p0(ptr captures(none), <9 x i1>, <9 x float>) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.masked.store.v16f32.p0(<16 x float>, ptr captures(none), <16 x i1>) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <16 x float> @llvm.masked.load.v16f32.p0(ptr captures(none), <16 x i1>, <16 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <16 x float> @llvm.fmuladd.v16f32(<16 x float>, <16 x float>, <16 x float>) #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.masked.store.v2f32.p0(<2 x float>, ptr captures(none), <2 x i1>) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <2 x float> @llvm.masked.load.v2f32.p0(ptr captures(none), <2 x i1>, <2 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fmuladd.v2f32(<2 x float>, <2 x float>, <2 x float>) #4

; Function Attrs: uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr %1) #5 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden float @iree_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #6 {
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
define hidden signext i16 @iree_f2h_ieee(float noundef %0) local_unnamed_addr #6 {
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
define hidden float @__gnu_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #6 {
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
define hidden float @__extendhfsf2(float noundef %0) local_unnamed_addr #6 {
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
define hidden signext i16 @__gnu_f2h_ieee(float noundef %0) local_unnamed_addr #6 {
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
define hidden float @__truncsfhf2(float noundef %0) local_unnamed_addr #6 {
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
  store i16 %36, ptr %2, align 4, !tbaa !116
  %37 = load float, ptr %2, align 4, !tbaa !118
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %37
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #7

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden double @__extendhfdf2(float noundef %0) local_unnamed_addr #6 {
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
define hidden float @__truncdfhf2(double noundef %0) local_unnamed_addr #6 {
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
  store i16 %37, ptr %2, align 4, !tbaa !116
  %38 = load float, ptr %2, align 4, !tbaa !118
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %38
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define hidden noundef double @fma(double noundef %0, double noundef %1, double noundef %2) local_unnamed_addr #6 {
  %4 = tail call double @llvm.fmuladd.f64(double %0, double %1, double %2)
  ret double %4
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #8

; Function Attrs: inlinehint
define hidden noundef float @__math_invalidf(float noundef %0) local_unnamed_addr #9 {
  %2 = fsub float %0, %0
  %3 = fdiv float %2, %2
  ret float %3
}

; Function Attrs: inlinehint
define hidden float @__math_oflowf(i32 noundef %0) local_unnamed_addr #9 {
  %2 = tail call float @__math_xflowf(i32 noundef %0, float noundef 0x4600000000000000) #9
  ret float %2
}

; Function Attrs: inlinehint
define hidden float @__math_xflowf(i32 noundef %0, float noundef %1) local_unnamed_addr #9 {
  %3 = alloca float, align 4
  %.not = icmp eq i32 %0, 0
  %4 = fneg float %1
  %5 = select i1 %.not, float %1, float %4
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %5, ptr %3, align 4, !tbaa !118
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !118
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %6 = fmul float %1, %.0..0..0..0..0..0..i
  ret float %6
}

; Function Attrs: inlinehint
define hidden float @__math_uflowf(i32 noundef %0) local_unnamed_addr #9 {
  %2 = tail call float @__math_xflowf(i32 noundef %0, float noundef 0x3A00000000000000) #9
  ret float %2
}

; Function Attrs: inlinehint
define hidden float @ceilf(float noundef %0) local_unnamed_addr #9 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !118
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
  store volatile float %24, ptr %2, align 4, !tbaa !118
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
define hidden float @expf(float noundef %0) local_unnamed_addr #9 {
  %2 = fpext float %0 to double
  %3 = bitcast float %0 to i32
  %4 = lshr i32 %3, 20
  %5 = and i32 %4, 2047
  %.not = icmp samesign ult i32 %5, 1067
  br i1 %.not, label %19, label %6, !prof !120

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
  %14 = tail call float @__math_oflowf(i32 noundef 0) #9
  br label %42

15:                                               ; preds = %11
  %16 = fcmp olt float %0, 0xC059FE3680000000
  br i1 %16, label %17, label %19

17:                                               ; preds = %15
  %18 = tail call float @__math_uflowf(i32 noundef 0) #9
  br label %42

19:                                               ; preds = %15, %1
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !121
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !124
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !125
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !127
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !127
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !127
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
define hidden noundef i32 @feclearexcept(i32 noundef %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @feraiseexcept(i32 noundef %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fetestexcept(i32 noundef %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fegetround() local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @__fesetround(i32 noundef %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fegetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden noundef i32 @fesetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #9 {
  ret i32 0
}

; Function Attrs: inlinehint
define hidden float @floorf(float noundef %0) local_unnamed_addr #9 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !118
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
  store volatile float %23, ptr %2, align 4, !tbaa !118
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
define hidden float @fmaf(float noundef %0, float noundef %1, float noundef %2) local_unnamed_addr #9 {
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
  %23 = tail call i32 @fegetround() #9
  %.not = icmp eq i32 %23, 0
  br i1 %.not, label %34, label %24

24:                                               ; preds = %22, %17, %3
  %25 = add nsw i32 %13, -874
  %or.cond3 = icmp ult i32 %25, 23
  br i1 %or.cond3, label %26, label %46

26:                                               ; preds = %24
  %27 = tail call i32 @fetestexcept(i32 noundef 32) #9
  %.not41 = icmp eq i32 %27, 0
  br i1 %.not41, label %46, label %28

28:                                               ; preds = %26
  %29 = tail call i32 @feclearexcept(i32 noundef 32) #9
  call void @llvm.lifetime.start.p0(ptr nonnull %4)
  store volatile float %2, ptr %4, align 4, !tbaa !118
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !118
  %30 = fpext float %.0..0..0..0.5 to double
  %31 = fadd double %7, %30
  %32 = tail call i32 @fetestexcept(i32 noundef 32) #9
  %.not42 = icmp eq i32 %32, 0
  %. = select i1 %.not42, i32 32, i32 16
  %33 = tail call i32 @feraiseexcept(i32 noundef %.) #9
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
define hidden float @fmodf(float noundef %0, float noundef %1) local_unnamed_addr #9 {
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
declare float @llvm.fabs.f32(float) #8

; Function Attrs: inlinehint
define hidden float @frexpf(float noundef %0, ptr noundef captures(none) %1) local_unnamed_addr #9 {
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
  %9 = tail call float @frexpf(float noundef %8, ptr noundef %1) #9
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
define hidden float @ldexpf(float noundef %0, i32 noundef %1) local_unnamed_addr #9 {
  %3 = tail call float @scalbnf(float noundef %0, i32 noundef %1) #9
  ret float %3
}

; Function Attrs: inlinehint
define hidden float @scalbnf(float noundef %0, i32 noundef %1) local_unnamed_addr #9 {
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
declare i32 @llvm.umin.i32(i32, i32) #8

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #8

; Function Attrs: inlinehint
define hidden float @powf(float noundef %0, float noundef %1) local_unnamed_addr #9 {
  %3 = alloca float, align 4
  %4 = bitcast float %0 to i32
  %5 = bitcast float %1 to i32
  %6 = add i32 %4, -2139095040
  %7 = icmp ult i32 %6, -2130706432
  %.pre = shl i32 %5, 1
  %8 = add i32 %.pre, 16777216
  %9 = icmp ult i32 %8, 16777217
  %or.cond99 = or i1 %7, %9
  br i1 %or.cond99, label %.critedge, label %73, !prof !128

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !120

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
  br i1 %31, label %47, label %32, !prof !120

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
  store volatile float %46, ptr %3, align 4, !tbaa !118
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !118
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
  %61 = tail call float @__math_invalidf(float noundef %0) #9
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
  %82 = load double, ptr %81, align 8, !tbaa !129
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !131
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !127
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !127
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !127
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !127
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !127
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !132

107:                                              ; preds = %73
  %108 = fcmp ogt double %103, 0x405FFFFFFFD1D571
  br i1 %108, label %109, label %111

109:                                              ; preds = %107
  %110 = tail call float @__math_oflowf(i32 noundef %.050) #9
  br label %138

111:                                              ; preds = %107
  %112 = fcmp ugt double %103, -1.500000e+02
  br i1 %112, label %115, label %113

113:                                              ; preds = %111
  %114 = tail call float @__math_uflowf(i32 noundef %.050) #9
  br label %138

115:                                              ; preds = %111, %73
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !133
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !125
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !127
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !127
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !127
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
define hidden noundef float @rintf(float noundef %0) local_unnamed_addr #9 {
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
define hidden float @roundf(float noundef %0) local_unnamed_addr #9 {
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
  store volatile float %9, ptr %2, align 4, !tbaa !118
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
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #4 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #5 = { uwtable "nonlazybind" }
attributes #6 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #7 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { inlinehint }

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!4, !5, !6}
!llvm.errno.tbaa = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/dynamic")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/x86_64/dump/dynamic")
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"frame-pointer", i32 2}
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
!97 = !DILocation(line: 27, column: 8, scope: !11)
!98 = !DILocation(line: 10, column: 8, scope: !11)
!99 = !DILocation(line: 1, column: 1, scope: !11)
!100 = !DILocation(line: 30, column: 8, scope: !11)
!101 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_Dx2x64_f32", linkageName: "infer_dispatch_1_matmul_Dx2x64_f32", scope: !3, file: !3, line: 1, type: !12, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!102 = !DILocation(line: 12, column: 8, scope: !101)
!103 = !DILocation(line: 13, column: 8, scope: !101)
!104 = !DILocation(line: 14, column: 8, scope: !101)
!105 = !DILocation(line: 15, column: 8, scope: !101)
!106 = !DILocation(line: 16, column: 8, scope: !101)
!107 = !DILocation(line: 17, column: 8, scope: !101)
!108 = !DILocation(line: 20, column: 8, scope: !101)
!109 = !DILocation(line: 22, column: 8, scope: !101)
!110 = !DILocation(line: 23, column: 8, scope: !101)
!111 = !DILocation(line: 28, column: 8, scope: !101)
!112 = !DILocation(line: 27, column: 8, scope: !101)
!113 = !DILocation(line: 10, column: 8, scope: !101)
!114 = !DILocation(line: 1, column: 1, scope: !101)
!115 = !DILocation(line: 30, column: 8, scope: !101)
!116 = !{!117, !117, i64 0}
!117 = !{!"short", !9, i64 0}
!118 = !{!119, !119, i64 0}
!119 = !{!"float", !9, i64 0}
!120 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!121 = !{!122, !123, i64 296}
!122 = !{!"exp2f_data", !9, i64 0, !123, i64 256, !9, i64 264, !123, i64 288, !123, i64 296, !9, i64 304}
!123 = !{!"double", !9, i64 0}
!124 = !{!122, !123, i64 288}
!125 = !{!126, !126, i64 0}
!126 = !{!"long", !9, i64 0}
!127 = !{!123, !123, i64 0}
!128 = !{!"branch_weights", i32 4001, i32 4000000}
!129 = !{!130, !123, i64 0}
!130 = !{!"", !123, i64 0, !123, i64 8}
!131 = !{!130, !123, i64 8}
!132 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!133 = !{!122, !123, i64 256}
