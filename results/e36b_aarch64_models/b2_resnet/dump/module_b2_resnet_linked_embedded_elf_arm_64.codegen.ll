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

define internal i32 @infer_dispatch_0_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !33 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !109
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !109
  %6 = load ptr, ptr %5, align 8, !dbg !109
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !110
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !111
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !111
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !111
  %10 = load ptr, ptr %9, align 8, !dbg !111
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !112
  br label %11, !dbg !113

11:                                               ; preds = %37, %3
  %12 = phi i64 [ %38, %37 ], [ 0, %3 ], !dbg !113
  %13 = icmp slt i64 %12, 3, !dbg !113
  br i1 %13, label %14, label %39, !dbg !113

14:                                               ; preds = %35, %11
  %15 = phi i64 [ %36, %35 ], [ 0, %11 ], !dbg !113
  %16 = icmp slt i64 %15, 32, !dbg !113
  br i1 %16, label %17, label %37, !dbg !113

17:                                               ; preds = %20, %14
  %18 = phi i64 [ %34, %20 ], [ 0, %14 ], !dbg !113
  %19 = icmp slt i64 %18, 32, !dbg !113
  br i1 %19, label %20, label %35, !dbg !113

20:                                               ; preds = %17
  %21 = mul i64 %12, 1024, !dbg !113
  %22 = mul i64 %15, 32, !dbg !113
  %23 = add i64 %21, %22, !dbg !113
  %24 = add i64 %23, %18, !dbg !113
  %25 = getelementptr float, ptr %6, i64 %24, !dbg !113
  %26 = load <4 x float>, ptr %25, align 4, !dbg !113
  %27 = add i64 %15, 1, !dbg !113
  %28 = add i64 %18, 1, !dbg !113
  %29 = mul i64 %12, 1156, !dbg !113
  %30 = mul i64 %27, 34, !dbg !113
  %31 = add i64 %29, %30, !dbg !113
  %32 = add i64 %31, %28, !dbg !113
  %33 = getelementptr float, ptr %10, i64 %32, !dbg !113
  store <4 x float> %26, ptr %33, align 4, !dbg !113
  %34 = add i64 %18, 4, !dbg !113
  br label %17, !dbg !113

35:                                               ; preds = %17
  %36 = add i64 %15, 1, !dbg !113
  br label %14, !dbg !113

37:                                               ; preds = %14
  %38 = add i64 %12, 1, !dbg !113
  br label %11, !dbg !113

39:                                               ; preds = %11
  ret i32 0, !dbg !114
}

define internal i32 @infer_dispatch_1_conv_16x32x32x3x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !115 {
  %4 = alloca float, i64 4, align 64, !dbg !116
  %5 = alloca float, i64 4, align 64, !dbg !117
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !118
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !118
  %8 = load ptr, ptr %7, align 8, !dbg !118
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !118
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !119
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !119
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !119
  %12 = load ptr, ptr %11, align 8, !dbg !119
  %13 = getelementptr float, ptr %12, i64 71680, !dbg !119
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !119
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !120
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !120
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !120
  %17 = load ptr, ptr %16, align 8, !dbg !120
  %18 = getelementptr float, ptr %17, i64 3472, !dbg !120
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !120
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !116
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !116
  %21 = zext i32 %20 to i64, !dbg !116
  %22 = sdiv i64 %21, 2, !dbg !116
  %23 = mul i64 %22, 2, !dbg !116
  %24 = icmp ne i64 %21, %23, !dbg !116
  %25 = icmp slt i64 %21, 0, !dbg !116
  %26 = and i1 %24, %25, !dbg !116
  %27 = add i64 %22, -1, !dbg !116
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !116
  %29 = srem i64 %21, 2, !dbg !116
  %30 = icmp slt i64 %29, 0, !dbg !116
  %31 = add nsw i64 %29, 2, !dbg !116
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !116
  %33 = mul nsw i64 %28, 2, !dbg !116
  %34 = mul nsw i64 %32, 16, !dbg !116
  %35 = getelementptr float, ptr %5, i64 0, !dbg !121
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !121
  br label %36, !dbg !116

36:                                               ; preds = %120, %3
  %37 = phi i64 [ %121, %120 ], [ 0, %3 ], !dbg !116
  %38 = icmp slt i64 %37, 2, !dbg !116
  br i1 %38, label %39, label %122, !dbg !116

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !116
  %41 = getelementptr float, ptr @__constant_16xf32, i64 %40, !dbg !122
  %42 = load <1 x float>, ptr %41, align 4, !dbg !122
  br label %43, !dbg !116

43:                                               ; preds = %118, %39
  %44 = phi i64 [ %119, %118 ], [ 0, %39 ], !dbg !116
  %45 = icmp slt i64 %44, 16, !dbg !116
  br i1 %45, label %46, label %120, !dbg !116

46:                                               ; preds = %102, %43
  %47 = phi i64 [ %117, %102 ], [ 0, %43 ], !dbg !116
  %48 = icmp slt i64 %47, 32, !dbg !116
  br i1 %48, label %49, label %118, !dbg !116

49:                                               ; preds = %52, %46
  %50 = phi i64 [ %57, %52 ], [ 0, %46 ], !dbg !116
  %51 = icmp slt i64 %50, 4, !dbg !116
  br i1 %51, label %52, label %58, !dbg !116

52:                                               ; preds = %49
  %53 = add nuw nsw i64 0, %50, !dbg !116
  %54 = getelementptr inbounds nuw float, ptr %5, i64 %53, !dbg !116
  %55 = load float, ptr %54, align 4, !dbg !116
  %56 = getelementptr inbounds nuw float, ptr %4, i64 %53, !dbg !116
  store float %55, ptr %56, align 4, !dbg !116
  %57 = add i64 %50, 1, !dbg !116
  br label %49, !dbg !116

58:                                               ; preds = %100, %49
  %59 = phi i64 [ %101, %100 ], [ 0, %49 ], !dbg !116
  %60 = icmp slt i64 %59, 3, !dbg !116
  br i1 %60, label %61, label %102, !dbg !116

61:                                               ; preds = %98, %58
  %62 = phi i64 [ %99, %98 ], [ 0, %58 ], !dbg !116
  %63 = icmp slt i64 %62, 3, !dbg !116
  br i1 %63, label %64, label %100, !dbg !116

64:                                               ; preds = %61
  %65 = add i64 %62, %44, !dbg !116
  %66 = add i64 %65, %34, !dbg !116
  br label %67, !dbg !116

67:                                               ; preds = %96, %64
  %68 = phi i64 [ %97, %96 ], [ 0, %64 ], !dbg !116
  %69 = icmp slt i64 %68, 4, !dbg !116
  br i1 %69, label %70, label %98, !dbg !116

70:                                               ; preds = %73, %67
  %71 = phi i64 [ %95, %73 ], [ 0, %67 ], !dbg !116
  %72 = icmp slt i64 %71, 3, !dbg !116
  br i1 %72, label %73, label %96, !dbg !116

73:                                               ; preds = %70
  %74 = add i64 %47, %68, !dbg !116
  %75 = add i64 %74, %71, !dbg !116
  %76 = mul nuw nsw i64 %59, 1156, !dbg !116
  %77 = mul nuw nsw i64 %66, 34, !dbg !116
  %78 = add nuw nsw i64 %76, %77, !dbg !116
  %79 = add nuw nsw i64 %78, %75, !dbg !116
  %80 = getelementptr inbounds nuw float, ptr %8, i64 %79, !dbg !116
  %81 = load float, ptr %80, align 4, !dbg !116
  %82 = mul nuw nsw i64 %40, 27, !dbg !116
  %83 = mul nuw nsw i64 %59, 9, !dbg !116
  %84 = add nuw nsw i64 %82, %83, !dbg !116
  %85 = mul nuw nsw i64 %62, 3, !dbg !116
  %86 = add nuw nsw i64 %84, %85, !dbg !116
  %87 = add nuw nsw i64 %86, %71, !dbg !116
  %88 = getelementptr inbounds nuw float, ptr %13, i64 %87, !dbg !116
  %89 = load float, ptr %88, align 4, !dbg !116
  %90 = add nuw nsw i64 0, %68, !dbg !116
  %91 = getelementptr inbounds nuw float, ptr %4, i64 %90, !dbg !116
  %92 = load float, ptr %91, align 4, !dbg !116
  %93 = fmul contract float %81, %89, !dbg !123
  %94 = fadd contract float %92, %93, !dbg !124
  store float %94, ptr %91, align 4, !dbg !116
  %95 = add i64 %71, 1, !dbg !116
  br label %70, !dbg !116

96:                                               ; preds = %70
  %97 = add i64 %68, 1, !dbg !116
  br label %67, !dbg !116

98:                                               ; preds = %67
  %99 = add i64 %62, 1, !dbg !116
  br label %61, !dbg !116

100:                                              ; preds = %61
  %101 = add i64 %59, 1, !dbg !116
  br label %58, !dbg !116

102:                                              ; preds = %58
  %103 = getelementptr float, ptr %4, i64 0, !dbg !122
  %104 = load <4 x float>, ptr %103, align 4, !dbg !122
  %105 = extractelement <1 x float> %42, i64 0, !dbg !125
  %106 = insertelement <4 x float> poison, float %105, i32 0, !dbg !125
  %107 = shufflevector <4 x float> %106, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !125
  %108 = fadd contract <4 x float> %104, %107, !dbg !125
  %109 = fcmp ugt <4 x float> %108, zeroinitializer, !dbg !126
  %110 = select <4 x i1> %109, <4 x float> %108, <4 x float> zeroinitializer, !dbg !127
  %111 = add i64 %34, %44, !dbg !116
  %112 = mul i64 %40, 1024, !dbg !116
  %113 = mul i64 %111, 32, !dbg !116
  %114 = add i64 %112, %113, !dbg !116
  %115 = add i64 %114, %47, !dbg !116
  %116 = getelementptr float, ptr %18, i64 %115, !dbg !116
  store <4 x float> %110, ptr %116, align 4, !dbg !116
  %117 = add i64 %47, 4, !dbg !116
  br label %46, !dbg !116

118:                                              ; preds = %46
  %119 = add i64 %44, 1, !dbg !116
  br label %43, !dbg !116

120:                                              ; preds = %43
  %121 = add i64 %37, 1, !dbg !116
  br label %36, !dbg !116

122:                                              ; preds = %36
  ret i32 0, !dbg !128
}

define internal i32 @infer_dispatch_2_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !129 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !130
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !130
  %6 = load ptr, ptr %5, align 8, !dbg !130
  %7 = getelementptr float, ptr %6, i64 3472, !dbg !131
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !131
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !132
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !132
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !132
  %11 = load ptr, ptr %10, align 8, !dbg !132
  %12 = getelementptr float, ptr %11, i64 19856, !dbg !133
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !133
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !134
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !134
  %15 = zext i32 %14 to i64, !dbg !134
  %16 = sdiv i64 %15, 2, !dbg !134
  %17 = mul i64 %16, 2, !dbg !134
  %18 = icmp ne i64 %15, %17, !dbg !134
  %19 = icmp slt i64 %15, 0, !dbg !134
  %20 = and i1 %18, %19, !dbg !134
  %21 = add i64 %16, -1, !dbg !134
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !134
  %23 = srem i64 %15, 2, !dbg !134
  %24 = icmp slt i64 %23, 0, !dbg !134
  %25 = add nsw i64 %23, 2, !dbg !134
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !134
  %27 = mul nsw i64 %22, 8, !dbg !134
  %28 = mul nsw i64 %26, 16, !dbg !134
  br label %29, !dbg !134

29:                                               ; preds = %57, %3
  %30 = phi i64 [ %58, %57 ], [ 0, %3 ], !dbg !134
  %31 = icmp slt i64 %30, 8, !dbg !134
  br i1 %31, label %32, label %59, !dbg !134

32:                                               ; preds = %55, %29
  %33 = phi i64 [ %56, %55 ], [ 0, %29 ], !dbg !134
  %34 = icmp slt i64 %33, 16, !dbg !134
  br i1 %34, label %35, label %57, !dbg !134

35:                                               ; preds = %38, %32
  %36 = phi i64 [ %54, %38 ], [ 0, %32 ], !dbg !134
  %37 = icmp slt i64 %36, 32, !dbg !134
  br i1 %37, label %38, label %55, !dbg !134

38:                                               ; preds = %35
  %39 = add i64 %27, %30, !dbg !134
  %40 = add i64 %28, %33, !dbg !134
  %41 = mul i64 %39, 1024, !dbg !134
  %42 = mul i64 %40, 32, !dbg !134
  %43 = add i64 %41, %42, !dbg !134
  %44 = add i64 %43, %36, !dbg !134
  %45 = getelementptr float, ptr %7, i64 %44, !dbg !134
  %46 = load <4 x float>, ptr %45, align 4, !dbg !134
  %47 = add i64 %40, 1, !dbg !134
  %48 = add i64 %36, 1, !dbg !134
  %49 = mul i64 %39, 1156, !dbg !134
  %50 = mul i64 %47, 34, !dbg !134
  %51 = add i64 %49, %50, !dbg !134
  %52 = add i64 %51, %48, !dbg !134
  %53 = getelementptr float, ptr %12, i64 %52, !dbg !134
  store <4 x float> %46, ptr %53, align 4, !dbg !134
  %54 = add i64 %36, 4, !dbg !134
  br label %35, !dbg !134

55:                                               ; preds = %35
  %56 = add i64 %33, 1, !dbg !134
  br label %32, !dbg !134

57:                                               ; preds = %32
  %58 = add i64 %30, 1, !dbg !134
  br label %29, !dbg !134

59:                                               ; preds = %29
  ret i32 0, !dbg !135
}

define internal i32 @infer_dispatch_3_conv_16x32x32x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !136 {
  %4 = alloca float, i64 4, align 64, !dbg !137
  %5 = alloca float, i64 4, align 64, !dbg !138
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !139
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !139
  %8 = load ptr, ptr %7, align 8, !dbg !139
  %9 = getelementptr float, ptr %8, i64 19856, !dbg !139
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !139
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !140
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !140
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !140
  %13 = load ptr, ptr %12, align 8, !dbg !140
  %14 = getelementptr float, ptr %13, i64 4864, !dbg !140
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !140
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !141
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !141
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !141
  %18 = load ptr, ptr %17, align 8, !dbg !141
  %19 = getelementptr float, ptr %18, i64 38352, !dbg !141
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !141
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !137
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !137
  %22 = zext i32 %21 to i64, !dbg !137
  %23 = sdiv i64 %22, 2, !dbg !137
  %24 = mul i64 %23, 2, !dbg !137
  %25 = icmp ne i64 %22, %24, !dbg !137
  %26 = icmp slt i64 %22, 0, !dbg !137
  %27 = and i1 %25, %26, !dbg !137
  %28 = add i64 %23, -1, !dbg !137
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !137
  %30 = srem i64 %22, 2, !dbg !137
  %31 = icmp slt i64 %30, 0, !dbg !137
  %32 = add nsw i64 %30, 2, !dbg !137
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !137
  %34 = mul nsw i64 %29, 2, !dbg !137
  %35 = mul nsw i64 %33, 16, !dbg !137
  %36 = getelementptr float, ptr %5, i64 0, !dbg !142
  store <4 x float> zeroinitializer, ptr %36, align 4, !dbg !142
  br label %37, !dbg !137

37:                                               ; preds = %123, %3
  %38 = phi i64 [ %124, %123 ], [ 0, %3 ], !dbg !137
  %39 = icmp slt i64 %38, 2, !dbg !137
  br i1 %39, label %40, label %125, !dbg !137

40:                                               ; preds = %37
  %41 = add i64 %38, %34, !dbg !137
  %42 = getelementptr float, ptr @__constant_16xf32_0, i64 %41, !dbg !143
  %43 = load <1 x float>, ptr %42, align 4, !dbg !143
  br label %44, !dbg !137

44:                                               ; preds = %121, %40
  %45 = phi i64 [ %122, %121 ], [ 0, %40 ], !dbg !137
  %46 = icmp slt i64 %45, 16, !dbg !137
  br i1 %46, label %47, label %123, !dbg !137

47:                                               ; preds = %103, %44
  %48 = phi i64 [ %120, %103 ], [ 0, %44 ], !dbg !137
  %49 = icmp slt i64 %48, 32, !dbg !137
  br i1 %49, label %50, label %121, !dbg !137

50:                                               ; preds = %53, %47
  %51 = phi i64 [ %58, %53 ], [ 0, %47 ], !dbg !137
  %52 = icmp slt i64 %51, 4, !dbg !137
  br i1 %52, label %53, label %59, !dbg !137

53:                                               ; preds = %50
  %54 = add nuw nsw i64 0, %51, !dbg !137
  %55 = getelementptr inbounds nuw float, ptr %5, i64 %54, !dbg !137
  %56 = load float, ptr %55, align 4, !dbg !137
  %57 = getelementptr inbounds nuw float, ptr %4, i64 %54, !dbg !137
  store float %56, ptr %57, align 4, !dbg !137
  %58 = add i64 %51, 1, !dbg !137
  br label %50, !dbg !137

59:                                               ; preds = %101, %50
  %60 = phi i64 [ %102, %101 ], [ 0, %50 ], !dbg !137
  %61 = icmp slt i64 %60, 16, !dbg !137
  br i1 %61, label %62, label %103, !dbg !137

62:                                               ; preds = %99, %59
  %63 = phi i64 [ %100, %99 ], [ 0, %59 ], !dbg !137
  %64 = icmp slt i64 %63, 3, !dbg !137
  br i1 %64, label %65, label %101, !dbg !137

65:                                               ; preds = %62
  %66 = add i64 %63, %45, !dbg !137
  %67 = add i64 %66, %35, !dbg !137
  br label %68, !dbg !137

68:                                               ; preds = %97, %65
  %69 = phi i64 [ %98, %97 ], [ 0, %65 ], !dbg !137
  %70 = icmp slt i64 %69, 4, !dbg !137
  br i1 %70, label %71, label %99, !dbg !137

71:                                               ; preds = %74, %68
  %72 = phi i64 [ %96, %74 ], [ 0, %68 ], !dbg !137
  %73 = icmp slt i64 %72, 3, !dbg !137
  br i1 %73, label %74, label %97, !dbg !137

74:                                               ; preds = %71
  %75 = add i64 %48, %69, !dbg !137
  %76 = add i64 %75, %72, !dbg !137
  %77 = mul nuw nsw i64 %60, 1156, !dbg !137
  %78 = mul nuw nsw i64 %67, 34, !dbg !137
  %79 = add nuw nsw i64 %77, %78, !dbg !137
  %80 = add nuw nsw i64 %79, %76, !dbg !137
  %81 = getelementptr inbounds nuw float, ptr %9, i64 %80, !dbg !137
  %82 = load float, ptr %81, align 4, !dbg !137
  %83 = mul nuw nsw i64 %41, 144, !dbg !137
  %84 = mul nuw nsw i64 %60, 9, !dbg !137
  %85 = add nuw nsw i64 %83, %84, !dbg !137
  %86 = mul nuw nsw i64 %63, 3, !dbg !137
  %87 = add nuw nsw i64 %85, %86, !dbg !137
  %88 = add nuw nsw i64 %87, %72, !dbg !137
  %89 = getelementptr inbounds nuw float, ptr %14, i64 %88, !dbg !137
  %90 = load float, ptr %89, align 4, !dbg !137
  %91 = add nuw nsw i64 0, %69, !dbg !137
  %92 = getelementptr inbounds nuw float, ptr %4, i64 %91, !dbg !137
  %93 = load float, ptr %92, align 4, !dbg !137
  %94 = fmul contract float %82, %90, !dbg !144
  %95 = fadd contract float %93, %94, !dbg !145
  store float %95, ptr %92, align 4, !dbg !137
  %96 = add i64 %72, 1, !dbg !137
  br label %71, !dbg !137

97:                                               ; preds = %71
  %98 = add i64 %69, 1, !dbg !137
  br label %68, !dbg !137

99:                                               ; preds = %68
  %100 = add i64 %63, 1, !dbg !137
  br label %62, !dbg !137

101:                                              ; preds = %62
  %102 = add i64 %60, 1, !dbg !137
  br label %59, !dbg !137

103:                                              ; preds = %59
  %104 = getelementptr float, ptr %4, i64 0, !dbg !143
  %105 = load <4 x float>, ptr %104, align 4, !dbg !143
  %106 = extractelement <1 x float> %43, i64 0, !dbg !146
  %107 = insertelement <4 x float> poison, float %106, i32 0, !dbg !146
  %108 = shufflevector <4 x float> %107, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !146
  %109 = fadd contract <4 x float> %105, %108, !dbg !146
  %110 = fcmp ugt <4 x float> %109, zeroinitializer, !dbg !147
  %111 = select <4 x i1> %110, <4 x float> %109, <4 x float> zeroinitializer, !dbg !148
  %112 = add i64 %35, %45, !dbg !137
  %113 = add i64 %112, 1, !dbg !137
  %114 = add i64 %48, 1, !dbg !137
  %115 = mul i64 %41, 1156, !dbg !137
  %116 = mul i64 %113, 34, !dbg !137
  %117 = add i64 %115, %116, !dbg !137
  %118 = add i64 %117, %114, !dbg !137
  %119 = getelementptr float, ptr %19, i64 %118, !dbg !137
  store <4 x float> %111, ptr %119, align 4, !dbg !137
  %120 = add i64 %48, 4, !dbg !137
  br label %47, !dbg !137

121:                                              ; preds = %47
  %122 = add i64 %45, 1, !dbg !137
  br label %44, !dbg !137

123:                                              ; preds = %44
  %124 = add i64 %38, 1, !dbg !137
  br label %37, !dbg !137

125:                                              ; preds = %37
  ret i32 0, !dbg !149
}

