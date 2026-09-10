; ModuleID = 'b2_resnet_linked'
source_filename = "b2_resnet_linked"
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

@__constant_16xf32 = private constant [16 x float] [float 0x3FE3797060000000, float 0x3FD49DDCC0000000, float 0x3FE640F5C0000000, float 0x3FD40A2FA0000000, float 0x3FE01243C0000000, float 0x3FC695D220000000, float 0x3FE08EB180000000, float 0x3FE30EF860000000, float 0x3FC76B6360000000, float 0x3FD379CD80000000, float 0x3FC29C33A0000000, float 0x3FE708B9E0000000, float 0x3FE7C54340000000, float 0xBFC6132FC0000000, float 0xBFEE139260000000, float 0x3FF71FC120000000], align 64
@__constant_16xf32_0 = private constant [16 x float] [float 0x400DC5B820000000, float 0xBFF1716C00000000, float 0x400554FC60000000, float 0x3FF5052840000000, float 0x400DA5E000000000, float 0x3FE0126680000000, float 0xBFE66B0200000000, float 0x3FDA8DED00000000, float 0x3FFC654DA0000000, float 0x3F8A0F9D40000000, float 0xC0123A1E40000000, float 0xBFF21E5360000000, float 0x3FDCC6F7C0000000, float 0x3FC168F9E0000000, float 0x3FC66AD700000000, float 0x3FF25C0F40000000], align 64
@__constant_16xf32_1 = private constant [16 x float] [float 0x3FEC967500000000, float 0x3FD028C620000000, float 0xBFCEC95980000000, float 0xBFF47E9940000000, float 0x3FB8D54C40000000, float 0x3FAC865DC0000000, float 0xBFD8763680000000, float 0xBFEDA1A0C0000000, float 0xBF880BF820000000, float 0x3FF2760720000000, float 0x3FF21BC7E0000000, float 0xBFCF8D5B60000000, float 0xBFC9F88EC0000000, float 0x3FC2C53260000000, float 0x3FE3231720000000, float 0xBFF13A7200000000], align 64
@__constant_32xf32 = private constant [32 x float] [float 0x3FF57BF880000000, float 0x3FD1691CA0000000, float 0x3FFAF39FA0000000, float 0xBFF789C0E0000000, float 0x4001B51D40000000, float 0x3FF8D4E640000000, float 0xBFED4DB340000000, float 0x3FFFA37320000000, float 0x3FF481FD40000000, float 0x3FE924C200000000, float 0xBFD35924E0000000, float 0x3FFBBE9D40000000, float 0x3FB8413E80000000, float 0xBFE6089200000000, float 0x3FFE238C80000000, float 0x3FDCA0D500000000, float 0x3FE3A10960000000, float 0xBFDC6A4E80000000, float 0xBFFA16C3E0000000, float 0x3FB507A0A0000000, float 0x3FD8155300000000, float 0xBFE0C303E0000000, float 0x3FD6EC3A00000000, float 0x3FEC9E0920000000, float 0x3FDBDCC320000000, float 0x3FBA8CC640000000, float 0x400681B980000000, float 0x3FCBC93300000000, float 0x3FE6EA2040000000, float 0x3FF515A9E0000000, float 0xBFC2906D80000000, float 0x3FED98EAA0000000], align 64
@__constant_32xf32_0 = private constant [32 x float] [float 0xBF89430180000000, float 0x3F62125DE0000000, float 0x3FC4FD1080000000, float 0xBFBF1F1980000000, float 0xBFB4C3AB00000000, float 0xBFC2A285A0000000, float 0xBF96D13E40000000, float 0x3FC1EAF5A0000000, float 0x3FD3E38680000000, float 0xBFBAAA3F80000000, float 0xBFBA4123E0000000, float 0xBFB0065CA0000000, float 0xBFCA1FD020000000, float 0xBFA22CFBA0000000, float 0x3FB01312E0000000, float 0x3FB3889700000000, float 0x3F9642F640000000, float 0xBFB5EBD7E0000000, float 0x3FCB0F9D20000000, float 0x3FC41F10A0000000, float 0xBFD0FF9A80000000, float 0x3FB9470FC0000000, float 0x3FC27050A0000000, float 0xBFC30D38C0000000, float 0x3F92535A40000000, float 0x3FAC076CE0000000, float 0xBFCF6648A0000000, float 0xBF82C22320000000, float 0x3FC95D6A40000000, float 0xBFCED06DA0000000, float 0x3FB8322360000000, float 0x3FD03CB660000000], align 64
@__constant_32xf32_1 = private constant [32 x float] [float 0x3FF8820840000000, float 0xBFE01EDE00000000, float 0x3FE8985BA0000000, float 0xBFE7CBE1C0000000, float 0x3FE4906380000000, float 0xBFD9D7AF60000000, float 0x400D5CAD40000000, float 0xBFA63CF3E0000000, float 0x400D159680000000, float 0xBFFE2ABA60000000, float 0x3FDCF6F660000000, float 0x3FFD105340000000, float 0x3FF7511260000000, float 0x3FFEBB6740000000, float 0xBFFB8A51A0000000, float 0xBFF0828000000000, float 0x400A7249A0000000, float 0x3FE7A76920000000, float 0x3FD22B51E0000000, float 0x4003A40920000000, float 0xC0034EC920000000, float 0x3FF6D69580000000, float 0x3FF73600A0000000, float 0x3FC474FF40000000, float 0xBFC6D8D2E0000000, float 0x3FF1B52AA0000000, float 0xBFF3171B80000000, float 0xBFF0C7E3C0000000, float 0x4008F344E0000000, float 0xBFD2F5F7A0000000, float 0x3FFB63A300000000, float 0x3FEF1A08A0000000], align 64
@__constant_64xf32 = private constant [64 x float] [float 0x3FE3B5B8A0000000, float 0x3FF40AB280000000, float 0x3FF88AF860000000, float 0xBFF02B6440000000, float 0xBFC40E8EA0000000, float 0x3FD608E880000000, float 0x3FF07CCFE0000000, float 0xBFFB3175E0000000, float 0x3FD3ADDBA0000000, float 0x3FD757E580000000, float 0x3FFB105040000000, float 0xBFC79F9780000000, float 0x3FE204B460000000, float 0x3FCF28D660000000, float 0x3FD76DD7C0000000, float 0x3FF56612A0000000, float 0xBF91EC3DE0000000, float 0xBFE1563060000000, float 0x3FCA60B020000000, float 0x3FED076D40000000, float 0x3F0C3F6400000000, float 0x3FF11BDD20000000, float 0xBFE352EBC0000000, float 0xBFFA207320000000, float 0x3FF7605620000000, float 0x3FED2DA7E0000000, float 0x3FDAAEFC20000000, float 0x3FEE59FAA0000000, float 0xBFE3A14660000000, float 0xBFF0F294E0000000, float 0xBFDDA310A0000000, float 0xBFFD71E0A0000000, float 0xBFF9E523C0000000, float 0xBF94FD0BC0000000, float 0x3FE67D4E80000000, float 0xBFEE4F8A60000000, float 0x3FF5E445E0000000, float 0xC005BC5BA0000000, float 0xBFD1562760000000, float 0x400063B6C0000000, float 0x3FD42B7700000000, float 0x3FF83AB5E0000000, float 0x3FFB16EEA0000000, float 0xBFD7878C60000000, float 0xBFCBC88AE0000000, float 0xBFD640DFA0000000, float 0x3FFFA94D80000000, float 0x3FBBB518A0000000, float 0xBFFAB3B980000000, float 0xBFC2D74160000000, float 0x3FD63A7360000000, float 0x3FE111B440000000, float 0xBFEC772BA0000000, float 0xBFD80A6E20000000, float 0xBFEC67B800000000, float 0x3FF1909C20000000, float 0xBFF5108DC0000000, float 0x3FECB574E0000000, float 0xBFE8C35940000000, float 0x3FE6DE6260000000, float 0xBFD72307E0000000, float 0xBFFF383EC0000000, float 0x3FE1C54640000000, float 0x3FF3B6E860000000], align 64
@__constant_64xf32_0 = private constant [64 x float] [float 0xBFD7797A20000000, float 0x3FA8BEEC00000000, float 0xBFD345B2E0000000, float 0xBFCD4F3F40000000, float 0xBFBBB0F1C0000000, float 0xBFE2D2DC20000000, float 0xBFCFABAA20000000, float 0xBFB865B6E0000000, float 0xBFC4A93D80000000, float 0xBFCAE492A0000000, float 0xBFA52EF560000000, float 0x3F879FF4A0000000, float 0xBFD537B9A0000000, float 0xBFC46F9500000000, float 0xBF7AC44840000000, float 0xBFA0837860000000, float 0xBFAC69F640000000, float 0xBFD1EBF500000000, float 0xBFAE499280000000, float 0x3FBE685700000000, float 0xBFC0147D00000000, float 0xBFC56FD0A0000000, float 0x3FA2B86220000000, float 0xBFC2BAC5A0000000, float 0xBFB2172820000000, float 0xBFCE10E1E0000000, float 0xBF9AD8AA00000000, float 0xBFE8346840000000, float 0xBFCD3E2980000000, float 0xBFC3B7AC20000000, float 0xBFD182BC00000000, float 0xBFBAC8B200000000, float 0xBFCC137B20000000, float 0x3FC0EE99C0000000, float 0xBF85EC0760000000, float 0xBFE5004540000000, float 0xBFC3EB6BE0000000, float 0xBFC7A1E320000000, float 0xBFC8DAE260000000, float 0x3FAF9B4100000000, float 0xBFBFFA5F80000000, float 0xBFD2FE8BE0000000, float 0xBF9A1B99A0000000, float 0xBFD7AE8C40000000, float 0x3FB8BA91A0000000, float 0xBFC170BA20000000, float 0xBFBD1F81E0000000, float 0xBFCFC68C40000000, float 0x3F935E81A0000000, float 0xBFC88A5EE0000000, float 0xBFD1FAD900000000, float 0xBFD2101000000000, float 0x3F7F3D4BE0000000, float 0xBFE11C9540000000, float 0xBFDD773760000000, float 0xBFDC6549A0000000, float 0x3F91E506A0000000, float 0xBFB2D6E620000000, float 0xBFA932E4E0000000, float 0xBFB7C02540000000, float 0xBFD07F3260000000, float 0x3FAEC124A0000000, float 0xBFCAAF9300000000, float 0xBFA09177C0000000], align 64
@__constant_64xf32_1 = private constant [64 x float] [float 0x3FE7E6EE60000000, float 0xBFA0CEB4E0000000, float 0xBFEFECD960000000, float 0x3FD0135780000000, float 0x40069F1420000000, float 0xBFECCC6080000000, float 0x3FCB8E3DC0000000, float 0xBFF3F730E0000000, float 0x400B68BF80000000, float 0x3FF2CA5DC0000000, float 0x3FF1F495E0000000, float 0x4004C74180000000, float 0x3FCD8D0DE0000000, float 0x40046E72A0000000, float 0x4001809D00000000, float 0xBFED8E6520000000, float 0x3FD9D8BFA0000000, float 0x3FF6080D20000000, float 0x3FF9A82FE0000000, float 0xBFE251F200000000, float 0x3FC1C1CBE0000000, float 0x3FEEC10E80000000, float 0x4003B9E500000000, float 0x3FA0186180000000, float 0xBFF140E520000000, float 0x3FE2C3CF60000000, float 0x4003E524E0000000, float 0x3FF3580C20000000, float 0x40051B4920000000, float 0xBFDF92EF60000000, float 0x40024903E0000000, float 0x4013297460000000, float 0x40162AD8E0000000, float 0x3FFD5CE880000000, float 0xBFECEB6AA0000000, float 0xBFEE8972E0000000, float 0x3FF6C73740000000, float 0x3FF7F490E0000000, float 0xBFB39C6140000000, float 0x4009606100000000, float 0xBFD2703000000000, float 0x4007FC7580000000, float 0x400CFAAFC0000000, float 0xBFE7206500000000, float 0x4000741B40000000, float 0xBFC889E240000000, float 0x3FE8E61E40000000, float 0x3FCDF8B1A0000000, float 0x3FD65A9760000000, float 0xBFF181DE20000000, float 0x3FF7EDC660000000, float 0x3FF4B81F20000000, float 0x4006F98700000000, float 0x3FEDF83D60000000, float 0x400D1156C0000000, float 0x400CB38D80000000, float 0x3FF3276200000000, float 0x40044303E0000000, float 0x40032565E0000000, float 0x3FF82070E0000000, float 0xBFF19DC800000000, float 0x3FFB51B1C0000000, float 0xBFDDD1F000000000, float 0x4005EA6B60000000], align 64
@__constant_1x10xf32 = private constant [1 x [10 x float]] [[10 x float] [float 0xBFB6C447C0000000, float 0xBFC4001D60000000, float 0x3F92039880000000, float 0x3FB21875E0000000, float 0x3FA7DF3500000000, float 0xBFC0EBFFA0000000, float 0x3FC5D7DEC0000000, float 0xBFBBD90560000000, float 0xBF7B8D63C0000000, float 0x3FC6F33C40000000]], align 64
@0 = private constant [17 x i8] c"b2_resnet_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [16 x ptr] [ptr @infer_dispatch_0_slow_memcpy, ptr @infer_dispatch_1_conv_16x32x32x3x3x3_f32, ptr @infer_dispatch_2_slow_memcpy, ptr @infer_dispatch_3_conv_16x32x32x16x3x3_f32, ptr @infer_dispatch_4_conv_16x32x32x16x3x3_f32, ptr @infer_dispatch_5_slow_memcpy, ptr @infer_dispatch_6_conv_32x16x16x16x3x3_f32, ptr @infer_dispatch_7_matmul_like_32x16x16x16_f32, ptr @infer_dispatch_8_conv_32x16x16x32x3x3_f32, ptr @infer_dispatch_9_slow_memcpy, ptr @infer_dispatch_10_conv_64x8x8x32x3x3_f32, ptr @infer_dispatch_11_conv_64x8x8x64x3x3_f32, ptr @infer_dispatch_12_matmul_like_64x8x8x32_f32, ptr @infer_dispatch_13_reduction_64x64_f32, ptr @infer_dispatch_14_matmul_1x10x64_f32, ptr @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store]
@iree_hal_executable_library_query_v0_attrs = private constant [16 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [29 x i8] c"infer_dispatch_0_slow_memcpy\00", align 1
@2 = private constant [41 x i8] c"infer_dispatch_1_conv_16x32x32x3x3x3_f32\00", align 1
@3 = private constant [29 x i8] c"infer_dispatch_2_slow_memcpy\00", align 1
@4 = private constant [42 x i8] c"infer_dispatch_3_conv_16x32x32x16x3x3_f32\00", align 1
@5 = private constant [42 x i8] c"infer_dispatch_4_conv_16x32x32x16x3x3_f32\00", align 1
@6 = private constant [29 x i8] c"infer_dispatch_5_slow_memcpy\00", align 1
@7 = private constant [42 x i8] c"infer_dispatch_6_conv_32x16x16x16x3x3_f32\00", align 1
@8 = private constant [45 x i8] c"infer_dispatch_7_matmul_like_32x16x16x16_f32\00", align 1
@9 = private constant [42 x i8] c"infer_dispatch_8_conv_32x16x16x32x3x3_f32\00", align 1
@10 = private constant [29 x i8] c"infer_dispatch_9_slow_memcpy\00", align 1
@11 = private constant [41 x i8] c"infer_dispatch_10_conv_64x8x8x32x3x3_f32\00", align 1
@12 = private constant [41 x i8] c"infer_dispatch_11_conv_64x8x8x64x3x3_f32\00", align 1
@13 = private constant [44 x i8] c"infer_dispatch_12_matmul_like_64x8x8x32_f32\00", align 1
@14 = private constant [38 x i8] c"infer_dispatch_13_reduction_64x64_f32\00", align 1
@15 = private constant [37 x i8] c"infer_dispatch_14_matmul_1x10x64_f32\00", align 1
@16 = private constant [55 x i8] c"infer_dispatch_15_softmax_10xf32_dispatch_tensor_store\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [16 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5, ptr @6, ptr @7, ptr @8, ptr @9, ptr @10, ptr @11, ptr @12, ptr @13, ptr @14, ptr @15, ptr @16]
@17 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@18 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@19 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@20 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_3.mlir\00", align 1
@21 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@22 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@23 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_6.mlir\00", align 1
@24 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_7.mlir\00", align 1
@25 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_8.mlir\00", align 1
@26 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_9.mlir\00", align 1
@27 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_10.mlir\00", align 1
@28 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_11.mlir\00", align 1
@29 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_12.mlir\00", align 1
@30 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_13.mlir\00", align 1
@31 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_14.mlir\00", align 1
@32 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_15.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [16 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @17 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @18 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @19 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @20 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @21 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @22 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @23 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @24 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @25 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @26 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @27 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @28 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @29 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @30 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @31 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @32 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [16 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 16, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = hidden local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = hidden local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

define internal i32 @infer_dispatch_0_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !39 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !115
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !115
  %6 = load ptr, ptr %5, align 8, !dbg !115
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !116
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !117
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !117
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !117
  %10 = load ptr, ptr %9, align 8, !dbg !117
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !118
  br label %11, !dbg !119

11:                                               ; preds = %37, %3
  %12 = phi i64 [ %38, %37 ], [ 0, %3 ], !dbg !119
  %13 = icmp slt i64 %12, 3, !dbg !119
  br i1 %13, label %14, label %39, !dbg !119

14:                                               ; preds = %35, %11
  %15 = phi i64 [ %36, %35 ], [ 0, %11 ], !dbg !119
  %16 = icmp slt i64 %15, 32, !dbg !119
  br i1 %16, label %17, label %37, !dbg !119

17:                                               ; preds = %20, %14
  %18 = phi i64 [ %34, %20 ], [ 0, %14 ], !dbg !119
  %19 = icmp slt i64 %18, 32, !dbg !119
  br i1 %19, label %20, label %35, !dbg !119

20:                                               ; preds = %17
  %21 = mul i64 %12, 1024, !dbg !119
  %22 = mul i64 %15, 32, !dbg !119
  %23 = add i64 %21, %22, !dbg !119
  %24 = add i64 %23, %18, !dbg !119
  %25 = getelementptr float, ptr %6, i64 %24, !dbg !119
  %26 = load <4 x float>, ptr %25, align 4, !dbg !119
  %27 = add i64 %15, 1, !dbg !119
  %28 = add i64 %18, 1, !dbg !119
  %29 = mul i64 %12, 1156, !dbg !119
  %30 = mul i64 %27, 34, !dbg !119
  %31 = add i64 %29, %30, !dbg !119
  %32 = add i64 %31, %28, !dbg !119
  %33 = getelementptr float, ptr %10, i64 %32, !dbg !119
  store <4 x float> %26, ptr %33, align 4, !dbg !119
  %34 = add i64 %18, 4, !dbg !119
  br label %17, !dbg !119

35:                                               ; preds = %17
  %36 = add i64 %15, 1, !dbg !119
  br label %14, !dbg !119

37:                                               ; preds = %14
  %38 = add i64 %12, 1, !dbg !119
  br label %11, !dbg !119

39:                                               ; preds = %11
  ret i32 0, !dbg !120
}

define internal i32 @infer_dispatch_1_conv_16x32x32x3x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !121 {
  %4 = alloca float, i64 4, align 64, !dbg !122
  %5 = alloca float, i64 4, align 64, !dbg !123
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !124
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !124
  %8 = load ptr, ptr %7, align 8, !dbg !124
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !124
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !125
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !125
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !125
  %12 = load ptr, ptr %11, align 8, !dbg !125
  %13 = getelementptr float, ptr %12, i64 71680, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !125
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !126
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !126
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !126
  %17 = load ptr, ptr %16, align 8, !dbg !126
  %18 = getelementptr float, ptr %17, i64 3472, !dbg !126
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !126
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !122
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !122
  %21 = zext i32 %20 to i64, !dbg !122
  %22 = sdiv i64 %21, 2, !dbg !122
  %23 = mul i64 %22, 2, !dbg !122
  %24 = icmp ne i64 %21, %23, !dbg !122
  %25 = icmp slt i64 %21, 0, !dbg !122
  %26 = and i1 %24, %25, !dbg !122
  %27 = add i64 %22, -1, !dbg !122
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !122
  %29 = srem i64 %21, 2, !dbg !122
  %30 = icmp slt i64 %29, 0, !dbg !122
  %31 = add nsw i64 %29, 2, !dbg !122
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !122
  %33 = mul nsw i64 %28, 2, !dbg !122
  %34 = mul nsw i64 %32, 16, !dbg !122
  %35 = getelementptr float, ptr %5, i64 0, !dbg !127
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !127
  br label %36, !dbg !122

36:                                               ; preds = %120, %3
  %37 = phi i64 [ %121, %120 ], [ 0, %3 ], !dbg !122
  %38 = icmp slt i64 %37, 2, !dbg !122
  br i1 %38, label %39, label %122, !dbg !122

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !122
  %41 = getelementptr float, ptr @__constant_16xf32, i64 %40, !dbg !128
  %42 = load <1 x float>, ptr %41, align 4, !dbg !128
  br label %43, !dbg !122

43:                                               ; preds = %118, %39
  %44 = phi i64 [ %119, %118 ], [ 0, %39 ], !dbg !122
  %45 = icmp slt i64 %44, 16, !dbg !122
  br i1 %45, label %46, label %120, !dbg !122

46:                                               ; preds = %102, %43
  %47 = phi i64 [ %117, %102 ], [ 0, %43 ], !dbg !122
  %48 = icmp slt i64 %47, 32, !dbg !122
  br i1 %48, label %49, label %118, !dbg !122

49:                                               ; preds = %52, %46
  %50 = phi i64 [ %57, %52 ], [ 0, %46 ], !dbg !122
  %51 = icmp slt i64 %50, 4, !dbg !122
  br i1 %51, label %52, label %58, !dbg !122

52:                                               ; preds = %49
  %53 = add nuw nsw i64 0, %50, !dbg !122
  %54 = getelementptr inbounds nuw float, ptr %5, i64 %53, !dbg !122
  %55 = load float, ptr %54, align 4, !dbg !122
  %56 = getelementptr inbounds nuw float, ptr %4, i64 %53, !dbg !122
  store float %55, ptr %56, align 4, !dbg !122
  %57 = add i64 %50, 1, !dbg !122
  br label %49, !dbg !122

58:                                               ; preds = %100, %49
  %59 = phi i64 [ %101, %100 ], [ 0, %49 ], !dbg !122
  %60 = icmp slt i64 %59, 3, !dbg !122
  br i1 %60, label %61, label %102, !dbg !122

61:                                               ; preds = %98, %58
  %62 = phi i64 [ %99, %98 ], [ 0, %58 ], !dbg !122
  %63 = icmp slt i64 %62, 3, !dbg !122
  br i1 %63, label %64, label %100, !dbg !122

64:                                               ; preds = %61
  %65 = add i64 %62, %44, !dbg !122
  %66 = add i64 %65, %34, !dbg !122
  br label %67, !dbg !122

67:                                               ; preds = %96, %64
  %68 = phi i64 [ %97, %96 ], [ 0, %64 ], !dbg !122
  %69 = icmp slt i64 %68, 4, !dbg !122
  br i1 %69, label %70, label %98, !dbg !122

70:                                               ; preds = %73, %67
  %71 = phi i64 [ %95, %73 ], [ 0, %67 ], !dbg !122
  %72 = icmp slt i64 %71, 3, !dbg !122
  br i1 %72, label %73, label %96, !dbg !122

73:                                               ; preds = %70
  %74 = add i64 %47, %68, !dbg !122
  %75 = add i64 %74, %71, !dbg !122
  %76 = mul nuw nsw i64 %59, 1156, !dbg !122
  %77 = mul nuw nsw i64 %66, 34, !dbg !122
  %78 = add nuw nsw i64 %76, %77, !dbg !122
  %79 = add nuw nsw i64 %78, %75, !dbg !122
  %80 = getelementptr inbounds nuw float, ptr %8, i64 %79, !dbg !122
  %81 = load float, ptr %80, align 4, !dbg !122
  %82 = mul nuw nsw i64 %40, 27, !dbg !122
  %83 = mul nuw nsw i64 %59, 9, !dbg !122
  %84 = add nuw nsw i64 %82, %83, !dbg !122
  %85 = mul nuw nsw i64 %62, 3, !dbg !122
  %86 = add nuw nsw i64 %84, %85, !dbg !122
  %87 = add nuw nsw i64 %86, %71, !dbg !122
  %88 = getelementptr inbounds nuw float, ptr %13, i64 %87, !dbg !122
  %89 = load float, ptr %88, align 4, !dbg !122
  %90 = add nuw nsw i64 0, %68, !dbg !122
  %91 = getelementptr inbounds nuw float, ptr %4, i64 %90, !dbg !122
  %92 = load float, ptr %91, align 4, !dbg !122
  %93 = fmul contract float %81, %89, !dbg !129
  %94 = fadd contract float %92, %93, !dbg !130
  store float %94, ptr %91, align 4, !dbg !122
  %95 = add i64 %71, 1, !dbg !122
  br label %70, !dbg !122

96:                                               ; preds = %70
  %97 = add i64 %68, 1, !dbg !122
  br label %67, !dbg !122

98:                                               ; preds = %67
  %99 = add i64 %62, 1, !dbg !122
  br label %61, !dbg !122

100:                                              ; preds = %61
  %101 = add i64 %59, 1, !dbg !122
  br label %58, !dbg !122

102:                                              ; preds = %58
  %103 = getelementptr float, ptr %4, i64 0, !dbg !128
  %104 = load <4 x float>, ptr %103, align 4, !dbg !128
  %105 = extractelement <1 x float> %42, i64 0, !dbg !131
  %106 = insertelement <4 x float> poison, float %105, i32 0, !dbg !131
  %107 = shufflevector <4 x float> %106, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !131
  %108 = fadd contract <4 x float> %104, %107, !dbg !131
  %109 = fcmp ugt <4 x float> %108, zeroinitializer, !dbg !132
  %110 = select <4 x i1> %109, <4 x float> %108, <4 x float> zeroinitializer, !dbg !133
  %111 = add i64 %34, %44, !dbg !122
  %112 = mul i64 %40, 1024, !dbg !122
  %113 = mul i64 %111, 32, !dbg !122
  %114 = add i64 %112, %113, !dbg !122
  %115 = add i64 %114, %47, !dbg !122
  %116 = getelementptr float, ptr %18, i64 %115, !dbg !122
  store <4 x float> %110, ptr %116, align 4, !dbg !122
  %117 = add i64 %47, 4, !dbg !122
  br label %46, !dbg !122

118:                                              ; preds = %46
  %119 = add i64 %44, 1, !dbg !122
  br label %43, !dbg !122

120:                                              ; preds = %43
  %121 = add i64 %37, 1, !dbg !122
  br label %36, !dbg !122

122:                                              ; preds = %36
  ret i32 0, !dbg !134
}

define internal i32 @infer_dispatch_2_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !135 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !136
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !136
  %6 = load ptr, ptr %5, align 8, !dbg !136
  %7 = getelementptr float, ptr %6, i64 3472, !dbg !137
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !137
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !138
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !138
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !138
  %11 = load ptr, ptr %10, align 8, !dbg !138
  %12 = getelementptr float, ptr %11, i64 19856, !dbg !139
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !139
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !140
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !140
  %15 = zext i32 %14 to i64, !dbg !140
  %16 = sdiv i64 %15, 2, !dbg !140
  %17 = mul i64 %16, 2, !dbg !140
  %18 = icmp ne i64 %15, %17, !dbg !140
  %19 = icmp slt i64 %15, 0, !dbg !140
  %20 = and i1 %18, %19, !dbg !140
  %21 = add i64 %16, -1, !dbg !140
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !140
  %23 = srem i64 %15, 2, !dbg !140
  %24 = icmp slt i64 %23, 0, !dbg !140
  %25 = add nsw i64 %23, 2, !dbg !140
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !140
  %27 = mul nsw i64 %22, 8, !dbg !140
  %28 = mul nsw i64 %26, 16, !dbg !140
  br label %29, !dbg !140

29:                                               ; preds = %57, %3
  %30 = phi i64 [ %58, %57 ], [ 0, %3 ], !dbg !140
  %31 = icmp slt i64 %30, 8, !dbg !140
  br i1 %31, label %32, label %59, !dbg !140

32:                                               ; preds = %55, %29
  %33 = phi i64 [ %56, %55 ], [ 0, %29 ], !dbg !140
  %34 = icmp slt i64 %33, 16, !dbg !140
  br i1 %34, label %35, label %57, !dbg !140

35:                                               ; preds = %38, %32
  %36 = phi i64 [ %54, %38 ], [ 0, %32 ], !dbg !140
  %37 = icmp slt i64 %36, 32, !dbg !140
  br i1 %37, label %38, label %55, !dbg !140

38:                                               ; preds = %35
  %39 = add i64 %27, %30, !dbg !140
  %40 = add i64 %28, %33, !dbg !140
  %41 = mul i64 %39, 1024, !dbg !140
  %42 = mul i64 %40, 32, !dbg !140
  %43 = add i64 %41, %42, !dbg !140
  %44 = add i64 %43, %36, !dbg !140
  %45 = getelementptr float, ptr %7, i64 %44, !dbg !140
  %46 = load <4 x float>, ptr %45, align 4, !dbg !140
  %47 = add i64 %40, 1, !dbg !140
  %48 = add i64 %36, 1, !dbg !140
  %49 = mul i64 %39, 1156, !dbg !140
  %50 = mul i64 %47, 34, !dbg !140
  %51 = add i64 %49, %50, !dbg !140
  %52 = add i64 %51, %48, !dbg !140
  %53 = getelementptr float, ptr %12, i64 %52, !dbg !140
  store <4 x float> %46, ptr %53, align 4, !dbg !140
  %54 = add i64 %36, 4, !dbg !140
  br label %35, !dbg !140

55:                                               ; preds = %35
  %56 = add i64 %33, 1, !dbg !140
  br label %32, !dbg !140

57:                                               ; preds = %32
  %58 = add i64 %30, 1, !dbg !140
  br label %29, !dbg !140

59:                                               ; preds = %29
  ret i32 0, !dbg !141
}

define internal i32 @infer_dispatch_3_conv_16x32x32x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !142 {
  %4 = alloca float, i64 4, align 64, !dbg !143
  %5 = alloca float, i64 4, align 64, !dbg !144
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !145
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !145
  %8 = load ptr, ptr %7, align 8, !dbg !145
  %9 = getelementptr float, ptr %8, i64 19856, !dbg !145
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !145
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !146
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !146
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !146
  %13 = load ptr, ptr %12, align 8, !dbg !146
  %14 = getelementptr float, ptr %13, i64 4864, !dbg !146
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !146
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !147
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !147
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !147
  %18 = load ptr, ptr %17, align 8, !dbg !147
  %19 = getelementptr float, ptr %18, i64 38352, !dbg !147
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !147
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !143
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !143
  %22 = zext i32 %21 to i64, !dbg !143
  %23 = sdiv i64 %22, 2, !dbg !143
  %24 = mul i64 %23, 2, !dbg !143
  %25 = icmp ne i64 %22, %24, !dbg !143
  %26 = icmp slt i64 %22, 0, !dbg !143
  %27 = and i1 %25, %26, !dbg !143
  %28 = add i64 %23, -1, !dbg !143
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !143
  %30 = srem i64 %22, 2, !dbg !143
  %31 = icmp slt i64 %30, 0, !dbg !143
  %32 = add nsw i64 %30, 2, !dbg !143
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !143
  %34 = mul nsw i64 %29, 2, !dbg !143
  %35 = mul nsw i64 %33, 16, !dbg !143
  %36 = getelementptr float, ptr %5, i64 0, !dbg !148
  store <4 x float> zeroinitializer, ptr %36, align 4, !dbg !148
  br label %37, !dbg !143

37:                                               ; preds = %123, %3
  %38 = phi i64 [ %124, %123 ], [ 0, %3 ], !dbg !143
  %39 = icmp slt i64 %38, 2, !dbg !143
  br i1 %39, label %40, label %125, !dbg !143

40:                                               ; preds = %37
  %41 = add i64 %38, %34, !dbg !143
  %42 = getelementptr float, ptr @__constant_16xf32_0, i64 %41, !dbg !149
  %43 = load <1 x float>, ptr %42, align 4, !dbg !149
  br label %44, !dbg !143

44:                                               ; preds = %121, %40
  %45 = phi i64 [ %122, %121 ], [ 0, %40 ], !dbg !143
  %46 = icmp slt i64 %45, 16, !dbg !143
  br i1 %46, label %47, label %123, !dbg !143

47:                                               ; preds = %103, %44
  %48 = phi i64 [ %120, %103 ], [ 0, %44 ], !dbg !143
  %49 = icmp slt i64 %48, 32, !dbg !143
  br i1 %49, label %50, label %121, !dbg !143

50:                                               ; preds = %53, %47
  %51 = phi i64 [ %58, %53 ], [ 0, %47 ], !dbg !143
  %52 = icmp slt i64 %51, 4, !dbg !143
  br i1 %52, label %53, label %59, !dbg !143

53:                                               ; preds = %50
  %54 = add nuw nsw i64 0, %51, !dbg !143
  %55 = getelementptr inbounds nuw float, ptr %5, i64 %54, !dbg !143
  %56 = load float, ptr %55, align 4, !dbg !143
  %57 = getelementptr inbounds nuw float, ptr %4, i64 %54, !dbg !143
  store float %56, ptr %57, align 4, !dbg !143
  %58 = add i64 %51, 1, !dbg !143
  br label %50, !dbg !143

59:                                               ; preds = %101, %50
  %60 = phi i64 [ %102, %101 ], [ 0, %50 ], !dbg !143
  %61 = icmp slt i64 %60, 16, !dbg !143
  br i1 %61, label %62, label %103, !dbg !143

62:                                               ; preds = %99, %59
  %63 = phi i64 [ %100, %99 ], [ 0, %59 ], !dbg !143
  %64 = icmp slt i64 %63, 3, !dbg !143
  br i1 %64, label %65, label %101, !dbg !143

65:                                               ; preds = %62
  %66 = add i64 %63, %45, !dbg !143
  %67 = add i64 %66, %35, !dbg !143
  br label %68, !dbg !143

68:                                               ; preds = %97, %65
  %69 = phi i64 [ %98, %97 ], [ 0, %65 ], !dbg !143
  %70 = icmp slt i64 %69, 4, !dbg !143
  br i1 %70, label %71, label %99, !dbg !143

71:                                               ; preds = %74, %68
  %72 = phi i64 [ %96, %74 ], [ 0, %68 ], !dbg !143
  %73 = icmp slt i64 %72, 3, !dbg !143
  br i1 %73, label %74, label %97, !dbg !143

74:                                               ; preds = %71
  %75 = add i64 %48, %69, !dbg !143
  %76 = add i64 %75, %72, !dbg !143
  %77 = mul nuw nsw i64 %60, 1156, !dbg !143
  %78 = mul nuw nsw i64 %67, 34, !dbg !143
  %79 = add nuw nsw i64 %77, %78, !dbg !143
  %80 = add nuw nsw i64 %79, %76, !dbg !143
  %81 = getelementptr inbounds nuw float, ptr %9, i64 %80, !dbg !143
  %82 = load float, ptr %81, align 4, !dbg !143
  %83 = mul nuw nsw i64 %41, 144, !dbg !143
  %84 = mul nuw nsw i64 %60, 9, !dbg !143
  %85 = add nuw nsw i64 %83, %84, !dbg !143
  %86 = mul nuw nsw i64 %63, 3, !dbg !143
  %87 = add nuw nsw i64 %85, %86, !dbg !143
  %88 = add nuw nsw i64 %87, %72, !dbg !143
  %89 = getelementptr inbounds nuw float, ptr %14, i64 %88, !dbg !143
  %90 = load float, ptr %89, align 4, !dbg !143
  %91 = add nuw nsw i64 0, %69, !dbg !143
  %92 = getelementptr inbounds nuw float, ptr %4, i64 %91, !dbg !143
  %93 = load float, ptr %92, align 4, !dbg !143
  %94 = fmul contract float %82, %90, !dbg !150
  %95 = fadd contract float %93, %94, !dbg !151
  store float %95, ptr %92, align 4, !dbg !143
  %96 = add i64 %72, 1, !dbg !143
  br label %71, !dbg !143

97:                                               ; preds = %71
  %98 = add i64 %69, 1, !dbg !143
  br label %68, !dbg !143

99:                                               ; preds = %68
  %100 = add i64 %63, 1, !dbg !143
  br label %62, !dbg !143

101:                                              ; preds = %62
  %102 = add i64 %60, 1, !dbg !143
  br label %59, !dbg !143

103:                                              ; preds = %59
  %104 = getelementptr float, ptr %4, i64 0, !dbg !149
  %105 = load <4 x float>, ptr %104, align 4, !dbg !149
  %106 = extractelement <1 x float> %43, i64 0, !dbg !152
  %107 = insertelement <4 x float> poison, float %106, i32 0, !dbg !152
  %108 = shufflevector <4 x float> %107, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !152
  %109 = fadd contract <4 x float> %105, %108, !dbg !152
  %110 = fcmp ugt <4 x float> %109, zeroinitializer, !dbg !153
  %111 = select <4 x i1> %110, <4 x float> %109, <4 x float> zeroinitializer, !dbg !154
  %112 = add i64 %35, %45, !dbg !143
  %113 = add i64 %112, 1, !dbg !143
  %114 = add i64 %48, 1, !dbg !143
  %115 = mul i64 %41, 1156, !dbg !143
  %116 = mul i64 %113, 34, !dbg !143
  %117 = add i64 %115, %116, !dbg !143
  %118 = add i64 %117, %114, !dbg !143
  %119 = getelementptr float, ptr %19, i64 %118, !dbg !143
  store <4 x float> %111, ptr %119, align 4, !dbg !143
  %120 = add i64 %48, 4, !dbg !143
  br label %47, !dbg !143

121:                                              ; preds = %47
  %122 = add i64 %45, 1, !dbg !143
  br label %44, !dbg !143

123:                                              ; preds = %44
  %124 = add i64 %38, 1, !dbg !143
  br label %37, !dbg !143

125:                                              ; preds = %37
  ret i32 0, !dbg !155
}

define internal i32 @infer_dispatch_4_conv_16x32x32x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !156 {
  %4 = alloca float, i64 4, align 64, !dbg !157
  %5 = alloca float, i64 4, align 64, !dbg !158
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !159
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !159
  %8 = load ptr, ptr %7, align 8, !dbg !159
  %9 = getelementptr float, ptr %8, i64 38352, !dbg !159
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !159
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !160
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !160
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !160
  %13 = load ptr, ptr %12, align 8, !dbg !160
  %14 = getelementptr float, ptr %13, i64 2560, !dbg !160
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !160
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !161
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !161
  %17 = load ptr, ptr %16, align 8, !dbg !161
  %18 = getelementptr float, ptr %17, i64 3472, !dbg !161
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !161
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !162
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !162
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !162
  %22 = load ptr, ptr %21, align 8, !dbg !162
  %23 = getelementptr float, ptr %22, i64 19856, !dbg !162
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !162
  %24 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !157
  %25 = extractvalue %iree_hal_executable_workgroup_state_v0_t %24, 0, !dbg !157
  %26 = zext i32 %25 to i64, !dbg !157
  %27 = sdiv i64 %26, 2, !dbg !157
  %28 = mul i64 %27, 2, !dbg !157
  %29 = icmp ne i64 %26, %28, !dbg !157
  %30 = icmp slt i64 %26, 0, !dbg !157
  %31 = and i1 %29, %30, !dbg !157
  %32 = add i64 %27, -1, !dbg !157
  %33 = select i1 %31, i64 %32, i64 %27, !dbg !157
  %34 = srem i64 %26, 2, !dbg !157
  %35 = icmp slt i64 %34, 0, !dbg !157
  %36 = add nsw i64 %34, 2, !dbg !157
  %37 = select i1 %35, i64 %36, i64 %34, !dbg !157
  %38 = mul nsw i64 %33, 2, !dbg !157
  %39 = mul nsw i64 %37, 16, !dbg !157
  %40 = getelementptr float, ptr %5, i64 0, !dbg !163
  store <4 x float> zeroinitializer, ptr %40, align 4, !dbg !163
  br label %41, !dbg !157

41:                                               ; preds = %128, %3
  %42 = phi i64 [ %129, %128 ], [ 0, %3 ], !dbg !157
  %43 = icmp slt i64 %42, 2, !dbg !157
  br i1 %43, label %44, label %130, !dbg !157

44:                                               ; preds = %41
  %45 = add i64 %42, %38, !dbg !157
  %46 = getelementptr float, ptr @__constant_16xf32_1, i64 %45, !dbg !164
  %47 = load <1 x float>, ptr %46, align 4, !dbg !164
  br label %48, !dbg !157

48:                                               ; preds = %126, %44
  %49 = phi i64 [ %127, %126 ], [ 0, %44 ], !dbg !157
  %50 = icmp slt i64 %49, 16, !dbg !157
  br i1 %50, label %51, label %128, !dbg !157

51:                                               ; preds = %107, %48
  %52 = phi i64 [ %125, %107 ], [ 0, %48 ], !dbg !157
  %53 = icmp slt i64 %52, 32, !dbg !157
  br i1 %53, label %54, label %126, !dbg !157

54:                                               ; preds = %57, %51
  %55 = phi i64 [ %62, %57 ], [ 0, %51 ], !dbg !157
  %56 = icmp slt i64 %55, 4, !dbg !157
  br i1 %56, label %57, label %63, !dbg !157

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !157
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !157
  %60 = load float, ptr %59, align 4, !dbg !157
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !157
  store float %60, ptr %61, align 4, !dbg !157
  %62 = add i64 %55, 1, !dbg !157
  br label %54, !dbg !157

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !157
  %65 = icmp slt i64 %64, 16, !dbg !157
  br i1 %65, label %66, label %107, !dbg !157

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !157
  %68 = icmp slt i64 %67, 3, !dbg !157
  br i1 %68, label %69, label %105, !dbg !157

69:                                               ; preds = %66
  %70 = add i64 %67, %49, !dbg !157
  %71 = add i64 %70, %39, !dbg !157
  br label %72, !dbg !157

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !157
  %74 = icmp slt i64 %73, 4, !dbg !157
  br i1 %74, label %75, label %103, !dbg !157

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !157
  %77 = icmp slt i64 %76, 3, !dbg !157
  br i1 %77, label %78, label %101, !dbg !157

78:                                               ; preds = %75
  %79 = add i64 %52, %73, !dbg !157
  %80 = add i64 %79, %76, !dbg !157
  %81 = mul nuw nsw i64 %64, 1156, !dbg !157
  %82 = mul nuw nsw i64 %71, 34, !dbg !157
  %83 = add nuw nsw i64 %81, %82, !dbg !157
  %84 = add nuw nsw i64 %83, %80, !dbg !157
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !157
  %86 = load float, ptr %85, align 4, !dbg !157
  %87 = mul nuw nsw i64 %45, 144, !dbg !157
  %88 = mul nuw nsw i64 %64, 9, !dbg !157
  %89 = add nuw nsw i64 %87, %88, !dbg !157
  %90 = mul nuw nsw i64 %67, 3, !dbg !157
  %91 = add nuw nsw i64 %89, %90, !dbg !157
  %92 = add nuw nsw i64 %91, %76, !dbg !157
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !157
  %94 = load float, ptr %93, align 4, !dbg !157
  %95 = add nuw nsw i64 0, %73, !dbg !157
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !157
  %97 = load float, ptr %96, align 4, !dbg !157
  %98 = fmul contract float %86, %94, !dbg !165
  %99 = fadd contract float %97, %98, !dbg !166
  store float %99, ptr %96, align 4, !dbg !157
  %100 = add i64 %76, 1, !dbg !157
  br label %75, !dbg !157

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !157
  br label %72, !dbg !157

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !157
  br label %66, !dbg !157

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !157
  br label %63, !dbg !157

107:                                              ; preds = %63
  %108 = add i64 %49, %39, !dbg !164
  %109 = mul i64 %45, 1024, !dbg !164
  %110 = mul i64 %108, 32, !dbg !164
  %111 = add i64 %109, %110, !dbg !164
  %112 = add i64 %111, %52, !dbg !164
  %113 = getelementptr float, ptr %18, i64 %112, !dbg !164
  %114 = load <4 x float>, ptr %113, align 4, !dbg !164
  %115 = getelementptr float, ptr %4, i64 0, !dbg !164
  %116 = load <4 x float>, ptr %115, align 4, !dbg !164
  %117 = extractelement <1 x float> %47, i64 0, !dbg !167
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !167
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !167
  %120 = fadd contract <4 x float> %116, %119, !dbg !167
  %121 = fadd contract <4 x float> %114, %120, !dbg !168
  %122 = fcmp ugt <4 x float> %121, zeroinitializer, !dbg !169
  %123 = select <4 x i1> %122, <4 x float> %121, <4 x float> zeroinitializer, !dbg !170
  %124 = getelementptr float, ptr %23, i64 %112, !dbg !157
  store <4 x float> %123, ptr %124, align 4, !dbg !157
  %125 = add i64 %52, 4, !dbg !157
  br label %51, !dbg !157

126:                                              ; preds = %51
  %127 = add i64 %49, 1, !dbg !157
  br label %48, !dbg !157

128:                                              ; preds = %48
  %129 = add i64 %42, 1, !dbg !157
  br label %41, !dbg !157

130:                                              ; preds = %41
  ret i32 0, !dbg !171
}

define internal i32 @infer_dispatch_5_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !172 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !173
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !173
  %6 = load ptr, ptr %5, align 8, !dbg !173
  %7 = getelementptr float, ptr %6, i64 19856, !dbg !174
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !174
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !175
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !175
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !175
  %11 = load ptr, ptr %10, align 8, !dbg !175
  %12 = getelementptr float, ptr %11, i64 56848, !dbg !176
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !176
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !177
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !177
  %15 = zext i32 %14 to i64, !dbg !177
  %16 = sdiv i64 %15, 2, !dbg !177
  %17 = mul i64 %16, 2, !dbg !177
  %18 = icmp ne i64 %15, %17, !dbg !177
  %19 = icmp slt i64 %15, 0, !dbg !177
  %20 = and i1 %18, %19, !dbg !177
  %21 = add i64 %16, -1, !dbg !177
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !177
  %23 = srem i64 %15, 2, !dbg !177
  %24 = icmp slt i64 %23, 0, !dbg !177
  %25 = add nsw i64 %23, 2, !dbg !177
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !177
  %27 = mul nsw i64 %22, 8, !dbg !177
  %28 = mul nsw i64 %26, 16, !dbg !177
  br label %29, !dbg !177

29:                                               ; preds = %55, %3
  %30 = phi i64 [ %56, %55 ], [ 0, %3 ], !dbg !177
  %31 = icmp slt i64 %30, 8, !dbg !177
  br i1 %31, label %32, label %57, !dbg !177

32:                                               ; preds = %53, %29
  %33 = phi i64 [ %54, %53 ], [ 0, %29 ], !dbg !177
  %34 = icmp slt i64 %33, 16, !dbg !177
  br i1 %34, label %35, label %55, !dbg !177

35:                                               ; preds = %38, %32
  %36 = phi i64 [ %52, %38 ], [ 0, %32 ], !dbg !177
  %37 = icmp slt i64 %36, 32, !dbg !177
  br i1 %37, label %38, label %53, !dbg !177

38:                                               ; preds = %35
  %39 = add i64 %27, %30, !dbg !177
  %40 = add i64 %28, %33, !dbg !177
  %41 = mul i64 %39, 1024, !dbg !177
  %42 = mul i64 %40, 32, !dbg !177
  %43 = add i64 %41, %42, !dbg !177
  %44 = add i64 %43, %36, !dbg !177
  %45 = getelementptr float, ptr %7, i64 %44, !dbg !177
  %46 = load <4 x float>, ptr %45, align 4, !dbg !177
  %47 = mul i64 %39, 1089, !dbg !177
  %48 = mul i64 %40, 33, !dbg !177
  %49 = add i64 %47, %48, !dbg !177
  %50 = add i64 %49, %36, !dbg !177
  %51 = getelementptr float, ptr %12, i64 %50, !dbg !177
  store <4 x float> %46, ptr %51, align 4, !dbg !177
  %52 = add i64 %36, 4, !dbg !177
  br label %35, !dbg !177

53:                                               ; preds = %35
  %54 = add i64 %33, 1, !dbg !177
  br label %32, !dbg !177

55:                                               ; preds = %32
  %56 = add i64 %30, 1, !dbg !177
  br label %29, !dbg !177

57:                                               ; preds = %29
  ret i32 0, !dbg !178
}

