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

@__constant_16xf32 = internal unnamed_addr constant [16 x float] [float 0x3FE3797060000000, float 0x3FD49DDCC0000000, float 0x3FE640F5C0000000, float 0x3FD40A2FA0000000, float 0x3FE01243C0000000, float 0x3FC695D220000000, float 0x3FE08EB180000000, float 0x3FE30EF860000000, float 0x3FC76B6360000000, float 0x3FD379CD80000000, float 0x3FC29C33A0000000, float 0x3FE708B9E0000000, float 0x3FE7C54340000000, float 0xBFC6132FC0000000, float 0xBFEE139260000000, float 0x3FF71FC120000000], align 64
@__constant_16xf32_0 = internal unnamed_addr constant [16 x float] [float 0x400DC5B820000000, float 0xBFF1716C00000000, float 0x400554FC60000000, float 0x3FF5052840000000, float 0x400DA5E000000000, float 0x3FE0126680000000, float 0xBFE66B0200000000, float 0x3FDA8DED00000000, float 0x3FFC654DA0000000, float 0x3F8A0F9D40000000, float 0xC0123A1E40000000, float 0xBFF21E5360000000, float 0x3FDCC6F7C0000000, float 0x3FC168F9E0000000, float 0x3FC66AD700000000, float 0x3FF25C0F40000000], align 64
@__constant_16xf32_1 = internal unnamed_addr constant [16 x float] [float 0x3FEC967500000000, float 0x3FD028C620000000, float 0xBFCEC95980000000, float 0xBFF47E9940000000, float 0x3FB8D54C40000000, float 0x3FAC865DC0000000, float 0xBFD8763680000000, float 0xBFEDA1A0C0000000, float 0xBF880BF820000000, float 0x3FF2760720000000, float 0x3FF21BC7E0000000, float 0xBFCF8D5B60000000, float 0xBFC9F88EC0000000, float 0x3FC2C53260000000, float 0x3FE3231720000000, float 0xBFF13A7200000000], align 64
@__constant_32xf32 = internal unnamed_addr constant [32 x float] [float 0x3FF57BF880000000, float 0x3FD1691CA0000000, float 0x3FFAF39FA0000000, float 0xBFF789C0E0000000, float 0x4001B51D40000000, float 0x3FF8D4E640000000, float 0xBFED4DB340000000, float 0x3FFFA37320000000, float 0x3FF481FD40000000, float 0x3FE924C200000000, float 0xBFD35924E0000000, float 0x3FFBBE9D40000000, float 0x3FB8413E80000000, float 0xBFE6089200000000, float 0x3FFE238C80000000, float 0x3FDCA0D500000000, float 0x3FE3A10960000000, float 0xBFDC6A4E80000000, float 0xBFFA16C3E0000000, float 0x3FB507A0A0000000, float 0x3FD8155300000000, float 0xBFE0C303E0000000, float 0x3FD6EC3A00000000, float 0x3FEC9E0920000000, float 0x3FDBDCC320000000, float 0x3FBA8CC640000000, float 0x400681B980000000, float 0x3FCBC93300000000, float 0x3FE6EA2040000000, float 0x3FF515A9E0000000, float 0xBFC2906D80000000, float 0x3FED98EAA0000000], align 64
@__constant_32xf32_0 = internal unnamed_addr constant [32 x float] [float 0xBF89430180000000, float 0x3F62125DE0000000, float 0x3FC4FD1080000000, float 0xBFBF1F1980000000, float 0xBFB4C3AB00000000, float 0xBFC2A285A0000000, float 0xBF96D13E40000000, float 0x3FC1EAF5A0000000, float 0x3FD3E38680000000, float 0xBFBAAA3F80000000, float 0xBFBA4123E0000000, float 0xBFB0065CA0000000, float 0xBFCA1FD020000000, float 0xBFA22CFBA0000000, float 0x3FB01312E0000000, float 0x3FB3889700000000, float 0x3F9642F640000000, float 0xBFB5EBD7E0000000, float 0x3FCB0F9D20000000, float 0x3FC41F10A0000000, float 0xBFD0FF9A80000000, float 0x3FB9470FC0000000, float 0x3FC27050A0000000, float 0xBFC30D38C0000000, float 0x3F92535A40000000, float 0x3FAC076CE0000000, float 0xBFCF6648A0000000, float 0xBF82C22320000000, float 0x3FC95D6A40000000, float 0xBFCED06DA0000000, float 0x3FB8322360000000, float 0x3FD03CB660000000], align 64
@__constant_32xf32_1 = internal unnamed_addr constant [32 x float] [float 0x3FF8820840000000, float 0xBFE01EDE00000000, float 0x3FE8985BA0000000, float 0xBFE7CBE1C0000000, float 0x3FE4906380000000, float 0xBFD9D7AF60000000, float 0x400D5CAD40000000, float 0xBFA63CF3E0000000, float 0x400D159680000000, float 0xBFFE2ABA60000000, float 0x3FDCF6F660000000, float 0x3FFD105340000000, float 0x3FF7511260000000, float 0x3FFEBB6740000000, float 0xBFFB8A51A0000000, float 0xBFF0828000000000, float 0x400A7249A0000000, float 0x3FE7A76920000000, float 0x3FD22B51E0000000, float 0x4003A40920000000, float 0xC0034EC920000000, float 0x3FF6D69580000000, float 0x3FF73600A0000000, float 0x3FC474FF40000000, float 0xBFC6D8D2E0000000, float 0x3FF1B52AA0000000, float 0xBFF3171B80000000, float 0xBFF0C7E3C0000000, float 0x4008F344E0000000, float 0xBFD2F5F7A0000000, float 0x3FFB63A300000000, float 0x3FEF1A08A0000000], align 64
@__constant_64xf32 = internal unnamed_addr constant [64 x float] [float 0x3FE3B5B8A0000000, float 0x3FF40AB280000000, float 0x3FF88AF860000000, float 0xBFF02B6440000000, float 0xBFC40E8EA0000000, float 0x3FD608E880000000, float 0x3FF07CCFE0000000, float 0xBFFB3175E0000000, float 0x3FD3ADDBA0000000, float 0x3FD757E580000000, float 0x3FFB105040000000, float 0xBFC79F9780000000, float 0x3FE204B460000000, float 0x3FCF28D660000000, float 0x3FD76DD7C0000000, float 0x3FF56612A0000000, float 0xBF91EC3DE0000000, float 0xBFE1563060000000, float 0x3FCA60B020000000, float 0x3FED076D40000000, float 0x3F0C3F6400000000, float 0x3FF11BDD20000000, float 0xBFE352EBC0000000, float 0xBFFA207320000000, float 0x3FF7605620000000, float 0x3FED2DA7E0000000, float 0x3FDAAEFC20000000, float 0x3FEE59FAA0000000, float 0xBFE3A14660000000, float 0xBFF0F294E0000000, float 0xBFDDA310A0000000, float 0xBFFD71E0A0000000, float 0xBFF9E523C0000000, float 0xBF94FD0BC0000000, float 0x3FE67D4E80000000, float 0xBFEE4F8A60000000, float 0x3FF5E445E0000000, float 0xC005BC5BA0000000, float 0xBFD1562760000000, float 0x400063B6C0000000, float 0x3FD42B7700000000, float 0x3FF83AB5E0000000, float 0x3FFB16EEA0000000, float 0xBFD7878C60000000, float 0xBFCBC88AE0000000, float 0xBFD640DFA0000000, float 0x3FFFA94D80000000, float 0x3FBBB518A0000000, float 0xBFFAB3B980000000, float 0xBFC2D74160000000, float 0x3FD63A7360000000, float 0x3FE111B440000000, float 0xBFEC772BA0000000, float 0xBFD80A6E20000000, float 0xBFEC67B800000000, float 0x3FF1909C20000000, float 0xBFF5108DC0000000, float 0x3FECB574E0000000, float 0xBFE8C35940000000, float 0x3FE6DE6260000000, float 0xBFD72307E0000000, float 0xBFFF383EC0000000, float 0x3FE1C54640000000, float 0x3FF3B6E860000000], align 64
@__constant_64xf32_0 = internal unnamed_addr constant [64 x float] [float 0xBFD7797A20000000, float 0x3FA8BEEC00000000, float 0xBFD345B2E0000000, float 0xBFCD4F3F40000000, float 0xBFBBB0F1C0000000, float 0xBFE2D2DC20000000, float 0xBFCFABAA20000000, float 0xBFB865B6E0000000, float 0xBFC4A93D80000000, float 0xBFCAE492A0000000, float 0xBFA52EF560000000, float 0x3F879FF4A0000000, float 0xBFD537B9A0000000, float 0xBFC46F9500000000, float 0xBF7AC44840000000, float 0xBFA0837860000000, float 0xBFAC69F640000000, float 0xBFD1EBF500000000, float 0xBFAE499280000000, float 0x3FBE685700000000, float 0xBFC0147D00000000, float 0xBFC56FD0A0000000, float 0x3FA2B86220000000, float 0xBFC2BAC5A0000000, float 0xBFB2172820000000, float 0xBFCE10E1E0000000, float 0xBF9AD8AA00000000, float 0xBFE8346840000000, float 0xBFCD3E2980000000, float 0xBFC3B7AC20000000, float 0xBFD182BC00000000, float 0xBFBAC8B200000000, float 0xBFCC137B20000000, float 0x3FC0EE99C0000000, float 0xBF85EC0760000000, float 0xBFE5004540000000, float 0xBFC3EB6BE0000000, float 0xBFC7A1E320000000, float 0xBFC8DAE260000000, float 0x3FAF9B4100000000, float 0xBFBFFA5F80000000, float 0xBFD2FE8BE0000000, float 0xBF9A1B99A0000000, float 0xBFD7AE8C40000000, float 0x3FB8BA91A0000000, float 0xBFC170BA20000000, float 0xBFBD1F81E0000000, float 0xBFCFC68C40000000, float 0x3F935E81A0000000, float 0xBFC88A5EE0000000, float 0xBFD1FAD900000000, float 0xBFD2101000000000, float 0x3F7F3D4BE0000000, float 0xBFE11C9540000000, float 0xBFDD773760000000, float 0xBFDC6549A0000000, float 0x3F91E506A0000000, float 0xBFB2D6E620000000, float 0xBFA932E4E0000000, float 0xBFB7C02540000000, float 0xBFD07F3260000000, float 0x3FAEC124A0000000, float 0xBFCAAF9300000000, float 0xBFA09177C0000000], align 64
@__constant_64xf32_1 = internal unnamed_addr constant [64 x float] [float 0x3FE7E6EE60000000, float 0xBFA0CEB4E0000000, float 0xBFEFECD960000000, float 0x3FD0135780000000, float 0x40069F1420000000, float 0xBFECCC6080000000, float 0x3FCB8E3DC0000000, float 0xBFF3F730E0000000, float 0x400B68BF80000000, float 0x3FF2CA5DC0000000, float 0x3FF1F495E0000000, float 0x4004C74180000000, float 0x3FCD8D0DE0000000, float 0x40046E72A0000000, float 0x4001809D00000000, float 0xBFED8E6520000000, float 0x3FD9D8BFA0000000, float 0x3FF6080D20000000, float 0x3FF9A82FE0000000, float 0xBFE251F200000000, float 0x3FC1C1CBE0000000, float 0x3FEEC10E80000000, float 0x4003B9E500000000, float 0x3FA0186180000000, float 0xBFF140E520000000, float 0x3FE2C3CF60000000, float 0x4003E524E0000000, float 0x3FF3580C20000000, float 0x40051B4920000000, float 0xBFDF92EF60000000, float 0x40024903E0000000, float 0x4013297460000000, float 0x40162AD8E0000000, float 0x3FFD5CE880000000, float 0xBFECEB6AA0000000, float 0xBFEE8972E0000000, float 0x3FF6C73740000000, float 0x3FF7F490E0000000, float 0xBFB39C6140000000, float 0x4009606100000000, float 0xBFD2703000000000, float 0x4007FC7580000000, float 0x400CFAAFC0000000, float 0xBFE7206500000000, float 0x4000741B40000000, float 0xBFC889E240000000, float 0x3FE8E61E40000000, float 0x3FCDF8B1A0000000, float 0x3FD65A9760000000, float 0xBFF181DE20000000, float 0x3FF7EDC660000000, float 0x3FF4B81F20000000, float 0x4006F98700000000, float 0x3FEDF83D60000000, float 0x400D1156C0000000, float 0x400CB38D80000000, float 0x3FF3276200000000, float 0x40044303E0000000, float 0x40032565E0000000, float 0x3FF82070E0000000, float 0xBFF19DC800000000, float 0x3FFB51B1C0000000, float 0xBFDDD1F000000000, float 0x4005EA6B60000000], align 64
@__constant_1x10xf32 = internal unnamed_addr constant [1 x [10 x float]] [[10 x float] [float 0xBFB6C447C0000000, float 0xBFC4001D60000000, float 0x3F92039880000000, float 0x3FB21875E0000000, float 0x3FA7DF3500000000, float 0xBFC0EBFFA0000000, float 0x3FC5D7DEC0000000, float 0xBFBBD90560000000, float 0xBF7B8D63C0000000, float 0x3FC6F33C40000000]], align 64
@0 = internal constant [17 x i8] c"b2_resnet_linked\00", align 1
@iree_hal_executable_library_query_v0_header = internal constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = internal constant [16 x ptr] [ptr @infer_dispatch_0_slow_memcpy, ptr @infer_dispatch_1_conv_16x32x32x3x3x3_f32, ptr @infer_dispatch_2_slow_memcpy, ptr @infer_dispatch_3_conv_16x32x32x16x3x3_f32, ptr @infer_dispatch_4_conv_16x32x32x16x3x3_f32, ptr @infer_dispatch_5_slow_memcpy, ptr @infer_dispatch_6_conv_32x16x16x16x3x3_f32, ptr @infer_dispatch_7_matmul_like_32x16x16x16_f32, ptr @infer_dispatch_8_conv_32x16x16x32x3x3_f32, ptr @infer_dispatch_9_slow_memcpy, ptr @infer_dispatch_10_conv_64x8x8x32x3x3_f32, ptr @infer_dispatch_11_conv_64x8x8x64x3x3_f32, ptr @infer_dispatch_12_matmul_like_64x8x8x32_f32, ptr @infer_dispatch_13_reduction_64x64_f32, ptr @infer_dispatch_14_matmul_1x10x64_f32, ptr @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store]
@iree_hal_executable_library_query_v0_attrs = internal constant [16 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = internal constant [29 x i8] c"infer_dispatch_0_slow_memcpy\00", align 1
@2 = internal constant [41 x i8] c"infer_dispatch_1_conv_16x32x32x3x3x3_f32\00", align 1
@3 = internal constant [29 x i8] c"infer_dispatch_2_slow_memcpy\00", align 1
@4 = internal constant [42 x i8] c"infer_dispatch_3_conv_16x32x32x16x3x3_f32\00", align 1
@5 = internal constant [42 x i8] c"infer_dispatch_4_conv_16x32x32x16x3x3_f32\00", align 1
@6 = internal constant [29 x i8] c"infer_dispatch_5_slow_memcpy\00", align 1
@7 = internal constant [42 x i8] c"infer_dispatch_6_conv_32x16x16x16x3x3_f32\00", align 1
@8 = internal constant [45 x i8] c"infer_dispatch_7_matmul_like_32x16x16x16_f32\00", align 1
@9 = internal constant [42 x i8] c"infer_dispatch_8_conv_32x16x16x32x3x3_f32\00", align 1
@10 = internal constant [29 x i8] c"infer_dispatch_9_slow_memcpy\00", align 1
@11 = internal constant [41 x i8] c"infer_dispatch_10_conv_64x8x8x32x3x3_f32\00", align 1
@12 = internal constant [41 x i8] c"infer_dispatch_11_conv_64x8x8x64x3x3_f32\00", align 1
@13 = internal constant [44 x i8] c"infer_dispatch_12_matmul_like_64x8x8x32_f32\00", align 1
@14 = internal constant [38 x i8] c"infer_dispatch_13_reduction_64x64_f32\00", align 1
@15 = internal constant [37 x i8] c"infer_dispatch_14_matmul_1x10x64_f32\00", align 1
@16 = internal constant [55 x i8] c"infer_dispatch_15_softmax_10xf32_dispatch_tensor_store\00", align 1
@iree_hal_executable_library_query_v0_names = internal constant [16 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5, ptr @6, ptr @7, ptr @8, ptr @9, ptr @10, ptr @11, ptr @12, ptr @13, ptr @14, ptr @15, ptr @16]
@17 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@18 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@19 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@20 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_3.mlir\00", align 1
@21 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@22 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@23 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_6.mlir\00", align 1
@24 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_7.mlir\00", align 1
@25 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_8.mlir\00", align 1
@26 = internal constant [45 x i8] c"dump/configured_module_infer_dispatch_9.mlir\00", align 1
@27 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_10.mlir\00", align 1
@28 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_11.mlir\00", align 1
@29 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_12.mlir\00", align 1
@30 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_13.mlir\00", align 1
@31 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_14.mlir\00", align 1
@32 = internal constant [46 x i8] c"dump/configured_module_infer_dispatch_15.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = internal constant [16 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @17 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @18 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @19 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @20 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @21 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @22 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @23 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @24 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @25 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @26 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @27 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @28 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @29 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @30 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @31 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @32 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_names = internal constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_source_locations = internal constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = internal constant [16 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_16x32x32x3x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_conv_16x32x32x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_conv_16x32x32x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_conv_32x16x16x16x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_32x16x16x16_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_32x16x16x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_slow_memcpy_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_conv_64x8x8x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_64x8x8x64x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_64x8x8x32_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_reduction_64x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_matmul_1x10x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_softmax_10xf32_dispatch_tensor_store_stage_source_locations }]
@iree_hal_executable_library_query_v0 = internal constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 16, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }
@__exp2f_data = internal local_unnamed_addr constant %struct.exp2f_data { [32 x i64] [i64 4607182418800017408, i64 4607140297302181236, i64 4607100335213349135, i64 4607062579818421073, i64 4607027079437701499, i64 4606993883449571754, i64 4606963042313658936, i64 4606934607594512097, i64 4606908631985796885, i64 4606885169335019979, i64 4606864274668794914, i64 4606846004218661165, i64 4606830415447468583, i64 4606817567076339586, i64 4606807519112221737, i64 4606800332876043653, i64 4606796071031487437, i64 4606794797614391156, i64 4606796578062795143, i64 4606801479247646227, i64 4606809569504174299, i64 4606820918663955941, i64 4606835598087680144, i64 4606853680698631517, i64 4606875241016906669, i64 4606900355194379847, i64 4606929101050434204, i64 4606961558108475497, i64 4606997807633245319, i64 4607037932668951391, i64 4607082018078232794, i64 4607130150581978432], double 0x42E8000000000000, [3 x double] [double 0x3FAC6AF84B912394, double 0x3FCEBFCE50FAC4F3, double 0x3FE62E42FF0C52D6], double 0x4338000000000000, double 0x40471547652B82FE, [3 x double] [double 0x3EBC6AF84B912394, double 0x3F2EBFCE50FAC4F3, double 0x3F962E42FF0C52D6] }, align 8
@__powf_log2_data = internal local_unnamed_addr constant %struct.powf_log2_data { [16 x %struct.anon] [%struct.anon { double 0x3FF661EC79F8F3BE, double 0xBFDEFEC65B963019 }, %struct.anon { double 0x3FF571ED4AAF883D, double 0xBFDB0B6832D4FCA4 }, %struct.anon { double 0x3FF49539F0F010B0, double 0xBFD7418B0A1FB77B }, %struct.anon { double 0x3FF3C995B0B80385, double 0xBFD39DE91A6DCF7B }, %struct.anon { double 0x3FF30D190C8864A5, double 0xBFD01D9BF3F2B631 }, %struct.anon { double 0x3FF25E227B0B8EA0, double 0xBFC97C1D1B3B7AF0 }, %struct.anon { double 0x3FF1BB4A4A1A343F, double 0xBFC2F9E393AF3C9F }, %struct.anon { double 0x3FF12358F08AE5BA, double 0xBFB960CBBF788D5C }, %struct.anon { double 0x3FF0953F419900A7, double 0xBFAA6F9DB6475FCE }, %struct.anon { double 1.000000e+00, double 0.000000e+00 }, %struct.anon { double 0x3FEE608CFD9A47AC, double 0x3FB338CA9F24F53D }, %struct.anon { double 0x3FECA4B31F026AA0, double 0x3FC476A9543891BA }, %struct.anon { double 0x3FEB2036576AFCE6, double 0x3FCE840B4AC4E4D2 }, %struct.anon { double 0x3FE9C2D163A1AA2D, double 0x3FD40645F0C6651C }, %struct.anon { double 0x3FE886E6037841ED, double 0x3FD88E9C2C1B9FF8 }, %struct.anon { double 0x3FE767DCF5534862, double 0x3FDCE0A44EB17BCC }], [5 x double] [double 0x3FD27616C9496E0B, double 0xBFD71969A075C67A, double 0x3FDEC70A6CA7BADD, double 0xBFE7154748BEF6C8, double 0x3FF71547652AB82B] }, align 8

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_0_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias nonnull readnone align 16 captures(none) %2) #0 !dbg !39 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !115
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !115
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !115
  call void @llvm.assume(i1 true) [ "align"(ptr %4, i64 64) ], !dbg !116
  %5 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !117
  %6 = load ptr, ptr %5, align 8, !dbg !117
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !118
  br label %.preheader26, !dbg !119

