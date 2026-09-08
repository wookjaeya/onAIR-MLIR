; ModuleID = 'dyn_batch_mlp_linked'
source_filename = "dyn_batch_mlp_linked"
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

@0 = private constant [21 x i8] c"dyn_batch_mlp_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [2 x ptr] [ptr @infer_dispatch_0_matmul_Dx64x9_f32, ptr @infer_dispatch_1_matmul_Dx2x64_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [35 x i8] c"infer_dispatch_0_matmul_Dx64x9_f32\00", align 1
@2 = private constant [35 x i8] c"infer_dispatch_1_matmul_Dx2x64_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [2 x ptr] [ptr @1, ptr @2]
@3 = private constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [86 x i8] c"results/e14_aarch64_qemu/aarch64/dump/dynamic/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 85, ptr @4 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [2 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_Dx64x9_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_Dx2x64_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 2, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_matmul_Dx64x9_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !5 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !81
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !81
  %6 = load i32, ptr %5, align 4, !dbg !81
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !82
  %8 = load i32, ptr %7, align 4, !dbg !82
  %9 = zext i32 %6 to i64, !dbg !83
  %10 = zext i32 %8 to i64, !dbg !84
  %11 = shl i64 %10, 32, !dbg !85
  %12 = or i64 %9, %11, !dbg !86
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !87
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !87
  %15 = load ptr, ptr %14, align 8, !dbg !87
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !87
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !88
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !88
  %18 = load ptr, ptr %17, align 8, !dbg !88
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !88
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !89
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !89
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !89
  %22 = load ptr, ptr %21, align 8, !dbg !89
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !89
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !90
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !90
  %25 = zext i32 %24 to i64, !dbg !90
  %26 = sdiv i64 %25, 8, !dbg !90
  %27 = mul i64 %26, 8, !dbg !90
  %28 = icmp ne i64 %25, %27, !dbg !90
  %29 = icmp slt i64 %25, 0, !dbg !90
  %30 = and i1 %28, %29, !dbg !90
  %31 = add i64 %26, -1, !dbg !90
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !90
  %33 = srem i64 %25, 8, !dbg !90
  %34 = icmp slt i64 %33, 0, !dbg !90
  %35 = add nsw i64 %33, 8, !dbg !90
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !90
  %37 = mul nsw i64 %32, 64, !dbg !90
  %38 = mul nsw i64 %36, 8, !dbg !90
  %39 = mul nsw i64 %32, -64, !dbg !90
  %40 = add i64 %39, %12, !dbg !90
  %41 = icmp slt i64 %40, 64, !dbg !90
  %42 = select i1 %41, i64 %40, i64 64, !dbg !90
  %43 = icmp slt i64 %42, 0, !dbg !90
  %44 = sub i64 -1, %42, !dbg !90
  %45 = select i1 %43, i64 %44, i64 %42, !dbg !90
  %46 = sdiv i64 %45, 64, !dbg !90
  %47 = sub i64 -1, %46, !dbg !90
  %48 = select i1 %43, i64 %47, i64 %46, !dbg !90
  %49 = mul nsw i64 %48, 64, !dbg !90
  %50 = icmp sgt i64 %49, 0, !dbg !90
  br i1 %50, label %51, label %405, !dbg !90

51:                                               ; preds = %3
  %52 = add i64 512, %38, !dbg !90
  %53 = getelementptr float, ptr %15, i64 %52, !dbg !90
  %54 = load <8 x float>, ptr %53, align 4, !dbg !90
  br label %55, !dbg !90

55:                                               ; preds = %307, %51
  %56 = phi i64 [ %404, %307 ], [ 0, %51 ], !dbg !90
  %57 = icmp slt i64 %56, 64, !dbg !90
  br i1 %57, label %58, label %405, !dbg !90

58:                                               ; preds = %62, %55
  %59 = phi i64 [ %306, %62 ], [ 0, %55 ], !dbg !90
  %60 = phi [8 x <8 x float>] [ %305, %62 ], [ zeroinitializer, %55 ], !dbg !90
  %61 = icmp slt i64 %59, 8, !dbg !90
  br i1 %61, label %62, label %307, !dbg !90