define internal i32 @infer_dispatch_6_conv_32x16x16x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !179 {
  %4 = alloca float, i64 4, align 64, !dbg !180
  %5 = alloca float, i64 4, align 64, !dbg !181
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !182
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !182
  %8 = load ptr, ptr %7, align 8, !dbg !182
  %9 = getelementptr float, ptr %8, i64 56848, !dbg !182
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !182
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !183
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !183
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !183
  %13 = load ptr, ptr %12, align 8, !dbg !183
  %14 = getelementptr float, ptr %13, i64 72112, !dbg !183
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !183
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !184
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !184
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !184
  %18 = load ptr, ptr %17, align 8, !dbg !184
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !184
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !180
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !180
  %21 = zext i32 %20 to i64, !dbg !180
  %22 = sdiv i64 %21, 2, !dbg !180
  %23 = mul i64 %22, 2, !dbg !180
  %24 = icmp ne i64 %21, %23, !dbg !180
  %25 = icmp slt i64 %21, 0, !dbg !180
  %26 = and i1 %24, %25, !dbg !180
  %27 = add i64 %22, -1, !dbg !180
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !180
  %29 = srem i64 %21, 2, !dbg !180
  %30 = icmp slt i64 %29, 0, !dbg !180
  %31 = add nsw i64 %29, 2, !dbg !180
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !180
  %33 = mul nsw i64 %28, 4, !dbg !180
  %34 = mul nsw i64 %32, 8, !dbg !180
  %35 = getelementptr float, ptr %5, i64 0, !dbg !185
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !185
  br label %36, !dbg !180

36:                                               ; preds = %127, %3
  %37 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !180
  %38 = icmp slt i64 %37, 4, !dbg !180
  br i1 %38, label %39, label %129, !dbg !180

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !180
  %41 = getelementptr float, ptr @__constant_32xf32, i64 %40, !dbg !186
  %42 = load <1 x float>, ptr %41, align 4, !dbg !186
  br label %43, !dbg !180

43:                                               ; preds = %125, %39
  %44 = phi i64 [ %126, %125 ], [ 0, %39 ], !dbg !180
  %45 = icmp slt i64 %44, 8, !dbg !180
  br i1 %45, label %46, label %127, !dbg !180

46:                                               ; preds = %107, %43
  %47 = phi i64 [ %124, %107 ], [ 0, %43 ], !dbg !180
  %48 = icmp slt i64 %47, 16, !dbg !180
  br i1 %48, label %49, label %125, !dbg !180

49:                                               ; preds = %46
  %50 = mul nsw i64 %47, 2, !dbg !180
  br label %51, !dbg !180

51:                                               ; preds = %54, %49
  %52 = phi i64 [ %59, %54 ], [ 0, %49 ], !dbg !180
  %53 = icmp slt i64 %52, 4, !dbg !180
  br i1 %53, label %54, label %60, !dbg !180

54:                                               ; preds = %51
  %55 = add nuw nsw i64 0, %52, !dbg !180
  %56 = getelementptr inbounds nuw float, ptr %5, i64 %55, !dbg !180
  %57 = load float, ptr %56, align 4, !dbg !180
  %58 = getelementptr inbounds nuw float, ptr %4, i64 %55, !dbg !180
  store float %57, ptr %58, align 4, !dbg !180
  %59 = add i64 %52, 1, !dbg !180
  br label %51, !dbg !180

60:                                               ; preds = %105, %51
  %61 = phi i64 [ %106, %105 ], [ 0, %51 ], !dbg !180
  %62 = icmp slt i64 %61, 16, !dbg !180
  br i1 %62, label %63, label %107, !dbg !180

63:                                               ; preds = %103, %60
  %64 = phi i64 [ %104, %103 ], [ 0, %60 ], !dbg !180
  %65 = icmp slt i64 %64, 3, !dbg !180
  br i1 %65, label %66, label %105, !dbg !180

66:                                               ; preds = %63
  %67 = mul nsw i64 %44, 2, !dbg !180
  %68 = mul nsw i64 %32, 16, !dbg !180
  %69 = add i64 %67, %68, !dbg !180
  %70 = add i64 %69, %64, !dbg !180
  br label %71, !dbg !180

71:                                               ; preds = %101, %66
  %72 = phi i64 [ %102, %101 ], [ 0, %66 ], !dbg !180
  %73 = icmp slt i64 %72, 4, !dbg !180
  br i1 %73, label %74, label %103, !dbg !180

74:                                               ; preds = %77, %71
  %75 = phi i64 [ %100, %77 ], [ 0, %71 ], !dbg !180
  %76 = icmp slt i64 %75, 3, !dbg !180
  br i1 %76, label %77, label %101, !dbg !180

77:                                               ; preds = %74
  %78 = mul nsw i64 %72, 2, !dbg !180
  %79 = add i64 %50, %78, !dbg !180
  %80 = add i64 %79, %75, !dbg !180
  %81 = mul nuw nsw i64 %61, 1089, !dbg !180
  %82 = mul nuw nsw i64 %70, 33, !dbg !180
  %83 = add nuw nsw i64 %81, %82, !dbg !180
  %84 = add nuw nsw i64 %83, %80, !dbg !180
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !180
  %86 = load float, ptr %85, align 4, !dbg !180
  %87 = mul nuw nsw i64 %40, 144, !dbg !180
  %88 = mul nuw nsw i64 %61, 9, !dbg !180
  %89 = add nuw nsw i64 %87, %88, !dbg !180
  %90 = mul nuw nsw i64 %64, 3, !dbg !180
  %91 = add nuw nsw i64 %89, %90, !dbg !180
  %92 = add nuw nsw i64 %91, %75, !dbg !180
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !180
  %94 = load float, ptr %93, align 4, !dbg !180
  %95 = add nuw nsw i64 0, %72, !dbg !180
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !180
  %97 = load float, ptr %96, align 4, !dbg !180
  %98 = fmul contract float %86, %94, !dbg !187
  %99 = fadd contract float %97, %98, !dbg !188
  store float %99, ptr %96, align 4, !dbg !180
  %100 = add i64 %75, 1, !dbg !180
  br label %74, !dbg !180

101:                                              ; preds = %74
  %102 = add i64 %72, 1, !dbg !180
  br label %71, !dbg !180

103:                                              ; preds = %71
  %104 = add i64 %64, 1, !dbg !180
  br label %63, !dbg !180

105:                                              ; preds = %63
  %106 = add i64 %61, 1, !dbg !180
  br label %60, !dbg !180

107:                                              ; preds = %60
  %108 = getelementptr float, ptr %4, i64 0, !dbg !186
  %109 = load <4 x float>, ptr %108, align 4, !dbg !186
  %110 = extractelement <1 x float> %42, i64 0, !dbg !189
  %111 = insertelement <4 x float> poison, float %110, i32 0, !dbg !189
  %112 = shufflevector <4 x float> %111, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !189
  %113 = fadd contract <4 x float> %109, %112, !dbg !189
  %114 = fcmp ugt <4 x float> %113, zeroinitializer, !dbg !190
  %115 = select <4 x i1> %114, <4 x float> %113, <4 x float> zeroinitializer, !dbg !191
  %116 = add i64 %34, %44, !dbg !180
  %117 = add i64 %116, 1, !dbg !180
  %118 = add i64 %47, 1, !dbg !180
  %119 = mul i64 %40, 324, !dbg !180
  %120 = mul i64 %117, 18, !dbg !180
  %121 = add i64 %119, %120, !dbg !180
  %122 = add i64 %121, %118, !dbg !180
  %123 = getelementptr float, ptr %18, i64 %122, !dbg !180
  store <4 x float> %115, ptr %123, align 4, !dbg !180
  %124 = add i64 %47, 4, !dbg !180
  br label %46, !dbg !180

125:                                              ; preds = %46
  %126 = add i64 %44, 1, !dbg !180
  br label %43, !dbg !180

127:                                              ; preds = %43
  %128 = add i64 %37, 1, !dbg !180
  br label %36, !dbg !180

129:                                              ; preds = %36
  ret i32 0, !dbg !192
}