.preheader26:                                     ; preds = %3, %23
  %7 = phi i64 [ 0, %3 ], [ %24, %23 ]
  %.idx = shl nuw nsw i64 %7, 12
  %8 = getelementptr i8, ptr %4, i64 %.idx
  %.idx24 = mul nuw nsw i64 %7, 4624
  %9 = getelementptr i8, ptr %6, i64 %.idx24
  br label %.preheader, !dbg !119

.preheader:                                       ; preds = %.preheader26, %21
  %10 = phi i64 [ 0, %.preheader26 ], [ %22, %21 ]
  %.idx23 = shl i64 %10, 7
  %11 = getelementptr i8, ptr %8, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %10, 136
  %12 = getelementptr i8, ptr %9, i64 %.idx25
  %13 = getelementptr i8, ptr %12, i64 140
  br label %14, !dbg !119

14:                                               ; preds = %.preheader, %14
  %15 = phi i64 [ 0, %.preheader ], [ %19, %14 ]
  %16 = getelementptr [4 x i8], ptr %11, i64 %15, !dbg !119
  %17 = load <4 x float>, ptr %16, align 16, !dbg !119
  %18 = getelementptr [4 x i8], ptr %13, i64 %15, !dbg !119
  store <4 x float> %17, ptr %18, align 4, !dbg !119
  %19 = add nuw nsw i64 %15, 4, !dbg !119
  %20 = icmp samesign ult i64 %15, 28, !dbg !119
  br i1 %20, label %14, label %21, !dbg !119

21:                                               ; preds = %14
  %22 = add nuw nsw i64 %10, 1, !dbg !119
  %exitcond.not = icmp eq i64 %22, 32, !dbg !119
  br i1 %exitcond.not, label %23, label %.preheader, !dbg !119

23:                                               ; preds = %21
  %24 = add nuw nsw i64 %7, 1, !dbg !119
  %exitcond27.not = icmp eq i64 %24, 3, !dbg !119
  br i1 %exitcond27.not, label %25, label %.preheader26, !dbg !119