62:                                               ; preds = %58
  %63 = mul i64 %59, 64, !dbg !90
  %64 = add i64 %63, %38, !dbg !90
  %65 = getelementptr float, ptr %15, i64 %64, !dbg !90
  %66 = load <8 x float>, ptr %65, align 4, !dbg !90
  %67 = add i64 %59, 1, !dbg !90
  %68 = mul i64 %67, 64, !dbg !90
  %69 = add i64 %68, %38, !dbg !90
  %70 = getelementptr float, ptr %15, i64 %69, !dbg !90
  %71 = load <8 x float>, ptr %70, align 4, !dbg !90
  %72 = add i64 %59, 2, !dbg !90
  %73 = mul i64 %72, 64, !dbg !90
  %74 = add i64 %73, %38, !dbg !90
  %75 = getelementptr float, ptr %15, i64 %74, !dbg !90
  %76 = load <8 x float>, ptr %75, align 4, !dbg !90
  %77 = add i64 %59, 3, !dbg !90
  %78 = mul i64 %77, 64, !dbg !90
  %79 = add i64 %78, %38, !dbg !90
  %80 = getelementptr float, ptr %15, i64 %79, !dbg !90
  %81 = load <8 x float>, ptr %80, align 4, !dbg !90
  %82 = add i64 %56, %37, !dbg !91
  %83 = mul nuw nsw i64 %82, 9, !dbg !91
  %84 = add nuw nsw i64 %83, %59, !dbg !91
  %85 = getelementptr inbounds nuw float, ptr %18, i64 %84, !dbg !91
  %86 = load float, ptr %85, align 4, !dbg !91
  %87 = insertelement <8 x float> poison, float %86, i32 0, !dbg !91
  %88 = shufflevector <8 x float> %87, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %89 = extractvalue [8 x <8 x float>] %60, 0, !dbg !91
  %90 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %88, <8 x float> %66, <8 x float> %89), !dbg !91
  %91 = add i64 %82, 1, !dbg !91
  %92 = mul nuw nsw i64 %91, 9, !dbg !91
  %93 = add nuw nsw i64 %92, %59, !dbg !91
  %94 = getelementptr inbounds nuw float, ptr %18, i64 %93, !dbg !91
  %95 = load float, ptr %94, align 4, !dbg !91
  %96 = insertelement <8 x float> poison, float %95, i32 0, !dbg !91
  %97 = shufflevector <8 x float> %96, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %98 = extractvalue [8 x <8 x float>] %60, 1, !dbg !91
  %99 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %97, <8 x float> %66, <8 x float> %98), !dbg !91
  %100 = add i64 %82, 2, !dbg !91
  %101 = mul nuw nsw i64 %100, 9, !dbg !91
  %102 = add nuw nsw i64 %101, %59, !dbg !91
  %103 = getelementptr inbounds nuw float, ptr %18, i64 %102, !dbg !91
  %104 = load float, ptr %103, align 4, !dbg !91
  %105 = insertelement <8 x float> poison, float %104, i32 0, !dbg !91
  %106 = shufflevector <8 x float> %105, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %107 = extractvalue [8 x <8 x float>] %60, 2, !dbg !91
  %108 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %106, <8 x float> %66, <8 x float> %107), !dbg !91
  %109 = add i64 %82, 3, !dbg !91
  %110 = mul nuw nsw i64 %109, 9, !dbg !91
  %111 = add nuw nsw i64 %110, %59, !dbg !91
  %112 = getelementptr inbounds nuw float, ptr %18, i64 %111, !dbg !91
  %113 = load float, ptr %112, align 4, !dbg !91
  %114 = insertelement <8 x float> poison, float %113, i32 0, !dbg !91
  %115 = shufflevector <8 x float> %114, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %116 = extractvalue [8 x <8 x float>] %60, 3, !dbg !91
  %117 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %115, <8 x float> %66, <8 x float> %116), !dbg !91
  %118 = add i64 %82, 4, !dbg !91
  %119 = mul nuw nsw i64 %118, 9, !dbg !91
  %120 = add nuw nsw i64 %119, %59, !dbg !91
  %121 = getelementptr inbounds nuw float, ptr %18, i64 %120, !dbg !91
  %122 = load float, ptr %121, align 4, !dbg !91
  %123 = insertelement <8 x float> poison, float %122, i32 0, !dbg !91
  %124 = shufflevector <8 x float> %123, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %125 = extractvalue [8 x <8 x float>] %60, 4, !dbg !91
  %126 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %124, <8 x float> %66, <8 x float> %125), !dbg !91
  %127 = add i64 %82, 5, !dbg !91
  %128 = mul nuw nsw i64 %127, 9, !dbg !91
  %129 = add nuw nsw i64 %128, %59, !dbg !91
  %130 = getelementptr inbounds nuw float, ptr %18, i64 %129, !dbg !91
  %131 = load float, ptr %130, align 4, !dbg !91
  %132 = insertelement <8 x float> poison, float %131, i32 0, !dbg !91
  %133 = shufflevector <8 x float> %132, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %134 = extractvalue [8 x <8 x float>] %60, 5, !dbg !91
  %135 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %133, <8 x float> %66, <8 x float> %134), !dbg !91
  %136 = add i64 %82, 6, !dbg !91
  %137 = mul nuw nsw i64 %136, 9, !dbg !91
  %138 = add nuw nsw i64 %137, %59, !dbg !91
  %139 = getelementptr inbounds nuw float, ptr %18, i64 %138, !dbg !91
  %140 = load float, ptr %139, align 4, !dbg !91
  %141 = insertelement <8 x float> poison, float %140, i32 0, !dbg !91
  %142 = shufflevector <8 x float> %141, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %143 = extractvalue [8 x <8 x float>] %60, 6, !dbg !91
  %144 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %66, <8 x float> %143), !dbg !91
  %145 = add i64 %82, 7, !dbg !91
  %146 = mul nuw nsw i64 %145, 9, !dbg !91
  %147 = add nuw nsw i64 %146, %59, !dbg !91
  %148 = getelementptr inbounds nuw float, ptr %18, i64 %147, !dbg !91
  %149 = load float, ptr %148, align 4, !dbg !91
  %150 = insertelement <8 x float> poison, float %149, i32 0, !dbg !91
  %151 = shufflevector <8 x float> %150, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %152 = extractvalue [8 x <8 x float>] %60, 7, !dbg !91
  %153 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %151, <8 x float> %66, <8 x float> %152), !dbg !91
  %154 = add nuw nsw i64 %83, %67, !dbg !91
  %155 = getelementptr inbounds nuw float, ptr %18, i64 %154, !dbg !91
  %156 = load float, ptr %155, align 4, !dbg !91
  %157 = insertelement <8 x float> poison, float %156, i32 0, !dbg !91
  %158 = shufflevector <8 x float> %157, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %159 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %158, <8 x float> %71, <8 x float> %90), !dbg !91
  %160 = add nuw nsw i64 %92, %67, !dbg !91
  %161 = getelementptr inbounds nuw float, ptr %18, i64 %160, !dbg !91
  %162 = load float, ptr %161, align 4, !dbg !91
  %163 = insertelement <8 x float> poison, float %162, i32 0, !dbg !91
  %164 = shufflevector <8 x float> %163, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %165 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %164, <8 x float> %71, <8 x float> %99), !dbg !91
  %166 = add nuw nsw i64 %101, %67, !dbg !91
  %167 = getelementptr inbounds nuw float, ptr %18, i64 %166, !dbg !91
  %168 = load float, ptr %167, align 4, !dbg !91
  %169 = insertelement <8 x float> poison, float %168, i32 0, !dbg !91
  %170 = shufflevector <8 x float> %169, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %171 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %170, <8 x float> %71, <8 x float> %108), !dbg !91
  %172 = add nuw nsw i64 %110, %67, !dbg !91
  %173 = getelementptr inbounds nuw float, ptr %18, i64 %172, !dbg !91
  %174 = load float, ptr %173, align 4, !dbg !91
  %175 = insertelement <8 x float> poison, float %174, i32 0, !dbg !91
  %176 = shufflevector <8 x float> %175, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %177 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %176, <8 x float> %71, <8 x float> %117), !dbg !91
  %178 = add nuw nsw i64 %119, %67, !dbg !91
  %179 = getelementptr inbounds nuw float, ptr %18, i64 %178, !dbg !91
  %180 = load float, ptr %179, align 4, !dbg !91
  %181 = insertelement <8 x float> poison, float %180, i32 0, !dbg !91
  %182 = shufflevector <8 x float> %181, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %183 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %182, <8 x float> %71, <8 x float> %126), !dbg !91
  %184 = add nuw nsw i64 %128, %67, !dbg !91
  %185 = getelementptr inbounds nuw float, ptr %18, i64 %184, !dbg !91
  %186 = load float, ptr %185, align 4, !dbg !91
  %187 = insertelement <8 x float> poison, float %186, i32 0, !dbg !91
  %188 = shufflevector <8 x float> %187, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %189 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %188, <8 x float> %71, <8 x float> %135), !dbg !91
  %190 = add nuw nsw i64 %137, %67, !dbg !91
  %191 = getelementptr inbounds nuw float, ptr %18, i64 %190, !dbg !91
  %192 = load float, ptr %191, align 4, !dbg !91
  %193 = insertelement <8 x float> poison, float %192, i32 0, !dbg !91
  %194 = shufflevector <8 x float> %193, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %195 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %194, <8 x float> %71, <8 x float> %144), !dbg !91
  %196 = add nuw nsw i64 %146, %67, !dbg !91
  %197 = getelementptr inbounds nuw float, ptr %18, i64 %196, !dbg !91
  %198 = load float, ptr %197, align 4, !dbg !91
  %199 = insertelement <8 x float> poison, float %198, i32 0, !dbg !91
  %200 = shufflevector <8 x float> %199, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %201 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %200, <8 x float> %71, <8 x float> %153), !dbg !91
  %202 = add nuw nsw i64 %83, %72, !dbg !91
  %203 = getelementptr inbounds nuw float, ptr %18, i64 %202, !dbg !91
  %204 = load float, ptr %203, align 4, !dbg !91
  %205 = insertelement <8 x float> poison, float %204, i32 0, !dbg !91
  %206 = shufflevector <8 x float> %205, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %207 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %206, <8 x float> %76, <8 x float> %159), !dbg !91
  %208 = add nuw nsw i64 %92, %72, !dbg !91
  %209 = getelementptr inbounds nuw float, ptr %18, i64 %208, !dbg !91
  %210 = load float, ptr %209, align 4, !dbg !91
  %211 = insertelement <8 x float> poison, float %210, i32 0, !dbg !91
  %212 = shufflevector <8 x float> %211, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %213 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %212, <8 x float> %76, <8 x float> %165), !dbg !91
  %214 = add nuw nsw i64 %101, %72, !dbg !91
  %215 = getelementptr inbounds nuw float, ptr %18, i64 %214, !dbg !91
  %216 = load float, ptr %215, align 4, !dbg !91
  %217 = insertelement <8 x float> poison, float %216, i32 0, !dbg !91
  %218 = shufflevector <8 x float> %217, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %219 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %218, <8 x float> %76, <8 x float> %171), !dbg !91
  %220 = add nuw nsw i64 %110, %72, !dbg !91
  %221 = getelementptr inbounds nuw float, ptr %18, i64 %220, !dbg !91
  %222 = load float, ptr %221, align 4, !dbg !91
  %223 = insertelement <8 x float> poison, float %222, i32 0, !dbg !91
  %224 = shufflevector <8 x float> %223, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %225 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %224, <8 x float> %76, <8 x float> %177), !dbg !91
  %226 = add nuw nsw i64 %119, %72, !dbg !91
  %227 = getelementptr inbounds nuw float, ptr %18, i64 %226, !dbg !91
  %228 = load float, ptr %227, align 4, !dbg !91
  %229 = insertelement <8 x float> poison, float %228, i32 0, !dbg !91
  %230 = shufflevector <8 x float> %229, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %231 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %230, <8 x float> %76, <8 x float> %183), !dbg !91
  %232 = add nuw nsw i64 %128, %72, !dbg !91
  %233 = getelementptr inbounds nuw float, ptr %18, i64 %232, !dbg !91
  %234 = load float, ptr %233, align 4, !dbg !91
  %235 = insertelement <8 x float> poison, float %234, i32 0, !dbg !91
  %236 = shufflevector <8 x float> %235, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %237 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %236, <8 x float> %76, <8 x float> %189), !dbg !91
  %238 = add nuw nsw i64 %137, %72, !dbg !91
  %239 = getelementptr inbounds nuw float, ptr %18, i64 %238, !dbg !91
  %240 = load float, ptr %239, align 4, !dbg !91
  %241 = insertelement <8 x float> poison, float %240, i32 0, !dbg !91
  %242 = shufflevector <8 x float> %241, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %243 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %242, <8 x float> %76, <8 x float> %195), !dbg !91
  %244 = add nuw nsw i64 %146, %72, !dbg !91
  %245 = getelementptr inbounds nuw float, ptr %18, i64 %244, !dbg !91
  %246 = load float, ptr %245, align 4, !dbg !91
  %247 = insertelement <8 x float> poison, float %246, i32 0, !dbg !91
  %248 = shufflevector <8 x float> %247, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %249 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %248, <8 x float> %76, <8 x float> %201), !dbg !91
  %250 = add nuw nsw i64 %83, %77, !dbg !91
  %251 = getelementptr inbounds nuw float, ptr %18, i64 %250, !dbg !91
  %252 = load float, ptr %251, align 4, !dbg !91
  %253 = insertelement <8 x float> poison, float %252, i32 0, !dbg !91
  %254 = shufflevector <8 x float> %253, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %255 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %254, <8 x float> %81, <8 x float> %207), !dbg !91
  %256 = add nuw nsw i64 %92, %77, !dbg !91
  %257 = getelementptr inbounds nuw float, ptr %18, i64 %256, !dbg !91
  %258 = load float, ptr %257, align 4, !dbg !91
  %259 = insertelement <8 x float> poison, float %258, i32 0, !dbg !91
  %260 = shufflevector <8 x float> %259, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %261 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %260, <8 x float> %81, <8 x float> %213), !dbg !91
  %262 = add nuw nsw i64 %101, %77, !dbg !91
  %263 = getelementptr inbounds nuw float, ptr %18, i64 %262, !dbg !91
  %264 = load float, ptr %263, align 4, !dbg !91
  %265 = insertelement <8 x float> poison, float %264, i32 0, !dbg !91
  %266 = shufflevector <8 x float> %265, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %267 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %266, <8 x float> %81, <8 x float> %219), !dbg !91
  %268 = add nuw nsw i64 %110, %77, !dbg !91
  %269 = getelementptr inbounds nuw float, ptr %18, i64 %268, !dbg !91
  %270 = load float, ptr %269, align 4, !dbg !91
  %271 = insertelement <8 x float> poison, float %270, i32 0, !dbg !91
  %272 = shufflevector <8 x float> %271, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %273 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %272, <8 x float> %81, <8 x float> %225), !dbg !91
  %274 = add nuw nsw i64 %119, %77, !dbg !91
  %275 = getelementptr inbounds nuw float, ptr %18, i64 %274, !dbg !91
  %276 = load float, ptr %275, align 4, !dbg !91
  %277 = insertelement <8 x float> poison, float %276, i32 0, !dbg !91
  %278 = shufflevector <8 x float> %277, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %279 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %278, <8 x float> %81, <8 x float> %231), !dbg !91
  %280 = add nuw nsw i64 %128, %77, !dbg !91
  %281 = getelementptr inbounds nuw float, ptr %18, i64 %280, !dbg !91
  %282 = load float, ptr %281, align 4, !dbg !91
  %283 = insertelement <8 x float> poison, float %282, i32 0, !dbg !91
  %284 = shufflevector <8 x float> %283, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %285 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %284, <8 x float> %81, <8 x float> %237), !dbg !91
  %286 = add nuw nsw i64 %137, %77, !dbg !91
  %287 = getelementptr inbounds nuw float, ptr %18, i64 %286, !dbg !91
  %288 = load float, ptr %287, align 4, !dbg !91
  %289 = insertelement <8 x float> poison, float %288, i32 0, !dbg !91
  %290 = shufflevector <8 x float> %289, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %291 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %290, <8 x float> %81, <8 x float> %243), !dbg !91
  %292 = add nuw nsw i64 %146, %77, !dbg !91
  %293 = getelementptr inbounds nuw float, ptr %18, i64 %292, !dbg !91
  %294 = load float, ptr %293, align 4, !dbg !91
  %295 = insertelement <8 x float> poison, float %294, i32 0, !dbg !91
  %296 = shufflevector <8 x float> %295, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %297 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %296, <8 x float> %81, <8 x float> %249), !dbg !91
  %298 = insertvalue [8 x <8 x float>] poison, <8 x float> %255, 0, !dbg !91
  %299 = insertvalue [8 x <8 x float>] %298, <8 x float> %261, 1, !dbg !91
  %300 = insertvalue [8 x <8 x float>] %299, <8 x float> %267, 2, !dbg !91
  %301 = insertvalue [8 x <8 x float>] %300, <8 x float> %273, 3, !dbg !91
  %302 = insertvalue [8 x <8 x float>] %301, <8 x float> %279, 4, !dbg !91
  %303 = insertvalue [8 x <8 x float>] %302, <8 x float> %285, 5, !dbg !91
  %304 = insertvalue [8 x <8 x float>] %303, <8 x float> %291, 6, !dbg !91
  %305 = insertvalue [8 x <8 x float>] %304, <8 x float> %297, 7, !dbg !91
  %306 = add i64 %59, 4, !dbg !90
  br label %58, !dbg !90

