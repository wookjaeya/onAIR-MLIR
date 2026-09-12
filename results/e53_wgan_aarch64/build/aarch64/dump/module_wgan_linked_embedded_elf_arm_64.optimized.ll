; ModuleID = 'wgan_linked'
source_filename = "wgan_linked"
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

@__constant_32xf32 = internal unnamed_addr constant [32 x float] [float 0xBF9ABF8B00000000, float 0x3F9EF007C0000000, float 0x3F94365BA0000000, float 0x3F9E0BADC0000000, float 0xBF7FE73AC0000000, float 0x3FBC5DD4E0000000, float 0x3F96BF16C0000000, float 0x3FB16F9880000000, float 0x3F8BF51D40000000, float 0xBF7928DC00000000, float 0x3F7FFEE1C0000000, float 0xBF8ABD18A0000000, float 0xBF8C057A40000000, float 0x3F9AD45080000000, float 0x3F8377FAC0000000, float 0x3F81AE1A80000000, float 0xBF8388EF80000000, float 0x3FAE115260000000, float 0xBF8310FA40000000, float 0x3FAB206940000000, float 0x3F83F81C00000000, float 0x3F933EC1C0000000, float 0x3F6A5CAD20000000, float 0x3F60688980000000, float 0x3F94307DC0000000, float 0xBF54E28440000000, float 0x3F8EDA7220000000, float 0x3FA82689E0000000, float 0xBF479BE420000000, float 0xBF6D520600000000, float 0x3FC1AF7B00000000, float 0x3FB87B0DE0000000], align 64
@__constant_64xf32 = internal unnamed_addr constant [64 x float] [float 0x3F98AC8880000000, float 0x3F9D9E7880000000, float 0xBF8080A260000000, float 0x3F96C3BEC0000000, float 0xBF81108100000000, float 0x3FA81EF000000000, float 0x3F9DE0F100000000, float 0x3F7AE6C220000000, float 0x3F81B25B80000000, float 0x3F6375DA60000000, float 0xBF7734B4C0000000, float 0x3FA50D0780000000, float 0x3FA6AD5CA0000000, float 0x3F82C90040000000, float 0xBF601AFFC0000000, float 0x3FA36A8680000000, float 0x3FA648DCE0000000, float 0x3F77C09980000000, float 0xBF742D91C0000000, float 0x3FA82DF840000000, float 0xBF9A2ACD00000000, float 0xBF7A6F4C00000000, float 0x3F90BAD0E0000000, float 0xBF95FF8FC0000000, float 0x3F8CA9A180000000, float 0xBF91CBF200000000, float 0x3FA32A8480000000, float 0x3F81188A40000000, float 0x3F51BBD6C0000000, float 0xBF9888E800000000, float 0x3F8767BF20000000, float 0x3F8C6C18C0000000, float 0xBF833A2C40000000, float 0xBF69B18540000000, float 0x3F5FF72840000000, float 0x3F922D22C0000000, float 0x3FA1F265C0000000, float 0x3FA1434AE0000000, float 0x3F92DBE0C0000000, float 0xBF57BAD080000000, float 0x3F91899380000000, float 0x3F7A9C7100000000, float 0x3F1E40E720000000, float 0x3F63E88AC0000000, float 0x3F9A5FC0E0000000, float 0xBF765CB700000000, float 0x3FA18826C0000000, float 0xBF6A6049C0000000, float 0xBF64D3D740000000, float 0x3F8D3E9100000000, float 0x3F922E4F80000000, float 0x3F9A4B7C40000000, float 0x3FA600DBC0000000, float 0x3F6CBEF6C0000000, float 0x3F91EAB000000000, float 0xBF94FAC6A0000000, float 0x3F8E422660000000, float 0x3F931E4780000000, float 0x3F897491C0000000, float 0x3F8F6C4900000000, float 0x3F8F3A6900000000, float 0x3F832718C0000000, float 0x3FA48EA400000000, float 0xBF6D789140000000], align 64
@__constant_64xf32_0 = internal unnamed_addr constant [64 x float] [float 0xBF94F5C8C0000000, float 0x3F8EAAF540000000, float 0x3F99AD9580000000, float 0xBFA14FB6A0000000, float 0x3F9F852CA0000000, float 0x3F9227F0E0000000, float 0xBF6F3B5000000000, float 0xBFA1ACBD80000000, float 0x3FA00234A0000000, float 0xBF8D9BE140000000, float 0xBF914DEDA0000000, float 0xBF788C4C20000000, float 0x3F9A52AC80000000, float 0xBF8D72DBC0000000, float 0x3F9339B500000000, float 0xBF9C2FB080000000, float 0x3FA0386360000000, float 0xBF67736540000000, float 0xBF9E56CB60000000, float 0xBFA109A320000000, float 0x3FA1C6E180000000, float 0xBF666827E0000000, float 0x3FA0CC12A0000000, float 0x3FA0C83F40000000, float 0xBF99324DA0000000, float 0x3F73628FC0000000, float 0xBF7E45AF00000000, float 0xBF7A1DF6A0000000, float 0xBF9FC7B1E0000000, float 0xBF7B1F1640000000, float 0x3FA0EA6740000000, float 0xBF77A11780000000, float 0x3FA67DFDC0000000, float 0xBF9AABAAE0000000, float 0xBF922796E0000000, float 0xBF9A4436C0000000, float 0x3F988F0040000000, float 0xBFA18C19E0000000, float 0x3F58D55280000000, float 0x3F31AC6700000000, float 0x3F82F27600000000, float 0x3F9F9C33C0000000, float 0x3F95163D00000000, float 0x3F968F5E40000000, float 0x3F66486700000000, float 0x3FA2D89D40000000, float 0xBFA4610300000000, float 0x3F8D8F2A80000000, float 0x3FADB0CC00000000, float 0x3F95D3D620000000, float 0x3F6BF9BE80000000, float 0xBF82593000000000, float 0xBF883480C0000000, float 0x3F983C2D00000000, float 0x3F9BEC6A80000000, float 0xBFA2A7F2C0000000, float 0x3F8D0629E0000000, float 0x3F9D63B000000000, float 0xBF93DBC780000000, float 0x3F8FE60E40000000, float 0x3F73EE2220000000, float 0xBF8DE4BEC0000000, float 0x3F6A87D1A0000000, float 0x3FA4E03680000000], align 64
@__constant_32xf32_0 = internal unnamed_addr constant [32 x float] [float 0x3F8A61A680000000, float 0x3FA8D28EC0000000, float 0x3FBB2A5B40000000, float 0x3F902F2B40000000, float 0x3FA527A340000000, float 0xBFB6F386C0000000, float 0xBF91EC4380000000, float 0xBF67E46C80000000, float 0xBF71B4E980000000, float 0xBF77B60E00000000, float 0xBFB07BFC60000000, float 0x3F9DA10640000000, float 0x3F8A445E80000000, float 0x3F86F53F80000000, float 0x3F870BFBC0000000, float 0x3F96148900000000, float 0xBFAF298880000000, float 0x3F95AE3040000000, float 0xBF9741DBC0000000, float 0xBFB3B3D840000000, float 0x3F9BCE1460000000, float 0xBFB45AEEC0000000, float 0x3FA7E7EAE0000000, float 0x3FA9A51340000000, float 0xBF9350E7A0000000, float 0xBF86983D80000000, float 0x3F99B3D560000000, float 0xBFA739FA40000000, float 0x3F9D048440000000, float 0xBFA6A09A60000000, float 0xBF9816B5C0000000, float 0x3F9F3FF5E0000000], align 64
@__constant_3xf32 = internal unnamed_addr constant [3 x float] [float 0xBFA8DEE240000000, float 0xBF9B8A0760000000, float 0xBF634E1040000000], align 64
@0 = internal constant [12 x i8] c"wgan_linked\00", align 1
@iree_hal_executable_library_query_v0_header = internal constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = internal constant [12 x ptr] [ptr @infer_dispatch_0_matmul_like_32x50176x3_f32, ptr @infer_dispatch_1_slow_memcpy, ptr @infer_dispatch_2_conv_64x224x224x32x3x3_f32, ptr @infer_dispatch_3_conv_128x224x224x64x3x3_f32, ptr @infer_dispatch_4_slow_memcpy, ptr @infer_dispatch_5_conv_128x224x224x128x3x3_f32, ptr @infer_dispatch_6_conv_128x224x224x128x3x3_f32, ptr @infer_dispatch_13_elementwise_broadcast_128x112x112_f32, ptr @infer_dispatch_14_conv_64x112x112x128x3x3_f32, ptr @infer_dispatch_15_elementwise_broadcast_64x224x224_f32, ptr @infer_dispatch_16_conv_32x224x224x64x3x3_f32, ptr @infer_dispatch_17_conv_3x224x224x32x3x3_f32]
@iree_hal_executable_library_query_v0_attrs = internal constant [12 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 5, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 4, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = internal constant [44 x i8] c"infer_dispatch_0_matmul_like_32x50176x3_f32\00", align 1
@2 = internal constant [29 x i8] c"infer_dispatch_1_slow_memcpy\00", align 1
@3 = internal constant [44 x i8] c"infer_dispatch_2_conv_64x224x224x32x3x3_f32\00", align 1
@4 = internal constant [45 x i8] c"infer_dispatch_3_conv_128x224x224x64x3x3_f32\00", align 1
@5 = internal constant [29 x i8] c"infer_dispatch_4_slow_memcpy\00", align 1
@6 = internal constant [46 x i8] c"infer_dispatch_5_conv_128x224x224x128x3x3_f32\00", align 1
@7 = internal constant [46 x i8] c"infer_dispatch_6_conv_128x224x224x128x3x3_f32\00", align 1
@8 = internal constant [56 x i8] c"infer_dispatch_13_elementwise_broadcast_128x112x112_f32\00", align 1
@9 = internal constant [46 x i8] c"infer_dispatch_14_conv_64x112x112x128x3x3_f32\00", align 1
@10 = internal constant [55 x i8] c"infer_dispatch_15_elementwise_broadcast_64x224x224_f32\00", align 1
@11 = internal constant [45 x i8] c"infer_dispatch_16_conv_32x224x224x64x3x3_f32\00", align 1
@12 = internal constant [44 x i8] c"infer_dispatch_17_conv_3x224x224x32x3x3_f32\00", align 1
@iree_hal_executable_library_query_v0_names = internal constant [12 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5, ptr @6, ptr @7, ptr @8, ptr @9, ptr @10, ptr @11, ptr @12]
@13 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@14 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@15 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@16 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_3.mlir\00", align 1
@17 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@18 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@19 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_6.mlir\00", align 1
@20 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_13.mlir\00", align 1
@21 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_14.mlir\00", align 1
@22 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_15.mlir\00", align 1
@23 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_16.mlir\00", align 1
@24 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_17.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = internal constant [12 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @13 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @14 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @15 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @16 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @17 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @18 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @19 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @20 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @21 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @22 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @23 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @24 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = internal constant [12 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = internal constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 12, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = internal local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = internal local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_0_matmul_like_32x50176x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !31 {
  %.elt20 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !107
  %.unpack21 = load ptr, ptr %.elt20, align 16, !dbg !107
  %4 = load ptr, ptr %.unpack21, align 8, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %4, i64 64) ], !dbg !107
  %5 = getelementptr i8, ptr %.unpack21, i64 8, !dbg !108
  %6 = load ptr, ptr %5, align 8, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !108
  %7 = getelementptr i8, ptr %.unpack21, i64 16, !dbg !109
  %8 = load ptr, ptr %7, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !109
  %9 = load i32, ptr %2, align 16, !dbg !110
  %10 = zext i32 %9 to i64, !dbg !110
  %11 = shl nuw nsw i64 %10, 6, !dbg !110
  %invariant.gep42 = getelementptr [4 x i8], ptr %4, i64 %11
  br label %12, !dbg !110

12:                                               ; preds = %3, %677
  %13 = phi i64 [ 0, %3 ], [ %678, %677 ]
  %14 = getelementptr [4 x i8], ptr @__constant_32xf32, i64 %13, !dbg !111
  %15 = load <8 x float>, ptr %14, align 32, !dbg !111
  %16 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> zeroinitializer, !dbg !111
  %17 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, !dbg !111
  %18 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2>, !dbg !111
  %19 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>, !dbg !111
  %20 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4>, !dbg !111
  %21 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>, !dbg !111
  %22 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6>, !dbg !111
  %23 = shufflevector <8 x float> %15, <8 x float> poison, <16 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>, !dbg !111
  %.idx31 = mul nuw nsw i64 %13, 12
  %24 = getelementptr i8, ptr %6, i64 %.idx31
  %25 = getelementptr i8, ptr %24, i64 12
  %26 = getelementptr i8, ptr %24, i64 24
  %27 = getelementptr i8, ptr %24, i64 36
  %28 = getelementptr i8, ptr %24, i64 48
  %29 = getelementptr i8, ptr %24, i64 60
  %30 = getelementptr i8, ptr %24, i64 72
  %31 = getelementptr i8, ptr %24, i64 84
  %.idx = mul nuw nsw i64 %13, 200704
  %32 = getelementptr i8, ptr %8, i64 %.idx
  %33 = getelementptr i8, ptr %32, i64 200704
  %34 = getelementptr i8, ptr %32, i64 401408
  %35 = getelementptr i8, ptr %32, i64 602112
  %36 = getelementptr i8, ptr %32, i64 802816
  %37 = getelementptr i8, ptr %32, i64 1003520
  %38 = getelementptr i8, ptr %32, i64 1204224
  %39 = getelementptr i8, ptr %32, i64 1404928
  br label %.preheader, !dbg !110

.preheader:                                       ; preds = %12, %609
  %40 = phi i64 [ 0, %12 ], [ %675, %609 ]
  %gep = getelementptr [4 x i8], ptr %invariant.gep42, i64 %40, !dbg !110
  br label %41, !dbg !110

41:                                               ; preds = %.preheader, %41
  %42 = phi [8 x <16 x float>] [ zeroinitializer, %.preheader ], [ %607, %41 ]
  %43 = phi i64 [ 0, %.preheader ], [ %608, %41 ]
  %44 = getelementptr [4 x i8], ptr %24, i64 %43, !dbg !110
  %45 = load <1 x float>, ptr %44, align 4, !dbg !110
  %46 = getelementptr [4 x i8], ptr %25, i64 %43, !dbg !110
  %47 = load <1 x float>, ptr %46, align 4, !dbg !110
  %48 = getelementptr [4 x i8], ptr %26, i64 %43, !dbg !110
  %49 = load <1 x float>, ptr %48, align 4, !dbg !110
  %50 = shufflevector <1 x float> %49, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %51 = getelementptr [4 x i8], ptr %27, i64 %43, !dbg !110
  %52 = load <1 x float>, ptr %51, align 4, !dbg !110
  %53 = shufflevector <1 x float> %52, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %54 = getelementptr [4 x i8], ptr %28, i64 %43, !dbg !110
  %55 = load <1 x float>, ptr %54, align 4, !dbg !110
  %56 = shufflevector <1 x float> %55, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %57 = getelementptr [4 x i8], ptr %29, i64 %43, !dbg !110
  %58 = load <1 x float>, ptr %57, align 4, !dbg !110
  %59 = shufflevector <1 x float> %58, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %60 = getelementptr [4 x i8], ptr %30, i64 %43, !dbg !110
  %61 = load <1 x float>, ptr %60, align 4, !dbg !110
  %62 = shufflevector <1 x float> %61, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %63 = getelementptr [4 x i8], ptr %31, i64 %43, !dbg !110
  %64 = load <1 x float>, ptr %63, align 4, !dbg !110
  %65 = shufflevector <1 x float> %64, <1 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %.idx39 = mul nuw nsw i64 %43, 200704, !dbg !112
  %gep41 = getelementptr i8, ptr %gep, i64 %.idx39, !dbg !112
  %66 = load float, ptr %gep41, align 64, !dbg !112
  %67 = extractvalue [8 x <16 x float>] %42, 0, !dbg !112
  %68 = extractvalue [8 x <16 x float>] %42, 1, !dbg !112
  %69 = extractvalue [8 x <16 x float>] %42, 2, !dbg !112
  %70 = extractvalue [8 x <16 x float>] %42, 3, !dbg !112
  %71 = extractvalue [8 x <16 x float>] %42, 4, !dbg !112
  %72 = extractelement <16 x float> %71, i64 0, !dbg !112
  %73 = extractvalue [8 x <16 x float>] %42, 5, !dbg !112
  %74 = extractvalue [8 x <16 x float>] %42, 6, !dbg !112
  %75 = extractvalue [8 x <16 x float>] %42, 7, !dbg !112
  %76 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 0, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %77 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %78 = shufflevector <8 x float> %76, <8 x float> %77, <8 x i32> <i32 0, i32 1, i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %79 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %80 = shufflevector <8 x float> %78, <8 x float> %79, <8 x i32> <i32 0, i32 1, i32 2, i32 8, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %81 = insertelement <8 x float> %80, float %72, i64 4, !dbg !112
  %82 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %83 = shufflevector <8 x float> %81, <8 x float> %82, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 8, i32 poison, i32 poison>, !dbg !112
  %84 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %85 = shufflevector <8 x float> %83, <8 x float> %84, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 poison>, !dbg !112
  %86 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %87 = shufflevector <8 x float> %85, <8 x float> %86, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 8>, !dbg !112
  %88 = shufflevector <1 x float> %45, <1 x float> %47, <8 x i32> <i32 0, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %89 = shufflevector <8 x float> %88, <8 x float> %50, <8 x i32> <i32 0, i32 1, i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %90 = shufflevector <8 x float> %89, <8 x float> %53, <8 x i32> <i32 0, i32 1, i32 2, i32 8, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %91 = shufflevector <8 x float> %90, <8 x float> %56, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 poison, i32 poison, i32 poison>, !dbg !112
  %92 = shufflevector <8 x float> %91, <8 x float> %59, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 8, i32 poison, i32 poison>, !dbg !112
  %93 = shufflevector <8 x float> %92, <8 x float> %62, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 poison>, !dbg !112
  %94 = shufflevector <8 x float> %93, <8 x float> %65, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 8>, !dbg !112
  %95 = insertelement <8 x float> poison, float %66, i64 0, !dbg !112
  %96 = shufflevector <8 x float> %95, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %97 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %96, <8 x float> %87), !dbg !112
  %98 = getelementptr inbounds nuw i8, ptr %gep41, i64 4, !dbg !112
  %99 = load float, ptr %98, align 4, !dbg !112
  %100 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 1, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %101 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %102 = shufflevector <8 x float> %100, <8 x float> %101, <8 x i32> <i32 0, i32 1, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %103 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %104 = shufflevector <8 x float> %102, <8 x float> %103, <8 x i32> <i32 0, i32 1, i32 2, i32 9, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %105 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %106 = shufflevector <8 x float> %104, <8 x float> %105, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 9, i32 poison, i32 poison, i32 poison>, !dbg !112
  %107 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %108 = shufflevector <8 x float> %106, <8 x float> %107, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 9, i32 poison, i32 poison>, !dbg !112
  %109 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %110 = shufflevector <8 x float> %108, <8 x float> %109, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 9, i32 poison>, !dbg !112
  %111 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %112 = shufflevector <8 x float> %110, <8 x float> %111, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 9>, !dbg !112
  %113 = insertelement <8 x float> poison, float %99, i64 0, !dbg !112
  %114 = shufflevector <8 x float> %113, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %115 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %114, <8 x float> %112), !dbg !112
  %116 = getelementptr inbounds nuw i8, ptr %gep41, i64 8, !dbg !112
  %117 = load float, ptr %116, align 8, !dbg !112
  %118 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 2, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %119 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %120 = shufflevector <8 x float> %118, <8 x float> %119, <8 x i32> <i32 0, i32 1, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %121 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %122 = shufflevector <8 x float> %120, <8 x float> %121, <8 x i32> <i32 0, i32 1, i32 2, i32 10, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %123 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %124 = shufflevector <8 x float> %122, <8 x float> %123, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 10, i32 poison, i32 poison, i32 poison>, !dbg !112
  %125 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %126 = shufflevector <8 x float> %124, <8 x float> %125, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 10, i32 poison, i32 poison>, !dbg !112
  %127 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %128 = shufflevector <8 x float> %126, <8 x float> %127, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 10, i32 poison>, !dbg !112
  %129 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %130 = shufflevector <8 x float> %128, <8 x float> %129, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 10>, !dbg !112
  %131 = insertelement <8 x float> poison, float %117, i64 0, !dbg !112
  %132 = shufflevector <8 x float> %131, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %133 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %132, <8 x float> %130), !dbg !112
  %134 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %135 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %136 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %137 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %138 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %139 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %140 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %141 = shufflevector <8 x float> %133, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %142 = getelementptr inbounds nuw i8, ptr %gep41, i64 12, !dbg !112
  %143 = load float, ptr %142, align 4, !dbg !112
  %144 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 3, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %145 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %146 = shufflevector <8 x float> %144, <8 x float> %145, <8 x i32> <i32 0, i32 1, i32 11, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %147 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %148 = shufflevector <8 x float> %146, <8 x float> %147, <8 x i32> <i32 0, i32 1, i32 2, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %149 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %150 = shufflevector <8 x float> %148, <8 x float> %149, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 11, i32 poison, i32 poison, i32 poison>, !dbg !112
  %151 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %152 = shufflevector <8 x float> %150, <8 x float> %151, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 11, i32 poison, i32 poison>, !dbg !112
  %153 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %154 = shufflevector <8 x float> %152, <8 x float> %153, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 11, i32 poison>, !dbg !112
  %155 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %156 = shufflevector <8 x float> %154, <8 x float> %155, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 11>, !dbg !112
  %157 = insertelement <8 x float> poison, float %143, i64 0, !dbg !112
  %158 = shufflevector <8 x float> %157, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %159 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %158, <8 x float> %156), !dbg !112
  %160 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %161 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %162 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %163 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %164 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %165 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %166 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %167 = shufflevector <8 x float> %159, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %168 = getelementptr inbounds nuw i8, ptr %gep41, i64 16, !dbg !112
  %169 = load float, ptr %168, align 16, !dbg !112
  %170 = extractelement <16 x float> %71, i64 4, !dbg !112
  %171 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 4, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %172 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison>, !dbg !112
  %173 = shufflevector <8 x float> %171, <8 x float> %172, <8 x i32> <i32 0, i32 1, i32 12, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %174 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison>, !dbg !112
  %175 = shufflevector <8 x float> %173, <8 x float> %174, <8 x i32> <i32 0, i32 1, i32 2, i32 12, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %176 = insertelement <8 x float> %175, float %170, i64 4, !dbg !112
  %177 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison>, !dbg !112
  %178 = shufflevector <8 x float> %176, <8 x float> %177, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 12, i32 poison, i32 poison>, !dbg !112
  %179 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison>, !dbg !112
  %180 = shufflevector <8 x float> %178, <8 x float> %179, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 12, i32 poison>, !dbg !112
  %181 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison>, !dbg !112
  %182 = shufflevector <8 x float> %180, <8 x float> %181, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 12>, !dbg !112
  %183 = insertelement <8 x float> poison, float %169, i64 0, !dbg !112
  %184 = shufflevector <8 x float> %183, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %185 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %184, <8 x float> %182), !dbg !112
  %186 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %187 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %188 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %189 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %190 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %191 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %192 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %193 = shufflevector <8 x float> %185, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %194 = getelementptr inbounds nuw i8, ptr %gep41, i64 20, !dbg !112
  %195 = load float, ptr %194, align 4, !dbg !112
  %196 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 5, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %197 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %198 = shufflevector <8 x float> %196, <8 x float> %197, <8 x i32> <i32 0, i32 1, i32 13, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %199 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %200 = shufflevector <8 x float> %198, <8 x float> %199, <8 x i32> <i32 0, i32 1, i32 2, i32 13, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %201 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %202 = shufflevector <8 x float> %200, <8 x float> %201, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 13, i32 poison, i32 poison, i32 poison>, !dbg !112
  %203 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %204 = shufflevector <8 x float> %202, <8 x float> %203, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 13, i32 poison, i32 poison>, !dbg !112
  %205 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %206 = shufflevector <8 x float> %204, <8 x float> %205, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 13, i32 poison>, !dbg !112
  %207 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison>, !dbg !112
  %208 = shufflevector <8 x float> %206, <8 x float> %207, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 13>, !dbg !112
  %209 = insertelement <8 x float> poison, float %195, i64 0, !dbg !112
  %210 = shufflevector <8 x float> %209, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %211 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %210, <8 x float> %208), !dbg !112
  %212 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %213 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %214 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %215 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %216 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %217 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %218 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %219 = shufflevector <8 x float> %211, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %220 = getelementptr inbounds nuw i8, ptr %gep41, i64 24, !dbg !112
  %221 = load float, ptr %220, align 8, !dbg !112
  %222 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 6, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %223 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %224 = shufflevector <8 x float> %222, <8 x float> %223, <8 x i32> <i32 0, i32 1, i32 14, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %225 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %226 = shufflevector <8 x float> %224, <8 x float> %225, <8 x i32> <i32 0, i32 1, i32 2, i32 14, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %227 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %228 = shufflevector <8 x float> %226, <8 x float> %227, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 14, i32 poison, i32 poison, i32 poison>, !dbg !112
  %229 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %230 = shufflevector <8 x float> %228, <8 x float> %229, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 14, i32 poison, i32 poison>, !dbg !112
  %231 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %232 = shufflevector <8 x float> %230, <8 x float> %231, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 14, i32 poison>, !dbg !112
  %233 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison>, !dbg !112
  %234 = shufflevector <8 x float> %232, <8 x float> %233, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 14>, !dbg !112
  %235 = insertelement <8 x float> poison, float %221, i64 0, !dbg !112
  %236 = shufflevector <8 x float> %235, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %237 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %236, <8 x float> %234), !dbg !112
  %238 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %239 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %240 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %241 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %242 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %243 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %244 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %245 = shufflevector <8 x float> %237, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %246 = getelementptr inbounds nuw i8, ptr %gep41, i64 28, !dbg !112
  %247 = load float, ptr %246, align 4, !dbg !112
  %248 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 7, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %249 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %250 = shufflevector <8 x float> %248, <8 x float> %249, <8 x i32> <i32 0, i32 1, i32 15, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %251 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %252 = shufflevector <8 x float> %250, <8 x float> %251, <8 x i32> <i32 0, i32 1, i32 2, i32 15, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %253 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %254 = shufflevector <8 x float> %252, <8 x float> %253, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 15, i32 poison, i32 poison, i32 poison>, !dbg !112
  %255 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %256 = shufflevector <8 x float> %254, <8 x float> %255, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 15, i32 poison, i32 poison>, !dbg !112
  %257 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %258 = shufflevector <8 x float> %256, <8 x float> %257, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 15, i32 poison>, !dbg !112
  %259 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7>, !dbg !112
  %260 = shufflevector <8 x float> %258, <8 x float> %259, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 15>, !dbg !112
  %261 = insertelement <8 x float> poison, float %247, i64 0, !dbg !112
  %262 = shufflevector <8 x float> %261, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %263 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %262, <8 x float> %260), !dbg !112
  %264 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %265 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %266 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %267 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %268 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %269 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %270 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %271 = shufflevector <8 x float> %263, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %272 = getelementptr inbounds nuw i8, ptr %gep41, i64 32, !dbg !112
  %273 = load float, ptr %272, align 32, !dbg !112
  %274 = extractelement <16 x float> %71, i64 8, !dbg !112
  %275 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 8, i32 24, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %276 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %277 = shufflevector <8 x float> %275, <8 x float> %276, <8 x i32> <i32 0, i32 1, i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %278 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %279 = shufflevector <8 x float> %277, <8 x float> %278, <8 x i32> <i32 0, i32 1, i32 2, i32 8, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %280 = insertelement <8 x float> %279, float %274, i64 4, !dbg !112
  %281 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %282 = shufflevector <8 x float> %280, <8 x float> %281, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 8, i32 poison, i32 poison>, !dbg !112
  %283 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %284 = shufflevector <8 x float> %282, <8 x float> %283, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 poison>, !dbg !112
  %285 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %286 = shufflevector <8 x float> %284, <8 x float> %285, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 8>, !dbg !112
  %287 = insertelement <8 x float> poison, float %273, i64 0, !dbg !112
  %288 = shufflevector <8 x float> %287, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %289 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %288, <8 x float> %286), !dbg !112
  %290 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %291 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %292 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %293 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %294 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %295 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %296 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %297 = shufflevector <8 x float> %289, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %298 = getelementptr inbounds nuw i8, ptr %gep41, i64 36, !dbg !112
  %299 = load float, ptr %298, align 4, !dbg !112
  %300 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 9, i32 25, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %301 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %302 = shufflevector <8 x float> %300, <8 x float> %301, <8 x i32> <i32 0, i32 1, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %303 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %304 = shufflevector <8 x float> %302, <8 x float> %303, <8 x i32> <i32 0, i32 1, i32 2, i32 9, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %305 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %306 = shufflevector <8 x float> %304, <8 x float> %305, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 9, i32 poison, i32 poison, i32 poison>, !dbg !112
  %307 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %308 = shufflevector <8 x float> %306, <8 x float> %307, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 9, i32 poison, i32 poison>, !dbg !112
  %309 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %310 = shufflevector <8 x float> %308, <8 x float> %309, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 9, i32 poison>, !dbg !112
  %311 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %312 = shufflevector <8 x float> %310, <8 x float> %311, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 9>, !dbg !112
  %313 = insertelement <8 x float> poison, float %299, i64 0, !dbg !112
  %314 = shufflevector <8 x float> %313, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %315 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %314, <8 x float> %312), !dbg !112
  %316 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %317 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %318 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %319 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %320 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %321 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %322 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %323 = shufflevector <8 x float> %315, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %324 = getelementptr inbounds nuw i8, ptr %gep41, i64 40, !dbg !112
  %325 = load float, ptr %324, align 8, !dbg !112
  %326 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 10, i32 26, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %327 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %328 = shufflevector <8 x float> %326, <8 x float> %327, <8 x i32> <i32 0, i32 1, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %329 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %330 = shufflevector <8 x float> %328, <8 x float> %329, <8 x i32> <i32 0, i32 1, i32 2, i32 10, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %331 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %332 = shufflevector <8 x float> %330, <8 x float> %331, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 10, i32 poison, i32 poison, i32 poison>, !dbg !112
  %333 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %334 = shufflevector <8 x float> %332, <8 x float> %333, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 10, i32 poison, i32 poison>, !dbg !112
  %335 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %336 = shufflevector <8 x float> %334, <8 x float> %335, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 10, i32 poison>, !dbg !112
  %337 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %338 = shufflevector <8 x float> %336, <8 x float> %337, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 10>, !dbg !112
  %339 = insertelement <8 x float> poison, float %325, i64 0, !dbg !112
  %340 = shufflevector <8 x float> %339, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %341 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %340, <8 x float> %338), !dbg !112
  %342 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %343 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %344 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %345 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %346 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %347 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %348 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %349 = shufflevector <8 x float> %341, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %350 = getelementptr inbounds nuw i8, ptr %gep41, i64 44, !dbg !112
  %351 = load float, ptr %350, align 4, !dbg !112
  %352 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 11, i32 27, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %353 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %354 = shufflevector <8 x float> %352, <8 x float> %353, <8 x i32> <i32 0, i32 1, i32 11, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %355 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %356 = shufflevector <8 x float> %354, <8 x float> %355, <8 x i32> <i32 0, i32 1, i32 2, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %357 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %358 = shufflevector <8 x float> %356, <8 x float> %357, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 11, i32 poison, i32 poison, i32 poison>, !dbg !112
  %359 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %360 = shufflevector <8 x float> %358, <8 x float> %359, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 11, i32 poison, i32 poison>, !dbg !112
  %361 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %362 = shufflevector <8 x float> %360, <8 x float> %361, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 11, i32 poison>, !dbg !112
  %363 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 11, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %364 = shufflevector <8 x float> %362, <8 x float> %363, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 11>, !dbg !112
  %365 = insertelement <8 x float> poison, float %351, i64 0, !dbg !112
  %366 = shufflevector <8 x float> %365, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %367 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %366, <8 x float> %364), !dbg !112
  %368 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %369 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %370 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %371 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %372 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %373 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %374 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %375 = shufflevector <8 x float> %367, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %376 = getelementptr inbounds nuw i8, ptr %gep41, i64 48, !dbg !112
  %377 = load float, ptr %376, align 16, !dbg !112
  %378 = extractelement <16 x float> %71, i64 12, !dbg !112
  %379 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 12, i32 28, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %380 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 12, i32 poison, i32 poison, i32 poison>, !dbg !112
  %381 = shufflevector <8 x float> %379, <8 x float> %380, <8 x i32> <i32 0, i32 1, i32 12, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %382 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 12, i32 poison, i32 poison, i32 poison>, !dbg !112
  %383 = shufflevector <8 x float> %381, <8 x float> %382, <8 x i32> <i32 0, i32 1, i32 2, i32 12, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %384 = insertelement <8 x float> %383, float %378, i64 4, !dbg !112
  %385 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 12, i32 poison, i32 poison, i32 poison>, !dbg !112
  %386 = shufflevector <8 x float> %384, <8 x float> %385, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 12, i32 poison, i32 poison>, !dbg !112
  %387 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 12, i32 poison, i32 poison, i32 poison>, !dbg !112
  %388 = shufflevector <8 x float> %386, <8 x float> %387, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 12, i32 poison>, !dbg !112
  %389 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 12, i32 poison, i32 poison, i32 poison>, !dbg !112
  %390 = shufflevector <8 x float> %388, <8 x float> %389, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 12>, !dbg !112
  %391 = insertelement <8 x float> poison, float %377, i64 0, !dbg !112
  %392 = shufflevector <8 x float> %391, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %393 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %392, <8 x float> %390), !dbg !112
  %394 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %395 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %396 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %397 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %398 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %399 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %400 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %401 = shufflevector <8 x float> %393, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %402 = getelementptr inbounds nuw i8, ptr %gep41, i64 52, !dbg !112
  %403 = load float, ptr %402, align 4, !dbg !112
  %404 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 13, i32 29, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %405 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %406 = shufflevector <8 x float> %404, <8 x float> %405, <8 x i32> <i32 0, i32 1, i32 13, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %407 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %408 = shufflevector <8 x float> %406, <8 x float> %407, <8 x i32> <i32 0, i32 1, i32 2, i32 13, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %409 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %410 = shufflevector <8 x float> %408, <8 x float> %409, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 13, i32 poison, i32 poison, i32 poison>, !dbg !112
  %411 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %412 = shufflevector <8 x float> %410, <8 x float> %411, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 13, i32 poison, i32 poison>, !dbg !112
  %413 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %414 = shufflevector <8 x float> %412, <8 x float> %413, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 13, i32 poison>, !dbg !112
  %415 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 13, i32 poison, i32 poison>, !dbg !112
  %416 = shufflevector <8 x float> %414, <8 x float> %415, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 13>, !dbg !112
  %417 = insertelement <8 x float> poison, float %403, i64 0, !dbg !112
  %418 = shufflevector <8 x float> %417, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %419 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %418, <8 x float> %416), !dbg !112
  %420 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %421 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %422 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %423 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %424 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %425 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %426 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %427 = shufflevector <8 x float> %419, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %428 = getelementptr inbounds nuw i8, ptr %gep41, i64 56, !dbg !112
  %429 = load float, ptr %428, align 8, !dbg !112
  %430 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 14, i32 30, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %431 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %432 = shufflevector <8 x float> %430, <8 x float> %431, <8 x i32> <i32 0, i32 1, i32 14, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %433 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %434 = shufflevector <8 x float> %432, <8 x float> %433, <8 x i32> <i32 0, i32 1, i32 2, i32 14, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %435 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %436 = shufflevector <8 x float> %434, <8 x float> %435, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 14, i32 poison, i32 poison, i32 poison>, !dbg !112
  %437 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %438 = shufflevector <8 x float> %436, <8 x float> %437, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 14, i32 poison, i32 poison>, !dbg !112
  %439 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %440 = shufflevector <8 x float> %438, <8 x float> %439, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 14, i32 poison>, !dbg !112
  %441 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 14, i32 poison>, !dbg !112
  %442 = shufflevector <8 x float> %440, <8 x float> %441, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 14>, !dbg !112
  %443 = insertelement <8 x float> poison, float %429, i64 0, !dbg !112
  %444 = shufflevector <8 x float> %443, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %445 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %444, <8 x float> %442), !dbg !112
  %446 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %447 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %448 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %449 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %450 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %451 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %452 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %453 = shufflevector <8 x float> %445, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %454 = getelementptr inbounds nuw i8, ptr %gep41, i64 60, !dbg !112
  %455 = load float, ptr %454, align 4, !dbg !112
  %456 = shufflevector <16 x float> %67, <16 x float> %68, <8 x i32> <i32 15, i32 31, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %457 = shufflevector <16 x float> %69, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %458 = shufflevector <8 x float> %456, <8 x float> %457, <8 x i32> <i32 0, i32 1, i32 15, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %459 = shufflevector <16 x float> %70, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %460 = shufflevector <8 x float> %458, <8 x float> %459, <8 x i32> <i32 0, i32 1, i32 2, i32 15, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %461 = shufflevector <16 x float> %71, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %462 = shufflevector <8 x float> %460, <8 x float> %461, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 15, i32 poison, i32 poison, i32 poison>, !dbg !112
  %463 = shufflevector <16 x float> %73, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %464 = shufflevector <8 x float> %462, <8 x float> %463, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 15, i32 poison, i32 poison>, !dbg !112
  %465 = shufflevector <16 x float> %74, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %466 = shufflevector <8 x float> %464, <8 x float> %465, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 15, i32 poison>, !dbg !112
  %467 = shufflevector <16 x float> %75, <16 x float> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 15>, !dbg !112
  %468 = shufflevector <8 x float> %466, <8 x float> %467, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 15>, !dbg !112
  %469 = insertelement <8 x float> poison, float %455, i64 0, !dbg !112
  %470 = shufflevector <8 x float> %469, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %471 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> %470, <8 x float> %468), !dbg !112
  %472 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %473 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 6, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %474 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 5, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %475 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 4, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %476 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %477 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 poison, i32 2, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %478 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %479 = shufflevector <8 x float> %471, <8 x float> poison, <16 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %480 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 0, i32 8, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %481 = shufflevector <16 x float> %480, <16 x float> %141, <16 x i32> <i32 0, i32 1, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %482 = shufflevector <16 x float> %481, <16 x float> %167, <16 x i32> <i32 0, i32 1, i32 2, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %483 = shufflevector <16 x float> %482, <16 x float> %193, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %484 = shufflevector <16 x float> %483, <16 x float> %219, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %485 = shufflevector <16 x float> %484, <16 x float> %245, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %486 = shufflevector <16 x float> %485, <16 x float> %271, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %487 = shufflevector <16 x float> %486, <16 x float> %297, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %488 = shufflevector <16 x float> %487, <16 x float> %323, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %489 = shufflevector <16 x float> %488, <16 x float> %349, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 16, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %490 = shufflevector <16 x float> %489, <16 x float> %375, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 16, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %491 = shufflevector <16 x float> %490, <16 x float> %401, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 poison, i32 poison, i32 poison>, !dbg !112
  %492 = shufflevector <16 x float> %491, <16 x float> %427, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 16, i32 poison, i32 poison>, !dbg !112
  %493 = shufflevector <16 x float> %492, <16 x float> %453, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 16, i32 poison>, !dbg !112
  %494 = shufflevector <16 x float> %493, <16 x float> %479, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 16>, !dbg !112
  %495 = insertvalue [8 x <16 x float>] poison, <16 x float> %494, 0, !dbg !112
  %496 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 1, i32 9, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %497 = shufflevector <16 x float> %496, <16 x float> %140, <16 x i32> <i32 0, i32 1, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %498 = shufflevector <16 x float> %497, <16 x float> %166, <16 x i32> <i32 0, i32 1, i32 2, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %499 = shufflevector <16 x float> %498, <16 x float> %192, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %500 = shufflevector <16 x float> %499, <16 x float> %218, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %501 = shufflevector <16 x float> %500, <16 x float> %244, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %502 = shufflevector <16 x float> %501, <16 x float> %270, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %503 = shufflevector <16 x float> %502, <16 x float> %296, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %504 = shufflevector <16 x float> %503, <16 x float> %322, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %505 = shufflevector <16 x float> %504, <16 x float> %348, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 17, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %506 = shufflevector <16 x float> %505, <16 x float> %374, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 17, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %507 = shufflevector <16 x float> %506, <16 x float> %400, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 17, i32 poison, i32 poison, i32 poison>, !dbg !112
  %508 = shufflevector <16 x float> %507, <16 x float> %426, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 17, i32 poison, i32 poison>, !dbg !112
  %509 = shufflevector <16 x float> %508, <16 x float> %452, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 17, i32 poison>, !dbg !112
  %510 = shufflevector <16 x float> %509, <16 x float> %478, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 17>, !dbg !112
  %511 = insertvalue [8 x <16 x float>] %495, <16 x float> %510, 1, !dbg !112
  %512 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 2, i32 10, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %513 = shufflevector <16 x float> %512, <16 x float> %139, <16 x i32> <i32 0, i32 1, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %514 = shufflevector <16 x float> %513, <16 x float> %165, <16 x i32> <i32 0, i32 1, i32 2, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %515 = shufflevector <16 x float> %514, <16 x float> %191, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %516 = shufflevector <16 x float> %515, <16 x float> %217, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %517 = shufflevector <16 x float> %516, <16 x float> %243, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %518 = shufflevector <16 x float> %517, <16 x float> %269, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %519 = shufflevector <16 x float> %518, <16 x float> %295, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %520 = shufflevector <16 x float> %519, <16 x float> %321, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %521 = shufflevector <16 x float> %520, <16 x float> %347, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 18, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %522 = shufflevector <16 x float> %521, <16 x float> %373, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 18, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %523 = shufflevector <16 x float> %522, <16 x float> %399, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 18, i32 poison, i32 poison, i32 poison>, !dbg !112
  %524 = shufflevector <16 x float> %523, <16 x float> %425, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 18, i32 poison, i32 poison>, !dbg !112
  %525 = shufflevector <16 x float> %524, <16 x float> %451, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 18, i32 poison>, !dbg !112
  %526 = shufflevector <16 x float> %525, <16 x float> %477, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 18>, !dbg !112
  %527 = insertvalue [8 x <16 x float>] %511, <16 x float> %526, 2, !dbg !112
  %528 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 3, i32 11, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %529 = shufflevector <16 x float> %528, <16 x float> %138, <16 x i32> <i32 0, i32 1, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %530 = shufflevector <16 x float> %529, <16 x float> %164, <16 x i32> <i32 0, i32 1, i32 2, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %531 = shufflevector <16 x float> %530, <16 x float> %190, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %532 = shufflevector <16 x float> %531, <16 x float> %216, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %533 = shufflevector <16 x float> %532, <16 x float> %242, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %534 = shufflevector <16 x float> %533, <16 x float> %268, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %535 = shufflevector <16 x float> %534, <16 x float> %294, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %536 = shufflevector <16 x float> %535, <16 x float> %320, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %537 = shufflevector <16 x float> %536, <16 x float> %346, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 19, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %538 = shufflevector <16 x float> %537, <16 x float> %372, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 19, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %539 = shufflevector <16 x float> %538, <16 x float> %398, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 19, i32 poison, i32 poison, i32 poison>, !dbg !112
  %540 = shufflevector <16 x float> %539, <16 x float> %424, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 19, i32 poison, i32 poison>, !dbg !112
  %541 = shufflevector <16 x float> %540, <16 x float> %450, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 19, i32 poison>, !dbg !112
  %542 = shufflevector <16 x float> %541, <16 x float> %476, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 19>, !dbg !112
  %543 = insertvalue [8 x <16 x float>] %527, <16 x float> %542, 3, !dbg !112
  %544 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 4, i32 12, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %545 = shufflevector <16 x float> %544, <16 x float> %137, <16 x i32> <i32 0, i32 1, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %546 = shufflevector <16 x float> %545, <16 x float> %163, <16 x i32> <i32 0, i32 1, i32 2, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %547 = shufflevector <16 x float> %546, <16 x float> %189, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %548 = shufflevector <16 x float> %547, <16 x float> %215, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %549 = shufflevector <16 x float> %548, <16 x float> %241, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %550 = shufflevector <16 x float> %549, <16 x float> %267, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %551 = shufflevector <16 x float> %550, <16 x float> %293, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %552 = shufflevector <16 x float> %551, <16 x float> %319, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %553 = shufflevector <16 x float> %552, <16 x float> %345, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 20, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %554 = shufflevector <16 x float> %553, <16 x float> %371, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 20, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %555 = shufflevector <16 x float> %554, <16 x float> %397, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 20, i32 poison, i32 poison, i32 poison>, !dbg !112
  %556 = shufflevector <16 x float> %555, <16 x float> %423, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 20, i32 poison, i32 poison>, !dbg !112
  %557 = shufflevector <16 x float> %556, <16 x float> %449, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 20, i32 poison>, !dbg !112
  %558 = shufflevector <16 x float> %557, <16 x float> %475, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 20>, !dbg !112
  %559 = insertvalue [8 x <16 x float>] %543, <16 x float> %558, 4, !dbg !112
  %560 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 5, i32 13, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %561 = shufflevector <16 x float> %560, <16 x float> %136, <16 x i32> <i32 0, i32 1, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %562 = shufflevector <16 x float> %561, <16 x float> %162, <16 x i32> <i32 0, i32 1, i32 2, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %563 = shufflevector <16 x float> %562, <16 x float> %188, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %564 = shufflevector <16 x float> %563, <16 x float> %214, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %565 = shufflevector <16 x float> %564, <16 x float> %240, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %566 = shufflevector <16 x float> %565, <16 x float> %266, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %567 = shufflevector <16 x float> %566, <16 x float> %292, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %568 = shufflevector <16 x float> %567, <16 x float> %318, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %569 = shufflevector <16 x float> %568, <16 x float> %344, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 21, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %570 = shufflevector <16 x float> %569, <16 x float> %370, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 21, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %571 = shufflevector <16 x float> %570, <16 x float> %396, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 21, i32 poison, i32 poison, i32 poison>, !dbg !112
  %572 = shufflevector <16 x float> %571, <16 x float> %422, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 21, i32 poison, i32 poison>, !dbg !112
  %573 = shufflevector <16 x float> %572, <16 x float> %448, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 21, i32 poison>, !dbg !112
  %574 = shufflevector <16 x float> %573, <16 x float> %474, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 21>, !dbg !112
  %575 = insertvalue [8 x <16 x float>] %559, <16 x float> %574, 5, !dbg !112
  %576 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 6, i32 14, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %577 = shufflevector <16 x float> %576, <16 x float> %135, <16 x i32> <i32 0, i32 1, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %578 = shufflevector <16 x float> %577, <16 x float> %161, <16 x i32> <i32 0, i32 1, i32 2, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %579 = shufflevector <16 x float> %578, <16 x float> %187, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %580 = shufflevector <16 x float> %579, <16 x float> %213, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %581 = shufflevector <16 x float> %580, <16 x float> %239, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %582 = shufflevector <16 x float> %581, <16 x float> %265, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %583 = shufflevector <16 x float> %582, <16 x float> %291, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %584 = shufflevector <16 x float> %583, <16 x float> %317, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %585 = shufflevector <16 x float> %584, <16 x float> %343, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 22, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %586 = shufflevector <16 x float> %585, <16 x float> %369, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 22, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %587 = shufflevector <16 x float> %586, <16 x float> %395, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 22, i32 poison, i32 poison, i32 poison>, !dbg !112
  %588 = shufflevector <16 x float> %587, <16 x float> %421, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 22, i32 poison, i32 poison>, !dbg !112
  %589 = shufflevector <16 x float> %588, <16 x float> %447, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 22, i32 poison>, !dbg !112
  %590 = shufflevector <16 x float> %589, <16 x float> %473, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 22>, !dbg !112
  %591 = insertvalue [8 x <16 x float>] %575, <16 x float> %590, 6, !dbg !112
  %592 = shufflevector <8 x float> %97, <8 x float> %115, <16 x i32> <i32 7, i32 15, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %593 = shufflevector <16 x float> %592, <16 x float> %134, <16 x i32> <i32 0, i32 1, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %594 = shufflevector <16 x float> %593, <16 x float> %160, <16 x i32> <i32 0, i32 1, i32 2, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %595 = shufflevector <16 x float> %594, <16 x float> %186, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %596 = shufflevector <16 x float> %595, <16 x float> %212, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %597 = shufflevector <16 x float> %596, <16 x float> %238, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %598 = shufflevector <16 x float> %597, <16 x float> %264, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %599 = shufflevector <16 x float> %598, <16 x float> %290, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %600 = shufflevector <16 x float> %599, <16 x float> %316, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %601 = shufflevector <16 x float> %600, <16 x float> %342, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %602 = shufflevector <16 x float> %601, <16 x float> %368, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 23, i32 poison, i32 poison, i32 poison, i32 poison>, !dbg !112
  %603 = shufflevector <16 x float> %602, <16 x float> %394, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 23, i32 poison, i32 poison, i32 poison>, !dbg !112
  %604 = shufflevector <16 x float> %603, <16 x float> %420, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 23, i32 poison, i32 poison>, !dbg !112
  %605 = shufflevector <16 x float> %604, <16 x float> %446, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 23, i32 poison>, !dbg !112
  %606 = shufflevector <16 x float> %605, <16 x float> %472, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 23>, !dbg !112
  %607 = insertvalue [8 x <16 x float>] %591, <16 x float> %606, 7, !dbg !112
  %608 = add nuw nsw i64 %43, 1, !dbg !110
  %exitcond.not = icmp eq i64 %608, 3, !dbg !110
  br i1 %exitcond.not, label %609, label %41, !dbg !110