define internal i32 @infer_dispatch_4_conv_16x32x32x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !150 {
  %4 = alloca float, i64 4, align 64, !dbg !151
  %5 = alloca float, i64 4, align 64, !dbg !152
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !153
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !153
  %8 = load ptr, ptr %7, align 8, !dbg !153
  %9 = getelementptr float, ptr %8, i64 38352, !dbg !153
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !153
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !154
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !154
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !154
  %13 = load ptr, ptr %12, align 8, !dbg !154
  %14 = getelementptr float, ptr %13, i64 2560, !dbg !154
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !154
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !155
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !155
  %17 = load ptr, ptr %16, align 8, !dbg !155
  %18 = getelementptr float, ptr %17, i64 3472, !dbg !155
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !155
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !156
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !156
  %21 = getelementptr ptr, ptr %20, i32 2, !dbg !156
  %22 = load ptr, ptr %21, align 8, !dbg !156
  %23 = getelementptr float, ptr %22, i64 19856, !dbg !156
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !156
  %24 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !151
  %25 = extractvalue %iree_hal_executable_workgroup_state_v0_t %24, 0, !dbg !151
  %26 = zext i32 %25 to i64, !dbg !151
  %27 = sdiv i64 %26, 2, !dbg !151
  %28 = mul i64 %27, 2, !dbg !151
  %29 = icmp ne i64 %26, %28, !dbg !151
  %30 = icmp slt i64 %26, 0, !dbg !151
  %31 = and i1 %29, %30, !dbg !151
  %32 = add i64 %27, -1, !dbg !151
  %33 = select i1 %31, i64 %32, i64 %27, !dbg !151
  %34 = srem i64 %26, 2, !dbg !151
  %35 = icmp slt i64 %34, 0, !dbg !151
  %36 = add nsw i64 %34, 2, !dbg !151
  %37 = select i1 %35, i64 %36, i64 %34, !dbg !151
  %38 = mul nsw i64 %33, 2, !dbg !151
  %39 = mul nsw i64 %37, 16, !dbg !151
  %40 = getelementptr float, ptr %5, i64 0, !dbg !157
  store <4 x float> zeroinitializer, ptr %40, align 4, !dbg !157
  br label %41, !dbg !151

41:                                               ; preds = %128, %3
  %42 = phi i64 [ %129, %128 ], [ 0, %3 ], !dbg !151
  %43 = icmp slt i64 %42, 2, !dbg !151
  br i1 %43, label %44, label %130, !dbg !151

44:                                               ; preds = %41
  %45 = add i64 %42, %38, !dbg !151
  %46 = getelementptr float, ptr @__constant_16xf32_1, i64 %45, !dbg !158
  %47 = load <1 x float>, ptr %46, align 4, !dbg !158
  br label %48, !dbg !151

48:                                               ; preds = %126, %44
  %49 = phi i64 [ %127, %126 ], [ 0, %44 ], !dbg !151
  %50 = icmp slt i64 %49, 16, !dbg !151
  br i1 %50, label %51, label %128, !dbg !151

51:                                               ; preds = %107, %48
  %52 = phi i64 [ %125, %107 ], [ 0, %48 ], !dbg !151
  %53 = icmp slt i64 %52, 32, !dbg !151
  br i1 %53, label %54, label %126, !dbg !151

54:                                               ; preds = %57, %51
  %55 = phi i64 [ %62, %57 ], [ 0, %51 ], !dbg !151
  %56 = icmp slt i64 %55, 4, !dbg !151
  br i1 %56, label %57, label %63, !dbg !151

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !151
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !151
  %60 = load float, ptr %59, align 4, !dbg !151
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !151
  store float %60, ptr %61, align 4, !dbg !151
  %62 = add i64 %55, 1, !dbg !151
  br label %54, !dbg !151

63:                                               ; preds = %105, %54
  %64 = phi i64 [ %106, %105 ], [ 0, %54 ], !dbg !151
  %65 = icmp slt i64 %64, 16, !dbg !151
  br i1 %65, label %66, label %107, !dbg !151

66:                                               ; preds = %103, %63
  %67 = phi i64 [ %104, %103 ], [ 0, %63 ], !dbg !151
  %68 = icmp slt i64 %67, 3, !dbg !151
  br i1 %68, label %69, label %105, !dbg !151

69:                                               ; preds = %66
  %70 = add i64 %67, %49, !dbg !151
  %71 = add i64 %70, %39, !dbg !151
  br label %72, !dbg !151

72:                                               ; preds = %101, %69
  %73 = phi i64 [ %102, %101 ], [ 0, %69 ], !dbg !151
  %74 = icmp slt i64 %73, 4, !dbg !151
  br i1 %74, label %75, label %103, !dbg !151

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %100, %78 ], [ 0, %72 ], !dbg !151
  %77 = icmp slt i64 %76, 3, !dbg !151
  br i1 %77, label %78, label %101, !dbg !151

78:                                               ; preds = %75
  %79 = add i64 %52, %73, !dbg !151
  %80 = add i64 %79, %76, !dbg !151
  %81 = mul nuw nsw i64 %64, 1156, !dbg !151
  %82 = mul nuw nsw i64 %71, 34, !dbg !151
  %83 = add nuw nsw i64 %81, %82, !dbg !151
  %84 = add nuw nsw i64 %83, %80, !dbg !151
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !151
  %86 = load float, ptr %85, align 4, !dbg !151
  %87 = mul nuw nsw i64 %45, 144, !dbg !151
  %88 = mul nuw nsw i64 %64, 9, !dbg !151
  %89 = add nuw nsw i64 %87, %88, !dbg !151
  %90 = mul nuw nsw i64 %67, 3, !dbg !151
  %91 = add nuw nsw i64 %89, %90, !dbg !151
  %92 = add nuw nsw i64 %91, %76, !dbg !151
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !151
  %94 = load float, ptr %93, align 4, !dbg !151
  %95 = add nuw nsw i64 0, %73, !dbg !151
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !151
  %97 = load float, ptr %96, align 4, !dbg !151
  %98 = fmul contract float %86, %94, !dbg !159
  %99 = fadd contract float %97, %98, !dbg !160
  store float %99, ptr %96, align 4, !dbg !151
  %100 = add i64 %76, 1, !dbg !151
  br label %75, !dbg !151

101:                                              ; preds = %75
  %102 = add i64 %73, 1, !dbg !151
  br label %72, !dbg !151

103:                                              ; preds = %72
  %104 = add i64 %67, 1, !dbg !151
  br label %66, !dbg !151

105:                                              ; preds = %66
  %106 = add i64 %64, 1, !dbg !151
  br label %63, !dbg !151

107:                                              ; preds = %63
  %108 = add i64 %49, %39, !dbg !158
  %109 = mul i64 %45, 1024, !dbg !158
  %110 = mul i64 %108, 32, !dbg !158
  %111 = add i64 %109, %110, !dbg !158
  %112 = add i64 %111, %52, !dbg !158
  %113 = getelementptr float, ptr %18, i64 %112, !dbg !158
  %114 = load <4 x float>, ptr %113, align 4, !dbg !158
  %115 = getelementptr float, ptr %4, i64 0, !dbg !158
  %116 = load <4 x float>, ptr %115, align 4, !dbg !158
  %117 = extractelement <1 x float> %47, i64 0, !dbg !161
  %118 = insertelement <4 x float> poison, float %117, i32 0, !dbg !161
  %119 = shufflevector <4 x float> %118, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !161
  %120 = fadd contract <4 x float> %116, %119, !dbg !161
  %121 = fadd contract <4 x float> %114, %120, !dbg !162
  %122 = fcmp ugt <4 x float> %121, zeroinitializer, !dbg !163
  %123 = select <4 x i1> %122, <4 x float> %121, <4 x float> zeroinitializer, !dbg !164
  %124 = getelementptr float, ptr %23, i64 %112, !dbg !151
  store <4 x float> %123, ptr %124, align 4, !dbg !151
  %125 = add i64 %52, 4, !dbg !151
  br label %51, !dbg !151

126:                                              ; preds = %51
  %127 = add i64 %49, 1, !dbg !151
  br label %48, !dbg !151

128:                                              ; preds = %48
  %129 = add i64 %42, 1, !dbg !151
  br label %41, !dbg !151

130:                                              ; preds = %41
  ret i32 0, !dbg !165
}

define internal i32 @infer_dispatch_5_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !166 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !167
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !167
  %6 = load ptr, ptr %5, align 8, !dbg !167
  %7 = getelementptr float, ptr %6, i64 19856, !dbg !168
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !168
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !169
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !169
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !169
  %11 = load ptr, ptr %10, align 8, !dbg !169
  %12 = getelementptr float, ptr %11, i64 56848, !dbg !170
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !170
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !171
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !171
  %15 = zext i32 %14 to i64, !dbg !171
  %16 = sdiv i64 %15, 2, !dbg !171
  %17 = mul i64 %16, 2, !dbg !171
  %18 = icmp ne i64 %15, %17, !dbg !171
  %19 = icmp slt i64 %15, 0, !dbg !171
  %20 = and i1 %18, %19, !dbg !171
  %21 = add i64 %16, -1, !dbg !171
  %22 = select i1 %20, i64 %21, i64 %16, !dbg !171
  %23 = srem i64 %15, 2, !dbg !171
  %24 = icmp slt i64 %23, 0, !dbg !171
  %25 = add nsw i64 %23, 2, !dbg !171
  %26 = select i1 %24, i64 %25, i64 %23, !dbg !171
  %27 = mul nsw i64 %22, 8, !dbg !171
  %28 = mul nsw i64 %26, 16, !dbg !171
  br label %29, !dbg !171

29:                                               ; preds = %55, %3
  %30 = phi i64 [ %56, %55 ], [ 0, %3 ], !dbg !171
  %31 = icmp slt i64 %30, 8, !dbg !171
  br i1 %31, label %32, label %57, !dbg !171

32:                                               ; preds = %53, %29
  %33 = phi i64 [ %54, %53 ], [ 0, %29 ], !dbg !171
  %34 = icmp slt i64 %33, 16, !dbg !171
  br i1 %34, label %35, label %55, !dbg !171

35:                                               ; preds = %38, %32
  %36 = phi i64 [ %52, %38 ], [ 0, %32 ], !dbg !171
  %37 = icmp slt i64 %36, 32, !dbg !171
  br i1 %37, label %38, label %53, !dbg !171

38:                                               ; preds = %35
  %39 = add i64 %27, %30, !dbg !171
  %40 = add i64 %28, %33, !dbg !171
  %41 = mul i64 %39, 1024, !dbg !171
  %42 = mul i64 %40, 32, !dbg !171
  %43 = add i64 %41, %42, !dbg !171
  %44 = add i64 %43, %36, !dbg !171
  %45 = getelementptr float, ptr %7, i64 %44, !dbg !171
  %46 = load <4 x float>, ptr %45, align 4, !dbg !171
  %47 = mul i64 %39, 1089, !dbg !171
  %48 = mul i64 %40, 33, !dbg !171
  %49 = add i64 %47, %48, !dbg !171
  %50 = add i64 %49, %36, !dbg !171
  %51 = getelementptr float, ptr %12, i64 %50, !dbg !171
  store <4 x float> %46, ptr %51, align 4, !dbg !171
  %52 = add i64 %36, 4, !dbg !171
  br label %35, !dbg !171

53:                                               ; preds = %35
  %54 = add i64 %33, 1, !dbg !171
  br label %32, !dbg !171

55:                                               ; preds = %32
  %56 = add i64 %30, 1, !dbg !171
  br label %29, !dbg !171

57:                                               ; preds = %29
  ret i32 0, !dbg !172
}