307:                                              ; preds = %58
  %308 = add i64 %56, %37, !dbg !91
  %309 = mul nuw nsw i64 %308, 9, !dbg !91
  %310 = add nuw nsw i64 %309, 8, !dbg !91
  %311 = getelementptr inbounds nuw float, ptr %18, i64 %310, !dbg !91
  %312 = load float, ptr %311, align 4, !dbg !91
  %313 = insertelement <8 x float> poison, float %312, i32 0, !dbg !91
  %314 = shufflevector <8 x float> %313, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %315 = extractvalue [8 x <8 x float>] %60, 0, !dbg !91
  %316 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %314, <8 x float> %54, <8 x float> %315), !dbg !91
  %317 = add i64 %308, 1, !dbg !91
  %318 = mul nuw nsw i64 %317, 9, !dbg !91
  %319 = add nuw nsw i64 %318, 8, !dbg !91
  %320 = getelementptr inbounds nuw float, ptr %18, i64 %319, !dbg !91
  %321 = load float, ptr %320, align 4, !dbg !91
  %322 = insertelement <8 x float> poison, float %321, i32 0, !dbg !91
  %323 = shufflevector <8 x float> %322, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %324 = extractvalue [8 x <8 x float>] %60, 1, !dbg !91
  %325 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %323, <8 x float> %54, <8 x float> %324), !dbg !91
  %326 = add i64 %308, 2, !dbg !91
  %327 = mul nuw nsw i64 %326, 9, !dbg !91
  %328 = add nuw nsw i64 %327, 8, !dbg !91
  %329 = getelementptr inbounds nuw float, ptr %18, i64 %328, !dbg !91
  %330 = load float, ptr %329, align 4, !dbg !91
  %331 = insertelement <8 x float> poison, float %330, i32 0, !dbg !91
  %332 = shufflevector <8 x float> %331, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %333 = extractvalue [8 x <8 x float>] %60, 2, !dbg !91
  %334 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %332, <8 x float> %54, <8 x float> %333), !dbg !91
  %335 = add i64 %308, 3, !dbg !91
  %336 = mul nuw nsw i64 %335, 9, !dbg !91
  %337 = add nuw nsw i64 %336, 8, !dbg !91
  %338 = getelementptr inbounds nuw float, ptr %18, i64 %337, !dbg !91
  %339 = load float, ptr %338, align 4, !dbg !91
  %340 = insertelement <8 x float> poison, float %339, i32 0, !dbg !91
  %341 = shufflevector <8 x float> %340, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %342 = extractvalue [8 x <8 x float>] %60, 3, !dbg !91
  %343 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %341, <8 x float> %54, <8 x float> %342), !dbg !91
  %344 = add i64 %308, 4, !dbg !91
  %345 = mul nuw nsw i64 %344, 9, !dbg !91
  %346 = add nuw nsw i64 %345, 8, !dbg !91
  %347 = getelementptr inbounds nuw float, ptr %18, i64 %346, !dbg !91
  %348 = load float, ptr %347, align 4, !dbg !91
  %349 = insertelement <8 x float> poison, float %348, i32 0, !dbg !91
  %350 = shufflevector <8 x float> %349, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %351 = extractvalue [8 x <8 x float>] %60, 4, !dbg !91
  %352 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %350, <8 x float> %54, <8 x float> %351), !dbg !91
  %353 = add i64 %308, 5, !dbg !91
  %354 = mul nuw nsw i64 %353, 9, !dbg !91
  %355 = add nuw nsw i64 %354, 8, !dbg !91
  %356 = getelementptr inbounds nuw float, ptr %18, i64 %355, !dbg !91
  %357 = load float, ptr %356, align 4, !dbg !91
  %358 = insertelement <8 x float> poison, float %357, i32 0, !dbg !91
  %359 = shufflevector <8 x float> %358, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %360 = extractvalue [8 x <8 x float>] %60, 5, !dbg !91
  %361 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %359, <8 x float> %54, <8 x float> %360), !dbg !91
  %362 = add i64 %308, 6, !dbg !91
  %363 = mul nuw nsw i64 %362, 9, !dbg !91
  %364 = add nuw nsw i64 %363, 8, !dbg !91
  %365 = getelementptr inbounds nuw float, ptr %18, i64 %364, !dbg !91
  %366 = load float, ptr %365, align 4, !dbg !91
  %367 = insertelement <8 x float> poison, float %366, i32 0, !dbg !91
  %368 = shufflevector <8 x float> %367, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %369 = extractvalue [8 x <8 x float>] %60, 6, !dbg !91
  %370 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %368, <8 x float> %54, <8 x float> %369), !dbg !91
  %371 = add i64 %308, 7, !dbg !91
  %372 = mul nuw nsw i64 %371, 9, !dbg !91
  %373 = add nuw nsw i64 %372, 8, !dbg !91
  %374 = getelementptr inbounds nuw float, ptr %18, i64 %373, !dbg !91
  %375 = load float, ptr %374, align 4, !dbg !91
  %376 = insertelement <8 x float> poison, float %375, i32 0, !dbg !91
  %377 = shufflevector <8 x float> %376, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !91
  %378 = extractvalue [8 x <8 x float>] %60, 7, !dbg !91
  %379 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %377, <8 x float> %54, <8 x float> %378), !dbg !91
  %380 = mul i64 %308, 64, !dbg !90
  %381 = add i64 %380, %38, !dbg !90
  %382 = getelementptr float, ptr %22, i64 %381, !dbg !90
  store <8 x float> %316, ptr %382, align 4, !dbg !90
  %383 = mul i64 %317, 64, !dbg !90
  %384 = add i64 %383, %38, !dbg !90
  %385 = getelementptr float, ptr %22, i64 %384, !dbg !90
  store <8 x float> %325, ptr %385, align 4, !dbg !90
  %386 = mul i64 %326, 64, !dbg !90
  %387 = add i64 %386, %38, !dbg !90
  %388 = getelementptr float, ptr %22, i64 %387, !dbg !90
  store <8 x float> %334, ptr %388, align 4, !dbg !90
  %389 = mul i64 %335, 64, !dbg !90
  %390 = add i64 %389, %38, !dbg !90
  %391 = getelementptr float, ptr %22, i64 %390, !dbg !90
  store <8 x float> %343, ptr %391, align 4, !dbg !90
  %392 = mul i64 %344, 64, !dbg !90
  %393 = add i64 %392, %38, !dbg !90
  %394 = getelementptr float, ptr %22, i64 %393, !dbg !90
  store <8 x float> %352, ptr %394, align 4, !dbg !90
  %395 = mul i64 %353, 64, !dbg !90
  %396 = add i64 %395, %38, !dbg !90
  %397 = getelementptr float, ptr %22, i64 %396, !dbg !90
  store <8 x float> %361, ptr %397, align 4, !dbg !90
  %398 = mul i64 %362, 64, !dbg !90
  %399 = add i64 %398, %38, !dbg !90
  %400 = getelementptr float, ptr %22, i64 %399, !dbg !90
  store <8 x float> %370, ptr %400, align 4, !dbg !90
  %401 = mul i64 %371, 64, !dbg !90
  %402 = add i64 %401, %38, !dbg !90
  %403 = getelementptr float, ptr %22, i64 %402, !dbg !90
  store <8 x float> %379, ptr %403, align 4, !dbg !90
  %404 = add i64 %56, 8, !dbg !90
  br label %55, !dbg !90

