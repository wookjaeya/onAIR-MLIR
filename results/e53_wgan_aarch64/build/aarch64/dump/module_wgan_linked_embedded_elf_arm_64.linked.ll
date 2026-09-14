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
%iree_hal_executable_dispatch_state_v0_t = type { i32, i32, i16, i16, i32, i32, i16, i8, i8, ptr, ptr, ptr }
%iree_hal_executable_workgroup_state_v0_t = type { i32, i32, i16, i16, i32, ptr, i32 }

@__constant_32xf32 = private constant [32 x float] [float 0xBF9ABF8B00000000, float 0x3F9EF007C0000000, float 0x3F94365BA0000000, float 0x3F9E0BADC0000000, float 0xBF7FE73AC0000000, float 0x3FBC5DD4E0000000, float 0x3F96BF16C0000000, float 0x3FB16F9880000000, float 0x3F8BF51D40000000, float 0xBF7928DC00000000, float 0x3F7FFEE1C0000000, float 0xBF8ABD18A0000000, float 0xBF8C057A40000000, float 0x3F9AD45080000000, float 0x3F8377FAC0000000, float 0x3F81AE1A80000000, float 0xBF8388EF80000000, float 0x3FAE115260000000, float 0xBF8310FA40000000, float 0x3FAB206940000000, float 0x3F83F81C00000000, float 0x3F933EC1C0000000, float 0x3F6A5CAD20000000, float 0x3F60688980000000, float 0x3F94307DC0000000, float 0xBF54E28440000000, float 0x3F8EDA7220000000, float 0x3FA82689E0000000, float 0xBF479BE420000000, float 0xBF6D520600000000, float 0x3FC1AF7B00000000, float 0x3FB87B0DE0000000], align 64
@__constant_64xf32 = private constant [64 x float] [float 0x3F98AC8880000000, float 0x3F9D9E7880000000, float 0xBF8080A260000000, float 0x3F96C3BEC0000000, float 0xBF81108100000000, float 0x3FA81EF000000000, float 0x3F9DE0F100000000, float 0x3F7AE6C220000000, float 0x3F81B25B80000000, float 0x3F6375DA60000000, float 0xBF7734B4C0000000, float 0x3FA50D0780000000, float 0x3FA6AD5CA0000000, float 0x3F82C90040000000, float 0xBF601AFFC0000000, float 0x3FA36A8680000000, float 0x3FA648DCE0000000, float 0x3F77C09980000000, float 0xBF742D91C0000000, float 0x3FA82DF840000000, float 0xBF9A2ACD00000000, float 0xBF7A6F4C00000000, float 0x3F90BAD0E0000000, float 0xBF95FF8FC0000000, float 0x3F8CA9A180000000, float 0xBF91CBF200000000, float 0x3FA32A8480000000, float 0x3F81188A40000000, float 0x3F51BBD6C0000000, float 0xBF9888E800000000, float 0x3F8767BF20000000, float 0x3F8C6C18C0000000, float 0xBF833A2C40000000, float 0xBF69B18540000000, float 0x3F5FF72840000000, float 0x3F922D22C0000000, float 0x3FA1F265C0000000, float 0x3FA1434AE0000000, float 0x3F92DBE0C0000000, float 0xBF57BAD080000000, float 0x3F91899380000000, float 0x3F7A9C7100000000, float 0x3F1E40E720000000, float 0x3F63E88AC0000000, float 0x3F9A5FC0E0000000, float 0xBF765CB700000000, float 0x3FA18826C0000000, float 0xBF6A6049C0000000, float 0xBF64D3D740000000, float 0x3F8D3E9100000000, float 0x3F922E4F80000000, float 0x3F9A4B7C40000000, float 0x3FA600DBC0000000, float 0x3F6CBEF6C0000000, float 0x3F91EAB000000000, float 0xBF94FAC6A0000000, float 0x3F8E422660000000, float 0x3F931E4780000000, float 0x3F897491C0000000, float 0x3F8F6C4900000000, float 0x3F8F3A6900000000, float 0x3F832718C0000000, float 0x3FA48EA400000000, float 0xBF6D789140000000], align 64
@__constant_64xf32_0 = private constant [64 x float] [float 0xBF94F5C8C0000000, float 0x3F8EAAF540000000, float 0x3F99AD9580000000, float 0xBFA14FB6A0000000, float 0x3F9F852CA0000000, float 0x3F9227F0E0000000, float 0xBF6F3B5000000000, float 0xBFA1ACBD80000000, float 0x3FA00234A0000000, float 0xBF8D9BE140000000, float 0xBF914DEDA0000000, float 0xBF788C4C20000000, float 0x3F9A52AC80000000, float 0xBF8D72DBC0000000, float 0x3F9339B500000000, float 0xBF9C2FB080000000, float 0x3FA0386360000000, float 0xBF67736540000000, float 0xBF9E56CB60000000, float 0xBFA109A320000000, float 0x3FA1C6E180000000, float 0xBF666827E0000000, float 0x3FA0CC12A0000000, float 0x3FA0C83F40000000, float 0xBF99324DA0000000, float 0x3F73628FC0000000, float 0xBF7E45AF00000000, float 0xBF7A1DF6A0000000, float 0xBF9FC7B1E0000000, float 0xBF7B1F1640000000, float 0x3FA0EA6740000000, float 0xBF77A11780000000, float 0x3FA67DFDC0000000, float 0xBF9AABAAE0000000, float 0xBF922796E0000000, float 0xBF9A4436C0000000, float 0x3F988F0040000000, float 0xBFA18C19E0000000, float 0x3F58D55280000000, float 0x3F31AC6700000000, float 0x3F82F27600000000, float 0x3F9F9C33C0000000, float 0x3F95163D00000000, float 0x3F968F5E40000000, float 0x3F66486700000000, float 0x3FA2D89D40000000, float 0xBFA4610300000000, float 0x3F8D8F2A80000000, float 0x3FADB0CC00000000, float 0x3F95D3D620000000, float 0x3F6BF9BE80000000, float 0xBF82593000000000, float 0xBF883480C0000000, float 0x3F983C2D00000000, float 0x3F9BEC6A80000000, float 0xBFA2A7F2C0000000, float 0x3F8D0629E0000000, float 0x3F9D63B000000000, float 0xBF93DBC780000000, float 0x3F8FE60E40000000, float 0x3F73EE2220000000, float 0xBF8DE4BEC0000000, float 0x3F6A87D1A0000000, float 0x3FA4E03680000000], align 64
@__constant_32xf32_0 = private constant [32 x float] [float 0x3F8A61A680000000, float 0x3FA8D28EC0000000, float 0x3FBB2A5B40000000, float 0x3F902F2B40000000, float 0x3FA527A340000000, float 0xBFB6F386C0000000, float 0xBF91EC4380000000, float 0xBF67E46C80000000, float 0xBF71B4E980000000, float 0xBF77B60E00000000, float 0xBFB07BFC60000000, float 0x3F9DA10640000000, float 0x3F8A445E80000000, float 0x3F86F53F80000000, float 0x3F870BFBC0000000, float 0x3F96148900000000, float 0xBFAF298880000000, float 0x3F95AE3040000000, float 0xBF9741DBC0000000, float 0xBFB3B3D840000000, float 0x3F9BCE1460000000, float 0xBFB45AEEC0000000, float 0x3FA7E7EAE0000000, float 0x3FA9A51340000000, float 0xBF9350E7A0000000, float 0xBF86983D80000000, float 0x3F99B3D560000000, float 0xBFA739FA40000000, float 0x3F9D048440000000, float 0xBFA6A09A60000000, float 0xBF9816B5C0000000, float 0x3F9F3FF5E0000000], align 64
@__constant_3xf32 = private constant [3 x float] [float 0xBFA8DEE240000000, float 0xBF9B8A0760000000, float 0xBF634E1040000000], align 64
@0 = private constant [12 x i8] c"wgan_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [12 x ptr] [ptr @infer_dispatch_0_matmul_like_32x50176x3_f32, ptr @infer_dispatch_1_slow_memcpy, ptr @infer_dispatch_2_conv_64x224x224x32x3x3_f32, ptr @infer_dispatch_3_conv_128x224x224x64x3x3_f32, ptr @infer_dispatch_4_slow_memcpy, ptr @infer_dispatch_5_conv_128x224x224x128x3x3_f32, ptr @infer_dispatch_6_conv_128x224x224x128x3x3_f32, ptr @infer_dispatch_13_elementwise_broadcast_128x112x112_f32, ptr @infer_dispatch_14_conv_64x112x112x128x3x3_f32, ptr @infer_dispatch_15_elementwise_broadcast_64x224x224_f32, ptr @infer_dispatch_16_conv_32x224x224x64x3x3_f32, ptr @infer_dispatch_17_conv_3x224x224x32x3x3_f32]
@iree_hal_executable_library_query_v0_attrs = private constant [12 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 5, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 4, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [44 x i8] c"infer_dispatch_0_matmul_like_32x50176x3_f32\00", align 1
@2 = private constant [29 x i8] c"infer_dispatch_1_slow_memcpy\00", align 1
@3 = private constant [44 x i8] c"infer_dispatch_2_conv_64x224x224x32x3x3_f32\00", align 1
@4 = private constant [45 x i8] c"infer_dispatch_3_conv_128x224x224x64x3x3_f32\00", align 1
@5 = private constant [29 x i8] c"infer_dispatch_4_slow_memcpy\00", align 1
@6 = private constant [46 x i8] c"infer_dispatch_5_conv_128x224x224x128x3x3_f32\00", align 1
@7 = private constant [46 x i8] c"infer_dispatch_6_conv_128x224x224x128x3x3_f32\00", align 1
@8 = private constant [56 x i8] c"infer_dispatch_13_elementwise_broadcast_128x112x112_f32\00", align 1
@9 = private constant [46 x i8] c"infer_dispatch_14_conv_64x112x112x128x3x3_f32\00", align 1
@10 = private constant [55 x i8] c"infer_dispatch_15_elementwise_broadcast_64x224x224_f32\00", align 1
@11 = private constant [45 x i8] c"infer_dispatch_16_conv_32x224x224x64x3x3_f32\00", align 1
@12 = private constant [44 x i8] c"infer_dispatch_17_conv_3x224x224x32x3x3_f32\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [12 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5, ptr @6, ptr @7, ptr @8, ptr @9, ptr @10, ptr @11, ptr @12]
@13 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@14 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@15 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@16 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_3.mlir\00", align 1
@17 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@18 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@19 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_6.mlir\00", align 1
@20 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_13.mlir\00", align 1
@21 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_14.mlir\00", align 1
@22 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_15.mlir\00", align 1
@23 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_16.mlir\00", align 1
@24 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_17.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [12 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @13 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @14 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @15 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @16 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @17 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @18 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @19 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @20 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @21 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @22 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @23 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @24 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [12 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_matmul_like_32x50176x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_64x224x224x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_128x224x224x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_128x224x224x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_128x224x224x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_elementwise_broadcast_128x112x112_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_64x112x112x128x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_elementwise_broadcast_64x224x224_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_16_conv_32x224x224x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_17_conv_3x224x224x32x3x3_f32_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 12, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_matmul_like_32x50176x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !31 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !107
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !107
  %6 = load ptr, ptr %5, align 8, !dbg !107
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !107
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !108
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !108
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !108
  %10 = load ptr, ptr %9, align 8, !dbg !108
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !108
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !109
  %13 = getelementptr ptr, ptr %12, i32 2, !dbg !109
  %14 = load ptr, ptr %13, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !109
  %15 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !110
  %16 = extractvalue %iree_hal_executable_workgroup_state_v0_t %15, 0, !dbg !110
  %17 = zext i32 %16 to i64, !dbg !110
  %18 = mul nsw i64 %17, 64, !dbg !110
  br label %19, !dbg !110

19:                                               ; preds = %854, %3
  %20 = phi i64 [ %855, %854 ], [ 0, %3 ], !dbg !110
  %21 = icmp slt i64 %20, 32, !dbg !110
  br i1 %21, label %22, label %856, !dbg !110

22:                                               ; preds = %19
  %23 = getelementptr float, ptr @__constant_32xf32, i64 %20, !dbg !111
  %24 = load <8 x float>, ptr %23, align 4, !dbg !111
  %25 = shufflevector <8 x float> %24, <8 x float> %24, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !111
  %26 = shufflevector <128 x float> %25, <128 x float> poison, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %27 = shufflevector <128 x float> %25, <128 x float> %26, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %28 = shufflevector <128 x float> %25, <128 x float> %27, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %29 = shufflevector <128 x float> %25, <128 x float> %28, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %30 = shufflevector <128 x float> %25, <128 x float> %29, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %31 = shufflevector <128 x float> %25, <128 x float> %30, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %32 = shufflevector <128 x float> %25, <128 x float> %31, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %33 = shufflevector <128 x float> %25, <128 x float> %32, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %34 = shufflevector <128 x float> %25, <128 x float> %33, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %35 = shufflevector <128 x float> %25, <128 x float> %34, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %36 = shufflevector <128 x float> %25, <128 x float> %35, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %37 = shufflevector <128 x float> %25, <128 x float> %36, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %38 = shufflevector <128 x float> %25, <128 x float> %37, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %39 = shufflevector <128 x float> %25, <128 x float> %38, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %40 = shufflevector <128 x float> %25, <128 x float> %39, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !111
  %41 = shufflevector <128 x float> %25, <128 x float> %40, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>, !dbg !111
  %42 = shufflevector <128 x float> %41, <128 x float> %41, <128 x i32> <i32 0, i32 8, i32 16, i32 24, i32 32, i32 40, i32 48, i32 56, i32 64, i32 72, i32 80, i32 88, i32 96, i32 104, i32 112, i32 120, i32 1, i32 9, i32 17, i32 25, i32 33, i32 41, i32 49, i32 57, i32 65, i32 73, i32 81, i32 89, i32 97, i32 105, i32 113, i32 121, i32 2, i32 10, i32 18, i32 26, i32 34, i32 42, i32 50, i32 58, i32 66, i32 74, i32 82, i32 90, i32 98, i32 106, i32 114, i32 122, i32 3, i32 11, i32 19, i32 27, i32 35, i32 43, i32 51, i32 59, i32 67, i32 75, i32 83, i32 91, i32 99, i32 107, i32 115, i32 123, i32 4, i32 12, i32 20, i32 28, i32 36, i32 44, i32 52, i32 60, i32 68, i32 76, i32 84, i32 92, i32 100, i32 108, i32 116, i32 124, i32 5, i32 13, i32 21, i32 29, i32 37, i32 45, i32 53, i32 61, i32 69, i32 77, i32 85, i32 93, i32 101, i32 109, i32 117, i32 125, i32 6, i32 14, i32 22, i32 30, i32 38, i32 46, i32 54, i32 62, i32 70, i32 78, i32 86, i32 94, i32 102, i32 110, i32 118, i32 126, i32 7, i32 15, i32 23, i32 31, i32 39, i32 47, i32 55, i32 63, i32 71, i32 79, i32 87, i32 95, i32 103, i32 111, i32 119, i32 127>, !dbg !111
  %43 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>, !dbg !111
  %44 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !111
  %45 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>, !dbg !111
  %46 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>, !dbg !111
  %47 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79>, !dbg !111
  %48 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>, !dbg !111
  %49 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111>, !dbg !111
  %50 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>, !dbg !111
  br label %51, !dbg !110

51:                                               ; preds = %756, %22
  %52 = phi i64 [ %853, %756 ], [ 0, %22 ], !dbg !110
  %53 = icmp slt i64 %52, 64, !dbg !110
  br i1 %53, label %54, label %854, !dbg !110

54:                                               ; preds = %58, %51
  %55 = phi i64 [ %755, %58 ], [ 0, %51 ], !dbg !110
  %56 = phi [8 x <16 x float>] [ %754, %58 ], [ zeroinitializer, %51 ], !dbg !110
  %57 = icmp slt i64 %55, 3, !dbg !110
  br i1 %57, label %58, label %756, !dbg !110

58:                                               ; preds = %54
  %59 = mul i64 %20, 3, !dbg !110
  %60 = add i64 %59, %55, !dbg !110
  %61 = getelementptr float, ptr %10, i64 %60, !dbg !110
  %62 = load <1 x float>, ptr %61, align 4, !dbg !110
  %63 = add i64 %20, 1, !dbg !110
  %64 = mul i64 %63, 3, !dbg !110
  %65 = add i64 %64, %55, !dbg !110
  %66 = getelementptr float, ptr %10, i64 %65, !dbg !110
  %67 = load <1 x float>, ptr %66, align 4, !dbg !110
  %68 = add i64 %20, 2, !dbg !110
  %69 = mul i64 %68, 3, !dbg !110
  %70 = add i64 %69, %55, !dbg !110
  %71 = getelementptr float, ptr %10, i64 %70, !dbg !110
  %72 = load <1 x float>, ptr %71, align 4, !dbg !110
  %73 = add i64 %20, 3, !dbg !110
  %74 = mul i64 %73, 3, !dbg !110
  %75 = add i64 %74, %55, !dbg !110
  %76 = getelementptr float, ptr %10, i64 %75, !dbg !110
  %77 = load <1 x float>, ptr %76, align 4, !dbg !110
  %78 = add i64 %20, 4, !dbg !110
  %79 = mul i64 %78, 3, !dbg !110
  %80 = add i64 %79, %55, !dbg !110
  %81 = getelementptr float, ptr %10, i64 %80, !dbg !110
  %82 = load <1 x float>, ptr %81, align 4, !dbg !110
  %83 = add i64 %20, 5, !dbg !110
  %84 = mul i64 %83, 3, !dbg !110
  %85 = add i64 %84, %55, !dbg !110
  %86 = getelementptr float, ptr %10, i64 %85, !dbg !110
  %87 = load <1 x float>, ptr %86, align 4, !dbg !110
  %88 = add i64 %20, 6, !dbg !110
  %89 = mul i64 %88, 3, !dbg !110
  %90 = add i64 %89, %55, !dbg !110
  %91 = getelementptr float, ptr %10, i64 %90, !dbg !110
  %92 = load <1 x float>, ptr %91, align 4, !dbg !110
  %93 = add i64 %20, 7, !dbg !110
  %94 = mul i64 %93, 3, !dbg !110
  %95 = add i64 %94, %55, !dbg !110
  %96 = getelementptr float, ptr %10, i64 %95, !dbg !110
  %97 = load <1 x float>, ptr %96, align 4, !dbg !110
  %98 = extractelement <1 x float> %62, i64 0, !dbg !110
  %99 = extractelement <1 x float> %67, i64 0, !dbg !110
  %100 = extractelement <1 x float> %72, i64 0, !dbg !110
  %101 = extractelement <1 x float> %77, i64 0, !dbg !110
  %102 = extractelement <1 x float> %82, i64 0, !dbg !110
  %103 = extractelement <1 x float> %87, i64 0, !dbg !110
  %104 = extractelement <1 x float> %92, i64 0, !dbg !110
  %105 = extractelement <1 x float> %97, i64 0, !dbg !110
  %106 = add i64 %52, %18, !dbg !112
  %107 = mul nuw nsw i64 %55, 50176, !dbg !112
  %108 = add nuw nsw i64 %107, %106, !dbg !112
  %109 = getelementptr inbounds nuw float, ptr %6, i64 %108, !dbg !112
  %110 = load float, ptr %109, align 4, !dbg !112
  %111 = extractvalue [8 x <16 x float>] %56, 0, !dbg !112
  %112 = extractelement <16 x float> %111, i64 0, !dbg !112
  %113 = extractvalue [8 x <16 x float>] %56, 1, !dbg !112
  %114 = extractelement <16 x float> %113, i64 0, !dbg !112
  %115 = extractvalue [8 x <16 x float>] %56, 2, !dbg !112
  %116 = extractelement <16 x float> %115, i64 0, !dbg !112
  %117 = extractvalue [8 x <16 x float>] %56, 3, !dbg !112
  %118 = extractelement <16 x float> %117, i64 0, !dbg !112
  %119 = extractvalue [8 x <16 x float>] %56, 4, !dbg !112
  %120 = extractelement <16 x float> %119, i64 0, !dbg !112
  %121 = extractvalue [8 x <16 x float>] %56, 5, !dbg !112
  %122 = extractelement <16 x float> %121, i64 0, !dbg !112
  %123 = extractvalue [8 x <16 x float>] %56, 6, !dbg !112
  %124 = extractelement <16 x float> %123, i64 0, !dbg !112
  %125 = extractvalue [8 x <16 x float>] %56, 7, !dbg !112
  %126 = extractelement <16 x float> %125, i64 0, !dbg !112
  %127 = insertelement <8 x float> poison, float %112, i64 0, !dbg !112
  %128 = insertelement <8 x float> %127, float %114, i64 1, !dbg !112
  %129 = insertelement <8 x float> %128, float %116, i64 2, !dbg !112
  %130 = insertelement <8 x float> %129, float %118, i64 3, !dbg !112
  %131 = insertelement <8 x float> %130, float %120, i64 4, !dbg !112
  %132 = insertelement <8 x float> %131, float %122, i64 5, !dbg !112
  %133 = insertelement <8 x float> %132, float %124, i64 6, !dbg !112
  %134 = insertelement <8 x float> %133, float %126, i64 7, !dbg !112
  %135 = insertelement <8 x float> poison, float %98, i64 0, !dbg !112
  %136 = insertelement <8 x float> %135, float %99, i64 1, !dbg !112
  %137 = insertelement <8 x float> %136, float %100, i64 2, !dbg !112
  %138 = insertelement <8 x float> %137, float %101, i64 3, !dbg !112
  %139 = insertelement <8 x float> %138, float %102, i64 4, !dbg !112
  %140 = insertelement <8 x float> %139, float %103, i64 5, !dbg !112
  %141 = insertelement <8 x float> %140, float %104, i64 6, !dbg !112
  %142 = insertelement <8 x float> %141, float %105, i64 7, !dbg !112
  %143 = insertelement <8 x float> poison, float %110, i32 0, !dbg !112
  %144 = shufflevector <8 x float> %143, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %145 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %144, <8 x float> %134), !dbg !112
  %146 = extractelement <8 x float> %145, i64 0, !dbg !112
  %147 = extractelement <8 x float> %145, i64 1, !dbg !112
  %148 = extractelement <8 x float> %145, i64 2, !dbg !112
  %149 = extractelement <8 x float> %145, i64 3, !dbg !112
  %150 = extractelement <8 x float> %145, i64 4, !dbg !112
  %151 = extractelement <8 x float> %145, i64 5, !dbg !112
  %152 = extractelement <8 x float> %145, i64 6, !dbg !112
  %153 = extractelement <8 x float> %145, i64 7, !dbg !112
  %154 = add i64 %106, 1, !dbg !112
  %155 = add nuw nsw i64 %107, %154, !dbg !112
  %156 = getelementptr inbounds nuw float, ptr %6, i64 %155, !dbg !112
  %157 = load float, ptr %156, align 4, !dbg !112
  %158 = extractelement <16 x float> %111, i64 1, !dbg !112
  %159 = extractelement <16 x float> %113, i64 1, !dbg !112
  %160 = extractelement <16 x float> %115, i64 1, !dbg !112
  %161 = extractelement <16 x float> %117, i64 1, !dbg !112
  %162 = extractelement <16 x float> %119, i64 1, !dbg !112
  %163 = extractelement <16 x float> %121, i64 1, !dbg !112
  %164 = extractelement <16 x float> %123, i64 1, !dbg !112
  %165 = extractelement <16 x float> %125, i64 1, !dbg !112
  %166 = insertelement <8 x float> poison, float %158, i64 0, !dbg !112
  %167 = insertelement <8 x float> %166, float %159, i64 1, !dbg !112
  %168 = insertelement <8 x float> %167, float %160, i64 2, !dbg !112
  %169 = insertelement <8 x float> %168, float %161, i64 3, !dbg !112
  %170 = insertelement <8 x float> %169, float %162, i64 4, !dbg !112
  %171 = insertelement <8 x float> %170, float %163, i64 5, !dbg !112
  %172 = insertelement <8 x float> %171, float %164, i64 6, !dbg !112
  %173 = insertelement <8 x float> %172, float %165, i64 7, !dbg !112
  %174 = insertelement <8 x float> poison, float %157, i32 0, !dbg !112
  %175 = shufflevector <8 x float> %174, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %176 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %175, <8 x float> %173), !dbg !112
  %177 = extractelement <8 x float> %176, i64 0, !dbg !112
  %178 = extractelement <8 x float> %176, i64 1, !dbg !112
  %179 = extractelement <8 x float> %176, i64 2, !dbg !112
  %180 = extractelement <8 x float> %176, i64 3, !dbg !112
  %181 = extractelement <8 x float> %176, i64 4, !dbg !112
  %182 = extractelement <8 x float> %176, i64 5, !dbg !112
  %183 = extractelement <8 x float> %176, i64 6, !dbg !112
  %184 = extractelement <8 x float> %176, i64 7, !dbg !112
  %185 = add i64 %106, 2, !dbg !112
  %186 = add nuw nsw i64 %107, %185, !dbg !112
  %187 = getelementptr inbounds nuw float, ptr %6, i64 %186, !dbg !112
  %188 = load float, ptr %187, align 4, !dbg !112
  %189 = extractelement <16 x float> %111, i64 2, !dbg !112
  %190 = extractelement <16 x float> %113, i64 2, !dbg !112
  %191 = extractelement <16 x float> %115, i64 2, !dbg !112
  %192 = extractelement <16 x float> %117, i64 2, !dbg !112
  %193 = extractelement <16 x float> %119, i64 2, !dbg !112
  %194 = extractelement <16 x float> %121, i64 2, !dbg !112
  %195 = extractelement <16 x float> %123, i64 2, !dbg !112
  %196 = extractelement <16 x float> %125, i64 2, !dbg !112
  %197 = insertelement <8 x float> poison, float %189, i64 0, !dbg !112
  %198 = insertelement <8 x float> %197, float %190, i64 1, !dbg !112
  %199 = insertelement <8 x float> %198, float %191, i64 2, !dbg !112
  %200 = insertelement <8 x float> %199, float %192, i64 3, !dbg !112
  %201 = insertelement <8 x float> %200, float %193, i64 4, !dbg !112
  %202 = insertelement <8 x float> %201, float %194, i64 5, !dbg !112
  %203 = insertelement <8 x float> %202, float %195, i64 6, !dbg !112
  %204 = insertelement <8 x float> %203, float %196, i64 7, !dbg !112
  %205 = insertelement <8 x float> poison, float %188, i32 0, !dbg !112
  %206 = shufflevector <8 x float> %205, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %207 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %206, <8 x float> %204), !dbg !112
  %208 = extractelement <8 x float> %207, i64 0, !dbg !112
  %209 = extractelement <8 x float> %207, i64 1, !dbg !112
  %210 = extractelement <8 x float> %207, i64 2, !dbg !112
  %211 = extractelement <8 x float> %207, i64 3, !dbg !112
  %212 = extractelement <8 x float> %207, i64 4, !dbg !112
  %213 = extractelement <8 x float> %207, i64 5, !dbg !112
  %214 = extractelement <8 x float> %207, i64 6, !dbg !112
  %215 = extractelement <8 x float> %207, i64 7, !dbg !112
  %216 = add i64 %106, 3, !dbg !112
  %217 = add nuw nsw i64 %107, %216, !dbg !112
  %218 = getelementptr inbounds nuw float, ptr %6, i64 %217, !dbg !112
  %219 = load float, ptr %218, align 4, !dbg !112
  %220 = extractelement <16 x float> %111, i64 3, !dbg !112
  %221 = extractelement <16 x float> %113, i64 3, !dbg !112
  %222 = extractelement <16 x float> %115, i64 3, !dbg !112
  %223 = extractelement <16 x float> %117, i64 3, !dbg !112
  %224 = extractelement <16 x float> %119, i64 3, !dbg !112
  %225 = extractelement <16 x float> %121, i64 3, !dbg !112
  %226 = extractelement <16 x float> %123, i64 3, !dbg !112
  %227 = extractelement <16 x float> %125, i64 3, !dbg !112
  %228 = insertelement <8 x float> poison, float %220, i64 0, !dbg !112
  %229 = insertelement <8 x float> %228, float %221, i64 1, !dbg !112
  %230 = insertelement <8 x float> %229, float %222, i64 2, !dbg !112
  %231 = insertelement <8 x float> %230, float %223, i64 3, !dbg !112
  %232 = insertelement <8 x float> %231, float %224, i64 4, !dbg !112
  %233 = insertelement <8 x float> %232, float %225, i64 5, !dbg !112
  %234 = insertelement <8 x float> %233, float %226, i64 6, !dbg !112
  %235 = insertelement <8 x float> %234, float %227, i64 7, !dbg !112
  %236 = insertelement <8 x float> poison, float %219, i32 0, !dbg !112
  %237 = shufflevector <8 x float> %236, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %238 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %237, <8 x float> %235), !dbg !112
  %239 = extractelement <8 x float> %238, i64 0, !dbg !112
  %240 = extractelement <8 x float> %238, i64 1, !dbg !112
  %241 = extractelement <8 x float> %238, i64 2, !dbg !112
  %242 = extractelement <8 x float> %238, i64 3, !dbg !112
  %243 = extractelement <8 x float> %238, i64 4, !dbg !112
  %244 = extractelement <8 x float> %238, i64 5, !dbg !112
  %245 = extractelement <8 x float> %238, i64 6, !dbg !112
  %246 = extractelement <8 x float> %238, i64 7, !dbg !112
  %247 = add i64 %106, 4, !dbg !112
  %248 = add nuw nsw i64 %107, %247, !dbg !112
  %249 = getelementptr inbounds nuw float, ptr %6, i64 %248, !dbg !112
  %250 = load float, ptr %249, align 4, !dbg !112
  %251 = extractelement <16 x float> %111, i64 4, !dbg !112
  %252 = extractelement <16 x float> %113, i64 4, !dbg !112
  %253 = extractelement <16 x float> %115, i64 4, !dbg !112
  %254 = extractelement <16 x float> %117, i64 4, !dbg !112
  %255 = extractelement <16 x float> %119, i64 4, !dbg !112
  %256 = extractelement <16 x float> %121, i64 4, !dbg !112
  %257 = extractelement <16 x float> %123, i64 4, !dbg !112
  %258 = extractelement <16 x float> %125, i64 4, !dbg !112
  %259 = insertelement <8 x float> poison, float %251, i64 0, !dbg !112
  %260 = insertelement <8 x float> %259, float %252, i64 1, !dbg !112
  %261 = insertelement <8 x float> %260, float %253, i64 2, !dbg !112
  %262 = insertelement <8 x float> %261, float %254, i64 3, !dbg !112
  %263 = insertelement <8 x float> %262, float %255, i64 4, !dbg !112
  %264 = insertelement <8 x float> %263, float %256, i64 5, !dbg !112
  %265 = insertelement <8 x float> %264, float %257, i64 6, !dbg !112
  %266 = insertelement <8 x float> %265, float %258, i64 7, !dbg !112
  %267 = insertelement <8 x float> poison, float %250, i32 0, !dbg !112
  %268 = shufflevector <8 x float> %267, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %269 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %268, <8 x float> %266), !dbg !112
  %270 = extractelement <8 x float> %269, i64 0, !dbg !112
  %271 = extractelement <8 x float> %269, i64 1, !dbg !112
  %272 = extractelement <8 x float> %269, i64 2, !dbg !112
  %273 = extractelement <8 x float> %269, i64 3, !dbg !112
  %274 = extractelement <8 x float> %269, i64 4, !dbg !112
  %275 = extractelement <8 x float> %269, i64 5, !dbg !112
  %276 = extractelement <8 x float> %269, i64 6, !dbg !112
  %277 = extractelement <8 x float> %269, i64 7, !dbg !112
  %278 = add i64 %106, 5, !dbg !112
  %279 = add nuw nsw i64 %107, %278, !dbg !112
  %280 = getelementptr inbounds nuw float, ptr %6, i64 %279, !dbg !112
  %281 = load float, ptr %280, align 4, !dbg !112
  %282 = extractelement <16 x float> %111, i64 5, !dbg !112
  %283 = extractelement <16 x float> %113, i64 5, !dbg !112
  %284 = extractelement <16 x float> %115, i64 5, !dbg !112
  %285 = extractelement <16 x float> %117, i64 5, !dbg !112
  %286 = extractelement <16 x float> %119, i64 5, !dbg !112
  %287 = extractelement <16 x float> %121, i64 5, !dbg !112
  %288 = extractelement <16 x float> %123, i64 5, !dbg !112
  %289 = extractelement <16 x float> %125, i64 5, !dbg !112
  %290 = insertelement <8 x float> poison, float %282, i64 0, !dbg !112
  %291 = insertelement <8 x float> %290, float %283, i64 1, !dbg !112
  %292 = insertelement <8 x float> %291, float %284, i64 2, !dbg !112
  %293 = insertelement <8 x float> %292, float %285, i64 3, !dbg !112
  %294 = insertelement <8 x float> %293, float %286, i64 4, !dbg !112
  %295 = insertelement <8 x float> %294, float %287, i64 5, !dbg !112
  %296 = insertelement <8 x float> %295, float %288, i64 6, !dbg !112
  %297 = insertelement <8 x float> %296, float %289, i64 7, !dbg !112
  %298 = insertelement <8 x float> poison, float %281, i32 0, !dbg !112
  %299 = shufflevector <8 x float> %298, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %300 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %299, <8 x float> %297), !dbg !112
  %301 = extractelement <8 x float> %300, i64 0, !dbg !112
  %302 = extractelement <8 x float> %300, i64 1, !dbg !112
  %303 = extractelement <8 x float> %300, i64 2, !dbg !112
  %304 = extractelement <8 x float> %300, i64 3, !dbg !112
  %305 = extractelement <8 x float> %300, i64 4, !dbg !112
  %306 = extractelement <8 x float> %300, i64 5, !dbg !112
  %307 = extractelement <8 x float> %300, i64 6, !dbg !112
  %308 = extractelement <8 x float> %300, i64 7, !dbg !112
  %309 = add i64 %106, 6, !dbg !112
  %310 = add nuw nsw i64 %107, %309, !dbg !112
  %311 = getelementptr inbounds nuw float, ptr %6, i64 %310, !dbg !112
  %312 = load float, ptr %311, align 4, !dbg !112
  %313 = extractelement <16 x float> %111, i64 6, !dbg !112
  %314 = extractelement <16 x float> %113, i64 6, !dbg !112
  %315 = extractelement <16 x float> %115, i64 6, !dbg !112
  %316 = extractelement <16 x float> %117, i64 6, !dbg !112
  %317 = extractelement <16 x float> %119, i64 6, !dbg !112
  %318 = extractelement <16 x float> %121, i64 6, !dbg !112
  %319 = extractelement <16 x float> %123, i64 6, !dbg !112
  %320 = extractelement <16 x float> %125, i64 6, !dbg !112
  %321 = insertelement <8 x float> poison, float %313, i64 0, !dbg !112
  %322 = insertelement <8 x float> %321, float %314, i64 1, !dbg !112
  %323 = insertelement <8 x float> %322, float %315, i64 2, !dbg !112
  %324 = insertelement <8 x float> %323, float %316, i64 3, !dbg !112
  %325 = insertelement <8 x float> %324, float %317, i64 4, !dbg !112
  %326 = insertelement <8 x float> %325, float %318, i64 5, !dbg !112
  %327 = insertelement <8 x float> %326, float %319, i64 6, !dbg !112
  %328 = insertelement <8 x float> %327, float %320, i64 7, !dbg !112
  %329 = insertelement <8 x float> poison, float %312, i32 0, !dbg !112
  %330 = shufflevector <8 x float> %329, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %331 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %330, <8 x float> %328), !dbg !112
  %332 = extractelement <8 x float> %331, i64 0, !dbg !112
  %333 = extractelement <8 x float> %331, i64 1, !dbg !112
  %334 = extractelement <8 x float> %331, i64 2, !dbg !112
  %335 = extractelement <8 x float> %331, i64 3, !dbg !112
  %336 = extractelement <8 x float> %331, i64 4, !dbg !112
  %337 = extractelement <8 x float> %331, i64 5, !dbg !112
  %338 = extractelement <8 x float> %331, i64 6, !dbg !112
  %339 = extractelement <8 x float> %331, i64 7, !dbg !112
  %340 = add i64 %106, 7, !dbg !112
  %341 = add nuw nsw i64 %107, %340, !dbg !112
  %342 = getelementptr inbounds nuw float, ptr %6, i64 %341, !dbg !112
  %343 = load float, ptr %342, align 4, !dbg !112
  %344 = extractelement <16 x float> %111, i64 7, !dbg !112
  %345 = extractelement <16 x float> %113, i64 7, !dbg !112
  %346 = extractelement <16 x float> %115, i64 7, !dbg !112
  %347 = extractelement <16 x float> %117, i64 7, !dbg !112
  %348 = extractelement <16 x float> %119, i64 7, !dbg !112
  %349 = extractelement <16 x float> %121, i64 7, !dbg !112
  %350 = extractelement <16 x float> %123, i64 7, !dbg !112
  %351 = extractelement <16 x float> %125, i64 7, !dbg !112
  %352 = insertelement <8 x float> poison, float %344, i64 0, !dbg !112
  %353 = insertelement <8 x float> %352, float %345, i64 1, !dbg !112
  %354 = insertelement <8 x float> %353, float %346, i64 2, !dbg !112
  %355 = insertelement <8 x float> %354, float %347, i64 3, !dbg !112
  %356 = insertelement <8 x float> %355, float %348, i64 4, !dbg !112
  %357 = insertelement <8 x float> %356, float %349, i64 5, !dbg !112
  %358 = insertelement <8 x float> %357, float %350, i64 6, !dbg !112
  %359 = insertelement <8 x float> %358, float %351, i64 7, !dbg !112
  %360 = insertelement <8 x float> poison, float %343, i32 0, !dbg !112
  %361 = shufflevector <8 x float> %360, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %362 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %361, <8 x float> %359), !dbg !112
  %363 = extractelement <8 x float> %362, i64 0, !dbg !112
  %364 = extractelement <8 x float> %362, i64 1, !dbg !112
  %365 = extractelement <8 x float> %362, i64 2, !dbg !112
  %366 = extractelement <8 x float> %362, i64 3, !dbg !112
  %367 = extractelement <8 x float> %362, i64 4, !dbg !112
  %368 = extractelement <8 x float> %362, i64 5, !dbg !112
  %369 = extractelement <8 x float> %362, i64 6, !dbg !112
  %370 = extractelement <8 x float> %362, i64 7, !dbg !112
  %371 = add i64 %106, 8, !dbg !112
  %372 = add nuw nsw i64 %107, %371, !dbg !112
  %373 = getelementptr inbounds nuw float, ptr %6, i64 %372, !dbg !112
  %374 = load float, ptr %373, align 4, !dbg !112
  %375 = extractelement <16 x float> %111, i64 8, !dbg !112
  %376 = extractelement <16 x float> %113, i64 8, !dbg !112
  %377 = extractelement <16 x float> %115, i64 8, !dbg !112
  %378 = extractelement <16 x float> %117, i64 8, !dbg !112
  %379 = extractelement <16 x float> %119, i64 8, !dbg !112
  %380 = extractelement <16 x float> %121, i64 8, !dbg !112
  %381 = extractelement <16 x float> %123, i64 8, !dbg !112
  %382 = extractelement <16 x float> %125, i64 8, !dbg !112
  %383 = insertelement <8 x float> poison, float %375, i64 0, !dbg !112
  %384 = insertelement <8 x float> %383, float %376, i64 1, !dbg !112
  %385 = insertelement <8 x float> %384, float %377, i64 2, !dbg !112
  %386 = insertelement <8 x float> %385, float %378, i64 3, !dbg !112
  %387 = insertelement <8 x float> %386, float %379, i64 4, !dbg !112
  %388 = insertelement <8 x float> %387, float %380, i64 5, !dbg !112
  %389 = insertelement <8 x float> %388, float %381, i64 6, !dbg !112
  %390 = insertelement <8 x float> %389, float %382, i64 7, !dbg !112
  %391 = insertelement <8 x float> poison, float %374, i32 0, !dbg !112
  %392 = shufflevector <8 x float> %391, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %393 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %392, <8 x float> %390), !dbg !112
  %394 = extractelement <8 x float> %393, i64 0, !dbg !112
  %395 = extractelement <8 x float> %393, i64 1, !dbg !112
  %396 = extractelement <8 x float> %393, i64 2, !dbg !112
  %397 = extractelement <8 x float> %393, i64 3, !dbg !112
  %398 = extractelement <8 x float> %393, i64 4, !dbg !112
  %399 = extractelement <8 x float> %393, i64 5, !dbg !112
  %400 = extractelement <8 x float> %393, i64 6, !dbg !112
  %401 = extractelement <8 x float> %393, i64 7, !dbg !112
  %402 = add i64 %106, 9, !dbg !112
  %403 = add nuw nsw i64 %107, %402, !dbg !112
  %404 = getelementptr inbounds nuw float, ptr %6, i64 %403, !dbg !112
  %405 = load float, ptr %404, align 4, !dbg !112
  %406 = extractelement <16 x float> %111, i64 9, !dbg !112
  %407 = extractelement <16 x float> %113, i64 9, !dbg !112
  %408 = extractelement <16 x float> %115, i64 9, !dbg !112
  %409 = extractelement <16 x float> %117, i64 9, !dbg !112
  %410 = extractelement <16 x float> %119, i64 9, !dbg !112
  %411 = extractelement <16 x float> %121, i64 9, !dbg !112
  %412 = extractelement <16 x float> %123, i64 9, !dbg !112
  %413 = extractelement <16 x float> %125, i64 9, !dbg !112
  %414 = insertelement <8 x float> poison, float %406, i64 0, !dbg !112
  %415 = insertelement <8 x float> %414, float %407, i64 1, !dbg !112
  %416 = insertelement <8 x float> %415, float %408, i64 2, !dbg !112
  %417 = insertelement <8 x float> %416, float %409, i64 3, !dbg !112
  %418 = insertelement <8 x float> %417, float %410, i64 4, !dbg !112
  %419 = insertelement <8 x float> %418, float %411, i64 5, !dbg !112
  %420 = insertelement <8 x float> %419, float %412, i64 6, !dbg !112
  %421 = insertelement <8 x float> %420, float %413, i64 7, !dbg !112
  %422 = insertelement <8 x float> poison, float %405, i32 0, !dbg !112
  %423 = shufflevector <8 x float> %422, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %424 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %423, <8 x float> %421), !dbg !112
  %425 = extractelement <8 x float> %424, i64 0, !dbg !112
  %426 = extractelement <8 x float> %424, i64 1, !dbg !112
  %427 = extractelement <8 x float> %424, i64 2, !dbg !112
  %428 = extractelement <8 x float> %424, i64 3, !dbg !112
  %429 = extractelement <8 x float> %424, i64 4, !dbg !112
  %430 = extractelement <8 x float> %424, i64 5, !dbg !112
  %431 = extractelement <8 x float> %424, i64 6, !dbg !112
  %432 = extractelement <8 x float> %424, i64 7, !dbg !112
  %433 = add i64 %106, 10, !dbg !112
  %434 = add nuw nsw i64 %107, %433, !dbg !112
  %435 = getelementptr inbounds nuw float, ptr %6, i64 %434, !dbg !112
  %436 = load float, ptr %435, align 4, !dbg !112
  %437 = extractelement <16 x float> %111, i64 10, !dbg !112
  %438 = extractelement <16 x float> %113, i64 10, !dbg !112
  %439 = extractelement <16 x float> %115, i64 10, !dbg !112
  %440 = extractelement <16 x float> %117, i64 10, !dbg !112
  %441 = extractelement <16 x float> %119, i64 10, !dbg !112
  %442 = extractelement <16 x float> %121, i64 10, !dbg !112
  %443 = extractelement <16 x float> %123, i64 10, !dbg !112
  %444 = extractelement <16 x float> %125, i64 10, !dbg !112
  %445 = insertelement <8 x float> poison, float %437, i64 0, !dbg !112
  %446 = insertelement <8 x float> %445, float %438, i64 1, !dbg !112
  %447 = insertelement <8 x float> %446, float %439, i64 2, !dbg !112
  %448 = insertelement <8 x float> %447, float %440, i64 3, !dbg !112
  %449 = insertelement <8 x float> %448, float %441, i64 4, !dbg !112
  %450 = insertelement <8 x float> %449, float %442, i64 5, !dbg !112
  %451 = insertelement <8 x float> %450, float %443, i64 6, !dbg !112
  %452 = insertelement <8 x float> %451, float %444, i64 7, !dbg !112
  %453 = insertelement <8 x float> poison, float %436, i32 0, !dbg !112
  %454 = shufflevector <8 x float> %453, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %455 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %454, <8 x float> %452), !dbg !112
  %456 = extractelement <8 x float> %455, i64 0, !dbg !112
  %457 = extractelement <8 x float> %455, i64 1, !dbg !112
  %458 = extractelement <8 x float> %455, i64 2, !dbg !112
  %459 = extractelement <8 x float> %455, i64 3, !dbg !112
  %460 = extractelement <8 x float> %455, i64 4, !dbg !112
  %461 = extractelement <8 x float> %455, i64 5, !dbg !112
  %462 = extractelement <8 x float> %455, i64 6, !dbg !112
  %463 = extractelement <8 x float> %455, i64 7, !dbg !112
  %464 = add i64 %106, 11, !dbg !112
  %465 = add nuw nsw i64 %107, %464, !dbg !112
  %466 = getelementptr inbounds nuw float, ptr %6, i64 %465, !dbg !112
  %467 = load float, ptr %466, align 4, !dbg !112
  %468 = extractelement <16 x float> %111, i64 11, !dbg !112
  %469 = extractelement <16 x float> %113, i64 11, !dbg !112
  %470 = extractelement <16 x float> %115, i64 11, !dbg !112
  %471 = extractelement <16 x float> %117, i64 11, !dbg !112
  %472 = extractelement <16 x float> %119, i64 11, !dbg !112
  %473 = extractelement <16 x float> %121, i64 11, !dbg !112
  %474 = extractelement <16 x float> %123, i64 11, !dbg !112
  %475 = extractelement <16 x float> %125, i64 11, !dbg !112
  %476 = insertelement <8 x float> poison, float %468, i64 0, !dbg !112
  %477 = insertelement <8 x float> %476, float %469, i64 1, !dbg !112
  %478 = insertelement <8 x float> %477, float %470, i64 2, !dbg !112
  %479 = insertelement <8 x float> %478, float %471, i64 3, !dbg !112
  %480 = insertelement <8 x float> %479, float %472, i64 4, !dbg !112
  %481 = insertelement <8 x float> %480, float %473, i64 5, !dbg !112
  %482 = insertelement <8 x float> %481, float %474, i64 6, !dbg !112
  %483 = insertelement <8 x float> %482, float %475, i64 7, !dbg !112
  %484 = insertelement <8 x float> poison, float %467, i32 0, !dbg !112
  %485 = shufflevector <8 x float> %484, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %486 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %485, <8 x float> %483), !dbg !112
  %487 = extractelement <8 x float> %486, i64 0, !dbg !112
  %488 = extractelement <8 x float> %486, i64 1, !dbg !112
  %489 = extractelement <8 x float> %486, i64 2, !dbg !112
  %490 = extractelement <8 x float> %486, i64 3, !dbg !112
  %491 = extractelement <8 x float> %486, i64 4, !dbg !112
  %492 = extractelement <8 x float> %486, i64 5, !dbg !112
  %493 = extractelement <8 x float> %486, i64 6, !dbg !112
  %494 = extractelement <8 x float> %486, i64 7, !dbg !112
  %495 = add i64 %106, 12, !dbg !112
  %496 = add nuw nsw i64 %107, %495, !dbg !112
  %497 = getelementptr inbounds nuw float, ptr %6, i64 %496, !dbg !112
  %498 = load float, ptr %497, align 4, !dbg !112
  %499 = extractelement <16 x float> %111, i64 12, !dbg !112
  %500 = extractelement <16 x float> %113, i64 12, !dbg !112
  %501 = extractelement <16 x float> %115, i64 12, !dbg !112
  %502 = extractelement <16 x float> %117, i64 12, !dbg !112
  %503 = extractelement <16 x float> %119, i64 12, !dbg !112
  %504 = extractelement <16 x float> %121, i64 12, !dbg !112
  %505 = extractelement <16 x float> %123, i64 12, !dbg !112
  %506 = extractelement <16 x float> %125, i64 12, !dbg !112
  %507 = insertelement <8 x float> poison, float %499, i64 0, !dbg !112
  %508 = insertelement <8 x float> %507, float %500, i64 1, !dbg !112
  %509 = insertelement <8 x float> %508, float %501, i64 2, !dbg !112
  %510 = insertelement <8 x float> %509, float %502, i64 3, !dbg !112
  %511 = insertelement <8 x float> %510, float %503, i64 4, !dbg !112
  %512 = insertelement <8 x float> %511, float %504, i64 5, !dbg !112
  %513 = insertelement <8 x float> %512, float %505, i64 6, !dbg !112
  %514 = insertelement <8 x float> %513, float %506, i64 7, !dbg !112
  %515 = insertelement <8 x float> poison, float %498, i32 0, !dbg !112
  %516 = shufflevector <8 x float> %515, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %517 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %516, <8 x float> %514), !dbg !112
  %518 = extractelement <8 x float> %517, i64 0, !dbg !112
  %519 = extractelement <8 x float> %517, i64 1, !dbg !112
  %520 = extractelement <8 x float> %517, i64 2, !dbg !112
  %521 = extractelement <8 x float> %517, i64 3, !dbg !112
  %522 = extractelement <8 x float> %517, i64 4, !dbg !112
  %523 = extractelement <8 x float> %517, i64 5, !dbg !112
  %524 = extractelement <8 x float> %517, i64 6, !dbg !112
  %525 = extractelement <8 x float> %517, i64 7, !dbg !112
  %526 = add i64 %106, 13, !dbg !112
  %527 = add nuw nsw i64 %107, %526, !dbg !112
  %528 = getelementptr inbounds nuw float, ptr %6, i64 %527, !dbg !112
  %529 = load float, ptr %528, align 4, !dbg !112
  %530 = extractelement <16 x float> %111, i64 13, !dbg !112
  %531 = extractelement <16 x float> %113, i64 13, !dbg !112
  %532 = extractelement <16 x float> %115, i64 13, !dbg !112
  %533 = extractelement <16 x float> %117, i64 13, !dbg !112
  %534 = extractelement <16 x float> %119, i64 13, !dbg !112
  %535 = extractelement <16 x float> %121, i64 13, !dbg !112
  %536 = extractelement <16 x float> %123, i64 13, !dbg !112
  %537 = extractelement <16 x float> %125, i64 13, !dbg !112
  %538 = insertelement <8 x float> poison, float %530, i64 0, !dbg !112
  %539 = insertelement <8 x float> %538, float %531, i64 1, !dbg !112
  %540 = insertelement <8 x float> %539, float %532, i64 2, !dbg !112
  %541 = insertelement <8 x float> %540, float %533, i64 3, !dbg !112
  %542 = insertelement <8 x float> %541, float %534, i64 4, !dbg !112
  %543 = insertelement <8 x float> %542, float %535, i64 5, !dbg !112
  %544 = insertelement <8 x float> %543, float %536, i64 6, !dbg !112
  %545 = insertelement <8 x float> %544, float %537, i64 7, !dbg !112
  %546 = insertelement <8 x float> poison, float %529, i32 0, !dbg !112
  %547 = shufflevector <8 x float> %546, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %548 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %547, <8 x float> %545), !dbg !112
  %549 = extractelement <8 x float> %548, i64 0, !dbg !112
  %550 = extractelement <8 x float> %548, i64 1, !dbg !112
  %551 = extractelement <8 x float> %548, i64 2, !dbg !112
  %552 = extractelement <8 x float> %548, i64 3, !dbg !112
  %553 = extractelement <8 x float> %548, i64 4, !dbg !112
  %554 = extractelement <8 x float> %548, i64 5, !dbg !112
  %555 = extractelement <8 x float> %548, i64 6, !dbg !112
  %556 = extractelement <8 x float> %548, i64 7, !dbg !112
  %557 = add i64 %106, 14, !dbg !112
  %558 = add nuw nsw i64 %107, %557, !dbg !112
  %559 = getelementptr inbounds nuw float, ptr %6, i64 %558, !dbg !112
  %560 = load float, ptr %559, align 4, !dbg !112
  %561 = extractelement <16 x float> %111, i64 14, !dbg !112
  %562 = extractelement <16 x float> %113, i64 14, !dbg !112
  %563 = extractelement <16 x float> %115, i64 14, !dbg !112
  %564 = extractelement <16 x float> %117, i64 14, !dbg !112
  %565 = extractelement <16 x float> %119, i64 14, !dbg !112
  %566 = extractelement <16 x float> %121, i64 14, !dbg !112
  %567 = extractelement <16 x float> %123, i64 14, !dbg !112
  %568 = extractelement <16 x float> %125, i64 14, !dbg !112
  %569 = insertelement <8 x float> poison, float %561, i64 0, !dbg !112
  %570 = insertelement <8 x float> %569, float %562, i64 1, !dbg !112
  %571 = insertelement <8 x float> %570, float %563, i64 2, !dbg !112
  %572 = insertelement <8 x float> %571, float %564, i64 3, !dbg !112
  %573 = insertelement <8 x float> %572, float %565, i64 4, !dbg !112
  %574 = insertelement <8 x float> %573, float %566, i64 5, !dbg !112
  %575 = insertelement <8 x float> %574, float %567, i64 6, !dbg !112
  %576 = insertelement <8 x float> %575, float %568, i64 7, !dbg !112
  %577 = insertelement <8 x float> poison, float %560, i32 0, !dbg !112
  %578 = shufflevector <8 x float> %577, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %579 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %578, <8 x float> %576), !dbg !112
  %580 = extractelement <8 x float> %579, i64 0, !dbg !112
  %581 = extractelement <8 x float> %579, i64 1, !dbg !112
  %582 = extractelement <8 x float> %579, i64 2, !dbg !112
  %583 = extractelement <8 x float> %579, i64 3, !dbg !112
  %584 = extractelement <8 x float> %579, i64 4, !dbg !112
  %585 = extractelement <8 x float> %579, i64 5, !dbg !112
  %586 = extractelement <8 x float> %579, i64 6, !dbg !112
  %587 = extractelement <8 x float> %579, i64 7, !dbg !112
  %588 = add i64 %106, 15, !dbg !112
  %589 = add nuw nsw i64 %107, %588, !dbg !112
  %590 = getelementptr inbounds nuw float, ptr %6, i64 %589, !dbg !112
  %591 = load float, ptr %590, align 4, !dbg !112
  %592 = extractelement <16 x float> %111, i64 15, !dbg !112
  %593 = extractelement <16 x float> %113, i64 15, !dbg !112
  %594 = extractelement <16 x float> %115, i64 15, !dbg !112
  %595 = extractelement <16 x float> %117, i64 15, !dbg !112
  %596 = extractelement <16 x float> %119, i64 15, !dbg !112
  %597 = extractelement <16 x float> %121, i64 15, !dbg !112
  %598 = extractelement <16 x float> %123, i64 15, !dbg !112
  %599 = extractelement <16 x float> %125, i64 15, !dbg !112
  %600 = insertelement <8 x float> poison, float %592, i64 0, !dbg !112
  %601 = insertelement <8 x float> %600, float %593, i64 1, !dbg !112
  %602 = insertelement <8 x float> %601, float %594, i64 2, !dbg !112
  %603 = insertelement <8 x float> %602, float %595, i64 3, !dbg !112
  %604 = insertelement <8 x float> %603, float %596, i64 4, !dbg !112
  %605 = insertelement <8 x float> %604, float %597, i64 5, !dbg !112
  %606 = insertelement <8 x float> %605, float %598, i64 6, !dbg !112
  %607 = insertelement <8 x float> %606, float %599, i64 7, !dbg !112
  %608 = insertelement <8 x float> poison, float %591, i32 0, !dbg !112
  %609 = shufflevector <8 x float> %608, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !112
  %610 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %609, <8 x float> %607), !dbg !112
  %611 = extractelement <8 x float> %610, i64 0, !dbg !112
  %612 = extractelement <8 x float> %610, i64 1, !dbg !112
  %613 = extractelement <8 x float> %610, i64 2, !dbg !112
  %614 = extractelement <8 x float> %610, i64 3, !dbg !112
  %615 = extractelement <8 x float> %610, i64 4, !dbg !112
  %616 = extractelement <8 x float> %610, i64 5, !dbg !112
  %617 = extractelement <8 x float> %610, i64 6, !dbg !112
  %618 = extractelement <8 x float> %610, i64 7, !dbg !112
  %619 = insertelement <16 x float> poison, float %146, i64 0, !dbg !112
  %620 = insertelement <16 x float> %619, float %177, i64 1, !dbg !112
  %621 = insertelement <16 x float> %620, float %208, i64 2, !dbg !112
  %622 = insertelement <16 x float> %621, float %239, i64 3, !dbg !112
  %623 = insertelement <16 x float> %622, float %270, i64 4, !dbg !112
  %624 = insertelement <16 x float> %623, float %301, i64 5, !dbg !112
  %625 = insertelement <16 x float> %624, float %332, i64 6, !dbg !112
  %626 = insertelement <16 x float> %625, float %363, i64 7, !dbg !112
  %627 = insertelement <16 x float> %626, float %394, i64 8, !dbg !112
  %628 = insertelement <16 x float> %627, float %425, i64 9, !dbg !112
  %629 = insertelement <16 x float> %628, float %456, i64 10, !dbg !112
  %630 = insertelement <16 x float> %629, float %487, i64 11, !dbg !112
  %631 = insertelement <16 x float> %630, float %518, i64 12, !dbg !112
  %632 = insertelement <16 x float> %631, float %549, i64 13, !dbg !112
  %633 = insertelement <16 x float> %632, float %580, i64 14, !dbg !112
  %634 = insertelement <16 x float> %633, float %611, i64 15, !dbg !112
  %635 = insertvalue [8 x <16 x float>] poison, <16 x float> %634, 0, !dbg !112
  %636 = insertelement <16 x float> poison, float %147, i64 0, !dbg !112
  %637 = insertelement <16 x float> %636, float %178, i64 1, !dbg !112
  %638 = insertelement <16 x float> %637, float %209, i64 2, !dbg !112
  %639 = insertelement <16 x float> %638, float %240, i64 3, !dbg !112
  %640 = insertelement <16 x float> %639, float %271, i64 4, !dbg !112
  %641 = insertelement <16 x float> %640, float %302, i64 5, !dbg !112
  %642 = insertelement <16 x float> %641, float %333, i64 6, !dbg !112
  %643 = insertelement <16 x float> %642, float %364, i64 7, !dbg !112
  %644 = insertelement <16 x float> %643, float %395, i64 8, !dbg !112
  %645 = insertelement <16 x float> %644, float %426, i64 9, !dbg !112
  %646 = insertelement <16 x float> %645, float %457, i64 10, !dbg !112
  %647 = insertelement <16 x float> %646, float %488, i64 11, !dbg !112
  %648 = insertelement <16 x float> %647, float %519, i64 12, !dbg !112
  %649 = insertelement <16 x float> %648, float %550, i64 13, !dbg !112
  %650 = insertelement <16 x float> %649, float %581, i64 14, !dbg !112
  %651 = insertelement <16 x float> %650, float %612, i64 15, !dbg !112
  %652 = insertvalue [8 x <16 x float>] %635, <16 x float> %651, 1, !dbg !112
  %653 = insertelement <16 x float> poison, float %148, i64 0, !dbg !112
  %654 = insertelement <16 x float> %653, float %179, i64 1, !dbg !112
  %655 = insertelement <16 x float> %654, float %210, i64 2, !dbg !112
  %656 = insertelement <16 x float> %655, float %241, i64 3, !dbg !112
  %657 = insertelement <16 x float> %656, float %272, i64 4, !dbg !112
  %658 = insertelement <16 x float> %657, float %303, i64 5, !dbg !112
  %659 = insertelement <16 x float> %658, float %334, i64 6, !dbg !112
  %660 = insertelement <16 x float> %659, float %365, i64 7, !dbg !112
  %661 = insertelement <16 x float> %660, float %396, i64 8, !dbg !112
  %662 = insertelement <16 x float> %661, float %427, i64 9, !dbg !112
  %663 = insertelement <16 x float> %662, float %458, i64 10, !dbg !112
  %664 = insertelement <16 x float> %663, float %489, i64 11, !dbg !112
  %665 = insertelement <16 x float> %664, float %520, i64 12, !dbg !112
  %666 = insertelement <16 x float> %665, float %551, i64 13, !dbg !112
  %667 = insertelement <16 x float> %666, float %582, i64 14, !dbg !112
  %668 = insertelement <16 x float> %667, float %613, i64 15, !dbg !112
  %669 = insertvalue [8 x <16 x float>] %652, <16 x float> %668, 2, !dbg !112
  %670 = insertelement <16 x float> poison, float %149, i64 0, !dbg !112
  %671 = insertelement <16 x float> %670, float %180, i64 1, !dbg !112
  %672 = insertelement <16 x float> %671, float %211, i64 2, !dbg !112
  %673 = insertelement <16 x float> %672, float %242, i64 3, !dbg !112
  %674 = insertelement <16 x float> %673, float %273, i64 4, !dbg !112
  %675 = insertelement <16 x float> %674, float %304, i64 5, !dbg !112
  %676 = insertelement <16 x float> %675, float %335, i64 6, !dbg !112
  %677 = insertelement <16 x float> %676, float %366, i64 7, !dbg !112
  %678 = insertelement <16 x float> %677, float %397, i64 8, !dbg !112
  %679 = insertelement <16 x float> %678, float %428, i64 9, !dbg !112
  %680 = insertelement <16 x float> %679, float %459, i64 10, !dbg !112
  %681 = insertelement <16 x float> %680, float %490, i64 11, !dbg !112
  %682 = insertelement <16 x float> %681, float %521, i64 12, !dbg !112
  %683 = insertelement <16 x float> %682, float %552, i64 13, !dbg !112
  %684 = insertelement <16 x float> %683, float %583, i64 14, !dbg !112
  %685 = insertelement <16 x float> %684, float %614, i64 15, !dbg !112
  %686 = insertvalue [8 x <16 x float>] %669, <16 x float> %685, 3, !dbg !112
  %687 = insertelement <16 x float> poison, float %150, i64 0, !dbg !112
  %688 = insertelement <16 x float> %687, float %181, i64 1, !dbg !112
  %689 = insertelement <16 x float> %688, float %212, i64 2, !dbg !112
  %690 = insertelement <16 x float> %689, float %243, i64 3, !dbg !112
  %691 = insertelement <16 x float> %690, float %274, i64 4, !dbg !112
  %692 = insertelement <16 x float> %691, float %305, i64 5, !dbg !112
  %693 = insertelement <16 x float> %692, float %336, i64 6, !dbg !112
  %694 = insertelement <16 x float> %693, float %367, i64 7, !dbg !112
  %695 = insertelement <16 x float> %694, float %398, i64 8, !dbg !112
  %696 = insertelement <16 x float> %695, float %429, i64 9, !dbg !112
  %697 = insertelement <16 x float> %696, float %460, i64 10, !dbg !112
  %698 = insertelement <16 x float> %697, float %491, i64 11, !dbg !112
  %699 = insertelement <16 x float> %698, float %522, i64 12, !dbg !112
  %700 = insertelement <16 x float> %699, float %553, i64 13, !dbg !112
  %701 = insertelement <16 x float> %700, float %584, i64 14, !dbg !112
  %702 = insertelement <16 x float> %701, float %615, i64 15, !dbg !112
  %703 = insertvalue [8 x <16 x float>] %686, <16 x float> %702, 4, !dbg !112
  %704 = insertelement <16 x float> poison, float %151, i64 0, !dbg !112
  %705 = insertelement <16 x float> %704, float %182, i64 1, !dbg !112
  %706 = insertelement <16 x float> %705, float %213, i64 2, !dbg !112
  %707 = insertelement <16 x float> %706, float %244, i64 3, !dbg !112
  %708 = insertelement <16 x float> %707, float %275, i64 4, !dbg !112
  %709 = insertelement <16 x float> %708, float %306, i64 5, !dbg !112
  %710 = insertelement <16 x float> %709, float %337, i64 6, !dbg !112
  %711 = insertelement <16 x float> %710, float %368, i64 7, !dbg !112
  %712 = insertelement <16 x float> %711, float %399, i64 8, !dbg !112
  %713 = insertelement <16 x float> %712, float %430, i64 9, !dbg !112
  %714 = insertelement <16 x float> %713, float %461, i64 10, !dbg !112
  %715 = insertelement <16 x float> %714, float %492, i64 11, !dbg !112
  %716 = insertelement <16 x float> %715, float %523, i64 12, !dbg !112
  %717 = insertelement <16 x float> %716, float %554, i64 13, !dbg !112
  %718 = insertelement <16 x float> %717, float %585, i64 14, !dbg !112
  %719 = insertelement <16 x float> %718, float %616, i64 15, !dbg !112
  %720 = insertvalue [8 x <16 x float>] %703, <16 x float> %719, 5, !dbg !112
  %721 = insertelement <16 x float> poison, float %152, i64 0, !dbg !112
  %722 = insertelement <16 x float> %721, float %183, i64 1, !dbg !112
  %723 = insertelement <16 x float> %722, float %214, i64 2, !dbg !112
  %724 = insertelement <16 x float> %723, float %245, i64 3, !dbg !112
  %725 = insertelement <16 x float> %724, float %276, i64 4, !dbg !112
  %726 = insertelement <16 x float> %725, float %307, i64 5, !dbg !112
  %727 = insertelement <16 x float> %726, float %338, i64 6, !dbg !112
  %728 = insertelement <16 x float> %727, float %369, i64 7, !dbg !112
  %729 = insertelement <16 x float> %728, float %400, i64 8, !dbg !112
  %730 = insertelement <16 x float> %729, float %431, i64 9, !dbg !112
  %731 = insertelement <16 x float> %730, float %462, i64 10, !dbg !112
  %732 = insertelement <16 x float> %731, float %493, i64 11, !dbg !112
  %733 = insertelement <16 x float> %732, float %524, i64 12, !dbg !112
  %734 = insertelement <16 x float> %733, float %555, i64 13, !dbg !112
  %735 = insertelement <16 x float> %734, float %586, i64 14, !dbg !112
  %736 = insertelement <16 x float> %735, float %617, i64 15, !dbg !112
  %737 = insertvalue [8 x <16 x float>] %720, <16 x float> %736, 6, !dbg !112
  %738 = insertelement <16 x float> poison, float %153, i64 0, !dbg !112
  %739 = insertelement <16 x float> %738, float %184, i64 1, !dbg !112
  %740 = insertelement <16 x float> %739, float %215, i64 2, !dbg !112
  %741 = insertelement <16 x float> %740, float %246, i64 3, !dbg !112
  %742 = insertelement <16 x float> %741, float %277, i64 4, !dbg !112
  %743 = insertelement <16 x float> %742, float %308, i64 5, !dbg !112
  %744 = insertelement <16 x float> %743, float %339, i64 6, !dbg !112
  %745 = insertelement <16 x float> %744, float %370, i64 7, !dbg !112
  %746 = insertelement <16 x float> %745, float %401, i64 8, !dbg !112
  %747 = insertelement <16 x float> %746, float %432, i64 9, !dbg !112
  %748 = insertelement <16 x float> %747, float %463, i64 10, !dbg !112
  %749 = insertelement <16 x float> %748, float %494, i64 11, !dbg !112
  %750 = insertelement <16 x float> %749, float %525, i64 12, !dbg !112
  %751 = insertelement <16 x float> %750, float %556, i64 13, !dbg !112
  %752 = insertelement <16 x float> %751, float %587, i64 14, !dbg !112
  %753 = insertelement <16 x float> %752, float %618, i64 15, !dbg !112
  %754 = insertvalue [8 x <16 x float>] %737, <16 x float> %753, 7, !dbg !112
  %755 = add i64 %55, 1, !dbg !110
  br label %54, !dbg !110