25:                                               ; preds = %23
  ret i32 0, !dbg !120
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_1_conv_16x32x32x3x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !121 {
  %4 = alloca [4 x float], align 64, !dbg !122
  %5 = alloca [4 x float], align 64, !dbg !123
  %.elt22 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !124
  %.unpack23 = load ptr, ptr %.elt22, align 16, !dbg !124
  %6 = load ptr, ptr %.unpack23, align 8, !dbg !124
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !124
  %7 = getelementptr i8, ptr %.unpack23, i64 8, !dbg !125
  %8 = load ptr, ptr %7, align 8, !dbg !125
  %9 = getelementptr i8, ptr %8, i64 286720, !dbg !125
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !125
  %10 = getelementptr i8, ptr %.unpack23, i64 16, !dbg !126
  %11 = load ptr, ptr %10, align 8, !dbg !126
  %12 = getelementptr i8, ptr %11, i64 13888, !dbg !126
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !126
  %13 = load i32, ptr %2, align 16, !dbg !122
  %14 = zext i32 %13 to i64, !dbg !122
  %15 = and i64 %14, 4294967294, !dbg !122
  %16 = shl nuw nsw i64 %14, 4, !dbg !122
  %17 = and i64 %16, 16, !dbg !122
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !127
  br label %18, !dbg !122

18:                                               ; preds = %3, %71
  %19 = phi i1 [ true, %3 ], [ false, %71 ]
  %20 = phi i64 [ 0, %3 ], [ 1, %71 ]
  %21 = or disjoint i64 %20, %15, !dbg !122
  %22 = getelementptr [4 x i8], ptr @__constant_16xf32, i64 %21, !dbg !128
  %23 = load <1 x float>, ptr %22, align 4, !dbg !128
  %.idx29 = mul nuw nsw i64 %21, 108
  %24 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx29
  %25 = shufflevector <1 x float> %23, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = shl nuw nsw i64 %21, 12
  %26 = getelementptr i8, ptr %12, i64 %.idx
  br label %.preheader35, !dbg !122

.preheader35:                                     ; preds = %18, %69
  %27 = phi i64 [ 0, %18 ], [ %70, %69 ]
  %28 = add nuw nsw i64 %27, %17
  %.idx26 = shl i64 %28, 7
  %29 = getelementptr i8, ptr %26, i64 %.idx26
  br label %.preheader34, !dbg !122

.preheader34:                                     ; preds = %.preheader35, %62
  %30 = phi i64 [ 0, %.preheader35 ], [ %67, %62 ]
  br label %31, !dbg !122

.preheader33:                                     ; preds = %31
  %invariant.gep36 = getelementptr [4 x i8], ptr %6, i64 %30, !dbg !122
  br label %.preheader32, !dbg !122

31:                                               ; preds = %.preheader34, %31
  %32 = phi i64 [ 0, %.preheader34 ], [ %36, %31 ]
  %33 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %32, !dbg !122
  %34 = load float, ptr %33, align 4, !dbg !122
  %35 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %32, !dbg !122
  store float %34, ptr %35, align 4, !dbg !122
  %36 = add nuw nsw i64 %32, 1, !dbg !122
  %exitcond.not = icmp eq i64 %36, 4, !dbg !122
  br i1 %exitcond.not, label %.preheader33, label %31, !dbg !122

.preheader32:                                     ; preds = %.preheader33, %60
  %37 = phi i64 [ 0, %.preheader33 ], [ %61, %60 ]
  %.idx27 = mul nuw nsw i64 %37, 4624
  %gep37 = getelementptr i8, ptr %invariant.gep36, i64 %.idx27, !dbg !122
  %.idx30 = mul nuw nsw i64 %37, 36
  %38 = getelementptr inbounds nuw i8, ptr %24, i64 %.idx30
  br label %39, !dbg !122

39:                                               ; preds = %.preheader32, %58
  %40 = phi i64 [ 0, %.preheader32 ], [ %59, %58 ]
  %41 = add nuw nsw i64 %28, %40, !dbg !122
  %.idx28 = mul nuw nsw i64 %41, 136
  %gep = getelementptr i8, ptr %gep37, i64 %.idx28
  %.idx31 = mul nuw nsw i64 %40, 12
  %42 = getelementptr inbounds nuw i8, ptr %38, i64 %.idx31
  br label %.preheader, !dbg !122

.preheader:                                       ; preds = %39, %56
  %43 = phi i64 [ 0, %39 ], [ %57, %56 ]
  %44 = getelementptr [4 x i8], ptr %gep, i64 %43
  %45 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %43
  %.promoted = load float, ptr %45, align 4
  br label %46, !dbg !122

46:                                               ; preds = %.preheader, %46
  %47 = phi i64 [ 0, %.preheader ], [ %55, %46 ]
  %48 = phi float [ %.promoted, %.preheader ], [ %54, %46 ]
  %49 = getelementptr [4 x i8], ptr %44, i64 %47, !dbg !122
  %50 = load float, ptr %49, align 4, !dbg !122
  %51 = getelementptr inbounds nuw [4 x i8], ptr %42, i64 %47, !dbg !122
  %52 = load float, ptr %51, align 4, !dbg !122
  %53 = fmul contract float %50, %52, !dbg !129
  %54 = fadd contract float %48, %53, !dbg !130
  %55 = add nuw nsw i64 %47, 1, !dbg !122
  %exitcond38.not = icmp eq i64 %55, 3, !dbg !122
  br i1 %exitcond38.not, label %56, label %46, !dbg !122

56:                                               ; preds = %46
  store float %54, ptr %45, align 4, !dbg !122
  %57 = add nuw nsw i64 %43, 1, !dbg !122
  %exitcond39.not = icmp eq i64 %57, 4, !dbg !122
  br i1 %exitcond39.not, label %58, label %.preheader, !dbg !122

58:                                               ; preds = %56
  %59 = add nuw nsw i64 %40, 1, !dbg !122
  %exitcond40.not = icmp eq i64 %59, 3, !dbg !122
  br i1 %exitcond40.not, label %60, label %39, !dbg !122

60:                                               ; preds = %58
  %61 = add nuw nsw i64 %37, 1, !dbg !122
  %exitcond41.not = icmp eq i64 %61, 3, !dbg !122
  br i1 %exitcond41.not, label %62, label %.preheader32, !dbg !122

62:                                               ; preds = %60
  %63 = load <4 x float>, ptr %4, align 64, !dbg !128
  %64 = fadd contract <4 x float> %25, %63, !dbg !131
  %.inv = fcmp ole <4 x float> %64, zeroinitializer, !dbg !132
  %65 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %64, !dbg !132
  %66 = getelementptr [4 x i8], ptr %29, i64 %30, !dbg !122
  store <4 x float> %65, ptr %66, align 16, !dbg !122
  %67 = add nuw nsw i64 %30, 4, !dbg !122
  %68 = icmp samesign ult i64 %30, 28, !dbg !122
  br i1 %68, label %.preheader34, label %69, !dbg !122

69:                                               ; preds = %62
  %70 = add nuw nsw i64 %27, 1, !dbg !122
  %exitcond42.not = icmp eq i64 %70, 16, !dbg !122
  br i1 %exitcond42.not, label %71, label %.preheader35, !dbg !122

71:                                               ; preds = %69
  br i1 %19, label %18, label %72, !dbg !122

72:                                               ; preds = %71
  ret i32 0, !dbg !133
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_2_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !134 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !135
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !135
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !135
  %5 = getelementptr i8, ptr %4, i64 13888, !dbg !136
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !136
  %6 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !137
  %7 = load ptr, ptr %6, align 8, !dbg !137
  %8 = getelementptr i8, ptr %7, i64 79424, !dbg !138
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !138
  %9 = load i32, ptr %2, align 16, !dbg !139
  %10 = zext i32 %9 to i64, !dbg !139
  %11 = shl nuw nsw i64 %10, 2, !dbg !139
  %12 = and i64 %11, 17179869176, !dbg !139
  %13 = shl nuw nsw i64 %10, 4, !dbg !139
  %14 = and i64 %13, 16, !dbg !139
  br label %.preheader26, !dbg !139

.preheader26:                                     ; preds = %3, %33
  %15 = phi i64 [ 0, %3 ], [ %34, %33 ]
  %16 = add nuw nsw i64 %15, %12
  %.idx = shl i64 %16, 12
  %17 = getelementptr i8, ptr %5, i64 %.idx
  %.idx24 = mul nuw nsw i64 %16, 4624
  %18 = getelementptr i8, ptr %8, i64 %.idx24
  br label %.preheader, !dbg !139

.preheader:                                       ; preds = %.preheader26, %31
  %19 = phi i64 [ 0, %.preheader26 ], [ %32, %31 ]
  %20 = add nuw nsw i64 %19, %14
  %.idx23 = shl i64 %20, 7
  %21 = getelementptr i8, ptr %17, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %20, 136
  %22 = getelementptr i8, ptr %18, i64 %.idx25
  %23 = getelementptr i8, ptr %22, i64 140
  br label %24, !dbg !139

24:                                               ; preds = %.preheader, %24
  %25 = phi i64 [ 0, %.preheader ], [ %29, %24 ]
  %26 = getelementptr [4 x i8], ptr %21, i64 %25, !dbg !139
  %27 = load <4 x float>, ptr %26, align 16, !dbg !139
  %28 = getelementptr [4 x i8], ptr %23, i64 %25, !dbg !139
  store <4 x float> %27, ptr %28, align 4, !dbg !139
  %29 = add nuw nsw i64 %25, 4, !dbg !139
  %30 = icmp samesign ult i64 %25, 28, !dbg !139
  br i1 %30, label %24, label %31, !dbg !139

31:                                               ; preds = %24
  %32 = add nuw nsw i64 %19, 1, !dbg !139
  %exitcond.not = icmp eq i64 %32, 16, !dbg !139
  br i1 %exitcond.not, label %33, label %.preheader, !dbg !139

33:                                               ; preds = %31
  %34 = add nuw nsw i64 %15, 1, !dbg !139
  %exitcond27.not = icmp eq i64 %34, 8, !dbg !139
  br i1 %exitcond27.not, label %35, label %.preheader26, !dbg !139

35:                                               ; preds = %33
  ret i32 0, !dbg !140
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_3_conv_16x32x32x16x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !141 {
  %4 = alloca [4 x float], align 64, !dbg !142
  %5 = alloca [4 x float], align 64, !dbg !143
  %.elt22 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !144
  %.unpack23 = load ptr, ptr %.elt22, align 16, !dbg !144
  %6 = load ptr, ptr %.unpack23, align 8, !dbg !144
  %7 = getelementptr i8, ptr %6, i64 79424, !dbg !144
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !144
  %8 = getelementptr i8, ptr %.unpack23, i64 8, !dbg !145
  %9 = load ptr, ptr %8, align 8, !dbg !145
  %10 = getelementptr i8, ptr %9, i64 19456, !dbg !145
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !145
  %11 = getelementptr i8, ptr %.unpack23, i64 16, !dbg !146
  %12 = load ptr, ptr %11, align 8, !dbg !146
  %13 = getelementptr i8, ptr %12, i64 153408, !dbg !146
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !146
  %14 = load i32, ptr %2, align 16, !dbg !142
  %15 = zext i32 %14 to i64, !dbg !142
  %16 = and i64 %15, 4294967294, !dbg !142
  %17 = shl nuw nsw i64 %15, 4, !dbg !142
  %18 = and i64 %17, 16, !dbg !142
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !147
  br label %19, !dbg !142

19:                                               ; preds = %3, %73
  %20 = phi i1 [ true, %3 ], [ false, %73 ]
  %21 = phi i64 [ 0, %3 ], [ 1, %73 ]
  %22 = or disjoint i64 %21, %16, !dbg !142
  %23 = getelementptr [4 x i8], ptr @__constant_16xf32_0, i64 %22, !dbg !148
  %24 = load <1 x float>, ptr %23, align 4, !dbg !148
  %.idx29 = mul nuw nsw i64 %22, 576
  %25 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx29
  %26 = shufflevector <1 x float> %24, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %22, 4624
  %27 = getelementptr i8, ptr %13, i64 %.idx
  br label %.preheader35, !dbg !142

.preheader35:                                     ; preds = %19, %71
  %28 = phi i64 [ 0, %19 ], [ %72, %71 ]
  %29 = add nuw nsw i64 %28, %18
  %.idx26 = mul nuw nsw i64 %29, 136
  %30 = getelementptr i8, ptr %27, i64 %.idx26
  %31 = getelementptr i8, ptr %30, i64 140
  br label %.preheader34, !dbg !142

.preheader34:                                     ; preds = %.preheader35, %64
  %32 = phi i64 [ 0, %.preheader35 ], [ %69, %64 ]
  br label %33, !dbg !142

.preheader33:                                     ; preds = %33
  %invariant.gep36 = getelementptr [4 x i8], ptr %7, i64 %32, !dbg !142
  br label %.preheader32, !dbg !142

33:                                               ; preds = %.preheader34, %33
  %34 = phi i64 [ 0, %.preheader34 ], [ %38, %33 ]
  %35 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %34, !dbg !142
  %36 = load float, ptr %35, align 4, !dbg !142
  %37 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %34, !dbg !142
  store float %36, ptr %37, align 4, !dbg !142
  %38 = add nuw nsw i64 %34, 1, !dbg !142
  %exitcond.not = icmp eq i64 %38, 4, !dbg !142
  br i1 %exitcond.not, label %.preheader33, label %33, !dbg !142

.preheader32:                                     ; preds = %.preheader33, %62
  %39 = phi i64 [ 0, %.preheader33 ], [ %63, %62 ]
  %.idx27 = mul nuw nsw i64 %39, 4624
  %gep37 = getelementptr i8, ptr %invariant.gep36, i64 %.idx27, !dbg !142
  %.idx30 = mul nuw nsw i64 %39, 36
  %40 = getelementptr inbounds nuw i8, ptr %25, i64 %.idx30
  br label %41, !dbg !142

41:                                               ; preds = %.preheader32, %60
  %42 = phi i64 [ 0, %.preheader32 ], [ %61, %60 ]
  %43 = add nuw nsw i64 %29, %42, !dbg !142
  %.idx28 = mul nuw nsw i64 %43, 136
  %gep = getelementptr i8, ptr %gep37, i64 %.idx28
  %.idx31 = mul nuw nsw i64 %42, 12
  %44 = getelementptr inbounds nuw i8, ptr %40, i64 %.idx31
  br label %.preheader, !dbg !142

.preheader:                                       ; preds = %41, %58
  %45 = phi i64 [ 0, %41 ], [ %59, %58 ]
  %46 = getelementptr [4 x i8], ptr %gep, i64 %45
  %47 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %45
  %.promoted = load float, ptr %47, align 4
  br label %48, !dbg !142

48:                                               ; preds = %.preheader, %48
  %49 = phi i64 [ 0, %.preheader ], [ %57, %48 ]
  %50 = phi float [ %.promoted, %.preheader ], [ %56, %48 ]
  %51 = getelementptr [4 x i8], ptr %46, i64 %49, !dbg !142
  %52 = load float, ptr %51, align 4, !dbg !142
  %53 = getelementptr inbounds nuw [4 x i8], ptr %44, i64 %49, !dbg !142
  %54 = load float, ptr %53, align 4, !dbg !142
  %55 = fmul contract float %52, %54, !dbg !149
  %56 = fadd contract float %50, %55, !dbg !150
  %57 = add nuw nsw i64 %49, 1, !dbg !142
  %exitcond38.not = icmp eq i64 %57, 3, !dbg !142
  br i1 %exitcond38.not, label %58, label %48, !dbg !142

58:                                               ; preds = %48
  store float %56, ptr %47, align 4, !dbg !142
  %59 = add nuw nsw i64 %45, 1, !dbg !142
  %exitcond39.not = icmp eq i64 %59, 4, !dbg !142
  br i1 %exitcond39.not, label %60, label %.preheader, !dbg !142

60:                                               ; preds = %58
  %61 = add nuw nsw i64 %42, 1, !dbg !142
  %exitcond40.not = icmp eq i64 %61, 3, !dbg !142
  br i1 %exitcond40.not, label %62, label %41, !dbg !142

62:                                               ; preds = %60
  %63 = add nuw nsw i64 %39, 1, !dbg !142
  %exitcond41.not = icmp eq i64 %63, 16, !dbg !142
  br i1 %exitcond41.not, label %64, label %.preheader32, !dbg !142

64:                                               ; preds = %62
  %65 = load <4 x float>, ptr %4, align 64, !dbg !148
  %66 = fadd contract <4 x float> %26, %65, !dbg !151
  %.inv = fcmp ole <4 x float> %66, zeroinitializer, !dbg !152
  %67 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %66, !dbg !152
  %68 = getelementptr [4 x i8], ptr %31, i64 %32, !dbg !142
  store <4 x float> %67, ptr %68, align 4, !dbg !142
  %69 = add nuw nsw i64 %32, 4, !dbg !142
  %70 = icmp samesign ult i64 %32, 28, !dbg !142
  br i1 %70, label %.preheader34, label %71, !dbg !142

71:                                               ; preds = %64
  %72 = add nuw nsw i64 %28, 1, !dbg !142
  %exitcond42.not = icmp eq i64 %72, 16, !dbg !142
  br i1 %exitcond42.not, label %73, label %.preheader35, !dbg !142

73:                                               ; preds = %71
  br i1 %20, label %19, label %74, !dbg !142

74:                                               ; preds = %73
  ret i32 0, !dbg !153
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_4_conv_16x32x32x16x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !154 {
  %4 = alloca [4 x float], align 64, !dbg !155
  %5 = alloca [4 x float], align 64, !dbg !156
  %.elt22 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !157
  %.unpack23 = load ptr, ptr %.elt22, align 16, !dbg !157
  %6 = load ptr, ptr %.unpack23, align 8, !dbg !157
  %7 = getelementptr i8, ptr %6, i64 153408, !dbg !157
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !157
  %8 = getelementptr i8, ptr %.unpack23, i64 8, !dbg !158
  %9 = load ptr, ptr %8, align 8, !dbg !158
  %10 = getelementptr i8, ptr %9, i64 10240, !dbg !158
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !158
  %11 = getelementptr i8, ptr %6, i64 13888, !dbg !159
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !159
  %12 = getelementptr i8, ptr %.unpack23, i64 16, !dbg !160
  %13 = load ptr, ptr %12, align 8, !dbg !160
  %14 = getelementptr i8, ptr %13, i64 79424, !dbg !160
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !160
  %15 = load i32, ptr %2, align 16, !dbg !155
  %16 = zext i32 %15 to i64, !dbg !155
  %17 = and i64 %16, 4294967294, !dbg !155
  %18 = shl nuw nsw i64 %16, 4, !dbg !155
  %19 = and i64 %18, 16, !dbg !155
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !161
  br label %20, !dbg !155

20:                                               ; preds = %3, %78
  %21 = phi i1 [ true, %3 ], [ false, %78 ]
  %22 = phi i64 [ 0, %3 ], [ 1, %78 ]
  %23 = or disjoint i64 %22, %17, !dbg !155
  %24 = getelementptr [4 x i8], ptr @__constant_16xf32_1, i64 %23, !dbg !162
  %25 = load <1 x float>, ptr %24, align 4, !dbg !162
  %.idx27 = mul nuw nsw i64 %23, 576
  %26 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx27
  %27 = shl nuw nsw i64 %23, 10
  %28 = shufflevector <1 x float> %25, <1 x float> poison, <4 x i32> zeroinitializer
  br label %.preheader33, !dbg !155

.preheader33:                                     ; preds = %20, %76
  %29 = phi i64 [ 0, %20 ], [ %77, %76 ]
  %30 = add nuw nsw i64 %29, %19
  %31 = shl i64 %30, 5
  %32 = add i64 %31, %27
  br label %.preheader32, !dbg !155

.preheader32:                                     ; preds = %.preheader33, %65
  %33 = phi i64 [ 0, %.preheader33 ], [ %74, %65 ]
  br label %34, !dbg !155

.preheader31:                                     ; preds = %34
  %invariant.gep34 = getelementptr [4 x i8], ptr %7, i64 %33, !dbg !155
  br label %.preheader30, !dbg !155

34:                                               ; preds = %.preheader32, %34
  %35 = phi i64 [ 0, %.preheader32 ], [ %39, %34 ]
  %36 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %35, !dbg !155
  %37 = load float, ptr %36, align 4, !dbg !155
  %38 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %35, !dbg !155
  store float %37, ptr %38, align 4, !dbg !155
  %39 = add nuw nsw i64 %35, 1, !dbg !155
  %exitcond.not = icmp eq i64 %39, 4, !dbg !155
  br i1 %exitcond.not, label %.preheader31, label %34, !dbg !155

.preheader30:                                     ; preds = %.preheader31, %63
  %40 = phi i64 [ 0, %.preheader31 ], [ %64, %63 ]
  %.idx = mul nuw nsw i64 %40, 4624
  %gep35 = getelementptr i8, ptr %invariant.gep34, i64 %.idx, !dbg !155
  %.idx28 = mul nuw nsw i64 %40, 36
  %41 = getelementptr inbounds nuw i8, ptr %26, i64 %.idx28
  br label %42, !dbg !155

42:                                               ; preds = %.preheader30, %61
  %43 = phi i64 [ 0, %.preheader30 ], [ %62, %61 ]
  %44 = add nuw nsw i64 %30, %43, !dbg !155
  %.idx26 = mul nuw nsw i64 %44, 136
  %gep = getelementptr i8, ptr %gep35, i64 %.idx26
  %.idx29 = mul nuw nsw i64 %43, 12
  %45 = getelementptr inbounds nuw i8, ptr %41, i64 %.idx29
  br label %.preheader, !dbg !155

.preheader:                                       ; preds = %42, %59
  %46 = phi i64 [ 0, %42 ], [ %60, %59 ]
  %47 = getelementptr [4 x i8], ptr %gep, i64 %46
  %48 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %46
  %.promoted = load float, ptr %48, align 4
  br label %49, !dbg !155

49:                                               ; preds = %.preheader, %49
  %50 = phi i64 [ 0, %.preheader ], [ %58, %49 ]
  %51 = phi float [ %.promoted, %.preheader ], [ %57, %49 ]
  %52 = getelementptr [4 x i8], ptr %47, i64 %50, !dbg !155
  %53 = load float, ptr %52, align 4, !dbg !155
  %54 = getelementptr inbounds nuw [4 x i8], ptr %45, i64 %50, !dbg !155
  %55 = load float, ptr %54, align 4, !dbg !155
  %56 = fmul contract float %53, %55, !dbg !163
  %57 = fadd contract float %51, %56, !dbg !164
  %58 = add nuw nsw i64 %50, 1, !dbg !155
  %exitcond36.not = icmp eq i64 %58, 3, !dbg !155
  br i1 %exitcond36.not, label %59, label %49, !dbg !155

59:                                               ; preds = %49
  store float %57, ptr %48, align 4, !dbg !155
  %60 = add nuw nsw i64 %46, 1, !dbg !155
  %exitcond37.not = icmp eq i64 %60, 4, !dbg !155
  br i1 %exitcond37.not, label %61, label %.preheader, !dbg !155

61:                                               ; preds = %59
  %62 = add nuw nsw i64 %43, 1, !dbg !155
  %exitcond38.not = icmp eq i64 %62, 3, !dbg !155
  br i1 %exitcond38.not, label %63, label %42, !dbg !155

63:                                               ; preds = %61
  %64 = add nuw nsw i64 %40, 1, !dbg !155
  %exitcond39.not = icmp eq i64 %64, 16, !dbg !155
  br i1 %exitcond39.not, label %65, label %.preheader30, !dbg !155

65:                                               ; preds = %63
  %66 = add nuw nsw i64 %32, %33, !dbg !162
  %67 = getelementptr [4 x i8], ptr %11, i64 %66, !dbg !162
  %68 = load <4 x float>, ptr %67, align 16, !dbg !162
  %69 = load <4 x float>, ptr %4, align 64, !dbg !162
  %70 = fadd contract <4 x float> %28, %69, !dbg !165
  %71 = fadd contract <4 x float> %68, %70, !dbg !166
  %.inv = fcmp ole <4 x float> %71, zeroinitializer, !dbg !167
  %72 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %71, !dbg !167
  %73 = getelementptr [4 x i8], ptr %14, i64 %66, !dbg !155
  store <4 x float> %72, ptr %73, align 16, !dbg !155
  %74 = add nuw nsw i64 %33, 4, !dbg !155
  %75 = icmp samesign ult i64 %33, 28, !dbg !155
  br i1 %75, label %.preheader32, label %76, !dbg !155

76:                                               ; preds = %65
  %77 = add nuw nsw i64 %29, 1, !dbg !155
  %exitcond40.not = icmp eq i64 %77, 16, !dbg !155
  br i1 %exitcond40.not, label %78, label %.preheader33, !dbg !155

78:                                               ; preds = %76
  br i1 %21, label %20, label %79, !dbg !155

79:                                               ; preds = %78
  ret i32 0, !dbg !168
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_5_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !169 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !170
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !170
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !170
  %5 = getelementptr i8, ptr %4, i64 79424, !dbg !171
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !171
  %6 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !172
  %7 = load ptr, ptr %6, align 8, !dbg !172
  %8 = getelementptr i8, ptr %7, i64 227392, !dbg !173
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !173
  %9 = load i32, ptr %2, align 16, !dbg !174
  %10 = zext i32 %9 to i64, !dbg !174
  %11 = shl nuw nsw i64 %10, 2, !dbg !174
  %12 = and i64 %11, 17179869176, !dbg !174
  %13 = shl nuw nsw i64 %10, 4, !dbg !174
  %14 = and i64 %13, 16, !dbg !174
  br label %.preheader26, !dbg !174

.preheader26:                                     ; preds = %3, %32
  %15 = phi i64 [ 0, %3 ], [ %33, %32 ]
  %16 = add nuw nsw i64 %15, %12
  %.idx = shl i64 %16, 12
  %17 = getelementptr i8, ptr %5, i64 %.idx
  %.idx24 = mul nuw nsw i64 %16, 4356
  %18 = getelementptr i8, ptr %8, i64 %.idx24
  br label %.preheader, !dbg !174

.preheader:                                       ; preds = %.preheader26, %30
  %19 = phi i64 [ 0, %.preheader26 ], [ %31, %30 ]
  %20 = add nuw nsw i64 %19, %14
  %.idx23 = shl i64 %20, 7
  %21 = getelementptr i8, ptr %17, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %20, 132
  %22 = getelementptr i8, ptr %18, i64 %.idx25
  br label %23, !dbg !174

23:                                               ; preds = %.preheader, %23
  %24 = phi i64 [ 0, %.preheader ], [ %28, %23 ]
  %25 = getelementptr [4 x i8], ptr %21, i64 %24, !dbg !174
  %26 = load <4 x float>, ptr %25, align 16, !dbg !174
  %27 = getelementptr [4 x i8], ptr %22, i64 %24, !dbg !174
  store <4 x float> %26, ptr %27, align 4, !dbg !174
  %28 = add nuw nsw i64 %24, 4, !dbg !174
  %29 = icmp samesign ult i64 %24, 28, !dbg !174
  br i1 %29, label %23, label %30, !dbg !174

30:                                               ; preds = %23
  %31 = add nuw nsw i64 %19, 1, !dbg !174
  %exitcond.not = icmp eq i64 %31, 16, !dbg !174
  br i1 %exitcond.not, label %32, label %.preheader, !dbg !174

32:                                               ; preds = %30
  %33 = add nuw nsw i64 %15, 1, !dbg !174
  %exitcond27.not = icmp eq i64 %33, 8, !dbg !174
  br i1 %exitcond27.not, label %34, label %.preheader26, !dbg !174

34:                                               ; preds = %32
  ret i32 0, !dbg !175
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_6_conv_32x16x16x16x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !176 {
  %4 = alloca [4 x float], align 64, !dbg !177
  %5 = alloca [4 x float], align 64, !dbg !178
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !179
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !179
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !179
  %7 = getelementptr i8, ptr %6, i64 227392, !dbg !179
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !179
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !180
  %9 = load ptr, ptr %8, align 8, !dbg !180
  %10 = getelementptr i8, ptr %9, i64 288448, !dbg !180
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !180
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !181
  %12 = load ptr, ptr %11, align 8, !dbg !181
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !181
  %13 = load i32, ptr %2, align 16, !dbg !177
  %14 = zext i32 %13 to i64, !dbg !177
  %15 = and i64 %14, 1, !dbg !177
  %16 = shl nuw nsw i64 %14, 1, !dbg !177
  %17 = and i64 %16, 8589934588, !dbg !177
  %18 = shl nuw nsw i64 %15, 3, !dbg !177
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !182
  %19 = shl nuw nsw i64 %15, 4
  br label %20, !dbg !177

20:                                               ; preds = %3, %78
  %21 = phi i64 [ 0, %3 ], [ %79, %78 ]
  %22 = or disjoint i64 %21, %17, !dbg !177
  %23 = getelementptr [4 x i8], ptr @__constant_32xf32, i64 %22, !dbg !183
  %24 = load <1 x float>, ptr %23, align 4, !dbg !183
  %.idx31 = mul nuw nsw i64 %22, 576
  %25 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx31
  %26 = shufflevector <1 x float> %24, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %22, 1296
  %27 = getelementptr i8, ptr %12, i64 %.idx
  br label %.preheader37, !dbg !177

.preheader37:                                     ; preds = %20, %76
  %28 = phi i64 [ 0, %20 ], [ %77, %76 ]
  %29 = shl nuw nsw i64 %28, 1
  %30 = add nuw nsw i64 %29, %19
  %31 = add nuw nsw i64 %28, %18
  %.idx27 = mul nuw nsw i64 %31, 72
  %32 = getelementptr i8, ptr %27, i64 %.idx27
  %33 = getelementptr i8, ptr %32, i64 76
  br label %.preheader36, !dbg !177

.preheader36:                                     ; preds = %.preheader37, %69
  %34 = phi i64 [ 0, %.preheader37 ], [ %74, %69 ]
  br label %35, !dbg !177

35:                                               ; preds = %.preheader36, %35
  %36 = phi i64 [ 0, %.preheader36 ], [ %40, %35 ]
  %37 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %36, !dbg !177
  %38 = load float, ptr %37, align 4, !dbg !177
  %39 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %36, !dbg !177
  store float %38, ptr %39, align 4, !dbg !177
  %40 = add nuw nsw i64 %36, 1, !dbg !177
  %exitcond.not = icmp eq i64 %40, 4, !dbg !177
  br i1 %exitcond.not, label %.preheader34, label %35, !dbg !177

.preheader34:                                     ; preds = %35, %67
  %41 = phi i64 [ %68, %67 ], [ 0, %35 ]
  %.idx28 = mul nuw nsw i64 %41, 4356
  %42 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx28
  %.idx32 = mul nuw nsw i64 %41, 36
  %43 = getelementptr inbounds nuw i8, ptr %25, i64 %.idx32
  br label %44, !dbg !177

44:                                               ; preds = %.preheader34, %65
  %45 = phi i64 [ 0, %.preheader34 ], [ %66, %65 ]
  %46 = add nuw nsw i64 %30, %45, !dbg !177
  %.idx29 = mul nuw nsw i64 %46, 132
  %47 = getelementptr inbounds nuw i8, ptr %42, i64 %.idx29
  %.idx33 = mul nuw nsw i64 %45, 12
  %48 = getelementptr inbounds nuw i8, ptr %43, i64 %.idx33
  br label %.preheader, !dbg !177

.preheader:                                       ; preds = %44, %63
  %49 = phi i64 [ 0, %44 ], [ %64, %63 ]
  %50 = add nuw nsw i64 %49, %34
  %.idx30 = shl i64 %50, 3
  %51 = getelementptr i8, ptr %47, i64 %.idx30
  %52 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %49
  %.promoted = load float, ptr %52, align 4
  br label %53, !dbg !177

53:                                               ; preds = %.preheader, %53
  %54 = phi i64 [ 0, %.preheader ], [ %62, %53 ]
  %55 = phi float [ %.promoted, %.preheader ], [ %61, %53 ]
  %56 = getelementptr [4 x i8], ptr %51, i64 %54, !dbg !177
  %57 = load float, ptr %56, align 4, !dbg !177
  %58 = getelementptr inbounds nuw [4 x i8], ptr %48, i64 %54, !dbg !177
  %59 = load float, ptr %58, align 4, !dbg !177
  %60 = fmul contract float %57, %59, !dbg !184
  %61 = fadd contract float %55, %60, !dbg !185
  %62 = add nuw nsw i64 %54, 1, !dbg !177
  %exitcond38.not = icmp eq i64 %62, 3, !dbg !177
  br i1 %exitcond38.not, label %63, label %53, !dbg !177

63:                                               ; preds = %53
  store float %61, ptr %52, align 4, !dbg !177
  %64 = add nuw nsw i64 %49, 1, !dbg !177
  %exitcond39.not = icmp eq i64 %64, 4, !dbg !177
  br i1 %exitcond39.not, label %65, label %.preheader, !dbg !177

65:                                               ; preds = %63
  %66 = add nuw nsw i64 %45, 1, !dbg !177
  %exitcond40.not = icmp eq i64 %66, 3, !dbg !177
  br i1 %exitcond40.not, label %67, label %44, !dbg !177

67:                                               ; preds = %65
  %68 = add nuw nsw i64 %41, 1, !dbg !177
  %exitcond41.not = icmp eq i64 %68, 16, !dbg !177
  br i1 %exitcond41.not, label %69, label %.preheader34, !dbg !177

69:                                               ; preds = %67
  %70 = load <4 x float>, ptr %4, align 64, !dbg !183
  %71 = fadd contract <4 x float> %26, %70, !dbg !186
  %.inv = fcmp ole <4 x float> %71, zeroinitializer, !dbg !187
  %72 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %71, !dbg !187
  %73 = getelementptr [4 x i8], ptr %33, i64 %34, !dbg !177
  store <4 x float> %72, ptr %73, align 4, !dbg !177
  %74 = add nuw nsw i64 %34, 4, !dbg !177
  %75 = icmp samesign ult i64 %34, 12, !dbg !177
  br i1 %75, label %.preheader36, label %76, !dbg !177

76:                                               ; preds = %69
  %77 = add nuw nsw i64 %28, 1, !dbg !177
  %exitcond42.not = icmp eq i64 %77, 8, !dbg !177
  br i1 %exitcond42.not, label %78, label %.preheader37, !dbg !177

78:                                               ; preds = %76
  %79 = add nuw nsw i64 %21, 1, !dbg !177
  %exitcond43.not = icmp eq i64 %79, 4, !dbg !177
  br i1 %exitcond43.not, label %80, label %20, !dbg !177

80:                                               ; preds = %78
  ret i32 0, !dbg !188
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_7_matmul_like_32x16x16x16_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !189 {
  %.elt27 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !190
  %.unpack28 = load ptr, ptr %.elt27, align 16, !dbg !190
  %4 = load ptr, ptr %.unpack28, align 8, !dbg !190
  %5 = getelementptr i8, ptr %4, i64 79424, !dbg !190
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !190
  %6 = getelementptr i8, ptr %.unpack28, i64 8, !dbg !191
  %7 = load ptr, ptr %6, align 8, !dbg !191
  %8 = getelementptr i8, ptr %7, i64 8192, !dbg !191
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !191
  %9 = getelementptr i8, ptr %.unpack28, i64 16, !dbg !192
  %10 = load ptr, ptr %9, align 8, !dbg !192
  %11 = getelementptr i8, ptr %10, i64 41472, !dbg !192
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !192
  %12 = load i32, ptr %2, align 16, !dbg !193
  %13 = zext i32 %12 to i64, !dbg !193
  %14 = shl nuw nsw i64 %13, 1, !dbg !193
  %15 = and i64 %14, 8589934588, !dbg !193
  %16 = shl nuw nsw i64 %13, 3, !dbg !193
  %17 = and i64 %16, 8, !dbg !193
  %.idx61 = shl nuw nsw i64 %17, 8
  %invariant.gep = getelementptr inbounds nuw i8, ptr %5, i64 %.idx61
  %.idx = shl nuw nsw i64 %17, 6
  %invariant.gep93 = getelementptr i8, ptr %11, i64 %.idx, !dbg !193
  br label %18, !dbg !193

18:                                               ; preds = %3, %117
  %19 = phi i64 [ 0, %3 ], [ %125, %117 ]
  %20 = or disjoint i64 %19, %15, !dbg !193
  %.idx38 = shl nuw nsw i64 %20, 6
  %21 = getelementptr inbounds nuw i8, ptr %8, i64 %.idx38
  br label %.preheader70, !dbg !193

.preheader70:                                     ; preds = %18, %87
  %22 = phi [8 x <16 x float>] [ zeroinitializer, %18 ], [ %115, %87 ]
  %23 = phi i64 [ 0, %18 ], [ %116, %87 ]
  %.idx60 = shl nuw nsw i64 %23, 12
  %gep = getelementptr inbounds nuw i8, ptr %invariant.gep, i64 %.idx60
  br label %25, !dbg !193

.preheader69:                                     ; preds = %25
  %24 = getelementptr inbounds nuw i8, ptr %gep, i64 256
  br label %33, !dbg !193

25:                                               ; preds = %.preheader70, %25
  %26 = phi <16 x float> [ poison, %.preheader70 ], [ %30, %25 ]
  %27 = phi i64 [ 0, %.preheader70 ], [ %31, %25 ]
  %.idx62 = shl nuw nsw i64 %27, 3, !dbg !193
  %28 = getelementptr inbounds nuw i8, ptr %gep, i64 %.idx62, !dbg !193
  %29 = load float, ptr %28, align 8, !dbg !193
  %30 = insertelement <16 x float> %26, float %29, i64 %27, !dbg !193
  %31 = add nuw nsw i64 %27, 1, !dbg !193
  %exitcond.not = icmp eq i64 %31, 16, !dbg !193
  br i1 %exitcond.not, label %.preheader69, label %25, !dbg !193

.preheader68:                                     ; preds = %33
  %32 = getelementptr inbounds nuw i8, ptr %gep, i64 512
  br label %41, !dbg !193

33:                                               ; preds = %.preheader69, %33
  %34 = phi <16 x float> [ poison, %.preheader69 ], [ %38, %33 ]
  %35 = phi i64 [ 0, %.preheader69 ], [ %39, %33 ]
  %.idx59 = shl nuw nsw i64 %35, 3, !dbg !193
  %36 = getelementptr inbounds nuw i8, ptr %24, i64 %.idx59, !dbg !193
  %37 = load float, ptr %36, align 8, !dbg !193
  %38 = insertelement <16 x float> %34, float %37, i64 %35, !dbg !193
  %39 = add nuw nsw i64 %35, 1, !dbg !193
  %exitcond110.not = icmp eq i64 %39, 16, !dbg !193
  br i1 %exitcond110.not, label %.preheader68, label %33, !dbg !193

.preheader67:                                     ; preds = %41
  %40 = getelementptr inbounds nuw i8, ptr %gep, i64 768
  br label %49, !dbg !193

41:                                               ; preds = %.preheader68, %41
  %42 = phi <16 x float> [ poison, %.preheader68 ], [ %46, %41 ]
  %43 = phi i64 [ 0, %.preheader68 ], [ %47, %41 ]
  %.idx56 = shl nuw nsw i64 %43, 3, !dbg !193
  %44 = getelementptr inbounds nuw i8, ptr %32, i64 %.idx56, !dbg !193
  %45 = load float, ptr %44, align 8, !dbg !193
  %46 = insertelement <16 x float> %42, float %45, i64 %43, !dbg !193
  %47 = add nuw nsw i64 %43, 1, !dbg !193
  %exitcond111.not = icmp eq i64 %47, 16, !dbg !193
  br i1 %exitcond111.not, label %.preheader67, label %41, !dbg !193

.preheader66:                                     ; preds = %49
  %48 = getelementptr inbounds nuw i8, ptr %gep, i64 1024
  br label %57, !dbg !193

49:                                               ; preds = %.preheader67, %49
  %50 = phi <16 x float> [ poison, %.preheader67 ], [ %54, %49 ]
  %51 = phi i64 [ 0, %.preheader67 ], [ %55, %49 ]
  %.idx53 = shl nuw nsw i64 %51, 3, !dbg !193
  %52 = getelementptr inbounds nuw i8, ptr %40, i64 %.idx53, !dbg !193
  %53 = load float, ptr %52, align 8, !dbg !193
  %54 = insertelement <16 x float> %50, float %53, i64 %51, !dbg !193
  %55 = add nuw nsw i64 %51, 1, !dbg !193
  %exitcond112.not = icmp eq i64 %55, 16, !dbg !193
  br i1 %exitcond112.not, label %.preheader66, label %49, !dbg !193

.preheader65:                                     ; preds = %57
  %56 = getelementptr inbounds nuw i8, ptr %gep, i64 1280
  br label %65, !dbg !193

57:                                               ; preds = %.preheader66, %57
  %58 = phi <16 x float> [ poison, %.preheader66 ], [ %62, %57 ]
  %59 = phi i64 [ 0, %.preheader66 ], [ %63, %57 ]
  %.idx50 = shl nuw nsw i64 %59, 3, !dbg !193
  %60 = getelementptr inbounds nuw i8, ptr %48, i64 %.idx50, !dbg !193
  %61 = load float, ptr %60, align 8, !dbg !193
  %62 = insertelement <16 x float> %58, float %61, i64 %59, !dbg !193
  %63 = add nuw nsw i64 %59, 1, !dbg !193
  %exitcond113.not = icmp eq i64 %63, 16, !dbg !193
  br i1 %exitcond113.not, label %.preheader65, label %57, !dbg !193

.preheader64:                                     ; preds = %65
  %64 = getelementptr inbounds nuw i8, ptr %gep, i64 1536
  br label %73, !dbg !193

65:                                               ; preds = %.preheader65, %65
  %66 = phi <16 x float> [ poison, %.preheader65 ], [ %70, %65 ]
  %67 = phi i64 [ 0, %.preheader65 ], [ %71, %65 ]
  %.idx47 = shl nuw nsw i64 %67, 3, !dbg !193
  %68 = getelementptr inbounds nuw i8, ptr %56, i64 %.idx47, !dbg !193
  %69 = load float, ptr %68, align 8, !dbg !193
  %70 = insertelement <16 x float> %66, float %69, i64 %67, !dbg !193
  %71 = add nuw nsw i64 %67, 1, !dbg !193
  %exitcond114.not = icmp eq i64 %71, 16, !dbg !193
  br i1 %exitcond114.not, label %.preheader64, label %65, !dbg !193

.preheader:                                       ; preds = %73
  %72 = getelementptr inbounds nuw i8, ptr %gep, i64 1792
  br label %80, !dbg !193

73:                                               ; preds = %.preheader64, %73
  %74 = phi <16 x float> [ poison, %.preheader64 ], [ %78, %73 ]
  %75 = phi i64 [ 0, %.preheader64 ], [ %79, %73 ]
  %.idx44 = shl nuw nsw i64 %75, 3, !dbg !193
  %76 = getelementptr inbounds nuw i8, ptr %64, i64 %.idx44, !dbg !193
  %77 = load float, ptr %76, align 8, !dbg !193
  %78 = insertelement <16 x float> %74, float %77, i64 %75, !dbg !193
  %79 = add nuw nsw i64 %75, 1, !dbg !193
  %exitcond115.not = icmp eq i64 %79, 16, !dbg !193
  br i1 %exitcond115.not, label %.preheader, label %73, !dbg !193

80:                                               ; preds = %.preheader, %80
  %81 = phi <16 x float> [ poison, %.preheader ], [ %85, %80 ]
  %82 = phi i64 [ 0, %.preheader ], [ %86, %80 ]
  %.idx41 = shl nuw nsw i64 %82, 3, !dbg !193
  %83 = getelementptr inbounds nuw i8, ptr %72, i64 %.idx41, !dbg !193
  %84 = load float, ptr %83, align 8, !dbg !193
  %85 = insertelement <16 x float> %81, float %84, i64 %82, !dbg !193
  %86 = add nuw nsw i64 %82, 1, !dbg !193
  %exitcond116.not = icmp eq i64 %86, 16, !dbg !193
  br i1 %exitcond116.not, label %87, label %80, !dbg !193

87:                                               ; preds = %80
  %88 = extractvalue [8 x <16 x float>] %22, 0, !dbg !194
  %89 = getelementptr inbounds nuw [4 x i8], ptr %21, i64 %23, !dbg !194
  %90 = load float, ptr %89, align 4, !dbg !194
  %91 = insertelement <16 x float> poison, float %90, i64 0, !dbg !194
  %92 = shufflevector <16 x float> %91, <16 x float> poison, <16 x i32> zeroinitializer, !dbg !194
  %93 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %30, <16 x float> %92, <16 x float> %88), !dbg !194
  %94 = extractvalue [8 x <16 x float>] %22, 1, !dbg !194
  %95 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %38, <16 x float> %92, <16 x float> %94), !dbg !194
  %96 = extractvalue [8 x <16 x float>] %22, 2, !dbg !194
  %97 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %46, <16 x float> %92, <16 x float> %96), !dbg !194
  %98 = extractvalue [8 x <16 x float>] %22, 3, !dbg !194
  %99 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %54, <16 x float> %92, <16 x float> %98), !dbg !194
  %100 = extractvalue [8 x <16 x float>] %22, 4, !dbg !194
  %101 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %62, <16 x float> %92, <16 x float> %100), !dbg !194
  %102 = extractvalue [8 x <16 x float>] %22, 5, !dbg !194
  %103 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %70, <16 x float> %92, <16 x float> %102), !dbg !194
  %104 = extractvalue [8 x <16 x float>] %22, 6, !dbg !194
  %105 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %78, <16 x float> %92, <16 x float> %104), !dbg !194
  %106 = extractvalue [8 x <16 x float>] %22, 7, !dbg !194
  %107 = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %85, <16 x float> %92, <16 x float> %106), !dbg !194
  %108 = insertvalue [8 x <16 x float>] poison, <16 x float> %93, 0, !dbg !194
  %109 = insertvalue [8 x <16 x float>] %108, <16 x float> %95, 1, !dbg !194
  %110 = insertvalue [8 x <16 x float>] %109, <16 x float> %97, 2, !dbg !194
  %111 = insertvalue [8 x <16 x float>] %110, <16 x float> %99, 3, !dbg !194
  %112 = insertvalue [8 x <16 x float>] %111, <16 x float> %101, 4, !dbg !194
  %113 = insertvalue [8 x <16 x float>] %112, <16 x float> %103, 5, !dbg !194
  %114 = insertvalue [8 x <16 x float>] %113, <16 x float> %105, 6, !dbg !194
  %115 = insertvalue [8 x <16 x float>] %114, <16 x float> %107, 7, !dbg !194
  %116 = add nuw nsw i64 %23, 1, !dbg !193
  %exitcond117.not = icmp eq i64 %116, 16, !dbg !193
  br i1 %exitcond117.not, label %117, label %.preheader70, !dbg !193