405:                                              ; preds = %509, %55, %3
  %406 = phi i64 [ %510, %509 ], [ %49, %55 ], [ %49, %3 ], !dbg !90
  %407 = icmp slt i64 %406, %42, !dbg !90
  br i1 %407, label %408, label %511, !dbg !90

408:                                              ; preds = %405
  %409 = sub i64 %42, %406, !dbg !90
  br label %410, !dbg !90

410:                                              ; preds = %507, %408
  %411 = phi i64 [ %508, %507 ], [ 0, %408 ], !dbg !90
  %412 = icmp slt i64 %411, %409, !dbg !90
  br i1 %412, label %413, label %509, !dbg !90

413:                                              ; preds = %410
  %414 = mul nsw i64 %411, -1, !dbg !90
  %415 = sub i64 %414, %406, !dbg !90
  %416 = add i64 %415, %42, !dbg !90
  %417 = icmp slt i64 %416, 8, !dbg !90
  %418 = select i1 %417, i64 %416, i64 8, !dbg !90
  br label %419, !dbg !92

419:                                              ; preds = %434, %413
  %420 = phi i64 [ %435, %434 ], [ 0, %413 ], !dbg !92
  %421 = icmp slt i64 %420, %418, !dbg !92
  br i1 %421, label %422, label %436, !dbg !92

422:                                              ; preds = %425, %419
  %423 = phi i64 [ %433, %425 ], [ 0, %419 ], !dbg !92
  %424 = icmp slt i64 %423, 8, !dbg !92
  br i1 %424, label %425, label %434, !dbg !92

425:                                              ; preds = %422
  %426 = add i64 %37, %406, !dbg !92
  %427 = add i64 %426, %411, !dbg !92
  %428 = add i64 %427, %420, !dbg !92
  %429 = add i64 %38, %423, !dbg !92
  %430 = mul nuw nsw i64 %428, 64, !dbg !92
  %431 = add nuw nsw i64 %430, %429, !dbg !92
  %432 = getelementptr inbounds nuw float, ptr %22, i64 %431, !dbg !92
  store float 0.000000e+00, ptr %432, align 4, !dbg !92
  %433 = add i64 %423, 1, !dbg !92
  br label %422, !dbg !92

434:                                              ; preds = %422
  %435 = add i64 %420, 1, !dbg !92
  br label %419, !dbg !92

436:                                              ; preds = %419
  %437 = add i64 %411, %406, !dbg !90
  %438 = add i64 %437, %37, !dbg !90
  br label %439, !dbg !90

439:                                              ; preds = %477, %436
  %440 = phi i64 [ %478, %477 ], [ 0, %436 ], !dbg !90
  %441 = icmp slt i64 %440, 8, !dbg !90
  br i1 %441, label %442, label %479, !dbg !90

442:                                              ; preds = %475, %439
  %443 = phi i64 [ %476, %475 ], [ 0, %439 ], !dbg !90
  %444 = icmp slt i64 %443, %418, !dbg !90
  br i1 %444, label %445, label %477, !dbg !90

445:                                              ; preds = %473, %442
  %446 = phi i64 [ %474, %473 ], [ 0, %442 ], !dbg !90
  %447 = icmp slt i64 %446, 8, !dbg !90
  br i1 %447, label %448, label %475, !dbg !90

448:                                              ; preds = %451, %445
  %449 = phi i64 [ %472, %451 ], [ 0, %445 ], !dbg !90
  %450 = icmp slt i64 %449, 4, !dbg !90
  br i1 %450, label %451, label %473, !dbg !90

451:                                              ; preds = %448
  %452 = add i64 %438, %443, !dbg !90
  %453 = add i64 %440, %449, !dbg !90
  %454 = mul nuw nsw i64 %452, 9, !dbg !90
  %455 = add nuw nsw i64 %454, %453, !dbg !90
  %456 = getelementptr inbounds nuw float, ptr %18, i64 %455, !dbg !90
  %457 = load float, ptr %456, align 4, !dbg !90
  %458 = add i64 %38, %446, !dbg !90
  %459 = mul nuw nsw i64 %453, 64, !dbg !90
  %460 = add nuw nsw i64 %459, %458, !dbg !90
  %461 = getelementptr inbounds nuw float, ptr %15, i64 %460, !dbg !90
  %462 = load float, ptr %461, align 4, !dbg !90
  %463 = add i64 %37, %406, !dbg !90
  %464 = add i64 %463, %411, !dbg !90
  %465 = add i64 %464, %443, !dbg !90
  %466 = mul nuw nsw i64 %465, 64, !dbg !90
  %467 = add nuw nsw i64 %466, %458, !dbg !90
  %468 = getelementptr inbounds nuw float, ptr %22, i64 %467, !dbg !90
  %469 = load float, ptr %468, align 4, !dbg !90
  %470 = fmul contract float %457, %462, !dbg !91
  %471 = fadd contract float %469, %470, !dbg !91
  store float %471, ptr %468, align 4, !dbg !90
  %472 = add i64 %449, 1, !dbg !90
  br label %448, !dbg !90

