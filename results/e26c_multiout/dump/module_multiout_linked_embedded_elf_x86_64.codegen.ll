; ModuleID = 'multiout_linked'
source_filename = "multiout_linked"
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

@__constant_8x4xf32 = private constant [8 x [4 x float]] [[4 x float] [float 0xBFD4C63F20000000, float 0x3FCC361140000000, float 0xBFDB98C7E0000000, float 0xBFD161E500000000], [4 x float] [float 0x3FAE69AD40000000, float 0x3FD68DB8C0000000, float 0x3FBD42C3C0000000, float 0xBFCC226800000000], [4 x float] [float 0x3FDAB6AE80000000, float 0xBFD2F1AA00000000, float 0xBFDEF00680000000, float 0xBFCD8ADAC0000000], [4 x float] [float 0xBFABCD35A0000000, float 0xBFDC20C4A0000000, float 0xBFD4B78040000000, float 0xBFC0CB2960000000], [4 x float] [float 0x3FB27BB300000000, float 0xBFD793DDA0000000, float 0xBFC1A6B500000000, float 0x3FD9048160000000], [4 x float] [float 0x3FDEC08320000000, float 0x3FC4154CA0000000, float 0x3FC8793DE0000000, float 0x3FB59B3D00000000], [4 x float] [float 0xBFD7055320000000, float 0xBFDDC0EBE0000000, float 0xBFDEDABA00000000, float 0x3FDA40B780000000], [4 x float] [float 0x3FC9BA5E40000000, float 0x3FDD9E83E0000000, float 0xBFDEA30560000000, float 0x3FC16F0060000000]], align 64
@0 = private constant [16 x i8] c"multiout_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [2 x ptr] [ptr @infer_dispatch_0_matmul_1x8x16_f32, ptr @infer_dispatch_1_matmul_1x4x8_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [2 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [35 x i8] c"infer_dispatch_0_matmul_1x8x16_f32\00", align 1
@2 = private constant [34 x i8] c"infer_dispatch_1_matmul_1x4x8_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [2 x ptr] [ptr @1, ptr @2]
@3 = private constant [67 x i8] c"results/e26c_multiout/dump/configured_module_infer_dispatch_0.mlir\00", align 1
@4 = private constant [67 x i8] c"results/e26c_multiout/dump/configured_module_infer_dispatch_1.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [2 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 66, ptr @3 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 66, ptr @4 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x8x16_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x8x16_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x4x8_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x4x8_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [2 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x8x16_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_1x8x16_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x4x8_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_matmul_1x4x8_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 2, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_matmul_1x8x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !5 {
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
  br label %15, !dbg !84

15:                                               ; preds = %63, %3
  %16 = phi i64 [ %67, %63 ], [ 0, %3 ], !dbg !84
  %17 = icmp slt i64 %16, 8, !dbg !84
  br i1 %17, label %18, label %68, !dbg !84

18:                                               ; preds = %22, %15
  %19 = phi i64 [ %62, %22 ], [ 0, %15 ], !dbg !84
  %20 = phi <1 x float> [ %61, %22 ], [ zeroinitializer, %15 ], !dbg !84
  %21 = icmp slt i64 %19, 16, !dbg !84
  br i1 %21, label %22, label %63, !dbg !84