117:                                              ; preds = %87
  %.idx63 = shl nuw nsw i64 %20, 10, !dbg !193
  %gep94 = getelementptr i8, ptr %invariant.gep93, i64 %.idx63, !dbg !193
  store <16 x float> %93, ptr %gep94, align 64, !dbg !193
  %118 = getelementptr i8, ptr %gep94, i64 64, !dbg !193
  store <16 x float> %95, ptr %118, align 64, !dbg !193
  %119 = getelementptr i8, ptr %gep94, i64 128, !dbg !193
  store <16 x float> %97, ptr %119, align 64, !dbg !193
  %120 = getelementptr i8, ptr %gep94, i64 192, !dbg !193
  store <16 x float> %99, ptr %120, align 64, !dbg !193
  %121 = getelementptr i8, ptr %gep94, i64 256, !dbg !193
  store <16 x float> %101, ptr %121, align 64, !dbg !193
  %122 = getelementptr i8, ptr %gep94, i64 320, !dbg !193
  store <16 x float> %103, ptr %122, align 64, !dbg !193
  %123 = getelementptr i8, ptr %gep94, i64 384, !dbg !193
  store <16 x float> %105, ptr %123, align 64, !dbg !193
  %124 = getelementptr i8, ptr %gep94, i64 448, !dbg !193
  store <16 x float> %107, ptr %124, align 64, !dbg !193
  %125 = add nuw nsw i64 %19, 1, !dbg !193
  %exitcond118.not = icmp eq i64 %125, 4, !dbg !193
  br i1 %exitcond118.not, label %126, label %18, !dbg !193