756:                                              ; preds = %54
  %757 = extractvalue [8 x <16 x float>] %56, 0, !dbg !113
  %758 = fadd contract <16 x float> %757, %43, !dbg !113
  %759 = extractvalue [8 x <16 x float>] %56, 1, !dbg !113
  %760 = fadd contract <16 x float> %759, %44, !dbg !113
  %761 = extractvalue [8 x <16 x float>] %56, 2, !dbg !113
  %762 = fadd contract <16 x float> %761, %45, !dbg !113
  %763 = extractvalue [8 x <16 x float>] %56, 3, !dbg !113
  %764 = fadd contract <16 x float> %763, %46, !dbg !113
  %765 = extractvalue [8 x <16 x float>] %56, 4, !dbg !113
  %766 = fadd contract <16 x float> %765, %47, !dbg !113
  %767 = extractvalue [8 x <16 x float>] %56, 5, !dbg !113
  %768 = fadd contract <16 x float> %767, %48, !dbg !113
  %769 = extractvalue [8 x <16 x float>] %56, 6, !dbg !113
  %770 = fadd contract <16 x float> %769, %49, !dbg !113
  %771 = extractvalue [8 x <16 x float>] %56, 7, !dbg !113
  %772 = fadd contract <16 x float> %771, %50, !dbg !113
  %773 = fcmp olt <16 x float> zeroinitializer, %758, !dbg !114
  %774 = fcmp olt <16 x float> zeroinitializer, %760, !dbg !114
  %775 = fcmp olt <16 x float> zeroinitializer, %762, !dbg !114
  %776 = fcmp olt <16 x float> zeroinitializer, %764, !dbg !114
  %777 = fcmp olt <16 x float> zeroinitializer, %766, !dbg !114
  %778 = fcmp olt <16 x float> zeroinitializer, %768, !dbg !114
  %779 = fcmp olt <16 x float> zeroinitializer, %770, !dbg !114
  %780 = fcmp olt <16 x float> zeroinitializer, %772, !dbg !114
  %781 = select <16 x i1> %773, <16 x float> zeroinitializer, <16 x float> %758, !dbg !115
  %782 = select <16 x i1> %774, <16 x float> zeroinitializer, <16 x float> %760, !dbg !115
  %783 = select <16 x i1> %775, <16 x float> zeroinitializer, <16 x float> %762, !dbg !115
  %784 = select <16 x i1> %776, <16 x float> zeroinitializer, <16 x float> %764, !dbg !115
  %785 = select <16 x i1> %777, <16 x float> zeroinitializer, <16 x float> %766, !dbg !115
  %786 = select <16 x i1> %778, <16 x float> zeroinitializer, <16 x float> %768, !dbg !115
  %787 = select <16 x i1> %779, <16 x float> zeroinitializer, <16 x float> %770, !dbg !115
  %788 = select <16 x i1> %780, <16 x float> zeroinitializer, <16 x float> %772, !dbg !115
  %789 = fmul contract <16 x float> %781, splat (float 0x3FC99999A0000000), !dbg !116
  %790 = fmul contract <16 x float> %782, splat (float 0x3FC99999A0000000), !dbg !116
  %791 = fmul contract <16 x float> %783, splat (float 0x3FC99999A0000000), !dbg !116
  %792 = fmul contract <16 x float> %784, splat (float 0x3FC99999A0000000), !dbg !116
  %793 = fmul contract <16 x float> %785, splat (float 0x3FC99999A0000000), !dbg !116
  %794 = fmul contract <16 x float> %786, splat (float 0x3FC99999A0000000), !dbg !116
  %795 = fmul contract <16 x float> %787, splat (float 0x3FC99999A0000000), !dbg !116
  %796 = fmul contract <16 x float> %788, splat (float 0x3FC99999A0000000), !dbg !116
  %797 = fcmp ogt <16 x float> zeroinitializer, %758, !dbg !117
  %798 = fcmp ogt <16 x float> zeroinitializer, %760, !dbg !117
  %799 = fcmp ogt <16 x float> zeroinitializer, %762, !dbg !117
  %800 = fcmp ogt <16 x float> zeroinitializer, %764, !dbg !117
  %801 = fcmp ogt <16 x float> zeroinitializer, %766, !dbg !117
  %802 = fcmp ogt <16 x float> zeroinitializer, %768, !dbg !117
  %803 = fcmp ogt <16 x float> zeroinitializer, %770, !dbg !117
  %804 = fcmp ogt <16 x float> zeroinitializer, %772, !dbg !117
  %805 = select <16 x i1> %797, <16 x float> zeroinitializer, <16 x float> %758, !dbg !118
  %806 = select <16 x i1> %798, <16 x float> zeroinitializer, <16 x float> %760, !dbg !118
  %807 = select <16 x i1> %799, <16 x float> zeroinitializer, <16 x float> %762, !dbg !118
  %808 = select <16 x i1> %800, <16 x float> zeroinitializer, <16 x float> %764, !dbg !118
  %809 = select <16 x i1> %801, <16 x float> zeroinitializer, <16 x float> %766, !dbg !118
  %810 = select <16 x i1> %802, <16 x float> zeroinitializer, <16 x float> %768, !dbg !118
  %811 = select <16 x i1> %803, <16 x float> zeroinitializer, <16 x float> %770, !dbg !118
  %812 = select <16 x i1> %804, <16 x float> zeroinitializer, <16 x float> %772, !dbg !118
  %813 = fadd contract <16 x float> %805, %789, !dbg !119
  %814 = fadd contract <16 x float> %806, %790, !dbg !119
  %815 = fadd contract <16 x float> %807, %791, !dbg !119
  %816 = fadd contract <16 x float> %808, %792, !dbg !119
  %817 = fadd contract <16 x float> %809, %793, !dbg !119
  %818 = fadd contract <16 x float> %810, %794, !dbg !119
  %819 = fadd contract <16 x float> %811, %795, !dbg !119
  %820 = fadd contract <16 x float> %812, %796, !dbg !119
  %821 = add i64 %18, %52, !dbg !110
  %822 = mul i64 %20, 50176, !dbg !110
  %823 = add i64 %822, %821, !dbg !110
  %824 = getelementptr float, ptr %14, i64 %823, !dbg !110
  store <16 x float> %813, ptr %824, align 4, !dbg !110
  %825 = add i64 %20, 1, !dbg !110
  %826 = mul i64 %825, 50176, !dbg !110
  %827 = add i64 %826, %821, !dbg !110
  %828 = getelementptr float, ptr %14, i64 %827, !dbg !110
  store <16 x float> %814, ptr %828, align 4, !dbg !110
  %829 = add i64 %20, 2, !dbg !110
  %830 = mul i64 %829, 50176, !dbg !110
  %831 = add i64 %830, %821, !dbg !110
  %832 = getelementptr float, ptr %14, i64 %831, !dbg !110
  store <16 x float> %815, ptr %832, align 4, !dbg !110
  %833 = add i64 %20, 3, !dbg !110
  %834 = mul i64 %833, 50176, !dbg !110
  %835 = add i64 %834, %821, !dbg !110
  %836 = getelementptr float, ptr %14, i64 %835, !dbg !110
  store <16 x float> %816, ptr %836, align 4, !dbg !110
  %837 = add i64 %20, 4, !dbg !110
  %838 = mul i64 %837, 50176, !dbg !110
  %839 = add i64 %838, %821, !dbg !110
  %840 = getelementptr float, ptr %14, i64 %839, !dbg !110
  store <16 x float> %817, ptr %840, align 4, !dbg !110
  %841 = add i64 %20, 5, !dbg !110
  %842 = mul i64 %841, 50176, !dbg !110
  %843 = add i64 %842, %821, !dbg !110
  %844 = getelementptr float, ptr %14, i64 %843, !dbg !110
  store <16 x float> %818, ptr %844, align 4, !dbg !110
  %845 = add i64 %20, 6, !dbg !110
  %846 = mul i64 %845, 50176, !dbg !110
  %847 = add i64 %846, %821, !dbg !110
  %848 = getelementptr float, ptr %14, i64 %847, !dbg !110
  store <16 x float> %819, ptr %848, align 4, !dbg !110
  %849 = add i64 %20, 7, !dbg !110
  %850 = mul i64 %849, 50176, !dbg !110
  %851 = add i64 %850, %821, !dbg !110
  %852 = getelementptr float, ptr %14, i64 %851, !dbg !110
  store <16 x float> %820, ptr %852, align 4, !dbg !110
  %853 = add i64 %52, 16, !dbg !110
  br label %51, !dbg !110