define internal i32 @infer_dispatch_7_matmul_like_32x16x16x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !193 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !194
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !194
  %6 = load ptr, ptr %5, align 8, !dbg !194
  %7 = getelementptr float, ptr %6, i64 19856, !dbg !194
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !194
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !195
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !195
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !195
  %11 = load ptr, ptr %10, align 8, !dbg !195
  %12 = getelementptr float, ptr %11, i64 2048, !dbg !195
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !195
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !196
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !196
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !196
  %16 = load ptr, ptr %15, align 8, !dbg !196
  %17 = getelementptr float, ptr %16, i64 10368, !dbg !196
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !196
  %18 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !197
  %19 = extractvalue %iree_hal_executable_workgroup_state_v0_t %18, 0, !dbg !197
  %20 = zext i32 %19 to i64, !dbg !197
  %21 = sdiv i64 %20, 2, !dbg !197
  %22 = mul i64 %21, 2, !dbg !197
  %23 = icmp ne i64 %20, %22, !dbg !197
  %24 = icmp slt i64 %20, 0, !dbg !197
  %25 = and i1 %23, %24, !dbg !197
  %26 = add i64 %21, -1, !dbg !197
  %27 = select i1 %25, i64 %26, i64 %21, !dbg !197
  %28 = srem i64 %20, 2, !dbg !197
  %29 = icmp slt i64 %28, 0, !dbg !197
  %30 = add nsw i64 %28, 2, !dbg !197
  %31 = select i1 %29, i64 %30, i64 %28, !dbg !197
  %32 = mul nsw i64 %27, 4, !dbg !197
  %33 = mul nsw i64 %31, 8, !dbg !197
  br label %34, !dbg !197

34:                                               ; preds = %209, %3
  %35 = phi i64 [ %258, %209 ], [ 0, %3 ], !dbg !197
  %36 = icmp slt i64 %35, 4, !dbg !197
  br i1 %36, label %37, label %259, !dbg !197

37:                                               ; preds = %34
  %38 = add i64 %35, %32, !dbg !197
  br label %39, !dbg !197

39:                                               ; preds = %177, %37
  %40 = phi i64 [ %208, %177 ], [ 0, %37 ], !dbg !197
  %41 = phi [8 x <16 x float>] [ %207, %177 ], [ zeroinitializer, %37 ], !dbg !197
  %42 = icmp slt i64 %40, 16, !dbg !197
  br i1 %42, label %43, label %209, !dbg !197

43:                                               ; preds = %47, %39
  %44 = phi i64 [ %57, %47 ], [ 0, %39 ], !dbg !197
  %45 = phi <16 x float> [ %56, %47 ], [ poison, %39 ], !dbg !197
  %46 = icmp slt i64 %44, 16, !dbg !197
  br i1 %46, label %47, label %58, !dbg !197

47:                                               ; preds = %43
  %48 = mul nsw i64 %33, 2, !dbg !197
  %49 = mul nsw i64 %44, 2, !dbg !197
  %50 = mul nuw nsw i64 %40, 1024, !dbg !197
  %51 = mul nuw nsw i64 %48, 32, !dbg !197
  %52 = add nuw nsw i64 %50, %51, !dbg !197
  %53 = add nuw nsw i64 %52, %49, !dbg !197
  %54 = getelementptr inbounds nuw float, ptr %7, i64 %53, !dbg !197
  %55 = load float, ptr %54, align 4, !dbg !197
  %56 = insertelement <16 x float> %45, float %55, i64 %44, !dbg !197
  %57 = add i64 %44, 1, !dbg !197
  br label %43, !dbg !197

58:                                               ; preds = %43
  %59 = add i64 %33, 1, !dbg !197
  br label %60, !dbg !197

60:                                               ; preds = %64, %58
  %61 = phi i64 [ %74, %64 ], [ 0, %58 ], !dbg !197
  %62 = phi <16 x float> [ %73, %64 ], [ poison, %58 ], !dbg !197
  %63 = icmp slt i64 %61, 16, !dbg !197
  br i1 %63, label %64, label %75, !dbg !197

64:                                               ; preds = %60
  %65 = mul nsw i64 %59, 2, !dbg !197
  %66 = mul nsw i64 %61, 2, !dbg !197
  %67 = mul nuw nsw i64 %40, 1024, !dbg !197
  %68 = mul nuw nsw i64 %65, 32, !dbg !197
  %69 = add nuw nsw i64 %67, %68, !dbg !197
  %70 = add nuw nsw i64 %69, %66, !dbg !197
  %71 = getelementptr inbounds nuw float, ptr %7, i64 %70, !dbg !197
  %72 = load float, ptr %71, align 4, !dbg !197
  %73 = insertelement <16 x float> %62, float %72, i64 %61, !dbg !197
  %74 = add i64 %61, 1, !dbg !197
  br label %60, !dbg !197

75:                                               ; preds = %60
  %76 = add i64 %33, 2, !dbg !197
  br label %77, !dbg !197

77:                                               ; preds = %81, %75
  %78 = phi i64 [ %91, %81 ], [ 0, %75 ], !dbg !197
  %79 = phi <16 x float> [ %90, %81 ], [ poison, %75 ], !dbg !197
  %80 = icmp slt i64 %78, 16, !dbg !197
  br i1 %80, label %81, label %92, !dbg !197

81:                                               ; preds = %77
  %82 = mul nsw i64 %76, 2, !dbg !197
  %83 = mul nsw i64 %78, 2, !dbg !197
  %84 = mul nuw nsw i64 %40, 1024, !dbg !197
  %85 = mul nuw nsw i64 %82, 32, !dbg !197
  %86 = add nuw nsw i64 %84, %85, !dbg !197
  %87 = add nuw nsw i64 %86, %83, !dbg !197
  %88 = getelementptr inbounds nuw float, ptr %7, i64 %87, !dbg !197
  %89 = load float, ptr %88, align 4, !dbg !197
  %90 = insertelement <16 x float> %79, float %89, i64 %78, !dbg !197
  %91 = add i64 %78, 1, !dbg !197
  br label %77, !dbg !197

92:                                               ; preds = %77
  %93 = add i64 %33, 3, !dbg !197
  br label %94, !dbg !197

94:                                               ; preds = %98, %92
  %95 = phi i64 [ %108, %98 ], [ 0, %92 ], !dbg !197
  %96 = phi <16 x float> [ %107, %98 ], [ poison, %92 ], !dbg !197
  %97 = icmp slt i64 %95, 16, !dbg !197
  br i1 %97, label %98, label %109, !dbg !197