define internal i32 @infer_dispatch_6_conv_32x16x16x16x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !173 {
  %4 = alloca float, i64 4, align 64, !dbg !174
  %5 = alloca float, i64 4, align 64, !dbg !175
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !176
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !176
  %8 = load ptr, ptr %7, align 8, !dbg !176
  %9 = getelementptr float, ptr %8, i64 56848, !dbg !176
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !176
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !177
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !177
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !177
  %13 = load ptr, ptr %12, align 8, !dbg !177
  %14 = getelementptr float, ptr %13, i64 72112, !dbg !177
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !177
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !178
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !178
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !178
  %18 = load ptr, ptr %17, align 8, !dbg !178
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !178
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !174
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !174
  %21 = zext i32 %20 to i64, !dbg !174
  %22 = sdiv i64 %21, 2, !dbg !174
  %23 = mul i64 %22, 2, !dbg !174
  %24 = icmp ne i64 %21, %23, !dbg !174
  %25 = icmp slt i64 %21, 0, !dbg !174
  %26 = and i1 %24, %25, !dbg !174
  %27 = add i64 %22, -1, !dbg !174
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !174
  %29 = srem i64 %21, 2, !dbg !174
  %30 = icmp slt i64 %29, 0, !dbg !174
  %31 = add nsw i64 %29, 2, !dbg !174
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !174
  %33 = mul nsw i64 %28, 4, !dbg !174
  %34 = mul nsw i64 %32, 8, !dbg !174
  %35 = getelementptr float, ptr %5, i64 0, !dbg !179
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !179
  br label %36, !dbg !174

36:                                               ; preds = %127, %3
  %37 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !174
  %38 = icmp slt i64 %37, 4, !dbg !174
  br i1 %38, label %39, label %129, !dbg !174

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !174
  %41 = getelementptr float, ptr @__constant_32xf32, i64 %40, !dbg !180
  %42 = load <1 x float>, ptr %41, align 4, !dbg !180
  br label %43, !dbg !174

43:                                               ; preds = %125, %39
  %44 = phi i64 [ %126, %125 ], [ 0, %39 ], !dbg !174
  %45 = icmp slt i64 %44, 8, !dbg !174
  br i1 %45, label %46, label %127, !dbg !174

46:                                               ; preds = %107, %43
  %47 = phi i64 [ %124, %107 ], [ 0, %43 ], !dbg !174
  %48 = icmp slt i64 %47, 16, !dbg !174
  br i1 %48, label %49, label %125, !dbg !174

49:                                               ; preds = %46
  %50 = mul nsw i64 %47, 2, !dbg !174
  br label %51, !dbg !174

51:                                               ; preds = %54, %49
  %52 = phi i64 [ %59, %54 ], [ 0, %49 ], !dbg !174
  %53 = icmp slt i64 %52, 4, !dbg !174
  br i1 %53, label %54, label %60, !dbg !174

54:                                               ; preds = %51
  %55 = add nuw nsw i64 0, %52, !dbg !174
  %56 = getelementptr inbounds nuw float, ptr %5, i64 %55, !dbg !174
  %57 = load float, ptr %56, align 4, !dbg !174
  %58 = getelementptr inbounds nuw float, ptr %4, i64 %55, !dbg !174
  store float %57, ptr %58, align 4, !dbg !174
  %59 = add i64 %52, 1, !dbg !174
  br label %51, !dbg !174

60:                                               ; preds = %105, %51
  %61 = phi i64 [ %106, %105 ], [ 0, %51 ], !dbg !174
  %62 = icmp slt i64 %61, 16, !dbg !174
  br i1 %62, label %63, label %107, !dbg !174

63:                                               ; preds = %103, %60
  %64 = phi i64 [ %104, %103 ], [ 0, %60 ], !dbg !174
  %65 = icmp slt i64 %64, 3, !dbg !174
  br i1 %65, label %66, label %105, !dbg !174

66:                                               ; preds = %63
  %67 = mul nsw i64 %44, 2, !dbg !174
  %68 = mul nsw i64 %32, 16, !dbg !174
  %69 = add i64 %67, %68, !dbg !174
  %70 = add i64 %69, %64, !dbg !174
  br label %71, !dbg !174

71:                                               ; preds = %101, %66
  %72 = phi i64 [ %102, %101 ], [ 0, %66 ], !dbg !174
  %73 = icmp slt i64 %72, 4, !dbg !174
  br i1 %73, label %74, label %103, !dbg !174

74:                                               ; preds = %77, %71
  %75 = phi i64 [ %100, %77 ], [ 0, %71 ], !dbg !174
  %76 = icmp slt i64 %75, 3, !dbg !174
  br i1 %76, label %77, label %101, !dbg !174

77:                                               ; preds = %74
  %78 = mul nsw i64 %72, 2, !dbg !174
  %79 = add i64 %50, %78, !dbg !174
  %80 = add i64 %79, %75, !dbg !174
  %81 = mul nuw nsw i64 %61, 1089, !dbg !174
  %82 = mul nuw nsw i64 %70, 33, !dbg !174
  %83 = add nuw nsw i64 %81, %82, !dbg !174
  %84 = add nuw nsw i64 %83, %80, !dbg !174
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !174
  %86 = load float, ptr %85, align 4, !dbg !174
  %87 = mul nuw nsw i64 %40, 144, !dbg !174
  %88 = mul nuw nsw i64 %61, 9, !dbg !174
  %89 = add nuw nsw i64 %87, %88, !dbg !174
  %90 = mul nuw nsw i64 %64, 3, !dbg !174
  %91 = add nuw nsw i64 %89, %90, !dbg !174
  %92 = add nuw nsw i64 %91, %75, !dbg !174
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !174
  %94 = load float, ptr %93, align 4, !dbg !174
  %95 = add nuw nsw i64 0, %72, !dbg !174
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !174
  %97 = load float, ptr %96, align 4, !dbg !174
  %98 = fmul contract float %86, %94, !dbg !181
  %99 = fadd contract float %97, %98, !dbg !182
  store float %99, ptr %96, align 4, !dbg !174
  %100 = add i64 %75, 1, !dbg !174
  br label %74, !dbg !174

101:                                              ; preds = %74
  %102 = add i64 %72, 1, !dbg !174
  br label %71, !dbg !174

103:                                              ; preds = %71
  %104 = add i64 %64, 1, !dbg !174
  br label %63, !dbg !174

105:                                              ; preds = %63
  %106 = add i64 %61, 1, !dbg !174
  br label %60, !dbg !174

107:                                              ; preds = %60
  %108 = getelementptr float, ptr %4, i64 0, !dbg !180
  %109 = load <4 x float>, ptr %108, align 4, !dbg !180
  %110 = extractelement <1 x float> %42, i64 0, !dbg !183
  %111 = insertelement <4 x float> poison, float %110, i32 0, !dbg !183
  %112 = shufflevector <4 x float> %111, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !183
  %113 = fadd contract <4 x float> %109, %112, !dbg !183
  %114 = fcmp ugt <4 x float> %113, zeroinitializer, !dbg !184
  %115 = select <4 x i1> %114, <4 x float> %113, <4 x float> zeroinitializer, !dbg !185
  %116 = add i64 %34, %44, !dbg !174
  %117 = add i64 %116, 1, !dbg !174
  %118 = add i64 %47, 1, !dbg !174
  %119 = mul i64 %40, 324, !dbg !174
  %120 = mul i64 %117, 18, !dbg !174
  %121 = add i64 %119, %120, !dbg !174
  %122 = add i64 %121, %118, !dbg !174
  %123 = getelementptr float, ptr %18, i64 %122, !dbg !174
  store <4 x float> %115, ptr %123, align 4, !dbg !174
  %124 = add i64 %47, 4, !dbg !174
  br label %46, !dbg !174

125:                                              ; preds = %46
  %126 = add i64 %44, 1, !dbg !174
  br label %43, !dbg !174

127:                                              ; preds = %43
  %128 = add i64 %37, 1, !dbg !174
  br label %36, !dbg !174

129:                                              ; preds = %36
  ret i32 0, !dbg !186
}

define internal i32 @infer_dispatch_7_matmul_like_32x16x16x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !187 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !188
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !188
  %6 = load ptr, ptr %5, align 8, !dbg !188
  %7 = getelementptr float, ptr %6, i64 19856, !dbg !188
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !188
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !189
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !189
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !189
  %11 = load ptr, ptr %10, align 8, !dbg !189
  %12 = getelementptr float, ptr %11, i64 2048, !dbg !189
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !189
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !190
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !190
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !190
  %16 = load ptr, ptr %15, align 8, !dbg !190
  %17 = getelementptr float, ptr %16, i64 10368, !dbg !190
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !190
  %18 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !191
  %19 = extractvalue %iree_hal_executable_workgroup_state_v0_t %18, 0, !dbg !191
  %20 = zext i32 %19 to i64, !dbg !191
  %21 = sdiv i64 %20, 2, !dbg !191
  %22 = mul i64 %21, 2, !dbg !191
  %23 = icmp ne i64 %20, %22, !dbg !191
  %24 = icmp slt i64 %20, 0, !dbg !191
  %25 = and i1 %23, %24, !dbg !191
  %26 = add i64 %21, -1, !dbg !191
  %27 = select i1 %25, i64 %26, i64 %21, !dbg !191
  %28 = srem i64 %20, 2, !dbg !191
  %29 = icmp slt i64 %28, 0, !dbg !191
  %30 = add nsw i64 %28, 2, !dbg !191
  %31 = select i1 %29, i64 %30, i64 %28, !dbg !191
  %32 = mul nsw i64 %27, 4, !dbg !191
  %33 = mul nsw i64 %31, 8, !dbg !191
  br label %34, !dbg !191

34:                                               ; preds = %209, %3
  %35 = phi i64 [ %258, %209 ], [ 0, %3 ], !dbg !191
  %36 = icmp slt i64 %35, 4, !dbg !191
  br i1 %36, label %37, label %259, !dbg !191

37:                                               ; preds = %34
  %38 = add i64 %35, %32, !dbg !191
  br label %39, !dbg !191

39:                                               ; preds = %177, %37
  %40 = phi i64 [ %208, %177 ], [ 0, %37 ], !dbg !191
  %41 = phi [8 x <16 x float>] [ %207, %177 ], [ zeroinitializer, %37 ], !dbg !191
  %42 = icmp slt i64 %40, 16, !dbg !191
  br i1 %42, label %43, label %209, !dbg !191

43:                                               ; preds = %47, %39
  %44 = phi i64 [ %57, %47 ], [ 0, %39 ], !dbg !191
  %45 = phi <16 x float> [ %56, %47 ], [ poison, %39 ], !dbg !191
  %46 = icmp slt i64 %44, 16, !dbg !191
  br i1 %46, label %47, label %58, !dbg !191

47:                                               ; preds = %43
  %48 = mul nsw i64 %33, 2, !dbg !191
  %49 = mul nsw i64 %44, 2, !dbg !191
  %50 = mul nuw nsw i64 %40, 1024, !dbg !191
  %51 = mul nuw nsw i64 %48, 32, !dbg !191
  %52 = add nuw nsw i64 %50, %51, !dbg !191
  %53 = add nuw nsw i64 %52, %49, !dbg !191
  %54 = getelementptr inbounds nuw float, ptr %7, i64 %53, !dbg !191
  %55 = load float, ptr %54, align 4, !dbg !191
  %56 = insertelement <16 x float> %45, float %55, i64 %44, !dbg !191
  %57 = add i64 %44, 1, !dbg !191
  br label %43, !dbg !191

58:                                               ; preds = %43
  %59 = add i64 %33, 1, !dbg !191
  br label %60, !dbg !191

60:                                               ; preds = %64, %58
  %61 = phi i64 [ %74, %64 ], [ 0, %58 ], !dbg !191
  %62 = phi <16 x float> [ %73, %64 ], [ poison, %58 ], !dbg !191
  %63 = icmp slt i64 %61, 16, !dbg !191
  br i1 %63, label %64, label %75, !dbg !191

64:                                               ; preds = %60
  %65 = mul nsw i64 %59, 2, !dbg !191
  %66 = mul nsw i64 %61, 2, !dbg !191
  %67 = mul nuw nsw i64 %40, 1024, !dbg !191
  %68 = mul nuw nsw i64 %65, 32, !dbg !191
  %69 = add nuw nsw i64 %67, %68, !dbg !191
  %70 = add nuw nsw i64 %69, %66, !dbg !191
  %71 = getelementptr inbounds nuw float, ptr %7, i64 %70, !dbg !191
  %72 = load float, ptr %71, align 4, !dbg !191
  %73 = insertelement <16 x float> %62, float %72, i64 %61, !dbg !191
  %74 = add i64 %61, 1, !dbg !191
  br label %60, !dbg !191

75:                                               ; preds = %60
  %76 = add i64 %33, 2, !dbg !191
  br label %77, !dbg !191

77:                                               ; preds = %81, %75
  %78 = phi i64 [ %91, %81 ], [ 0, %75 ], !dbg !191
  %79 = phi <16 x float> [ %90, %81 ], [ poison, %75 ], !dbg !191
  %80 = icmp slt i64 %78, 16, !dbg !191
  br i1 %80, label %81, label %92, !dbg !191

81:                                               ; preds = %77
  %82 = mul nsw i64 %76, 2, !dbg !191
  %83 = mul nsw i64 %78, 2, !dbg !191
  %84 = mul nuw nsw i64 %40, 1024, !dbg !191
  %85 = mul nuw nsw i64 %82, 32, !dbg !191
  %86 = add nuw nsw i64 %84, %85, !dbg !191
  %87 = add nuw nsw i64 %86, %83, !dbg !191
  %88 = getelementptr inbounds nuw float, ptr %7, i64 %87, !dbg !191
  %89 = load float, ptr %88, align 4, !dbg !191
  %90 = insertelement <16 x float> %79, float %89, i64 %78, !dbg !191
  %91 = add i64 %78, 1, !dbg !191
  br label %77, !dbg !191

92:                                               ; preds = %77
  %93 = add i64 %33, 3, !dbg !191
  br label %94, !dbg !191

94:                                               ; preds = %98, %92
  %95 = phi i64 [ %108, %98 ], [ 0, %92 ], !dbg !191
  %96 = phi <16 x float> [ %107, %98 ], [ poison, %92 ], !dbg !191
  %97 = icmp slt i64 %95, 16, !dbg !191
  br i1 %97, label %98, label %109, !dbg !191

98:                                               ; preds = %94
  %99 = mul nsw i64 %93, 2, !dbg !191
  %100 = mul nsw i64 %95, 2, !dbg !191
  %101 = mul nuw nsw i64 %40, 1024, !dbg !191
  %102 = mul nuw nsw i64 %99, 32, !dbg !191
  %103 = add nuw nsw i64 %101, %102, !dbg !191
  %104 = add nuw nsw i64 %103, %100, !dbg !191
  %105 = getelementptr inbounds nuw float, ptr %7, i64 %104, !dbg !191
  %106 = load float, ptr %105, align 4, !dbg !191
  %107 = insertelement <16 x float> %96, float %106, i64 %95, !dbg !191
  %108 = add i64 %95, 1, !dbg !191
  br label %94, !dbg !191

109:                                              ; preds = %94
  %110 = add i64 %33, 4, !dbg !191
  br label %111, !dbg !191

111:                                              ; preds = %115, %109
  %112 = phi i64 [ %125, %115 ], [ 0, %109 ], !dbg !191
  %113 = phi <16 x float> [ %124, %115 ], [ poison, %109 ], !dbg !191
  %114 = icmp slt i64 %112, 16, !dbg !191
  br i1 %114, label %115, label %126, !dbg !191

115:                                              ; preds = %111
  %116 = mul nsw i64 %110, 2, !dbg !191
  %117 = mul nsw i64 %112, 2, !dbg !191
  %118 = mul nuw nsw i64 %40, 1024, !dbg !191
  %119 = mul nuw nsw i64 %116, 32, !dbg !191
  %120 = add nuw nsw i64 %118, %119, !dbg !191
  %121 = add nuw nsw i64 %120, %117, !dbg !191
  %122 = getelementptr inbounds nuw float, ptr %7, i64 %121, !dbg !191
  %123 = load float, ptr %122, align 4, !dbg !191
  %124 = insertelement <16 x float> %113, float %123, i64 %112, !dbg !191
  %125 = add i64 %112, 1, !dbg !191
  br label %111, !dbg !191

126:                                              ; preds = %111
  %127 = add i64 %33, 5, !dbg !191
  br label %128, !dbg !191

128:                                              ; preds = %132, %126
  %129 = phi i64 [ %142, %132 ], [ 0, %126 ], !dbg !191
  %130 = phi <16 x float> [ %141, %132 ], [ poison, %126 ], !dbg !191
  %131 = icmp slt i64 %129, 16, !dbg !191
  br i1 %131, label %132, label %143, !dbg !191

132:                                              ; preds = %128
  %133 = mul nsw i64 %127, 2, !dbg !191
  %134 = mul nsw i64 %129, 2, !dbg !191
  %135 = mul nuw nsw i64 %40, 1024, !dbg !191
  %136 = mul nuw nsw i64 %133, 32, !dbg !191
  %137 = add nuw nsw i64 %135, %136, !dbg !191
  %138 = add nuw nsw i64 %137, %134, !dbg !191
  %139 = getelementptr inbounds nuw float, ptr %7, i64 %138, !dbg !191
  %140 = load float, ptr %139, align 4, !dbg !191
  %141 = insertelement <16 x float> %130, float %140, i64 %129, !dbg !191
  %142 = add i64 %129, 1, !dbg !191
  br label %128, !dbg !191

143:                                              ; preds = %128
  %144 = add i64 %33, 6, !dbg !191
  br label %145, !dbg !191

145:                                              ; preds = %149, %143
  %146 = phi i64 [ %159, %149 ], [ 0, %143 ], !dbg !191
  %147 = phi <16 x float> [ %158, %149 ], [ poison, %143 ], !dbg !191
  %148 = icmp slt i64 %146, 16, !dbg !191
  br i1 %148, label %149, label %160, !dbg !191

149:                                              ; preds = %145
  %150 = mul nsw i64 %144, 2, !dbg !191
  %151 = mul nsw i64 %146, 2, !dbg !191
  %152 = mul nuw nsw i64 %40, 1024, !dbg !191
  %153 = mul nuw nsw i64 %150, 32, !dbg !191
  %154 = add nuw nsw i64 %152, %153, !dbg !191
  %155 = add nuw nsw i64 %154, %151, !dbg !191
  %156 = getelementptr inbounds nuw float, ptr %7, i64 %155, !dbg !191
  %157 = load float, ptr %156, align 4, !dbg !191
  %158 = insertelement <16 x float> %147, float %157, i64 %146, !dbg !191
  %159 = add i64 %146, 1, !dbg !191
  br label %145, !dbg !191

160:                                              ; preds = %145
  %161 = add i64 %33, 7, !dbg !191
  br label %162, !dbg !191

162:                                              ; preds = %166, %160
  %163 = phi i64 [ %176, %166 ], [ 0, %160 ], !dbg !191
  %164 = phi <16 x float> [ %175, %166 ], [ poison, %160 ], !dbg !191
  %165 = icmp slt i64 %163, 16, !dbg !191
  br i1 %165, label %166, label %177, !dbg !191

166:                                              ; preds = %162
  %167 = mul nsw i64 %161, 2, !dbg !191
  %168 = mul nsw i64 %163, 2, !dbg !191
  %169 = mul nuw nsw i64 %40, 1024, !dbg !191
  %170 = mul nuw nsw i64 %167, 32, !dbg !191
  %171 = add nuw nsw i64 %169, %170, !dbg !191
  %172 = add nuw nsw i64 %171, %168, !dbg !191
  %173 = getelementptr inbounds nuw float, ptr %7, i64 %172, !dbg !191
  %174 = load float, ptr %173, align 4, !dbg !191
  %175 = insertelement <16 x float> %164, float %174, i64 %163, !dbg !191
  %176 = add i64 %163, 1, !dbg !191
  br label %162, !dbg !191