126:                                              ; preds = %117
  ret i32 0, !dbg !195
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_8_conv_32x16x16x32x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !196 {
  %4 = alloca [4 x float], align 64, !dbg !197
  %5 = alloca [4 x float], align 64, !dbg !198
  %.elt22 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !199
  %.unpack23 = load ptr, ptr %.elt22, align 16, !dbg !199
  %6 = load ptr, ptr %.unpack23, align 8, !dbg !199
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !199
  %7 = getelementptr i8, ptr %.unpack23, i64 8, !dbg !200
  %8 = load ptr, ptr %7, align 8, !dbg !200
  %9 = getelementptr i8, ptr %8, i64 249856, !dbg !200
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !200
  %10 = getelementptr i8, ptr %6, i64 41472, !dbg !201
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !201
  %11 = getelementptr i8, ptr %.unpack23, i64 16, !dbg !202
  %12 = load ptr, ptr %11, align 8, !dbg !202
  %13 = getelementptr i8, ptr %12, i64 74240, !dbg !202
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !202
  %14 = load i32, ptr %2, align 16, !dbg !197
  %15 = zext i32 %14 to i64, !dbg !197
  %16 = shl nuw nsw i64 %15, 1, !dbg !197
  %17 = and i64 %16, 8589934588, !dbg !197
  %18 = shl nuw nsw i64 %15, 3, !dbg !197
  %19 = and i64 %18, 8, !dbg !197
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !203
  br label %20, !dbg !197

20:                                               ; preds = %3, %81
  %21 = phi i64 [ 0, %3 ], [ %82, %81 ]
  %22 = or disjoint i64 %21, %17, !dbg !197
  %23 = getelementptr [4 x i8], ptr @__constant_32xf32_0, i64 %22, !dbg !204
  %24 = load <1 x float>, ptr %23, align 4, !dbg !204
  %25 = getelementptr [4 x i8], ptr @__constant_32xf32_1, i64 %22, !dbg !204
  %26 = load <1 x float>, ptr %25, align 4, !dbg !204
  %.idx27 = mul nuw nsw i64 %22, 1152
  %27 = getelementptr inbounds nuw i8, ptr %9, i64 %.idx27
  %28 = shl nuw nsw i64 %22, 8
  %29 = shufflevector <1 x float> %26, <1 x float> poison, <4 x i32> zeroinitializer
  %30 = shufflevector <1 x float> %24, <1 x float> poison, <4 x i32> zeroinitializer
  br label %.preheader33, !dbg !197

.preheader33:                                     ; preds = %20, %79
  %31 = phi i64 [ 0, %20 ], [ %80, %79 ]
  %32 = add nuw nsw i64 %31, %19
  %33 = shl i64 %32, 4
  %34 = add i64 %33, %28
  br label %.preheader32, !dbg !197

.preheader32:                                     ; preds = %.preheader33, %67
  %35 = phi i64 [ 0, %.preheader33 ], [ %77, %67 ]
  br label %36, !dbg !197

.preheader31:                                     ; preds = %36
  %invariant.gep34 = getelementptr [4 x i8], ptr %6, i64 %35, !dbg !197
  br label %.preheader30, !dbg !197

36:                                               ; preds = %.preheader32, %36
  %37 = phi i64 [ 0, %.preheader32 ], [ %41, %36 ]
  %38 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %37, !dbg !197
  %39 = load float, ptr %38, align 4, !dbg !197
  %40 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %37, !dbg !197
  store float %39, ptr %40, align 4, !dbg !197
  %41 = add nuw nsw i64 %37, 1, !dbg !197
  %exitcond.not = icmp eq i64 %41, 4, !dbg !197
  br i1 %exitcond.not, label %.preheader31, label %36, !dbg !197

.preheader30:                                     ; preds = %.preheader31, %65
  %42 = phi i64 [ 0, %.preheader31 ], [ %66, %65 ]
  %.idx = mul nuw nsw i64 %42, 1296
  %gep35 = getelementptr i8, ptr %invariant.gep34, i64 %.idx, !dbg !197
  %.idx28 = mul nuw nsw i64 %42, 36
  %43 = getelementptr inbounds nuw i8, ptr %27, i64 %.idx28
  br label %44, !dbg !197

44:                                               ; preds = %.preheader30, %63
  %45 = phi i64 [ 0, %.preheader30 ], [ %64, %63 ]
  %46 = add nuw nsw i64 %32, %45, !dbg !197
  %.idx26 = mul nuw nsw i64 %46, 72
  %gep = getelementptr i8, ptr %gep35, i64 %.idx26
  %.idx29 = mul nuw nsw i64 %45, 12
  %47 = getelementptr inbounds nuw i8, ptr %43, i64 %.idx29
  br label %.preheader, !dbg !197

.preheader:                                       ; preds = %44, %61
  %48 = phi i64 [ 0, %44 ], [ %62, %61 ]
  %49 = getelementptr [4 x i8], ptr %gep, i64 %48
  %50 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %48
  %.promoted = load float, ptr %50, align 4
  br label %51, !dbg !197

51:                                               ; preds = %.preheader, %51
  %52 = phi i64 [ 0, %.preheader ], [ %60, %51 ]
  %53 = phi float [ %.promoted, %.preheader ], [ %59, %51 ]
  %54 = getelementptr [4 x i8], ptr %49, i64 %52, !dbg !197
  %55 = load float, ptr %54, align 4, !dbg !197
  %56 = getelementptr inbounds nuw [4 x i8], ptr %47, i64 %52, !dbg !197
  %57 = load float, ptr %56, align 4, !dbg !197
  %58 = fmul contract float %55, %57, !dbg !205
  %59 = fadd contract float %53, %58, !dbg !206
  %60 = add nuw nsw i64 %52, 1, !dbg !197
  %exitcond36.not = icmp eq i64 %60, 3, !dbg !197
  br i1 %exitcond36.not, label %61, label %51, !dbg !197

61:                                               ; preds = %51
  store float %59, ptr %50, align 4, !dbg !197
  %62 = add nuw nsw i64 %48, 1, !dbg !197
  %exitcond37.not = icmp eq i64 %62, 4, !dbg !197
  br i1 %exitcond37.not, label %63, label %.preheader, !dbg !197

63:                                               ; preds = %61
  %64 = add nuw nsw i64 %45, 1, !dbg !197
  %exitcond38.not = icmp eq i64 %64, 3, !dbg !197
  br i1 %exitcond38.not, label %65, label %44, !dbg !197

65:                                               ; preds = %63
  %66 = add nuw nsw i64 %42, 1, !dbg !197
  %exitcond39.not = icmp eq i64 %66, 32, !dbg !197
  br i1 %exitcond39.not, label %67, label %.preheader30, !dbg !197

67:                                               ; preds = %65
  %68 = add nuw nsw i64 %34, %35, !dbg !204
  %69 = getelementptr [4 x i8], ptr %10, i64 %68, !dbg !204
  %70 = load <4 x float>, ptr %69, align 16, !dbg !204
  %71 = load <4 x float>, ptr %4, align 64, !dbg !204
  %72 = fadd contract <4 x float> %29, %71, !dbg !207
  %73 = fadd contract <4 x float> %30, %70, !dbg !208
  %74 = fadd contract <4 x float> %73, %72, !dbg !209
  %.inv = fcmp ole <4 x float> %74, zeroinitializer, !dbg !210
  %75 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %74, !dbg !210
  %76 = getelementptr [4 x i8], ptr %13, i64 %68, !dbg !197
  store <4 x float> %75, ptr %76, align 16, !dbg !197
  %77 = add nuw nsw i64 %35, 4, !dbg !197
  %78 = icmp samesign ult i64 %35, 12, !dbg !197
  br i1 %78, label %.preheader32, label %79, !dbg !197

79:                                               ; preds = %67
  %80 = add nuw nsw i64 %31, 1, !dbg !197
  %exitcond40.not = icmp eq i64 %80, 8, !dbg !197
  br i1 %exitcond40.not, label %81, label %.preheader33, !dbg !197

81:                                               ; preds = %79
  %82 = add nuw nsw i64 %21, 1, !dbg !197
  %exitcond41.not = icmp eq i64 %82, 4, !dbg !197
  br i1 %exitcond41.not, label %83, label %20, !dbg !197

83:                                               ; preds = %81
  ret i32 0, !dbg !211
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_9_slow_memcpy(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !212 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !213
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !213
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !213
  %5 = getelementptr i8, ptr %4, i64 74240, !dbg !214
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !214
  %6 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !215
  %7 = load ptr, ptr %6, align 8, !dbg !215
  %8 = getelementptr i8, ptr %7, i64 107008, !dbg !216
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !216
  %9 = load i32, ptr %2, align 16, !dbg !217
  %10 = zext i32 %9 to i64, !dbg !217
  %11 = shl nuw nsw i64 %10, 3, !dbg !217
  br label %.preheader26, !dbg !217

.preheader26:                                     ; preds = %3, %28
  %12 = phi i64 [ 0, %3 ], [ %29, %28 ]
  %.idx = shl i64 %12, 10
  %13 = getelementptr i8, ptr %5, i64 %.idx
  %.idx24 = mul nuw nsw i64 %12, 1156
  %14 = getelementptr i8, ptr %8, i64 %.idx24
  br label %.preheader, !dbg !217

.preheader:                                       ; preds = %.preheader26, %26
  %15 = phi i64 [ 0, %.preheader26 ], [ %27, %26 ]
  %16 = add nuw nsw i64 %15, %11
  %.idx23 = shl i64 %16, 6
  %17 = getelementptr i8, ptr %13, i64 %.idx23
  %.idx25 = mul nuw nsw i64 %16, 68
  %18 = getelementptr i8, ptr %14, i64 %.idx25
  br label %19, !dbg !217

19:                                               ; preds = %.preheader, %19
  %20 = phi i64 [ 0, %.preheader ], [ %24, %19 ]
  %21 = getelementptr [4 x i8], ptr %17, i64 %20, !dbg !217
  %22 = load <4 x float>, ptr %21, align 16, !dbg !217
  %23 = getelementptr [4 x i8], ptr %18, i64 %20, !dbg !217
  store <4 x float> %22, ptr %23, align 4, !dbg !217
  %24 = add nuw nsw i64 %20, 4, !dbg !217
  %25 = icmp samesign ult i64 %20, 12, !dbg !217
  br i1 %25, label %19, label %26, !dbg !217

26:                                               ; preds = %19
  %27 = add nuw nsw i64 %15, 1, !dbg !217
  %exitcond.not = icmp eq i64 %27, 8, !dbg !217
  br i1 %exitcond.not, label %28, label %.preheader, !dbg !217

28:                                               ; preds = %26
  %29 = add nuw nsw i64 %12, 1, !dbg !217
  %exitcond27.not = icmp eq i64 %29, 32, !dbg !217
  br i1 %exitcond27.not, label %30, label %.preheader26, !dbg !217

30:                                               ; preds = %28
  ret i32 0, !dbg !218
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_10_conv_64x8x8x32x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !219 {
  %4 = alloca [4 x float], align 64, !dbg !220
  %5 = alloca [4 x float], align 64, !dbg !221
  %.elt23 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !222
  %.unpack24 = load ptr, ptr %.elt23, align 16, !dbg !222
  %6 = load ptr, ptr %.unpack24, align 8, !dbg !222
  %7 = getelementptr i8, ptr %6, i64 107008, !dbg !222
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !222
  %8 = getelementptr i8, ptr %.unpack24, i64 8, !dbg !223
  %9 = load ptr, ptr %8, align 8, !dbg !223
  %10 = getelementptr i8, ptr %9, i64 176128, !dbg !223
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !223
  %11 = getelementptr i8, ptr %.unpack24, i64 16, !dbg !224
  %12 = load ptr, ptr %11, align 8, !dbg !224
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !224
  %13 = load i32, ptr %2, align 16, !dbg !220
  %14 = zext i32 %13 to i64, !dbg !220
  %15 = and i64 %14, 1, !dbg !220
  %16 = shl nuw nsw i64 %14, 2, !dbg !220
  %17 = and i64 %16, 17179869176, !dbg !220
  %18 = shl nuw nsw i64 %15, 2, !dbg !220
  store <4 x float> zeroinitializer, ptr %5, align 64, !dbg !225
  %19 = shl nuw nsw i64 %15, 3
  br label %20, !dbg !220

20:                                               ; preds = %3, %77
  %21 = phi i64 [ 0, %3 ], [ %78, %77 ]
  %22 = or disjoint i64 %21, %17, !dbg !220
  %23 = getelementptr [4 x i8], ptr @__constant_64xf32, i64 %22, !dbg !226
  %24 = load <1 x float>, ptr %23, align 4, !dbg !226
  %.idx31 = mul nuw nsw i64 %22, 1152
  %25 = getelementptr inbounds nuw i8, ptr %10, i64 %.idx31
  %26 = shufflevector <1 x float> %24, <1 x float> poison, <4 x i32> zeroinitializer
  %.idx = mul nuw nsw i64 %22, 400
  %27 = getelementptr i8, ptr %12, i64 %.idx
  br label %.preheader37, !dbg !220

.preheader37:                                     ; preds = %20, %75
  %28 = phi i64 [ 0, %20 ], [ %76, %75 ]
  %29 = shl nuw nsw i64 %28, 1
  %30 = add nuw nsw i64 %29, %19
  %31 = add nuw nsw i64 %28, %18
  %.idx27 = mul nuw nsw i64 %31, 40
  %32 = getelementptr i8, ptr %27, i64 %.idx27
  %33 = getelementptr i8, ptr %32, i64 44
  br label %.preheader36, !dbg !220

.preheader36:                                     ; preds = %.preheader37, %70
  %34 = phi i1 [ true, %.preheader37 ], [ false, %70 ]
  %35 = phi i64 [ 0, %.preheader37 ], [ 4, %70 ]
  br label %36, !dbg !220

36:                                               ; preds = %.preheader36, %36
  %37 = phi i64 [ 0, %.preheader36 ], [ %41, %36 ]
  %38 = getelementptr inbounds nuw [4 x i8], ptr %5, i64 %37, !dbg !220
  %39 = load float, ptr %38, align 4, !dbg !220
  %40 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %37, !dbg !220
  store float %39, ptr %40, align 4, !dbg !220
  %41 = add nuw nsw i64 %37, 1, !dbg !220
  %exitcond.not = icmp eq i64 %41, 4, !dbg !220
  br i1 %exitcond.not, label %.preheader34, label %36, !dbg !220

.preheader34:                                     ; preds = %36, %68
  %42 = phi i64 [ %69, %68 ], [ 0, %36 ]
  %.idx28 = mul nuw nsw i64 %42, 1156
  %43 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx28
  %.idx32 = mul nuw nsw i64 %42, 36
  %44 = getelementptr inbounds nuw i8, ptr %25, i64 %.idx32
  br label %45, !dbg !220

45:                                               ; preds = %.preheader34, %66
  %46 = phi i64 [ 0, %.preheader34 ], [ %67, %66 ]
  %47 = add nuw nsw i64 %30, %46, !dbg !220
  %.idx29 = mul nuw nsw i64 %47, 68
  %48 = getelementptr inbounds nuw i8, ptr %43, i64 %.idx29
  %.idx33 = mul nuw nsw i64 %46, 12
  %49 = getelementptr inbounds nuw i8, ptr %44, i64 %.idx33
  br label %.preheader, !dbg !220

.preheader:                                       ; preds = %45, %64
  %50 = phi i64 [ 0, %45 ], [ %65, %64 ]
  %51 = add nuw nsw i64 %50, %35
  %.idx30 = shl i64 %51, 3
  %52 = getelementptr i8, ptr %48, i64 %.idx30
  %53 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %50
  %.promoted = load float, ptr %53, align 4
  br label %54, !dbg !220

54:                                               ; preds = %.preheader, %54
  %55 = phi i64 [ 0, %.preheader ], [ %63, %54 ]
  %56 = phi float [ %.promoted, %.preheader ], [ %62, %54 ]
  %57 = getelementptr [4 x i8], ptr %52, i64 %55, !dbg !220
  %58 = load float, ptr %57, align 4, !dbg !220
  %59 = getelementptr inbounds nuw [4 x i8], ptr %49, i64 %55, !dbg !220
  %60 = load float, ptr %59, align 4, !dbg !220
  %61 = fmul contract float %58, %60, !dbg !227
  %62 = fadd contract float %56, %61, !dbg !228
  %63 = add nuw nsw i64 %55, 1, !dbg !220
  %exitcond38.not = icmp eq i64 %63, 3, !dbg !220
  br i1 %exitcond38.not, label %64, label %54, !dbg !220

64:                                               ; preds = %54
  store float %62, ptr %53, align 4, !dbg !220
  %65 = add nuw nsw i64 %50, 1, !dbg !220
  %exitcond39.not = icmp eq i64 %65, 4, !dbg !220
  br i1 %exitcond39.not, label %66, label %.preheader, !dbg !220

66:                                               ; preds = %64
  %67 = add nuw nsw i64 %46, 1, !dbg !220
  %exitcond40.not = icmp eq i64 %67, 3, !dbg !220
  br i1 %exitcond40.not, label %68, label %45, !dbg !220

68:                                               ; preds = %66
  %69 = add nuw nsw i64 %42, 1, !dbg !220
  %exitcond41.not = icmp eq i64 %69, 32, !dbg !220
  br i1 %exitcond41.not, label %70, label %.preheader34, !dbg !220

70:                                               ; preds = %68
  %71 = load <4 x float>, ptr %4, align 64, !dbg !226
  %72 = fadd contract <4 x float> %26, %71, !dbg !229
  %.inv = fcmp ole <4 x float> %72, zeroinitializer, !dbg !230
  %73 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %72, !dbg !230
  %74 = getelementptr [4 x i8], ptr %33, i64 %35, !dbg !220
  store <4 x float> %73, ptr %74, align 4, !dbg !220
  br i1 %34, label %.preheader36, label %75, !dbg !220

75:                                               ; preds = %70
  %76 = add nuw nsw i64 %28, 1, !dbg !220
  %exitcond42.not = icmp eq i64 %76, 4, !dbg !220
  br i1 %exitcond42.not, label %77, label %.preheader37, !dbg !220

77:                                               ; preds = %75
  %78 = add nuw nsw i64 %21, 1, !dbg !220
  %exitcond43.not = icmp eq i64 %78, 8, !dbg !220
  br i1 %exitcond43.not, label %79, label %20, !dbg !220

79:                                               ; preds = %77
  ret i32 0, !dbg !231
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_11_conv_64x8x8x64x3x3_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !232 {
  %.elt22 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !233
  %.unpack23 = load ptr, ptr %.elt22, align 16, !dbg !233
  %4 = load ptr, ptr %.unpack23, align 8, !dbg !233
  call void @llvm.assume(i1 true) [ "align"(ptr %4, i64 64) ], !dbg !233
  %5 = getelementptr i8, ptr %.unpack23, i64 8, !dbg !234
  %6 = load ptr, ptr %5, align 8, !dbg !234
  %7 = getelementptr i8, ptr %6, i64 28672, !dbg !234
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !234
  %8 = getelementptr i8, ptr %.unpack23, i64 16, !dbg !235
  %9 = load ptr, ptr %8, align 8, !dbg !235
  %10 = getelementptr i8, ptr %9, i64 25600, !dbg !235
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !235
  %11 = load i32, ptr %2, align 16, !dbg !236
  %12 = zext i32 %11 to i64, !dbg !236
  %13 = shl nuw nsw i64 %12, 2, !dbg !236
  %14 = and i64 %13, 17179869176, !dbg !236
  %15 = and i64 %13, 4, !dbg !236
  br label %16, !dbg !236

16:                                               ; preds = %3, %59
  %17 = phi i64 [ 0, %3 ], [ %60, %59 ]
  %18 = or disjoint i64 %17, %14, !dbg !236
  %.idx30 = shl nuw nsw i64 %18, 8
  %19 = getelementptr i8, ptr %10, i64 %.idx30
  %.idx27 = mul nuw nsw i64 %18, 2304
  %20 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx27
  br label %.preheader33, !dbg !236

.preheader33:                                     ; preds = %16, %57
  %21 = phi i64 [ 0, %16 ], [ %58, %57 ]
  %22 = add nuw nsw i64 %21, %15
  %.idx31 = shl i64 %22, 5
  %23 = getelementptr i8, ptr %19, i64 %.idx31
  br label %24, !dbg !236

24:                                               ; preds = %.preheader33, %56
  %25 = phi i1 [ true, %.preheader33 ], [ false, %56 ]
  %26 = phi i64 [ 0, %.preheader33 ], [ 4, %56 ]
  %27 = getelementptr [4 x i8], ptr %23, i64 %26, !dbg !237
  store <4 x float> zeroinitializer, ptr %27, align 16, !dbg !237
  br label %.preheader32, !dbg !236

.preheader32:                                     ; preds = %24, %54
  %28 = phi i64 [ 0, %24 ], [ %55, %54 ]
  %.idx = mul nuw nsw i64 %28, 400
  %29 = getelementptr inbounds nuw i8, ptr %4, i64 %.idx
  %.idx28 = mul nuw nsw i64 %28, 36
  %30 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx28
  br label %31, !dbg !236

31:                                               ; preds = %.preheader32, %52
  %32 = phi i64 [ 0, %.preheader32 ], [ %53, %52 ]
  %33 = add nuw nsw i64 %22, %32, !dbg !236
  %.idx26 = mul nuw nsw i64 %33, 40
  %34 = getelementptr inbounds nuw i8, ptr %29, i64 %.idx26
  %.idx29 = mul nuw nsw i64 %32, 12
  %35 = getelementptr inbounds nuw i8, ptr %30, i64 %.idx29
  br label %.preheader, !dbg !236

.preheader:                                       ; preds = %31, %50
  %36 = phi i64 [ 0, %31 ], [ %51, %50 ]
  %37 = add nuw nsw i64 %36, %26
  %38 = getelementptr [4 x i8], ptr %34, i64 %37
  %39 = getelementptr inbounds nuw [4 x i8], ptr %23, i64 %37
  %.promoted = load float, ptr %39, align 4
  br label %40, !dbg !236

40:                                               ; preds = %.preheader, %40
  %41 = phi i64 [ 0, %.preheader ], [ %49, %40 ]
  %42 = phi float [ %.promoted, %.preheader ], [ %48, %40 ]
  %43 = getelementptr [4 x i8], ptr %38, i64 %41, !dbg !236
  %44 = load float, ptr %43, align 4, !dbg !236
  %45 = getelementptr inbounds nuw [4 x i8], ptr %35, i64 %41, !dbg !236
  %46 = load float, ptr %45, align 4, !dbg !236
  %47 = fmul contract float %44, %46, !dbg !238
  %48 = fadd contract float %42, %47, !dbg !239
  store float %48, ptr %39, align 4, !dbg !236
  %49 = add nuw nsw i64 %41, 1, !dbg !236
  %exitcond.not = icmp eq i64 %49, 3, !dbg !236
  br i1 %exitcond.not, label %50, label %40, !dbg !236

50:                                               ; preds = %40
  %51 = add nuw nsw i64 %36, 1, !dbg !236
  %exitcond34.not = icmp eq i64 %51, 4, !dbg !236
  br i1 %exitcond34.not, label %52, label %.preheader, !dbg !236

52:                                               ; preds = %50
  %53 = add nuw nsw i64 %32, 1, !dbg !236
  %exitcond35.not = icmp eq i64 %53, 3, !dbg !236
  br i1 %exitcond35.not, label %54, label %31, !dbg !236

54:                                               ; preds = %52
  %55 = add nuw nsw i64 %28, 1, !dbg !236
  %exitcond36.not = icmp eq i64 %55, 64, !dbg !236
  br i1 %exitcond36.not, label %56, label %.preheader32, !dbg !236

56:                                               ; preds = %54
  br i1 %25, label %24, label %57, !dbg !236

57:                                               ; preds = %56
  %58 = add nuw nsw i64 %21, 1, !dbg !236
  %exitcond37.not = icmp eq i64 %58, 4, !dbg !236
  br i1 %exitcond37.not, label %59, label %.preheader33, !dbg !236

59:                                               ; preds = %57
  %60 = add nuw nsw i64 %17, 1, !dbg !236
  %exitcond38.not = icmp eq i64 %60, 8, !dbg !236
  br i1 %exitcond38.not, label %61, label %16, !dbg !236

61:                                               ; preds = %59
  ret i32 0, !dbg !240
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_12_matmul_like_64x8x8x32_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !241 {
  %.elt27 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !242
  %.unpack28 = load ptr, ptr %.elt27, align 16, !dbg !242
  %4 = load ptr, ptr %.unpack28, align 8, !dbg !242
  %5 = getelementptr i8, ptr %4, i64 74240, !dbg !242
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !242
  %6 = getelementptr i8, ptr %.unpack28, i64 8, !dbg !243
  %7 = load ptr, ptr %6, align 8, !dbg !243
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !243
  %8 = getelementptr i8, ptr %.unpack28, i64 16, !dbg !244
  %9 = load ptr, ptr %8, align 8, !dbg !244
  %10 = getelementptr i8, ptr %9, i64 41984, !dbg !244
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !244
  %11 = load i32, ptr %2, align 16, !dbg !245
  %12 = zext i32 %11 to i64, !dbg !245
  %13 = shl nuw nsw i64 %12, 3, !dbg !245
  br label %14, !dbg !245

14:                                               ; preds = %3, %107
  %15 = phi i64 [ 0, %3 ], [ %116, %107 ]
  %16 = add nuw nsw i64 %15, %13, !dbg !245
  %.idx = shl nuw nsw i64 %16, 7
  %17 = getelementptr inbounds nuw i8, ptr %7, i64 %.idx
  br label %.preheader54, !dbg !245

.preheader54:                                     ; preds = %14, %77
  %18 = phi [8 x <8 x float>] [ zeroinitializer, %14 ], [ %105, %77 ]
  %19 = phi i64 [ 0, %14 ], [ %106, %77 ]
  %.idx45 = shl nuw nsw i64 %19, 10
  %20 = getelementptr inbounds nuw i8, ptr %5, i64 %.idx45
  br label %21, !dbg !245

21:                                               ; preds = %.preheader54, %21
  %22 = phi <8 x float> [ poison, %.preheader54 ], [ %26, %21 ]
  %23 = phi i64 [ 0, %.preheader54 ], [ %27, %21 ]
  %.idx46 = shl nuw nsw i64 %23, 3, !dbg !245
  %24 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx46, !dbg !245
  %25 = load float, ptr %24, align 8, !dbg !245
  %26 = insertelement <8 x float> %22, float %25, i64 %23, !dbg !245
  %27 = add nuw nsw i64 %23, 1, !dbg !245
  %exitcond.not = icmp eq i64 %27, 8, !dbg !245
  br i1 %exitcond.not, label %.preheader53, label %21, !dbg !245

.preheader53:                                     ; preds = %21, %.preheader53
  %28 = phi <8 x float> [ %33, %.preheader53 ], [ poison, %21 ]
  %29 = phi i64 [ %34, %.preheader53 ], [ 0, %21 ]
  %.idx44 = shl nuw nsw i64 %29, 3, !dbg !245
  %30 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx44, !dbg !245
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 128, !dbg !245
  %32 = load float, ptr %31, align 8, !dbg !245
  %33 = insertelement <8 x float> %28, float %32, i64 %29, !dbg !245
  %34 = add nuw nsw i64 %29, 1, !dbg !245
  %exitcond78.not = icmp eq i64 %34, 8, !dbg !245
  br i1 %exitcond78.not, label %.preheader52, label %.preheader53, !dbg !245

.preheader52:                                     ; preds = %.preheader53, %.preheader52
  %35 = phi <8 x float> [ %40, %.preheader52 ], [ poison, %.preheader53 ]
  %36 = phi i64 [ %41, %.preheader52 ], [ 0, %.preheader53 ]
  %.idx42 = shl nuw nsw i64 %36, 3, !dbg !245
  %37 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx42, !dbg !245
  %38 = getelementptr inbounds nuw i8, ptr %37, i64 256, !dbg !245
  %39 = load float, ptr %38, align 8, !dbg !245
  %40 = insertelement <8 x float> %35, float %39, i64 %36, !dbg !245
  %41 = add nuw nsw i64 %36, 1, !dbg !245
  %exitcond79.not = icmp eq i64 %41, 8, !dbg !245
  br i1 %exitcond79.not, label %.preheader51, label %.preheader52, !dbg !245

.preheader51:                                     ; preds = %.preheader52, %.preheader51
  %42 = phi <8 x float> [ %47, %.preheader51 ], [ poison, %.preheader52 ]
  %43 = phi i64 [ %48, %.preheader51 ], [ 0, %.preheader52 ]
  %.idx40 = shl nuw nsw i64 %43, 3, !dbg !245
  %44 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx40, !dbg !245
  %45 = getelementptr inbounds nuw i8, ptr %44, i64 384, !dbg !245
  %46 = load float, ptr %45, align 8, !dbg !245
  %47 = insertelement <8 x float> %42, float %46, i64 %43, !dbg !245
  %48 = add nuw nsw i64 %43, 1, !dbg !245
  %exitcond80.not = icmp eq i64 %48, 8, !dbg !245
  br i1 %exitcond80.not, label %.preheader50, label %.preheader51, !dbg !245

.preheader50:                                     ; preds = %.preheader51, %.preheader50
  %49 = phi <8 x float> [ %54, %.preheader50 ], [ poison, %.preheader51 ]
  %50 = phi i64 [ %55, %.preheader50 ], [ 0, %.preheader51 ]
  %.idx38 = shl nuw nsw i64 %50, 3, !dbg !245
  %51 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx38, !dbg !245
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 512, !dbg !245
  %53 = load float, ptr %52, align 8, !dbg !245
  %54 = insertelement <8 x float> %49, float %53, i64 %50, !dbg !245
  %55 = add nuw nsw i64 %50, 1, !dbg !245
  %exitcond81.not = icmp eq i64 %55, 8, !dbg !245
  br i1 %exitcond81.not, label %.preheader49, label %.preheader50, !dbg !245

.preheader49:                                     ; preds = %.preheader50, %.preheader49
  %56 = phi <8 x float> [ %61, %.preheader49 ], [ poison, %.preheader50 ]
  %57 = phi i64 [ %62, %.preheader49 ], [ 0, %.preheader50 ]
  %.idx36 = shl nuw nsw i64 %57, 3, !dbg !245
  %58 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx36, !dbg !245
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 640, !dbg !245
  %60 = load float, ptr %59, align 8, !dbg !245
  %61 = insertelement <8 x float> %56, float %60, i64 %57, !dbg !245
  %62 = add nuw nsw i64 %57, 1, !dbg !245
  %exitcond82.not = icmp eq i64 %62, 8, !dbg !245
  br i1 %exitcond82.not, label %.preheader48, label %.preheader49, !dbg !245

.preheader48:                                     ; preds = %.preheader49, %.preheader48
  %63 = phi <8 x float> [ %68, %.preheader48 ], [ poison, %.preheader49 ]
  %64 = phi i64 [ %69, %.preheader48 ], [ 0, %.preheader49 ]
  %.idx34 = shl nuw nsw i64 %64, 3, !dbg !245
  %65 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx34, !dbg !245
  %66 = getelementptr inbounds nuw i8, ptr %65, i64 768, !dbg !245
  %67 = load float, ptr %66, align 8, !dbg !245
  %68 = insertelement <8 x float> %63, float %67, i64 %64, !dbg !245
  %69 = add nuw nsw i64 %64, 1, !dbg !245
  %exitcond83.not = icmp eq i64 %69, 8, !dbg !245
  br i1 %exitcond83.not, label %.preheader, label %.preheader48, !dbg !245

.preheader:                                       ; preds = %.preheader48, %.preheader
  %70 = phi <8 x float> [ %75, %.preheader ], [ poison, %.preheader48 ]
  %71 = phi i64 [ %76, %.preheader ], [ 0, %.preheader48 ]
  %.idx32 = shl nuw nsw i64 %71, 3, !dbg !245
  %72 = getelementptr inbounds nuw i8, ptr %20, i64 %.idx32, !dbg !245
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 896, !dbg !245
  %74 = load float, ptr %73, align 8, !dbg !245
  %75 = insertelement <8 x float> %70, float %74, i64 %71, !dbg !245
  %76 = add nuw nsw i64 %71, 1, !dbg !245
  %exitcond84.not = icmp eq i64 %76, 8, !dbg !245
  br i1 %exitcond84.not, label %77, label %.preheader, !dbg !245

77:                                               ; preds = %.preheader
  %78 = extractvalue [8 x <8 x float>] %18, 0, !dbg !246
  %79 = getelementptr inbounds nuw [4 x i8], ptr %17, i64 %19, !dbg !246
  %80 = load float, ptr %79, align 4, !dbg !246
  %81 = insertelement <8 x float> poison, float %80, i64 0, !dbg !246
  %82 = shufflevector <8 x float> %81, <8 x float> poison, <8 x i32> zeroinitializer, !dbg !246
  %83 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %26, <8 x float> %82, <8 x float> %78), !dbg !246
  %84 = extractvalue [8 x <8 x float>] %18, 1, !dbg !246
  %85 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %33, <8 x float> %82, <8 x float> %84), !dbg !246
  %86 = extractvalue [8 x <8 x float>] %18, 2, !dbg !246
  %87 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %40, <8 x float> %82, <8 x float> %86), !dbg !246
  %88 = extractvalue [8 x <8 x float>] %18, 3, !dbg !246
  %89 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %47, <8 x float> %82, <8 x float> %88), !dbg !246
  %90 = extractvalue [8 x <8 x float>] %18, 4, !dbg !246
  %91 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %54, <8 x float> %82, <8 x float> %90), !dbg !246
  %92 = extractvalue [8 x <8 x float>] %18, 5, !dbg !246
  %93 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %61, <8 x float> %82, <8 x float> %92), !dbg !246
  %94 = extractvalue [8 x <8 x float>] %18, 6, !dbg !246
  %95 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %68, <8 x float> %82, <8 x float> %94), !dbg !246
  %96 = extractvalue [8 x <8 x float>] %18, 7, !dbg !246
  %97 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %75, <8 x float> %82, <8 x float> %96), !dbg !246
  %98 = insertvalue [8 x <8 x float>] poison, <8 x float> %83, 0, !dbg !246
  %99 = insertvalue [8 x <8 x float>] %98, <8 x float> %85, 1, !dbg !246
  %100 = insertvalue [8 x <8 x float>] %99, <8 x float> %87, 2, !dbg !246
  %101 = insertvalue [8 x <8 x float>] %100, <8 x float> %89, 3, !dbg !246
  %102 = insertvalue [8 x <8 x float>] %101, <8 x float> %91, 4, !dbg !246
  %103 = insertvalue [8 x <8 x float>] %102, <8 x float> %93, 5, !dbg !246
  %104 = insertvalue [8 x <8 x float>] %103, <8 x float> %95, 6, !dbg !246
  %105 = insertvalue [8 x <8 x float>] %104, <8 x float> %97, 7, !dbg !246
  %106 = add nuw nsw i64 %19, 1, !dbg !245
  %exitcond85.not = icmp eq i64 %106, 32, !dbg !245
  br i1 %exitcond85.not, label %107, label %.preheader54, !dbg !245