98:                                               ; preds = %94
  %99 = mul nsw i64 %93, 2, !dbg !197
  %100 = mul nsw i64 %95, 2, !dbg !197
  %101 = mul nuw nsw i64 %40, 1024, !dbg !197
  %102 = mul nuw nsw i64 %99, 32, !dbg !197
  %103 = add nuw nsw i64 %101, %102, !dbg !197
  %104 = add nuw nsw i64 %103, %100, !dbg !197
  %105 = getelementptr inbounds nuw float, ptr %7, i64 %104, !dbg !197
  %106 = load float, ptr %105, align 4, !dbg !197
  %107 = insertelement <16 x float> %96, float %106, i64 %95, !dbg !197
  %108 = add i64 %95, 1, !dbg !197
  br label %94, !dbg !197

109:                                              ; preds = %94
  %110 = add i64 %33, 4, !dbg !197
  br label %111, !dbg !197

111:                                              ; preds = %115, %109
  %112 = phi i64 [ %125, %115 ], [ 0, %109 ], !dbg !197
  %113 = phi <16 x float> [ %124, %115 ], [ poison, %109 ], !dbg !197
  %114 = icmp slt i64 %112, 16, !dbg !197
  br i1 %114, label %115, label %126, !dbg !197

115:                                              ; preds = %111
  %116 = mul nsw i64 %110, 2, !dbg !197
  %117 = mul nsw i64 %112, 2, !dbg !197
  %118 = mul nuw nsw i64 %40, 1024, !dbg !197
  %119 = mul nuw nsw i64 %116, 32, !dbg !197
  %120 = add nuw nsw i64 %118, %119, !dbg !197
  %121 = add nuw nsw i64 %120, %117, !dbg !197
  %122 = getelementptr inbounds nuw float, ptr %7, i64 %121, !dbg !197
  %123 = load float, ptr %122, align 4, !dbg !197
  %124 = insertelement <16 x float> %113, float %123, i64 %112, !dbg !197
  %125 = add i64 %112, 1, !dbg !197
  br label %111, !dbg !197

126:                                              ; preds = %111
  %127 = add i64 %33, 5, !dbg !197
  br label %128, !dbg !197

128:                                              ; preds = %132, %126
  %129 = phi i64 [ %142, %132 ], [ 0, %126 ], !dbg !197
  %130 = phi <16 x float> [ %141, %132 ], [ poison, %126 ], !dbg !197
  %131 = icmp slt i64 %129, 16, !dbg !197
  br i1 %131, label %132, label %143, !dbg !197

132:                                              ; preds = %128
  %133 = mul nsw i64 %127, 2, !dbg !197
  %134 = mul nsw i64 %129, 2, !dbg !197
  %135 = mul nuw nsw i64 %40, 1024, !dbg !197
  %136 = mul nuw nsw i64 %133, 32, !dbg !197
  %137 = add nuw nsw i64 %135, %136, !dbg !197
  %138 = add nuw nsw i64 %137, %134, !dbg !197
  %139 = getelementptr inbounds nuw float, ptr %7, i64 %138, !dbg !197
  %140 = load float, ptr %139, align 4, !dbg !197
  %141 = insertelement <16 x float> %130, float %140, i64 %129, !dbg !197
  %142 = add i64 %129, 1, !dbg !197
  br label %128, !dbg !197

143:                                              ; preds = %128
  %144 = add i64 %33, 6, !dbg !197
  br label %145, !dbg !197

145:                                              ; preds = %149, %143
  %146 = phi i64 [ %159, %149 ], [ 0, %143 ], !dbg !197
  %147 = phi <16 x float> [ %158, %149 ], [ poison, %143 ], !dbg !197
  %148 = icmp slt i64 %146, 16, !dbg !197
  br i1 %148, label %149, label %160, !dbg !197

149:                                              ; preds = %145
  %150 = mul nsw i64 %144, 2, !dbg !197
  %151 = mul nsw i64 %146, 2, !dbg !197
  %152 = mul nuw nsw i64 %40, 1024, !dbg !197
  %153 = mul nuw nsw i64 %150, 32, !dbg !197
  %154 = add nuw nsw i64 %152, %153, !dbg !197
  %155 = add nuw nsw i64 %154, %151, !dbg !197
  %156 = getelementptr inbounds nuw float, ptr %7, i64 %155, !dbg !197
  %157 = load float, ptr %156, align 4, !dbg !197
  %158 = insertelement <16 x float> %147, float %157, i64 %146, !dbg !197
  %159 = add i64 %146, 1, !dbg !197
  br label %145, !dbg !197

160:                                              ; preds = %145
  %161 = add i64 %33, 7, !dbg !197
  br label %162, !dbg !197

162:                                              ; preds = %166, %160
  %163 = phi i64 [ %176, %166 ], [ 0, %160 ], !dbg !197
  %164 = phi <16 x float> [ %175, %166 ], [ poison, %160 ], !dbg !197
  %165 = icmp slt i64 %163, 16, !dbg !197
  br i1 %165, label %166, label %177, !dbg !197

166:                                              ; preds = %162
  %167 = mul nsw i64 %161, 2, !dbg !197
  %168 = mul nsw i64 %163, 2, !dbg !197
  %169 = mul nuw nsw i64 %40, 1024, !dbg !197
  %170 = mul nuw nsw i64 %167, 32, !dbg !197
  %171 = add nuw nsw i64 %169, %170, !dbg !197
  %172 = add nuw nsw i64 %171, %168, !dbg !197
  %173 = getelementptr inbounds nuw float, ptr %7, i64 %172, !dbg !197
  %174 = load float, ptr %173, align 4, !dbg !197
  %175 = insertelement <16 x float> %164, float %174, i64 %163, !dbg !197
  %176 = add i64 %163, 1, !dbg !197
  br label %162, !dbg !197

177:                                              ; preds = %162
  %178 = extractvalue [8 x <16 x float>] %41, 0, !dbg !198
  %179 = mul nuw nsw i64 %38, 16, !dbg !198
  %180 = add nuw nsw i64 %179, %40, !dbg !198
  %181 = getelementptr inbounds nuw float, ptr %12, i64 %180, !dbg !198
  %182 = load float, ptr %181, align 4, !dbg !198
  %183 = insertelement <16 x float> poison, float %182, i32 0, !dbg !198
  %184 = shufflevector <16 x float> %183, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !198
  %185 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %45, <16 x float> %184, <16 x float> %178), !dbg !198
  %186 = extractvalue [8 x <16 x float>] %41, 1, !dbg !198
  %187 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %62, <16 x float> %184, <16 x float> %186), !dbg !198
  %188 = extractvalue [8 x <16 x float>] %41, 2, !dbg !198
  %189 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %79, <16 x float> %184, <16 x float> %188), !dbg !198
  %190 = extractvalue [8 x <16 x float>] %41, 3, !dbg !198
  %191 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %96, <16 x float> %184, <16 x float> %190), !dbg !198
  %192 = extractvalue [8 x <16 x float>] %41, 4, !dbg !198
  %193 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %113, <16 x float> %184, <16 x float> %192), !dbg !198
  %194 = extractvalue [8 x <16 x float>] %41, 5, !dbg !198
  %195 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %130, <16 x float> %184, <16 x float> %194), !dbg !198
  %196 = extractvalue [8 x <16 x float>] %41, 6, !dbg !198
  %197 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %147, <16 x float> %184, <16 x float> %196), !dbg !198
  %198 = extractvalue [8 x <16 x float>] %41, 7, !dbg !198
  %199 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %164, <16 x float> %184, <16 x float> %198), !dbg !198
  %200 = insertvalue [8 x <16 x float>] poison, <16 x float> %185, 0, !dbg !198
  %201 = insertvalue [8 x <16 x float>] %200, <16 x float> %187, 1, !dbg !198
  %202 = insertvalue [8 x <16 x float>] %201, <16 x float> %189, 2, !dbg !198
  %203 = insertvalue [8 x <16 x float>] %202, <16 x float> %191, 3, !dbg !198
  %204 = insertvalue [8 x <16 x float>] %203, <16 x float> %193, 4, !dbg !198
  %205 = insertvalue [8 x <16 x float>] %204, <16 x float> %195, 5, !dbg !198
  %206 = insertvalue [8 x <16 x float>] %205, <16 x float> %197, 6, !dbg !198
  %207 = insertvalue [8 x <16 x float>] %206, <16 x float> %199, 7, !dbg !198
  %208 = add i64 %40, 1, !dbg !197
  br label %39, !dbg !197

209:                                              ; preds = %39
  %210 = extractvalue [8 x <16 x float>] %41, 0, !dbg !197
  %211 = mul i64 %38, 256, !dbg !197
  %212 = mul i64 %33, 16, !dbg !197
  %213 = add i64 %211, %212, !dbg !197
  %214 = add i64 %213, 0, !dbg !197
  %215 = getelementptr float, ptr %17, i64 %214, !dbg !197
  store <16 x float> %210, ptr %215, align 4, !dbg !197
  %216 = extractvalue [8 x <16 x float>] %41, 1, !dbg !197
  %217 = add i64 %33, 1, !dbg !197
  %218 = mul i64 %217, 16, !dbg !197
  %219 = add i64 %211, %218, !dbg !197
  %220 = add i64 %219, 0, !dbg !197
  %221 = getelementptr float, ptr %17, i64 %220, !dbg !197
  store <16 x float> %216, ptr %221, align 4, !dbg !197
  %222 = extractvalue [8 x <16 x float>] %41, 2, !dbg !197
  %223 = add i64 %33, 2, !dbg !197
  %224 = mul i64 %223, 16, !dbg !197
  %225 = add i64 %211, %224, !dbg !197
  %226 = add i64 %225, 0, !dbg !197
  %227 = getelementptr float, ptr %17, i64 %226, !dbg !197
  store <16 x float> %222, ptr %227, align 4, !dbg !197
  %228 = extractvalue [8 x <16 x float>] %41, 3, !dbg !197
  %229 = add i64 %33, 3, !dbg !197
  %230 = mul i64 %229, 16, !dbg !197
  %231 = add i64 %211, %230, !dbg !197
  %232 = add i64 %231, 0, !dbg !197
  %233 = getelementptr float, ptr %17, i64 %232, !dbg !197
  store <16 x float> %228, ptr %233, align 4, !dbg !197
  %234 = extractvalue [8 x <16 x float>] %41, 4, !dbg !197
  %235 = add i64 %33, 4, !dbg !197
  %236 = mul i64 %235, 16, !dbg !197
  %237 = add i64 %211, %236, !dbg !197
  %238 = add i64 %237, 0, !dbg !197
  %239 = getelementptr float, ptr %17, i64 %238, !dbg !197
  store <16 x float> %234, ptr %239, align 4, !dbg !197
  %240 = extractvalue [8 x <16 x float>] %41, 5, !dbg !197
  %241 = add i64 %33, 5, !dbg !197
  %242 = mul i64 %241, 16, !dbg !197
  %243 = add i64 %211, %242, !dbg !197
  %244 = add i64 %243, 0, !dbg !197
  %245 = getelementptr float, ptr %17, i64 %244, !dbg !197
  store <16 x float> %240, ptr %245, align 4, !dbg !197
  %246 = extractvalue [8 x <16 x float>] %41, 6, !dbg !197
  %247 = add i64 %33, 6, !dbg !197
  %248 = mul i64 %247, 16, !dbg !197
  %249 = add i64 %211, %248, !dbg !197
  %250 = add i64 %249, 0, !dbg !197
  %251 = getelementptr float, ptr %17, i64 %250, !dbg !197
  store <16 x float> %246, ptr %251, align 4, !dbg !197
  %252 = extractvalue [8 x <16 x float>] %41, 7, !dbg !197
  %253 = add i64 %33, 7, !dbg !197
  %254 = mul i64 %253, 16, !dbg !197
  %255 = add i64 %211, %254, !dbg !197
  %256 = add i64 %255, 0, !dbg !197
  %257 = getelementptr float, ptr %17, i64 %256, !dbg !197
  store <16 x float> %252, ptr %257, align 4, !dbg !197
  %258 = add i64 %35, 1, !dbg !197
  br label %34, !dbg !197

259:                                              ; preds = %34
  ret i32 0, !dbg !199
}

define internal i32 @infer_dispatch_8_conv_32x16x16x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !200 {
  %4 = alloca float, i64 4, align 64, !dbg !201
  %5 = alloca float, i64 4, align 64, !dbg !202
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !203
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !203
  %8 = load ptr, ptr %7, align 8, !dbg !203
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !203
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !204
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !204
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !204
  %12 = load ptr, ptr %11, align 8, !dbg !204
  %13 = getelementptr float, ptr %12, i64 62464, !dbg !204
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !204
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !205
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !205
  %16 = load ptr, ptr %15, align 8, !dbg !205
  %17 = getelementptr float, ptr %16, i64 10368, !dbg !205
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !205
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !206
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !206
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !206
  %21 = load ptr, ptr %20, align 8, !dbg !206
  %22 = getelementptr float, ptr %21, i64 18560, !dbg !206
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !206
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !201
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !201
  %25 = zext i32 %24 to i64, !dbg !201
  %26 = sdiv i64 %25, 2, !dbg !201
  %27 = mul i64 %26, 2, !dbg !201
  %28 = icmp ne i64 %25, %27, !dbg !201
  %29 = icmp slt i64 %25, 0, !dbg !201
  %30 = and i1 %28, %29, !dbg !201
  %31 = add i64 %26, -1, !dbg !201
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !201
  %33 = srem i64 %25, 2, !dbg !201
  %34 = icmp slt i64 %33, 0, !dbg !201
  %35 = add nsw i64 %33, 2, !dbg !201
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !201
  %37 = mul nsw i64 %32, 4, !dbg !201
  %38 = mul nsw i64 %36, 8, !dbg !201
  %39 = getelementptr float, ptr %5, i64 0, !dbg !207
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !207
  br label %40, !dbg !201

40:                                               ; preds = %133, %3
  %41 = phi i64 [ %134, %133 ], [ 0, %3 ], !dbg !201
  %42 = icmp slt i64 %41, 4, !dbg !201
  br i1 %42, label %43, label %135, !dbg !201

43:                                               ; preds = %40
  %44 = add i64 %41, %37, !dbg !201
  %45 = getelementptr float, ptr @__constant_32xf32_0, i64 %44, !dbg !208
  %46 = load <1 x float>, ptr %45, align 4, !dbg !208
  %47 = getelementptr float, ptr @__constant_32xf32_1, i64 %44, !dbg !208
  %48 = load <1 x float>, ptr %47, align 4, !dbg !208
  br label %49, !dbg !201

49:                                               ; preds = %131, %43
  %50 = phi i64 [ %132, %131 ], [ 0, %43 ], !dbg !201
  %51 = icmp slt i64 %50, 8, !dbg !201
  br i1 %51, label %52, label %133, !dbg !201

52:                                               ; preds = %108, %49
  %53 = phi i64 [ %130, %108 ], [ 0, %49 ], !dbg !201
  %54 = icmp slt i64 %53, 16, !dbg !201
  br i1 %54, label %55, label %131, !dbg !201

55:                                               ; preds = %58, %52
  %56 = phi i64 [ %63, %58 ], [ 0, %52 ], !dbg !201
  %57 = icmp slt i64 %56, 4, !dbg !201
  br i1 %57, label %58, label %64, !dbg !201

58:                                               ; preds = %55
  %59 = add nuw nsw i64 0, %56, !dbg !201
  %60 = getelementptr inbounds nuw float, ptr %5, i64 %59, !dbg !201
  %61 = load float, ptr %60, align 4, !dbg !201
  %62 = getelementptr inbounds nuw float, ptr %4, i64 %59, !dbg !201
  store float %61, ptr %62, align 4, !dbg !201
  %63 = add i64 %56, 1, !dbg !201
  br label %55, !dbg !201

64:                                               ; preds = %106, %55
  %65 = phi i64 [ %107, %106 ], [ 0, %55 ], !dbg !201
  %66 = icmp slt i64 %65, 32, !dbg !201
  br i1 %66, label %67, label %108, !dbg !201

67:                                               ; preds = %104, %64
  %68 = phi i64 [ %105, %104 ], [ 0, %64 ], !dbg !201
  %69 = icmp slt i64 %68, 3, !dbg !201
  br i1 %69, label %70, label %106, !dbg !201

70:                                               ; preds = %67
  %71 = add i64 %68, %50, !dbg !201
  %72 = add i64 %71, %38, !dbg !201
  br label %73, !dbg !201

73:                                               ; preds = %102, %70
  %74 = phi i64 [ %103, %102 ], [ 0, %70 ], !dbg !201
  %75 = icmp slt i64 %74, 4, !dbg !201
  br i1 %75, label %76, label %104, !dbg !201

76:                                               ; preds = %79, %73
  %77 = phi i64 [ %101, %79 ], [ 0, %73 ], !dbg !201
  %78 = icmp slt i64 %77, 3, !dbg !201
  br i1 %78, label %79, label %102, !dbg !201

79:                                               ; preds = %76
  %80 = add i64 %53, %74, !dbg !201
  %81 = add i64 %80, %77, !dbg !201
  %82 = mul nuw nsw i64 %65, 324, !dbg !201
  %83 = mul nuw nsw i64 %72, 18, !dbg !201
  %84 = add nuw nsw i64 %82, %83, !dbg !201
  %85 = add nuw nsw i64 %84, %81, !dbg !201
  %86 = getelementptr inbounds nuw float, ptr %8, i64 %85, !dbg !201
  %87 = load float, ptr %86, align 4, !dbg !201
  %88 = mul nuw nsw i64 %44, 288, !dbg !201
  %89 = mul nuw nsw i64 %65, 9, !dbg !201
  %90 = add nuw nsw i64 %88, %89, !dbg !201
  %91 = mul nuw nsw i64 %68, 3, !dbg !201
  %92 = add nuw nsw i64 %90, %91, !dbg !201
  %93 = add nuw nsw i64 %92, %77, !dbg !201
  %94 = getelementptr inbounds nuw float, ptr %13, i64 %93, !dbg !201
  %95 = load float, ptr %94, align 4, !dbg !201
  %96 = add nuw nsw i64 0, %74, !dbg !201
  %97 = getelementptr inbounds nuw float, ptr %4, i64 %96, !dbg !201
  %98 = load float, ptr %97, align 4, !dbg !201
  %99 = fmul contract float %87, %95, !dbg !209
  %100 = fadd contract float %98, %99, !dbg !210
  store float %100, ptr %97, align 4, !dbg !201
  %101 = add i64 %77, 1, !dbg !201
  br label %76, !dbg !201

102:                                              ; preds = %76
  %103 = add i64 %74, 1, !dbg !201
  br label %73, !dbg !201

104:                                              ; preds = %73
  %105 = add i64 %68, 1, !dbg !201
  br label %67, !dbg !201

106:                                              ; preds = %67
  %107 = add i64 %65, 1, !dbg !201
  br label %64, !dbg !201

108:                                              ; preds = %64
  %109 = add i64 %50, %38, !dbg !208
  %110 = mul i64 %44, 256, !dbg !208
  %111 = mul i64 %109, 16, !dbg !208
  %112 = add i64 %110, %111, !dbg !208
  %113 = add i64 %112, %53, !dbg !208
  %114 = getelementptr float, ptr %17, i64 %113, !dbg !208
  %115 = load <4 x float>, ptr %114, align 4, !dbg !208
  %116 = getelementptr float, ptr %4, i64 0, !dbg !208
  %117 = load <4 x float>, ptr %116, align 4, !dbg !208
  %118 = extractelement <1 x float> %48, i64 0, !dbg !211
  %119 = insertelement <4 x float> poison, float %118, i32 0, !dbg !211
  %120 = shufflevector <4 x float> %119, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !211
  %121 = fadd contract <4 x float> %117, %120, !dbg !211
  %122 = extractelement <1 x float> %46, i64 0, !dbg !212
  %123 = insertelement <4 x float> poison, float %122, i32 0, !dbg !212
  %124 = shufflevector <4 x float> %123, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !212
  %125 = fadd contract <4 x float> %115, %124, !dbg !212
  %126 = fadd contract <4 x float> %125, %121, !dbg !213
  %127 = fcmp ugt <4 x float> %126, zeroinitializer, !dbg !214
  %128 = select <4 x i1> %127, <4 x float> %126, <4 x float> zeroinitializer, !dbg !215
  %129 = getelementptr float, ptr %22, i64 %113, !dbg !201
  store <4 x float> %128, ptr %129, align 4, !dbg !201
  %130 = add i64 %53, 4, !dbg !201
  br label %52, !dbg !201

131:                                              ; preds = %52
  %132 = add i64 %50, 1, !dbg !201
  br label %49, !dbg !201

133:                                              ; preds = %49
  %134 = add i64 %41, 1, !dbg !201
  br label %40, !dbg !201

135:                                              ; preds = %40
  ret i32 0, !dbg !216
}

define internal i32 @infer_dispatch_9_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !217 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !218
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !218
  %6 = load ptr, ptr %5, align 8, !dbg !218
  %7 = getelementptr float, ptr %6, i64 18560, !dbg !219
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !219
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !220
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !220
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !220
  %11 = load ptr, ptr %10, align 8, !dbg !220
  %12 = getelementptr float, ptr %11, i64 26752, !dbg !221
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !221
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !222
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !222
  %15 = zext i32 %14 to i64, !dbg !222
  %16 = mul nsw i64 %15, 8, !dbg !222
  br label %17, !dbg !222