609:                                              ; preds = %41
  %610 = fadd contract <16 x float> %16, %494, !dbg !113
  %611 = fadd contract <16 x float> %17, %510, !dbg !113
  %612 = fadd contract <16 x float> %18, %526, !dbg !113
  %613 = fadd contract <16 x float> %19, %542, !dbg !113
  %614 = fadd contract <16 x float> %20, %558, !dbg !113
  %615 = fadd contract <16 x float> %21, %574, !dbg !113
  %616 = fadd contract <16 x float> %22, %590, !dbg !113
  %617 = fadd contract <16 x float> %23, %606, !dbg !113
  %618 = fcmp ogt <16 x float> %610, zeroinitializer, !dbg !114
  %619 = fcmp ogt <16 x float> %611, zeroinitializer, !dbg !114
  %620 = fcmp ogt <16 x float> %612, zeroinitializer, !dbg !114
  %621 = fcmp ogt <16 x float> %613, zeroinitializer, !dbg !114
  %622 = fcmp ogt <16 x float> %614, zeroinitializer, !dbg !114
  %623 = fcmp ogt <16 x float> %615, zeroinitializer, !dbg !114
  %624 = fcmp ogt <16 x float> %616, zeroinitializer, !dbg !114
  %625 = fcmp ogt <16 x float> %617, zeroinitializer, !dbg !114
  %626 = select <16 x i1> %618, <16 x float> zeroinitializer, <16 x float> %610, !dbg !115
  %627 = select <16 x i1> %619, <16 x float> zeroinitializer, <16 x float> %611, !dbg !115
  %628 = select <16 x i1> %620, <16 x float> zeroinitializer, <16 x float> %612, !dbg !115
  %629 = select <16 x i1> %621, <16 x float> zeroinitializer, <16 x float> %613, !dbg !115
  %630 = select <16 x i1> %622, <16 x float> zeroinitializer, <16 x float> %614, !dbg !115
  %631 = select <16 x i1> %623, <16 x float> zeroinitializer, <16 x float> %615, !dbg !115
  %632 = select <16 x i1> %624, <16 x float> zeroinitializer, <16 x float> %616, !dbg !115
  %633 = select <16 x i1> %625, <16 x float> zeroinitializer, <16 x float> %617, !dbg !115
  %634 = fmul contract <16 x float> %626, splat (float 0x3FC99999A0000000), !dbg !116
  %635 = fmul contract <16 x float> %627, splat (float 0x3FC99999A0000000), !dbg !116
  %636 = fmul contract <16 x float> %628, splat (float 0x3FC99999A0000000), !dbg !116
  %637 = fmul contract <16 x float> %629, splat (float 0x3FC99999A0000000), !dbg !116
  %638 = fmul contract <16 x float> %630, splat (float 0x3FC99999A0000000), !dbg !116
  %639 = fmul contract <16 x float> %631, splat (float 0x3FC99999A0000000), !dbg !116
  %640 = fmul contract <16 x float> %632, splat (float 0x3FC99999A0000000), !dbg !116
  %641 = fmul contract <16 x float> %633, splat (float 0x3FC99999A0000000), !dbg !116
  %642 = fcmp olt <16 x float> %610, zeroinitializer, !dbg !117
  %643 = fcmp olt <16 x float> %611, zeroinitializer, !dbg !117
  %644 = fcmp olt <16 x float> %612, zeroinitializer, !dbg !117
  %645 = fcmp olt <16 x float> %613, zeroinitializer, !dbg !117
  %646 = fcmp olt <16 x float> %614, zeroinitializer, !dbg !117
  %647 = fcmp olt <16 x float> %615, zeroinitializer, !dbg !117
  %648 = fcmp olt <16 x float> %616, zeroinitializer, !dbg !117
  %649 = fcmp olt <16 x float> %617, zeroinitializer, !dbg !117
  %650 = select <16 x i1> %642, <16 x float> zeroinitializer, <16 x float> %610, !dbg !118
  %651 = select <16 x i1> %643, <16 x float> zeroinitializer, <16 x float> %611, !dbg !118
  %652 = select <16 x i1> %644, <16 x float> zeroinitializer, <16 x float> %612, !dbg !118
  %653 = select <16 x i1> %645, <16 x float> zeroinitializer, <16 x float> %613, !dbg !118
  %654 = select <16 x i1> %646, <16 x float> zeroinitializer, <16 x float> %614, !dbg !118
  %655 = select <16 x i1> %647, <16 x float> zeroinitializer, <16 x float> %615, !dbg !118
  %656 = select <16 x i1> %648, <16 x float> zeroinitializer, <16 x float> %616, !dbg !118
  %657 = select <16 x i1> %649, <16 x float> zeroinitializer, <16 x float> %617, !dbg !118
  %658 = fadd contract <16 x float> %650, %634, !dbg !119
  %659 = fadd contract <16 x float> %651, %635, !dbg !119
  %660 = fadd contract <16 x float> %652, %636, !dbg !119
  %661 = fadd contract <16 x float> %653, %637, !dbg !119
  %662 = fadd contract <16 x float> %654, %638, !dbg !119
  %663 = fadd contract <16 x float> %655, %639, !dbg !119
  %664 = fadd contract <16 x float> %656, %640, !dbg !119
  %665 = fadd contract <16 x float> %657, %641, !dbg !119
  %666 = add nuw nsw i64 %40, %11, !dbg !110
  %667 = getelementptr [4 x i8], ptr %32, i64 %666, !dbg !110
  store <16 x float> %658, ptr %667, align 64, !dbg !110
  %668 = getelementptr [4 x i8], ptr %33, i64 %666, !dbg !110
  store <16 x float> %659, ptr %668, align 64, !dbg !110
  %669 = getelementptr [4 x i8], ptr %34, i64 %666, !dbg !110
  store <16 x float> %660, ptr %669, align 64, !dbg !110
  %670 = getelementptr [4 x i8], ptr %35, i64 %666, !dbg !110
  store <16 x float> %661, ptr %670, align 64, !dbg !110
  %671 = getelementptr [4 x i8], ptr %36, i64 %666, !dbg !110
  store <16 x float> %662, ptr %671, align 64, !dbg !110
  %672 = getelementptr [4 x i8], ptr %37, i64 %666, !dbg !110
  store <16 x float> %663, ptr %672, align 64, !dbg !110
  %673 = getelementptr [4 x i8], ptr %38, i64 %666, !dbg !110
  store <16 x float> %664, ptr %673, align 64, !dbg !110
  %674 = getelementptr [4 x i8], ptr %39, i64 %666, !dbg !110
  store <16 x float> %665, ptr %674, align 64, !dbg !110
  %675 = add nuw nsw i64 %40, 16, !dbg !110
  %676 = icmp samesign ult i64 %40, 48, !dbg !110
  br i1 %676, label %.preheader, label %677, !dbg !110

677:                                              ; preds = %609
  %678 = add nuw nsw i64 %13, 8, !dbg !110
  %679 = icmp samesign ult i64 %13, 24, !dbg !110
  br i1 %679, label %12, label %680, !dbg !110

680:                                              ; preds = %677
  ret i32 0, !dbg !120
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_1_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !121 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !122
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !122
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !122
  call void @llvm.assume(i1 true) [ "align"(ptr %4, i64 64) ], !dbg !123
  %5 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !124
  %6 = load ptr, ptr %5, align 8, !dbg !124
  %7 = getelementptr i8, ptr %6, i64 6422528, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !125
  %8 = load i32, ptr %2, align 16, !dbg !126
  %9 = zext i32 %8 to i64, !dbg !126
  %10 = lshr i64 %9, 2, !dbg !126
  %11 = and i64 %9, 3, !dbg !126
  %12 = mul nuw nsw i64 %10, 56, !dbg !126
  %13 = mul nuw nsw i64 %11, 56, !dbg !126
  br label %.preheader26, !dbg !126

.preheader26:                                     ; preds = %3, %32
  %14 = phi i64 [ 0, %3 ], [ %33, %32 ]
  %.idx = mul nuw nsw i64 %14, 200704
  %15 = getelementptr i8, ptr %4, i64 %.idx
  %.idx24 = mul nuw nsw i64 %14, 204304
  %16 = getelementptr i8, ptr %7, i64 %.idx24
  br label %.preheader, !dbg !126

.preheader:                                       ; preds = %.preheader26, %30
  %17 = phi i64 [ 0, %.preheader26 ], [ %31, %30 ]
  %18 = add nuw nsw i64 %17, %12
  %.idx23 = mul nuw nsw i64 %18, 896
  %19 = getelementptr i8, ptr %15, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %18, 904
  %20 = getelementptr i8, ptr %16, i64 %.idx25
  %21 = getelementptr i8, ptr %20, i64 908
  br label %22, !dbg !126

22:                                               ; preds = %.preheader, %22
  %23 = phi i64 [ 0, %.preheader ], [ %28, %22 ]
  %24 = add nuw nsw i64 %23, %13, !dbg !126
  %25 = getelementptr [4 x i8], ptr %19, i64 %24, !dbg !126
  %26 = load <4 x float>, ptr %25, align 16, !dbg !126
  %27 = getelementptr [4 x i8], ptr %21, i64 %24, !dbg !126
  store <4 x float> %26, ptr %27, align 4, !dbg !126
  %28 = add nuw nsw i64 %23, 4, !dbg !126
  %29 = icmp samesign ult i64 %23, 52, !dbg !126
  br i1 %29, label %22, label %30, !dbg !126

30:                                               ; preds = %22
  %31 = add nuw nsw i64 %17, 1, !dbg !126
  %exitcond.not = icmp eq i64 %31, 56, !dbg !126
  br i1 %exitcond.not, label %32, label %.preheader, !dbg !126

32:                                               ; preds = %30
  %33 = add nuw nsw i64 %14, 1, !dbg !126
  %exitcond27.not = icmp eq i64 %33, 32, !dbg !126
  br i1 %exitcond27.not, label %34, label %.preheader26, !dbg !126

