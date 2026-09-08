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
@3 = private constant [57 x i8] c"/tmp/e13/generic/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [57 x i8] c"/tmp/e13/generic/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 56, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 56, ptr @4 }]
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

19:                                               ; preds = %69, %3
  %20 = phi i64 [ %80, %69 ], [ 0, %3 ], !dbg !84
  %21 = icmp slt i64 %20, 64, !dbg !84
  br i1 %21, label %22, label %81, !dbg !84

22:                                               ; preds = %19
  %23 = add i64 %20, %18, !dbg !84
  br label %24, !dbg !84

24:                                               ; preds = %28, %22
  %25 = phi i64 [ %68, %28 ], [ 0, %22 ], !dbg !84
  %26 = phi <1 x float> [ %67, %28 ], [ zeroinitializer, %22 ], !dbg !84
  %27 = icmp slt i64 %25, 8, !dbg !84
  br i1 %27, label %28, label %69, !dbg !84

28:                                               ; preds = %24
  %29 = mul i64 %25, 16384, !dbg !84
  %30 = add i64 %29, %23, !dbg !84
  %31 = getelementptr float, ptr %10, i64 %30, !dbg !84
  %32 = load <1 x float>, ptr %31, align 4, !dbg !84
  %33 = add i64 %25, 1, !dbg !84
  %34 = mul i64 %33, 16384, !dbg !84
  %35 = add i64 %34, %23, !dbg !84
  %36 = getelementptr float, ptr %10, i64 %35, !dbg !84
  %37 = load <1 x float>, ptr %36, align 4, !dbg !84
  %38 = add i64 %25, 2, !dbg !84
  %39 = mul i64 %38, 16384, !dbg !84
  %40 = add i64 %39, %23, !dbg !84
  %41 = getelementptr float, ptr %10, i64 %40, !dbg !84
  %42 = load <1 x float>, ptr %41, align 4, !dbg !84
  %43 = add i64 %25, 3, !dbg !84
  %44 = mul i64 %43, 16384, !dbg !84
  %45 = add i64 %44, %23, !dbg !84
  %46 = getelementptr float, ptr %10, i64 %45, !dbg !84
  %47 = load <1 x float>, ptr %46, align 4, !dbg !84
  %48 = add nuw nsw i64 0, %25, !dbg !85
  %49 = getelementptr inbounds nuw float, ptr %6, i64 %48, !dbg !85
  %50 = load float, ptr %49, align 4, !dbg !85
  %51 = insertelement <1 x float> poison, float %50, i32 0, !dbg !85
  %52 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %32, <1 x float> %51, <1 x float> %26), !dbg !85
  %53 = add nuw nsw i64 0, %33, !dbg !85
  %54 = getelementptr inbounds nuw float, ptr %6, i64 %53, !dbg !85
  %55 = load float, ptr %54, align 4, !dbg !85
  %56 = insertelement <1 x float> poison, float %55, i32 0, !dbg !85
  %57 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %37, <1 x float> %56, <1 x float> %52), !dbg !85
  %58 = add nuw nsw i64 0, %38, !dbg !85
  %59 = getelementptr inbounds nuw float, ptr %6, i64 %58, !dbg !85
  %60 = load float, ptr %59, align 4, !dbg !85
  %61 = insertelement <1 x float> poison, float %60, i32 0, !dbg !85
  %62 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %42, <1 x float> %61, <1 x float> %57), !dbg !85
  %63 = add nuw nsw i64 0, %43, !dbg !85
  %64 = getelementptr inbounds nuw float, ptr %6, i64 %63, !dbg !85
  %65 = load float, ptr %64, align 4, !dbg !85
  %66 = insertelement <1 x float> poison, float %65, i32 0, !dbg !85
  %67 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %47, <1 x float> %66, <1 x float> %62), !dbg !85
  %68 = add i64 %25, 4, !dbg !84
  br label %24, !dbg !84

69:                                               ; preds = %24
  %70 = add i64 131072, %23, !dbg !84
  %71 = getelementptr float, ptr %10, i64 %70, !dbg !84
  %72 = load <1 x float>, ptr %71, align 4, !dbg !84
  %73 = getelementptr inbounds nuw float, ptr %6, i64 8, !dbg !85
  %74 = load float, ptr %73, align 4, !dbg !85
  %75 = insertelement <1 x float> poison, float %74, i32 0, !dbg !85
  %76 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %72, <1 x float> %75, <1 x float> %26), !dbg !85
  %77 = extractelement <1 x float> %76, i64 0, !dbg !84
  %78 = add nuw nsw i64 0, %23, !dbg !84
  %79 = getelementptr inbounds nuw float, ptr %14, i64 %78, !dbg !84
  store float %77, ptr %79, align 4, !dbg !84
  %80 = add i64 %20, 1, !dbg !84
  br label %19, !dbg !84

