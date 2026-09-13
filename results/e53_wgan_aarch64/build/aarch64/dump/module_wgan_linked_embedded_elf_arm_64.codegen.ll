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

define internal i32 @infer_dispatch_0_matmul_like_32x50176x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !25 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !101
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !101
  %6 = load ptr, ptr %5, align 8, !dbg !101
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !101
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !102
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !102
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !102
  %10 = load ptr, ptr %9, align 8, !dbg !102
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !102
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !103
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !103
  %13 = getelementptr ptr, ptr %12, i32 2, !dbg !103
  %14 = load ptr, ptr %13, align 8, !dbg !103
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !103
  %15 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !104
  %16 = extractvalue %iree_hal_executable_workgroup_state_v0_t %15, 0, !dbg !104
  %17 = zext i32 %16 to i64, !dbg !104
  %18 = mul nsw i64 %17, 64, !dbg !104
  br label %19, !dbg !104

19:                                               ; preds = %854, %3
  %20 = phi i64 [ %855, %854 ], [ 0, %3 ], !dbg !104
  %21 = icmp slt i64 %20, 32, !dbg !104
  br i1 %21, label %22, label %856, !dbg !104

22:                                               ; preds = %19
  %23 = getelementptr float, ptr @__constant_32xf32, i64 %20, !dbg !105
  %24 = load <8 x float>, ptr %23, align 4, !dbg !105
  %25 = shufflevector <8 x float> %24, <8 x float> %24, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !105
  %26 = shufflevector <128 x float> %25, <128 x float> poison, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %27 = shufflevector <128 x float> %25, <128 x float> %26, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %28 = shufflevector <128 x float> %25, <128 x float> %27, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %29 = shufflevector <128 x float> %25, <128 x float> %28, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %30 = shufflevector <128 x float> %25, <128 x float> %29, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %31 = shufflevector <128 x float> %25, <128 x float> %30, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %32 = shufflevector <128 x float> %25, <128 x float> %31, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %33 = shufflevector <128 x float> %25, <128 x float> %32, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %34 = shufflevector <128 x float> %25, <128 x float> %33, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %35 = shufflevector <128 x float> %25, <128 x float> %34, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %36 = shufflevector <128 x float> %25, <128 x float> %35, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %37 = shufflevector <128 x float> %25, <128 x float> %36, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %38 = shufflevector <128 x float> %25, <128 x float> %37, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %39 = shufflevector <128 x float> %25, <128 x float> %38, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %40 = shufflevector <128 x float> %25, <128 x float> %39, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 248, i32 249, i32 250, i32 251, i32 252, i32 253, i32 254, i32 255>, !dbg !105
  %41 = shufflevector <128 x float> %25, <128 x float> %40, <128 x i32> <i32 128, i32 129, i32 130, i32 131, i32 132, i32 133, i32 134, i32 135, i32 136, i32 137, i32 138, i32 139, i32 140, i32 141, i32 142, i32 143, i32 144, i32 145, i32 146, i32 147, i32 148, i32 149, i32 150, i32 151, i32 152, i32 153, i32 154, i32 155, i32 156, i32 157, i32 158, i32 159, i32 160, i32 161, i32 162, i32 163, i32 164, i32 165, i32 166, i32 167, i32 168, i32 169, i32 170, i32 171, i32 172, i32 173, i32 174, i32 175, i32 176, i32 177, i32 178, i32 179, i32 180, i32 181, i32 182, i32 183, i32 184, i32 185, i32 186, i32 187, i32 188, i32 189, i32 190, i32 191, i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199, i32 200, i32 201, i32 202, i32 203, i32 204, i32 205, i32 206, i32 207, i32 208, i32 209, i32 210, i32 211, i32 212, i32 213, i32 214, i32 215, i32 216, i32 217, i32 218, i32 219, i32 220, i32 221, i32 222, i32 223, i32 224, i32 225, i32 226, i32 227, i32 228, i32 229, i32 230, i32 231, i32 232, i32 233, i32 234, i32 235, i32 236, i32 237, i32 238, i32 239, i32 240, i32 241, i32 242, i32 243, i32 244, i32 245, i32 246, i32 247, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>, !dbg !105
  %42 = shufflevector <128 x float> %41, <128 x float> %41, <128 x i32> <i32 0, i32 8, i32 16, i32 24, i32 32, i32 40, i32 48, i32 56, i32 64, i32 72, i32 80, i32 88, i32 96, i32 104, i32 112, i32 120, i32 1, i32 9, i32 17, i32 25, i32 33, i32 41, i32 49, i32 57, i32 65, i32 73, i32 81, i32 89, i32 97, i32 105, i32 113, i32 121, i32 2, i32 10, i32 18, i32 26, i32 34, i32 42, i32 50, i32 58, i32 66, i32 74, i32 82, i32 90, i32 98, i32 106, i32 114, i32 122, i32 3, i32 11, i32 19, i32 27, i32 35, i32 43, i32 51, i32 59, i32 67, i32 75, i32 83, i32 91, i32 99, i32 107, i32 115, i32 123, i32 4, i32 12, i32 20, i32 28, i32 36, i32 44, i32 52, i32 60, i32 68, i32 76, i32 84, i32 92, i32 100, i32 108, i32 116, i32 124, i32 5, i32 13, i32 21, i32 29, i32 37, i32 45, i32 53, i32 61, i32 69, i32 77, i32 85, i32 93, i32 101, i32 109, i32 117, i32 125, i32 6, i32 14, i32 22, i32 30, i32 38, i32 46, i32 54, i32 62, i32 70, i32 78, i32 86, i32 94, i32 102, i32 110, i32 118, i32 126, i32 7, i32 15, i32 23, i32 31, i32 39, i32 47, i32 55, i32 63, i32 71, i32 79, i32 87, i32 95, i32 103, i32 111, i32 119, i32 127>, !dbg !105
  %43 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>, !dbg !105
  %44 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !105
  %45 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>, !dbg !105
  %46 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>, !dbg !105
  %47 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79>, !dbg !105
  %48 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>, !dbg !105
  %49 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111>, !dbg !105
  %50 = shufflevector <128 x float> %42, <128 x float> %42, <16 x i32> <i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>, !dbg !105
  br label %51, !dbg !104

51:                                               ; preds = %756, %22
  %52 = phi i64 [ %853, %756 ], [ 0, %22 ], !dbg !104
  %53 = icmp slt i64 %52, 64, !dbg !104
  br i1 %53, label %54, label %854, !dbg !104

54:                                               ; preds = %58, %51
  %55 = phi i64 [ %755, %58 ], [ 0, %51 ], !dbg !104
  %56 = phi [8 x <16 x float>] [ %754, %58 ], [ zeroinitializer, %51 ], !dbg !104
  %57 = icmp slt i64 %55, 3, !dbg !104
  br i1 %57, label %58, label %756, !dbg !104