34:                                               ; preds = %32
  ret i32 0, !dbg !127
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_2_conv_64x224x224x32x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !128 {
  %4 = alloca [4 x float], align 64, !dbg !129
  %5 = alloca [4 x float], align 64, !dbg !130
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !131
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !131
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !131
  %7 = getelementptr i8, ptr %6, i64 6422528, !dbg !131
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !131
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !132
  %9 = load ptr, ptr %8, align 8, !dbg !132
  %10 = getelementptr i8, ptr %9, i64 4209920, !dbg !132
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !132
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !133
  %12 = load ptr, ptr %11, align 8, !dbg !133
  %13 = getelementptr i8, ptr %12, i64 12960256, !dbg !133
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !133
  %14 = load i32, ptr %2, align 16, !dbg !129
  %.frozen = freeze i32 %14, !dbg !129
  %15 = udiv i32 %.frozen, 49, !dbg !129
  %16 = mul i32 %15, 49, !dbg !129
  %.decomposed = sub i32 %.frozen, %16, !dbg !129
  %.lhs.trunc35 = trunc nuw nsw i32 %.decomposed to i8, !dbg !129
  %17 = udiv i8 %.lhs.trunc35, 7, !dbg !129
  %.zext36 = zext nneg i8 %17 to i64, !dbg !129
  %18 = urem i32 %14, 7, !dbg !129
  %19 = shl nuw i32 %15, 5, !dbg !129
  %20 = zext i32 %19 to i64, !dbg !129
  %21 = shl nuw nsw i64 %.zext36, 5, !dbg !129
  %22 = shl nuw nsw i32 %18, 5, !dbg !129
  %23 = zext nneg i32 %22 to i64, !dbg !129
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !134
  br label %24, !dbg !129

24:                                               ; preds = %3, %84
  %25 = phi i64 [ 0, %3 ], [ %85, %84 ]
  %26 = or disjoint i64 %25, %20, !dbg !129
  %27 = getelementptr [4 x i8], ptr @__constant_64xf32, i64 %26, !dbg !135
  %28 = load <1 x float>, ptr %27, align 4, !dbg !135
  %.idx30 = mul nuw nsw i64 %26, 1152
  %29 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx30
  %30 = shufflevector <1 x float> %28, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %26, 204304
  %31 = getelementptr i8, ptr %13, i64 %.idx
  br label %.preheader41, !dbg !129

.preheader41:                                     ; preds = %24, %82
  %32 = phi i64 [ 0, %24 ], [ %83, %82 ]
  %33 = add nuw nsw i64 %32, %21
  %.idx27 = mul nuw nsw i64 %33, 904
  %34 = getelementptr i8, ptr %31, i64 %.idx27
  %35 = getelementptr i8, ptr %34, i64 908
  br label %36, !dbg !129

36:                                               ; preds = %.preheader41, %70
  %37 = phi i64 [ 0, %.preheader41 ], [ %80, %70 ]
  br label %39, !dbg !129

.preheader40:                                     ; preds = %39
  %38 = or disjoint i64 %37, %23, !dbg !129
  %invariant.gep42 = getelementptr [4 x i8], ptr %7, i64 %38, !dbg !129
  br label %.preheader39, !dbg !129

39:                                               ; preds = %36, %39
  %40 = phi i64 [ 0, %36 ], [ %44, %39 ]
  %41 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %40, !dbg !129
  %42 = load float, ptr %41, align 4, !dbg !129
  %43 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %40, !dbg !129
  store float %42, ptr %43, align 4, !dbg !129
  %44 = add nuw nsw i64 %40, 1, !dbg !129
  %exitcond.not = icmp eq i64 %44, 4, !dbg !129
  br i1 %exitcond.not, label %.preheader40, label %39, !dbg !129

.preheader39:                                     ; preds = %.preheader40, %68
  %45 = phi i64 [ 0, %.preheader40 ], [ %69, %68 ]
  %.idx28 = mul nuw nsw i64 %45, 204304
  %gep43 = getelementptr i8, ptr %invariant.gep42, i64 %.idx28, !dbg !129
  %.idx31 = mul nuw nsw i64 %45, 36
  %46 = getelementptr inbounds nuw i8, ptr %29, i64 %.idx31
  br label %47, !dbg !129

47:                                               ; preds = %.preheader39, %66
  %48 = phi i64 [ 0, %.preheader39 ], [ %67, %66 ]
  %49 = add nuw nsw i64 %33, %48, !dbg !129
  %.idx29 = mul nuw nsw i64 %49, 904
  %gep = getelementptr i8, ptr %gep43, i64 %.idx29
  %.idx32 = mul nuw nsw i64 %48, 12
  %50 = getelementptr inbounds nuw i8, ptr %46, i64 %.idx32
  br label %.preheader, !dbg !129

.preheader:                                       ; preds = %47, %64
  %51 = phi i64 [ 0, %47 ], [ %65, %64 ]
  %52 = getelementptr [4 x i8], ptr %gep, i64 %51
  %53 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %51
  %.promoted = load float, ptr %53, align 4
  br label %54, !dbg !129

54:                                               ; preds = %.preheader, %54
  %55 = phi i64 [ 0, %.preheader ], [ %63, %54 ]
  %56 = phi float [ %.promoted, %.preheader ], [ %62, %54 ]
  %57 = getelementptr [4 x i8], ptr %52, i64 %55, !dbg !129
  %58 = load float, ptr %57, align 4, !dbg !129
  %59 = getelementptr inbounds nuw [4 x i8], ptr %50, i64 %55, !dbg !129
  %60 = load float, ptr %59, align 4, !dbg !129
  %61 = fmul contract float %58, %60, !dbg !136
  %62 = fadd contract float %56, %61, !dbg !137
  %63 = add nuw nsw i64 %55, 1, !dbg !129
  %exitcond44.not = icmp eq i64 %63, 3, !dbg !129
  br i1 %exitcond44.not, label %64, label %54, !dbg !129

64:                                               ; preds = %54
  store float %62, ptr %53, align 4, !dbg !129
  %65 = add nuw nsw i64 %51, 1, !dbg !129
  %exitcond45.not = icmp eq i64 %65, 4, !dbg !129
  br i1 %exitcond45.not, label %66, label %.preheader, !dbg !129

66:                                               ; preds = %64
  %67 = add nuw nsw i64 %48, 1, !dbg !129
  %exitcond46.not = icmp eq i64 %67, 3, !dbg !129
  br i1 %exitcond46.not, label %68, label %47, !dbg !129

68:                                               ; preds = %66
  %69 = add nuw nsw i64 %45, 1, !dbg !129
  %exitcond47.not = icmp eq i64 %69, 32, !dbg !129
  br i1 %exitcond47.not, label %70, label %.preheader39, !dbg !129

70:                                               ; preds = %68
  %71 = load <4 x float>, ptr %4, align 64, !dbg !135
  %72 = fadd contract <4 x float> %30, %71, !dbg !138
  %73 = fcmp ogt <4 x float> %72, zeroinitializer, !dbg !139
  %74 = select <4 x i1> %73, <4 x float> zeroinitializer, <4 x float> %72, !dbg !140
  %75 = fmul contract <4 x float> %74, splat (float 0x3FC99999A0000000), !dbg !141
  %76 = fcmp olt <4 x float> %72, zeroinitializer, !dbg !142
  %77 = select <4 x i1> %76, <4 x float> zeroinitializer, <4 x float> %72, !dbg !143
  %78 = fadd contract <4 x float> %77, %75, !dbg !144
  %79 = getelementptr [4 x i8], ptr %35, i64 %38, !dbg !129
  store <4 x float> %78, ptr %79, align 4, !dbg !129
  %80 = add nuw nsw i64 %37, 4, !dbg !129
  %81 = icmp samesign ult i64 %37, 28, !dbg !129
  br i1 %81, label %36, label %82, !dbg !129

82:                                               ; preds = %70
  %83 = add nuw nsw i64 %32, 1, !dbg !129
  %exitcond48.not = icmp eq i64 %83, 32, !dbg !129
  br i1 %exitcond48.not, label %84, label %.preheader41, !dbg !129

84:                                               ; preds = %82
  %85 = add nuw nsw i64 %25, 1, !dbg !129
  %exitcond49.not = icmp eq i64 %85, 32, !dbg !129
  br i1 %exitcond49.not, label %86, label %24, !dbg !129

86:                                               ; preds = %84
  ret i32 0, !dbg !145
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_3_conv_128x224x224x64x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !146 {
  %4 = alloca [4 x float], align 64, !dbg !147
  %5 = alloca [4 x float], align 64, !dbg !148
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !149
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !149
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !149
  %7 = getelementptr i8, ptr %6, i64 12960256, !dbg !149
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !149
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !150
  %9 = load ptr, ptr %8, align 8, !dbg !150
  %10 = getelementptr i8, ptr %9, i64 3837312, !dbg !150
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !150
  %11 = getelementptr i8, ptr %9, i64 4132224, !dbg !151
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !151
  %12 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !152
  %13 = load ptr, ptr %12, align 8, !dbg !152
  %14 = getelementptr i8, ptr %13, i64 26035712, !dbg !152
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !152
  %15 = load i32, ptr %2, align 16, !dbg !147
  %.frozen = freeze i32 %15, !dbg !147
  %16 = udiv i32 %.frozen, 49, !dbg !147
  %17 = mul i32 %16, 49, !dbg !147
  %.decomposed = sub i32 %.frozen, %17, !dbg !147
  %.lhs.trunc35 = trunc nuw nsw i32 %.decomposed to i8, !dbg !147
  %18 = udiv i8 %.lhs.trunc35, 7, !dbg !147
  %.zext36 = zext nneg i8 %18 to i64, !dbg !147
  %19 = urem i32 %15, 7, !dbg !147
  %20 = shl nuw i32 %16, 5, !dbg !147
  %21 = zext i32 %20 to i64, !dbg !147
  %22 = shl nuw nsw i64 %.zext36, 5, !dbg !147
  %23 = shl nuw nsw i32 %19, 5, !dbg !147
  %24 = zext nneg i32 %23 to i64, !dbg !147
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !153
  br label %25, !dbg !147

25:                                               ; preds = %3, %84
  %26 = phi i64 [ 0, %3 ], [ %85, %84 ]
  %27 = or disjoint i64 %26, %21, !dbg !147
  %28 = getelementptr [4 x i8], ptr %11, i64 %27, !dbg !154
  %29 = load <1 x float>, ptr %28, align 4, !dbg !154
  %.idx30 = mul nuw nsw i64 %27, 2304
  %30 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx30
  %31 = shufflevector <1 x float> %29, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %27, 200704
  %32 = getelementptr i8, ptr %14, i64 %.idx
  br label %.preheader41, !dbg !147

.preheader41:                                     ; preds = %25, %82
  %33 = phi i64 [ 0, %25 ], [ %83, %82 ]
  %34 = add nuw nsw i64 %33, %22
  %.idx27 = mul nuw nsw i64 %34, 896
  %35 = getelementptr i8, ptr %32, i64 %.idx27
  br label %36, !dbg !147

36:                                               ; preds = %.preheader41, %70
  %37 = phi i64 [ 0, %.preheader41 ], [ %80, %70 ]
  br label %39, !dbg !147

.preheader40:                                     ; preds = %39
  %38 = or disjoint i64 %37, %24, !dbg !147
  %invariant.gep42 = getelementptr [4 x i8], ptr %7, i64 %38, !dbg !147
  br label %.preheader39, !dbg !147

39:                                               ; preds = %36, %39
  %40 = phi i64 [ 0, %36 ], [ %44, %39 ]
  %41 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %40, !dbg !147
  %42 = load float, ptr %41, align 4, !dbg !147
  %43 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %40, !dbg !147
  store float %42, ptr %43, align 4, !dbg !147
  %44 = add nuw nsw i64 %40, 1, !dbg !147
  %exitcond.not = icmp eq i64 %44, 4, !dbg !147
  br i1 %exitcond.not, label %.preheader40, label %39, !dbg !147

.preheader39:                                     ; preds = %.preheader40, %68
  %45 = phi i64 [ 0, %.preheader40 ], [ %69, %68 ]
  %.idx28 = mul nuw nsw i64 %45, 204304
  %gep43 = getelementptr i8, ptr %invariant.gep42, i64 %.idx28, !dbg !147
  %.idx31 = mul nuw nsw i64 %45, 36
  %46 = getelementptr inbounds nuw i8, ptr %30, i64 %.idx31
  br label %47, !dbg !147

47:                                               ; preds = %.preheader39, %66
  %48 = phi i64 [ 0, %.preheader39 ], [ %67, %66 ]
  %49 = add nuw nsw i64 %34, %48, !dbg !147
  %.idx29 = mul nuw nsw i64 %49, 904
  %gep = getelementptr i8, ptr %gep43, i64 %.idx29
  %.idx32 = mul nuw nsw i64 %48, 12
  %50 = getelementptr inbounds nuw i8, ptr %46, i64 %.idx32
  br label %.preheader, !dbg !147

.preheader:                                       ; preds = %47, %64
  %51 = phi i64 [ 0, %47 ], [ %65, %64 ]
  %52 = getelementptr [4 x i8], ptr %gep, i64 %51
  %53 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %51
  %.promoted = load float, ptr %53, align 4
  br label %54, !dbg !147

54:                                               ; preds = %.preheader, %54
  %55 = phi i64 [ 0, %.preheader ], [ %63, %54 ]
  %56 = phi float [ %.promoted, %.preheader ], [ %62, %54 ]
  %57 = getelementptr [4 x i8], ptr %52, i64 %55, !dbg !147
  %58 = load float, ptr %57, align 4, !dbg !147
  %59 = getelementptr inbounds nuw [4 x i8], ptr %50, i64 %55, !dbg !147
  %60 = load float, ptr %59, align 4, !dbg !147
  %61 = fmul contract float %58, %60, !dbg !155
  %62 = fadd contract float %56, %61, !dbg !156
  %63 = add nuw nsw i64 %55, 1, !dbg !147
  %exitcond44.not = icmp eq i64 %63, 3, !dbg !147
  br i1 %exitcond44.not, label %64, label %54, !dbg !147

64:                                               ; preds = %54
  store float %62, ptr %53, align 4, !dbg !147
  %65 = add nuw nsw i64 %51, 1, !dbg !147
  %exitcond45.not = icmp eq i64 %65, 4, !dbg !147
  br i1 %exitcond45.not, label %66, label %.preheader, !dbg !147

66:                                               ; preds = %64
  %67 = add nuw nsw i64 %48, 1, !dbg !147
  %exitcond46.not = icmp eq i64 %67, 3, !dbg !147
  br i1 %exitcond46.not, label %68, label %47, !dbg !147

68:                                               ; preds = %66
  %69 = add nuw nsw i64 %45, 1, !dbg !147
  %exitcond47.not = icmp eq i64 %69, 64, !dbg !147
  br i1 %exitcond47.not, label %70, label %.preheader39, !dbg !147

70:                                               ; preds = %68
  %71 = load <4 x float>, ptr %4, align 64, !dbg !154
  %72 = fadd contract <4 x float> %31, %71, !dbg !157
  %73 = fcmp ogt <4 x float> %72, zeroinitializer, !dbg !158
  %74 = select <4 x i1> %73, <4 x float> zeroinitializer, <4 x float> %72, !dbg !159
  %75 = fmul contract <4 x float> %74, splat (float 0x3FC99999A0000000), !dbg !160
  %76 = fcmp olt <4 x float> %72, zeroinitializer, !dbg !161
  %77 = select <4 x i1> %76, <4 x float> zeroinitializer, <4 x float> %72, !dbg !162
  %78 = fadd contract <4 x float> %77, %75, !dbg !163
  %79 = getelementptr [4 x i8], ptr %35, i64 %38, !dbg !147
  store <4 x float> %78, ptr %79, align 16, !dbg !147
  %80 = add nuw nsw i64 %37, 4, !dbg !147
  %81 = icmp samesign ult i64 %37, 28, !dbg !147
  br i1 %81, label %36, label %82, !dbg !147

82:                                               ; preds = %70
  %83 = add nuw nsw i64 %33, 1, !dbg !147
  %exitcond48.not = icmp eq i64 %83, 32, !dbg !147
  br i1 %exitcond48.not, label %84, label %.preheader41, !dbg !147

84:                                               ; preds = %82
  %85 = add nuw nsw i64 %26, 1, !dbg !147
  %exitcond49.not = icmp eq i64 %85, 32, !dbg !147
  br i1 %exitcond49.not, label %86, label %25, !dbg !147

86:                                               ; preds = %84
  ret i32 0, !dbg !164
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_4_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !165 {
  %.elt17 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !166
  %.unpack18 = load ptr, ptr %.elt17, align 8, !dbg !166
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !166
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !166
  %4 = load i32, ptr %.unpack18, align 4, !dbg !166
  %5 = getelementptr i8, ptr %.unpack18, i64 4, !dbg !167
  %6 = load i32, ptr %5, align 4, !dbg !167
  %7 = load ptr, ptr %.unpack20, align 8, !dbg !168
  %8 = lshr i32 %4, 2, !dbg !168
  %9 = zext nneg i32 %8 to i64, !dbg !168
  %10 = getelementptr [4 x i8], ptr %7, i64 %9, !dbg !169
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !169
  %11 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !170
  %12 = load ptr, ptr %11, align 8, !dbg !170
  %13 = lshr i32 %6, 2, !dbg !170
  %14 = zext nneg i32 %13 to i64, !dbg !170
  %15 = getelementptr [4 x i8], ptr %12, i64 %14, !dbg !171
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !171
  %16 = load i32, ptr %2, align 16, !dbg !172
  %17 = zext i32 %16 to i64, !dbg !172
  %18 = lshr i64 %17, 2, !dbg !172
  %19 = and i64 %18, 3, !dbg !172
  %20 = and i64 %17, 3, !dbg !172
  %21 = shl nuw nsw i64 %17, 2, !dbg !172
  %22 = and i64 %21, 17179869120, !dbg !172
  %23 = mul nuw nsw i64 %19, 56, !dbg !172
  %24 = mul nuw nsw i64 %20, 56, !dbg !172
  br label %.preheader26, !dbg !172

.preheader26:                                     ; preds = %3, %44
  %25 = phi i64 [ 0, %3 ], [ %45, %44 ]
  %26 = add nuw nsw i64 %25, %22
  %.idx = mul nuw nsw i64 %26, 200704
  %27 = getelementptr i8, ptr %10, i64 %.idx
  %.idx24 = mul nuw nsw i64 %26, 204304
  %28 = getelementptr i8, ptr %15, i64 %.idx24
  br label %.preheader, !dbg !172

.preheader:                                       ; preds = %.preheader26, %42
  %29 = phi i64 [ 0, %.preheader26 ], [ %43, %42 ]
  %30 = add nuw nsw i64 %29, %23
  %.idx23 = mul nuw nsw i64 %30, 896
  %31 = getelementptr i8, ptr %27, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %30, 904
  %32 = getelementptr i8, ptr %28, i64 %.idx25
  %33 = getelementptr i8, ptr %32, i64 908
  br label %34, !dbg !172

34:                                               ; preds = %.preheader, %34
  %35 = phi i64 [ 0, %.preheader ], [ %40, %34 ]
  %36 = add nuw nsw i64 %35, %24, !dbg !172
  %37 = getelementptr [4 x i8], ptr %31, i64 %36, !dbg !172
  %38 = load <4 x float>, ptr %37, align 16, !dbg !172
  %39 = getelementptr [4 x i8], ptr %33, i64 %36, !dbg !172
  store <4 x float> %38, ptr %39, align 4, !dbg !172
  %40 = add nuw nsw i64 %35, 4, !dbg !172
  %41 = icmp samesign ult i64 %35, 52, !dbg !172
  br i1 %41, label %34, label %42, !dbg !172

42:                                               ; preds = %34
  %43 = add nuw nsw i64 %29, 1, !dbg !172
  %exitcond.not = icmp eq i64 %43, 56, !dbg !172
  br i1 %exitcond.not, label %44, label %.preheader, !dbg !172

44:                                               ; preds = %42
  %45 = add nuw nsw i64 %25, 1, !dbg !172
  %exitcond27.not = icmp eq i64 %45, 64, !dbg !172
  br i1 %exitcond27.not, label %46, label %.preheader26, !dbg !172

46:                                               ; preds = %44
  ret i32 0, !dbg !173
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_5_conv_128x224x224x128x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !174 {
  %4 = alloca [4 x float], align 64, !dbg !175
  %5 = alloca [4 x float], align 64, !dbg !176
  %.elt21 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !177
  %.unpack22 = load ptr, ptr %.elt21, align 8, !dbg !177
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !177
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !177
  %6 = load i32, ptr %.unpack22, align 4, !dbg !177
  %7 = getelementptr i8, ptr %.unpack22, i64 4, !dbg !178
  %8 = load i32, ptr %7, align 4, !dbg !178
  %9 = getelementptr i8, ptr %.unpack22, i64 8, !dbg !179
  %10 = load i32, ptr %9, align 4, !dbg !179
  %11 = getelementptr i8, ptr %.unpack22, i64 12, !dbg !180
  %12 = load i32, ptr %11, align 4, !dbg !180
  %13 = load ptr, ptr %.unpack24, align 8, !dbg !181
  %14 = lshr i32 %6, 2, !dbg !181
  %15 = zext nneg i32 %14 to i64, !dbg !181
  %16 = getelementptr [4 x i8], ptr %13, i64 %15, !dbg !181
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !181
  %17 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !182
  %18 = load ptr, ptr %17, align 8, !dbg !182
  %19 = lshr i32 %8, 2, !dbg !182
  %20 = zext nneg i32 %19 to i64, !dbg !182
  %21 = getelementptr [4 x i8], ptr %18, i64 %20, !dbg !182
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !182
  %22 = lshr i32 %10, 2, !dbg !183
  %23 = zext nneg i32 %22 to i64, !dbg !183
  %24 = getelementptr [4 x i8], ptr %18, i64 %23, !dbg !183
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !183
  %25 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !184
  %26 = load ptr, ptr %25, align 8, !dbg !184
  %27 = lshr i32 %12, 2, !dbg !184
  %28 = zext nneg i32 %27 to i64, !dbg !184
  %29 = getelementptr [4 x i8], ptr %26, i64 %28, !dbg !184
  call void @llvm.assume(i1 true) [ "align"(ptr %29, i64 64) ], !dbg !184
  %30 = load i32, ptr %2, align 16, !dbg !175
  %.frozen = freeze i32 %30, !dbg !175
  %31 = udiv i32 %.frozen, 49, !dbg !175
  %32 = mul i32 %31, 49, !dbg !175
  %.decomposed = sub i32 %.frozen, %32, !dbg !175
  %.lhs.trunc35 = trunc nuw nsw i32 %.decomposed to i8, !dbg !175
  %33 = udiv i8 %.lhs.trunc35, 7, !dbg !175
  %.zext36 = zext nneg i8 %33 to i64, !dbg !175
  %34 = urem i32 %30, 7, !dbg !175
  %35 = shl nuw i32 %31, 5, !dbg !175
  %36 = zext i32 %35 to i64, !dbg !175
  %37 = shl nuw nsw i64 %.zext36, 5, !dbg !175
  %38 = shl nuw nsw i32 %34, 5, !dbg !175
  %39 = zext nneg i32 %38 to i64, !dbg !175
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !185
  br label %40, !dbg !175

40:                                               ; preds = %3, %100
  %41 = phi i64 [ 0, %3 ], [ %101, %100 ]
  %42 = or disjoint i64 %41, %36, !dbg !175
  %43 = getelementptr [4 x i8], ptr %24, i64 %42, !dbg !186
  %44 = load <1 x float>, ptr %43, align 4, !dbg !186
  %.idx30 = mul nuw nsw i64 %42, 4608
  %45 = getelementptr inbounds nuw i8, ptr %21, i64 %.idx30
  %46 = shufflevector <1 x float> %44, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %42, 204304
  %47 = getelementptr i8, ptr %29, i64 %.idx
  br label %.preheader41, !dbg !175

.preheader41:                                     ; preds = %40, %98
  %48 = phi i64 [ 0, %40 ], [ %99, %98 ]
  %49 = add nuw nsw i64 %48, %37
  %.idx27 = mul nuw nsw i64 %49, 904
  %50 = getelementptr i8, ptr %47, i64 %.idx27
  %51 = getelementptr i8, ptr %50, i64 908
  br label %52, !dbg !175

52:                                               ; preds = %.preheader41, %86
  %53 = phi i64 [ 0, %.preheader41 ], [ %96, %86 ]
  br label %55, !dbg !175

.preheader40:                                     ; preds = %55
  %54 = or disjoint i64 %53, %39, !dbg !175
  %invariant.gep42 = getelementptr [4 x i8], ptr %16, i64 %54, !dbg !175
  br label %.preheader39, !dbg !175

55:                                               ; preds = %52, %55
  %56 = phi i64 [ 0, %52 ], [ %60, %55 ]
  %57 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %56, !dbg !175
  %58 = load float, ptr %57, align 4, !dbg !175
  %59 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %56, !dbg !175
  store float %58, ptr %59, align 4, !dbg !175
  %60 = add nuw nsw i64 %56, 1, !dbg !175
  %exitcond.not = icmp eq i64 %60, 4, !dbg !175
  br i1 %exitcond.not, label %.preheader40, label %55, !dbg !175

.preheader39:                                     ; preds = %.preheader40, %84
  %61 = phi i64 [ 0, %.preheader40 ], [ %85, %84 ]
  %.idx28 = mul nuw nsw i64 %61, 204304
  %gep43 = getelementptr i8, ptr %invariant.gep42, i64 %.idx28, !dbg !175
  %.idx31 = mul nuw nsw i64 %61, 36
  %62 = getelementptr inbounds nuw i8, ptr %45, i64 %.idx31
  br label %63, !dbg !175

63:                                               ; preds = %.preheader39, %82
  %64 = phi i64 [ 0, %.preheader39 ], [ %83, %82 ]
  %65 = add nuw nsw i64 %49, %64, !dbg !175
  %.idx29 = mul nuw nsw i64 %65, 904
  %gep = getelementptr i8, ptr %gep43, i64 %.idx29
  %.idx32 = mul nuw nsw i64 %64, 12
  %66 = getelementptr inbounds nuw i8, ptr %62, i64 %.idx32
  br label %.preheader, !dbg !175

.preheader:                                       ; preds = %63, %80
  %67 = phi i64 [ 0, %63 ], [ %81, %80 ]
  %68 = getelementptr [4 x i8], ptr %gep, i64 %67
  %69 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %67
  %.promoted = load float, ptr %69, align 4
  br label %70, !dbg !175

70:                                               ; preds = %.preheader, %70
  %71 = phi i64 [ 0, %.preheader ], [ %79, %70 ]
  %72 = phi float [ %.promoted, %.preheader ], [ %78, %70 ]
  %73 = getelementptr [4 x i8], ptr %68, i64 %71, !dbg !175
  %74 = load float, ptr %73, align 4, !dbg !175
  %75 = getelementptr inbounds nuw [4 x i8], ptr %66, i64 %71, !dbg !175
  %76 = load float, ptr %75, align 4, !dbg !175
  %77 = fmul contract float %74, %76, !dbg !187
  %78 = fadd contract float %72, %77, !dbg !188
  %79 = add nuw nsw i64 %71, 1, !dbg !175
  %exitcond44.not = icmp eq i64 %79, 3, !dbg !175
  br i1 %exitcond44.not, label %80, label %70, !dbg !175

80:                                               ; preds = %70
  store float %78, ptr %69, align 4, !dbg !175
  %81 = add nuw nsw i64 %67, 1, !dbg !175
  %exitcond45.not = icmp eq i64 %81, 4, !dbg !175
  br i1 %exitcond45.not, label %82, label %.preheader, !dbg !175

82:                                               ; preds = %80
  %83 = add nuw nsw i64 %64, 1, !dbg !175
  %exitcond46.not = icmp eq i64 %83, 3, !dbg !175
  br i1 %exitcond46.not, label %84, label %63, !dbg !175

84:                                               ; preds = %82
  %85 = add nuw nsw i64 %61, 1, !dbg !175
  %exitcond47.not = icmp eq i64 %85, 128, !dbg !175
  br i1 %exitcond47.not, label %86, label %.preheader39, !dbg !175

86:                                               ; preds = %84
  %87 = load <4 x float>, ptr %4, align 64, !dbg !186
  %88 = fadd contract <4 x float> %46, %87, !dbg !189
  %89 = fcmp ogt <4 x float> %88, zeroinitializer, !dbg !190
  %90 = select <4 x i1> %89, <4 x float> zeroinitializer, <4 x float> %88, !dbg !191
  %91 = fmul contract <4 x float> %90, splat (float 0x3FC99999A0000000), !dbg !192
  %92 = fcmp olt <4 x float> %88, zeroinitializer, !dbg !193
  %93 = select <4 x i1> %92, <4 x float> zeroinitializer, <4 x float> %88, !dbg !194
  %94 = fadd contract <4 x float> %93, %91, !dbg !195
  %95 = getelementptr [4 x i8], ptr %51, i64 %54, !dbg !175
  store <4 x float> %94, ptr %95, align 4, !dbg !175
  %96 = add nuw nsw i64 %53, 4, !dbg !175
  %97 = icmp samesign ult i64 %53, 28, !dbg !175
  br i1 %97, label %52, label %98, !dbg !175

98:                                               ; preds = %86
  %99 = add nuw nsw i64 %48, 1, !dbg !175
  %exitcond48.not = icmp eq i64 %99, 32, !dbg !175
  br i1 %exitcond48.not, label %100, label %.preheader41, !dbg !175

100:                                              ; preds = %98
  %101 = add nuw nsw i64 %41, 1, !dbg !175
  %exitcond49.not = icmp eq i64 %101, 32, !dbg !175
  br i1 %exitcond49.not, label %102, label %40, !dbg !175

102:                                              ; preds = %100
  ret i32 0, !dbg !196
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_6_conv_128x224x224x128x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !197 {
  %4 = alloca [4 x float], align 64, !dbg !198
  %5 = alloca [4 x float], align 64, !dbg !199
  %.elt21 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !200
  %.unpack22 = load ptr, ptr %.elt21, align 8, !dbg !200
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !200
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !200
  %6 = load i32, ptr %.unpack22, align 4, !dbg !200
  %7 = getelementptr i8, ptr %.unpack22, i64 4, !dbg !201
  %8 = load i32, ptr %7, align 4, !dbg !201
  %9 = getelementptr i8, ptr %.unpack22, i64 8, !dbg !202
  %10 = load i32, ptr %9, align 4, !dbg !202
  %11 = getelementptr i8, ptr %.unpack22, i64 12, !dbg !203
  %12 = load i32, ptr %11, align 4, !dbg !203
  %13 = getelementptr i8, ptr %.unpack22, i64 16, !dbg !204
  %14 = load i32, ptr %13, align 4, !dbg !204
  %15 = load ptr, ptr %.unpack24, align 8, !dbg !205
  %16 = lshr i32 %6, 2, !dbg !205
  %17 = zext nneg i32 %16 to i64, !dbg !205
  %18 = getelementptr [4 x i8], ptr %15, i64 %17, !dbg !205
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !205
  %19 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !206
  %20 = load ptr, ptr %19, align 8, !dbg !206
  %21 = lshr i32 %10, 2, !dbg !206
  %22 = zext nneg i32 %21 to i64, !dbg !206
  %23 = getelementptr [4 x i8], ptr %20, i64 %22, !dbg !206
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !206
  %24 = lshr i32 %8, 2, !dbg !207
  %25 = zext nneg i32 %24 to i64, !dbg !207
  %26 = getelementptr [4 x i8], ptr %15, i64 %25, !dbg !207
  call void @llvm.assume(i1 true) [ "align"(ptr %26, i64 64) ], !dbg !207
  %27 = lshr i32 %12, 2, !dbg !208
  %28 = zext nneg i32 %27 to i64, !dbg !208
  %29 = getelementptr [4 x i8], ptr %20, i64 %28, !dbg !208
  call void @llvm.assume(i1 true) [ "align"(ptr %29, i64 64) ], !dbg !208
  %30 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !209
  %31 = load ptr, ptr %30, align 8, !dbg !209
  %32 = lshr i32 %14, 2, !dbg !209
  %33 = zext nneg i32 %32 to i64, !dbg !209
  %34 = getelementptr [4 x i8], ptr %31, i64 %33, !dbg !209
  call void @llvm.assume(i1 true) [ "align"(ptr %34, i64 64) ], !dbg !209
  %35 = load i32, ptr %2, align 16, !dbg !198
  %.frozen = freeze i32 %35, !dbg !198
  %36 = udiv i32 %.frozen, 49, !dbg !198
  %37 = mul i32 %36, 49, !dbg !198
  %.decomposed = sub i32 %.frozen, %37, !dbg !198
  %.lhs.trunc33 = trunc nuw nsw i32 %.decomposed to i8, !dbg !198
  %38 = udiv i8 %.lhs.trunc33, 7, !dbg !198
  %.zext34 = zext nneg i8 %38 to i64, !dbg !198
  %39 = urem i32 %35, 7, !dbg !198
  %40 = shl nuw i32 %36, 5, !dbg !198
  %41 = zext i32 %40 to i64, !dbg !198
  %42 = shl nuw nsw i64 %.zext34, 5, !dbg !198
  %43 = shl nuw nsw i32 %39, 5, !dbg !198
  %44 = zext nneg i32 %43 to i64, !dbg !198
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !210
  br label %45, !dbg !198

45:                                               ; preds = %3, %109
  %46 = phi i64 [ 0, %3 ], [ %110, %109 ]
  %47 = or disjoint i64 %46, %41, !dbg !198
  %48 = getelementptr [4 x i8], ptr %29, i64 %47, !dbg !211
  %49 = load <1 x float>, ptr %48, align 4, !dbg !211
  %.idx28 = mul nuw nsw i64 %47, 4608
  %50 = getelementptr inbounds nuw i8, ptr %23, i64 %.idx28
  %51 = mul nuw nsw i64 %47, 50176
  %52 = shufflevector <1 x float> %49, <1 x float> poison, <4 x i32> zeroinitializer
  br label %.preheader39, !dbg !198

.preheader39:                                     ; preds = %45, %107
  %53 = phi i64 [ 0, %45 ], [ %108, %107 ]
  %54 = add nuw nsw i64 %53, %42
  %55 = mul nuw nsw i64 %54, 224
  %56 = add nuw i64 %55, %51
  br label %57, !dbg !198

57:                                               ; preds = %.preheader39, %91
  %58 = phi i64 [ 0, %.preheader39 ], [ %105, %91 ]
  br label %60, !dbg !198

.preheader38:                                     ; preds = %60
  %59 = or disjoint i64 %58, %44, !dbg !198
  %invariant.gep40 = getelementptr [4 x i8], ptr %18, i64 %59, !dbg !198
  br label %.preheader37, !dbg !198

60:                                               ; preds = %57, %60
  %61 = phi i64 [ 0, %57 ], [ %65, %60 ]
  %62 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %61, !dbg !198
  %63 = load float, ptr %62, align 4, !dbg !198
  %64 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %61, !dbg !198
  store float %63, ptr %64, align 4, !dbg !198
  %65 = add nuw nsw i64 %61, 1, !dbg !198
  %exitcond.not = icmp eq i64 %65, 4, !dbg !198
  br i1 %exitcond.not, label %.preheader38, label %60, !dbg !198

.preheader37:                                     ; preds = %.preheader38, %89
  %66 = phi i64 [ 0, %.preheader38 ], [ %90, %89 ]
  %.idx = mul nuw nsw i64 %66, 204304
  %gep41 = getelementptr i8, ptr %invariant.gep40, i64 %.idx, !dbg !198
  %.idx29 = mul nuw nsw i64 %66, 36
  %67 = getelementptr inbounds nuw i8, ptr %50, i64 %.idx29
  br label %68, !dbg !198

68:                                               ; preds = %.preheader37, %87
  %69 = phi i64 [ 0, %.preheader37 ], [ %88, %87 ]
  %70 = add nuw nsw i64 %54, %69, !dbg !198
  %.idx27 = mul nuw nsw i64 %70, 904
  %gep = getelementptr i8, ptr %gep41, i64 %.idx27
  %.idx30 = mul nuw nsw i64 %69, 12
  %71 = getelementptr inbounds nuw i8, ptr %67, i64 %.idx30
  br label %.preheader, !dbg !198

.preheader:                                       ; preds = %68, %85
  %72 = phi i64 [ 0, %68 ], [ %86, %85 ]
  %73 = getelementptr [4 x i8], ptr %gep, i64 %72
  %74 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %72
  %.promoted = load float, ptr %74, align 4
  br label %75, !dbg !198

75:                                               ; preds = %.preheader, %75
  %76 = phi i64 [ 0, %.preheader ], [ %84, %75 ]
  %77 = phi float [ %.promoted, %.preheader ], [ %83, %75 ]
  %78 = getelementptr [4 x i8], ptr %73, i64 %76, !dbg !198
  %79 = load float, ptr %78, align 4, !dbg !198
  %80 = getelementptr inbounds nuw [4 x i8], ptr %71, i64 %76, !dbg !198
  %81 = load float, ptr %80, align 4, !dbg !198
  %82 = fmul contract float %79, %81, !dbg !212
  %83 = fadd contract float %77, %82, !dbg !213
  %84 = add nuw nsw i64 %76, 1, !dbg !198
  %exitcond42.not = icmp eq i64 %84, 3, !dbg !198
  br i1 %exitcond42.not, label %85, label %75, !dbg !198

85:                                               ; preds = %75
  store float %83, ptr %74, align 4, !dbg !198
  %86 = add nuw nsw i64 %72, 1, !dbg !198
  %exitcond43.not = icmp eq i64 %86, 4, !dbg !198
  br i1 %exitcond43.not, label %87, label %.preheader, !dbg !198

87:                                               ; preds = %85
  %88 = add nuw nsw i64 %69, 1, !dbg !198
  %exitcond44.not = icmp eq i64 %88, 3, !dbg !198
  br i1 %exitcond44.not, label %89, label %68, !dbg !198

89:                                               ; preds = %87
  %90 = add nuw nsw i64 %66, 1, !dbg !198
  %exitcond45.not = icmp eq i64 %90, 128, !dbg !198
  br i1 %exitcond45.not, label %91, label %.preheader37, !dbg !198

91:                                               ; preds = %89
  %92 = add i64 %56, %59, !dbg !211
  %93 = getelementptr [4 x i8], ptr %26, i64 %92, !dbg !211
  %94 = load <4 x float>, ptr %93, align 16, !dbg !211
  %95 = load <4 x float>, ptr %4, align 64, !dbg !211
  %96 = fadd contract <4 x float> %52, %95, !dbg !214
  %97 = fcmp ogt <4 x float> %96, zeroinitializer, !dbg !215
  %98 = select <4 x i1> %97, <4 x float> zeroinitializer, <4 x float> %96, !dbg !216
  %99 = fmul contract <4 x float> %98, splat (float 0x3FC99999A0000000), !dbg !217
  %100 = fcmp olt <4 x float> %96, zeroinitializer, !dbg !218
  %101 = select <4 x i1> %100, <4 x float> zeroinitializer, <4 x float> %96, !dbg !219
  %102 = fadd contract <4 x float> %101, %99, !dbg !220
  %103 = fadd contract <4 x float> %94, %102, !dbg !221
  %104 = getelementptr [4 x i8], ptr %34, i64 %92, !dbg !198
  store <4 x float> %103, ptr %104, align 16, !dbg !198
  %105 = add nuw nsw i64 %58, 4, !dbg !198
  %106 = icmp samesign ult i64 %58, 28, !dbg !198
  br i1 %106, label %57, label %107, !dbg !198

107:                                              ; preds = %91
  %108 = add nuw nsw i64 %53, 1, !dbg !198
  %exitcond46.not = icmp eq i64 %108, 32, !dbg !198
  br i1 %exitcond46.not, label %109, label %.preheader39, !dbg !198

109:                                              ; preds = %107
  %110 = add nuw nsw i64 %46, 1, !dbg !198
  %exitcond47.not = icmp eq i64 %110, 32, !dbg !198
  br i1 %exitcond47.not, label %111, label %45, !dbg !198

111:                                              ; preds = %109
  ret i32 0, !dbg !222
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_13_elementwise_broadcast_128x112x112_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !223 {
  %.elt21 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !224
  %.unpack22 = load ptr, ptr %.elt21, align 16, !dbg !224
  %4 = load ptr, ptr %.unpack22, align 8, !dbg !224
  %5 = getelementptr i8, ptr %4, i64 58263552, !dbg !224
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !224
  %6 = getelementptr i8, ptr %.unpack22, i64 8, !dbg !225
  %7 = load ptr, ptr %6, align 8, !dbg !225
  %8 = getelementptr i8, ptr %7, i64 83953664, !dbg !225
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !225
  %9 = load i32, ptr %2, align 16, !dbg !226
  %10 = zext i32 %9 to i64, !dbg !226
  %11 = shl nuw nsw i64 %10, 3, !dbg !226
  %12 = and i64 %11, 34359738336, !dbg !226
  %13 = and i64 %10, 2, !dbg !226
  %.not = icmp eq i64 %13, 0, !dbg !226
  %14 = select i1 %.not, i64 0, i64 56, !dbg !226
  %15 = trunc i32 %9 to i1, !dbg !226
  %16 = select i1 %15, i64 56, i64 0, !dbg !226
  br label %17, !dbg !226

17:                                               ; preds = %3, %463
  %18 = phi i64 [ 0, %3 ], [ %464, %463 ]
  %19 = or disjoint i64 %18, %12, !dbg !227
  %20 = mul nuw nsw i64 %19, 224, !dbg !228
  %.idx60 = mul nuw nsw i64 %19, 51984
  %21 = getelementptr i8, ptr %8, i64 %.idx60
  br label %22, !dbg !226

22:                                               ; preds = %17, %461
  %23 = phi i64 [ 0, %17 ], [ %462, %461 ]
  %24 = add nuw nsw i64 %23, %14, !dbg !229
  %25 = uitofp nneg i64 %24 to float, !dbg !230
  %26 = fadd nnan contract float %25, 5.000000e-01, !dbg !231
  %27 = fmul nnan float %26, 2.000000e+00, !dbg !232
  %28 = fadd contract float %27, -5.000000e-01, !dbg !233
  %.inv = fcmp ole float %28, 0.000000e+00, !dbg !234
  %29 = select i1 %.inv, float 0.000000e+00, float %28, !dbg !234
  %.inv25 = fcmp oge float %29, 2.230000e+02, !dbg !235
  %30 = select i1 %.inv25, float 2.230000e+02, float %29, !dbg !235
  %31 = tail call float @llvm.floor.f32(float %30), !dbg !236
  %32 = fadd contract float %30, 1.000000e+00, !dbg !237
  %33 = tail call float @llvm.floor.f32(float %32), !dbg !238
  %34 = fptosi float %31 to i64, !dbg !239
  %.inv26 = fcmp oge float %32, 2.230000e+02, !dbg !240
  %35 = select i1 %.inv26, float 2.230000e+02, float %32, !dbg !240
  %36 = fptosi float %35 to i64, !dbg !241
  %37 = add i64 %20, %34, !dbg !228
  %38 = mul i64 %37, 224, !dbg !228
  %39 = add i64 %20, %36, !dbg !242
  %40 = mul i64 %39, 224, !dbg !242
  %41 = fsub contract float %33, %30, !dbg !243
  %42 = fsub contract float %30, %31, !dbg !244
  %43 = insertelement <4 x i64> poison, i64 %38, i64 0
  %44 = shufflevector <4 x i64> %43, <4 x i64> poison, <4 x i32> zeroinitializer
  %45 = insertelement <4 x i64> poison, i64 %40, i64 0
  %46 = shufflevector <4 x i64> %45, <4 x i64> poison, <4 x i32> zeroinitializer
  %47 = insertelement <4 x float> poison, float %41, i64 0
  %48 = shufflevector <4 x float> %47, <4 x float> poison, <4 x i32> zeroinitializer
  %49 = insertelement <4 x float> poison, float %42, i64 0
  %50 = shufflevector <4 x float> %49, <4 x float> poison, <4 x i32> zeroinitializer
  %.idx61 = mul nuw nsw i64 %24, 456
  %51 = getelementptr i8, ptr %21, i64 %.idx61
  %52 = getelementptr i8, ptr %51, i64 460
  br label %53, !dbg !226

53:                                               ; preds = %22, %53
  %54 = phi i64 [ 0, %22 ], [ %459, %53 ]
  %55 = add nuw nsw i64 %54, %16, !dbg !245
  %56 = insertelement <4 x i64> poison, i64 %55, i64 0, !dbg !226
  %57 = shufflevector <4 x i64> %56, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !226
  %58 = or disjoint <4 x i64> %57, <i64 0, i64 1, i64 2, i64 3>, !dbg !245
  %59 = uitofp nneg <4 x i64> %58 to <4 x float>, !dbg !246
  %60 = fadd nnan contract <4 x float> %59, splat (float 5.000000e-01), !dbg !247
  %61 = fmul nnan <4 x float> %60, splat (float 2.000000e+00), !dbg !248
  %62 = fadd contract <4 x float> %61, splat (float -5.000000e-01), !dbg !249
  %.inv27 = fcmp ole <4 x float> %62, zeroinitializer, !dbg !250
  %63 = select <4 x i1> %.inv27, <4 x float> zeroinitializer, <4 x float> %62, !dbg !250
  %.inv28 = fcmp oge <4 x float> %63, splat (float 2.230000e+02), !dbg !251
  %64 = select <4 x i1> %.inv28, <4 x float> splat (float 2.230000e+02), <4 x float> %63, !dbg !251
  %65 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %64), !dbg !252
  %66 = fadd contract <4 x float> %64, splat (float 1.000000e+00), !dbg !253
  %67 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %66), !dbg !254
  %68 = fptosi <4 x float> %65 to <4 x i64>, !dbg !255
  %.inv29 = fcmp oge <4 x float> %66, splat (float 2.230000e+02), !dbg !256
  %69 = select <4 x i1> %.inv29, <4 x float> splat (float 2.230000e+02), <4 x float> %66, !dbg !256
  %70 = fptosi <4 x float> %69 to <4 x i64>, !dbg !257
  %71 = add <4 x i64> %44, %68, !dbg !228
  %72 = extractelement <4 x i64> %71, i64 0, !dbg !228
  %.frozen = freeze i64 %72, !dbg !228
  %73 = sdiv i64 %.frozen, 50176, !dbg !228
  %74 = mul nsw i64 %73, 50176, !dbg !228
  %75 = icmp ne i64 %72, %74, !dbg !228
  %76 = icmp slt i64 %72, 0, !dbg !228
  %77 = and i1 %76, %75, !dbg !228
  %78 = sext i1 %77 to i64, !dbg !228
  %79 = add nsw i64 %73, %78, !dbg !228
  %80 = mul i64 %73, 50176, !dbg !228
  %.decomposed = sub i64 %.frozen, %80, !dbg !228
  %81 = icmp slt i64 %.decomposed, 0, !dbg !228
  %82 = add nsw i64 %.decomposed, 50176, !dbg !228
  %83 = select i1 %81, i64 %82, i64 %.decomposed, !dbg !228
  %84 = srem i64 %72, 224, !dbg !228
  %85 = icmp slt i64 %84, 0, !dbg !228
  %86 = add nsw i64 %84, 224, !dbg !228
  %87 = select i1 %85, i64 %86, i64 %84, !dbg !228
  %.fr = freeze i64 %83, !dbg !228
  %88 = srem i64 %.fr, 224, !dbg !228
  %89 = sub nsw i64 %.fr, %88, !dbg !228
  %.idx = mul i64 %79, 200704, !dbg !228
  %90 = getelementptr i8, ptr %5, i64 %.idx, !dbg !228
  %91 = getelementptr [4 x i8], ptr %90, i64 %89, !dbg !228
  %92 = getelementptr [4 x i8], ptr %91, i64 %87, !dbg !228
  %93 = load <1 x float>, ptr %92, align 4, !dbg !228
  %94 = extractelement <4 x i64> %71, i64 1, !dbg !228
  %.frozen64 = freeze i64 %94, !dbg !228
  %95 = sdiv i64 %.frozen64, 50176, !dbg !228
  %96 = mul nsw i64 %95, 50176, !dbg !228
  %97 = icmp ne i64 %94, %96, !dbg !228
  %98 = icmp slt i64 %94, 0, !dbg !228
  %99 = and i1 %98, %97, !dbg !228
  %100 = sext i1 %99 to i64, !dbg !228
  %101 = add nsw i64 %95, %100, !dbg !228
  %102 = mul i64 %95, 50176, !dbg !228
  %.decomposed65 = sub i64 %.frozen64, %102, !dbg !228
  %103 = icmp slt i64 %.decomposed65, 0, !dbg !228
  %104 = add nsw i64 %.decomposed65, 50176, !dbg !228
  %105 = select i1 %103, i64 %104, i64 %.decomposed65, !dbg !228
  %106 = srem i64 %94, 224, !dbg !228
  %107 = icmp slt i64 %106, 0, !dbg !228
  %108 = add nsw i64 %106, 224, !dbg !228
  %109 = select i1 %107, i64 %108, i64 %106, !dbg !228
  %.fr30 = freeze i64 %105, !dbg !228
  %110 = srem i64 %.fr30, 224, !dbg !228
  %111 = sub nsw i64 %.fr30, %110, !dbg !228
  %.idx31 = mul i64 %101, 200704, !dbg !228
  %112 = getelementptr i8, ptr %5, i64 %.idx31, !dbg !228
  %113 = getelementptr [4 x i8], ptr %112, i64 %111, !dbg !228
  %114 = getelementptr [4 x i8], ptr %113, i64 %109, !dbg !228
  %115 = load <1 x float>, ptr %114, align 4, !dbg !228
  %116 = extractelement <4 x i64> %71, i64 2, !dbg !228
  %.frozen66 = freeze i64 %116, !dbg !228
  %117 = sdiv i64 %.frozen66, 50176, !dbg !228
  %118 = mul nsw i64 %117, 50176, !dbg !228
  %119 = icmp ne i64 %116, %118, !dbg !228
  %120 = icmp slt i64 %116, 0, !dbg !228
  %121 = and i1 %120, %119, !dbg !228
  %122 = sext i1 %121 to i64, !dbg !228
  %123 = add nsw i64 %117, %122, !dbg !228
  %124 = mul i64 %117, 50176, !dbg !228
  %.decomposed67 = sub i64 %.frozen66, %124, !dbg !228
  %125 = icmp slt i64 %.decomposed67, 0, !dbg !228
  %126 = add nsw i64 %.decomposed67, 50176, !dbg !228
  %127 = select i1 %125, i64 %126, i64 %.decomposed67, !dbg !228
  %128 = srem i64 %116, 224, !dbg !228
  %129 = icmp slt i64 %128, 0, !dbg !228
  %130 = add nsw i64 %128, 224, !dbg !228
  %131 = select i1 %129, i64 %130, i64 %128, !dbg !228
  %.fr32 = freeze i64 %127, !dbg !228
  %132 = srem i64 %.fr32, 224, !dbg !228
  %133 = sub nsw i64 %.fr32, %132, !dbg !228
  %.idx33 = mul i64 %123, 200704, !dbg !228
  %134 = getelementptr i8, ptr %5, i64 %.idx33, !dbg !228
  %135 = getelementptr [4 x i8], ptr %134, i64 %133, !dbg !228
  %136 = getelementptr [4 x i8], ptr %135, i64 %131, !dbg !228
  %137 = load <1 x float>, ptr %136, align 4, !dbg !228
  %138 = shufflevector <1 x float> %137, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %139 = extractelement <4 x i64> %71, i64 3, !dbg !228
  %.frozen68 = freeze i64 %139, !dbg !228
  %140 = sdiv i64 %.frozen68, 50176, !dbg !228
  %141 = mul nsw i64 %140, 50176, !dbg !228
  %142 = icmp ne i64 %139, %141, !dbg !228
  %143 = icmp slt i64 %139, 0, !dbg !228
  %144 = and i1 %143, %142, !dbg !228
  %145 = sext i1 %144 to i64, !dbg !228
  %146 = add nsw i64 %140, %145, !dbg !228
  %147 = mul i64 %140, 50176, !dbg !228
  %.decomposed69 = sub i64 %.frozen68, %147, !dbg !228
  %148 = icmp slt i64 %.decomposed69, 0, !dbg !228
  %149 = add nsw i64 %.decomposed69, 50176, !dbg !228
  %150 = select i1 %148, i64 %149, i64 %.decomposed69, !dbg !228
  %151 = srem i64 %139, 224, !dbg !228
  %152 = icmp slt i64 %151, 0, !dbg !228
  %153 = add nsw i64 %151, 224, !dbg !228
  %154 = select i1 %152, i64 %153, i64 %151, !dbg !228
  %.fr34 = freeze i64 %150, !dbg !228
  %155 = srem i64 %.fr34, 224, !dbg !228
  %156 = sub nsw i64 %.fr34, %155, !dbg !228
  %.idx35 = mul i64 %146, 200704, !dbg !228
  %157 = getelementptr i8, ptr %5, i64 %.idx35, !dbg !228
  %158 = getelementptr [4 x i8], ptr %157, i64 %156, !dbg !228
  %159 = getelementptr [4 x i8], ptr %158, i64 %154, !dbg !228
  %160 = load <1 x float>, ptr %159, align 4, !dbg !228
  %161 = shufflevector <1 x float> %160, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %162 = add <4 x i64> %44, %70, !dbg !258
  %163 = extractelement <4 x i64> %162, i64 0, !dbg !258
  %.frozen70 = freeze i64 %163, !dbg !258
  %164 = sdiv i64 %.frozen70, 50176, !dbg !258
  %165 = mul nsw i64 %164, 50176, !dbg !258
  %166 = icmp ne i64 %163, %165, !dbg !258
  %167 = icmp slt i64 %163, 0, !dbg !258
  %168 = and i1 %167, %166, !dbg !258
  %169 = sext i1 %168 to i64, !dbg !258
  %170 = add nsw i64 %164, %169, !dbg !258
  %171 = mul i64 %164, 50176, !dbg !258
  %.decomposed71 = sub i64 %.frozen70, %171, !dbg !258
  %172 = icmp slt i64 %.decomposed71, 0, !dbg !258
  %173 = add nsw i64 %.decomposed71, 50176, !dbg !258
  %174 = select i1 %172, i64 %173, i64 %.decomposed71, !dbg !258
  %175 = srem i64 %163, 224, !dbg !258
  %176 = icmp slt i64 %175, 0, !dbg !258
  %177 = add nsw i64 %175, 224, !dbg !258
  %178 = select i1 %176, i64 %177, i64 %175, !dbg !258
  %.fr36 = freeze i64 %174, !dbg !258
  %179 = srem i64 %.fr36, 224, !dbg !258
  %180 = sub nsw i64 %.fr36, %179, !dbg !258
  %.idx37 = mul i64 %170, 200704, !dbg !258
  %181 = getelementptr i8, ptr %5, i64 %.idx37, !dbg !258
  %182 = getelementptr [4 x i8], ptr %181, i64 %180, !dbg !258
  %183 = getelementptr [4 x i8], ptr %182, i64 %178, !dbg !258
  %184 = load <1 x float>, ptr %183, align 4, !dbg !258
  %185 = extractelement <4 x i64> %162, i64 1, !dbg !258
  %.frozen72 = freeze i64 %185, !dbg !258
  %186 = sdiv i64 %.frozen72, 50176, !dbg !258
  %187 = mul nsw i64 %186, 50176, !dbg !258
  %188 = icmp ne i64 %185, %187, !dbg !258
  %189 = icmp slt i64 %185, 0, !dbg !258
  %190 = and i1 %189, %188, !dbg !258
  %191 = sext i1 %190 to i64, !dbg !258
  %192 = add nsw i64 %186, %191, !dbg !258
  %193 = mul i64 %186, 50176, !dbg !258
  %.decomposed73 = sub i64 %.frozen72, %193, !dbg !258
  %194 = icmp slt i64 %.decomposed73, 0, !dbg !258
  %195 = add nsw i64 %.decomposed73, 50176, !dbg !258
  %196 = select i1 %194, i64 %195, i64 %.decomposed73, !dbg !258
  %197 = srem i64 %185, 224, !dbg !258
  %198 = icmp slt i64 %197, 0, !dbg !258
  %199 = add nsw i64 %197, 224, !dbg !258
  %200 = select i1 %198, i64 %199, i64 %197, !dbg !258
  %.fr38 = freeze i64 %196, !dbg !258
  %201 = srem i64 %.fr38, 224, !dbg !258
  %202 = sub nsw i64 %.fr38, %201, !dbg !258
  %.idx39 = mul i64 %192, 200704, !dbg !258
  %203 = getelementptr i8, ptr %5, i64 %.idx39, !dbg !258
  %204 = getelementptr [4 x i8], ptr %203, i64 %202, !dbg !258
  %205 = getelementptr [4 x i8], ptr %204, i64 %200, !dbg !258
  %206 = load <1 x float>, ptr %205, align 4, !dbg !258
  %207 = extractelement <4 x i64> %162, i64 2, !dbg !258
  %.frozen74 = freeze i64 %207, !dbg !258
  %208 = sdiv i64 %.frozen74, 50176, !dbg !258
  %209 = mul nsw i64 %208, 50176, !dbg !258
  %210 = icmp ne i64 %207, %209, !dbg !258
  %211 = icmp slt i64 %207, 0, !dbg !258
  %212 = and i1 %211, %210, !dbg !258
  %213 = sext i1 %212 to i64, !dbg !258
  %214 = add nsw i64 %208, %213, !dbg !258
  %215 = mul i64 %208, 50176, !dbg !258
  %.decomposed75 = sub i64 %.frozen74, %215, !dbg !258
  %216 = icmp slt i64 %.decomposed75, 0, !dbg !258
  %217 = add nsw i64 %.decomposed75, 50176, !dbg !258
  %218 = select i1 %216, i64 %217, i64 %.decomposed75, !dbg !258
  %219 = srem i64 %207, 224, !dbg !258
  %220 = icmp slt i64 %219, 0, !dbg !258
  %221 = add nsw i64 %219, 224, !dbg !258
  %222 = select i1 %220, i64 %221, i64 %219, !dbg !258
  %.fr40 = freeze i64 %218, !dbg !258
  %223 = srem i64 %.fr40, 224, !dbg !258
  %224 = sub nsw i64 %.fr40, %223, !dbg !258
  %.idx41 = mul i64 %214, 200704, !dbg !258
  %225 = getelementptr i8, ptr %5, i64 %.idx41, !dbg !258
  %226 = getelementptr [4 x i8], ptr %225, i64 %224, !dbg !258
  %227 = getelementptr [4 x i8], ptr %226, i64 %222, !dbg !258
  %228 = load <1 x float>, ptr %227, align 4, !dbg !258
  %229 = shufflevector <1 x float> %228, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %230 = extractelement <4 x i64> %162, i64 3, !dbg !258
  %.frozen76 = freeze i64 %230, !dbg !258
  %231 = sdiv i64 %.frozen76, 50176, !dbg !258
  %232 = mul nsw i64 %231, 50176, !dbg !258
  %233 = icmp ne i64 %230, %232, !dbg !258
  %234 = icmp slt i64 %230, 0, !dbg !258
  %235 = and i1 %234, %233, !dbg !258
  %236 = sext i1 %235 to i64, !dbg !258
  %237 = add nsw i64 %231, %236, !dbg !258
  %238 = mul i64 %231, 50176, !dbg !258
  %.decomposed77 = sub i64 %.frozen76, %238, !dbg !258
  %239 = icmp slt i64 %.decomposed77, 0, !dbg !258
  %240 = add nsw i64 %.decomposed77, 50176, !dbg !258
  %241 = select i1 %239, i64 %240, i64 %.decomposed77, !dbg !258
  %242 = srem i64 %230, 224, !dbg !258
  %243 = icmp slt i64 %242, 0, !dbg !258
  %244 = add nsw i64 %242, 224, !dbg !258
  %245 = select i1 %243, i64 %244, i64 %242, !dbg !258
  %.fr42 = freeze i64 %241, !dbg !258
  %246 = srem i64 %.fr42, 224, !dbg !258
  %247 = sub nsw i64 %.fr42, %246, !dbg !258
  %.idx43 = mul i64 %237, 200704, !dbg !258
  %248 = getelementptr i8, ptr %5, i64 %.idx43, !dbg !258
  %249 = getelementptr [4 x i8], ptr %248, i64 %247, !dbg !258
  %250 = getelementptr [4 x i8], ptr %249, i64 %245, !dbg !258
  %251 = load <1 x float>, ptr %250, align 4, !dbg !258
  %252 = shufflevector <1 x float> %251, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %253 = add <4 x i64> %46, %68, !dbg !242
  %254 = extractelement <4 x i64> %253, i64 0, !dbg !242
  %.frozen78 = freeze i64 %254, !dbg !242
  %255 = sdiv i64 %.frozen78, 50176, !dbg !242
  %256 = mul nsw i64 %255, 50176, !dbg !242
  %257 = icmp ne i64 %254, %256, !dbg !242
  %258 = icmp slt i64 %254, 0, !dbg !242
  %259 = and i1 %258, %257, !dbg !242
  %260 = sext i1 %259 to i64, !dbg !242
  %261 = add nsw i64 %255, %260, !dbg !242
  %262 = mul i64 %255, 50176, !dbg !242
  %.decomposed79 = sub i64 %.frozen78, %262, !dbg !242
  %263 = icmp slt i64 %.decomposed79, 0, !dbg !242
  %264 = add nsw i64 %.decomposed79, 50176, !dbg !242
  %265 = select i1 %263, i64 %264, i64 %.decomposed79, !dbg !242
  %266 = srem i64 %254, 224, !dbg !242
  %267 = icmp slt i64 %266, 0, !dbg !242
  %268 = add nsw i64 %266, 224, !dbg !242
  %269 = select i1 %267, i64 %268, i64 %266, !dbg !242
  %.fr44 = freeze i64 %265, !dbg !242
  %270 = srem i64 %.fr44, 224, !dbg !242
  %271 = sub nsw i64 %.fr44, %270, !dbg !242
  %.idx45 = mul i64 %261, 200704, !dbg !242
  %272 = getelementptr i8, ptr %5, i64 %.idx45, !dbg !242
  %273 = getelementptr [4 x i8], ptr %272, i64 %271, !dbg !242
  %274 = getelementptr [4 x i8], ptr %273, i64 %269, !dbg !242
  %275 = load <1 x float>, ptr %274, align 4, !dbg !242
  %276 = extractelement <4 x i64> %253, i64 1, !dbg !242
  %.frozen80 = freeze i64 %276, !dbg !242
  %277 = sdiv i64 %.frozen80, 50176, !dbg !242
  %278 = mul nsw i64 %277, 50176, !dbg !242
  %279 = icmp ne i64 %276, %278, !dbg !242
  %280 = icmp slt i64 %276, 0, !dbg !242
  %281 = and i1 %280, %279, !dbg !242
  %282 = sext i1 %281 to i64, !dbg !242
  %283 = add nsw i64 %277, %282, !dbg !242
  %284 = mul i64 %277, 50176, !dbg !242
  %.decomposed81 = sub i64 %.frozen80, %284, !dbg !242
  %285 = icmp slt i64 %.decomposed81, 0, !dbg !242
  %286 = add nsw i64 %.decomposed81, 50176, !dbg !242
  %287 = select i1 %285, i64 %286, i64 %.decomposed81, !dbg !242
  %288 = srem i64 %276, 224, !dbg !242
  %289 = icmp slt i64 %288, 0, !dbg !242
  %290 = add nsw i64 %288, 224, !dbg !242
  %291 = select i1 %289, i64 %290, i64 %288, !dbg !242
  %.fr46 = freeze i64 %287, !dbg !242
  %292 = srem i64 %.fr46, 224, !dbg !242
  %293 = sub nsw i64 %.fr46, %292, !dbg !242
  %.idx47 = mul i64 %283, 200704, !dbg !242
  %294 = getelementptr i8, ptr %5, i64 %.idx47, !dbg !242
  %295 = getelementptr [4 x i8], ptr %294, i64 %293, !dbg !242
  %296 = getelementptr [4 x i8], ptr %295, i64 %291, !dbg !242
  %297 = load <1 x float>, ptr %296, align 4, !dbg !242
  %298 = extractelement <4 x i64> %253, i64 2, !dbg !242
  %.frozen82 = freeze i64 %298, !dbg !242
  %299 = sdiv i64 %.frozen82, 50176, !dbg !242
  %300 = mul nsw i64 %299, 50176, !dbg !242
  %301 = icmp ne i64 %298, %300, !dbg !242
  %302 = icmp slt i64 %298, 0, !dbg !242
  %303 = and i1 %302, %301, !dbg !242
  %304 = sext i1 %303 to i64, !dbg !242
  %305 = add nsw i64 %299, %304, !dbg !242
  %306 = mul i64 %299, 50176, !dbg !242
  %.decomposed83 = sub i64 %.frozen82, %306, !dbg !242
  %307 = icmp slt i64 %.decomposed83, 0, !dbg !242
  %308 = add nsw i64 %.decomposed83, 50176, !dbg !242
  %309 = select i1 %307, i64 %308, i64 %.decomposed83, !dbg !242
  %310 = srem i64 %298, 224, !dbg !242
  %311 = icmp slt i64 %310, 0, !dbg !242
  %312 = add nsw i64 %310, 224, !dbg !242
  %313 = select i1 %311, i64 %312, i64 %310, !dbg !242
  %.fr48 = freeze i64 %309, !dbg !242
  %314 = srem i64 %.fr48, 224, !dbg !242
  %315 = sub nsw i64 %.fr48, %314, !dbg !242
  %.idx49 = mul i64 %305, 200704, !dbg !242
  %316 = getelementptr i8, ptr %5, i64 %.idx49, !dbg !242
  %317 = getelementptr [4 x i8], ptr %316, i64 %315, !dbg !242
  %318 = getelementptr [4 x i8], ptr %317, i64 %313, !dbg !242
  %319 = load <1 x float>, ptr %318, align 4, !dbg !242
  %320 = shufflevector <1 x float> %319, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %321 = extractelement <4 x i64> %253, i64 3, !dbg !242
  %.frozen84 = freeze i64 %321, !dbg !242
  %322 = sdiv i64 %.frozen84, 50176, !dbg !242
  %323 = mul nsw i64 %322, 50176, !dbg !242
  %324 = icmp ne i64 %321, %323, !dbg !242
  %325 = icmp slt i64 %321, 0, !dbg !242
  %326 = and i1 %325, %324, !dbg !242
  %327 = sext i1 %326 to i64, !dbg !242
  %328 = add nsw i64 %322, %327, !dbg !242
  %329 = mul i64 %322, 50176, !dbg !242
  %.decomposed85 = sub i64 %.frozen84, %329, !dbg !242
  %330 = icmp slt i64 %.decomposed85, 0, !dbg !242
  %331 = add nsw i64 %.decomposed85, 50176, !dbg !242
  %332 = select i1 %330, i64 %331, i64 %.decomposed85, !dbg !242
  %333 = srem i64 %321, 224, !dbg !242
  %334 = icmp slt i64 %333, 0, !dbg !242
  %335 = add nsw i64 %333, 224, !dbg !242
  %336 = select i1 %334, i64 %335, i64 %333, !dbg !242
  %.fr50 = freeze i64 %332, !dbg !242
  %337 = srem i64 %.fr50, 224, !dbg !242
  %338 = sub nsw i64 %.fr50, %337, !dbg !242
  %.idx51 = mul i64 %328, 200704, !dbg !242
  %339 = getelementptr i8, ptr %5, i64 %.idx51, !dbg !242
  %340 = getelementptr [4 x i8], ptr %339, i64 %338, !dbg !242
  %341 = getelementptr [4 x i8], ptr %340, i64 %336, !dbg !242
  %342 = load <1 x float>, ptr %341, align 4, !dbg !242
  %343 = shufflevector <1 x float> %342, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %344 = add <4 x i64> %46, %70, !dbg !259
  %345 = extractelement <4 x i64> %344, i64 0, !dbg !259
  %.frozen86 = freeze i64 %345, !dbg !259
  %346 = sdiv i64 %.frozen86, 50176, !dbg !259
  %347 = mul nsw i64 %346, 50176, !dbg !259
  %348 = icmp ne i64 %345, %347, !dbg !259
  %349 = icmp slt i64 %345, 0, !dbg !259
  %350 = and i1 %349, %348, !dbg !259
  %351 = sext i1 %350 to i64, !dbg !259
  %352 = add nsw i64 %346, %351, !dbg !259
  %353 = mul i64 %346, 50176, !dbg !259
  %.decomposed87 = sub i64 %.frozen86, %353, !dbg !259
  %354 = icmp slt i64 %.decomposed87, 0, !dbg !259
  %355 = add nsw i64 %.decomposed87, 50176, !dbg !259
  %356 = select i1 %354, i64 %355, i64 %.decomposed87, !dbg !259
  %357 = srem i64 %345, 224, !dbg !259
  %358 = icmp slt i64 %357, 0, !dbg !259
  %359 = add nsw i64 %357, 224, !dbg !259
  %360 = select i1 %358, i64 %359, i64 %357, !dbg !259
  %.fr52 = freeze i64 %356, !dbg !259
  %361 = srem i64 %.fr52, 224, !dbg !259
  %362 = sub nsw i64 %.fr52, %361, !dbg !259
  %.idx53 = mul i64 %352, 200704, !dbg !259
  %363 = getelementptr i8, ptr %5, i64 %.idx53, !dbg !259
  %364 = getelementptr [4 x i8], ptr %363, i64 %362, !dbg !259
  %365 = getelementptr [4 x i8], ptr %364, i64 %360, !dbg !259
  %366 = load <1 x float>, ptr %365, align 4, !dbg !259
  %367 = extractelement <4 x i64> %344, i64 1, !dbg !259
  %.frozen88 = freeze i64 %367, !dbg !259
  %368 = sdiv i64 %.frozen88, 50176, !dbg !259
  %369 = mul nsw i64 %368, 50176, !dbg !259
  %370 = icmp ne i64 %367, %369, !dbg !259
  %371 = icmp slt i64 %367, 0, !dbg !259
  %372 = and i1 %371, %370, !dbg !259
  %373 = sext i1 %372 to i64, !dbg !259
  %374 = add nsw i64 %368, %373, !dbg !259
  %375 = mul i64 %368, 50176, !dbg !259
  %.decomposed89 = sub i64 %.frozen88, %375, !dbg !259
  %376 = icmp slt i64 %.decomposed89, 0, !dbg !259
  %377 = add nsw i64 %.decomposed89, 50176, !dbg !259
  %378 = select i1 %376, i64 %377, i64 %.decomposed89, !dbg !259
  %379 = srem i64 %367, 224, !dbg !259
  %380 = icmp slt i64 %379, 0, !dbg !259
  %381 = add nsw i64 %379, 224, !dbg !259
  %382 = select i1 %380, i64 %381, i64 %379, !dbg !259
  %.fr54 = freeze i64 %378, !dbg !259
  %383 = srem i64 %.fr54, 224, !dbg !259
  %384 = sub nsw i64 %.fr54, %383, !dbg !259
  %.idx55 = mul i64 %374, 200704, !dbg !259
  %385 = getelementptr i8, ptr %5, i64 %.idx55, !dbg !259
  %386 = getelementptr [4 x i8], ptr %385, i64 %384, !dbg !259
  %387 = getelementptr [4 x i8], ptr %386, i64 %382, !dbg !259
  %388 = load <1 x float>, ptr %387, align 4, !dbg !259
  %389 = extractelement <4 x i64> %344, i64 2, !dbg !259
  %.frozen90 = freeze i64 %389, !dbg !259
  %390 = sdiv i64 %.frozen90, 50176, !dbg !259
  %391 = mul nsw i64 %390, 50176, !dbg !259
  %392 = icmp ne i64 %389, %391, !dbg !259
  %393 = icmp slt i64 %389, 0, !dbg !259
  %394 = and i1 %393, %392, !dbg !259
  %395 = sext i1 %394 to i64, !dbg !259
  %396 = add nsw i64 %390, %395, !dbg !259
  %397 = mul i64 %390, 50176, !dbg !259
  %.decomposed91 = sub i64 %.frozen90, %397, !dbg !259
  %398 = icmp slt i64 %.decomposed91, 0, !dbg !259
  %399 = add nsw i64 %.decomposed91, 50176, !dbg !259
  %400 = select i1 %398, i64 %399, i64 %.decomposed91, !dbg !259
  %401 = srem i64 %389, 224, !dbg !259
  %402 = icmp slt i64 %401, 0, !dbg !259
  %403 = add nsw i64 %401, 224, !dbg !259
  %404 = select i1 %402, i64 %403, i64 %401, !dbg !259
  %.fr56 = freeze i64 %400, !dbg !259
  %405 = srem i64 %.fr56, 224, !dbg !259
  %406 = sub nsw i64 %.fr56, %405, !dbg !259
  %.idx57 = mul i64 %396, 200704, !dbg !259
  %407 = getelementptr i8, ptr %5, i64 %.idx57, !dbg !259
  %408 = getelementptr [4 x i8], ptr %407, i64 %406, !dbg !259
  %409 = getelementptr [4 x i8], ptr %408, i64 %404, !dbg !259
  %410 = load <1 x float>, ptr %409, align 4, !dbg !259
  %411 = shufflevector <1 x float> %410, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %412 = extractelement <4 x i64> %344, i64 3, !dbg !259
  %.frozen92 = freeze i64 %412, !dbg !259
  %413 = sdiv i64 %.frozen92, 50176, !dbg !259
  %414 = mul nsw i64 %413, 50176, !dbg !259
  %415 = icmp ne i64 %412, %414, !dbg !259
  %416 = icmp slt i64 %412, 0, !dbg !259
  %417 = and i1 %416, %415, !dbg !259
  %418 = sext i1 %417 to i64, !dbg !259
  %419 = add nsw i64 %413, %418, !dbg !259
  %420 = mul i64 %413, 50176, !dbg !259
  %.decomposed93 = sub i64 %.frozen92, %420, !dbg !259
  %421 = icmp slt i64 %.decomposed93, 0, !dbg !259
  %422 = add nsw i64 %.decomposed93, 50176, !dbg !259
  %423 = select i1 %421, i64 %422, i64 %.decomposed93, !dbg !259
  %424 = srem i64 %412, 224, !dbg !259
  %425 = icmp slt i64 %424, 0, !dbg !259
  %426 = add nsw i64 %424, 224, !dbg !259
  %427 = select i1 %425, i64 %426, i64 %424, !dbg !259
  %.fr58 = freeze i64 %423, !dbg !259
  %428 = srem i64 %.fr58, 224, !dbg !259
  %429 = sub nsw i64 %.fr58, %428, !dbg !259
  %.idx59 = mul i64 %419, 200704, !dbg !259
  %430 = getelementptr i8, ptr %5, i64 %.idx59, !dbg !259
  %431 = getelementptr [4 x i8], ptr %430, i64 %429, !dbg !259
  %432 = getelementptr [4 x i8], ptr %431, i64 %427, !dbg !259
  %433 = load <1 x float>, ptr %432, align 4, !dbg !259
  %434 = shufflevector <1 x float> %433, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %435 = fsub contract <4 x float> %67, %64, !dbg !260
  %436 = fsub contract <4 x float> %64, %65, !dbg !261
  %437 = shufflevector <1 x float> %93, <1 x float> %115, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !262
  %438 = shufflevector <4 x float> %437, <4 x float> %138, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !262
  %439 = shufflevector <4 x float> %438, <4 x float> %161, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !262
  %440 = fmul contract <4 x float> %435, %439, !dbg !262
  %441 = shufflevector <1 x float> %184, <1 x float> %206, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !263
  %442 = shufflevector <4 x float> %441, <4 x float> %229, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !263
  %443 = shufflevector <4 x float> %442, <4 x float> %252, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !263
  %444 = fmul contract <4 x float> %436, %443, !dbg !263
  %445 = fadd contract <4 x float> %440, %444, !dbg !264
  %446 = fmul contract <4 x float> %48, %445, !dbg !265
  %447 = shufflevector <1 x float> %275, <1 x float> %297, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !266
  %448 = shufflevector <4 x float> %447, <4 x float> %320, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !266
  %449 = shufflevector <4 x float> %448, <4 x float> %343, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !266
  %450 = fmul contract <4 x float> %435, %449, !dbg !266
  %451 = shufflevector <1 x float> %366, <1 x float> %388, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !267
  %452 = shufflevector <4 x float> %451, <4 x float> %411, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !267
  %453 = shufflevector <4 x float> %452, <4 x float> %434, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !267
  %454 = fmul contract <4 x float> %436, %453, !dbg !267
  %455 = fadd contract <4 x float> %450, %454, !dbg !268
  %456 = fmul contract <4 x float> %50, %455, !dbg !269
  %457 = fadd contract <4 x float> %446, %456, !dbg !270
  %458 = getelementptr [4 x i8], ptr %52, i64 %55, !dbg !226
  store <4 x float> %457, ptr %458, align 4, !dbg !226
  %459 = add nuw nsw i64 %54, 4, !dbg !226
  %460 = icmp samesign ult i64 %54, 52, !dbg !226
  br i1 %460, label %53, label %461, !dbg !226

461:                                              ; preds = %53
  %462 = add nuw nsw i64 %23, 1, !dbg !226
  %exitcond.not = icmp eq i64 %462, 56, !dbg !226
  br i1 %exitcond.not, label %463, label %22, !dbg !226

463:                                              ; preds = %461
  %464 = add nuw nsw i64 %18, 1, !dbg !226
  %exitcond62.not = icmp eq i64 %464, 32, !dbg !226
  br i1 %exitcond62.not, label %465, label %17, !dbg !226

465:                                              ; preds = %463
  ret i32 0, !dbg !271
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_14_conv_64x112x112x128x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !272 {
  %4 = alloca [4 x float], align 64, !dbg !273
  %5 = alloca [4 x float], align 64, !dbg !274
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !275
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !275
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !275
  %7 = getelementptr i8, ptr %6, i64 83953664, !dbg !275
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !275
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !276
  %9 = load ptr, ptr %8, align 8, !dbg !276
  %10 = getelementptr i8, ptr %9, i64 384, !dbg !276
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !276
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !277
  %12 = load ptr, ptr %11, align 8, !dbg !277
  %13 = getelementptr i8, ptr %12, i64 6422528, !dbg !277
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !277
  %14 = load i32, ptr %2, align 16, !dbg !273
  %15 = zext i32 %14 to i64, !dbg !273
  %16 = lshr i64 %15, 2, !dbg !273
  %17 = and i64 %16, 3, !dbg !273
  %18 = and i64 %15, 3, !dbg !273
  %19 = shl nuw nsw i64 %15, 1, !dbg !273
  %20 = and i64 %19, 8589934560, !dbg !273
  %21 = mul nuw nsw i64 %17, 28, !dbg !273
  %22 = mul nuw nsw i64 %18, 28, !dbg !273
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !278
  br label %23, !dbg !273

23:                                               ; preds = %3, %82
  %24 = phi i64 [ 0, %3 ], [ %83, %82 ]
  %25 = or disjoint i64 %24, %20, !dbg !273
  %26 = getelementptr [4 x i8], ptr @__constant_64xf32_0, i64 %25, !dbg !279
  %27 = load <1 x float>, ptr %26, align 4, !dbg !279
  %.idx30 = mul nuw nsw i64 %25, 4608
  %28 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx30
  %29 = shufflevector <1 x float> %27, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %25, 50176
  %30 = getelementptr i8, ptr %13, i64 %.idx
  br label %.preheader35, !dbg !273

.preheader35:                                     ; preds = %23, %80
  %31 = phi i64 [ 0, %23 ], [ %81, %80 ]
  %32 = add nuw nsw i64 %31, %21
  %.idx27 = mul nuw nsw i64 %32, 448
  %33 = getelementptr i8, ptr %30, i64 %.idx27
  br label %34, !dbg !273

34:                                               ; preds = %.preheader35, %68
  %35 = phi i64 [ 0, %.preheader35 ], [ %78, %68 ]
  br label %37, !dbg !273

.preheader34:                                     ; preds = %37
  %36 = add nuw nsw i64 %35, %22, !dbg !273
  %invariant.gep36 = getelementptr [4 x i8], ptr %7, i64 %36, !dbg !273
  br label %.preheader33, !dbg !273

37:                                               ; preds = %34, %37
  %38 = phi i64 [ 0, %34 ], [ %42, %37 ]
  %39 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %38, !dbg !273
  %40 = load float, ptr %39, align 4, !dbg !273
  %41 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %38, !dbg !273
  store float %40, ptr %41, align 4, !dbg !273
  %42 = add nuw nsw i64 %38, 1, !dbg !273
  %exitcond.not = icmp eq i64 %42, 4, !dbg !273
  br i1 %exitcond.not, label %.preheader34, label %37, !dbg !273

.preheader33:                                     ; preds = %.preheader34, %66
  %43 = phi i64 [ 0, %.preheader34 ], [ %67, %66 ]
  %.idx28 = mul nuw nsw i64 %43, 51984
  %gep37 = getelementptr i8, ptr %invariant.gep36, i64 %.idx28, !dbg !273
  %.idx31 = mul nuw nsw i64 %43, 36
  %44 = getelementptr inbounds nuw i8, ptr %28, i64 %.idx31
  br label %45, !dbg !273

45:                                               ; preds = %.preheader33, %64
  %46 = phi i64 [ 0, %.preheader33 ], [ %65, %64 ]
  %47 = add nuw nsw i64 %32, %46, !dbg !273
  %.idx29 = mul nuw nsw i64 %47, 456
  %gep = getelementptr i8, ptr %gep37, i64 %.idx29
  %.idx32 = mul nuw nsw i64 %46, 12
  %48 = getelementptr inbounds nuw i8, ptr %44, i64 %.idx32
  br label %.preheader, !dbg !273

.preheader:                                       ; preds = %45, %62
  %49 = phi i64 [ 0, %45 ], [ %63, %62 ]
  %50 = getelementptr [4 x i8], ptr %gep, i64 %49
  %51 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %49
  %.promoted = load float, ptr %51, align 4
  br label %52, !dbg !273

52:                                               ; preds = %.preheader, %52
  %53 = phi i64 [ 0, %.preheader ], [ %61, %52 ]
  %54 = phi float [ %.promoted, %.preheader ], [ %60, %52 ]
  %55 = getelementptr [4 x i8], ptr %50, i64 %53, !dbg !273
  %56 = load float, ptr %55, align 4, !dbg !273
  %57 = getelementptr inbounds nuw [4 x i8], ptr %48, i64 %53, !dbg !273
  %58 = load float, ptr %57, align 4, !dbg !273
  %59 = fmul contract float %56, %58, !dbg !280
  %60 = fadd contract float %54, %59, !dbg !281
  %61 = add nuw nsw i64 %53, 1, !dbg !273
  %exitcond38.not = icmp eq i64 %61, 3, !dbg !273
  br i1 %exitcond38.not, label %62, label %52, !dbg !273

62:                                               ; preds = %52
  store float %60, ptr %51, align 4, !dbg !273
  %63 = add nuw nsw i64 %49, 1, !dbg !273
  %exitcond39.not = icmp eq i64 %63, 4, !dbg !273
  br i1 %exitcond39.not, label %64, label %.preheader, !dbg !273

64:                                               ; preds = %62
  %65 = add nuw nsw i64 %46, 1, !dbg !273
  %exitcond40.not = icmp eq i64 %65, 3, !dbg !273
  br i1 %exitcond40.not, label %66, label %45, !dbg !273

66:                                               ; preds = %64
  %67 = add nuw nsw i64 %43, 1, !dbg !273
  %exitcond41.not = icmp eq i64 %67, 128, !dbg !273
  br i1 %exitcond41.not, label %68, label %.preheader33, !dbg !273

68:                                               ; preds = %66
  %69 = load <4 x float>, ptr %4, align 64, !dbg !279
  %70 = fadd contract <4 x float> %29, %69, !dbg !282
  %71 = fcmp ogt <4 x float> %70, zeroinitializer, !dbg !283
  %72 = select <4 x i1> %71, <4 x float> zeroinitializer, <4 x float> %70, !dbg !284
  %73 = fmul contract <4 x float> %72, splat (float 0x3FC99999A0000000), !dbg !285
  %74 = fcmp olt <4 x float> %70, zeroinitializer, !dbg !286
  %75 = select <4 x i1> %74, <4 x float> zeroinitializer, <4 x float> %70, !dbg !287
  %76 = fadd contract <4 x float> %75, %73, !dbg !288
  %77 = getelementptr [4 x i8], ptr %33, i64 %36, !dbg !273
  store <4 x float> %76, ptr %77, align 16, !dbg !273
  %78 = add nuw nsw i64 %35, 4, !dbg !273
  %79 = icmp samesign ult i64 %35, 24, !dbg !273
  br i1 %79, label %34, label %80, !dbg !273

80:                                               ; preds = %68
  %81 = add nuw nsw i64 %31, 1, !dbg !273
  %exitcond42.not = icmp eq i64 %81, 28, !dbg !273
  br i1 %exitcond42.not, label %82, label %.preheader35, !dbg !273

82:                                               ; preds = %80
  %83 = add nuw nsw i64 %24, 1, !dbg !273
  %exitcond43.not = icmp eq i64 %83, 32, !dbg !273
  br i1 %exitcond43.not, label %84, label %23, !dbg !273

84:                                               ; preds = %82
  ret i32 0, !dbg !289
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_15_elementwise_broadcast_64x224x224_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !290 {
  %.elt21 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !291
  %.unpack22 = load ptr, ptr %.elt21, align 16, !dbg !291
  %4 = load ptr, ptr %.unpack22, align 8, !dbg !291
  %5 = getelementptr i8, ptr %4, i64 6422528, !dbg !291
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !291
  %6 = getelementptr i8, ptr %.unpack22, i64 8, !dbg !292
  %7 = load ptr, ptr %6, align 8, !dbg !292
  %8 = getelementptr i8, ptr %7, i64 9633792, !dbg !292
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !292
  %9 = load i32, ptr %2, align 16, !dbg !293
  %10 = zext i32 %9 to i64, !dbg !293
  %11 = lshr i64 %10, 2, !dbg !293
  %12 = and i64 %10, 3, !dbg !293
  %13 = mul nuw nsw i64 %11, 56, !dbg !293
  %14 = mul nuw nsw i64 %12, 56, !dbg !293
  br label %15, !dbg !293

15:                                               ; preds = %3, %460
  %16 = phi i64 [ 0, %3 ], [ %461, %460 ]
  %17 = mul nuw nsw i64 %16, 112, !dbg !294
  %.idx60 = mul nuw nsw i64 %16, 204304
  %18 = getelementptr i8, ptr %8, i64 %.idx60
  br label %19, !dbg !293

19:                                               ; preds = %15, %458
  %20 = phi i64 [ 0, %15 ], [ %459, %458 ]
  %21 = add nuw nsw i64 %20, %13, !dbg !295
  %22 = uitofp nneg i64 %21 to float, !dbg !296
  %23 = fadd nnan contract float %22, 5.000000e-01, !dbg !297
  %24 = fmul nnan float %23, 5.000000e-01, !dbg !298
  %25 = fadd contract float %24, -5.000000e-01, !dbg !299
  %.inv = fcmp ole float %25, 0.000000e+00, !dbg !300
  %26 = select i1 %.inv, float 0.000000e+00, float %25, !dbg !300
  %.inv25 = fcmp oge float %26, 1.110000e+02, !dbg !301
  %27 = select i1 %.inv25, float 1.110000e+02, float %26, !dbg !301
  %28 = tail call float @llvm.floor.f32(float %27), !dbg !302
  %29 = fadd contract float %27, 1.000000e+00, !dbg !303
  %30 = tail call float @llvm.floor.f32(float %29), !dbg !304
  %31 = fptosi float %28 to i64, !dbg !305
  %.inv26 = fcmp oge float %29, 1.110000e+02, !dbg !306
  %32 = select i1 %.inv26, float 1.110000e+02, float %29, !dbg !306
  %33 = fptosi float %32 to i64, !dbg !307
  %34 = add i64 %17, %31, !dbg !294
  %35 = mul i64 %34, 112, !dbg !294
  %36 = add i64 %17, %33, !dbg !308
  %37 = mul i64 %36, 112, !dbg !308
  %38 = fsub contract float %30, %27, !dbg !309
  %39 = fsub contract float %27, %28, !dbg !310
  %40 = insertelement <4 x i64> poison, i64 %35, i64 0
  %41 = shufflevector <4 x i64> %40, <4 x i64> poison, <4 x i32> zeroinitializer
  %42 = insertelement <4 x i64> poison, i64 %37, i64 0
  %43 = shufflevector <4 x i64> %42, <4 x i64> poison, <4 x i32> zeroinitializer
  %44 = insertelement <4 x float> poison, float %38, i64 0
  %45 = shufflevector <4 x float> %44, <4 x float> poison, <4 x i32> zeroinitializer
  %46 = insertelement <4 x float> poison, float %39, i64 0
  %47 = shufflevector <4 x float> %46, <4 x float> poison, <4 x i32> zeroinitializer
  %.idx61 = mul nuw nsw i64 %21, 904
  %48 = getelementptr i8, ptr %18, i64 %.idx61
  %49 = getelementptr i8, ptr %48, i64 908
  br label %50, !dbg !293

50:                                               ; preds = %19, %50
  %51 = phi i64 [ 0, %19 ], [ %456, %50 ]
  %52 = add nuw nsw i64 %51, %14, !dbg !311
  %53 = insertelement <4 x i64> poison, i64 %52, i64 0, !dbg !293
  %54 = shufflevector <4 x i64> %53, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !293
  %55 = or disjoint <4 x i64> %54, <i64 0, i64 1, i64 2, i64 3>, !dbg !311
  %56 = uitofp nneg <4 x i64> %55 to <4 x float>, !dbg !312
  %57 = fadd nnan contract <4 x float> %56, splat (float 5.000000e-01), !dbg !313
  %58 = fmul nnan <4 x float> %57, splat (float 5.000000e-01), !dbg !314
  %59 = fadd contract <4 x float> %58, splat (float -5.000000e-01), !dbg !315
  %.inv27 = fcmp ole <4 x float> %59, zeroinitializer, !dbg !316
  %60 = select <4 x i1> %.inv27, <4 x float> zeroinitializer, <4 x float> %59, !dbg !316
  %.inv28 = fcmp oge <4 x float> %60, splat (float 1.110000e+02), !dbg !317
  %61 = select <4 x i1> %.inv28, <4 x float> splat (float 1.110000e+02), <4 x float> %60, !dbg !317
  %62 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %61), !dbg !318
  %63 = fadd contract <4 x float> %61, splat (float 1.000000e+00), !dbg !319
  %64 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %63), !dbg !320
  %65 = fptosi <4 x float> %62 to <4 x i64>, !dbg !321
  %.inv29 = fcmp oge <4 x float> %63, splat (float 1.110000e+02), !dbg !322
  %66 = select <4 x i1> %.inv29, <4 x float> splat (float 1.110000e+02), <4 x float> %63, !dbg !322
  %67 = fptosi <4 x float> %66 to <4 x i64>, !dbg !323
  %68 = add <4 x i64> %41, %65, !dbg !294
  %69 = extractelement <4 x i64> %68, i64 0, !dbg !294
  %.frozen = freeze i64 %69, !dbg !294
  %70 = sdiv i64 %.frozen, 12544, !dbg !294
  %71 = mul nsw i64 %70, 12544, !dbg !294
  %72 = icmp ne i64 %69, %71, !dbg !294
  %73 = icmp slt i64 %69, 0, !dbg !294
  %74 = and i1 %73, %72, !dbg !294
  %75 = sext i1 %74 to i64, !dbg !294
  %76 = add nsw i64 %70, %75, !dbg !294
  %77 = mul i64 %70, 12544, !dbg !294
  %.decomposed = sub i64 %.frozen, %77, !dbg !294
  %78 = icmp slt i64 %.decomposed, 0, !dbg !294
  %79 = add nsw i64 %.decomposed, 12544, !dbg !294
  %80 = select i1 %78, i64 %79, i64 %.decomposed, !dbg !294
  %81 = srem i64 %69, 112, !dbg !294
  %82 = icmp slt i64 %81, 0, !dbg !294
  %83 = add nsw i64 %81, 112, !dbg !294
  %84 = select i1 %82, i64 %83, i64 %81, !dbg !294
  %.fr = freeze i64 %80, !dbg !294
  %85 = srem i64 %.fr, 112, !dbg !294
  %86 = sub nsw i64 %.fr, %85, !dbg !294
  %.idx = mul i64 %76, 50176, !dbg !294
  %87 = getelementptr i8, ptr %5, i64 %.idx, !dbg !294
  %88 = getelementptr [4 x i8], ptr %87, i64 %86, !dbg !294
  %89 = getelementptr [4 x i8], ptr %88, i64 %84, !dbg !294
  %90 = load <1 x float>, ptr %89, align 4, !dbg !294
  %91 = extractelement <4 x i64> %68, i64 1, !dbg !294
  %.frozen64 = freeze i64 %91, !dbg !294
  %92 = sdiv i64 %.frozen64, 12544, !dbg !294
  %93 = mul nsw i64 %92, 12544, !dbg !294
  %94 = icmp ne i64 %91, %93, !dbg !294
  %95 = icmp slt i64 %91, 0, !dbg !294
  %96 = and i1 %95, %94, !dbg !294
  %97 = sext i1 %96 to i64, !dbg !294
  %98 = add nsw i64 %92, %97, !dbg !294
  %99 = mul i64 %92, 12544, !dbg !294
  %.decomposed65 = sub i64 %.frozen64, %99, !dbg !294
  %100 = icmp slt i64 %.decomposed65, 0, !dbg !294
  %101 = add nsw i64 %.decomposed65, 12544, !dbg !294
  %102 = select i1 %100, i64 %101, i64 %.decomposed65, !dbg !294
  %103 = srem i64 %91, 112, !dbg !294
  %104 = icmp slt i64 %103, 0, !dbg !294
  %105 = add nsw i64 %103, 112, !dbg !294
  %106 = select i1 %104, i64 %105, i64 %103, !dbg !294
  %.fr30 = freeze i64 %102, !dbg !294
  %107 = srem i64 %.fr30, 112, !dbg !294
  %108 = sub nsw i64 %.fr30, %107, !dbg !294
  %.idx31 = mul i64 %98, 50176, !dbg !294
  %109 = getelementptr i8, ptr %5, i64 %.idx31, !dbg !294
  %110 = getelementptr [4 x i8], ptr %109, i64 %108, !dbg !294
  %111 = getelementptr [4 x i8], ptr %110, i64 %106, !dbg !294
  %112 = load <1 x float>, ptr %111, align 4, !dbg !294
  %113 = extractelement <4 x i64> %68, i64 2, !dbg !294
  %.frozen66 = freeze i64 %113, !dbg !294
  %114 = sdiv i64 %.frozen66, 12544, !dbg !294
  %115 = mul nsw i64 %114, 12544, !dbg !294
  %116 = icmp ne i64 %113, %115, !dbg !294
  %117 = icmp slt i64 %113, 0, !dbg !294
  %118 = and i1 %117, %116, !dbg !294
  %119 = sext i1 %118 to i64, !dbg !294
  %120 = add nsw i64 %114, %119, !dbg !294
  %121 = mul i64 %114, 12544, !dbg !294
  %.decomposed67 = sub i64 %.frozen66, %121, !dbg !294
  %122 = icmp slt i64 %.decomposed67, 0, !dbg !294
  %123 = add nsw i64 %.decomposed67, 12544, !dbg !294
  %124 = select i1 %122, i64 %123, i64 %.decomposed67, !dbg !294
  %125 = srem i64 %113, 112, !dbg !294
  %126 = icmp slt i64 %125, 0, !dbg !294
  %127 = add nsw i64 %125, 112, !dbg !294
  %128 = select i1 %126, i64 %127, i64 %125, !dbg !294
  %.fr32 = freeze i64 %124, !dbg !294
  %129 = srem i64 %.fr32, 112, !dbg !294
  %130 = sub nsw i64 %.fr32, %129, !dbg !294
  %.idx33 = mul i64 %120, 50176, !dbg !294
  %131 = getelementptr i8, ptr %5, i64 %.idx33, !dbg !294
  %132 = getelementptr [4 x i8], ptr %131, i64 %130, !dbg !294
  %133 = getelementptr [4 x i8], ptr %132, i64 %128, !dbg !294
  %134 = load <1 x float>, ptr %133, align 4, !dbg !294
  %135 = shufflevector <1 x float> %134, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %136 = extractelement <4 x i64> %68, i64 3, !dbg !294
  %.frozen68 = freeze i64 %136, !dbg !294
  %137 = sdiv i64 %.frozen68, 12544, !dbg !294
  %138 = mul nsw i64 %137, 12544, !dbg !294
  %139 = icmp ne i64 %136, %138, !dbg !294
  %140 = icmp slt i64 %136, 0, !dbg !294
  %141 = and i1 %140, %139, !dbg !294
  %142 = sext i1 %141 to i64, !dbg !294
  %143 = add nsw i64 %137, %142, !dbg !294
  %144 = mul i64 %137, 12544, !dbg !294
  %.decomposed69 = sub i64 %.frozen68, %144, !dbg !294
  %145 = icmp slt i64 %.decomposed69, 0, !dbg !294
  %146 = add nsw i64 %.decomposed69, 12544, !dbg !294
  %147 = select i1 %145, i64 %146, i64 %.decomposed69, !dbg !294
  %148 = srem i64 %136, 112, !dbg !294
  %149 = icmp slt i64 %148, 0, !dbg !294
  %150 = add nsw i64 %148, 112, !dbg !294
  %151 = select i1 %149, i64 %150, i64 %148, !dbg !294
  %.fr34 = freeze i64 %147, !dbg !294
  %152 = srem i64 %.fr34, 112, !dbg !294
  %153 = sub nsw i64 %.fr34, %152, !dbg !294
  %.idx35 = mul i64 %143, 50176, !dbg !294
  %154 = getelementptr i8, ptr %5, i64 %.idx35, !dbg !294
  %155 = getelementptr [4 x i8], ptr %154, i64 %153, !dbg !294
  %156 = getelementptr [4 x i8], ptr %155, i64 %151, !dbg !294
  %157 = load <1 x float>, ptr %156, align 4, !dbg !294
  %158 = shufflevector <1 x float> %157, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %159 = add <4 x i64> %41, %67, !dbg !324
  %160 = extractelement <4 x i64> %159, i64 0, !dbg !324
  %.frozen70 = freeze i64 %160, !dbg !324
  %161 = sdiv i64 %.frozen70, 12544, !dbg !324
  %162 = mul nsw i64 %161, 12544, !dbg !324
  %163 = icmp ne i64 %160, %162, !dbg !324
  %164 = icmp slt i64 %160, 0, !dbg !324
  %165 = and i1 %164, %163, !dbg !324
  %166 = sext i1 %165 to i64, !dbg !324
  %167 = add nsw i64 %161, %166, !dbg !324
  %168 = mul i64 %161, 12544, !dbg !324
  %.decomposed71 = sub i64 %.frozen70, %168, !dbg !324
  %169 = icmp slt i64 %.decomposed71, 0, !dbg !324
  %170 = add nsw i64 %.decomposed71, 12544, !dbg !324
  %171 = select i1 %169, i64 %170, i64 %.decomposed71, !dbg !324
  %172 = srem i64 %160, 112, !dbg !324
  %173 = icmp slt i64 %172, 0, !dbg !324
  %174 = add nsw i64 %172, 112, !dbg !324
  %175 = select i1 %173, i64 %174, i64 %172, !dbg !324
  %.fr36 = freeze i64 %171, !dbg !324
  %176 = srem i64 %.fr36, 112, !dbg !324
  %177 = sub nsw i64 %.fr36, %176, !dbg !324
  %.idx37 = mul i64 %167, 50176, !dbg !324
  %178 = getelementptr i8, ptr %5, i64 %.idx37, !dbg !324
  %179 = getelementptr [4 x i8], ptr %178, i64 %177, !dbg !324
  %180 = getelementptr [4 x i8], ptr %179, i64 %175, !dbg !324
  %181 = load <1 x float>, ptr %180, align 4, !dbg !324
  %182 = extractelement <4 x i64> %159, i64 1, !dbg !324
  %.frozen72 = freeze i64 %182, !dbg !324
  %183 = sdiv i64 %.frozen72, 12544, !dbg !324
  %184 = mul nsw i64 %183, 12544, !dbg !324
  %185 = icmp ne i64 %182, %184, !dbg !324
  %186 = icmp slt i64 %182, 0, !dbg !324
  %187 = and i1 %186, %185, !dbg !324
  %188 = sext i1 %187 to i64, !dbg !324
  %189 = add nsw i64 %183, %188, !dbg !324
  %190 = mul i64 %183, 12544, !dbg !324
  %.decomposed73 = sub i64 %.frozen72, %190, !dbg !324
  %191 = icmp slt i64 %.decomposed73, 0, !dbg !324
  %192 = add nsw i64 %.decomposed73, 12544, !dbg !324
  %193 = select i1 %191, i64 %192, i64 %.decomposed73, !dbg !324
  %194 = srem i64 %182, 112, !dbg !324
  %195 = icmp slt i64 %194, 0, !dbg !324
  %196 = add nsw i64 %194, 112, !dbg !324
  %197 = select i1 %195, i64 %196, i64 %194, !dbg !324
  %.fr38 = freeze i64 %193, !dbg !324
  %198 = srem i64 %.fr38, 112, !dbg !324
  %199 = sub nsw i64 %.fr38, %198, !dbg !324
  %.idx39 = mul i64 %189, 50176, !dbg !324
  %200 = getelementptr i8, ptr %5, i64 %.idx39, !dbg !324
  %201 = getelementptr [4 x i8], ptr %200, i64 %199, !dbg !324
  %202 = getelementptr [4 x i8], ptr %201, i64 %197, !dbg !324
  %203 = load <1 x float>, ptr %202, align 4, !dbg !324
  %204 = extractelement <4 x i64> %159, i64 2, !dbg !324
  %.frozen74 = freeze i64 %204, !dbg !324
  %205 = sdiv i64 %.frozen74, 12544, !dbg !324
  %206 = mul nsw i64 %205, 12544, !dbg !324
  %207 = icmp ne i64 %204, %206, !dbg !324
  %208 = icmp slt i64 %204, 0, !dbg !324
  %209 = and i1 %208, %207, !dbg !324
  %210 = sext i1 %209 to i64, !dbg !324
  %211 = add nsw i64 %205, %210, !dbg !324
  %212 = mul i64 %205, 12544, !dbg !324
  %.decomposed75 = sub i64 %.frozen74, %212, !dbg !324
  %213 = icmp slt i64 %.decomposed75, 0, !dbg !324
  %214 = add nsw i64 %.decomposed75, 12544, !dbg !324
  %215 = select i1 %213, i64 %214, i64 %.decomposed75, !dbg !324
  %216 = srem i64 %204, 112, !dbg !324
  %217 = icmp slt i64 %216, 0, !dbg !324
  %218 = add nsw i64 %216, 112, !dbg !324
  %219 = select i1 %217, i64 %218, i64 %216, !dbg !324
  %.fr40 = freeze i64 %215, !dbg !324
  %220 = srem i64 %.fr40, 112, !dbg !324
  %221 = sub nsw i64 %.fr40, %220, !dbg !324
  %.idx41 = mul i64 %211, 50176, !dbg !324
  %222 = getelementptr i8, ptr %5, i64 %.idx41, !dbg !324
  %223 = getelementptr [4 x i8], ptr %222, i64 %221, !dbg !324
  %224 = getelementptr [4 x i8], ptr %223, i64 %219, !dbg !324
  %225 = load <1 x float>, ptr %224, align 4, !dbg !324
  %226 = shufflevector <1 x float> %225, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %227 = extractelement <4 x i64> %159, i64 3, !dbg !324
  %.frozen76 = freeze i64 %227, !dbg !324
  %228 = sdiv i64 %.frozen76, 12544, !dbg !324
  %229 = mul nsw i64 %228, 12544, !dbg !324
  %230 = icmp ne i64 %227, %229, !dbg !324
  %231 = icmp slt i64 %227, 0, !dbg !324
  %232 = and i1 %231, %230, !dbg !324
  %233 = sext i1 %232 to i64, !dbg !324
  %234 = add nsw i64 %228, %233, !dbg !324
  %235 = mul i64 %228, 12544, !dbg !324
  %.decomposed77 = sub i64 %.frozen76, %235, !dbg !324
  %236 = icmp slt i64 %.decomposed77, 0, !dbg !324
  %237 = add nsw i64 %.decomposed77, 12544, !dbg !324
  %238 = select i1 %236, i64 %237, i64 %.decomposed77, !dbg !324
  %239 = srem i64 %227, 112, !dbg !324
  %240 = icmp slt i64 %239, 0, !dbg !324
  %241 = add nsw i64 %239, 112, !dbg !324
  %242 = select i1 %240, i64 %241, i64 %239, !dbg !324
  %.fr42 = freeze i64 %238, !dbg !324
  %243 = srem i64 %.fr42, 112, !dbg !324
  %244 = sub nsw i64 %.fr42, %243, !dbg !324
  %.idx43 = mul i64 %234, 50176, !dbg !324
  %245 = getelementptr i8, ptr %5, i64 %.idx43, !dbg !324
  %246 = getelementptr [4 x i8], ptr %245, i64 %244, !dbg !324
  %247 = getelementptr [4 x i8], ptr %246, i64 %242, !dbg !324
  %248 = load <1 x float>, ptr %247, align 4, !dbg !324
  %249 = shufflevector <1 x float> %248, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %250 = add <4 x i64> %43, %65, !dbg !308
  %251 = extractelement <4 x i64> %250, i64 0, !dbg !308
  %.frozen78 = freeze i64 %251, !dbg !308
  %252 = sdiv i64 %.frozen78, 12544, !dbg !308
  %253 = mul nsw i64 %252, 12544, !dbg !308
  %254 = icmp ne i64 %251, %253, !dbg !308
  %255 = icmp slt i64 %251, 0, !dbg !308
  %256 = and i1 %255, %254, !dbg !308
  %257 = sext i1 %256 to i64, !dbg !308
  %258 = add nsw i64 %252, %257, !dbg !308
  %259 = mul i64 %252, 12544, !dbg !308
  %.decomposed79 = sub i64 %.frozen78, %259, !dbg !308
  %260 = icmp slt i64 %.decomposed79, 0, !dbg !308
  %261 = add nsw i64 %.decomposed79, 12544, !dbg !308
  %262 = select i1 %260, i64 %261, i64 %.decomposed79, !dbg !308
  %263 = srem i64 %251, 112, !dbg !308
  %264 = icmp slt i64 %263, 0, !dbg !308
  %265 = add nsw i64 %263, 112, !dbg !308
  %266 = select i1 %264, i64 %265, i64 %263, !dbg !308
  %.fr44 = freeze i64 %262, !dbg !308
  %267 = srem i64 %.fr44, 112, !dbg !308
  %268 = sub nsw i64 %.fr44, %267, !dbg !308
  %.idx45 = mul i64 %258, 50176, !dbg !308
  %269 = getelementptr i8, ptr %5, i64 %.idx45, !dbg !308
  %270 = getelementptr [4 x i8], ptr %269, i64 %268, !dbg !308
  %271 = getelementptr [4 x i8], ptr %270, i64 %266, !dbg !308
  %272 = load <1 x float>, ptr %271, align 4, !dbg !308
  %273 = extractelement <4 x i64> %250, i64 1, !dbg !308
  %.frozen80 = freeze i64 %273, !dbg !308
  %274 = sdiv i64 %.frozen80, 12544, !dbg !308
  %275 = mul nsw i64 %274, 12544, !dbg !308
  %276 = icmp ne i64 %273, %275, !dbg !308
  %277 = icmp slt i64 %273, 0, !dbg !308
  %278 = and i1 %277, %276, !dbg !308
  %279 = sext i1 %278 to i64, !dbg !308
  %280 = add nsw i64 %274, %279, !dbg !308
  %281 = mul i64 %274, 12544, !dbg !308
  %.decomposed81 = sub i64 %.frozen80, %281, !dbg !308
  %282 = icmp slt i64 %.decomposed81, 0, !dbg !308
  %283 = add nsw i64 %.decomposed81, 12544, !dbg !308
  %284 = select i1 %282, i64 %283, i64 %.decomposed81, !dbg !308
  %285 = srem i64 %273, 112, !dbg !308
  %286 = icmp slt i64 %285, 0, !dbg !308
  %287 = add nsw i64 %285, 112, !dbg !308
  %288 = select i1 %286, i64 %287, i64 %285, !dbg !308
  %.fr46 = freeze i64 %284, !dbg !308
  %289 = srem i64 %.fr46, 112, !dbg !308
  %290 = sub nsw i64 %.fr46, %289, !dbg !308
  %.idx47 = mul i64 %280, 50176, !dbg !308
  %291 = getelementptr i8, ptr %5, i64 %.idx47, !dbg !308
  %292 = getelementptr [4 x i8], ptr %291, i64 %290, !dbg !308
  %293 = getelementptr [4 x i8], ptr %292, i64 %288, !dbg !308
  %294 = load <1 x float>, ptr %293, align 4, !dbg !308
  %295 = extractelement <4 x i64> %250, i64 2, !dbg !308
  %.frozen82 = freeze i64 %295, !dbg !308
  %296 = sdiv i64 %.frozen82, 12544, !dbg !308
  %297 = mul nsw i64 %296, 12544, !dbg !308
  %298 = icmp ne i64 %295, %297, !dbg !308
  %299 = icmp slt i64 %295, 0, !dbg !308
  %300 = and i1 %299, %298, !dbg !308
  %301 = sext i1 %300 to i64, !dbg !308
  %302 = add nsw i64 %296, %301, !dbg !308
  %303 = mul i64 %296, 12544, !dbg !308
  %.decomposed83 = sub i64 %.frozen82, %303, !dbg !308
  %304 = icmp slt i64 %.decomposed83, 0, !dbg !308
  %305 = add nsw i64 %.decomposed83, 12544, !dbg !308
  %306 = select i1 %304, i64 %305, i64 %.decomposed83, !dbg !308
  %307 = srem i64 %295, 112, !dbg !308
  %308 = icmp slt i64 %307, 0, !dbg !308
  %309 = add nsw i64 %307, 112, !dbg !308
  %310 = select i1 %308, i64 %309, i64 %307, !dbg !308
  %.fr48 = freeze i64 %306, !dbg !308
  %311 = srem i64 %.fr48, 112, !dbg !308
  %312 = sub nsw i64 %.fr48, %311, !dbg !308
  %.idx49 = mul i64 %302, 50176, !dbg !308
  %313 = getelementptr i8, ptr %5, i64 %.idx49, !dbg !308
  %314 = getelementptr [4 x i8], ptr %313, i64 %312, !dbg !308
  %315 = getelementptr [4 x i8], ptr %314, i64 %310, !dbg !308
  %316 = load <1 x float>, ptr %315, align 4, !dbg !308
  %317 = shufflevector <1 x float> %316, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %318 = extractelement <4 x i64> %250, i64 3, !dbg !308
  %.frozen84 = freeze i64 %318, !dbg !308
  %319 = sdiv i64 %.frozen84, 12544, !dbg !308
  %320 = mul nsw i64 %319, 12544, !dbg !308
  %321 = icmp ne i64 %318, %320, !dbg !308
  %322 = icmp slt i64 %318, 0, !dbg !308
  %323 = and i1 %322, %321, !dbg !308
  %324 = sext i1 %323 to i64, !dbg !308
  %325 = add nsw i64 %319, %324, !dbg !308
  %326 = mul i64 %319, 12544, !dbg !308
  %.decomposed85 = sub i64 %.frozen84, %326, !dbg !308
  %327 = icmp slt i64 %.decomposed85, 0, !dbg !308
  %328 = add nsw i64 %.decomposed85, 12544, !dbg !308
  %329 = select i1 %327, i64 %328, i64 %.decomposed85, !dbg !308
  %330 = srem i64 %318, 112, !dbg !308
  %331 = icmp slt i64 %330, 0, !dbg !308
  %332 = add nsw i64 %330, 112, !dbg !308
  %333 = select i1 %331, i64 %332, i64 %330, !dbg !308
  %.fr50 = freeze i64 %329, !dbg !308
  %334 = srem i64 %.fr50, 112, !dbg !308
  %335 = sub nsw i64 %.fr50, %334, !dbg !308
  %.idx51 = mul i64 %325, 50176, !dbg !308
  %336 = getelementptr i8, ptr %5, i64 %.idx51, !dbg !308
  %337 = getelementptr [4 x i8], ptr %336, i64 %335, !dbg !308
  %338 = getelementptr [4 x i8], ptr %337, i64 %333, !dbg !308
  %339 = load <1 x float>, ptr %338, align 4, !dbg !308
  %340 = shufflevector <1 x float> %339, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %341 = add <4 x i64> %43, %67, !dbg !325
  %342 = extractelement <4 x i64> %341, i64 0, !dbg !325
  %.frozen86 = freeze i64 %342, !dbg !325
  %343 = sdiv i64 %.frozen86, 12544, !dbg !325
  %344 = mul nsw i64 %343, 12544, !dbg !325
  %345 = icmp ne i64 %342, %344, !dbg !325
  %346 = icmp slt i64 %342, 0, !dbg !325
  %347 = and i1 %346, %345, !dbg !325
  %348 = sext i1 %347 to i64, !dbg !325
  %349 = add nsw i64 %343, %348, !dbg !325
  %350 = mul i64 %343, 12544, !dbg !325
  %.decomposed87 = sub i64 %.frozen86, %350, !dbg !325
  %351 = icmp slt i64 %.decomposed87, 0, !dbg !325
  %352 = add nsw i64 %.decomposed87, 12544, !dbg !325
  %353 = select i1 %351, i64 %352, i64 %.decomposed87, !dbg !325
  %354 = srem i64 %342, 112, !dbg !325
  %355 = icmp slt i64 %354, 0, !dbg !325
  %356 = add nsw i64 %354, 112, !dbg !325
  %357 = select i1 %355, i64 %356, i64 %354, !dbg !325
  %.fr52 = freeze i64 %353, !dbg !325
  %358 = srem i64 %.fr52, 112, !dbg !325
  %359 = sub nsw i64 %.fr52, %358, !dbg !325
  %.idx53 = mul i64 %349, 50176, !dbg !325
  %360 = getelementptr i8, ptr %5, i64 %.idx53, !dbg !325
  %361 = getelementptr [4 x i8], ptr %360, i64 %359, !dbg !325
  %362 = getelementptr [4 x i8], ptr %361, i64 %357, !dbg !325
  %363 = load <1 x float>, ptr %362, align 4, !dbg !325
  %364 = extractelement <4 x i64> %341, i64 1, !dbg !325
  %.frozen88 = freeze i64 %364, !dbg !325
  %365 = sdiv i64 %.frozen88, 12544, !dbg !325
  %366 = mul nsw i64 %365, 12544, !dbg !325
  %367 = icmp ne i64 %364, %366, !dbg !325
  %368 = icmp slt i64 %364, 0, !dbg !325
  %369 = and i1 %368, %367, !dbg !325
  %370 = sext i1 %369 to i64, !dbg !325
  %371 = add nsw i64 %365, %370, !dbg !325
  %372 = mul i64 %365, 12544, !dbg !325
  %.decomposed89 = sub i64 %.frozen88, %372, !dbg !325
  %373 = icmp slt i64 %.decomposed89, 0, !dbg !325
  %374 = add nsw i64 %.decomposed89, 12544, !dbg !325
  %375 = select i1 %373, i64 %374, i64 %.decomposed89, !dbg !325
  %376 = srem i64 %364, 112, !dbg !325
  %377 = icmp slt i64 %376, 0, !dbg !325
  %378 = add nsw i64 %376, 112, !dbg !325
  %379 = select i1 %377, i64 %378, i64 %376, !dbg !325
  %.fr54 = freeze i64 %375, !dbg !325
  %380 = srem i64 %.fr54, 112, !dbg !325
  %381 = sub nsw i64 %.fr54, %380, !dbg !325
  %.idx55 = mul i64 %371, 50176, !dbg !325
  %382 = getelementptr i8, ptr %5, i64 %.idx55, !dbg !325
  %383 = getelementptr [4 x i8], ptr %382, i64 %381, !dbg !325
  %384 = getelementptr [4 x i8], ptr %383, i64 %379, !dbg !325
  %385 = load <1 x float>, ptr %384, align 4, !dbg !325
  %386 = extractelement <4 x i64> %341, i64 2, !dbg !325
  %.frozen90 = freeze i64 %386, !dbg !325
  %387 = sdiv i64 %.frozen90, 12544, !dbg !325
  %388 = mul nsw i64 %387, 12544, !dbg !325
  %389 = icmp ne i64 %386, %388, !dbg !325
  %390 = icmp slt i64 %386, 0, !dbg !325
  %391 = and i1 %390, %389, !dbg !325
  %392 = sext i1 %391 to i64, !dbg !325
  %393 = add nsw i64 %387, %392, !dbg !325
  %394 = mul i64 %387, 12544, !dbg !325
  %.decomposed91 = sub i64 %.frozen90, %394, !dbg !325
  %395 = icmp slt i64 %.decomposed91, 0, !dbg !325
  %396 = add nsw i64 %.decomposed91, 12544, !dbg !325
  %397 = select i1 %395, i64 %396, i64 %.decomposed91, !dbg !325
  %398 = srem i64 %386, 112, !dbg !325
  %399 = icmp slt i64 %398, 0, !dbg !325
  %400 = add nsw i64 %398, 112, !dbg !325
  %401 = select i1 %399, i64 %400, i64 %398, !dbg !325
  %.fr56 = freeze i64 %397, !dbg !325
  %402 = srem i64 %.fr56, 112, !dbg !325
  %403 = sub nsw i64 %.fr56, %402, !dbg !325
  %.idx57 = mul i64 %393, 50176, !dbg !325
  %404 = getelementptr i8, ptr %5, i64 %.idx57, !dbg !325
  %405 = getelementptr [4 x i8], ptr %404, i64 %403, !dbg !325
  %406 = getelementptr [4 x i8], ptr %405, i64 %401, !dbg !325
  %407 = load <1 x float>, ptr %406, align 4, !dbg !325
  %408 = shufflevector <1 x float> %407, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %409 = extractelement <4 x i64> %341, i64 3, !dbg !325
  %.frozen92 = freeze i64 %409, !dbg !325
  %410 = sdiv i64 %.frozen92, 12544, !dbg !325
  %411 = mul nsw i64 %410, 12544, !dbg !325
  %412 = icmp ne i64 %409, %411, !dbg !325
  %413 = icmp slt i64 %409, 0, !dbg !325
  %414 = and i1 %413, %412, !dbg !325
  %415 = sext i1 %414 to i64, !dbg !325
  %416 = add nsw i64 %410, %415, !dbg !325
  %417 = mul i64 %410, 12544, !dbg !325
  %.decomposed93 = sub i64 %.frozen92, %417, !dbg !325
  %418 = icmp slt i64 %.decomposed93, 0, !dbg !325
  %419 = add nsw i64 %.decomposed93, 12544, !dbg !325
  %420 = select i1 %418, i64 %419, i64 %.decomposed93, !dbg !325
  %421 = srem i64 %409, 112, !dbg !325
  %422 = icmp slt i64 %421, 0, !dbg !325
  %423 = add nsw i64 %421, 112, !dbg !325
  %424 = select i1 %422, i64 %423, i64 %421, !dbg !325
  %.fr58 = freeze i64 %420, !dbg !325
  %425 = srem i64 %.fr58, 112, !dbg !325
  %426 = sub nsw i64 %.fr58, %425, !dbg !325
  %.idx59 = mul i64 %416, 50176, !dbg !325
  %427 = getelementptr i8, ptr %5, i64 %.idx59, !dbg !325
  %428 = getelementptr [4 x i8], ptr %427, i64 %426, !dbg !325
  %429 = getelementptr [4 x i8], ptr %428, i64 %424, !dbg !325
  %430 = load <1 x float>, ptr %429, align 4, !dbg !325
  %431 = shufflevector <1 x float> %430, <1 x float> poison, <4 x i32> <i32 0, i32 poison, i32 poison, i32 poison>
  %432 = fsub contract <4 x float> %64, %61, !dbg !326
  %433 = fsub contract <4 x float> %61, %62, !dbg !327
  %434 = shufflevector <1 x float> %90, <1 x float> %112, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !328
  %435 = shufflevector <4 x float> %434, <4 x float> %135, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !328
  %436 = shufflevector <4 x float> %435, <4 x float> %158, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !328
  %437 = fmul contract <4 x float> %432, %436, !dbg !328
  %438 = shufflevector <1 x float> %181, <1 x float> %203, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !329
  %439 = shufflevector <4 x float> %438, <4 x float> %226, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !329
  %440 = shufflevector <4 x float> %439, <4 x float> %249, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !329
  %441 = fmul contract <4 x float> %433, %440, !dbg !329
  %442 = fadd contract <4 x float> %437, %441, !dbg !330
  %443 = fmul contract <4 x float> %45, %442, !dbg !331
  %444 = shufflevector <1 x float> %272, <1 x float> %294, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !332
  %445 = shufflevector <4 x float> %444, <4 x float> %317, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !332
  %446 = shufflevector <4 x float> %445, <4 x float> %340, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !332
  %447 = fmul contract <4 x float> %432, %446, !dbg !332
  %448 = shufflevector <1 x float> %363, <1 x float> %385, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>, !dbg !333
  %449 = shufflevector <4 x float> %448, <4 x float> %408, <4 x i32> <i32 0, i32 1, i32 4, i32 poison>, !dbg !333
  %450 = shufflevector <4 x float> %449, <4 x float> %431, <4 x i32> <i32 0, i32 1, i32 2, i32 4>, !dbg !333
  %451 = fmul contract <4 x float> %433, %450, !dbg !333
  %452 = fadd contract <4 x float> %447, %451, !dbg !334
  %453 = fmul contract <4 x float> %47, %452, !dbg !335
  %454 = fadd contract <4 x float> %443, %453, !dbg !336
  %455 = getelementptr [4 x i8], ptr %49, i64 %52, !dbg !293
  store <4 x float> %454, ptr %455, align 4, !dbg !293
  %456 = add nuw nsw i64 %51, 4, !dbg !293
  %457 = icmp samesign ult i64 %51, 52, !dbg !293
  br i1 %457, label %50, label %458, !dbg !293

458:                                              ; preds = %50
  %459 = add nuw nsw i64 %20, 1, !dbg !293
  %exitcond.not = icmp eq i64 %459, 56, !dbg !293
  br i1 %exitcond.not, label %460, label %19, !dbg !293

460:                                              ; preds = %458
  %461 = add nuw nsw i64 %16, 1, !dbg !293
  %exitcond62.not = icmp eq i64 %461, 64, !dbg !293
  br i1 %exitcond62.not, label %462, label %15, !dbg !293

462:                                              ; preds = %460
  ret i32 0, !dbg !337
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_16_conv_32x224x224x64x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !338 {
  %4 = alloca [4 x float], align 64, !dbg !339
  %5 = alloca [4 x float], align 64, !dbg !340
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !341
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !341
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !341
  %7 = getelementptr i8, ptr %6, i64 9633792, !dbg !341
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !341
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !342
  %9 = load ptr, ptr %8, align 8, !dbg !342
  %10 = getelementptr i8, ptr %9, i64 4136192, !dbg !342
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !342
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !343
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !344
  %12 = load ptr, ptr %11, align 8, !dbg !344
  %13 = getelementptr i8, ptr %12, i64 22709248, !dbg !344
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !344
  %14 = load i32, ptr %2, align 16, !dbg !339
  %.frozen = freeze i32 %14, !dbg !339
  %15 = udiv i32 %.frozen, 7, !dbg !339
  %.zext = zext nneg i32 %15 to i64, !dbg !339
  %16 = mul i32 %15, 7, !dbg !339
  %.decomposed = sub i32 %.frozen, %16, !dbg !339
  %17 = shl nuw nsw i64 %.zext, 5, !dbg !339
  %18 = shl nuw nsw i32 %.decomposed, 5, !dbg !339
  %19 = zext nneg i32 %18 to i64, !dbg !339
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !345
  br label %20, !dbg !339

20:                                               ; preds = %3, %84
  %21 = phi i64 [ 0, %3 ], [ %85, %84 ]
  %22 = getelementptr [4 x i8], ptr @__constant_32xf32_0, i64 %21, !dbg !346
  %23 = load <1 x float>, ptr %22, align 4, !dbg !346
  %.idx32 = mul nuw nsw i64 %21, 2304
  %24 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx32
  %.idx = mul nuw nsw i64 %21, 200704
  %25 = getelementptr i8, ptr %6, i64 %.idx
  %26 = shufflevector <1 x float> %23, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx28 = mul nuw nsw i64 %21, 204304
  %27 = getelementptr i8, ptr %13, i64 %.idx28
  br label %.preheader39, !dbg !339

.preheader39:                                     ; preds = %20, %82
  %28 = phi i64 [ 0, %20 ], [ %83, %82 ]
  %29 = add nuw nsw i64 %28, %17
  %.idx27 = mul nuw nsw i64 %29, 896
  %30 = getelementptr i8, ptr %25, i64 %.idx27
  %.idx29 = mul nuw nsw i64 %29, 904
  %31 = getelementptr i8, ptr %27, i64 %.idx29
  %32 = getelementptr i8, ptr %31, i64 908
  br label %33, !dbg !339

33:                                               ; preds = %.preheader39, %67
  %34 = phi i64 [ 0, %.preheader39 ], [ %80, %67 ]
  br label %36, !dbg !339

.preheader38:                                     ; preds = %36
  %35 = or disjoint i64 %34, %19, !dbg !339
  %invariant.gep40 = getelementptr [4 x i8], ptr %7, i64 %35, !dbg !339
  br label %.preheader37, !dbg !339

36:                                               ; preds = %33, %36
  %37 = phi i64 [ 0, %33 ], [ %41, %36 ]
  %38 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %37, !dbg !339
  %39 = load float, ptr %38, align 4, !dbg !339
  %40 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %37, !dbg !339
  store float %39, ptr %40, align 4, !dbg !339
  %41 = add nuw nsw i64 %37, 1, !dbg !339
  %exitcond.not = icmp eq i64 %41, 4, !dbg !339
  br i1 %exitcond.not, label %.preheader38, label %36, !dbg !339

.preheader37:                                     ; preds = %.preheader38, %65
  %42 = phi i64 [ 0, %.preheader38 ], [ %66, %65 ]
  %.idx30 = mul nuw nsw i64 %42, 204304
  %gep41 = getelementptr i8, ptr %invariant.gep40, i64 %.idx30, !dbg !339
  %.idx33 = mul nuw nsw i64 %42, 36
  %43 = getelementptr inbounds nuw i8, ptr %24, i64 %.idx33
  br label %44, !dbg !339

44:                                               ; preds = %.preheader37, %63
  %45 = phi i64 [ 0, %.preheader37 ], [ %64, %63 ]
  %46 = add nuw nsw i64 %29, %45, !dbg !339
  %.idx31 = mul nuw nsw i64 %46, 904
  %gep = getelementptr i8, ptr %gep41, i64 %.idx31
  %.idx34 = mul nuw nsw i64 %45, 12
  %47 = getelementptr inbounds nuw i8, ptr %43, i64 %.idx34
  br label %.preheader, !dbg !339

.preheader:                                       ; preds = %44, %61
  %48 = phi i64 [ 0, %44 ], [ %62, %61 ]
  %49 = getelementptr [4 x i8], ptr %gep, i64 %48
  %50 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %48
  %.promoted = load float, ptr %50, align 4
  br label %51, !dbg !339

51:                                               ; preds = %.preheader, %51
  %52 = phi i64 [ 0, %.preheader ], [ %60, %51 ]
  %53 = phi float [ %.promoted, %.preheader ], [ %59, %51 ]
  %54 = getelementptr [4 x i8], ptr %49, i64 %52, !dbg !339
  %55 = load float, ptr %54, align 4, !dbg !339
  %56 = getelementptr inbounds nuw [4 x i8], ptr %47, i64 %52, !dbg !339
  %57 = load float, ptr %56, align 4, !dbg !339
  %58 = fmul contract float %55, %57, !dbg !347
  %59 = fadd contract float %53, %58, !dbg !348
  %60 = add nuw nsw i64 %52, 1, !dbg !339
  %exitcond42.not = icmp eq i64 %60, 3, !dbg !339
  br i1 %exitcond42.not, label %61, label %51, !dbg !339

61:                                               ; preds = %51
  store float %59, ptr %50, align 4, !dbg !339
  %62 = add nuw nsw i64 %48, 1, !dbg !339
  %exitcond43.not = icmp eq i64 %62, 4, !dbg !339
  br i1 %exitcond43.not, label %63, label %.preheader, !dbg !339

63:                                               ; preds = %61
  %64 = add nuw nsw i64 %45, 1, !dbg !339
  %exitcond44.not = icmp eq i64 %64, 3, !dbg !339
  br i1 %exitcond44.not, label %65, label %44, !dbg !339

65:                                               ; preds = %63
  %66 = add nuw nsw i64 %42, 1, !dbg !339
  %exitcond45.not = icmp eq i64 %66, 64, !dbg !339
  br i1 %exitcond45.not, label %67, label %.preheader37, !dbg !339

67:                                               ; preds = %65
  %68 = getelementptr [4 x i8], ptr %30, i64 %35, !dbg !346
  %69 = load <4 x float>, ptr %68, align 16, !dbg !346
  %70 = load <4 x float>, ptr %4, align 64, !dbg !346
  %71 = fadd contract <4 x float> %26, %70, !dbg !349
  %72 = fcmp ogt <4 x float> %71, zeroinitializer, !dbg !350
  %73 = select <4 x i1> %72, <4 x float> zeroinitializer, <4 x float> %71, !dbg !351
  %74 = fmul contract <4 x float> %73, splat (float 0x3FC99999A0000000), !dbg !352
  %75 = fcmp olt <4 x float> %71, zeroinitializer, !dbg !353
  %76 = select <4 x i1> %75, <4 x float> zeroinitializer, <4 x float> %71, !dbg !354
  %77 = fadd contract <4 x float> %76, %74, !dbg !355
  %78 = fmul contract <4 x float> %69, %77, !dbg !356
  %79 = getelementptr [4 x i8], ptr %32, i64 %35, !dbg !339
  store <4 x float> %78, ptr %79, align 4, !dbg !339
  %80 = add nuw nsw i64 %34, 4, !dbg !339
  %81 = icmp samesign ult i64 %34, 28, !dbg !339
  br i1 %81, label %33, label %82, !dbg !339

82:                                               ; preds = %67
  %83 = add nuw nsw i64 %28, 1, !dbg !339
  %exitcond46.not = icmp eq i64 %83, 32, !dbg !339
  br i1 %exitcond46.not, label %84, label %.preheader39, !dbg !339

84:                                               ; preds = %82
  %85 = add nuw nsw i64 %21, 1, !dbg !339
  %exitcond47.not = icmp eq i64 %85, 32, !dbg !339
  br i1 %exitcond47.not, label %86, label %20, !dbg !339

86:                                               ; preds = %84
  ret i32 0, !dbg !357
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_17_conv_3x224x224x32x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !358 {
  %4 = alloca [4 x float], align 64, !dbg !359
  %5 = alloca [4 x float], align 64, !dbg !360
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !361
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !361
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !361
  %7 = getelementptr i8, ptr %6, i64 22709248, !dbg !361
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !361
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !362
  %9 = load ptr, ptr %8, align 8, !dbg !362
  %10 = getelementptr i8, ptr %9, i64 4132736, !dbg !362
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !362
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !363
  %12 = load ptr, ptr %11, align 8, !dbg !363
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !363
  %13 = getelementptr i8, ptr %.unpack24, i64 24, !dbg !364
  %14 = load ptr, ptr %13, align 8, !dbg !364
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !364
  %15 = load i32, ptr %2, align 16, !dbg !359
  %.frozen = freeze i32 %15, !dbg !359
  %16 = udiv i32 %.frozen, 7, !dbg !359
  %.zext = zext nneg i32 %16 to i64, !dbg !359
  %17 = mul i32 %16, 7, !dbg !359
  %.decomposed = sub i32 %.frozen, %17, !dbg !359
  %18 = shl nuw nsw i64 %.zext, 5, !dbg !359
  %19 = shl nuw nsw i32 %.decomposed, 5, !dbg !359
  %20 = zext nneg i32 %19 to i64, !dbg !359
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !365
  br label %21, !dbg !359

21:                                               ; preds = %3, %95
  %22 = phi i64 [ 0, %3 ], [ %96, %95 ]
  %23 = getelementptr [4 x i8], ptr @__constant_3xf32, i64 %22, !dbg !366
  %24 = load <1 x float>, ptr %23, align 4, !dbg !366
  %.idx29 = mul nuw nsw i64 %22, 1152
  %25 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx29
  %26 = mul nuw nsw i64 %22, 50176
  %27 = shufflevector <1 x float> %24, <1 x float> poison, <4 x i32> zeroinitializer
  br label %.preheader36, !dbg !359

.preheader36:                                     ; preds = %21, %93
  %28 = phi i64 [ 0, %21 ], [ %94, %93 ]
  %29 = add nuw nsw i64 %28, %18
  %30 = mul nuw nsw i64 %29, 224
  %31 = add nuw nsw i64 %30, %26
  br label %32, !dbg !359

32:                                               ; preds = %.preheader36, %66
  %33 = phi i64 [ 0, %.preheader36 ], [ %91, %66 ]
  br label %35, !dbg !359

.preheader35:                                     ; preds = %35
  %34 = or disjoint i64 %33, %20, !dbg !359
  %invariant.gep37 = getelementptr [4 x i8], ptr %7, i64 %34, !dbg !359
  br label %.preheader34, !dbg !359

35:                                               ; preds = %32, %35
  %36 = phi i64 [ 0, %32 ], [ %40, %35 ]
  %37 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %36, !dbg !359
  %38 = load float, ptr %37, align 4, !dbg !359
  %39 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %36, !dbg !359
  store float %38, ptr %39, align 4, !dbg !359
  %40 = add nuw nsw i64 %36, 1, !dbg !359
  %exitcond.not = icmp eq i64 %40, 4, !dbg !359
  br i1 %exitcond.not, label %.preheader35, label %35, !dbg !359

.preheader34:                                     ; preds = %.preheader35, %64
  %41 = phi i64 [ 0, %.preheader35 ], [ %65, %64 ]
  %.idx = mul nuw nsw i64 %41, 204304
  %gep38 = getelementptr i8, ptr %invariant.gep37, i64 %.idx, !dbg !359
  %.idx30 = mul nuw nsw i64 %41, 36
  %42 = getelementptr inbounds nuw i8, ptr %25, i64 %.idx30
  br label %43, !dbg !359

43:                                               ; preds = %.preheader34, %62
  %44 = phi i64 [ 0, %.preheader34 ], [ %63, %62 ]
  %45 = add nuw nsw i64 %29, %44, !dbg !359
  %.idx28 = mul nuw nsw i64 %45, 904
  %gep = getelementptr i8, ptr %gep38, i64 %.idx28
  %.idx31 = mul nuw nsw i64 %44, 12
  %46 = getelementptr inbounds nuw i8, ptr %42, i64 %.idx31
  br label %.preheader, !dbg !359

.preheader:                                       ; preds = %43, %60
  %47 = phi i64 [ 0, %43 ], [ %61, %60 ]
  %48 = getelementptr [4 x i8], ptr %gep, i64 %47
  %49 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %47
  %.promoted = load float, ptr %49, align 4
  br label %50, !dbg !359

50:                                               ; preds = %.preheader, %50
  %51 = phi i64 [ 0, %.preheader ], [ %59, %50 ]
  %52 = phi float [ %.promoted, %.preheader ], [ %58, %50 ]
  %53 = getelementptr [4 x i8], ptr %48, i64 %51, !dbg !359
  %54 = load float, ptr %53, align 4, !dbg !359
  %55 = getelementptr inbounds nuw [4 x i8], ptr %46, i64 %51, !dbg !359
  %56 = load float, ptr %55, align 4, !dbg !359
  %57 = fmul contract float %54, %56, !dbg !367
  %58 = fadd contract float %52, %57, !dbg !368
  %59 = add nuw nsw i64 %51, 1, !dbg !359
  %exitcond39.not = icmp eq i64 %59, 3, !dbg !359
  br i1 %exitcond39.not, label %60, label %50, !dbg !359

60:                                               ; preds = %50
  store float %58, ptr %49, align 4, !dbg !359
  %61 = add nuw nsw i64 %47, 1, !dbg !359
  %exitcond40.not = icmp eq i64 %61, 4, !dbg !359
  br i1 %exitcond40.not, label %62, label %.preheader, !dbg !359

62:                                               ; preds = %60
  %63 = add nuw nsw i64 %44, 1, !dbg !359
  %exitcond41.not = icmp eq i64 %63, 3, !dbg !359
  br i1 %exitcond41.not, label %64, label %43, !dbg !359

64:                                               ; preds = %62
  %65 = add nuw nsw i64 %41, 1, !dbg !359
  %exitcond42.not = icmp eq i64 %65, 32, !dbg !359
  br i1 %exitcond42.not, label %66, label %.preheader34, !dbg !359

66:                                               ; preds = %64
  %67 = add nuw i64 %31, %34, !dbg !366
  %68 = getelementptr [4 x i8], ptr %12, i64 %67, !dbg !366
  %69 = load <4 x float>, ptr %68, align 16, !dbg !366
  %70 = load <4 x float>, ptr %4, align 64, !dbg !366
  %71 = fadd contract <4 x float> %27, %70, !dbg !369
  %.inv = fcmp oge <4 x float> %71, splat (float 0x401FFEC880000000), !dbg !370
  %72 = select <4 x i1> %.inv, <4 x float> splat (float 0x401FFEC880000000), <4 x float> %71, !dbg !370
  %.inv27 = fcmp ole <4 x float> %72, splat (float 0xC01FFEC880000000), !dbg !370
  %73 = select <4 x i1> %.inv27, <4 x float> splat (float 0xC01FFEC880000000), <4 x float> %72, !dbg !370
  %74 = tail call <4 x float> @llvm.fabs.v4f32(<4 x float> %71), !dbg !370
  %75 = fcmp olt <4 x float> %74, splat (float 0x3F3A36E2E0000000), !dbg !370
  %76 = fmul contract <4 x float> %73, %73, !dbg !370
  %77 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> splat (float 0xBCB3E4B800000000), <4 x float> splat (float 0x3D4C266FC0000000)), !dbg !370
  %78 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %77, <4 x float> splat (float 0xBDD7A6FFE0000000)), !dbg !370
  %79 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %78, <4 x float> splat (float 0x3E6B800820000000)), !dbg !370
  %80 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %79, <4 x float> splat (float 0x3EEF286940000000)), !dbg !370
  %81 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %80, <4 x float> splat (float 0x3F44E1BDA0000000)), !dbg !370
  %82 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %81, <4 x float> splat (float 0x3F740B3B80000000)), !dbg !370
  %83 = fmul contract <4 x float> %73, %82, !dbg !370
  %84 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> splat (float 0x3EB41A7B00000000), <4 x float> splat (float 0x3F1F12BAC0000000)), !dbg !370
  %85 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %84, <4 x float> splat (float 0x3F629540A0000000)), !dbg !370
  %86 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %76, <4 x float> %85, <4 x float> splat (float 0x3F740B3BA0000000)), !dbg !370
  %87 = fdiv <4 x float> %83, %86, !dbg !370
  %88 = select <4 x i1> %75, <4 x float> %73, <4 x float> %87, !dbg !370
  %89 = fadd contract <4 x float> %69, %88, !dbg !371
  %90 = getelementptr [4 x i8], ptr %14, i64 %67, !dbg !359
  store <4 x float> %89, ptr %90, align 16, !dbg !359
  %91 = add nuw nsw i64 %33, 4, !dbg !359
  %92 = icmp samesign ult i64 %33, 28, !dbg !359
  br i1 %92, label %32, label %93, !dbg !359