107:                                              ; preds = %77
  %.idx47 = shl nuw nsw i64 %16, 8, !dbg !245
  %108 = getelementptr i8, ptr %10, i64 %.idx47, !dbg !245
  store <8 x float> %83, ptr %108, align 64, !dbg !245
  %109 = getelementptr i8, ptr %108, i64 32, !dbg !245
  store <8 x float> %85, ptr %109, align 32, !dbg !245
  %110 = getelementptr i8, ptr %108, i64 64, !dbg !245
  store <8 x float> %87, ptr %110, align 64, !dbg !245
  %111 = getelementptr i8, ptr %108, i64 96, !dbg !245
  store <8 x float> %89, ptr %111, align 32, !dbg !245
  %112 = getelementptr i8, ptr %108, i64 128, !dbg !245
  store <8 x float> %91, ptr %112, align 64, !dbg !245
  %113 = getelementptr i8, ptr %108, i64 160, !dbg !245
  store <8 x float> %93, ptr %113, align 32, !dbg !245
  %114 = getelementptr i8, ptr %108, i64 192, !dbg !245
  store <8 x float> %95, ptr %114, align 64, !dbg !245
  %115 = getelementptr i8, ptr %108, i64 224, !dbg !245
  store <8 x float> %97, ptr %115, align 32, !dbg !245
  %116 = add nuw nsw i64 %15, 1, !dbg !245
  %exitcond86.not = icmp eq i64 %116, 8, !dbg !245
  br i1 %exitcond86.not, label %117, label %14, !dbg !245