58:                                               ; preds = %54
  %59 = mul i64 %20, 3, !dbg !104
  %60 = add i64 %59, %55, !dbg !104
  %61 = getelementptr float, ptr %10, i64 %60, !dbg !104
  %62 = load <1 x float>, ptr %61, align 4, !dbg !104
  %63 = add i64 %20, 1, !dbg !104
  %64 = mul i64 %63, 3, !dbg !104
  %65 = add i64 %64, %55, !dbg !104
  %66 = getelementptr float, ptr %10, i64 %65, !dbg !104
  %67 = load <1 x float>, ptr %66, align 4, !dbg !104
  %68 = add i64 %20, 2, !dbg !104
  %69 = mul i64 %68, 3, !dbg !104
  %70 = add i64 %69, %55, !dbg !104
  %71 = getelementptr float, ptr %10, i64 %70, !dbg !104
  %72 = load <1 x float>, ptr %71, align 4, !dbg !104
  %73 = add i64 %20, 3, !dbg !104
  %74 = mul i64 %73, 3, !dbg !104
  %75 = add i64 %74, %55, !dbg !104
  %76 = getelementptr float, ptr %10, i64 %75, !dbg !104
  %77 = load <1 x float>, ptr %76, align 4, !dbg !104
  %78 = add i64 %20, 4, !dbg !104
  %79 = mul i64 %78, 3, !dbg !104
  %80 = add i64 %79, %55, !dbg !104
  %81 = getelementptr float, ptr %10, i64 %80, !dbg !104
  %82 = load <1 x float>, ptr %81, align 4, !dbg !104
  %83 = add i64 %20, 5, !dbg !104
  %84 = mul i64 %83, 3, !dbg !104
  %85 = add i64 %84, %55, !dbg !104
  %86 = getelementptr float, ptr %10, i64 %85, !dbg !104
  %87 = load <1 x float>, ptr %86, align 4, !dbg !104
  %88 = add i64 %20, 6, !dbg !104
  %89 = mul i64 %88, 3, !dbg !104
  %90 = add i64 %89, %55, !dbg !104
  %91 = getelementptr float, ptr %10, i64 %90, !dbg !104
  %92 = load <1 x float>, ptr %91, align 4, !dbg !104
  %93 = add i64 %20, 7, !dbg !104
  %94 = mul i64 %93, 3, !dbg !104
  %95 = add i64 %94, %55, !dbg !104
  %96 = getelementptr float, ptr %10, i64 %95, !dbg !104
  %97 = load <1 x float>, ptr %96, align 4, !dbg !104
  %98 = extractelement <1 x float> %62, i64 0, !dbg !104
  %99 = extractelement <1 x float> %67, i64 0, !dbg !104
  %100 = extractelement <1 x float> %72, i64 0, !dbg !104
  %101 = extractelement <1 x float> %77, i64 0, !dbg !104
  %102 = extractelement <1 x float> %82, i64 0, !dbg !104
  %103 = extractelement <1 x float> %87, i64 0, !dbg !104
  %104 = extractelement <1 x float> %92, i64 0, !dbg !104
  %105 = extractelement <1 x float> %97, i64 0, !dbg !104
  %106 = add i64 %52, %18, !dbg !106
  %107 = mul nuw nsw i64 %55, 50176, !dbg !106
  %108 = add nuw nsw i64 %107, %106, !dbg !106
  %109 = getelementptr inbounds nuw float, ptr %6, i64 %108, !dbg !106
  %110 = load float, ptr %109, align 4, !dbg !106
  %111 = extractvalue [8 x <16 x float>] %56, 0, !dbg !106
  %112 = extractelement <16 x float> %111, i64 0, !dbg !106
  %113 = extractvalue [8 x <16 x float>] %56, 1, !dbg !106
  %114 = extractelement <16 x float> %113, i64 0, !dbg !106
  %115 = extractvalue [8 x <16 x float>] %56, 2, !dbg !106
  %116 = extractelement <16 x float> %115, i64 0, !dbg !106
  %117 = extractvalue [8 x <16 x float>] %56, 3, !dbg !106
  %118 = extractelement <16 x float> %117, i64 0, !dbg !106
  %119 = extractvalue [8 x <16 x float>] %56, 4, !dbg !106
  %120 = extractelement <16 x float> %119, i64 0, !dbg !106
  %121 = extractvalue [8 x <16 x float>] %56, 5, !dbg !106
  %122 = extractelement <16 x float> %121, i64 0, !dbg !106
  %123 = extractvalue [8 x <16 x float>] %56, 6, !dbg !106
  %124 = extractelement <16 x float> %123, i64 0, !dbg !106
  %125 = extractvalue [8 x <16 x float>] %56, 7, !dbg !106
  %126 = extractelement <16 x float> %125, i64 0, !dbg !106
  %127 = insertelement <8 x float> poison, float %112, i64 0, !dbg !106
  %128 = insertelement <8 x float> %127, float %114, i64 1, !dbg !106
  %129 = insertelement <8 x float> %128, float %116, i64 2, !dbg !106
  %130 = insertelement <8 x float> %129, float %118, i64 3, !dbg !106
  %131 = insertelement <8 x float> %130, float %120, i64 4, !dbg !106
  %132 = insertelement <8 x float> %131, float %122, i64 5, !dbg !106
  %133 = insertelement <8 x float> %132, float %124, i64 6, !dbg !106
  %134 = insertelement <8 x float> %133, float %126, i64 7, !dbg !106
  %135 = insertelement <8 x float> poison, float %98, i64 0, !dbg !106
  %136 = insertelement <8 x float> %135, float %99, i64 1, !dbg !106
  %137 = insertelement <8 x float> %136, float %100, i64 2, !dbg !106
  %138 = insertelement <8 x float> %137, float %101, i64 3, !dbg !106
  %139 = insertelement <8 x float> %138, float %102, i64 4, !dbg !106
  %140 = insertelement <8 x float> %139, float %103, i64 5, !dbg !106
  %141 = insertelement <8 x float> %140, float %104, i64 6, !dbg !106
  %142 = insertelement <8 x float> %141, float %105, i64 7, !dbg !106
  %143 = insertelement <8 x float> poison, float %110, i32 0, !dbg !106
  %144 = shufflevector <8 x float> %143, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %145 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %144, <8 x float> %134), !dbg !106
  %146 = extractelement <8 x float> %145, i64 0, !dbg !106
  %147 = extractelement <8 x float> %145, i64 1, !dbg !106
  %148 = extractelement <8 x float> %145, i64 2, !dbg !106
  %149 = extractelement <8 x float> %145, i64 3, !dbg !106
  %150 = extractelement <8 x float> %145, i64 4, !dbg !106
  %151 = extractelement <8 x float> %145, i64 5, !dbg !106
  %152 = extractelement <8 x float> %145, i64 6, !dbg !106
  %153 = extractelement <8 x float> %145, i64 7, !dbg !106
  %154 = add i64 %106, 1, !dbg !106
  %155 = add nuw nsw i64 %107, %154, !dbg !106
  %156 = getelementptr inbounds nuw float, ptr %6, i64 %155, !dbg !106
  %157 = load float, ptr %156, align 4, !dbg !106
  %158 = extractelement <16 x float> %111, i64 1, !dbg !106
  %159 = extractelement <16 x float> %113, i64 1, !dbg !106
  %160 = extractelement <16 x float> %115, i64 1, !dbg !106
  %161 = extractelement <16 x float> %117, i64 1, !dbg !106
  %162 = extractelement <16 x float> %119, i64 1, !dbg !106
  %163 = extractelement <16 x float> %121, i64 1, !dbg !106
  %164 = extractelement <16 x float> %123, i64 1, !dbg !106
  %165 = extractelement <16 x float> %125, i64 1, !dbg !106
  %166 = insertelement <8 x float> poison, float %158, i64 0, !dbg !106
  %167 = insertelement <8 x float> %166, float %159, i64 1, !dbg !106
  %168 = insertelement <8 x float> %167, float %160, i64 2, !dbg !106
  %169 = insertelement <8 x float> %168, float %161, i64 3, !dbg !106
  %170 = insertelement <8 x float> %169, float %162, i64 4, !dbg !106
  %171 = insertelement <8 x float> %170, float %163, i64 5, !dbg !106
  %172 = insertelement <8 x float> %171, float %164, i64 6, !dbg !106
  %173 = insertelement <8 x float> %172, float %165, i64 7, !dbg !106
  %174 = insertelement <8 x float> poison, float %157, i32 0, !dbg !106
  %175 = shufflevector <8 x float> %174, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %176 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %175, <8 x float> %173), !dbg !106
  %177 = extractelement <8 x float> %176, i64 0, !dbg !106
  %178 = extractelement <8 x float> %176, i64 1, !dbg !106
  %179 = extractelement <8 x float> %176, i64 2, !dbg !106
  %180 = extractelement <8 x float> %176, i64 3, !dbg !106
  %181 = extractelement <8 x float> %176, i64 4, !dbg !106
  %182 = extractelement <8 x float> %176, i64 5, !dbg !106
  %183 = extractelement <8 x float> %176, i64 6, !dbg !106
  %184 = extractelement <8 x float> %176, i64 7, !dbg !106
  %185 = add i64 %106, 2, !dbg !106
  %186 = add nuw nsw i64 %107, %185, !dbg !106
  %187 = getelementptr inbounds nuw float, ptr %6, i64 %186, !dbg !106
  %188 = load float, ptr %187, align 4, !dbg !106
  %189 = extractelement <16 x float> %111, i64 2, !dbg !106
  %190 = extractelement <16 x float> %113, i64 2, !dbg !106
  %191 = extractelement <16 x float> %115, i64 2, !dbg !106
  %192 = extractelement <16 x float> %117, i64 2, !dbg !106
  %193 = extractelement <16 x float> %119, i64 2, !dbg !106
  %194 = extractelement <16 x float> %121, i64 2, !dbg !106
  %195 = extractelement <16 x float> %123, i64 2, !dbg !106
  %196 = extractelement <16 x float> %125, i64 2, !dbg !106
  %197 = insertelement <8 x float> poison, float %189, i64 0, !dbg !106
  %198 = insertelement <8 x float> %197, float %190, i64 1, !dbg !106
  %199 = insertelement <8 x float> %198, float %191, i64 2, !dbg !106
  %200 = insertelement <8 x float> %199, float %192, i64 3, !dbg !106
  %201 = insertelement <8 x float> %200, float %193, i64 4, !dbg !106
  %202 = insertelement <8 x float> %201, float %194, i64 5, !dbg !106
  %203 = insertelement <8 x float> %202, float %195, i64 6, !dbg !106
  %204 = insertelement <8 x float> %203, float %196, i64 7, !dbg !106
  %205 = insertelement <8 x float> poison, float %188, i32 0, !dbg !106
  %206 = shufflevector <8 x float> %205, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %207 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %206, <8 x float> %204), !dbg !106
  %208 = extractelement <8 x float> %207, i64 0, !dbg !106
  %209 = extractelement <8 x float> %207, i64 1, !dbg !106
  %210 = extractelement <8 x float> %207, i64 2, !dbg !106
  %211 = extractelement <8 x float> %207, i64 3, !dbg !106
  %212 = extractelement <8 x float> %207, i64 4, !dbg !106
  %213 = extractelement <8 x float> %207, i64 5, !dbg !106
  %214 = extractelement <8 x float> %207, i64 6, !dbg !106
  %215 = extractelement <8 x float> %207, i64 7, !dbg !106
  %216 = add i64 %106, 3, !dbg !106
  %217 = add nuw nsw i64 %107, %216, !dbg !106
  %218 = getelementptr inbounds nuw float, ptr %6, i64 %217, !dbg !106
  %219 = load float, ptr %218, align 4, !dbg !106
  %220 = extractelement <16 x float> %111, i64 3, !dbg !106
  %221 = extractelement <16 x float> %113, i64 3, !dbg !106
  %222 = extractelement <16 x float> %115, i64 3, !dbg !106
  %223 = extractelement <16 x float> %117, i64 3, !dbg !106
  %224 = extractelement <16 x float> %119, i64 3, !dbg !106
  %225 = extractelement <16 x float> %121, i64 3, !dbg !106
  %226 = extractelement <16 x float> %123, i64 3, !dbg !106
  %227 = extractelement <16 x float> %125, i64 3, !dbg !106
  %228 = insertelement <8 x float> poison, float %220, i64 0, !dbg !106
  %229 = insertelement <8 x float> %228, float %221, i64 1, !dbg !106
  %230 = insertelement <8 x float> %229, float %222, i64 2, !dbg !106
  %231 = insertelement <8 x float> %230, float %223, i64 3, !dbg !106
  %232 = insertelement <8 x float> %231, float %224, i64 4, !dbg !106
  %233 = insertelement <8 x float> %232, float %225, i64 5, !dbg !106
  %234 = insertelement <8 x float> %233, float %226, i64 6, !dbg !106
  %235 = insertelement <8 x float> %234, float %227, i64 7, !dbg !106
  %236 = insertelement <8 x float> poison, float %219, i32 0, !dbg !106
  %237 = shufflevector <8 x float> %236, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %238 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %237, <8 x float> %235), !dbg !106
  %239 = extractelement <8 x float> %238, i64 0, !dbg !106
  %240 = extractelement <8 x float> %238, i64 1, !dbg !106
  %241 = extractelement <8 x float> %238, i64 2, !dbg !106
  %242 = extractelement <8 x float> %238, i64 3, !dbg !106
  %243 = extractelement <8 x float> %238, i64 4, !dbg !106
  %244 = extractelement <8 x float> %238, i64 5, !dbg !106
  %245 = extractelement <8 x float> %238, i64 6, !dbg !106
  %246 = extractelement <8 x float> %238, i64 7, !dbg !106
  %247 = add i64 %106, 4, !dbg !106
  %248 = add nuw nsw i64 %107, %247, !dbg !106
  %249 = getelementptr inbounds nuw float, ptr %6, i64 %248, !dbg !106
  %250 = load float, ptr %249, align 4, !dbg !106
  %251 = extractelement <16 x float> %111, i64 4, !dbg !106
  %252 = extractelement <16 x float> %113, i64 4, !dbg !106
  %253 = extractelement <16 x float> %115, i64 4, !dbg !106
  %254 = extractelement <16 x float> %117, i64 4, !dbg !106
  %255 = extractelement <16 x float> %119, i64 4, !dbg !106
  %256 = extractelement <16 x float> %121, i64 4, !dbg !106
  %257 = extractelement <16 x float> %123, i64 4, !dbg !106
  %258 = extractelement <16 x float> %125, i64 4, !dbg !106
  %259 = insertelement <8 x float> poison, float %251, i64 0, !dbg !106
  %260 = insertelement <8 x float> %259, float %252, i64 1, !dbg !106
  %261 = insertelement <8 x float> %260, float %253, i64 2, !dbg !106
  %262 = insertelement <8 x float> %261, float %254, i64 3, !dbg !106
  %263 = insertelement <8 x float> %262, float %255, i64 4, !dbg !106
  %264 = insertelement <8 x float> %263, float %256, i64 5, !dbg !106
  %265 = insertelement <8 x float> %264, float %257, i64 6, !dbg !106
  %266 = insertelement <8 x float> %265, float %258, i64 7, !dbg !106
  %267 = insertelement <8 x float> poison, float %250, i32 0, !dbg !106
  %268 = shufflevector <8 x float> %267, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %269 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %268, <8 x float> %266), !dbg !106
  %270 = extractelement <8 x float> %269, i64 0, !dbg !106
  %271 = extractelement <8 x float> %269, i64 1, !dbg !106
  %272 = extractelement <8 x float> %269, i64 2, !dbg !106
  %273 = extractelement <8 x float> %269, i64 3, !dbg !106
  %274 = extractelement <8 x float> %269, i64 4, !dbg !106
  %275 = extractelement <8 x float> %269, i64 5, !dbg !106
  %276 = extractelement <8 x float> %269, i64 6, !dbg !106
  %277 = extractelement <8 x float> %269, i64 7, !dbg !106
  %278 = add i64 %106, 5, !dbg !106
  %279 = add nuw nsw i64 %107, %278, !dbg !106
  %280 = getelementptr inbounds nuw float, ptr %6, i64 %279, !dbg !106
  %281 = load float, ptr %280, align 4, !dbg !106
  %282 = extractelement <16 x float> %111, i64 5, !dbg !106
  %283 = extractelement <16 x float> %113, i64 5, !dbg !106
  %284 = extractelement <16 x float> %115, i64 5, !dbg !106
  %285 = extractelement <16 x float> %117, i64 5, !dbg !106
  %286 = extractelement <16 x float> %119, i64 5, !dbg !106
  %287 = extractelement <16 x float> %121, i64 5, !dbg !106
  %288 = extractelement <16 x float> %123, i64 5, !dbg !106
  %289 = extractelement <16 x float> %125, i64 5, !dbg !106
  %290 = insertelement <8 x float> poison, float %282, i64 0, !dbg !106
  %291 = insertelement <8 x float> %290, float %283, i64 1, !dbg !106
  %292 = insertelement <8 x float> %291, float %284, i64 2, !dbg !106
  %293 = insertelement <8 x float> %292, float %285, i64 3, !dbg !106
  %294 = insertelement <8 x float> %293, float %286, i64 4, !dbg !106
  %295 = insertelement <8 x float> %294, float %287, i64 5, !dbg !106
  %296 = insertelement <8 x float> %295, float %288, i64 6, !dbg !106
  %297 = insertelement <8 x float> %296, float %289, i64 7, !dbg !106
  %298 = insertelement <8 x float> poison, float %281, i32 0, !dbg !106
  %299 = shufflevector <8 x float> %298, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %300 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %299, <8 x float> %297), !dbg !106
  %301 = extractelement <8 x float> %300, i64 0, !dbg !106
  %302 = extractelement <8 x float> %300, i64 1, !dbg !106
  %303 = extractelement <8 x float> %300, i64 2, !dbg !106
  %304 = extractelement <8 x float> %300, i64 3, !dbg !106
  %305 = extractelement <8 x float> %300, i64 4, !dbg !106
  %306 = extractelement <8 x float> %300, i64 5, !dbg !106
  %307 = extractelement <8 x float> %300, i64 6, !dbg !106
  %308 = extractelement <8 x float> %300, i64 7, !dbg !106
  %309 = add i64 %106, 6, !dbg !106
  %310 = add nuw nsw i64 %107, %309, !dbg !106
  %311 = getelementptr inbounds nuw float, ptr %6, i64 %310, !dbg !106
  %312 = load float, ptr %311, align 4, !dbg !106
  %313 = extractelement <16 x float> %111, i64 6, !dbg !106
  %314 = extractelement <16 x float> %113, i64 6, !dbg !106
  %315 = extractelement <16 x float> %115, i64 6, !dbg !106
  %316 = extractelement <16 x float> %117, i64 6, !dbg !106
  %317 = extractelement <16 x float> %119, i64 6, !dbg !106
  %318 = extractelement <16 x float> %121, i64 6, !dbg !106
  %319 = extractelement <16 x float> %123, i64 6, !dbg !106
  %320 = extractelement <16 x float> %125, i64 6, !dbg !106
  %321 = insertelement <8 x float> poison, float %313, i64 0, !dbg !106
  %322 = insertelement <8 x float> %321, float %314, i64 1, !dbg !106
  %323 = insertelement <8 x float> %322, float %315, i64 2, !dbg !106
  %324 = insertelement <8 x float> %323, float %316, i64 3, !dbg !106
  %325 = insertelement <8 x float> %324, float %317, i64 4, !dbg !106
  %326 = insertelement <8 x float> %325, float %318, i64 5, !dbg !106
  %327 = insertelement <8 x float> %326, float %319, i64 6, !dbg !106
  %328 = insertelement <8 x float> %327, float %320, i64 7, !dbg !106
  %329 = insertelement <8 x float> poison, float %312, i32 0, !dbg !106
  %330 = shufflevector <8 x float> %329, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %331 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %330, <8 x float> %328), !dbg !106
  %332 = extractelement <8 x float> %331, i64 0, !dbg !106
  %333 = extractelement <8 x float> %331, i64 1, !dbg !106
  %334 = extractelement <8 x float> %331, i64 2, !dbg !106
  %335 = extractelement <8 x float> %331, i64 3, !dbg !106
  %336 = extractelement <8 x float> %331, i64 4, !dbg !106
  %337 = extractelement <8 x float> %331, i64 5, !dbg !106
  %338 = extractelement <8 x float> %331, i64 6, !dbg !106
  %339 = extractelement <8 x float> %331, i64 7, !dbg !106
  %340 = add i64 %106, 7, !dbg !106
  %341 = add nuw nsw i64 %107, %340, !dbg !106
  %342 = getelementptr inbounds nuw float, ptr %6, i64 %341, !dbg !106
  %343 = load float, ptr %342, align 4, !dbg !106
  %344 = extractelement <16 x float> %111, i64 7, !dbg !106
  %345 = extractelement <16 x float> %113, i64 7, !dbg !106
  %346 = extractelement <16 x float> %115, i64 7, !dbg !106
  %347 = extractelement <16 x float> %117, i64 7, !dbg !106
  %348 = extractelement <16 x float> %119, i64 7, !dbg !106
  %349 = extractelement <16 x float> %121, i64 7, !dbg !106
  %350 = extractelement <16 x float> %123, i64 7, !dbg !106
  %351 = extractelement <16 x float> %125, i64 7, !dbg !106
  %352 = insertelement <8 x float> poison, float %344, i64 0, !dbg !106
  %353 = insertelement <8 x float> %352, float %345, i64 1, !dbg !106
  %354 = insertelement <8 x float> %353, float %346, i64 2, !dbg !106
  %355 = insertelement <8 x float> %354, float %347, i64 3, !dbg !106
  %356 = insertelement <8 x float> %355, float %348, i64 4, !dbg !106
  %357 = insertelement <8 x float> %356, float %349, i64 5, !dbg !106
  %358 = insertelement <8 x float> %357, float %350, i64 6, !dbg !106
  %359 = insertelement <8 x float> %358, float %351, i64 7, !dbg !106
  %360 = insertelement <8 x float> poison, float %343, i32 0, !dbg !106
  %361 = shufflevector <8 x float> %360, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %362 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %361, <8 x float> %359), !dbg !106
  %363 = extractelement <8 x float> %362, i64 0, !dbg !106
  %364 = extractelement <8 x float> %362, i64 1, !dbg !106
  %365 = extractelement <8 x float> %362, i64 2, !dbg !106
  %366 = extractelement <8 x float> %362, i64 3, !dbg !106
  %367 = extractelement <8 x float> %362, i64 4, !dbg !106
  %368 = extractelement <8 x float> %362, i64 5, !dbg !106
  %369 = extractelement <8 x float> %362, i64 6, !dbg !106
  %370 = extractelement <8 x float> %362, i64 7, !dbg !106
  %371 = add i64 %106, 8, !dbg !106
  %372 = add nuw nsw i64 %107, %371, !dbg !106
  %373 = getelementptr inbounds nuw float, ptr %6, i64 %372, !dbg !106
  %374 = load float, ptr %373, align 4, !dbg !106
  %375 = extractelement <16 x float> %111, i64 8, !dbg !106
  %376 = extractelement <16 x float> %113, i64 8, !dbg !106
  %377 = extractelement <16 x float> %115, i64 8, !dbg !106
  %378 = extractelement <16 x float> %117, i64 8, !dbg !106
  %379 = extractelement <16 x float> %119, i64 8, !dbg !106
  %380 = extractelement <16 x float> %121, i64 8, !dbg !106
  %381 = extractelement <16 x float> %123, i64 8, !dbg !106
  %382 = extractelement <16 x float> %125, i64 8, !dbg !106
  %383 = insertelement <8 x float> poison, float %375, i64 0, !dbg !106
  %384 = insertelement <8 x float> %383, float %376, i64 1, !dbg !106
  %385 = insertelement <8 x float> %384, float %377, i64 2, !dbg !106
  %386 = insertelement <8 x float> %385, float %378, i64 3, !dbg !106
  %387 = insertelement <8 x float> %386, float %379, i64 4, !dbg !106
  %388 = insertelement <8 x float> %387, float %380, i64 5, !dbg !106
  %389 = insertelement <8 x float> %388, float %381, i64 6, !dbg !106
  %390 = insertelement <8 x float> %389, float %382, i64 7, !dbg !106
  %391 = insertelement <8 x float> poison, float %374, i32 0, !dbg !106
  %392 = shufflevector <8 x float> %391, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %393 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %392, <8 x float> %390), !dbg !106
  %394 = extractelement <8 x float> %393, i64 0, !dbg !106
  %395 = extractelement <8 x float> %393, i64 1, !dbg !106
  %396 = extractelement <8 x float> %393, i64 2, !dbg !106
  %397 = extractelement <8 x float> %393, i64 3, !dbg !106
  %398 = extractelement <8 x float> %393, i64 4, !dbg !106
  %399 = extractelement <8 x float> %393, i64 5, !dbg !106
  %400 = extractelement <8 x float> %393, i64 6, !dbg !106
  %401 = extractelement <8 x float> %393, i64 7, !dbg !106
  %402 = add i64 %106, 9, !dbg !106
  %403 = add nuw nsw i64 %107, %402, !dbg !106
  %404 = getelementptr inbounds nuw float, ptr %6, i64 %403, !dbg !106
  %405 = load float, ptr %404, align 4, !dbg !106
  %406 = extractelement <16 x float> %111, i64 9, !dbg !106
  %407 = extractelement <16 x float> %113, i64 9, !dbg !106
  %408 = extractelement <16 x float> %115, i64 9, !dbg !106
  %409 = extractelement <16 x float> %117, i64 9, !dbg !106
  %410 = extractelement <16 x float> %119, i64 9, !dbg !106
  %411 = extractelement <16 x float> %121, i64 9, !dbg !106
  %412 = extractelement <16 x float> %123, i64 9, !dbg !106
  %413 = extractelement <16 x float> %125, i64 9, !dbg !106
  %414 = insertelement <8 x float> poison, float %406, i64 0, !dbg !106
  %415 = insertelement <8 x float> %414, float %407, i64 1, !dbg !106
  %416 = insertelement <8 x float> %415, float %408, i64 2, !dbg !106
  %417 = insertelement <8 x float> %416, float %409, i64 3, !dbg !106
  %418 = insertelement <8 x float> %417, float %410, i64 4, !dbg !106
  %419 = insertelement <8 x float> %418, float %411, i64 5, !dbg !106
  %420 = insertelement <8 x float> %419, float %412, i64 6, !dbg !106
  %421 = insertelement <8 x float> %420, float %413, i64 7, !dbg !106
  %422 = insertelement <8 x float> poison, float %405, i32 0, !dbg !106
  %423 = shufflevector <8 x float> %422, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %424 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %423, <8 x float> %421), !dbg !106
  %425 = extractelement <8 x float> %424, i64 0, !dbg !106
  %426 = extractelement <8 x float> %424, i64 1, !dbg !106
  %427 = extractelement <8 x float> %424, i64 2, !dbg !106
  %428 = extractelement <8 x float> %424, i64 3, !dbg !106
  %429 = extractelement <8 x float> %424, i64 4, !dbg !106
  %430 = extractelement <8 x float> %424, i64 5, !dbg !106
  %431 = extractelement <8 x float> %424, i64 6, !dbg !106
  %432 = extractelement <8 x float> %424, i64 7, !dbg !106
  %433 = add i64 %106, 10, !dbg !106
  %434 = add nuw nsw i64 %107, %433, !dbg !106
  %435 = getelementptr inbounds nuw float, ptr %6, i64 %434, !dbg !106
  %436 = load float, ptr %435, align 4, !dbg !106
  %437 = extractelement <16 x float> %111, i64 10, !dbg !106
  %438 = extractelement <16 x float> %113, i64 10, !dbg !106
  %439 = extractelement <16 x float> %115, i64 10, !dbg !106
  %440 = extractelement <16 x float> %117, i64 10, !dbg !106
  %441 = extractelement <16 x float> %119, i64 10, !dbg !106
  %442 = extractelement <16 x float> %121, i64 10, !dbg !106
  %443 = extractelement <16 x float> %123, i64 10, !dbg !106
  %444 = extractelement <16 x float> %125, i64 10, !dbg !106
  %445 = insertelement <8 x float> poison, float %437, i64 0, !dbg !106
  %446 = insertelement <8 x float> %445, float %438, i64 1, !dbg !106
  %447 = insertelement <8 x float> %446, float %439, i64 2, !dbg !106
  %448 = insertelement <8 x float> %447, float %440, i64 3, !dbg !106
  %449 = insertelement <8 x float> %448, float %441, i64 4, !dbg !106
  %450 = insertelement <8 x float> %449, float %442, i64 5, !dbg !106
  %451 = insertelement <8 x float> %450, float %443, i64 6, !dbg !106
  %452 = insertelement <8 x float> %451, float %444, i64 7, !dbg !106
  %453 = insertelement <8 x float> poison, float %436, i32 0, !dbg !106
  %454 = shufflevector <8 x float> %453, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %455 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %454, <8 x float> %452), !dbg !106
  %456 = extractelement <8 x float> %455, i64 0, !dbg !106
  %457 = extractelement <8 x float> %455, i64 1, !dbg !106
  %458 = extractelement <8 x float> %455, i64 2, !dbg !106
  %459 = extractelement <8 x float> %455, i64 3, !dbg !106
  %460 = extractelement <8 x float> %455, i64 4, !dbg !106
  %461 = extractelement <8 x float> %455, i64 5, !dbg !106
  %462 = extractelement <8 x float> %455, i64 6, !dbg !106
  %463 = extractelement <8 x float> %455, i64 7, !dbg !106
  %464 = add i64 %106, 11, !dbg !106
  %465 = add nuw nsw i64 %107, %464, !dbg !106
  %466 = getelementptr inbounds nuw float, ptr %6, i64 %465, !dbg !106
  %467 = load float, ptr %466, align 4, !dbg !106
  %468 = extractelement <16 x float> %111, i64 11, !dbg !106
  %469 = extractelement <16 x float> %113, i64 11, !dbg !106
  %470 = extractelement <16 x float> %115, i64 11, !dbg !106
  %471 = extractelement <16 x float> %117, i64 11, !dbg !106
  %472 = extractelement <16 x float> %119, i64 11, !dbg !106
  %473 = extractelement <16 x float> %121, i64 11, !dbg !106
  %474 = extractelement <16 x float> %123, i64 11, !dbg !106
  %475 = extractelement <16 x float> %125, i64 11, !dbg !106
  %476 = insertelement <8 x float> poison, float %468, i64 0, !dbg !106
  %477 = insertelement <8 x float> %476, float %469, i64 1, !dbg !106
  %478 = insertelement <8 x float> %477, float %470, i64 2, !dbg !106
  %479 = insertelement <8 x float> %478, float %471, i64 3, !dbg !106
  %480 = insertelement <8 x float> %479, float %472, i64 4, !dbg !106
  %481 = insertelement <8 x float> %480, float %473, i64 5, !dbg !106
  %482 = insertelement <8 x float> %481, float %474, i64 6, !dbg !106
  %483 = insertelement <8 x float> %482, float %475, i64 7, !dbg !106
  %484 = insertelement <8 x float> poison, float %467, i32 0, !dbg !106
  %485 = shufflevector <8 x float> %484, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %486 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %485, <8 x float> %483), !dbg !106
  %487 = extractelement <8 x float> %486, i64 0, !dbg !106
  %488 = extractelement <8 x float> %486, i64 1, !dbg !106
  %489 = extractelement <8 x float> %486, i64 2, !dbg !106
  %490 = extractelement <8 x float> %486, i64 3, !dbg !106
  %491 = extractelement <8 x float> %486, i64 4, !dbg !106
  %492 = extractelement <8 x float> %486, i64 5, !dbg !106
  %493 = extractelement <8 x float> %486, i64 6, !dbg !106
  %494 = extractelement <8 x float> %486, i64 7, !dbg !106
  %495 = add i64 %106, 12, !dbg !106
  %496 = add nuw nsw i64 %107, %495, !dbg !106
  %497 = getelementptr inbounds nuw float, ptr %6, i64 %496, !dbg !106
  %498 = load float, ptr %497, align 4, !dbg !106
  %499 = extractelement <16 x float> %111, i64 12, !dbg !106
  %500 = extractelement <16 x float> %113, i64 12, !dbg !106
  %501 = extractelement <16 x float> %115, i64 12, !dbg !106
  %502 = extractelement <16 x float> %117, i64 12, !dbg !106
  %503 = extractelement <16 x float> %119, i64 12, !dbg !106
  %504 = extractelement <16 x float> %121, i64 12, !dbg !106
  %505 = extractelement <16 x float> %123, i64 12, !dbg !106
  %506 = extractelement <16 x float> %125, i64 12, !dbg !106
  %507 = insertelement <8 x float> poison, float %499, i64 0, !dbg !106
  %508 = insertelement <8 x float> %507, float %500, i64 1, !dbg !106
  %509 = insertelement <8 x float> %508, float %501, i64 2, !dbg !106
  %510 = insertelement <8 x float> %509, float %502, i64 3, !dbg !106
  %511 = insertelement <8 x float> %510, float %503, i64 4, !dbg !106
  %512 = insertelement <8 x float> %511, float %504, i64 5, !dbg !106
  %513 = insertelement <8 x float> %512, float %505, i64 6, !dbg !106
  %514 = insertelement <8 x float> %513, float %506, i64 7, !dbg !106
  %515 = insertelement <8 x float> poison, float %498, i32 0, !dbg !106
  %516 = shufflevector <8 x float> %515, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %517 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %516, <8 x float> %514), !dbg !106
  %518 = extractelement <8 x float> %517, i64 0, !dbg !106
  %519 = extractelement <8 x float> %517, i64 1, !dbg !106
  %520 = extractelement <8 x float> %517, i64 2, !dbg !106
  %521 = extractelement <8 x float> %517, i64 3, !dbg !106
  %522 = extractelement <8 x float> %517, i64 4, !dbg !106
  %523 = extractelement <8 x float> %517, i64 5, !dbg !106
  %524 = extractelement <8 x float> %517, i64 6, !dbg !106
  %525 = extractelement <8 x float> %517, i64 7, !dbg !106
  %526 = add i64 %106, 13, !dbg !106
  %527 = add nuw nsw i64 %107, %526, !dbg !106
  %528 = getelementptr inbounds nuw float, ptr %6, i64 %527, !dbg !106
  %529 = load float, ptr %528, align 4, !dbg !106
  %530 = extractelement <16 x float> %111, i64 13, !dbg !106
  %531 = extractelement <16 x float> %113, i64 13, !dbg !106
  %532 = extractelement <16 x float> %115, i64 13, !dbg !106
  %533 = extractelement <16 x float> %117, i64 13, !dbg !106
  %534 = extractelement <16 x float> %119, i64 13, !dbg !106
  %535 = extractelement <16 x float> %121, i64 13, !dbg !106
  %536 = extractelement <16 x float> %123, i64 13, !dbg !106
  %537 = extractelement <16 x float> %125, i64 13, !dbg !106
  %538 = insertelement <8 x float> poison, float %530, i64 0, !dbg !106
  %539 = insertelement <8 x float> %538, float %531, i64 1, !dbg !106
  %540 = insertelement <8 x float> %539, float %532, i64 2, !dbg !106
  %541 = insertelement <8 x float> %540, float %533, i64 3, !dbg !106
  %542 = insertelement <8 x float> %541, float %534, i64 4, !dbg !106
  %543 = insertelement <8 x float> %542, float %535, i64 5, !dbg !106
  %544 = insertelement <8 x float> %543, float %536, i64 6, !dbg !106
  %545 = insertelement <8 x float> %544, float %537, i64 7, !dbg !106
  %546 = insertelement <8 x float> poison, float %529, i32 0, !dbg !106
  %547 = shufflevector <8 x float> %546, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %548 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %547, <8 x float> %545), !dbg !106
  %549 = extractelement <8 x float> %548, i64 0, !dbg !106
  %550 = extractelement <8 x float> %548, i64 1, !dbg !106
  %551 = extractelement <8 x float> %548, i64 2, !dbg !106
  %552 = extractelement <8 x float> %548, i64 3, !dbg !106
  %553 = extractelement <8 x float> %548, i64 4, !dbg !106
  %554 = extractelement <8 x float> %548, i64 5, !dbg !106
  %555 = extractelement <8 x float> %548, i64 6, !dbg !106
  %556 = extractelement <8 x float> %548, i64 7, !dbg !106
  %557 = add i64 %106, 14, !dbg !106
  %558 = add nuw nsw i64 %107, %557, !dbg !106
  %559 = getelementptr inbounds nuw float, ptr %6, i64 %558, !dbg !106
  %560 = load float, ptr %559, align 4, !dbg !106
  %561 = extractelement <16 x float> %111, i64 14, !dbg !106
  %562 = extractelement <16 x float> %113, i64 14, !dbg !106
  %563 = extractelement <16 x float> %115, i64 14, !dbg !106
  %564 = extractelement <16 x float> %117, i64 14, !dbg !106
  %565 = extractelement <16 x float> %119, i64 14, !dbg !106
  %566 = extractelement <16 x float> %121, i64 14, !dbg !106
  %567 = extractelement <16 x float> %123, i64 14, !dbg !106
  %568 = extractelement <16 x float> %125, i64 14, !dbg !106
  %569 = insertelement <8 x float> poison, float %561, i64 0, !dbg !106
  %570 = insertelement <8 x float> %569, float %562, i64 1, !dbg !106
  %571 = insertelement <8 x float> %570, float %563, i64 2, !dbg !106
  %572 = insertelement <8 x float> %571, float %564, i64 3, !dbg !106
  %573 = insertelement <8 x float> %572, float %565, i64 4, !dbg !106
  %574 = insertelement <8 x float> %573, float %566, i64 5, !dbg !106
  %575 = insertelement <8 x float> %574, float %567, i64 6, !dbg !106
  %576 = insertelement <8 x float> %575, float %568, i64 7, !dbg !106
  %577 = insertelement <8 x float> poison, float %560, i32 0, !dbg !106
  %578 = shufflevector <8 x float> %577, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %579 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %578, <8 x float> %576), !dbg !106
  %580 = extractelement <8 x float> %579, i64 0, !dbg !106
  %581 = extractelement <8 x float> %579, i64 1, !dbg !106
  %582 = extractelement <8 x float> %579, i64 2, !dbg !106
  %583 = extractelement <8 x float> %579, i64 3, !dbg !106
  %584 = extractelement <8 x float> %579, i64 4, !dbg !106
  %585 = extractelement <8 x float> %579, i64 5, !dbg !106
  %586 = extractelement <8 x float> %579, i64 6, !dbg !106
  %587 = extractelement <8 x float> %579, i64 7, !dbg !106
  %588 = add i64 %106, 15, !dbg !106
  %589 = add nuw nsw i64 %107, %588, !dbg !106
  %590 = getelementptr inbounds nuw float, ptr %6, i64 %589, !dbg !106
  %591 = load float, ptr %590, align 4, !dbg !106
  %592 = extractelement <16 x float> %111, i64 15, !dbg !106
  %593 = extractelement <16 x float> %113, i64 15, !dbg !106
  %594 = extractelement <16 x float> %115, i64 15, !dbg !106
  %595 = extractelement <16 x float> %117, i64 15, !dbg !106
  %596 = extractelement <16 x float> %119, i64 15, !dbg !106
  %597 = extractelement <16 x float> %121, i64 15, !dbg !106
  %598 = extractelement <16 x float> %123, i64 15, !dbg !106
  %599 = extractelement <16 x float> %125, i64 15, !dbg !106
  %600 = insertelement <8 x float> poison, float %592, i64 0, !dbg !106
  %601 = insertelement <8 x float> %600, float %593, i64 1, !dbg !106
  %602 = insertelement <8 x float> %601, float %594, i64 2, !dbg !106
  %603 = insertelement <8 x float> %602, float %595, i64 3, !dbg !106
  %604 = insertelement <8 x float> %603, float %596, i64 4, !dbg !106
  %605 = insertelement <8 x float> %604, float %597, i64 5, !dbg !106
  %606 = insertelement <8 x float> %605, float %598, i64 6, !dbg !106
  %607 = insertelement <8 x float> %606, float %599, i64 7, !dbg !106
  %608 = insertelement <8 x float> poison, float %591, i32 0, !dbg !106
  %609 = shufflevector <8 x float> %608, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !106
  %610 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %142, <8 x float> %609, <8 x float> %607), !dbg !106
  %611 = extractelement <8 x float> %610, i64 0, !dbg !106
  %612 = extractelement <8 x float> %610, i64 1, !dbg !106
  %613 = extractelement <8 x float> %610, i64 2, !dbg !106
  %614 = extractelement <8 x float> %610, i64 3, !dbg !106
  %615 = extractelement <8 x float> %610, i64 4, !dbg !106
  %616 = extractelement <8 x float> %610, i64 5, !dbg !106
  %617 = extractelement <8 x float> %610, i64 6, !dbg !106
  %618 = extractelement <8 x float> %610, i64 7, !dbg !106
  %619 = insertelement <16 x float> poison, float %146, i64 0, !dbg !106
  %620 = insertelement <16 x float> %619, float %177, i64 1, !dbg !106
  %621 = insertelement <16 x float> %620, float %208, i64 2, !dbg !106
  %622 = insertelement <16 x float> %621, float %239, i64 3, !dbg !106
  %623 = insertelement <16 x float> %622, float %270, i64 4, !dbg !106
  %624 = insertelement <16 x float> %623, float %301, i64 5, !dbg !106
  %625 = insertelement <16 x float> %624, float %332, i64 6, !dbg !106
  %626 = insertelement <16 x float> %625, float %363, i64 7, !dbg !106
  %627 = insertelement <16 x float> %626, float %394, i64 8, !dbg !106
  %628 = insertelement <16 x float> %627, float %425, i64 9, !dbg !106
  %629 = insertelement <16 x float> %628, float %456, i64 10, !dbg !106
  %630 = insertelement <16 x float> %629, float %487, i64 11, !dbg !106
  %631 = insertelement <16 x float> %630, float %518, i64 12, !dbg !106
  %632 = insertelement <16 x float> %631, float %549, i64 13, !dbg !106
  %633 = insertelement <16 x float> %632, float %580, i64 14, !dbg !106
  %634 = insertelement <16 x float> %633, float %611, i64 15, !dbg !106
  %635 = insertvalue [8 x <16 x float>] poison, <16 x float> %634, 0, !dbg !106
  %636 = insertelement <16 x float> poison, float %147, i64 0, !dbg !106
  %637 = insertelement <16 x float> %636, float %178, i64 1, !dbg !106
  %638 = insertelement <16 x float> %637, float %209, i64 2, !dbg !106
  %639 = insertelement <16 x float> %638, float %240, i64 3, !dbg !106
  %640 = insertelement <16 x float> %639, float %271, i64 4, !dbg !106
  %641 = insertelement <16 x float> %640, float %302, i64 5, !dbg !106
  %642 = insertelement <16 x float> %641, float %333, i64 6, !dbg !106
  %643 = insertelement <16 x float> %642, float %364, i64 7, !dbg !106
  %644 = insertelement <16 x float> %643, float %395, i64 8, !dbg !106
  %645 = insertelement <16 x float> %644, float %426, i64 9, !dbg !106
  %646 = insertelement <16 x float> %645, float %457, i64 10, !dbg !106
  %647 = insertelement <16 x float> %646, float %488, i64 11, !dbg !106
  %648 = insertelement <16 x float> %647, float %519, i64 12, !dbg !106
  %649 = insertelement <16 x float> %648, float %550, i64 13, !dbg !106
  %650 = insertelement <16 x float> %649, float %581, i64 14, !dbg !106
  %651 = insertelement <16 x float> %650, float %612, i64 15, !dbg !106
  %652 = insertvalue [8 x <16 x float>] %635, <16 x float> %651, 1, !dbg !106
  %653 = insertelement <16 x float> poison, float %148, i64 0, !dbg !106
  %654 = insertelement <16 x float> %653, float %179, i64 1, !dbg !106
  %655 = insertelement <16 x float> %654, float %210, i64 2, !dbg !106
  %656 = insertelement <16 x float> %655, float %241, i64 3, !dbg !106
  %657 = insertelement <16 x float> %656, float %272, i64 4, !dbg !106
  %658 = insertelement <16 x float> %657, float %303, i64 5, !dbg !106
  %659 = insertelement <16 x float> %658, float %334, i64 6, !dbg !106
  %660 = insertelement <16 x float> %659, float %365, i64 7, !dbg !106
  %661 = insertelement <16 x float> %660, float %396, i64 8, !dbg !106
  %662 = insertelement <16 x float> %661, float %427, i64 9, !dbg !106
  %663 = insertelement <16 x float> %662, float %458, i64 10, !dbg !106
  %664 = insertelement <16 x float> %663, float %489, i64 11, !dbg !106
  %665 = insertelement <16 x float> %664, float %520, i64 12, !dbg !106
  %666 = insertelement <16 x float> %665, float %551, i64 13, !dbg !106
  %667 = insertelement <16 x float> %666, float %582, i64 14, !dbg !106
  %668 = insertelement <16 x float> %667, float %613, i64 15, !dbg !106
  %669 = insertvalue [8 x <16 x float>] %652, <16 x float> %668, 2, !dbg !106
  %670 = insertelement <16 x float> poison, float %149, i64 0, !dbg !106
  %671 = insertelement <16 x float> %670, float %180, i64 1, !dbg !106
  %672 = insertelement <16 x float> %671, float %211, i64 2, !dbg !106
  %673 = insertelement <16 x float> %672, float %242, i64 3, !dbg !106
  %674 = insertelement <16 x float> %673, float %273, i64 4, !dbg !106
  %675 = insertelement <16 x float> %674, float %304, i64 5, !dbg !106
  %676 = insertelement <16 x float> %675, float %335, i64 6, !dbg !106
  %677 = insertelement <16 x float> %676, float %366, i64 7, !dbg !106
  %678 = insertelement <16 x float> %677, float %397, i64 8, !dbg !106
  %679 = insertelement <16 x float> %678, float %428, i64 9, !dbg !106
  %680 = insertelement <16 x float> %679, float %459, i64 10, !dbg !106
  %681 = insertelement <16 x float> %680, float %490, i64 11, !dbg !106
  %682 = insertelement <16 x float> %681, float %521, i64 12, !dbg !106
  %683 = insertelement <16 x float> %682, float %552, i64 13, !dbg !106
  %684 = insertelement <16 x float> %683, float %583, i64 14, !dbg !106
  %685 = insertelement <16 x float> %684, float %614, i64 15, !dbg !106
  %686 = insertvalue [8 x <16 x float>] %669, <16 x float> %685, 3, !dbg !106
  %687 = insertelement <16 x float> poison, float %150, i64 0, !dbg !106
  %688 = insertelement <16 x float> %687, float %181, i64 1, !dbg !106
  %689 = insertelement <16 x float> %688, float %212, i64 2, !dbg !106
  %690 = insertelement <16 x float> %689, float %243, i64 3, !dbg !106
  %691 = insertelement <16 x float> %690, float %274, i64 4, !dbg !106
  %692 = insertelement <16 x float> %691, float %305, i64 5, !dbg !106
  %693 = insertelement <16 x float> %692, float %336, i64 6, !dbg !106
  %694 = insertelement <16 x float> %693, float %367, i64 7, !dbg !106
  %695 = insertelement <16 x float> %694, float %398, i64 8, !dbg !106
  %696 = insertelement <16 x float> %695, float %429, i64 9, !dbg !106
  %697 = insertelement <16 x float> %696, float %460, i64 10, !dbg !106
  %698 = insertelement <16 x float> %697, float %491, i64 11, !dbg !106
  %699 = insertelement <16 x float> %698, float %522, i64 12, !dbg !106
  %700 = insertelement <16 x float> %699, float %553, i64 13, !dbg !106
  %701 = insertelement <16 x float> %700, float %584, i64 14, !dbg !106
  %702 = insertelement <16 x float> %701, float %615, i64 15, !dbg !106
  %703 = insertvalue [8 x <16 x float>] %686, <16 x float> %702, 4, !dbg !106
  %704 = insertelement <16 x float> poison, float %151, i64 0, !dbg !106
  %705 = insertelement <16 x float> %704, float %182, i64 1, !dbg !106
  %706 = insertelement <16 x float> %705, float %213, i64 2, !dbg !106
  %707 = insertelement <16 x float> %706, float %244, i64 3, !dbg !106
  %708 = insertelement <16 x float> %707, float %275, i64 4, !dbg !106
  %709 = insertelement <16 x float> %708, float %306, i64 5, !dbg !106
  %710 = insertelement <16 x float> %709, float %337, i64 6, !dbg !106
  %711 = insertelement <16 x float> %710, float %368, i64 7, !dbg !106
  %712 = insertelement <16 x float> %711, float %399, i64 8, !dbg !106
  %713 = insertelement <16 x float> %712, float %430, i64 9, !dbg !106
  %714 = insertelement <16 x float> %713, float %461, i64 10, !dbg !106
  %715 = insertelement <16 x float> %714, float %492, i64 11, !dbg !106
  %716 = insertelement <16 x float> %715, float %523, i64 12, !dbg !106
  %717 = insertelement <16 x float> %716, float %554, i64 13, !dbg !106
  %718 = insertelement <16 x float> %717, float %585, i64 14, !dbg !106
  %719 = insertelement <16 x float> %718, float %616, i64 15, !dbg !106
  %720 = insertvalue [8 x <16 x float>] %703, <16 x float> %719, 5, !dbg !106
  %721 = insertelement <16 x float> poison, float %152, i64 0, !dbg !106
  %722 = insertelement <16 x float> %721, float %183, i64 1, !dbg !106
  %723 = insertelement <16 x float> %722, float %214, i64 2, !dbg !106
  %724 = insertelement <16 x float> %723, float %245, i64 3, !dbg !106
  %725 = insertelement <16 x float> %724, float %276, i64 4, !dbg !106
  %726 = insertelement <16 x float> %725, float %307, i64 5, !dbg !106
  %727 = insertelement <16 x float> %726, float %338, i64 6, !dbg !106
  %728 = insertelement <16 x float> %727, float %369, i64 7, !dbg !106
  %729 = insertelement <16 x float> %728, float %400, i64 8, !dbg !106
  %730 = insertelement <16 x float> %729, float %431, i64 9, !dbg !106
  %731 = insertelement <16 x float> %730, float %462, i64 10, !dbg !106
  %732 = insertelement <16 x float> %731, float %493, i64 11, !dbg !106
  %733 = insertelement <16 x float> %732, float %524, i64 12, !dbg !106
  %734 = insertelement <16 x float> %733, float %555, i64 13, !dbg !106
  %735 = insertelement <16 x float> %734, float %586, i64 14, !dbg !106
  %736 = insertelement <16 x float> %735, float %617, i64 15, !dbg !106
  %737 = insertvalue [8 x <16 x float>] %720, <16 x float> %736, 6, !dbg !106
  %738 = insertelement <16 x float> poison, float %153, i64 0, !dbg !106
  %739 = insertelement <16 x float> %738, float %184, i64 1, !dbg !106
  %740 = insertelement <16 x float> %739, float %215, i64 2, !dbg !106
  %741 = insertelement <16 x float> %740, float %246, i64 3, !dbg !106
  %742 = insertelement <16 x float> %741, float %277, i64 4, !dbg !106
  %743 = insertelement <16 x float> %742, float %308, i64 5, !dbg !106
  %744 = insertelement <16 x float> %743, float %339, i64 6, !dbg !106
  %745 = insertelement <16 x float> %744, float %370, i64 7, !dbg !106
  %746 = insertelement <16 x float> %745, float %401, i64 8, !dbg !106
  %747 = insertelement <16 x float> %746, float %432, i64 9, !dbg !106
  %748 = insertelement <16 x float> %747, float %463, i64 10, !dbg !106
  %749 = insertelement <16 x float> %748, float %494, i64 11, !dbg !106
  %750 = insertelement <16 x float> %749, float %525, i64 12, !dbg !106
  %751 = insertelement <16 x float> %750, float %556, i64 13, !dbg !106
  %752 = insertelement <16 x float> %751, float %587, i64 14, !dbg !106
  %753 = insertelement <16 x float> %752, float %618, i64 15, !dbg !106
  %754 = insertvalue [8 x <16 x float>] %737, <16 x float> %753, 7, !dbg !106
  %755 = add i64 %55, 1, !dbg !104
  br label %54, !dbg !104