17:                                               ; preds = %42, %3
  %18 = phi i64 [ %43, %42 ], [ 0, %3 ], !dbg !222
  %19 = icmp slt i64 %18, 32, !dbg !222
  br i1 %19, label %20, label %44, !dbg !222

20:                                               ; preds = %40, %17
  %21 = phi i64 [ %41, %40 ], [ 0, %17 ], !dbg !222
  %22 = icmp slt i64 %21, 8, !dbg !222
  br i1 %22, label %23, label %42, !dbg !222

23:                                               ; preds = %26, %20
  %24 = phi i64 [ %39, %26 ], [ 0, %20 ], !dbg !222
  %25 = icmp slt i64 %24, 16, !dbg !222
  br i1 %25, label %26, label %40, !dbg !222

26:                                               ; preds = %23
  %27 = add i64 %16, %21, !dbg !222
  %28 = mul i64 %18, 256, !dbg !222
  %29 = mul i64 %27, 16, !dbg !222
  %30 = add i64 %28, %29, !dbg !222
  %31 = add i64 %30, %24, !dbg !222
  %32 = getelementptr float, ptr %7, i64 %31, !dbg !222
  %33 = load <4 x float>, ptr %32, align 4, !dbg !222
  %34 = mul i64 %18, 289, !dbg !222
  %35 = mul i64 %27, 17, !dbg !222
  %36 = add i64 %34, %35, !dbg !222
  %37 = add i64 %36, %24, !dbg !222
  %38 = getelementptr float, ptr %12, i64 %37, !dbg !222
  store <4 x float> %33, ptr %38, align 4, !dbg !222
  %39 = add i64 %24, 4, !dbg !222
  br label %23, !dbg !222

40:                                               ; preds = %23
  %41 = add i64 %21, 1, !dbg !222
  br label %20, !dbg !222

42:                                               ; preds = %20
  %43 = add i64 %18, 1, !dbg !222
  br label %17, !dbg !222

44:                                               ; preds = %17
  ret i32 0, !dbg !223
}

define internal i32 @infer_dispatch_10_conv_64x8x8x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !224 {
  %4 = alloca float, i64 4, align 64, !dbg !225
  %5 = alloca float, i64 4, align 64, !dbg !226
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !227
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !227
  %8 = load ptr, ptr %7, align 8, !dbg !227
  %9 = getelementptr float, ptr %8, i64 26752, !dbg !227
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !227
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !228
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !228
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !228
  %13 = load ptr, ptr %12, align 8, !dbg !228
  %14 = getelementptr float, ptr %13, i64 44032, !dbg !228
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !228
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !229
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !229
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !229
  %18 = load ptr, ptr %17, align 8, !dbg !229
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !229
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !225
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !225
  %21 = zext i32 %20 to i64, !dbg !225
  %22 = sdiv i64 %21, 2, !dbg !225
  %23 = mul i64 %22, 2, !dbg !225
  %24 = icmp ne i64 %21, %23, !dbg !225
  %25 = icmp slt i64 %21, 0, !dbg !225
  %26 = and i1 %24, %25, !dbg !225
  %27 = add i64 %22, -1, !dbg !225
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !225
  %29 = srem i64 %21, 2, !dbg !225
  %30 = icmp slt i64 %29, 0, !dbg !225
  %31 = add nsw i64 %29, 2, !dbg !225
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !225
  %33 = mul nsw i64 %28, 8, !dbg !225
  %34 = mul nsw i64 %32, 4, !dbg !225
  %35 = getelementptr float, ptr %5, i64 0, !dbg !230
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !230
  br label %36, !dbg !225

36:                                               ; preds = %127, %3
  %37 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !225
  %38 = icmp slt i64 %37, 8, !dbg !225
  br i1 %38, label %39, label %129, !dbg !225

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !225
  %41 = getelementptr float, ptr @__constant_64xf32, i64 %40, !dbg !231
  %42 = load <1 x float>, ptr %41, align 4, !dbg !231
  br label %43, !dbg !225

43:                                               ; preds = %125, %39
  %44 = phi i64 [ %126, %125 ], [ 0, %39 ], !dbg !225
  %45 = icmp slt i64 %44, 4, !dbg !225
  br i1 %45, label %46, label %127, !dbg !225

46:                                               ; preds = %107, %43
  %47 = phi i64 [ %124, %107 ], [ 0, %43 ], !dbg !225
  %48 = icmp slt i64 %47, 8, !dbg !225
  br i1 %48, label %49, label %125, !dbg !225

49:                                               ; preds = %46
  %50 = mul nsw i64 %47, 2, !dbg !225
  br label %51, !dbg !225

51:                                               ; preds = %54, %49
  %52 = phi i64 [ %59, %54 ], [ 0, %49 ], !dbg !225
  %53 = icmp slt i64 %52, 4, !dbg !225
  br i1 %53, label %54, label %60, !dbg !225

54:                                               ; preds = %51
  %55 = add nuw nsw i64 0, %52, !dbg !225
  %56 = getelementptr inbounds nuw float, ptr %5, i64 %55, !dbg !225
  %57 = load float, ptr %56, align 4, !dbg !225
  %58 = getelementptr inbounds nuw float, ptr %4, i64 %55, !dbg !225
  store float %57, ptr %58, align 4, !dbg !225
  %59 = add i64 %52, 1, !dbg !225
  br label %51, !dbg !225

60:                                               ; preds = %105, %51
  %61 = phi i64 [ %106, %105 ], [ 0, %51 ], !dbg !225
  %62 = icmp slt i64 %61, 32, !dbg !225
  br i1 %62, label %63, label %107, !dbg !225

63:                                               ; preds = %103, %60
  %64 = phi i64 [ %104, %103 ], [ 0, %60 ], !dbg !225
  %65 = icmp slt i64 %64, 3, !dbg !225
  br i1 %65, label %66, label %105, !dbg !225

66:                                               ; preds = %63
  %67 = mul nsw i64 %44, 2, !dbg !225
  %68 = mul nsw i64 %32, 8, !dbg !225
  %69 = add i64 %67, %68, !dbg !225
  %70 = add i64 %69, %64, !dbg !225
  br label %71, !dbg !225

71:                                               ; preds = %101, %66
  %72 = phi i64 [ %102, %101 ], [ 0, %66 ], !dbg !225
  %73 = icmp slt i64 %72, 4, !dbg !225
  br i1 %73, label %74, label %103, !dbg !225

74:                                               ; preds = %77, %71
  %75 = phi i64 [ %100, %77 ], [ 0, %71 ], !dbg !225
  %76 = icmp slt i64 %75, 3, !dbg !225
  br i1 %76, label %77, label %101, !dbg !225

77:                                               ; preds = %74
  %78 = mul nsw i64 %72, 2, !dbg !225
  %79 = add i64 %50, %78, !dbg !225
  %80 = add i64 %79, %75, !dbg !225
  %81 = mul nuw nsw i64 %61, 289, !dbg !225
  %82 = mul nuw nsw i64 %70, 17, !dbg !225
  %83 = add nuw nsw i64 %81, %82, !dbg !225
  %84 = add nuw nsw i64 %83, %80, !dbg !225
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !225
  %86 = load float, ptr %85, align 4, !dbg !225
  %87 = mul nuw nsw i64 %40, 288, !dbg !225
  %88 = mul nuw nsw i64 %61, 9, !dbg !225
  %89 = add nuw nsw i64 %87, %88, !dbg !225
  %90 = mul nuw nsw i64 %64, 3, !dbg !225
  %91 = add nuw nsw i64 %89, %90, !dbg !225
  %92 = add nuw nsw i64 %91, %75, !dbg !225
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !225
  %94 = load float, ptr %93, align 4, !dbg !225
  %95 = add nuw nsw i64 0, %72, !dbg !225
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !225
  %97 = load float, ptr %96, align 4, !dbg !225
  %98 = fmul contract float %86, %94, !dbg !232
  %99 = fadd contract float %97, %98, !dbg !233
  store float %99, ptr %96, align 4, !dbg !225
  %100 = add i64 %75, 1, !dbg !225
  br label %74, !dbg !225

101:                                              ; preds = %74
  %102 = add i64 %72, 1, !dbg !225
  br label %71, !dbg !225

103:                                              ; preds = %71
  %104 = add i64 %64, 1, !dbg !225
  br label %63, !dbg !225

105:                                              ; preds = %63
  %106 = add i64 %61, 1, !dbg !225
  br label %60, !dbg !225

107:                                              ; preds = %60
  %108 = getelementptr float, ptr %4, i64 0, !dbg !231
  %109 = load <4 x float>, ptr %108, align 4, !dbg !231
  %110 = extractelement <1 x float> %42, i64 0, !dbg !234
  %111 = insertelement <4 x float> poison, float %110, i32 0, !dbg !234
  %112 = shufflevector <4 x float> %111, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !234
  %113 = fadd contract <4 x float> %109, %112, !dbg !234
  %114 = fcmp ugt <4 x float> %113, zeroinitializer, !dbg !235
  %115 = select <4 x i1> %114, <4 x float> %113, <4 x float> zeroinitializer, !dbg !236
  %116 = add i64 %34, %44, !dbg !225
  %117 = add i64 %116, 1, !dbg !225
  %118 = add i64 %47, 1, !dbg !225
  %119 = mul i64 %40, 100, !dbg !225
  %120 = mul i64 %117, 10, !dbg !225
  %121 = add i64 %119, %120, !dbg !225
  %122 = add i64 %121, %118, !dbg !225
  %123 = getelementptr float, ptr %18, i64 %122, !dbg !225
  store <4 x float> %115, ptr %123, align 4, !dbg !225
  %124 = add i64 %47, 4, !dbg !225
  br label %46, !dbg !225

125:                                              ; preds = %46
  %126 = add i64 %44, 1, !dbg !225
  br label %43, !dbg !225

127:                                              ; preds = %43
  %128 = add i64 %37, 1, !dbg !225
  br label %36, !dbg !225

129:                                              ; preds = %36
  ret i32 0, !dbg !237
}

define internal i32 @infer_dispatch_11_conv_64x8x8x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !238 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !239
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !239
  %6 = load ptr, ptr %5, align 8, !dbg !239
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !239
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !240
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !240
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !240
  %10 = load ptr, ptr %9, align 8, !dbg !240
  %11 = getelementptr float, ptr %10, i64 7168, !dbg !240
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !240
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !241
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !241
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !241
  %15 = load ptr, ptr %14, align 8, !dbg !241
  %16 = getelementptr float, ptr %15, i64 6400, !dbg !241
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !241
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !242
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !242
  %19 = zext i32 %18 to i64, !dbg !242
  %20 = sdiv i64 %19, 2, !dbg !242
  %21 = mul i64 %20, 2, !dbg !242
  %22 = icmp ne i64 %19, %21, !dbg !242
  %23 = icmp slt i64 %19, 0, !dbg !242
  %24 = and i1 %22, %23, !dbg !242
  %25 = add i64 %20, -1, !dbg !242
  %26 = select i1 %24, i64 %25, i64 %20, !dbg !242
  %27 = srem i64 %19, 2, !dbg !242
  %28 = icmp slt i64 %27, 0, !dbg !242
  %29 = add nsw i64 %27, 2, !dbg !242
  %30 = select i1 %28, i64 %29, i64 %27, !dbg !242
  %31 = mul nsw i64 %26, 8, !dbg !242
  %32 = mul nsw i64 %30, 4, !dbg !242
  br label %33, !dbg !242

33:                                               ; preds = %102, %3
  %34 = phi i64 [ %103, %102 ], [ 0, %3 ], !dbg !242
  %35 = icmp slt i64 %34, 8, !dbg !242
  br i1 %35, label %36, label %104, !dbg !242

36:                                               ; preds = %33
  %37 = add i64 %34, %31, !dbg !242
  br label %38, !dbg !242

38:                                               ; preds = %100, %36
  %39 = phi i64 [ %101, %100 ], [ 0, %36 ], !dbg !242
  %40 = icmp slt i64 %39, 4, !dbg !242
  br i1 %40, label %41, label %102, !dbg !242

41:                                               ; preds = %98, %38
  %42 = phi i64 [ %99, %98 ], [ 0, %38 ], !dbg !242
  %43 = icmp slt i64 %42, 8, !dbg !242
  br i1 %43, label %44, label %100, !dbg !242

44:                                               ; preds = %41
  %45 = add i64 %32, %39, !dbg !243
  %46 = mul i64 %37, 64, !dbg !243
  %47 = mul i64 %45, 8, !dbg !243
  %48 = add i64 %46, %47, !dbg !243
  %49 = add i64 %48, %42, !dbg !243
  %50 = getelementptr float, ptr %16, i64 %49, !dbg !243
  store <4 x float> zeroinitializer, ptr %50, align 4, !dbg !243
  br label %51, !dbg !242

51:                                               ; preds = %96, %44
  %52 = phi i64 [ %97, %96 ], [ 0, %44 ], !dbg !242
  %53 = icmp slt i64 %52, 64, !dbg !242
  br i1 %53, label %54, label %98, !dbg !242

54:                                               ; preds = %94, %51
  %55 = phi i64 [ %95, %94 ], [ 0, %51 ], !dbg !242
  %56 = icmp slt i64 %55, 3, !dbg !242
  br i1 %56, label %57, label %96, !dbg !242

57:                                               ; preds = %54
  %58 = add i64 %55, %39, !dbg !242
  %59 = add i64 %58, %32, !dbg !242
  br label %60, !dbg !242

60:                                               ; preds = %92, %57
  %61 = phi i64 [ %93, %92 ], [ 0, %57 ], !dbg !242
  %62 = icmp slt i64 %61, 4, !dbg !242
  br i1 %62, label %63, label %94, !dbg !242

63:                                               ; preds = %66, %60
  %64 = phi i64 [ %91, %66 ], [ 0, %60 ], !dbg !242
  %65 = icmp slt i64 %64, 3, !dbg !242
  br i1 %65, label %66, label %92, !dbg !242

66:                                               ; preds = %63
  %67 = add i64 %42, %61, !dbg !242
  %68 = add i64 %67, %64, !dbg !242
  %69 = mul nuw nsw i64 %52, 100, !dbg !242
  %70 = mul nuw nsw i64 %59, 10, !dbg !242
  %71 = add nuw nsw i64 %69, %70, !dbg !242
  %72 = add nuw nsw i64 %71, %68, !dbg !242
  %73 = getelementptr inbounds nuw float, ptr %6, i64 %72, !dbg !242
  %74 = load float, ptr %73, align 4, !dbg !242
  %75 = mul nuw nsw i64 %37, 576, !dbg !242
  %76 = mul nuw nsw i64 %52, 9, !dbg !242
  %77 = add nuw nsw i64 %75, %76, !dbg !242
  %78 = mul nuw nsw i64 %55, 3, !dbg !242
  %79 = add nuw nsw i64 %77, %78, !dbg !242
  %80 = add nuw nsw i64 %79, %64, !dbg !242
  %81 = getelementptr inbounds nuw float, ptr %11, i64 %80, !dbg !242
  %82 = load float, ptr %81, align 4, !dbg !242
  %83 = mul nuw nsw i64 %37, 64, !dbg !242
  %84 = mul nuw nsw i64 %45, 8, !dbg !242
  %85 = add nuw nsw i64 %83, %84, !dbg !242
  %86 = add nuw nsw i64 %85, %67, !dbg !242
  %87 = getelementptr inbounds nuw float, ptr %16, i64 %86, !dbg !242
  %88 = load float, ptr %87, align 4, !dbg !242
  %89 = fmul contract float %74, %82, !dbg !244
  %90 = fadd contract float %88, %89, !dbg !245
  store float %90, ptr %87, align 4, !dbg !242
  %91 = add i64 %64, 1, !dbg !242
  br label %63, !dbg !242

92:                                               ; preds = %63
  %93 = add i64 %61, 1, !dbg !242
  br label %60, !dbg !242

94:                                               ; preds = %60
  %95 = add i64 %55, 1, !dbg !242
  br label %54, !dbg !242

96:                                               ; preds = %54
  %97 = add i64 %52, 1, !dbg !242
  br label %51, !dbg !242

98:                                               ; preds = %51
  %99 = add i64 %42, 4, !dbg !242
  br label %41, !dbg !242

100:                                              ; preds = %41
  %101 = add i64 %39, 1, !dbg !242
  br label %38, !dbg !242

102:                                              ; preds = %38
  %103 = add i64 %34, 1, !dbg !242
  br label %33, !dbg !242

104:                                              ; preds = %33
  ret i32 0, !dbg !246
}

define internal i32 @infer_dispatch_12_matmul_like_64x8x8x32_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !247 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !248
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !248
  %6 = load ptr, ptr %5, align 8, !dbg !248
  %7 = getelementptr float, ptr %6, i64 18560, !dbg !248
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !248
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !249
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !249
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !249
  %11 = load ptr, ptr %10, align 8, !dbg !249
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !249
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !250
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !250
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !250
  %15 = load ptr, ptr %14, align 8, !dbg !250
  %16 = getelementptr float, ptr %15, i64 10496, !dbg !250
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !250
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !251
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !251
  %19 = zext i32 %18 to i64, !dbg !251
  %20 = mul nsw i64 %19, 8, !dbg !251
  br label %21, !dbg !251

21:                                               ; preds = %166, %3
  %22 = phi i64 [ %200, %166 ], [ 0, %3 ], !dbg !251
  %23 = icmp slt i64 %22, 8, !dbg !251
  br i1 %23, label %24, label %201, !dbg !251

24:                                               ; preds = %21
  %25 = add i64 %22, %20, !dbg !251
  br label %26, !dbg !251

26:                                               ; preds = %134, %24
  %27 = phi i64 [ %165, %134 ], [ 0, %24 ], !dbg !251
  %28 = phi [8 x <8 x float>] [ %164, %134 ], [ zeroinitializer, %24 ], !dbg !251
  %29 = icmp slt i64 %27, 32, !dbg !251
  br i1 %29, label %30, label %166, !dbg !251

30:                                               ; preds = %34, %26
  %31 = phi i64 [ %42, %34 ], [ 0, %26 ], !dbg !251
  %32 = phi <8 x float> [ %41, %34 ], [ poison, %26 ], !dbg !251
  %33 = icmp slt i64 %31, 8, !dbg !251
  br i1 %33, label %34, label %43, !dbg !251

34:                                               ; preds = %30
  %35 = mul nsw i64 %31, 2, !dbg !251
  %36 = mul nuw nsw i64 %27, 256, !dbg !251
  %37 = add nuw nsw i64 %36, 0, !dbg !251
  %38 = add nuw nsw i64 %37, %35, !dbg !251
  %39 = getelementptr inbounds nuw float, ptr %7, i64 %38, !dbg !251
  %40 = load float, ptr %39, align 4, !dbg !251
  %41 = insertelement <8 x float> %32, float %40, i64 %31, !dbg !251
  %42 = add i64 %31, 1, !dbg !251
  br label %30, !dbg !251

43:                                               ; preds = %47, %30
  %44 = phi i64 [ %55, %47 ], [ 0, %30 ], !dbg !251
  %45 = phi <8 x float> [ %54, %47 ], [ poison, %30 ], !dbg !251
  %46 = icmp slt i64 %44, 8, !dbg !251
  br i1 %46, label %47, label %56, !dbg !251

47:                                               ; preds = %43
  %48 = mul nsw i64 %44, 2, !dbg !251
  %49 = mul nuw nsw i64 %27, 256, !dbg !251
  %50 = add nuw nsw i64 %49, 32, !dbg !251
  %51 = add nuw nsw i64 %50, %48, !dbg !251
  %52 = getelementptr inbounds nuw float, ptr %7, i64 %51, !dbg !251
  %53 = load float, ptr %52, align 4, !dbg !251
  %54 = insertelement <8 x float> %45, float %53, i64 %44, !dbg !251
  %55 = add i64 %44, 1, !dbg !251
  br label %43, !dbg !251

56:                                               ; preds = %60, %43
  %57 = phi i64 [ %68, %60 ], [ 0, %43 ], !dbg !251
  %58 = phi <8 x float> [ %67, %60 ], [ poison, %43 ], !dbg !251
  %59 = icmp slt i64 %57, 8, !dbg !251
  br i1 %59, label %60, label %69, !dbg !251

60:                                               ; preds = %56
  %61 = mul nsw i64 %57, 2, !dbg !251
  %62 = mul nuw nsw i64 %27, 256, !dbg !251
  %63 = add nuw nsw i64 %62, 64, !dbg !251
  %64 = add nuw nsw i64 %63, %61, !dbg !251
  %65 = getelementptr inbounds nuw float, ptr %7, i64 %64, !dbg !251
  %66 = load float, ptr %65, align 4, !dbg !251
  %67 = insertelement <8 x float> %58, float %66, i64 %57, !dbg !251
  %68 = add i64 %57, 1, !dbg !251
  br label %56, !dbg !251

69:                                               ; preds = %73, %56
  %70 = phi i64 [ %81, %73 ], [ 0, %56 ], !dbg !251
  %71 = phi <8 x float> [ %80, %73 ], [ poison, %56 ], !dbg !251
  %72 = icmp slt i64 %70, 8, !dbg !251
  br i1 %72, label %73, label %82, !dbg !251