473:                                              ; preds = %448
  %474 = add i64 %446, 1, !dbg !90
  br label %445, !dbg !90

475:                                              ; preds = %445
  %476 = add i64 %443, 1, !dbg !90
  br label %442, !dbg !90

477:                                              ; preds = %442
  %478 = add i64 %440, 4, !dbg !90
  br label %439, !dbg !90

479:                                              ; preds = %505, %439
  %480 = phi i64 [ %506, %505 ], [ 0, %439 ], !dbg !90
  %481 = icmp slt i64 %480, %418, !dbg !90
  br i1 %481, label %482, label %507, !dbg !90

482:                                              ; preds = %485, %479
  %483 = phi i64 [ %504, %485 ], [ 0, %479 ], !dbg !90
  %484 = icmp slt i64 %483, 8, !dbg !90
  br i1 %484, label %485, label %505, !dbg !90

485:                                              ; preds = %482
  %486 = add i64 %438, %480, !dbg !90
  %487 = mul nuw nsw i64 %486, 9, !dbg !90
  %488 = add nuw nsw i64 %487, 8, !dbg !90
  %489 = getelementptr inbounds nuw float, ptr %18, i64 %488, !dbg !90
  %490 = load float, ptr %489, align 4, !dbg !90
  %491 = add i64 %38, %483, !dbg !90
  %492 = add nuw nsw i64 512, %491, !dbg !90
  %493 = getelementptr inbounds nuw float, ptr %15, i64 %492, !dbg !90
  %494 = load float, ptr %493, align 4, !dbg !90
  %495 = add i64 %37, %406, !dbg !90
  %496 = add i64 %495, %411, !dbg !90
  %497 = add i64 %496, %480, !dbg !90
  %498 = mul nuw nsw i64 %497, 64, !dbg !90
  %499 = add nuw nsw i64 %498, %491, !dbg !90
  %500 = getelementptr inbounds nuw float, ptr %22, i64 %499, !dbg !90
  %501 = load float, ptr %500, align 4, !dbg !90
  %502 = fmul contract float %490, %494, !dbg !91
  %503 = fadd contract float %501, %502, !dbg !91
  store float %503, ptr %500, align 4, !dbg !90
  %504 = add i64 %483, 1, !dbg !90
  br label %482, !dbg !90

505:                                              ; preds = %482
  %506 = add i64 %480, 1, !dbg !90
  br label %479, !dbg !90

507:                                              ; preds = %479
  %508 = add i64 %411, 8, !dbg !90
  br label %410, !dbg !90

509:                                              ; preds = %410
  %510 = add i64 %406, 64, !dbg !90
  br label %405, !dbg !90

511:                                              ; preds = %405
  ret i32 0, !dbg !93
}

define internal i32 @infer_dispatch_1_matmul_Dx2x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !94 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !95
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !95
  %6 = load i32, ptr %5, align 4, !dbg !95
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !96
  %8 = load i32, ptr %7, align 4, !dbg !96
  %9 = zext i32 %6 to i64, !dbg !97
  %10 = zext i32 %8 to i64, !dbg !98
  %11 = shl i64 %10, 32, !dbg !99
  %12 = or i64 %9, %11, !dbg !100
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !101
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !101
  %15 = load ptr, ptr %14, align 8, !dbg !101
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !101
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !102
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !102
  %18 = load ptr, ptr %17, align 8, !dbg !102
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !102
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !103
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !103
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !103
  %22 = load ptr, ptr %21, align 8, !dbg !103
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !103
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !104
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !104
  %25 = zext i32 %24 to i64, !dbg !104
  %26 = mul nsw i64 %25, 64, !dbg !104
  %27 = mul nsw i64 %25, -64, !dbg !104
  %28 = add i64 %27, %12, !dbg !104
  %29 = icmp slt i64 %28, 64, !dbg !104
  %30 = select i1 %29, i64 %28, i64 64, !dbg !104
  %31 = icmp slt i64 %30, 0, !dbg !104
  %32 = sub i64 -1, %30, !dbg !104
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !104
  %34 = sdiv i64 %33, 64, !dbg !104
  %35 = sub i64 -1, %34, !dbg !104
  %36 = select i1 %31, i64 %35, i64 %34, !dbg !104
  %37 = mul nsw i64 %36, 64, !dbg !104
  %38 = icmp sgt i64 %37, 0, !dbg !104
  br i1 %38, label %39, label %340, !dbg !104

39:                                               ; preds = %291, %3
  %40 = phi i64 [ %339, %291 ], [ 0, %3 ], !dbg !104
  %41 = icmp slt i64 %40, 64, !dbg !104
  br i1 %41, label %42, label %340, !dbg !104

42:                                               ; preds = %46, %39
  %43 = phi i64 [ %290, %46 ], [ 0, %39 ], !dbg !104
  %44 = phi [8 x <2 x float>] [ %289, %46 ], [ zeroinitializer, %39 ], !dbg !104
  %45 = icmp slt i64 %43, 64, !dbg !104
  br i1 %45, label %46, label %291, !dbg !104