756:                                              ; preds = %54
  %757 = extractvalue [8 x <16 x float>] %56, 0, !dbg !107
  %758 = fadd contract <16 x float> %757, %43, !dbg !107
  %759 = extractvalue [8 x <16 x float>] %56, 1, !dbg !107
  %760 = fadd contract <16 x float> %759, %44, !dbg !107
  %761 = extractvalue [8 x <16 x float>] %56, 2, !dbg !107
  %762 = fadd contract <16 x float> %761, %45, !dbg !107
  %763 = extractvalue [8 x <16 x float>] %56, 3, !dbg !107
  %764 = fadd contract <16 x float> %763, %46, !dbg !107
  %765 = extractvalue [8 x <16 x float>] %56, 4, !dbg !107
  %766 = fadd contract <16 x float> %765, %47, !dbg !107
  %767 = extractvalue [8 x <16 x float>] %56, 5, !dbg !107
  %768 = fadd contract <16 x float> %767, %48, !dbg !107
  %769 = extractvalue [8 x <16 x float>] %56, 6, !dbg !107
  %770 = fadd contract <16 x float> %769, %49, !dbg !107
  %771 = extractvalue [8 x <16 x float>] %56, 7, !dbg !107
  %772 = fadd contract <16 x float> %771, %50, !dbg !107
  %773 = fcmp olt <16 x float> zeroinitializer, %758, !dbg !108
  %774 = fcmp olt <16 x float> zeroinitializer, %760, !dbg !108
  %775 = fcmp olt <16 x float> zeroinitializer, %762, !dbg !108
  %776 = fcmp olt <16 x float> zeroinitializer, %764, !dbg !108
  %777 = fcmp olt <16 x float> zeroinitializer, %766, !dbg !108
  %778 = fcmp olt <16 x float> zeroinitializer, %768, !dbg !108
  %779 = fcmp olt <16 x float> zeroinitializer, %770, !dbg !108
  %780 = fcmp olt <16 x float> zeroinitializer, %772, !dbg !108
  %781 = select <16 x i1> %773, <16 x float> zeroinitializer, <16 x float> %758, !dbg !109
  %782 = select <16 x i1> %774, <16 x float> zeroinitializer, <16 x float> %760, !dbg !109
  %783 = select <16 x i1> %775, <16 x float> zeroinitializer, <16 x float> %762, !dbg !109
  %784 = select <16 x i1> %776, <16 x float> zeroinitializer, <16 x float> %764, !dbg !109
  %785 = select <16 x i1> %777, <16 x float> zeroinitializer, <16 x float> %766, !dbg !109
  %786 = select <16 x i1> %778, <16 x float> zeroinitializer, <16 x float> %768, !dbg !109
  %787 = select <16 x i1> %779, <16 x float> zeroinitializer, <16 x float> %770, !dbg !109
  %788 = select <16 x i1> %780, <16 x float> zeroinitializer, <16 x float> %772, !dbg !109
  %789 = fmul contract <16 x float> %781, splat (float 0x3FC99999A0000000), !dbg !110
  %790 = fmul contract <16 x float> %782, splat (float 0x3FC99999A0000000), !dbg !110
  %791 = fmul contract <16 x float> %783, splat (float 0x3FC99999A0000000), !dbg !110
  %792 = fmul contract <16 x float> %784, splat (float 0x3FC99999A0000000), !dbg !110
  %793 = fmul contract <16 x float> %785, splat (float 0x3FC99999A0000000), !dbg !110
  %794 = fmul contract <16 x float> %786, splat (float 0x3FC99999A0000000), !dbg !110
  %795 = fmul contract <16 x float> %787, splat (float 0x3FC99999A0000000), !dbg !110
  %796 = fmul contract <16 x float> %788, splat (float 0x3FC99999A0000000), !dbg !110
  %797 = fcmp ogt <16 x float> zeroinitializer, %758, !dbg !111
  %798 = fcmp ogt <16 x float> zeroinitializer, %760, !dbg !111
  %799 = fcmp ogt <16 x float> zeroinitializer, %762, !dbg !111
  %800 = fcmp ogt <16 x float> zeroinitializer, %764, !dbg !111
  %801 = fcmp ogt <16 x float> zeroinitializer, %766, !dbg !111
  %802 = fcmp ogt <16 x float> zeroinitializer, %768, !dbg !111
  %803 = fcmp ogt <16 x float> zeroinitializer, %770, !dbg !111
  %804 = fcmp ogt <16 x float> zeroinitializer, %772, !dbg !111
  %805 = select <16 x i1> %797, <16 x float> zeroinitializer, <16 x float> %758, !dbg !112
  %806 = select <16 x i1> %798, <16 x float> zeroinitializer, <16 x float> %760, !dbg !112
  %807 = select <16 x i1> %799, <16 x float> zeroinitializer, <16 x float> %762, !dbg !112
  %808 = select <16 x i1> %800, <16 x float> zeroinitializer, <16 x float> %764, !dbg !112
  %809 = select <16 x i1> %801, <16 x float> zeroinitializer, <16 x float> %766, !dbg !112
  %810 = select <16 x i1> %802, <16 x float> zeroinitializer, <16 x float> %768, !dbg !112
  %811 = select <16 x i1> %803, <16 x float> zeroinitializer, <16 x float> %770, !dbg !112
  %812 = select <16 x i1> %804, <16 x float> zeroinitializer, <16 x float> %772, !dbg !112
  %813 = fadd contract <16 x float> %805, %789, !dbg !113
  %814 = fadd contract <16 x float> %806, %790, !dbg !113
  %815 = fadd contract <16 x float> %807, %791, !dbg !113
  %816 = fadd contract <16 x float> %808, %792, !dbg !113
  %817 = fadd contract <16 x float> %809, %793, !dbg !113
  %818 = fadd contract <16 x float> %810, %794, !dbg !113
  %819 = fadd contract <16 x float> %811, %795, !dbg !113
  %820 = fadd contract <16 x float> %812, %796, !dbg !113
  %821 = add i64 %18, %52, !dbg !104
  %822 = mul i64 %20, 50176, !dbg !104
  %823 = add i64 %822, %821, !dbg !104
  %824 = getelementptr float, ptr %14, i64 %823, !dbg !104
  store <16 x float> %813, ptr %824, align 4, !dbg !104
  %825 = add i64 %20, 1, !dbg !104
  %826 = mul i64 %825, 50176, !dbg !104
  %827 = add i64 %826, %821, !dbg !104
  %828 = getelementptr float, ptr %14, i64 %827, !dbg !104
  store <16 x float> %814, ptr %828, align 4, !dbg !104
  %829 = add i64 %20, 2, !dbg !104
  %830 = mul i64 %829, 50176, !dbg !104
  %831 = add i64 %830, %821, !dbg !104
  %832 = getelementptr float, ptr %14, i64 %831, !dbg !104
  store <16 x float> %815, ptr %832, align 4, !dbg !104
  %833 = add i64 %20, 3, !dbg !104
  %834 = mul i64 %833, 50176, !dbg !104
  %835 = add i64 %834, %821, !dbg !104
  %836 = getelementptr float, ptr %14, i64 %835, !dbg !104
  store <16 x float> %816, ptr %836, align 4, !dbg !104
  %837 = add i64 %20, 4, !dbg !104
  %838 = mul i64 %837, 50176, !dbg !104
  %839 = add i64 %838, %821, !dbg !104
  %840 = getelementptr float, ptr %14, i64 %839, !dbg !104
  store <16 x float> %817, ptr %840, align 4, !dbg !104
  %841 = add i64 %20, 5, !dbg !104
  %842 = mul i64 %841, 50176, !dbg !104
  %843 = add i64 %842, %821, !dbg !104
  %844 = getelementptr float, ptr %14, i64 %843, !dbg !104
  store <16 x float> %818, ptr %844, align 4, !dbg !104
  %845 = add i64 %20, 6, !dbg !104
  %846 = mul i64 %845, 50176, !dbg !104
  %847 = add i64 %846, %821, !dbg !104
  %848 = getelementptr float, ptr %14, i64 %847, !dbg !104
  store <16 x float> %819, ptr %848, align 4, !dbg !104
  %849 = add i64 %20, 7, !dbg !104
  %850 = mul i64 %849, 50176, !dbg !104
  %851 = add i64 %850, %821, !dbg !104
  %852 = getelementptr float, ptr %14, i64 %851, !dbg !104
  store <16 x float> %820, ptr %852, align 4, !dbg !104
  %853 = add i64 %52, 16, !dbg !104
  br label %51, !dbg !104

854:                                              ; preds = %51
  %855 = add i64 %20, 8, !dbg !104
  br label %19, !dbg !104

856:                                              ; preds = %19
  ret i32 0, !dbg !114
}

define internal i32 @infer_dispatch_1_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !115 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !116
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !116
  %6 = load ptr, ptr %5, align 8, !dbg !116
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !117
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !118
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !118
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !118
  %10 = load ptr, ptr %9, align 8, !dbg !118
  %11 = getelementptr float, ptr %10, i64 1605632, !dbg !119
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !119
  %12 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !120
  %13 = extractvalue %iree_hal_executable_workgroup_state_v0_t %12, 0, !dbg !120
  %14 = zext i32 %13 to i64, !dbg !120
  %15 = sdiv i64 %14, 4, !dbg !120
  %16 = mul i64 %15, 4, !dbg !120
  %17 = icmp ne i64 %14, %16, !dbg !120
  %18 = icmp slt i64 %14, 0, !dbg !120
  %19 = and i1 %17, %18, !dbg !120
  %20 = add i64 %15, -1, !dbg !120
  %21 = select i1 %19, i64 %20, i64 %15, !dbg !120
  %22 = srem i64 %14, 4, !dbg !120
  %23 = icmp slt i64 %22, 0, !dbg !120
  %24 = add nsw i64 %22, 4, !dbg !120
  %25 = select i1 %23, i64 %24, i64 %22, !dbg !120
  %26 = mul nsw i64 %21, 56, !dbg !120
  %27 = mul nsw i64 %25, 56, !dbg !120
  br label %28, !dbg !120

28:                                               ; preds = %56, %3
  %29 = phi i64 [ %57, %56 ], [ 0, %3 ], !dbg !120
  %30 = icmp slt i64 %29, 32, !dbg !120
  br i1 %30, label %31, label %58, !dbg !120

31:                                               ; preds = %54, %28
  %32 = phi i64 [ %55, %54 ], [ 0, %28 ], !dbg !120
  %33 = icmp slt i64 %32, 56, !dbg !120
  br i1 %33, label %34, label %56, !dbg !120

34:                                               ; preds = %37, %31
  %35 = phi i64 [ %53, %37 ], [ 0, %31 ], !dbg !120
  %36 = icmp slt i64 %35, 56, !dbg !120
  br i1 %36, label %37, label %54, !dbg !120

37:                                               ; preds = %34
  %38 = add i64 %26, %32, !dbg !120
  %39 = add i64 %27, %35, !dbg !120
  %40 = mul i64 %29, 50176, !dbg !120
  %41 = mul i64 %38, 224, !dbg !120
  %42 = add i64 %40, %41, !dbg !120
  %43 = add i64 %42, %39, !dbg !120
  %44 = getelementptr float, ptr %6, i64 %43, !dbg !120
  %45 = load <4 x float>, ptr %44, align 4, !dbg !120
  %46 = add i64 %38, 1, !dbg !120
  %47 = add i64 %39, 1, !dbg !120
  %48 = mul i64 %29, 51076, !dbg !120
  %49 = mul i64 %46, 226, !dbg !120
  %50 = add i64 %48, %49, !dbg !120
  %51 = add i64 %50, %47, !dbg !120
  %52 = getelementptr float, ptr %11, i64 %51, !dbg !120
  store <4 x float> %45, ptr %52, align 4, !dbg !120
  %53 = add i64 %35, 4, !dbg !120
  br label %34, !dbg !120

54:                                               ; preds = %34
  %55 = add i64 %32, 1, !dbg !120
  br label %31, !dbg !120

56:                                               ; preds = %31
  %57 = add i64 %29, 1, !dbg !120
  br label %28, !dbg !120

58:                                               ; preds = %28
  ret i32 0, !dbg !121
}

define internal i32 @infer_dispatch_2_conv_64x224x224x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !122 {
  %4 = alloca float, i64 4, align 64, !dbg !123
  %5 = alloca float, i64 4, align 64, !dbg !124
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !125
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !125
  %8 = load ptr, ptr %7, align 8, !dbg !125
  %9 = getelementptr float, ptr %8, i64 1605632, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !125
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !126
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !126
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !126
  %13 = load ptr, ptr %12, align 8, !dbg !126
  %14 = getelementptr float, ptr %13, i64 1052480, !dbg !126
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !126
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !127
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !127
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !127
  %18 = load ptr, ptr %17, align 8, !dbg !127
  %19 = getelementptr float, ptr %18, i64 3240064, !dbg !127
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !127
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !123
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !123
  %22 = zext i32 %21 to i64, !dbg !123
  %23 = sdiv i64 %22, 49, !dbg !123
  %24 = mul i64 %23, 49, !dbg !123
  %25 = icmp ne i64 %22, %24, !dbg !123
  %26 = icmp slt i64 %22, 0, !dbg !123
  %27 = and i1 %25, %26, !dbg !123
  %28 = add i64 %23, -1, !dbg !123
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !123
  %30 = srem i64 %22, 49, !dbg !123
  %31 = icmp slt i64 %30, 0, !dbg !123
  %32 = add nsw i64 %30, 49, !dbg !123
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !123
  %34 = sdiv i64 %33, 7, !dbg !123
  %35 = srem i64 %22, 7, !dbg !123
  %36 = icmp slt i64 %35, 0, !dbg !123
  %37 = add nsw i64 %35, 7, !dbg !123
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !123
  %39 = mul nsw i64 %29, 32, !dbg !123
  %40 = mul nsw i64 %34, 32, !dbg !123
  %41 = mul nsw i64 %38, 32, !dbg !123
  %42 = getelementptr float, ptr %5, i64 0, !dbg !128
  store <4 x float> zeroinitializer, ptr %42, align 4, !dbg !128
  br label %43, !dbg !123

43:                                               ; preds = %135, %3
  %44 = phi i64 [ %136, %135 ], [ 0, %3 ], !dbg !123
  %45 = icmp slt i64 %44, 32, !dbg !123
  br i1 %45, label %46, label %137, !dbg !123

46:                                               ; preds = %43
  %47 = add i64 %44, %39, !dbg !123
  %48 = getelementptr float, ptr @__constant_64xf32, i64 %47, !dbg !129
  %49 = load <1 x float>, ptr %48, align 4, !dbg !129
  br label %50, !dbg !123

50:                                               ; preds = %133, %46
  %51 = phi i64 [ %134, %133 ], [ 0, %46 ], !dbg !123
  %52 = icmp slt i64 %51, 32, !dbg !123
  br i1 %52, label %53, label %135, !dbg !123

53:                                               ; preds = %111, %50
  %54 = phi i64 [ %132, %111 ], [ 0, %50 ], !dbg !123
  %55 = icmp slt i64 %54, 32, !dbg !123
  br i1 %55, label %56, label %133, !dbg !123

56:                                               ; preds = %53
  %57 = add i64 %54, %41, !dbg !123
  br label %58, !dbg !123

58:                                               ; preds = %61, %56
  %59 = phi i64 [ %66, %61 ], [ 0, %56 ], !dbg !123
  %60 = icmp slt i64 %59, 4, !dbg !123
  br i1 %60, label %61, label %67, !dbg !123

61:                                               ; preds = %58
  %62 = add nuw nsw i64 0, %59, !dbg !123
  %63 = getelementptr inbounds nuw float, ptr %5, i64 %62, !dbg !123
  %64 = load float, ptr %63, align 4, !dbg !123
  %65 = getelementptr inbounds nuw float, ptr %4, i64 %62, !dbg !123
  store float %64, ptr %65, align 4, !dbg !123
  %66 = add i64 %59, 1, !dbg !123
  br label %58, !dbg !123

67:                                               ; preds = %109, %58
  %68 = phi i64 [ %110, %109 ], [ 0, %58 ], !dbg !123
  %69 = icmp slt i64 %68, 32, !dbg !123
  br i1 %69, label %70, label %111, !dbg !123

70:                                               ; preds = %107, %67
  %71 = phi i64 [ %108, %107 ], [ 0, %67 ], !dbg !123
  %72 = icmp slt i64 %71, 3, !dbg !123
  br i1 %72, label %73, label %109, !dbg !123

73:                                               ; preds = %70
  %74 = add i64 %71, %51, !dbg !123
  %75 = add i64 %74, %40, !dbg !123
  br label %76, !dbg !123

76:                                               ; preds = %105, %73
  %77 = phi i64 [ %106, %105 ], [ 0, %73 ], !dbg !123
  %78 = icmp slt i64 %77, 4, !dbg !123
  br i1 %78, label %79, label %107, !dbg !123

79:                                               ; preds = %82, %76
  %80 = phi i64 [ %104, %82 ], [ 0, %76 ], !dbg !123
  %81 = icmp slt i64 %80, 3, !dbg !123
  br i1 %81, label %82, label %105, !dbg !123

82:                                               ; preds = %79
  %83 = add i64 %57, %77, !dbg !123
  %84 = add i64 %83, %80, !dbg !123
  %85 = mul nuw nsw i64 %68, 51076, !dbg !123
  %86 = mul nuw nsw i64 %75, 226, !dbg !123
  %87 = add nuw nsw i64 %85, %86, !dbg !123
  %88 = add nuw nsw i64 %87, %84, !dbg !123
  %89 = getelementptr inbounds nuw float, ptr %9, i64 %88, !dbg !123
  %90 = load float, ptr %89, align 4, !dbg !123
  %91 = mul nuw nsw i64 %47, 288, !dbg !123
  %92 = mul nuw nsw i64 %68, 9, !dbg !123
  %93 = add nuw nsw i64 %91, %92, !dbg !123
  %94 = mul nuw nsw i64 %71, 3, !dbg !123
  %95 = add nuw nsw i64 %93, %94, !dbg !123
  %96 = add nuw nsw i64 %95, %80, !dbg !123
  %97 = getelementptr inbounds nuw float, ptr %14, i64 %96, !dbg !123
  %98 = load float, ptr %97, align 4, !dbg !123
  %99 = add nuw nsw i64 0, %77, !dbg !123
  %100 = getelementptr inbounds nuw float, ptr %4, i64 %99, !dbg !123
  %101 = load float, ptr %100, align 4, !dbg !123
  %102 = fmul contract float %90, %98, !dbg !130
  %103 = fadd contract float %101, %102, !dbg !131
  store float %103, ptr %100, align 4, !dbg !123
  %104 = add i64 %80, 1, !dbg !123
  br label %79, !dbg !123

105:                                              ; preds = %79
  %106 = add i64 %77, 1, !dbg !123
  br label %76, !dbg !123

107:                                              ; preds = %76
  %108 = add i64 %71, 1, !dbg !123
  br label %70, !dbg !123

109:                                              ; preds = %70
  %110 = add i64 %68, 1, !dbg !123
  br label %67, !dbg !123

111:                                              ; preds = %67
  %112 = getelementptr float, ptr %4, i64 0, !dbg !129
  %113 = load <4 x float>, ptr %112, align 4, !dbg !129
  %114 = extractelement <1 x float> %49, i64 0, !dbg !132
  %115 = insertelement <4 x float> poison, float %114, i32 0, !dbg !132
  %116 = shufflevector <4 x float> %115, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !132
  %117 = fadd contract <4 x float> %113, %116, !dbg !132
  %118 = fcmp olt <4 x float> zeroinitializer, %117, !dbg !133
  %119 = select <4 x i1> %118, <4 x float> zeroinitializer, <4 x float> %117, !dbg !134
  %120 = fmul contract <4 x float> %119, splat (float 0x3FC99999A0000000), !dbg !135
  %121 = fcmp ogt <4 x float> zeroinitializer, %117, !dbg !136
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %117, !dbg !137
  %123 = fadd contract <4 x float> %122, %120, !dbg !138
  %124 = add i64 %40, %51, !dbg !123
  %125 = add i64 %124, 1, !dbg !123
  %126 = add i64 %57, 1, !dbg !123
  %127 = mul i64 %47, 51076, !dbg !123
  %128 = mul i64 %125, 226, !dbg !123
  %129 = add i64 %127, %128, !dbg !123
  %130 = add i64 %129, %126, !dbg !123
  %131 = getelementptr float, ptr %19, i64 %130, !dbg !123
  store <4 x float> %123, ptr %131, align 4, !dbg !123
  %132 = add i64 %54, 4, !dbg !123
  br label %53, !dbg !123

133:                                              ; preds = %53
  %134 = add i64 %51, 1, !dbg !123
  br label %50, !dbg !123

135:                                              ; preds = %50
  %136 = add i64 %44, 1, !dbg !123
  br label %43, !dbg !123

137:                                              ; preds = %43
  ret i32 0, !dbg !139
}

define internal i32 @infer_dispatch_3_conv_128x224x224x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !140 {
  %4 = alloca float, i64 4, align 64, !dbg !141
  %5 = alloca float, i64 4, align 64, !dbg !142
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !143
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !143
  %8 = load ptr, ptr %7, align 8, !dbg !143
  %9 = getelementptr float, ptr %8, i64 3240064, !dbg !143
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !143
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !144
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !144
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !144
  %13 = load ptr, ptr %12, align 8, !dbg !144
  %14 = getelementptr float, ptr %13, i64 959328, !dbg !144
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !144
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !145
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !145
  %17 = getelementptr ptr, ptr %16, i32 1, !dbg !145
  %18 = load ptr, ptr %17, align 8, !dbg !145
  %19 = getelementptr float, ptr %18, i64 1033056, !dbg !145
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !145
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !146
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !146
  %22 = getelementptr ptr, ptr %21, i32 2, !dbg !146
  %23 = load ptr, ptr %22, align 8, !dbg !146
  %24 = getelementptr float, ptr %23, i64 6508928, !dbg !146
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !146
  %25 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !141
  %26 = extractvalue %iree_hal_executable_workgroup_state_v0_t %25, 0, !dbg !141
  %27 = zext i32 %26 to i64, !dbg !141
  %28 = sdiv i64 %27, 49, !dbg !141
  %29 = mul i64 %28, 49, !dbg !141
  %30 = icmp ne i64 %27, %29, !dbg !141
  %31 = icmp slt i64 %27, 0, !dbg !141
  %32 = and i1 %30, %31, !dbg !141
  %33 = add i64 %28, -1, !dbg !141
  %34 = select i1 %32, i64 %33, i64 %28, !dbg !141
  %35 = srem i64 %27, 49, !dbg !141
  %36 = icmp slt i64 %35, 0, !dbg !141
  %37 = add nsw i64 %35, 49, !dbg !141
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !141
  %39 = sdiv i64 %38, 7, !dbg !141
  %40 = srem i64 %27, 7, !dbg !141
  %41 = icmp slt i64 %40, 0, !dbg !141
  %42 = add nsw i64 %40, 7, !dbg !141
  %43 = select i1 %41, i64 %42, i64 %40, !dbg !141
  %44 = mul nsw i64 %34, 32, !dbg !141
  %45 = mul nsw i64 %39, 32, !dbg !141
  %46 = mul nsw i64 %43, 32, !dbg !141
  %47 = getelementptr float, ptr %5, i64 0, !dbg !147
  store <4 x float> zeroinitializer, ptr %47, align 4, !dbg !147
  br label %48, !dbg !141

48:                                               ; preds = %138, %3
  %49 = phi i64 [ %139, %138 ], [ 0, %3 ], !dbg !141
  %50 = icmp slt i64 %49, 32, !dbg !141
  br i1 %50, label %51, label %140, !dbg !141

51:                                               ; preds = %48
  %52 = add i64 %49, %44, !dbg !141
  %53 = getelementptr float, ptr %19, i64 %52, !dbg !148
  %54 = load <1 x float>, ptr %53, align 4, !dbg !148
  br label %55, !dbg !141

55:                                               ; preds = %136, %51
  %56 = phi i64 [ %137, %136 ], [ 0, %51 ], !dbg !141
  %57 = icmp slt i64 %56, 32, !dbg !141
  br i1 %57, label %58, label %138, !dbg !141

58:                                               ; preds = %116, %55
  %59 = phi i64 [ %135, %116 ], [ 0, %55 ], !dbg !141
  %60 = icmp slt i64 %59, 32, !dbg !141
  br i1 %60, label %61, label %136, !dbg !141

61:                                               ; preds = %58
  %62 = add i64 %59, %46, !dbg !141
  br label %63, !dbg !141

63:                                               ; preds = %66, %61
  %64 = phi i64 [ %71, %66 ], [ 0, %61 ], !dbg !141
  %65 = icmp slt i64 %64, 4, !dbg !141
  br i1 %65, label %66, label %72, !dbg !141

66:                                               ; preds = %63
  %67 = add nuw nsw i64 0, %64, !dbg !141
  %68 = getelementptr inbounds nuw float, ptr %5, i64 %67, !dbg !141
  %69 = load float, ptr %68, align 4, !dbg !141
  %70 = getelementptr inbounds nuw float, ptr %4, i64 %67, !dbg !141
  store float %69, ptr %70, align 4, !dbg !141
  %71 = add i64 %64, 1, !dbg !141
  br label %63, !dbg !141

72:                                               ; preds = %114, %63
  %73 = phi i64 [ %115, %114 ], [ 0, %63 ], !dbg !141
  %74 = icmp slt i64 %73, 64, !dbg !141
  br i1 %74, label %75, label %116, !dbg !141

75:                                               ; preds = %112, %72
  %76 = phi i64 [ %113, %112 ], [ 0, %72 ], !dbg !141
  %77 = icmp slt i64 %76, 3, !dbg !141
  br i1 %77, label %78, label %114, !dbg !141

78:                                               ; preds = %75
  %79 = add i64 %76, %56, !dbg !141
  %80 = add i64 %79, %45, !dbg !141
  br label %81, !dbg !141

81:                                               ; preds = %110, %78
  %82 = phi i64 [ %111, %110 ], [ 0, %78 ], !dbg !141
  %83 = icmp slt i64 %82, 4, !dbg !141
  br i1 %83, label %84, label %112, !dbg !141

84:                                               ; preds = %87, %81
  %85 = phi i64 [ %109, %87 ], [ 0, %81 ], !dbg !141
  %86 = icmp slt i64 %85, 3, !dbg !141
  br i1 %86, label %87, label %110, !dbg !141

87:                                               ; preds = %84
  %88 = add i64 %62, %82, !dbg !141
  %89 = add i64 %88, %85, !dbg !141
  %90 = mul nuw nsw i64 %73, 51076, !dbg !141
  %91 = mul nuw nsw i64 %80, 226, !dbg !141
  %92 = add nuw nsw i64 %90, %91, !dbg !141
  %93 = add nuw nsw i64 %92, %89, !dbg !141
  %94 = getelementptr inbounds nuw float, ptr %9, i64 %93, !dbg !141
  %95 = load float, ptr %94, align 4, !dbg !141
  %96 = mul nuw nsw i64 %52, 576, !dbg !141
  %97 = mul nuw nsw i64 %73, 9, !dbg !141
  %98 = add nuw nsw i64 %96, %97, !dbg !141
  %99 = mul nuw nsw i64 %76, 3, !dbg !141
  %100 = add nuw nsw i64 %98, %99, !dbg !141
  %101 = add nuw nsw i64 %100, %85, !dbg !141
  %102 = getelementptr inbounds nuw float, ptr %14, i64 %101, !dbg !141
  %103 = load float, ptr %102, align 4, !dbg !141
  %104 = add nuw nsw i64 0, %82, !dbg !141
  %105 = getelementptr inbounds nuw float, ptr %4, i64 %104, !dbg !141
  %106 = load float, ptr %105, align 4, !dbg !141
  %107 = fmul contract float %95, %103, !dbg !149
  %108 = fadd contract float %106, %107, !dbg !150
  store float %108, ptr %105, align 4, !dbg !141
  %109 = add i64 %85, 1, !dbg !141
  br label %84, !dbg !141

110:                                              ; preds = %84
  %111 = add i64 %82, 1, !dbg !141
  br label %81, !dbg !141

112:                                              ; preds = %81
  %113 = add i64 %76, 1, !dbg !141
  br label %75, !dbg !141

114:                                              ; preds = %75
  %115 = add i64 %73, 1, !dbg !141
  br label %72, !dbg !141

116:                                              ; preds = %72
  %117 = getelementptr float, ptr %4, i64 0, !dbg !148
  %118 = load <4 x float>, ptr %117, align 4, !dbg !148
  %119 = extractelement <1 x float> %54, i64 0, !dbg !151
  %120 = insertelement <4 x float> poison, float %119, i32 0, !dbg !151
  %121 = shufflevector <4 x float> %120, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !151
  %122 = fadd contract <4 x float> %118, %121, !dbg !151
  %123 = fcmp olt <4 x float> zeroinitializer, %122, !dbg !152
  %124 = select <4 x i1> %123, <4 x float> zeroinitializer, <4 x float> %122, !dbg !153
  %125 = fmul contract <4 x float> %124, splat (float 0x3FC99999A0000000), !dbg !154
  %126 = fcmp ogt <4 x float> zeroinitializer, %122, !dbg !155
  %127 = select <4 x i1> %126, <4 x float> zeroinitializer, <4 x float> %122, !dbg !156
  %128 = fadd contract <4 x float> %127, %125, !dbg !157
  %129 = add i64 %45, %56, !dbg !141
  %130 = mul i64 %52, 50176, !dbg !141
  %131 = mul i64 %129, 224, !dbg !141
  %132 = add i64 %130, %131, !dbg !141
  %133 = add i64 %132, %62, !dbg !141
  %134 = getelementptr float, ptr %24, i64 %133, !dbg !141
  store <4 x float> %128, ptr %134, align 4, !dbg !141
  %135 = add i64 %59, 4, !dbg !141
  br label %58, !dbg !141

136:                                              ; preds = %58
  %137 = add i64 %56, 1, !dbg !141
  br label %55, !dbg !141

138:                                              ; preds = %55
  %139 = add i64 %49, 1, !dbg !141
  br label %48, !dbg !141

140:                                              ; preds = %48
  ret i32 0, !dbg !158
}