73:                                               ; preds = %69
  %74 = mul nsw i64 %70, 2, !dbg !251
  %75 = mul nuw nsw i64 %27, 256, !dbg !251
  %76 = add nuw nsw i64 %75, 96, !dbg !251
  %77 = add nuw nsw i64 %76, %74, !dbg !251
  %78 = getelementptr inbounds nuw float, ptr %7, i64 %77, !dbg !251
  %79 = load float, ptr %78, align 4, !dbg !251
  %80 = insertelement <8 x float> %71, float %79, i64 %70, !dbg !251
  %81 = add i64 %70, 1, !dbg !251
  br label %69, !dbg !251

82:                                               ; preds = %86, %69
  %83 = phi i64 [ %94, %86 ], [ 0, %69 ], !dbg !251
  %84 = phi <8 x float> [ %93, %86 ], [ poison, %69 ], !dbg !251
  %85 = icmp slt i64 %83, 8, !dbg !251
  br i1 %85, label %86, label %95, !dbg !251

86:                                               ; preds = %82
  %87 = mul nsw i64 %83, 2, !dbg !251
  %88 = mul nuw nsw i64 %27, 256, !dbg !251
  %89 = add nuw nsw i64 %88, 128, !dbg !251
  %90 = add nuw nsw i64 %89, %87, !dbg !251
  %91 = getelementptr inbounds nuw float, ptr %7, i64 %90, !dbg !251
  %92 = load float, ptr %91, align 4, !dbg !251
  %93 = insertelement <8 x float> %84, float %92, i64 %83, !dbg !251
  %94 = add i64 %83, 1, !dbg !251
  br label %82, !dbg !251

95:                                               ; preds = %99, %82
  %96 = phi i64 [ %107, %99 ], [ 0, %82 ], !dbg !251
  %97 = phi <8 x float> [ %106, %99 ], [ poison, %82 ], !dbg !251
  %98 = icmp slt i64 %96, 8, !dbg !251
  br i1 %98, label %99, label %108, !dbg !251

99:                                               ; preds = %95
  %100 = mul nsw i64 %96, 2, !dbg !251
  %101 = mul nuw nsw i64 %27, 256, !dbg !251
  %102 = add nuw nsw i64 %101, 160, !dbg !251
  %103 = add nuw nsw i64 %102, %100, !dbg !251
  %104 = getelementptr inbounds nuw float, ptr %7, i64 %103, !dbg !251
  %105 = load float, ptr %104, align 4, !dbg !251
  %106 = insertelement <8 x float> %97, float %105, i64 %96, !dbg !251
  %107 = add i64 %96, 1, !dbg !251
  br label %95, !dbg !251

108:                                              ; preds = %112, %95
  %109 = phi i64 [ %120, %112 ], [ 0, %95 ], !dbg !251
  %110 = phi <8 x float> [ %119, %112 ], [ poison, %95 ], !dbg !251
  %111 = icmp slt i64 %109, 8, !dbg !251
  br i1 %111, label %112, label %121, !dbg !251

112:                                              ; preds = %108
  %113 = mul nsw i64 %109, 2, !dbg !251
  %114 = mul nuw nsw i64 %27, 256, !dbg !251
  %115 = add nuw nsw i64 %114, 192, !dbg !251
  %116 = add nuw nsw i64 %115, %113, !dbg !251
  %117 = getelementptr inbounds nuw float, ptr %7, i64 %116, !dbg !251
  %118 = load float, ptr %117, align 4, !dbg !251
  %119 = insertelement <8 x float> %110, float %118, i64 %109, !dbg !251
  %120 = add i64 %109, 1, !dbg !251
  br label %108, !dbg !251

121:                                              ; preds = %125, %108
  %122 = phi i64 [ %133, %125 ], [ 0, %108 ], !dbg !251
  %123 = phi <8 x float> [ %132, %125 ], [ poison, %108 ], !dbg !251
  %124 = icmp slt i64 %122, 8, !dbg !251
  br i1 %124, label %125, label %134, !dbg !251

125:                                              ; preds = %121
  %126 = mul nsw i64 %122, 2, !dbg !251
  %127 = mul nuw nsw i64 %27, 256, !dbg !251
  %128 = add nuw nsw i64 %127, 224, !dbg !251
  %129 = add nuw nsw i64 %128, %126, !dbg !251
  %130 = getelementptr inbounds nuw float, ptr %7, i64 %129, !dbg !251
  %131 = load float, ptr %130, align 4, !dbg !251
  %132 = insertelement <8 x float> %123, float %131, i64 %122, !dbg !251
  %133 = add i64 %122, 1, !dbg !251
  br label %121, !dbg !251

134:                                              ; preds = %121
  %135 = extractvalue [8 x <8 x float>] %28, 0, !dbg !252
  %136 = mul nuw nsw i64 %25, 32, !dbg !252
  %137 = add nuw nsw i64 %136, %27, !dbg !252
  %138 = getelementptr inbounds nuw float, ptr %11, i64 %137, !dbg !252
  %139 = load float, ptr %138, align 4, !dbg !252
  %140 = insertelement <8 x float> poison, float %139, i32 0, !dbg !252
  %141 = shufflevector <8 x float> %140, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !252
  %142 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %32, <8 x float> %141, <8 x float> %135), !dbg !252
  %143 = extractvalue [8 x <8 x float>] %28, 1, !dbg !252
  %144 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %45, <8 x float> %141, <8 x float> %143), !dbg !252
  %145 = extractvalue [8 x <8 x float>] %28, 2, !dbg !252
  %146 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %58, <8 x float> %141, <8 x float> %145), !dbg !252
  %147 = extractvalue [8 x <8 x float>] %28, 3, !dbg !252
  %148 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %71, <8 x float> %141, <8 x float> %147), !dbg !252
  %149 = extractvalue [8 x <8 x float>] %28, 4, !dbg !252
  %150 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %84, <8 x float> %141, <8 x float> %149), !dbg !252
  %151 = extractvalue [8 x <8 x float>] %28, 5, !dbg !252
  %152 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %97, <8 x float> %141, <8 x float> %151), !dbg !252
  %153 = extractvalue [8 x <8 x float>] %28, 6, !dbg !252
  %154 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %110, <8 x float> %141, <8 x float> %153), !dbg !252
  %155 = extractvalue [8 x <8 x float>] %28, 7, !dbg !252
  %156 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %123, <8 x float> %141, <8 x float> %155), !dbg !252
  %157 = insertvalue [8 x <8 x float>] poison, <8 x float> %142, 0, !dbg !252
  %158 = insertvalue [8 x <8 x float>] %157, <8 x float> %144, 1, !dbg !252
  %159 = insertvalue [8 x <8 x float>] %158, <8 x float> %146, 2, !dbg !252
  %160 = insertvalue [8 x <8 x float>] %159, <8 x float> %148, 3, !dbg !252
  %161 = insertvalue [8 x <8 x float>] %160, <8 x float> %150, 4, !dbg !252
  %162 = insertvalue [8 x <8 x float>] %161, <8 x float> %152, 5, !dbg !252
  %163 = insertvalue [8 x <8 x float>] %162, <8 x float> %154, 6, !dbg !252
  %164 = insertvalue [8 x <8 x float>] %163, <8 x float> %156, 7, !dbg !252
  %165 = add i64 %27, 1, !dbg !251
  br label %26, !dbg !251

166:                                              ; preds = %26
  %167 = extractvalue [8 x <8 x float>] %28, 0, !dbg !251
  %168 = mul i64 %25, 64, !dbg !251
  %169 = add i64 %168, 0, !dbg !251
  %170 = add i64 %169, 0, !dbg !251
  %171 = getelementptr float, ptr %16, i64 %170, !dbg !251
  store <8 x float> %167, ptr %171, align 4, !dbg !251
  %172 = extractvalue [8 x <8 x float>] %28, 1, !dbg !251
  %173 = add i64 %168, 8, !dbg !251
  %174 = add i64 %173, 0, !dbg !251
  %175 = getelementptr float, ptr %16, i64 %174, !dbg !251
  store <8 x float> %172, ptr %175, align 4, !dbg !251
  %176 = extractvalue [8 x <8 x float>] %28, 2, !dbg !251
  %177 = add i64 %168, 16, !dbg !251
  %178 = add i64 %177, 0, !dbg !251
  %179 = getelementptr float, ptr %16, i64 %178, !dbg !251
  store <8 x float> %176, ptr %179, align 4, !dbg !251
  %180 = extractvalue [8 x <8 x float>] %28, 3, !dbg !251
  %181 = add i64 %168, 24, !dbg !251
  %182 = add i64 %181, 0, !dbg !251
  %183 = getelementptr float, ptr %16, i64 %182, !dbg !251
  store <8 x float> %180, ptr %183, align 4, !dbg !251
  %184 = extractvalue [8 x <8 x float>] %28, 4, !dbg !251
  %185 = add i64 %168, 32, !dbg !251
  %186 = add i64 %185, 0, !dbg !251
  %187 = getelementptr float, ptr %16, i64 %186, !dbg !251
  store <8 x float> %184, ptr %187, align 4, !dbg !251
  %188 = extractvalue [8 x <8 x float>] %28, 5, !dbg !251
  %189 = add i64 %168, 40, !dbg !251
  %190 = add i64 %189, 0, !dbg !251
  %191 = getelementptr float, ptr %16, i64 %190, !dbg !251
  store <8 x float> %188, ptr %191, align 4, !dbg !251
  %192 = extractvalue [8 x <8 x float>] %28, 6, !dbg !251
  %193 = add i64 %168, 48, !dbg !251
  %194 = add i64 %193, 0, !dbg !251
  %195 = getelementptr float, ptr %16, i64 %194, !dbg !251
  store <8 x float> %192, ptr %195, align 4, !dbg !251
  %196 = extractvalue [8 x <8 x float>] %28, 7, !dbg !251
  %197 = add i64 %168, 56, !dbg !251
  %198 = add i64 %197, 0, !dbg !251
  %199 = getelementptr float, ptr %16, i64 %198, !dbg !251
  store <8 x float> %196, ptr %199, align 4, !dbg !251
  %200 = add i64 %22, 1, !dbg !251
  br label %21, !dbg !251

201:                                              ; preds = %21
  ret i32 0, !dbg !253
}

define internal i32 @infer_dispatch_13_reduction_64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !254 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !255
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !255
  %6 = load ptr, ptr %5, align 8, !dbg !255
  %7 = getelementptr float, ptr %6, i64 10496, !dbg !255
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !255
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !256
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !256
  %10 = load ptr, ptr %9, align 8, !dbg !256
  %11 = getelementptr float, ptr %10, i64 6400, !dbg !256
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !256
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !257
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !257
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !257
  %15 = load ptr, ptr %14, align 8, !dbg !257
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !257
  %16 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !258
  %17 = extractvalue %iree_hal_executable_workgroup_state_v0_t %16, 0, !dbg !258
  %18 = zext i32 %17 to i64, !dbg !258
  %19 = mul nsw i64 %18, 8, !dbg !258
  br label %20, !dbg !258

20:                                               ; preds = %114, %3
  %21 = phi i64 [ %117, %114 ], [ 0, %3 ], !dbg !258
  %22 = icmp slt i64 %21, 8, !dbg !258
  br i1 %22, label %23, label %118, !dbg !258

23:                                               ; preds = %20
  %24 = add i64 %21, %19, !dbg !258
  %25 = getelementptr float, ptr @__constant_64xf32_0, i64 %24, !dbg !258
  %26 = load <4 x float>, ptr %25, align 4, !dbg !258
  %27 = shufflevector <4 x float> %26, <4 x float> %26, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !258
  %28 = shufflevector <16 x float> %27, <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %29 = shufflevector <16 x float> %27, <16 x float> %28, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %30 = shufflevector <16 x float> %27, <16 x float> %29, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %31 = shufflevector <16 x float> %27, <16 x float> %30, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 0, i32 1, i32 2, i32 3>, !dbg !258
  %32 = shufflevector <16 x float> %31, <16 x float> %31, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>, !dbg !258
  %33 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, !dbg !258
  %34 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 4, i32 5, i32 6, i32 7>, !dbg !258
  %35 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 8, i32 9, i32 10, i32 11>, !dbg !258
  %36 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 12, i32 13, i32 14, i32 15>, !dbg !258
  %37 = getelementptr float, ptr @__constant_64xf32_1, i64 %24, !dbg !258
  %38 = load <4 x float>, ptr %37, align 4, !dbg !258
  %39 = shufflevector <4 x float> %38, <4 x float> %38, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !258
  %40 = shufflevector <16 x float> %39, <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %41 = shufflevector <16 x float> %39, <16 x float> %40, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %42 = shufflevector <16 x float> %39, <16 x float> %41, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 28, i32 29, i32 30, i32 31>, !dbg !258
  %43 = shufflevector <16 x float> %39, <16 x float> %42, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 0, i32 1, i32 2, i32 3>, !dbg !258
  %44 = shufflevector <16 x float> %43, <16 x float> %43, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>, !dbg !258
  %45 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, !dbg !258
  %46 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 4, i32 5, i32 6, i32 7>, !dbg !258
  %47 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 8, i32 9, i32 10, i32 11>, !dbg !258
  %48 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 12, i32 13, i32 14, i32 15>, !dbg !258
  br label %49, !dbg !258

49:                                               ; preds = %53, %23
  %50 = phi i64 [ %113, %53 ], [ 0, %23 ], !dbg !258
  %51 = phi <4 x float> [ %112, %53 ], [ zeroinitializer, %23 ], !dbg !258
  %52 = icmp slt i64 %50, 64, !dbg !258
  br i1 %52, label %53, label %114, !dbg !258

53:                                               ; preds = %49
  %54 = mul i64 %24, 64, !dbg !258
  %55 = add i64 %54, %50, !dbg !258
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !258
  %57 = load <4 x float>, ptr %56, align 4, !dbg !258
  %58 = add i64 %24, 1, !dbg !258
  %59 = mul i64 %58, 64, !dbg !258
  %60 = add i64 %59, %50, !dbg !258
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !258
  %62 = load <4 x float>, ptr %61, align 4, !dbg !258
  %63 = add i64 %24, 2, !dbg !258
  %64 = mul i64 %63, 64, !dbg !258
  %65 = add i64 %64, %50, !dbg !258
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !258
  %67 = load <4 x float>, ptr %66, align 4, !dbg !258
  %68 = add i64 %24, 3, !dbg !258
  %69 = mul i64 %68, 64, !dbg !258
  %70 = add i64 %69, %50, !dbg !258
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !258
  %72 = load <4 x float>, ptr %71, align 4, !dbg !258
  %73 = getelementptr float, ptr %11, i64 %55, !dbg !258
  %74 = load <4 x float>, ptr %73, align 4, !dbg !258
  %75 = getelementptr float, ptr %11, i64 %60, !dbg !258
  %76 = load <4 x float>, ptr %75, align 4, !dbg !258
  %77 = getelementptr float, ptr %11, i64 %65, !dbg !258
  %78 = load <4 x float>, ptr %77, align 4, !dbg !258
  %79 = getelementptr float, ptr %11, i64 %70, !dbg !258
  %80 = load <4 x float>, ptr %79, align 4, !dbg !258
  %81 = fadd contract <4 x float> %74, %45, !dbg !259
  %82 = fadd contract <4 x float> %76, %46, !dbg !259
  %83 = fadd contract <4 x float> %78, %47, !dbg !259
  %84 = fadd contract <4 x float> %80, %48, !dbg !259
  %85 = fadd contract <4 x float> %57, %33, !dbg !260
  %86 = fadd contract <4 x float> %62, %34, !dbg !260
  %87 = fadd contract <4 x float> %67, %35, !dbg !260
  %88 = fadd contract <4 x float> %72, %36, !dbg !260
  %89 = fadd contract <4 x float> %85, %81, !dbg !261
  %90 = fadd contract <4 x float> %86, %82, !dbg !261
  %91 = fadd contract <4 x float> %87, %83, !dbg !261
  %92 = fadd contract <4 x float> %88, %84, !dbg !261
  %93 = fcmp ugt <4 x float> %89, zeroinitializer, !dbg !262
  %94 = fcmp ugt <4 x float> %90, zeroinitializer, !dbg !262
  %95 = fcmp ugt <4 x float> %91, zeroinitializer, !dbg !262
  %96 = fcmp ugt <4 x float> %92, zeroinitializer, !dbg !262
  %97 = select <4 x i1> %93, <4 x float> %89, <4 x float> zeroinitializer, !dbg !263
  %98 = select <4 x i1> %94, <4 x float> %90, <4 x float> zeroinitializer, !dbg !263
  %99 = select <4 x i1> %95, <4 x float> %91, <4 x float> zeroinitializer, !dbg !263
  %100 = select <4 x i1> %96, <4 x float> %92, <4 x float> zeroinitializer, !dbg !263
  %101 = extractelement <4 x float> %51, i64 0, !dbg !264
  %102 = call float @llvm.vector.reduce.fadd.v4f32(float %101, <4 x float> %97), !dbg !264
  %103 = extractelement <4 x float> %51, i64 1, !dbg !264
  %104 = call float @llvm.vector.reduce.fadd.v4f32(float %103, <4 x float> %98), !dbg !264
  %105 = extractelement <4 x float> %51, i64 2, !dbg !264
  %106 = call float @llvm.vector.reduce.fadd.v4f32(float %105, <4 x float> %99), !dbg !264
  %107 = extractelement <4 x float> %51, i64 3, !dbg !264
  %108 = call float @llvm.vector.reduce.fadd.v4f32(float %107, <4 x float> %100), !dbg !264
  %109 = insertelement <4 x float> poison, float %102, i64 0, !dbg !264
  %110 = insertelement <4 x float> %109, float %104, i64 1, !dbg !264
  %111 = insertelement <4 x float> %110, float %106, i64 2, !dbg !264
  %112 = insertelement <4 x float> %111, float %108, i64 3, !dbg !264
  %113 = add i64 %50, 4, !dbg !258
  br label %49, !dbg !258

114:                                              ; preds = %49
  %115 = fdiv <4 x float> %51, splat (float 6.400000e+01), !dbg !265
  %116 = getelementptr float, ptr %15, i64 %24, !dbg !258
  store <4 x float> %115, ptr %116, align 4, !dbg !258
  %117 = add i64 %21, 4, !dbg !258
  br label %20, !dbg !258

118:                                              ; preds = %20
  ret i32 0, !dbg !266
}

define internal i32 @infer_dispatch_14_matmul_1x10x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !267 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !268
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !268
  %6 = load ptr, ptr %5, align 8, !dbg !268
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !268
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !269
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !269
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !269
  %10 = load ptr, ptr %9, align 8, !dbg !269
  %11 = getelementptr float, ptr %10, i64 76720, !dbg !269
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !269
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !270
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !270
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !270
  %15 = load ptr, ptr %14, align 8, !dbg !270
  %16 = getelementptr float, ptr %15, i64 64, !dbg !270
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !270
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !271
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !271
  %19 = zext i32 %18 to i64, !dbg !271
  %20 = mul nsw i64 %19, 5, !dbg !271
  br label %21, !dbg !271

21:                                               ; preds = %25, %3
  %22 = phi i64 [ %122, %25 ], [ 0, %3 ], !dbg !271
  %23 = phi <5 x float> [ %121, %25 ], [ zeroinitializer, %3 ], !dbg !271
  %24 = icmp slt i64 %22, 64, !dbg !271
  br i1 %24, label %25, label %123, !dbg !271