177:                                              ; preds = %162
  %178 = extractvalue [8 x <16 x float>] %41, 0, !dbg !192
  %179 = mul nuw nsw i64 %38, 16, !dbg !192
  %180 = add nuw nsw i64 %179, %40, !dbg !192
  %181 = getelementptr inbounds nuw float, ptr %12, i64 %180, !dbg !192
  %182 = load float, ptr %181, align 4, !dbg !192
  %183 = insertelement <16 x float> poison, float %182, i32 0, !dbg !192
  %184 = shufflevector <16 x float> %183, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !192
  %185 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %45, <16 x float> %184, <16 x float> %178), !dbg !192
  %186 = extractvalue [8 x <16 x float>] %41, 1, !dbg !192
  %187 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %62, <16 x float> %184, <16 x float> %186), !dbg !192
  %188 = extractvalue [8 x <16 x float>] %41, 2, !dbg !192
  %189 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %79, <16 x float> %184, <16 x float> %188), !dbg !192
  %190 = extractvalue [8 x <16 x float>] %41, 3, !dbg !192
  %191 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %96, <16 x float> %184, <16 x float> %190), !dbg !192
  %192 = extractvalue [8 x <16 x float>] %41, 4, !dbg !192
  %193 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %113, <16 x float> %184, <16 x float> %192), !dbg !192
  %194 = extractvalue [8 x <16 x float>] %41, 5, !dbg !192
  %195 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %130, <16 x float> %184, <16 x float> %194), !dbg !192
  %196 = extractvalue [8 x <16 x float>] %41, 6, !dbg !192
  %197 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %147, <16 x float> %184, <16 x float> %196), !dbg !192
  %198 = extractvalue [8 x <16 x float>] %41, 7, !dbg !192
  %199 = call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %164, <16 x float> %184, <16 x float> %198), !dbg !192
  %200 = insertvalue [8 x <16 x float>] poison, <16 x float> %185, 0, !dbg !192
  %201 = insertvalue [8 x <16 x float>] %200, <16 x float> %187, 1, !dbg !192
  %202 = insertvalue [8 x <16 x float>] %201, <16 x float> %189, 2, !dbg !192
  %203 = insertvalue [8 x <16 x float>] %202, <16 x float> %191, 3, !dbg !192
  %204 = insertvalue [8 x <16 x float>] %203, <16 x float> %193, 4, !dbg !192
  %205 = insertvalue [8 x <16 x float>] %204, <16 x float> %195, 5, !dbg !192
  %206 = insertvalue [8 x <16 x float>] %205, <16 x float> %197, 6, !dbg !192
  %207 = insertvalue [8 x <16 x float>] %206, <16 x float> %199, 7, !dbg !192
  %208 = add i64 %40, 1, !dbg !191
  br label %39, !dbg !191

209:                                              ; preds = %39
  %210 = extractvalue [8 x <16 x float>] %41, 0, !dbg !191
  %211 = mul i64 %38, 256, !dbg !191
  %212 = mul i64 %33, 16, !dbg !191
  %213 = add i64 %211, %212, !dbg !191
  %214 = add i64 %213, 0, !dbg !191
  %215 = getelementptr float, ptr %17, i64 %214, !dbg !191
  store <16 x float> %210, ptr %215, align 4, !dbg !191
  %216 = extractvalue [8 x <16 x float>] %41, 1, !dbg !191
  %217 = add i64 %33, 1, !dbg !191
  %218 = mul i64 %217, 16, !dbg !191
  %219 = add i64 %211, %218, !dbg !191
  %220 = add i64 %219, 0, !dbg !191
  %221 = getelementptr float, ptr %17, i64 %220, !dbg !191
  store <16 x float> %216, ptr %221, align 4, !dbg !191
  %222 = extractvalue [8 x <16 x float>] %41, 2, !dbg !191
  %223 = add i64 %33, 2, !dbg !191
  %224 = mul i64 %223, 16, !dbg !191
  %225 = add i64 %211, %224, !dbg !191
  %226 = add i64 %225, 0, !dbg !191
  %227 = getelementptr float, ptr %17, i64 %226, !dbg !191
  store <16 x float> %222, ptr %227, align 4, !dbg !191
  %228 = extractvalue [8 x <16 x float>] %41, 3, !dbg !191
  %229 = add i64 %33, 3, !dbg !191
  %230 = mul i64 %229, 16, !dbg !191
  %231 = add i64 %211, %230, !dbg !191
  %232 = add i64 %231, 0, !dbg !191
  %233 = getelementptr float, ptr %17, i64 %232, !dbg !191
  store <16 x float> %228, ptr %233, align 4, !dbg !191
  %234 = extractvalue [8 x <16 x float>] %41, 4, !dbg !191
  %235 = add i64 %33, 4, !dbg !191
  %236 = mul i64 %235, 16, !dbg !191
  %237 = add i64 %211, %236, !dbg !191
  %238 = add i64 %237, 0, !dbg !191
  %239 = getelementptr float, ptr %17, i64 %238, !dbg !191
  store <16 x float> %234, ptr %239, align 4, !dbg !191
  %240 = extractvalue [8 x <16 x float>] %41, 5, !dbg !191
  %241 = add i64 %33, 5, !dbg !191
  %242 = mul i64 %241, 16, !dbg !191
  %243 = add i64 %211, %242, !dbg !191
  %244 = add i64 %243, 0, !dbg !191
  %245 = getelementptr float, ptr %17, i64 %244, !dbg !191
  store <16 x float> %240, ptr %245, align 4, !dbg !191
  %246 = extractvalue [8 x <16 x float>] %41, 6, !dbg !191
  %247 = add i64 %33, 6, !dbg !191
  %248 = mul i64 %247, 16, !dbg !191
  %249 = add i64 %211, %248, !dbg !191
  %250 = add i64 %249, 0, !dbg !191
  %251 = getelementptr float, ptr %17, i64 %250, !dbg !191
  store <16 x float> %246, ptr %251, align 4, !dbg !191
  %252 = extractvalue [8 x <16 x float>] %41, 7, !dbg !191
  %253 = add i64 %33, 7, !dbg !191
  %254 = mul i64 %253, 16, !dbg !191
  %255 = add i64 %211, %254, !dbg !191
  %256 = add i64 %255, 0, !dbg !191
  %257 = getelementptr float, ptr %17, i64 %256, !dbg !191
  store <16 x float> %252, ptr %257, align 4, !dbg !191
  %258 = add i64 %35, 1, !dbg !191
  br label %34, !dbg !191

259:                                              ; preds = %34
  ret i32 0, !dbg !193
}

define internal i32 @infer_dispatch_8_conv_32x16x16x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !194 {
  %4 = alloca float, i64 4, align 64, !dbg !195
  %5 = alloca float, i64 4, align 64, !dbg !196
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !197
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !197
  %8 = load ptr, ptr %7, align 8, !dbg !197
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !197
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !198
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !198
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !198
  %12 = load ptr, ptr %11, align 8, !dbg !198
  %13 = getelementptr float, ptr %12, i64 62464, !dbg !198
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !198
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !199
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !199
  %16 = load ptr, ptr %15, align 8, !dbg !199
  %17 = getelementptr float, ptr %16, i64 10368, !dbg !199
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !199
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !200
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !200
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !200
  %21 = load ptr, ptr %20, align 8, !dbg !200
  %22 = getelementptr float, ptr %21, i64 18560, !dbg !200
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !200
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !195
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !195
  %25 = zext i32 %24 to i64, !dbg !195
  %26 = sdiv i64 %25, 2, !dbg !195
  %27 = mul i64 %26, 2, !dbg !195
  %28 = icmp ne i64 %25, %27, !dbg !195
  %29 = icmp slt i64 %25, 0, !dbg !195
  %30 = and i1 %28, %29, !dbg !195
  %31 = add i64 %26, -1, !dbg !195
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !195
  %33 = srem i64 %25, 2, !dbg !195
  %34 = icmp slt i64 %33, 0, !dbg !195
  %35 = add nsw i64 %33, 2, !dbg !195
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !195
  %37 = mul nsw i64 %32, 4, !dbg !195
  %38 = mul nsw i64 %36, 8, !dbg !195
  %39 = getelementptr float, ptr %5, i64 0, !dbg !201
  store <4 x float> zeroinitializer, ptr %39, align 4, !dbg !201
  br label %40, !dbg !195

40:                                               ; preds = %133, %3
  %41 = phi i64 [ %134, %133 ], [ 0, %3 ], !dbg !195
  %42 = icmp slt i64 %41, 4, !dbg !195
  br i1 %42, label %43, label %135, !dbg !195

43:                                               ; preds = %40
  %44 = add i64 %41, %37, !dbg !195
  %45 = getelementptr float, ptr @__constant_32xf32_0, i64 %44, !dbg !202
  %46 = load <1 x float>, ptr %45, align 4, !dbg !202
  %47 = getelementptr float, ptr @__constant_32xf32_1, i64 %44, !dbg !202
  %48 = load <1 x float>, ptr %47, align 4, !dbg !202
  br label %49, !dbg !195

49:                                               ; preds = %131, %43
  %50 = phi i64 [ %132, %131 ], [ 0, %43 ], !dbg !195
  %51 = icmp slt i64 %50, 8, !dbg !195
  br i1 %51, label %52, label %133, !dbg !195

52:                                               ; preds = %108, %49
  %53 = phi i64 [ %130, %108 ], [ 0, %49 ], !dbg !195
  %54 = icmp slt i64 %53, 16, !dbg !195
  br i1 %54, label %55, label %131, !dbg !195

55:                                               ; preds = %58, %52
  %56 = phi i64 [ %63, %58 ], [ 0, %52 ], !dbg !195
  %57 = icmp slt i64 %56, 4, !dbg !195
  br i1 %57, label %58, label %64, !dbg !195

58:                                               ; preds = %55
  %59 = add nuw nsw i64 0, %56, !dbg !195
  %60 = getelementptr inbounds nuw float, ptr %5, i64 %59, !dbg !195
  %61 = load float, ptr %60, align 4, !dbg !195
  %62 = getelementptr inbounds nuw float, ptr %4, i64 %59, !dbg !195
  store float %61, ptr %62, align 4, !dbg !195
  %63 = add i64 %56, 1, !dbg !195
  br label %55, !dbg !195

64:                                               ; preds = %106, %55
  %65 = phi i64 [ %107, %106 ], [ 0, %55 ], !dbg !195
  %66 = icmp slt i64 %65, 32, !dbg !195
  br i1 %66, label %67, label %108, !dbg !195

67:                                               ; preds = %104, %64
  %68 = phi i64 [ %105, %104 ], [ 0, %64 ], !dbg !195
  %69 = icmp slt i64 %68, 3, !dbg !195
  br i1 %69, label %70, label %106, !dbg !195

70:                                               ; preds = %67
  %71 = add i64 %68, %50, !dbg !195
  %72 = add i64 %71, %38, !dbg !195
  br label %73, !dbg !195

73:                                               ; preds = %102, %70
  %74 = phi i64 [ %103, %102 ], [ 0, %70 ], !dbg !195
  %75 = icmp slt i64 %74, 4, !dbg !195
  br i1 %75, label %76, label %104, !dbg !195

76:                                               ; preds = %79, %73
  %77 = phi i64 [ %101, %79 ], [ 0, %73 ], !dbg !195
  %78 = icmp slt i64 %77, 3, !dbg !195
  br i1 %78, label %79, label %102, !dbg !195

79:                                               ; preds = %76
  %80 = add i64 %53, %74, !dbg !195
  %81 = add i64 %80, %77, !dbg !195
  %82 = mul nuw nsw i64 %65, 324, !dbg !195
  %83 = mul nuw nsw i64 %72, 18, !dbg !195
  %84 = add nuw nsw i64 %82, %83, !dbg !195
  %85 = add nuw nsw i64 %84, %81, !dbg !195
  %86 = getelementptr inbounds nuw float, ptr %8, i64 %85, !dbg !195
  %87 = load float, ptr %86, align 4, !dbg !195
  %88 = mul nuw nsw i64 %44, 288, !dbg !195
  %89 = mul nuw nsw i64 %65, 9, !dbg !195
  %90 = add nuw nsw i64 %88, %89, !dbg !195
  %91 = mul nuw nsw i64 %68, 3, !dbg !195
  %92 = add nuw nsw i64 %90, %91, !dbg !195
  %93 = add nuw nsw i64 %92, %77, !dbg !195
  %94 = getelementptr inbounds nuw float, ptr %13, i64 %93, !dbg !195
  %95 = load float, ptr %94, align 4, !dbg !195
  %96 = add nuw nsw i64 0, %74, !dbg !195
  %97 = getelementptr inbounds nuw float, ptr %4, i64 %96, !dbg !195
  %98 = load float, ptr %97, align 4, !dbg !195
  %99 = fmul contract float %87, %95, !dbg !203
  %100 = fadd contract float %98, %99, !dbg !204
  store float %100, ptr %97, align 4, !dbg !195
  %101 = add i64 %77, 1, !dbg !195
  br label %76, !dbg !195

102:                                              ; preds = %76
  %103 = add i64 %74, 1, !dbg !195
  br label %73, !dbg !195

104:                                              ; preds = %73
  %105 = add i64 %68, 1, !dbg !195
  br label %67, !dbg !195

106:                                              ; preds = %67
  %107 = add i64 %65, 1, !dbg !195
  br label %64, !dbg !195

108:                                              ; preds = %64
  %109 = add i64 %50, %38, !dbg !202
  %110 = mul i64 %44, 256, !dbg !202
  %111 = mul i64 %109, 16, !dbg !202
  %112 = add i64 %110, %111, !dbg !202
  %113 = add i64 %112, %53, !dbg !202
  %114 = getelementptr float, ptr %17, i64 %113, !dbg !202
  %115 = load <4 x float>, ptr %114, align 4, !dbg !202
  %116 = getelementptr float, ptr %4, i64 0, !dbg !202
  %117 = load <4 x float>, ptr %116, align 4, !dbg !202
  %118 = extractelement <1 x float> %48, i64 0, !dbg !205
  %119 = insertelement <4 x float> poison, float %118, i32 0, !dbg !205
  %120 = shufflevector <4 x float> %119, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !205
  %121 = fadd contract <4 x float> %117, %120, !dbg !205
  %122 = extractelement <1 x float> %46, i64 0, !dbg !206
  %123 = insertelement <4 x float> poison, float %122, i32 0, !dbg !206
  %124 = shufflevector <4 x float> %123, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !206
  %125 = fadd contract <4 x float> %115, %124, !dbg !206
  %126 = fadd contract <4 x float> %125, %121, !dbg !207
  %127 = fcmp ugt <4 x float> %126, zeroinitializer, !dbg !208
  %128 = select <4 x i1> %127, <4 x float> %126, <4 x float> zeroinitializer, !dbg !209
  %129 = getelementptr float, ptr %22, i64 %113, !dbg !195
  store <4 x float> %128, ptr %129, align 4, !dbg !195
  %130 = add i64 %53, 4, !dbg !195
  br label %52, !dbg !195

131:                                              ; preds = %52
  %132 = add i64 %50, 1, !dbg !195
  br label %49, !dbg !195

133:                                              ; preds = %49
  %134 = add i64 %41, 1, !dbg !195
  br label %40, !dbg !195

135:                                              ; preds = %40
  ret i32 0, !dbg !210
}

define internal i32 @infer_dispatch_9_slow_memcpy(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !211 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !212
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !212
  %6 = load ptr, ptr %5, align 8, !dbg !212
  %7 = getelementptr float, ptr %6, i64 18560, !dbg !213
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !213
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !214
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !214
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !214
  %11 = load ptr, ptr %10, align 8, !dbg !214
  %12 = getelementptr float, ptr %11, i64 26752, !dbg !215
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !215
  %13 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !216
  %14 = extractvalue %iree_hal_executable_workgroup_state_v0_t %13, 0, !dbg !216
  %15 = zext i32 %14 to i64, !dbg !216
  %16 = mul nsw i64 %15, 8, !dbg !216
  br label %17, !dbg !216

17:                                               ; preds = %42, %3
  %18 = phi i64 [ %43, %42 ], [ 0, %3 ], !dbg !216
  %19 = icmp slt i64 %18, 32, !dbg !216
  br i1 %19, label %20, label %44, !dbg !216

20:                                               ; preds = %40, %17
  %21 = phi i64 [ %41, %40 ], [ 0, %17 ], !dbg !216
  %22 = icmp slt i64 %21, 8, !dbg !216
  br i1 %22, label %23, label %42, !dbg !216

23:                                               ; preds = %26, %20
  %24 = phi i64 [ %39, %26 ], [ 0, %20 ], !dbg !216
  %25 = icmp slt i64 %24, 16, !dbg !216
  br i1 %25, label %26, label %40, !dbg !216

26:                                               ; preds = %23
  %27 = add i64 %16, %21, !dbg !216
  %28 = mul i64 %18, 256, !dbg !216
  %29 = mul i64 %27, 16, !dbg !216
  %30 = add i64 %28, %29, !dbg !216
  %31 = add i64 %30, %24, !dbg !216
  %32 = getelementptr float, ptr %7, i64 %31, !dbg !216
  %33 = load <4 x float>, ptr %32, align 4, !dbg !216
  %34 = mul i64 %18, 289, !dbg !216
  %35 = mul i64 %27, 17, !dbg !216
  %36 = add i64 %34, %35, !dbg !216
  %37 = add i64 %36, %24, !dbg !216
  %38 = getelementptr float, ptr %12, i64 %37, !dbg !216
  store <4 x float> %33, ptr %38, align 4, !dbg !216
  %39 = add i64 %24, 4, !dbg !216
  br label %23, !dbg !216

40:                                               ; preds = %23
  %41 = add i64 %21, 1, !dbg !216
  br label %20, !dbg !216

42:                                               ; preds = %20
  %43 = add i64 %18, 1, !dbg !216
  br label %17, !dbg !216

44:                                               ; preds = %17
  ret i32 0, !dbg !217
}