define internal i32 @infer_dispatch_4_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !159 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !160
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !160
  %6 = load i32, ptr %5, align 4, !dbg !160
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !161
  %8 = load i32, ptr %7, align 4, !dbg !161
  %9 = zext i32 %6 to i64, !dbg !162
  %10 = zext i32 %8 to i64, !dbg !163
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !164
  %12 = load ptr, ptr %11, align 8, !dbg !164
  %13 = mul i64 %9, 8, !dbg !164
  %14 = udiv i64 %13, 32, !dbg !164
  %15 = getelementptr float, ptr %12, i64 %14, !dbg !165
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !165
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !166
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !166
  %18 = getelementptr ptr, ptr %17, i32 1, !dbg !166
  %19 = load ptr, ptr %18, align 8, !dbg !166
  %20 = mul i64 %10, 8, !dbg !166
  %21 = udiv i64 %20, 32, !dbg !166
  %22 = getelementptr float, ptr %19, i64 %21, !dbg !167
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !167
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !168
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !168
  %25 = zext i32 %24 to i64, !dbg !168
  %26 = sdiv i64 %25, 16, !dbg !168
  %27 = mul i64 %26, 16, !dbg !168
  %28 = icmp ne i64 %25, %27, !dbg !168
  %29 = icmp slt i64 %25, 0, !dbg !168
  %30 = and i1 %28, %29, !dbg !168
  %31 = add i64 %26, -1, !dbg !168
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !168
  %33 = srem i64 %25, 16, !dbg !168
  %34 = icmp slt i64 %33, 0, !dbg !168
  %35 = add nsw i64 %33, 16, !dbg !168
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !168
  %37 = sdiv i64 %36, 4, !dbg !168
  %38 = srem i64 %25, 4, !dbg !168
  %39 = icmp slt i64 %38, 0, !dbg !168
  %40 = add nsw i64 %38, 4, !dbg !168
  %41 = select i1 %39, i64 %40, i64 %38, !dbg !168
  %42 = mul nsw i64 %32, 64, !dbg !168
  %43 = mul nsw i64 %37, 56, !dbg !168
  %44 = mul nsw i64 %41, 56, !dbg !168
  br label %45, !dbg !168

45:                                               ; preds = %74, %3
  %46 = phi i64 [ %75, %74 ], [ 0, %3 ], !dbg !168
  %47 = icmp slt i64 %46, 64, !dbg !168
  br i1 %47, label %48, label %76, !dbg !168

48:                                               ; preds = %72, %45
  %49 = phi i64 [ %73, %72 ], [ 0, %45 ], !dbg !168
  %50 = icmp slt i64 %49, 56, !dbg !168
  br i1 %50, label %51, label %74, !dbg !168

51:                                               ; preds = %54, %48
  %52 = phi i64 [ %71, %54 ], [ 0, %48 ], !dbg !168
  %53 = icmp slt i64 %52, 56, !dbg !168
  br i1 %53, label %54, label %72, !dbg !168

54:                                               ; preds = %51
  %55 = add i64 %42, %46, !dbg !168
  %56 = add i64 %43, %49, !dbg !168
  %57 = add i64 %44, %52, !dbg !168
  %58 = mul i64 %55, 50176, !dbg !168
  %59 = mul i64 %56, 224, !dbg !168
  %60 = add i64 %58, %59, !dbg !168
  %61 = add i64 %60, %57, !dbg !168
  %62 = getelementptr float, ptr %15, i64 %61, !dbg !168
  %63 = load <4 x float>, ptr %62, align 4, !dbg !168
  %64 = add i64 %56, 1, !dbg !168
  %65 = add i64 %57, 1, !dbg !168
  %66 = mul i64 %55, 51076, !dbg !168
  %67 = mul i64 %64, 226, !dbg !168
  %68 = add i64 %66, %67, !dbg !168
  %69 = add i64 %68, %65, !dbg !168
  %70 = getelementptr float, ptr %22, i64 %69, !dbg !168
  store <4 x float> %63, ptr %70, align 4, !dbg !168
  %71 = add i64 %52, 4, !dbg !168
  br label %51, !dbg !168

72:                                               ; preds = %51
  %73 = add i64 %49, 1, !dbg !168
  br label %48, !dbg !168

74:                                               ; preds = %48
  %75 = add i64 %46, 1, !dbg !168
  br label %45, !dbg !168

76:                                               ; preds = %45
  ret i32 0, !dbg !169
}

define internal i32 @infer_dispatch_5_conv_128x224x224x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !170 {
  %4 = alloca float, i64 4, align 64, !dbg !171
  %5 = alloca float, i64 4, align 64, !dbg !172
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !173
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 9, !dbg !173
  %8 = load i32, ptr %7, align 4, !dbg !173
  %9 = getelementptr i32, ptr %7, i32 1, !dbg !174
  %10 = load i32, ptr %9, align 4, !dbg !174
  %11 = getelementptr i32, ptr %7, i32 2, !dbg !175
  %12 = load i32, ptr %11, align 4, !dbg !175
  %13 = getelementptr i32, ptr %7, i32 3, !dbg !176
  %14 = load i32, ptr %13, align 4, !dbg !176
  %15 = zext i32 %8 to i64, !dbg !177
  %16 = zext i32 %10 to i64, !dbg !178
  %17 = zext i32 %12 to i64, !dbg !179
  %18 = zext i32 %14 to i64, !dbg !180
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !181
  %20 = load ptr, ptr %19, align 8, !dbg !181
  %21 = mul i64 %15, 8, !dbg !181
  %22 = udiv i64 %21, 32, !dbg !181
  %23 = getelementptr float, ptr %20, i64 %22, !dbg !181
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !181
  %24 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !182
  %25 = extractvalue %iree_hal_executable_dispatch_state_v0_t %24, 10, !dbg !182
  %26 = getelementptr ptr, ptr %25, i32 1, !dbg !182
  %27 = load ptr, ptr %26, align 8, !dbg !182
  %28 = mul i64 %16, 8, !dbg !182
  %29 = udiv i64 %28, 32, !dbg !182
  %30 = getelementptr float, ptr %27, i64 %29, !dbg !182
  call void @llvm.assume(i1 true) [ "align"(ptr %30, i64 64) ], !dbg !182
  %31 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !183
  %32 = extractvalue %iree_hal_executable_dispatch_state_v0_t %31, 10, !dbg !183
  %33 = getelementptr ptr, ptr %32, i32 1, !dbg !183
  %34 = load ptr, ptr %33, align 8, !dbg !183
  %35 = mul i64 %17, 8, !dbg !183
  %36 = udiv i64 %35, 32, !dbg !183
  %37 = getelementptr float, ptr %34, i64 %36, !dbg !183
  call void @llvm.assume(i1 true) [ "align"(ptr %37, i64 64) ], !dbg !183
  %38 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !184
  %39 = extractvalue %iree_hal_executable_dispatch_state_v0_t %38, 10, !dbg !184
  %40 = getelementptr ptr, ptr %39, i32 2, !dbg !184
  %41 = load ptr, ptr %40, align 8, !dbg !184
  %42 = mul i64 %18, 8, !dbg !184
  %43 = udiv i64 %42, 32, !dbg !184
  %44 = getelementptr float, ptr %41, i64 %43, !dbg !184
  call void @llvm.assume(i1 true) [ "align"(ptr %44, i64 64) ], !dbg !184
  %45 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !171
  %46 = extractvalue %iree_hal_executable_workgroup_state_v0_t %45, 0, !dbg !171
  %47 = zext i32 %46 to i64, !dbg !171
  %48 = sdiv i64 %47, 49, !dbg !171
  %49 = mul i64 %48, 49, !dbg !171
  %50 = icmp ne i64 %47, %49, !dbg !171
  %51 = icmp slt i64 %47, 0, !dbg !171
  %52 = and i1 %50, %51, !dbg !171
  %53 = add i64 %48, -1, !dbg !171
  %54 = select i1 %52, i64 %53, i64 %48, !dbg !171
  %55 = srem i64 %47, 49, !dbg !171
  %56 = icmp slt i64 %55, 0, !dbg !171
  %57 = add nsw i64 %55, 49, !dbg !171
  %58 = select i1 %56, i64 %57, i64 %55, !dbg !171
  %59 = sdiv i64 %58, 7, !dbg !171
  %60 = srem i64 %47, 7, !dbg !171
  %61 = icmp slt i64 %60, 0, !dbg !171
  %62 = add nsw i64 %60, 7, !dbg !171
  %63 = select i1 %61, i64 %62, i64 %60, !dbg !171
  %64 = mul nsw i64 %54, 32, !dbg !171
  %65 = mul nsw i64 %59, 32, !dbg !171
  %66 = mul nsw i64 %63, 32, !dbg !171
  %67 = getelementptr float, ptr %5, i64 0, !dbg !185
  store <4 x float> zeroinitializer, ptr %67, align 4, !dbg !185
  br label %68, !dbg !171

68:                                               ; preds = %160, %3
  %69 = phi i64 [ %161, %160 ], [ 0, %3 ], !dbg !171
  %70 = icmp slt i64 %69, 32, !dbg !171
  br i1 %70, label %71, label %162, !dbg !171

71:                                               ; preds = %68
  %72 = add i64 %69, %64, !dbg !171
  %73 = getelementptr float, ptr %37, i64 %72, !dbg !186
  %74 = load <1 x float>, ptr %73, align 4, !dbg !186
  br label %75, !dbg !171

75:                                               ; preds = %158, %71
  %76 = phi i64 [ %159, %158 ], [ 0, %71 ], !dbg !171
  %77 = icmp slt i64 %76, 32, !dbg !171
  br i1 %77, label %78, label %160, !dbg !171

78:                                               ; preds = %136, %75
  %79 = phi i64 [ %157, %136 ], [ 0, %75 ], !dbg !171
  %80 = icmp slt i64 %79, 32, !dbg !171
  br i1 %80, label %81, label %158, !dbg !171

81:                                               ; preds = %78
  %82 = add i64 %79, %66, !dbg !171
  br label %83, !dbg !171

83:                                               ; preds = %86, %81
  %84 = phi i64 [ %91, %86 ], [ 0, %81 ], !dbg !171
  %85 = icmp slt i64 %84, 4, !dbg !171
  br i1 %85, label %86, label %92, !dbg !171

86:                                               ; preds = %83
  %87 = add nuw nsw i64 0, %84, !dbg !171
  %88 = getelementptr inbounds nuw float, ptr %5, i64 %87, !dbg !171
  %89 = load float, ptr %88, align 4, !dbg !171
  %90 = getelementptr inbounds nuw float, ptr %4, i64 %87, !dbg !171
  store float %89, ptr %90, align 4, !dbg !171
  %91 = add i64 %84, 1, !dbg !171
  br label %83, !dbg !171

92:                                               ; preds = %134, %83
  %93 = phi i64 [ %135, %134 ], [ 0, %83 ], !dbg !171
  %94 = icmp slt i64 %93, 128, !dbg !171
  br i1 %94, label %95, label %136, !dbg !171

95:                                               ; preds = %132, %92
  %96 = phi i64 [ %133, %132 ], [ 0, %92 ], !dbg !171
  %97 = icmp slt i64 %96, 3, !dbg !171
  br i1 %97, label %98, label %134, !dbg !171

98:                                               ; preds = %95
  %99 = add i64 %96, %76, !dbg !171
  %100 = add i64 %99, %65, !dbg !171
  br label %101, !dbg !171

101:                                              ; preds = %130, %98
  %102 = phi i64 [ %131, %130 ], [ 0, %98 ], !dbg !171
  %103 = icmp slt i64 %102, 4, !dbg !171
  br i1 %103, label %104, label %132, !dbg !171

104:                                              ; preds = %107, %101
  %105 = phi i64 [ %129, %107 ], [ 0, %101 ], !dbg !171
  %106 = icmp slt i64 %105, 3, !dbg !171
  br i1 %106, label %107, label %130, !dbg !171

107:                                              ; preds = %104
  %108 = add i64 %82, %102, !dbg !171
  %109 = add i64 %108, %105, !dbg !171
  %110 = mul nuw nsw i64 %93, 51076, !dbg !171
  %111 = mul nuw nsw i64 %100, 226, !dbg !171
  %112 = add nuw nsw i64 %110, %111, !dbg !171
  %113 = add nuw nsw i64 %112, %109, !dbg !171
  %114 = getelementptr inbounds nuw float, ptr %23, i64 %113, !dbg !171
  %115 = load float, ptr %114, align 4, !dbg !171
  %116 = mul nuw nsw i64 %72, 1152, !dbg !171
  %117 = mul nuw nsw i64 %93, 9, !dbg !171
  %118 = add nuw nsw i64 %116, %117, !dbg !171
  %119 = mul nuw nsw i64 %96, 3, !dbg !171
  %120 = add nuw nsw i64 %118, %119, !dbg !171
  %121 = add nuw nsw i64 %120, %105, !dbg !171
  %122 = getelementptr inbounds nuw float, ptr %30, i64 %121, !dbg !171
  %123 = load float, ptr %122, align 4, !dbg !171
  %124 = add nuw nsw i64 0, %102, !dbg !171
  %125 = getelementptr inbounds nuw float, ptr %4, i64 %124, !dbg !171
  %126 = load float, ptr %125, align 4, !dbg !171
  %127 = fmul contract float %115, %123, !dbg !187
  %128 = fadd contract float %126, %127, !dbg !188
  store float %128, ptr %125, align 4, !dbg !171
  %129 = add i64 %105, 1, !dbg !171
  br label %104, !dbg !171

130:                                              ; preds = %104
  %131 = add i64 %102, 1, !dbg !171
  br label %101, !dbg !171

132:                                              ; preds = %101
  %133 = add i64 %96, 1, !dbg !171
  br label %95, !dbg !171

134:                                              ; preds = %95
  %135 = add i64 %93, 1, !dbg !171
  br label %92, !dbg !171

136:                                              ; preds = %92
  %137 = getelementptr float, ptr %4, i64 0, !dbg !186
  %138 = load <4 x float>, ptr %137, align 4, !dbg !186
  %139 = extractelement <1 x float> %74, i64 0, !dbg !189
  %140 = insertelement <4 x float> poison, float %139, i32 0, !dbg !189
  %141 = shufflevector <4 x float> %140, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !189
  %142 = fadd contract <4 x float> %138, %141, !dbg !189
  %143 = fcmp olt <4 x float> zeroinitializer, %142, !dbg !190
  %144 = select <4 x i1> %143, <4 x float> zeroinitializer, <4 x float> %142, !dbg !191
  %145 = fmul contract <4 x float> %144, splat (float 0x3FC99999A0000000), !dbg !192
  %146 = fcmp ogt <4 x float> zeroinitializer, %142, !dbg !193
  %147 = select <4 x i1> %146, <4 x float> zeroinitializer, <4 x float> %142, !dbg !194
  %148 = fadd contract <4 x float> %147, %145, !dbg !195
  %149 = add i64 %65, %76, !dbg !171
  %150 = add i64 %149, 1, !dbg !171
  %151 = add i64 %82, 1, !dbg !171
  %152 = mul i64 %72, 51076, !dbg !171
  %153 = mul i64 %150, 226, !dbg !171
  %154 = add i64 %152, %153, !dbg !171
  %155 = add i64 %154, %151, !dbg !171
  %156 = getelementptr float, ptr %44, i64 %155, !dbg !171
  store <4 x float> %148, ptr %156, align 4, !dbg !171
  %157 = add i64 %79, 4, !dbg !171
  br label %78, !dbg !171

158:                                              ; preds = %78
  %159 = add i64 %76, 1, !dbg !171
  br label %75, !dbg !171

160:                                              ; preds = %75
  %161 = add i64 %69, 1, !dbg !171
  br label %68, !dbg !171

162:                                              ; preds = %68
  ret i32 0, !dbg !196
}

define internal i32 @infer_dispatch_6_conv_128x224x224x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !197 {
  %4 = alloca float, i64 4, align 64, !dbg !198
  %5 = alloca float, i64 4, align 64, !dbg !199
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !200
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 9, !dbg !200
  %8 = load i32, ptr %7, align 4, !dbg !200
  %9 = getelementptr i32, ptr %7, i32 1, !dbg !201
  %10 = load i32, ptr %9, align 4, !dbg !201
  %11 = getelementptr i32, ptr %7, i32 2, !dbg !202
  %12 = load i32, ptr %11, align 4, !dbg !202
  %13 = getelementptr i32, ptr %7, i32 3, !dbg !203
  %14 = load i32, ptr %13, align 4, !dbg !203
  %15 = getelementptr i32, ptr %7, i32 4, !dbg !204
  %16 = load i32, ptr %15, align 4, !dbg !204
  %17 = zext i32 %8 to i64, !dbg !205
  %18 = zext i32 %10 to i64, !dbg !206
  %19 = zext i32 %12 to i64, !dbg !207
  %20 = zext i32 %14 to i64, !dbg !208
  %21 = zext i32 %16 to i64, !dbg !209
  %22 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !210
  %23 = load ptr, ptr %22, align 8, !dbg !210
  %24 = mul i64 %17, 8, !dbg !210
  %25 = udiv i64 %24, 32, !dbg !210
  %26 = getelementptr float, ptr %23, i64 %25, !dbg !210
  call void @llvm.assume(i1 true) [ "align"(ptr %26, i64 64) ], !dbg !210
  %27 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !211
  %28 = extractvalue %iree_hal_executable_dispatch_state_v0_t %27, 10, !dbg !211
  %29 = getelementptr ptr, ptr %28, i32 1, !dbg !211
  %30 = load ptr, ptr %29, align 8, !dbg !211
  %31 = mul i64 %19, 8, !dbg !211
  %32 = udiv i64 %31, 32, !dbg !211
  %33 = getelementptr float, ptr %30, i64 %32, !dbg !211
  call void @llvm.assume(i1 true) [ "align"(ptr %33, i64 64) ], !dbg !211
  %34 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !212
  %35 = extractvalue %iree_hal_executable_dispatch_state_v0_t %34, 10, !dbg !212
  %36 = load ptr, ptr %35, align 8, !dbg !212
  %37 = mul i64 %18, 8, !dbg !212
  %38 = udiv i64 %37, 32, !dbg !212
  %39 = getelementptr float, ptr %36, i64 %38, !dbg !212
  call void @llvm.assume(i1 true) [ "align"(ptr %39, i64 64) ], !dbg !212
  %40 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !213
  %41 = extractvalue %iree_hal_executable_dispatch_state_v0_t %40, 10, !dbg !213
  %42 = getelementptr ptr, ptr %41, i32 1, !dbg !213
  %43 = load ptr, ptr %42, align 8, !dbg !213
  %44 = mul i64 %20, 8, !dbg !213
  %45 = udiv i64 %44, 32, !dbg !213
  %46 = getelementptr float, ptr %43, i64 %45, !dbg !213
  call void @llvm.assume(i1 true) [ "align"(ptr %46, i64 64) ], !dbg !213
  %47 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !214
  %48 = extractvalue %iree_hal_executable_dispatch_state_v0_t %47, 10, !dbg !214
  %49 = getelementptr ptr, ptr %48, i32 2, !dbg !214
  %50 = load ptr, ptr %49, align 8, !dbg !214
  %51 = mul i64 %21, 8, !dbg !214
  %52 = udiv i64 %51, 32, !dbg !214
  %53 = getelementptr float, ptr %50, i64 %52, !dbg !214
  call void @llvm.assume(i1 true) [ "align"(ptr %53, i64 64) ], !dbg !214
  %54 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !198
  %55 = extractvalue %iree_hal_executable_workgroup_state_v0_t %54, 0, !dbg !198
  %56 = zext i32 %55 to i64, !dbg !198
  %57 = sdiv i64 %56, 49, !dbg !198
  %58 = mul i64 %57, 49, !dbg !198
  %59 = icmp ne i64 %56, %58, !dbg !198
  %60 = icmp slt i64 %56, 0, !dbg !198
  %61 = and i1 %59, %60, !dbg !198
  %62 = add i64 %57, -1, !dbg !198
  %63 = select i1 %61, i64 %62, i64 %57, !dbg !198
  %64 = srem i64 %56, 49, !dbg !198
  %65 = icmp slt i64 %64, 0, !dbg !198
  %66 = add nsw i64 %64, 49, !dbg !198
  %67 = select i1 %65, i64 %66, i64 %64, !dbg !198
  %68 = sdiv i64 %67, 7, !dbg !198
  %69 = srem i64 %56, 7, !dbg !198
  %70 = icmp slt i64 %69, 0, !dbg !198
  %71 = add nsw i64 %69, 7, !dbg !198
  %72 = select i1 %70, i64 %71, i64 %69, !dbg !198
  %73 = mul nsw i64 %63, 32, !dbg !198
  %74 = mul nsw i64 %68, 32, !dbg !198
  %75 = mul nsw i64 %72, 32, !dbg !198
  %76 = getelementptr float, ptr %5, i64 0, !dbg !215
  store <4 x float> zeroinitializer, ptr %76, align 4, !dbg !215
  br label %77, !dbg !198

77:                                               ; preds = %170, %3
  %78 = phi i64 [ %171, %170 ], [ 0, %3 ], !dbg !198
  %79 = icmp slt i64 %78, 32, !dbg !198
  br i1 %79, label %80, label %172, !dbg !198

80:                                               ; preds = %77
  %81 = add i64 %78, %73, !dbg !198
  %82 = getelementptr float, ptr %46, i64 %81, !dbg !216
  %83 = load <1 x float>, ptr %82, align 4, !dbg !216
  br label %84, !dbg !198

84:                                               ; preds = %168, %80
  %85 = phi i64 [ %169, %168 ], [ 0, %80 ], !dbg !198
  %86 = icmp slt i64 %85, 32, !dbg !198
  br i1 %86, label %87, label %170, !dbg !198

87:                                               ; preds = %145, %84
  %88 = phi i64 [ %167, %145 ], [ 0, %84 ], !dbg !198
  %89 = icmp slt i64 %88, 32, !dbg !198
  br i1 %89, label %90, label %168, !dbg !198

90:                                               ; preds = %87
  %91 = add i64 %88, %75, !dbg !198
  br label %92, !dbg !198

92:                                               ; preds = %95, %90
  %93 = phi i64 [ %100, %95 ], [ 0, %90 ], !dbg !198
  %94 = icmp slt i64 %93, 4, !dbg !198
  br i1 %94, label %95, label %101, !dbg !198

95:                                               ; preds = %92
  %96 = add nuw nsw i64 0, %93, !dbg !198
  %97 = getelementptr inbounds nuw float, ptr %5, i64 %96, !dbg !198
  %98 = load float, ptr %97, align 4, !dbg !198
  %99 = getelementptr inbounds nuw float, ptr %4, i64 %96, !dbg !198
  store float %98, ptr %99, align 4, !dbg !198
  %100 = add i64 %93, 1, !dbg !198
  br label %92, !dbg !198

101:                                              ; preds = %143, %92
  %102 = phi i64 [ %144, %143 ], [ 0, %92 ], !dbg !198
  %103 = icmp slt i64 %102, 128, !dbg !198
  br i1 %103, label %104, label %145, !dbg !198

104:                                              ; preds = %141, %101
  %105 = phi i64 [ %142, %141 ], [ 0, %101 ], !dbg !198
  %106 = icmp slt i64 %105, 3, !dbg !198
  br i1 %106, label %107, label %143, !dbg !198

107:                                              ; preds = %104
  %108 = add i64 %105, %85, !dbg !198
  %109 = add i64 %108, %74, !dbg !198
  br label %110, !dbg !198

110:                                              ; preds = %139, %107
  %111 = phi i64 [ %140, %139 ], [ 0, %107 ], !dbg !198
  %112 = icmp slt i64 %111, 4, !dbg !198
  br i1 %112, label %113, label %141, !dbg !198

113:                                              ; preds = %116, %110
  %114 = phi i64 [ %138, %116 ], [ 0, %110 ], !dbg !198
  %115 = icmp slt i64 %114, 3, !dbg !198
  br i1 %115, label %116, label %139, !dbg !198

116:                                              ; preds = %113
  %117 = add i64 %91, %111, !dbg !198
  %118 = add i64 %117, %114, !dbg !198
  %119 = mul nuw nsw i64 %102, 51076, !dbg !198
  %120 = mul nuw nsw i64 %109, 226, !dbg !198
  %121 = add nuw nsw i64 %119, %120, !dbg !198
  %122 = add nuw nsw i64 %121, %118, !dbg !198
  %123 = getelementptr inbounds nuw float, ptr %26, i64 %122, !dbg !198
  %124 = load float, ptr %123, align 4, !dbg !198
  %125 = mul nuw nsw i64 %81, 1152, !dbg !198
  %126 = mul nuw nsw i64 %102, 9, !dbg !198
  %127 = add nuw nsw i64 %125, %126, !dbg !198
  %128 = mul nuw nsw i64 %105, 3, !dbg !198
  %129 = add nuw nsw i64 %127, %128, !dbg !198
  %130 = add nuw nsw i64 %129, %114, !dbg !198
  %131 = getelementptr inbounds nuw float, ptr %33, i64 %130, !dbg !198
  %132 = load float, ptr %131, align 4, !dbg !198
  %133 = add nuw nsw i64 0, %111, !dbg !198
  %134 = getelementptr inbounds nuw float, ptr %4, i64 %133, !dbg !198
  %135 = load float, ptr %134, align 4, !dbg !198
  %136 = fmul contract float %124, %132, !dbg !217
  %137 = fadd contract float %135, %136, !dbg !218
  store float %137, ptr %134, align 4, !dbg !198
  %138 = add i64 %114, 1, !dbg !198
  br label %113, !dbg !198

139:                                              ; preds = %113
  %140 = add i64 %111, 1, !dbg !198
  br label %110, !dbg !198

141:                                              ; preds = %110
  %142 = add i64 %105, 1, !dbg !198
  br label %104, !dbg !198

143:                                              ; preds = %104
  %144 = add i64 %102, 1, !dbg !198
  br label %101, !dbg !198

145:                                              ; preds = %101
  %146 = add i64 %85, %74, !dbg !216
  %147 = mul i64 %81, 50176, !dbg !216
  %148 = mul i64 %146, 224, !dbg !216
  %149 = add i64 %147, %148, !dbg !216
  %150 = add i64 %149, %91, !dbg !216
  %151 = getelementptr float, ptr %39, i64 %150, !dbg !216
  %152 = load <4 x float>, ptr %151, align 4, !dbg !216
  %153 = getelementptr float, ptr %4, i64 0, !dbg !216
  %154 = load <4 x float>, ptr %153, align 4, !dbg !216
  %155 = extractelement <1 x float> %83, i64 0, !dbg !219
  %156 = insertelement <4 x float> poison, float %155, i32 0, !dbg !219
  %157 = shufflevector <4 x float> %156, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !219
  %158 = fadd contract <4 x float> %154, %157, !dbg !219
  %159 = fcmp olt <4 x float> zeroinitializer, %158, !dbg !220
  %160 = select <4 x i1> %159, <4 x float> zeroinitializer, <4 x float> %158, !dbg !221
  %161 = fmul contract <4 x float> %160, splat (float 0x3FC99999A0000000), !dbg !222
  %162 = fcmp ogt <4 x float> zeroinitializer, %158, !dbg !223
  %163 = select <4 x i1> %162, <4 x float> zeroinitializer, <4 x float> %158, !dbg !224
  %164 = fadd contract <4 x float> %163, %161, !dbg !225
  %165 = fadd contract <4 x float> %152, %164, !dbg !226
  %166 = getelementptr float, ptr %53, i64 %150, !dbg !198
  store <4 x float> %165, ptr %166, align 4, !dbg !198
  %167 = add i64 %88, 4, !dbg !198
  br label %87, !dbg !198

168:                                              ; preds = %87
  %169 = add i64 %85, 1, !dbg !198
  br label %84, !dbg !198

170:                                              ; preds = %84
  %171 = add i64 %78, 1, !dbg !198
  br label %77, !dbg !198

172:                                              ; preds = %77
  ret i32 0, !dbg !227
}