25:                                               ; preds = %21
  %26 = mul i64 %20, 64, !dbg !271
  %27 = add i64 %26, %22, !dbg !271
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !271
  %29 = load <4 x float>, ptr %28, align 4, !dbg !271
  %30 = add i64 %20, 1, !dbg !271
  %31 = mul i64 %30, 64, !dbg !271
  %32 = add i64 %31, %22, !dbg !271
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !271
  %34 = load <4 x float>, ptr %33, align 4, !dbg !271
  %35 = add i64 %20, 2, !dbg !271
  %36 = mul i64 %35, 64, !dbg !271
  %37 = add i64 %36, %22, !dbg !271
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !271
  %39 = load <4 x float>, ptr %38, align 4, !dbg !271
  %40 = add i64 %20, 3, !dbg !271
  %41 = mul i64 %40, 64, !dbg !271
  %42 = add i64 %41, %22, !dbg !271
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !271
  %44 = load <4 x float>, ptr %43, align 4, !dbg !271
  %45 = add i64 %20, 4, !dbg !271
  %46 = mul i64 %45, 64, !dbg !271
  %47 = add i64 %46, %22, !dbg !271
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !271
  %49 = load <4 x float>, ptr %48, align 4, !dbg !271
  %50 = extractelement <4 x float> %29, i64 0, !dbg !271
  %51 = extractelement <4 x float> %29, i64 1, !dbg !271
  %52 = extractelement <4 x float> %29, i64 2, !dbg !271
  %53 = extractelement <4 x float> %29, i64 3, !dbg !271
  %54 = extractelement <4 x float> %34, i64 0, !dbg !271
  %55 = extractelement <4 x float> %34, i64 1, !dbg !271
  %56 = extractelement <4 x float> %34, i64 2, !dbg !271
  %57 = extractelement <4 x float> %34, i64 3, !dbg !271
  %58 = extractelement <4 x float> %39, i64 0, !dbg !271
  %59 = extractelement <4 x float> %39, i64 1, !dbg !271
  %60 = extractelement <4 x float> %39, i64 2, !dbg !271
  %61 = extractelement <4 x float> %39, i64 3, !dbg !271
  %62 = extractelement <4 x float> %44, i64 0, !dbg !271
  %63 = extractelement <4 x float> %44, i64 1, !dbg !271
  %64 = extractelement <4 x float> %44, i64 2, !dbg !271
  %65 = extractelement <4 x float> %44, i64 3, !dbg !271
  %66 = extractelement <4 x float> %49, i64 0, !dbg !271
  %67 = extractelement <4 x float> %49, i64 1, !dbg !271
  %68 = extractelement <4 x float> %49, i64 2, !dbg !271
  %69 = extractelement <4 x float> %49, i64 3, !dbg !271
  %70 = insertelement <20 x float> poison, float %50, i64 0
  %71 = insertelement <20 x float> %70, float %51, i64 1
  %72 = insertelement <20 x float> %71, float %52, i64 2
  %73 = insertelement <20 x float> %72, float %53, i64 3
  %74 = insertelement <20 x float> %73, float %54, i64 4
  %75 = insertelement <20 x float> %74, float %55, i64 5
  %76 = insertelement <20 x float> %75, float %56, i64 6
  %77 = insertelement <20 x float> %76, float %57, i64 7
  %78 = insertelement <20 x float> %77, float %58, i64 8
  %79 = insertelement <20 x float> %78, float %59, i64 9
  %80 = insertelement <20 x float> %79, float %60, i64 10
  %81 = insertelement <20 x float> %80, float %61, i64 11
  %82 = insertelement <20 x float> %81, float %62, i64 12
  %83 = insertelement <20 x float> %82, float %63, i64 13
  %84 = insertelement <20 x float> %83, float %64, i64 14
  %85 = insertelement <20 x float> %84, float %65, i64 15
  %86 = insertelement <20 x float> %85, float %66, i64 16
  %87 = insertelement <20 x float> %86, float %67, i64 17
  %88 = insertelement <20 x float> %87, float %68, i64 18
  %89 = insertelement <20 x float> %88, float %69, i64 19
  %90 = shufflevector <20 x float> %89, <20 x float> %89, <20 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 1, i32 5, i32 9, i32 13, i32 17, i32 2, i32 6, i32 10, i32 14, i32 18, i32 3, i32 7, i32 11, i32 15, i32 19>
  %91 = shufflevector <20 x float> %90, <20 x float> %90, <5 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4>
  %92 = shufflevector <20 x float> %90, <20 x float> %90, <5 x i32> <i32 5, i32 6, i32 7, i32 8, i32 9>
  %93 = shufflevector <20 x float> %90, <20 x float> %90, <5 x i32> <i32 10, i32 11, i32 12, i32 13, i32 14>
  %94 = shufflevector <20 x float> %90, <20 x float> %90, <5 x i32> <i32 15, i32 16, i32 17, i32 18, i32 19>
  %95 = add nuw nsw i64 0, %22
  %96 = getelementptr inbounds nuw float, ptr %6, i64 %95
  %97 = load float, ptr %96, align 4
  %98 = insertelement <5 x float> poison, float %97, i32 0
  %99 = shufflevector <5 x float> %98, <5 x float> poison, <5 x i32> zeroinitializer
  %100 = call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %91, <5 x float> %99, <5 x float> %23)
  %101 = add i64 %22, 1
  %102 = add nuw nsw i64 0, %101
  %103 = getelementptr inbounds nuw float, ptr %6, i64 %102
  %104 = load float, ptr %103, align 4
  %105 = insertelement <5 x float> poison, float %104, i32 0
  %106 = shufflevector <5 x float> %105, <5 x float> poison, <5 x i32> zeroinitializer
  %107 = call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %92, <5 x float> %106, <5 x float> %100)
  %108 = add i64 %22, 2
  %109 = add nuw nsw i64 0, %108
  %110 = getelementptr inbounds nuw float, ptr %6, i64 %109
  %111 = load float, ptr %110, align 4
  %112 = insertelement <5 x float> poison, float %111, i32 0
  %113 = shufflevector <5 x float> %112, <5 x float> poison, <5 x i32> zeroinitializer
  %114 = call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %93, <5 x float> %113, <5 x float> %107)
  %115 = add i64 %22, 3
  %116 = add nuw nsw i64 0, %115
  %117 = getelementptr inbounds nuw float, ptr %6, i64 %116
  %118 = load float, ptr %117, align 4
  %119 = insertelement <5 x float> poison, float %118, i32 0
  %120 = shufflevector <5 x float> %119, <5 x float> poison, <5 x i32> zeroinitializer
  %121 = call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %94, <5 x float> %120, <5 x float> %114)
  %122 = add i64 %22, 4, !dbg !271
  br label %21, !dbg !271

123:                                              ; preds = %21
  %124 = add i64 0, %20, !dbg !272
  %125 = getelementptr float, ptr @__constant_1x10xf32, i64 %124, !dbg !272
  %126 = load <5 x float>, ptr %125, align 4, !dbg !272
  %127 = fadd contract <5 x float> %23, %126, !dbg !273
  %128 = getelementptr float, ptr %16, i64 %124, !dbg !273
  store <5 x float> %127, ptr %128, align 4, !dbg !273
  ret i32 0, !dbg !274
}

define internal i32 @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !275 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !276
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !276
  %6 = load ptr, ptr %5, align 8, !dbg !276
  %7 = getelementptr float, ptr %6, i64 64, !dbg !276
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !276
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !277
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !277
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !277
  %11 = load ptr, ptr %10, align 8, !dbg !277
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !277
  br label %12, !dbg !278

12:                                               ; preds = %16, %3
  %13 = phi i64 [ %23, %16 ], [ 0, %3 ], !dbg !278
  %14 = phi <1 x float> [ %22, %16 ], [ splat (float 0xFFF8000000000000), %3 ], !dbg !278
  %15 = icmp slt i64 %13, 8, !dbg !278
  br i1 %15, label %16, label %24, !dbg !278

16:                                               ; preds = %12
  %17 = getelementptr float, ptr %7, i64 %13, !dbg !278
  %18 = load <4 x float>, ptr %17, align 4, !dbg !278
  %19 = extractelement <1 x float> %14, i64 0, !dbg !278
  %20 = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> %18), !dbg !279
  %21 = call float @llvm.maxnum.f32(float %20, float %19), !dbg !279
  %22 = insertelement <1 x float> poison, float %21, i32 0, !dbg !278
  %23 = add i64 %13, 4, !dbg !278
  br label %12, !dbg !278

24:                                               ; preds = %12
  %25 = getelementptr float, ptr %7, i32 8, !dbg !278
  %26 = load <2 x float>, ptr %25, align 4, !dbg !278
  %27 = extractelement <1 x float> %14, i64 0, !dbg !278
  %28 = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> %26), !dbg !279
  %29 = call float @llvm.maxnum.f32(float %28, float %27), !dbg !279
  %30 = insertelement <4 x float> poison, float %29, i32 0, !dbg !280
  %31 = shufflevector <4 x float> %30, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !280
  br label %32, !dbg !280

32:                                               ; preds = %36, %24
  %33 = phi i64 [ %68, %36 ], [ 0, %24 ], !dbg !280
  %34 = phi <1 x float> [ %67, %36 ], [ zeroinitializer, %24 ], !dbg !280
  %35 = icmp slt i64 %33, 8, !dbg !280
  br i1 %35, label %36, label %69, !dbg !280