854:                                              ; preds = %51
  %855 = add i64 %20, 8, !dbg !110
  br label %19, !dbg !110

856:                                              ; preds = %19
  ret i32 0, !dbg !120
}

define internal i32 @infer_dispatch_1_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !121 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !122
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !122
  %6 = load ptr, ptr %5, align 8, !dbg !122
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !123
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !124
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !124
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !124
  %10 = load ptr, ptr %9, align 8, !dbg !124
  %11 = getelementptr float, ptr %10, i64 1605632, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !125
  %12 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !126
  %13 = extractvalue %iree_hal_executable_workgroup_state_v0_t %12, 0, !dbg !126
  %14 = zext i32 %13 to i64, !dbg !126
  %15 = sdiv i64 %14, 4, !dbg !126
  %16 = mul i64 %15, 4, !dbg !126
  %17 = icmp ne i64 %14, %16, !dbg !126
  %18 = icmp slt i64 %14, 0, !dbg !126
  %19 = and i1 %17, %18, !dbg !126
  %20 = add i64 %15, -1, !dbg !126
  %21 = select i1 %19, i64 %20, i64 %15, !dbg !126
  %22 = srem i64 %14, 4, !dbg !126
  %23 = icmp slt i64 %22, 0, !dbg !126
  %24 = add nsw i64 %22, 4, !dbg !126
  %25 = select i1 %23, i64 %24, i64 %22, !dbg !126
  %26 = mul nsw i64 %21, 56, !dbg !126
  %27 = mul nsw i64 %25, 56, !dbg !126
  br label %28, !dbg !126

28:                                               ; preds = %56, %3
  %29 = phi i64 [ %57, %56 ], [ 0, %3 ], !dbg !126
  %30 = icmp slt i64 %29, 32, !dbg !126
  br i1 %30, label %31, label %58, !dbg !126

31:                                               ; preds = %54, %28
  %32 = phi i64 [ %55, %54 ], [ 0, %28 ], !dbg !126
  %33 = icmp slt i64 %32, 56, !dbg !126
  br i1 %33, label %34, label %56, !dbg !126

34:                                               ; preds = %37, %31
  %35 = phi i64 [ %53, %37 ], [ 0, %31 ], !dbg !126
  %36 = icmp slt i64 %35, 56, !dbg !126
  br i1 %36, label %37, label %54, !dbg !126

37:                                               ; preds = %34
  %38 = add i64 %26, %32, !dbg !126
  %39 = add i64 %27, %35, !dbg !126
  %40 = mul i64 %29, 50176, !dbg !126
  %41 = mul i64 %38, 224, !dbg !126
  %42 = add i64 %40, %41, !dbg !126
  %43 = add i64 %42, %39, !dbg !126
  %44 = getelementptr float, ptr %6, i64 %43, !dbg !126
  %45 = load <4 x float>, ptr %44, align 4, !dbg !126
  %46 = add i64 %38, 1, !dbg !126
  %47 = add i64 %39, 1, !dbg !126
  %48 = mul i64 %29, 51076, !dbg !126
  %49 = mul i64 %46, 226, !dbg !126
  %50 = add i64 %48, %49, !dbg !126
  %51 = add i64 %50, %47, !dbg !126
  %52 = getelementptr float, ptr %11, i64 %51, !dbg !126
  store <4 x float> %45, ptr %52, align 4, !dbg !126
  %53 = add i64 %35, 4, !dbg !126
  br label %34, !dbg !126

54:                                               ; preds = %34
  %55 = add i64 %32, 1, !dbg !126
  br label %31, !dbg !126

56:                                               ; preds = %31
  %57 = add i64 %29, 1, !dbg !126
  br label %28, !dbg !126

58:                                               ; preds = %28
  ret i32 0, !dbg !127
}

define internal i32 @infer_dispatch_2_conv_64x224x224x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !128 {
  %4 = alloca float, i64 4, align 64, !dbg !129
  %5 = alloca float, i64 4, align 64, !dbg !130
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !131
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !131
  %8 = load ptr, ptr %7, align 8, !dbg !131
  %9 = getelementptr float, ptr %8, i64 1605632, !dbg !131
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !131
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !132
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !132
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !132
  %13 = load ptr, ptr %12, align 8, !dbg !132
  %14 = getelementptr float, ptr %13, i64 1052480, !dbg !132
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !132
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !133
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !133
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !133
  %18 = load ptr, ptr %17, align 8, !dbg !133
  %19 = getelementptr float, ptr %18, i64 3240064, !dbg !133
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !133
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !129
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !129
  %22 = zext i32 %21 to i64, !dbg !129
  %23 = sdiv i64 %22, 49, !dbg !129
  %24 = mul i64 %23, 49, !dbg !129
  %25 = icmp ne i64 %22, %24, !dbg !129
  %26 = icmp slt i64 %22, 0, !dbg !129
  %27 = and i1 %25, %26, !dbg !129
  %28 = add i64 %23, -1, !dbg !129
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !129
  %30 = srem i64 %22, 49, !dbg !129
  %31 = icmp slt i64 %30, 0, !dbg !129
  %32 = add nsw i64 %30, 49, !dbg !129
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !129
  %34 = sdiv i64 %33, 7, !dbg !129
  %35 = srem i64 %22, 7, !dbg !129
  %36 = icmp slt i64 %35, 0, !dbg !129
  %37 = add nsw i64 %35, 7, !dbg !129
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !129
  %39 = mul nsw i64 %29, 32, !dbg !129
  %40 = mul nsw i64 %34, 32, !dbg !129
  %41 = mul nsw i64 %38, 32, !dbg !129
  %42 = getelementptr float, ptr %5, i64 0, !dbg !134
  store <4 x float> zeroinitializer, ptr %42, align 4, !dbg !134
  br label %43, !dbg !129

43:                                               ; preds = %135, %3
  %44 = phi i64 [ %136, %135 ], [ 0, %3 ], !dbg !129
  %45 = icmp slt i64 %44, 32, !dbg !129
  br i1 %45, label %46, label %137, !dbg !129

46:                                               ; preds = %43
  %47 = add i64 %44, %39, !dbg !129
  %48 = getelementptr float, ptr @__constant_64xf32, i64 %47, !dbg !135
  %49 = load <1 x float>, ptr %48, align 4, !dbg !135
  br label %50, !dbg !129

50:                                               ; preds = %133, %46
  %51 = phi i64 [ %134, %133 ], [ 0, %46 ], !dbg !129
  %52 = icmp slt i64 %51, 32, !dbg !129
  br i1 %52, label %53, label %135, !dbg !129

53:                                               ; preds = %111, %50
  %54 = phi i64 [ %132, %111 ], [ 0, %50 ], !dbg !129
  %55 = icmp slt i64 %54, 32, !dbg !129
  br i1 %55, label %56, label %133, !dbg !129

56:                                               ; preds = %53
  %57 = add i64 %54, %41, !dbg !129
  br label %58, !dbg !129

58:                                               ; preds = %61, %56
  %59 = phi i64 [ %66, %61 ], [ 0, %56 ], !dbg !129
  %60 = icmp slt i64 %59, 4, !dbg !129
  br i1 %60, label %61, label %67, !dbg !129

61:                                               ; preds = %58
  %62 = add nuw nsw i64 0, %59, !dbg !129
  %63 = getelementptr inbounds nuw float, ptr %5, i64 %62, !dbg !129
  %64 = load float, ptr %63, align 4, !dbg !129
  %65 = getelementptr inbounds nuw float, ptr %4, i64 %62, !dbg !129
  store float %64, ptr %65, align 4, !dbg !129
  %66 = add i64 %59, 1, !dbg !129
  br label %58, !dbg !129

67:                                               ; preds = %109, %58
  %68 = phi i64 [ %110, %109 ], [ 0, %58 ], !dbg !129
  %69 = icmp slt i64 %68, 32, !dbg !129
  br i1 %69, label %70, label %111, !dbg !129

70:                                               ; preds = %107, %67
  %71 = phi i64 [ %108, %107 ], [ 0, %67 ], !dbg !129
  %72 = icmp slt i64 %71, 3, !dbg !129
  br i1 %72, label %73, label %109, !dbg !129

73:                                               ; preds = %70
  %74 = add i64 %71, %51, !dbg !129
  %75 = add i64 %74, %40, !dbg !129
  br label %76, !dbg !129

76:                                               ; preds = %105, %73
  %77 = phi i64 [ %106, %105 ], [ 0, %73 ], !dbg !129
  %78 = icmp slt i64 %77, 4, !dbg !129
  br i1 %78, label %79, label %107, !dbg !129

79:                                               ; preds = %82, %76
  %80 = phi i64 [ %104, %82 ], [ 0, %76 ], !dbg !129
  %81 = icmp slt i64 %80, 3, !dbg !129
  br i1 %81, label %82, label %105, !dbg !129

82:                                               ; preds = %79
  %83 = add i64 %57, %77, !dbg !129
  %84 = add i64 %83, %80, !dbg !129
  %85 = mul nuw nsw i64 %68, 51076, !dbg !129
  %86 = mul nuw nsw i64 %75, 226, !dbg !129
  %87 = add nuw nsw i64 %85, %86, !dbg !129
  %88 = add nuw nsw i64 %87, %84, !dbg !129
  %89 = getelementptr inbounds nuw float, ptr %9, i64 %88, !dbg !129
  %90 = load float, ptr %89, align 4, !dbg !129
  %91 = mul nuw nsw i64 %47, 288, !dbg !129
  %92 = mul nuw nsw i64 %68, 9, !dbg !129
  %93 = add nuw nsw i64 %91, %92, !dbg !129
  %94 = mul nuw nsw i64 %71, 3, !dbg !129
  %95 = add nuw nsw i64 %93, %94, !dbg !129
  %96 = add nuw nsw i64 %95, %80, !dbg !129
  %97 = getelementptr inbounds nuw float, ptr %14, i64 %96, !dbg !129
  %98 = load float, ptr %97, align 4, !dbg !129
  %99 = add nuw nsw i64 0, %77, !dbg !129
  %100 = getelementptr inbounds nuw float, ptr %4, i64 %99, !dbg !129
  %101 = load float, ptr %100, align 4, !dbg !129
  %102 = fmul contract float %90, %98, !dbg !136
  %103 = fadd contract float %101, %102, !dbg !137
  store float %103, ptr %100, align 4, !dbg !129
  %104 = add i64 %80, 1, !dbg !129
  br label %79, !dbg !129

105:                                              ; preds = %79
  %106 = add i64 %77, 1, !dbg !129
  br label %76, !dbg !129

107:                                              ; preds = %76
  %108 = add i64 %71, 1, !dbg !129
  br label %70, !dbg !129

109:                                              ; preds = %70
  %110 = add i64 %68, 1, !dbg !129
  br label %67, !dbg !129

111:                                              ; preds = %67
  %112 = getelementptr float, ptr %4, i64 0, !dbg !135
  %113 = load <4 x float>, ptr %112, align 4, !dbg !135
  %114 = extractelement <1 x float> %49, i64 0, !dbg !138
  %115 = insertelement <4 x float> poison, float %114, i32 0, !dbg !138
  %116 = shufflevector <4 x float> %115, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !138
  %117 = fadd contract <4 x float> %113, %116, !dbg !138
  %118 = fcmp olt <4 x float> zeroinitializer, %117, !dbg !139
  %119 = select <4 x i1> %118, <4 x float> zeroinitializer, <4 x float> %117, !dbg !140
  %120 = fmul contract <4 x float> %119, splat (float 0x3FC99999A0000000), !dbg !141
  %121 = fcmp ogt <4 x float> zeroinitializer, %117, !dbg !142
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %117, !dbg !143
  %123 = fadd contract <4 x float> %122, %120, !dbg !144
  %124 = add i64 %40, %51, !dbg !129
  %125 = add i64 %124, 1, !dbg !129
  %126 = add i64 %57, 1, !dbg !129
  %127 = mul i64 %47, 51076, !dbg !129
  %128 = mul i64 %125, 226, !dbg !129
  %129 = add i64 %127, %128, !dbg !129
  %130 = add i64 %129, %126, !dbg !129
  %131 = getelementptr float, ptr %19, i64 %130, !dbg !129
  store <4 x float> %123, ptr %131, align 4, !dbg !129
  %132 = add i64 %54, 4, !dbg !129
  br label %53, !dbg !129

133:                                              ; preds = %53
  %134 = add i64 %51, 1, !dbg !129
  br label %50, !dbg !129

135:                                              ; preds = %50
  %136 = add i64 %44, 1, !dbg !129
  br label %43, !dbg !129

137:                                              ; preds = %43
  ret i32 0, !dbg !145
}