117:                                              ; preds = %107
  ret i32 0, !dbg !247
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_13_reduction_64x64_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !248 {
  %.elt20 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !249
  %.unpack21 = load ptr, ptr %.elt20, align 16, !dbg !249
  %4 = load ptr, ptr %.unpack21, align 8, !dbg !249
  %5 = getelementptr i8, ptr %4, i64 41984, !dbg !249
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !249
  %6 = getelementptr i8, ptr %4, i64 25600, !dbg !250
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !250
  %7 = getelementptr i8, ptr %.unpack21, i64 8, !dbg !251
  %8 = load ptr, ptr %7, align 8, !dbg !251
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !251
  %9 = load i32, ptr %2, align 16, !dbg !252
  %10 = zext i32 %9 to i64, !dbg !252
  %11 = shl nuw nsw i64 %10, 3, !dbg !252
  br label %12, !dbg !252

12:                                               ; preds = %3, %82
  %13 = phi i1 [ true, %3 ], [ false, %82 ]
  %14 = phi i64 [ 0, %3 ], [ 4, %82 ]
  %15 = or disjoint i64 %14, %11, !dbg !252
  %16 = getelementptr [4 x i8], ptr @__constant_64xf32_0, i64 %15, !dbg !252
  %17 = load <4 x float>, ptr %16, align 16, !dbg !252
  %18 = shufflevector <4 x float> %17, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !252
  %19 = shufflevector <4 x float> %17, <4 x float> poison, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, !dbg !252
  %20 = shufflevector <4 x float> %17, <4 x float> poison, <4 x i32> <i32 2, i32 2, i32 2, i32 2>, !dbg !252
  %21 = shufflevector <4 x float> %17, <4 x float> poison, <4 x i32> <i32 3, i32 3, i32 3, i32 3>, !dbg !252
  %22 = getelementptr [4 x i8], ptr @__constant_64xf32_1, i64 %15, !dbg !252
  %23 = load <4 x float>, ptr %22, align 16, !dbg !252
  %24 = shufflevector <4 x float> %23, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !252
  %25 = shufflevector <4 x float> %23, <4 x float> poison, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, !dbg !252
  %26 = shufflevector <4 x float> %23, <4 x float> poison, <4 x i32> <i32 2, i32 2, i32 2, i32 2>, !dbg !252
  %27 = shufflevector <4 x float> %23, <4 x float> poison, <4 x i32> <i32 3, i32 3, i32 3, i32 3>, !dbg !252
  %28 = shl nuw nsw i64 %15, 6
  br label %29, !dbg !252

29:                                               ; preds = %12, %29
  %30 = phi <4 x float> [ zeroinitializer, %12 ], [ %79, %29 ]
  %31 = phi i64 [ 0, %12 ], [ %80, %29 ]
  %32 = add nuw nsw i64 %31, %28, !dbg !252
  %33 = getelementptr [4 x i8], ptr %5, i64 %32, !dbg !252
  %34 = load <4 x float>, ptr %33, align 16, !dbg !252
  %35 = or disjoint i64 %32, 64, !dbg !252
  %36 = getelementptr [4 x i8], ptr %5, i64 %35, !dbg !252
  %37 = load <4 x float>, ptr %36, align 16, !dbg !252
  %38 = or disjoint i64 %32, 128, !dbg !252
  %39 = getelementptr [4 x i8], ptr %5, i64 %38, !dbg !252
  %40 = load <4 x float>, ptr %39, align 16, !dbg !252
  %41 = or disjoint i64 %32, 192, !dbg !252
  %42 = getelementptr [4 x i8], ptr %5, i64 %41, !dbg !252
  %43 = load <4 x float>, ptr %42, align 16, !dbg !252
  %44 = getelementptr [4 x i8], ptr %6, i64 %32, !dbg !252
  %45 = load <4 x float>, ptr %44, align 16, !dbg !252
  %46 = getelementptr [4 x i8], ptr %6, i64 %35, !dbg !252
  %47 = load <4 x float>, ptr %46, align 16, !dbg !252
  %48 = getelementptr [4 x i8], ptr %6, i64 %38, !dbg !252
  %49 = load <4 x float>, ptr %48, align 16, !dbg !252
  %50 = getelementptr [4 x i8], ptr %6, i64 %41, !dbg !252
  %51 = load <4 x float>, ptr %50, align 16, !dbg !252
  %52 = fadd contract <4 x float> %24, %45, !dbg !253
  %53 = fadd contract <4 x float> %25, %47, !dbg !253
  %54 = fadd contract <4 x float> %26, %49, !dbg !253
  %55 = fadd contract <4 x float> %27, %51, !dbg !253
  %56 = fadd contract <4 x float> %18, %34, !dbg !254
  %57 = fadd contract <4 x float> %19, %37, !dbg !254
  %58 = fadd contract <4 x float> %20, %40, !dbg !254
  %59 = fadd contract <4 x float> %21, %43, !dbg !254
  %60 = fadd contract <4 x float> %56, %52, !dbg !255
  %61 = fadd contract <4 x float> %57, %53, !dbg !255
  %62 = fadd contract <4 x float> %58, %54, !dbg !255
  %63 = fadd contract <4 x float> %59, %55, !dbg !255
  %.inv = fcmp ole <4 x float> %60, zeroinitializer, !dbg !256
  %64 = select <4 x i1> %.inv, <4 x float> zeroinitializer, <4 x float> %60, !dbg !256
  %.inv24 = fcmp ole <4 x float> %61, zeroinitializer, !dbg !256
  %65 = select <4 x i1> %.inv24, <4 x float> zeroinitializer, <4 x float> %61, !dbg !256
  %.inv25 = fcmp ole <4 x float> %62, zeroinitializer, !dbg !256
  %66 = select <4 x i1> %.inv25, <4 x float> zeroinitializer, <4 x float> %62, !dbg !256
  %.inv26 = fcmp ole <4 x float> %63, zeroinitializer, !dbg !256
  %67 = select <4 x i1> %.inv26, <4 x float> zeroinitializer, <4 x float> %63, !dbg !256
  %68 = extractelement <4 x float> %30, i64 0, !dbg !257
  %69 = tail call float @llvm.vector.reduce.fadd.v4f32(float %68, <4 x float> %64), !dbg !257
  %70 = extractelement <4 x float> %30, i64 1, !dbg !257
  %71 = tail call float @llvm.vector.reduce.fadd.v4f32(float %70, <4 x float> %65), !dbg !257
  %72 = extractelement <4 x float> %30, i64 2, !dbg !257
  %73 = tail call float @llvm.vector.reduce.fadd.v4f32(float %72, <4 x float> %66), !dbg !257
  %74 = extractelement <4 x float> %30, i64 3, !dbg !257
  %75 = tail call float @llvm.vector.reduce.fadd.v4f32(float %74, <4 x float> %67), !dbg !257
  %76 = insertelement <4 x float> poison, float %69, i64 0, !dbg !257
  %77 = insertelement <4 x float> %76, float %71, i64 1, !dbg !257
  %78 = insertelement <4 x float> %77, float %73, i64 2, !dbg !257
  %79 = insertelement <4 x float> %78, float %75, i64 3, !dbg !257
  %80 = add nuw nsw i64 %31, 4, !dbg !252
  %81 = icmp samesign ult i64 %31, 60, !dbg !252
  br i1 %81, label %29, label %82, !dbg !252

82:                                               ; preds = %29
  %83 = fmul <4 x float> %79, splat (float 1.562500e-02), !dbg !258
  %84 = getelementptr [4 x i8], ptr %8, i64 %15, !dbg !252
  store <4 x float> %83, ptr %84, align 16, !dbg !252
  br i1 %13, label %12, label %85, !dbg !252

85:                                               ; preds = %82
  ret i32 0, !dbg !259
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_14_matmul_1x10x64_f32(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias noundef nonnull readonly align 16 captures(none) %2) #0 !dbg !260 {
  %.elt19 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !261
  %.unpack20 = load ptr, ptr %.elt19, align 16, !dbg !261
  %4 = load ptr, ptr %.unpack20, align 8, !dbg !261
  call void @llvm.assume(i1 true) [ "align"(ptr %4, i64 64) ], !dbg !261
  %5 = getelementptr i8, ptr %.unpack20, i64 8, !dbg !262
  %6 = load ptr, ptr %5, align 8, !dbg !262
  %7 = getelementptr i8, ptr %6, i64 306880, !dbg !262
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !262
  %8 = getelementptr i8, ptr %.unpack20, i64 16, !dbg !263
  %9 = load ptr, ptr %8, align 8, !dbg !263
  %10 = load i32, ptr %2, align 16, !dbg !264
  %11 = zext i32 %10 to i64, !dbg !264
  %.idx = mul nuw nsw i64 %11, 1280
  %12 = getelementptr i8, ptr %7, i64 %.idx
  %13 = getelementptr i8, ptr %12, i64 256
  %14 = getelementptr i8, ptr %12, i64 512
  %15 = getelementptr i8, ptr %12, i64 768
  %16 = getelementptr i8, ptr %12, i64 1024
  br label %17, !dbg !264

17:                                               ; preds = %3, %17
  %18 = phi <5 x float> [ zeroinitializer, %3 ], [ %59, %17 ]
  %19 = phi i64 [ 0, %3 ], [ %60, %17 ]
  %20 = getelementptr [4 x i8], ptr %12, i64 %19, !dbg !264
  %21 = load <4 x float>, ptr %20, align 16, !dbg !264
  %22 = getelementptr [4 x i8], ptr %13, i64 %19, !dbg !264
  %23 = load <4 x float>, ptr %22, align 16, !dbg !264
  %24 = getelementptr [4 x i8], ptr %14, i64 %19, !dbg !264
  %25 = load <4 x float>, ptr %24, align 16, !dbg !264
  %26 = shufflevector <4 x float> %25, <4 x float> poison, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %27 = getelementptr [4 x i8], ptr %15, i64 %19, !dbg !264
  %28 = load <4 x float>, ptr %27, align 16, !dbg !264
  %29 = shufflevector <4 x float> %28, <4 x float> poison, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %30 = getelementptr [4 x i8], ptr %16, i64 %19, !dbg !264
  %31 = load <4 x float>, ptr %30, align 16, !dbg !264
  %32 = shufflevector <4 x float> %31, <4 x float> poison, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %33 = shufflevector <4 x float> %21, <4 x float> %23, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %34 = shufflevector <20 x float> %33, <20 x float> %26, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %35 = shufflevector <20 x float> %34, <20 x float> %29, <20 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 20, i32 21, i32 22, i32 23, i32 poison, i32 poison, i32 poison, i32 poison>
  %36 = shufflevector <20 x float> %35, <20 x float> %32, <5 x i32> <i32 0, i32 4, i32 8, i32 12, i32 20>
  %37 = shufflevector <20 x float> %35, <20 x float> %32, <5 x i32> <i32 1, i32 5, i32 9, i32 13, i32 21>
  %38 = shufflevector <20 x float> %35, <20 x float> %32, <5 x i32> <i32 2, i32 6, i32 10, i32 14, i32 22>
  %39 = shufflevector <20 x float> %35, <20 x float> %32, <5 x i32> <i32 3, i32 7, i32 11, i32 15, i32 23>
  %40 = getelementptr inbounds nuw [4 x i8], ptr %4, i64 %19
  %41 = load float, ptr %40, align 16
  %42 = insertelement <5 x float> poison, float %41, i64 0
  %43 = shufflevector <5 x float> %42, <5 x float> poison, <5 x i32> zeroinitializer
  %44 = tail call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %36, <5 x float> %43, <5 x float> %18)
  %45 = getelementptr inbounds nuw i8, ptr %40, i64 4
  %46 = load float, ptr %45, align 4
  %47 = insertelement <5 x float> poison, float %46, i64 0
  %48 = shufflevector <5 x float> %47, <5 x float> poison, <5 x i32> zeroinitializer
  %49 = tail call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %37, <5 x float> %48, <5 x float> %44)
  %50 = getelementptr inbounds nuw i8, ptr %40, i64 8
  %51 = load float, ptr %50, align 8
  %52 = insertelement <5 x float> poison, float %51, i64 0
  %53 = shufflevector <5 x float> %52, <5 x float> poison, <5 x i32> zeroinitializer
  %54 = tail call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %38, <5 x float> %53, <5 x float> %49)
  %55 = getelementptr inbounds nuw i8, ptr %40, i64 12
  %56 = load float, ptr %55, align 4
  %57 = insertelement <5 x float> poison, float %56, i64 0
  %58 = shufflevector <5 x float> %57, <5 x float> poison, <5 x i32> zeroinitializer
  %59 = tail call <5 x float> @llvm.fmuladd.v5f32(<5 x float> %39, <5 x float> %58, <5 x float> %54)
  %60 = add nuw nsw i64 %19, 4, !dbg !264
  %61 = icmp samesign ult i64 %19, 60, !dbg !264
  br i1 %61, label %17, label %62, !dbg !264

62:                                               ; preds = %17
  %63 = mul nuw nsw i64 %11, 5, !dbg !264
  %64 = getelementptr i8, ptr %9, i64 256, !dbg !263
  %65 = getelementptr [4 x i8], ptr @__constant_1x10xf32, i64 %63, !dbg !265
  %66 = load <5 x float>, ptr %65, align 4, !dbg !265
  %67 = fadd contract <5 x float> %59, %66, !dbg !266
  %68 = getelementptr [4 x i8], ptr %64, i64 %63, !dbg !266
  store <5 x float> %67, ptr %68, align 4, !dbg !266
  ret i32 0, !dbg !267
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: write, target_mem0: none, target_mem1: none)
define internal noundef i32 @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store(ptr noalias nonnull readnone align 16 captures(none) %0, ptr noalias noundef nonnull readonly align 16 captures(none) %1, ptr noalias nonnull readnone align 16 captures(none) %2) #0 !dbg !268 {
  %.elt21 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !269
  %.unpack22 = load ptr, ptr %.elt21, align 16, !dbg !269
  %4 = load ptr, ptr %.unpack22, align 8, !dbg !269
  %5 = getelementptr i8, ptr %4, i64 256, !dbg !269
  call void @llvm.assume(i1 true) [ "align"(ptr %5, i64 64) ], !dbg !269
  %6 = getelementptr i8, ptr %.unpack22, i64 8, !dbg !270
  %7 = load ptr, ptr %6, align 8, !dbg !270
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !270
  br label %8, !dbg !271

8:                                                ; preds = %3, %8
  %9 = phi <1 x float> [ splat (float 0xFFF8000000000000), %3 ], [ %17, %8 ]
  %10 = phi i1 [ true, %3 ], [ false, %8 ]
  %11 = phi i64 [ 0, %3 ], [ 4, %8 ]
  %12 = getelementptr [4 x i8], ptr %5, i64 %11, !dbg !271
  %13 = load <4 x float>, ptr %12, align 16, !dbg !271
  %14 = extractelement <1 x float> %9, i64 0, !dbg !271
  %15 = tail call float @llvm.vector.reduce.fmax.v4f32(<4 x float> %13), !dbg !272
  %16 = tail call float @llvm.maxnum.f32(float %15, float %14), !dbg !272
  %17 = insertelement <1 x float> poison, float %16, i64 0, !dbg !271
  br i1 %10, label %8, label %18, !dbg !271

18:                                               ; preds = %8
  %19 = getelementptr i8, ptr %4, i64 288, !dbg !271
  %20 = load <2 x float>, ptr %19, align 4, !dbg !271
  %21 = tail call float @llvm.vector.reduce.fmax.v2f32(<2 x float> %20), !dbg !272
  %22 = tail call float @llvm.maxnum.f32(float %21, float %16), !dbg !272
  %23 = insertelement <4 x float> poison, float %22, i64 0, !dbg !273
  %24 = shufflevector <4 x float> %23, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !273
  br label %25, !dbg !273

25:                                               ; preds = %18, %25
  %26 = phi <1 x float> [ zeroinitializer, %18 ], [ %55, %25 ]
  %27 = phi i1 [ true, %18 ], [ false, %25 ]
  %28 = phi i64 [ 0, %18 ], [ 4, %25 ]
  %29 = getelementptr [4 x i8], ptr %5, i64 %28, !dbg !273
  %30 = load <4 x float>, ptr %29, align 16, !dbg !273
  %31 = extractelement <1 x float> %26, i64 0, !dbg !273
  %32 = fsub contract <4 x float> %30, %24, !dbg !274
  %.inv32 = fcmp olt <4 x float> %32, splat (float 0xC055F33340000000), !dbg !275
  %33 = select <4 x i1> %.inv32, <4 x float> splat (float 0xC055F33340000000), <4 x float> %32, !dbg !275
  %.inv33 = fcmp ogt <4 x float> %33, splat (float 0x4056333340000000), !dbg !275
  %34 = select <4 x i1> %.inv33, <4 x float> splat (float 0x4056333340000000), <4 x float> %33, !dbg !275
  %35 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %34, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !275
  %36 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %35), !dbg !275
  %.inv34 = fcmp olt <4 x float> %36, splat (float -1.270000e+02), !dbg !275
  %37 = select <4 x i1> %.inv34, <4 x float> splat (float -1.270000e+02), <4 x float> %36, !dbg !275
  %.inv35 = fcmp ogt <4 x float> %37, splat (float 1.270000e+02), !dbg !275
  %38 = select <4 x i1> %.inv35, <4 x float> splat (float 1.270000e+02), <4 x float> %37, !dbg !275
  %39 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %38, <4 x float> splat (float 0xBFE6300000000000), <4 x float> %34), !dbg !275
  %40 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %38, <4 x float> splat (float 0x3F2BD01060000000), <4 x float> %39), !dbg !275
  %41 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %40, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !275
  %42 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %41, <4 x float> %40, <4 x float> splat (float 0x3F81112100000000)), !dbg !275
  %43 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %42, <4 x float> %40, <4 x float> splat (float 0x3FA5553820000000)), !dbg !275
  %44 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %43, <4 x float> %40, <4 x float> splat (float 0x3FC5555540000000)), !dbg !275
  %45 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %44, <4 x float> %40, <4 x float> splat (float 5.000000e-01)), !dbg !275
  %46 = fmul contract <4 x float> %40, %40, !dbg !275
  %47 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %45, <4 x float> %46, <4 x float> %40), !dbg !275
  %48 = fadd contract <4 x float> %47, splat (float 1.000000e+00), !dbg !275
  %49 = fptosi <4 x float> %38 to <4 x i32>, !dbg !275
  %50 = shl <4 x i32> %49, splat (i32 23), !dbg !275
  %51 = add <4 x i32> %50, splat (i32 1065353216), !dbg !275
  %52 = bitcast <4 x i32> %51 to <4 x float>, !dbg !275
  %53 = fmul contract <4 x float> %48, %52, !dbg !275
  %54 = tail call float @llvm.vector.reduce.fadd.v4f32(float %31, <4 x float> %53), !dbg !276
  %55 = insertelement <1 x float> poison, float %54, i64 0, !dbg !273
  br i1 %27, label %25, label %56, !dbg !273

56:                                               ; preds = %25
  %57 = insertelement <2 x float> poison, float %22, i64 0, !dbg !273
  %58 = shufflevector <2 x float> %57, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !273
  %59 = fsub contract <2 x float> %20, %58, !dbg !274
  %.inv = fcmp olt <2 x float> %59, splat (float 0xC055F33340000000), !dbg !275
  %60 = select <2 x i1> %.inv, <2 x float> splat (float 0xC055F33340000000), <2 x float> %59, !dbg !275
  %.inv25 = fcmp ogt <2 x float> %60, splat (float 0x4056333340000000), !dbg !275
  %61 = select <2 x i1> %.inv25, <2 x float> splat (float 0x4056333340000000), <2 x float> %60, !dbg !275
  %62 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %61, <2 x float> splat (float 0x3FF7154760000000), <2 x float> splat (float 5.000000e-01)), !dbg !275
  %63 = tail call <2 x float> @llvm.floor.v2f32(<2 x float> %62), !dbg !275
  %.inv26 = fcmp olt <2 x float> %63, splat (float -1.270000e+02), !dbg !275
  %64 = select <2 x i1> %.inv26, <2 x float> splat (float -1.270000e+02), <2 x float> %63, !dbg !275
  %.inv27 = fcmp ogt <2 x float> %64, splat (float 1.270000e+02), !dbg !275
  %65 = select <2 x i1> %.inv27, <2 x float> splat (float 1.270000e+02), <2 x float> %64, !dbg !275
  %66 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %65, <2 x float> splat (float 0xBFE6300000000000), <2 x float> %61), !dbg !275
  %67 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %65, <2 x float> splat (float 0x3F2BD01060000000), <2 x float> %66), !dbg !275
  %68 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %67, <2 x float> splat (float 0x3F2A0D2CE0000000), <2 x float> splat (float 0x3F56E879C0000000)), !dbg !275
  %69 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %68, <2 x float> %67, <2 x float> splat (float 0x3F81112100000000)), !dbg !275
  %70 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %69, <2 x float> %67, <2 x float> splat (float 0x3FA5553820000000)), !dbg !275
  %71 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %70, <2 x float> %67, <2 x float> splat (float 0x3FC5555540000000)), !dbg !275
  %72 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %71, <2 x float> %67, <2 x float> splat (float 5.000000e-01)), !dbg !275
  %73 = fmul contract <2 x float> %67, %67, !dbg !275
  %74 = tail call <2 x float> @llvm.fma.v2f32(<2 x float> %72, <2 x float> %73, <2 x float> %67), !dbg !275
  %75 = fadd contract <2 x float> %74, splat (float 1.000000e+00), !dbg !275
  %76 = fptosi <2 x float> %65 to <2 x i32>, !dbg !275
  %77 = shl <2 x i32> %76, splat (i32 23), !dbg !275
  %78 = add <2 x i32> %77, splat (i32 1065353216), !dbg !275
  %79 = bitcast <2 x i32> %78 to <2 x float>, !dbg !275
  %80 = fmul contract <2 x float> %75, %79, !dbg !275
  %81 = tail call float @llvm.vector.reduce.fadd.v2f32(float %54, <2 x float> %80), !dbg !276
  %82 = insertelement <4 x float> poison, float %81, i64 0, !dbg !277
  %83 = shufflevector <4 x float> %82, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !277
  br label %84, !dbg !277