81:                                               ; preds = %19
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

16:                                               ; preds = %64, %3
  %17 = phi i64 [ %68, %64 ], [ 0, %3 ], !dbg !91
  %18 = icmp slt i64 %17, 2, !dbg !91
  br i1 %18, label %19, label %69, !dbg !91

19:                                               ; preds = %23, %16
  %20 = phi i64 [ %63, %23 ], [ 0, %16 ], !dbg !91
  %21 = phi <1 x float> [ %62, %23 ], [ zeroinitializer, %16 ], !dbg !91
  %22 = icmp slt i64 %20, 16384, !dbg !91
  br i1 %22, label %23, label %64, !dbg !91

23:                                               ; preds = %19
  %24 = mul i64 %20, 2, !dbg !91
  %25 = add i64 %24, %17, !dbg !91
  %26 = getelementptr float, ptr %11, i64 %25, !dbg !91
  %27 = load <1 x float>, ptr %26, align 4, !dbg !91
  %28 = add i64 %20, 1, !dbg !91
  %29 = mul i64 %28, 2, !dbg !91
  %30 = add i64 %29, %17, !dbg !91
  %31 = getelementptr float, ptr %11, i64 %30, !dbg !91
  %32 = load <1 x float>, ptr %31, align 4, !dbg !91
  %33 = add i64 %20, 2, !dbg !91
  %34 = mul i64 %33, 2, !dbg !91
  %35 = add i64 %34, %17, !dbg !91
  %36 = getelementptr float, ptr %11, i64 %35, !dbg !91
  %37 = load <1 x float>, ptr %36, align 4, !dbg !91
  %38 = add i64 %20, 3, !dbg !91
  %39 = mul i64 %38, 2, !dbg !91
  %40 = add i64 %39, %17, !dbg !91
  %41 = getelementptr float, ptr %11, i64 %40, !dbg !91
  %42 = load <1 x float>, ptr %41, align 4, !dbg !91
  %43 = add nuw nsw i64 0, %20, !dbg !92
  %44 = getelementptr inbounds nuw float, ptr %6, i64 %43, !dbg !92
  %45 = load float, ptr %44, align 4, !dbg !92
  %46 = insertelement <1 x float> poison, float %45, i32 0, !dbg !92
  %47 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %27, <1 x float> %46, <1 x float> %21), !dbg !92
  %48 = add nuw nsw i64 0, %28, !dbg !92
  %49 = getelementptr inbounds nuw float, ptr %6, i64 %48, !dbg !92
  %50 = load float, ptr %49, align 4, !dbg !92
  %51 = insertelement <1 x float> poison, float %50, i32 0, !dbg !92
  %52 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %32, <1 x float> %51, <1 x float> %47), !dbg !92
  %53 = add nuw nsw i64 0, %33, !dbg !92
  %54 = getelementptr inbounds nuw float, ptr %6, i64 %53, !dbg !92
  %55 = load float, ptr %54, align 4, !dbg !92
  %56 = insertelement <1 x float> poison, float %55, i32 0, !dbg !92
  %57 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %37, <1 x float> %56, <1 x float> %52), !dbg !92
  %58 = add nuw nsw i64 0, %38, !dbg !92
  %59 = getelementptr inbounds nuw float, ptr %6, i64 %58, !dbg !92
  %60 = load float, ptr %59, align 4, !dbg !92
  %61 = insertelement <1 x float> poison, float %60, i32 0, !dbg !92
  %62 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %42, <1 x float> %61, <1 x float> %57), !dbg !92
  %63 = add i64 %20, 4, !dbg !91
  br label %19, !dbg !91

64:                                               ; preds = %19
  %65 = extractelement <1 x float> %21, i64 0, !dbg !91
  %66 = add nuw nsw i64 0, %17, !dbg !91
  %67 = getelementptr inbounds nuw float, ptr %15, i64 %66, !dbg !91
  store float %65, ptr %67, align 4, !dbg !91
  %68 = add i64 %17, 1, !dbg !91
  br label %16, !dbg !91

69:                                               ; preds = %16
  ret i32 0, !dbg !93
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

!llvm.dbg.cu = !{!0, !2}
!llvm.module.flags = !{!4}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "/tmp/e13/generic")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "/tmp/e13/generic")
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