define internal i32 @infer_dispatch_3_conv_128x224x224x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !146 {
  %4 = alloca float, i64 4, align 64, !dbg !147
  %5 = alloca float, i64 4, align 64, !dbg !148
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !149
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !149
  %8 = load ptr, ptr %7, align 8, !dbg !149
  %9 = getelementptr float, ptr %8, i64 3240064, !dbg !149
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !149
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !150
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !150
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !150
  %13 = load ptr, ptr %12, align 8, !dbg !150
  %14 = getelementptr float, ptr %13, i64 959328, !dbg !150
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !150
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !151
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !151
  %17 = getelementptr ptr, ptr %16, i32 1, !dbg !151
  %18 = load ptr, ptr %17, align 8, !dbg !151
  %19 = getelementptr float, ptr %18, i64 1033056, !dbg !151
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !151
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !152
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !152
  %22 = getelementptr ptr, ptr %21, i32 2, !dbg !152
  %23 = load ptr, ptr %22, align 8, !dbg !152
  %24 = getelementptr float, ptr %23, i64 6508928, !dbg !152
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !152
  %25 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !147
  %26 = extractvalue %iree_hal_executable_workgroup_state_v0_t %25, 0, !dbg !147
  %27 = zext i32 %26 to i64, !dbg !147
  %28 = sdiv i64 %27, 49, !dbg !147
  %29 = mul i64 %28, 49, !dbg !147
  %30 = icmp ne i64 %27, %29, !dbg !147
  %31 = icmp slt i64 %27, 0, !dbg !147
  %32 = and i1 %30, %31, !dbg !147
  %33 = add i64 %28, -1, !dbg !147
  %34 = select i1 %32, i64 %33, i64 %28, !dbg !147
  %35 = srem i64 %27, 49, !dbg !147
  %36 = icmp slt i64 %35, 0, !dbg !147
  %37 = add nsw i64 %35, 49, !dbg !147
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !147
  %39 = sdiv i64 %38, 7, !dbg !147
  %40 = srem i64 %27, 7, !dbg !147
  %41 = icmp slt i64 %40, 0, !dbg !147
  %42 = add nsw i64 %40, 7, !dbg !147
  %43 = select i1 %41, i64 %42, i64 %40, !dbg !147
  %44 = mul nsw i64 %34, 32, !dbg !147
  %45 = mul nsw i64 %39, 32, !dbg !147
  %46 = mul nsw i64 %43, 32, !dbg !147
  %47 = getelementptr float, ptr %5, i64 0, !dbg !153
  store <4 x float> zeroinitializer, ptr %47, align 4, !dbg !153
  br label %48, !dbg !147

48:                                               ; preds = %138, %3
  %49 = phi i64 [ %139, %138 ], [ 0, %3 ], !dbg !147
  %50 = icmp slt i64 %49, 32, !dbg !147
  br i1 %50, label %51, label %140, !dbg !147

51:                                               ; preds = %48
  %52 = add i64 %49, %44, !dbg !147
  %53 = getelementptr float, ptr %19, i64 %52, !dbg !154
  %54 = load <1 x float>, ptr %53, align 4, !dbg !154
  br label %55, !dbg !147

55:                                               ; preds = %136, %51
  %56 = phi i64 [ %137, %136 ], [ 0, %51 ], !dbg !147
  %57 = icmp slt i64 %56, 32, !dbg !147
  br i1 %57, label %58, label %138, !dbg !147

58:                                               ; preds = %116, %55
  %59 = phi i64 [ %135, %116 ], [ 0, %55 ], !dbg !147
  %60 = icmp slt i64 %59, 32, !dbg !147
  br i1 %60, label %61, label %136, !dbg !147

61:                                               ; preds = %58
  %62 = add i64 %59, %46, !dbg !147
  br label %63, !dbg !147

63:                                               ; preds = %66, %61
  %64 = phi i64 [ %71, %66 ], [ 0, %61 ], !dbg !147
  %65 = icmp slt i64 %64, 4, !dbg !147
  br i1 %65, label %66, label %72, !dbg !147

66:                                               ; preds = %63
  %67 = add nuw nsw i64 0, %64, !dbg !147
  %68 = getelementptr inbounds nuw float, ptr %5, i64 %67, !dbg !147
  %69 = load float, ptr %68, align 4, !dbg !147
  %70 = getelementptr inbounds nuw float, ptr %4, i64 %67, !dbg !147
  store float %69, ptr %70, align 4, !dbg !147
  %71 = add i64 %64, 1, !dbg !147
  br label %63, !dbg !147

72:                                               ; preds = %114, %63
  %73 = phi i64 [ %115, %114 ], [ 0, %63 ], !dbg !147
  %74 = icmp slt i64 %73, 64, !dbg !147
  br i1 %74, label %75, label %116, !dbg !147

75:                                               ; preds = %112, %72
  %76 = phi i64 [ %113, %112 ], [ 0, %72 ], !dbg !147
  %77 = icmp slt i64 %76, 3, !dbg !147
  br i1 %77, label %78, label %114, !dbg !147

78:                                               ; preds = %75
  %79 = add i64 %76, %56, !dbg !147
  %80 = add i64 %79, %45, !dbg !147
  br label %81, !dbg !147

81:                                               ; preds = %110, %78
  %82 = phi i64 [ %111, %110 ], [ 0, %78 ], !dbg !147
  %83 = icmp slt i64 %82, 4, !dbg !147
  br i1 %83, label %84, label %112, !dbg !147

84:                                               ; preds = %87, %81
  %85 = phi i64 [ %109, %87 ], [ 0, %81 ], !dbg !147
  %86 = icmp slt i64 %85, 3, !dbg !147
  br i1 %86, label %87, label %110, !dbg !147

87:                                               ; preds = %84
  %88 = add i64 %62, %82, !dbg !147
  %89 = add i64 %88, %85, !dbg !147
  %90 = mul nuw nsw i64 %73, 51076, !dbg !147
  %91 = mul nuw nsw i64 %80, 226, !dbg !147
  %92 = add nuw nsw i64 %90, %91, !dbg !147
  %93 = add nuw nsw i64 %92, %89, !dbg !147
  %94 = getelementptr inbounds nuw float, ptr %9, i64 %93, !dbg !147
  %95 = load float, ptr %94, align 4, !dbg !147
  %96 = mul nuw nsw i64 %52, 576, !dbg !147
  %97 = mul nuw nsw i64 %73, 9, !dbg !147
  %98 = add nuw nsw i64 %96, %97, !dbg !147
  %99 = mul nuw nsw i64 %76, 3, !dbg !147
  %100 = add nuw nsw i64 %98, %99, !dbg !147
  %101 = add nuw nsw i64 %100, %85, !dbg !147
  %102 = getelementptr inbounds nuw float, ptr %14, i64 %101, !dbg !147
  %103 = load float, ptr %102, align 4, !dbg !147
  %104 = add nuw nsw i64 0, %82, !dbg !147
  %105 = getelementptr inbounds nuw float, ptr %4, i64 %104, !dbg !147
  %106 = load float, ptr %105, align 4, !dbg !147
  %107 = fmul contract float %95, %103, !dbg !155
  %108 = fadd contract float %106, %107, !dbg !156
  store float %108, ptr %105, align 4, !dbg !147
  %109 = add i64 %85, 1, !dbg !147
  br label %84, !dbg !147

110:                                              ; preds = %84
  %111 = add i64 %82, 1, !dbg !147
  br label %81, !dbg !147

112:                                              ; preds = %81
  %113 = add i64 %76, 1, !dbg !147
  br label %75, !dbg !147

114:                                              ; preds = %75
  %115 = add i64 %73, 1, !dbg !147
  br label %72, !dbg !147

116:                                              ; preds = %72
  %117 = getelementptr float, ptr %4, i64 0, !dbg !154
  %118 = load <4 x float>, ptr %117, align 4, !dbg !154
  %119 = extractelement <1 x float> %54, i64 0, !dbg !157
  %120 = insertelement <4 x float> poison, float %119, i32 0, !dbg !157
  %121 = shufflevector <4 x float> %120, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !157
  %122 = fadd contract <4 x float> %118, %121, !dbg !157
  %123 = fcmp olt <4 x float> zeroinitializer, %122, !dbg !158
  %124 = select <4 x i1> %123, <4 x float> zeroinitializer, <4 x float> %122, !dbg !159
  %125 = fmul contract <4 x float> %124, splat (float 0x3FC99999A0000000), !dbg !160
  %126 = fcmp ogt <4 x float> zeroinitializer, %122, !dbg !161
  %127 = select <4 x i1> %126, <4 x float> zeroinitializer, <4 x float> %122, !dbg !162
  %128 = fadd contract <4 x float> %127, %125, !dbg !163
  %129 = add i64 %45, %56, !dbg !147
  %130 = mul i64 %52, 50176, !dbg !147
  %131 = mul i64 %129, 224, !dbg !147
  %132 = add i64 %130, %131, !dbg !147
  %133 = add i64 %132, %62, !dbg !147
  %134 = getelementptr float, ptr %24, i64 %133, !dbg !147
  store <4 x float> %128, ptr %134, align 4, !dbg !147
  %135 = add i64 %59, 4, !dbg !147
  br label %58, !dbg !147

136:                                              ; preds = %58
  %137 = add i64 %56, 1, !dbg !147
  br label %55, !dbg !147

138:                                              ; preds = %55
  %139 = add i64 %49, 1, !dbg !147
  br label %48, !dbg !147

140:                                              ; preds = %48
  ret i32 0, !dbg !164
}

define internal i32 @infer_dispatch_4_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !165 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !166
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !166
  %6 = load i32, ptr %5, align 4, !dbg !166
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !167
  %8 = load i32, ptr %7, align 4, !dbg !167
  %9 = zext i32 %6 to i64, !dbg !168
  %10 = zext i32 %8 to i64, !dbg !169
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !170
  %12 = load ptr, ptr %11, align 8, !dbg !170
  %13 = mul i64 %9, 8, !dbg !170
  %14 = udiv i64 %13, 32, !dbg !170
  %15 = getelementptr float, ptr %12, i64 %14, !dbg !171
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !171
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !172
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !172
  %18 = getelementptr ptr, ptr %17, i32 1, !dbg !172
  %19 = load ptr, ptr %18, align 8, !dbg !172
  %20 = mul i64 %10, 8, !dbg !172
  %21 = udiv i64 %20, 32, !dbg !172
  %22 = getelementptr float, ptr %19, i64 %21, !dbg !173
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !173
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !174
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !174
  %25 = zext i32 %24 to i64, !dbg !174
  %26 = sdiv i64 %25, 16, !dbg !174
  %27 = mul i64 %26, 16, !dbg !174
  %28 = icmp ne i64 %25, %27, !dbg !174
  %29 = icmp slt i64 %25, 0, !dbg !174
  %30 = and i1 %28, %29, !dbg !174
  %31 = add i64 %26, -1, !dbg !174
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !174
  %33 = srem i64 %25, 16, !dbg !174
  %34 = icmp slt i64 %33, 0, !dbg !174
  %35 = add nsw i64 %33, 16, !dbg !174
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !174
  %37 = sdiv i64 %36, 4, !dbg !174
  %38 = srem i64 %25, 4, !dbg !174
  %39 = icmp slt i64 %38, 0, !dbg !174
  %40 = add nsw i64 %38, 4, !dbg !174
  %41 = select i1 %39, i64 %40, i64 %38, !dbg !174
  %42 = mul nsw i64 %32, 64, !dbg !174
  %43 = mul nsw i64 %37, 56, !dbg !174
  %44 = mul nsw i64 %41, 56, !dbg !174
  br label %45, !dbg !174

45:                                               ; preds = %74, %3
  %46 = phi i64 [ %75, %74 ], [ 0, %3 ], !dbg !174
  %47 = icmp slt i64 %46, 64, !dbg !174
  br i1 %47, label %48, label %76, !dbg !174

48:                                               ; preds = %72, %45
  %49 = phi i64 [ %73, %72 ], [ 0, %45 ], !dbg !174
  %50 = icmp slt i64 %49, 56, !dbg !174
  br i1 %50, label %51, label %74, !dbg !174

51:                                               ; preds = %54, %48
  %52 = phi i64 [ %71, %54 ], [ 0, %48 ], !dbg !174
  %53 = icmp slt i64 %52, 56, !dbg !174
  br i1 %53, label %54, label %72, !dbg !174

54:                                               ; preds = %51
  %55 = add i64 %42, %46, !dbg !174
  %56 = add i64 %43, %49, !dbg !174
  %57 = add i64 %44, %52, !dbg !174
  %58 = mul i64 %55, 50176, !dbg !174
  %59 = mul i64 %56, 224, !dbg !174
  %60 = add i64 %58, %59, !dbg !174
  %61 = add i64 %60, %57, !dbg !174
  %62 = getelementptr float, ptr %15, i64 %61, !dbg !174
  %63 = load <4 x float>, ptr %62, align 4, !dbg !174
  %64 = add i64 %56, 1, !dbg !174
  %65 = add i64 %57, 1, !dbg !174
  %66 = mul i64 %55, 51076, !dbg !174
  %67 = mul i64 %64, 226, !dbg !174
  %68 = add i64 %66, %67, !dbg !174
  %69 = add i64 %68, %65, !dbg !174
  %70 = getelementptr float, ptr %22, i64 %69, !dbg !174
  store <4 x float> %63, ptr %70, align 4, !dbg !174
  %71 = add i64 %52, 4, !dbg !174
  br label %51, !dbg !174

72:                                               ; preds = %51
  %73 = add i64 %49, 1, !dbg !174
  br label %48, !dbg !174

74:                                               ; preds = %48
  %75 = add i64 %46, 1, !dbg !174
  br label %45, !dbg !174

76:                                               ; preds = %45
  ret i32 0, !dbg !175
}

define internal i32 @infer_dispatch_5_conv_128x224x224x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !176 {
  %4 = alloca float, i64 4, align 64, !dbg !177
  %5 = alloca float, i64 4, align 64, !dbg !178
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !179
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 9, !dbg !179
  %8 = load i32, ptr %7, align 4, !dbg !179
  %9 = getelementptr i32, ptr %7, i32 1, !dbg !180
  %10 = load i32, ptr %9, align 4, !dbg !180
  %11 = getelementptr i32, ptr %7, i32 2, !dbg !181
  %12 = load i32, ptr %11, align 4, !dbg !181
  %13 = getelementptr i32, ptr %7, i32 3, !dbg !182
  %14 = load i32, ptr %13, align 4, !dbg !182
  %15 = zext i32 %8 to i64, !dbg !183
  %16 = zext i32 %10 to i64, !dbg !184
  %17 = zext i32 %12 to i64, !dbg !185
  %18 = zext i32 %14 to i64, !dbg !186
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !187
  %20 = load ptr, ptr %19, align 8, !dbg !187
  %21 = mul i64 %15, 8, !dbg !187
  %22 = udiv i64 %21, 32, !dbg !187
  %23 = getelementptr float, ptr %20, i64 %22, !dbg !187
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !187
  %24 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !188
  %25 = extractvalue %iree_hal_executable_dispatch_state_v0_t %24, 10, !dbg !188
  %26 = getelementptr ptr, ptr %25, i32 1, !dbg !188
  %27 = load ptr, ptr %26, align 8, !dbg !188
  %28 = mul i64 %16, 8, !dbg !188
  %29 = udiv i64 %28, 32, !dbg !188
  %30 = getelementptr float, ptr %27, i64 %29, !dbg !188
  call void @llvm.assume(i1 true) [ "align"(ptr %30, i64 64) ], !dbg !188
  %31 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !189
  %32 = extractvalue %iree_hal_executable_dispatch_state_v0_t %31, 10, !dbg !189
  %33 = getelementptr ptr, ptr %32, i32 1, !dbg !189
  %34 = load ptr, ptr %33, align 8, !dbg !189
  %35 = mul i64 %17, 8, !dbg !189
  %36 = udiv i64 %35, 32, !dbg !189
  %37 = getelementptr float, ptr %34, i64 %36, !dbg !189
  call void @llvm.assume(i1 true) [ "align"(ptr %37, i64 64) ], !dbg !189
  %38 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !190
  %39 = extractvalue %iree_hal_executable_dispatch_state_v0_t %38, 10, !dbg !190
  %40 = getelementptr ptr, ptr %39, i32 2, !dbg !190
  %41 = load ptr, ptr %40, align 8, !dbg !190
  %42 = mul i64 %18, 8, !dbg !190
  %43 = udiv i64 %42, 32, !dbg !190
  %44 = getelementptr float, ptr %41, i64 %43, !dbg !190
  call void @llvm.assume(i1 true) [ "align"(ptr %44, i64 64) ], !dbg !190
  %45 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !177
  %46 = extractvalue %iree_hal_executable_workgroup_state_v0_t %45, 0, !dbg !177
  %47 = zext i32 %46 to i64, !dbg !177
  %48 = sdiv i64 %47, 49, !dbg !177
  %49 = mul i64 %48, 49, !dbg !177
  %50 = icmp ne i64 %47, %49, !dbg !177
  %51 = icmp slt i64 %47, 0, !dbg !177
  %52 = and i1 %50, %51, !dbg !177
  %53 = add i64 %48, -1, !dbg !177
  %54 = select i1 %52, i64 %53, i64 %48, !dbg !177
  %55 = srem i64 %47, 49, !dbg !177
  %56 = icmp slt i64 %55, 0, !dbg !177
  %57 = add nsw i64 %55, 49, !dbg !177
  %58 = select i1 %56, i64 %57, i64 %55, !dbg !177
  %59 = sdiv i64 %58, 7, !dbg !177
  %60 = srem i64 %47, 7, !dbg !177
  %61 = icmp slt i64 %60, 0, !dbg !177
  %62 = add nsw i64 %60, 7, !dbg !177
  %63 = select i1 %61, i64 %62, i64 %60, !dbg !177
  %64 = mul nsw i64 %54, 32, !dbg !177
  %65 = mul nsw i64 %59, 32, !dbg !177
  %66 = mul nsw i64 %63, 32, !dbg !177
  %67 = getelementptr float, ptr %5, i64 0, !dbg !191
  store <4 x float> zeroinitializer, ptr %67, align 4, !dbg !191
  br label %68, !dbg !177

68:                                               ; preds = %160, %3
  %69 = phi i64 [ %161, %160 ], [ 0, %3 ], !dbg !177
  %70 = icmp slt i64 %69, 32, !dbg !177
  br i1 %70, label %71, label %162, !dbg !177

71:                                               ; preds = %68
  %72 = add i64 %69, %64, !dbg !177
  %73 = getelementptr float, ptr %37, i64 %72, !dbg !192
  %74 = load <1 x float>, ptr %73, align 4, !dbg !192
  br label %75, !dbg !177

75:                                               ; preds = %158, %71
  %76 = phi i64 [ %159, %158 ], [ 0, %71 ], !dbg !177
  %77 = icmp slt i64 %76, 32, !dbg !177
  br i1 %77, label %78, label %160, !dbg !177

78:                                               ; preds = %136, %75
  %79 = phi i64 [ %157, %136 ], [ 0, %75 ], !dbg !177
  %80 = icmp slt i64 %79, 32, !dbg !177
  br i1 %80, label %81, label %158, !dbg !177

81:                                               ; preds = %78
  %82 = add i64 %79, %66, !dbg !177
  br label %83, !dbg !177

83:                                               ; preds = %86, %81
  %84 = phi i64 [ %91, %86 ], [ 0, %81 ], !dbg !177
  %85 = icmp slt i64 %84, 4, !dbg !177
  br i1 %85, label %86, label %92, !dbg !177

86:                                               ; preds = %83
  %87 = add nuw nsw i64 0, %84, !dbg !177
  %88 = getelementptr inbounds nuw float, ptr %5, i64 %87, !dbg !177
  %89 = load float, ptr %88, align 4, !dbg !177
  %90 = getelementptr inbounds nuw float, ptr %4, i64 %87, !dbg !177
  store float %89, ptr %90, align 4, !dbg !177
  %91 = add i64 %84, 1, !dbg !177
  br label %83, !dbg !177

92:                                               ; preds = %134, %83
  %93 = phi i64 [ %135, %134 ], [ 0, %83 ], !dbg !177
  %94 = icmp slt i64 %93, 128, !dbg !177
  br i1 %94, label %95, label %136, !dbg !177

95:                                               ; preds = %132, %92
  %96 = phi i64 [ %133, %132 ], [ 0, %92 ], !dbg !177
  %97 = icmp slt i64 %96, 3, !dbg !177
  br i1 %97, label %98, label %134, !dbg !177

98:                                               ; preds = %95
  %99 = add i64 %96, %76, !dbg !177
  %100 = add i64 %99, %65, !dbg !177
  br label %101, !dbg !177

101:                                              ; preds = %130, %98
  %102 = phi i64 [ %131, %130 ], [ 0, %98 ], !dbg !177
  %103 = icmp slt i64 %102, 4, !dbg !177
  br i1 %103, label %104, label %132, !dbg !177

104:                                              ; preds = %107, %101
  %105 = phi i64 [ %129, %107 ], [ 0, %101 ], !dbg !177
  %106 = icmp slt i64 %105, 3, !dbg !177
  br i1 %106, label %107, label %130, !dbg !177

107:                                              ; preds = %104
  %108 = add i64 %82, %102, !dbg !177
  %109 = add i64 %108, %105, !dbg !177
  %110 = mul nuw nsw i64 %93, 51076, !dbg !177
  %111 = mul nuw nsw i64 %100, 226, !dbg !177
  %112 = add nuw nsw i64 %110, %111, !dbg !177
  %113 = add nuw nsw i64 %112, %109, !dbg !177
  %114 = getelementptr inbounds nuw float, ptr %23, i64 %113, !dbg !177
  %115 = load float, ptr %114, align 4, !dbg !177
  %116 = mul nuw nsw i64 %72, 1152, !dbg !177
  %117 = mul nuw nsw i64 %93, 9, !dbg !177
  %118 = add nuw nsw i64 %116, %117, !dbg !177
  %119 = mul nuw nsw i64 %96, 3, !dbg !177
  %120 = add nuw nsw i64 %118, %119, !dbg !177
  %121 = add nuw nsw i64 %120, %105, !dbg !177
  %122 = getelementptr inbounds nuw float, ptr %30, i64 %121, !dbg !177
  %123 = load float, ptr %122, align 4, !dbg !177
  %124 = add nuw nsw i64 0, %102, !dbg !177
  %125 = getelementptr inbounds nuw float, ptr %4, i64 %124, !dbg !177
  %126 = load float, ptr %125, align 4, !dbg !177
  %127 = fmul contract float %115, %123, !dbg !193
  %128 = fadd contract float %126, %127, !dbg !194
  store float %128, ptr %125, align 4, !dbg !177
  %129 = add i64 %105, 1, !dbg !177
  br label %104, !dbg !177

130:                                              ; preds = %104
  %131 = add i64 %102, 1, !dbg !177
  br label %101, !dbg !177

132:                                              ; preds = %101
  %133 = add i64 %96, 1, !dbg !177
  br label %95, !dbg !177

134:                                              ; preds = %95
  %135 = add i64 %93, 1, !dbg !177
  br label %92, !dbg !177

136:                                              ; preds = %92
  %137 = getelementptr float, ptr %4, i64 0, !dbg !192
  %138 = load <4 x float>, ptr %137, align 4, !dbg !192
  %139 = extractelement <1 x float> %74, i64 0, !dbg !195
  %140 = insertelement <4 x float> poison, float %139, i32 0, !dbg !195
  %141 = shufflevector <4 x float> %140, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !195
  %142 = fadd contract <4 x float> %138, %141, !dbg !195
  %143 = fcmp olt <4 x float> zeroinitializer, %142, !dbg !196
  %144 = select <4 x i1> %143, <4 x float> zeroinitializer, <4 x float> %142, !dbg !197
  %145 = fmul contract <4 x float> %144, splat (float 0x3FC99999A0000000), !dbg !198
  %146 = fcmp ogt <4 x float> zeroinitializer, %142, !dbg !199
  %147 = select <4 x i1> %146, <4 x float> zeroinitializer, <4 x float> %142, !dbg !200
  %148 = fadd contract <4 x float> %147, %145, !dbg !201
  %149 = add i64 %65, %76, !dbg !177
  %150 = add i64 %149, 1, !dbg !177
  %151 = add i64 %82, 1, !dbg !177
  %152 = mul i64 %72, 51076, !dbg !177
  %153 = mul i64 %150, 226, !dbg !177
  %154 = add i64 %152, %153, !dbg !177
  %155 = add i64 %154, %151, !dbg !177
  %156 = getelementptr float, ptr %44, i64 %155, !dbg !177
  store <4 x float> %148, ptr %156, align 4, !dbg !177
  %157 = add i64 %79, 4, !dbg !177
  br label %78, !dbg !177

158:                                              ; preds = %78
  %159 = add i64 %76, 1, !dbg !177
  br label %75, !dbg !177

160:                                              ; preds = %75
  %161 = add i64 %69, 1, !dbg !177
  br label %68, !dbg !177

162:                                              ; preds = %68
  ret i32 0, !dbg !202
}