93:                                               ; preds = %66
  %94 = add nuw nsw i64 %28, 1, !dbg !359
  %exitcond43.not = icmp eq i64 %94, 32, !dbg !359
  br i1 %exitcond43.not, label %95, label %.preheader36, !dbg !359

95:                                               ; preds = %93
  %96 = add nuw nsw i64 %22, 1, !dbg !359
  %exitcond44.not = icmp eq i64 %96, 3, !dbg !359
  br i1 %exitcond44.not, label %97, label %21, !dbg !359

97:                                               ; preds = %95
  ret i32 0, !dbg !372
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.floor.f32(float) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.floor.v4f32(<4 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fabs.v4f32(<4 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>) #2

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr readnone captures(none) %1) local_unnamed_addr #3 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @iree_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
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
define internal signext i16 @iree_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
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
define internal float @__gnu_h2f_ieee(i16 noundef signext %0) local_unnamed_addr #4 {
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
define internal float @__extendhfsf2(float noundef %0) local_unnamed_addr #4 {
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
define internal signext i16 @__gnu_f2h_ieee(float noundef %0) local_unnamed_addr #4 {
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
  %29 = add nsw i32 %25, %28
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
define internal float @__truncsfhf2(float noundef %0) local_unnamed_addr #4 {
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
  %30 = add nsw i32 %26, %29
  br label %31