46:                                               ; preds = %42
  %47 = mul i64 %43, 2, !dbg !104
  %48 = add i64 %47, 0, !dbg !104
  %49 = getelementptr float, ptr %15, i64 %48, !dbg !104
  %50 = load <2 x float>, ptr %49, align 4, !dbg !104
  %51 = add i64 %43, 1, !dbg !104
  %52 = mul i64 %51, 2, !dbg !104
  %53 = add i64 %52, 0, !dbg !104
  %54 = getelementptr float, ptr %15, i64 %53, !dbg !104
  %55 = load <2 x float>, ptr %54, align 4, !dbg !104
  %56 = add i64 %43, 2, !dbg !104
  %57 = mul i64 %56, 2, !dbg !104
  %58 = add i64 %57, 0, !dbg !104
  %59 = getelementptr float, ptr %15, i64 %58, !dbg !104
  %60 = load <2 x float>, ptr %59, align 4, !dbg !104
  %61 = add i64 %43, 3, !dbg !104
  %62 = mul i64 %61, 2, !dbg !104
  %63 = add i64 %62, 0, !dbg !104
  %64 = getelementptr float, ptr %15, i64 %63, !dbg !104
  %65 = load <2 x float>, ptr %64, align 4, !dbg !104
  %66 = add i64 %40, %26, !dbg !105
  %67 = mul nuw nsw i64 %66, 64, !dbg !105
  %68 = add nuw nsw i64 %67, %43, !dbg !105
  %69 = getelementptr inbounds nuw float, ptr %18, i64 %68, !dbg !105
  %70 = load float, ptr %69, align 4, !dbg !105
  %71 = insertelement <2 x float> poison, float %70, i32 0, !dbg !105
  %72 = shufflevector <2 x float> %71, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %73 = extractvalue [8 x <2 x float>] %44, 0, !dbg !105
  %74 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %72, <2 x float> %50, <2 x float> %73), !dbg !105
  %75 = add i64 %66, 1, !dbg !105
  %76 = mul nuw nsw i64 %75, 64, !dbg !105
  %77 = add nuw nsw i64 %76, %43, !dbg !105
  %78 = getelementptr inbounds nuw float, ptr %18, i64 %77, !dbg !105
  %79 = load float, ptr %78, align 4, !dbg !105
  %80 = insertelement <2 x float> poison, float %79, i32 0, !dbg !105
  %81 = shufflevector <2 x float> %80, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %82 = extractvalue [8 x <2 x float>] %44, 1, !dbg !105
  %83 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %81, <2 x float> %50, <2 x float> %82), !dbg !105
  %84 = add i64 %66, 2, !dbg !105
  %85 = mul nuw nsw i64 %84, 64, !dbg !105
  %86 = add nuw nsw i64 %85, %43, !dbg !105
  %87 = getelementptr inbounds nuw float, ptr %18, i64 %86, !dbg !105
  %88 = load float, ptr %87, align 4, !dbg !105
  %89 = insertelement <2 x float> poison, float %88, i32 0, !dbg !105
  %90 = shufflevector <2 x float> %89, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %91 = extractvalue [8 x <2 x float>] %44, 2, !dbg !105
  %92 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %90, <2 x float> %50, <2 x float> %91), !dbg !105
  %93 = add i64 %66, 3, !dbg !105
  %94 = mul nuw nsw i64 %93, 64, !dbg !105
  %95 = add nuw nsw i64 %94, %43, !dbg !105
  %96 = getelementptr inbounds nuw float, ptr %18, i64 %95, !dbg !105
  %97 = load float, ptr %96, align 4, !dbg !105
  %98 = insertelement <2 x float> poison, float %97, i32 0, !dbg !105
  %99 = shufflevector <2 x float> %98, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %100 = extractvalue [8 x <2 x float>] %44, 3, !dbg !105
  %101 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %99, <2 x float> %50, <2 x float> %100), !dbg !105
  %102 = add i64 %66, 4, !dbg !105
  %103 = mul nuw nsw i64 %102, 64, !dbg !105
  %104 = add nuw nsw i64 %103, %43, !dbg !105
  %105 = getelementptr inbounds nuw float, ptr %18, i64 %104, !dbg !105
  %106 = load float, ptr %105, align 4, !dbg !105
  %107 = insertelement <2 x float> poison, float %106, i32 0, !dbg !105
  %108 = shufflevector <2 x float> %107, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %109 = extractvalue [8 x <2 x float>] %44, 4, !dbg !105
  %110 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %108, <2 x float> %50, <2 x float> %109), !dbg !105
  %111 = add i64 %66, 5, !dbg !105
  %112 = mul nuw nsw i64 %111, 64, !dbg !105
  %113 = add nuw nsw i64 %112, %43, !dbg !105
  %114 = getelementptr inbounds nuw float, ptr %18, i64 %113, !dbg !105
  %115 = load float, ptr %114, align 4, !dbg !105
  %116 = insertelement <2 x float> poison, float %115, i32 0, !dbg !105
  %117 = shufflevector <2 x float> %116, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %118 = extractvalue [8 x <2 x float>] %44, 5, !dbg !105
  %119 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %117, <2 x float> %50, <2 x float> %118), !dbg !105
  %120 = add i64 %66, 6, !dbg !105
  %121 = mul nuw nsw i64 %120, 64, !dbg !105
  %122 = add nuw nsw i64 %121, %43, !dbg !105
  %123 = getelementptr inbounds nuw float, ptr %18, i64 %122, !dbg !105
  %124 = load float, ptr %123, align 4, !dbg !105
  %125 = insertelement <2 x float> poison, float %124, i32 0, !dbg !105
  %126 = shufflevector <2 x float> %125, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %127 = extractvalue [8 x <2 x float>] %44, 6, !dbg !105
  %128 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %126, <2 x float> %50, <2 x float> %127), !dbg !105
  %129 = add i64 %66, 7, !dbg !105
  %130 = mul nuw nsw i64 %129, 64, !dbg !105
  %131 = add nuw nsw i64 %130, %43, !dbg !105
  %132 = getelementptr inbounds nuw float, ptr %18, i64 %131, !dbg !105
  %133 = load float, ptr %132, align 4, !dbg !105
  %134 = insertelement <2 x float> poison, float %133, i32 0, !dbg !105
  %135 = shufflevector <2 x float> %134, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %136 = extractvalue [8 x <2 x float>] %44, 7, !dbg !105
  %137 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %135, <2 x float> %50, <2 x float> %136), !dbg !105
  %138 = add nuw nsw i64 %67, %51, !dbg !105
  %139 = getelementptr inbounds nuw float, ptr %18, i64 %138, !dbg !105
  %140 = load float, ptr %139, align 4, !dbg !105
  %141 = insertelement <2 x float> poison, float %140, i32 0, !dbg !105
  %142 = shufflevector <2 x float> %141, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %143 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %142, <2 x float> %55, <2 x float> %74), !dbg !105
  %144 = add nuw nsw i64 %76, %51, !dbg !105
  %145 = getelementptr inbounds nuw float, ptr %18, i64 %144, !dbg !105
  %146 = load float, ptr %145, align 4, !dbg !105
  %147 = insertelement <2 x float> poison, float %146, i32 0, !dbg !105
  %148 = shufflevector <2 x float> %147, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %149 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %148, <2 x float> %55, <2 x float> %83), !dbg !105
  %150 = add nuw nsw i64 %85, %51, !dbg !105
  %151 = getelementptr inbounds nuw float, ptr %18, i64 %150, !dbg !105
  %152 = load float, ptr %151, align 4, !dbg !105
  %153 = insertelement <2 x float> poison, float %152, i32 0, !dbg !105
  %154 = shufflevector <2 x float> %153, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %155 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %154, <2 x float> %55, <2 x float> %92), !dbg !105
  %156 = add nuw nsw i64 %94, %51, !dbg !105
  %157 = getelementptr inbounds nuw float, ptr %18, i64 %156, !dbg !105
  %158 = load float, ptr %157, align 4, !dbg !105
  %159 = insertelement <2 x float> poison, float %158, i32 0, !dbg !105
  %160 = shufflevector <2 x float> %159, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %161 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %160, <2 x float> %55, <2 x float> %101), !dbg !105
  %162 = add nuw nsw i64 %103, %51, !dbg !105
  %163 = getelementptr inbounds nuw float, ptr %18, i64 %162, !dbg !105
  %164 = load float, ptr %163, align 4, !dbg !105
  %165 = insertelement <2 x float> poison, float %164, i32 0, !dbg !105
  %166 = shufflevector <2 x float> %165, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %167 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %166, <2 x float> %55, <2 x float> %110), !dbg !105
  %168 = add nuw nsw i64 %112, %51, !dbg !105
  %169 = getelementptr inbounds nuw float, ptr %18, i64 %168, !dbg !105
  %170 = load float, ptr %169, align 4, !dbg !105
  %171 = insertelement <2 x float> poison, float %170, i32 0, !dbg !105
  %172 = shufflevector <2 x float> %171, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %173 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %172, <2 x float> %55, <2 x float> %119), !dbg !105
  %174 = add nuw nsw i64 %121, %51, !dbg !105
  %175 = getelementptr inbounds nuw float, ptr %18, i64 %174, !dbg !105
  %176 = load float, ptr %175, align 4, !dbg !105
  %177 = insertelement <2 x float> poison, float %176, i32 0, !dbg !105
  %178 = shufflevector <2 x float> %177, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %179 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %178, <2 x float> %55, <2 x float> %128), !dbg !105
  %180 = add nuw nsw i64 %130, %51, !dbg !105
  %181 = getelementptr inbounds nuw float, ptr %18, i64 %180, !dbg !105
  %182 = load float, ptr %181, align 4, !dbg !105
  %183 = insertelement <2 x float> poison, float %182, i32 0, !dbg !105
  %184 = shufflevector <2 x float> %183, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %185 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %184, <2 x float> %55, <2 x float> %137), !dbg !105
  %186 = add nuw nsw i64 %67, %56, !dbg !105
  %187 = getelementptr inbounds nuw float, ptr %18, i64 %186, !dbg !105
  %188 = load float, ptr %187, align 4, !dbg !105
  %189 = insertelement <2 x float> poison, float %188, i32 0, !dbg !105
  %190 = shufflevector <2 x float> %189, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %191 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %190, <2 x float> %60, <2 x float> %143), !dbg !105
  %192 = add nuw nsw i64 %76, %56, !dbg !105
  %193 = getelementptr inbounds nuw float, ptr %18, i64 %192, !dbg !105
  %194 = load float, ptr %193, align 4, !dbg !105
  %195 = insertelement <2 x float> poison, float %194, i32 0, !dbg !105
  %196 = shufflevector <2 x float> %195, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %197 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %196, <2 x float> %60, <2 x float> %149), !dbg !105
  %198 = add nuw nsw i64 %85, %56, !dbg !105
  %199 = getelementptr inbounds nuw float, ptr %18, i64 %198, !dbg !105
  %200 = load float, ptr %199, align 4, !dbg !105
  %201 = insertelement <2 x float> poison, float %200, i32 0, !dbg !105
  %202 = shufflevector <2 x float> %201, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %203 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %202, <2 x float> %60, <2 x float> %155), !dbg !105
  %204 = add nuw nsw i64 %94, %56, !dbg !105
  %205 = getelementptr inbounds nuw float, ptr %18, i64 %204, !dbg !105
  %206 = load float, ptr %205, align 4, !dbg !105
  %207 = insertelement <2 x float> poison, float %206, i32 0, !dbg !105
  %208 = shufflevector <2 x float> %207, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %209 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %208, <2 x float> %60, <2 x float> %161), !dbg !105
  %210 = add nuw nsw i64 %103, %56, !dbg !105
  %211 = getelementptr inbounds nuw float, ptr %18, i64 %210, !dbg !105
  %212 = load float, ptr %211, align 4, !dbg !105
  %213 = insertelement <2 x float> poison, float %212, i32 0, !dbg !105
  %214 = shufflevector <2 x float> %213, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %215 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %214, <2 x float> %60, <2 x float> %167), !dbg !105
  %216 = add nuw nsw i64 %112, %56, !dbg !105
  %217 = getelementptr inbounds nuw float, ptr %18, i64 %216, !dbg !105
  %218 = load float, ptr %217, align 4, !dbg !105
  %219 = insertelement <2 x float> poison, float %218, i32 0, !dbg !105
  %220 = shufflevector <2 x float> %219, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %221 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %220, <2 x float> %60, <2 x float> %173), !dbg !105
  %222 = add nuw nsw i64 %121, %56, !dbg !105
  %223 = getelementptr inbounds nuw float, ptr %18, i64 %222, !dbg !105
  %224 = load float, ptr %223, align 4, !dbg !105
  %225 = insertelement <2 x float> poison, float %224, i32 0, !dbg !105
  %226 = shufflevector <2 x float> %225, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %227 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %226, <2 x float> %60, <2 x float> %179), !dbg !105
  %228 = add nuw nsw i64 %130, %56, !dbg !105
  %229 = getelementptr inbounds nuw float, ptr %18, i64 %228, !dbg !105
  %230 = load float, ptr %229, align 4, !dbg !105
  %231 = insertelement <2 x float> poison, float %230, i32 0, !dbg !105
  %232 = shufflevector <2 x float> %231, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %233 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %232, <2 x float> %60, <2 x float> %185), !dbg !105
  %234 = add nuw nsw i64 %67, %61, !dbg !105
  %235 = getelementptr inbounds nuw float, ptr %18, i64 %234, !dbg !105
  %236 = load float, ptr %235, align 4, !dbg !105
  %237 = insertelement <2 x float> poison, float %236, i32 0, !dbg !105
  %238 = shufflevector <2 x float> %237, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %239 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %238, <2 x float> %65, <2 x float> %191), !dbg !105
  %240 = add nuw nsw i64 %76, %61, !dbg !105
  %241 = getelementptr inbounds nuw float, ptr %18, i64 %240, !dbg !105
  %242 = load float, ptr %241, align 4, !dbg !105
  %243 = insertelement <2 x float> poison, float %242, i32 0, !dbg !105
  %244 = shufflevector <2 x float> %243, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %245 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %244, <2 x float> %65, <2 x float> %197), !dbg !105
  %246 = add nuw nsw i64 %85, %61, !dbg !105
  %247 = getelementptr inbounds nuw float, ptr %18, i64 %246, !dbg !105
  %248 = load float, ptr %247, align 4, !dbg !105
  %249 = insertelement <2 x float> poison, float %248, i32 0, !dbg !105
  %250 = shufflevector <2 x float> %249, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %251 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %250, <2 x float> %65, <2 x float> %203), !dbg !105
  %252 = add nuw nsw i64 %94, %61, !dbg !105
  %253 = getelementptr inbounds nuw float, ptr %18, i64 %252, !dbg !105
  %254 = load float, ptr %253, align 4, !dbg !105
  %255 = insertelement <2 x float> poison, float %254, i32 0, !dbg !105
  %256 = shufflevector <2 x float> %255, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %257 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %256, <2 x float> %65, <2 x float> %209), !dbg !105
  %258 = add nuw nsw i64 %103, %61, !dbg !105
  %259 = getelementptr inbounds nuw float, ptr %18, i64 %258, !dbg !105
  %260 = load float, ptr %259, align 4, !dbg !105
  %261 = insertelement <2 x float> poison, float %260, i32 0, !dbg !105
  %262 = shufflevector <2 x float> %261, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %263 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %262, <2 x float> %65, <2 x float> %215), !dbg !105
  %264 = add nuw nsw i64 %112, %61, !dbg !105
  %265 = getelementptr inbounds nuw float, ptr %18, i64 %264, !dbg !105
  %266 = load float, ptr %265, align 4, !dbg !105
  %267 = insertelement <2 x float> poison, float %266, i32 0, !dbg !105
  %268 = shufflevector <2 x float> %267, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %269 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %268, <2 x float> %65, <2 x float> %221), !dbg !105
  %270 = add nuw nsw i64 %121, %61, !dbg !105
  %271 = getelementptr inbounds nuw float, ptr %18, i64 %270, !dbg !105
  %272 = load float, ptr %271, align 4, !dbg !105
  %273 = insertelement <2 x float> poison, float %272, i32 0, !dbg !105
  %274 = shufflevector <2 x float> %273, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %275 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %274, <2 x float> %65, <2 x float> %227), !dbg !105
  %276 = add nuw nsw i64 %130, %61, !dbg !105
  %277 = getelementptr inbounds nuw float, ptr %18, i64 %276, !dbg !105
  %278 = load float, ptr %277, align 4, !dbg !105
  %279 = insertelement <2 x float> poison, float %278, i32 0, !dbg !105
  %280 = shufflevector <2 x float> %279, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !105
  %281 = call <2 x float> @llvm.fmuladd.v2f32(<2 x float> %280, <2 x float> %65, <2 x float> %233), !dbg !105
  %282 = insertvalue [8 x <2 x float>] poison, <2 x float> %239, 0, !dbg !105
  %283 = insertvalue [8 x <2 x float>] %282, <2 x float> %245, 1, !dbg !105
  %284 = insertvalue [8 x <2 x float>] %283, <2 x float> %251, 2, !dbg !105
  %285 = insertvalue [8 x <2 x float>] %284, <2 x float> %257, 3, !dbg !105
  %286 = insertvalue [8 x <2 x float>] %285, <2 x float> %263, 4, !dbg !105
  %287 = insertvalue [8 x <2 x float>] %286, <2 x float> %269, 5, !dbg !105
  %288 = insertvalue [8 x <2 x float>] %287, <2 x float> %275, 6, !dbg !105
  %289 = insertvalue [8 x <2 x float>] %288, <2 x float> %281, 7, !dbg !105
  %290 = add i64 %43, 4, !dbg !104
  br label %42, !dbg !104