define internal i32 @infer_dispatch_13_elementwise_broadcast_128x112x112_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !228 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !229
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !229
  %6 = load ptr, ptr %5, align 8, !dbg !229
  %7 = getelementptr float, ptr %6, i64 14565888, !dbg !229
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !229
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !230
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !230
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !230
  %11 = load ptr, ptr %10, align 8, !dbg !230
  %12 = getelementptr float, ptr %11, i64 20988416, !dbg !230
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !230
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !231
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !231
  %15 = zext i32 %14 to i64, !dbg !231
  %16 = sdiv i64 %15, 4, !dbg !231
  %17 = mul i64 %16, 4, !dbg !231
  %18 = icmp ne i64 %15, %17, !dbg !231
  %19 = icmp slt i64 %15, 0, !dbg !231
  %20 = and i1 %18, %19, !dbg !231
  %21 = add i64 %16, -1, !dbg !231
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !231
  %23 = srem i64 %15, 4, !dbg !231
  %24 = icmp slt i64 %23, 0, !dbg !231
  %25 = add nsw i64 %23, 4, !dbg !231
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !231
  %27 = sdiv i64 %26, 2, !dbg !231
  %28 = srem i64 %15, 2, !dbg !231
  %29 = icmp slt i64 %28, 0, !dbg !231
  %30 = add nsw i64 %28, 2, !dbg !231
  %31 = select i1 %29, i64 %30, i64 %28, !dbg !231
  %32 = mul nsw i64 %22, 32, !dbg !231
  %33 = mul nsw i64 %27, 56, !dbg !231
  %34 = mul nsw i64 %31, 56, !dbg !231
  br label %35, !dbg !231

35:                                               ; preds = %526, %3
  %36 = phi i64 [ %527, %526 ], [ 0, %3 ], !dbg !231
  %37 = icmp slt i64 %36, 32, !dbg !231
  br i1 %37, label %38, label %528, !dbg !231

38:                                               ; preds = %35
  %39 = add i64 %32, %36, !dbg !232
  %40 = mul i64 %39, 224, !dbg !233
  br label %41, !dbg !231

41:                                               ; preds = %524, %38
  %42 = phi i64 [ %525, %524 ], [ 0, %38 ], !dbg !231
  %43 = icmp slt i64 %42, 56, !dbg !231
  br i1 %43, label %44, label %526, !dbg !231

44:                                               ; preds = %41
  %45 = add i64 %33, %42, !dbg !234
  %46 = sitofp i64 %45 to float, !dbg !235
  %47 = fadd contract float %46, 5.000000e-01, !dbg !236
  %48 = fdiv float %47, 5.000000e-01, !dbg !237
  %49 = fsub contract float %48, 5.000000e-01, !dbg !238
  %50 = fcmp ugt float %49, 0.000000e+00, !dbg !239
  %51 = select i1 %50, float %49, float 0.000000e+00, !dbg !239
  %52 = fcmp ult float %51, 2.230000e+02, !dbg !240
  %53 = select i1 %52, float %51, float 2.230000e+02, !dbg !240
  %54 = call float @llvm.floor.f32(float %53), !dbg !241
  %55 = fadd contract float %53, 1.000000e+00, !dbg !242
  %56 = call float @llvm.floor.f32(float %55), !dbg !243
  %57 = fptosi float %54 to i64, !dbg !244
  %58 = fcmp ult float %55, 2.230000e+02, !dbg !245
  %59 = select i1 %58, float %55, float 2.230000e+02, !dbg !245
  %60 = fptosi float %59 to i64, !dbg !246
  %61 = add i64 %57, %40, !dbg !233
  %62 = mul i64 %61, 224, !dbg !233
  %63 = add i64 %60, %40, !dbg !247
  %64 = mul i64 %63, 224, !dbg !247
  %65 = fsub contract float %56, %53, !dbg !248
  %66 = fsub contract float %53, %54, !dbg !249
  br label %67, !dbg !231

67:                                               ; preds = %70, %44
  %68 = phi i64 [ %523, %70 ], [ 0, %44 ], !dbg !231
  %69 = icmp slt i64 %68, 56, !dbg !231
  br i1 %69, label %70, label %524, !dbg !231

70:                                               ; preds = %67
  %71 = add i64 %34, %68, !dbg !250
  %72 = insertelement <4 x i64> poison, i64 %71, i32 0, !dbg !231
  %73 = shufflevector <4 x i64> %72, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !231
  %74 = add <4 x i64> %73, <i64 0, i64 1, i64 2, i64 3>, !dbg !250
  %75 = sitofp <4 x i64> %74 to <4 x float>, !dbg !251
  %76 = fadd contract <4 x float> %75, splat (float 5.000000e-01), !dbg !252
  %77 = fdiv <4 x float> %76, splat (float 5.000000e-01), !dbg !253
  %78 = fsub contract <4 x float> %77, splat (float 5.000000e-01), !dbg !254
  %79 = fcmp ugt <4 x float> %78, zeroinitializer, !dbg !255
  %80 = select <4 x i1> %79, <4 x float> %78, <4 x float> zeroinitializer, !dbg !255
  %81 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %80, !dbg !255
  %82 = fcmp ult <4 x float> %81, splat (float 2.230000e+02), !dbg !256
  %83 = select <4 x i1> %82, <4 x float> %81, <4 x float> splat (float 2.230000e+02), !dbg !256
  %84 = select <4 x i1> zeroinitializer, <4 x float> splat (float 2.230000e+02), <4 x float> %83, !dbg !256
  %85 = call <4 x float> @llvm.floor.v4f32(<4 x float> %84), !dbg !257
  %86 = fadd contract <4 x float> %84, splat (float 1.000000e+00), !dbg !258
  %87 = call <4 x float> @llvm.floor.v4f32(<4 x float> %86), !dbg !259
  %88 = fptosi <4 x float> %85 to <4 x i64>, !dbg !260
  %89 = fcmp ult <4 x float> %86, splat (float 2.230000e+02), !dbg !261
  %90 = select <4 x i1> %89, <4 x float> %86, <4 x float> splat (float 2.230000e+02), !dbg !261
  %91 = select <4 x i1> zeroinitializer, <4 x float> splat (float 2.230000e+02), <4 x float> %90, !dbg !261
  %92 = fptosi <4 x float> %91 to <4 x i64>, !dbg !262
  %93 = insertelement <4 x i64> poison, i64 %62, i32 0, !dbg !233
  %94 = shufflevector <4 x i64> %93, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !233
  %95 = add <4 x i64> %88, %94, !dbg !233
  %96 = extractelement <4 x i64> %95, i64 0, !dbg !233
  %97 = sdiv i64 %96, 50176, !dbg !233
  %98 = mul i64 %97, 50176, !dbg !233
  %99 = icmp ne i64 %96, %98, !dbg !233
  %100 = icmp slt i64 %96, 0, !dbg !233
  %101 = and i1 %99, %100, !dbg !233
  %102 = add i64 %97, -1, !dbg !233
  %103 = select i1 %101, i64 %102, i64 %97, !dbg !233
  %104 = srem i64 %96, 50176, !dbg !233
  %105 = icmp slt i64 %104, 0, !dbg !233
  %106 = add nsw i64 %104, 50176, !dbg !233
  %107 = select i1 %105, i64 %106, i64 %104, !dbg !233
  %108 = sdiv i64 %107, 224, !dbg !233
  %109 = srem i64 %96, 224, !dbg !233
  %110 = icmp slt i64 %109, 0, !dbg !233
  %111 = add nsw i64 %109, 224, !dbg !233
  %112 = select i1 %110, i64 %111, i64 %109, !dbg !233
  %113 = mul i64 %103, 50176, !dbg !233
  %114 = mul i64 %108, 224, !dbg !233
  %115 = add i64 %113, %114, !dbg !233
  %116 = add i64 %115, %112, !dbg !233
  %117 = getelementptr float, ptr %7, i64 %116, !dbg !233
  %118 = load <1 x float>, ptr %117, align 4, !dbg !233
  %119 = extractelement <1 x float> %118, i64 0, !dbg !233
  %120 = extractelement <4 x i64> %95, i64 1, !dbg !233
  %121 = sdiv i64 %120, 50176, !dbg !233
  %122 = mul i64 %121, 50176, !dbg !233
  %123 = icmp ne i64 %120, %122, !dbg !233
  %124 = icmp slt i64 %120, 0, !dbg !233
  %125 = and i1 %123, %124, !dbg !233
  %126 = add i64 %121, -1, !dbg !233
  %127 = select i1 %125, i64 %126, i64 %121, !dbg !233
  %128 = srem i64 %120, 50176, !dbg !233
  %129 = icmp slt i64 %128, 0, !dbg !233
  %130 = add nsw i64 %128, 50176, !dbg !233
  %131 = select i1 %129, i64 %130, i64 %128, !dbg !233
  %132 = sdiv i64 %131, 224, !dbg !233
  %133 = srem i64 %120, 224, !dbg !233
  %134 = icmp slt i64 %133, 0, !dbg !233
  %135 = add nsw i64 %133, 224, !dbg !233
  %136 = select i1 %134, i64 %135, i64 %133, !dbg !233
  %137 = mul i64 %127, 50176, !dbg !233
  %138 = mul i64 %132, 224, !dbg !233
  %139 = add i64 %137, %138, !dbg !233
  %140 = add i64 %139, %136, !dbg !233
  %141 = getelementptr float, ptr %7, i64 %140, !dbg !233
  %142 = load <1 x float>, ptr %141, align 4, !dbg !233
  %143 = extractelement <1 x float> %142, i64 0, !dbg !233
  %144 = extractelement <4 x i64> %95, i64 2, !dbg !233
  %145 = sdiv i64 %144, 50176, !dbg !233
  %146 = mul i64 %145, 50176, !dbg !233
  %147 = icmp ne i64 %144, %146, !dbg !233
  %148 = icmp slt i64 %144, 0, !dbg !233
  %149 = and i1 %147, %148, !dbg !233
  %150 = add i64 %145, -1, !dbg !233
  %151 = select i1 %149, i64 %150, i64 %145, !dbg !233
  %152 = srem i64 %144, 50176, !dbg !233
  %153 = icmp slt i64 %152, 0, !dbg !233
  %154 = add nsw i64 %152, 50176, !dbg !233
  %155 = select i1 %153, i64 %154, i64 %152, !dbg !233
  %156 = sdiv i64 %155, 224, !dbg !233
  %157 = srem i64 %144, 224, !dbg !233
  %158 = icmp slt i64 %157, 0, !dbg !233
  %159 = add nsw i64 %157, 224, !dbg !233
  %160 = select i1 %158, i64 %159, i64 %157, !dbg !233
  %161 = mul i64 %151, 50176, !dbg !233
  %162 = mul i64 %156, 224, !dbg !233
  %163 = add i64 %161, %162, !dbg !233
  %164 = add i64 %163, %160, !dbg !233
  %165 = getelementptr float, ptr %7, i64 %164, !dbg !233
  %166 = load <1 x float>, ptr %165, align 4, !dbg !233
  %167 = extractelement <1 x float> %166, i64 0, !dbg !233
  %168 = extractelement <4 x i64> %95, i64 3, !dbg !233
  %169 = sdiv i64 %168, 50176, !dbg !233
  %170 = mul i64 %169, 50176, !dbg !233
  %171 = icmp ne i64 %168, %170, !dbg !233
  %172 = icmp slt i64 %168, 0, !dbg !233
  %173 = and i1 %171, %172, !dbg !233
  %174 = add i64 %169, -1, !dbg !233
  %175 = select i1 %173, i64 %174, i64 %169, !dbg !233
  %176 = srem i64 %168, 50176, !dbg !233
  %177 = icmp slt i64 %176, 0, !dbg !233
  %178 = add nsw i64 %176, 50176, !dbg !233
  %179 = select i1 %177, i64 %178, i64 %176, !dbg !233
  %180 = sdiv i64 %179, 224, !dbg !233
  %181 = srem i64 %168, 224, !dbg !233
  %182 = icmp slt i64 %181, 0, !dbg !233
  %183 = add nsw i64 %181, 224, !dbg !233
  %184 = select i1 %182, i64 %183, i64 %181, !dbg !233
  %185 = mul i64 %175, 50176, !dbg !233
  %186 = mul i64 %180, 224, !dbg !233
  %187 = add i64 %185, %186, !dbg !233
  %188 = add i64 %187, %184, !dbg !233
  %189 = getelementptr float, ptr %7, i64 %188, !dbg !233
  %190 = load <1 x float>, ptr %189, align 4, !dbg !233
  %191 = extractelement <1 x float> %190, i64 0, !dbg !233
  %192 = add <4 x i64> %92, %94, !dbg !263
  %193 = extractelement <4 x i64> %192, i64 0, !dbg !263
  %194 = sdiv i64 %193, 50176, !dbg !263
  %195 = mul i64 %194, 50176, !dbg !263
  %196 = icmp ne i64 %193, %195, !dbg !263
  %197 = icmp slt i64 %193, 0, !dbg !263
  %198 = and i1 %196, %197, !dbg !263
  %199 = add i64 %194, -1, !dbg !263
  %200 = select i1 %198, i64 %199, i64 %194, !dbg !263
  %201 = srem i64 %193, 50176, !dbg !263
  %202 = icmp slt i64 %201, 0, !dbg !263
  %203 = add nsw i64 %201, 50176, !dbg !263
  %204 = select i1 %202, i64 %203, i64 %201, !dbg !263
  %205 = sdiv i64 %204, 224, !dbg !263
  %206 = srem i64 %193, 224, !dbg !263
  %207 = icmp slt i64 %206, 0, !dbg !263
  %208 = add nsw i64 %206, 224, !dbg !263
  %209 = select i1 %207, i64 %208, i64 %206, !dbg !263
  %210 = mul i64 %200, 50176, !dbg !263
  %211 = mul i64 %205, 224, !dbg !263
  %212 = add i64 %210, %211, !dbg !263
  %213 = add i64 %212, %209, !dbg !263
  %214 = getelementptr float, ptr %7, i64 %213, !dbg !263
  %215 = load <1 x float>, ptr %214, align 4, !dbg !263
  %216 = extractelement <1 x float> %215, i64 0, !dbg !263
  %217 = extractelement <4 x i64> %192, i64 1, !dbg !263
  %218 = sdiv i64 %217, 50176, !dbg !263
  %219 = mul i64 %218, 50176, !dbg !263
  %220 = icmp ne i64 %217, %219, !dbg !263
  %221 = icmp slt i64 %217, 0, !dbg !263
  %222 = and i1 %220, %221, !dbg !263
  %223 = add i64 %218, -1, !dbg !263
  %224 = select i1 %222, i64 %223, i64 %218, !dbg !263
  %225 = srem i64 %217, 50176, !dbg !263
  %226 = icmp slt i64 %225, 0, !dbg !263
  %227 = add nsw i64 %225, 50176, !dbg !263
  %228 = select i1 %226, i64 %227, i64 %225, !dbg !263
  %229 = sdiv i64 %228, 224, !dbg !263
  %230 = srem i64 %217, 224, !dbg !263
  %231 = icmp slt i64 %230, 0, !dbg !263
  %232 = add nsw i64 %230, 224, !dbg !263
  %233 = select i1 %231, i64 %232, i64 %230, !dbg !263
  %234 = mul i64 %224, 50176, !dbg !263
  %235 = mul i64 %229, 224, !dbg !263
  %236 = add i64 %234, %235, !dbg !263
  %237 = add i64 %236, %233, !dbg !263
  %238 = getelementptr float, ptr %7, i64 %237, !dbg !263
  %239 = load <1 x float>, ptr %238, align 4, !dbg !263
  %240 = extractelement <1 x float> %239, i64 0, !dbg !263
  %241 = extractelement <4 x i64> %192, i64 2, !dbg !263
  %242 = sdiv i64 %241, 50176, !dbg !263
  %243 = mul i64 %242, 50176, !dbg !263
  %244 = icmp ne i64 %241, %243, !dbg !263
  %245 = icmp slt i64 %241, 0, !dbg !263
  %246 = and i1 %244, %245, !dbg !263
  %247 = add i64 %242, -1, !dbg !263
  %248 = select i1 %246, i64 %247, i64 %242, !dbg !263
  %249 = srem i64 %241, 50176, !dbg !263
  %250 = icmp slt i64 %249, 0, !dbg !263
  %251 = add nsw i64 %249, 50176, !dbg !263
  %252 = select i1 %250, i64 %251, i64 %249, !dbg !263
  %253 = sdiv i64 %252, 224, !dbg !263
  %254 = srem i64 %241, 224, !dbg !263
  %255 = icmp slt i64 %254, 0, !dbg !263
  %256 = add nsw i64 %254, 224, !dbg !263
  %257 = select i1 %255, i64 %256, i64 %254, !dbg !263
  %258 = mul i64 %248, 50176, !dbg !263
  %259 = mul i64 %253, 224, !dbg !263
  %260 = add i64 %258, %259, !dbg !263
  %261 = add i64 %260, %257, !dbg !263
  %262 = getelementptr float, ptr %7, i64 %261, !dbg !263
  %263 = load <1 x float>, ptr %262, align 4, !dbg !263
  %264 = extractelement <1 x float> %263, i64 0, !dbg !263
  %265 = extractelement <4 x i64> %192, i64 3, !dbg !263
  %266 = sdiv i64 %265, 50176, !dbg !263
  %267 = mul i64 %266, 50176, !dbg !263
  %268 = icmp ne i64 %265, %267, !dbg !263
  %269 = icmp slt i64 %265, 0, !dbg !263
  %270 = and i1 %268, %269, !dbg !263
  %271 = add i64 %266, -1, !dbg !263
  %272 = select i1 %270, i64 %271, i64 %266, !dbg !263
  %273 = srem i64 %265, 50176, !dbg !263
  %274 = icmp slt i64 %273, 0, !dbg !263
  %275 = add nsw i64 %273, 50176, !dbg !263
  %276 = select i1 %274, i64 %275, i64 %273, !dbg !263
  %277 = sdiv i64 %276, 224, !dbg !263
  %278 = srem i64 %265, 224, !dbg !263
  %279 = icmp slt i64 %278, 0, !dbg !263
  %280 = add nsw i64 %278, 224, !dbg !263
  %281 = select i1 %279, i64 %280, i64 %278, !dbg !263
  %282 = mul i64 %272, 50176, !dbg !263
  %283 = mul i64 %277, 224, !dbg !263
  %284 = add i64 %282, %283, !dbg !263
  %285 = add i64 %284, %281, !dbg !263
  %286 = getelementptr float, ptr %7, i64 %285, !dbg !263
  %287 = load <1 x float>, ptr %286, align 4, !dbg !263
  %288 = extractelement <1 x float> %287, i64 0, !dbg !263
  %289 = insertelement <4 x i64> poison, i64 %64, i32 0, !dbg !247
  %290 = shufflevector <4 x i64> %289, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !247
  %291 = add <4 x i64> %88, %290, !dbg !247
  %292 = extractelement <4 x i64> %291, i64 0, !dbg !247
  %293 = sdiv i64 %292, 50176, !dbg !247
  %294 = mul i64 %293, 50176, !dbg !247
  %295 = icmp ne i64 %292, %294, !dbg !247
  %296 = icmp slt i64 %292, 0, !dbg !247
  %297 = and i1 %295, %296, !dbg !247
  %298 = add i64 %293, -1, !dbg !247
  %299 = select i1 %297, i64 %298, i64 %293, !dbg !247
  %300 = srem i64 %292, 50176, !dbg !247
  %301 = icmp slt i64 %300, 0, !dbg !247
  %302 = add nsw i64 %300, 50176, !dbg !247
  %303 = select i1 %301, i64 %302, i64 %300, !dbg !247
  %304 = sdiv i64 %303, 224, !dbg !247
  %305 = srem i64 %292, 224, !dbg !247
  %306 = icmp slt i64 %305, 0, !dbg !247
  %307 = add nsw i64 %305, 224, !dbg !247
  %308 = select i1 %306, i64 %307, i64 %305, !dbg !247
  %309 = mul i64 %299, 50176, !dbg !247
  %310 = mul i64 %304, 224, !dbg !247
  %311 = add i64 %309, %310, !dbg !247
  %312 = add i64 %311, %308, !dbg !247
  %313 = getelementptr float, ptr %7, i64 %312, !dbg !247
  %314 = load <1 x float>, ptr %313, align 4, !dbg !247
  %315 = extractelement <1 x float> %314, i64 0, !dbg !247
  %316 = extractelement <4 x i64> %291, i64 1, !dbg !247
  %317 = sdiv i64 %316, 50176, !dbg !247
  %318 = mul i64 %317, 50176, !dbg !247
  %319 = icmp ne i64 %316, %318, !dbg !247
  %320 = icmp slt i64 %316, 0, !dbg !247
  %321 = and i1 %319, %320, !dbg !247
  %322 = add i64 %317, -1, !dbg !247
  %323 = select i1 %321, i64 %322, i64 %317, !dbg !247
  %324 = srem i64 %316, 50176, !dbg !247
  %325 = icmp slt i64 %324, 0, !dbg !247
  %326 = add nsw i64 %324, 50176, !dbg !247
  %327 = select i1 %325, i64 %326, i64 %324, !dbg !247
  %328 = sdiv i64 %327, 224, !dbg !247
  %329 = srem i64 %316, 224, !dbg !247
  %330 = icmp slt i64 %329, 0, !dbg !247
  %331 = add nsw i64 %329, 224, !dbg !247
  %332 = select i1 %330, i64 %331, i64 %329, !dbg !247
  %333 = mul i64 %323, 50176, !dbg !247
  %334 = mul i64 %328, 224, !dbg !247
  %335 = add i64 %333, %334, !dbg !247
  %336 = add i64 %335, %332, !dbg !247
  %337 = getelementptr float, ptr %7, i64 %336, !dbg !247
  %338 = load <1 x float>, ptr %337, align 4, !dbg !247
  %339 = extractelement <1 x float> %338, i64 0, !dbg !247
  %340 = extractelement <4 x i64> %291, i64 2, !dbg !247
  %341 = sdiv i64 %340, 50176, !dbg !247
  %342 = mul i64 %341, 50176, !dbg !247
  %343 = icmp ne i64 %340, %342, !dbg !247
  %344 = icmp slt i64 %340, 0, !dbg !247
  %345 = and i1 %343, %344, !dbg !247
  %346 = add i64 %341, -1, !dbg !247
  %347 = select i1 %345, i64 %346, i64 %341, !dbg !247
  %348 = srem i64 %340, 50176, !dbg !247
  %349 = icmp slt i64 %348, 0, !dbg !247
  %350 = add nsw i64 %348, 50176, !dbg !247
  %351 = select i1 %349, i64 %350, i64 %348, !dbg !247
  %352 = sdiv i64 %351, 224, !dbg !247
  %353 = srem i64 %340, 224, !dbg !247
  %354 = icmp slt i64 %353, 0, !dbg !247
  %355 = add nsw i64 %353, 224, !dbg !247
  %356 = select i1 %354, i64 %355, i64 %353, !dbg !247
  %357 = mul i64 %347, 50176, !dbg !247
  %358 = mul i64 %352, 224, !dbg !247
  %359 = add i64 %357, %358, !dbg !247
  %360 = add i64 %359, %356, !dbg !247
  %361 = getelementptr float, ptr %7, i64 %360, !dbg !247
  %362 = load <1 x float>, ptr %361, align 4, !dbg !247
  %363 = extractelement <1 x float> %362, i64 0, !dbg !247
  %364 = extractelement <4 x i64> %291, i64 3, !dbg !247
  %365 = sdiv i64 %364, 50176, !dbg !247
  %366 = mul i64 %365, 50176, !dbg !247
  %367 = icmp ne i64 %364, %366, !dbg !247
  %368 = icmp slt i64 %364, 0, !dbg !247
  %369 = and i1 %367, %368, !dbg !247
  %370 = add i64 %365, -1, !dbg !247
  %371 = select i1 %369, i64 %370, i64 %365, !dbg !247
  %372 = srem i64 %364, 50176, !dbg !247
  %373 = icmp slt i64 %372, 0, !dbg !247
  %374 = add nsw i64 %372, 50176, !dbg !247
  %375 = select i1 %373, i64 %374, i64 %372, !dbg !247
  %376 = sdiv i64 %375, 224, !dbg !247
  %377 = srem i64 %364, 224, !dbg !247
  %378 = icmp slt i64 %377, 0, !dbg !247
  %379 = add nsw i64 %377, 224, !dbg !247
  %380 = select i1 %378, i64 %379, i64 %377, !dbg !247
  %381 = mul i64 %371, 50176, !dbg !247
  %382 = mul i64 %376, 224, !dbg !247
  %383 = add i64 %381, %382, !dbg !247
  %384 = add i64 %383, %380, !dbg !247
  %385 = getelementptr float, ptr %7, i64 %384, !dbg !247
  %386 = load <1 x float>, ptr %385, align 4, !dbg !247
  %387 = extractelement <1 x float> %386, i64 0, !dbg !247
  %388 = add <4 x i64> %92, %290, !dbg !264
  %389 = extractelement <4 x i64> %388, i64 0, !dbg !264
  %390 = sdiv i64 %389, 50176, !dbg !264
  %391 = mul i64 %390, 50176, !dbg !264
  %392 = icmp ne i64 %389, %391, !dbg !264
  %393 = icmp slt i64 %389, 0, !dbg !264
  %394 = and i1 %392, %393, !dbg !264
  %395 = add i64 %390, -1, !dbg !264
  %396 = select i1 %394, i64 %395, i64 %390, !dbg !264
  %397 = srem i64 %389, 50176, !dbg !264
  %398 = icmp slt i64 %397, 0, !dbg !264
  %399 = add nsw i64 %397, 50176, !dbg !264
  %400 = select i1 %398, i64 %399, i64 %397, !dbg !264
  %401 = sdiv i64 %400, 224, !dbg !264
  %402 = srem i64 %389, 224, !dbg !264
  %403 = icmp slt i64 %402, 0, !dbg !264
  %404 = add nsw i64 %402, 224, !dbg !264
  %405 = select i1 %403, i64 %404, i64 %402, !dbg !264
  %406 = mul i64 %396, 50176, !dbg !264
  %407 = mul i64 %401, 224, !dbg !264
  %408 = add i64 %406, %407, !dbg !264
  %409 = add i64 %408, %405, !dbg !264
  %410 = getelementptr float, ptr %7, i64 %409, !dbg !264
  %411 = load <1 x float>, ptr %410, align 4, !dbg !264
  %412 = extractelement <1 x float> %411, i64 0, !dbg !264
  %413 = extractelement <4 x i64> %388, i64 1, !dbg !264
  %414 = sdiv i64 %413, 50176, !dbg !264
  %415 = mul i64 %414, 50176, !dbg !264
  %416 = icmp ne i64 %413, %415, !dbg !264
  %417 = icmp slt i64 %413, 0, !dbg !264
  %418 = and i1 %416, %417, !dbg !264
  %419 = add i64 %414, -1, !dbg !264
  %420 = select i1 %418, i64 %419, i64 %414, !dbg !264
  %421 = srem i64 %413, 50176, !dbg !264
  %422 = icmp slt i64 %421, 0, !dbg !264
  %423 = add nsw i64 %421, 50176, !dbg !264
  %424 = select i1 %422, i64 %423, i64 %421, !dbg !264
  %425 = sdiv i64 %424, 224, !dbg !264
  %426 = srem i64 %413, 224, !dbg !264
  %427 = icmp slt i64 %426, 0, !dbg !264
  %428 = add nsw i64 %426, 224, !dbg !264
  %429 = select i1 %427, i64 %428, i64 %426, !dbg !264
  %430 = mul i64 %420, 50176, !dbg !264
  %431 = mul i64 %425, 224, !dbg !264
  %432 = add i64 %430, %431, !dbg !264
  %433 = add i64 %432, %429, !dbg !264
  %434 = getelementptr float, ptr %7, i64 %433, !dbg !264
  %435 = load <1 x float>, ptr %434, align 4, !dbg !264
  %436 = extractelement <1 x float> %435, i64 0, !dbg !264
  %437 = extractelement <4 x i64> %388, i64 2, !dbg !264
  %438 = sdiv i64 %437, 50176, !dbg !264
  %439 = mul i64 %438, 50176, !dbg !264
  %440 = icmp ne i64 %437, %439, !dbg !264
  %441 = icmp slt i64 %437, 0, !dbg !264
  %442 = and i1 %440, %441, !dbg !264
  %443 = add i64 %438, -1, !dbg !264
  %444 = select i1 %442, i64 %443, i64 %438, !dbg !264
  %445 = srem i64 %437, 50176, !dbg !264
  %446 = icmp slt i64 %445, 0, !dbg !264
  %447 = add nsw i64 %445, 50176, !dbg !264
  %448 = select i1 %446, i64 %447, i64 %445, !dbg !264
  %449 = sdiv i64 %448, 224, !dbg !264
  %450 = srem i64 %437, 224, !dbg !264
  %451 = icmp slt i64 %450, 0, !dbg !264
  %452 = add nsw i64 %450, 224, !dbg !264
  %453 = select i1 %451, i64 %452, i64 %450, !dbg !264
  %454 = mul i64 %444, 50176, !dbg !264
  %455 = mul i64 %449, 224, !dbg !264
  %456 = add i64 %454, %455, !dbg !264
  %457 = add i64 %456, %453, !dbg !264
  %458 = getelementptr float, ptr %7, i64 %457, !dbg !264
  %459 = load <1 x float>, ptr %458, align 4, !dbg !264
  %460 = extractelement <1 x float> %459, i64 0, !dbg !264
  %461 = extractelement <4 x i64> %388, i64 3, !dbg !264
  %462 = sdiv i64 %461, 50176, !dbg !264
  %463 = mul i64 %462, 50176, !dbg !264
  %464 = icmp ne i64 %461, %463, !dbg !264
  %465 = icmp slt i64 %461, 0, !dbg !264
  %466 = and i1 %464, %465, !dbg !264
  %467 = add i64 %462, -1, !dbg !264
  %468 = select i1 %466, i64 %467, i64 %462, !dbg !264
  %469 = srem i64 %461, 50176, !dbg !264
  %470 = icmp slt i64 %469, 0, !dbg !264
  %471 = add nsw i64 %469, 50176, !dbg !264
  %472 = select i1 %470, i64 %471, i64 %469, !dbg !264
  %473 = sdiv i64 %472, 224, !dbg !264
  %474 = srem i64 %461, 224, !dbg !264
  %475 = icmp slt i64 %474, 0, !dbg !264
  %476 = add nsw i64 %474, 224, !dbg !264
  %477 = select i1 %475, i64 %476, i64 %474, !dbg !264
  %478 = mul i64 %468, 50176, !dbg !264
  %479 = mul i64 %473, 224, !dbg !264
  %480 = add i64 %478, %479, !dbg !264
  %481 = add i64 %480, %477, !dbg !264
  %482 = getelementptr float, ptr %7, i64 %481, !dbg !264
  %483 = load <1 x float>, ptr %482, align 4, !dbg !264
  %484 = extractelement <1 x float> %483, i64 0, !dbg !264
  %485 = fsub contract <4 x float> %87, %84, !dbg !265
  %486 = fsub contract <4 x float> %84, %85, !dbg !266
  %487 = insertelement <4 x float> poison, float %119, i64 0, !dbg !267
  %488 = insertelement <4 x float> %487, float %143, i64 1, !dbg !267
  %489 = insertelement <4 x float> %488, float %167, i64 2, !dbg !267
  %490 = insertelement <4 x float> %489, float %191, i64 3, !dbg !267
  %491 = fmul contract <4 x float> %485, %490, !dbg !267
  %492 = insertelement <4 x float> poison, float %216, i64 0, !dbg !268
  %493 = insertelement <4 x float> %492, float %240, i64 1, !dbg !268
  %494 = insertelement <4 x float> %493, float %264, i64 2, !dbg !268
  %495 = insertelement <4 x float> %494, float %288, i64 3, !dbg !268
  %496 = fmul contract <4 x float> %486, %495, !dbg !268
  %497 = fadd contract <4 x float> %491, %496, !dbg !269
  %498 = insertelement <4 x float> poison, float %65, i32 0, !dbg !270
  %499 = shufflevector <4 x float> %498, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !270
  %500 = fmul contract <4 x float> %499, %497, !dbg !270
  %501 = insertelement <4 x float> poison, float %315, i64 0, !dbg !271
  %502 = insertelement <4 x float> %501, float %339, i64 1, !dbg !271
  %503 = insertelement <4 x float> %502, float %363, i64 2, !dbg !271
  %504 = insertelement <4 x float> %503, float %387, i64 3, !dbg !271
  %505 = fmul contract <4 x float> %485, %504, !dbg !271
  %506 = insertelement <4 x float> poison, float %412, i64 0, !dbg !272
  %507 = insertelement <4 x float> %506, float %436, i64 1, !dbg !272
  %508 = insertelement <4 x float> %507, float %460, i64 2, !dbg !272
  %509 = insertelement <4 x float> %508, float %484, i64 3, !dbg !272
  %510 = fmul contract <4 x float> %486, %509, !dbg !272
  %511 = fadd contract <4 x float> %505, %510, !dbg !273
  %512 = insertelement <4 x float> poison, float %66, i32 0, !dbg !274
  %513 = shufflevector <4 x float> %512, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !274
  %514 = fmul contract <4 x float> %513, %511, !dbg !274
  %515 = fadd contract <4 x float> %500, %514, !dbg !275
  %516 = add i64 %45, 1, !dbg !231
  %517 = add i64 %71, 1, !dbg !231
  %518 = mul i64 %39, 12996, !dbg !231
  %519 = mul i64 %516, 114, !dbg !231
  %520 = add i64 %518, %519, !dbg !231
  %521 = add i64 %520, %517, !dbg !231
  %522 = getelementptr float, ptr %12, i64 %521, !dbg !231
  store <4 x float> %515, ptr %522, align 4, !dbg !231
  %523 = add i64 %68, 4, !dbg !231
  br label %67, !dbg !231