define internal i32 @infer_dispatch_10_conv_64x8x8x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !218 {
  %4 = alloca float, i64 4, align 64, !dbg !219
  %5 = alloca float, i64 4, align 64, !dbg !220
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !221
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !221
  %8 = load ptr, ptr %7, align 8, !dbg !221
  %9 = getelementptr float, ptr %8, i64 26752, !dbg !221
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !221
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !222
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !222
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !222
  %13 = load ptr, ptr %12, align 8, !dbg !222
  %14 = getelementptr float, ptr %13, i64 44032, !dbg !222
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !222
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !223
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !223
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !223
  %18 = load ptr, ptr %17, align 8, !dbg !223
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !223
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !219
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !219
  %21 = zext i32 %20 to i64, !dbg !219
  %22 = sdiv i64 %21, 2, !dbg !219
  %23 = mul i64 %22, 2, !dbg !219
  %24 = icmp ne i64 %21, %23, !dbg !219
  %25 = icmp slt i64 %21, 0, !dbg !219
  %26 = and i1 %24, %25, !dbg !219
  %27 = add i64 %22, -1, !dbg !219
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !219
  %29 = srem i64 %21, 2, !dbg !219
  %30 = icmp slt i64 %29, 0, !dbg !219
  %31 = add nsw i64 %29, 2, !dbg !219
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !219
  %33 = mul nsw i64 %28, 8, !dbg !219
  %34 = mul nsw i64 %32, 4, !dbg !219
  %35 = getelementptr float, ptr %5, i64 0, !dbg !224
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !224
  br label %36, !dbg !219

36:                                               ; preds = %127, %3
  %37 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !219
  %38 = icmp slt i64 %37, 8, !dbg !219
  br i1 %38, label %39, label %129, !dbg !219

39:                                               ; preds = %36
  %40 = add i64 %37, %33, !dbg !219
  %41 = getelementptr float, ptr @__constant_64xf32, i64 %40, !dbg !225
  %42 = load <1 x float>, ptr %41, align 4, !dbg !225
  br label %43, !dbg !219

43:                                               ; preds = %125, %39
  %44 = phi i64 [ %126, %125 ], [ 0, %39 ], !dbg !219
  %45 = icmp slt i64 %44, 4, !dbg !219
  br i1 %45, label %46, label %127, !dbg !219

46:                                               ; preds = %107, %43
  %47 = phi i64 [ %124, %107 ], [ 0, %43 ], !dbg !219
  %48 = icmp slt i64 %47, 8, !dbg !219
  br i1 %48, label %49, label %125, !dbg !219

49:                                               ; preds = %46
  %50 = mul nsw i64 %47, 2, !dbg !219
  br label %51, !dbg !219

51:                                               ; preds = %54, %49
  %52 = phi i64 [ %59, %54 ], [ 0, %49 ], !dbg !219
  %53 = icmp slt i64 %52, 4, !dbg !219
  br i1 %53, label %54, label %60, !dbg !219

54:                                               ; preds = %51
  %55 = add nuw nsw i64 0, %52, !dbg !219
  %56 = getelementptr inbounds nuw float, ptr %5, i64 %55, !dbg !219
  %57 = load float, ptr %56, align 4, !dbg !219
  %58 = getelementptr inbounds nuw float, ptr %4, i64 %55, !dbg !219
  store float %57, ptr %58, align 4, !dbg !219
  %59 = add i64 %52, 1, !dbg !219
  br label %51, !dbg !219

60:                                               ; preds = %105, %51
  %61 = phi i64 [ %106, %105 ], [ 0, %51 ], !dbg !219
  %62 = icmp slt i64 %61, 32, !dbg !219
  br i1 %62, label %63, label %107, !dbg !219

63:                                               ; preds = %103, %60
  %64 = phi i64 [ %104, %103 ], [ 0, %60 ], !dbg !219
  %65 = icmp slt i64 %64, 3, !dbg !219
  br i1 %65, label %66, label %105, !dbg !219

66:                                               ; preds = %63
  %67 = mul nsw i64 %44, 2, !dbg !219
  %68 = mul nsw i64 %32, 8, !dbg !219
  %69 = add i64 %67, %68, !dbg !219
  %70 = add i64 %69, %64, !dbg !219
  br label %71, !dbg !219

71:                                               ; preds = %101, %66
  %72 = phi i64 [ %102, %101 ], [ 0, %66 ], !dbg !219
  %73 = icmp slt i64 %72, 4, !dbg !219
  br i1 %73, label %74, label %103, !dbg !219

74:                                               ; preds = %77, %71
  %75 = phi i64 [ %100, %77 ], [ 0, %71 ], !dbg !219
  %76 = icmp slt i64 %75, 3, !dbg !219
  br i1 %76, label %77, label %101, !dbg !219

77:                                               ; preds = %74
  %78 = mul nsw i64 %72, 2, !dbg !219
  %79 = add i64 %50, %78, !dbg !219
  %80 = add i64 %79, %75, !dbg !219
  %81 = mul nuw nsw i64 %61, 289, !dbg !219
  %82 = mul nuw nsw i64 %70, 17, !dbg !219
  %83 = add nuw nsw i64 %81, %82, !dbg !219
  %84 = add nuw nsw i64 %83, %80, !dbg !219
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !219
  %86 = load float, ptr %85, align 4, !dbg !219
  %87 = mul nuw nsw i64 %40, 288, !dbg !219
  %88 = mul nuw nsw i64 %61, 9, !dbg !219
  %89 = add nuw nsw i64 %87, %88, !dbg !219
  %90 = mul nuw nsw i64 %64, 3, !dbg !219
  %91 = add nuw nsw i64 %89, %90, !dbg !219
  %92 = add nuw nsw i64 %91, %75, !dbg !219
  %93 = getelementptr inbounds nuw float, ptr %14, i64 %92, !dbg !219
  %94 = load float, ptr %93, align 4, !dbg !219
  %95 = add nuw nsw i64 0, %72, !dbg !219
  %96 = getelementptr inbounds nuw float, ptr %4, i64 %95, !dbg !219
  %97 = load float, ptr %96, align 4, !dbg !219
  %98 = fmul contract float %86, %94, !dbg !226
  %99 = fadd contract float %97, %98, !dbg !227
  store float %99, ptr %96, align 4, !dbg !219
  %100 = add i64 %75, 1, !dbg !219
  br label %74, !dbg !219

101:                                              ; preds = %74
  %102 = add i64 %72, 1, !dbg !219
  br label %71, !dbg !219

103:                                              ; preds = %71
  %104 = add i64 %64, 1, !dbg !219
  br label %63, !dbg !219

105:                                              ; preds = %63
  %106 = add i64 %61, 1, !dbg !219
  br label %60, !dbg !219

107:                                              ; preds = %60
  %108 = getelementptr float, ptr %4, i64 0, !dbg !225
  %109 = load <4 x float>, ptr %108, align 4, !dbg !225
  %110 = extractelement <1 x float> %42, i64 0, !dbg !228
  %111 = insertelement <4 x float> poison, float %110, i32 0, !dbg !228
  %112 = shufflevector <4 x float> %111, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !228
  %113 = fadd contract <4 x float> %109, %112, !dbg !228
  %114 = fcmp ugt <4 x float> %113, zeroinitializer, !dbg !229
  %115 = select <4 x i1> %114, <4 x float> %113, <4 x float> zeroinitializer, !dbg !230
  %116 = add i64 %34, %44, !dbg !219
  %117 = add i64 %116, 1, !dbg !219
  %118 = add i64 %47, 1, !dbg !219
  %119 = mul i64 %40, 100, !dbg !219
  %120 = mul i64 %117, 10, !dbg !219
  %121 = add i64 %119, %120, !dbg !219
  %122 = add i64 %121, %118, !dbg !219
  %123 = getelementptr float, ptr %18, i64 %122, !dbg !219
  store <4 x float> %115, ptr %123, align 4, !dbg !219
  %124 = add i64 %47, 4, !dbg !219
  br label %46, !dbg !219

125:                                              ; preds = %46
  %126 = add i64 %44, 1, !dbg !219
  br label %43, !dbg !219

127:                                              ; preds = %43
  %128 = add i64 %37, 1, !dbg !219
  br label %36, !dbg !219

129:                                              ; preds = %36
  ret i32 0, !dbg !231
}

define internal i32 @infer_dispatch_11_conv_64x8x8x64x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !232 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !233
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !233
  %6 = load ptr, ptr %5, align 8, !dbg !233
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !233
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !234
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !234
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !234
  %10 = load ptr, ptr %9, align 8, !dbg !234
  %11 = getelementptr float, ptr %10, i64 7168, !dbg !234
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !234
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !235
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !235
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !235
  %15 = load ptr, ptr %14, align 8, !dbg !235
  %16 = getelementptr float, ptr %15, i64 6400, !dbg !235
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !235
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !236
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !236
  %19 = zext i32 %18 to i64, !dbg !236
  %20 = sdiv i64 %19, 2, !dbg !236
  %21 = mul i64 %20, 2, !dbg !236
  %22 = icmp ne i64 %19, %21, !dbg !236
  %23 = icmp slt i64 %19, 0, !dbg !236
  %24 = and i1 %22, %23, !dbg !236
  %25 = add i64 %20, -1, !dbg !236
  %26 = select i1 %24, i64 %25, i64 %20, !dbg !236
  %27 = srem i64 %19, 2, !dbg !236
  %28 = icmp slt i64 %27, 0, !dbg !236
  %29 = add nsw i64 %27, 2, !dbg !236
  %30 = select i1 %28, i64 %29, i64 %27, !dbg !236
  %31 = mul nsw i64 %26, 8, !dbg !236
  %32 = mul nsw i64 %30, 4, !dbg !236
  br label %33, !dbg !236

33:                                               ; preds = %102, %3
  %34 = phi i64 [ %103, %102 ], [ 0, %3 ], !dbg !236
  %35 = icmp slt i64 %34, 8, !dbg !236
  br i1 %35, label %36, label %104, !dbg !236

36:                                               ; preds = %33
  %37 = add i64 %34, %31, !dbg !236
  br label %38, !dbg !236

38:                                               ; preds = %100, %36
  %39 = phi i64 [ %101, %100 ], [ 0, %36 ], !dbg !236
  %40 = icmp slt i64 %39, 4, !dbg !236
  br i1 %40, label %41, label %102, !dbg !236

41:                                               ; preds = %98, %38
  %42 = phi i64 [ %99, %98 ], [ 0, %38 ], !dbg !236
  %43 = icmp slt i64 %42, 8, !dbg !236
  br i1 %43, label %44, label %100, !dbg !236

44:                                               ; preds = %41
  %45 = add i64 %32, %39, !dbg !237
  %46 = mul i64 %37, 64, !dbg !237
  %47 = mul i64 %45, 8, !dbg !237
  %48 = add i64 %46, %47, !dbg !237
  %49 = add i64 %48, %42, !dbg !237
  %50 = getelementptr float, ptr %16, i64 %49, !dbg !237
  store <4 x float> zeroinitializer, ptr %50, align 4, !dbg !237
  br label %51, !dbg !236

51:                                               ; preds = %96, %44
  %52 = phi i64 [ %97, %96 ], [ 0, %44 ], !dbg !236
  %53 = icmp slt i64 %52, 64, !dbg !236
  br i1 %53, label %54, label %98, !dbg !236

54:                                               ; preds = %94, %51
  %55 = phi i64 [ %95, %94 ], [ 0, %51 ], !dbg !236
  %56 = icmp slt i64 %55, 3, !dbg !236
  br i1 %56, label %57, label %96, !dbg !236

57:                                               ; preds = %54
  %58 = add i64 %55, %39, !dbg !236
  %59 = add i64 %58, %32, !dbg !236
  br label %60, !dbg !236

60:                                               ; preds = %92, %57
  %61 = phi i64 [ %93, %92 ], [ 0, %57 ], !dbg !236
  %62 = icmp slt i64 %61, 4, !dbg !236
  br i1 %62, label %63, label %94, !dbg !236

63:                                               ; preds = %66, %60
  %64 = phi i64 [ %91, %66 ], [ 0, %60 ], !dbg !236
  %65 = icmp slt i64 %64, 3, !dbg !236
  br i1 %65, label %66, label %92, !dbg !236

66:                                               ; preds = %63
  %67 = add i64 %42, %61, !dbg !236
  %68 = add i64 %67, %64, !dbg !236
  %69 = mul nuw nsw i64 %52, 100, !dbg !236
  %70 = mul nuw nsw i64 %59, 10, !dbg !236
  %71 = add nuw nsw i64 %69, %70, !dbg !236
  %72 = add nuw nsw i64 %71, %68, !dbg !236
  %73 = getelementptr inbounds nuw float, ptr %6, i64 %72, !dbg !236
  %74 = load float, ptr %73, align 4, !dbg !236
  %75 = mul nuw nsw i64 %37, 576, !dbg !236
  %76 = mul nuw nsw i64 %52, 9, !dbg !236
  %77 = add nuw nsw i64 %75, %76, !dbg !236
  %78 = mul nuw nsw i64 %55, 3, !dbg !236
  %79 = add nuw nsw i64 %77, %78, !dbg !236
  %80 = add nuw nsw i64 %79, %64, !dbg !236
  %81 = getelementptr inbounds nuw float, ptr %11, i64 %80, !dbg !236
  %82 = load float, ptr %81, align 4, !dbg !236
  %83 = mul nuw nsw i64 %37, 64, !dbg !236
  %84 = mul nuw nsw i64 %45, 8, !dbg !236
  %85 = add nuw nsw i64 %83, %84, !dbg !236
  %86 = add nuw nsw i64 %85, %67, !dbg !236
  %87 = getelementptr inbounds nuw float, ptr %16, i64 %86, !dbg !236
  %88 = load float, ptr %87, align 4, !dbg !236
  %89 = fmul contract float %74, %82, !dbg !238
  %90 = fadd contract float %88, %89, !dbg !239
  store float %90, ptr %87, align 4, !dbg !236
  %91 = add i64 %64, 1, !dbg !236
  br label %63, !dbg !236

92:                                               ; preds = %63
  %93 = add i64 %61, 1, !dbg !236
  br label %60, !dbg !236

94:                                               ; preds = %60
  %95 = add i64 %55, 1, !dbg !236
  br label %54, !dbg !236

96:                                               ; preds = %54
  %97 = add i64 %52, 1, !dbg !236
  br label %51, !dbg !236

98:                                               ; preds = %51
  %99 = add i64 %42, 4, !dbg !236
  br label %41, !dbg !236

100:                                              ; preds = %41
  %101 = add i64 %39, 1, !dbg !236
  br label %38, !dbg !236

102:                                              ; preds = %38
  %103 = add i64 %34, 1, !dbg !236
  br label %33, !dbg !236

104:                                              ; preds = %33
  ret i32 0, !dbg !240
}

define internal i32 @infer_dispatch_12_matmul_like_64x8x8x32_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !241 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !242
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !242
  %6 = load ptr, ptr %5, align 8, !dbg !242
  %7 = getelementptr float, ptr %6, i64 18560, !dbg !242
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !242
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !243
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !243
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !243
  %11 = load ptr, ptr %10, align 8, !dbg !243
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !243
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !244
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !244
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !244
  %15 = load ptr, ptr %14, align 8, !dbg !244
  %16 = getelementptr float, ptr %15, i64 10496, !dbg !244
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !244
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !245
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !245
  %19 = zext i32 %18 to i64, !dbg !245
  %20 = mul nsw i64 %19, 8, !dbg !245
  br label %21, !dbg !245

21:                                               ; preds = %166, %3
  %22 = phi i64 [ %200, %166 ], [ 0, %3 ], !dbg !245
  %23 = icmp slt i64 %22, 8, !dbg !245
  br i1 %23, label %24, label %201, !dbg !245

24:                                               ; preds = %21
  %25 = add i64 %22, %20, !dbg !245
  br label %26, !dbg !245

26:                                               ; preds = %134, %24
  %27 = phi i64 [ %165, %134 ], [ 0, %24 ], !dbg !245
  %28 = phi [8 x <8 x float>] [ %164, %134 ], [ zeroinitializer, %24 ], !dbg !245
  %29 = icmp slt i64 %27, 32, !dbg !245
  br i1 %29, label %30, label %166, !dbg !245

30:                                               ; preds = %34, %26
  %31 = phi i64 [ %42, %34 ], [ 0, %26 ], !dbg !245
  %32 = phi <8 x float> [ %41, %34 ], [ poison, %26 ], !dbg !245
  %33 = icmp slt i64 %31, 8, !dbg !245
  br i1 %33, label %34, label %43, !dbg !245

34:                                               ; preds = %30
  %35 = mul nsw i64 %31, 2, !dbg !245
  %36 = mul nuw nsw i64 %27, 256, !dbg !245
  %37 = add nuw nsw i64 %36, 0, !dbg !245
  %38 = add nuw nsw i64 %37, %35, !dbg !245
  %39 = getelementptr inbounds nuw float, ptr %7, i64 %38, !dbg !245
  %40 = load float, ptr %39, align 4, !dbg !245
  %41 = insertelement <8 x float> %32, float %40, i64 %31, !dbg !245
  %42 = add i64 %31, 1, !dbg !245
  br label %30, !dbg !245

43:                                               ; preds = %47, %30
  %44 = phi i64 [ %55, %47 ], [ 0, %30 ], !dbg !245
  %45 = phi <8 x float> [ %54, %47 ], [ poison, %30 ], !dbg !245
  %46 = icmp slt i64 %44, 8, !dbg !245
  br i1 %46, label %47, label %56, !dbg !245

47:                                               ; preds = %43
  %48 = mul nsw i64 %44, 2, !dbg !245
  %49 = mul nuw nsw i64 %27, 256, !dbg !245
  %50 = add nuw nsw i64 %49, 32, !dbg !245
  %51 = add nuw nsw i64 %50, %48, !dbg !245
  %52 = getelementptr inbounds nuw float, ptr %7, i64 %51, !dbg !245
  %53 = load float, ptr %52, align 4, !dbg !245
  %54 = insertelement <8 x float> %45, float %53, i64 %44, !dbg !245
  %55 = add i64 %44, 1, !dbg !245
  br label %43, !dbg !245