22:                                               ; preds = %18
  %23 = mul i64 %19, 8, !dbg !84
  %24 = add i64 %23, %16, !dbg !84
  %25 = getelementptr float, ptr %10, i64 %24, !dbg !84
  %26 = load <1 x float>, ptr %25, align 4, !dbg !84
  %27 = add i64 %19, 1, !dbg !84
  %28 = mul i64 %27, 8, !dbg !84
  %29 = add i64 %28, %16, !dbg !84
  %30 = getelementptr float, ptr %10, i64 %29, !dbg !84
  %31 = load <1 x float>, ptr %30, align 4, !dbg !84
  %32 = add i64 %19, 2, !dbg !84
  %33 = mul i64 %32, 8, !dbg !84
  %34 = add i64 %33, %16, !dbg !84
  %35 = getelementptr float, ptr %10, i64 %34, !dbg !84
  %36 = load <1 x float>, ptr %35, align 4, !dbg !84
  %37 = add i64 %19, 3, !dbg !84
  %38 = mul i64 %37, 8, !dbg !84
  %39 = add i64 %38, %16, !dbg !84
  %40 = getelementptr float, ptr %10, i64 %39, !dbg !84
  %41 = load <1 x float>, ptr %40, align 4, !dbg !84
  %42 = add nuw nsw i64 0, %19, !dbg !85
  %43 = getelementptr inbounds nuw float, ptr %6, i64 %42, !dbg !85
  %44 = load float, ptr %43, align 4, !dbg !85
  %45 = insertelement <1 x float> poison, float %44, i32 0, !dbg !85
  %46 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %26, <1 x float> %45, <1 x float> %20), !dbg !85
  %47 = add nuw nsw i64 0, %27, !dbg !85
  %48 = getelementptr inbounds nuw float, ptr %6, i64 %47, !dbg !85
  %49 = load float, ptr %48, align 4, !dbg !85
  %50 = insertelement <1 x float> poison, float %49, i32 0, !dbg !85
  %51 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %31, <1 x float> %50, <1 x float> %46), !dbg !85
  %52 = add nuw nsw i64 0, %32, !dbg !85
  %53 = getelementptr inbounds nuw float, ptr %6, i64 %52, !dbg !85
  %54 = load float, ptr %53, align 4, !dbg !85
  %55 = insertelement <1 x float> poison, float %54, i32 0, !dbg !85
  %56 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %36, <1 x float> %55, <1 x float> %51), !dbg !85
  %57 = add nuw nsw i64 0, %37, !dbg !85
  %58 = getelementptr inbounds nuw float, ptr %6, i64 %57, !dbg !85
  %59 = load float, ptr %58, align 4, !dbg !85
  %60 = insertelement <1 x float> poison, float %59, i32 0, !dbg !85
  %61 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %41, <1 x float> %60, <1 x float> %56), !dbg !85
  %62 = add i64 %19, 4, !dbg !84
  br label %18, !dbg !84

63:                                               ; preds = %18
  %64 = extractelement <1 x float> %20, i64 0, !dbg !84
  %65 = add nuw nsw i64 0, %16, !dbg !84
  %66 = getelementptr inbounds nuw float, ptr %14, i64 %65, !dbg !84
  store float %64, ptr %66, align 4, !dbg !84
  %67 = add i64 %16, 1, !dbg !84
  br label %15, !dbg !84

68:                                               ; preds = %15
  ret i32 0, !dbg !86
}

define internal i32 @infer_dispatch_1_matmul_1x4x8_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !87 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !88
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !88
  %6 = load ptr, ptr %5, align 8, !dbg !88
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !88
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !89
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !89
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !89
  %10 = load ptr, ptr %9, align 8, !dbg !89
  %11 = getelementptr float, ptr %10, i64 16, !dbg !89
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !89
  br label %12, !dbg !90

12:                                               ; preds = %60, %3
  %13 = phi i64 [ %64, %60 ], [ 0, %3 ], !dbg !90
  %14 = icmp slt i64 %13, 4, !dbg !90
  br i1 %14, label %15, label %65, !dbg !90

15:                                               ; preds = %19, %12
  %16 = phi i64 [ %59, %19 ], [ 0, %12 ], !dbg !90
  %17 = phi <1 x float> [ %58, %19 ], [ zeroinitializer, %12 ], !dbg !90
  %18 = icmp slt i64 %16, 8, !dbg !90
  br i1 %18, label %19, label %60, !dbg !90