define internal i32 @infer_dispatch_6_conv_128x224x224x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !203 {
  %4 = alloca float, i64 4, align 64, !dbg !204
  %5 = alloca float, i64 4, align 64, !dbg !205
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !206
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 9, !dbg !206
  %8 = load i32, ptr %7, align 4, !dbg !206
  %9 = getelementptr i32, ptr %7, i32 1, !dbg !207
  %10 = load i32, ptr %9, align 4, !dbg !207
  %11 = getelementptr i32, ptr %7, i32 2, !dbg !208
  %12 = load i32, ptr %11, align 4, !dbg !208
  %13 = getelementptr i32, ptr %7, i32 3, !dbg !209
  %14 = load i32, ptr %13, align 4, !dbg !209
  %15 = getelementptr i32, ptr %7, i32 4, !dbg !210
  %16 = load i32, ptr %15, align 4, !dbg !210
  %17 = zext i32 %8 to i64, !dbg !211
  %18 = zext i32 %10 to i64, !dbg !212
  %19 = zext i32 %12 to i64, !dbg !213
  %20 = zext i32 %14 to i64, !dbg !214
  %21 = zext i32 %16 to i64, !dbg !215
  %22 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !216
  %23 = load ptr, ptr %22, align 8, !dbg !216
  %24 = mul i64 %17, 8, !dbg !216
  %25 = udiv i64 %24, 32, !dbg !216
  %26 = getelementptr float, ptr %23, i64 %25, !dbg !216
  call void @llvm.assume(i1 true) [ "align"(ptr %26, i64 64) ], !dbg !216
  %27 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !217
  %28 = extractvalue %iree_hal_executable_dispatch_state_v0_t %27, 10, !dbg !217
  %29 = getelementptr ptr, ptr %28, i32 1, !dbg !217
  %30 = load ptr, ptr %29, align 8, !dbg !217
  %31 = mul i64 %19, 8, !dbg !217
  %32 = udiv i64 %31, 32, !dbg !217
  %33 = getelementptr float, ptr %30, i64 %32, !dbg !217
  call void @llvm.assume(i1 true) [ "align"(ptr %33, i64 64) ], !dbg !217
  %34 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !218
  %35 = extractvalue %iree_hal_executable_dispatch_state_v0_t %34, 10, !dbg !218
  %36 = load ptr, ptr %35, align 8, !dbg !218
  %37 = mul i64 %18, 8, !dbg !218
  %38 = udiv i64 %37, 32, !dbg !218
  %39 = getelementptr float, ptr %36, i64 %38, !dbg !218
  call void @llvm.assume(i1 true) [ "align"(ptr %39, i64 64) ], !dbg !218
  %40 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !219
  %41 = extractvalue %iree_hal_executable_dispatch_state_v0_t %40, 10, !dbg !219
  %42 = getelementptr ptr, ptr %41, i32 1, !dbg !219
  %43 = load ptr, ptr %42, align 8, !dbg !219
  %44 = mul i64 %20, 8, !dbg !219
  %45 = udiv i64 %44, 32, !dbg !219
  %46 = getelementptr float, ptr %43, i64 %45, !dbg !219
  call void @llvm.assume(i1 true) [ "align"(ptr %46, i64 64) ], !dbg !219
  %47 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !220
  %48 = extractvalue %iree_hal_executable_dispatch_state_v0_t %47, 10, !dbg !220
  %49 = getelementptr ptr, ptr %48, i32 2, !dbg !220
  %50 = load ptr, ptr %49, align 8, !dbg !220
  %51 = mul i64 %21, 8, !dbg !220
  %52 = udiv i64 %51, 32, !dbg !220
  %53 = getelementptr float, ptr %50, i64 %52, !dbg !220
  call void @llvm.assume(i1 true) [ "align"(ptr %53, i64 64) ], !dbg !220
  %54 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !204
  %55 = extractvalue %iree_hal_executable_workgroup_state_v0_t %54, 0, !dbg !204
  %56 = zext i32 %55 to i64, !dbg !204
  %57 = sdiv i64 %56, 49, !dbg !204
  %58 = mul i64 %57, 49, !dbg !204
  %59 = icmp ne i64 %56, %58, !dbg !204
  %60 = icmp slt i64 %56, 0, !dbg !204
  %61 = and i1 %59, %60, !dbg !204
  %62 = add i64 %57, -1, !dbg !204
  %63 = select i1 %61, i64 %62, i64 %57, !dbg !204
  %64 = srem i64 %56, 49, !dbg !204
  %65 = icmp slt i64 %64, 0, !dbg !204
  %66 = add nsw i64 %64, 49, !dbg !204
  %67 = select i1 %65, i64 %66, i64 %64, !dbg !204
  %68 = sdiv i64 %67, 7, !dbg !204
  %69 = srem i64 %56, 7, !dbg !204
  %70 = icmp slt i64 %69, 0, !dbg !204
  %71 = add nsw i64 %69, 7, !dbg !204
  %72 = select i1 %70, i64 %71, i64 %69, !dbg !204
  %73 = mul nsw i64 %63, 32, !dbg !204
  %74 = mul nsw i64 %68, 32, !dbg !204
  %75 = mul nsw i64 %72, 32, !dbg !204
  %76 = getelementptr float, ptr %5, i64 0, !dbg !221
  store <4 x float> zeroinitializer, ptr %76, align 4, !dbg !221
  br label %77, !dbg !204

77:                                               ; preds = %170, %3
  %78 = phi i64 [ %171, %170 ], [ 0, %3 ], !dbg !204
  %79 = icmp slt i64 %78, 32, !dbg !204
  br i1 %79, label %80, label %172, !dbg !204

80:                                               ; preds = %77
  %81 = add i64 %78, %73, !dbg !204
  %82 = getelementptr float, ptr %46, i64 %81, !dbg !222
  %83 = load <1 x float>, ptr %82, align 4, !dbg !222
  br label %84, !dbg !204

84:                                               ; preds = %168, %80
  %85 = phi i64 [ %169, %168 ], [ 0, %80 ], !dbg !204
  %86 = icmp slt i64 %85, 32, !dbg !204
  br i1 %86, label %87, label %170, !dbg !204

87:                                               ; preds = %145, %84
  %88 = phi i64 [ %167, %145 ], [ 0, %84 ], !dbg !204
  %89 = icmp slt i64 %88, 32, !dbg !204
  br i1 %89, label %90, label %168, !dbg !204

90:                                               ; preds = %87
  %91 = add i64 %88, %75, !dbg !204
  br label %92, !dbg !204

92:                                               ; preds = %95, %90
  %93 = phi i64 [ %100, %95 ], [ 0, %90 ], !dbg !204
  %94 = icmp slt i64 %93, 4, !dbg !204
  br i1 %94, label %95, label %101, !dbg !204

95:                                               ; preds = %92
  %96 = add nuw nsw i64 0, %93, !dbg !204
  %97 = getelementptr inbounds nuw float, ptr %5, i64 %96, !dbg !204
  %98 = load float, ptr %97, align 4, !dbg !204
  %99 = getelementptr inbounds nuw float, ptr %4, i64 %96, !dbg !204
  store float %98, ptr %99, align 4, !dbg !204
  %100 = add i64 %93, 1, !dbg !204
  br label %92, !dbg !204

101:                                              ; preds = %143, %92
  %102 = phi i64 [ %144, %143 ], [ 0, %92 ], !dbg !204
  %103 = icmp slt i64 %102, 128, !dbg !204
  br i1 %103, label %104, label %145, !dbg !204

104:                                              ; preds = %141, %101
  %105 = phi i64 [ %142, %141 ], [ 0, %101 ], !dbg !204
  %106 = icmp slt i64 %105, 3, !dbg !204
  br i1 %106, label %107, label %143, !dbg !204

107:                                              ; preds = %104
  %108 = add i64 %105, %85, !dbg !204
  %109 = add i64 %108, %74, !dbg !204
  br label %110, !dbg !204

110:                                              ; preds = %139, %107
  %111 = phi i64 [ %140, %139 ], [ 0, %107 ], !dbg !204
  %112 = icmp slt i64 %111, 4, !dbg !204
  br i1 %112, label %113, label %141, !dbg !204

113:                                              ; preds = %116, %110
  %114 = phi i64 [ %138, %116 ], [ 0, %110 ], !dbg !204
  %115 = icmp slt i64 %114, 3, !dbg !204
  br i1 %115, label %116, label %139, !dbg !204

116:                                              ; preds = %113
  %117 = add i64 %91, %111, !dbg !204
  %118 = add i64 %117, %114, !dbg !204
  %119 = mul nuw nsw i64 %102, 51076, !dbg !204
  %120 = mul nuw nsw i64 %109, 226, !dbg !204
  %121 = add nuw nsw i64 %119, %120, !dbg !204
  %122 = add nuw nsw i64 %121, %118, !dbg !204
  %123 = getelementptr inbounds nuw float, ptr %26, i64 %122, !dbg !204
  %124 = load float, ptr %123, align 4, !dbg !204
  %125 = mul nuw nsw i64 %81, 1152, !dbg !204
  %126 = mul nuw nsw i64 %102, 9, !dbg !204
  %127 = add nuw nsw i64 %125, %126, !dbg !204
  %128 = mul nuw nsw i64 %105, 3, !dbg !204
  %129 = add nuw nsw i64 %127, %128, !dbg !204
  %130 = add nuw nsw i64 %129, %114, !dbg !204
  %131 = getelementptr inbounds nuw float, ptr %33, i64 %130, !dbg !204
  %132 = load float, ptr %131, align 4, !dbg !204
  %133 = add nuw nsw i64 0, %111, !dbg !204
  %134 = getelementptr inbounds nuw float, ptr %4, i64 %133, !dbg !204
  %135 = load float, ptr %134, align 4, !dbg !204
  %136 = fmul contract float %124, %132, !dbg !223
  %137 = fadd contract float %135, %136, !dbg !224
  store float %137, ptr %134, align 4, !dbg !204
  %138 = add i64 %114, 1, !dbg !204
  br label %113, !dbg !204

139:                                              ; preds = %113
  %140 = add i64 %111, 1, !dbg !204
  br label %110, !dbg !204

141:                                              ; preds = %110
  %142 = add i64 %105, 1, !dbg !204
  br label %104, !dbg !204

143:                                              ; preds = %104
  %144 = add i64 %102, 1, !dbg !204
  br label %101, !dbg !204

145:                                              ; preds = %101
  %146 = add i64 %85, %74, !dbg !222
  %147 = mul i64 %81, 50176, !dbg !222
  %148 = mul i64 %146, 224, !dbg !222
  %149 = add i64 %147, %148, !dbg !222
  %150 = add i64 %149, %91, !dbg !222
  %151 = getelementptr float, ptr %39, i64 %150, !dbg !222
  %152 = load <4 x float>, ptr %151, align 4, !dbg !222
  %153 = getelementptr float, ptr %4, i64 0, !dbg !222
  %154 = load <4 x float>, ptr %153, align 4, !dbg !222
  %155 = extractelement <1 x float> %83, i64 0, !dbg !225
  %156 = insertelement <4 x float> poison, float %155, i32 0, !dbg !225
  %157 = shufflevector <4 x float> %156, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !225
  %158 = fadd contract <4 x float> %154, %157, !dbg !225
  %159 = fcmp olt <4 x float> zeroinitializer, %158, !dbg !226
  %160 = select <4 x i1> %159, <4 x float> zeroinitializer, <4 x float> %158, !dbg !227
  %161 = fmul contract <4 x float> %160, splat (float 0x3FC99999A0000000), !dbg !228
  %162 = fcmp ogt <4 x float> zeroinitializer, %158, !dbg !229
  %163 = select <4 x i1> %162, <4 x float> zeroinitializer, <4 x float> %158, !dbg !230
  %164 = fadd contract <4 x float> %163, %161, !dbg !231
  %165 = fadd contract <4 x float> %152, %164, !dbg !232
  %166 = getelementptr float, ptr %53, i64 %150, !dbg !204
  store <4 x float> %165, ptr %166, align 4, !dbg !204
  %167 = add i64 %88, 4, !dbg !204
  br label %87, !dbg !204

168:                                              ; preds = %87
  %169 = add i64 %85, 1, !dbg !204
  br label %84, !dbg !204

170:                                              ; preds = %84
  %171 = add i64 %78, 1, !dbg !204
  br label %77, !dbg !204

172:                                              ; preds = %77
  ret i32 0, !dbg !233
}

define internal i32 @infer_dispatch_13_elementwise_broadcast_128x112x112_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !234 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !235
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !235
  %6 = load ptr, ptr %5, align 8, !dbg !235
  %7 = getelementptr float, ptr %6, i64 14565888, !dbg !235
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !235
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !236
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !236
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !236
  %11 = load ptr, ptr %10, align 8, !dbg !236
  %12 = getelementptr float, ptr %11, i64 20988416, !dbg !236
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !236
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !237
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !237
  %15 = zext i32 %14 to i64, !dbg !237
  %16 = sdiv i64 %15, 4, !dbg !237
  %17 = mul i64 %16, 4, !dbg !237
  %18 = icmp ne i64 %15, %17, !dbg !237
  %19 = icmp slt i64 %15, 0, !dbg !237
  %20 = and i1 %18, %19, !dbg !237
  %21 = add i64 %16, -1, !dbg !237
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !237
  %23 = srem i64 %15, 4, !dbg !237
  %24 = icmp slt i64 %23, 0, !dbg !237
  %25 = add nsw i64 %23, 4, !dbg !237
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !237
  %27 = sdiv i64 %26, 2, !dbg !237
  %28 = srem i64 %15, 2, !dbg !237
  %29 = icmp slt i64 %28, 0, !dbg !237
  %30 = add nsw i64 %28, 2, !dbg !237
  %31 = select i1 %29, i64 %30, i64 %28, !dbg !237
  %32 = mul nsw i64 %22, 32, !dbg !237
  %33 = mul nsw i64 %27, 56, !dbg !237
  %34 = mul nsw i64 %31, 56, !dbg !237
  br label %35, !dbg !237

35:                                               ; preds = %526, %3
  %36 = phi i64 [ %527, %526 ], [ 0, %3 ], !dbg !237
  %37 = icmp slt i64 %36, 32, !dbg !237
  br i1 %37, label %38, label %528, !dbg !237

38:                                               ; preds = %35
  %39 = add i64 %32, %36, !dbg !238
  %40 = mul i64 %39, 224, !dbg !239
  br label %41, !dbg !237

41:                                               ; preds = %524, %38
  %42 = phi i64 [ %525, %524 ], [ 0, %38 ], !dbg !237
  %43 = icmp slt i64 %42, 56, !dbg !237
  br i1 %43, label %44, label %526, !dbg !237

44:                                               ; preds = %41
  %45 = add i64 %33, %42, !dbg !240
  %46 = sitofp i64 %45 to float, !dbg !241
  %47 = fadd contract float %46, 5.000000e-01, !dbg !242
  %48 = fdiv float %47, 5.000000e-01, !dbg !243
  %49 = fsub contract float %48, 5.000000e-01, !dbg !244
  %50 = fcmp ugt float %49, 0.000000e+00, !dbg !245
  %51 = select i1 %50, float %49, float 0.000000e+00, !dbg !245
  %52 = fcmp ult float %51, 2.230000e+02, !dbg !246
  %53 = select i1 %52, float %51, float 2.230000e+02, !dbg !246
  %54 = call float @llvm.floor.f32(float %53), !dbg !247
  %55 = fadd contract float %53, 1.000000e+00, !dbg !248
  %56 = call float @llvm.floor.f32(float %55), !dbg !249
  %57 = fptosi float %54 to i64, !dbg !250
  %58 = fcmp ult float %55, 2.230000e+02, !dbg !251
  %59 = select i1 %58, float %55, float 2.230000e+02, !dbg !251
  %60 = fptosi float %59 to i64, !dbg !252
  %61 = add i64 %57, %40, !dbg !239
  %62 = mul i64 %61, 224, !dbg !239
  %63 = add i64 %60, %40, !dbg !253
  %64 = mul i64 %63, 224, !dbg !253
  %65 = fsub contract float %56, %53, !dbg !254
  %66 = fsub contract float %53, %54, !dbg !255
  br label %67, !dbg !237

67:                                               ; preds = %70, %44
  %68 = phi i64 [ %523, %70 ], [ 0, %44 ], !dbg !237
  %69 = icmp slt i64 %68, 56, !dbg !237
  br i1 %69, label %70, label %524, !dbg !237

70:                                               ; preds = %67
  %71 = add i64 %34, %68, !dbg !256
  %72 = insertelement <4 x i64> poison, i64 %71, i32 0, !dbg !237
  %73 = shufflevector <4 x i64> %72, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !237
  %74 = add <4 x i64> %73, <i64 0, i64 1, i64 2, i64 3>, !dbg !256
  %75 = sitofp <4 x i64> %74 to <4 x float>, !dbg !257
  %76 = fadd contract <4 x float> %75, splat (float 5.000000e-01), !dbg !258
  %77 = fdiv <4 x float> %76, splat (float 5.000000e-01), !dbg !259
  %78 = fsub contract <4 x float> %77, splat (float 5.000000e-01), !dbg !260
  %79 = fcmp ugt <4 x float> %78, zeroinitializer, !dbg !261
  %80 = select <4 x i1> %79, <4 x float> %78, <4 x float> zeroinitializer, !dbg !261
  %81 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %80, !dbg !261
  %82 = fcmp ult <4 x float> %81, splat (float 2.230000e+02), !dbg !262
  %83 = select <4 x i1> %82, <4 x float> %81, <4 x float> splat (float 2.230000e+02), !dbg !262
  %84 = select <4 x i1> zeroinitializer, <4 x float> splat (float 2.230000e+02), <4 x float> %83, !dbg !262
  %85 = call <4 x float> @llvm.floor.v4f32(<4 x float> %84), !dbg !263
  %86 = fadd contract <4 x float> %84, splat (float 1.000000e+00), !dbg !264
  %87 = call <4 x float> @llvm.floor.v4f32(<4 x float> %86), !dbg !265
  %88 = fptosi <4 x float> %85 to <4 x i64>, !dbg !266
  %89 = fcmp ult <4 x float> %86, splat (float 2.230000e+02), !dbg !267
  %90 = select <4 x i1> %89, <4 x float> %86, <4 x float> splat (float 2.230000e+02), !dbg !267
  %91 = select <4 x i1> zeroinitializer, <4 x float> splat (float 2.230000e+02), <4 x float> %90, !dbg !267
  %92 = fptosi <4 x float> %91 to <4 x i64>, !dbg !268
  %93 = insertelement <4 x i64> poison, i64 %62, i32 0, !dbg !239
  %94 = shufflevector <4 x i64> %93, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !239
  %95 = add <4 x i64> %88, %94, !dbg !239
  %96 = extractelement <4 x i64> %95, i64 0, !dbg !239
  %97 = sdiv i64 %96, 50176, !dbg !239
  %98 = mul i64 %97, 50176, !dbg !239
  %99 = icmp ne i64 %96, %98, !dbg !239
  %100 = icmp slt i64 %96, 0, !dbg !239
  %101 = and i1 %99, %100, !dbg !239
  %102 = add i64 %97, -1, !dbg !239
  %103 = select i1 %101, i64 %102, i64 %97, !dbg !239
  %104 = srem i64 %96, 50176, !dbg !239
  %105 = icmp slt i64 %104, 0, !dbg !239
  %106 = add nsw i64 %104, 50176, !dbg !239
  %107 = select i1 %105, i64 %106, i64 %104, !dbg !239
  %108 = sdiv i64 %107, 224, !dbg !239
  %109 = srem i64 %96, 224, !dbg !239
  %110 = icmp slt i64 %109, 0, !dbg !239
  %111 = add nsw i64 %109, 224, !dbg !239
  %112 = select i1 %110, i64 %111, i64 %109, !dbg !239
  %113 = mul i64 %103, 50176, !dbg !239
  %114 = mul i64 %108, 224, !dbg !239
  %115 = add i64 %113, %114, !dbg !239
  %116 = add i64 %115, %112, !dbg !239
  %117 = getelementptr float, ptr %7, i64 %116, !dbg !239
  %118 = load <1 x float>, ptr %117, align 4, !dbg !239
  %119 = extractelement <1 x float> %118, i64 0, !dbg !239
  %120 = extractelement <4 x i64> %95, i64 1, !dbg !239
  %121 = sdiv i64 %120, 50176, !dbg !239
  %122 = mul i64 %121, 50176, !dbg !239
  %123 = icmp ne i64 %120, %122, !dbg !239
  %124 = icmp slt i64 %120, 0, !dbg !239
  %125 = and i1 %123, %124, !dbg !239
  %126 = add i64 %121, -1, !dbg !239
  %127 = select i1 %125, i64 %126, i64 %121, !dbg !239
  %128 = srem i64 %120, 50176, !dbg !239
  %129 = icmp slt i64 %128, 0, !dbg !239
  %130 = add nsw i64 %128, 50176, !dbg !239
  %131 = select i1 %129, i64 %130, i64 %128, !dbg !239
  %132 = sdiv i64 %131, 224, !dbg !239
  %133 = srem i64 %120, 224, !dbg !239
  %134 = icmp slt i64 %133, 0, !dbg !239
  %135 = add nsw i64 %133, 224, !dbg !239
  %136 = select i1 %134, i64 %135, i64 %133, !dbg !239
  %137 = mul i64 %127, 50176, !dbg !239
  %138 = mul i64 %132, 224, !dbg !239
  %139 = add i64 %137, %138, !dbg !239
  %140 = add i64 %139, %136, !dbg !239
  %141 = getelementptr float, ptr %7, i64 %140, !dbg !239
  %142 = load <1 x float>, ptr %141, align 4, !dbg !239
  %143 = extractelement <1 x float> %142, i64 0, !dbg !239
  %144 = extractelement <4 x i64> %95, i64 2, !dbg !239
  %145 = sdiv i64 %144, 50176, !dbg !239
  %146 = mul i64 %145, 50176, !dbg !239
  %147 = icmp ne i64 %144, %146, !dbg !239
  %148 = icmp slt i64 %144, 0, !dbg !239
  %149 = and i1 %147, %148, !dbg !239
  %150 = add i64 %145, -1, !dbg !239
  %151 = select i1 %149, i64 %150, i64 %145, !dbg !239
  %152 = srem i64 %144, 50176, !dbg !239
  %153 = icmp slt i64 %152, 0, !dbg !239
  %154 = add nsw i64 %152, 50176, !dbg !239
  %155 = select i1 %153, i64 %154, i64 %152, !dbg !239
  %156 = sdiv i64 %155, 224, !dbg !239
  %157 = srem i64 %144, 224, !dbg !239
  %158 = icmp slt i64 %157, 0, !dbg !239
  %159 = add nsw i64 %157, 224, !dbg !239
  %160 = select i1 %158, i64 %159, i64 %157, !dbg !239
  %161 = mul i64 %151, 50176, !dbg !239
  %162 = mul i64 %156, 224, !dbg !239
  %163 = add i64 %161, %162, !dbg !239
  %164 = add i64 %163, %160, !dbg !239
  %165 = getelementptr float, ptr %7, i64 %164, !dbg !239
  %166 = load <1 x float>, ptr %165, align 4, !dbg !239
  %167 = extractelement <1 x float> %166, i64 0, !dbg !239
  %168 = extractelement <4 x i64> %95, i64 3, !dbg !239
  %169 = sdiv i64 %168, 50176, !dbg !239
  %170 = mul i64 %169, 50176, !dbg !239
  %171 = icmp ne i64 %168, %170, !dbg !239
  %172 = icmp slt i64 %168, 0, !dbg !239
  %173 = and i1 %171, %172, !dbg !239
  %174 = add i64 %169, -1, !dbg !239
  %175 = select i1 %173, i64 %174, i64 %169, !dbg !239
  %176 = srem i64 %168, 50176, !dbg !239
  %177 = icmp slt i64 %176, 0, !dbg !239
  %178 = add nsw i64 %176, 50176, !dbg !239
  %179 = select i1 %177, i64 %178, i64 %176, !dbg !239
  %180 = sdiv i64 %179, 224, !dbg !239
  %181 = srem i64 %168, 224, !dbg !239
  %182 = icmp slt i64 %181, 0, !dbg !239
  %183 = add nsw i64 %181, 224, !dbg !239
  %184 = select i1 %182, i64 %183, i64 %181, !dbg !239
  %185 = mul i64 %175, 50176, !dbg !239
  %186 = mul i64 %180, 224, !dbg !239
  %187 = add i64 %185, %186, !dbg !239
  %188 = add i64 %187, %184, !dbg !239
  %189 = getelementptr float, ptr %7, i64 %188, !dbg !239
  %190 = load <1 x float>, ptr %189, align 4, !dbg !239
  %191 = extractelement <1 x float> %190, i64 0, !dbg !239
  %192 = add <4 x i64> %92, %94, !dbg !269
  %193 = extractelement <4 x i64> %192, i64 0, !dbg !269
  %194 = sdiv i64 %193, 50176, !dbg !269
  %195 = mul i64 %194, 50176, !dbg !269
  %196 = icmp ne i64 %193, %195, !dbg !269
  %197 = icmp slt i64 %193, 0, !dbg !269
  %198 = and i1 %196, %197, !dbg !269
  %199 = add i64 %194, -1, !dbg !269
  %200 = select i1 %198, i64 %199, i64 %194, !dbg !269
  %201 = srem i64 %193, 50176, !dbg !269
  %202 = icmp slt i64 %201, 0, !dbg !269
  %203 = add nsw i64 %201, 50176, !dbg !269
  %204 = select i1 %202, i64 %203, i64 %201, !dbg !269
  %205 = sdiv i64 %204, 224, !dbg !269
  %206 = srem i64 %193, 224, !dbg !269
  %207 = icmp slt i64 %206, 0, !dbg !269
  %208 = add nsw i64 %206, 224, !dbg !269
  %209 = select i1 %207, i64 %208, i64 %206, !dbg !269
  %210 = mul i64 %200, 50176, !dbg !269
  %211 = mul i64 %205, 224, !dbg !269
  %212 = add i64 %210, %211, !dbg !269
  %213 = add i64 %212, %209, !dbg !269
  %214 = getelementptr float, ptr %7, i64 %213, !dbg !269
  %215 = load <1 x float>, ptr %214, align 4, !dbg !269
  %216 = extractelement <1 x float> %215, i64 0, !dbg !269
  %217 = extractelement <4 x i64> %192, i64 1, !dbg !269
  %218 = sdiv i64 %217, 50176, !dbg !269
  %219 = mul i64 %218, 50176, !dbg !269
  %220 = icmp ne i64 %217, %219, !dbg !269
  %221 = icmp slt i64 %217, 0, !dbg !269
  %222 = and i1 %220, %221, !dbg !269
  %223 = add i64 %218, -1, !dbg !269
  %224 = select i1 %222, i64 %223, i64 %218, !dbg !269
  %225 = srem i64 %217, 50176, !dbg !269
  %226 = icmp slt i64 %225, 0, !dbg !269
  %227 = add nsw i64 %225, 50176, !dbg !269
  %228 = select i1 %226, i64 %227, i64 %225, !dbg !269
  %229 = sdiv i64 %228, 224, !dbg !269
  %230 = srem i64 %217, 224, !dbg !269
  %231 = icmp slt i64 %230, 0, !dbg !269
  %232 = add nsw i64 %230, 224, !dbg !269
  %233 = select i1 %231, i64 %232, i64 %230, !dbg !269
  %234 = mul i64 %224, 50176, !dbg !269
  %235 = mul i64 %229, 224, !dbg !269
  %236 = add i64 %234, %235, !dbg !269
  %237 = add i64 %236, %233, !dbg !269
  %238 = getelementptr float, ptr %7, i64 %237, !dbg !269
  %239 = load <1 x float>, ptr %238, align 4, !dbg !269
  %240 = extractelement <1 x float> %239, i64 0, !dbg !269
  %241 = extractelement <4 x i64> %192, i64 2, !dbg !269
  %242 = sdiv i64 %241, 50176, !dbg !269
  %243 = mul i64 %242, 50176, !dbg !269
  %244 = icmp ne i64 %241, %243, !dbg !269
  %245 = icmp slt i64 %241, 0, !dbg !269
  %246 = and i1 %244, %245, !dbg !269
  %247 = add i64 %242, -1, !dbg !269
  %248 = select i1 %246, i64 %247, i64 %242, !dbg !269
  %249 = srem i64 %241, 50176, !dbg !269
  %250 = icmp slt i64 %249, 0, !dbg !269
  %251 = add nsw i64 %249, 50176, !dbg !269
  %252 = select i1 %250, i64 %251, i64 %249, !dbg !269
  %253 = sdiv i64 %252, 224, !dbg !269
  %254 = srem i64 %241, 224, !dbg !269
  %255 = icmp slt i64 %254, 0, !dbg !269
  %256 = add nsw i64 %254, 224, !dbg !269
  %257 = select i1 %255, i64 %256, i64 %254, !dbg !269
  %258 = mul i64 %248, 50176, !dbg !269
  %259 = mul i64 %253, 224, !dbg !269
  %260 = add i64 %258, %259, !dbg !269
  %261 = add i64 %260, %257, !dbg !269
  %262 = getelementptr float, ptr %7, i64 %261, !dbg !269
  %263 = load <1 x float>, ptr %262, align 4, !dbg !269
  %264 = extractelement <1 x float> %263, i64 0, !dbg !269
  %265 = extractelement <4 x i64> %192, i64 3, !dbg !269
  %266 = sdiv i64 %265, 50176, !dbg !269
  %267 = mul i64 %266, 50176, !dbg !269
  %268 = icmp ne i64 %265, %267, !dbg !269
  %269 = icmp slt i64 %265, 0, !dbg !269
  %270 = and i1 %268, %269, !dbg !269
  %271 = add i64 %266, -1, !dbg !269
  %272 = select i1 %270, i64 %271, i64 %266, !dbg !269
  %273 = srem i64 %265, 50176, !dbg !269
  %274 = icmp slt i64 %273, 0, !dbg !269
  %275 = add nsw i64 %273, 50176, !dbg !269
  %276 = select i1 %274, i64 %275, i64 %273, !dbg !269
  %277 = sdiv i64 %276, 224, !dbg !269
  %278 = srem i64 %265, 224, !dbg !269
  %279 = icmp slt i64 %278, 0, !dbg !269
  %280 = add nsw i64 %278, 224, !dbg !269
  %281 = select i1 %279, i64 %280, i64 %278, !dbg !269
  %282 = mul i64 %272, 50176, !dbg !269
  %283 = mul i64 %277, 224, !dbg !269
  %284 = add i64 %282, %283, !dbg !269
  %285 = add i64 %284, %281, !dbg !269
  %286 = getelementptr float, ptr %7, i64 %285, !dbg !269
  %287 = load <1 x float>, ptr %286, align 4, !dbg !269
  %288 = extractelement <1 x float> %287, i64 0, !dbg !269
  %289 = insertelement <4 x i64> poison, i64 %64, i32 0, !dbg !253
  %290 = shufflevector <4 x i64> %289, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !253
  %291 = add <4 x i64> %88, %290, !dbg !253
  %292 = extractelement <4 x i64> %291, i64 0, !dbg !253
  %293 = sdiv i64 %292, 50176, !dbg !253
  %294 = mul i64 %293, 50176, !dbg !253
  %295 = icmp ne i64 %292, %294, !dbg !253
  %296 = icmp slt i64 %292, 0, !dbg !253
  %297 = and i1 %295, %296, !dbg !253
  %298 = add i64 %293, -1, !dbg !253
  %299 = select i1 %297, i64 %298, i64 %293, !dbg !253
  %300 = srem i64 %292, 50176, !dbg !253
  %301 = icmp slt i64 %300, 0, !dbg !253
  %302 = add nsw i64 %300, 50176, !dbg !253
  %303 = select i1 %301, i64 %302, i64 %300, !dbg !253
  %304 = sdiv i64 %303, 224, !dbg !253
  %305 = srem i64 %292, 224, !dbg !253
  %306 = icmp slt i64 %305, 0, !dbg !253
  %307 = add nsw i64 %305, 224, !dbg !253
  %308 = select i1 %306, i64 %307, i64 %305, !dbg !253
  %309 = mul i64 %299, 50176, !dbg !253
  %310 = mul i64 %304, 224, !dbg !253
  %311 = add i64 %309, %310, !dbg !253
  %312 = add i64 %311, %308, !dbg !253
  %313 = getelementptr float, ptr %7, i64 %312, !dbg !253
  %314 = load <1 x float>, ptr %313, align 4, !dbg !253
  %315 = extractelement <1 x float> %314, i64 0, !dbg !253
  %316 = extractelement <4 x i64> %291, i64 1, !dbg !253
  %317 = sdiv i64 %316, 50176, !dbg !253
  %318 = mul i64 %317, 50176, !dbg !253
  %319 = icmp ne i64 %316, %318, !dbg !253
  %320 = icmp slt i64 %316, 0, !dbg !253
  %321 = and i1 %319, %320, !dbg !253
  %322 = add i64 %317, -1, !dbg !253
  %323 = select i1 %321, i64 %322, i64 %317, !dbg !253
  %324 = srem i64 %316, 50176, !dbg !253
  %325 = icmp slt i64 %324, 0, !dbg !253
  %326 = add nsw i64 %324, 50176, !dbg !253
  %327 = select i1 %325, i64 %326, i64 %324, !dbg !253
  %328 = sdiv i64 %327, 224, !dbg !253
  %329 = srem i64 %316, 224, !dbg !253
  %330 = icmp slt i64 %329, 0, !dbg !253
  %331 = add nsw i64 %329, 224, !dbg !253
  %332 = select i1 %330, i64 %331, i64 %329, !dbg !253
  %333 = mul i64 %323, 50176, !dbg !253
  %334 = mul i64 %328, 224, !dbg !253
  %335 = add i64 %333, %334, !dbg !253
  %336 = add i64 %335, %332, !dbg !253
  %337 = getelementptr float, ptr %7, i64 %336, !dbg !253
  %338 = load <1 x float>, ptr %337, align 4, !dbg !253
  %339 = extractelement <1 x float> %338, i64 0, !dbg !253
  %340 = extractelement <4 x i64> %291, i64 2, !dbg !253
  %341 = sdiv i64 %340, 50176, !dbg !253
  %342 = mul i64 %341, 50176, !dbg !253
  %343 = icmp ne i64 %340, %342, !dbg !253
  %344 = icmp slt i64 %340, 0, !dbg !253
  %345 = and i1 %343, %344, !dbg !253
  %346 = add i64 %341, -1, !dbg !253
  %347 = select i1 %345, i64 %346, i64 %341, !dbg !253
  %348 = srem i64 %340, 50176, !dbg !253
  %349 = icmp slt i64 %348, 0, !dbg !253
  %350 = add nsw i64 %348, 50176, !dbg !253
  %351 = select i1 %349, i64 %350, i64 %348, !dbg !253
  %352 = sdiv i64 %351, 224, !dbg !253
  %353 = srem i64 %340, 224, !dbg !253
  %354 = icmp slt i64 %353, 0, !dbg !253
  %355 = add nsw i64 %353, 224, !dbg !253
  %356 = select i1 %354, i64 %355, i64 %353, !dbg !253
  %357 = mul i64 %347, 50176, !dbg !253
  %358 = mul i64 %352, 224, !dbg !253
  %359 = add i64 %357, %358, !dbg !253
  %360 = add i64 %359, %356, !dbg !253
  %361 = getelementptr float, ptr %7, i64 %360, !dbg !253
  %362 = load <1 x float>, ptr %361, align 4, !dbg !253
  %363 = extractelement <1 x float> %362, i64 0, !dbg !253
  %364 = extractelement <4 x i64> %291, i64 3, !dbg !253
  %365 = sdiv i64 %364, 50176, !dbg !253
  %366 = mul i64 %365, 50176, !dbg !253
  %367 = icmp ne i64 %364, %366, !dbg !253
  %368 = icmp slt i64 %364, 0, !dbg !253
  %369 = and i1 %367, %368, !dbg !253
  %370 = add i64 %365, -1, !dbg !253
  %371 = select i1 %369, i64 %370, i64 %365, !dbg !253
  %372 = srem i64 %364, 50176, !dbg !253
  %373 = icmp slt i64 %372, 0, !dbg !253
  %374 = add nsw i64 %372, 50176, !dbg !253
  %375 = select i1 %373, i64 %374, i64 %372, !dbg !253
  %376 = sdiv i64 %375, 224, !dbg !253
  %377 = srem i64 %364, 224, !dbg !253
  %378 = icmp slt i64 %377, 0, !dbg !253
  %379 = add nsw i64 %377, 224, !dbg !253
  %380 = select i1 %378, i64 %379, i64 %377, !dbg !253
  %381 = mul i64 %371, 50176, !dbg !253
  %382 = mul i64 %376, 224, !dbg !253
  %383 = add i64 %381, %382, !dbg !253
  %384 = add i64 %383, %380, !dbg !253
  %385 = getelementptr float, ptr %7, i64 %384, !dbg !253
  %386 = load <1 x float>, ptr %385, align 4, !dbg !253
  %387 = extractelement <1 x float> %386, i64 0, !dbg !253
  %388 = add <4 x i64> %92, %290, !dbg !270
  %389 = extractelement <4 x i64> %388, i64 0, !dbg !270
  %390 = sdiv i64 %389, 50176, !dbg !270
  %391 = mul i64 %390, 50176, !dbg !270
  %392 = icmp ne i64 %389, %391, !dbg !270
  %393 = icmp slt i64 %389, 0, !dbg !270
  %394 = and i1 %392, %393, !dbg !270
  %395 = add i64 %390, -1, !dbg !270
  %396 = select i1 %394, i64 %395, i64 %390, !dbg !270
  %397 = srem i64 %389, 50176, !dbg !270
  %398 = icmp slt i64 %397, 0, !dbg !270
  %399 = add nsw i64 %397, 50176, !dbg !270
  %400 = select i1 %398, i64 %399, i64 %397, !dbg !270
  %401 = sdiv i64 %400, 224, !dbg !270
  %402 = srem i64 %389, 224, !dbg !270
  %403 = icmp slt i64 %402, 0, !dbg !270
  %404 = add nsw i64 %402, 224, !dbg !270
  %405 = select i1 %403, i64 %404, i64 %402, !dbg !270
  %406 = mul i64 %396, 50176, !dbg !270
  %407 = mul i64 %401, 224, !dbg !270
  %408 = add i64 %406, %407, !dbg !270
  %409 = add i64 %408, %405, !dbg !270
  %410 = getelementptr float, ptr %7, i64 %409, !dbg !270
  %411 = load <1 x float>, ptr %410, align 4, !dbg !270
  %412 = extractelement <1 x float> %411, i64 0, !dbg !270
  %413 = extractelement <4 x i64> %388, i64 1, !dbg !270
  %414 = sdiv i64 %413, 50176, !dbg !270
  %415 = mul i64 %414, 50176, !dbg !270
  %416 = icmp ne i64 %413, %415, !dbg !270
  %417 = icmp slt i64 %413, 0, !dbg !270
  %418 = and i1 %416, %417, !dbg !270
  %419 = add i64 %414, -1, !dbg !270
  %420 = select i1 %418, i64 %419, i64 %414, !dbg !270
  %421 = srem i64 %413, 50176, !dbg !270
  %422 = icmp slt i64 %421, 0, !dbg !270
  %423 = add nsw i64 %421, 50176, !dbg !270
  %424 = select i1 %422, i64 %423, i64 %421, !dbg !270
  %425 = sdiv i64 %424, 224, !dbg !270
  %426 = srem i64 %413, 224, !dbg !270
  %427 = icmp slt i64 %426, 0, !dbg !270
  %428 = add nsw i64 %426, 224, !dbg !270
  %429 = select i1 %427, i64 %428, i64 %426, !dbg !270
  %430 = mul i64 %420, 50176, !dbg !270
  %431 = mul i64 %425, 224, !dbg !270
  %432 = add i64 %430, %431, !dbg !270
  %433 = add i64 %432, %429, !dbg !270
  %434 = getelementptr float, ptr %7, i64 %433, !dbg !270
  %435 = load <1 x float>, ptr %434, align 4, !dbg !270
  %436 = extractelement <1 x float> %435, i64 0, !dbg !270
  %437 = extractelement <4 x i64> %388, i64 2, !dbg !270
  %438 = sdiv i64 %437, 50176, !dbg !270
  %439 = mul i64 %438, 50176, !dbg !270
  %440 = icmp ne i64 %437, %439, !dbg !270
  %441 = icmp slt i64 %437, 0, !dbg !270
  %442 = and i1 %440, %441, !dbg !270
  %443 = add i64 %438, -1, !dbg !270
  %444 = select i1 %442, i64 %443, i64 %438, !dbg !270
  %445 = srem i64 %437, 50176, !dbg !270
  %446 = icmp slt i64 %445, 0, !dbg !270
  %447 = add nsw i64 %445, 50176, !dbg !270
  %448 = select i1 %446, i64 %447, i64 %445, !dbg !270
  %449 = sdiv i64 %448, 224, !dbg !270
  %450 = srem i64 %437, 224, !dbg !270
  %451 = icmp slt i64 %450, 0, !dbg !270
  %452 = add nsw i64 %450, 224, !dbg !270
  %453 = select i1 %451, i64 %452, i64 %450, !dbg !270
  %454 = mul i64 %444, 50176, !dbg !270
  %455 = mul i64 %449, 224, !dbg !270
  %456 = add i64 %454, %455, !dbg !270
  %457 = add i64 %456, %453, !dbg !270
  %458 = getelementptr float, ptr %7, i64 %457, !dbg !270
  %459 = load <1 x float>, ptr %458, align 4, !dbg !270
  %460 = extractelement <1 x float> %459, i64 0, !dbg !270
  %461 = extractelement <4 x i64> %388, i64 3, !dbg !270
  %462 = sdiv i64 %461, 50176, !dbg !270
  %463 = mul i64 %462, 50176, !dbg !270
  %464 = icmp ne i64 %461, %463, !dbg !270
  %465 = icmp slt i64 %461, 0, !dbg !270
  %466 = and i1 %464, %465, !dbg !270
  %467 = add i64 %462, -1, !dbg !270
  %468 = select i1 %466, i64 %467, i64 %462, !dbg !270
  %469 = srem i64 %461, 50176, !dbg !270
  %470 = icmp slt i64 %469, 0, !dbg !270
  %471 = add nsw i64 %469, 50176, !dbg !270
  %472 = select i1 %470, i64 %471, i64 %469, !dbg !270
  %473 = sdiv i64 %472, 224, !dbg !270
  %474 = srem i64 %461, 224, !dbg !270
  %475 = icmp slt i64 %474, 0, !dbg !270
  %476 = add nsw i64 %474, 224, !dbg !270
  %477 = select i1 %475, i64 %476, i64 %474, !dbg !270
  %478 = mul i64 %468, 50176, !dbg !270
  %479 = mul i64 %473, 224, !dbg !270
  %480 = add i64 %478, %479, !dbg !270
  %481 = add i64 %480, %477, !dbg !270
  %482 = getelementptr float, ptr %7, i64 %481, !dbg !270
  %483 = load <1 x float>, ptr %482, align 4, !dbg !270
  %484 = extractelement <1 x float> %483, i64 0, !dbg !270
  %485 = fsub contract <4 x float> %87, %84, !dbg !271
  %486 = fsub contract <4 x float> %84, %85, !dbg !272
  %487 = insertelement <4 x float> poison, float %119, i64 0, !dbg !273
  %488 = insertelement <4 x float> %487, float %143, i64 1, !dbg !273
  %489 = insertelement <4 x float> %488, float %167, i64 2, !dbg !273
  %490 = insertelement <4 x float> %489, float %191, i64 3, !dbg !273
  %491 = fmul contract <4 x float> %485, %490, !dbg !273
  %492 = insertelement <4 x float> poison, float %216, i64 0, !dbg !274
  %493 = insertelement <4 x float> %492, float %240, i64 1, !dbg !274
  %494 = insertelement <4 x float> %493, float %264, i64 2, !dbg !274
  %495 = insertelement <4 x float> %494, float %288, i64 3, !dbg !274
  %496 = fmul contract <4 x float> %486, %495, !dbg !274
  %497 = fadd contract <4 x float> %491, %496, !dbg !275
  %498 = insertelement <4 x float> poison, float %65, i32 0, !dbg !276
  %499 = shufflevector <4 x float> %498, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !276
  %500 = fmul contract <4 x float> %499, %497, !dbg !276
  %501 = insertelement <4 x float> poison, float %315, i64 0, !dbg !277
  %502 = insertelement <4 x float> %501, float %339, i64 1, !dbg !277
  %503 = insertelement <4 x float> %502, float %363, i64 2, !dbg !277
  %504 = insertelement <4 x float> %503, float %387, i64 3, !dbg !277
  %505 = fmul contract <4 x float> %485, %504, !dbg !277
  %506 = insertelement <4 x float> poison, float %412, i64 0, !dbg !278
  %507 = insertelement <4 x float> %506, float %436, i64 1, !dbg !278
  %508 = insertelement <4 x float> %507, float %460, i64 2, !dbg !278
  %509 = insertelement <4 x float> %508, float %484, i64 3, !dbg !278
  %510 = fmul contract <4 x float> %486, %509, !dbg !278
  %511 = fadd contract <4 x float> %505, %510, !dbg !279
  %512 = insertelement <4 x float> poison, float %66, i32 0, !dbg !280
  %513 = shufflevector <4 x float> %512, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !280
  %514 = fmul contract <4 x float> %513, %511, !dbg !280
  %515 = fadd contract <4 x float> %500, %514, !dbg !281
  %516 = add i64 %45, 1, !dbg !237
  %517 = add i64 %71, 1, !dbg !237
  %518 = mul i64 %39, 12996, !dbg !237
  %519 = mul i64 %516, 114, !dbg !237
  %520 = add i64 %518, %519, !dbg !237
  %521 = add i64 %520, %517, !dbg !237
  %522 = getelementptr float, ptr %12, i64 %521, !dbg !237
  store <4 x float> %515, ptr %522, align 4, !dbg !237
  %523 = add i64 %68, 4, !dbg !237
  br label %67, !dbg !237