56:                                               ; preds = %60, %43
  %57 = phi i64 [ %68, %60 ], [ 0, %43 ], !dbg !245
  %58 = phi <8 x float> [ %67, %60 ], [ poison, %43 ], !dbg !245
  %59 = icmp slt i64 %57, 8, !dbg !245
  br i1 %59, label %60, label %69, !dbg !245

60:                                               ; preds = %56
  %61 = mul nsw i64 %57, 2, !dbg !245
  %62 = mul nuw nsw i64 %27, 256, !dbg !245
  %63 = add nuw nsw i64 %62, 64, !dbg !245
  %64 = add nuw nsw i64 %63, %61, !dbg !245
  %65 = getelementptr inbounds nuw float, ptr %7, i64 %64, !dbg !245
  %66 = load float, ptr %65, align 4, !dbg !245
  %67 = insertelement <8 x float> %58, float %66, i64 %57, !dbg !245
  %68 = add i64 %57, 1, !dbg !245
  br label %56, !dbg !245

69:                                               ; preds = %73, %56
  %70 = phi i64 [ %81, %73 ], [ 0, %56 ], !dbg !245
  %71 = phi <8 x float> [ %80, %73 ], [ poison, %56 ], !dbg !245
  %72 = icmp slt i64 %70, 8, !dbg !245
  br i1 %72, label %73, label %82, !dbg !245

73:                                               ; preds = %69
  %74 = mul nsw i64 %70, 2, !dbg !245
  %75 = mul nuw nsw i64 %27, 256, !dbg !245
  %76 = add nuw nsw i64 %75, 96, !dbg !245
  %77 = add nuw nsw i64 %76, %74, !dbg !245
  %78 = getelementptr inbounds nuw float, ptr %7, i64 %77, !dbg !245
  %79 = load float, ptr %78, align 4, !dbg !245
  %80 = insertelement <8 x float> %71, float %79, i64 %70, !dbg !245
  %81 = add i64 %70, 1, !dbg !245
  br label %69, !dbg !245

82:                                               ; preds = %86, %69
  %83 = phi i64 [ %94, %86 ], [ 0, %69 ], !dbg !245
  %84 = phi <8 x float> [ %93, %86 ], [ poison, %69 ], !dbg !245
  %85 = icmp slt i64 %83, 8, !dbg !245
  br i1 %85, label %86, label %95, !dbg !245

86:                                               ; preds = %82
  %87 = mul nsw i64 %83, 2, !dbg !245
  %88 = mul nuw nsw i64 %27, 256, !dbg !245
  %89 = add nuw nsw i64 %88, 128, !dbg !245
  %90 = add nuw nsw i64 %89, %87, !dbg !245
  %91 = getelementptr inbounds nuw float, ptr %7, i64 %90, !dbg !245
  %92 = load float, ptr %91, align 4, !dbg !245
  %93 = insertelement <8 x float> %84, float %92, i64 %83, !dbg !245
  %94 = add i64 %83, 1, !dbg !245
  br label %82, !dbg !245

95:                                               ; preds = %99, %82
  %96 = phi i64 [ %107, %99 ], [ 0, %82 ], !dbg !245
  %97 = phi <8 x float> [ %106, %99 ], [ poison, %82 ], !dbg !245
  %98 = icmp slt i64 %96, 8, !dbg !245
  br i1 %98, label %99, label %108, !dbg !245

99:                                               ; preds = %95
  %100 = mul nsw i64 %96, 2, !dbg !245
  %101 = mul nuw nsw i64 %27, 256, !dbg !245
  %102 = add nuw nsw i64 %101, 160, !dbg !245
  %103 = add nuw nsw i64 %102, %100, !dbg !245
  %104 = getelementptr inbounds nuw float, ptr %7, i64 %103, !dbg !245
  %105 = load float, ptr %104, align 4, !dbg !245
  %106 = insertelement <8 x float> %97, float %105, i64 %96, !dbg !245
  %107 = add i64 %96, 1, !dbg !245
  br label %95, !dbg !245

108:                                              ; preds = %112, %95
  %109 = phi i64 [ %120, %112 ], [ 0, %95 ], !dbg !245
  %110 = phi <8 x float> [ %119, %112 ], [ poison, %95 ], !dbg !245
  %111 = icmp slt i64 %109, 8, !dbg !245
  br i1 %111, label %112, label %121, !dbg !245

112:                                              ; preds = %108
  %113 = mul nsw i64 %109, 2, !dbg !245
  %114 = mul nuw nsw i64 %27, 256, !dbg !245
  %115 = add nuw nsw i64 %114, 192, !dbg !245
  %116 = add nuw nsw i64 %115, %113, !dbg !245
  %117 = getelementptr inbounds nuw float, ptr %7, i64 %116, !dbg !245
  %118 = load float, ptr %117, align 4, !dbg !245
  %119 = insertelement <8 x float> %110, float %118, i64 %109, !dbg !245
  %120 = add i64 %109, 1, !dbg !245
  br label %108, !dbg !245

121:                                              ; preds = %125, %108
  %122 = phi i64 [ %133, %125 ], [ 0, %108 ], !dbg !245
  %123 = phi <8 x float> [ %132, %125 ], [ poison, %108 ], !dbg !245
  %124 = icmp slt i64 %122, 8, !dbg !245
  br i1 %124, label %125, label %134, !dbg !245

125:                                              ; preds = %121
  %126 = mul nsw i64 %122, 2, !dbg !245
  %127 = mul nuw nsw i64 %27, 256, !dbg !245
  %128 = add nuw nsw i64 %127, 224, !dbg !245
  %129 = add nuw nsw i64 %128, %126, !dbg !245
  %130 = getelementptr inbounds nuw float, ptr %7, i64 %129, !dbg !245
  %131 = load float, ptr %130, align 4, !dbg !245
  %132 = insertelement <8 x float> %123, float %131, i64 %122, !dbg !245
  %133 = add i64 %122, 1, !dbg !245
  br label %121, !dbg !245

134:                                              ; preds = %121
  %135 = extractvalue [8 x <8 x float>] %28, 0, !dbg !246
  %136 = mul nuw nsw i64 %25, 32, !dbg !246
  %137 = add nuw nsw i64 %136, %27, !dbg !246
  %138 = getelementptr inbounds nuw float, ptr %11, i64 %137, !dbg !246
  %139 = load float, ptr %138, align 4, !dbg !246
  %140 = insertelement <8 x float> poison, float %139, i32 0, !dbg !246
  %141 = shufflevector <8 x float> %140, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !246
  %142 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %32, <8 x float> %141, <8 x float> %135), !dbg !246
  %143 = extractvalue [8 x <8 x float>] %28, 1, !dbg !246
  %144 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %45, <8 x float> %141, <8 x float> %143), !dbg !246
  %145 = extractvalue [8 x <8 x float>] %28, 2, !dbg !246
  %146 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %58, <8 x float> %141, <8 x float> %145), !dbg !246
  %147 = extractvalue [8 x <8 x float>] %28, 3, !dbg !246
  %148 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %71, <8 x float> %141, <8 x float> %147), !dbg !246
  %149 = extractvalue [8 x <8 x float>] %28, 4, !dbg !246
  %150 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %84, <8 x float> %141, <8 x float> %149), !dbg !246
  %151 = extractvalue [8 x <8 x float>] %28, 5, !dbg !246
  %152 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %97, <8 x float> %141, <8 x float> %151), !dbg !246
  %153 = extractvalue [8 x <8 x float>] %28, 6, !dbg !246
  %154 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %110, <8 x float> %141, <8 x float> %153), !dbg !246
  %155 = extractvalue [8 x <8 x float>] %28, 7, !dbg !246
  %156 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %123, <8 x float> %141, <8 x float> %155), !dbg !246
  %157 = insertvalue [8 x <8 x float>] poison, <8 x float> %142, 0, !dbg !246
  %158 = insertvalue [8 x <8 x float>] %157, <8 x float> %144, 1, !dbg !246
  %159 = insertvalue [8 x <8 x float>] %158, <8 x float> %146, 2, !dbg !246
  %160 = insertvalue [8 x <8 x float>] %159, <8 x float> %148, 3, !dbg !246
  %161 = insertvalue [8 x <8 x float>] %160, <8 x float> %150, 4, !dbg !246
  %162 = insertvalue [8 x <8 x float>] %161, <8 x float> %152, 5, !dbg !246
  %163 = insertvalue [8 x <8 x float>] %162, <8 x float> %154, 6, !dbg !246
  %164 = insertvalue [8 x <8 x float>] %163, <8 x float> %156, 7, !dbg !246
  %165 = add i64 %27, 1, !dbg !245
  br label %26, !dbg !245

166:                                              ; preds = %26
  %167 = extractvalue [8 x <8 x float>] %28, 0, !dbg !245
  %168 = mul i64 %25, 64, !dbg !245
  %169 = add i64 %168, 0, !dbg !245
  %170 = add i64 %169, 0, !dbg !245
  %171 = getelementptr float, ptr %16, i64 %170, !dbg !245
  store <8 x float> %167, ptr %171, align 4, !dbg !245
  %172 = extractvalue [8 x <8 x float>] %28, 1, !dbg !245
  %173 = add i64 %168, 8, !dbg !245
  %174 = add i64 %173, 0, !dbg !245
  %175 = getelementptr float, ptr %16, i64 %174, !dbg !245
  store <8 x float> %172, ptr %175, align 4, !dbg !245
  %176 = extractvalue [8 x <8 x float>] %28, 2, !dbg !245
  %177 = add i64 %168, 16, !dbg !245
  %178 = add i64 %177, 0, !dbg !245
  %179 = getelementptr float, ptr %16, i64 %178, !dbg !245
  store <8 x float> %176, ptr %179, align 4, !dbg !245
  %180 = extractvalue [8 x <8 x float>] %28, 3, !dbg !245
  %181 = add i64 %168, 24, !dbg !245
  %182 = add i64 %181, 0, !dbg !245
  %183 = getelementptr float, ptr %16, i64 %182, !dbg !245
  store <8 x float> %180, ptr %183, align 4, !dbg !245
  %184 = extractvalue [8 x <8 x float>] %28, 4, !dbg !245
  %185 = add i64 %168, 32, !dbg !245
  %186 = add i64 %185, 0, !dbg !245
  %187 = getelementptr float, ptr %16, i64 %186, !dbg !245
  store <8 x float> %184, ptr %187, align 4, !dbg !245
  %188 = extractvalue [8 x <8 x float>] %28, 5, !dbg !245
  %189 = add i64 %168, 40, !dbg !245
  %190 = add i64 %189, 0, !dbg !245
  %191 = getelementptr float, ptr %16, i64 %190, !dbg !245
  store <8 x float> %188, ptr %191, align 4, !dbg !245
  %192 = extractvalue [8 x <8 x float>] %28, 6, !dbg !245
  %193 = add i64 %168, 48, !dbg !245
  %194 = add i64 %193, 0, !dbg !245
  %195 = getelementptr float, ptr %16, i64 %194, !dbg !245
  store <8 x float> %192, ptr %195, align 4, !dbg !245
  %196 = extractvalue [8 x <8 x float>] %28, 7, !dbg !245
  %197 = add i64 %168, 56, !dbg !245
  %198 = add i64 %197, 0, !dbg !245
  %199 = getelementptr float, ptr %16, i64 %198, !dbg !245
  store <8 x float> %196, ptr %199, align 4, !dbg !245
  %200 = add i64 %22, 1, !dbg !245
  br label %21, !dbg !245

201:                                              ; preds = %21
  ret i32 0, !dbg !247
}

define internal i32 @infer_dispatch_13_reduction_64x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !248 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !249
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !249
  %6 = load ptr, ptr %5, align 8, !dbg !249
  %7 = getelementptr float, ptr %6, i64 10496, !dbg !249
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !249
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !250
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !250
  %10 = load ptr, ptr %9, align 8, !dbg !250
  %11 = getelementptr float, ptr %10, i64 6400, !dbg !250
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !250
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !251
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !251
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !251
  %15 = load ptr, ptr %14, align 8, !dbg !251
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !251
  %16 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !252
  %17 = extractvalue %iree_hal_executable_workgroup_state_v0_t %16, 0, !dbg !252
  %18 = zext i32 %17 to i64, !dbg !252
  %19 = mul nsw i64 %18, 8, !dbg !252
  br label %20, !dbg !252

20:                                               ; preds = %114, %3
  %21 = phi i64 [ %117, %114 ], [ 0, %3 ], !dbg !252
  %22 = icmp slt i64 %21, 8, !dbg !252
  br i1 %22, label %23, label %118, !dbg !252

23:                                               ; preds = %20
  %24 = add i64 %21, %19, !dbg !252
  %25 = getelementptr float, ptr @__constant_64xf32_0, i64 %24, !dbg !252
  %26 = load <4 x float>, ptr %25, align 4, !dbg !252
  %27 = shufflevector <4 x float> %26, <4 x float> %26, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !252
  %28 = shufflevector <16 x float> %27, <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %29 = shufflevector <16 x float> %27, <16 x float> %28, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %30 = shufflevector <16 x float> %27, <16 x float> %29, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %31 = shufflevector <16 x float> %27, <16 x float> %30, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 0, i32 1, i32 2, i32 3>, !dbg !252
  %32 = shufflevector <16 x float> %31, <16 x float> %31, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>, !dbg !252
  %33 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, !dbg !252
  %34 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 4, i32 5, i32 6, i32 7>, !dbg !252
  %35 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 8, i32 9, i32 10, i32 11>, !dbg !252
  %36 = shufflevector <16 x float> %32, <16 x float> %32, <4 x i32> <i32 12, i32 13, i32 14, i32 15>, !dbg !252
  %37 = getelementptr float, ptr @__constant_64xf32_1, i64 %24, !dbg !252
  %38 = load <4 x float>, ptr %37, align 4, !dbg !252
  %39 = shufflevector <4 x float> %38, <4 x float> %38, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !252
  %40 = shufflevector <16 x float> %39, <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %41 = shufflevector <16 x float> %39, <16 x float> %40, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %42 = shufflevector <16 x float> %39, <16 x float> %41, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 28, i32 29, i32 30, i32 31>, !dbg !252
  %43 = shufflevector <16 x float> %39, <16 x float> %42, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 0, i32 1, i32 2, i32 3>, !dbg !252
  %44 = shufflevector <16 x float> %43, <16 x float> %43, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>, !dbg !252
  %45 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, !dbg !252
  %46 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 4, i32 5, i32 6, i32 7>, !dbg !252
  %47 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 8, i32 9, i32 10, i32 11>, !dbg !252
  %48 = shufflevector <16 x float> %44, <16 x float> %44, <4 x i32> <i32 12, i32 13, i32 14, i32 15>, !dbg !252
  br label %49, !dbg !252

49:                                               ; preds = %53, %23
  %50 = phi i64 [ %113, %53 ], [ 0, %23 ], !dbg !252
  %51 = phi <4 x float> [ %112, %53 ], [ zeroinitializer, %23 ], !dbg !252
  %52 = icmp slt i64 %50, 64, !dbg !252
  br i1 %52, label %53, label %114, !dbg !252

53:                                               ; preds = %49
  %54 = mul i64 %24, 64, !dbg !252
  %55 = add i64 %54, %50, !dbg !252
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !252
  %57 = load <4 x float>, ptr %56, align 4, !dbg !252
  %58 = add i64 %24, 1, !dbg !252
  %59 = mul i64 %58, 64, !dbg !252
  %60 = add i64 %59, %50, !dbg !252
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !252
  %62 = load <4 x float>, ptr %61, align 4, !dbg !252
  %63 = add i64 %24, 2, !dbg !252
  %64 = mul i64 %63, 64, !dbg !252
  %65 = add i64 %64, %50, !dbg !252
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !252
  %67 = load <4 x float>, ptr %66, align 4, !dbg !252
  %68 = add i64 %24, 3, !dbg !252
  %69 = mul i64 %68, 64, !dbg !252
  %70 = add i64 %69, %50, !dbg !252
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !252
  %72 = load <4 x float>, ptr %71, align 4, !dbg !252
  %73 = getelementptr float, ptr %11, i64 %55, !dbg !252
  %74 = load <4 x float>, ptr %73, align 4, !dbg !252
  %75 = getelementptr float, ptr %11, i64 %60, !dbg !252
  %76 = load <4 x float>, ptr %75, align 4, !dbg !252
  %77 = getelementptr float, ptr %11, i64 %65, !dbg !252
  %78 = load <4 x float>, ptr %77, align 4, !dbg !252
  %79 = getelementptr float, ptr %11, i64 %70, !dbg !252
  %80 = load <4 x float>, ptr %79, align 4, !dbg !252
  %81 = fadd contract <4 x float> %74, %45, !dbg !253
  %82 = fadd contract <4 x float> %76, %46, !dbg !253
  %83 = fadd contract <4 x float> %78, %47, !dbg !253
  %84 = fadd contract <4 x float> %80, %48, !dbg !253
  %85 = fadd contract <4 x float> %57, %33, !dbg !254
  %86 = fadd contract <4 x float> %62, %34, !dbg !254
  %87 = fadd contract <4 x float> %67, %35, !dbg !254
  %88 = fadd contract <4 x float> %72, %36, !dbg !254
  %89 = fadd contract <4 x float> %85, %81, !dbg !255
  %90 = fadd contract <4 x float> %86, %82, !dbg !255
  %91 = fadd contract <4 x float> %87, %83, !dbg !255
  %92 = fadd contract <4 x float> %88, %84, !dbg !255
  %93 = fcmp ugt <4 x float> %89, zeroinitializer, !dbg !256
  %94 = fcmp ugt <4 x float> %90, zeroinitializer, !dbg !256
  %95 = fcmp ugt <4 x float> %91, zeroinitializer, !dbg !256
  %96 = fcmp ugt <4 x float> %92, zeroinitializer, !dbg !256
  %97 = select <4 x i1> %93, <4 x float> %89, <4 x float> zeroinitializer, !dbg !257
  %98 = select <4 x i1> %94, <4 x float> %90, <4 x float> zeroinitializer, !dbg !257
  %99 = select <4 x i1> %95, <4 x float> %91, <4 x float> zeroinitializer, !dbg !257
  %100 = select <4 x i1> %96, <4 x float> %92, <4 x float> zeroinitializer, !dbg !257
  %101 = extractelement <4 x float> %51, i64 0, !dbg !258
  %102 = call float @llvm.vector.reduce.fadd.v4f32(float %101, <4 x float> %97), !dbg !258
  %103 = extractelement <4 x float> %51, i64 1, !dbg !258
  %104 = call float @llvm.vector.reduce.fadd.v4f32(float %103, <4 x float> %98), !dbg !258
  %105 = extractelement <4 x float> %51, i64 2, !dbg !258
  %106 = call float @llvm.vector.reduce.fadd.v4f32(float %105, <4 x float> %99), !dbg !258
  %107 = extractelement <4 x float> %51, i64 3, !dbg !258
  %108 = call float @llvm.vector.reduce.fadd.v4f32(float %107, <4 x float> %100), !dbg !258
  %109 = insertelement <4 x float> poison, float %102, i64 0, !dbg !258
  %110 = insertelement <4 x float> %109, float %104, i64 1, !dbg !258
  %111 = insertelement <4 x float> %110, float %106, i64 2, !dbg !258
  %112 = insertelement <4 x float> %111, float %108, i64 3, !dbg !258
  %113 = add i64 %50, 4, !dbg !252
  br label %49, !dbg !252