31:                                               ; preds = %18, %16, %13, %8, %1
  %32 = phi i32 [ 31744, %8 ], [ %4, %1 ], [ %30, %18 ], [ 31744, %13 ], [ 0, %16 ]
  %33 = or i32 %32, %7
  %34 = trunc i32 %33 to i16
  br label %35

35:                                               ; preds = %10, %31
  %36 = phi i16 [ %12, %10 ], [ %34, %31 ]
  store i16 %36, ptr %2, align 4, !tbaa !373
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %.0..0..0..0.
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #5

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal double @__extendhfdf2(float noundef %0) local_unnamed_addr #4 {
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
define internal float @__truncdfhf2(double noundef %0) local_unnamed_addr #4 {
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
  store i16 %37, ptr %2, align 4, !tbaa !373
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  ret float %.0..0..0..0.
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef double @fma(double noundef %0, double noundef %1, double noundef %2) local_unnamed_addr #4 {
  %4 = tail call double @llvm.fmuladd.f64(double %0, double %1, double %2)
  ret double %4
}

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef float @__math_invalidf(float noundef %0) local_unnamed_addr #7 {
  %2 = fsub float %0, %0
  %3 = fdiv float %2, %2
  ret float %3
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_oflowf(i32 noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %.not.i = icmp eq i32 %0, 0
  %3 = select i1 %.not.i, float 0x4600000000000000, float 0xC600000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %3, ptr %2, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %4 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..i.i, 0x4600000000000000
  ret float %4
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_xflowf(i32 noundef %0, float noundef %1) local_unnamed_addr #8 {
  %3 = alloca float, align 4
  %.not = icmp eq i32 %0, 0
  %4 = fneg float %1
  %5 = select i1 %.not, float %1, float %4
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %5, ptr %3, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %6 = fmul float %1, %.0..0..0..0..0..0..0..0..0..0..i
  ret float %6
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @__math_uflowf(i32 noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %.not.i = icmp eq i32 %0, 0
  %3 = select i1 %.not.i, float 0x3A00000000000000, float 0xBA00000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float %3, ptr %2, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %4 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..i.i, 0x3A00000000000000
  ret float %4
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @ceilf(float noundef %0) local_unnamed_addr #8 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !375
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
  store volatile float %24, ptr %2, align 4, !tbaa !375
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

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @expf(float noundef %0) local_unnamed_addr #8 {
  %2 = alloca float, align 4
  %3 = alloca float, align 4
  %4 = fpext float %0 to double
  %5 = bitcast float %0 to i32
  %6 = lshr i32 %5, 20
  %7 = and i32 %6, 2047
  %.not = icmp samesign ult i32 %7, 1067
  br i1 %.not, label %21, label %8, !prof !377

8:                                                ; preds = %1
  %9 = fcmp oeq float %0, 0xFFF0000000000000
  br i1 %9, label %39, label %10

10:                                               ; preds = %8
  %.not34 = icmp samesign ult i32 %7, 2040
  br i1 %.not34, label %13, label %11

11:                                               ; preds = %10
  %12 = fadd float %0, %0
  br label %39

13:                                               ; preds = %10
  %14 = fcmp ogt float %0, 0x40562E42E0000000
  br i1 %14, label %15, label %17

15:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float 0x4600000000000000, ptr %3, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %3, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %16 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i, 0x4600000000000000
  br label %39

17:                                               ; preds = %13
  %18 = fcmp olt float %0, 0xC059FE3680000000
  br i1 %18, label %19, label %21

19:                                               ; preds = %17
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float 0x3A00000000000000, ptr %2, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i3 = load volatile float, ptr %2, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %2)
  %20 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i3, 0x3A00000000000000
  br label %39

21:                                               ; preds = %17, %1
  %22 = fmul double %4, 0x40471547652B82FE
  %23 = fadd double %22, 0x4338000000000000
  %24 = bitcast double %23 to i64
  %25 = fadd double %23, 0xC338000000000000
  %26 = fsub double %22, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw [8 x i8], ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !378
  %30 = shl i64 %24, 47
  %31 = add i64 %29, %30
  %32 = bitcast i64 %31 to double
  %33 = tail call double @llvm.fmuladd.f64(double %26, double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3)
  %34 = fmul double %26, %26
  %35 = tail call double @llvm.fmuladd.f64(double %26, double 0x3F962E42FF0C52D6, double 1.000000e+00)
  %36 = tail call double @llvm.fmuladd.f64(double %33, double %34, double %35)
  %37 = fmul double %36, %32
  %38 = fptrunc double %37 to float
  br label %39

39:                                               ; preds = %21, %19, %15, %11, %8
  %.0 = phi float [ %12, %11 ], [ %16, %15 ], [ %20, %19 ], [ %38, %21 ], [ 0.000000e+00, %8 ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @feclearexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @feraiseexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fetestexcept(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fegetround() local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @__fesetround(i32 noundef %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fegetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @fesetenv(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @floorf(float noundef %0) local_unnamed_addr #8 {
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
  store volatile float %16, ptr %3, align 4, !tbaa !375
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
  store volatile float %23, ptr %2, align 4, !tbaa !375
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

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @fmaf(float noundef %0, float noundef %1, float noundef %2) local_unnamed_addr #7 {
  %4 = fpext float %0 to double
  %5 = fpext float %1 to double
  %6 = fmul double %4, %5
  %7 = fpext float %2 to double
  %8 = fadd double %6, %7
  %9 = bitcast double %8 to i64
  %10 = and i64 %9, 536870911
  %11 = icmp ne i64 %10, 268435456
  %12 = and i64 %9, 9218868437227405312
  %13 = icmp eq i64 %12, 9218868437227405312
  %or.cond = or i1 %11, %13
  br i1 %or.cond, label %31, label %14

14:                                               ; preds = %3
  %15 = fsub double %8, %6
  %16 = fcmp oeq double %15, %7
  %17 = fsub double %8, %7
  %18 = fcmp oeq double %17, %6
  %or.cond44 = and i1 %16, %18
  br i1 %or.cond44, label %31, label %19

19:                                               ; preds = %14
  %20 = icmp slt i64 %9, 0
  %21 = fcmp uge double %6, %7
  %22 = xor i1 %21, %20
  %23 = fsub double %6, %8
  %24 = fadd double %23, %7
  %25 = fsub double %7, %8
  %26 = fadd double %6, %25
  %.038 = select i1 %22, double %24, double %26
  %27 = fcmp uge double %.038, 0.000000e+00
  %28 = xor i1 %20, %27
  %29 = or disjoint i64 %9, 1
  %30 = add nsw i64 %9, -1
  %.sroa.0.0.in = select i1 %28, i64 %29, i64 %30
  %.sroa.0.0 = bitcast i64 %.sroa.0.0.in to double
  br label %31

31:                                               ; preds = %3, %14, %19
  %.0.in = phi double [ %.sroa.0.0, %19 ], [ %8, %14 ], [ %8, %3 ]
  %.0 = fptrunc double %.0.in to float
  ret float %.0
}

; Function Attrs: inlinehint nofree norecurse nosync nounwind memory(none)
define internal float @fmodf(float noundef %0, float noundef %1) local_unnamed_addr #9 {
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

.lr.ph:                                           ; preds = %26, %.lr.ph
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

.lr.ph90:                                         ; preds = %38, %.lr.ph90
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

.lr.ph96:                                         ; preds = %49, %57
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

.lr.ph103:                                        ; preds = %67, %.lr.ph103
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

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fabs.f32(float) #6

; Function Attrs: inlinehint nofree nosync nounwind memory(argmem: readwrite)
define internal float @frexpf(float noundef %0, ptr noundef captures(none) %1) local_unnamed_addr #10 {
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
  %9 = tail call float @frexpf(float noundef %8, ptr noundef %1) #11
  %10 = load i32, ptr %1, align 4, !tbaa !27
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !27
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !27
  %16 = and i32 %3, -2139095041
  %17 = or disjoint i32 %16, 1056964608
  %18 = bitcast i32 %17 to float
  br label %19

19:                                               ; preds = %13, %12, %2
  %.0 = phi float [ %18, %13 ], [ %.014, %12 ], [ %0, %2 ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @ldexpf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = icmp sgt i32 %1, 127
  br i1 %3, label %4, label %11

4:                                                ; preds = %2
  %5 = fmul float %0, 0x47E0000000000000
  %6 = add nsw i32 %1, -127
  %7 = icmp samesign ugt i32 %1, 254
  br i1 %7, label %8, label %scalbnf.exit

8:                                                ; preds = %4
  %9 = fmul float %5, 0x47E0000000000000
  %10 = tail call i32 @llvm.umin.i32(i32 %1, i32 381)
  %spec.store.select.i = add nsw i32 %10, -254
  br label %scalbnf.exit

11:                                               ; preds = %2
  %12 = icmp slt i32 %1, -126
  br i1 %12, label %13, label %scalbnf.exit

13:                                               ; preds = %11
  %14 = fmul float %0, 0x3990000000000000
  %15 = add nuw nsw i32 %1, 102
  %16 = icmp samesign ult i32 %1, -228
  br i1 %16, label %17, label %scalbnf.exit

17:                                               ; preds = %13
  %18 = fmul float %14, 0x3990000000000000
  %19 = tail call i32 @llvm.umax.i32(i32 %1, i32 -330)
  %spec.store.select1.i = add nuw nsw i32 %19, 204
  br label %scalbnf.exit

scalbnf.exit:                                     ; preds = %4, %8, %11, %13, %17
  %.018.i = phi i32 [ %spec.store.select.i, %8 ], [ %6, %4 ], [ %spec.store.select1.i, %17 ], [ %15, %13 ], [ %1, %11 ]
  %.0.i = phi float [ %9, %8 ], [ %5, %4 ], [ %18, %17 ], [ %14, %13 ], [ %0, %11 ]
  %20 = shl nsw i32 %.018.i, 23
  %21 = add nsw i32 %20, 1065353216
  %22 = bitcast i32 %21 to float
  %23 = fmul float %.0.i, %22
  ret float %23
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal float @scalbnf(float noundef %0, i32 noundef %1) local_unnamed_addr #7 {
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

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #6

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #6

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @powf(float noundef %0, float noundef %1) local_unnamed_addr #8 {
  %3 = alloca float, align 4
  %4 = alloca float, align 4
  %5 = alloca float, align 4
  %6 = bitcast float %0 to i32
  %7 = bitcast float %1 to i32
  %8 = add i32 %6, -2139095040
  %9 = icmp ult i32 %8, -2130706432
  %.pre = shl i32 %7, 1
  %10 = add i32 %.pre, 16777216
  %11 = icmp ult i32 %10, 16777217
  %or.cond99 = or i1 %9, %11
  br i1 %or.cond99, label %.critedge, label %76, !prof !380

.critedge:                                        ; preds = %2
  %12 = add i32 %.pre, -1
  %13 = icmp ult i32 %12, -16777217
  br i1 %13, label %30, label %14, !prof !377

14:                                               ; preds = %.critedge
  %15 = icmp eq i32 %.pre, 0
  %16 = icmp eq i32 %6, 1065353216
  %or.cond70 = or i1 %16, %15
  br i1 %or.cond70, label %134, label %17

17:                                               ; preds = %14
  %18 = shl i32 %6, 1
  %19 = icmp ugt i32 %18, -16777216
  %20 = icmp samesign ugt i32 %.pre, -16777216
  %or.cond = or i1 %19, %20
  br i1 %or.cond, label %21, label %23

21:                                               ; preds = %17
  %22 = fadd float %0, %1
  br label %134

23:                                               ; preds = %17
  %24 = icmp eq i32 %18, 2130706432
  br i1 %24, label %134, label %25

25:                                               ; preds = %23
  %26 = icmp ult i32 %18, 2130706432
  %27 = icmp slt i32 %7, 0
  %28 = xor i1 %26, %27
  %29 = fmul float %1, %1
  %spec.select71 = select i1 %28, float 0.000000e+00, float %29
  br label %134

30:                                               ; preds = %.critedge
  %31 = shl i32 %6, 1
  %32 = add i32 %31, -1
  %33 = icmp ult i32 %32, -16777217
  br i1 %33, label %49, label %34, !prof !377

34:                                               ; preds = %30
  %35 = fmul float %0, %0
  %.not66 = icmp sgt i32 %6, -1
  br i1 %.not66, label %checkint.exit.thread, label %36

36:                                               ; preds = %34
  %37 = lshr i32 %7, 23
  %38 = and i32 %37, 255
  %39 = add nsw i32 %38, -151
  %or.cond92 = icmp ult i32 %39, -24
  br i1 %or.cond92, label %checkint.exit.thread, label %40

40:                                               ; preds = %36
  %41 = sub nuw nsw i32 150, %38
  %42 = shl nuw nsw i32 1, %41
  %43 = add nsw i32 %42, -1
  %44 = and i32 %43, %7
  %.not.i = icmp ne i32 %44, 0
  %45 = and i32 %42, %7
  %.not9.i = icmp eq i32 %45, 0
  %or.cond93 = or i1 %.not9.i, %.not.i
  %46 = fneg float %35
  %spec.select = select i1 %or.cond93, float %35, float %46
  br label %checkint.exit.thread

checkint.exit.thread:                             ; preds = %40, %36, %34
  %.057 = phi float [ %35, %34 ], [ %35, %36 ], [ %spec.select, %40 ]
  %.not67 = icmp sgt i32 %7, -1
  br i1 %.not67, label %134, label %47

47:                                               ; preds = %checkint.exit.thread
  %48 = fdiv float 1.000000e+00, %.057
  call void @llvm.lifetime.start.p0(ptr nonnull %5)
  store volatile float %48, ptr %5, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %5, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %5)
  br label %134

49:                                               ; preds = %30
  %.not64 = icmp sgt i32 %6, -1
  br i1 %.not64, label %69, label %50

50:                                               ; preds = %49
  %51 = lshr i32 %7, 23
  %52 = and i32 %51, 255
  %53 = icmp samesign ult i32 %52, 127
  br i1 %53, label %.thread, label %54

54:                                               ; preds = %50
  %55 = icmp samesign ugt i32 %52, 150
  br i1 %55, label %checkint.exit76.thread85, label %56

56:                                               ; preds = %54
  %57 = sub nuw nsw i32 150, %52
  %58 = shl nuw nsw i32 1, %57
  %59 = add nsw i32 %58, -1
  %60 = and i32 %59, %7
  %.not.i72 = icmp eq i32 %60, 0
  br i1 %.not.i72, label %61, label %.thread

61:                                               ; preds = %56
  %62 = and i32 %58, %7
  %.not9.i74 = icmp eq i32 %62, 0
  br i1 %.not9.i74, label %checkint.exit76.thread85, label %65

.thread:                                          ; preds = %56, %50
  %63 = fsub float %0, %0
  %64 = fdiv float %63, %63
  br label %134

checkint.exit76.thread85:                         ; preds = %61, %54
  br label %65

65:                                               ; preds = %checkint.exit76.thread85, %61
  %66 = phi i32 [ 0, %checkint.exit76.thread85 ], [ 65536, %61 ]
  %67 = tail call float @llvm.fabs.f32(float %0)
  %68 = bitcast float %67 to i32
  br label %69

69:                                               ; preds = %65, %49
  %.154 = phi i32 [ %68, %65 ], [ %6, %49 ]
  %.151 = phi i32 [ %66, %65 ], [ 0, %49 ]
  %70 = icmp ult i32 %.154, 8388608
  br i1 %70, label %71, label %76

71:                                               ; preds = %69
  %72 = fmul float %0, 0x4160000000000000
  %73 = tail call float @llvm.fabs.f32(float %72)
  %74 = bitcast float %73 to i32
  %75 = add nsw i32 %74, -192937984
  br label %76

76:                                               ; preds = %71, %69, %2
  %.053 = phi i32 [ %75, %71 ], [ %.154, %69 ], [ %6, %2 ]
  %.050 = phi i32 [ %.151, %71 ], [ %.151, %69 ], [ 0, %2 ]
  %77 = add i32 %.053, -1060306944
  %78 = lshr i32 %77, 19
  %79 = and i32 %78, 15
  %80 = and i32 %77, -8388608
  %81 = sub i32 %.053, %80
  %82 = ashr i32 %77, 23
  %83 = zext nneg i32 %79 to i64
  %84 = getelementptr inbounds nuw [16 x i8], ptr @__powf_log2_data, i64 %83
  %85 = load double, ptr %84, align 8, !tbaa !381
  %86 = getelementptr inbounds nuw i8, ptr %84, i64 8
  %87 = load double, ptr %86, align 8, !tbaa !384
  %88 = bitcast i32 %81 to float
  %89 = fpext float %88 to double
  %90 = tail call double @llvm.fmuladd.f64(double %89, double %85, double -1.000000e+00)
  %91 = sitofp i32 %82 to double
  %92 = fadd double %87, %91
  %93 = fmul double %90, %90
  %94 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A)
  %95 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8)
  %96 = fmul double %93, %93
  %97 = tail call double @llvm.fmuladd.f64(double %90, double 0x3FF71547652AB82B, double %92)
  %98 = tail call double @llvm.fmuladd.f64(double %95, double %93, double %97)
  %99 = tail call double @llvm.fmuladd.f64(double %94, double %96, double %98)
  %100 = fpext float %1 to double
  %101 = fmul double %99, %100
  %102 = bitcast double %101 to i64
  %103 = and i64 %102, 9223231299366420480
  %104 = icmp samesign ugt i64 %103, 4638426141214900224
  br i1 %104, label %105, label %115, !prof !385

105:                                              ; preds = %76
  %106 = fcmp ogt double %101, 0x405FFFFFFFD1D571
  br i1 %106, label %107, label %110

107:                                              ; preds = %105
  %.not.i.i = icmp eq i32 %.050, 0
  %108 = select i1 %.not.i.i, float 0x4600000000000000, float 0xC600000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %4)
  store volatile float %108, ptr %4, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %4, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %4)
  %109 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i, 0x4600000000000000
  br label %134