291:                                              ; preds = %42
  %292 = extractvalue [8 x <2 x float>] %44, 0, !dbg !104
  %293 = add i64 %26, %40, !dbg !104
  %294 = mul i64 %293, 2, !dbg !104
  %295 = add i64 %294, 0, !dbg !104
  %296 = getelementptr float, ptr %22, i64 %295, !dbg !104
  store <2 x float> %292, ptr %296, align 4, !dbg !104
  %297 = add i64 %40, 1, !dbg !104
  %298 = extractvalue [8 x <2 x float>] %44, 1, !dbg !104
  %299 = add i64 %26, %297, !dbg !104
  %300 = mul i64 %299, 2, !dbg !104
  %301 = add i64 %300, 0, !dbg !104
  %302 = getelementptr float, ptr %22, i64 %301, !dbg !104
  store <2 x float> %298, ptr %302, align 4, !dbg !104
  %303 = add i64 %40, 2, !dbg !104
  %304 = extractvalue [8 x <2 x float>] %44, 2, !dbg !104
  %305 = add i64 %26, %303, !dbg !104
  %306 = mul i64 %305, 2, !dbg !104
  %307 = add i64 %306, 0, !dbg !104
  %308 = getelementptr float, ptr %22, i64 %307, !dbg !104
  store <2 x float> %304, ptr %308, align 4, !dbg !104
  %309 = add i64 %40, 3, !dbg !104
  %310 = extractvalue [8 x <2 x float>] %44, 3, !dbg !104
  %311 = add i64 %26, %309, !dbg !104
  %312 = mul i64 %311, 2, !dbg !104
  %313 = add i64 %312, 0, !dbg !104
  %314 = getelementptr float, ptr %22, i64 %313, !dbg !104
  store <2 x float> %310, ptr %314, align 4, !dbg !104
  %315 = add i64 %40, 4, !dbg !104
  %316 = extractvalue [8 x <2 x float>] %44, 4, !dbg !104
  %317 = add i64 %26, %315, !dbg !104
  %318 = mul i64 %317, 2, !dbg !104
  %319 = add i64 %318, 0, !dbg !104
  %320 = getelementptr float, ptr %22, i64 %319, !dbg !104
  store <2 x float> %316, ptr %320, align 4, !dbg !104
  %321 = add i64 %40, 5, !dbg !104
  %322 = extractvalue [8 x <2 x float>] %44, 5, !dbg !104
  %323 = add i64 %26, %321, !dbg !104
  %324 = mul i64 %323, 2, !dbg !104
  %325 = add i64 %324, 0, !dbg !104
  %326 = getelementptr float, ptr %22, i64 %325, !dbg !104
  store <2 x float> %322, ptr %326, align 4, !dbg !104
  %327 = add i64 %40, 6, !dbg !104
  %328 = extractvalue [8 x <2 x float>] %44, 6, !dbg !104
  %329 = add i64 %26, %327, !dbg !104
  %330 = mul i64 %329, 2, !dbg !104
  %331 = add i64 %330, 0, !dbg !104
  %332 = getelementptr float, ptr %22, i64 %331, !dbg !104
  store <2 x float> %328, ptr %332, align 4, !dbg !104
  %333 = add i64 %40, 7, !dbg !104
  %334 = extractvalue [8 x <2 x float>] %44, 7, !dbg !104
  %335 = add i64 %26, %333, !dbg !104
  %336 = mul i64 %335, 2, !dbg !104
  %337 = add i64 %336, 0, !dbg !104
  %338 = getelementptr float, ptr %22, i64 %337, !dbg !104
  store <2 x float> %334, ptr %338, align 4, !dbg !104
  %339 = add i64 %40, 8, !dbg !104
  br label %39, !dbg !104