524:                                              ; preds = %67
  %525 = add i64 %42, 1, !dbg !231
  br label %41, !dbg !231

526:                                              ; preds = %41
  %527 = add i64 %36, 1, !dbg !231
  br label %35, !dbg !231

528:                                              ; preds = %35
  ret i32 0, !dbg !276
}

define internal i32 @infer_dispatch_14_conv_64x112x112x128x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !277 {
  %4 = alloca float, i64 4, align 64, !dbg !278
  %5 = alloca float, i64 4, align 64, !dbg !279
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !280
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !280
  %8 = load ptr, ptr %7, align 8, !dbg !280
  %9 = getelementptr float, ptr %8, i64 20988416, !dbg !280
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !280
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !281
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !281
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !281
  %13 = load ptr, ptr %12, align 8, !dbg !281
  %14 = getelementptr float, ptr %13, i64 96, !dbg !281
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !281
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !282
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !282
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !282
  %18 = load ptr, ptr %17, align 8, !dbg !282
  %19 = getelementptr float, ptr %18, i64 1605632, !dbg !282
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !282
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !278
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !278
  %22 = zext i32 %21 to i64, !dbg !278
  %23 = sdiv i64 %22, 16, !dbg !278
  %24 = mul i64 %23, 16, !dbg !278
  %25 = icmp ne i64 %22, %24, !dbg !278
  %26 = icmp slt i64 %22, 0, !dbg !278
  %27 = and i1 %25, %26, !dbg !278
  %28 = add i64 %23, -1, !dbg !278
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !278
  %30 = srem i64 %22, 16, !dbg !278
  %31 = icmp slt i64 %30, 0, !dbg !278
  %32 = add nsw i64 %30, 16, !dbg !278
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !278
  %34 = sdiv i64 %33, 4, !dbg !278
  %35 = srem i64 %22, 4, !dbg !278
  %36 = icmp slt i64 %35, 0, !dbg !278
  %37 = add nsw i64 %35, 4, !dbg !278
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !278
  %39 = mul nsw i64 %29, 32, !dbg !278
  %40 = mul nsw i64 %34, 28, !dbg !278
  %41 = mul nsw i64 %38, 28, !dbg !278
  %42 = getelementptr float, ptr %5, i64 0, !dbg !283
  store <4 x float> zeroinitializer, ptr %42, align 4, !dbg !283
  br label %43, !dbg !278

43:                                               ; preds = %133, %3
  %44 = phi i64 [ %134, %133 ], [ 0, %3 ], !dbg !278
  %45 = icmp slt i64 %44, 32, !dbg !278
  br i1 %45, label %46, label %135, !dbg !278

46:                                               ; preds = %43
  %47 = add i64 %44, %39, !dbg !278
  %48 = getelementptr float, ptr @__constant_64xf32_0, i64 %47, !dbg !284
  %49 = load <1 x float>, ptr %48, align 4, !dbg !284
  br label %50, !dbg !278

50:                                               ; preds = %131, %46
  %51 = phi i64 [ %132, %131 ], [ 0, %46 ], !dbg !278
  %52 = icmp slt i64 %51, 28, !dbg !278
  br i1 %52, label %53, label %133, !dbg !278

53:                                               ; preds = %111, %50
  %54 = phi i64 [ %130, %111 ], [ 0, %50 ], !dbg !278
  %55 = icmp slt i64 %54, 28, !dbg !278
  br i1 %55, label %56, label %131, !dbg !278

56:                                               ; preds = %53
  %57 = add i64 %54, %41, !dbg !278
  br label %58, !dbg !278

58:                                               ; preds = %61, %56
  %59 = phi i64 [ %66, %61 ], [ 0, %56 ], !dbg !278
  %60 = icmp slt i64 %59, 4, !dbg !278
  br i1 %60, label %61, label %67, !dbg !278

61:                                               ; preds = %58
  %62 = add nuw nsw i64 0, %59, !dbg !278
  %63 = getelementptr inbounds nuw float, ptr %5, i64 %62, !dbg !278
  %64 = load float, ptr %63, align 4, !dbg !278
  %65 = getelementptr inbounds nuw float, ptr %4, i64 %62, !dbg !278
  store float %64, ptr %65, align 4, !dbg !278
  %66 = add i64 %59, 1, !dbg !278
  br label %58, !dbg !278

67:                                               ; preds = %109, %58
  %68 = phi i64 [ %110, %109 ], [ 0, %58 ], !dbg !278
  %69 = icmp slt i64 %68, 128, !dbg !278
  br i1 %69, label %70, label %111, !dbg !278

70:                                               ; preds = %107, %67
  %71 = phi i64 [ %108, %107 ], [ 0, %67 ], !dbg !278
  %72 = icmp slt i64 %71, 3, !dbg !278
  br i1 %72, label %73, label %109, !dbg !278

73:                                               ; preds = %70
  %74 = add i64 %71, %51, !dbg !278
  %75 = add i64 %74, %40, !dbg !278
  br label %76, !dbg !278

76:                                               ; preds = %105, %73
  %77 = phi i64 [ %106, %105 ], [ 0, %73 ], !dbg !278
  %78 = icmp slt i64 %77, 4, !dbg !278
  br i1 %78, label %79, label %107, !dbg !278

79:                                               ; preds = %82, %76
  %80 = phi i64 [ %104, %82 ], [ 0, %76 ], !dbg !278
  %81 = icmp slt i64 %80, 3, !dbg !278
  br i1 %81, label %82, label %105, !dbg !278

82:                                               ; preds = %79
  %83 = add i64 %57, %77, !dbg !278
  %84 = add i64 %83, %80, !dbg !278
  %85 = mul nuw nsw i64 %68, 12996, !dbg !278
  %86 = mul nuw nsw i64 %75, 114, !dbg !278
  %87 = add nuw nsw i64 %85, %86, !dbg !278
  %88 = add nuw nsw i64 %87, %84, !dbg !278
  %89 = getelementptr inbounds nuw float, ptr %9, i64 %88, !dbg !278
  %90 = load float, ptr %89, align 4, !dbg !278
  %91 = mul nuw nsw i64 %47, 1152, !dbg !278
  %92 = mul nuw nsw i64 %68, 9, !dbg !278
  %93 = add nuw nsw i64 %91, %92, !dbg !278
  %94 = mul nuw nsw i64 %71, 3, !dbg !278
  %95 = add nuw nsw i64 %93, %94, !dbg !278
  %96 = add nuw nsw i64 %95, %80, !dbg !278
  %97 = getelementptr inbounds nuw float, ptr %14, i64 %96, !dbg !278
  %98 = load float, ptr %97, align 4, !dbg !278
  %99 = add nuw nsw i64 0, %77, !dbg !278
  %100 = getelementptr inbounds nuw float, ptr %4, i64 %99, !dbg !278
  %101 = load float, ptr %100, align 4, !dbg !278
  %102 = fmul contract float %90, %98, !dbg !285
  %103 = fadd contract float %101, %102, !dbg !286
  store float %103, ptr %100, align 4, !dbg !278
  %104 = add i64 %80, 1, !dbg !278
  br label %79, !dbg !278

105:                                              ; preds = %79
  %106 = add i64 %77, 1, !dbg !278
  br label %76, !dbg !278

107:                                              ; preds = %76
  %108 = add i64 %71, 1, !dbg !278
  br label %70, !dbg !278

109:                                              ; preds = %70
  %110 = add i64 %68, 1, !dbg !278
  br label %67, !dbg !278

111:                                              ; preds = %67
  %112 = getelementptr float, ptr %4, i64 0, !dbg !284
  %113 = load <4 x float>, ptr %112, align 4, !dbg !284
  %114 = extractelement <1 x float> %49, i64 0, !dbg !287
  %115 = insertelement <4 x float> poison, float %114, i32 0, !dbg !287
  %116 = shufflevector <4 x float> %115, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !287
  %117 = fadd contract <4 x float> %113, %116, !dbg !287
  %118 = fcmp olt <4 x float> zeroinitializer, %117, !dbg !288
  %119 = select <4 x i1> %118, <4 x float> zeroinitializer, <4 x float> %117, !dbg !289
  %120 = fmul contract <4 x float> %119, splat (float 0x3FC99999A0000000), !dbg !290
  %121 = fcmp ogt <4 x float> zeroinitializer, %117, !dbg !291
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %117, !dbg !292
  %123 = fadd contract <4 x float> %122, %120, !dbg !293
  %124 = add i64 %40, %51, !dbg !278
  %125 = mul i64 %47, 12544, !dbg !278
  %126 = mul i64 %124, 112, !dbg !278
  %127 = add i64 %125, %126, !dbg !278
  %128 = add i64 %127, %57, !dbg !278
  %129 = getelementptr float, ptr %19, i64 %128, !dbg !278
  store <4 x float> %123, ptr %129, align 4, !dbg !278
  %130 = add i64 %54, 4, !dbg !278
  br label %53, !dbg !278

131:                                              ; preds = %53
  %132 = add i64 %51, 1, !dbg !278
  br label %50, !dbg !278

133:                                              ; preds = %50
  %134 = add i64 %44, 1, !dbg !278
  br label %43, !dbg !278

135:                                              ; preds = %43
  ret i32 0, !dbg !294
}

define internal i32 @infer_dispatch_15_elementwise_broadcast_64x224x224_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !295 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !296
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !296
  %6 = load ptr, ptr %5, align 8, !dbg !296
  %7 = getelementptr float, ptr %6, i64 1605632, !dbg !296
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !296
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !297
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !297
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !297
  %11 = load ptr, ptr %10, align 8, !dbg !297
  %12 = getelementptr float, ptr %11, i64 2408448, !dbg !297
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !297
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !298
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !298
  %15 = zext i32 %14 to i64, !dbg !298
  %16 = sdiv i64 %15, 4, !dbg !298
  %17 = mul i64 %16, 4, !dbg !298
  %18 = icmp ne i64 %15, %17, !dbg !298
  %19 = icmp slt i64 %15, 0, !dbg !298
  %20 = and i1 %18, %19, !dbg !298
  %21 = add i64 %16, -1, !dbg !298
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !298
  %23 = srem i64 %15, 4, !dbg !298
  %24 = icmp slt i64 %23, 0, !dbg !298
  %25 = add nsw i64 %23, 4, !dbg !298
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !298
  %27 = mul nsw i64 %22, 56, !dbg !298
  %28 = mul nsw i64 %26, 56, !dbg !298
  br label %29, !dbg !298

29:                                               ; preds = %519, %3
  %30 = phi i64 [ %520, %519 ], [ 0, %3 ], !dbg !298
  %31 = icmp slt i64 %30, 64, !dbg !298
  br i1 %31, label %32, label %521, !dbg !298

32:                                               ; preds = %29
  %33 = mul i64 %30, 112, !dbg !299
  br label %34, !dbg !298

34:                                               ; preds = %517, %32
  %35 = phi i64 [ %518, %517 ], [ 0, %32 ], !dbg !298
  %36 = icmp slt i64 %35, 56, !dbg !298
  br i1 %36, label %37, label %519, !dbg !298

37:                                               ; preds = %34
  %38 = add i64 %27, %35, !dbg !300
  %39 = sitofp i64 %38 to float, !dbg !301
  %40 = fadd contract float %39, 5.000000e-01, !dbg !302
  %41 = fdiv float %40, 2.000000e+00, !dbg !303
  %42 = fsub contract float %41, 5.000000e-01, !dbg !304
  %43 = fcmp ugt float %42, 0.000000e+00, !dbg !305
  %44 = select i1 %43, float %42, float 0.000000e+00, !dbg !305
  %45 = fcmp ult float %44, 1.110000e+02, !dbg !306
  %46 = select i1 %45, float %44, float 1.110000e+02, !dbg !306
  %47 = call float @llvm.floor.f32(float %46), !dbg !307
  %48 = fadd contract float %46, 1.000000e+00, !dbg !308
  %49 = call float @llvm.floor.f32(float %48), !dbg !309
  %50 = fptosi float %47 to i64, !dbg !310
  %51 = fcmp ult float %48, 1.110000e+02, !dbg !311
  %52 = select i1 %51, float %48, float 1.110000e+02, !dbg !311
  %53 = fptosi float %52 to i64, !dbg !312
  %54 = add i64 %50, %33, !dbg !299
  %55 = mul i64 %54, 112, !dbg !299
  %56 = add i64 %53, %33, !dbg !313
  %57 = mul i64 %56, 112, !dbg !313
  %58 = fsub contract float %49, %46, !dbg !314
  %59 = fsub contract float %46, %47, !dbg !315
  br label %60, !dbg !298

60:                                               ; preds = %63, %37
  %61 = phi i64 [ %516, %63 ], [ 0, %37 ], !dbg !298
  %62 = icmp slt i64 %61, 56, !dbg !298
  br i1 %62, label %63, label %517, !dbg !298