110:                                              ; preds = %105
  %111 = fcmp ugt double %101, -1.500000e+02
  br i1 %111, label %115, label %112

112:                                              ; preds = %110
  %.not.i.i5 = icmp eq i32 %.050, 0
  %113 = select i1 %.not.i.i5, float 0x3A00000000000000, float 0xBA00000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %3)
  store volatile float %113, ptr %3, align 4, !tbaa !375
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i6 = load volatile float, ptr %3, align 4, !tbaa !375
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %114 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i6, 0x3A00000000000000
  br label %134

115:                                              ; preds = %110, %76
  %116 = fadd double %101, 0x42E8000000000000
  %117 = bitcast double %116 to i64
  %118 = fadd double %116, 0xC2E8000000000000
  %119 = fsub double %101, %118
  %120 = and i64 %117, 31
  %121 = getelementptr inbounds nuw [8 x i8], ptr @__exp2f_data, i64 %120
  %122 = load i64, ptr %121, align 8, !tbaa !378
  %123 = zext nneg i32 %.050 to i64
  %124 = add i64 %117, %123
  %125 = shl i64 %124, 47
  %126 = add i64 %122, %125
  %127 = bitcast i64 %126 to double
  %128 = tail call double @llvm.fmuladd.f64(double %119, double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3)
  %129 = fmul double %119, %119
  %130 = tail call double @llvm.fmuladd.f64(double %119, double 0x3FE62E42FF0C52D6, double 1.000000e+00)
  %131 = tail call double @llvm.fmuladd.f64(double %128, double %129, double %130)
  %132 = fmul double %131, %127
  %133 = fptrunc double %132 to float
  br label %134