114:                                              ; preds = %49
  %115 = fdiv <4 x float> %51, splat (float 6.400000e+01), !dbg !259
  %116 = getelementptr float, ptr %15, i64 %24, !dbg !252
  store <4 x float> %115, ptr %116, align 4, !dbg !252
  %117 = add i64 %21, 4, !dbg !252
  br label %20, !dbg !252

118:                                              ; preds = %20
  ret i32 0, !dbg !260
}

define internal i32 @infer_dispatch_14_matmul_1x10x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !261 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !262
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !262
  %6 = load ptr, ptr %5, align 8, !dbg !262
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !262
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !263
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !263
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !263
  %10 = load ptr, ptr %9, align 8, !dbg !263
  %11 = getelementptr float, ptr %10, i64 76720, !dbg !263
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !263
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !264
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !264
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !264
  %15 = load ptr, ptr %14, align 8, !dbg !264
  %16 = getelementptr float, ptr %15, i64 64, !dbg !264
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !264
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !265
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !265
  %19 = zext i32 %18 to i64, !dbg !265
  %20 = mul nsw i64 %19, 5, !dbg !265
  br label %21, !dbg !265

21:                                               ; preds = %25, %3
  %22 = phi i64 [ %122, %25 ], [ 0, %3 ], !dbg !265
  %23 = phi <5 x float> [ %121, %25 ], [ zeroinitializer, %3 ], !dbg !265
  %24 = icmp slt i64 %22, 64, !dbg !265
  br i1 %24, label %25, label %123, !dbg !265

25:                                               ; preds = %21
  %26 = mul i64 %20, 64, !dbg !265
  %27 = add i64 %26, %22, !dbg !265
  %28 = getelementptr float, ptr %11, i64 %27, !dbg !265
  %29 = load <4 x float>, ptr %28, align 4, !dbg !265
  %30 = add i64 %20, 1, !dbg !265
  %31 = mul i64 %30, 64, !dbg !265
  %32 = add i64 %31, %22, !dbg !265
  %33 = getelementptr float, ptr %11, i64 %32, !dbg !265
  %34 = load <4 x float>, ptr %33, align 4, !dbg !265
  %35 = add i64 %20, 2, !dbg !265
  %36 = mul i64 %35, 64, !dbg !265
  %37 = add i64 %36, %22, !dbg !265
  %38 = getelementptr float, ptr %11, i64 %37, !dbg !265
  %39 = load <4 x float>, ptr %38, align 4, !dbg !265
  %40 = add i64 %20, 3, !dbg !265
  %41 = mul i64 %40, 64, !dbg !265
  %42 = add i64 %41, %22, !dbg !265
  %43 = getelementptr float, ptr %11, i64 %42, !dbg !265
  %44 = load <4 x float>, ptr %43, align 4, !dbg !265
  %45 = add i64 %20, 4, !dbg !265
  %46 = mul i64 %45, 64, !dbg !265
  %47 = add i64 %46, %22, !dbg !265
  %48 = getelementptr float, ptr %11, i64 %47, !dbg !265
  %49 = load <4 x float>, ptr %48, align 4, !dbg !265
  %50 = extractelement <4 x float> %29, i64 0, !dbg !265
  %51 = extractelement <4 x float> %29, i64 1, !dbg !265
  %52 = extractelement <4 x float> %29, i64 2, !dbg !265
  %53 = extractelement <4 x float> %29, i64 3, !dbg !265
  %54 = extractelement <4 x float> %34, i64 0, !dbg !265
  %55 = extractelement <4 x float> %34, i64 1, !dbg !265
  %56 = extractelement <4 x float> %34, i64 2, !dbg !265
  %57 = extractelement <4 x float> %34, i64 3, !dbg !265
  %58 = extractelement <4 x float> %39, i64 0, !dbg !265
  %59 = extractelement <4 x float> %39, i64 1, !dbg !265
  %60 = extractelement <4 x float> %39, i64 2, !dbg !265
  %61 = extractelement <4 x float> %39, i64 3, !dbg !265
  %62 = extractelement <4 x float> %44, i64 0, !dbg !265
  %63 = extractelement <4 x float> %44, i64 1, !dbg !265
  %64 = extractelement <4 x float> %44, i64 2, !dbg !265
  %65 = extractelement <4 x float> %44, i64 3, !dbg !265
  %66 = extractelement <4 x float> %49, i64 0, !dbg !265
  %67 = extractelement <4 x float> %49, i64 1, !dbg !265
  %68 = extractelement <4 x float> %49, i64 2, !dbg !265
  %69 = extractelement <4 x float> %49, i64 3, !dbg !265
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
  %122 = add i64 %22, 4, !dbg !265
  br label %21, !dbg !265

123:                                              ; preds = %21
  %124 = add i64 0, %20, !dbg !266
  %125 = getelementptr float, ptr @__constant_1x10xf32, i64 %124, !dbg !266
  %126 = load <5 x float>, ptr %125, align 4, !dbg !266
  %127 = fadd contract <5 x float> %23, %126, !dbg !267
  %128 = getelementptr float, ptr %16, i64 %124, !dbg !267
  store <5 x float> %127, ptr %128, align 4, !dbg !267
  ret i32 0, !dbg !268
}

define internal i32 @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !269 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !270
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !270
  %6 = load ptr, ptr %5, align 8, !dbg !270
  %7 = getelementptr float, ptr %6, i64 64, !dbg !270
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !270
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !271
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !271
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !271
  %11 = load ptr, ptr %10, align 8, !dbg !271
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !271
  br label %12, !dbg !272

12:                                               ; preds = %16, %3
  %13 = phi i64 [ %23, %16 ], [ 0, %3 ], !dbg !272
  %14 = phi <1 x float> [ %22, %16 ], [ splat (float 0xFFF8000000000000), %3 ], !dbg !272
  %15 = icmp slt i64 %13, 8, !dbg !272
  br i1 %15, label %16, label %24, !dbg !272

16:                                               ; preds = %12
  %17 = getelementptr float, ptr %7, i64 %13, !dbg !272
  %18 = load <4 x float>, ptr %17, align 4, !dbg !272
  %19 = extractelement <1 x float> %14, i64 0, !dbg !272
  %20 = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> %18), !dbg !273
  %21 = call float @llvm.maxnum.f32(float %20, float %19), !dbg !273
  %22 = insertelement <1 x float> poison, float %21, i32 0, !dbg !272
  %23 = add i64 %13, 4, !dbg !272
  br label %12, !dbg !272

24:                                               ; preds = %12
  %25 = getelementptr float, ptr %7, i32 8, !dbg !272
  %26 = load <2 x float>, ptr %25, align 4, !dbg !272
  %27 = extractelement <1 x float> %14, i64 0, !dbg !272
  %28 = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> %26), !dbg !273
  %29 = call float @llvm.maxnum.f32(float %28, float %27), !dbg !273
  %30 = insertelement <4 x float> poison, float %29, i32 0, !dbg !274
  %31 = shufflevector <4 x float> %30, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !274
  br label %32, !dbg !274

32:                                               ; preds = %36, %24
  %33 = phi i64 [ %68, %36 ], [ 0, %24 ], !dbg !274
  %34 = phi <1 x float> [ %67, %36 ], [ zeroinitializer, %24 ], !dbg !274
  %35 = icmp slt i64 %33, 8, !dbg !274
  br i1 %35, label %36, label %69, !dbg !274