524:                                              ; preds = %67
  %525 = add i64 %42, 1, !dbg !237
  br label %41, !dbg !237

526:                                              ; preds = %41
  %527 = add i64 %36, 1, !dbg !237
  br label %35, !dbg !237

528:                                              ; preds = %35
  ret i32 0, !dbg !282
}

define internal i32 @infer_dispatch_14_conv_64x112x112x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !283 {
  %4 = alloca float, i64 4, align 64, !dbg !284
  %5 = alloca float, i64 4, align 64, !dbg !285
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !286
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !286
  %8 = load ptr, ptr %7, align 8, !dbg !286
  %9 = getelementptr float, ptr %8, i64 20988416, !dbg !286
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !286
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !287
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !287
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !287
  %13 = load ptr, ptr %12, align 8, !dbg !287
  %14 = getelementptr float, ptr %13, i64 96, !dbg !287
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !287
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !288
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !288
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !288
  %18 = load ptr, ptr %17, align 8, !dbg !288
  %19 = getelementptr float, ptr %18, i64 1605632, !dbg !288
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !288
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !284
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !284
  %22 = zext i32 %21 to i64, !dbg !284
  %23 = sdiv i64 %22, 16, !dbg !284
  %24 = mul i64 %23, 16, !dbg !284
  %25 = icmp ne i64 %22, %24, !dbg !284
  %26 = icmp slt i64 %22, 0, !dbg !284
  %27 = and i1 %25, %26, !dbg !284
  %28 = add i64 %23, -1, !dbg !284
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !284
  %30 = srem i64 %22, 16, !dbg !284
  %31 = icmp slt i64 %30, 0, !dbg !284
  %32 = add nsw i64 %30, 16, !dbg !284
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !284
  %34 = sdiv i64 %33, 4, !dbg !284
  %35 = srem i64 %22, 4, !dbg !284
  %36 = icmp slt i64 %35, 0, !dbg !284
  %37 = add nsw i64 %35, 4, !dbg !284
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !284
  %39 = mul nsw i64 %29, 32, !dbg !284
  %40 = mul nsw i64 %34, 28, !dbg !284
  %41 = mul nsw i64 %38, 28, !dbg !284
  %42 = getelementptr float, ptr %5, i64 0, !dbg !289
  store <4 x float> zeroinitializer, ptr %42, align 4, !dbg !289
  br label %43, !dbg !284

43:                                               ; preds = %133, %3
  %44 = phi i64 [ %134, %133 ], [ 0, %3 ], !dbg !284
  %45 = icmp slt i64 %44, 32, !dbg !284
  br i1 %45, label %46, label %135, !dbg !284

46:                                               ; preds = %43
  %47 = add i64 %44, %39, !dbg !284
  %48 = getelementptr float, ptr @__constant_64xf32_0, i64 %47, !dbg !290
  %49 = load <1 x float>, ptr %48, align 4, !dbg !290
  br label %50, !dbg !284

50:                                               ; preds = %131, %46
  %51 = phi i64 [ %132, %131 ], [ 0, %46 ], !dbg !284
  %52 = icmp slt i64 %51, 28, !dbg !284
  br i1 %52, label %53, label %133, !dbg !284

53:                                               ; preds = %111, %50
  %54 = phi i64 [ %130, %111 ], [ 0, %50 ], !dbg !284
  %55 = icmp slt i64 %54, 28, !dbg !284
  br i1 %55, label %56, label %131, !dbg !284

56:                                               ; preds = %53
  %57 = add i64 %54, %41, !dbg !284
  br label %58, !dbg !284

58:                                               ; preds = %61, %56
  %59 = phi i64 [ %66, %61 ], [ 0, %56 ], !dbg !284
  %60 = icmp slt i64 %59, 4, !dbg !284
  br i1 %60, label %61, label %67, !dbg !284

61:                                               ; preds = %58
  %62 = add nuw nsw i64 0, %59, !dbg !284
  %63 = getelementptr inbounds nuw float, ptr %5, i64 %62, !dbg !284
  %64 = load float, ptr %63, align 4, !dbg !284
  %65 = getelementptr inbounds nuw float, ptr %4, i64 %62, !dbg !284
  store float %64, ptr %65, align 4, !dbg !284
  %66 = add i64 %59, 1, !dbg !284
  br label %58, !dbg !284

67:                                               ; preds = %109, %58
  %68 = phi i64 [ %110, %109 ], [ 0, %58 ], !dbg !284
  %69 = icmp slt i64 %68, 128, !dbg !284
  br i1 %69, label %70, label %111, !dbg !284

70:                                               ; preds = %107, %67
  %71 = phi i64 [ %108, %107 ], [ 0, %67 ], !dbg !284
  %72 = icmp slt i64 %71, 3, !dbg !284
  br i1 %72, label %73, label %109, !dbg !284

73:                                               ; preds = %70
  %74 = add i64 %71, %51, !dbg !284
  %75 = add i64 %74, %40, !dbg !284
  br label %76, !dbg !284

76:                                               ; preds = %105, %73
  %77 = phi i64 [ %106, %105 ], [ 0, %73 ], !dbg !284
  %78 = icmp slt i64 %77, 4, !dbg !284
  br i1 %78, label %79, label %107, !dbg !284

79:                                               ; preds = %82, %76
  %80 = phi i64 [ %104, %82 ], [ 0, %76 ], !dbg !284
  %81 = icmp slt i64 %80, 3, !dbg !284
  br i1 %81, label %82, label %105, !dbg !284

82:                                               ; preds = %79
  %83 = add i64 %57, %77, !dbg !284
  %84 = add i64 %83, %80, !dbg !284
  %85 = mul nuw nsw i64 %68, 12996, !dbg !284
  %86 = mul nuw nsw i64 %75, 114, !dbg !284
  %87 = add nuw nsw i64 %85, %86, !dbg !284
  %88 = add nuw nsw i64 %87, %84, !dbg !284
  %89 = getelementptr inbounds nuw float, ptr %9, i64 %88, !dbg !284
  %90 = load float, ptr %89, align 4, !dbg !284
  %91 = mul nuw nsw i64 %47, 1152, !dbg !284
  %92 = mul nuw nsw i64 %68, 9, !dbg !284
  %93 = add nuw nsw i64 %91, %92, !dbg !284
  %94 = mul nuw nsw i64 %71, 3, !dbg !284
  %95 = add nuw nsw i64 %93, %94, !dbg !284
  %96 = add nuw nsw i64 %95, %80, !dbg !284
  %97 = getelementptr inbounds nuw float, ptr %14, i64 %96, !dbg !284
  %98 = load float, ptr %97, align 4, !dbg !284
  %99 = add nuw nsw i64 0, %77, !dbg !284
  %100 = getelementptr inbounds nuw float, ptr %4, i64 %99, !dbg !284
  %101 = load float, ptr %100, align 4, !dbg !284
  %102 = fmul contract float %90, %98, !dbg !291
  %103 = fadd contract float %101, %102, !dbg !292
  store float %103, ptr %100, align 4, !dbg !284
  %104 = add i64 %80, 1, !dbg !284
  br label %79, !dbg !284

105:                                              ; preds = %79
  %106 = add i64 %77, 1, !dbg !284
  br label %76, !dbg !284

107:                                              ; preds = %76
  %108 = add i64 %71, 1, !dbg !284
  br label %70, !dbg !284

109:                                              ; preds = %70
  %110 = add i64 %68, 1, !dbg !284
  br label %67, !dbg !284

111:                                              ; preds = %67
  %112 = getelementptr float, ptr %4, i64 0, !dbg !290
  %113 = load <4 x float>, ptr %112, align 4, !dbg !290
  %114 = extractelement <1 x float> %49, i64 0, !dbg !293
  %115 = insertelement <4 x float> poison, float %114, i32 0, !dbg !293
  %116 = shufflevector <4 x float> %115, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !293
  %117 = fadd contract <4 x float> %113, %116, !dbg !293
  %118 = fcmp olt <4 x float> zeroinitializer, %117, !dbg !294
  %119 = select <4 x i1> %118, <4 x float> zeroinitializer, <4 x float> %117, !dbg !295
  %120 = fmul contract <4 x float> %119, splat (float 0x3FC99999A0000000), !dbg !296
  %121 = fcmp ogt <4 x float> zeroinitializer, %117, !dbg !297
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %117, !dbg !298
  %123 = fadd contract <4 x float> %122, %120, !dbg !299
  %124 = add i64 %40, %51, !dbg !284
  %125 = mul i64 %47, 12544, !dbg !284
  %126 = mul i64 %124, 112, !dbg !284
  %127 = add i64 %125, %126, !dbg !284
  %128 = add i64 %127, %57, !dbg !284
  %129 = getelementptr float, ptr %19, i64 %128, !dbg !284
  store <4 x float> %123, ptr %129, align 4, !dbg !284
  %130 = add i64 %54, 4, !dbg !284
  br label %53, !dbg !284

131:                                              ; preds = %53
  %132 = add i64 %51, 1, !dbg !284
  br label %50, !dbg !284

133:                                              ; preds = %50
  %134 = add i64 %44, 1, !dbg !284
  br label %43, !dbg !284

135:                                              ; preds = %43
  ret i32 0, !dbg !300
}

define internal i32 @infer_dispatch_15_elementwise_broadcast_64x224x224_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !301 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !302
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !302
  %6 = load ptr, ptr %5, align 8, !dbg !302
  %7 = getelementptr float, ptr %6, i64 1605632, !dbg !302
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !302
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !303
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !303
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !303
  %11 = load ptr, ptr %10, align 8, !dbg !303
  %12 = getelementptr float, ptr %11, i64 2408448, !dbg !303
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !303
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !304
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !304
  %15 = zext i32 %14 to i64, !dbg !304
  %16 = sdiv i64 %15, 4, !dbg !304
  %17 = mul i64 %16, 4, !dbg !304
  %18 = icmp ne i64 %15, %17, !dbg !304
  %19 = icmp slt i64 %15, 0, !dbg !304
  %20 = and i1 %18, %19, !dbg !304
  %21 = add i64 %16, -1, !dbg !304
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !304
  %23 = srem i64 %15, 4, !dbg !304
  %24 = icmp slt i64 %23, 0, !dbg !304
  %25 = add nsw i64 %23, 4, !dbg !304
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !304
  %27 = mul nsw i64 %22, 56, !dbg !304
  %28 = mul nsw i64 %26, 56, !dbg !304
  br label %29, !dbg !304

29:                                               ; preds = %519, %3
  %30 = phi i64 [ %520, %519 ], [ 0, %3 ], !dbg !304
  %31 = icmp slt i64 %30, 64, !dbg !304
  br i1 %31, label %32, label %521, !dbg !304

32:                                               ; preds = %29
  %33 = mul i64 %30, 112, !dbg !305
  br label %34, !dbg !304

34:                                               ; preds = %517, %32
  %35 = phi i64 [ %518, %517 ], [ 0, %32 ], !dbg !304
  %36 = icmp slt i64 %35, 56, !dbg !304
  br i1 %36, label %37, label %519, !dbg !304

37:                                               ; preds = %34
  %38 = add i64 %27, %35, !dbg !306
  %39 = sitofp i64 %38 to float, !dbg !307
  %40 = fadd contract float %39, 5.000000e-01, !dbg !308
  %41 = fdiv float %40, 2.000000e+00, !dbg !309
  %42 = fsub contract float %41, 5.000000e-01, !dbg !310
  %43 = fcmp ugt float %42, 0.000000e+00, !dbg !311
  %44 = select i1 %43, float %42, float 0.000000e+00, !dbg !311
  %45 = fcmp ult float %44, 1.110000e+02, !dbg !312
  %46 = select i1 %45, float %44, float 1.110000e+02, !dbg !312
  %47 = call float @llvm.floor.f32(float %46), !dbg !313
  %48 = fadd contract float %46, 1.000000e+00, !dbg !314
  %49 = call float @llvm.floor.f32(float %48), !dbg !315
  %50 = fptosi float %47 to i64, !dbg !316
  %51 = fcmp ult float %48, 1.110000e+02, !dbg !317
  %52 = select i1 %51, float %48, float 1.110000e+02, !dbg !317
  %53 = fptosi float %52 to i64, !dbg !318
  %54 = add i64 %50, %33, !dbg !305
  %55 = mul i64 %54, 112, !dbg !305
  %56 = add i64 %53, %33, !dbg !319
  %57 = mul i64 %56, 112, !dbg !319
  %58 = fsub contract float %49, %46, !dbg !320
  %59 = fsub contract float %46, %47, !dbg !321
  br label %60, !dbg !304

60:                                               ; preds = %63, %37
  %61 = phi i64 [ %516, %63 ], [ 0, %37 ], !dbg !304
  %62 = icmp slt i64 %61, 56, !dbg !304
  br i1 %62, label %63, label %517, !dbg !304