134:                                              ; preds = %115, %112, %107, %.thread, %47, %checkint.exit.thread, %25, %23, %21, %14
  %.0 = phi float [ %22, %21 ], [ 1.000000e+00, %14 ], [ 1.000000e+00, %23 ], [ %.0..0..0..0..0..0..0..0..0..0..i, %47 ], [ %.057, %checkint.exit.thread ], [ %109, %107 ], [ %114, %112 ], [ %133, %115 ], [ %spec.select71, %25 ], [ %64, %.thread ]
  ret float %.0
}

; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef float @rintf(float noundef %0) local_unnamed_addr #7 {
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

; Function Attrs: inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite)
define internal float @roundf(float noundef %0) local_unnamed_addr #8 {
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
  store volatile float %9, ptr %2, align 4, !tbaa !375
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

attributes #0 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "nonlazybind" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #5 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #8 = { inlinehint nofree norecurse nounwind memory(inaccessiblemem: readwrite) }
attributes #9 = { inlinehint nofree norecurse nosync nounwind memory(none) }
attributes #10 = { inlinehint nofree nosync nounwind memory(argmem: readwrite) }
attributes #11 = { inlinehint }

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22}
!llvm.module.flags = !{!24, !25, !26}
!llvm.errno.tbaa = !{!27}