36:                                               ; preds = %32
  %37 = getelementptr float, ptr %7, i64 %33, !dbg !280
  %38 = load <4 x float>, ptr %37, align 4, !dbg !280
  %39 = extractelement <1 x float> %34, i64 0, !dbg !280
  %40 = fsub contract <4 x float> %38, %31, !dbg !281
  %41 = fcmp uge <4 x float> %40, splat (float 0xC055F33340000000), !dbg !282
  %42 = select <4 x i1> %41, <4 x float> %40, <4 x float> splat (float 0xC055F33340000000), !dbg !282
  %43 = fcmp ule <4 x float> %42, splat (float 0x4056333340000000), !dbg !282
  %44 = select <4 x i1> %43, <4 x float> %42, <4 x float> splat (float 0x4056333340000000), !dbg !282
  %45 = call <4 x float> @llvm.fma.v4f32(<4 x float> %44, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !282
  %46 = call <4 x float> @llvm.floor.v4f32(<4 x float> %45), !dbg !282
  %47 = fcmp uge <4 x float> %46, splat (float -1.270000e+02), !dbg !282
  %48 = select <4 x i1> %47, <4 x float> %46, <4 x float> splat (float -1.270000e+02), !dbg !282
  %49 = fcmp ule <4 x float> %48, splat (float 1.270000e+02), !dbg !282
  %50 = select <4 x i1> %49, <4 x float> %48, <4 x float> splat (float 1.270000e+02), !dbg !282
  %51 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0xBFE6300000000000), <4 x float> %50, <4 x float> %44), !dbg !282
  %52 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0x3F2BD01060000000), <4 x float> %50, <4 x float> %51), !dbg !282
  %53 = call <4 x float> @llvm.fma.v4f32(<4 x float> %52, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !282
  %54 = call <4 x float> @llvm.fma.v4f32(<4 x float> %53, <4 x float> %52, <4 x float> splat (float 0x3F81112100000000)), !dbg !282
  %55 = call <4 x float> @llvm.fma.v4f32(<4 x float> %54, <4 x float> %52, <4 x float> splat (float 0x3FA5553820000000)), !dbg !282
  %56 = call <4 x float> @llvm.fma.v4f32(<4 x float> %55, <4 x float> %52, <4 x float> splat (float 0x3FC5555540000000)), !dbg !282
  %57 = call <4 x float> @llvm.fma.v4f32(<4 x float> %56, <4 x float> %52, <4 x float> splat (float 5.000000e-01)), !dbg !282
  %58 = fmul contract <4 x float> %52, %52, !dbg !282
  %59 = call <4 x float> @llvm.fma.v4f32(<4 x float> %57, <4 x float> %58, <4 x float> %52), !dbg !282
  %60 = fadd contract <4 x float> %59, splat (float 1.000000e+00), !dbg !282
  %61 = fptosi <4 x float> %50 to <4 x i32>, !dbg !282
  %62 = add <4 x i32> %61, splat (i32 127), !dbg !282
  %63 = shl <4 x i32> %62, splat (i32 23), !dbg !282
  %64 = bitcast <4 x i32> %63 to <4 x float>, !dbg !282
  %65 = fmul contract <4 x float> %60, %64, !dbg !282
  %66 = call float @llvm.vector.reduce.fadd.v4f32(float %39, <4 x float> %65), !dbg !283
  %67 = insertelement <1 x float> poison, float %66, i32 0, !dbg !280
  %68 = add i64 %33, 4, !dbg !280
  br label %32, !dbg !280

69:                                               ; preds = %32
  %70 = insertelement <2 x float> poison, float %29, i32 0, !dbg !280
  %71 = shufflevector <2 x float> %70, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !280
  %72 = extractelement <1 x float> %34, i64 0, !dbg !280
  %73 = fsub contract <2 x float> %26, %71, !dbg !281
  %74 = fcmp uge <2 x float> %73, splat (float 0xC055F33340000000), !dbg !282
  %75 = select <2 x i1> %74, <2 x float> %73, <2 x float> splat (float 0xC055F33340000000), !dbg !282
  %76 = fcmp ule <2 x float> %75, splat (float 0x4056333340000000), !dbg !282
  %77 = select <2 x i1> %76, <2 x float> %75, <2 x float> splat (float 0x4056333340000000), !dbg !282
  %78 = call <2 x float> @llvm.fma.v2f32(<2 x float> %77, <2 x float> splat (float 0x3FF7154760000000), <2 x float> splat (float 5.000000e-01)), !dbg !282
  %79 = call <2 x float> @llvm.floor.v2f32(<2 x float> %78), !dbg !282
  %80 = fcmp uge <2 x float> %79, splat (float -1.270000e+02), !dbg !282
  %81 = select <2 x i1> %80, <2 x float> %79, <2 x float> splat (float -1.270000e+02), !dbg !282
  %82 = fcmp ule <2 x float> %81, splat (float 1.270000e+02), !dbg !282
  %83 = select <2 x i1> %82, <2 x float> %81, <2 x float> splat (float 1.270000e+02), !dbg !282
  %84 = call <2 x float> @llvm.fma.v2f32(<2 x float> splat (float 0xBFE6300000000000), <2 x float> %83, <2 x float> %77), !dbg !282
  %85 = call <2 x float> @llvm.fma.v2f32(<2 x float> splat (float 0x3F2BD01060000000), <2 x float> %83, <2 x float> %84), !dbg !282
  %86 = call <2 x float> @llvm.fma.v2f32(<2 x float> %85, <2 x float> splat (float 0x3F2A0D2CE0000000), <2 x float> splat (float 0x3F56E879C0000000)), !dbg !282
  %87 = call <2 x float> @llvm.fma.v2f32(<2 x float> %86, <2 x float> %85, <2 x float> splat (float 0x3F81112100000000)), !dbg !282
  %88 = call <2 x float> @llvm.fma.v2f32(<2 x float> %87, <2 x float> %85, <2 x float> splat (float 0x3FA5553820000000)), !dbg !282
  %89 = call <2 x float> @llvm.fma.v2f32(<2 x float> %88, <2 x float> %85, <2 x float> splat (float 0x3FC5555540000000)), !dbg !282
  %90 = call <2 x float> @llvm.fma.v2f32(<2 x float> %89, <2 x float> %85, <2 x float> splat (float 5.000000e-01)), !dbg !282
  %91 = fmul contract <2 x float> %85, %85, !dbg !282
  %92 = call <2 x float> @llvm.fma.v2f32(<2 x float> %90, <2 x float> %91, <2 x float> %85), !dbg !282
  %93 = fadd contract <2 x float> %92, splat (float 1.000000e+00), !dbg !282
  %94 = fptosi <2 x float> %83 to <2 x i32>, !dbg !282
  %95 = add <2 x i32> %94, splat (i32 127), !dbg !282
  %96 = shl <2 x i32> %95, splat (i32 23), !dbg !282
  %97 = bitcast <2 x i32> %96 to <2 x float>, !dbg !282
  %98 = fmul contract <2 x float> %93, %97, !dbg !282
  %99 = call float @llvm.vector.reduce.fadd.v2f32(float %72, <2 x float> %98), !dbg !283
  %100 = insertelement <4 x float> poison, float %99, i32 0, !dbg !284
  %101 = shufflevector <4 x float> %100, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !284
  br label %102, !dbg !284

102:                                              ; preds = %105, %69
  %103 = phi i64 [ %136, %105 ], [ 0, %69 ], !dbg !284
  %104 = icmp slt i64 %103, 8, !dbg !284
  br i1 %104, label %105, label %137, !dbg !284

105:                                              ; preds = %102
  %106 = getelementptr float, ptr %7, i64 %103, !dbg !284
  %107 = load <4 x float>, ptr %106, align 4, !dbg !284
  %108 = fsub contract <4 x float> %107, %31, !dbg !285
  %109 = fcmp uge <4 x float> %108, splat (float 0xC055F33340000000), !dbg !286
  %110 = select <4 x i1> %109, <4 x float> %108, <4 x float> splat (float 0xC055F33340000000), !dbg !286
  %111 = fcmp ule <4 x float> %110, splat (float 0x4056333340000000), !dbg !286
  %112 = select <4 x i1> %111, <4 x float> %110, <4 x float> splat (float 0x4056333340000000), !dbg !286
  %113 = call <4 x float> @llvm.fma.v4f32(<4 x float> %112, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !286
  %114 = call <4 x float> @llvm.floor.v4f32(<4 x float> %113), !dbg !286
  %115 = fcmp uge <4 x float> %114, splat (float -1.270000e+02), !dbg !286
  %116 = select <4 x i1> %115, <4 x float> %114, <4 x float> splat (float -1.270000e+02), !dbg !286
  %117 = fcmp ule <4 x float> %116, splat (float 1.270000e+02), !dbg !286
  %118 = select <4 x i1> %117, <4 x float> %116, <4 x float> splat (float 1.270000e+02), !dbg !286
  %119 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0xBFE6300000000000), <4 x float> %118, <4 x float> %112), !dbg !286
  %120 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0x3F2BD01060000000), <4 x float> %118, <4 x float> %119), !dbg !286
  %121 = call <4 x float> @llvm.fma.v4f32(<4 x float> %120, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !286
  %122 = call <4 x float> @llvm.fma.v4f32(<4 x float> %121, <4 x float> %120, <4 x float> splat (float 0x3F81112100000000)), !dbg !286
  %123 = call <4 x float> @llvm.fma.v4f32(<4 x float> %122, <4 x float> %120, <4 x float> splat (float 0x3FA5553820000000)), !dbg !286
  %124 = call <4 x float> @llvm.fma.v4f32(<4 x float> %123, <4 x float> %120, <4 x float> splat (float 0x3FC5555540000000)), !dbg !286
  %125 = call <4 x float> @llvm.fma.v4f32(<4 x float> %124, <4 x float> %120, <4 x float> splat (float 5.000000e-01)), !dbg !286
  %126 = fmul contract <4 x float> %120, %120, !dbg !286
  %127 = call <4 x float> @llvm.fma.v4f32(<4 x float> %125, <4 x float> %126, <4 x float> %120), !dbg !286
  %128 = fadd contract <4 x float> %127, splat (float 1.000000e+00), !dbg !286
  %129 = fptosi <4 x float> %118 to <4 x i32>, !dbg !286
  %130 = add <4 x i32> %129, splat (i32 127), !dbg !286
  %131 = shl <4 x i32> %130, splat (i32 23), !dbg !286
  %132 = bitcast <4 x i32> %131 to <4 x float>, !dbg !286
  %133 = fmul contract <4 x float> %128, %132, !dbg !286
  %134 = fdiv <4 x float> %133, %101, !dbg !287
  %135 = getelementptr float, ptr %11, i64 %103, !dbg !284
  store <4 x float> %134, ptr %135, align 4, !dbg !284
  %136 = add i64 %103, 4, !dbg !284
  br label %102, !dbg !284

137:                                              ; preds = %102
  %138 = insertelement <2 x float> poison, float %99, i32 0, !dbg !284
  %139 = shufflevector <2 x float> %138, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !284
  %140 = fdiv <2 x float> %98, %139, !dbg !287
  %141 = getelementptr float, ptr %11, i32 8, !dbg !284
  store <2 x float> %140, ptr %141, align 4, !dbg !284
  ret i32 0, !dbg !288
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <16 x float> @llvm.fmuladd.v16f32(<16 x float>, <16 x float>, <16 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v4f32(float, <4 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <5 x float> @llvm.fmuladd.v5f32(<5 x float>, <5 x float>, <5 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fmax.v2f32(<2 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.maxnum.f32(float, float) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fma.v2f32(<2 x float>, <2 x float>, <2 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.floor.v2f32(<2 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v2f32(float, <2 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.floor.v4f32(<4 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>) #2

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
  store i16 %36, ptr %2, align 4, !tbaa !289
  %37 = load float, ptr %2, align 4, !tbaa !291
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
  store i16 %37, ptr %2, align 4, !tbaa !289
  %38 = load float, ptr %2, align 4, !tbaa !291
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
  store volatile float %5, ptr %3, align 4, !tbaa !291
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !291
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
  store volatile float %16, ptr %3, align 4, !tbaa !291
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
  store volatile float %24, ptr %2, align 4, !tbaa !291
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
  br i1 %.not, label %19, label %6, !prof !293

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
  %20 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 296), align 8, !tbaa !294
  %21 = fmul double %20, %2
  %22 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 288), align 8, !tbaa !297
  %23 = fadd double %21, %22
  %24 = bitcast double %23 to i64
  %25 = fsub double %23, %22
  %26 = fsub double %21, %25
  %27 = and i64 %24, 31
  %28 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %27
  %29 = load i64, ptr %28, align 8, !tbaa !298
  %30 = shl i64 %24, 47
  %31 = add i64 %30, %29
  %32 = bitcast i64 %31 to double
  %33 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 304), align 8, !tbaa !300
  %34 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 312), align 8, !tbaa !300
  %35 = tail call double @llvm.fmuladd.f64(double %33, double %26, double %34)
  %36 = fmul double %26, %26
  %37 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 320), align 8, !tbaa !300
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
  store volatile float %16, ptr %3, align 4, !tbaa !291
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
  store volatile float %23, ptr %2, align 4, !tbaa !291
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
  store volatile float %2, ptr %4, align 4, !tbaa !291
  %.0..0..0..0.5 = load volatile float, ptr %4, align 4, !tbaa !291
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
  %10 = load i32, ptr %1, align 4, !tbaa !35
  %11 = add nsw i32 %10, -64
  br label %12

12:                                               ; preds = %7, %5
  %storemerge = phi i32 [ %11, %7 ], [ 0, %5 ]
  %.014 = phi float [ %9, %7 ], [ %0, %5 ]
  store i32 %storemerge, ptr %1, align 4, !tbaa !35
  br label %19

13:                                               ; preds = %2
  %14 = and i32 %4, 255
  %15 = add nsw i32 %14, -126
  store i32 %15, ptr %1, align 4, !tbaa !35
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
  br i1 %or.cond99, label %.critedge, label %73, !prof !301

.critedge:                                        ; preds = %2
  %10 = add i32 %.pre, -1
  %11 = icmp ult i32 %10, -16777217
  br i1 %11, label %28, label %12, !prof !293

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
  br i1 %31, label %47, label %32, !prof !293

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
  store volatile float %46, ptr %3, align 4, !tbaa !291
  %.0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !291
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
  %82 = load double, ptr %81, align 8, !tbaa !302
  %83 = getelementptr inbounds nuw i8, ptr %81, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !304
  %85 = bitcast i32 %78 to float
  %86 = fpext float %85 to double
  %87 = tail call double @llvm.fmuladd.f64(double %86, double %82, double -1.000000e+00)
  %88 = sitofp i32 %79 to double
  %89 = fadd double %84, %88
  %90 = fmul double %87, %87
  %91 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 256), align 8, !tbaa !300
  %92 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 264), align 8, !tbaa !300
  %93 = tail call double @llvm.fmuladd.f64(double %91, double %87, double %92)
  %94 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 272), align 8, !tbaa !300
  %95 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 280), align 8, !tbaa !300
  %96 = tail call double @llvm.fmuladd.f64(double %94, double %87, double %95)
  %97 = fmul double %90, %90
  %98 = load double, ptr getelementptr inbounds nuw (i8, ptr @__powf_log2_data, i64 288), align 8, !tbaa !300
  %99 = tail call double @llvm.fmuladd.f64(double %98, double %87, double %89)
  %100 = tail call double @llvm.fmuladd.f64(double %96, double %90, double %99)
  %101 = tail call double @llvm.fmuladd.f64(double %93, double %97, double %100)
  %102 = fpext float %1 to double
  %103 = fmul double %101, %102
  %104 = bitcast double %103 to i64
  %105 = and i64 %104, 9223231299366420480
  %106 = icmp samesign ugt i64 %105, 4638426141214900224
  br i1 %106, label %107, label %115, !prof !305

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
  %116 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 256), align 8, !tbaa !306
  %117 = fadd double %103, %116
  %118 = bitcast double %117 to i64
  %119 = fsub double %117, %116
  %120 = fsub double %103, %119
  %121 = and i64 %118, 31
  %122 = getelementptr inbounds nuw i64, ptr @__exp2f_data, i64 %121
  %123 = load i64, ptr %122, align 8, !tbaa !298
  %124 = zext nneg i32 %.050 to i64
  %125 = add i64 %118, %124
  %126 = shl i64 %125, 47
  %127 = add i64 %126, %123
  %128 = bitcast i64 %127 to double
  %129 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 264), align 8, !tbaa !300
  %130 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 272), align 8, !tbaa !300
  %131 = tail call double @llvm.fmuladd.f64(double %129, double %120, double %130)
  %132 = fmul double %120, %120
  %133 = load double, ptr getelementptr inbounds nuw (i8, ptr @__exp2f_data, i64 280), align 8, !tbaa !300
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
  store volatile float %9, ptr %2, align 4, !tbaa !291
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

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22, !24, !26, !28, !30}
!llvm.module.flags = !{!32, !33, !34}
!llvm.errno.tbaa = !{!35}

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
!15 = !DIFile(filename: "configured_module_infer_dispatch_7.mlir", directory: "dump")
!16 = distinct !DICompileUnit(language: DW_LANG_C17, file: !17, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!17 = !DIFile(filename: "configured_module_infer_dispatch_8.mlir", directory: "dump")
!18 = distinct !DICompileUnit(language: DW_LANG_C17, file: !19, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!19 = !DIFile(filename: "configured_module_infer_dispatch_9.mlir", directory: "dump")
!20 = distinct !DICompileUnit(language: DW_LANG_C17, file: !21, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!21 = !DIFile(filename: "configured_module_infer_dispatch_10.mlir", directory: "dump")
!22 = distinct !DICompileUnit(language: DW_LANG_C17, file: !23, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!23 = !DIFile(filename: "configured_module_infer_dispatch_11.mlir", directory: "dump")
!24 = distinct !DICompileUnit(language: DW_LANG_C17, file: !25, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!25 = !DIFile(filename: "configured_module_infer_dispatch_12.mlir", directory: "dump")
!26 = distinct !DICompileUnit(language: DW_LANG_C17, file: !27, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!27 = !DIFile(filename: "configured_module_infer_dispatch_13.mlir", directory: "dump")
!28 = distinct !DICompileUnit(language: DW_LANG_C17, file: !29, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!29 = !DIFile(filename: "configured_module_infer_dispatch_14.mlir", directory: "dump")
!30 = distinct !DICompileUnit(language: DW_LANG_C17, file: !31, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!31 = !DIFile(filename: "configured_module_infer_dispatch_15.mlir", directory: "dump")
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 1, !"wchar_size", i32 4}
!34 = !{i32 7, !"frame-pointer", i32 4}
!35 = !{!36, !36, i64 0}
!36 = !{!"int", !37, i64 0}
!37 = !{!"omnipotent char", !38, i64 0}
!38 = !{!"Simple C/C++ TBAA"}
!39 = distinct !DISubprogram(name: "infer_dispatch_0_slow_memcpy", linkageName: "infer_dispatch_0_slow_memcpy", scope: !1, file: !1, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!40 = !DISubroutineType(cc: DW_CC_normal, types: !41)
!41 = !{!42, !43, !74, !103}
!42 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !47, file: !47, line: 246, size: 768, elements: !48)
!47 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!48 = !{!49, !57, !60, !63, !65}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!52 = !DICompositeType(tag: DW_TAG_array_type, scope: !47, file: !47, line: 227, baseType: !53, size: 2048, elements: !55)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !54)
!54 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!55 = !{!56}
!56 = !DISubrange(count: 64)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !58, size: 64, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !61, size: 64, offset: 128)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !58)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !64, size: 64, offset: 192)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !66, offset: 256)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !47, file: !47, line: 227, size: 512, elements: !67)
!67 = !{!68}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !69)
!69 = !DICompositeType(tag: DW_TAG_array_type, scope: !47, file: !47, line: 227, baseType: !70, size: 512, elements: !72)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !71)
!71 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!72 = !{!73}
!73 = !DISubrange(count: 8)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !76)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !77)
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !47, file: !47, line: 275, size: 384, elements: !78)
!78 = !{!79, !80, !81, !84, !85, !86, !87, !88, !91, !92, !93, !98}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !53, size: 32)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !53, size: 32, offset: 32)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !82, size: 16, offset: 64)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !83)
!83 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !82, size: 16, offset: 80)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !53, size: 32, offset: 96)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !53, size: 32, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !82, size: 16, offset: 160)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !89, size: 8, offset: 176)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !90)
!90 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !89, size: 8, offset: 184)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !50, size: 64, offset: 192)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !94, size: 64, offset: 256)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !96)
!96 = !DICompositeType(tag: DW_TAG_array_type, scope: !47, file: !47, line: 227, baseType: !97, size: 4096, elements: !55)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !99, size: 64, offset: 320)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !101)
!101 = !DICompositeType(tag: DW_TAG_array_type, scope: !47, file: !47, line: 227, baseType: !102, size: 4096, elements: !55)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !70)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !105)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !106)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !47, file: !47, line: 321, size: 256, elements: !107)
!107 = !{!108, !109, !110, !111, !112, !113, !114}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !53, size: 32)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !53, size: 32, offset: 32)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !82, size: 16, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !82, size: 16, offset: 80)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !53, size: 32, offset: 96)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !58, size: 64, offset: 128)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !53, size: 32, offset: 192)
!115 = !DILocation(line: 10, column: 8, scope: !39)
!116 = !DILocation(line: 11, column: 8, scope: !39)
!117 = !DILocation(line: 12, column: 8, scope: !39)
!118 = !DILocation(line: 13, column: 8, scope: !39)
!119 = !DILocation(line: 15, column: 8, scope: !39)
!120 = !DILocation(line: 19, column: 8, scope: !39)
!121 = distinct !DISubprogram(name: "infer_dispatch_1_conv_16x32x32x3x3x3_f32", linkageName: "infer_dispatch_1_conv_16x32x32x3x3x3_f32", scope: !3, file: !3, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!122 = !DILocation(line: 21, column: 8, scope: !121)
!123 = !DILocation(line: 20, column: 8, scope: !121)
!124 = !DILocation(line: 14, column: 8, scope: !121)
!125 = !DILocation(line: 15, column: 8, scope: !121)
!126 = !DILocation(line: 16, column: 8, scope: !121)
!127 = !DILocation(line: 9, column: 8, scope: !121)
!128 = !DILocation(line: 27, column: 8, scope: !121)
!129 = !DILocation(line: 23, column: 10, scope: !121)
!130 = !DILocation(line: 24, column: 10, scope: !121)
!131 = !DILocation(line: 29, column: 10, scope: !121)
!132 = !DILocation(line: 30, column: 10, scope: !121)
!133 = !DILocation(line: 31, column: 10, scope: !121)
!134 = !DILocation(line: 35, column: 8, scope: !121)
!135 = distinct !DISubprogram(name: "infer_dispatch_2_slow_memcpy", linkageName: "infer_dispatch_2_slow_memcpy", scope: !5, file: !5, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!136 = !DILocation(line: 11, column: 8, scope: !135)
!137 = !DILocation(line: 12, column: 8, scope: !135)
!138 = !DILocation(line: 13, column: 8, scope: !135)
!139 = !DILocation(line: 14, column: 8, scope: !135)
!140 = !DILocation(line: 16, column: 8, scope: !135)
!141 = !DILocation(line: 20, column: 8, scope: !135)
!142 = distinct !DISubprogram(name: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", scope: !7, file: !7, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!143 = !DILocation(line: 21, column: 8, scope: !142)
!144 = !DILocation(line: 20, column: 8, scope: !142)
!145 = !DILocation(line: 14, column: 8, scope: !142)
!146 = !DILocation(line: 15, column: 8, scope: !142)
!147 = !DILocation(line: 16, column: 8, scope: !142)
!148 = !DILocation(line: 9, column: 8, scope: !142)
!149 = !DILocation(line: 27, column: 8, scope: !142)
!150 = !DILocation(line: 23, column: 10, scope: !142)
!151 = !DILocation(line: 24, column: 10, scope: !142)
!152 = !DILocation(line: 29, column: 10, scope: !142)
!153 = !DILocation(line: 30, column: 10, scope: !142)
!154 = !DILocation(line: 31, column: 10, scope: !142)
!155 = !DILocation(line: 35, column: 8, scope: !142)
!156 = distinct !DISubprogram(name: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", scope: !9, file: !9, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!157 = !DILocation(line: 24, column: 8, scope: !156)
!158 = !DILocation(line: 23, column: 8, scope: !156)
!159 = !DILocation(line: 15, column: 8, scope: !156)
!160 = !DILocation(line: 16, column: 8, scope: !156)
!161 = !DILocation(line: 17, column: 8, scope: !156)
!162 = !DILocation(line: 18, column: 8, scope: !156)
!163 = !DILocation(line: 9, column: 8, scope: !156)
!164 = !DILocation(line: 30, column: 8, scope: !156)
!165 = !DILocation(line: 26, column: 10, scope: !156)
!166 = !DILocation(line: 27, column: 10, scope: !156)
!167 = !DILocation(line: 32, column: 10, scope: !156)
!168 = !DILocation(line: 33, column: 10, scope: !156)
!169 = !DILocation(line: 34, column: 10, scope: !156)
!170 = !DILocation(line: 35, column: 10, scope: !156)
!171 = !DILocation(line: 39, column: 8, scope: !156)
!172 = distinct !DISubprogram(name: "infer_dispatch_5_slow_memcpy", linkageName: "infer_dispatch_5_slow_memcpy", scope: !11, file: !11, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!173 = !DILocation(line: 11, column: 8, scope: !172)
!174 = !DILocation(line: 12, column: 8, scope: !172)
!175 = !DILocation(line: 13, column: 8, scope: !172)
!176 = !DILocation(line: 14, column: 8, scope: !172)
!177 = !DILocation(line: 16, column: 8, scope: !172)
!178 = !DILocation(line: 20, column: 8, scope: !172)
!179 = distinct !DISubprogram(name: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", linkageName: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", scope: !13, file: !13, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!180 = !DILocation(line: 21, column: 8, scope: !179)
!181 = !DILocation(line: 20, column: 8, scope: !179)
!182 = !DILocation(line: 14, column: 8, scope: !179)
!183 = !DILocation(line: 15, column: 8, scope: !179)
!184 = !DILocation(line: 16, column: 8, scope: !179)
!185 = !DILocation(line: 9, column: 8, scope: !179)
!186 = !DILocation(line: 27, column: 8, scope: !179)
!187 = !DILocation(line: 23, column: 10, scope: !179)
!188 = !DILocation(line: 24, column: 10, scope: !179)
!189 = !DILocation(line: 29, column: 10, scope: !179)
!190 = !DILocation(line: 30, column: 10, scope: !179)
!191 = !DILocation(line: 31, column: 10, scope: !179)
!192 = !DILocation(line: 35, column: 8, scope: !179)
!193 = distinct !DISubprogram(name: "infer_dispatch_7_matmul_like_32x16x16x16_f32", linkageName: "infer_dispatch_7_matmul_like_32x16x16x16_f32", scope: !15, file: !15, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!194 = !DILocation(line: 13, column: 8, scope: !193)
!195 = !DILocation(line: 14, column: 8, scope: !193)
!196 = !DILocation(line: 15, column: 8, scope: !193)
!197 = !DILocation(line: 20, column: 8, scope: !193)
!198 = !DILocation(line: 23, column: 10, scope: !193)
!199 = !DILocation(line: 27, column: 8, scope: !193)
!200 = distinct !DISubprogram(name: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", linkageName: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", scope: !17, file: !17, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!201 = !DILocation(line: 25, column: 8, scope: !200)
!202 = !DILocation(line: 24, column: 8, scope: !200)
!203 = !DILocation(line: 16, column: 8, scope: !200)
!204 = !DILocation(line: 17, column: 8, scope: !200)
!205 = !DILocation(line: 18, column: 8, scope: !200)
!206 = !DILocation(line: 19, column: 8, scope: !200)
!207 = !DILocation(line: 9, column: 8, scope: !200)
!208 = !DILocation(line: 31, column: 8, scope: !200)
!209 = !DILocation(line: 27, column: 10, scope: !200)
!210 = !DILocation(line: 28, column: 10, scope: !200)
!211 = !DILocation(line: 33, column: 10, scope: !200)
!212 = !DILocation(line: 34, column: 10, scope: !200)
!213 = !DILocation(line: 35, column: 10, scope: !200)
!214 = !DILocation(line: 36, column: 10, scope: !200)
!215 = !DILocation(line: 37, column: 10, scope: !200)
!216 = !DILocation(line: 41, column: 8, scope: !200)
!217 = distinct !DISubprogram(name: "infer_dispatch_9_slow_memcpy", linkageName: "infer_dispatch_9_slow_memcpy", scope: !19, file: !19, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!218 = !DILocation(line: 11, column: 8, scope: !217)
!219 = !DILocation(line: 12, column: 8, scope: !217)
!220 = !DILocation(line: 13, column: 8, scope: !217)
!221 = !DILocation(line: 14, column: 8, scope: !217)
!222 = !DILocation(line: 16, column: 8, scope: !217)
!223 = !DILocation(line: 20, column: 8, scope: !217)
!224 = distinct !DISubprogram(name: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", linkageName: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", scope: !21, file: !21, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!225 = !DILocation(line: 21, column: 8, scope: !224)
!226 = !DILocation(line: 20, column: 8, scope: !224)
!227 = !DILocation(line: 14, column: 8, scope: !224)
!228 = !DILocation(line: 15, column: 8, scope: !224)
!229 = !DILocation(line: 16, column: 8, scope: !224)
!230 = !DILocation(line: 9, column: 8, scope: !224)
!231 = !DILocation(line: 27, column: 8, scope: !224)
!232 = !DILocation(line: 23, column: 10, scope: !224)
!233 = !DILocation(line: 24, column: 10, scope: !224)
!234 = !DILocation(line: 29, column: 10, scope: !224)
!235 = !DILocation(line: 30, column: 10, scope: !224)
!236 = !DILocation(line: 31, column: 10, scope: !224)
!237 = !DILocation(line: 35, column: 8, scope: !224)
!238 = distinct !DISubprogram(name: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", linkageName: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", scope: !23, file: !23, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!239 = !DILocation(line: 13, column: 8, scope: !238)
!240 = !DILocation(line: 14, column: 8, scope: !238)
!241 = !DILocation(line: 15, column: 8, scope: !238)
!242 = !DILocation(line: 20, column: 8, scope: !238)
!243 = !DILocation(line: 9, column: 8, scope: !238)
!244 = !DILocation(line: 22, column: 10, scope: !238)
!245 = !DILocation(line: 23, column: 10, scope: !238)
!246 = !DILocation(line: 27, column: 8, scope: !238)
!247 = distinct !DISubprogram(name: "infer_dispatch_12_matmul_like_64x8x8x32_f32", linkageName: "infer_dispatch_12_matmul_like_64x8x8x32_f32", scope: !25, file: !25, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !24)
!248 = !DILocation(line: 13, column: 8, scope: !247)
!249 = !DILocation(line: 14, column: 8, scope: !247)
!250 = !DILocation(line: 15, column: 8, scope: !247)
!251 = !DILocation(line: 20, column: 8, scope: !247)
!252 = !DILocation(line: 23, column: 10, scope: !247)
!253 = !DILocation(line: 27, column: 8, scope: !247)
!254 = distinct !DISubprogram(name: "infer_dispatch_13_reduction_64x64_f32", linkageName: "infer_dispatch_13_reduction_64x64_f32", scope: !27, file: !27, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !26)
!255 = !DILocation(line: 16, column: 8, scope: !254)
!256 = !DILocation(line: 17, column: 8, scope: !254)
!257 = !DILocation(line: 18, column: 8, scope: !254)
!258 = !DILocation(line: 23, column: 8, scope: !254)
!259 = !DILocation(line: 25, column: 10, scope: !254)
!260 = !DILocation(line: 26, column: 10, scope: !254)
!261 = !DILocation(line: 27, column: 10, scope: !254)
!262 = !DILocation(line: 28, column: 10, scope: !254)
!263 = !DILocation(line: 29, column: 10, scope: !254)
!264 = !DILocation(line: 30, column: 10, scope: !254)
!265 = !DILocation(line: 35, column: 10, scope: !254)
!266 = !DILocation(line: 39, column: 8, scope: !254)
!267 = distinct !DISubprogram(name: "infer_dispatch_14_matmul_1x10x64_f32", linkageName: "infer_dispatch_14_matmul_1x10x64_f32", scope: !29, file: !29, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !28)
!268 = !DILocation(line: 14, column: 8, scope: !267)
!269 = !DILocation(line: 15, column: 8, scope: !267)
!270 = !DILocation(line: 16, column: 8, scope: !267)
!271 = !DILocation(line: 21, column: 8, scope: !267)
!272 = !DILocation(line: 22, column: 8, scope: !267)
!273 = !DILocation(line: 24, column: 10, scope: !267)
!274 = !DILocation(line: 28, column: 8, scope: !267)
!275 = distinct !DISubprogram(name: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", linkageName: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", scope: !31, file: !31, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !30)
!276 = !DILocation(line: 13, column: 8, scope: !275)
!277 = !DILocation(line: 14, column: 8, scope: !275)
!278 = !DILocation(line: 19, column: 8, scope: !275)
!279 = !DILocation(line: 21, column: 10, scope: !275)
!280 = !DILocation(line: 25, column: 8, scope: !275)
!281 = !DILocation(line: 27, column: 10, scope: !275)
!282 = !DILocation(line: 28, column: 10, scope: !275)
!283 = !DILocation(line: 29, column: 10, scope: !275)
!284 = !DILocation(line: 32, column: 8, scope: !275)
!285 = !DILocation(line: 34, column: 10, scope: !275)
!286 = !DILocation(line: 35, column: 10, scope: !275)
!287 = !DILocation(line: 36, column: 10, scope: !275)
!288 = !DILocation(line: 40, column: 8, scope: !275)
!289 = !{!290, !290, i64 0}
!290 = !{!"short", !37, i64 0}
!291 = !{!292, !292, i64 0}
!292 = !{!"float", !37, i64 0}
!293 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!294 = !{!295, !296, i64 296}
!295 = !{!"exp2f_data", !37, i64 0, !296, i64 256, !37, i64 264, !296, i64 288, !296, i64 296, !37, i64 304}
!296 = !{!"double", !37, i64 0}
!297 = !{!295, !296, i64 288}
!298 = !{!299, !299, i64 0}
!299 = !{!"long", !37, i64 0}
!300 = !{!296, !296, i64 0}
!301 = !{!"branch_weights", i32 4001, i32 4000000}
!302 = !{!303, !296, i64 0}
!303 = !{!"", !296, i64 0, !296, i64 8}
!304 = !{!303, !296, i64 8}
!305 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!306 = !{!295, !296, i64 256}