63:                                               ; preds = %60
  %64 = add i64 %28, %61, !dbg !322
  %65 = insertelement <4 x i64> poison, i64 %64, i32 0, !dbg !304
  %66 = shufflevector <4 x i64> %65, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !304
  %67 = add <4 x i64> %66, <i64 0, i64 1, i64 2, i64 3>, !dbg !322
  %68 = sitofp <4 x i64> %67 to <4 x float>, !dbg !323
  %69 = fadd contract <4 x float> %68, splat (float 5.000000e-01), !dbg !324
  %70 = fdiv <4 x float> %69, splat (float 2.000000e+00), !dbg !325
  %71 = fsub contract <4 x float> %70, splat (float 5.000000e-01), !dbg !326
  %72 = fcmp ugt <4 x float> %71, zeroinitializer, !dbg !327
  %73 = select <4 x i1> %72, <4 x float> %71, <4 x float> zeroinitializer, !dbg !327
  %74 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %73, !dbg !327
  %75 = fcmp ult <4 x float> %74, splat (float 1.110000e+02), !dbg !328
  %76 = select <4 x i1> %75, <4 x float> %74, <4 x float> splat (float 1.110000e+02), !dbg !328
  %77 = select <4 x i1> zeroinitializer, <4 x float> splat (float 1.110000e+02), <4 x float> %76, !dbg !328
  %78 = call <4 x float> @llvm.floor.v4f32(<4 x float> %77), !dbg !329
  %79 = fadd contract <4 x float> %77, splat (float 1.000000e+00), !dbg !330
  %80 = call <4 x float> @llvm.floor.v4f32(<4 x float> %79), !dbg !331
  %81 = fptosi <4 x float> %78 to <4 x i64>, !dbg !332
  %82 = fcmp ult <4 x float> %79, splat (float 1.110000e+02), !dbg !333
  %83 = select <4 x i1> %82, <4 x float> %79, <4 x float> splat (float 1.110000e+02), !dbg !333
  %84 = select <4 x i1> zeroinitializer, <4 x float> splat (float 1.110000e+02), <4 x float> %83, !dbg !333
  %85 = fptosi <4 x float> %84 to <4 x i64>, !dbg !334
  %86 = insertelement <4 x i64> poison, i64 %55, i32 0, !dbg !305
  %87 = shufflevector <4 x i64> %86, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !305
  %88 = add <4 x i64> %81, %87, !dbg !305
  %89 = extractelement <4 x i64> %88, i64 0, !dbg !305
  %90 = sdiv i64 %89, 12544, !dbg !305
  %91 = mul i64 %90, 12544, !dbg !305
  %92 = icmp ne i64 %89, %91, !dbg !305
  %93 = icmp slt i64 %89, 0, !dbg !305
  %94 = and i1 %92, %93, !dbg !305
  %95 = add i64 %90, -1, !dbg !305
  %96 = select i1 %94, i64 %95, i64 %90, !dbg !305
  %97 = srem i64 %89, 12544, !dbg !305
  %98 = icmp slt i64 %97, 0, !dbg !305
  %99 = add nsw i64 %97, 12544, !dbg !305
  %100 = select i1 %98, i64 %99, i64 %97, !dbg !305
  %101 = sdiv i64 %100, 112, !dbg !305
  %102 = srem i64 %89, 112, !dbg !305
  %103 = icmp slt i64 %102, 0, !dbg !305
  %104 = add nsw i64 %102, 112, !dbg !305
  %105 = select i1 %103, i64 %104, i64 %102, !dbg !305
  %106 = mul i64 %96, 12544, !dbg !305
  %107 = mul i64 %101, 112, !dbg !305
  %108 = add i64 %106, %107, !dbg !305
  %109 = add i64 %108, %105, !dbg !305
  %110 = getelementptr float, ptr %7, i64 %109, !dbg !305
  %111 = load <1 x float>, ptr %110, align 4, !dbg !305
  %112 = extractelement <1 x float> %111, i64 0, !dbg !305
  %113 = extractelement <4 x i64> %88, i64 1, !dbg !305
  %114 = sdiv i64 %113, 12544, !dbg !305
  %115 = mul i64 %114, 12544, !dbg !305
  %116 = icmp ne i64 %113, %115, !dbg !305
  %117 = icmp slt i64 %113, 0, !dbg !305
  %118 = and i1 %116, %117, !dbg !305
  %119 = add i64 %114, -1, !dbg !305
  %120 = select i1 %118, i64 %119, i64 %114, !dbg !305
  %121 = srem i64 %113, 12544, !dbg !305
  %122 = icmp slt i64 %121, 0, !dbg !305
  %123 = add nsw i64 %121, 12544, !dbg !305
  %124 = select i1 %122, i64 %123, i64 %121, !dbg !305
  %125 = sdiv i64 %124, 112, !dbg !305
  %126 = srem i64 %113, 112, !dbg !305
  %127 = icmp slt i64 %126, 0, !dbg !305
  %128 = add nsw i64 %126, 112, !dbg !305
  %129 = select i1 %127, i64 %128, i64 %126, !dbg !305
  %130 = mul i64 %120, 12544, !dbg !305
  %131 = mul i64 %125, 112, !dbg !305
  %132 = add i64 %130, %131, !dbg !305
  %133 = add i64 %132, %129, !dbg !305
  %134 = getelementptr float, ptr %7, i64 %133, !dbg !305
  %135 = load <1 x float>, ptr %134, align 4, !dbg !305
  %136 = extractelement <1 x float> %135, i64 0, !dbg !305
  %137 = extractelement <4 x i64> %88, i64 2, !dbg !305
  %138 = sdiv i64 %137, 12544, !dbg !305
  %139 = mul i64 %138, 12544, !dbg !305
  %140 = icmp ne i64 %137, %139, !dbg !305
  %141 = icmp slt i64 %137, 0, !dbg !305
  %142 = and i1 %140, %141, !dbg !305
  %143 = add i64 %138, -1, !dbg !305
  %144 = select i1 %142, i64 %143, i64 %138, !dbg !305
  %145 = srem i64 %137, 12544, !dbg !305
  %146 = icmp slt i64 %145, 0, !dbg !305
  %147 = add nsw i64 %145, 12544, !dbg !305
  %148 = select i1 %146, i64 %147, i64 %145, !dbg !305
  %149 = sdiv i64 %148, 112, !dbg !305
  %150 = srem i64 %137, 112, !dbg !305
  %151 = icmp slt i64 %150, 0, !dbg !305
  %152 = add nsw i64 %150, 112, !dbg !305
  %153 = select i1 %151, i64 %152, i64 %150, !dbg !305
  %154 = mul i64 %144, 12544, !dbg !305
  %155 = mul i64 %149, 112, !dbg !305
  %156 = add i64 %154, %155, !dbg !305
  %157 = add i64 %156, %153, !dbg !305
  %158 = getelementptr float, ptr %7, i64 %157, !dbg !305
  %159 = load <1 x float>, ptr %158, align 4, !dbg !305
  %160 = extractelement <1 x float> %159, i64 0, !dbg !305
  %161 = extractelement <4 x i64> %88, i64 3, !dbg !305
  %162 = sdiv i64 %161, 12544, !dbg !305
  %163 = mul i64 %162, 12544, !dbg !305
  %164 = icmp ne i64 %161, %163, !dbg !305
  %165 = icmp slt i64 %161, 0, !dbg !305
  %166 = and i1 %164, %165, !dbg !305
  %167 = add i64 %162, -1, !dbg !305
  %168 = select i1 %166, i64 %167, i64 %162, !dbg !305
  %169 = srem i64 %161, 12544, !dbg !305
  %170 = icmp slt i64 %169, 0, !dbg !305
  %171 = add nsw i64 %169, 12544, !dbg !305
  %172 = select i1 %170, i64 %171, i64 %169, !dbg !305
  %173 = sdiv i64 %172, 112, !dbg !305
  %174 = srem i64 %161, 112, !dbg !305
  %175 = icmp slt i64 %174, 0, !dbg !305
  %176 = add nsw i64 %174, 112, !dbg !305
  %177 = select i1 %175, i64 %176, i64 %174, !dbg !305
  %178 = mul i64 %168, 12544, !dbg !305
  %179 = mul i64 %173, 112, !dbg !305
  %180 = add i64 %178, %179, !dbg !305
  %181 = add i64 %180, %177, !dbg !305
  %182 = getelementptr float, ptr %7, i64 %181, !dbg !305
  %183 = load <1 x float>, ptr %182, align 4, !dbg !305
  %184 = extractelement <1 x float> %183, i64 0, !dbg !305
  %185 = add <4 x i64> %85, %87, !dbg !335
  %186 = extractelement <4 x i64> %185, i64 0, !dbg !335
  %187 = sdiv i64 %186, 12544, !dbg !335
  %188 = mul i64 %187, 12544, !dbg !335
  %189 = icmp ne i64 %186, %188, !dbg !335
  %190 = icmp slt i64 %186, 0, !dbg !335
  %191 = and i1 %189, %190, !dbg !335
  %192 = add i64 %187, -1, !dbg !335
  %193 = select i1 %191, i64 %192, i64 %187, !dbg !335
  %194 = srem i64 %186, 12544, !dbg !335
  %195 = icmp slt i64 %194, 0, !dbg !335
  %196 = add nsw i64 %194, 12544, !dbg !335
  %197 = select i1 %195, i64 %196, i64 %194, !dbg !335
  %198 = sdiv i64 %197, 112, !dbg !335
  %199 = srem i64 %186, 112, !dbg !335
  %200 = icmp slt i64 %199, 0, !dbg !335
  %201 = add nsw i64 %199, 112, !dbg !335
  %202 = select i1 %200, i64 %201, i64 %199, !dbg !335
  %203 = mul i64 %193, 12544, !dbg !335
  %204 = mul i64 %198, 112, !dbg !335
  %205 = add i64 %203, %204, !dbg !335
  %206 = add i64 %205, %202, !dbg !335
  %207 = getelementptr float, ptr %7, i64 %206, !dbg !335
  %208 = load <1 x float>, ptr %207, align 4, !dbg !335
  %209 = extractelement <1 x float> %208, i64 0, !dbg !335
  %210 = extractelement <4 x i64> %185, i64 1, !dbg !335
  %211 = sdiv i64 %210, 12544, !dbg !335
  %212 = mul i64 %211, 12544, !dbg !335
  %213 = icmp ne i64 %210, %212, !dbg !335
  %214 = icmp slt i64 %210, 0, !dbg !335
  %215 = and i1 %213, %214, !dbg !335
  %216 = add i64 %211, -1, !dbg !335
  %217 = select i1 %215, i64 %216, i64 %211, !dbg !335
  %218 = srem i64 %210, 12544, !dbg !335
  %219 = icmp slt i64 %218, 0, !dbg !335
  %220 = add nsw i64 %218, 12544, !dbg !335
  %221 = select i1 %219, i64 %220, i64 %218, !dbg !335
  %222 = sdiv i64 %221, 112, !dbg !335
  %223 = srem i64 %210, 112, !dbg !335
  %224 = icmp slt i64 %223, 0, !dbg !335
  %225 = add nsw i64 %223, 112, !dbg !335
  %226 = select i1 %224, i64 %225, i64 %223, !dbg !335
  %227 = mul i64 %217, 12544, !dbg !335
  %228 = mul i64 %222, 112, !dbg !335
  %229 = add i64 %227, %228, !dbg !335
  %230 = add i64 %229, %226, !dbg !335
  %231 = getelementptr float, ptr %7, i64 %230, !dbg !335
  %232 = load <1 x float>, ptr %231, align 4, !dbg !335
  %233 = extractelement <1 x float> %232, i64 0, !dbg !335
  %234 = extractelement <4 x i64> %185, i64 2, !dbg !335
  %235 = sdiv i64 %234, 12544, !dbg !335
  %236 = mul i64 %235, 12544, !dbg !335
  %237 = icmp ne i64 %234, %236, !dbg !335
  %238 = icmp slt i64 %234, 0, !dbg !335
  %239 = and i1 %237, %238, !dbg !335
  %240 = add i64 %235, -1, !dbg !335
  %241 = select i1 %239, i64 %240, i64 %235, !dbg !335
  %242 = srem i64 %234, 12544, !dbg !335
  %243 = icmp slt i64 %242, 0, !dbg !335
  %244 = add nsw i64 %242, 12544, !dbg !335
  %245 = select i1 %243, i64 %244, i64 %242, !dbg !335
  %246 = sdiv i64 %245, 112, !dbg !335
  %247 = srem i64 %234, 112, !dbg !335
  %248 = icmp slt i64 %247, 0, !dbg !335
  %249 = add nsw i64 %247, 112, !dbg !335
  %250 = select i1 %248, i64 %249, i64 %247, !dbg !335
  %251 = mul i64 %241, 12544, !dbg !335
  %252 = mul i64 %246, 112, !dbg !335
  %253 = add i64 %251, %252, !dbg !335
  %254 = add i64 %253, %250, !dbg !335
  %255 = getelementptr float, ptr %7, i64 %254, !dbg !335
  %256 = load <1 x float>, ptr %255, align 4, !dbg !335
  %257 = extractelement <1 x float> %256, i64 0, !dbg !335
  %258 = extractelement <4 x i64> %185, i64 3, !dbg !335
  %259 = sdiv i64 %258, 12544, !dbg !335
  %260 = mul i64 %259, 12544, !dbg !335
  %261 = icmp ne i64 %258, %260, !dbg !335
  %262 = icmp slt i64 %258, 0, !dbg !335
  %263 = and i1 %261, %262, !dbg !335
  %264 = add i64 %259, -1, !dbg !335
  %265 = select i1 %263, i64 %264, i64 %259, !dbg !335
  %266 = srem i64 %258, 12544, !dbg !335
  %267 = icmp slt i64 %266, 0, !dbg !335
  %268 = add nsw i64 %266, 12544, !dbg !335
  %269 = select i1 %267, i64 %268, i64 %266, !dbg !335
  %270 = sdiv i64 %269, 112, !dbg !335
  %271 = srem i64 %258, 112, !dbg !335
  %272 = icmp slt i64 %271, 0, !dbg !335
  %273 = add nsw i64 %271, 112, !dbg !335
  %274 = select i1 %272, i64 %273, i64 %271, !dbg !335
  %275 = mul i64 %265, 12544, !dbg !335
  %276 = mul i64 %270, 112, !dbg !335
  %277 = add i64 %275, %276, !dbg !335
  %278 = add i64 %277, %274, !dbg !335
  %279 = getelementptr float, ptr %7, i64 %278, !dbg !335
  %280 = load <1 x float>, ptr %279, align 4, !dbg !335
  %281 = extractelement <1 x float> %280, i64 0, !dbg !335
  %282 = insertelement <4 x i64> poison, i64 %57, i32 0, !dbg !319
  %283 = shufflevector <4 x i64> %282, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !319
  %284 = add <4 x i64> %81, %283, !dbg !319
  %285 = extractelement <4 x i64> %284, i64 0, !dbg !319
  %286 = sdiv i64 %285, 12544, !dbg !319
  %287 = mul i64 %286, 12544, !dbg !319
  %288 = icmp ne i64 %285, %287, !dbg !319
  %289 = icmp slt i64 %285, 0, !dbg !319
  %290 = and i1 %288, %289, !dbg !319
  %291 = add i64 %286, -1, !dbg !319
  %292 = select i1 %290, i64 %291, i64 %286, !dbg !319
  %293 = srem i64 %285, 12544, !dbg !319
  %294 = icmp slt i64 %293, 0, !dbg !319
  %295 = add nsw i64 %293, 12544, !dbg !319
  %296 = select i1 %294, i64 %295, i64 %293, !dbg !319
  %297 = sdiv i64 %296, 112, !dbg !319
  %298 = srem i64 %285, 112, !dbg !319
  %299 = icmp slt i64 %298, 0, !dbg !319
  %300 = add nsw i64 %298, 112, !dbg !319
  %301 = select i1 %299, i64 %300, i64 %298, !dbg !319
  %302 = mul i64 %292, 12544, !dbg !319
  %303 = mul i64 %297, 112, !dbg !319
  %304 = add i64 %302, %303, !dbg !319
  %305 = add i64 %304, %301, !dbg !319
  %306 = getelementptr float, ptr %7, i64 %305, !dbg !319
  %307 = load <1 x float>, ptr %306, align 4, !dbg !319
  %308 = extractelement <1 x float> %307, i64 0, !dbg !319
  %309 = extractelement <4 x i64> %284, i64 1, !dbg !319
  %310 = sdiv i64 %309, 12544, !dbg !319
  %311 = mul i64 %310, 12544, !dbg !319
  %312 = icmp ne i64 %309, %311, !dbg !319
  %313 = icmp slt i64 %309, 0, !dbg !319
  %314 = and i1 %312, %313, !dbg !319
  %315 = add i64 %310, -1, !dbg !319
  %316 = select i1 %314, i64 %315, i64 %310, !dbg !319
  %317 = srem i64 %309, 12544, !dbg !319
  %318 = icmp slt i64 %317, 0, !dbg !319
  %319 = add nsw i64 %317, 12544, !dbg !319
  %320 = select i1 %318, i64 %319, i64 %317, !dbg !319
  %321 = sdiv i64 %320, 112, !dbg !319
  %322 = srem i64 %309, 112, !dbg !319
  %323 = icmp slt i64 %322, 0, !dbg !319
  %324 = add nsw i64 %322, 112, !dbg !319
  %325 = select i1 %323, i64 %324, i64 %322, !dbg !319
  %326 = mul i64 %316, 12544, !dbg !319
  %327 = mul i64 %321, 112, !dbg !319
  %328 = add i64 %326, %327, !dbg !319
  %329 = add i64 %328, %325, !dbg !319
  %330 = getelementptr float, ptr %7, i64 %329, !dbg !319
  %331 = load <1 x float>, ptr %330, align 4, !dbg !319
  %332 = extractelement <1 x float> %331, i64 0, !dbg !319
  %333 = extractelement <4 x i64> %284, i64 2, !dbg !319
  %334 = sdiv i64 %333, 12544, !dbg !319
  %335 = mul i64 %334, 12544, !dbg !319
  %336 = icmp ne i64 %333, %335, !dbg !319
  %337 = icmp slt i64 %333, 0, !dbg !319
  %338 = and i1 %336, %337, !dbg !319
  %339 = add i64 %334, -1, !dbg !319
  %340 = select i1 %338, i64 %339, i64 %334, !dbg !319
  %341 = srem i64 %333, 12544, !dbg !319
  %342 = icmp slt i64 %341, 0, !dbg !319
  %343 = add nsw i64 %341, 12544, !dbg !319
  %344 = select i1 %342, i64 %343, i64 %341, !dbg !319
  %345 = sdiv i64 %344, 112, !dbg !319
  %346 = srem i64 %333, 112, !dbg !319
  %347 = icmp slt i64 %346, 0, !dbg !319
  %348 = add nsw i64 %346, 112, !dbg !319
  %349 = select i1 %347, i64 %348, i64 %346, !dbg !319
  %350 = mul i64 %340, 12544, !dbg !319
  %351 = mul i64 %345, 112, !dbg !319
  %352 = add i64 %350, %351, !dbg !319
  %353 = add i64 %352, %349, !dbg !319
  %354 = getelementptr float, ptr %7, i64 %353, !dbg !319
  %355 = load <1 x float>, ptr %354, align 4, !dbg !319
  %356 = extractelement <1 x float> %355, i64 0, !dbg !319
  %357 = extractelement <4 x i64> %284, i64 3, !dbg !319
  %358 = sdiv i64 %357, 12544, !dbg !319
  %359 = mul i64 %358, 12544, !dbg !319
  %360 = icmp ne i64 %357, %359, !dbg !319
  %361 = icmp slt i64 %357, 0, !dbg !319
  %362 = and i1 %360, %361, !dbg !319
  %363 = add i64 %358, -1, !dbg !319
  %364 = select i1 %362, i64 %363, i64 %358, !dbg !319
  %365 = srem i64 %357, 12544, !dbg !319
  %366 = icmp slt i64 %365, 0, !dbg !319
  %367 = add nsw i64 %365, 12544, !dbg !319
  %368 = select i1 %366, i64 %367, i64 %365, !dbg !319
  %369 = sdiv i64 %368, 112, !dbg !319
  %370 = srem i64 %357, 112, !dbg !319
  %371 = icmp slt i64 %370, 0, !dbg !319
  %372 = add nsw i64 %370, 112, !dbg !319
  %373 = select i1 %371, i64 %372, i64 %370, !dbg !319
  %374 = mul i64 %364, 12544, !dbg !319
  %375 = mul i64 %369, 112, !dbg !319
  %376 = add i64 %374, %375, !dbg !319
  %377 = add i64 %376, %373, !dbg !319
  %378 = getelementptr float, ptr %7, i64 %377, !dbg !319
  %379 = load <1 x float>, ptr %378, align 4, !dbg !319
  %380 = extractelement <1 x float> %379, i64 0, !dbg !319
  %381 = add <4 x i64> %85, %283, !dbg !336
  %382 = extractelement <4 x i64> %381, i64 0, !dbg !336
  %383 = sdiv i64 %382, 12544, !dbg !336
  %384 = mul i64 %383, 12544, !dbg !336
  %385 = icmp ne i64 %382, %384, !dbg !336
  %386 = icmp slt i64 %382, 0, !dbg !336
  %387 = and i1 %385, %386, !dbg !336
  %388 = add i64 %383, -1, !dbg !336
  %389 = select i1 %387, i64 %388, i64 %383, !dbg !336
  %390 = srem i64 %382, 12544, !dbg !336
  %391 = icmp slt i64 %390, 0, !dbg !336
  %392 = add nsw i64 %390, 12544, !dbg !336
  %393 = select i1 %391, i64 %392, i64 %390, !dbg !336
  %394 = sdiv i64 %393, 112, !dbg !336
  %395 = srem i64 %382, 112, !dbg !336
  %396 = icmp slt i64 %395, 0, !dbg !336
  %397 = add nsw i64 %395, 112, !dbg !336
  %398 = select i1 %396, i64 %397, i64 %395, !dbg !336
  %399 = mul i64 %389, 12544, !dbg !336
  %400 = mul i64 %394, 112, !dbg !336
  %401 = add i64 %399, %400, !dbg !336
  %402 = add i64 %401, %398, !dbg !336
  %403 = getelementptr float, ptr %7, i64 %402, !dbg !336
  %404 = load <1 x float>, ptr %403, align 4, !dbg !336
  %405 = extractelement <1 x float> %404, i64 0, !dbg !336
  %406 = extractelement <4 x i64> %381, i64 1, !dbg !336
  %407 = sdiv i64 %406, 12544, !dbg !336
  %408 = mul i64 %407, 12544, !dbg !336
  %409 = icmp ne i64 %406, %408, !dbg !336
  %410 = icmp slt i64 %406, 0, !dbg !336
  %411 = and i1 %409, %410, !dbg !336
  %412 = add i64 %407, -1, !dbg !336
  %413 = select i1 %411, i64 %412, i64 %407, !dbg !336
  %414 = srem i64 %406, 12544, !dbg !336
  %415 = icmp slt i64 %414, 0, !dbg !336
  %416 = add nsw i64 %414, 12544, !dbg !336
  %417 = select i1 %415, i64 %416, i64 %414, !dbg !336
  %418 = sdiv i64 %417, 112, !dbg !336
  %419 = srem i64 %406, 112, !dbg !336
  %420 = icmp slt i64 %419, 0, !dbg !336
  %421 = add nsw i64 %419, 112, !dbg !336
  %422 = select i1 %420, i64 %421, i64 %419, !dbg !336
  %423 = mul i64 %413, 12544, !dbg !336
  %424 = mul i64 %418, 112, !dbg !336
  %425 = add i64 %423, %424, !dbg !336
  %426 = add i64 %425, %422, !dbg !336
  %427 = getelementptr float, ptr %7, i64 %426, !dbg !336
  %428 = load <1 x float>, ptr %427, align 4, !dbg !336
  %429 = extractelement <1 x float> %428, i64 0, !dbg !336
  %430 = extractelement <4 x i64> %381, i64 2, !dbg !336
  %431 = sdiv i64 %430, 12544, !dbg !336
  %432 = mul i64 %431, 12544, !dbg !336
  %433 = icmp ne i64 %430, %432, !dbg !336
  %434 = icmp slt i64 %430, 0, !dbg !336
  %435 = and i1 %433, %434, !dbg !336
  %436 = add i64 %431, -1, !dbg !336
  %437 = select i1 %435, i64 %436, i64 %431, !dbg !336
  %438 = srem i64 %430, 12544, !dbg !336
  %439 = icmp slt i64 %438, 0, !dbg !336
  %440 = add nsw i64 %438, 12544, !dbg !336
  %441 = select i1 %439, i64 %440, i64 %438, !dbg !336
  %442 = sdiv i64 %441, 112, !dbg !336
  %443 = srem i64 %430, 112, !dbg !336
  %444 = icmp slt i64 %443, 0, !dbg !336
  %445 = add nsw i64 %443, 112, !dbg !336
  %446 = select i1 %444, i64 %445, i64 %443, !dbg !336
  %447 = mul i64 %437, 12544, !dbg !336
  %448 = mul i64 %442, 112, !dbg !336
  %449 = add i64 %447, %448, !dbg !336
  %450 = add i64 %449, %446, !dbg !336
  %451 = getelementptr float, ptr %7, i64 %450, !dbg !336
  %452 = load <1 x float>, ptr %451, align 4, !dbg !336
  %453 = extractelement <1 x float> %452, i64 0, !dbg !336
  %454 = extractelement <4 x i64> %381, i64 3, !dbg !336
  %455 = sdiv i64 %454, 12544, !dbg !336
  %456 = mul i64 %455, 12544, !dbg !336
  %457 = icmp ne i64 %454, %456, !dbg !336
  %458 = icmp slt i64 %454, 0, !dbg !336
  %459 = and i1 %457, %458, !dbg !336
  %460 = add i64 %455, -1, !dbg !336
  %461 = select i1 %459, i64 %460, i64 %455, !dbg !336
  %462 = srem i64 %454, 12544, !dbg !336
  %463 = icmp slt i64 %462, 0, !dbg !336
  %464 = add nsw i64 %462, 12544, !dbg !336
  %465 = select i1 %463, i64 %464, i64 %462, !dbg !336
  %466 = sdiv i64 %465, 112, !dbg !336
  %467 = srem i64 %454, 112, !dbg !336
  %468 = icmp slt i64 %467, 0, !dbg !336
  %469 = add nsw i64 %467, 112, !dbg !336
  %470 = select i1 %468, i64 %469, i64 %467, !dbg !336
  %471 = mul i64 %461, 12544, !dbg !336
  %472 = mul i64 %466, 112, !dbg !336
  %473 = add i64 %471, %472, !dbg !336
  %474 = add i64 %473, %470, !dbg !336
  %475 = getelementptr float, ptr %7, i64 %474, !dbg !336
  %476 = load <1 x float>, ptr %475, align 4, !dbg !336
  %477 = extractelement <1 x float> %476, i64 0, !dbg !336
  %478 = fsub contract <4 x float> %80, %77, !dbg !337
  %479 = fsub contract <4 x float> %77, %78, !dbg !338
  %480 = insertelement <4 x float> poison, float %112, i64 0, !dbg !339
  %481 = insertelement <4 x float> %480, float %136, i64 1, !dbg !339
  %482 = insertelement <4 x float> %481, float %160, i64 2, !dbg !339
  %483 = insertelement <4 x float> %482, float %184, i64 3, !dbg !339
  %484 = fmul contract <4 x float> %478, %483, !dbg !339
  %485 = insertelement <4 x float> poison, float %209, i64 0, !dbg !340
  %486 = insertelement <4 x float> %485, float %233, i64 1, !dbg !340
  %487 = insertelement <4 x float> %486, float %257, i64 2, !dbg !340
  %488 = insertelement <4 x float> %487, float %281, i64 3, !dbg !340
  %489 = fmul contract <4 x float> %479, %488, !dbg !340
  %490 = fadd contract <4 x float> %484, %489, !dbg !341
  %491 = insertelement <4 x float> poison, float %58, i32 0, !dbg !342
  %492 = shufflevector <4 x float> %491, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !342
  %493 = fmul contract <4 x float> %492, %490, !dbg !342
  %494 = insertelement <4 x float> poison, float %308, i64 0, !dbg !343
  %495 = insertelement <4 x float> %494, float %332, i64 1, !dbg !343
  %496 = insertelement <4 x float> %495, float %356, i64 2, !dbg !343
  %497 = insertelement <4 x float> %496, float %380, i64 3, !dbg !343
  %498 = fmul contract <4 x float> %478, %497, !dbg !343
  %499 = insertelement <4 x float> poison, float %405, i64 0, !dbg !344
  %500 = insertelement <4 x float> %499, float %429, i64 1, !dbg !344
  %501 = insertelement <4 x float> %500, float %453, i64 2, !dbg !344
  %502 = insertelement <4 x float> %501, float %477, i64 3, !dbg !344
  %503 = fmul contract <4 x float> %479, %502, !dbg !344
  %504 = fadd contract <4 x float> %498, %503, !dbg !345
  %505 = insertelement <4 x float> poison, float %59, i32 0, !dbg !346
  %506 = shufflevector <4 x float> %505, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !346
  %507 = fmul contract <4 x float> %506, %504, !dbg !346
  %508 = fadd contract <4 x float> %493, %507, !dbg !347
  %509 = add i64 %38, 1, !dbg !304
  %510 = add i64 %64, 1, !dbg !304
  %511 = mul i64 %30, 51076, !dbg !304
  %512 = mul i64 %509, 226, !dbg !304
  %513 = add i64 %511, %512, !dbg !304
  %514 = add i64 %513, %510, !dbg !304
  %515 = getelementptr float, ptr %12, i64 %514, !dbg !304
  store <4 x float> %508, ptr %515, align 4, !dbg !304
  %516 = add i64 %61, 4, !dbg !304
  br label %60, !dbg !304

517:                                              ; preds = %60
  %518 = add i64 %35, 1, !dbg !304
  br label %34, !dbg !304

519:                                              ; preds = %34
  %520 = add i64 %30, 1, !dbg !304
  br label %29, !dbg !304

521:                                              ; preds = %29
  ret i32 0, !dbg !348
}