!0 = distinct !DICompileUnit(language: DW_LANG_C17, file: !1, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "configured_module_infer_dispatch_0.mlir", directory: "dump")
!2 = distinct !DICompileUnit(language: DW_LANG_C17, file: !3, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!3 = !DIFile(filename: "configured_module_infer_dispatch_1.mlir", directory: "dump")
!4 = distinct !DICompileUnit(language: DW_LANG_C17, file: !5, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!5 = !DIFile(filename: "configured_module_infer_dispatch_2.mlir", directory: "dump")
!6 = distinct !DICompileUnit(language: DW_LANG_C17, file: !7, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!7 = !DIFile(filename: "configured_module_infer_dispatch_3.mlir", directory: "dump")
!8 = distinct !DICompileUnit(language: DW_LANG_C17, file: !9, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!9 = !DIFile(filename: "configured_module_infer_dispatch_4.mlir", directory: "dump")
!10 = distinct !DICompileUnit(language: DW_LANG_C17, file: !11, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!11 = !DIFile(filename: "configured_module_infer_dispatch_5.mlir", directory: "dump")
!12 = distinct !DICompileUnit(language: DW_LANG_C17, file: !13, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!13 = !DIFile(filename: "configured_module_infer_dispatch_6.mlir", directory: "dump")
!14 = distinct !DICompileUnit(language: DW_LANG_C17, file: !15, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!15 = !DIFile(filename: "configured_module_infer_dispatch_13.mlir", directory: "dump")
!16 = distinct !DICompileUnit(language: DW_LANG_C17, file: !17, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!17 = !DIFile(filename: "configured_module_infer_dispatch_14.mlir", directory: "dump")
!18 = distinct !DICompileUnit(language: DW_LANG_C17, file: !19, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!19 = !DIFile(filename: "configured_module_infer_dispatch_15.mlir", directory: "dump")
!20 = distinct !DICompileUnit(language: DW_LANG_C17, file: !21, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!21 = !DIFile(filename: "configured_module_infer_dispatch_16.mlir", directory: "dump")
!22 = distinct !DICompileUnit(language: DW_LANG_C17, file: !23, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!23 = !DIFile(filename: "configured_module_infer_dispatch_17.mlir", directory: "dump")
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 7, !"frame-pointer", i32 4}
!27 = !{!28, !28, i64 0}
!28 = !{!"int", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_like_32x50176x3_f32", linkageName: "infer_dispatch_0_matmul_like_32x50176x3_f32", scope: !1, file: !1, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!32 = !DISubroutineType(cc: DW_CC_normal, types: !33)
!33 = !{!34, !35, !66, !95}
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !37)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !39, file: !39, line: 246, size: 768, elements: !40)
!39 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!40 = !{!41, !49, !52, !55, !57}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !44)
!44 = !DICompositeType(tag: DW_TAG_array_type, scope: !39, file: !39, line: 227, baseType: !45, size: 2048, elements: !47)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !46)
!46 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!47 = !{!48}
!48 = !DISubrange(count: 64)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !50, size: 64, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !53, size: 64, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !50)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !56, size: 64, offset: 192)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !58, offset: 256)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !39, file: !39, line: 227, size: 512, elements: !59)
!59 = !{!60}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !61)
!61 = !DICompositeType(tag: DW_TAG_array_type, scope: !39, file: !39, line: 227, baseType: !62, size: 512, elements: !64)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !63)
!63 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!64 = !{!65}
!65 = !DISubrange(count: 8)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !69)
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !39, file: !39, line: 275, size: 384, elements: !70)
!70 = !{!71, !72, !73, !76, !77, !78, !79, !80, !83, !84, !85, !90}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !45, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !45, size: 32, offset: 32)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !74, size: 16, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !75)
!75 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !74, size: 16, offset: 80)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !45, size: 32, offset: 96)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !45, size: 32, offset: 128)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !74, size: 16, offset: 160)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !81, size: 8, offset: 176)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !82)
!82 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !81, size: 8, offset: 184)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !42, size: 64, offset: 192)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !86, size: 64, offset: 256)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !88)
!88 = !DICompositeType(tag: DW_TAG_array_type, scope: !39, file: !39, line: 227, baseType: !89, size: 4096, elements: !47)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !91, size: 64, offset: 320)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !93)
!93 = !DICompositeType(tag: DW_TAG_array_type, scope: !39, file: !39, line: 227, baseType: !94, size: 4096, elements: !47)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !62)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !98)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !39, file: !39, line: 321, size: 256, elements: !99)
!99 = !{!100, !101, !102, !103, !104, !105, !106}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !45, size: 32)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !45, size: 32, offset: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !74, size: 16, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !74, size: 16, offset: 80)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !45, size: 32, offset: 96)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !50, size: 64, offset: 128)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !45, size: 32, offset: 192)
!107 = !DILocation(line: 13, column: 8, scope: !31)
!108 = !DILocation(line: 14, column: 8, scope: !31)
!109 = !DILocation(line: 15, column: 8, scope: !31)
!110 = !DILocation(line: 20, column: 8, scope: !31)
!111 = !DILocation(line: 26, column: 8, scope: !31)
!112 = !DILocation(line: 23, column: 10, scope: !31)
!113 = !DILocation(line: 28, column: 10, scope: !31)
!114 = !DILocation(line: 29, column: 10, scope: !31)
!115 = !DILocation(line: 30, column: 10, scope: !31)
!116 = !DILocation(line: 31, column: 10, scope: !31)
!117 = !DILocation(line: 32, column: 10, scope: !31)
!118 = !DILocation(line: 33, column: 10, scope: !31)
!119 = !DILocation(line: 34, column: 10, scope: !31)
!120 = !DILocation(line: 38, column: 8, scope: !31)
!121 = distinct !DISubprogram(name: "infer_dispatch_1_slow_memcpy", linkageName: "infer_dispatch_1_slow_memcpy", scope: !3, file: !3, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!122 = !DILocation(line: 11, column: 8, scope: !121)
!123 = !DILocation(line: 12, column: 8, scope: !121)
!124 = !DILocation(line: 13, column: 8, scope: !121)
!125 = !DILocation(line: 14, column: 8, scope: !121)
!126 = !DILocation(line: 16, column: 8, scope: !121)
!127 = !DILocation(line: 20, column: 8, scope: !121)
!128 = distinct !DISubprogram(name: "infer_dispatch_2_conv_64x224x224x32x3x3_f32", linkageName: "infer_dispatch_2_conv_64x224x224x32x3x3_f32", scope: !5, file: !5, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!129 = !DILocation(line: 22, column: 8, scope: !128)
!130 = !DILocation(line: 21, column: 8, scope: !128)
!131 = !DILocation(line: 15, column: 8, scope: !128)
!132 = !DILocation(line: 16, column: 8, scope: !128)
!133 = !DILocation(line: 17, column: 8, scope: !128)
!134 = !DILocation(line: 9, column: 8, scope: !128)
!135 = !DILocation(line: 28, column: 8, scope: !128)
!136 = !DILocation(line: 24, column: 10, scope: !128)
!137 = !DILocation(line: 25, column: 10, scope: !128)
!138 = !DILocation(line: 30, column: 10, scope: !128)
!139 = !DILocation(line: 31, column: 10, scope: !128)
!140 = !DILocation(line: 32, column: 10, scope: !128)
!141 = !DILocation(line: 33, column: 10, scope: !128)
!142 = !DILocation(line: 34, column: 10, scope: !128)
!143 = !DILocation(line: 35, column: 10, scope: !128)
!144 = !DILocation(line: 36, column: 10, scope: !128)
!145 = !DILocation(line: 40, column: 8, scope: !128)
!146 = distinct !DISubprogram(name: "infer_dispatch_3_conv_128x224x224x64x3x3_f32", linkageName: "infer_dispatch_3_conv_128x224x224x64x3x3_f32", scope: !7, file: !7, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!147 = !DILocation(line: 24, column: 8, scope: !146)
!148 = !DILocation(line: 23, column: 8, scope: !146)
!149 = !DILocation(line: 15, column: 8, scope: !146)
!150 = !DILocation(line: 16, column: 8, scope: !146)
!151 = !DILocation(line: 17, column: 8, scope: !146)
!152 = !DILocation(line: 18, column: 8, scope: !146)
!153 = !DILocation(line: 9, column: 8, scope: !146)
!154 = !DILocation(line: 30, column: 8, scope: !146)
!155 = !DILocation(line: 26, column: 10, scope: !146)
!156 = !DILocation(line: 27, column: 10, scope: !146)
!157 = !DILocation(line: 32, column: 10, scope: !146)
!158 = !DILocation(line: 33, column: 10, scope: !146)
!159 = !DILocation(line: 34, column: 10, scope: !146)
!160 = !DILocation(line: 35, column: 10, scope: !146)
!161 = !DILocation(line: 36, column: 10, scope: !146)
!162 = !DILocation(line: 37, column: 10, scope: !146)
!163 = !DILocation(line: 38, column: 10, scope: !146)
!164 = !DILocation(line: 42, column: 8, scope: !146)
!165 = distinct !DISubprogram(name: "infer_dispatch_4_slow_memcpy", linkageName: "infer_dispatch_4_slow_memcpy", scope: !9, file: !9, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!166 = !DILocation(line: 9, column: 8, scope: !165)
!167 = !DILocation(line: 10, column: 8, scope: !165)
!168 = !DILocation(line: 17, column: 8, scope: !165)
!169 = !DILocation(line: 18, column: 8, scope: !165)
!170 = !DILocation(line: 19, column: 8, scope: !165)
!171 = !DILocation(line: 20, column: 8, scope: !165)
!172 = !DILocation(line: 22, column: 8, scope: !165)
!173 = !DILocation(line: 26, column: 8, scope: !165)
!174 = distinct !DISubprogram(name: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", scope: !11, file: !11, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!175 = !DILocation(line: 34, column: 8, scope: !174)
!176 = !DILocation(line: 33, column: 8, scope: !174)
!177 = !DILocation(line: 11, column: 8, scope: !174)
!178 = !DILocation(line: 12, column: 8, scope: !174)
!179 = !DILocation(line: 13, column: 8, scope: !174)
!180 = !DILocation(line: 14, column: 8, scope: !174)
!181 = !DILocation(line: 25, column: 8, scope: !174)
!182 = !DILocation(line: 26, column: 8, scope: !174)
!183 = !DILocation(line: 27, column: 8, scope: !174)
!184 = !DILocation(line: 28, column: 8, scope: !174)
!185 = !DILocation(line: 10, column: 8, scope: !174)
!186 = !DILocation(line: 40, column: 8, scope: !174)
!187 = !DILocation(line: 36, column: 10, scope: !174)
!188 = !DILocation(line: 37, column: 10, scope: !174)
!189 = !DILocation(line: 42, column: 10, scope: !174)
!190 = !DILocation(line: 43, column: 10, scope: !174)
!191 = !DILocation(line: 44, column: 10, scope: !174)
!192 = !DILocation(line: 45, column: 10, scope: !174)
!193 = !DILocation(line: 46, column: 10, scope: !174)
!194 = !DILocation(line: 47, column: 10, scope: !174)
!195 = !DILocation(line: 48, column: 10, scope: !174)
!196 = !DILocation(line: 52, column: 8, scope: !174)
!197 = distinct !DISubprogram(name: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", scope: !13, file: !13, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!198 = !DILocation(line: 39, column: 8, scope: !197)
!199 = !DILocation(line: 38, column: 8, scope: !197)
!200 = !DILocation(line: 11, column: 8, scope: !197)
!201 = !DILocation(line: 12, column: 8, scope: !197)
!202 = !DILocation(line: 13, column: 8, scope: !197)
!203 = !DILocation(line: 14, column: 8, scope: !197)
!204 = !DILocation(line: 15, column: 8, scope: !197)
!205 = !DILocation(line: 28, column: 8, scope: !197)
!206 = !DILocation(line: 29, column: 8, scope: !197)
!207 = !DILocation(line: 30, column: 8, scope: !197)
!208 = !DILocation(line: 31, column: 8, scope: !197)
!209 = !DILocation(line: 32, column: 8, scope: !197)
!210 = !DILocation(line: 10, column: 8, scope: !197)
!211 = !DILocation(line: 45, column: 8, scope: !197)
!212 = !DILocation(line: 41, column: 10, scope: !197)
!213 = !DILocation(line: 42, column: 10, scope: !197)
!214 = !DILocation(line: 47, column: 10, scope: !197)
!215 = !DILocation(line: 48, column: 10, scope: !197)
!216 = !DILocation(line: 49, column: 10, scope: !197)
!217 = !DILocation(line: 50, column: 10, scope: !197)
!218 = !DILocation(line: 51, column: 10, scope: !197)
!219 = !DILocation(line: 52, column: 10, scope: !197)
!220 = !DILocation(line: 53, column: 10, scope: !197)
!221 = !DILocation(line: 54, column: 10, scope: !197)
!222 = !DILocation(line: 58, column: 8, scope: !197)
!223 = distinct !DISubprogram(name: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", linkageName: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", scope: !15, file: !15, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!224 = !DILocation(line: 15, column: 8, scope: !223)
!225 = !DILocation(line: 16, column: 8, scope: !223)
!226 = !DILocation(line: 19, column: 8, scope: !223)
!227 = !DILocation(line: 21, column: 10, scope: !223)
!228 = !DILocation(line: 54, column: 10, scope: !223)
!229 = !DILocation(line: 22, column: 10, scope: !223)
!230 = !DILocation(line: 25, column: 10, scope: !223)
!231 = !DILocation(line: 26, column: 10, scope: !223)
!232 = !DILocation(line: 27, column: 10, scope: !223)
!233 = !DILocation(line: 28, column: 10, scope: !223)
!234 = !DILocation(line: 29, column: 10, scope: !223)
!235 = !DILocation(line: 30, column: 10, scope: !223)
!236 = !DILocation(line: 38, column: 10, scope: !223)
!237 = !DILocation(line: 39, column: 10, scope: !223)
!238 = !DILocation(line: 40, column: 10, scope: !223)
!239 = !DILocation(line: 41, column: 10, scope: !223)
!240 = !DILocation(line: 43, column: 10, scope: !223)
!241 = !DILocation(line: 44, column: 10, scope: !223)
!242 = !DILocation(line: 56, column: 10, scope: !223)
!243 = !DILocation(line: 58, column: 10, scope: !223)
!244 = !DILocation(line: 59, column: 10, scope: !223)
!245 = !DILocation(line: 23, column: 10, scope: !223)
!246 = !DILocation(line: 32, column: 10, scope: !223)
!247 = !DILocation(line: 33, column: 10, scope: !223)
!248 = !DILocation(line: 34, column: 10, scope: !223)
!249 = !DILocation(line: 35, column: 10, scope: !223)
!250 = !DILocation(line: 36, column: 10, scope: !223)
!251 = !DILocation(line: 37, column: 10, scope: !223)
!252 = !DILocation(line: 46, column: 10, scope: !223)
!253 = !DILocation(line: 47, column: 10, scope: !223)
!254 = !DILocation(line: 48, column: 10, scope: !223)
!255 = !DILocation(line: 49, column: 10, scope: !223)
!256 = !DILocation(line: 51, column: 10, scope: !223)
!257 = !DILocation(line: 52, column: 10, scope: !223)
!258 = !DILocation(line: 55, column: 10, scope: !223)
!259 = !DILocation(line: 57, column: 10, scope: !223)
!260 = !DILocation(line: 60, column: 10, scope: !223)
!261 = !DILocation(line: 61, column: 10, scope: !223)
!262 = !DILocation(line: 62, column: 10, scope: !223)
!263 = !DILocation(line: 63, column: 10, scope: !223)
!264 = !DILocation(line: 64, column: 10, scope: !223)
!265 = !DILocation(line: 65, column: 10, scope: !223)
!266 = !DILocation(line: 66, column: 10, scope: !223)
!267 = !DILocation(line: 67, column: 10, scope: !223)
!268 = !DILocation(line: 68, column: 10, scope: !223)
!269 = !DILocation(line: 69, column: 10, scope: !223)
!270 = !DILocation(line: 70, column: 10, scope: !223)
!271 = !DILocation(line: 74, column: 8, scope: !223)
!272 = distinct !DISubprogram(name: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", linkageName: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", scope: !17, file: !17, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!273 = !DILocation(line: 22, column: 8, scope: !272)
!274 = !DILocation(line: 21, column: 8, scope: !272)
!275 = !DILocation(line: 15, column: 8, scope: !272)
!276 = !DILocation(line: 16, column: 8, scope: !272)
!277 = !DILocation(line: 17, column: 8, scope: !272)
!278 = !DILocation(line: 9, column: 8, scope: !272)
!279 = !DILocation(line: 28, column: 8, scope: !272)
!280 = !DILocation(line: 24, column: 10, scope: !272)
!281 = !DILocation(line: 25, column: 10, scope: !272)
!282 = !DILocation(line: 30, column: 10, scope: !272)
!283 = !DILocation(line: 31, column: 10, scope: !272)
!284 = !DILocation(line: 32, column: 10, scope: !272)
!285 = !DILocation(line: 33, column: 10, scope: !272)
!286 = !DILocation(line: 34, column: 10, scope: !272)
!287 = !DILocation(line: 35, column: 10, scope: !272)
!288 = !DILocation(line: 36, column: 10, scope: !272)
!289 = !DILocation(line: 40, column: 8, scope: !272)
!290 = distinct !DISubprogram(name: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", linkageName: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", scope: !19, file: !19, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!291 = !DILocation(line: 16, column: 8, scope: !290)
!292 = !DILocation(line: 17, column: 8, scope: !290)
!293 = !DILocation(line: 20, column: 8, scope: !290)
!294 = !DILocation(line: 55, column: 10, scope: !290)
!295 = !DILocation(line: 23, column: 10, scope: !290)
!296 = !DILocation(line: 26, column: 10, scope: !290)
!297 = !DILocation(line: 27, column: 10, scope: !290)
!298 = !DILocation(line: 28, column: 10, scope: !290)
!299 = !DILocation(line: 29, column: 10, scope: !290)
!300 = !DILocation(line: 30, column: 10, scope: !290)
!301 = !DILocation(line: 31, column: 10, scope: !290)
!302 = !DILocation(line: 39, column: 10, scope: !290)
!303 = !DILocation(line: 40, column: 10, scope: !290)
!304 = !DILocation(line: 41, column: 10, scope: !290)
!305 = !DILocation(line: 42, column: 10, scope: !290)
!306 = !DILocation(line: 44, column: 10, scope: !290)
!307 = !DILocation(line: 45, column: 10, scope: !290)
!308 = !DILocation(line: 57, column: 10, scope: !290)
!309 = !DILocation(line: 59, column: 10, scope: !290)
!310 = !DILocation(line: 60, column: 10, scope: !290)
!311 = !DILocation(line: 24, column: 10, scope: !290)
!312 = !DILocation(line: 33, column: 10, scope: !290)
!313 = !DILocation(line: 34, column: 10, scope: !290)
!314 = !DILocation(line: 35, column: 10, scope: !290)
!315 = !DILocation(line: 36, column: 10, scope: !290)
!316 = !DILocation(line: 37, column: 10, scope: !290)
!317 = !DILocation(line: 38, column: 10, scope: !290)
!318 = !DILocation(line: 47, column: 10, scope: !290)
!319 = !DILocation(line: 48, column: 10, scope: !290)
!320 = !DILocation(line: 49, column: 10, scope: !290)
!321 = !DILocation(line: 50, column: 10, scope: !290)
!322 = !DILocation(line: 52, column: 10, scope: !290)
!323 = !DILocation(line: 53, column: 10, scope: !290)
!324 = !DILocation(line: 56, column: 10, scope: !290)
!325 = !DILocation(line: 58, column: 10, scope: !290)
!326 = !DILocation(line: 61, column: 10, scope: !290)
!327 = !DILocation(line: 62, column: 10, scope: !290)
!328 = !DILocation(line: 63, column: 10, scope: !290)
!329 = !DILocation(line: 64, column: 10, scope: !290)
!330 = !DILocation(line: 65, column: 10, scope: !290)
!331 = !DILocation(line: 66, column: 10, scope: !290)
!332 = !DILocation(line: 67, column: 10, scope: !290)
!333 = !DILocation(line: 68, column: 10, scope: !290)
!334 = !DILocation(line: 69, column: 10, scope: !290)
!335 = !DILocation(line: 70, column: 10, scope: !290)
!336 = !DILocation(line: 71, column: 10, scope: !290)
!337 = !DILocation(line: 75, column: 8, scope: !290)
!338 = distinct !DISubprogram(name: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", linkageName: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", scope: !21, file: !21, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!339 = !DILocation(line: 25, column: 8, scope: !338)
!340 = !DILocation(line: 24, column: 8, scope: !338)
!341 = !DILocation(line: 16, column: 8, scope: !338)
!342 = !DILocation(line: 17, column: 8, scope: !338)
!343 = !DILocation(line: 18, column: 8, scope: !338)
!344 = !DILocation(line: 19, column: 8, scope: !338)
!345 = !DILocation(line: 9, column: 8, scope: !338)
!346 = !DILocation(line: 31, column: 8, scope: !338)
!347 = !DILocation(line: 27, column: 10, scope: !338)
!348 = !DILocation(line: 28, column: 10, scope: !338)
!349 = !DILocation(line: 33, column: 10, scope: !338)
!350 = !DILocation(line: 34, column: 10, scope: !338)
!351 = !DILocation(line: 35, column: 10, scope: !338)
!352 = !DILocation(line: 36, column: 10, scope: !338)
!353 = !DILocation(line: 37, column: 10, scope: !338)
!354 = !DILocation(line: 38, column: 10, scope: !338)
!355 = !DILocation(line: 39, column: 10, scope: !338)
!356 = !DILocation(line: 40, column: 10, scope: !338)
!357 = !DILocation(line: 44, column: 8, scope: !338)
!358 = distinct !DISubprogram(name: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", linkageName: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", scope: !23, file: !23, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!359 = !DILocation(line: 23, column: 8, scope: !358)
!360 = !DILocation(line: 22, column: 8, scope: !358)
!361 = !DILocation(line: 14, column: 8, scope: !358)
!362 = !DILocation(line: 15, column: 8, scope: !358)
!363 = !DILocation(line: 16, column: 8, scope: !358)
!364 = !DILocation(line: 17, column: 8, scope: !358)
!365 = !DILocation(line: 9, column: 8, scope: !358)
!366 = !DILocation(line: 29, column: 8, scope: !358)
!367 = !DILocation(line: 25, column: 10, scope: !358)
!368 = !DILocation(line: 26, column: 10, scope: !358)
!369 = !DILocation(line: 31, column: 10, scope: !358)
!370 = !DILocation(line: 32, column: 10, scope: !358)
!371 = !DILocation(line: 33, column: 10, scope: !358)
!372 = !DILocation(line: 37, column: 8, scope: !358)
!373 = !{!374, !374, i64 0}
!374 = !{!"short", !29, i64 0}
!375 = !{!376, !376, i64 0}
!376 = !{!"float", !29, i64 0}
!377 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!378 = !{!379, !379, i64 0}
!379 = !{!"long", !29, i64 0}
!380 = !{!"branch_weights", i32 4001, i32 4000000}
!381 = !{!382, !383, i64 0}
!382 = !{!"", !383, i64 0, !383, i64 8}
!383 = !{!"double", !29, i64 0}
!384 = !{!382, !383, i64 8}
!385 = !{!"branch_weights", !"expected", i32 1, i32 2000}