63:                                               ; preds = %60
  %64 = add i64 %28, %61, !dbg !316
  %65 = insertelement <4 x i64> poison, i64 %64, i32 0, !dbg !298
  %66 = shufflevector <4 x i64> %65, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !298
  %67 = add <4 x i64> %66, <i64 0, i64 1, i64 2, i64 3>, !dbg !316
  %68 = sitofp <4 x i64> %67 to <4 x float>, !dbg !317
  %69 = fadd contract <4 x float> %68, splat (float 5.000000e-01), !dbg !318
  %70 = fdiv <4 x float> %69, splat (float 2.000000e+00), !dbg !319
  %71 = fsub contract <4 x float> %70, splat (float 5.000000e-01), !dbg !320
  %72 = fcmp ugt <4 x float> %71, zeroinitializer, !dbg !321
  %73 = select <4 x i1> %72, <4 x float> %71, <4 x float> zeroinitializer, !dbg !321
  %74 = select <4 x i1> zeroinitializer, <4 x float> zeroinitializer, <4 x float> %73, !dbg !321
  %75 = fcmp ult <4 x float> %74, splat (float 1.110000e+02), !dbg !322
  %76 = select <4 x i1> %75, <4 x float> %74, <4 x float> splat (float 1.110000e+02), !dbg !322
  %77 = select <4 x i1> zeroinitializer, <4 x float> splat (float 1.110000e+02), <4 x float> %76, !dbg !322
  %78 = call <4 x float> @llvm.floor.v4f32(<4 x float> %77), !dbg !323
  %79 = fadd contract <4 x float> %77, splat (float 1.000000e+00), !dbg !324
  %80 = call <4 x float> @llvm.floor.v4f32(<4 x float> %79), !dbg !325
  %81 = fptosi <4 x float> %78 to <4 x i64>, !dbg !326
  %82 = fcmp ult <4 x float> %79, splat (float 1.110000e+02), !dbg !327
  %83 = select <4 x i1> %82, <4 x float> %79, <4 x float> splat (float 1.110000e+02), !dbg !327
  %84 = select <4 x i1> zeroinitializer, <4 x float> splat (float 1.110000e+02), <4 x float> %83, !dbg !327
  %85 = fptosi <4 x float> %84 to <4 x i64>, !dbg !328
  %86 = insertelement <4 x i64> poison, i64 %55, i32 0, !dbg !299
  %87 = shufflevector <4 x i64> %86, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !299
  %88 = add <4 x i64> %81, %87, !dbg !299
  %89 = extractelement <4 x i64> %88, i64 0, !dbg !299
  %90 = sdiv i64 %89, 12544, !dbg !299
  %91 = mul i64 %90, 12544, !dbg !299
  %92 = icmp ne i64 %89, %91, !dbg !299
  %93 = icmp slt i64 %89, 0, !dbg !299
  %94 = and i1 %92, %93, !dbg !299
  %95 = add i64 %90, -1, !dbg !299
  %96 = select i1 %94, i64 %95, i64 %90, !dbg !299
  %97 = srem i64 %89, 12544, !dbg !299
  %98 = icmp slt i64 %97, 0, !dbg !299
  %99 = add nsw i64 %97, 12544, !dbg !299
  %100 = select i1 %98, i64 %99, i64 %97, !dbg !299
  %101 = sdiv i64 %100, 112, !dbg !299
  %102 = srem i64 %89, 112, !dbg !299
  %103 = icmp slt i64 %102, 0, !dbg !299
  %104 = add nsw i64 %102, 112, !dbg !299
  %105 = select i1 %103, i64 %104, i64 %102, !dbg !299
  %106 = mul i64 %96, 12544, !dbg !299
  %107 = mul i64 %101, 112, !dbg !299
  %108 = add i64 %106, %107, !dbg !299
  %109 = add i64 %108, %105, !dbg !299
  %110 = getelementptr float, ptr %7, i64 %109, !dbg !299
  %111 = load <1 x float>, ptr %110, align 4, !dbg !299
  %112 = extractelement <1 x float> %111, i64 0, !dbg !299
  %113 = extractelement <4 x i64> %88, i64 1, !dbg !299
  %114 = sdiv i64 %113, 12544, !dbg !299
  %115 = mul i64 %114, 12544, !dbg !299
  %116 = icmp ne i64 %113, %115, !dbg !299
  %117 = icmp slt i64 %113, 0, !dbg !299
  %118 = and i1 %116, %117, !dbg !299
  %119 = add i64 %114, -1, !dbg !299
  %120 = select i1 %118, i64 %119, i64 %114, !dbg !299
  %121 = srem i64 %113, 12544, !dbg !299
  %122 = icmp slt i64 %121, 0, !dbg !299
  %123 = add nsw i64 %121, 12544, !dbg !299
  %124 = select i1 %122, i64 %123, i64 %121, !dbg !299
  %125 = sdiv i64 %124, 112, !dbg !299
  %126 = srem i64 %113, 112, !dbg !299
  %127 = icmp slt i64 %126, 0, !dbg !299
  %128 = add nsw i64 %126, 112, !dbg !299
  %129 = select i1 %127, i64 %128, i64 %126, !dbg !299
  %130 = mul i64 %120, 12544, !dbg !299
  %131 = mul i64 %125, 112, !dbg !299
  %132 = add i64 %130, %131, !dbg !299
  %133 = add i64 %132, %129, !dbg !299
  %134 = getelementptr float, ptr %7, i64 %133, !dbg !299
  %135 = load <1 x float>, ptr %134, align 4, !dbg !299
  %136 = extractelement <1 x float> %135, i64 0, !dbg !299
  %137 = extractelement <4 x i64> %88, i64 2, !dbg !299
  %138 = sdiv i64 %137, 12544, !dbg !299
  %139 = mul i64 %138, 12544, !dbg !299
  %140 = icmp ne i64 %137, %139, !dbg !299
  %141 = icmp slt i64 %137, 0, !dbg !299
  %142 = and i1 %140, %141, !dbg !299
  %143 = add i64 %138, -1, !dbg !299
  %144 = select i1 %142, i64 %143, i64 %138, !dbg !299
  %145 = srem i64 %137, 12544, !dbg !299
  %146 = icmp slt i64 %145, 0, !dbg !299
  %147 = add nsw i64 %145, 12544, !dbg !299
  %148 = select i1 %146, i64 %147, i64 %145, !dbg !299
  %149 = sdiv i64 %148, 112, !dbg !299
  %150 = srem i64 %137, 112, !dbg !299
  %151 = icmp slt i64 %150, 0, !dbg !299
  %152 = add nsw i64 %150, 112, !dbg !299
  %153 = select i1 %151, i64 %152, i64 %150, !dbg !299
  %154 = mul i64 %144, 12544, !dbg !299
  %155 = mul i64 %149, 112, !dbg !299
  %156 = add i64 %154, %155, !dbg !299
  %157 = add i64 %156, %153, !dbg !299
  %158 = getelementptr float, ptr %7, i64 %157, !dbg !299
  %159 = load <1 x float>, ptr %158, align 4, !dbg !299
  %160 = extractelement <1 x float> %159, i64 0, !dbg !299
  %161 = extractelement <4 x i64> %88, i64 3, !dbg !299
  %162 = sdiv i64 %161, 12544, !dbg !299
  %163 = mul i64 %162, 12544, !dbg !299
  %164 = icmp ne i64 %161, %163, !dbg !299
  %165 = icmp slt i64 %161, 0, !dbg !299
  %166 = and i1 %164, %165, !dbg !299
  %167 = add i64 %162, -1, !dbg !299
  %168 = select i1 %166, i64 %167, i64 %162, !dbg !299
  %169 = srem i64 %161, 12544, !dbg !299
  %170 = icmp slt i64 %169, 0, !dbg !299
  %171 = add nsw i64 %169, 12544, !dbg !299
  %172 = select i1 %170, i64 %171, i64 %169, !dbg !299
  %173 = sdiv i64 %172, 112, !dbg !299
  %174 = srem i64 %161, 112, !dbg !299
  %175 = icmp slt i64 %174, 0, !dbg !299
  %176 = add nsw i64 %174, 112, !dbg !299
  %177 = select i1 %175, i64 %176, i64 %174, !dbg !299
  %178 = mul i64 %168, 12544, !dbg !299
  %179 = mul i64 %173, 112, !dbg !299
  %180 = add i64 %178, %179, !dbg !299
  %181 = add i64 %180, %177, !dbg !299
  %182 = getelementptr float, ptr %7, i64 %181, !dbg !299
  %183 = load <1 x float>, ptr %182, align 4, !dbg !299
  %184 = extractelement <1 x float> %183, i64 0, !dbg !299
  %185 = add <4 x i64> %85, %87, !dbg !329
  %186 = extractelement <4 x i64> %185, i64 0, !dbg !329
  %187 = sdiv i64 %186, 12544, !dbg !329
  %188 = mul i64 %187, 12544, !dbg !329
  %189 = icmp ne i64 %186, %188, !dbg !329
  %190 = icmp slt i64 %186, 0, !dbg !329
  %191 = and i1 %189, %190, !dbg !329
  %192 = add i64 %187, -1, !dbg !329
  %193 = select i1 %191, i64 %192, i64 %187, !dbg !329
  %194 = srem i64 %186, 12544, !dbg !329
  %195 = icmp slt i64 %194, 0, !dbg !329
  %196 = add nsw i64 %194, 12544, !dbg !329
  %197 = select i1 %195, i64 %196, i64 %194, !dbg !329
  %198 = sdiv i64 %197, 112, !dbg !329
  %199 = srem i64 %186, 112, !dbg !329
  %200 = icmp slt i64 %199, 0, !dbg !329
  %201 = add nsw i64 %199, 112, !dbg !329
  %202 = select i1 %200, i64 %201, i64 %199, !dbg !329
  %203 = mul i64 %193, 12544, !dbg !329
  %204 = mul i64 %198, 112, !dbg !329
  %205 = add i64 %203, %204, !dbg !329
  %206 = add i64 %205, %202, !dbg !329
  %207 = getelementptr float, ptr %7, i64 %206, !dbg !329
  %208 = load <1 x float>, ptr %207, align 4, !dbg !329
  %209 = extractelement <1 x float> %208, i64 0, !dbg !329
  %210 = extractelement <4 x i64> %185, i64 1, !dbg !329
  %211 = sdiv i64 %210, 12544, !dbg !329
  %212 = mul i64 %211, 12544, !dbg !329
  %213 = icmp ne i64 %210, %212, !dbg !329
  %214 = icmp slt i64 %210, 0, !dbg !329
  %215 = and i1 %213, %214, !dbg !329
  %216 = add i64 %211, -1, !dbg !329
  %217 = select i1 %215, i64 %216, i64 %211, !dbg !329
  %218 = srem i64 %210, 12544, !dbg !329
  %219 = icmp slt i64 %218, 0, !dbg !329
  %220 = add nsw i64 %218, 12544, !dbg !329
  %221 = select i1 %219, i64 %220, i64 %218, !dbg !329
  %222 = sdiv i64 %221, 112, !dbg !329
  %223 = srem i64 %210, 112, !dbg !329
  %224 = icmp slt i64 %223, 0, !dbg !329
  %225 = add nsw i64 %223, 112, !dbg !329
  %226 = select i1 %224, i64 %225, i64 %223, !dbg !329
  %227 = mul i64 %217, 12544, !dbg !329
  %228 = mul i64 %222, 112, !dbg !329
  %229 = add i64 %227, %228, !dbg !329
  %230 = add i64 %229, %226, !dbg !329
  %231 = getelementptr float, ptr %7, i64 %230, !dbg !329
  %232 = load <1 x float>, ptr %231, align 4, !dbg !329
  %233 = extractelement <1 x float> %232, i64 0, !dbg !329
  %234 = extractelement <4 x i64> %185, i64 2, !dbg !329
  %235 = sdiv i64 %234, 12544, !dbg !329
  %236 = mul i64 %235, 12544, !dbg !329
  %237 = icmp ne i64 %234, %236, !dbg !329
  %238 = icmp slt i64 %234, 0, !dbg !329
  %239 = and i1 %237, %238, !dbg !329
  %240 = add i64 %235, -1, !dbg !329
  %241 = select i1 %239, i64 %240, i64 %235, !dbg !329
  %242 = srem i64 %234, 12544, !dbg !329
  %243 = icmp slt i64 %242, 0, !dbg !329
  %244 = add nsw i64 %242, 12544, !dbg !329
  %245 = select i1 %243, i64 %244, i64 %242, !dbg !329
  %246 = sdiv i64 %245, 112, !dbg !329
  %247 = srem i64 %234, 112, !dbg !329
  %248 = icmp slt i64 %247, 0, !dbg !329
  %249 = add nsw i64 %247, 112, !dbg !329
  %250 = select i1 %248, i64 %249, i64 %247, !dbg !329
  %251 = mul i64 %241, 12544, !dbg !329
  %252 = mul i64 %246, 112, !dbg !329
  %253 = add i64 %251, %252, !dbg !329
  %254 = add i64 %253, %250, !dbg !329
  %255 = getelementptr float, ptr %7, i64 %254, !dbg !329
  %256 = load <1 x float>, ptr %255, align 4, !dbg !329
  %257 = extractelement <1 x float> %256, i64 0, !dbg !329
  %258 = extractelement <4 x i64> %185, i64 3, !dbg !329
  %259 = sdiv i64 %258, 12544, !dbg !329
  %260 = mul i64 %259, 12544, !dbg !329
  %261 = icmp ne i64 %258, %260, !dbg !329
  %262 = icmp slt i64 %258, 0, !dbg !329
  %263 = and i1 %261, %262, !dbg !329
  %264 = add i64 %259, -1, !dbg !329
  %265 = select i1 %263, i64 %264, i64 %259, !dbg !329
  %266 = srem i64 %258, 12544, !dbg !329
  %267 = icmp slt i64 %266, 0, !dbg !329
  %268 = add nsw i64 %266, 12544, !dbg !329
  %269 = select i1 %267, i64 %268, i64 %266, !dbg !329
  %270 = sdiv i64 %269, 112, !dbg !329
  %271 = srem i64 %258, 112, !dbg !329
  %272 = icmp slt i64 %271, 0, !dbg !329
  %273 = add nsw i64 %271, 112, !dbg !329
  %274 = select i1 %272, i64 %273, i64 %271, !dbg !329
  %275 = mul i64 %265, 12544, !dbg !329
  %276 = mul i64 %270, 112, !dbg !329
  %277 = add i64 %275, %276, !dbg !329
  %278 = add i64 %277, %274, !dbg !329
  %279 = getelementptr float, ptr %7, i64 %278, !dbg !329
  %280 = load <1 x float>, ptr %279, align 4, !dbg !329
  %281 = extractelement <1 x float> %280, i64 0, !dbg !329
  %282 = insertelement <4 x i64> poison, i64 %57, i32 0, !dbg !313
  %283 = shufflevector <4 x i64> %282, <4 x i64> poison, <4 x i32> zeroinitializer, !dbg !313
  %284 = add <4 x i64> %81, %283, !dbg !313
  %285 = extractelement <4 x i64> %284, i64 0, !dbg !313
  %286 = sdiv i64 %285, 12544, !dbg !313
  %287 = mul i64 %286, 12544, !dbg !313
  %288 = icmp ne i64 %285, %287, !dbg !313
  %289 = icmp slt i64 %285, 0, !dbg !313
  %290 = and i1 %288, %289, !dbg !313
  %291 = add i64 %286, -1, !dbg !313
  %292 = select i1 %290, i64 %291, i64 %286, !dbg !313
  %293 = srem i64 %285, 12544, !dbg !313
  %294 = icmp slt i64 %293, 0, !dbg !313
  %295 = add nsw i64 %293, 12544, !dbg !313
  %296 = select i1 %294, i64 %295, i64 %293, !dbg !313
  %297 = sdiv i64 %296, 112, !dbg !313
  %298 = srem i64 %285, 112, !dbg !313
  %299 = icmp slt i64 %298, 0, !dbg !313
  %300 = add nsw i64 %298, 112, !dbg !313
  %301 = select i1 %299, i64 %300, i64 %298, !dbg !313
  %302 = mul i64 %292, 12544, !dbg !313
  %303 = mul i64 %297, 112, !dbg !313
  %304 = add i64 %302, %303, !dbg !313
  %305 = add i64 %304, %301, !dbg !313
  %306 = getelementptr float, ptr %7, i64 %305, !dbg !313
  %307 = load <1 x float>, ptr %306, align 4, !dbg !313
  %308 = extractelement <1 x float> %307, i64 0, !dbg !313
  %309 = extractelement <4 x i64> %284, i64 1, !dbg !313
  %310 = sdiv i64 %309, 12544, !dbg !313
  %311 = mul i64 %310, 12544, !dbg !313
  %312 = icmp ne i64 %309, %311, !dbg !313
  %313 = icmp slt i64 %309, 0, !dbg !313
  %314 = and i1 %312, %313, !dbg !313
  %315 = add i64 %310, -1, !dbg !313
  %316 = select i1 %314, i64 %315, i64 %310, !dbg !313
  %317 = srem i64 %309, 12544, !dbg !313
  %318 = icmp slt i64 %317, 0, !dbg !313
  %319 = add nsw i64 %317, 12544, !dbg !313
  %320 = select i1 %318, i64 %319, i64 %317, !dbg !313
  %321 = sdiv i64 %320, 112, !dbg !313
  %322 = srem i64 %309, 112, !dbg !313
  %323 = icmp slt i64 %322, 0, !dbg !313
  %324 = add nsw i64 %322, 112, !dbg !313
  %325 = select i1 %323, i64 %324, i64 %322, !dbg !313
  %326 = mul i64 %316, 12544, !dbg !313
  %327 = mul i64 %321, 112, !dbg !313
  %328 = add i64 %326, %327, !dbg !313
  %329 = add i64 %328, %325, !dbg !313
  %330 = getelementptr float, ptr %7, i64 %329, !dbg !313
  %331 = load <1 x float>, ptr %330, align 4, !dbg !313
  %332 = extractelement <1 x float> %331, i64 0, !dbg !313
  %333 = extractelement <4 x i64> %284, i64 2, !dbg !313
  %334 = sdiv i64 %333, 12544, !dbg !313
  %335 = mul i64 %334, 12544, !dbg !313
  %336 = icmp ne i64 %333, %335, !dbg !313
  %337 = icmp slt i64 %333, 0, !dbg !313
  %338 = and i1 %336, %337, !dbg !313
  %339 = add i64 %334, -1, !dbg !313
  %340 = select i1 %338, i64 %339, i64 %334, !dbg !313
  %341 = srem i64 %333, 12544, !dbg !313
  %342 = icmp slt i64 %341, 0, !dbg !313
  %343 = add nsw i64 %341, 12544, !dbg !313
  %344 = select i1 %342, i64 %343, i64 %341, !dbg !313
  %345 = sdiv i64 %344, 112, !dbg !313
  %346 = srem i64 %333, 112, !dbg !313
  %347 = icmp slt i64 %346, 0, !dbg !313
  %348 = add nsw i64 %346, 112, !dbg !313
  %349 = select i1 %347, i64 %348, i64 %346, !dbg !313
  %350 = mul i64 %340, 12544, !dbg !313
  %351 = mul i64 %345, 112, !dbg !313
  %352 = add i64 %350, %351, !dbg !313
  %353 = add i64 %352, %349, !dbg !313
  %354 = getelementptr float, ptr %7, i64 %353, !dbg !313
  %355 = load <1 x float>, ptr %354, align 4, !dbg !313
  %356 = extractelement <1 x float> %355, i64 0, !dbg !313
  %357 = extractelement <4 x i64> %284, i64 3, !dbg !313
  %358 = sdiv i64 %357, 12544, !dbg !313
  %359 = mul i64 %358, 12544, !dbg !313
  %360 = icmp ne i64 %357, %359, !dbg !313
  %361 = icmp slt i64 %357, 0, !dbg !313
  %362 = and i1 %360, %361, !dbg !313
  %363 = add i64 %358, -1, !dbg !313
  %364 = select i1 %362, i64 %363, i64 %358, !dbg !313
  %365 = srem i64 %357, 12544, !dbg !313
  %366 = icmp slt i64 %365, 0, !dbg !313
  %367 = add nsw i64 %365, 12544, !dbg !313
  %368 = select i1 %366, i64 %367, i64 %365, !dbg !313
  %369 = sdiv i64 %368, 112, !dbg !313
  %370 = srem i64 %357, 112, !dbg !313
  %371 = icmp slt i64 %370, 0, !dbg !313
  %372 = add nsw i64 %370, 112, !dbg !313
  %373 = select i1 %371, i64 %372, i64 %370, !dbg !313
  %374 = mul i64 %364, 12544, !dbg !313
  %375 = mul i64 %369, 112, !dbg !313
  %376 = add i64 %374, %375, !dbg !313
  %377 = add i64 %376, %373, !dbg !313
  %378 = getelementptr float, ptr %7, i64 %377, !dbg !313
  %379 = load <1 x float>, ptr %378, align 4, !dbg !313
  %380 = extractelement <1 x float> %379, i64 0, !dbg !313
  %381 = add <4 x i64> %85, %283, !dbg !330
  %382 = extractelement <4 x i64> %381, i64 0, !dbg !330
  %383 = sdiv i64 %382, 12544, !dbg !330
  %384 = mul i64 %383, 12544, !dbg !330
  %385 = icmp ne i64 %382, %384, !dbg !330
  %386 = icmp slt i64 %382, 0, !dbg !330
  %387 = and i1 %385, %386, !dbg !330
  %388 = add i64 %383, -1, !dbg !330
  %389 = select i1 %387, i64 %388, i64 %383, !dbg !330
  %390 = srem i64 %382, 12544, !dbg !330
  %391 = icmp slt i64 %390, 0, !dbg !330
  %392 = add nsw i64 %390, 12544, !dbg !330
  %393 = select i1 %391, i64 %392, i64 %390, !dbg !330
  %394 = sdiv i64 %393, 112, !dbg !330
  %395 = srem i64 %382, 112, !dbg !330
  %396 = icmp slt i64 %395, 0, !dbg !330
  %397 = add nsw i64 %395, 112, !dbg !330
  %398 = select i1 %396, i64 %397, i64 %395, !dbg !330
  %399 = mul i64 %389, 12544, !dbg !330
  %400 = mul i64 %394, 112, !dbg !330
  %401 = add i64 %399, %400, !dbg !330
  %402 = add i64 %401, %398, !dbg !330
  %403 = getelementptr float, ptr %7, i64 %402, !dbg !330
  %404 = load <1 x float>, ptr %403, align 4, !dbg !330
  %405 = extractelement <1 x float> %404, i64 0, !dbg !330
  %406 = extractelement <4 x i64> %381, i64 1, !dbg !330
  %407 = sdiv i64 %406, 12544, !dbg !330
  %408 = mul i64 %407, 12544, !dbg !330
  %409 = icmp ne i64 %406, %408, !dbg !330
  %410 = icmp slt i64 %406, 0, !dbg !330
  %411 = and i1 %409, %410, !dbg !330
  %412 = add i64 %407, -1, !dbg !330
  %413 = select i1 %411, i64 %412, i64 %407, !dbg !330
  %414 = srem i64 %406, 12544, !dbg !330
  %415 = icmp slt i64 %414, 0, !dbg !330
  %416 = add nsw i64 %414, 12544, !dbg !330
  %417 = select i1 %415, i64 %416, i64 %414, !dbg !330
  %418 = sdiv i64 %417, 112, !dbg !330
  %419 = srem i64 %406, 112, !dbg !330
  %420 = icmp slt i64 %419, 0, !dbg !330
  %421 = add nsw i64 %419, 112, !dbg !330
  %422 = select i1 %420, i64 %421, i64 %419, !dbg !330
  %423 = mul i64 %413, 12544, !dbg !330
  %424 = mul i64 %418, 112, !dbg !330
  %425 = add i64 %423, %424, !dbg !330
  %426 = add i64 %425, %422, !dbg !330
  %427 = getelementptr float, ptr %7, i64 %426, !dbg !330
  %428 = load <1 x float>, ptr %427, align 4, !dbg !330
  %429 = extractelement <1 x float> %428, i64 0, !dbg !330
  %430 = extractelement <4 x i64> %381, i64 2, !dbg !330
  %431 = sdiv i64 %430, 12544, !dbg !330
  %432 = mul i64 %431, 12544, !dbg !330
  %433 = icmp ne i64 %430, %432, !dbg !330
  %434 = icmp slt i64 %430, 0, !dbg !330
  %435 = and i1 %433, %434, !dbg !330
  %436 = add i64 %431, -1, !dbg !330
  %437 = select i1 %435, i64 %436, i64 %431, !dbg !330
  %438 = srem i64 %430, 12544, !dbg !330
  %439 = icmp slt i64 %438, 0, !dbg !330
  %440 = add nsw i64 %438, 12544, !dbg !330
  %441 = select i1 %439, i64 %440, i64 %438, !dbg !330
  %442 = sdiv i64 %441, 112, !dbg !330
  %443 = srem i64 %430, 112, !dbg !330
  %444 = icmp slt i64 %443, 0, !dbg !330
  %445 = add nsw i64 %443, 112, !dbg !330
  %446 = select i1 %444, i64 %445, i64 %443, !dbg !330
  %447 = mul i64 %437, 12544, !dbg !330
  %448 = mul i64 %442, 112, !dbg !330
  %449 = add i64 %447, %448, !dbg !330
  %450 = add i64 %449, %446, !dbg !330
  %451 = getelementptr float, ptr %7, i64 %450, !dbg !330
  %452 = load <1 x float>, ptr %451, align 4, !dbg !330
  %453 = extractelement <1 x float> %452, i64 0, !dbg !330
  %454 = extractelement <4 x i64> %381, i64 3, !dbg !330
  %455 = sdiv i64 %454, 12544, !dbg !330
  %456 = mul i64 %455, 12544, !dbg !330
  %457 = icmp ne i64 %454, %456, !dbg !330
  %458 = icmp slt i64 %454, 0, !dbg !330
  %459 = and i1 %457, %458, !dbg !330
  %460 = add i64 %455, -1, !dbg !330
  %461 = select i1 %459, i64 %460, i64 %455, !dbg !330
  %462 = srem i64 %454, 12544, !dbg !330
  %463 = icmp slt i64 %462, 0, !dbg !330
  %464 = add nsw i64 %462, 12544, !dbg !330
  %465 = select i1 %463, i64 %464, i64 %462, !dbg !330
  %466 = sdiv i64 %465, 112, !dbg !330
  %467 = srem i64 %454, 112, !dbg !330
  %468 = icmp slt i64 %467, 0, !dbg !330
  %469 = add nsw i64 %467, 112, !dbg !330
  %470 = select i1 %468, i64 %469, i64 %467, !dbg !330
  %471 = mul i64 %461, 12544, !dbg !330
  %472 = mul i64 %466, 112, !dbg !330
  %473 = add i64 %471, %472, !dbg !330
  %474 = add i64 %473, %470, !dbg !330
  %475 = getelementptr float, ptr %7, i64 %474, !dbg !330
  %476 = load <1 x float>, ptr %475, align 4, !dbg !330
  %477 = extractelement <1 x float> %476, i64 0, !dbg !330
  %478 = fsub contract <4 x float> %80, %77, !dbg !331
  %479 = fsub contract <4 x float> %77, %78, !dbg !332
  %480 = insertelement <4 x float> poison, float %112, i64 0, !dbg !333
  %481 = insertelement <4 x float> %480, float %136, i64 1, !dbg !333
  %482 = insertelement <4 x float> %481, float %160, i64 2, !dbg !333
  %483 = insertelement <4 x float> %482, float %184, i64 3, !dbg !333
  %484 = fmul contract <4 x float> %478, %483, !dbg !333
  %485 = insertelement <4 x float> poison, float %209, i64 0, !dbg !334
  %486 = insertelement <4 x float> %485, float %233, i64 1, !dbg !334
  %487 = insertelement <4 x float> %486, float %257, i64 2, !dbg !334
  %488 = insertelement <4 x float> %487, float %281, i64 3, !dbg !334
  %489 = fmul contract <4 x float> %479, %488, !dbg !334
  %490 = fadd contract <4 x float> %484, %489, !dbg !335
  %491 = insertelement <4 x float> poison, float %58, i32 0, !dbg !336
  %492 = shufflevector <4 x float> %491, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !336
  %493 = fmul contract <4 x float> %492, %490, !dbg !336
  %494 = insertelement <4 x float> poison, float %308, i64 0, !dbg !337
  %495 = insertelement <4 x float> %494, float %332, i64 1, !dbg !337
  %496 = insertelement <4 x float> %495, float %356, i64 2, !dbg !337
  %497 = insertelement <4 x float> %496, float %380, i64 3, !dbg !337
  %498 = fmul contract <4 x float> %478, %497, !dbg !337
  %499 = insertelement <4 x float> poison, float %405, i64 0, !dbg !338
  %500 = insertelement <4 x float> %499, float %429, i64 1, !dbg !338
  %501 = insertelement <4 x float> %500, float %453, i64 2, !dbg !338
  %502 = insertelement <4 x float> %501, float %477, i64 3, !dbg !338
  %503 = fmul contract <4 x float> %479, %502, !dbg !338
  %504 = fadd contract <4 x float> %498, %503, !dbg !339
  %505 = insertelement <4 x float> poison, float %59, i32 0, !dbg !340
  %506 = shufflevector <4 x float> %505, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !340
  %507 = fmul contract <4 x float> %506, %504, !dbg !340
  %508 = fadd contract <4 x float> %493, %507, !dbg !341
  %509 = add i64 %38, 1, !dbg !298
  %510 = add i64 %64, 1, !dbg !298
  %511 = mul i64 %30, 51076, !dbg !298
  %512 = mul i64 %509, 226, !dbg !298
  %513 = add i64 %511, %512, !dbg !298
  %514 = add i64 %513, %510, !dbg !298
  %515 = getelementptr float, ptr %12, i64 %514, !dbg !298
  store <4 x float> %508, ptr %515, align 4, !dbg !298
  %516 = add i64 %61, 4, !dbg !298
  br label %60, !dbg !298

517:                                              ; preds = %60
  %518 = add i64 %35, 1, !dbg !298
  br label %34, !dbg !298

519:                                              ; preds = %34
  %520 = add i64 %30, 1, !dbg !298
  br label %29, !dbg !298

521:                                              ; preds = %29
  ret i32 0, !dbg !342
}

define internal i32 @infer_dispatch_16_conv_32x224x224x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !343 {
  %4 = alloca float, i64 4, align 64, !dbg !344
  %5 = alloca float, i64 4, align 64, !dbg !345
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !346
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !346
  %8 = load ptr, ptr %7, align 8, !dbg !346
  %9 = getelementptr float, ptr %8, i64 2408448, !dbg !346
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !346
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !347
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !347
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !347
  %13 = load ptr, ptr %12, align 8, !dbg !347
  %14 = getelementptr float, ptr %13, i64 1034048, !dbg !347
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !347
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !348
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !348
  %17 = load ptr, ptr %16, align 8, !dbg !348
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !348
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !349
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !349
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !349
  %21 = load ptr, ptr %20, align 8, !dbg !349
  %22 = getelementptr float, ptr %21, i64 5677312, !dbg !349
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !349
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !344
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !344
  %25 = zext i32 %24 to i64, !dbg !344
  %26 = sdiv i64 %25, 7, !dbg !344
  %27 = mul i64 %26, 7, !dbg !344
  %28 = icmp ne i64 %25, %27, !dbg !344
  %29 = icmp slt i64 %25, 0, !dbg !344
  %30 = and i1 %28, %29, !dbg !344
  %31 = add i64 %26, -1, !dbg !344
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !344
  %33 = srem i64 %25, 7, !dbg !344
  %34 = icmp slt i64 %33, 0, !dbg !344
  %35 = add nsw i64 %33, 7, !dbg !344
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !344
  %37 = mul nsw i64 %32, 32, !dbg !344
  %38 = mul nsw i64 %36, 32, !dbg !344
  %39 = getelementptr float, ptr %5, i64 0, !dbg !350
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !350
  br label %40, !dbg !344

40:                                               ; preds = %138, %3
  %41 = phi i64 [ %139, %138 ], [ 0, %3 ], !dbg !344
  %42 = icmp slt i64 %41, 32, !dbg !344
  br i1 %42, label %43, label %140, !dbg !344

43:                                               ; preds = %40
  %44 = getelementptr float, ptr @__constant_32xf32_0, i64 %41, !dbg !351
  %45 = load <1 x float>, ptr %44, align 4, !dbg !351
  br label %46, !dbg !344

46:                                               ; preds = %136, %43
  %47 = phi i64 [ %137, %136 ], [ 0, %43 ], !dbg !344
  %48 = icmp slt i64 %47, 32, !dbg !344
  br i1 %48, label %49, label %138, !dbg !344

49:                                               ; preds = %107, %46
  %50 = phi i64 [ %135, %107 ], [ 0, %46 ], !dbg !344
  %51 = icmp slt i64 %50, 32, !dbg !344
  br i1 %51, label %52, label %136, !dbg !344

52:                                               ; preds = %49
  %53 = add i64 %50, %38, !dbg !344
  br label %54, !dbg !344

54:                                               ; preds = %57, %52
  %55 = phi i64 [ %62, %57 ], [ 0, %52 ], !dbg !344
  %56 = icmp slt i64 %55, 4, !dbg !344
  br i1 %56, label %57, label %63, !dbg !344

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !344
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !344
  %60 = load float, ptr %59, align 4, !dbg !344
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !344
  store float %60, ptr %61, align 4, !dbg !344
  %62 = add i64 %55, 1, !dbg !344
  br label %54, !dbg !344

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !344
  %65 = icmp slt i64 %64, 64, !dbg !344
  br i1 %65, label %66, label %107, !dbg !344

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !344
  %68 = icmp slt i64 %67, 3, !dbg !344
  br i1 %68, label %69, label %105, !dbg !344

69:                                               ; preds = %66
  %70 = add i64 %67, %47, !dbg !344
  %71 = add i64 %70, %37, !dbg !344
  br label %72, !dbg !344

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !344
  %74 = icmp slt i64 %73, 4, !dbg !344
  br i1 %74, label %75, label %103, !dbg !344

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !344
  %77 = icmp slt i64 %76, 3, !dbg !344
  br i1 %77, label %78, label %101, !dbg !344

78:                                               ; preds = %75
  %79 = add i64 %53, %73, !dbg !344
  %80 = add i64 %79, %76, !dbg !344
  %81 = mul nuw nsw i64 %64, 51076, !dbg !344
  %82 = mul nuw nsw i64 %71, 226, !dbg !344
  %83 = add nuw nsw i64 %81, %82, !dbg !344
  %84 = add nuw nsw i64 %83, %80, !dbg !344
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !344
  %86 = load float, ptr %85, align 4, !dbg !344
  %87 = mul nuw nsw i64 %41, 576, !dbg !344
  %88 = mul nuw nsw i64 %64, 9, !dbg !344
  %89 = add nuw nsw i64 %87, %88, !dbg !344
  %90 = mul nuw nsw i64 %67, 3, !dbg !344
  %91 = add nuw nsw i64 %89, %90, !dbg !344
  %92 = add nuw nsw i64 %91, %76, !dbg !344
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !344
  %94 = load float, ptr %93, align 4, !dbg !344
  %95 = add nuw nsw i64 0, %73, !dbg !344
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !344
  %97 = load float, ptr %96, align 4, !dbg !344
  %98 = fmul contract float %86, %94, !dbg !352
  %99 = fadd contract float %97, %98, !dbg !353
  store float %99, ptr %96, align 4, !dbg !344
  %100 = add i64 %76, 1, !dbg !344
  br label %75, !dbg !344

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !344
  br label %72, !dbg !344

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !344
  br label %66, !dbg !344

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !344
  br label %63, !dbg !344

107:                                              ; preds = %63
  %108 = add i64 %47, %37, !dbg !351
  %109 = mul i64 %41, 50176, !dbg !351
  %110 = mul i64 %108, 224, !dbg !351
  %111 = add i64 %109, %110, !dbg !351
  %112 = add i64 %111, %53, !dbg !351
  %113 = getelementptr float, ptr %17, i64 %112, !dbg !351
  %114 = load <4 x float>, ptr %113, align 4, !dbg !351
  %115 = getelementptr float, ptr %4, i64 0, !dbg !351
  %116 = load <4 x float>, ptr %115, align 4, !dbg !351
  %117 = extractelement <1 x float> %45, i64 0, !dbg !354
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !354
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !354
  %120 = fadd contract <4 x float> %116, %119, !dbg !354
  %121 = fcmp olt <4 x float> zeroinitializer, %120, !dbg !355
  %122 = select <4 x i1> %121, <4 x float> zeroinitializer, <4 x float> %120, !dbg !356
  %123 = fmul contract <4 x float> %122, splat (float 0x3FC99999A0000000), !dbg !357
  %124 = fcmp ogt <4 x float> zeroinitializer, %120, !dbg !358
  %125 = select <4 x i1> %124, <4 x float> zeroinitializer, <4 x float> %120, !dbg !359
  %126 = fadd contract <4 x float> %125, %123, !dbg !360
  %127 = fmul contract <4 x float> %114, %126, !dbg !361
  %128 = add i64 %108, 1, !dbg !344
  %129 = add i64 %53, 1, !dbg !344
  %130 = mul i64 %41, 51076, !dbg !344
  %131 = mul i64 %128, 226, !dbg !344
  %132 = add i64 %130, %131, !dbg !344
  %133 = add i64 %132, %129, !dbg !344
  %134 = getelementptr float, ptr %22, i64 %133, !dbg !344
  store <4 x float> %127, ptr %134, align 4, !dbg !344
  %135 = add i64 %50, 4, !dbg !344
  br label %49, !dbg !344

136:                                              ; preds = %49
  %137 = add i64 %47, 1, !dbg !344
  br label %46, !dbg !344

138:                                              ; preds = %46
  %139 = add i64 %41, 1, !dbg !344
  br label %40, !dbg !344

140:                                              ; preds = %40
  ret i32 0, !dbg !362
}