define internal i32 @infer_dispatch_16_conv_32x224x224x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !349 {
  %4 = alloca float, i64 4, align 64, !dbg !350
  %5 = alloca float, i64 4, align 64, !dbg !351
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !352
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !352
  %8 = load ptr, ptr %7, align 8, !dbg !352
  %9 = getelementptr float, ptr %8, i64 2408448, !dbg !352
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !352
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !353
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !353
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !353
  %13 = load ptr, ptr %12, align 8, !dbg !353
  %14 = getelementptr float, ptr %13, i64 1034048, !dbg !353
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !353
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !354
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !354
  %17 = load ptr, ptr %16, align 8, !dbg !354
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !354
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !355
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !355
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !355
  %21 = load ptr, ptr %20, align 8, !dbg !355
  %22 = getelementptr float, ptr %21, i64 5677312, !dbg !355
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !355
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !350
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !350
  %25 = zext i32 %24 to i64, !dbg !350
  %26 = sdiv i64 %25, 7, !dbg !350
  %27 = mul i64 %26, 7, !dbg !350
  %28 = icmp ne i64 %25, %27, !dbg !350
  %29 = icmp slt i64 %25, 0, !dbg !350
  %30 = and i1 %28, %29, !dbg !350
  %31 = add i64 %26, -1, !dbg !350
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !350
  %33 = srem i64 %25, 7, !dbg !350
  %34 = icmp slt i64 %33, 0, !dbg !350
  %35 = add nsw i64 %33, 7, !dbg !350
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !350
  %37 = mul nsw i64 %32, 32, !dbg !350
  %38 = mul nsw i64 %36, 32, !dbg !350
  %39 = getelementptr float, ptr %5, i64 0, !dbg !356
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !356
  br label %40, !dbg !350

40:                                               ; preds = %138, %3
  %41 = phi i64 [ %139, %138 ], [ 0, %3 ], !dbg !350
  %42 = icmp slt i64 %41, 32, !dbg !350
  br i1 %42, label %43, label %140, !dbg !350

43:                                               ; preds = %40
  %44 = getelementptr float, ptr @__constant_32xf32_0, i64 %41, !dbg !357
  %45 = load <1 x float>, ptr %44, align 4, !dbg !357
  br label %46, !dbg !350

46:                                               ; preds = %136, %43
  %47 = phi i64 [ %137, %136 ], [ 0, %43 ], !dbg !350
  %48 = icmp slt i64 %47, 32, !dbg !350
  br i1 %48, label %49, label %138, !dbg !350

49:                                               ; preds = %107, %46
  %50 = phi i64 [ %135, %107 ], [ 0, %46 ], !dbg !350
  %51 = icmp slt i64 %50, 32, !dbg !350
  br i1 %51, label %52, label %136, !dbg !350

52:                                               ; preds = %49
  %53 = add i64 %50, %38, !dbg !350
  br label %54, !dbg !350

54:                                               ; preds = %57, %52
  %55 = phi i64 [ %62, %57 ], [ 0, %52 ], !dbg !350
  %56 = icmp slt i64 %55, 4, !dbg !350
  br i1 %56, label %57, label %63, !dbg !350

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !350
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !350
  %60 = load float, ptr %59, align 4, !dbg !350
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !350
  store float %60, ptr %61, align 4, !dbg !350
  %62 = add i64 %55, 1, !dbg !350
  br label %54, !dbg !350

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !350
  %65 = icmp slt i64 %64, 64, !dbg !350
  br i1 %65, label %66, label %107, !dbg !350

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !350
  %68 = icmp slt i64 %67, 3, !dbg !350
  br i1 %68, label %69, label %105, !dbg !350

69:                                               ; preds = %66
  %70 = add i64 %67, %47, !dbg !350
  %71 = add i64 %70, %37, !dbg !350
  br label %72, !dbg !350

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !350
  %74 = icmp slt i64 %73, 4, !dbg !350
  br i1 %74, label %75, label %103, !dbg !350

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !350
  %77 = icmp slt i64 %76, 3, !dbg !350
  br i1 %77, label %78, label %101, !dbg !350

78:                                               ; preds = %75
  %79 = add i64 %53, %73, !dbg !350
  %80 = add i64 %79, %76, !dbg !350
  %81 = mul nuw nsw i64 %64, 51076, !dbg !350
  %82 = mul nuw nsw i64 %71, 226, !dbg !350
  %83 = add nuw nsw i64 %81, %82, !dbg !350
  %84 = add nuw nsw i64 %83, %80, !dbg !350
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !350
  %86 = load float, ptr %85, align 4, !dbg !350
  %87 = mul nuw nsw i64 %41, 576, !dbg !350
  %88 = mul nuw nsw i64 %64, 9, !dbg !350
  %89 = add nuw nsw i64 %87, %88, !dbg !350
  %90 = mul nuw nsw i64 %67, 3, !dbg !350
  %91 = add nuw nsw i64 %89, %90, !dbg !350
  %92 = add nuw nsw i64 %91, %76, !dbg !350
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !350
  %94 = load float, ptr %93, align 4, !dbg !350
  %95 = add nuw nsw i64 0, %73, !dbg !350
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !350
  %97 = load float, ptr %96, align 4, !dbg !350
  %98 = fmul contract float %86, %94, !dbg !358
  %99 = fadd contract float %97, %98, !dbg !359
  store float %99, ptr %96, align 4, !dbg !350
  %100 = add i64 %76, 1, !dbg !350
  br label %75, !dbg !350

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !350
  br label %72, !dbg !350

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !350
  br label %66, !dbg !350

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !350
  br label %63, !dbg !350

107:                                              ; preds = %63
  %108 = add i64 %47, %37, !dbg !357
  %109 = mul i64 %41, 50176, !dbg !357
  %110 = mul i64 %108, 224, !dbg !357
  %111 = add i64 %109, %110, !dbg !357
  %112 = add i64 %111, %53, !dbg !357
  %113 = getelementptr float, ptr %17, i64 %112, !dbg !357
  %114 = load <4 x float>, ptr %113, align 4, !dbg !357
  %115 = getelementptr float, ptr %4, i64 0, !dbg !357
  %116 = load <4 x float>, ptr %115, align 4, !dbg !357
  %117 = extractelement <1 x float> %45, i64 0, !dbg !360
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !360
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !360
  %120 = fadd contract <4 x float> %116, %119, !dbg !360
  %121 = fcmp olt <4 x float> zeroinitializer, %120, !dbg !361
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %120, !dbg !362
  %123 = fmul contract <4 x float> %122, splat (float 0x3FC99999A0000000), !dbg !363
  %124 = fcmp ogt <4 x float> zeroinitializer, %120, !dbg !364
  %125 = select <4 x i1> %124, <4 x float> zeroinitializer, <4 x float> %120, !dbg !365
  %126 = fadd contract <4 x float> %125, %123, !dbg !366
  %127 = fmul contract <4 x float> %114, %126, !dbg !367
  %128 = add i64 %108, 1, !dbg !350
  %129 = add i64 %53, 1, !dbg !350
  %130 = mul i64 %41, 51076, !dbg !350
  %131 = mul i64 %128, 226, !dbg !350
  %132 = add i64 %130, %131, !dbg !350
  %133 = add i64 %132, %129, !dbg !350
  %134 = getelementptr float, ptr %22, i64 %133, !dbg !350
  store <4 x float> %127, ptr %134, align 4, !dbg !350
  %135 = add i64 %50, 4, !dbg !350
  br label %49, !dbg !350

136:                                              ; preds = %49
  %137 = add i64 %47, 1, !dbg !350
  br label %46, !dbg !350

138:                                              ; preds = %46
  %139 = add i64 %41, 1, !dbg !350
  br label %40, !dbg !350

140:                                              ; preds = %40
  ret i32 0, !dbg !368
}

define internal i32 @infer_dispatch_17_conv_3x224x224x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !369 {
  %4 = alloca float, i64 4, align 64, !dbg !370
  %5 = alloca float, i64 4, align 64, !dbg !371
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !372
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !372
  %8 = load ptr, ptr %7, align 8, !dbg !372
  %9 = getelementptr float, ptr %8, i64 5677312, !dbg !372
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !372
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !373
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !373
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !373
  %13 = load ptr, ptr %12, align 8, !dbg !373
  %14 = getelementptr float, ptr %13, i64 1033184, !dbg !373
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !373
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !374
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !374
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !374
  %18 = load ptr, ptr %17, align 8, !dbg !374
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !374
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !375
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !375
  %21 = getelementptr ptr, ptr %20, i32 3, !dbg !375
  %22 = load ptr, ptr %21, align 8, !dbg !375
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !375
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !370
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !370
  %25 = zext i32 %24 to i64, !dbg !370
  %26 = sdiv i64 %25, 7, !dbg !370
  %27 = mul i64 %26, 7, !dbg !370
  %28 = icmp ne i64 %25, %27, !dbg !370
  %29 = icmp slt i64 %25, 0, !dbg !370
  %30 = and i1 %28, %29, !dbg !370
  %31 = add i64 %26, -1, !dbg !370
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !370
  %33 = srem i64 %25, 7, !dbg !370
  %34 = icmp slt i64 %33, 0, !dbg !370
  %35 = add nsw i64 %33, 7, !dbg !370
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !370
  %37 = mul nsw i64 %32, 32, !dbg !370
  %38 = mul nsw i64 %36, 32, !dbg !370
  %39 = getelementptr float, ptr %5, i64 0, !dbg !376
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !376
  br label %40, !dbg !370

40:                                               ; preds = %145, %3
  %41 = phi i64 [ %146, %145 ], [ 0, %3 ], !dbg !370
  %42 = icmp slt i64 %41, 3, !dbg !370
  br i1 %42, label %43, label %147, !dbg !370

43:                                               ; preds = %40
  %44 = getelementptr float, ptr @__constant_3xf32, i64 %41, !dbg !377
  %45 = load <1 x float>, ptr %44, align 4, !dbg !377
  br label %46, !dbg !370

46:                                               ; preds = %143, %43
  %47 = phi i64 [ %144, %143 ], [ 0, %43 ], !dbg !370
  %48 = icmp slt i64 %47, 32, !dbg !370
  br i1 %48, label %49, label %145, !dbg !370

49:                                               ; preds = %107, %46
  %50 = phi i64 [ %142, %107 ], [ 0, %46 ], !dbg !370
  %51 = icmp slt i64 %50, 32, !dbg !370
  br i1 %51, label %52, label %143, !dbg !370

52:                                               ; preds = %49
  %53 = add i64 %50, %38, !dbg !370
  br label %54, !dbg !370

54:                                               ; preds = %57, %52
  %55 = phi i64 [ %62, %57 ], [ 0, %52 ], !dbg !370
  %56 = icmp slt i64 %55, 4, !dbg !370
  br i1 %56, label %57, label %63, !dbg !370

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !370
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !370
  %60 = load float, ptr %59, align 4, !dbg !370
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !370
  store float %60, ptr %61, align 4, !dbg !370
  %62 = add i64 %55, 1, !dbg !370
  br label %54, !dbg !370

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !370
  %65 = icmp slt i64 %64, 32, !dbg !370
  br i1 %65, label %66, label %107, !dbg !370

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !370
  %68 = icmp slt i64 %67, 3, !dbg !370
  br i1 %68, label %69, label %105, !dbg !370

69:                                               ; preds = %66
  %70 = add i64 %67, %47, !dbg !370
  %71 = add i64 %70, %37, !dbg !370
  br label %72, !dbg !370

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !370
  %74 = icmp slt i64 %73, 4, !dbg !370
  br i1 %74, label %75, label %103, !dbg !370

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !370
  %77 = icmp slt i64 %76, 3, !dbg !370
  br i1 %77, label %78, label %101, !dbg !370

78:                                               ; preds = %75
  %79 = add i64 %53, %73, !dbg !370
  %80 = add i64 %79, %76, !dbg !370
  %81 = mul nuw nsw i64 %64, 51076, !dbg !370
  %82 = mul nuw nsw i64 %71, 226, !dbg !370
  %83 = add nuw nsw i64 %81, %82, !dbg !370
  %84 = add nuw nsw i64 %83, %80, !dbg !370
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !370
  %86 = load float, ptr %85, align 4, !dbg !370
  %87 = mul nuw nsw i64 %41, 288, !dbg !370
  %88 = mul nuw nsw i64 %64, 9, !dbg !370
  %89 = add nuw nsw i64 %87, %88, !dbg !370
  %90 = mul nuw nsw i64 %67, 3, !dbg !370
  %91 = add nuw nsw i64 %89, %90, !dbg !370
  %92 = add nuw nsw i64 %91, %76, !dbg !370
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !370
  %94 = load float, ptr %93, align 4, !dbg !370
  %95 = add nuw nsw i64 0, %73, !dbg !370
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !370
  %97 = load float, ptr %96, align 4, !dbg !370
  %98 = fmul contract float %86, %94, !dbg !378
  %99 = fadd contract float %97, %98, !dbg !379
  store float %99, ptr %96, align 4, !dbg !370
  %100 = add i64 %76, 1, !dbg !370
  br label %75, !dbg !370

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !370
  br label %72, !dbg !370

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !370
  br label %66, !dbg !370

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !370
  br label %63, !dbg !370

107:                                              ; preds = %63
  %108 = add i64 %47, %37, !dbg !377
  %109 = mul i64 %41, 50176, !dbg !377
  %110 = mul i64 %108, 224, !dbg !377
  %111 = add i64 %109, %110, !dbg !377
  %112 = add i64 %111, %53, !dbg !377
  %113 = getelementptr float, ptr %18, i64 %112, !dbg !377
  %114 = load <4 x float>, ptr %113, align 4, !dbg !377
  %115 = getelementptr float, ptr %4, i64 0, !dbg !377
  %116 = load <4 x float>, ptr %115, align 4, !dbg !377
  %117 = extractelement <1 x float> %45, i64 0, !dbg !380
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !380
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !380
  %120 = fadd contract <4 x float> %116, %119, !dbg !380
  %121 = fcmp ult <4 x float> %120, splat (float 0x401FFEC880000000), !dbg !381
  %122 = select <4 x i1> %121, <4 x float> %120, <4 x float> splat (float 0x401FFEC880000000), !dbg !381
  %123 = fcmp ugt <4 x float> %122, splat (float 0xC01FFEC880000000), !dbg !381
  %124 = select <4 x i1> %123, <4 x float> %122, <4 x float> splat (float 0xC01FFEC880000000), !dbg !381
  %125 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %120), !dbg !381
  %126 = fcmp olt <4 x float> %125, splat (float 0x3F3A36E2E0000000), !dbg !381
  %127 = fmul contract <4 x float> %124, %124, !dbg !381
  %128 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> splat (float 0xBCB3E4B800000000), <4 x float> splat (float 0x3D4C266FC0000000)), !dbg !381
  %129 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %128, <4 x float> splat (float 0xBDD7A6FFE0000000)), !dbg !381
  %130 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %129, <4 x float> splat (float 0x3E6B800820000000)), !dbg !381
  %131 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %130, <4 x float> splat (float 0x3EEF286940000000)), !dbg !381
  %132 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %131, <4 x float> splat (float 0x3F44E1BDA0000000)), !dbg !381
  %133 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %132, <4 x float> splat (float 0x3F740B3B80000000)), !dbg !381
  %134 = fmul contract <4 x float> %124, %133, !dbg !381
  %135 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> splat (float 0x3EB41A7B00000000), <4 x float> splat (float 0x3F1F12BAC0000000)), !dbg !381
  %136 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %135, <4 x float> splat (float 0x3F629540A0000000)), !dbg !381
  %137 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %136, <4 x float> splat (float 0x3F740B3BA0000000)), !dbg !381
  %138 = fdiv <4 x float> %134, %137, !dbg !381
  %139 = select <4 x i1> %126, <4 x float> %124, <4 x float> %138, !dbg !381
  %140 = fadd contract <4 x float> %114, %139, !dbg !382
  %141 = getelementptr float, ptr %22, i64 %112, !dbg !370
  store <4 x float> %140, ptr %141, align 4, !dbg !370
  %142 = add i64 %50, 4, !dbg !370
  br label %49, !dbg !370

143:                                              ; preds = %49
  %144 = add i64 %47, 1, !dbg !370
  br label %46, !dbg !370

145:                                              ; preds = %46
  %146 = add i64 %41, 1, !dbg !370
  br label %40, !dbg !370

147:                                              ; preds = %40
  ret i32 0, !dbg !383
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.floor.f32(float) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.floor.v4f32(<4 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fabs.v4f32(<4 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>) #2

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
  store i16 %36, ptr %2, align 4, !tbaa !384
  %37 = load float, ptr %2, align 4, !tbaa !386
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
  store i16 %37, ptr %2, align 4, !tbaa !384
  %38 = load float, ptr %2, align 4, !tbaa !386
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
  store volatile float %5, ptr %3, align 4, !tbaa !386
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !386
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
  store volatile float %16, ptr %3, align 4, !tbaa !386
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
  store volatile float %24, ptr %2, align 4, !tbaa !386
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
  br i1 %.not, label %19, label %6, !prof !388

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
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !389
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !392
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !393
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !395
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !395
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !395
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
  store volatile float %16, ptr %3, align 4, !tbaa !386
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
  store volatile float %23, ptr %2, align 4, !tbaa !386
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
  store volatile float %2, ptr %4, align 4, !tbaa !386
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !386
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
  br i1 %or.cond99, label %.critedge, label %73, !prof !396

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !388

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
  br i1 %31, label %47, label %32, !prof !388

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
  store volatile float %46, ptr %3, align 4, !tbaa !386
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !386
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
  %82 = load double, ptr %81, align 8, !tbaa !397
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !399
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !395
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !395
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !395
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !395
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !395
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !400

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
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !401
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !393
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !395
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !395
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !395
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
  store volatile float %9, ptr %2, align 4, !tbaa !386
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
!168 = !DILocation(line: 11, column: 8, scope: !165)
!169 = !DILocation(line: 12, column: 8, scope: !165)
!170 = !DILocation(line: 17, column: 8, scope: !165)
!171 = !DILocation(line: 18, column: 8, scope: !165)
!172 = !DILocation(line: 19, column: 8, scope: !165)
!173 = !DILocation(line: 20, column: 8, scope: !165)
!174 = !DILocation(line: 22, column: 8, scope: !165)
!175 = !DILocation(line: 26, column: 8, scope: !165)
!176 = distinct !DISubprogram(name: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", scope: !11, file: !11, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!177 = !DILocation(line: 34, column: 8, scope: !176)
!178 = !DILocation(line: 33, column: 8, scope: !176)
!179 = !DILocation(line: 11, column: 8, scope: !176)
!180 = !DILocation(line: 12, column: 8, scope: !176)
!181 = !DILocation(line: 13, column: 8, scope: !176)
!182 = !DILocation(line: 14, column: 8, scope: !176)
!183 = !DILocation(line: 15, column: 8, scope: !176)
!184 = !DILocation(line: 16, column: 8, scope: !176)
!185 = !DILocation(line: 17, column: 8, scope: !176)
!186 = !DILocation(line: 18, column: 8, scope: !176)
!187 = !DILocation(line: 25, column: 8, scope: !176)
!188 = !DILocation(line: 26, column: 8, scope: !176)
!189 = !DILocation(line: 27, column: 8, scope: !176)
!190 = !DILocation(line: 28, column: 8, scope: !176)
!191 = !DILocation(line: 10, column: 8, scope: !176)
!192 = !DILocation(line: 40, column: 8, scope: !176)
!193 = !DILocation(line: 36, column: 10, scope: !176)
!194 = !DILocation(line: 37, column: 10, scope: !176)
!195 = !DILocation(line: 42, column: 10, scope: !176)
!196 = !DILocation(line: 43, column: 10, scope: !176)
!197 = !DILocation(line: 44, column: 10, scope: !176)
!198 = !DILocation(line: 45, column: 10, scope: !176)
!199 = !DILocation(line: 46, column: 10, scope: !176)
!200 = !DILocation(line: 47, column: 10, scope: !176)
!201 = !DILocation(line: 48, column: 10, scope: !176)
!202 = !DILocation(line: 52, column: 8, scope: !176)
!203 = distinct !DISubprogram(name: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", scope: !13, file: !13, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!204 = !DILocation(line: 39, column: 8, scope: !203)
!205 = !DILocation(line: 38, column: 8, scope: !203)
!206 = !DILocation(line: 11, column: 8, scope: !203)
!207 = !DILocation(line: 12, column: 8, scope: !203)
!208 = !DILocation(line: 13, column: 8, scope: !203)
!209 = !DILocation(line: 14, column: 8, scope: !203)
!210 = !DILocation(line: 15, column: 8, scope: !203)
!211 = !DILocation(line: 16, column: 8, scope: !203)
!212 = !DILocation(line: 17, column: 8, scope: !203)
!213 = !DILocation(line: 18, column: 8, scope: !203)
!214 = !DILocation(line: 19, column: 8, scope: !203)
!215 = !DILocation(line: 20, column: 8, scope: !203)
!216 = !DILocation(line: 28, column: 8, scope: !203)
!217 = !DILocation(line: 29, column: 8, scope: !203)
!218 = !DILocation(line: 30, column: 8, scope: !203)
!219 = !DILocation(line: 31, column: 8, scope: !203)
!220 = !DILocation(line: 32, column: 8, scope: !203)
!221 = !DILocation(line: 10, column: 8, scope: !203)
!222 = !DILocation(line: 45, column: 8, scope: !203)
!223 = !DILocation(line: 41, column: 10, scope: !203)
!224 = !DILocation(line: 42, column: 10, scope: !203)
!225 = !DILocation(line: 47, column: 10, scope: !203)
!226 = !DILocation(line: 48, column: 10, scope: !203)
!227 = !DILocation(line: 49, column: 10, scope: !203)
!228 = !DILocation(line: 50, column: 10, scope: !203)
!229 = !DILocation(line: 51, column: 10, scope: !203)
!230 = !DILocation(line: 52, column: 10, scope: !203)
!231 = !DILocation(line: 53, column: 10, scope: !203)
!232 = !DILocation(line: 54, column: 10, scope: !203)
!233 = !DILocation(line: 58, column: 8, scope: !203)
!234 = distinct !DISubprogram(name: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", linkageName: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", scope: !15, file: !15, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!235 = !DILocation(line: 15, column: 8, scope: !234)
!236 = !DILocation(line: 16, column: 8, scope: !234)
!237 = !DILocation(line: 19, column: 8, scope: !234)
!238 = !DILocation(line: 21, column: 10, scope: !234)
!239 = !DILocation(line: 54, column: 10, scope: !234)
!240 = !DILocation(line: 22, column: 10, scope: !234)
!241 = !DILocation(line: 25, column: 10, scope: !234)
!242 = !DILocation(line: 26, column: 10, scope: !234)
!243 = !DILocation(line: 27, column: 10, scope: !234)
!244 = !DILocation(line: 28, column: 10, scope: !234)
!245 = !DILocation(line: 29, column: 10, scope: !234)
!246 = !DILocation(line: 30, column: 10, scope: !234)
!247 = !DILocation(line: 38, column: 10, scope: !234)
!248 = !DILocation(line: 39, column: 10, scope: !234)
!249 = !DILocation(line: 40, column: 10, scope: !234)
!250 = !DILocation(line: 41, column: 10, scope: !234)
!251 = !DILocation(line: 43, column: 10, scope: !234)
!252 = !DILocation(line: 44, column: 10, scope: !234)
!253 = !DILocation(line: 56, column: 10, scope: !234)
!254 = !DILocation(line: 58, column: 10, scope: !234)
!255 = !DILocation(line: 59, column: 10, scope: !234)
!256 = !DILocation(line: 23, column: 10, scope: !234)
!257 = !DILocation(line: 32, column: 10, scope: !234)
!258 = !DILocation(line: 33, column: 10, scope: !234)
!259 = !DILocation(line: 34, column: 10, scope: !234)
!260 = !DILocation(line: 35, column: 10, scope: !234)
!261 = !DILocation(line: 36, column: 10, scope: !234)
!262 = !DILocation(line: 37, column: 10, scope: !234)
!263 = !DILocation(line: 46, column: 10, scope: !234)
!264 = !DILocation(line: 47, column: 10, scope: !234)
!265 = !DILocation(line: 48, column: 10, scope: !234)
!266 = !DILocation(line: 49, column: 10, scope: !234)
!267 = !DILocation(line: 51, column: 10, scope: !234)
!268 = !DILocation(line: 52, column: 10, scope: !234)
!269 = !DILocation(line: 55, column: 10, scope: !234)
!270 = !DILocation(line: 57, column: 10, scope: !234)
!271 = !DILocation(line: 60, column: 10, scope: !234)
!272 = !DILocation(line: 61, column: 10, scope: !234)
!273 = !DILocation(line: 62, column: 10, scope: !234)
!274 = !DILocation(line: 63, column: 10, scope: !234)
!275 = !DILocation(line: 64, column: 10, scope: !234)
!276 = !DILocation(line: 65, column: 10, scope: !234)
!277 = !DILocation(line: 66, column: 10, scope: !234)
!278 = !DILocation(line: 67, column: 10, scope: !234)
!279 = !DILocation(line: 68, column: 10, scope: !234)
!280 = !DILocation(line: 69, column: 10, scope: !234)
!281 = !DILocation(line: 70, column: 10, scope: !234)
!282 = !DILocation(line: 74, column: 8, scope: !234)
!283 = distinct !DISubprogram(name: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", linkageName: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", scope: !17, file: !17, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!284 = !DILocation(line: 22, column: 8, scope: !283)
!285 = !DILocation(line: 21, column: 8, scope: !283)
!286 = !DILocation(line: 15, column: 8, scope: !283)
!287 = !DILocation(line: 16, column: 8, scope: !283)
!288 = !DILocation(line: 17, column: 8, scope: !283)
!289 = !DILocation(line: 9, column: 8, scope: !283)
!290 = !DILocation(line: 28, column: 8, scope: !283)
!291 = !DILocation(line: 24, column: 10, scope: !283)
!292 = !DILocation(line: 25, column: 10, scope: !283)
!293 = !DILocation(line: 30, column: 10, scope: !283)
!294 = !DILocation(line: 31, column: 10, scope: !283)
!295 = !DILocation(line: 32, column: 10, scope: !283)
!296 = !DILocation(line: 33, column: 10, scope: !283)
!297 = !DILocation(line: 34, column: 10, scope: !283)
!298 = !DILocation(line: 35, column: 10, scope: !283)
!299 = !DILocation(line: 36, column: 10, scope: !283)
!300 = !DILocation(line: 40, column: 8, scope: !283)
!301 = distinct !DISubprogram(name: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", linkageName: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", scope: !19, file: !19, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!302 = !DILocation(line: 16, column: 8, scope: !301)
!303 = !DILocation(line: 17, column: 8, scope: !301)
!304 = !DILocation(line: 20, column: 8, scope: !301)
!305 = !DILocation(line: 55, column: 10, scope: !301)
!306 = !DILocation(line: 23, column: 10, scope: !301)
!307 = !DILocation(line: 26, column: 10, scope: !301)
!308 = !DILocation(line: 27, column: 10, scope: !301)
!309 = !DILocation(line: 28, column: 10, scope: !301)
!310 = !DILocation(line: 29, column: 10, scope: !301)
!311 = !DILocation(line: 30, column: 10, scope: !301)
!312 = !DILocation(line: 31, column: 10, scope: !301)
!313 = !DILocation(line: 39, column: 10, scope: !301)
!314 = !DILocation(line: 40, column: 10, scope: !301)
!315 = !DILocation(line: 41, column: 10, scope: !301)
!316 = !DILocation(line: 42, column: 10, scope: !301)
!317 = !DILocation(line: 44, column: 10, scope: !301)
!318 = !DILocation(line: 45, column: 10, scope: !301)
!319 = !DILocation(line: 57, column: 10, scope: !301)
!320 = !DILocation(line: 59, column: 10, scope: !301)
!321 = !DILocation(line: 60, column: 10, scope: !301)
!322 = !DILocation(line: 24, column: 10, scope: !301)
!323 = !DILocation(line: 33, column: 10, scope: !301)
!324 = !DILocation(line: 34, column: 10, scope: !301)
!325 = !DILocation(line: 35, column: 10, scope: !301)
!326 = !DILocation(line: 36, column: 10, scope: !301)
!327 = !DILocation(line: 37, column: 10, scope: !301)
!328 = !DILocation(line: 38, column: 10, scope: !301)
!329 = !DILocation(line: 47, column: 10, scope: !301)
!330 = !DILocation(line: 48, column: 10, scope: !301)
!331 = !DILocation(line: 49, column: 10, scope: !301)
!332 = !DILocation(line: 50, column: 10, scope: !301)
!333 = !DILocation(line: 52, column: 10, scope: !301)
!334 = !DILocation(line: 53, column: 10, scope: !301)
!335 = !DILocation(line: 56, column: 10, scope: !301)
!336 = !DILocation(line: 58, column: 10, scope: !301)
!337 = !DILocation(line: 61, column: 10, scope: !301)
!338 = !DILocation(line: 62, column: 10, scope: !301)
!339 = !DILocation(line: 63, column: 10, scope: !301)
!340 = !DILocation(line: 64, column: 10, scope: !301)
!341 = !DILocation(line: 65, column: 10, scope: !301)
!342 = !DILocation(line: 66, column: 10, scope: !301)
!343 = !DILocation(line: 67, column: 10, scope: !301)
!344 = !DILocation(line: 68, column: 10, scope: !301)
!345 = !DILocation(line: 69, column: 10, scope: !301)
!346 = !DILocation(line: 70, column: 10, scope: !301)
!347 = !DILocation(line: 71, column: 10, scope: !301)
!348 = !DILocation(line: 75, column: 8, scope: !301)
!349 = distinct !DISubprogram(name: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", linkageName: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", scope: !21, file: !21, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!350 = !DILocation(line: 25, column: 8, scope: !349)
!351 = !DILocation(line: 24, column: 8, scope: !349)
!352 = !DILocation(line: 16, column: 8, scope: !349)
!353 = !DILocation(line: 17, column: 8, scope: !349)
!354 = !DILocation(line: 18, column: 8, scope: !349)
!355 = !DILocation(line: 19, column: 8, scope: !349)
!356 = !DILocation(line: 9, column: 8, scope: !349)
!357 = !DILocation(line: 31, column: 8, scope: !349)
!358 = !DILocation(line: 27, column: 10, scope: !349)
!359 = !DILocation(line: 28, column: 10, scope: !349)
!360 = !DILocation(line: 33, column: 10, scope: !349)
!361 = !DILocation(line: 34, column: 10, scope: !349)
!362 = !DILocation(line: 35, column: 10, scope: !349)
!363 = !DILocation(line: 36, column: 10, scope: !349)
!364 = !DILocation(line: 37, column: 10, scope: !349)
!365 = !DILocation(line: 38, column: 10, scope: !349)
!366 = !DILocation(line: 39, column: 10, scope: !349)
!367 = !DILocation(line: 40, column: 10, scope: !349)
!368 = !DILocation(line: 44, column: 8, scope: !349)
!369 = distinct !DISubprogram(name: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", linkageName: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", scope: !23, file: !23, line: 1, type: !32, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!370 = !DILocation(line: 23, column: 8, scope: !369)
!371 = !DILocation(line: 22, column: 8, scope: !369)
!372 = !DILocation(line: 14, column: 8, scope: !369)
!373 = !DILocation(line: 15, column: 8, scope: !369)
!374 = !DILocation(line: 16, column: 8, scope: !369)
!375 = !DILocation(line: 17, column: 8, scope: !369)
!376 = !DILocation(line: 9, column: 8, scope: !369)
!377 = !DILocation(line: 29, column: 8, scope: !369)
!378 = !DILocation(line: 25, column: 10, scope: !369)
!379 = !DILocation(line: 26, column: 10, scope: !369)
!380 = !DILocation(line: 31, column: 10, scope: !369)
!381 = !DILocation(line: 32, column: 10, scope: !369)
!382 = !DILocation(line: 33, column: 10, scope: !369)
!383 = !DILocation(line: 37, column: 8, scope: !369)
!384 = !{!385, !385, i64 0}
!385 = !{!"short", !29, i64 0}
!386 = !{!387, !387, i64 0}
!387 = !{!"float", !29, i64 0}
!388 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!389 = !{!390, !391, i64 296}
!390 = !{!"exp2f_data", !29, i64 0, !391, i64 256, !29, i64 264, !391, i64 288, !391, i64 296, !29, i64 304}
!391 = !{!"double", !29, i64 0}
!392 = !{!390, !391, i64 288}
!393 = !{!394, !394, i64 0}
!394 = !{!"long", !29, i64 0}
!395 = !{!391, !391, i64 0}
!396 = !{!"branch_weights", i32 4001, i32 4000000}
!397 = !{!398, !391, i64 0}
!398 = !{!"", !391, i64 0, !391, i64 8}
!399 = !{!398, !391, i64 8}
!400 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!401 = !{!390, !391, i64 256}