19:                                               ; preds = %15
  %20 = mul i64 %16, 4, !dbg !90
  %21 = add i64 %20, %13, !dbg !90
  %22 = getelementptr float, ptr @__constant_8x4xf32, i64 %21, !dbg !90
  %23 = load <1 x float>, ptr %22, align 4, !dbg !90
  %24 = add i64 %16, 1, !dbg !90
  %25 = mul i64 %24, 4, !dbg !90
  %26 = add i64 %25, %13, !dbg !90
  %27 = getelementptr float, ptr @__constant_8x4xf32, i64 %26, !dbg !90
  %28 = load <1 x float>, ptr %27, align 4, !dbg !90
  %29 = add i64 %16, 2, !dbg !90
  %30 = mul i64 %29, 4, !dbg !90
  %31 = add i64 %30, %13, !dbg !90
  %32 = getelementptr float, ptr @__constant_8x4xf32, i64 %31, !dbg !90
  %33 = load <1 x float>, ptr %32, align 4, !dbg !90
  %34 = add i64 %16, 3, !dbg !90
  %35 = mul i64 %34, 4, !dbg !90
  %36 = add i64 %35, %13, !dbg !90
  %37 = getelementptr float, ptr @__constant_8x4xf32, i64 %36, !dbg !90
  %38 = load <1 x float>, ptr %37, align 4, !dbg !90
  %39 = add nuw nsw i64 0, %16, !dbg !91
  %40 = getelementptr inbounds nuw float, ptr %6, i64 %39, !dbg !91
  %41 = load float, ptr %40, align 4, !dbg !91
  %42 = insertelement <1 x float> poison, float %41, i32 0, !dbg !91
  %43 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %23, <1 x float> %42, <1 x float> %17), !dbg !91
  %44 = add nuw nsw i64 0, %24, !dbg !91
  %45 = getelementptr inbounds nuw float, ptr %6, i64 %44, !dbg !91
  %46 = load float, ptr %45, align 4, !dbg !91
  %47 = insertelement <1 x float> poison, float %46, i32 0, !dbg !91
  %48 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %28, <1 x float> %47, <1 x float> %43), !dbg !91
  %49 = add nuw nsw i64 0, %29, !dbg !91
  %50 = getelementptr inbounds nuw float, ptr %6, i64 %49, !dbg !91
  %51 = load float, ptr %50, align 4, !dbg !91
  %52 = insertelement <1 x float> poison, float %51, i32 0, !dbg !91
  %53 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %33, <1 x float> %52, <1 x float> %48), !dbg !91
  %54 = add nuw nsw i64 0, %34, !dbg !91
  %55 = getelementptr inbounds nuw float, ptr %6, i64 %54, !dbg !91
  %56 = load float, ptr %55, align 4, !dbg !91
  %57 = insertelement <1 x float> poison, float %56, i32 0, !dbg !91
  %58 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %38, <1 x float> %57, <1 x float> %53), !dbg !91
  %59 = add i64 %16, 4, !dbg !90
  br label %15, !dbg !90

60:                                               ; preds = %15
  %61 = extractelement <1 x float> %17, i64 0, !dbg !90
  %62 = add nuw nsw i64 0, %13, !dbg !90
  %63 = getelementptr inbounds nuw float, ptr %11, i64 %62, !dbg !90
  store float %61, ptr %63, align 4, !dbg !90
  %64 = add i64 %13, 1, !dbg !90
  br label %12, !dbg !90

65:                                               ; preds = %12
  ret i32 0, !dbg !92
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
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "results/e26c_multiout/dump")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "results/e26c_multiout/dump")
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_1x8x16_f32", linkageName: "infer_dispatch_0_matmul_1x8x16_f32", scope: !1, file: !1, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
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
!85 = !DILocation(line: 4, column: 1, scope: !5)
!86 = !DILocation(line: 20, column: 8, scope: !5)
!87 = distinct !DISubprogram(name: "infer_dispatch_1_matmul_1x4x8_f32", linkageName: "infer_dispatch_1_matmul_1x4x8_f32", scope: !3, file: !3, line: 1, type: !6, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!88 = !DILocation(line: 13, column: 8, scope: !87)
!89 = !DILocation(line: 14, column: 8, scope: !87)
!90 = !DILocation(line: 18, column: 8, scope: !87)
!91 = !DILocation(line: 4, column: 1, scope: !87)
!92 = !DILocation(line: 20, column: 8, scope: !87)