define internal i32 @infer_dispatch_17_conv_3x224x224x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !363 {
  %4 = alloca float, i64 4, align 64, !dbg !364
  %5 = alloca float, i64 4, align 64, !dbg !365
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !366
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !366
  %8 = load ptr, ptr %7, align 8, !dbg !366
  %9 = getelementptr float, ptr %8, i64 5677312, !dbg !366
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !366
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !367
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !367
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !367
  %13 = load ptr, ptr %12, align 8, !dbg !367
  %14 = getelementptr float, ptr %13, i64 1033184, !dbg !367
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !367
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !368
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !368
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !368
  %18 = load ptr, ptr %17, align 8, !dbg !368
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !368
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !369
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !369
  %21 = getelementptr ptr, ptr %20, i32 3, !dbg !369
  %22 = load ptr, ptr %21, align 8, !dbg !369
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !369
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !364
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !364
  %25 = zext i32 %24 to i64, !dbg !364
  %26 = sdiv i64 %25, 7, !dbg !364
  %27 = mul i64 %26, 7, !dbg !364
  %28 = icmp ne i64 %25, %27, !dbg !364
  %29 = icmp slt i64 %25, 0, !dbg !364
  %30 = and i1 %28, %29, !dbg !364
  %31 = add i64 %26, -1, !dbg !364
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !364
  %33 = srem i64 %25, 7, !dbg !364
  %34 = icmp slt i64 %33, 0, !dbg !364
  %35 = add nsw i64 %33, 7, !dbg !364
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !364
  %37 = mul nsw i64 %32, 32, !dbg !364
  %38 = mul nsw i64 %36, 32, !dbg !364
  %39 = getelementptr float, ptr %5, i64 0, !dbg !370
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !370
  br label %40, !dbg !364

40:                                               ; preds = %145, %3
  %41 = phi i64 [ %146, %145 ], [ 0, %3 ], !dbg !364
  %42 = icmp slt i64 %41, 3, !dbg !364
  br i1 %42, label %43, label %147, !dbg !364

43:                                               ; preds = %40
  %44 = getelementptr float, ptr @__constant_3xf32, i64 %41, !dbg !371
  %45 = load <1 x float>, ptr %44, align 4, !dbg !371
  br label %46, !dbg !364

46:                                               ; preds = %143, %43
  %47 = phi i64 [ %144, %143 ], [ 0, %43 ], !dbg !364
  %48 = icmp slt i64 %47, 32, !dbg !364
  br i1 %48, label %49, label %145, !dbg !364

49:                                               ; preds = %107, %46
  %50 = phi i64 [ %142, %107 ], [ 0, %46 ], !dbg !364
  %51 = icmp slt i64 %50, 32, !dbg !364
  br i1 %51, label %52, label %143, !dbg !364

52:                                               ; preds = %49
  %53 = add i64 %50, %38, !dbg !364
  br label %54, !dbg !364

54:                                               ; preds = %57, %52
  %55 = phi i64 [ %62, %57 ], [ 0, %52 ], !dbg !364
  %56 = icmp slt i64 %55, 4, !dbg !364
  br i1 %56, label %57, label %63, !dbg !364

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !364
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !364
  %60 = load float, ptr %59, align 4, !dbg !364
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !364
  store float %60, ptr %61, align 4, !dbg !364
  %62 = add i64 %55, 1, !dbg !364
  br label %54, !dbg !364

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !364
  %65 = icmp slt i64 %64, 32, !dbg !364
  br i1 %65, label %66, label %107, !dbg !364

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !364
  %68 = icmp slt i64 %67, 3, !dbg !364
  br i1 %68, label %69, label %105, !dbg !364

69:                                               ; preds = %66
  %70 = add i64 %67, %47, !dbg !364
  %71 = add i64 %70, %37, !dbg !364
  br label %72, !dbg !364

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !364
  %74 = icmp slt i64 %73, 4, !dbg !364
  br i1 %74, label %75, label %103, !dbg !364

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !364
  %77 = icmp slt i64 %76, 3, !dbg !364
  br i1 %77, label %78, label %101, !dbg !364

78:                                               ; preds = %75
  %79 = add i64 %53, %73, !dbg !364
  %80 = add i64 %79, %76, !dbg !364
  %81 = mul nuw nsw i64 %64, 51076, !dbg !364
  %82 = mul nuw nsw i64 %71, 226, !dbg !364
  %83 = add nuw nsw i64 %81, %82, !dbg !364
  %84 = add nuw nsw i64 %83, %80, !dbg !364
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !364
  %86 = load float, ptr %85, align 4, !dbg !364
  %87 = mul nuw nsw i64 %41, 288, !dbg !364
  %88 = mul nuw nsw i64 %64, 9, !dbg !364
  %89 = add nuw nsw i64 %87, %88, !dbg !364
  %90 = mul nuw nsw i64 %67, 3, !dbg !364
  %91 = add nuw nsw i64 %89, %90, !dbg !364
  %92 = add nuw nsw i64 %91, %76, !dbg !364
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !364
  %94 = load float, ptr %93, align 4, !dbg !364
  %95 = add nuw nsw i64 0, %73, !dbg !364
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !364
  %97 = load float, ptr %96, align 4, !dbg !364
  %98 = fmul contract float %86, %94, !dbg !372
  %99 = fadd contract float %97, %98, !dbg !373
  store float %99, ptr %96, align 4, !dbg !364
  %100 = add i64 %76, 1, !dbg !364
  br label %75, !dbg !364

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !364
  br label %72, !dbg !364

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !364
  br label %66, !dbg !364

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !364
  br label %63, !dbg !364

107:                                              ; preds = %63
  %108 = add i64 %47, %37, !dbg !371
  %109 = mul i64 %41, 50176, !dbg !371
  %110 = mul i64 %108, 224, !dbg !371
  %111 = add i64 %109, %110, !dbg !371
  %112 = add i64 %111, %53, !dbg !371
  %113 = getelementptr float, ptr %18, i64 %112, !dbg !371
  %114 = load <4 x float>, ptr %113, align 4, !dbg !371
  %115 = getelementptr float, ptr %4, i64 0, !dbg !371
  %116 = load <4 x float>, ptr %115, align 4, !dbg !371
  %117 = extractelement <1 x float> %45, i64 0, !dbg !374
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !374
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !374
  %120 = fadd contract <4 x float> %116, %119, !dbg !374
  %121 = fcmp ult <4 x float> %120, splat (float 0x401FFEC880000000), !dbg !375
  %122 = select <4 x i1> %121, <4 x float> %120, <4 x float> splat (float 0x401FFEC880000000), !dbg !375
  %123 = fcmp ugt <4 x float> %122, splat (float 0xC01FFEC880000000), !dbg !375
  %124 = select <4 x i1> %123, <4 x float> %122, <4 x float> splat (float 0xC01FFEC880000000), !dbg !375
  %125 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %120), !dbg !375
  %126 = fcmp olt <4 x float> %125, splat (float 0x3F3A36E2E0000000), !dbg !375
  %127 = fmul contract <4 x float> %124, %124, !dbg !375
  %128 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> splat (float 0xBCB3E4B800000000), <4 x float> splat (float 0x3D4C266FC0000000)), !dbg !375
  %129 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %128, <4 x float> splat (float 0xBDD7A6FFE0000000)), !dbg !375
  %130 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %129, <4 x float> splat (float 0x3E6B800820000000)), !dbg !375
  %131 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %130, <4 x float> splat (float 0x3EEF286940000000)), !dbg !375
  %132 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %131, <4 x float> splat (float 0x3F44E1BDA0000000)), !dbg !375
  %133 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %132, <4 x float> splat (float 0x3F740B3B80000000)), !dbg !375
  %134 = fmul contract <4 x float> %124, %133, !dbg !375
  %135 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> splat (float 0x3EB41A7B00000000), <4 x float> splat (float 0x3F1F12BAC0000000)), !dbg !375
  %136 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %135, <4 x float> splat (float 0x3F629540A0000000)), !dbg !375
  %137 = call <4 x float> @llvm.fma.v4f32(<4 x float> %127, <4 x float> %136, <4 x float> splat (float 0x3F740B3BA0000000)), !dbg !375
  %138 = fdiv <4 x float> %134, %137, !dbg !375
  %139 = select <4 x i1> %126, <4 x float> %124, <4 x float> %138, !dbg !375
  %140 = fadd contract <4 x float> %114, %139, !dbg !376
  %141 = getelementptr float, ptr %22, i64 %112, !dbg !364
  store <4 x float> %140, ptr %141, align 4, !dbg !364
  %142 = add i64 %50, 4, !dbg !364
  br label %49, !dbg !364

143:                                              ; preds = %49
  %144 = add i64 %47, 1, !dbg !364
  br label %46, !dbg !364

145:                                              ; preds = %46
  %146 = add i64 %41, 1, !dbg !364
  br label %40, !dbg !364

147:                                              ; preds = %40
  ret i32 0, !dbg !377
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

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { uwtable "nonlazybind" }

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22}
!llvm.module.flags = !{!24}

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
!25 = distinct !DISubprogram(name: "infer_dispatch_0_matmul_like_32x50176x3_f32", linkageName: "infer_dispatch_0_matmul_like_32x50176x3_f32", scope: !1, file: !1, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!26 = !DISubroutineType(cc: DW_CC_normal, types: !27)
!27 = !{!28, !29, !60, !89}
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !32)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !33, file: !33, line: 246, size: 768, elements: !34)
!33 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!34 = !{!35, !43, !46, !49, !51}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!38 = !DICompositeType(tag: DW_TAG_array_type, scope: !33, file: !33, line: 227, baseType: !39, size: 2048, elements: !41)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !40)
!40 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!41 = !{!42}
!42 = !DISubrange(count: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !44, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !47, size: 64, offset: 128)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !44)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !50, size: 64, offset: 192)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !52, offset: 256)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !33, file: !33, line: 227, size: 512, elements: !53)
!53 = !{!54}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !55)
!55 = !DICompositeType(tag: DW_TAG_array_type, scope: !33, file: !33, line: 227, baseType: !56, size: 512, elements: !58)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !57)
!57 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!58 = !{!59}
!59 = !DISubrange(count: 8)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !62)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !63)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !33, file: !33, line: 275, size: 384, elements: !64)
!64 = !{!65, !66, !67, !70, !71, !72, !73, !74, !77, !78, !79, !84}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !39, size: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !39, size: 32, offset: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !68, size: 16, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !69)
!69 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !68, size: 16, offset: 80)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !39, size: 32, offset: 96)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !39, size: 32, offset: 128)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !68, size: 16, offset: 160)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !75, size: 8, offset: 176)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !76)
!76 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !75, size: 8, offset: 184)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !36, size: 64, offset: 192)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !80, size: 64, offset: 256)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !82)
!82 = !DICompositeType(tag: DW_TAG_array_type, scope: !33, file: !33, line: 227, baseType: !83, size: 4096, elements: !41)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !85, size: 64, offset: 320)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !87)
!87 = !DICompositeType(tag: DW_TAG_array_type, scope: !33, file: !33, line: 227, baseType: !88, size: 4096, elements: !41)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !56)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !92)
!92 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !33, file: !33, line: 321, size: 256, elements: !93)
!93 = !{!94, !95, !96, !97, !98, !99, !100}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !39, size: 32)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !39, size: 32, offset: 32)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !68, size: 16, offset: 64)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !68, size: 16, offset: 80)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !39, size: 32, offset: 96)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !44, size: 64, offset: 128)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !39, size: 32, offset: 192)
!101 = !DILocation(line: 13, column: 8, scope: !25)
!102 = !DILocation(line: 14, column: 8, scope: !25)
!103 = !DILocation(line: 15, column: 8, scope: !25)
!104 = !DILocation(line: 20, column: 8, scope: !25)
!105 = !DILocation(line: 26, column: 8, scope: !25)
!106 = !DILocation(line: 23, column: 10, scope: !25)
!107 = !DILocation(line: 28, column: 10, scope: !25)
!108 = !DILocation(line: 29, column: 10, scope: !25)
!109 = !DILocation(line: 30, column: 10, scope: !25)
!110 = !DILocation(line: 31, column: 10, scope: !25)
!111 = !DILocation(line: 32, column: 10, scope: !25)
!112 = !DILocation(line: 33, column: 10, scope: !25)
!113 = !DILocation(line: 34, column: 10, scope: !25)
!114 = !DILocation(line: 38, column: 8, scope: !25)
!115 = distinct !DISubprogram(name: "infer_dispatch_1_slow_memcpy", linkageName: "infer_dispatch_1_slow_memcpy", scope: !3, file: !3, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!116 = !DILocation(line: 11, column: 8, scope: !115)
!117 = !DILocation(line: 12, column: 8, scope: !115)
!118 = !DILocation(line: 13, column: 8, scope: !115)
!119 = !DILocation(line: 14, column: 8, scope: !115)
!120 = !DILocation(line: 16, column: 8, scope: !115)
!121 = !DILocation(line: 20, column: 8, scope: !115)
!122 = distinct !DISubprogram(name: "infer_dispatch_2_conv_64x224x224x32x3x3_f32", linkageName: "infer_dispatch_2_conv_64x224x224x32x3x3_f32", scope: !5, file: !5, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!123 = !DILocation(line: 22, column: 8, scope: !122)
!124 = !DILocation(line: 21, column: 8, scope: !122)
!125 = !DILocation(line: 15, column: 8, scope: !122)
!126 = !DILocation(line: 16, column: 8, scope: !122)
!127 = !DILocation(line: 17, column: 8, scope: !122)
!128 = !DILocation(line: 9, column: 8, scope: !122)
!129 = !DILocation(line: 28, column: 8, scope: !122)
!130 = !DILocation(line: 24, column: 10, scope: !122)
!131 = !DILocation(line: 25, column: 10, scope: !122)
!132 = !DILocation(line: 30, column: 10, scope: !122)
!133 = !DILocation(line: 31, column: 10, scope: !122)
!134 = !DILocation(line: 32, column: 10, scope: !122)
!135 = !DILocation(line: 33, column: 10, scope: !122)
!136 = !DILocation(line: 34, column: 10, scope: !122)
!137 = !DILocation(line: 35, column: 10, scope: !122)
!138 = !DILocation(line: 36, column: 10, scope: !122)
!139 = !DILocation(line: 40, column: 8, scope: !122)
!140 = distinct !DISubprogram(name: "infer_dispatch_3_conv_128x224x224x64x3x3_f32", linkageName: "infer_dispatch_3_conv_128x224x224x64x3x3_f32", scope: !7, file: !7, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!141 = !DILocation(line: 24, column: 8, scope: !140)
!142 = !DILocation(line: 23, column: 8, scope: !140)
!143 = !DILocation(line: 15, column: 8, scope: !140)
!144 = !DILocation(line: 16, column: 8, scope: !140)
!145 = !DILocation(line: 17, column: 8, scope: !140)
!146 = !DILocation(line: 18, column: 8, scope: !140)
!147 = !DILocation(line: 9, column: 8, scope: !140)
!148 = !DILocation(line: 30, column: 8, scope: !140)
!149 = !DILocation(line: 26, column: 10, scope: !140)
!150 = !DILocation(line: 27, column: 10, scope: !140)
!151 = !DILocation(line: 32, column: 10, scope: !140)
!152 = !DILocation(line: 33, column: 10, scope: !140)
!153 = !DILocation(line: 34, column: 10, scope: !140)
!154 = !DILocation(line: 35, column: 10, scope: !140)
!155 = !DILocation(line: 36, column: 10, scope: !140)
!156 = !DILocation(line: 37, column: 10, scope: !140)
!157 = !DILocation(line: 38, column: 10, scope: !140)
!158 = !DILocation(line: 42, column: 8, scope: !140)
!159 = distinct !DISubprogram(name: "infer_dispatch_4_slow_memcpy", linkageName: "infer_dispatch_4_slow_memcpy", scope: !9, file: !9, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!160 = !DILocation(line: 9, column: 8, scope: !159)
!161 = !DILocation(line: 10, column: 8, scope: !159)
!162 = !DILocation(line: 11, column: 8, scope: !159)
!163 = !DILocation(line: 12, column: 8, scope: !159)
!164 = !DILocation(line: 17, column: 8, scope: !159)
!165 = !DILocation(line: 18, column: 8, scope: !159)
!166 = !DILocation(line: 19, column: 8, scope: !159)
!167 = !DILocation(line: 20, column: 8, scope: !159)
!168 = !DILocation(line: 22, column: 8, scope: !159)
!169 = !DILocation(line: 26, column: 8, scope: !159)
!170 = distinct !DISubprogram(name: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_5_conv_128x224x224x128x3x3_f32", scope: !11, file: !11, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!171 = !DILocation(line: 34, column: 8, scope: !170)
!172 = !DILocation(line: 33, column: 8, scope: !170)
!173 = !DILocation(line: 11, column: 8, scope: !170)
!174 = !DILocation(line: 12, column: 8, scope: !170)
!175 = !DILocation(line: 13, column: 8, scope: !170)
!176 = !DILocation(line: 14, column: 8, scope: !170)
!177 = !DILocation(line: 15, column: 8, scope: !170)
!178 = !DILocation(line: 16, column: 8, scope: !170)
!179 = !DILocation(line: 17, column: 8, scope: !170)
!180 = !DILocation(line: 18, column: 8, scope: !170)
!181 = !DILocation(line: 25, column: 8, scope: !170)
!182 = !DILocation(line: 26, column: 8, scope: !170)
!183 = !DILocation(line: 27, column: 8, scope: !170)
!184 = !DILocation(line: 28, column: 8, scope: !170)
!185 = !DILocation(line: 10, column: 8, scope: !170)
!186 = !DILocation(line: 40, column: 8, scope: !170)
!187 = !DILocation(line: 36, column: 10, scope: !170)
!188 = !DILocation(line: 37, column: 10, scope: !170)
!189 = !DILocation(line: 42, column: 10, scope: !170)
!190 = !DILocation(line: 43, column: 10, scope: !170)
!191 = !DILocation(line: 44, column: 10, scope: !170)
!192 = !DILocation(line: 45, column: 10, scope: !170)
!193 = !DILocation(line: 46, column: 10, scope: !170)
!194 = !DILocation(line: 47, column: 10, scope: !170)
!195 = !DILocation(line: 48, column: 10, scope: !170)
!196 = !DILocation(line: 52, column: 8, scope: !170)
!197 = distinct !DISubprogram(name: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", linkageName: "infer_dispatch_6_conv_128x224x224x128x3x3_f32", scope: !13, file: !13, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!198 = !DILocation(line: 39, column: 8, scope: !197)
!199 = !DILocation(line: 38, column: 8, scope: !197)
!200 = !DILocation(line: 11, column: 8, scope: !197)
!201 = !DILocation(line: 12, column: 8, scope: !197)
!202 = !DILocation(line: 13, column: 8, scope: !197)
!203 = !DILocation(line: 14, column: 8, scope: !197)
!204 = !DILocation(line: 15, column: 8, scope: !197)
!205 = !DILocation(line: 16, column: 8, scope: !197)
!206 = !DILocation(line: 17, column: 8, scope: !197)
!207 = !DILocation(line: 18, column: 8, scope: !197)
!208 = !DILocation(line: 19, column: 8, scope: !197)
!209 = !DILocation(line: 20, column: 8, scope: !197)
!210 = !DILocation(line: 28, column: 8, scope: !197)
!211 = !DILocation(line: 29, column: 8, scope: !197)
!212 = !DILocation(line: 30, column: 8, scope: !197)
!213 = !DILocation(line: 31, column: 8, scope: !197)
!214 = !DILocation(line: 32, column: 8, scope: !197)
!215 = !DILocation(line: 10, column: 8, scope: !197)
!216 = !DILocation(line: 45, column: 8, scope: !197)
!217 = !DILocation(line: 41, column: 10, scope: !197)
!218 = !DILocation(line: 42, column: 10, scope: !197)
!219 = !DILocation(line: 47, column: 10, scope: !197)
!220 = !DILocation(line: 48, column: 10, scope: !197)
!221 = !DILocation(line: 49, column: 10, scope: !197)
!222 = !DILocation(line: 50, column: 10, scope: !197)
!223 = !DILocation(line: 51, column: 10, scope: !197)
!224 = !DILocation(line: 52, column: 10, scope: !197)
!225 = !DILocation(line: 53, column: 10, scope: !197)
!226 = !DILocation(line: 54, column: 10, scope: !197)
!227 = !DILocation(line: 58, column: 8, scope: !197)
!228 = distinct !DISubprogram(name: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", linkageName: "infer_dispatch_13_elementwise_broadcast_128x112x112_f32", scope: !15, file: !15, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!229 = !DILocation(line: 15, column: 8, scope: !228)
!230 = !DILocation(line: 16, column: 8, scope: !228)
!231 = !DILocation(line: 19, column: 8, scope: !228)
!232 = !DILocation(line: 21, column: 10, scope: !228)
!233 = !DILocation(line: 54, column: 10, scope: !228)
!234 = !DILocation(line: 22, column: 10, scope: !228)
!235 = !DILocation(line: 25, column: 10, scope: !228)
!236 = !DILocation(line: 26, column: 10, scope: !228)
!237 = !DILocation(line: 27, column: 10, scope: !228)
!238 = !DILocation(line: 28, column: 10, scope: !228)
!239 = !DILocation(line: 29, column: 10, scope: !228)
!240 = !DILocation(line: 30, column: 10, scope: !228)
!241 = !DILocation(line: 38, column: 10, scope: !228)
!242 = !DILocation(line: 39, column: 10, scope: !228)
!243 = !DILocation(line: 40, column: 10, scope: !228)
!244 = !DILocation(line: 41, column: 10, scope: !228)
!245 = !DILocation(line: 43, column: 10, scope: !228)
!246 = !DILocation(line: 44, column: 10, scope: !228)
!247 = !DILocation(line: 56, column: 10, scope: !228)
!248 = !DILocation(line: 58, column: 10, scope: !228)
!249 = !DILocation(line: 59, column: 10, scope: !228)
!250 = !DILocation(line: 23, column: 10, scope: !228)
!251 = !DILocation(line: 32, column: 10, scope: !228)
!252 = !DILocation(line: 33, column: 10, scope: !228)
!253 = !DILocation(line: 34, column: 10, scope: !228)
!254 = !DILocation(line: 35, column: 10, scope: !228)
!255 = !DILocation(line: 36, column: 10, scope: !228)
!256 = !DILocation(line: 37, column: 10, scope: !228)
!257 = !DILocation(line: 46, column: 10, scope: !228)
!258 = !DILocation(line: 47, column: 10, scope: !228)
!259 = !DILocation(line: 48, column: 10, scope: !228)
!260 = !DILocation(line: 49, column: 10, scope: !228)
!261 = !DILocation(line: 51, column: 10, scope: !228)
!262 = !DILocation(line: 52, column: 10, scope: !228)
!263 = !DILocation(line: 55, column: 10, scope: !228)
!264 = !DILocation(line: 57, column: 10, scope: !228)
!265 = !DILocation(line: 60, column: 10, scope: !228)
!266 = !DILocation(line: 61, column: 10, scope: !228)
!267 = !DILocation(line: 62, column: 10, scope: !228)
!268 = !DILocation(line: 63, column: 10, scope: !228)
!269 = !DILocation(line: 64, column: 10, scope: !228)
!270 = !DILocation(line: 65, column: 10, scope: !228)
!271 = !DILocation(line: 66, column: 10, scope: !228)
!272 = !DILocation(line: 67, column: 10, scope: !228)
!273 = !DILocation(line: 68, column: 10, scope: !228)
!274 = !DILocation(line: 69, column: 10, scope: !228)
!275 = !DILocation(line: 70, column: 10, scope: !228)
!276 = !DILocation(line: 74, column: 8, scope: !228)
!277 = distinct !DISubprogram(name: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", linkageName: "infer_dispatch_14_conv_64x112x112x128x3x3_f32", scope: !17, file: !17, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!278 = !DILocation(line: 22, column: 8, scope: !277)
!279 = !DILocation(line: 21, column: 8, scope: !277)
!280 = !DILocation(line: 15, column: 8, scope: !277)
!281 = !DILocation(line: 16, column: 8, scope: !277)
!282 = !DILocation(line: 17, column: 8, scope: !277)
!283 = !DILocation(line: 9, column: 8, scope: !277)
!284 = !DILocation(line: 28, column: 8, scope: !277)
!285 = !DILocation(line: 24, column: 10, scope: !277)
!286 = !DILocation(line: 25, column: 10, scope: !277)
!287 = !DILocation(line: 30, column: 10, scope: !277)
!288 = !DILocation(line: 31, column: 10, scope: !277)
!289 = !DILocation(line: 32, column: 10, scope: !277)
!290 = !DILocation(line: 33, column: 10, scope: !277)
!291 = !DILocation(line: 34, column: 10, scope: !277)
!292 = !DILocation(line: 35, column: 10, scope: !277)
!293 = !DILocation(line: 36, column: 10, scope: !277)
!294 = !DILocation(line: 40, column: 8, scope: !277)
!295 = distinct !DISubprogram(name: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", linkageName: "infer_dispatch_15_elementwise_broadcast_64x224x224_f32", scope: !19, file: !19, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!296 = !DILocation(line: 16, column: 8, scope: !295)
!297 = !DILocation(line: 17, column: 8, scope: !295)
!298 = !DILocation(line: 20, column: 8, scope: !295)
!299 = !DILocation(line: 55, column: 10, scope: !295)
!300 = !DILocation(line: 23, column: 10, scope: !295)
!301 = !DILocation(line: 26, column: 10, scope: !295)
!302 = !DILocation(line: 27, column: 10, scope: !295)
!303 = !DILocation(line: 28, column: 10, scope: !295)
!304 = !DILocation(line: 29, column: 10, scope: !295)
!305 = !DILocation(line: 30, column: 10, scope: !295)
!306 = !DILocation(line: 31, column: 10, scope: !295)
!307 = !DILocation(line: 39, column: 10, scope: !295)
!308 = !DILocation(line: 40, column: 10, scope: !295)
!309 = !DILocation(line: 41, column: 10, scope: !295)
!310 = !DILocation(line: 42, column: 10, scope: !295)
!311 = !DILocation(line: 44, column: 10, scope: !295)
!312 = !DILocation(line: 45, column: 10, scope: !295)
!313 = !DILocation(line: 57, column: 10, scope: !295)
!314 = !DILocation(line: 59, column: 10, scope: !295)
!315 = !DILocation(line: 60, column: 10, scope: !295)
!316 = !DILocation(line: 24, column: 10, scope: !295)
!317 = !DILocation(line: 33, column: 10, scope: !295)
!318 = !DILocation(line: 34, column: 10, scope: !295)
!319 = !DILocation(line: 35, column: 10, scope: !295)
!320 = !DILocation(line: 36, column: 10, scope: !295)
!321 = !DILocation(line: 37, column: 10, scope: !295)
!322 = !DILocation(line: 38, column: 10, scope: !295)
!323 = !DILocation(line: 47, column: 10, scope: !295)
!324 = !DILocation(line: 48, column: 10, scope: !295)
!325 = !DILocation(line: 49, column: 10, scope: !295)
!326 = !DILocation(line: 50, column: 10, scope: !295)
!327 = !DILocation(line: 52, column: 10, scope: !295)
!328 = !DILocation(line: 53, column: 10, scope: !295)
!329 = !DILocation(line: 56, column: 10, scope: !295)
!330 = !DILocation(line: 58, column: 10, scope: !295)
!331 = !DILocation(line: 61, column: 10, scope: !295)
!332 = !DILocation(line: 62, column: 10, scope: !295)
!333 = !DILocation(line: 63, column: 10, scope: !295)
!334 = !DILocation(line: 64, column: 10, scope: !295)
!335 = !DILocation(line: 65, column: 10, scope: !295)
!336 = !DILocation(line: 66, column: 10, scope: !295)
!337 = !DILocation(line: 67, column: 10, scope: !295)
!338 = !DILocation(line: 68, column: 10, scope: !295)
!339 = !DILocation(line: 69, column: 10, scope: !295)
!340 = !DILocation(line: 70, column: 10, scope: !295)
!341 = !DILocation(line: 71, column: 10, scope: !295)
!342 = !DILocation(line: 75, column: 8, scope: !295)
!343 = distinct !DISubprogram(name: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", linkageName: "infer_dispatch_16_conv_32x224x224x64x3x3_f32", scope: !21, file: !21, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!344 = !DILocation(line: 25, column: 8, scope: !343)
!345 = !DILocation(line: 24, column: 8, scope: !343)
!346 = !DILocation(line: 16, column: 8, scope: !343)
!347 = !DILocation(line: 17, column: 8, scope: !343)
!348 = !DILocation(line: 18, column: 8, scope: !343)
!349 = !DILocation(line: 19, column: 8, scope: !343)
!350 = !DILocation(line: 9, column: 8, scope: !343)
!351 = !DILocation(line: 31, column: 8, scope: !343)
!352 = !DILocation(line: 27, column: 10, scope: !343)
!353 = !DILocation(line: 28, column: 10, scope: !343)
!354 = !DILocation(line: 33, column: 10, scope: !343)
!355 = !DILocation(line: 34, column: 10, scope: !343)
!356 = !DILocation(line: 35, column: 10, scope: !343)
!357 = !DILocation(line: 36, column: 10, scope: !343)
!358 = !DILocation(line: 37, column: 10, scope: !343)
!359 = !DILocation(line: 38, column: 10, scope: !343)
!360 = !DILocation(line: 39, column: 10, scope: !343)
!361 = !DILocation(line: 40, column: 10, scope: !343)
!362 = !DILocation(line: 44, column: 8, scope: !343)
!363 = distinct !DISubprogram(name: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", linkageName: "infer_dispatch_17_conv_3x224x224x32x3x3_f32", scope: !23, file: !23, line: 1, type: !26, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!364 = !DILocation(line: 23, column: 8, scope: !363)
!365 = !DILocation(line: 22, column: 8, scope: !363)
!366 = !DILocation(line: 14, column: 8, scope: !363)
!367 = !DILocation(line: 15, column: 8, scope: !363)
!368 = !DILocation(line: 16, column: 8, scope: !363)
!369 = !DILocation(line: 17, column: 8, scope: !363)
!370 = !DILocation(line: 9, column: 8, scope: !363)
!371 = !DILocation(line: 29, column: 8, scope: !363)
!372 = !DILocation(line: 25, column: 10, scope: !363)
!373 = !DILocation(line: 26, column: 10, scope: !363)
!374 = !DILocation(line: 31, column: 10, scope: !363)
!375 = !DILocation(line: 32, column: 10, scope: !363)
!376 = !DILocation(line: 33, column: 10, scope: !363)
!377 = !DILocation(line: 37, column: 8, scope: !363)