36:                                               ; preds = %32
  %37 = getelementptr float, ptr %7, i64 %33, !dbg !274
  %38 = load <4 x float>, ptr %37, align 4, !dbg !274
  %39 = extractelement <1 x float> %34, i64 0, !dbg !274
  %40 = fsub contract <4 x float> %38, %31, !dbg !275
  %41 = fcmp uge <4 x float> %40, splat (float 0xC055F33340000000), !dbg !276
  %42 = select <4 x i1> %41, <4 x float> %40, <4 x float> splat (float 0xC055F33340000000), !dbg !276
  %43 = fcmp ule <4 x float> %42, splat (float 0x4056333340000000), !dbg !276
  %44 = select <4 x i1> %43, <4 x float> %42, <4 x float> splat (float 0x4056333340000000), !dbg !276
  %45 = call <4 x float> @llvm.fma.v4f32(<4 x float> %44, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !276
  %46 = call <4 x float> @llvm.floor.v4f32(<4 x float> %45), !dbg !276
  %47 = fcmp uge <4 x float> %46, splat (float -1.270000e+02), !dbg !276
  %48 = select <4 x i1> %47, <4 x float> %46, <4 x float> splat (float -1.270000e+02), !dbg !276
  %49 = fcmp ule <4 x float> %48, splat (float 1.270000e+02), !dbg !276
  %50 = select <4 x i1> %49, <4 x float> %48, <4 x float> splat (float 1.270000e+02), !dbg !276
  %51 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0xBFE6300000000000), <4 x float> %50, <4 x float> %44), !dbg !276
  %52 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0x3F2BD01060000000), <4 x float> %50, <4 x float> %51), !dbg !276
  %53 = call <4 x float> @llvm.fma.v4f32(<4 x float> %52, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !276
  %54 = call <4 x float> @llvm.fma.v4f32(<4 x float> %53, <4 x float> %52, <4 x float> splat (float 0x3F81112100000000)), !dbg !276
  %55 = call <4 x float> @llvm.fma.v4f32(<4 x float> %54, <4 x float> %52, <4 x float> splat (float 0x3FA5553820000000)), !dbg !276
  %56 = call <4 x float> @llvm.fma.v4f32(<4 x float> %55, <4 x float> %52, <4 x float> splat (float 0x3FC5555540000000)), !dbg !276
  %57 = call <4 x float> @llvm.fma.v4f32(<4 x float> %56, <4 x float> %52, <4 x float> splat (float 5.000000e-01)), !dbg !276
  %58 = fmul contract <4 x float> %52, %52, !dbg !276
  %59 = call <4 x float> @llvm.fma.v4f32(<4 x float> %57, <4 x float> %58, <4 x float> %52), !dbg !276
  %60 = fadd contract <4 x float> %59, splat (float 1.000000e+00), !dbg !276
  %61 = fptosi <4 x float> %50 to <4 x i32>, !dbg !276
  %62 = add <4 x i32> %61, splat (i32 127), !dbg !276
  %63 = shl <4 x i32> %62, splat (i32 23), !dbg !276
  %64 = bitcast <4 x i32> %63 to <4 x float>, !dbg !276
  %65 = fmul contract <4 x float> %60, %64, !dbg !276
  %66 = call float @llvm.vector.reduce.fadd.v4f32(float %39, <4 x float> %65), !dbg !277
  %67 = insertelement <1 x float> poison, float %66, i32 0, !dbg !274
  %68 = add i64 %33, 4, !dbg !274
  br label %32, !dbg !274

69:                                               ; preds = %32
  %70 = insertelement <2 x float> poison, float %29, i32 0, !dbg !274
  %71 = shufflevector <2 x float> %70, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !274
  %72 = extractelement <1 x float> %34, i64 0, !dbg !274
  %73 = fsub contract <2 x float> %26, %71, !dbg !275
  %74 = fcmp uge <2 x float> %73, splat (float 0xC055F33340000000), !dbg !276
  %75 = select <2 x i1> %74, <2 x float> %73, <2 x float> splat (float 0xC055F33340000000), !dbg !276
  %76 = fcmp ule <2 x float> %75, splat (float 0x4056333340000000), !dbg !276
  %77 = select <2 x i1> %76, <2 x float> %75, <2 x float> splat (float 0x4056333340000000), !dbg !276
  %78 = call <2 x float> @llvm.fma.v2f32(<2 x float> %77, <2 x float> splat (float 0x3FF7154760000000), <2 x float> splat (float 5.000000e-01)), !dbg !276
  %79 = call <2 x float> @llvm.floor.v2f32(<2 x float> %78), !dbg !276
  %80 = fcmp uge <2 x float> %79, splat (float -1.270000e+02), !dbg !276
  %81 = select <2 x i1> %80, <2 x float> %79, <2 x float> splat (float -1.270000e+02), !dbg !276
  %82 = fcmp ule <2 x float> %81, splat (float 1.270000e+02), !dbg !276
  %83 = select <2 x i1> %82, <2 x float> %81, <2 x float> splat (float 1.270000e+02), !dbg !276
  %84 = call <2 x float> @llvm.fma.v2f32(<2 x float> splat (float 0xBFE6300000000000), <2 x float> %83, <2 x float> %77), !dbg !276
  %85 = call <2 x float> @llvm.fma.v2f32(<2 x float> splat (float 0x3F2BD01060000000), <2 x float> %83, <2 x float> %84), !dbg !276
  %86 = call <2 x float> @llvm.fma.v2f32(<2 x float> %85, <2 x float> splat (float 0x3F2A0D2CE0000000), <2 x float> splat (float 0x3F56E879C0000000)), !dbg !276
  %87 = call <2 x float> @llvm.fma.v2f32(<2 x float> %86, <2 x float> %85, <2 x float> splat (float 0x3F81112100000000)), !dbg !276
  %88 = call <2 x float> @llvm.fma.v2f32(<2 x float> %87, <2 x float> %85, <2 x float> splat (float 0x3FA5553820000000)), !dbg !276
  %89 = call <2 x float> @llvm.fma.v2f32(<2 x float> %88, <2 x float> %85, <2 x float> splat (float 0x3FC5555540000000)), !dbg !276
  %90 = call <2 x float> @llvm.fma.v2f32(<2 x float> %89, <2 x float> %85, <2 x float> splat (float 5.000000e-01)), !dbg !276
  %91 = fmul contract <2 x float> %85, %85, !dbg !276
  %92 = call <2 x float> @llvm.fma.v2f32(<2 x float> %90, <2 x float> %91, <2 x float> %85), !dbg !276
  %93 = fadd contract <2 x float> %92, splat (float 1.000000e+00), !dbg !276
  %94 = fptosi <2 x float> %83 to <2 x i32>, !dbg !276
  %95 = add <2 x i32> %94, splat (i32 127), !dbg !276
  %96 = shl <2 x i32> %95, splat (i32 23), !dbg !276
  %97 = bitcast <2 x i32> %96 to <2 x float>, !dbg !276
  %98 = fmul contract <2 x float> %93, %97, !dbg !276
  %99 = call float @llvm.vector.reduce.fadd.v2f32(float %72, <2 x float> %98), !dbg !277
  %100 = insertelement <4 x float> poison, float %99, i32 0, !dbg !278
  %101 = shufflevector <4 x float> %100, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !278
  br label %102, !dbg !278

102:                                              ; preds = %105, %69
  %103 = phi i64 [ %136, %105 ], [ 0, %69 ], !dbg !278
  %104 = icmp slt i64 %103, 8, !dbg !278
  br i1 %104, label %105, label %137, !dbg !278

105:                                              ; preds = %102
  %106 = getelementptr float, ptr %7, i64 %103, !dbg !278
  %107 = load <4 x float>, ptr %106, align 4, !dbg !278
  %108 = fsub contract <4 x float> %107, %31, !dbg !279
  %109 = fcmp uge <4 x float> %108, splat (float 0xC055F33340000000), !dbg !280
  %110 = select <4 x i1> %109, <4 x float> %108, <4 x float> splat (float 0xC055F33340000000), !dbg !280
  %111 = fcmp ule <4 x float> %110, splat (float 0x4056333340000000), !dbg !280
  %112 = select <4 x i1> %111, <4 x float> %110, <4 x float> splat (float 0x4056333340000000), !dbg !280
  %113 = call <4 x float> @llvm.fma.v4f32(<4 x float> %112, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !280
  %114 = call <4 x float> @llvm.floor.v4f32(<4 x float> %113), !dbg !280
  %115 = fcmp uge <4 x float> %114, splat (float -1.270000e+02), !dbg !280
  %116 = select <4 x i1> %115, <4 x float> %114, <4 x float> splat (float -1.270000e+02), !dbg !280
  %117 = fcmp ule <4 x float> %116, splat (float 1.270000e+02), !dbg !280
  %118 = select <4 x i1> %117, <4 x float> %116, <4 x float> splat (float 1.270000e+02), !dbg !280
  %119 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0xBFE6300000000000), <4 x float> %118, <4 x float> %112), !dbg !280
  %120 = call <4 x float> @llvm.fma.v4f32(<4 x float> splat (float 0x3F2BD01060000000), <4 x float> %118, <4 x float> %119), !dbg !280
  %121 = call <4 x float> @llvm.fma.v4f32(<4 x float> %120, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !280
  %122 = call <4 x float> @llvm.fma.v4f32(<4 x float> %121, <4 x float> %120, <4 x float> splat (float 0x3F81112100000000)), !dbg !280
  %123 = call <4 x float> @llvm.fma.v4f32(<4 x float> %122, <4 x float> %120, <4 x float> splat (float 0x3FA5553820000000)), !dbg !280
  %124 = call <4 x float> @llvm.fma.v4f32(<4 x float> %123, <4 x float> %120, <4 x float> splat (float 0x3FC5555540000000)), !dbg !280
  %125 = call <4 x float> @llvm.fma.v4f32(<4 x float> %124, <4 x float> %120, <4 x float> splat (float 5.000000e-01)), !dbg !280
  %126 = fmul contract <4 x float> %120, %120, !dbg !280
  %127 = call <4 x float> @llvm.fma.v4f32(<4 x float> %125, <4 x float> %126, <4 x float> %120), !dbg !280
  %128 = fadd contract <4 x float> %127, splat (float 1.000000e+00), !dbg !280
  %129 = fptosi <4 x float> %118 to <4 x i32>, !dbg !280
  %130 = add <4 x i32> %129, splat (i32 127), !dbg !280
  %131 = shl <4 x i32> %130, splat (i32 23), !dbg !280
  %132 = bitcast <4 x i32> %131 to <4 x float>, !dbg !280
  %133 = fmul contract <4 x float> %128, %132, !dbg !280
  %134 = fdiv <4 x float> %133, %101, !dbg !281
  %135 = getelementptr float, ptr %11, i64 %103, !dbg !278
  store <4 x float> %134, ptr %135, align 4, !dbg !278
  %136 = add i64 %103, 4, !dbg !278
  br label %102, !dbg !278

137:                                              ; preds = %102
  %138 = insertelement <2 x float> poison, float %99, i32 0, !dbg !278
  %139 = shufflevector <2 x float> %138, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !278
  %140 = fdiv <2 x float> %98, %139, !dbg !281
  %141 = getelementptr float, ptr %11, i32 8, !dbg !278
  store <2 x float> %140, ptr %141, align 4, !dbg !278
  ret i32 0, !dbg !282
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

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { uwtable "nonlazybind" }

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22, !24, !26, !28, !30}
!llvm.module.flags = !{!32}

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
!33 = distinct !DISubprogram(name: "infer_dispatch_0_slow_memcpy", linkageName: "infer_dispatch_0_slow_memcpy", scope: !1, file: !1, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!34 = !DISubroutineType(cc: DW_CC_normal, types: !35)
!35 = !{!36, !37, !68, !97}
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !41, file: !41, line: 246, size: 768, elements: !42)
!41 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!42 = !{!43, !51, !54, !57, !59}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !46)
!46 = !DICompositeType(tag: DW_TAG_array_type, scope: !41, file: !41, line: 227, baseType: !47, size: 2048, elements: !49)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !48)
!48 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!49 = !{!50}
!50 = !DISubrange(count: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !52, size: 64, offset: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !55, size: 64, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !58, size: 64, offset: 192)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !60, offset: 256)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !41, file: !41, line: 227, size: 512, elements: !61)
!61 = !{!62}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !63)
!63 = !DICompositeType(tag: DW_TAG_array_type, scope: !41, file: !41, line: 227, baseType: !64, size: 512, elements: !66)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !65)
!65 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!66 = !{!67}
!67 = !DISubrange(count: 8)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !70)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !71)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !41, file: !41, line: 275, size: 384, elements: !72)
!72 = !{!73, !74, !75, !78, !79, !80, !81, !82, !85, !86, !87, !92}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !47, size: 32)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !47, size: 32, offset: 32)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !76, size: 16, offset: 64)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !77)
!77 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !76, size: 16, offset: 80)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !47, size: 32, offset: 96)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !47, size: 32, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !76, size: 16, offset: 160)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !83, size: 8, offset: 176)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !84)
!84 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !83, size: 8, offset: 184)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !44, size: 64, offset: 192)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !88, size: 64, offset: 256)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !90)
!90 = !DICompositeType(tag: DW_TAG_array_type, scope: !41, file: !41, line: 227, baseType: !91, size: 4096, elements: !49)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !93, size: 64, offset: 320)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !95)
!95 = !DICompositeType(tag: DW_TAG_array_type, scope: !41, file: !41, line: 227, baseType: !96, size: 4096, elements: !49)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !99)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !100)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !41, file: !41, line: 321, size: 256, elements: !101)
!101 = !{!102, !103, !104, !105, !106, !107, !108}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !47, size: 32)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !47, size: 32, offset: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !76, size: 16, offset: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !76, size: 16, offset: 80)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !47, size: 32, offset: 96)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !52, size: 64, offset: 128)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !47, size: 32, offset: 192)
!109 = !DILocation(line: 10, column: 8, scope: !33)
!110 = !DILocation(line: 11, column: 8, scope: !33)
!111 = !DILocation(line: 12, column: 8, scope: !33)
!112 = !DILocation(line: 13, column: 8, scope: !33)
!113 = !DILocation(line: 15, column: 8, scope: !33)
!114 = !DILocation(line: 19, column: 8, scope: !33)
!115 = distinct !DISubprogram(name: "infer_dispatch_1_conv_16x32x32x3x3x3_f32", linkageName: "infer_dispatch_1_conv_16x32x32x3x3x3_f32", scope: !3, file: !3, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!116 = !DILocation(line: 21, column: 8, scope: !115)
!117 = !DILocation(line: 20, column: 8, scope: !115)
!118 = !DILocation(line: 14, column: 8, scope: !115)
!119 = !DILocation(line: 15, column: 8, scope: !115)
!120 = !DILocation(line: 16, column: 8, scope: !115)
!121 = !DILocation(line: 9, column: 8, scope: !115)
!122 = !DILocation(line: 27, column: 8, scope: !115)
!123 = !DILocation(line: 23, column: 10, scope: !115)
!124 = !DILocation(line: 24, column: 10, scope: !115)
!125 = !DILocation(line: 29, column: 10, scope: !115)
!126 = !DILocation(line: 30, column: 10, scope: !115)
!127 = !DILocation(line: 31, column: 10, scope: !115)
!128 = !DILocation(line: 35, column: 8, scope: !115)
!129 = distinct !DISubprogram(name: "infer_dispatch_2_slow_memcpy", linkageName: "infer_dispatch_2_slow_memcpy", scope: !5, file: !5, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!130 = !DILocation(line: 11, column: 8, scope: !129)
!131 = !DILocation(line: 12, column: 8, scope: !129)
!132 = !DILocation(line: 13, column: 8, scope: !129)
!133 = !DILocation(line: 14, column: 8, scope: !129)
!134 = !DILocation(line: 16, column: 8, scope: !129)
!135 = !DILocation(line: 20, column: 8, scope: !129)
!136 = distinct !DISubprogram(name: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", scope: !7, file: !7, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!137 = !DILocation(line: 21, column: 8, scope: !136)
!138 = !DILocation(line: 20, column: 8, scope: !136)
!139 = !DILocation(line: 14, column: 8, scope: !136)
!140 = !DILocation(line: 15, column: 8, scope: !136)
!141 = !DILocation(line: 16, column: 8, scope: !136)
!142 = !DILocation(line: 9, column: 8, scope: !136)
!143 = !DILocation(line: 27, column: 8, scope: !136)
!144 = !DILocation(line: 23, column: 10, scope: !136)
!145 = !DILocation(line: 24, column: 10, scope: !136)
!146 = !DILocation(line: 29, column: 10, scope: !136)
!147 = !DILocation(line: 30, column: 10, scope: !136)
!148 = !DILocation(line: 31, column: 10, scope: !136)
!149 = !DILocation(line: 35, column: 8, scope: !136)
!150 = distinct !DISubprogram(name: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", scope: !9, file: !9, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!151 = !DILocation(line: 24, column: 8, scope: !150)
!152 = !DILocation(line: 23, column: 8, scope: !150)
!153 = !DILocation(line: 15, column: 8, scope: !150)
!154 = !DILocation(line: 16, column: 8, scope: !150)
!155 = !DILocation(line: 17, column: 8, scope: !150)
!156 = !DILocation(line: 18, column: 8, scope: !150)
!157 = !DILocation(line: 9, column: 8, scope: !150)
!158 = !DILocation(line: 30, column: 8, scope: !150)
!159 = !DILocation(line: 26, column: 10, scope: !150)
!160 = !DILocation(line: 27, column: 10, scope: !150)
!161 = !DILocation(line: 32, column: 10, scope: !150)
!162 = !DILocation(line: 33, column: 10, scope: !150)
!163 = !DILocation(line: 34, column: 10, scope: !150)
!164 = !DILocation(line: 35, column: 10, scope: !150)
!165 = !DILocation(line: 39, column: 8, scope: !150)
!166 = distinct !DISubprogram(name: "infer_dispatch_5_slow_memcpy", linkageName: "infer_dispatch_5_slow_memcpy", scope: !11, file: !11, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!167 = !DILocation(line: 11, column: 8, scope: !166)
!168 = !DILocation(line: 12, column: 8, scope: !166)
!169 = !DILocation(line: 13, column: 8, scope: !166)
!170 = !DILocation(line: 14, column: 8, scope: !166)
!171 = !DILocation(line: 16, column: 8, scope: !166)
!172 = !DILocation(line: 20, column: 8, scope: !166)
!173 = distinct !DISubprogram(name: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", linkageName: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", scope: !13, file: !13, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!174 = !DILocation(line: 21, column: 8, scope: !173)
!175 = !DILocation(line: 20, column: 8, scope: !173)
!176 = !DILocation(line: 14, column: 8, scope: !173)
!177 = !DILocation(line: 15, column: 8, scope: !173)
!178 = !DILocation(line: 16, column: 8, scope: !173)
!179 = !DILocation(line: 9, column: 8, scope: !173)
!180 = !DILocation(line: 27, column: 8, scope: !173)
!181 = !DILocation(line: 23, column: 10, scope: !173)
!182 = !DILocation(line: 24, column: 10, scope: !173)
!183 = !DILocation(line: 29, column: 10, scope: !173)
!184 = !DILocation(line: 30, column: 10, scope: !173)
!185 = !DILocation(line: 31, column: 10, scope: !173)
!186 = !DILocation(line: 35, column: 8, scope: !173)
!187 = distinct !DISubprogram(name: "infer_dispatch_7_matmul_like_32x16x16x16_f32", linkageName: "infer_dispatch_7_matmul_like_32x16x16x16_f32", scope: !15, file: !15, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!188 = !DILocation(line: 13, column: 8, scope: !187)
!189 = !DILocation(line: 14, column: 8, scope: !187)
!190 = !DILocation(line: 15, column: 8, scope: !187)
!191 = !DILocation(line: 20, column: 8, scope: !187)
!192 = !DILocation(line: 23, column: 10, scope: !187)
!193 = !DILocation(line: 27, column: 8, scope: !187)
!194 = distinct !DISubprogram(name: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", linkageName: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", scope: !17, file: !17, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!195 = !DILocation(line: 25, column: 8, scope: !194)
!196 = !DILocation(line: 24, column: 8, scope: !194)
!197 = !DILocation(line: 16, column: 8, scope: !194)
!198 = !DILocation(line: 17, column: 8, scope: !194)
!199 = !DILocation(line: 18, column: 8, scope: !194)
!200 = !DILocation(line: 19, column: 8, scope: !194)
!201 = !DILocation(line: 9, column: 8, scope: !194)
!202 = !DILocation(line: 31, column: 8, scope: !194)
!203 = !DILocation(line: 27, column: 10, scope: !194)
!204 = !DILocation(line: 28, column: 10, scope: !194)
!205 = !DILocation(line: 33, column: 10, scope: !194)
!206 = !DILocation(line: 34, column: 10, scope: !194)
!207 = !DILocation(line: 35, column: 10, scope: !194)
!208 = !DILocation(line: 36, column: 10, scope: !194)
!209 = !DILocation(line: 37, column: 10, scope: !194)
!210 = !DILocation(line: 41, column: 8, scope: !194)
!211 = distinct !DISubprogram(name: "infer_dispatch_9_slow_memcpy", linkageName: "infer_dispatch_9_slow_memcpy", scope: !19, file: !19, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!212 = !DILocation(line: 11, column: 8, scope: !211)
!213 = !DILocation(line: 12, column: 8, scope: !211)
!214 = !DILocation(line: 13, column: 8, scope: !211)
!215 = !DILocation(line: 14, column: 8, scope: !211)
!216 = !DILocation(line: 16, column: 8, scope: !211)
!217 = !DILocation(line: 20, column: 8, scope: !211)
!218 = distinct !DISubprogram(name: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", linkageName: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", scope: !21, file: !21, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!219 = !DILocation(line: 21, column: 8, scope: !218)
!220 = !DILocation(line: 20, column: 8, scope: !218)
!221 = !DILocation(line: 14, column: 8, scope: !218)
!222 = !DILocation(line: 15, column: 8, scope: !218)
!223 = !DILocation(line: 16, column: 8, scope: !218)
!224 = !DILocation(line: 9, column: 8, scope: !218)
!225 = !DILocation(line: 27, column: 8, scope: !218)
!226 = !DILocation(line: 23, column: 10, scope: !218)
!227 = !DILocation(line: 24, column: 10, scope: !218)
!228 = !DILocation(line: 29, column: 10, scope: !218)
!229 = !DILocation(line: 30, column: 10, scope: !218)
!230 = !DILocation(line: 31, column: 10, scope: !218)
!231 = !DILocation(line: 35, column: 8, scope: !218)
!232 = distinct !DISubprogram(name: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", linkageName: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", scope: !23, file: !23, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!233 = !DILocation(line: 13, column: 8, scope: !232)
!234 = !DILocation(line: 14, column: 8, scope: !232)
!235 = !DILocation(line: 15, column: 8, scope: !232)
!236 = !DILocation(line: 20, column: 8, scope: !232)
!237 = !DILocation(line: 9, column: 8, scope: !232)
!238 = !DILocation(line: 22, column: 10, scope: !232)
!239 = !DILocation(line: 23, column: 10, scope: !232)
!240 = !DILocation(line: 27, column: 8, scope: !232)
!241 = distinct !DISubprogram(name: "infer_dispatch_12_matmul_like_64x8x8x32_f32", linkageName: "infer_dispatch_12_matmul_like_64x8x8x32_f32", scope: !25, file: !25, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !24)
!242 = !DILocation(line: 13, column: 8, scope: !241)
!243 = !DILocation(line: 14, column: 8, scope: !241)
!244 = !DILocation(line: 15, column: 8, scope: !241)
!245 = !DILocation(line: 20, column: 8, scope: !241)
!246 = !DILocation(line: 23, column: 10, scope: !241)
!247 = !DILocation(line: 27, column: 8, scope: !241)
!248 = distinct !DISubprogram(name: "infer_dispatch_13_reduction_64x64_f32", linkageName: "infer_dispatch_13_reduction_64x64_f32", scope: !27, file: !27, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !26)
!249 = !DILocation(line: 16, column: 8, scope: !248)
!250 = !DILocation(line: 17, column: 8, scope: !248)
!251 = !DILocation(line: 18, column: 8, scope: !248)
!252 = !DILocation(line: 23, column: 8, scope: !248)
!253 = !DILocation(line: 25, column: 10, scope: !248)
!254 = !DILocation(line: 26, column: 10, scope: !248)
!255 = !DILocation(line: 27, column: 10, scope: !248)
!256 = !DILocation(line: 28, column: 10, scope: !248)
!257 = !DILocation(line: 29, column: 10, scope: !248)
!258 = !DILocation(line: 30, column: 10, scope: !248)
!259 = !DILocation(line: 35, column: 10, scope: !248)
!260 = !DILocation(line: 39, column: 8, scope: !248)
!261 = distinct !DISubprogram(name: "infer_dispatch_14_matmul_1x10x64_f32", linkageName: "infer_dispatch_14_matmul_1x10x64_f32", scope: !29, file: !29, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !28)
!262 = !DILocation(line: 14, column: 8, scope: !261)
!263 = !DILocation(line: 15, column: 8, scope: !261)
!264 = !DILocation(line: 16, column: 8, scope: !261)
!265 = !DILocation(line: 21, column: 8, scope: !261)
!266 = !DILocation(line: 22, column: 8, scope: !261)
!267 = !DILocation(line: 24, column: 10, scope: !261)
!268 = !DILocation(line: 28, column: 8, scope: !261)
!269 = distinct !DISubprogram(name: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", linkageName: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", scope: !31, file: !31, line: 1, type: !34, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !30)
!270 = !DILocation(line: 13, column: 8, scope: !269)
!271 = !DILocation(line: 14, column: 8, scope: !269)
!272 = !DILocation(line: 19, column: 8, scope: !269)
!273 = !DILocation(line: 21, column: 10, scope: !269)
!274 = !DILocation(line: 25, column: 8, scope: !269)
!275 = !DILocation(line: 27, column: 10, scope: !269)
!276 = !DILocation(line: 28, column: 10, scope: !269)
!277 = !DILocation(line: 29, column: 10, scope: !269)
!278 = !DILocation(line: 32, column: 8, scope: !269)
!279 = !DILocation(line: 34, column: 10, scope: !269)
!280 = !DILocation(line: 35, column: 10, scope: !269)
!281 = !DILocation(line: 36, column: 10, scope: !269)
!282 = !DILocation(line: 40, column: 8, scope: !269)