84:                                               ; preds = %56, %84
  %85 = phi i1 [ true, %56 ], [ false, %84 ]
  %86 = phi i64 [ 0, %56 ], [ 4, %84 ]
  %87 = getelementptr [4 x i8], ptr %5, i64 %86, !dbg !277
  %88 = load <4 x float>, ptr %87, align 16, !dbg !277
  %89 = fsub contract <4 x float> %88, %24, !dbg !278
  %.inv28 = fcmp olt <4 x float> %89, splat (float 0xC055F33340000000), !dbg !279
  %90 = select <4 x i1> %.inv28, <4 x float> splat (float 0xC055F33340000000), <4 x float> %89, !dbg !279
  %.inv29 = fcmp ogt <4 x float> %90, splat (float 0x4056333340000000), !dbg !279
  %91 = select <4 x i1> %.inv29, <4 x float> splat (float 0x4056333340000000), <4 x float> %90, !dbg !279
  %92 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %91, <4 x float> splat (float 0x3FF7154760000000), <4 x float> splat (float 5.000000e-01)), !dbg !279
  %93 = tail call <4 x float> @llvm.floor.v4f32(<4 x float> %92), !dbg !279
  %.inv30 = fcmp olt <4 x float> %93, splat (float -1.270000e+02), !dbg !279
  %94 = select <4 x i1> %.inv30, <4 x float> splat (float -1.270000e+02), <4 x float> %93, !dbg !279
  %.inv31 = fcmp ogt <4 x float> %94, splat (float 1.270000e+02), !dbg !279
  %95 = select <4 x i1> %.inv31, <4 x float> splat (float 1.270000e+02), <4 x float> %94, !dbg !279
  %96 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %95, <4 x float> splat (float 0xBFE6300000000000), <4 x float> %91), !dbg !279
  %97 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %95, <4 x float> splat (float 0x3F2BD01060000000), <4 x float> %96), !dbg !279
  %98 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %97, <4 x float> splat (float 0x3F2A0D2CE0000000), <4 x float> splat (float 0x3F56E879C0000000)), !dbg !279
  %99 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %98, <4 x float> %97, <4 x float> splat (float 0x3F81112100000000)), !dbg !279
  %100 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %99, <4 x float> %97, <4 x float> splat (float 0x3FA5553820000000)), !dbg !279
  %101 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %100, <4 x float> %97, <4 x float> splat (float 0x3FC5555540000000)), !dbg !279
  %102 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %101, <4 x float> %97, <4 x float> splat (float 5.000000e-01)), !dbg !279
  %103 = fmul contract <4 x float> %97, %97, !dbg !279
  %104 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %102, <4 x float> %103, <4 x float> %97), !dbg !279
  %105 = fadd contract <4 x float> %104, splat (float 1.000000e+00), !dbg !279
  %106 = fptosi <4 x float> %95 to <4 x i32>, !dbg !279
  %107 = shl <4 x i32> %106, splat (i32 23), !dbg !279
  %108 = add <4 x i32> %107, splat (i32 1065353216), !dbg !279
  %109 = bitcast <4 x i32> %108 to <4 x float>, !dbg !279
  %110 = fmul contract <4 x float> %105, %109, !dbg !279
  %111 = fdiv <4 x float> %110, %83, !dbg !280
  %112 = getelementptr [4 x i8], ptr %7, i64 %86, !dbg !277
  store <4 x float> %111, ptr %112, align 16, !dbg !277
  br i1 %85, label %84, label %113, !dbg !277

113:                                              ; preds = %84
  %114 = insertelement <2 x float> poison, float %81, i64 0, !dbg !277
  %115 = shufflevector <2 x float> %114, <2 x float> poison, <2 x i32> zeroinitializer, !dbg !277
  %116 = fdiv <2 x float> %80, %115, !dbg !280
  %117 = getelementptr i8, ptr %7, i64 32, !dbg !277
  store <2 x float> %116, ptr %117, align 32, !dbg !277
  ret i32 0, !dbg !281
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <16 x float> @llvm.fmuladd.v16f32(<16 x float>, <16 x float>, <16 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v4f32(float, <4 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <5 x float> @llvm.fmuladd.v5f32(<5 x float>, <5 x float>, <5 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fmax.v2f32(<2 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.maxnum.f32(float, float) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.fma.v2f32(<2 x float>, <2 x float>, <2 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x float> @llvm.floor.v2f32(<2 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v2f32(float, <2 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.floor.v4f32(<4 x float>) #2

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>) #2

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
  store i16 %36, ptr %2, align 4, !tbaa !282
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !284
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
  store i16 %37, ptr %2, align 4, !tbaa !282
  %.0..0..0..0. = load float, ptr %2, align 4, !tbaa !284
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
  store volatile float %3, ptr %2, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !284
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
  store volatile float %5, ptr %3, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %3, align 4, !tbaa !284
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
  store volatile float %3, ptr %2, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..i.i = load volatile float, ptr %2, align 4, !tbaa !284
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
  store volatile float %16, ptr %3, align 4, !tbaa !284
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
  store volatile float %24, ptr %2, align 4, !tbaa !284
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
  br i1 %.not, label %21, label %8, !prof !286

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
  store volatile float 0x4600000000000000, ptr %3, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %3, align 4, !tbaa !284
  call void @llvm.lifetime.end.p0(ptr nonnull %3)
  %16 = fmul float %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i, 0x4600000000000000
  br label %39

17:                                               ; preds = %13
  %18 = fcmp olt float %0, 0xC059FE3680000000
  br i1 %18, label %19, label %21

19:                                               ; preds = %17
  call void @llvm.lifetime.start.p0(ptr nonnull %2)
  store volatile float 0x3A00000000000000, ptr %2, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i3 = load volatile float, ptr %2, align 4, !tbaa !284
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
  %29 = load i64, ptr %28, align 8, !tbaa !287
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
  store volatile float %16, ptr %3, align 4, !tbaa !284
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
  store volatile float %23, ptr %2, align 4, !tbaa !284
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
  br i1 %or.cond99, label %.critedge, label %76, !prof !289

.critedge:                                        ; preds = %2
  %12 = add i32 %.pre, -1
  %13 = icmp ult i32 %12, -16777217
  br i1 %13, label %30, label %14, !prof !286

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
  br i1 %33, label %49, label %34, !prof !286

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
  store volatile float %48, ptr %5, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..i = load volatile float, ptr %5, align 4, !tbaa !284
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
  %85 = load double, ptr %84, align 8, !tbaa !290
  %86 = getelementptr inbounds nuw i8, ptr %84, i64 8
  %87 = load double, ptr %86, align 8, !tbaa !293
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
  br i1 %104, label %105, label %115, !prof !294

105:                                              ; preds = %76
  %106 = fcmp ogt double %101, 0x405FFFFFFFD1D571
  br i1 %106, label %107, label %110

107:                                              ; preds = %105
  %.not.i.i = icmp eq i32 %.050, 0
  %108 = select i1 %.not.i.i, float 0x4600000000000000, float 0xC600000000000000
  call void @llvm.lifetime.start.p0(ptr nonnull %4)
  store volatile float %108, ptr %4, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i = load volatile float, ptr %4, align 4, !tbaa !284
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
  store volatile float %113, ptr %3, align 4, !tbaa !284
  %.0..0..0..0..0..0..0..0..0..0..0..0..0..0..i.i.i6 = load volatile float, ptr %3, align 4, !tbaa !284
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
  %122 = load i64, ptr %121, align 8, !tbaa !287
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
  store volatile float %9, ptr %2, align 4, !tbaa !284
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
!132 = !DILocation(line: 31, column: 10, scope: !121)
!133 = !DILocation(line: 35, column: 8, scope: !121)
!134 = distinct !DISubprogram(name: "infer_dispatch_2_slow_memcpy", linkageName: "infer_dispatch_2_slow_memcpy", scope: !5, file: !5, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!135 = !DILocation(line: 11, column: 8, scope: !134)
!136 = !DILocation(line: 12, column: 8, scope: !134)
!137 = !DILocation(line: 13, column: 8, scope: !134)
!138 = !DILocation(line: 14, column: 8, scope: !134)
!139 = !DILocation(line: 16, column: 8, scope: !134)
!140 = !DILocation(line: 20, column: 8, scope: !134)
!141 = distinct !DISubprogram(name: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_3_conv_16x32x32x16x3x3_f32", scope: !7, file: !7, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!142 = !DILocation(line: 21, column: 8, scope: !141)
!143 = !DILocation(line: 20, column: 8, scope: !141)
!144 = !DILocation(line: 14, column: 8, scope: !141)
!145 = !DILocation(line: 15, column: 8, scope: !141)
!146 = !DILocation(line: 16, column: 8, scope: !141)
!147 = !DILocation(line: 9, column: 8, scope: !141)
!148 = !DILocation(line: 27, column: 8, scope: !141)
!149 = !DILocation(line: 23, column: 10, scope: !141)
!150 = !DILocation(line: 24, column: 10, scope: !141)
!151 = !DILocation(line: 29, column: 10, scope: !141)
!152 = !DILocation(line: 31, column: 10, scope: !141)
!153 = !DILocation(line: 35, column: 8, scope: !141)
!154 = distinct !DISubprogram(name: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", linkageName: "infer_dispatch_4_conv_16x32x32x16x3x3_f32", scope: !9, file: !9, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!155 = !DILocation(line: 24, column: 8, scope: !154)
!156 = !DILocation(line: 23, column: 8, scope: !154)
!157 = !DILocation(line: 15, column: 8, scope: !154)
!158 = !DILocation(line: 16, column: 8, scope: !154)
!159 = !DILocation(line: 17, column: 8, scope: !154)
!160 = !DILocation(line: 18, column: 8, scope: !154)
!161 = !DILocation(line: 9, column: 8, scope: !154)
!162 = !DILocation(line: 30, column: 8, scope: !154)
!163 = !DILocation(line: 26, column: 10, scope: !154)
!164 = !DILocation(line: 27, column: 10, scope: !154)
!165 = !DILocation(line: 32, column: 10, scope: !154)
!166 = !DILocation(line: 33, column: 10, scope: !154)
!167 = !DILocation(line: 35, column: 10, scope: !154)
!168 = !DILocation(line: 39, column: 8, scope: !154)
!169 = distinct !DISubprogram(name: "infer_dispatch_5_slow_memcpy", linkageName: "infer_dispatch_5_slow_memcpy", scope: !11, file: !11, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!170 = !DILocation(line: 11, column: 8, scope: !169)
!171 = !DILocation(line: 12, column: 8, scope: !169)
!172 = !DILocation(line: 13, column: 8, scope: !169)
!173 = !DILocation(line: 14, column: 8, scope: !169)
!174 = !DILocation(line: 16, column: 8, scope: !169)
!175 = !DILocation(line: 20, column: 8, scope: !169)
!176 = distinct !DISubprogram(name: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", linkageName: "infer_dispatch_6_conv_32x16x16x16x3x3_f32", scope: !13, file: !13, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!177 = !DILocation(line: 21, column: 8, scope: !176)
!178 = !DILocation(line: 20, column: 8, scope: !176)
!179 = !DILocation(line: 14, column: 8, scope: !176)
!180 = !DILocation(line: 15, column: 8, scope: !176)
!181 = !DILocation(line: 16, column: 8, scope: !176)
!182 = !DILocation(line: 9, column: 8, scope: !176)
!183 = !DILocation(line: 27, column: 8, scope: !176)
!184 = !DILocation(line: 23, column: 10, scope: !176)
!185 = !DILocation(line: 24, column: 10, scope: !176)
!186 = !DILocation(line: 29, column: 10, scope: !176)
!187 = !DILocation(line: 31, column: 10, scope: !176)
!188 = !DILocation(line: 35, column: 8, scope: !176)
!189 = distinct !DISubprogram(name: "infer_dispatch_7_matmul_like_32x16x16x16_f32", linkageName: "infer_dispatch_7_matmul_like_32x16x16x16_f32", scope: !15, file: !15, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!190 = !DILocation(line: 13, column: 8, scope: !189)
!191 = !DILocation(line: 14, column: 8, scope: !189)
!192 = !DILocation(line: 15, column: 8, scope: !189)
!193 = !DILocation(line: 20, column: 8, scope: !189)
!194 = !DILocation(line: 23, column: 10, scope: !189)
!195 = !DILocation(line: 27, column: 8, scope: !189)
!196 = distinct !DISubprogram(name: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", linkageName: "infer_dispatch_8_conv_32x16x16x32x3x3_f32", scope: !17, file: !17, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!197 = !DILocation(line: 25, column: 8, scope: !196)
!198 = !DILocation(line: 24, column: 8, scope: !196)
!199 = !DILocation(line: 16, column: 8, scope: !196)
!200 = !DILocation(line: 17, column: 8, scope: !196)
!201 = !DILocation(line: 18, column: 8, scope: !196)
!202 = !DILocation(line: 19, column: 8, scope: !196)
!203 = !DILocation(line: 9, column: 8, scope: !196)
!204 = !DILocation(line: 31, column: 8, scope: !196)
!205 = !DILocation(line: 27, column: 10, scope: !196)
!206 = !DILocation(line: 28, column: 10, scope: !196)
!207 = !DILocation(line: 33, column: 10, scope: !196)
!208 = !DILocation(line: 34, column: 10, scope: !196)
!209 = !DILocation(line: 35, column: 10, scope: !196)
!210 = !DILocation(line: 37, column: 10, scope: !196)
!211 = !DILocation(line: 41, column: 8, scope: !196)
!212 = distinct !DISubprogram(name: "infer_dispatch_9_slow_memcpy", linkageName: "infer_dispatch_9_slow_memcpy", scope: !19, file: !19, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!213 = !DILocation(line: 11, column: 8, scope: !212)
!214 = !DILocation(line: 12, column: 8, scope: !212)
!215 = !DILocation(line: 13, column: 8, scope: !212)
!216 = !DILocation(line: 14, column: 8, scope: !212)
!217 = !DILocation(line: 16, column: 8, scope: !212)
!218 = !DILocation(line: 20, column: 8, scope: !212)
!219 = distinct !DISubprogram(name: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", linkageName: "infer_dispatch_10_conv_64x8x8x32x3x3_f32", scope: !21, file: !21, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!220 = !DILocation(line: 21, column: 8, scope: !219)
!221 = !DILocation(line: 20, column: 8, scope: !219)
!222 = !DILocation(line: 14, column: 8, scope: !219)
!223 = !DILocation(line: 15, column: 8, scope: !219)
!224 = !DILocation(line: 16, column: 8, scope: !219)
!225 = !DILocation(line: 9, column: 8, scope: !219)
!226 = !DILocation(line: 27, column: 8, scope: !219)
!227 = !DILocation(line: 23, column: 10, scope: !219)
!228 = !DILocation(line: 24, column: 10, scope: !219)
!229 = !DILocation(line: 29, column: 10, scope: !219)
!230 = !DILocation(line: 31, column: 10, scope: !219)
!231 = !DILocation(line: 35, column: 8, scope: !219)
!232 = distinct !DISubprogram(name: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", linkageName: "infer_dispatch_11_conv_64x8x8x64x3x3_f32", scope: !23, file: !23, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!233 = !DILocation(line: 13, column: 8, scope: !232)
!234 = !DILocation(line: 14, column: 8, scope: !232)
!235 = !DILocation(line: 15, column: 8, scope: !232)
!236 = !DILocation(line: 20, column: 8, scope: !232)
!237 = !DILocation(line: 9, column: 8, scope: !232)
!238 = !DILocation(line: 22, column: 10, scope: !232)
!239 = !DILocation(line: 23, column: 10, scope: !232)
!240 = !DILocation(line: 27, column: 8, scope: !232)
!241 = distinct !DISubprogram(name: "infer_dispatch_12_matmul_like_64x8x8x32_f32", linkageName: "infer_dispatch_12_matmul_like_64x8x8x32_f32", scope: !25, file: !25, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !24)
!242 = !DILocation(line: 13, column: 8, scope: !241)
!243 = !DILocation(line: 14, column: 8, scope: !241)
!244 = !DILocation(line: 15, column: 8, scope: !241)
!245 = !DILocation(line: 20, column: 8, scope: !241)
!246 = !DILocation(line: 23, column: 10, scope: !241)
!247 = !DILocation(line: 27, column: 8, scope: !241)
!248 = distinct !DISubprogram(name: "infer_dispatch_13_reduction_64x64_f32", linkageName: "infer_dispatch_13_reduction_64x64_f32", scope: !27, file: !27, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !26)
!249 = !DILocation(line: 16, column: 8, scope: !248)
!250 = !DILocation(line: 17, column: 8, scope: !248)
!251 = !DILocation(line: 18, column: 8, scope: !248)
!252 = !DILocation(line: 23, column: 8, scope: !248)
!253 = !DILocation(line: 25, column: 10, scope: !248)
!254 = !DILocation(line: 26, column: 10, scope: !248)
!255 = !DILocation(line: 27, column: 10, scope: !248)
!256 = !DILocation(line: 29, column: 10, scope: !248)
!257 = !DILocation(line: 30, column: 10, scope: !248)
!258 = !DILocation(line: 35, column: 10, scope: !248)
!259 = !DILocation(line: 39, column: 8, scope: !248)
!260 = distinct !DISubprogram(name: "infer_dispatch_14_matmul_1x10x64_f32", linkageName: "infer_dispatch_14_matmul_1x10x64_f32", scope: !29, file: !29, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !28)
!261 = !DILocation(line: 14, column: 8, scope: !260)
!262 = !DILocation(line: 15, column: 8, scope: !260)
!263 = !DILocation(line: 16, column: 8, scope: !260)
!264 = !DILocation(line: 21, column: 8, scope: !260)
!265 = !DILocation(line: 22, column: 8, scope: !260)
!266 = !DILocation(line: 24, column: 10, scope: !260)
!267 = !DILocation(line: 28, column: 8, scope: !260)
!268 = distinct !DISubprogram(name: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", linkageName: "infer_dispatch_15_softmax_10xf32_dispatch_tensor_store", scope: !31, file: !31, line: 1, type: !40, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !30)
!269 = !DILocation(line: 13, column: 8, scope: !268)
!270 = !DILocation(line: 14, column: 8, scope: !268)
!271 = !DILocation(line: 19, column: 8, scope: !268)
!272 = !DILocation(line: 21, column: 10, scope: !268)
!273 = !DILocation(line: 25, column: 8, scope: !268)
!274 = !DILocation(line: 27, column: 10, scope: !268)
!275 = !DILocation(line: 28, column: 10, scope: !268)
!276 = !DILocation(line: 29, column: 10, scope: !268)
!277 = !DILocation(line: 32, column: 8, scope: !268)
!278 = !DILocation(line: 34, column: 10, scope: !268)
!279 = !DILocation(line: 35, column: 10, scope: !268)
!280 = !DILocation(line: 36, column: 10, scope: !268)
!281 = !DILocation(line: 40, column: 8, scope: !268)
!282 = !{!283, !283, i64 0}
!283 = !{!"short", !37, i64 0}
!284 = !{!285, !285, i64 0}
!285 = !{!"float", !37, i64 0}
!286 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!287 = !{!288, !288, i64 0}
!288 = !{!"long", !37, i64 0}
!289 = !{!"branch_weights", i32 4001, i32 4000000}
!290 = !{!291, !292, i64 0}
!291 = !{!"", !292, i64 0, !292, i64 8}
!292 = !{!"double", !37, i64 0}
!293 = !{!291, !292, i64 8}
!294 = !{!"branch_weights", !"expected", i32 1, i32 2000}