340:                                              ; preds = %414, %39, %3
  %341 = phi i64 [ %415, %414 ], [ %37, %39 ], [ %37, %3 ], !dbg !104
  %342 = icmp slt i64 %341, %30, !dbg !104
  br i1 %342, label %343, label %416, !dbg !104

343:                                              ; preds = %340
  %344 = sub i64 %30, %341, !dbg !104
  br label %345, !dbg !104

345:                                              ; preds = %412, %343
  %346 = phi i64 [ %413, %412 ], [ 0, %343 ], !dbg !104
  %347 = icmp slt i64 %346, %344, !dbg !104
  br i1 %347, label %348, label %414, !dbg !104

348:                                              ; preds = %345
  %349 = mul nsw i64 %346, -1, !dbg !104
  %350 = sub i64 %349, %341, !dbg !104
  %351 = add i64 %350, %30, !dbg !104
  %352 = icmp slt i64 %351, 8, !dbg !104
  %353 = select i1 %352, i64 %351, i64 8, !dbg !104
  br label %354, !dbg !106

354:                                              ; preds = %368, %348
  %355 = phi i64 [ %369, %368 ], [ 0, %348 ], !dbg !106
  %356 = icmp slt i64 %355, %353, !dbg !106
  br i1 %356, label %357, label %370, !dbg !106

357:                                              ; preds = %360, %354
  %358 = phi i64 [ %367, %360 ], [ 0, %354 ], !dbg !106
  %359 = icmp slt i64 %358, 2, !dbg !106
  br i1 %359, label %360, label %368, !dbg !106

360:                                              ; preds = %357
  %361 = add i64 %26, %341, !dbg !106
  %362 = add i64 %361, %346, !dbg !106
  %363 = add i64 %362, %355, !dbg !106
  %364 = mul nuw nsw i64 %363, 2, !dbg !106
  %365 = add nuw nsw i64 %364, %358, !dbg !106
  %366 = getelementptr inbounds nuw float, ptr %22, i64 %365, !dbg !106
  store float 0.000000e+00, ptr %366, align 4, !dbg !106
  %367 = add i64 %358, 1, !dbg !106
  br label %357, !dbg !106

368:                                              ; preds = %357
  %369 = add i64 %355, 1, !dbg !106
  br label %354, !dbg !106

370:                                              ; preds = %354
  %371 = add i64 %346, %341, !dbg !104
  %372 = add i64 %371, %26, !dbg !104
  br label %373, !dbg !104

373:                                              ; preds = %410, %370
  %374 = phi i64 [ %411, %410 ], [ 0, %370 ], !dbg !104
  %375 = icmp slt i64 %374, 64, !dbg !104
  br i1 %375, label %376, label %412, !dbg !104

376:                                              ; preds = %408, %373
  %377 = phi i64 [ %409, %408 ], [ 0, %373 ], !dbg !104
  %378 = icmp slt i64 %377, %353, !dbg !104
  br i1 %378, label %379, label %410, !dbg !104

379:                                              ; preds = %406, %376
  %380 = phi i64 [ %407, %406 ], [ 0, %376 ], !dbg !104
  %381 = icmp slt i64 %380, 2, !dbg !104
  br i1 %381, label %382, label %408, !dbg !104

382:                                              ; preds = %385, %379
  %383 = phi i64 [ %405, %385 ], [ 0, %379 ], !dbg !104
  %384 = icmp slt i64 %383, 4, !dbg !104
  br i1 %384, label %385, label %406, !dbg !104

385:                                              ; preds = %382
  %386 = add i64 %372, %377, !dbg !104
  %387 = add i64 %374, %383, !dbg !104
  %388 = mul nuw nsw i64 %386, 64, !dbg !104
  %389 = add nuw nsw i64 %388, %387, !dbg !104
  %390 = getelementptr inbounds nuw float, ptr %18, i64 %389, !dbg !104
  %391 = load float, ptr %390, align 4, !dbg !104
  %392 = mul nuw nsw i64 %387, 2, !dbg !104
  %393 = add nuw nsw i64 %392, %380, !dbg !104
  %394 = getelementptr inbounds nuw float, ptr %15, i64 %393, !dbg !104
  %395 = load float, ptr %394, align 4, !dbg !104
  %396 = add i64 %26, %341, !dbg !104
  %397 = add i64 %396, %346, !dbg !104
  %398 = add i64 %397, %377, !dbg !104
  %399 = mul nuw nsw i64 %398, 2, !dbg !104
  %400 = add nuw nsw i64 %399, %380, !dbg !104
  %401 = getelementptr inbounds nuw float, ptr %22, i64 %400, !dbg !104
  %402 = load float, ptr %401, align 4, !dbg !104
  %403 = fmul contract float %391, %395, !dbg !105
  %404 = fadd contract float %402, %403, !dbg !105
  store float %404, ptr %401, align 4, !dbg !104
  %405 = add i64 %383, 1, !dbg !104
  br label %382, !dbg !104

406:                                              ; preds = %382
  %407 = add i64 %380, 1, !dbg !104
  br label %379, !dbg !104

408:                                              ; preds = %379
  %409 = add i64 %377, 1, !dbg !104
  br label %376, !dbg !104

410:                                              ; preds = %376
  %411 = add i64 %374, 4, !dbg !104
  br label %373, !dbg !104

412:                                              ; preds = %373
  %413 = add i64 %346, 8, !dbg !104
  br label %345, !dbg !104

414:                                              ; preds = %345
  %415 = add i64 %341, 64, !dbg !104
  br label %340, !dbg !104

416:                                              ; preds = %340
  ret i32 0, !dbg !107
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

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!4}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/dynamic")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e14_aarch64_qemu/aarch64/dump/dynamic")
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_Dx64x9_f32", linkageName: "infer_dispatch_0_matmul_Dx64x9_f32", scope: !1, file: !1, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
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
!81 = !DILocation(line: 12, column: 8, scope: !5)
!82 = !DILocation(line: 13, column: 8, scope: !5)
!83 = !DILocation(line: 14, column: 8, scope: !5)
!84 = !DILocation(line: 15, column: 8, scope: !5)
!85 = !DILocation(line: 16, column: 8, scope: !5)
!86 = !DILocation(line: 17, column: 8, scope: !5)
!87 = !DILocation(line: 20, column: 8, scope: !5)
!88 = !DILocation(line: 22, column: 8, scope: !5)
!89 = !DILocation(line: 23, column: 8, scope: !5)
!90 = !DILocation(line: 28, column: 8, scope: !5)
!91 = !DILocation(line: 1, column: 1, scope: !5)
!92 = !DILocation(line: 27, column: 8, scope: !5)
!93 = !DILocation(line: 30, column: 8, scope: !5)
!94 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_Dx2x64_f32", linkageName: "infer_dispatch_1_matmul_Dx2x64_f32", scope: !3, file: !3, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!95 = !DILocation(line: 12, column: 8, scope: !94)
!96 = !DILocation(line: 13, column: 8, scope: !94)
!97 = !DILocation(line: 14, column: 8, scope: !94)
!98 = !DILocation(line: 15, column: 8, scope: !94)
!99 = !DILocation(line: 16, column: 8, scope: !94)
!100 = !DILocation(line: 17, column: 8, scope: !94)
!101 = !DILocation(line: 20, column: 8, scope: !94)
!102 = !DILocation(line: 22, column: 8, scope: !94)
!103 = !DILocation(line: 23, column: 8, scope: !94)
!104 = !DILocation(line: 28, column: 8, scope: !94)
!105 = !DILocation(line: 1, column: 1, scope: !94)
!106 = !DILocation(line: 27, column: 8, scope: !94)
!107 = !DILocation(line: 30, column: 8, scope: !94)
