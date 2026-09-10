; ModuleID = 'smartcam_linked'
source_filename = "smartcam_linked"
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

@__constant_32xf32 = private constant [32 x float] [float 0x4006D21F00000000, float 0x401190FE40000000, float 0xBFEE3D1B20000000, float 0xBFF3735080000000, float 0x400FE28680000000, float 0x400474F480000000, float 0xC024D45080000000, float 0xC004579F00000000, float 0x400D6BA040000000, float 0x40071A4E00000000, float 0xC012CB00C0000000, float 0xBFD31E7A60000000, float 0xBFC9026020000000, float 0xBFF57F9EE0000000, float 0x401030B5E0000000, float 0x400EA951C0000000, float 0x3F9D0B3C00000000, float 0x4002755280000000, float 0xC01865E2E0000000, float 0xBFF4EF9700000000, float 0x4002E37640000000, float 0x4008BA91E0000000, float 0x40045754C0000000, float 0x3FDEED0380000000, float 0x4000F4FCE0000000, float 0x40129703C0000000, float 0x3FEC380B00000000, float 0x3FF296F140000000, float 0x3FB66D72A0000000, float 0x3FFE725DA0000000, float 0xBFDE02ED00000000, float 0x4013E234C0000000], align 64
@__constant_32xf32_0 = private constant [32 x float] [float 0x3FE532BE80000000, float 0x40137DD6C0000000, float 0xBFC8BC6880000000, float 0xBFC359E7C0000000, float 0x4008EB6480000000, float 0x4008563520000000, float 0x3FE04E46E0000000, float 0xBFCCCD2A80000000, float 0x400EE04180000000, float 0x3F64530000000000, float 0x3FC3C188C0000000, float 0xBFD7431CC0000000, float 0xBFDBEFA260000000, float 0xBFF0C33AE0000000, float 0x4002ED7E60000000, float 0x4004D38240000000, float 0xBFD01BD340000000, float 0x3FF66E63A0000000, float 0x400481F520000000, float 0xBFF5C0CD00000000, float 0x3FDDFFE5C0000000, float 0x400491CCE0000000, float 0x3FD458F7C0000000, float 0xBFF7270280000000, float 0x4009D58880000000, float 0x4007F985C0000000, float 0xBFB83B0900000000, float 0x401023F540000000, float 0xBFE0D5FC20000000, float 0x4001336120000000, float 0xBFE7594FC0000000, float 0xC012CCB500000000], align 64
@__constant_16xf32 = private constant [16 x float] [float 0xC00DF63500000000, float 0x4025132380000000, float 0x403135F3C0000000, float 0x4042A23860000000, float 0x402B2990C0000000, float 0x40006EA240000000, float 0x400CF877A0000000, float 0x40091517E0000000, float 0xC033A5FF00000000, float 0x4006C89AE0000000, float 0x4011866960000000, float 0x403F502BA0000000, float 0xC02C538780000000, float 0xC0265AC2A0000000, float 0x4019FFFB00000000, float 0xBFEC699140000000], align 64
@__constant_24xf32 = private constant [24 x float] [float 0x4020CC9720000000, float 0xC0200B31C0000000, float 0x402B951040000000, float 0xC016FCC640000000, float 0x3FF7FDAF40000000, float 0xBFF5A4FBE0000000, float 0xC0138E7D80000000, float 0x40051E0FC0000000, float 0xC0138D2FC0000000, float 0x3FC6780620000000, float 0x401704C300000000, float 0xC013126720000000, float 0x401A1026C0000000, float 0xC00F6DF960000000, float 0x40357B16E0000000, float 0xC016508080000000, float 0x401A2483A0000000, float 0xC0118A6840000000, float 0xBFD388B300000000, float 0x3FEB3DD920000000, float 0xC02427AB80000000, float 0xC022882BE0000000, float 0xBFF1CA2700000000, float 0x402920E460000000], align 64
@__constant_24xf32_0 = private constant [24 x float] [float 0x4040639500000000, float 0xC012651420000000, float 0x4021C23B80000000, float 0xC005DF6CC0000000, float 0x4003540600000000, float 0x3FEB5E2BE0000000, float 0x402FF49E60000000, float 0x403807E060000000, float 0xC032903820000000, float 0xC0416B5340000000, float 0x3FD82AF680000000, float 0x40062B68A0000000, float 0xC021B7BF20000000, float 0xBFF7C63DA0000000, float 0xC026CD92A0000000, float 0x40389EC680000000, float 0x4012536D20000000, float 0x402D9ECBE0000000, float 0x402827C720000000, float 0x4001ACC500000000, float 0xC011AAD0E0000000, float 0xC021D5CEA0000000, float 0xC01099E0E0000000, float 0xC0251EF2A0000000], align 64
@__constant_32xf32_1 = private constant [32 x float] [float 0xC018D37C00000000, float 0x4012A50FA0000000, float 0x400DD3CE00000000, float 0xC007294C60000000, float 0x40218152C0000000, float 0xBFE09B4040000000, float 0x4011563EA0000000, float 0xC02A82EA40000000, float 0xC03165DCA0000000, float 0xC0138AD6E0000000, float 0x400DFF6E00000000, float 0xC0248A5580000000, float 0x4011B33620000000, float 0xC0248DB940000000, float 0xC0057854C0000000, float 0x4002D206E0000000, float 0x3FFD41C100000000, float 0xC016B65540000000, float 0xC020AB30E0000000, float 0xC019247060000000, float 0xC00EB2E600000000, float 0xC035B70720000000, float 0xC02342DDE0000000, float 0x3FFEBC7960000000, float 0xBFDFFDC080000000, float 0xC010531560000000, float 0x40258AD280000000, float 0xC013898DC0000000, float 0xC009FF4660000000, float 0xC025EDC5C0000000, float 0xC0193A3EA0000000, float 0xBFC15BC880000000], align 64
@__constant_32xf32_2 = private constant [32 x float] [float 0x4014A89D80000000, float 0xBFE458CDA0000000, float 0x3FE721C9A0000000, float 0x401767F300000000, float 0x40216AE8A0000000, float 0xC006A7D640000000, float 0x3FFC1E9EE0000000, float 0x3FF122CB00000000, float 0x3FFA078380000000, float 0xC00CEF14A0000000, float 0x400B852C20000000, float 0x401945A9E0000000, float 0x400016A880000000, float 0x3FEB9A7A40000000, float 0x3FFBF52D00000000, float 0x401A013E20000000, float 0xC00A5C0D40000000, float 0x4029F21AA0000000, float 0x3FF3B46AE0000000, float 0x4006729B80000000, float 0xC000DC55E0000000, float 0xBFF33BA660000000, float 0x400A5A3BC0000000, float 0xC010BC33C0000000, float 0x400F33BB40000000, float 0xBFF738C860000000, float 0x40068D13A0000000, float 0x4009D0E020000000, float 0xC02A26B260000000, float 0xBFFC12FB40000000, float 0x3FB4D504E0000000, float 0x400F0E83C0000000], align 64
@__constant_32xf32_3 = private constant [32 x float] [float 0x3FFD294EC0000000, float 0x3FD020F4E0000000, float 0x400A3755A0000000, float 0xC00CED5C00000000, float 0x400004E800000000, float 0x3FD3CFF620000000, float 0xBFF8F517C0000000, float 0xBFF2A46880000000, float 0xBFF0DFD660000000, float 0x400DB5E9A0000000, float 0xC0064298E0000000, float 0x3FCFCD11A0000000, float 0xBFEACFDDE0000000, float 0xC001ED0D00000000, float 0xBFE89CDA60000000, float 0xBFC269DF60000000, float 0x40123CCE00000000, float 0x4003E7E6A0000000, float 0x4007D37BC0000000, float 0xC020717E60000000, float 0xBFCE14C400000000, float 0xBFFEC81680000000, float 0xC0203537E0000000, float 0x3FE4C7ECE0000000, float 0xC007F63980000000, float 0xC015A39A60000000, float 0x40053AC8E0000000, float 0xC00BBE2840000000, float 0xC0343506A0000000, float 0x4000D19120000000, float 0x3FC7CAD340000000, float 0x3FA62EF2A0000000], align 64
@__constant_64xf32 = private constant [64 x float] [float 0xC0265FCF00000000, float 0x3FF4807F40000000, float 0xC0130DCC60000000, float 0x4023DC01C0000000, float 0x3FE8761040000000, float 0xC01CF798C0000000, float 0x401EC55DE0000000, float 0x401463EEE0000000, float 0x400647ACE0000000, float 0x4025DEE280000000, float 0x4019233340000000, float 0x401D7DAB20000000, float 0xBFF6B54A80000000, float 0xC018E14BE0000000, float 0x3FF67012E0000000, float 0xC0097E5FA0000000, float 0x40019C8020000000, float 0x4001538100000000, float 0xC00A0FFD60000000, float 0x401AE83AC0000000, float 0x4038B0AAE0000000, float 0x402A27CD20000000, float 0x40171A8DE0000000, float 0x40288EE2C0000000, float 0x40172F4140000000, float 0xC01B4182C0000000, float 0xC0196990E0000000, float 0xC018A70EE0000000, float 0xBFE511CB20000000, float 0x40142FC280000000, float 0xC0022E50A0000000, float 0xC010FD66A0000000, float 0x4026C1FD80000000, float 0x4025C474E0000000, float 0xC01E589F80000000, float 0xBFE9B3EFE0000000, float 0x40055E5EC0000000, float 0x402B819A80000000, float 0xC00E2CEF40000000, float 0x4012BD7CE0000000, float 0x3FEE264960000000, float 0x3FE05147E0000000, float 0x4032518820000000, float 0xBFF58B3760000000, float 0xC026A86220000000, float 0xC0208060E0000000, float 0x40208FBB20000000, float 0xC01F4B3500000000, float 0x40069A1580000000, float 0x40012CD6C0000000, float 0xBFF5B48D20000000, float 0xC006376960000000, float 0x40193EDCA0000000, float 0xBFF321ECC0000000, float 0x402C7EAF60000000, float 0xBFF1D5FC20000000, float 0xC0022E45E0000000, float 0x3FCB94F5A0000000, float 0x4016BA9500000000, float 0x40240E5900000000, float 0x4019B8EFE0000000, float 0xBFE4C2B1A0000000, float 0x4023E9D280000000, float 0x40084948C0000000], align 64
@__constant_64xf32_0 = private constant [64 x float] [float 0x3FE9CAFB40000000, float 0xBFEC8530C0000000, float 0xBFD54F9BC0000000, float 0x3FE48F20A0000000, float 0x3FB815A520000000, float 0x3FB7177D60000000, float 0xBFE07185C0000000, float 0x3FE9002D40000000, float 0x3FDB1F7B40000000, float 0xBFE0E0EAE0000000, float 0xBFFBAB6D00000000, float 0x3FE3010FA0000000, float 0x3FB6038B00000000, float 0xBFED216280000000, float 0xBFEAEB4E20000000, float 0x4009584D40000000, float 0x3FDC20D800000000, float 0xBFF02BABC0000000, float 0x400977CA20000000, float 0xC001360D20000000, float 0x3FD94C8820000000, float 0xC003632CE0000000, float 0x3FFA4FED20000000, float 0xBFD490C420000000, float 0x3FDA549EC0000000, float 0xBFE834B680000000, float 0x3FC954A360000000, float 0xBFE71B0020000000, float 0x400ABF7C20000000, float 0x3FE57289A0000000, float 0xC0140C4EA0000000, float 0xC00EAA8E00000000, float 0x3FF1C8FDC0000000, float 0x3FCABA8540000000, float 0xBFF980BA00000000, float 0x40025B41A0000000, float 0xBFE9180420000000, float 0x3FCFBB1400000000, float 0x3FF2E360A0000000, float 0xC010701540000000, float 0x3FAAD19B80000000, float 0xC00907EC60000000, float 0x3FAAE073E0000000, float 0x3FF563E820000000, float 0x3FE3F0C840000000, float 0x3FB0A6F080000000, float 0xBFFD8F2BC0000000, float 0xBFB31D9C60000000, float 0xC00AB9C7C0000000, float 0xBFD35DC0E0000000, float 0xBFE770A920000000, float 0xBFF8814980000000, float 0xBFEE8F3480000000, float 0xBFF0650680000000, float 0x3FE491EAC0000000, float 0xBFE9D356C0000000, float 0x3FF6535BC0000000, float 0x3FD12F5D00000000, float 0xC000B4ED00000000, float 0x3FE6FE88A0000000, float 0x3FF5D29C60000000, float 0x400414F100000000, float 0xBFCB403A60000000, float 0x3FD93331A0000000], align 64
@__constant_64xf32_1 = private constant [64 x float] [float 0x3FF0F487A0000000, float 0x40171F76E0000000, float 0x3FF0238C40000000, float 0xBFBFC9D8A0000000, float 0xBFF0B36EE0000000, float 0xBFBC1B9020000000, float 0xBFDFCDD220000000, float 0x3FE9CFD640000000, float 0x3FF5239040000000, float 0xBFC923C8E0000000, float 0x400E3BF1E0000000, float 0xBFF81DEB60000000, float 0xC0011E6E80000000, float 0x3FEC6F6800000000, float 0xC004C97360000000, float 0xC018D89FE0000000, float 0xBFC4E679A0000000, float 0x3FB9BE6260000000, float 0x400AB8E280000000, float 0xBFCD4011C0000000, float 0xBFFCB4DC40000000, float 0x3FF9BA9E20000000, float 0xBFD0309740000000, float 0xBFD0460BE0000000, float 0x3FFD369CA0000000, float 0xBFFA4D3340000000, float 0x401016CDC0000000, float 0x4001AD6D40000000, float 0xBFE99E9B00000000, float 0x3FFB621240000000, float 0xC0040EED00000000, float 0xC0095CA180000000, float 0xBFDC7DAD60000000, float 0xBF92F5C960000000, float 0xC003573000000000, float 0x40038F86C0000000, float 0xBFF2709280000000, float 0xBFF6B3C9E0000000, float 0xBFDE78A3E0000000, float 0xC00B3CD9C0000000, float 0x400D72C960000000, float 0x40023A3600000000, float 0xBFFDB96BE0000000, float 0x3FE8520BC0000000, float 0x3FC4363080000000, float 0x3FF4E320A0000000, float 0x3FDBE2DFA0000000, float 0xBFCA921980000000, float 0xC016600960000000, float 0x3FE11435C0000000, float 0x3FDAA999C0000000, float 0xBFA9E44120000000, float 0xBFD5AD3380000000, float 0xBFEABF22E0000000, float 0x3FCE879400000000, float 0xBFFA3D6A40000000, float 0xBFFE357A80000000, float 0x3FFE256740000000, float 0x40005D0680000000, float 0x3FE759B600000000, float 0xC002BA6720000000, float 0x3FF621AB00000000, float 0xBFD9850640000000, float 0xBFFA7B1740000000], align 64
@__constant_64xf32_2 = private constant [64 x float] [float 0xBFAD434CC0000000, float 0xBFE2258BE0000000, float 0xBFE899DBE0000000, float 0x3FF1E13E60000000, float 0x3FE17A99C0000000, float 0xBFBE5FB900000000, float 0xC001697FE0000000, float 0xBFD1AEE260000000, float 0xC0114C4180000000, float 0xBFF0C74480000000, float 0xC00D870A20000000, float 0x4021090740000000, float 0x40086CB180000000, float 0xBFF8EFDDE0000000, float 0xC00849F080000000, float 0xC012E8CA20000000, float 0xBFF0607900000000, float 0xBFFEAAAA60000000, float 0x3FF47F8800000000, float 0x4009642DE0000000, float 0xBFE1A9C5C0000000, float 0xC00009AFA0000000, float 0xBFE21326A0000000, float 0x3FD4D8D020000000, float 0xBFE74EFE20000000, float 0x3FFB20D8C0000000, float 0xC00E7763A0000000, float 0x3FF3980F60000000, float 0xBFCB253D60000000, float 0xBFE88291A0000000, float 0x40074412E0000000, float 0xC013BE77E0000000, float 0xBFAD57A400000000, float 0xBFC74614E0000000, float 0x3FFA5EC3E0000000, float 0xC011979AA0000000, float 0x3FA8BF1C20000000, float 0xC00B9719E0000000, float 0x3FF1992700000000, float 0xC00F5FE6E0000000, float 0xBFC6C12E40000000, float 0xBFC8B558C0000000, float 0x3FEC5FB6E0000000, float 0x3FEEC469A0000000, float 0xBFD5E3CCA0000000, float 0x3FD2B344C0000000, float 0xBFDEF22C60000000, float 0x400394E3C0000000, float 0xBFF2CEF280000000, float 0xBFE9F80080000000, float 0xC0131551C0000000, float 0x3FE4235D60000000, float 0x3FF5AD51A0000000, float 0x4006BA78E0000000, float 0xBFC60C3E60000000, float 0x3FFA3A7420000000, float 0xC0057D3A60000000, float 0xC003F89500000000, float 0xBFDB4D7CE0000000, float 0x3FE8FB6900000000, float 0x3FEE9F96A0000000, float 0xC000B94600000000, float 0x3FBE85BAC0000000, float 0x4016F0C4E0000000], align 64
@__constant_1x3xf32 = private constant [1 x [3 x float]] [[3 x float] [float 0x3FAF2FED20000000, float 0xBF842C23E0000000, float 0xBFAA24D940000000]], align 64
@0 = private constant [16 x i8] c"smartcam_linked\00", align 1
@iree_hal_executable_library_query_v0_header = private constant %iree_hal_executable_library_header_t { i32 6, ptr @0, i32 0, i32 0 }
@iree_hal_executable_library_query_v0_funcs = private constant [40 x ptr] [ptr @infer_dispatch_0_elementwise_3x224x224_f32, ptr @infer_dispatch_1_conv_32x112x112x3x3x3_f32, ptr @infer_dispatch_2_conv_112x112x32x3x3_f32, ptr @infer_dispatch_3_matmul_like_16x12544x32_f32, ptr @infer_dispatch_4_matmul_like_96x112x112x16_f32, ptr @infer_dispatch_5_conv_56x56x96x3x3_f32, ptr @infer_dispatch_6_matmul_like_24x3136x96_f32, ptr @infer_dispatch_7_matmul_like_144x56x56x24_f32, ptr @infer_dispatch_8_conv_56x56x144x3x3_f32, ptr @infer_dispatch_9_matmul_like_24x3136x144_f32, ptr @infer_dispatch_10_matmul_like_144x56x56x24_f32, ptr @infer_dispatch_11_conv_28x28x144x3x3_f32, ptr @infer_dispatch_12_matmul_like_32x784x144_f32, ptr @infer_dispatch_13_matmul_like_192x28x28x32_f32, ptr @infer_dispatch_14_conv_28x28x192x3x3_f32, ptr @infer_dispatch_15_matmul_like_32x784x192_f32, ptr @infer_dispatch_18_matmul_like_32x784x192_f32, ptr @infer_dispatch_19_matmul_like_192x28x28x32_f32, ptr @infer_dispatch_20_conv_14x14x192x3x3_f32, ptr @infer_dispatch_21_matmul_like_64x196x192_f32, ptr @infer_dispatch_22_matmul_like_384x14x14x64_f32, ptr @infer_dispatch_23_conv_14x14x384x3x3_f32, ptr @infer_dispatch_24_matmul_like_64x196x384_f32, ptr @infer_dispatch_27_matmul_like_64x196x384_f32, ptr @infer_dispatch_30_matmul_like_64x196x384_f32, ptr @infer_dispatch_33_matmul_like_96x196x384_f32, ptr @infer_dispatch_34_matmul_like_576x14x14x96_f32, ptr @infer_dispatch_35_conv_14x14x576x3x3_f32, ptr @infer_dispatch_36_matmul_like_96x196x576_f32, ptr @infer_dispatch_40_matmul_like_576x14x14x96_f32, ptr @infer_dispatch_41_conv_7x7x576x3x3_f32, ptr @infer_dispatch_42_matmul_like_160x49x576_f32, ptr @infer_dispatch_43_matmul_like_960x7x7x160_f32, ptr @infer_dispatch_44_conv_7x7x960x3x3_f32, ptr @infer_dispatch_45_matmul_like_160x49x960_f32, ptr @infer_dispatch_51_matmul_like_320x49x960_f32, ptr @infer_dispatch_52_matmul_like_1280x49x320_f32, ptr @infer_dispatch_53_reduction_1280x49_f32, ptr @infer_dispatch_54_matmul_1x3x1280_f32, ptr @infer_dispatch_55_softmax_3xf32_dispatch_tensor_store]
@iree_hal_executable_library_query_v0_attrs = private constant [40 x %iree_hal_executable_dispatch_attrs_v0_t] [%iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 3, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 2, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 5, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 4, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 3, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }, %iree_hal_executable_dispatch_attrs_v0_t { i64 0, i16 0, i8 0, i8 2, i32 1, i32 1, i16 1, i16 0, i64 0, i64 0, i64 0, i64 0, i64 0 }]
@1 = private constant [43 x i8] c"infer_dispatch_0_elementwise_3x224x224_f32\00", align 1
@2 = private constant [43 x i8] c"infer_dispatch_1_conv_32x112x112x3x3x3_f32\00", align 1
@3 = private constant [41 x i8] c"infer_dispatch_2_conv_112x112x32x3x3_f32\00", align 1
@4 = private constant [45 x i8] c"infer_dispatch_3_matmul_like_16x12544x32_f32\00", align 1
@5 = private constant [47 x i8] c"infer_dispatch_4_matmul_like_96x112x112x16_f32\00", align 1
@6 = private constant [39 x i8] c"infer_dispatch_5_conv_56x56x96x3x3_f32\00", align 1
@7 = private constant [44 x i8] c"infer_dispatch_6_matmul_like_24x3136x96_f32\00", align 1
@8 = private constant [46 x i8] c"infer_dispatch_7_matmul_like_144x56x56x24_f32\00", align 1
@9 = private constant [40 x i8] c"infer_dispatch_8_conv_56x56x144x3x3_f32\00", align 1
@10 = private constant [45 x i8] c"infer_dispatch_9_matmul_like_24x3136x144_f32\00", align 1
@11 = private constant [47 x i8] c"infer_dispatch_10_matmul_like_144x56x56x24_f32\00", align 1
@12 = private constant [41 x i8] c"infer_dispatch_11_conv_28x28x144x3x3_f32\00", align 1
@13 = private constant [45 x i8] c"infer_dispatch_12_matmul_like_32x784x144_f32\00", align 1
@14 = private constant [47 x i8] c"infer_dispatch_13_matmul_like_192x28x28x32_f32\00", align 1
@15 = private constant [41 x i8] c"infer_dispatch_14_conv_28x28x192x3x3_f32\00", align 1
@16 = private constant [45 x i8] c"infer_dispatch_15_matmul_like_32x784x192_f32\00", align 1
@17 = private constant [45 x i8] c"infer_dispatch_18_matmul_like_32x784x192_f32\00", align 1
@18 = private constant [47 x i8] c"infer_dispatch_19_matmul_like_192x28x28x32_f32\00", align 1
@19 = private constant [41 x i8] c"infer_dispatch_20_conv_14x14x192x3x3_f32\00", align 1
@20 = private constant [45 x i8] c"infer_dispatch_21_matmul_like_64x196x192_f32\00", align 1
@21 = private constant [47 x i8] c"infer_dispatch_22_matmul_like_384x14x14x64_f32\00", align 1
@22 = private constant [41 x i8] c"infer_dispatch_23_conv_14x14x384x3x3_f32\00", align 1
@23 = private constant [45 x i8] c"infer_dispatch_24_matmul_like_64x196x384_f32\00", align 1
@24 = private constant [45 x i8] c"infer_dispatch_27_matmul_like_64x196x384_f32\00", align 1
@25 = private constant [45 x i8] c"infer_dispatch_30_matmul_like_64x196x384_f32\00", align 1
@26 = private constant [45 x i8] c"infer_dispatch_33_matmul_like_96x196x384_f32\00", align 1
@27 = private constant [47 x i8] c"infer_dispatch_34_matmul_like_576x14x14x96_f32\00", align 1
@28 = private constant [41 x i8] c"infer_dispatch_35_conv_14x14x576x3x3_f32\00", align 1
@29 = private constant [45 x i8] c"infer_dispatch_36_matmul_like_96x196x576_f32\00", align 1
@30 = private constant [47 x i8] c"infer_dispatch_40_matmul_like_576x14x14x96_f32\00", align 1
@31 = private constant [39 x i8] c"infer_dispatch_41_conv_7x7x576x3x3_f32\00", align 1
@32 = private constant [45 x i8] c"infer_dispatch_42_matmul_like_160x49x576_f32\00", align 1
@33 = private constant [46 x i8] c"infer_dispatch_43_matmul_like_960x7x7x160_f32\00", align 1
@34 = private constant [39 x i8] c"infer_dispatch_44_conv_7x7x960x3x3_f32\00", align 1
@35 = private constant [45 x i8] c"infer_dispatch_45_matmul_like_160x49x960_f32\00", align 1
@36 = private constant [45 x i8] c"infer_dispatch_51_matmul_like_320x49x960_f32\00", align 1
@37 = private constant [46 x i8] c"infer_dispatch_52_matmul_like_1280x49x320_f32\00", align 1
@38 = private constant [40 x i8] c"infer_dispatch_53_reduction_1280x49_f32\00", align 1
@39 = private constant [38 x i8] c"infer_dispatch_54_matmul_1x3x1280_f32\00", align 1
@40 = private constant [54 x i8] c"infer_dispatch_55_softmax_3xf32_dispatch_tensor_store\00", align 1
@iree_hal_executable_library_query_v0_names = private constant [40 x ptr] [ptr @1, ptr @2, ptr @3, ptr @4, ptr @5, ptr @6, ptr @7, ptr @8, ptr @9, ptr @10, ptr @11, ptr @12, ptr @13, ptr @14, ptr @15, ptr @16, ptr @17, ptr @18, ptr @19, ptr @20, ptr @21, ptr @22, ptr @23, ptr @24, ptr @25, ptr @26, ptr @27, ptr @28, ptr @29, ptr @30, ptr @31, ptr @32, ptr @33, ptr @34, ptr @35, ptr @36, ptr @37, ptr @38, ptr @39, ptr @40]
@41 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_0.mlir\00", align 1
@42 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_1.mlir\00", align 1
@43 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_2.mlir\00", align 1
@44 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_3.mlir\00", align 1
@45 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_4.mlir\00", align 1
@46 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_5.mlir\00", align 1
@47 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_6.mlir\00", align 1
@48 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_7.mlir\00", align 1
@49 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_8.mlir\00", align 1
@50 = private constant [45 x i8] c"dump/configured_module_infer_dispatch_9.mlir\00", align 1
@51 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_10.mlir\00", align 1
@52 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_11.mlir\00", align 1
@53 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_12.mlir\00", align 1
@54 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_13.mlir\00", align 1
@55 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_14.mlir\00", align 1
@56 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_15.mlir\00", align 1
@57 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_18.mlir\00", align 1
@58 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_19.mlir\00", align 1
@59 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_20.mlir\00", align 1
@60 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_21.mlir\00", align 1
@61 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_22.mlir\00", align 1
@62 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_23.mlir\00", align 1
@63 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_24.mlir\00", align 1
@64 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_27.mlir\00", align 1
@65 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_30.mlir\00", align 1
@66 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_33.mlir\00", align 1
@67 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_34.mlir\00", align 1
@68 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_35.mlir\00", align 1
@69 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_36.mlir\00", align 1
@70 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_40.mlir\00", align 1
@71 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_41.mlir\00", align 1
@72 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_42.mlir\00", align 1
@73 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_43.mlir\00", align 1
@74 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_44.mlir\00", align 1
@75 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_45.mlir\00", align 1
@76 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_51.mlir\00", align 1
@77 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_52.mlir\00", align 1
@78 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_53.mlir\00", align 1
@79 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_54.mlir\00", align 1
@80 = private constant [46 x i8] c"dump/configured_module_infer_dispatch_55.mlir\00", align 1
@iree_hal_executable_library_query_v0_source_locations = private constant [40 x %iree_hal_executable_source_location_v0_t] [%iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @41 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @42 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @43 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @44 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @45 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @46 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @47 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @48 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @49 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 44, ptr @50 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @51 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @52 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @53 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @54 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @55 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @56 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @57 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @58 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @59 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @60 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @61 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @62 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @63 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @64 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @65 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @66 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @67 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @68 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @69 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @70 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @71 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @72 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @73 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @74 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @75 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @76 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @77 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @78 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @79 }, %iree_hal_executable_source_location_v0_t { i32 3, i32 45, ptr @80 }]
@iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names = private constant [0 x ptr] zeroinitializer
@iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations = private constant [0 x %iree_hal_executable_source_location_v0_t] zeroinitializer
@iree_hal_executable_library_query_v0_stage_location_tables = private constant [40 x %iree_hal_executable_stage_location_table_v0_t] [%iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_0_elementwise_3x224x224_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_1_conv_32x112x112x3x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_2_conv_112x112x32x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_3_matmul_like_16x12544x32_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_4_matmul_like_96x112x112x16_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_5_conv_56x56x96x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_6_matmul_like_24x3136x96_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_7_matmul_like_144x56x56x24_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_8_conv_56x56x144x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_9_matmul_like_24x3136x144_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_10_matmul_like_144x56x56x24_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_11_conv_28x28x144x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_12_matmul_like_32x784x144_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_13_matmul_like_192x28x28x32_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_14_conv_28x28x192x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_15_matmul_like_32x784x192_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_18_matmul_like_32x784x192_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_19_matmul_like_192x28x28x32_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_20_conv_14x14x192x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_21_matmul_like_64x196x192_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_22_matmul_like_384x14x14x64_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_23_conv_14x14x384x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_24_matmul_like_64x196x384_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_27_matmul_like_64x196x384_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_30_matmul_like_64x196x384_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_33_matmul_like_96x196x384_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_34_matmul_like_576x14x14x96_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_35_conv_14x14x576x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_36_matmul_like_96x196x576_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_40_matmul_like_576x14x14x96_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_41_conv_7x7x576x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_42_matmul_like_160x49x576_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_43_matmul_like_960x7x7x160_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_44_conv_7x7x960x3x3_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_45_matmul_like_160x49x960_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_51_matmul_like_320x49x960_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_52_matmul_like_1280x49x320_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_53_reduction_1280x49_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_54_matmul_1x3x1280_f32_stage_source_locations }, %iree_hal_executable_stage_location_table_v0_t { i32 0, ptr @iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_names, ptr @iree_hal_executable_library_query_v0_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_stage_source_locations }]
@iree_hal_executable_library_query_v0 = private constant %iree_hal_executable_library_v0_t { ptr @iree_hal_executable_library_query_v0_header, %iree_hal_executable_import_table_v0_t zeroinitializer, %iree_hal_executable_export_table_v0_t { i32 40, ptr @iree_hal_executable_library_query_v0_funcs, ptr @iree_hal_executable_library_query_v0_attrs, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_names, ptr null, ptr null, ptr @iree_hal_executable_library_query_v0_source_locations, ptr @iree_hal_executable_library_query_v0_stage_location_tables }, %iree_hal_executable_constant_table_v0_t zeroinitializer, %iree_hal_executable_source_file_table_v0_t zeroinitializer }

define internal i32 @infer_dispatch_0_elementwise_3x224x224_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !81 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !157
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !157
  %6 = load ptr, ptr %5, align 8, !dbg !157
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !157
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !158
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !158
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !158
  %10 = load ptr, ptr %9, align 8, !dbg !158
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !158
  %11 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !159
  %12 = extractvalue %iree_hal_executable_workgroup_state_v0_t %11, 0, !dbg !159
  %13 = zext i32 %12 to i64, !dbg !159
  %14 = sdiv i64 %13, 4, !dbg !159
  %15 = mul i64 %14, 4, !dbg !159
  %16 = icmp ne i64 %13, %15, !dbg !159
  %17 = icmp slt i64 %13, 0, !dbg !159
  %18 = and i1 %16, %17, !dbg !159
  %19 = add i64 %14, -1, !dbg !159
  %20 = select i1 %18, i64 %19, i64 %14, !dbg !159
  %21 = srem i64 %13, 4, !dbg !159
  %22 = icmp slt i64 %21, 0, !dbg !159
  %23 = add nsw i64 %21, 4, !dbg !159
  %24 = select i1 %22, i64 %23, i64 %21, !dbg !159
  %25 = mul nsw i64 %20, 56, !dbg !159
  %26 = mul nsw i64 %24, 56, !dbg !159
  br label %27, !dbg !159

27:                                               ; preds = %56, %3
  %28 = phi i64 [ %57, %56 ], [ 0, %3 ], !dbg !159
  %29 = icmp slt i64 %28, 3, !dbg !159
  br i1 %29, label %30, label %58, !dbg !159

30:                                               ; preds = %54, %27
  %31 = phi i64 [ %55, %54 ], [ 0, %27 ], !dbg !159
  %32 = icmp slt i64 %31, 56, !dbg !159
  br i1 %32, label %33, label %56, !dbg !159

33:                                               ; preds = %30
  %34 = add i64 %31, %25, !dbg !159
  br label %35, !dbg !159

35:                                               ; preds = %38, %33
  %36 = phi i64 [ %53, %38 ], [ 0, %33 ], !dbg !159
  %37 = icmp slt i64 %36, 56, !dbg !159
  br i1 %37, label %38, label %54, !dbg !159

38:                                               ; preds = %35
  %39 = add i64 %36, %26, !dbg !159
  %40 = mul i64 %28, 50176, !dbg !159
  %41 = mul i64 %34, 224, !dbg !159
  %42 = add i64 %40, %41, !dbg !159
  %43 = add i64 %42, %39, !dbg !159
  %44 = getelementptr float, ptr %6, i64 %43, !dbg !159
  %45 = load <4 x float>, ptr %44, align 4, !dbg !159
  %46 = fmul contract <4 x float> %45, splat (float 2.000000e+00), !dbg !160
  %47 = fsub contract <4 x float> %46, splat (float 1.000000e+00), !dbg !161
  %48 = mul i64 %28, 50625, !dbg !159
  %49 = mul i64 %34, 225, !dbg !159
  %50 = add i64 %48, %49, !dbg !159
  %51 = add i64 %50, %39, !dbg !159
  %52 = getelementptr float, ptr %10, i64 %51, !dbg !159
  store <4 x float> %47, ptr %52, align 4, !dbg !159
  %53 = add i64 %36, 4, !dbg !159
  br label %35, !dbg !159

54:                                               ; preds = %35
  %55 = add i64 %31, 1, !dbg !159
  br label %30, !dbg !159

56:                                               ; preds = %30
  %57 = add i64 %28, 1, !dbg !159
  br label %27, !dbg !159

58:                                               ; preds = %27
  ret i32 0, !dbg !162
}

define internal i32 @infer_dispatch_1_conv_32x112x112x3x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !163 {
  %4 = alloca float, i64 4, align 64, !dbg !164
  %5 = alloca float, i64 4, align 64, !dbg !165
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !166
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !166
  %8 = load ptr, ptr %7, align 8, !dbg !166
  call void @llvm.assume(i1 true) [ "align"(ptr %8, i64 64) ], !dbg !166
  %9 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !167
  %10 = extractvalue %iree_hal_executable_dispatch_state_v0_t %9, 10, !dbg !167
  %11 = getelementptr ptr, ptr %10, i32 1, !dbg !167
  %12 = load ptr, ptr %11, align 8, !dbg !167
  %13 = getelementptr float, ptr %12, i64 2209312, !dbg !167
  call void @llvm.assume(i1 true) [ "align"(ptr %13, i64 64) ], !dbg !167
  %14 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !168
  %15 = extractvalue %iree_hal_executable_dispatch_state_v0_t %14, 10, !dbg !168
  %16 = getelementptr ptr, ptr %15, i32 2, !dbg !168
  %17 = load ptr, ptr %16, align 8, !dbg !168
  %18 = getelementptr float, ptr %17, i64 151888, !dbg !168
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !168
  %19 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !164
  %20 = extractvalue %iree_hal_executable_workgroup_state_v0_t %19, 0, !dbg !164
  %21 = zext i32 %20 to i64, !dbg !164
  %22 = sdiv i64 %21, 4, !dbg !164
  %23 = mul i64 %22, 4, !dbg !164
  %24 = icmp ne i64 %21, %23, !dbg !164
  %25 = icmp slt i64 %21, 0, !dbg !164
  %26 = and i1 %24, %25, !dbg !164
  %27 = add i64 %22, -1, !dbg !164
  %28 = select i1 %26, i64 %27, i64 %22, !dbg !164
  %29 = srem i64 %21, 4, !dbg !164
  %30 = icmp slt i64 %29, 0, !dbg !164
  %31 = add nsw i64 %29, 4, !dbg !164
  %32 = select i1 %30, i64 %31, i64 %29, !dbg !164
  %33 = mul nsw i64 %28, 28, !dbg !164
  %34 = mul nsw i64 %32, 28, !dbg !164
  %35 = getelementptr float, ptr %5, i64 0, !dbg !169
  store <4 x float> zeroinitializer, ptr %35, align 4, !dbg !169
  br label %36, !dbg !164

36:                                               ; preds = %131, %3
  %37 = phi i64 [ %132, %131 ], [ 0, %3 ], !dbg !164
  %38 = icmp slt i64 %37, 32, !dbg !164
  br i1 %38, label %39, label %133, !dbg !164

39:                                               ; preds = %36
  %40 = getelementptr float, ptr @__constant_32xf32, i64 %37, !dbg !170
  %41 = load <1 x float>, ptr %40, align 4, !dbg !170
  br label %42, !dbg !164

42:                                               ; preds = %129, %39
  %43 = phi i64 [ %130, %129 ], [ 0, %39 ], !dbg !164
  %44 = icmp slt i64 %43, 28, !dbg !164
  br i1 %44, label %45, label %131, !dbg !164

45:                                               ; preds = %108, %42
  %46 = phi i64 [ %128, %108 ], [ 0, %42 ], !dbg !164
  %47 = icmp slt i64 %46, 28, !dbg !164
  br i1 %47, label %48, label %129, !dbg !164

48:                                               ; preds = %45
  %49 = mul nsw i64 %46, 2, !dbg !164
  %50 = mul nsw i64 %32, 56, !dbg !164
  %51 = add i64 %49, %50, !dbg !164
  br label %52, !dbg !164

52:                                               ; preds = %55, %48
  %53 = phi i64 [ %60, %55 ], [ 0, %48 ], !dbg !164
  %54 = icmp slt i64 %53, 4, !dbg !164
  br i1 %54, label %55, label %61, !dbg !164

55:                                               ; preds = %52
  %56 = add nuw nsw i64 0, %53, !dbg !164
  %57 = getelementptr inbounds nuw float, ptr %5, i64 %56, !dbg !164
  %58 = load float, ptr %57, align 4, !dbg !164
  %59 = getelementptr inbounds nuw float, ptr %4, i64 %56, !dbg !164
  store float %58, ptr %59, align 4, !dbg !164
  %60 = add i64 %53, 1, !dbg !164
  br label %52, !dbg !164

61:                                               ; preds = %106, %52
  %62 = phi i64 [ %107, %106 ], [ 0, %52 ], !dbg !164
  %63 = icmp slt i64 %62, 3, !dbg !164
  br i1 %63, label %64, label %108, !dbg !164

64:                                               ; preds = %104, %61
  %65 = phi i64 [ %105, %104 ], [ 0, %61 ], !dbg !164
  %66 = icmp slt i64 %65, 3, !dbg !164
  br i1 %66, label %67, label %106, !dbg !164

67:                                               ; preds = %64
  %68 = mul nsw i64 %43, 2, !dbg !164
  %69 = mul nsw i64 %28, 56, !dbg !164
  %70 = add i64 %68, %69, !dbg !164
  %71 = add i64 %70, %65, !dbg !164
  br label %72, !dbg !164

72:                                               ; preds = %102, %67
  %73 = phi i64 [ %103, %102 ], [ 0, %67 ], !dbg !164
  %74 = icmp slt i64 %73, 4, !dbg !164
  br i1 %74, label %75, label %104, !dbg !164

75:                                               ; preds = %78, %72
  %76 = phi i64 [ %101, %78 ], [ 0, %72 ], !dbg !164
  %77 = icmp slt i64 %76, 3, !dbg !164
  br i1 %77, label %78, label %102, !dbg !164

78:                                               ; preds = %75
  %79 = mul nsw i64 %73, 2, !dbg !164
  %80 = add i64 %51, %79, !dbg !164
  %81 = add i64 %80, %76, !dbg !164
  %82 = mul nuw nsw i64 %62, 50625, !dbg !164
  %83 = mul nuw nsw i64 %71, 225, !dbg !164
  %84 = add nuw nsw i64 %82, %83, !dbg !164
  %85 = add nuw nsw i64 %84, %81, !dbg !164
  %86 = getelementptr inbounds nuw float, ptr %8, i64 %85, !dbg !164
  %87 = load float, ptr %86, align 4, !dbg !164
  %88 = mul nuw nsw i64 %37, 27, !dbg !164
  %89 = mul nuw nsw i64 %62, 9, !dbg !164
  %90 = add nuw nsw i64 %88, %89, !dbg !164
  %91 = mul nuw nsw i64 %65, 3, !dbg !164
  %92 = add nuw nsw i64 %90, %91, !dbg !164
  %93 = add nuw nsw i64 %92, %76, !dbg !164
  %94 = getelementptr inbounds nuw float, ptr %13, i64 %93, !dbg !164
  %95 = load float, ptr %94, align 4, !dbg !164
  %96 = add nuw nsw i64 0, %73, !dbg !164
  %97 = getelementptr inbounds nuw float, ptr %4, i64 %96, !dbg !164
  %98 = load float, ptr %97, align 4, !dbg !164
  %99 = fmul contract float %87, %95, !dbg !171
  %100 = fadd contract float %98, %99, !dbg !172
  store float %100, ptr %97, align 4, !dbg !164
  %101 = add i64 %76, 1, !dbg !164
  br label %75, !dbg !164

102:                                              ; preds = %75
  %103 = add i64 %73, 1, !dbg !164
  br label %72, !dbg !164

104:                                              ; preds = %72
  %105 = add i64 %65, 1, !dbg !164
  br label %64, !dbg !164

106:                                              ; preds = %64
  %107 = add i64 %62, 1, !dbg !164
  br label %61, !dbg !164

108:                                              ; preds = %61
  %109 = getelementptr float, ptr %4, i64 0, !dbg !170
  %110 = load <4 x float>, ptr %109, align 4, !dbg !170
  %111 = extractelement <1 x float> %41, i64 0, !dbg !173
  %112 = insertelement <4 x float> poison, float %111, i32 0, !dbg !173
  %113 = shufflevector <4 x float> %112, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !173
  %114 = fadd contract <4 x float> %110, %113, !dbg !173
  %115 = fcmp ult <4 x float> %114, zeroinitializer, !dbg !174
  %116 = select <4 x i1> %115, <4 x float> zeroinitializer, <4 x float> %114, !dbg !175
  %117 = fcmp ugt <4 x float> %116, splat (float 6.000000e+00), !dbg !176
  %118 = select <4 x i1> %117, <4 x float> splat (float 6.000000e+00), <4 x float> %116, !dbg !177
  %119 = add i64 %33, %43, !dbg !164
  %120 = add i64 %119, 1, !dbg !164
  %121 = add i64 %34, %46, !dbg !164
  %122 = add i64 %121, 1, !dbg !164
  %123 = mul i64 %37, 12996, !dbg !164
  %124 = mul i64 %120, 114, !dbg !164
  %125 = add i64 %123, %124, !dbg !164
  %126 = add i64 %125, %122, !dbg !164
  %127 = getelementptr float, ptr %18, i64 %126, !dbg !164
  store <4 x float> %118, ptr %127, align 4, !dbg !164
  %128 = add i64 %46, 4, !dbg !164
  br label %45, !dbg !164

129:                                              ; preds = %45
  %130 = add i64 %43, 1, !dbg !164
  br label %42, !dbg !164

131:                                              ; preds = %42
  %132 = add i64 %37, 1, !dbg !164
  br label %36, !dbg !164

133:                                              ; preds = %36
  ret i32 0, !dbg !178
}

define internal i32 @infer_dispatch_2_conv_112x112x32x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !179 {
  %4 = alloca float, i64 4, align 64, !dbg !180
  %5 = alloca float, i64 4, align 64, !dbg !181
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !182
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !182
  %8 = load ptr, ptr %7, align 8, !dbg !182
  %9 = getelementptr float, ptr %8, i64 151888, !dbg !182
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !182
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !183
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !183
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !183
  %13 = load ptr, ptr %12, align 8, !dbg !183
  %14 = getelementptr float, ptr %13, i64 2188608, !dbg !183
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !183
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !184
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !184
  %17 = getelementptr ptr, ptr %16, i32 2, !dbg !184
  %18 = load ptr, ptr %17, align 8, !dbg !184
  %19 = getelementptr float, ptr %18, i64 567760, !dbg !184
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !184
  %20 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !180
  %21 = extractvalue %iree_hal_executable_workgroup_state_v0_t %20, 0, !dbg !180
  %22 = zext i32 %21 to i64, !dbg !180
  %23 = sdiv i64 %22, 4, !dbg !180
  %24 = mul i64 %23, 4, !dbg !180
  %25 = icmp ne i64 %22, %24, !dbg !180
  %26 = icmp slt i64 %22, 0, !dbg !180
  %27 = and i1 %25, %26, !dbg !180
  %28 = add i64 %23, -1, !dbg !180
  %29 = select i1 %27, i64 %28, i64 %23, !dbg !180
  %30 = srem i64 %22, 4, !dbg !180
  %31 = icmp slt i64 %30, 0, !dbg !180
  %32 = add nsw i64 %30, 4, !dbg !180
  %33 = select i1 %31, i64 %32, i64 %30, !dbg !180
  %34 = mul nsw i64 %29, 28, !dbg !180
  %35 = mul nsw i64 %33, 28, !dbg !180
  %36 = getelementptr float, ptr %5, i64 0, !dbg !185
  store <4 x float> zeroinitializer, ptr %36, align 4, !dbg !185
  br label %37, !dbg !180

37:                                               ; preds = %116, %3
  %38 = phi i64 [ %117, %116 ], [ 0, %3 ], !dbg !180
  %39 = icmp slt i64 %38, 28, !dbg !180
  br i1 %39, label %40, label %118, !dbg !180

40:                                               ; preds = %114, %37
  %41 = phi i64 [ %115, %114 ], [ 0, %37 ], !dbg !180
  %42 = icmp slt i64 %41, 28, !dbg !180
  br i1 %42, label %43, label %116, !dbg !180

43:                                               ; preds = %40
  %44 = add i64 %41, %35, !dbg !180
  br label %45, !dbg !180

45:                                               ; preds = %94, %43
  %46 = phi i64 [ %113, %94 ], [ 0, %43 ], !dbg !180
  %47 = icmp slt i64 %46, 32, !dbg !180
  br i1 %47, label %48, label %114, !dbg !180

48:                                               ; preds = %51, %45
  %49 = phi i64 [ %56, %51 ], [ 0, %45 ], !dbg !180
  %50 = icmp slt i64 %49, 4, !dbg !180
  br i1 %50, label %51, label %57, !dbg !180

51:                                               ; preds = %48
  %52 = add nuw nsw i64 0, %49, !dbg !180
  %53 = getelementptr inbounds nuw float, ptr %5, i64 %52, !dbg !180
  %54 = load float, ptr %53, align 4, !dbg !180
  %55 = getelementptr inbounds nuw float, ptr %4, i64 %52, !dbg !180
  store float %54, ptr %55, align 4, !dbg !180
  %56 = add i64 %49, 1, !dbg !180
  br label %48, !dbg !180

57:                                               ; preds = %92, %48
  %58 = phi i64 [ %93, %92 ], [ 0, %48 ], !dbg !180
  %59 = icmp slt i64 %58, 3, !dbg !180
  br i1 %59, label %60, label %94, !dbg !180

60:                                               ; preds = %57
  %61 = add i64 %58, %38, !dbg !180
  %62 = add i64 %61, %34, !dbg !180
  br label %63, !dbg !180

63:                                               ; preds = %90, %60
  %64 = phi i64 [ %91, %90 ], [ 0, %60 ], !dbg !180
  %65 = icmp slt i64 %64, 4, !dbg !180
  br i1 %65, label %66, label %92, !dbg !180

66:                                               ; preds = %69, %63
  %67 = phi i64 [ %89, %69 ], [ 0, %63 ], !dbg !180
  %68 = icmp slt i64 %67, 3, !dbg !180
  br i1 %68, label %69, label %90, !dbg !180

69:                                               ; preds = %66
  %70 = add i64 %44, %64, !dbg !180
  %71 = add i64 %70, %67, !dbg !180
  %72 = mul nuw nsw i64 %46, 12996, !dbg !180
  %73 = mul nuw nsw i64 %62, 114, !dbg !180
  %74 = add nuw nsw i64 %72, %73, !dbg !180
  %75 = add nuw nsw i64 %74, %71, !dbg !180
  %76 = getelementptr inbounds nuw float, ptr %9, i64 %75, !dbg !180
  %77 = load float, ptr %76, align 4, !dbg !180
  %78 = mul nuw nsw i64 %46, 9, !dbg !180
  %79 = mul nuw nsw i64 %58, 3, !dbg !180
  %80 = add nuw nsw i64 %78, %79, !dbg !180
  %81 = add nuw nsw i64 %80, %67, !dbg !180
  %82 = getelementptr inbounds nuw float, ptr %14, i64 %81, !dbg !180
  %83 = load float, ptr %82, align 4, !dbg !180
  %84 = add nuw nsw i64 0, %64, !dbg !180
  %85 = getelementptr inbounds nuw float, ptr %4, i64 %84, !dbg !180
  %86 = load float, ptr %85, align 4, !dbg !180
  %87 = fmul contract float %77, %83, !dbg !186
  %88 = fadd contract float %86, %87, !dbg !187
  store float %88, ptr %85, align 4, !dbg !180
  %89 = add i64 %67, 1, !dbg !180
  br label %66, !dbg !180

90:                                               ; preds = %66
  %91 = add i64 %64, 1, !dbg !180
  br label %63, !dbg !180

92:                                               ; preds = %63
  %93 = add i64 %58, 1, !dbg !180
  br label %57, !dbg !180

94:                                               ; preds = %57
  %95 = getelementptr float, ptr %4, i64 0, !dbg !188
  %96 = load <4 x float>, ptr %95, align 4, !dbg !188
  %97 = getelementptr float, ptr @__constant_32xf32_0, i64 %46, !dbg !188
  %98 = load <1 x float>, ptr %97, align 4, !dbg !188
  %99 = extractelement <1 x float> %98, i64 0, !dbg !189
  %100 = insertelement <4 x float> poison, float %99, i32 0, !dbg !189
  %101 = shufflevector <4 x float> %100, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !189
  %102 = fadd contract <4 x float> %96, %101, !dbg !189
  %103 = fcmp ult <4 x float> %102, zeroinitializer, !dbg !190
  %104 = select <4 x i1> %103, <4 x float> zeroinitializer, <4 x float> %102, !dbg !191
  %105 = fcmp ugt <4 x float> %104, splat (float 6.000000e+00), !dbg !192
  %106 = select <4 x i1> %105, <4 x float> splat (float 6.000000e+00), <4 x float> %104, !dbg !193
  %107 = add i64 %34, %38, !dbg !180
  %108 = mul i64 %46, 12544, !dbg !180
  %109 = mul i64 %107, 112, !dbg !180
  %110 = add i64 %108, %109, !dbg !180
  %111 = add i64 %110, %44, !dbg !180
  %112 = getelementptr float, ptr %19, i64 %111, !dbg !180
  store <4 x float> %106, ptr %112, align 4, !dbg !180
  %113 = add i64 %46, 1, !dbg !180
  br label %45, !dbg !180

114:                                              ; preds = %45
  %115 = add i64 %41, 4, !dbg !180
  br label %40, !dbg !180

116:                                              ; preds = %40
  %117 = add i64 %38, 1, !dbg !180
  br label %37, !dbg !180

118:                                              ; preds = %37
  ret i32 0, !dbg !194
}

define internal i32 @infer_dispatch_3_matmul_like_16x12544x32_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !195 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !196
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !196
  %6 = load ptr, ptr %5, align 8, !dbg !196
  %7 = getelementptr float, ptr %6, i64 567760, !dbg !196
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !196
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !197
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !197
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !197
  %11 = load ptr, ptr %10, align 8, !dbg !197
  %12 = getelementptr float, ptr %11, i64 2124160, !dbg !197
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !197
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !198
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !198
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !198
  %16 = load ptr, ptr %15, align 8, !dbg !198
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !198
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !199
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !199
  %19 = zext i32 %18 to i64, !dbg !199
  %20 = mul nsw i64 %19, 64, !dbg !199
  br label %21, !dbg !199

21:                                               ; preds = %86, %3
  %22 = phi i64 [ %87, %86 ], [ 0, %3 ], !dbg !199
  %23 = icmp slt i64 %22, 16, !dbg !199
  br i1 %23, label %24, label %88, !dbg !199

24:                                               ; preds = %21
  %25 = getelementptr float, ptr @__constant_16xf32, i64 %22, !dbg !200
  %26 = load <1 x float>, ptr %25, align 4, !dbg !200
  br label %27, !dbg !199

27:                                               ; preds = %78, %24
  %28 = phi i64 [ %85, %78 ], [ 0, %24 ], !dbg !199
  %29 = icmp slt i64 %28, 64, !dbg !199
  br i1 %29, label %30, label %86, !dbg !199

30:                                               ; preds = %27
  %31 = add i64 %28, %20, !dbg !199
  br label %32, !dbg !199

32:                                               ; preds = %36, %30
  %33 = phi i64 [ %77, %36 ], [ 0, %30 ], !dbg !199
  %34 = phi <1 x float> [ %76, %36 ], [ zeroinitializer, %30 ], !dbg !199
  %35 = icmp slt i64 %33, 32, !dbg !199
  br i1 %35, label %36, label %78, !dbg !199

36:                                               ; preds = %32
  %37 = mul i64 %33, 12544, !dbg !199
  %38 = add i64 %37, %31, !dbg !199
  %39 = getelementptr float, ptr %7, i64 %38, !dbg !199
  %40 = load <1 x float>, ptr %39, align 4, !dbg !199
  %41 = add i64 %33, 1, !dbg !199
  %42 = mul i64 %41, 12544, !dbg !199
  %43 = add i64 %42, %31, !dbg !199
  %44 = getelementptr float, ptr %7, i64 %43, !dbg !199
  %45 = load <1 x float>, ptr %44, align 4, !dbg !199
  %46 = add i64 %33, 2, !dbg !199
  %47 = mul i64 %46, 12544, !dbg !199
  %48 = add i64 %47, %31, !dbg !199
  %49 = getelementptr float, ptr %7, i64 %48, !dbg !199
  %50 = load <1 x float>, ptr %49, align 4, !dbg !199
  %51 = add i64 %33, 3, !dbg !199
  %52 = mul i64 %51, 12544, !dbg !199
  %53 = add i64 %52, %31, !dbg !199
  %54 = getelementptr float, ptr %7, i64 %53, !dbg !199
  %55 = load <1 x float>, ptr %54, align 4, !dbg !199
  %56 = mul nuw nsw i64 %22, 32, !dbg !201
  %57 = add nuw nsw i64 %56, %33, !dbg !201
  %58 = getelementptr inbounds nuw float, ptr %12, i64 %57, !dbg !201
  %59 = load float, ptr %58, align 4, !dbg !201
  %60 = insertelement <1 x float> poison, float %59, i32 0, !dbg !201
  %61 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %40, <1 x float> %60, <1 x float> %34), !dbg !201
  %62 = add nuw nsw i64 %56, %41, !dbg !201
  %63 = getelementptr inbounds nuw float, ptr %12, i64 %62, !dbg !201
  %64 = load float, ptr %63, align 4, !dbg !201
  %65 = insertelement <1 x float> poison, float %64, i32 0, !dbg !201
  %66 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %45, <1 x float> %65, <1 x float> %61), !dbg !201
  %67 = add nuw nsw i64 %56, %46, !dbg !201
  %68 = getelementptr inbounds nuw float, ptr %12, i64 %67, !dbg !201
  %69 = load float, ptr %68, align 4, !dbg !201
  %70 = insertelement <1 x float> poison, float %69, i32 0, !dbg !201
  %71 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %50, <1 x float> %70, <1 x float> %66), !dbg !201
  %72 = add nuw nsw i64 %56, %51, !dbg !201
  %73 = getelementptr inbounds nuw float, ptr %12, i64 %72, !dbg !201
  %74 = load float, ptr %73, align 4, !dbg !201
  %75 = insertelement <1 x float> poison, float %74, i32 0, !dbg !201
  %76 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %55, <1 x float> %75, <1 x float> %71), !dbg !201
  %77 = add i64 %33, 4, !dbg !199
  br label %32, !dbg !199

78:                                               ; preds = %32
  %79 = extractelement <1 x float> %34, i64 0, !dbg !202
  %80 = extractelement <1 x float> %26, i64 0, !dbg !202
  %81 = fadd contract float %79, %80, !dbg !202
  %82 = mul nuw nsw i64 %22, 12544, !dbg !199
  %83 = add nuw nsw i64 %82, %31, !dbg !199
  %84 = getelementptr inbounds nuw float, ptr %16, i64 %83, !dbg !199
  store float %81, ptr %84, align 4, !dbg !199
  %85 = add i64 %28, 1, !dbg !199
  br label %27, !dbg !199

86:                                               ; preds = %27
  %87 = add i64 %22, 1, !dbg !199
  br label %21, !dbg !199

88:                                               ; preds = %21
  ret i32 0, !dbg !203
}

define internal i32 @infer_dispatch_4_matmul_like_96x112x112x16_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !204 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !205
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !205
  %6 = load ptr, ptr %5, align 8, !dbg !205
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !205
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !206
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !206
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !206
  %10 = load ptr, ptr %9, align 8, !dbg !206
  %11 = getelementptr float, ptr %10, i64 2122624, !dbg !206
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !206
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !207
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !207
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !207
  %15 = load ptr, ptr %14, align 8, !dbg !207
  %16 = getelementptr float, ptr %15, i64 2207840, !dbg !207
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !207
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !208
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !208
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !208
  %20 = load ptr, ptr %19, align 8, !dbg !208
  %21 = getelementptr float, ptr %20, i64 969168, !dbg !208
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !208
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !209
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !209
  %24 = zext i32 %23 to i64, !dbg !209
  %25 = sdiv i64 %24, 2, !dbg !209
  %26 = mul i64 %25, 2, !dbg !209
  %27 = icmp ne i64 %24, %26, !dbg !209
  %28 = icmp slt i64 %24, 0, !dbg !209
  %29 = and i1 %27, %28, !dbg !209
  %30 = add i64 %25, -1, !dbg !209
  %31 = select i1 %29, i64 %30, i64 %25, !dbg !209
  %32 = srem i64 %24, 2, !dbg !209
  %33 = icmp slt i64 %32, 0, !dbg !209
  %34 = add nsw i64 %32, 2, !dbg !209
  %35 = select i1 %33, i64 %34, i64 %32, !dbg !209
  %36 = mul nsw i64 %31, 16, !dbg !209
  %37 = mul nsw i64 %35, 56, !dbg !209
  br label %38, !dbg !209

38:                                               ; preds = %120, %3
  %39 = phi i64 [ %121, %120 ], [ 0, %3 ], !dbg !209
  %40 = icmp slt i64 %39, 96, !dbg !209
  br i1 %40, label %41, label %122, !dbg !209

41:                                               ; preds = %38
  %42 = getelementptr float, ptr %16, i64 %39, !dbg !210
  %43 = load <1 x float>, ptr %42, align 4, !dbg !210
  br label %44, !dbg !209

44:                                               ; preds = %118, %41
  %45 = phi i64 [ %119, %118 ], [ 0, %41 ], !dbg !209
  %46 = icmp slt i64 %45, 16, !dbg !209
  br i1 %46, label %47, label %120, !dbg !209

47:                                               ; preds = %104, %44
  %48 = phi i64 [ %117, %104 ], [ 0, %44 ], !dbg !209
  %49 = icmp slt i64 %48, 56, !dbg !209
  br i1 %49, label %50, label %118, !dbg !209

50:                                               ; preds = %47
  %51 = add i64 %48, %37, !dbg !209
  br label %52, !dbg !209

52:                                               ; preds = %56, %50
  %53 = phi i64 [ %103, %56 ], [ 0, %50 ], !dbg !209
  %54 = phi <1 x float> [ %102, %56 ], [ zeroinitializer, %50 ], !dbg !209
  %55 = icmp slt i64 %53, 16, !dbg !209
  br i1 %55, label %56, label %104, !dbg !209

56:                                               ; preds = %52
  %57 = add i64 %45, %36, !dbg !209
  %58 = mul i64 %53, 12544, !dbg !209
  %59 = mul i64 %57, 112, !dbg !209
  %60 = add i64 %58, %59, !dbg !209
  %61 = add i64 %60, %51, !dbg !209
  %62 = getelementptr float, ptr %6, i64 %61, !dbg !209
  %63 = load <1 x float>, ptr %62, align 4, !dbg !209
  %64 = add i64 %53, 1, !dbg !209
  %65 = mul i64 %64, 12544, !dbg !209
  %66 = add i64 %65, %59, !dbg !209
  %67 = add i64 %66, %51, !dbg !209
  %68 = getelementptr float, ptr %6, i64 %67, !dbg !209
  %69 = load <1 x float>, ptr %68, align 4, !dbg !209
  %70 = add i64 %53, 2, !dbg !209
  %71 = mul i64 %70, 12544, !dbg !209
  %72 = add i64 %71, %59, !dbg !209
  %73 = add i64 %72, %51, !dbg !209
  %74 = getelementptr float, ptr %6, i64 %73, !dbg !209
  %75 = load <1 x float>, ptr %74, align 4, !dbg !209
  %76 = add i64 %53, 3, !dbg !209
  %77 = mul i64 %76, 12544, !dbg !209
  %78 = add i64 %77, %59, !dbg !209
  %79 = add i64 %78, %51, !dbg !209
  %80 = getelementptr float, ptr %6, i64 %79, !dbg !209
  %81 = load <1 x float>, ptr %80, align 4, !dbg !209
  %82 = mul nuw nsw i64 %39, 16, !dbg !211
  %83 = add nuw nsw i64 %82, %53, !dbg !211
  %84 = getelementptr inbounds nuw float, ptr %11, i64 %83, !dbg !211
  %85 = load float, ptr %84, align 4, !dbg !211
  %86 = insertelement <1 x float> poison, float %85, i32 0, !dbg !211
  %87 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %86, <1 x float> %54), !dbg !211
  %88 = add nuw nsw i64 %82, %64, !dbg !211
  %89 = getelementptr inbounds nuw float, ptr %11, i64 %88, !dbg !211
  %90 = load float, ptr %89, align 4, !dbg !211
  %91 = insertelement <1 x float> poison, float %90, i32 0, !dbg !211
  %92 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %69, <1 x float> %91, <1 x float> %87), !dbg !211
  %93 = add nuw nsw i64 %82, %70, !dbg !211
  %94 = getelementptr inbounds nuw float, ptr %11, i64 %93, !dbg !211
  %95 = load float, ptr %94, align 4, !dbg !211
  %96 = insertelement <1 x float> poison, float %95, i32 0, !dbg !211
  %97 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %75, <1 x float> %96, <1 x float> %92), !dbg !211
  %98 = add nuw nsw i64 %82, %76, !dbg !211
  %99 = getelementptr inbounds nuw float, ptr %11, i64 %98, !dbg !211
  %100 = load float, ptr %99, align 4, !dbg !211
  %101 = insertelement <1 x float> poison, float %100, i32 0, !dbg !211
  %102 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %81, <1 x float> %101, <1 x float> %97), !dbg !211
  %103 = add i64 %53, 4, !dbg !209
  br label %52, !dbg !209

104:                                              ; preds = %52
  %105 = fadd contract <1 x float> %54, %43, !dbg !212
  %106 = fcmp ult <1 x float> %105, zeroinitializer, !dbg !213
  %107 = select <1 x i1> %106, <1 x float> zeroinitializer, <1 x float> %105, !dbg !214
  %108 = fcmp ugt <1 x float> %107, splat (float 6.000000e+00), !dbg !215
  %109 = select <1 x i1> %108, <1 x float> splat (float 6.000000e+00), <1 x float> %107, !dbg !216
  %110 = extractelement <1 x float> %109, i64 0, !dbg !209
  %111 = add i64 %36, %45, !dbg !209
  %112 = mul nuw nsw i64 %39, 12769, !dbg !209
  %113 = mul nuw nsw i64 %111, 113, !dbg !209
  %114 = add nuw nsw i64 %112, %113, !dbg !209
  %115 = add nuw nsw i64 %114, %51, !dbg !209
  %116 = getelementptr inbounds nuw float, ptr %21, i64 %115, !dbg !209
  store float %110, ptr %116, align 4, !dbg !209
  %117 = add i64 %48, 1, !dbg !209
  br label %47, !dbg !209

118:                                              ; preds = %47
  %119 = add i64 %45, 1, !dbg !209
  br label %44, !dbg !209

120:                                              ; preds = %44
  %121 = add i64 %39, 1, !dbg !209
  br label %38, !dbg !209

122:                                              ; preds = %38
  ret i32 0, !dbg !217
}

define internal i32 @infer_dispatch_5_conv_56x56x96x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !218 {
  %4 = alloca float, i64 4, align 64, !dbg !219
  %5 = alloca float, i64 4, align 64, !dbg !220
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !221
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !221
  %8 = load ptr, ptr %7, align 8, !dbg !221
  %9 = getelementptr float, ptr %8, i64 969168, !dbg !221
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !221
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !222
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !222
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !222
  %13 = load ptr, ptr %12, align 8, !dbg !222
  %14 = getelementptr float, ptr %13, i64 2187744, !dbg !222
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !222
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !223
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !223
  %17 = getelementptr ptr, ptr %16, i32 1, !dbg !223
  %18 = load ptr, ptr %17, align 8, !dbg !223
  %19 = getelementptr float, ptr %18, i64 2207936, !dbg !223
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !223
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !224
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !224
  %22 = getelementptr ptr, ptr %21, i32 2, !dbg !224
  %23 = load ptr, ptr %22, align 8, !dbg !224
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !224
  %24 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !219
  %25 = extractvalue %iree_hal_executable_workgroup_state_v0_t %24, 0, !dbg !219
  %26 = zext i32 %25 to i64, !dbg !219
  %27 = sdiv i64 %26, 6, !dbg !219
  %28 = mul i64 %27, 6, !dbg !219
  %29 = icmp ne i64 %26, %28, !dbg !219
  %30 = icmp slt i64 %26, 0, !dbg !219
  %31 = and i1 %29, %30, !dbg !219
  %32 = add i64 %27, -1, !dbg !219
  %33 = select i1 %31, i64 %32, i64 %27, !dbg !219
  %34 = srem i64 %26, 6, !dbg !219
  %35 = icmp slt i64 %34, 0, !dbg !219
  %36 = add nsw i64 %34, 6, !dbg !219
  %37 = select i1 %35, i64 %36, i64 %34, !dbg !219
  %38 = sdiv i64 %37, 3, !dbg !219
  %39 = srem i64 %26, 3, !dbg !219
  %40 = icmp slt i64 %39, 0, !dbg !219
  %41 = add nsw i64 %39, 3, !dbg !219
  %42 = select i1 %40, i64 %41, i64 %39, !dbg !219
  %43 = mul nsw i64 %33, 28, !dbg !219
  %44 = mul nsw i64 %38, 28, !dbg !219
  %45 = mul nsw i64 %42, 32, !dbg !219
  %46 = getelementptr float, ptr %5, i64 0, !dbg !225
  store <4 x float> zeroinitializer, ptr %46, align 4, !dbg !225
  br label %47, !dbg !219

47:                                               ; preds = %134, %3
  %48 = phi i64 [ %135, %134 ], [ 0, %3 ], !dbg !219
  %49 = icmp slt i64 %48, 28, !dbg !219
  br i1 %49, label %50, label %136, !dbg !219

50:                                               ; preds = %132, %47
  %51 = phi i64 [ %133, %132 ], [ 0, %47 ], !dbg !219
  %52 = icmp slt i64 %51, 28, !dbg !219
  br i1 %52, label %53, label %134, !dbg !219

53:                                               ; preds = %50
  %54 = mul nsw i64 %51, 2, !dbg !219
  %55 = mul nsw i64 %38, 56, !dbg !219
  %56 = add i64 %54, %55, !dbg !219
  br label %57, !dbg !219

57:                                               ; preds = %111, %53
  %58 = phi i64 [ %131, %111 ], [ 0, %53 ], !dbg !219
  %59 = icmp slt i64 %58, 32, !dbg !219
  br i1 %59, label %60, label %132, !dbg !219

60:                                               ; preds = %57
  %61 = add i64 %58, %45, !dbg !219
  br label %62, !dbg !219

62:                                               ; preds = %65, %60
  %63 = phi i64 [ %70, %65 ], [ 0, %60 ], !dbg !219
  %64 = icmp slt i64 %63, 4, !dbg !219
  br i1 %64, label %65, label %71, !dbg !219

65:                                               ; preds = %62
  %66 = add nuw nsw i64 0, %63, !dbg !219
  %67 = getelementptr inbounds nuw float, ptr %5, i64 %66, !dbg !219
  %68 = load float, ptr %67, align 4, !dbg !219
  %69 = getelementptr inbounds nuw float, ptr %4, i64 %66, !dbg !219
  store float %68, ptr %69, align 4, !dbg !219
  %70 = add i64 %63, 1, !dbg !219
  br label %62, !dbg !219

71:                                               ; preds = %109, %62
  %72 = phi i64 [ %110, %109 ], [ 0, %62 ], !dbg !219
  %73 = icmp slt i64 %72, 3, !dbg !219
  br i1 %73, label %74, label %111, !dbg !219

74:                                               ; preds = %71
  %75 = mul nsw i64 %48, 2, !dbg !219
  %76 = mul nsw i64 %33, 56, !dbg !219
  %77 = add i64 %75, %76, !dbg !219
  %78 = add i64 %77, %72, !dbg !219
  br label %79, !dbg !219

79:                                               ; preds = %107, %74
  %80 = phi i64 [ %108, %107 ], [ 0, %74 ], !dbg !219
  %81 = icmp slt i64 %80, 4, !dbg !219
  br i1 %81, label %82, label %109, !dbg !219

82:                                               ; preds = %85, %79
  %83 = phi i64 [ %106, %85 ], [ 0, %79 ], !dbg !219
  %84 = icmp slt i64 %83, 3, !dbg !219
  br i1 %84, label %85, label %107, !dbg !219

85:                                               ; preds = %82
  %86 = mul nsw i64 %80, 2, !dbg !219
  %87 = add i64 %56, %86, !dbg !219
  %88 = add i64 %87, %83, !dbg !219
  %89 = mul nuw nsw i64 %61, 12769, !dbg !219
  %90 = mul nuw nsw i64 %78, 113, !dbg !219
  %91 = add nuw nsw i64 %89, %90, !dbg !219
  %92 = add nuw nsw i64 %91, %88, !dbg !219
  %93 = getelementptr inbounds nuw float, ptr %9, i64 %92, !dbg !219
  %94 = load float, ptr %93, align 4, !dbg !219
  %95 = mul nuw nsw i64 %61, 9, !dbg !219
  %96 = mul nuw nsw i64 %72, 3, !dbg !219
  %97 = add nuw nsw i64 %95, %96, !dbg !219
  %98 = add nuw nsw i64 %97, %83, !dbg !219
  %99 = getelementptr inbounds nuw float, ptr %14, i64 %98, !dbg !219
  %100 = load float, ptr %99, align 4, !dbg !219
  %101 = add nuw nsw i64 0, %80, !dbg !219
  %102 = getelementptr inbounds nuw float, ptr %4, i64 %101, !dbg !219
  %103 = load float, ptr %102, align 4, !dbg !219
  %104 = fmul contract float %94, %100, !dbg !226
  %105 = fadd contract float %103, %104, !dbg !227
  store float %105, ptr %102, align 4, !dbg !219
  %106 = add i64 %83, 1, !dbg !219
  br label %82, !dbg !219

107:                                              ; preds = %82
  %108 = add i64 %80, 1, !dbg !219
  br label %79, !dbg !219

109:                                              ; preds = %79
  %110 = add i64 %72, 1, !dbg !219
  br label %71, !dbg !219

111:                                              ; preds = %71
  %112 = getelementptr float, ptr %4, i64 0, !dbg !228
  %113 = load <4 x float>, ptr %112, align 4, !dbg !228
  %114 = getelementptr float, ptr %19, i64 %61, !dbg !228
  %115 = load <1 x float>, ptr %114, align 4, !dbg !228
  %116 = extractelement <1 x float> %115, i64 0, !dbg !229
  %117 = insertelement <4 x float> poison, float %116, i32 0, !dbg !229
  %118 = shufflevector <4 x float> %117, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !229
  %119 = fadd contract <4 x float> %113, %118, !dbg !229
  %120 = fcmp ult <4 x float> %119, zeroinitializer, !dbg !230
  %121 = select <4 x i1> %120, <4 x float> zeroinitializer, <4 x float> %119, !dbg !231
  %122 = fcmp ugt <4 x float> %121, splat (float 6.000000e+00), !dbg !232
  %123 = select <4 x i1> %122, <4 x float> splat (float 6.000000e+00), <4 x float> %121, !dbg !233
  %124 = add i64 %43, %48, !dbg !219
  %125 = add i64 %44, %51, !dbg !219
  %126 = mul i64 %61, 3136, !dbg !219
  %127 = mul i64 %124, 56, !dbg !219
  %128 = add i64 %126, %127, !dbg !219
  %129 = add i64 %128, %125, !dbg !219
  %130 = getelementptr float, ptr %23, i64 %129, !dbg !219
  store <4 x float> %123, ptr %130, align 4, !dbg !219
  %131 = add i64 %58, 1, !dbg !219
  br label %57, !dbg !219

132:                                              ; preds = %57
  %133 = add i64 %51, 4, !dbg !219
  br label %50, !dbg !219

134:                                              ; preds = %50
  %135 = add i64 %48, 1, !dbg !219
  br label %47, !dbg !219

136:                                              ; preds = %47
  ret i32 0, !dbg !234
}

define internal i32 @infer_dispatch_6_matmul_like_24x3136x96_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !235 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !236
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !236
  %6 = load ptr, ptr %5, align 8, !dbg !236
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !236
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !237
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !237
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !237
  %10 = load ptr, ptr %9, align 8, !dbg !237
  %11 = getelementptr float, ptr %10, i64 2120320, !dbg !237
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !237
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !238
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !238
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !238
  %15 = load ptr, ptr %14, align 8, !dbg !238
  %16 = getelementptr float, ptr %15, i64 301056, !dbg !238
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !238
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !239
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !239
  %19 = zext i32 %18 to i64, !dbg !239
  %20 = sdiv i64 %19, 49, !dbg !239
  %21 = mul i64 %20, 49, !dbg !239
  %22 = icmp ne i64 %19, %21, !dbg !239
  %23 = icmp slt i64 %19, 0, !dbg !239
  %24 = and i1 %22, %23, !dbg !239
  %25 = add i64 %20, -1, !dbg !239
  %26 = select i1 %24, i64 %25, i64 %20, !dbg !239
  %27 = srem i64 %19, 49, !dbg !239
  %28 = icmp slt i64 %27, 0, !dbg !239
  %29 = add nsw i64 %27, 49, !dbg !239
  %30 = select i1 %28, i64 %29, i64 %27, !dbg !239
  %31 = mul nsw i64 %26, 8, !dbg !239
  %32 = mul nsw i64 %30, 64, !dbg !239
  br label %33, !dbg !239

33:                                               ; preds = %99, %3
  %34 = phi i64 [ %100, %99 ], [ 0, %3 ], !dbg !239
  %35 = icmp slt i64 %34, 8, !dbg !239
  br i1 %35, label %36, label %101, !dbg !239

36:                                               ; preds = %33
  %37 = add i64 %34, %31, !dbg !239
  %38 = getelementptr float, ptr @__constant_24xf32, i64 %37, !dbg !240
  %39 = load <1 x float>, ptr %38, align 4, !dbg !240
  br label %40, !dbg !239

40:                                               ; preds = %91, %36
  %41 = phi i64 [ %98, %91 ], [ 0, %36 ], !dbg !239
  %42 = icmp slt i64 %41, 64, !dbg !239
  br i1 %42, label %43, label %99, !dbg !239

43:                                               ; preds = %40
  %44 = add i64 %41, %32, !dbg !239
  br label %45, !dbg !239

45:                                               ; preds = %49, %43
  %46 = phi i64 [ %90, %49 ], [ 0, %43 ], !dbg !239
  %47 = phi <1 x float> [ %89, %49 ], [ zeroinitializer, %43 ], !dbg !239
  %48 = icmp slt i64 %46, 96, !dbg !239
  br i1 %48, label %49, label %91, !dbg !239

49:                                               ; preds = %45
  %50 = mul i64 %46, 3136, !dbg !239
  %51 = add i64 %50, %44, !dbg !239
  %52 = getelementptr float, ptr %6, i64 %51, !dbg !239
  %53 = load <1 x float>, ptr %52, align 4, !dbg !239
  %54 = add i64 %46, 1, !dbg !239
  %55 = mul i64 %54, 3136, !dbg !239
  %56 = add i64 %55, %44, !dbg !239
  %57 = getelementptr float, ptr %6, i64 %56, !dbg !239
  %58 = load <1 x float>, ptr %57, align 4, !dbg !239
  %59 = add i64 %46, 2, !dbg !239
  %60 = mul i64 %59, 3136, !dbg !239
  %61 = add i64 %60, %44, !dbg !239
  %62 = getelementptr float, ptr %6, i64 %61, !dbg !239
  %63 = load <1 x float>, ptr %62, align 4, !dbg !239
  %64 = add i64 %46, 3, !dbg !239
  %65 = mul i64 %64, 3136, !dbg !239
  %66 = add i64 %65, %44, !dbg !239
  %67 = getelementptr float, ptr %6, i64 %66, !dbg !239
  %68 = load <1 x float>, ptr %67, align 4, !dbg !239
  %69 = mul nuw nsw i64 %37, 96, !dbg !241
  %70 = add nuw nsw i64 %69, %46, !dbg !241
  %71 = getelementptr inbounds nuw float, ptr %11, i64 %70, !dbg !241
  %72 = load float, ptr %71, align 4, !dbg !241
  %73 = insertelement <1 x float> poison, float %72, i32 0, !dbg !241
  %74 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %53, <1 x float> %73, <1 x float> %47), !dbg !241
  %75 = add nuw nsw i64 %69, %54, !dbg !241
  %76 = getelementptr inbounds nuw float, ptr %11, i64 %75, !dbg !241
  %77 = load float, ptr %76, align 4, !dbg !241
  %78 = insertelement <1 x float> poison, float %77, i32 0, !dbg !241
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %58, <1 x float> %78, <1 x float> %74), !dbg !241
  %80 = add nuw nsw i64 %69, %59, !dbg !241
  %81 = getelementptr inbounds nuw float, ptr %11, i64 %80, !dbg !241
  %82 = load float, ptr %81, align 4, !dbg !241
  %83 = insertelement <1 x float> poison, float %82, i32 0, !dbg !241
  %84 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %83, <1 x float> %79), !dbg !241
  %85 = add nuw nsw i64 %69, %64, !dbg !241
  %86 = getelementptr inbounds nuw float, ptr %11, i64 %85, !dbg !241
  %87 = load float, ptr %86, align 4, !dbg !241
  %88 = insertelement <1 x float> poison, float %87, i32 0, !dbg !241
  %89 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %88, <1 x float> %84), !dbg !241
  %90 = add i64 %46, 4, !dbg !239
  br label %45, !dbg !239

91:                                               ; preds = %45
  %92 = extractelement <1 x float> %47, i64 0, !dbg !242
  %93 = extractelement <1 x float> %39, i64 0, !dbg !242
  %94 = fadd contract float %92, %93, !dbg !242
  %95 = mul nuw nsw i64 %37, 3136, !dbg !239
  %96 = add nuw nsw i64 %95, %44, !dbg !239
  %97 = getelementptr inbounds nuw float, ptr %16, i64 %96, !dbg !239
  store float %94, ptr %97, align 4, !dbg !239
  %98 = add i64 %41, 1, !dbg !239
  br label %40, !dbg !239

99:                                               ; preds = %40
  %100 = add i64 %34, 1, !dbg !239
  br label %33, !dbg !239

101:                                              ; preds = %33
  ret i32 0, !dbg !243
}

define internal i32 @infer_dispatch_7_matmul_like_144x56x56x24_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !244 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !245
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !245
  %6 = load ptr, ptr %5, align 8, !dbg !245
  %7 = getelementptr float, ptr %6, i64 301056, !dbg !245
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !245
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !246
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !246
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !246
  %11 = load ptr, ptr %10, align 8, !dbg !246
  %12 = getelementptr float, ptr %11, i64 2116864, !dbg !246
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !246
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !247
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !247
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !247
  %16 = load ptr, ptr %15, align 8, !dbg !247
  %17 = getelementptr float, ptr %16, i64 2196480, !dbg !247
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !247
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !248
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !248
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !248
  %21 = load ptr, ptr %20, align 8, !dbg !248
  %22 = getelementptr float, ptr %21, i64 376320, !dbg !248
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !248
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !249
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !249
  %25 = zext i32 %24 to i64, !dbg !249
  %26 = sdiv i64 %25, 7, !dbg !249
  %27 = mul i64 %26, 7, !dbg !249
  %28 = icmp ne i64 %25, %27, !dbg !249
  %29 = icmp slt i64 %25, 0, !dbg !249
  %30 = and i1 %28, %29, !dbg !249
  %31 = add i64 %26, -1, !dbg !249
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !249
  %33 = srem i64 %25, 7, !dbg !249
  %34 = icmp slt i64 %33, 0, !dbg !249
  %35 = add nsw i64 %33, 7, !dbg !249
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !249
  %37 = mul nsw i64 %32, 16, !dbg !249
  %38 = mul nsw i64 %36, 8, !dbg !249
  br label %39, !dbg !249

39:                                               ; preds = %121, %3
  %40 = phi i64 [ %122, %121 ], [ 0, %3 ], !dbg !249
  %41 = icmp slt i64 %40, 16, !dbg !249
  br i1 %41, label %42, label %123, !dbg !249

42:                                               ; preds = %39
  %43 = add i64 %40, %37, !dbg !249
  %44 = getelementptr float, ptr %17, i64 %43, !dbg !250
  %45 = load <1 x float>, ptr %44, align 4, !dbg !250
  br label %46, !dbg !249

46:                                               ; preds = %119, %42
  %47 = phi i64 [ %120, %119 ], [ 0, %42 ], !dbg !249
  %48 = icmp slt i64 %47, 8, !dbg !249
  br i1 %48, label %49, label %121, !dbg !249

49:                                               ; preds = %104, %46
  %50 = phi i64 [ %113, %104 ], [ 0, %46 ], !dbg !249
  %51 = icmp slt i64 %50, 56, !dbg !249
  br i1 %51, label %52, label %119, !dbg !249

52:                                               ; preds = %56, %49
  %53 = phi i64 [ %103, %56 ], [ 0, %49 ], !dbg !249
  %54 = phi <1 x float> [ %102, %56 ], [ zeroinitializer, %49 ], !dbg !249
  %55 = icmp slt i64 %53, 24, !dbg !249
  br i1 %55, label %56, label %104, !dbg !249

56:                                               ; preds = %52
  %57 = add i64 %47, %38, !dbg !249
  %58 = mul i64 %53, 3136, !dbg !249
  %59 = mul i64 %57, 56, !dbg !249
  %60 = add i64 %58, %59, !dbg !249
  %61 = add i64 %60, %50, !dbg !249
  %62 = getelementptr float, ptr %7, i64 %61, !dbg !249
  %63 = load <1 x float>, ptr %62, align 4, !dbg !249
  %64 = add i64 %53, 1, !dbg !249
  %65 = mul i64 %64, 3136, !dbg !249
  %66 = add i64 %65, %59, !dbg !249
  %67 = add i64 %66, %50, !dbg !249
  %68 = getelementptr float, ptr %7, i64 %67, !dbg !249
  %69 = load <1 x float>, ptr %68, align 4, !dbg !249
  %70 = add i64 %53, 2, !dbg !249
  %71 = mul i64 %70, 3136, !dbg !249
  %72 = add i64 %71, %59, !dbg !249
  %73 = add i64 %72, %50, !dbg !249
  %74 = getelementptr float, ptr %7, i64 %73, !dbg !249
  %75 = load <1 x float>, ptr %74, align 4, !dbg !249
  %76 = add i64 %53, 3, !dbg !249
  %77 = mul i64 %76, 3136, !dbg !249
  %78 = add i64 %77, %59, !dbg !249
  %79 = add i64 %78, %50, !dbg !249
  %80 = getelementptr float, ptr %7, i64 %79, !dbg !249
  %81 = load <1 x float>, ptr %80, align 4, !dbg !249
  %82 = mul nuw nsw i64 %43, 24, !dbg !251
  %83 = add nuw nsw i64 %82, %53, !dbg !251
  %84 = getelementptr inbounds nuw float, ptr %12, i64 %83, !dbg !251
  %85 = load float, ptr %84, align 4, !dbg !251
  %86 = insertelement <1 x float> poison, float %85, i32 0, !dbg !251
  %87 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %86, <1 x float> %54), !dbg !251
  %88 = add nuw nsw i64 %82, %64, !dbg !251
  %89 = getelementptr inbounds nuw float, ptr %12, i64 %88, !dbg !251
  %90 = load float, ptr %89, align 4, !dbg !251
  %91 = insertelement <1 x float> poison, float %90, i32 0, !dbg !251
  %92 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %69, <1 x float> %91, <1 x float> %87), !dbg !251
  %93 = add nuw nsw i64 %82, %70, !dbg !251
  %94 = getelementptr inbounds nuw float, ptr %12, i64 %93, !dbg !251
  %95 = load float, ptr %94, align 4, !dbg !251
  %96 = insertelement <1 x float> poison, float %95, i32 0, !dbg !251
  %97 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %75, <1 x float> %96, <1 x float> %92), !dbg !251
  %98 = add nuw nsw i64 %82, %76, !dbg !251
  %99 = getelementptr inbounds nuw float, ptr %12, i64 %98, !dbg !251
  %100 = load float, ptr %99, align 4, !dbg !251
  %101 = insertelement <1 x float> poison, float %100, i32 0, !dbg !251
  %102 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %81, <1 x float> %101, <1 x float> %97), !dbg !251
  %103 = add i64 %53, 4, !dbg !249
  br label %52, !dbg !249

104:                                              ; preds = %52
  %105 = fadd contract <1 x float> %54, %45, !dbg !252
  %106 = fcmp ult <1 x float> %105, zeroinitializer, !dbg !253
  %107 = select <1 x i1> %106, <1 x float> zeroinitializer, <1 x float> %105, !dbg !254
  %108 = fcmp ugt <1 x float> %107, splat (float 6.000000e+00), !dbg !255
  %109 = select <1 x i1> %108, <1 x float> splat (float 6.000000e+00), <1 x float> %107, !dbg !256
  %110 = extractelement <1 x float> %109, i64 0, !dbg !249
  %111 = add i64 %38, %47, !dbg !249
  %112 = add i64 %111, 1, !dbg !249
  %113 = add i64 %50, 1, !dbg !249
  %114 = mul nuw nsw i64 %43, 3364, !dbg !249
  %115 = mul nuw nsw i64 %112, 58, !dbg !249
  %116 = add nuw nsw i64 %114, %115, !dbg !249
  %117 = add nuw nsw i64 %116, %113, !dbg !249
  %118 = getelementptr inbounds nuw float, ptr %22, i64 %117, !dbg !249
  store float %110, ptr %118, align 4, !dbg !249
  br label %49, !dbg !249

119:                                              ; preds = %49
  %120 = add i64 %47, 1, !dbg !249
  br label %46, !dbg !249

121:                                              ; preds = %46
  %122 = add i64 %40, 1, !dbg !249
  br label %39, !dbg !249

123:                                              ; preds = %39
  ret i32 0, !dbg !257
}

define internal i32 @infer_dispatch_8_conv_56x56x144x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !258 {
  %4 = alloca float, i64 4, align 64, !dbg !259
  %5 = alloca float, i64 4, align 64, !dbg !260
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !261
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !261
  %8 = load ptr, ptr %7, align 8, !dbg !261
  %9 = getelementptr float, ptr %8, i64 376320, !dbg !261
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !261
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !262
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !262
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !262
  %13 = load ptr, ptr %12, align 8, !dbg !262
  %14 = getelementptr float, ptr %13, i64 2186448, !dbg !262
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !262
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !263
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !263
  %17 = getelementptr ptr, ptr %16, i32 1, !dbg !263
  %18 = load ptr, ptr %17, align 8, !dbg !263
  %19 = getelementptr float, ptr %18, i64 2196624, !dbg !263
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !263
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !264
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !264
  %22 = getelementptr ptr, ptr %21, i32 2, !dbg !264
  %23 = load ptr, ptr %22, align 8, !dbg !264
  %24 = getelementptr float, ptr %23, i64 860736, !dbg !264
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !264
  %25 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !259
  %26 = extractvalue %iree_hal_executable_workgroup_state_v0_t %25, 0, !dbg !259
  %27 = zext i32 %26 to i64, !dbg !259
  %28 = sdiv i64 %27, 12, !dbg !259
  %29 = mul i64 %28, 12, !dbg !259
  %30 = icmp ne i64 %27, %29, !dbg !259
  %31 = icmp slt i64 %27, 0, !dbg !259
  %32 = and i1 %30, %31, !dbg !259
  %33 = add i64 %28, -1, !dbg !259
  %34 = select i1 %32, i64 %33, i64 %28, !dbg !259
  %35 = srem i64 %27, 12, !dbg !259
  %36 = icmp slt i64 %35, 0, !dbg !259
  %37 = add nsw i64 %35, 12, !dbg !259
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !259
  %39 = sdiv i64 %38, 6, !dbg !259
  %40 = srem i64 %27, 6, !dbg !259
  %41 = icmp slt i64 %40, 0, !dbg !259
  %42 = add nsw i64 %40, 6, !dbg !259
  %43 = select i1 %41, i64 %42, i64 %40, !dbg !259
  %44 = mul nsw i64 %34, 28, !dbg !259
  %45 = mul nsw i64 %39, 28, !dbg !259
  %46 = mul nsw i64 %43, 24, !dbg !259
  %47 = getelementptr float, ptr %5, i64 0, !dbg !265
  store <4 x float> zeroinitializer, ptr %47, align 4, !dbg !265
  br label %48, !dbg !259

48:                                               ; preds = %129, %3
  %49 = phi i64 [ %130, %129 ], [ 0, %3 ], !dbg !259
  %50 = icmp slt i64 %49, 28, !dbg !259
  br i1 %50, label %51, label %131, !dbg !259

51:                                               ; preds = %127, %48
  %52 = phi i64 [ %128, %127 ], [ 0, %48 ], !dbg !259
  %53 = icmp slt i64 %52, 28, !dbg !259
  br i1 %53, label %54, label %129, !dbg !259

54:                                               ; preds = %51
  %55 = add i64 %52, %45, !dbg !259
  br label %56, !dbg !259

56:                                               ; preds = %107, %54
  %57 = phi i64 [ %126, %107 ], [ 0, %54 ], !dbg !259
  %58 = icmp slt i64 %57, 24, !dbg !259
  br i1 %58, label %59, label %127, !dbg !259

59:                                               ; preds = %56
  %60 = add i64 %57, %46, !dbg !259
  br label %61, !dbg !259

61:                                               ; preds = %64, %59
  %62 = phi i64 [ %69, %64 ], [ 0, %59 ], !dbg !259
  %63 = icmp slt i64 %62, 4, !dbg !259
  br i1 %63, label %64, label %70, !dbg !259

64:                                               ; preds = %61
  %65 = add nuw nsw i64 0, %62, !dbg !259
  %66 = getelementptr inbounds nuw float, ptr %5, i64 %65, !dbg !259
  %67 = load float, ptr %66, align 4, !dbg !259
  %68 = getelementptr inbounds nuw float, ptr %4, i64 %65, !dbg !259
  store float %67, ptr %68, align 4, !dbg !259
  %69 = add i64 %62, 1, !dbg !259
  br label %61, !dbg !259

70:                                               ; preds = %105, %61
  %71 = phi i64 [ %106, %105 ], [ 0, %61 ], !dbg !259
  %72 = icmp slt i64 %71, 3, !dbg !259
  br i1 %72, label %73, label %107, !dbg !259

73:                                               ; preds = %70
  %74 = add i64 %71, %49, !dbg !259
  %75 = add i64 %74, %44, !dbg !259
  br label %76, !dbg !259

76:                                               ; preds = %103, %73
  %77 = phi i64 [ %104, %103 ], [ 0, %73 ], !dbg !259
  %78 = icmp slt i64 %77, 4, !dbg !259
  br i1 %78, label %79, label %105, !dbg !259

79:                                               ; preds = %82, %76
  %80 = phi i64 [ %102, %82 ], [ 0, %76 ], !dbg !259
  %81 = icmp slt i64 %80, 3, !dbg !259
  br i1 %81, label %82, label %103, !dbg !259

82:                                               ; preds = %79
  %83 = add i64 %55, %77, !dbg !259
  %84 = add i64 %83, %80, !dbg !259
  %85 = mul nuw nsw i64 %60, 3364, !dbg !259
  %86 = mul nuw nsw i64 %75, 58, !dbg !259
  %87 = add nuw nsw i64 %85, %86, !dbg !259
  %88 = add nuw nsw i64 %87, %84, !dbg !259
  %89 = getelementptr inbounds nuw float, ptr %9, i64 %88, !dbg !259
  %90 = load float, ptr %89, align 4, !dbg !259
  %91 = mul nuw nsw i64 %60, 9, !dbg !259
  %92 = mul nuw nsw i64 %71, 3, !dbg !259
  %93 = add nuw nsw i64 %91, %92, !dbg !259
  %94 = add nuw nsw i64 %93, %80, !dbg !259
  %95 = getelementptr inbounds nuw float, ptr %14, i64 %94, !dbg !259
  %96 = load float, ptr %95, align 4, !dbg !259
  %97 = add nuw nsw i64 0, %77, !dbg !259
  %98 = getelementptr inbounds nuw float, ptr %4, i64 %97, !dbg !259
  %99 = load float, ptr %98, align 4, !dbg !259
  %100 = fmul contract float %90, %96, !dbg !266
  %101 = fadd contract float %99, %100, !dbg !267
  store float %101, ptr %98, align 4, !dbg !259
  %102 = add i64 %80, 1, !dbg !259
  br label %79, !dbg !259

103:                                              ; preds = %79
  %104 = add i64 %77, 1, !dbg !259
  br label %76, !dbg !259

105:                                              ; preds = %76
  %106 = add i64 %71, 1, !dbg !259
  br label %70, !dbg !259

107:                                              ; preds = %70
  %108 = getelementptr float, ptr %4, i64 0, !dbg !268
  %109 = load <4 x float>, ptr %108, align 4, !dbg !268
  %110 = getelementptr float, ptr %19, i64 %60, !dbg !268
  %111 = load <1 x float>, ptr %110, align 4, !dbg !268
  %112 = extractelement <1 x float> %111, i64 0, !dbg !269
  %113 = insertelement <4 x float> poison, float %112, i32 0, !dbg !269
  %114 = shufflevector <4 x float> %113, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !269
  %115 = fadd contract <4 x float> %109, %114, !dbg !269
  %116 = fcmp ult <4 x float> %115, zeroinitializer, !dbg !270
  %117 = select <4 x i1> %116, <4 x float> zeroinitializer, <4 x float> %115, !dbg !271
  %118 = fcmp ugt <4 x float> %117, splat (float 6.000000e+00), !dbg !272
  %119 = select <4 x i1> %118, <4 x float> splat (float 6.000000e+00), <4 x float> %117, !dbg !273
  %120 = add i64 %44, %49, !dbg !259
  %121 = mul i64 %60, 3136, !dbg !259
  %122 = mul i64 %120, 56, !dbg !259
  %123 = add i64 %121, %122, !dbg !259
  %124 = add i64 %123, %55, !dbg !259
  %125 = getelementptr float, ptr %24, i64 %124, !dbg !259
  store <4 x float> %119, ptr %125, align 4, !dbg !259
  %126 = add i64 %57, 1, !dbg !259
  br label %56, !dbg !259

127:                                              ; preds = %56
  %128 = add i64 %52, 4, !dbg !259
  br label %51, !dbg !259

129:                                              ; preds = %51
  %130 = add i64 %49, 1, !dbg !259
  br label %48, !dbg !259

131:                                              ; preds = %48
  ret i32 0, !dbg !274
}

define internal i32 @infer_dispatch_9_matmul_like_24x3136x144_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !275 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !276
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !276
  %6 = load ptr, ptr %5, align 8, !dbg !276
  %7 = getelementptr float, ptr %6, i64 860736, !dbg !276
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !276
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !277
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !277
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !277
  %11 = load ptr, ptr %10, align 8, !dbg !277
  %12 = getelementptr float, ptr %11, i64 2113408, !dbg !277
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !277
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !278
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !278
  %15 = load ptr, ptr %14, align 8, !dbg !278
  %16 = getelementptr float, ptr %15, i64 301056, !dbg !278
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !278
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !279
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !279
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !279
  %20 = load ptr, ptr %19, align 8, !dbg !279
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !279
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !280
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !280
  %23 = zext i32 %22 to i64, !dbg !280
  %24 = sdiv i64 %23, 49, !dbg !280
  %25 = mul i64 %24, 49, !dbg !280
  %26 = icmp ne i64 %23, %25, !dbg !280
  %27 = icmp slt i64 %23, 0, !dbg !280
  %28 = and i1 %26, %27, !dbg !280
  %29 = add i64 %24, -1, !dbg !280
  %30 = select i1 %28, i64 %29, i64 %24, !dbg !280
  %31 = srem i64 %23, 49, !dbg !280
  %32 = icmp slt i64 %31, 0, !dbg !280
  %33 = add nsw i64 %31, 49, !dbg !280
  %34 = select i1 %32, i64 %33, i64 %31, !dbg !280
  %35 = mul nsw i64 %30, 8, !dbg !280
  %36 = mul nsw i64 %34, 64, !dbg !280
  br label %37, !dbg !280

37:                                               ; preds = %109, %3
  %38 = phi i64 [ %110, %109 ], [ 0, %3 ], !dbg !280
  %39 = icmp slt i64 %38, 8, !dbg !280
  br i1 %39, label %40, label %111, !dbg !280

40:                                               ; preds = %37
  %41 = add i64 %38, %35, !dbg !280
  %42 = getelementptr float, ptr @__constant_24xf32_0, i64 %41, !dbg !281
  %43 = load <1 x float>, ptr %42, align 4, !dbg !281
  br label %44, !dbg !280

44:                                               ; preds = %95, %40
  %45 = phi i64 [ %108, %95 ], [ 0, %40 ], !dbg !280
  %46 = icmp slt i64 %45, 64, !dbg !280
  br i1 %46, label %47, label %109, !dbg !280

47:                                               ; preds = %44
  %48 = add i64 %45, %36, !dbg !280
  br label %49, !dbg !280

49:                                               ; preds = %53, %47
  %50 = phi i64 [ %94, %53 ], [ 0, %47 ], !dbg !280
  %51 = phi <1 x float> [ %93, %53 ], [ zeroinitializer, %47 ], !dbg !280
  %52 = icmp slt i64 %50, 144, !dbg !280
  br i1 %52, label %53, label %95, !dbg !280

53:                                               ; preds = %49
  %54 = mul i64 %50, 3136, !dbg !280
  %55 = add i64 %54, %48, !dbg !280
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !280
  %57 = load <1 x float>, ptr %56, align 4, !dbg !280
  %58 = add i64 %50, 1, !dbg !280
  %59 = mul i64 %58, 3136, !dbg !280
  %60 = add i64 %59, %48, !dbg !280
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !280
  %62 = load <1 x float>, ptr %61, align 4, !dbg !280
  %63 = add i64 %50, 2, !dbg !280
  %64 = mul i64 %63, 3136, !dbg !280
  %65 = add i64 %64, %48, !dbg !280
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !280
  %67 = load <1 x float>, ptr %66, align 4, !dbg !280
  %68 = add i64 %50, 3, !dbg !280
  %69 = mul i64 %68, 3136, !dbg !280
  %70 = add i64 %69, %48, !dbg !280
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !280
  %72 = load <1 x float>, ptr %71, align 4, !dbg !280
  %73 = mul nuw nsw i64 %41, 144, !dbg !282
  %74 = add nuw nsw i64 %73, %50, !dbg !282
  %75 = getelementptr inbounds nuw float, ptr %12, i64 %74, !dbg !282
  %76 = load float, ptr %75, align 4, !dbg !282
  %77 = insertelement <1 x float> poison, float %76, i32 0, !dbg !282
  %78 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %57, <1 x float> %77, <1 x float> %51), !dbg !282
  %79 = add nuw nsw i64 %73, %58, !dbg !282
  %80 = getelementptr inbounds nuw float, ptr %12, i64 %79, !dbg !282
  %81 = load float, ptr %80, align 4, !dbg !282
  %82 = insertelement <1 x float> poison, float %81, i32 0, !dbg !282
  %83 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %82, <1 x float> %78), !dbg !282
  %84 = add nuw nsw i64 %73, %63, !dbg !282
  %85 = getelementptr inbounds nuw float, ptr %12, i64 %84, !dbg !282
  %86 = load float, ptr %85, align 4, !dbg !282
  %87 = insertelement <1 x float> poison, float %86, i32 0, !dbg !282
  %88 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %67, <1 x float> %87, <1 x float> %83), !dbg !282
  %89 = add nuw nsw i64 %73, %68, !dbg !282
  %90 = getelementptr inbounds nuw float, ptr %12, i64 %89, !dbg !282
  %91 = load float, ptr %90, align 4, !dbg !282
  %92 = insertelement <1 x float> poison, float %91, i32 0, !dbg !282
  %93 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %72, <1 x float> %92, <1 x float> %88), !dbg !282
  %94 = add i64 %50, 4, !dbg !280
  br label %49, !dbg !280

95:                                               ; preds = %49
  %96 = mul i64 %41, 3136, !dbg !281
  %97 = add i64 %96, %48, !dbg !281
  %98 = getelementptr float, ptr %16, i64 %97, !dbg !281
  %99 = load <1 x float>, ptr %98, align 4, !dbg !281
  %100 = extractelement <1 x float> %51, i64 0, !dbg !283
  %101 = extractelement <1 x float> %43, i64 0, !dbg !283
  %102 = fadd contract float %100, %101, !dbg !283
  %103 = extractelement <1 x float> %99, i64 0, !dbg !284
  %104 = fadd contract float %102, %103, !dbg !284
  %105 = mul nuw nsw i64 %41, 3136, !dbg !280
  %106 = add nuw nsw i64 %105, %48, !dbg !280
  %107 = getelementptr inbounds nuw float, ptr %20, i64 %106, !dbg !280
  store float %104, ptr %107, align 4, !dbg !280
  %108 = add i64 %45, 1, !dbg !280
  br label %44, !dbg !280

109:                                              ; preds = %44
  %110 = add i64 %38, 1, !dbg !280
  br label %37, !dbg !280

111:                                              ; preds = %37
  ret i32 0, !dbg !285
}

define internal i32 @infer_dispatch_10_matmul_like_144x56x56x24_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !286 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !287
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !287
  %6 = load ptr, ptr %5, align 8, !dbg !287
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !287
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !288
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !288
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !288
  %10 = load ptr, ptr %9, align 8, !dbg !288
  %11 = getelementptr float, ptr %10, i64 2109952, !dbg !288
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !288
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !289
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !289
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !289
  %15 = load ptr, ptr %14, align 8, !dbg !289
  %16 = getelementptr float, ptr %15, i64 2196192, !dbg !289
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !289
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !290
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !290
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !290
  %20 = load ptr, ptr %19, align 8, !dbg !290
  %21 = getelementptr float, ptr %20, i64 376320, !dbg !290
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !290
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !291
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !291
  %24 = zext i32 %23 to i64, !dbg !291
  %25 = sdiv i64 %24, 7, !dbg !291
  %26 = mul i64 %25, 7, !dbg !291
  %27 = icmp ne i64 %24, %26, !dbg !291
  %28 = icmp slt i64 %24, 0, !dbg !291
  %29 = and i1 %27, %28, !dbg !291
  %30 = add i64 %25, -1, !dbg !291
  %31 = select i1 %29, i64 %30, i64 %25, !dbg !291
  %32 = srem i64 %24, 7, !dbg !291
  %33 = icmp slt i64 %32, 0, !dbg !291
  %34 = add nsw i64 %32, 7, !dbg !291
  %35 = select i1 %33, i64 %34, i64 %32, !dbg !291
  %36 = mul nsw i64 %31, 16, !dbg !291
  %37 = mul nsw i64 %35, 8, !dbg !291
  br label %38, !dbg !291

38:                                               ; preds = %119, %3
  %39 = phi i64 [ %120, %119 ], [ 0, %3 ], !dbg !291
  %40 = icmp slt i64 %39, 16, !dbg !291
  br i1 %40, label %41, label %121, !dbg !291

41:                                               ; preds = %38
  %42 = add i64 %39, %36, !dbg !291
  %43 = getelementptr float, ptr %16, i64 %42, !dbg !292
  %44 = load <1 x float>, ptr %43, align 4, !dbg !292
  br label %45, !dbg !291

45:                                               ; preds = %117, %41
  %46 = phi i64 [ %118, %117 ], [ 0, %41 ], !dbg !291
  %47 = icmp slt i64 %46, 8, !dbg !291
  br i1 %47, label %48, label %119, !dbg !291

48:                                               ; preds = %103, %45
  %49 = phi i64 [ %116, %103 ], [ 0, %45 ], !dbg !291
  %50 = icmp slt i64 %49, 56, !dbg !291
  br i1 %50, label %51, label %117, !dbg !291

51:                                               ; preds = %55, %48
  %52 = phi i64 [ %102, %55 ], [ 0, %48 ], !dbg !291
  %53 = phi <1 x float> [ %101, %55 ], [ zeroinitializer, %48 ], !dbg !291
  %54 = icmp slt i64 %52, 24, !dbg !291
  br i1 %54, label %55, label %103, !dbg !291

55:                                               ; preds = %51
  %56 = add i64 %46, %37, !dbg !291
  %57 = mul i64 %52, 3136, !dbg !291
  %58 = mul i64 %56, 56, !dbg !291
  %59 = add i64 %57, %58, !dbg !291
  %60 = add i64 %59, %49, !dbg !291
  %61 = getelementptr float, ptr %6, i64 %60, !dbg !291
  %62 = load <1 x float>, ptr %61, align 4, !dbg !291
  %63 = add i64 %52, 1, !dbg !291
  %64 = mul i64 %63, 3136, !dbg !291
  %65 = add i64 %64, %58, !dbg !291
  %66 = add i64 %65, %49, !dbg !291
  %67 = getelementptr float, ptr %6, i64 %66, !dbg !291
  %68 = load <1 x float>, ptr %67, align 4, !dbg !291
  %69 = add i64 %52, 2, !dbg !291
  %70 = mul i64 %69, 3136, !dbg !291
  %71 = add i64 %70, %58, !dbg !291
  %72 = add i64 %71, %49, !dbg !291
  %73 = getelementptr float, ptr %6, i64 %72, !dbg !291
  %74 = load <1 x float>, ptr %73, align 4, !dbg !291
  %75 = add i64 %52, 3, !dbg !291
  %76 = mul i64 %75, 3136, !dbg !291
  %77 = add i64 %76, %58, !dbg !291
  %78 = add i64 %77, %49, !dbg !291
  %79 = getelementptr float, ptr %6, i64 %78, !dbg !291
  %80 = load <1 x float>, ptr %79, align 4, !dbg !291
  %81 = mul nuw nsw i64 %42, 24, !dbg !293
  %82 = add nuw nsw i64 %81, %52, !dbg !293
  %83 = getelementptr inbounds nuw float, ptr %11, i64 %82, !dbg !293
  %84 = load float, ptr %83, align 4, !dbg !293
  %85 = insertelement <1 x float> poison, float %84, i32 0, !dbg !293
  %86 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %85, <1 x float> %53), !dbg !293
  %87 = add nuw nsw i64 %81, %63, !dbg !293
  %88 = getelementptr inbounds nuw float, ptr %11, i64 %87, !dbg !293
  %89 = load float, ptr %88, align 4, !dbg !293
  %90 = insertelement <1 x float> poison, float %89, i32 0, !dbg !293
  %91 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %90, <1 x float> %86), !dbg !293
  %92 = add nuw nsw i64 %81, %69, !dbg !293
  %93 = getelementptr inbounds nuw float, ptr %11, i64 %92, !dbg !293
  %94 = load float, ptr %93, align 4, !dbg !293
  %95 = insertelement <1 x float> poison, float %94, i32 0, !dbg !293
  %96 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %74, <1 x float> %95, <1 x float> %91), !dbg !293
  %97 = add nuw nsw i64 %81, %75, !dbg !293
  %98 = getelementptr inbounds nuw float, ptr %11, i64 %97, !dbg !293
  %99 = load float, ptr %98, align 4, !dbg !293
  %100 = insertelement <1 x float> poison, float %99, i32 0, !dbg !293
  %101 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %80, <1 x float> %100, <1 x float> %96), !dbg !293
  %102 = add i64 %52, 4, !dbg !291
  br label %51, !dbg !291

103:                                              ; preds = %51
  %104 = fadd contract <1 x float> %53, %44, !dbg !294
  %105 = fcmp ult <1 x float> %104, zeroinitializer, !dbg !295
  %106 = select <1 x i1> %105, <1 x float> zeroinitializer, <1 x float> %104, !dbg !296
  %107 = fcmp ugt <1 x float> %106, splat (float 6.000000e+00), !dbg !297
  %108 = select <1 x i1> %107, <1 x float> splat (float 6.000000e+00), <1 x float> %106, !dbg !298
  %109 = extractelement <1 x float> %108, i64 0, !dbg !291
  %110 = add i64 %37, %46, !dbg !291
  %111 = mul nuw nsw i64 %42, 3249, !dbg !291
  %112 = mul nuw nsw i64 %110, 57, !dbg !291
  %113 = add nuw nsw i64 %111, %112, !dbg !291
  %114 = add nuw nsw i64 %113, %49, !dbg !291
  %115 = getelementptr inbounds nuw float, ptr %21, i64 %114, !dbg !291
  store float %109, ptr %115, align 4, !dbg !291
  %116 = add i64 %49, 1, !dbg !291
  br label %48, !dbg !291

117:                                              ; preds = %48
  %118 = add i64 %46, 1, !dbg !291
  br label %45, !dbg !291

119:                                              ; preds = %45
  %120 = add i64 %39, 1, !dbg !291
  br label %38, !dbg !291

121:                                              ; preds = %38
  ret i32 0, !dbg !299
}

define internal i32 @infer_dispatch_11_conv_28x28x144x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !300 {
  %4 = alloca float, i64 4, align 64, !dbg !301
  %5 = alloca float, i64 4, align 64, !dbg !302
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !303
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !303
  %8 = load ptr, ptr %7, align 8, !dbg !303
  %9 = getelementptr float, ptr %8, i64 376320, !dbg !303
  call void @llvm.assume(i1 true) [ "align"(ptr %9, i64 64) ], !dbg !303
  %10 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !304
  %11 = extractvalue %iree_hal_executable_dispatch_state_v0_t %10, 10, !dbg !304
  %12 = getelementptr ptr, ptr %11, i32 1, !dbg !304
  %13 = load ptr, ptr %12, align 8, !dbg !304
  %14 = getelementptr float, ptr %13, i64 2185152, !dbg !304
  call void @llvm.assume(i1 true) [ "align"(ptr %14, i64 64) ], !dbg !304
  %15 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !305
  %16 = extractvalue %iree_hal_executable_dispatch_state_v0_t %15, 10, !dbg !305
  %17 = getelementptr ptr, ptr %16, i32 1, !dbg !305
  %18 = load ptr, ptr %17, align 8, !dbg !305
  %19 = getelementptr float, ptr %18, i64 2196336, !dbg !305
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !305
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !306
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !306
  %22 = getelementptr ptr, ptr %21, i32 2, !dbg !306
  %23 = load ptr, ptr %22, align 8, !dbg !306
  call void @llvm.assume(i1 true) [ "align"(ptr %23, i64 64) ], !dbg !306
  %24 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !301
  %25 = extractvalue %iree_hal_executable_workgroup_state_v0_t %24, 0, !dbg !301
  %26 = zext i32 %25 to i64, !dbg !301
  %27 = sdiv i64 %26, 6, !dbg !301
  %28 = mul i64 %27, 6, !dbg !301
  %29 = icmp ne i64 %26, %28, !dbg !301
  %30 = icmp slt i64 %26, 0, !dbg !301
  %31 = and i1 %29, %30, !dbg !301
  %32 = add i64 %27, -1, !dbg !301
  %33 = select i1 %31, i64 %32, i64 %27, !dbg !301
  %34 = srem i64 %26, 6, !dbg !301
  %35 = icmp slt i64 %34, 0, !dbg !301
  %36 = add nsw i64 %34, 6, !dbg !301
  %37 = select i1 %35, i64 %36, i64 %34, !dbg !301
  %38 = mul nsw i64 %33, 14, !dbg !301
  %39 = mul nsw i64 %37, 24, !dbg !301
  %40 = getelementptr float, ptr %5, i64 0, !dbg !307
  store <4 x float> zeroinitializer, ptr %40, align 4, !dbg !307
  br label %41, !dbg !301

41:                                               ; preds = %125, %3
  %42 = phi i64 [ %126, %125 ], [ 0, %3 ], !dbg !301
  %43 = icmp slt i64 %42, 14, !dbg !301
  br i1 %43, label %44, label %127, !dbg !301

44:                                               ; preds = %123, %41
  %45 = phi i64 [ %124, %123 ], [ 0, %41 ], !dbg !301
  %46 = icmp slt i64 %45, 28, !dbg !301
  br i1 %46, label %47, label %125, !dbg !301

47:                                               ; preds = %44
  %48 = mul nsw i64 %45, 2, !dbg !301
  br label %49, !dbg !301

49:                                               ; preds = %103, %47
  %50 = phi i64 [ %122, %103 ], [ 0, %47 ], !dbg !301
  %51 = icmp slt i64 %50, 24, !dbg !301
  br i1 %51, label %52, label %123, !dbg !301

52:                                               ; preds = %49
  %53 = add i64 %50, %39, !dbg !301
  br label %54, !dbg !301

54:                                               ; preds = %57, %52
  %55 = phi i64 [ %62, %57 ], [ 0, %52 ], !dbg !301
  %56 = icmp slt i64 %55, 4, !dbg !301
  br i1 %56, label %57, label %63, !dbg !301

57:                                               ; preds = %54
  %58 = add nuw nsw i64 0, %55, !dbg !301
  %59 = getelementptr inbounds nuw float, ptr %5, i64 %58, !dbg !301
  %60 = load float, ptr %59, align 4, !dbg !301
  %61 = getelementptr inbounds nuw float, ptr %4, i64 %58, !dbg !301
  store float %60, ptr %61, align 4, !dbg !301
  %62 = add i64 %55, 1, !dbg !301
  br label %54, !dbg !301

63:                                               ; preds = %101, %54
  %64 = phi i64 [ %102, %101 ], [ 0, %54 ], !dbg !301
  %65 = icmp slt i64 %64, 3, !dbg !301
  br i1 %65, label %66, label %103, !dbg !301

66:                                               ; preds = %63
  %67 = mul nsw i64 %42, 2, !dbg !301
  %68 = mul nsw i64 %33, 28, !dbg !301
  %69 = add i64 %67, %68, !dbg !301
  %70 = add i64 %69, %64, !dbg !301
  br label %71, !dbg !301

71:                                               ; preds = %99, %66
  %72 = phi i64 [ %100, %99 ], [ 0, %66 ], !dbg !301
  %73 = icmp slt i64 %72, 4, !dbg !301
  br i1 %73, label %74, label %101, !dbg !301

74:                                               ; preds = %77, %71
  %75 = phi i64 [ %98, %77 ], [ 0, %71 ], !dbg !301
  %76 = icmp slt i64 %75, 3, !dbg !301
  br i1 %76, label %77, label %99, !dbg !301

77:                                               ; preds = %74
  %78 = mul nsw i64 %72, 2, !dbg !301
  %79 = add i64 %48, %78, !dbg !301
  %80 = add i64 %79, %75, !dbg !301
  %81 = mul nuw nsw i64 %53, 3249, !dbg !301
  %82 = mul nuw nsw i64 %70, 57, !dbg !301
  %83 = add nuw nsw i64 %81, %82, !dbg !301
  %84 = add nuw nsw i64 %83, %80, !dbg !301
  %85 = getelementptr inbounds nuw float, ptr %9, i64 %84, !dbg !301
  %86 = load float, ptr %85, align 4, !dbg !301
  %87 = mul nuw nsw i64 %53, 9, !dbg !301
  %88 = mul nuw nsw i64 %64, 3, !dbg !301
  %89 = add nuw nsw i64 %87, %88, !dbg !301
  %90 = add nuw nsw i64 %89, %75, !dbg !301
  %91 = getelementptr inbounds nuw float, ptr %14, i64 %90, !dbg !301
  %92 = load float, ptr %91, align 4, !dbg !301
  %93 = add nuw nsw i64 0, %72, !dbg !301
  %94 = getelementptr inbounds nuw float, ptr %4, i64 %93, !dbg !301
  %95 = load float, ptr %94, align 4, !dbg !301
  %96 = fmul contract float %86, %92, !dbg !308
  %97 = fadd contract float %95, %96, !dbg !309
  store float %97, ptr %94, align 4, !dbg !301
  %98 = add i64 %75, 1, !dbg !301
  br label %74, !dbg !301

99:                                               ; preds = %74
  %100 = add i64 %72, 1, !dbg !301
  br label %71, !dbg !301

101:                                              ; preds = %71
  %102 = add i64 %64, 1, !dbg !301
  br label %63, !dbg !301

103:                                              ; preds = %63
  %104 = getelementptr float, ptr %4, i64 0, !dbg !310
  %105 = load <4 x float>, ptr %104, align 4, !dbg !310
  %106 = getelementptr float, ptr %19, i64 %53, !dbg !310
  %107 = load <1 x float>, ptr %106, align 4, !dbg !310
  %108 = extractelement <1 x float> %107, i64 0, !dbg !311
  %109 = insertelement <4 x float> poison, float %108, i32 0, !dbg !311
  %110 = shufflevector <4 x float> %109, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !311
  %111 = fadd contract <4 x float> %105, %110, !dbg !311
  %112 = fcmp ult <4 x float> %111, zeroinitializer, !dbg !312
  %113 = select <4 x i1> %112, <4 x float> zeroinitializer, <4 x float> %111, !dbg !313
  %114 = fcmp ugt <4 x float> %113, splat (float 6.000000e+00), !dbg !314
  %115 = select <4 x i1> %114, <4 x float> splat (float 6.000000e+00), <4 x float> %113, !dbg !315
  %116 = add i64 %38, %42, !dbg !301
  %117 = mul i64 %53, 784, !dbg !301
  %118 = mul i64 %116, 28, !dbg !301
  %119 = add i64 %117, %118, !dbg !301
  %120 = add i64 %119, %45, !dbg !301
  %121 = getelementptr float, ptr %23, i64 %120, !dbg !301
  store <4 x float> %115, ptr %121, align 4, !dbg !301
  %122 = add i64 %50, 1, !dbg !301
  br label %49, !dbg !301

123:                                              ; preds = %49
  %124 = add i64 %45, 4, !dbg !301
  br label %44, !dbg !301

125:                                              ; preds = %44
  %126 = add i64 %42, 1, !dbg !301
  br label %41, !dbg !301

127:                                              ; preds = %41
  ret i32 0, !dbg !316
}

define internal i32 @infer_dispatch_12_matmul_like_32x784x144_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !317 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !318
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !318
  %6 = load ptr, ptr %5, align 8, !dbg !318
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !318
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !319
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !319
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !319
  %10 = load ptr, ptr %9, align 8, !dbg !319
  %11 = getelementptr float, ptr %10, i64 2105344, !dbg !319
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !319
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !320
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !320
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !320
  %15 = load ptr, ptr %14, align 8, !dbg !320
  %16 = getelementptr float, ptr %15, i64 112896, !dbg !320
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !320
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !321
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !321
  %19 = zext i32 %18 to i64, !dbg !321
  %20 = mul nsw i64 %19, 56, !dbg !321
  br label %21, !dbg !321

21:                                               ; preds = %86, %3
  %22 = phi i64 [ %87, %86 ], [ 0, %3 ], !dbg !321
  %23 = icmp slt i64 %22, 32, !dbg !321
  br i1 %23, label %24, label %88, !dbg !321

24:                                               ; preds = %21
  %25 = getelementptr float, ptr @__constant_32xf32_1, i64 %22, !dbg !322
  %26 = load <1 x float>, ptr %25, align 4, !dbg !322
  br label %27, !dbg !321

27:                                               ; preds = %78, %24
  %28 = phi i64 [ %85, %78 ], [ 0, %24 ], !dbg !321
  %29 = icmp slt i64 %28, 56, !dbg !321
  br i1 %29, label %30, label %86, !dbg !321

30:                                               ; preds = %27
  %31 = add i64 %28, %20, !dbg !321
  br label %32, !dbg !321

32:                                               ; preds = %36, %30
  %33 = phi i64 [ %77, %36 ], [ 0, %30 ], !dbg !321
  %34 = phi <1 x float> [ %76, %36 ], [ zeroinitializer, %30 ], !dbg !321
  %35 = icmp slt i64 %33, 144, !dbg !321
  br i1 %35, label %36, label %78, !dbg !321

36:                                               ; preds = %32
  %37 = mul i64 %33, 784, !dbg !321
  %38 = add i64 %37, %31, !dbg !321
  %39 = getelementptr float, ptr %6, i64 %38, !dbg !321
  %40 = load <1 x float>, ptr %39, align 4, !dbg !321
  %41 = add i64 %33, 1, !dbg !321
  %42 = mul i64 %41, 784, !dbg !321
  %43 = add i64 %42, %31, !dbg !321
  %44 = getelementptr float, ptr %6, i64 %43, !dbg !321
  %45 = load <1 x float>, ptr %44, align 4, !dbg !321
  %46 = add i64 %33, 2, !dbg !321
  %47 = mul i64 %46, 784, !dbg !321
  %48 = add i64 %47, %31, !dbg !321
  %49 = getelementptr float, ptr %6, i64 %48, !dbg !321
  %50 = load <1 x float>, ptr %49, align 4, !dbg !321
  %51 = add i64 %33, 3, !dbg !321
  %52 = mul i64 %51, 784, !dbg !321
  %53 = add i64 %52, %31, !dbg !321
  %54 = getelementptr float, ptr %6, i64 %53, !dbg !321
  %55 = load <1 x float>, ptr %54, align 4, !dbg !321
  %56 = mul nuw nsw i64 %22, 144, !dbg !323
  %57 = add nuw nsw i64 %56, %33, !dbg !323
  %58 = getelementptr inbounds nuw float, ptr %11, i64 %57, !dbg !323
  %59 = load float, ptr %58, align 4, !dbg !323
  %60 = insertelement <1 x float> poison, float %59, i32 0, !dbg !323
  %61 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %40, <1 x float> %60, <1 x float> %34), !dbg !323
  %62 = add nuw nsw i64 %56, %41, !dbg !323
  %63 = getelementptr inbounds nuw float, ptr %11, i64 %62, !dbg !323
  %64 = load float, ptr %63, align 4, !dbg !323
  %65 = insertelement <1 x float> poison, float %64, i32 0, !dbg !323
  %66 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %45, <1 x float> %65, <1 x float> %61), !dbg !323
  %67 = add nuw nsw i64 %56, %46, !dbg !323
  %68 = getelementptr inbounds nuw float, ptr %11, i64 %67, !dbg !323
  %69 = load float, ptr %68, align 4, !dbg !323
  %70 = insertelement <1 x float> poison, float %69, i32 0, !dbg !323
  %71 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %50, <1 x float> %70, <1 x float> %66), !dbg !323
  %72 = add nuw nsw i64 %56, %51, !dbg !323
  %73 = getelementptr inbounds nuw float, ptr %11, i64 %72, !dbg !323
  %74 = load float, ptr %73, align 4, !dbg !323
  %75 = insertelement <1 x float> poison, float %74, i32 0, !dbg !323
  %76 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %55, <1 x float> %75, <1 x float> %71), !dbg !323
  %77 = add i64 %33, 4, !dbg !321
  br label %32, !dbg !321

78:                                               ; preds = %32
  %79 = extractelement <1 x float> %34, i64 0, !dbg !324
  %80 = extractelement <1 x float> %26, i64 0, !dbg !324
  %81 = fadd contract float %79, %80, !dbg !324
  %82 = mul nuw nsw i64 %22, 784, !dbg !321
  %83 = add nuw nsw i64 %82, %31, !dbg !321
  %84 = getelementptr inbounds nuw float, ptr %16, i64 %83, !dbg !321
  store float %81, ptr %84, align 4, !dbg !321
  %85 = add i64 %28, 1, !dbg !321
  br label %27, !dbg !321

86:                                               ; preds = %27
  %87 = add i64 %22, 1, !dbg !321
  br label %21, !dbg !321

88:                                               ; preds = %21
  ret i32 0, !dbg !325
}

define internal i32 @infer_dispatch_13_matmul_like_192x28x28x32_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !326 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !327
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !327
  %6 = load i32, ptr %5, align 4, !dbg !327
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !328
  %8 = load i32, ptr %7, align 4, !dbg !328
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !329
  %10 = load i32, ptr %9, align 4, !dbg !329
  %11 = zext i32 %6 to i64, !dbg !330
  %12 = zext i32 %8 to i64, !dbg !331
  %13 = zext i32 %10 to i64, !dbg !332
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !333
  %15 = load ptr, ptr %14, align 8, !dbg !333
  %16 = mul i64 %11, 8, !dbg !333
  %17 = udiv i64 %16, 32, !dbg !333
  %18 = getelementptr float, ptr %15, i64 %17, !dbg !333
  call void @llvm.assume(i1 true) [ "align"(ptr %18, i64 64) ], !dbg !333
  %19 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !334
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %19, 10, !dbg !334
  %21 = getelementptr ptr, ptr %20, i32 1, !dbg !334
  %22 = load ptr, ptr %21, align 8, !dbg !334
  %23 = mul i64 %12, 8, !dbg !334
  %24 = udiv i64 %23, 32, !dbg !334
  %25 = getelementptr float, ptr %22, i64 %24, !dbg !334
  call void @llvm.assume(i1 true) [ "align"(ptr %25, i64 64) ], !dbg !334
  %26 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !335
  %27 = extractvalue %iree_hal_executable_dispatch_state_v0_t %26, 10, !dbg !335
  %28 = getelementptr ptr, ptr %27, i32 1, !dbg !335
  %29 = load ptr, ptr %28, align 8, !dbg !335
  %30 = mul i64 %13, 8, !dbg !335
  %31 = udiv i64 %30, 32, !dbg !335
  %32 = getelementptr float, ptr %29, i64 %31, !dbg !335
  call void @llvm.assume(i1 true) [ "align"(ptr %32, i64 64) ], !dbg !335
  %33 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !336
  %34 = extractvalue %iree_hal_executable_dispatch_state_v0_t %33, 10, !dbg !336
  %35 = getelementptr ptr, ptr %34, i32 2, !dbg !336
  %36 = load ptr, ptr %35, align 8, !dbg !336
  %37 = getelementptr float, ptr %36, i64 137984, !dbg !336
  call void @llvm.assume(i1 true) [ "align"(ptr %37, i64 64) ], !dbg !336
  %38 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !337
  %39 = extractvalue %iree_hal_executable_workgroup_state_v0_t %38, 0, !dbg !337
  %40 = zext i32 %39 to i64, !dbg !337
  %41 = sdiv i64 %40, 2, !dbg !337
  %42 = mul i64 %41, 2, !dbg !337
  %43 = icmp ne i64 %40, %42, !dbg !337
  %44 = icmp slt i64 %40, 0, !dbg !337
  %45 = and i1 %43, %44, !dbg !337
  %46 = add i64 %41, -1, !dbg !337
  %47 = select i1 %45, i64 %46, i64 %41, !dbg !337
  %48 = srem i64 %40, 2, !dbg !337
  %49 = icmp slt i64 %48, 0, !dbg !337
  %50 = add nsw i64 %48, 2, !dbg !337
  %51 = select i1 %49, i64 %50, i64 %48, !dbg !337
  %52 = mul nsw i64 %47, 24, !dbg !337
  %53 = mul nsw i64 %51, 14, !dbg !337
  br label %54, !dbg !337

54:                                               ; preds = %136, %3
  %55 = phi i64 [ %137, %136 ], [ 0, %3 ], !dbg !337
  %56 = icmp slt i64 %55, 24, !dbg !337
  br i1 %56, label %57, label %138, !dbg !337

57:                                               ; preds = %54
  %58 = add i64 %55, %52, !dbg !337
  %59 = getelementptr float, ptr %32, i64 %58, !dbg !338
  %60 = load <1 x float>, ptr %59, align 4, !dbg !338
  br label %61, !dbg !337

61:                                               ; preds = %134, %57
  %62 = phi i64 [ %135, %134 ], [ 0, %57 ], !dbg !337
  %63 = icmp slt i64 %62, 14, !dbg !337
  br i1 %63, label %64, label %136, !dbg !337

64:                                               ; preds = %119, %61
  %65 = phi i64 [ %128, %119 ], [ 0, %61 ], !dbg !337
  %66 = icmp slt i64 %65, 28, !dbg !337
  br i1 %66, label %67, label %134, !dbg !337

67:                                               ; preds = %71, %64
  %68 = phi i64 [ %118, %71 ], [ 0, %64 ], !dbg !337
  %69 = phi <1 x float> [ %117, %71 ], [ zeroinitializer, %64 ], !dbg !337
  %70 = icmp slt i64 %68, 32, !dbg !337
  br i1 %70, label %71, label %119, !dbg !337

71:                                               ; preds = %67
  %72 = add i64 %62, %53, !dbg !337
  %73 = mul i64 %68, 784, !dbg !337
  %74 = mul i64 %72, 28, !dbg !337
  %75 = add i64 %73, %74, !dbg !337
  %76 = add i64 %75, %65, !dbg !337
  %77 = getelementptr float, ptr %18, i64 %76, !dbg !337
  %78 = load <1 x float>, ptr %77, align 4, !dbg !337
  %79 = add i64 %68, 1, !dbg !337
  %80 = mul i64 %79, 784, !dbg !337
  %81 = add i64 %80, %74, !dbg !337
  %82 = add i64 %81, %65, !dbg !337
  %83 = getelementptr float, ptr %18, i64 %82, !dbg !337
  %84 = load <1 x float>, ptr %83, align 4, !dbg !337
  %85 = add i64 %68, 2, !dbg !337
  %86 = mul i64 %85, 784, !dbg !337
  %87 = add i64 %86, %74, !dbg !337
  %88 = add i64 %87, %65, !dbg !337
  %89 = getelementptr float, ptr %18, i64 %88, !dbg !337
  %90 = load <1 x float>, ptr %89, align 4, !dbg !337
  %91 = add i64 %68, 3, !dbg !337
  %92 = mul i64 %91, 784, !dbg !337
  %93 = add i64 %92, %74, !dbg !337
  %94 = add i64 %93, %65, !dbg !337
  %95 = getelementptr float, ptr %18, i64 %94, !dbg !337
  %96 = load <1 x float>, ptr %95, align 4, !dbg !337
  %97 = mul nuw nsw i64 %58, 32, !dbg !339
  %98 = add nuw nsw i64 %97, %68, !dbg !339
  %99 = getelementptr inbounds nuw float, ptr %25, i64 %98, !dbg !339
  %100 = load float, ptr %99, align 4, !dbg !339
  %101 = insertelement <1 x float> poison, float %100, i32 0, !dbg !339
  %102 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %78, <1 x float> %101, <1 x float> %69), !dbg !339
  %103 = add nuw nsw i64 %97, %79, !dbg !339
  %104 = getelementptr inbounds nuw float, ptr %25, i64 %103, !dbg !339
  %105 = load float, ptr %104, align 4, !dbg !339
  %106 = insertelement <1 x float> poison, float %105, i32 0, !dbg !339
  %107 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %84, <1 x float> %106, <1 x float> %102), !dbg !339
  %108 = add nuw nsw i64 %97, %85, !dbg !339
  %109 = getelementptr inbounds nuw float, ptr %25, i64 %108, !dbg !339
  %110 = load float, ptr %109, align 4, !dbg !339
  %111 = insertelement <1 x float> poison, float %110, i32 0, !dbg !339
  %112 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %90, <1 x float> %111, <1 x float> %107), !dbg !339
  %113 = add nuw nsw i64 %97, %91, !dbg !339
  %114 = getelementptr inbounds nuw float, ptr %25, i64 %113, !dbg !339
  %115 = load float, ptr %114, align 4, !dbg !339
  %116 = insertelement <1 x float> poison, float %115, i32 0, !dbg !339
  %117 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %96, <1 x float> %116, <1 x float> %112), !dbg !339
  %118 = add i64 %68, 4, !dbg !337
  br label %67, !dbg !337

119:                                              ; preds = %67
  %120 = fadd contract <1 x float> %69, %60, !dbg !340
  %121 = fcmp ult <1 x float> %120, zeroinitializer, !dbg !341
  %122 = select <1 x i1> %121, <1 x float> zeroinitializer, <1 x float> %120, !dbg !342
  %123 = fcmp ugt <1 x float> %122, splat (float 6.000000e+00), !dbg !343
  %124 = select <1 x i1> %123, <1 x float> splat (float 6.000000e+00), <1 x float> %122, !dbg !344
  %125 = extractelement <1 x float> %124, i64 0, !dbg !337
  %126 = add i64 %53, %62, !dbg !337
  %127 = add i64 %126, 1, !dbg !337
  %128 = add i64 %65, 1, !dbg !337
  %129 = mul nuw nsw i64 %58, 900, !dbg !337
  %130 = mul nuw nsw i64 %127, 30, !dbg !337
  %131 = add nuw nsw i64 %129, %130, !dbg !337
  %132 = add nuw nsw i64 %131, %128, !dbg !337
  %133 = getelementptr inbounds nuw float, ptr %37, i64 %132, !dbg !337
  store float %125, ptr %133, align 4, !dbg !337
  br label %64, !dbg !337

134:                                              ; preds = %64
  %135 = add i64 %62, 1, !dbg !337
  br label %61, !dbg !337

136:                                              ; preds = %61
  %137 = add i64 %55, 1, !dbg !337
  br label %54, !dbg !337

138:                                              ; preds = %54
  ret i32 0, !dbg !345
}

define internal i32 @infer_dispatch_14_conv_28x28x192x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !346 {
  %4 = alloca float, i64 4, align 64, !dbg !347
  %5 = alloca float, i64 4, align 64, !dbg !348
  %6 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !349
  %7 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 9, !dbg !349
  %8 = load i32, ptr %7, align 4, !dbg !349
  %9 = getelementptr i32, ptr %7, i32 1, !dbg !350
  %10 = load i32, ptr %9, align 4, !dbg !350
  %11 = zext i32 %8 to i64, !dbg !351
  %12 = zext i32 %10 to i64, !dbg !352
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %6, 10, !dbg !353
  %14 = load ptr, ptr %13, align 8, !dbg !353
  %15 = getelementptr float, ptr %14, i64 137984, !dbg !353
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !353
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !354
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !354
  %18 = getelementptr ptr, ptr %17, i32 1, !dbg !354
  %19 = load ptr, ptr %18, align 8, !dbg !354
  %20 = mul i64 %11, 8, !dbg !354
  %21 = udiv i64 %20, 32, !dbg !354
  %22 = getelementptr float, ptr %19, i64 %21, !dbg !354
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !354
  %23 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !355
  %24 = extractvalue %iree_hal_executable_dispatch_state_v0_t %23, 10, !dbg !355
  %25 = getelementptr ptr, ptr %24, i32 1, !dbg !355
  %26 = load ptr, ptr %25, align 8, !dbg !355
  %27 = mul i64 %12, 8, !dbg !355
  %28 = udiv i64 %27, 32, !dbg !355
  %29 = getelementptr float, ptr %26, i64 %28, !dbg !355
  call void @llvm.assume(i1 true) [ "align"(ptr %29, i64 64) ], !dbg !355
  %30 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !356
  %31 = extractvalue %iree_hal_executable_dispatch_state_v0_t %30, 10, !dbg !356
  %32 = getelementptr ptr, ptr %31, i32 2, !dbg !356
  %33 = load ptr, ptr %32, align 8, !dbg !356
  %34 = getelementptr float, ptr %33, i64 310784, !dbg !356
  call void @llvm.assume(i1 true) [ "align"(ptr %34, i64 64) ], !dbg !356
  %35 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !347
  %36 = extractvalue %iree_hal_executable_workgroup_state_v0_t %35, 0, !dbg !347
  %37 = zext i32 %36 to i64, !dbg !347
  %38 = sdiv i64 %37, 6, !dbg !347
  %39 = mul i64 %38, 6, !dbg !347
  %40 = icmp ne i64 %37, %39, !dbg !347
  %41 = icmp slt i64 %37, 0, !dbg !347
  %42 = and i1 %40, %41, !dbg !347
  %43 = add i64 %38, -1, !dbg !347
  %44 = select i1 %42, i64 %43, i64 %38, !dbg !347
  %45 = srem i64 %37, 6, !dbg !347
  %46 = icmp slt i64 %45, 0, !dbg !347
  %47 = add nsw i64 %45, 6, !dbg !347
  %48 = select i1 %46, i64 %47, i64 %45, !dbg !347
  %49 = mul nsw i64 %44, 14, !dbg !347
  %50 = mul nsw i64 %48, 32, !dbg !347
  %51 = getelementptr float, ptr %5, i64 0, !dbg !357
  store <4 x float> zeroinitializer, ptr %51, align 4, !dbg !357
  br label %52, !dbg !347

52:                                               ; preds = %131, %3
  %53 = phi i64 [ %132, %131 ], [ 0, %3 ], !dbg !347
  %54 = icmp slt i64 %53, 14, !dbg !347
  br i1 %54, label %55, label %133, !dbg !347

55:                                               ; preds = %129, %52
  %56 = phi i64 [ %130, %129 ], [ 0, %52 ], !dbg !347
  %57 = icmp slt i64 %56, 28, !dbg !347
  br i1 %57, label %58, label %131, !dbg !347

58:                                               ; preds = %109, %55
  %59 = phi i64 [ %128, %109 ], [ 0, %55 ], !dbg !347
  %60 = icmp slt i64 %59, 32, !dbg !347
  br i1 %60, label %61, label %129, !dbg !347

61:                                               ; preds = %58
  %62 = add i64 %59, %50, !dbg !347
  br label %63, !dbg !347

63:                                               ; preds = %66, %61
  %64 = phi i64 [ %71, %66 ], [ 0, %61 ], !dbg !347
  %65 = icmp slt i64 %64, 4, !dbg !347
  br i1 %65, label %66, label %72, !dbg !347

66:                                               ; preds = %63
  %67 = add nuw nsw i64 0, %64, !dbg !347
  %68 = getelementptr inbounds nuw float, ptr %5, i64 %67, !dbg !347
  %69 = load float, ptr %68, align 4, !dbg !347
  %70 = getelementptr inbounds nuw float, ptr %4, i64 %67, !dbg !347
  store float %69, ptr %70, align 4, !dbg !347
  %71 = add i64 %64, 1, !dbg !347
  br label %63, !dbg !347

72:                                               ; preds = %107, %63
  %73 = phi i64 [ %108, %107 ], [ 0, %63 ], !dbg !347
  %74 = icmp slt i64 %73, 3, !dbg !347
  br i1 %74, label %75, label %109, !dbg !347

75:                                               ; preds = %72
  %76 = add i64 %73, %53, !dbg !347
  %77 = add i64 %76, %49, !dbg !347
  br label %78, !dbg !347

78:                                               ; preds = %105, %75
  %79 = phi i64 [ %106, %105 ], [ 0, %75 ], !dbg !347
  %80 = icmp slt i64 %79, 4, !dbg !347
  br i1 %80, label %81, label %107, !dbg !347

81:                                               ; preds = %84, %78
  %82 = phi i64 [ %104, %84 ], [ 0, %78 ], !dbg !347
  %83 = icmp slt i64 %82, 3, !dbg !347
  br i1 %83, label %84, label %105, !dbg !347

84:                                               ; preds = %81
  %85 = add i64 %56, %79, !dbg !347
  %86 = add i64 %85, %82, !dbg !347
  %87 = mul nuw nsw i64 %62, 900, !dbg !347
  %88 = mul nuw nsw i64 %77, 30, !dbg !347
  %89 = add nuw nsw i64 %87, %88, !dbg !347
  %90 = add nuw nsw i64 %89, %86, !dbg !347
  %91 = getelementptr inbounds nuw float, ptr %15, i64 %90, !dbg !347
  %92 = load float, ptr %91, align 4, !dbg !347
  %93 = mul nuw nsw i64 %62, 9, !dbg !347
  %94 = mul nuw nsw i64 %73, 3, !dbg !347
  %95 = add nuw nsw i64 %93, %94, !dbg !347
  %96 = add nuw nsw i64 %95, %82, !dbg !347
  %97 = getelementptr inbounds nuw float, ptr %22, i64 %96, !dbg !347
  %98 = load float, ptr %97, align 4, !dbg !347
  %99 = add nuw nsw i64 0, %79, !dbg !347
  %100 = getelementptr inbounds nuw float, ptr %4, i64 %99, !dbg !347
  %101 = load float, ptr %100, align 4, !dbg !347
  %102 = fmul contract float %92, %98, !dbg !358
  %103 = fadd contract float %101, %102, !dbg !359
  store float %103, ptr %100, align 4, !dbg !347
  %104 = add i64 %82, 1, !dbg !347
  br label %81, !dbg !347

105:                                              ; preds = %81
  %106 = add i64 %79, 1, !dbg !347
  br label %78, !dbg !347

107:                                              ; preds = %78
  %108 = add i64 %73, 1, !dbg !347
  br label %72, !dbg !347

109:                                              ; preds = %72
  %110 = getelementptr float, ptr %4, i64 0, !dbg !360
  %111 = load <4 x float>, ptr %110, align 4, !dbg !360
  %112 = getelementptr float, ptr %29, i64 %62, !dbg !360
  %113 = load <1 x float>, ptr %112, align 4, !dbg !360
  %114 = extractelement <1 x float> %113, i64 0, !dbg !361
  %115 = insertelement <4 x float> poison, float %114, i32 0, !dbg !361
  %116 = shufflevector <4 x float> %115, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !361
  %117 = fadd contract <4 x float> %111, %116, !dbg !361
  %118 = fcmp ult <4 x float> %117, zeroinitializer, !dbg !362
  %119 = select <4 x i1> %118, <4 x float> zeroinitializer, <4 x float> %117, !dbg !363
  %120 = fcmp ugt <4 x float> %119, splat (float 6.000000e+00), !dbg !364
  %121 = select <4 x i1> %120, <4 x float> splat (float 6.000000e+00), <4 x float> %119, !dbg !365
  %122 = add i64 %49, %53, !dbg !347
  %123 = mul i64 %62, 784, !dbg !347
  %124 = mul i64 %122, 28, !dbg !347
  %125 = add i64 %123, %124, !dbg !347
  %126 = add i64 %125, %56, !dbg !347
  %127 = getelementptr float, ptr %34, i64 %126, !dbg !347
  store <4 x float> %121, ptr %127, align 4, !dbg !347
  %128 = add i64 %59, 1, !dbg !347
  br label %58, !dbg !347

129:                                              ; preds = %58
  %130 = add i64 %56, 4, !dbg !347
  br label %55, !dbg !347

131:                                              ; preds = %55
  %132 = add i64 %53, 1, !dbg !347
  br label %52, !dbg !347

133:                                              ; preds = %52
  ret i32 0, !dbg !366
}

define internal i32 @infer_dispatch_15_matmul_like_32x784x192_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !367 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !368
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !368
  %6 = load ptr, ptr %5, align 8, !dbg !368
  %7 = getelementptr float, ptr %6, i64 310784, !dbg !368
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !368
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !369
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !369
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !369
  %11 = load ptr, ptr %10, align 8, !dbg !369
  %12 = getelementptr float, ptr %11, i64 2093056, !dbg !369
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !369
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !370
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !370
  %15 = load ptr, ptr %14, align 8, !dbg !370
  %16 = getelementptr float, ptr %15, i64 112896, !dbg !370
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !370
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !371
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !371
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !371
  %20 = load ptr, ptr %19, align 8, !dbg !371
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !371
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !372
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !372
  %23 = zext i32 %22 to i64, !dbg !372
  %24 = mul nsw i64 %23, 56, !dbg !372
  br label %25, !dbg !372

25:                                               ; preds = %96, %3
  %26 = phi i64 [ %97, %96 ], [ 0, %3 ], !dbg !372
  %27 = icmp slt i64 %26, 32, !dbg !372
  br i1 %27, label %28, label %98, !dbg !372

28:                                               ; preds = %25
  %29 = getelementptr float, ptr @__constant_32xf32_2, i64 %26, !dbg !373
  %30 = load <1 x float>, ptr %29, align 4, !dbg !373
  br label %31, !dbg !372

31:                                               ; preds = %82, %28
  %32 = phi i64 [ %95, %82 ], [ 0, %28 ], !dbg !372
  %33 = icmp slt i64 %32, 56, !dbg !372
  br i1 %33, label %34, label %96, !dbg !372

34:                                               ; preds = %31
  %35 = add i64 %32, %24, !dbg !372
  br label %36, !dbg !372

36:                                               ; preds = %40, %34
  %37 = phi i64 [ %81, %40 ], [ 0, %34 ], !dbg !372
  %38 = phi <1 x float> [ %80, %40 ], [ zeroinitializer, %34 ], !dbg !372
  %39 = icmp slt i64 %37, 192, !dbg !372
  br i1 %39, label %40, label %82, !dbg !372

40:                                               ; preds = %36
  %41 = mul i64 %37, 784, !dbg !372
  %42 = add i64 %41, %35, !dbg !372
  %43 = getelementptr float, ptr %7, i64 %42, !dbg !372
  %44 = load <1 x float>, ptr %43, align 4, !dbg !372
  %45 = add i64 %37, 1, !dbg !372
  %46 = mul i64 %45, 784, !dbg !372
  %47 = add i64 %46, %35, !dbg !372
  %48 = getelementptr float, ptr %7, i64 %47, !dbg !372
  %49 = load <1 x float>, ptr %48, align 4, !dbg !372
  %50 = add i64 %37, 2, !dbg !372
  %51 = mul i64 %50, 784, !dbg !372
  %52 = add i64 %51, %35, !dbg !372
  %53 = getelementptr float, ptr %7, i64 %52, !dbg !372
  %54 = load <1 x float>, ptr %53, align 4, !dbg !372
  %55 = add i64 %37, 3, !dbg !372
  %56 = mul i64 %55, 784, !dbg !372
  %57 = add i64 %56, %35, !dbg !372
  %58 = getelementptr float, ptr %7, i64 %57, !dbg !372
  %59 = load <1 x float>, ptr %58, align 4, !dbg !372
  %60 = mul nuw nsw i64 %26, 192, !dbg !374
  %61 = add nuw nsw i64 %60, %37, !dbg !374
  %62 = getelementptr inbounds nuw float, ptr %12, i64 %61, !dbg !374
  %63 = load float, ptr %62, align 4, !dbg !374
  %64 = insertelement <1 x float> poison, float %63, i32 0, !dbg !374
  %65 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %64, <1 x float> %38), !dbg !374
  %66 = add nuw nsw i64 %60, %45, !dbg !374
  %67 = getelementptr inbounds nuw float, ptr %12, i64 %66, !dbg !374
  %68 = load float, ptr %67, align 4, !dbg !374
  %69 = insertelement <1 x float> poison, float %68, i32 0, !dbg !374
  %70 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %49, <1 x float> %69, <1 x float> %65), !dbg !374
  %71 = add nuw nsw i64 %60, %50, !dbg !374
  %72 = getelementptr inbounds nuw float, ptr %12, i64 %71, !dbg !374
  %73 = load float, ptr %72, align 4, !dbg !374
  %74 = insertelement <1 x float> poison, float %73, i32 0, !dbg !374
  %75 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %54, <1 x float> %74, <1 x float> %70), !dbg !374
  %76 = add nuw nsw i64 %60, %55, !dbg !374
  %77 = getelementptr inbounds nuw float, ptr %12, i64 %76, !dbg !374
  %78 = load float, ptr %77, align 4, !dbg !374
  %79 = insertelement <1 x float> poison, float %78, i32 0, !dbg !374
  %80 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %59, <1 x float> %79, <1 x float> %75), !dbg !374
  %81 = add i64 %37, 4, !dbg !372
  br label %36, !dbg !372

82:                                               ; preds = %36
  %83 = mul i64 %26, 784, !dbg !373
  %84 = add i64 %83, %35, !dbg !373
  %85 = getelementptr float, ptr %16, i64 %84, !dbg !373
  %86 = load <1 x float>, ptr %85, align 4, !dbg !373
  %87 = extractelement <1 x float> %38, i64 0, !dbg !375
  %88 = extractelement <1 x float> %30, i64 0, !dbg !375
  %89 = fadd contract float %87, %88, !dbg !375
  %90 = extractelement <1 x float> %86, i64 0, !dbg !376
  %91 = fadd contract float %89, %90, !dbg !376
  %92 = mul nuw nsw i64 %26, 784, !dbg !372
  %93 = add nuw nsw i64 %92, %35, !dbg !372
  %94 = getelementptr inbounds nuw float, ptr %20, i64 %93, !dbg !372
  store float %91, ptr %94, align 4, !dbg !372
  %95 = add i64 %32, 1, !dbg !372
  br label %31, !dbg !372

96:                                               ; preds = %31
  %97 = add i64 %26, 1, !dbg !372
  br label %25, !dbg !372

98:                                               ; preds = %25
  ret i32 0, !dbg !377
}

define internal i32 @infer_dispatch_18_matmul_like_32x784x192_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !378 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !379
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !379
  %6 = load ptr, ptr %5, align 8, !dbg !379
  %7 = getelementptr float, ptr %6, i64 310784, !dbg !379
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !379
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !380
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !380
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !380
  %11 = load ptr, ptr %10, align 8, !dbg !380
  %12 = getelementptr float, ptr %11, i64 2080768, !dbg !380
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !380
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !381
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !381
  %15 = load ptr, ptr %14, align 8, !dbg !381
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !381
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !382
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !382
  %18 = getelementptr ptr, ptr %17, i32 2, !dbg !382
  %19 = load ptr, ptr %18, align 8, !dbg !382
  %20 = getelementptr float, ptr %19, i64 25088, !dbg !382
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !382
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !383
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !383
  %23 = zext i32 %22 to i64, !dbg !383
  %24 = mul nsw i64 %23, 56, !dbg !383
  br label %25, !dbg !383

25:                                               ; preds = %96, %3
  %26 = phi i64 [ %97, %96 ], [ 0, %3 ], !dbg !383
  %27 = icmp slt i64 %26, 32, !dbg !383
  br i1 %27, label %28, label %98, !dbg !383

28:                                               ; preds = %25
  %29 = getelementptr float, ptr @__constant_32xf32_3, i64 %26, !dbg !384
  %30 = load <1 x float>, ptr %29, align 4, !dbg !384
  br label %31, !dbg !383

31:                                               ; preds = %82, %28
  %32 = phi i64 [ %95, %82 ], [ 0, %28 ], !dbg !383
  %33 = icmp slt i64 %32, 56, !dbg !383
  br i1 %33, label %34, label %96, !dbg !383

34:                                               ; preds = %31
  %35 = add i64 %32, %24, !dbg !383
  br label %36, !dbg !383

36:                                               ; preds = %40, %34
  %37 = phi i64 [ %81, %40 ], [ 0, %34 ], !dbg !383
  %38 = phi <1 x float> [ %80, %40 ], [ zeroinitializer, %34 ], !dbg !383
  %39 = icmp slt i64 %37, 192, !dbg !383
  br i1 %39, label %40, label %82, !dbg !383

40:                                               ; preds = %36
  %41 = mul i64 %37, 784, !dbg !383
  %42 = add i64 %41, %35, !dbg !383
  %43 = getelementptr float, ptr %7, i64 %42, !dbg !383
  %44 = load <1 x float>, ptr %43, align 4, !dbg !383
  %45 = add i64 %37, 1, !dbg !383
  %46 = mul i64 %45, 784, !dbg !383
  %47 = add i64 %46, %35, !dbg !383
  %48 = getelementptr float, ptr %7, i64 %47, !dbg !383
  %49 = load <1 x float>, ptr %48, align 4, !dbg !383
  %50 = add i64 %37, 2, !dbg !383
  %51 = mul i64 %50, 784, !dbg !383
  %52 = add i64 %51, %35, !dbg !383
  %53 = getelementptr float, ptr %7, i64 %52, !dbg !383
  %54 = load <1 x float>, ptr %53, align 4, !dbg !383
  %55 = add i64 %37, 3, !dbg !383
  %56 = mul i64 %55, 784, !dbg !383
  %57 = add i64 %56, %35, !dbg !383
  %58 = getelementptr float, ptr %7, i64 %57, !dbg !383
  %59 = load <1 x float>, ptr %58, align 4, !dbg !383
  %60 = mul nuw nsw i64 %26, 192, !dbg !385
  %61 = add nuw nsw i64 %60, %37, !dbg !385
  %62 = getelementptr inbounds nuw float, ptr %12, i64 %61, !dbg !385
  %63 = load float, ptr %62, align 4, !dbg !385
  %64 = insertelement <1 x float> poison, float %63, i32 0, !dbg !385
  %65 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %64, <1 x float> %38), !dbg !385
  %66 = add nuw nsw i64 %60, %45, !dbg !385
  %67 = getelementptr inbounds nuw float, ptr %12, i64 %66, !dbg !385
  %68 = load float, ptr %67, align 4, !dbg !385
  %69 = insertelement <1 x float> poison, float %68, i32 0, !dbg !385
  %70 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %49, <1 x float> %69, <1 x float> %65), !dbg !385
  %71 = add nuw nsw i64 %60, %50, !dbg !385
  %72 = getelementptr inbounds nuw float, ptr %12, i64 %71, !dbg !385
  %73 = load float, ptr %72, align 4, !dbg !385
  %74 = insertelement <1 x float> poison, float %73, i32 0, !dbg !385
  %75 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %54, <1 x float> %74, <1 x float> %70), !dbg !385
  %76 = add nuw nsw i64 %60, %55, !dbg !385
  %77 = getelementptr inbounds nuw float, ptr %12, i64 %76, !dbg !385
  %78 = load float, ptr %77, align 4, !dbg !385
  %79 = insertelement <1 x float> poison, float %78, i32 0, !dbg !385
  %80 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %59, <1 x float> %79, <1 x float> %75), !dbg !385
  %81 = add i64 %37, 4, !dbg !383
  br label %36, !dbg !383

82:                                               ; preds = %36
  %83 = mul i64 %26, 784, !dbg !384
  %84 = add i64 %83, %35, !dbg !384
  %85 = getelementptr float, ptr %15, i64 %84, !dbg !384
  %86 = load <1 x float>, ptr %85, align 4, !dbg !384
  %87 = extractelement <1 x float> %38, i64 0, !dbg !386
  %88 = extractelement <1 x float> %30, i64 0, !dbg !386
  %89 = fadd contract float %87, %88, !dbg !386
  %90 = extractelement <1 x float> %86, i64 0, !dbg !387
  %91 = fadd contract float %89, %90, !dbg !387
  %92 = mul nuw nsw i64 %26, 784, !dbg !383
  %93 = add nuw nsw i64 %92, %35, !dbg !383
  %94 = getelementptr inbounds nuw float, ptr %20, i64 %93, !dbg !383
  store float %91, ptr %94, align 4, !dbg !383
  %95 = add i64 %32, 1, !dbg !383
  br label %31, !dbg !383

96:                                               ; preds = %31
  %97 = add i64 %26, 1, !dbg !383
  br label %25, !dbg !383

98:                                               ; preds = %25
  ret i32 0, !dbg !388
}

define internal i32 @infer_dispatch_19_matmul_like_192x28x28x32_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !389 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !390
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !390
  %6 = load ptr, ptr %5, align 8, !dbg !390
  %7 = getelementptr float, ptr %6, i64 25088, !dbg !390
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !390
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !391
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !391
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !391
  %11 = load ptr, ptr %10, align 8, !dbg !391
  %12 = getelementptr float, ptr %11, i64 2074624, !dbg !391
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !391
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !392
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !392
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !392
  %16 = load ptr, ptr %15, align 8, !dbg !392
  %17 = getelementptr float, ptr %16, i64 2195040, !dbg !392
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !392
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !393
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !393
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !393
  %21 = load ptr, ptr %20, align 8, !dbg !393
  %22 = getelementptr float, ptr %21, i64 50176, !dbg !393
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !393
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !394
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !394
  %25 = zext i32 %24 to i64, !dbg !394
  %26 = sdiv i64 %25, 2, !dbg !394
  %27 = mul i64 %26, 2, !dbg !394
  %28 = icmp ne i64 %25, %27, !dbg !394
  %29 = icmp slt i64 %25, 0, !dbg !394
  %30 = and i1 %28, %29, !dbg !394
  %31 = add i64 %26, -1, !dbg !394
  %32 = select i1 %30, i64 %31, i64 %26, !dbg !394
  %33 = srem i64 %25, 2, !dbg !394
  %34 = icmp slt i64 %33, 0, !dbg !394
  %35 = add nsw i64 %33, 2, !dbg !394
  %36 = select i1 %34, i64 %35, i64 %33, !dbg !394
  %37 = mul nsw i64 %32, 24, !dbg !394
  %38 = mul nsw i64 %36, 14, !dbg !394
  br label %39, !dbg !394

39:                                               ; preds = %120, %3
  %40 = phi i64 [ %121, %120 ], [ 0, %3 ], !dbg !394
  %41 = icmp slt i64 %40, 24, !dbg !394
  br i1 %41, label %42, label %122, !dbg !394

42:                                               ; preds = %39
  %43 = add i64 %40, %37, !dbg !394
  %44 = getelementptr float, ptr %17, i64 %43, !dbg !395
  %45 = load <1 x float>, ptr %44, align 4, !dbg !395
  br label %46, !dbg !394

46:                                               ; preds = %118, %42
  %47 = phi i64 [ %119, %118 ], [ 0, %42 ], !dbg !394
  %48 = icmp slt i64 %47, 14, !dbg !394
  br i1 %48, label %49, label %120, !dbg !394

49:                                               ; preds = %104, %46
  %50 = phi i64 [ %117, %104 ], [ 0, %46 ], !dbg !394
  %51 = icmp slt i64 %50, 28, !dbg !394
  br i1 %51, label %52, label %118, !dbg !394

52:                                               ; preds = %56, %49
  %53 = phi i64 [ %103, %56 ], [ 0, %49 ], !dbg !394
  %54 = phi <1 x float> [ %102, %56 ], [ zeroinitializer, %49 ], !dbg !394
  %55 = icmp slt i64 %53, 32, !dbg !394
  br i1 %55, label %56, label %104, !dbg !394

56:                                               ; preds = %52
  %57 = add i64 %47, %38, !dbg !394
  %58 = mul i64 %53, 784, !dbg !394
  %59 = mul i64 %57, 28, !dbg !394
  %60 = add i64 %58, %59, !dbg !394
  %61 = add i64 %60, %50, !dbg !394
  %62 = getelementptr float, ptr %7, i64 %61, !dbg !394
  %63 = load <1 x float>, ptr %62, align 4, !dbg !394
  %64 = add i64 %53, 1, !dbg !394
  %65 = mul i64 %64, 784, !dbg !394
  %66 = add i64 %65, %59, !dbg !394
  %67 = add i64 %66, %50, !dbg !394
  %68 = getelementptr float, ptr %7, i64 %67, !dbg !394
  %69 = load <1 x float>, ptr %68, align 4, !dbg !394
  %70 = add i64 %53, 2, !dbg !394
  %71 = mul i64 %70, 784, !dbg !394
  %72 = add i64 %71, %59, !dbg !394
  %73 = add i64 %72, %50, !dbg !394
  %74 = getelementptr float, ptr %7, i64 %73, !dbg !394
  %75 = load <1 x float>, ptr %74, align 4, !dbg !394
  %76 = add i64 %53, 3, !dbg !394
  %77 = mul i64 %76, 784, !dbg !394
  %78 = add i64 %77, %59, !dbg !394
  %79 = add i64 %78, %50, !dbg !394
  %80 = getelementptr float, ptr %7, i64 %79, !dbg !394
  %81 = load <1 x float>, ptr %80, align 4, !dbg !394
  %82 = mul nuw nsw i64 %43, 32, !dbg !396
  %83 = add nuw nsw i64 %82, %53, !dbg !396
  %84 = getelementptr inbounds nuw float, ptr %12, i64 %83, !dbg !396
  %85 = load float, ptr %84, align 4, !dbg !396
  %86 = insertelement <1 x float> poison, float %85, i32 0, !dbg !396
  %87 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %86, <1 x float> %54), !dbg !396
  %88 = add nuw nsw i64 %82, %64, !dbg !396
  %89 = getelementptr inbounds nuw float, ptr %12, i64 %88, !dbg !396
  %90 = load float, ptr %89, align 4, !dbg !396
  %91 = insertelement <1 x float> poison, float %90, i32 0, !dbg !396
  %92 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %69, <1 x float> %91, <1 x float> %87), !dbg !396
  %93 = add nuw nsw i64 %82, %70, !dbg !396
  %94 = getelementptr inbounds nuw float, ptr %12, i64 %93, !dbg !396
  %95 = load float, ptr %94, align 4, !dbg !396
  %96 = insertelement <1 x float> poison, float %95, i32 0, !dbg !396
  %97 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %75, <1 x float> %96, <1 x float> %92), !dbg !396
  %98 = add nuw nsw i64 %82, %76, !dbg !396
  %99 = getelementptr inbounds nuw float, ptr %12, i64 %98, !dbg !396
  %100 = load float, ptr %99, align 4, !dbg !396
  %101 = insertelement <1 x float> poison, float %100, i32 0, !dbg !396
  %102 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %81, <1 x float> %101, <1 x float> %97), !dbg !396
  %103 = add i64 %53, 4, !dbg !394
  br label %52, !dbg !394

104:                                              ; preds = %52
  %105 = fadd contract <1 x float> %54, %45, !dbg !397
  %106 = fcmp ult <1 x float> %105, zeroinitializer, !dbg !398
  %107 = select <1 x i1> %106, <1 x float> zeroinitializer, <1 x float> %105, !dbg !399
  %108 = fcmp ugt <1 x float> %107, splat (float 6.000000e+00), !dbg !400
  %109 = select <1 x i1> %108, <1 x float> splat (float 6.000000e+00), <1 x float> %107, !dbg !401
  %110 = extractelement <1 x float> %109, i64 0, !dbg !394
  %111 = add i64 %38, %47, !dbg !394
  %112 = mul nuw nsw i64 %43, 841, !dbg !394
  %113 = mul nuw nsw i64 %111, 29, !dbg !394
  %114 = add nuw nsw i64 %112, %113, !dbg !394
  %115 = add nuw nsw i64 %114, %50, !dbg !394
  %116 = getelementptr inbounds nuw float, ptr %22, i64 %115, !dbg !394
  store float %110, ptr %116, align 4, !dbg !394
  %117 = add i64 %50, 1, !dbg !394
  br label %49, !dbg !394

118:                                              ; preds = %49
  %119 = add i64 %47, 1, !dbg !394
  br label %46, !dbg !394

120:                                              ; preds = %46
  %121 = add i64 %40, 1, !dbg !394
  br label %39, !dbg !394

122:                                              ; preds = %39
  ret i32 0, !dbg !402
}

define internal i32 @infer_dispatch_20_conv_14x14x192x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !403 {
  %4 = alloca float, i64 4, align 64, !dbg !404
  %5 = alloca float, i64 4, align 64, !dbg !404
  %6 = alloca float, i64 4, align 64, !dbg !405
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !406
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !406
  %9 = load ptr, ptr %8, align 8, !dbg !406
  %10 = getelementptr float, ptr %9, i64 50176, !dbg !406
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !406
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !407
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !407
  %13 = getelementptr ptr, ptr %12, i32 1, !dbg !407
  %14 = load ptr, ptr %13, align 8, !dbg !407
  %15 = getelementptr float, ptr %14, i64 2179968, !dbg !407
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !407
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !408
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !408
  %18 = getelementptr ptr, ptr %17, i32 1, !dbg !408
  %19 = load ptr, ptr %18, align 8, !dbg !408
  %20 = getelementptr float, ptr %19, i64 2195232, !dbg !408
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !408
  %21 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !409
  %22 = extractvalue %iree_hal_executable_dispatch_state_v0_t %21, 10, !dbg !409
  %23 = getelementptr ptr, ptr %22, i32 2, !dbg !409
  %24 = load ptr, ptr %23, align 8, !dbg !409
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !409
  %25 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !404
  %26 = extractvalue %iree_hal_executable_workgroup_state_v0_t %25, 0, !dbg !404
  %27 = zext i32 %26 to i64, !dbg !404
  %28 = sdiv i64 %27, 6, !dbg !404
  %29 = mul i64 %28, 6, !dbg !404
  %30 = icmp ne i64 %27, %29, !dbg !404
  %31 = icmp slt i64 %27, 0, !dbg !404
  %32 = and i1 %30, %31, !dbg !404
  %33 = add i64 %28, -1, !dbg !404
  %34 = select i1 %32, i64 %33, i64 %28, !dbg !404
  %35 = srem i64 %27, 6, !dbg !404
  %36 = icmp slt i64 %35, 0, !dbg !404
  %37 = add nsw i64 %35, 6, !dbg !404
  %38 = select i1 %36, i64 %37, i64 %35, !dbg !404
  %39 = mul nsw i64 %34, 7, !dbg !404
  %40 = mul nsw i64 %38, 32, !dbg !404
  br label %41, !dbg !404

41:                                               ; preds = %154, %3
  %42 = phi i64 [ %155, %154 ], [ 0, %3 ], !dbg !404
  %43 = icmp slt i64 %42, 7, !dbg !404
  br i1 %43, label %44, label %156, !dbg !404

44:                                               ; preds = %152, %41
  %45 = phi i64 [ %153, %152 ], [ 0, %41 ], !dbg !404
  %46 = icmp slt i64 %45, 14, !dbg !404
  br i1 %46, label %47, label %154, !dbg !404

47:                                               ; preds = %44
  %48 = sub i64 14, %45, !dbg !404
  %49 = icmp slt i64 %48, 4, !dbg !404
  %50 = select i1 %49, i64 %48, i64 4, !dbg !404
  %51 = trunc i64 %50 to i32, !dbg !410
  %52 = insertelement <4 x i32> poison, i32 %51, i32 0, !dbg !410
  %53 = shufflevector <4 x i32> %52, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !410
  %54 = icmp sgt <4 x i32> %53, <i32 0, i32 1, i32 2, i32 3>, !dbg !410
  %55 = getelementptr float, ptr %6, i64 0, !dbg !410
  call void @llvm.masked.store.v4f32.p0(<4 x float> zeroinitializer, ptr align 4 %55, <4 x i1> %54), !dbg !410
  %56 = mul nsw i64 %45, 2, !dbg !404
  br label %57, !dbg !404

57:                                               ; preds = %150, %47
  %58 = phi i64 [ %151, %150 ], [ 0, %47 ], !dbg !404
  %59 = icmp slt i64 %58, 32, !dbg !404
  br i1 %59, label %60, label %152, !dbg !404

60:                                               ; preds = %57
  %61 = add i64 %58, %40, !dbg !404
  br label %62, !dbg !404

62:                                               ; preds = %65, %60
  %63 = phi i64 [ %70, %65 ], [ 0, %60 ], !dbg !404
  %64 = icmp slt i64 %63, %50, !dbg !404
  br i1 %64, label %65, label %71, !dbg !404

65:                                               ; preds = %62
  %66 = add nuw nsw i64 0, %63, !dbg !404
  %67 = getelementptr inbounds nuw float, ptr %6, i64 %66, !dbg !404
  %68 = load float, ptr %67, align 4, !dbg !404
  %69 = getelementptr inbounds nuw float, ptr %5, i64 %66, !dbg !404
  store float %68, ptr %69, align 4, !dbg !404
  %70 = add i64 %63, 1, !dbg !404
  br label %62, !dbg !404

71:                                               ; preds = %109, %62
  %72 = phi i64 [ %110, %109 ], [ 0, %62 ], !dbg !404
  %73 = icmp slt i64 %72, 3, !dbg !404
  br i1 %73, label %74, label %111, !dbg !404

74:                                               ; preds = %71
  %75 = mul nsw i64 %42, 2, !dbg !404
  %76 = mul nsw i64 %34, 14, !dbg !404
  %77 = add i64 %75, %76, !dbg !404
  %78 = add i64 %77, %72, !dbg !404
  br label %79, !dbg !404

79:                                               ; preds = %107, %74
  %80 = phi i64 [ %108, %107 ], [ 0, %74 ], !dbg !404
  %81 = icmp slt i64 %80, %50, !dbg !404
  br i1 %81, label %82, label %109, !dbg !404

82:                                               ; preds = %85, %79
  %83 = phi i64 [ %106, %85 ], [ 0, %79 ], !dbg !404
  %84 = icmp slt i64 %83, 3, !dbg !404
  br i1 %84, label %85, label %107, !dbg !404

85:                                               ; preds = %82
  %86 = mul nsw i64 %80, 2, !dbg !404
  %87 = add i64 %56, %86, !dbg !404
  %88 = add i64 %87, %83, !dbg !404
  %89 = mul nuw nsw i64 %61, 841, !dbg !404
  %90 = mul nuw nsw i64 %78, 29, !dbg !404
  %91 = add nuw nsw i64 %89, %90, !dbg !404
  %92 = add nuw nsw i64 %91, %88, !dbg !404
  %93 = getelementptr inbounds nuw float, ptr %10, i64 %92, !dbg !404
  %94 = load float, ptr %93, align 4, !dbg !404
  %95 = mul nuw nsw i64 %61, 9, !dbg !404
  %96 = mul nuw nsw i64 %72, 3, !dbg !404
  %97 = add nuw nsw i64 %95, %96, !dbg !404
  %98 = add nuw nsw i64 %97, %83, !dbg !404
  %99 = getelementptr inbounds nuw float, ptr %15, i64 %98, !dbg !404
  %100 = load float, ptr %99, align 4, !dbg !404
  %101 = add nuw nsw i64 0, %80, !dbg !404
  %102 = getelementptr inbounds nuw float, ptr %5, i64 %101, !dbg !404
  %103 = load float, ptr %102, align 4, !dbg !404
  %104 = fmul contract float %94, %100, !dbg !411
  %105 = fadd contract float %103, %104, !dbg !412
  store float %105, ptr %102, align 4, !dbg !404
  %106 = add i64 %83, 1, !dbg !404
  br label %82, !dbg !404

107:                                              ; preds = %82
  %108 = add i64 %80, 1, !dbg !404
  br label %79, !dbg !404

109:                                              ; preds = %79
  %110 = add i64 %72, 1, !dbg !404
  br label %71, !dbg !404

111:                                              ; preds = %114, %71
  %112 = phi i64 [ %119, %114 ], [ 0, %71 ], !dbg !404
  %113 = icmp slt i64 %112, %50, !dbg !404
  br i1 %113, label %114, label %120, !dbg !404

114:                                              ; preds = %111
  %115 = add nuw nsw i64 0, %112, !dbg !404
  %116 = getelementptr inbounds nuw float, ptr %6, i64 %115, !dbg !404
  %117 = load float, ptr %116, align 4, !dbg !404
  %118 = getelementptr inbounds nuw float, ptr %4, i64 %115, !dbg !404
  store float %117, ptr %118, align 4, !dbg !404
  %119 = add i64 %112, 1, !dbg !404
  br label %111, !dbg !404

120:                                              ; preds = %123, %111
  %121 = phi i64 [ %128, %123 ], [ 0, %111 ], !dbg !404
  %122 = icmp slt i64 %121, %50, !dbg !404
  br i1 %122, label %123, label %129, !dbg !404

123:                                              ; preds = %120
  %124 = add nuw nsw i64 0, %121, !dbg !404
  %125 = getelementptr inbounds nuw float, ptr %5, i64 %124, !dbg !404
  %126 = load float, ptr %125, align 4, !dbg !404
  %127 = getelementptr inbounds nuw float, ptr %4, i64 %124, !dbg !404
  store float %126, ptr %127, align 4, !dbg !404
  %128 = add i64 %121, 1, !dbg !404
  br label %120, !dbg !404

129:                                              ; preds = %120
  %130 = icmp sgt i64 %50, 0, !dbg !413
  br i1 %130, label %131, label %150, !dbg !413

131:                                              ; preds = %129
  %132 = getelementptr float, ptr %4, i64 0, !dbg !413
  %133 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %132, <4 x i1> %54, <4 x float> poison), !dbg !413
  %134 = getelementptr float, ptr %20, i64 %61, !dbg !413
  %135 = load <1 x float>, ptr %134, align 4, !dbg !413
  %136 = extractelement <1 x float> %135, i64 0, !dbg !414
  %137 = insertelement <4 x float> poison, float %136, i32 0, !dbg !414
  %138 = shufflevector <4 x float> %137, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !414
  %139 = fadd contract <4 x float> %133, %138, !dbg !414
  %140 = fcmp ult <4 x float> %139, zeroinitializer, !dbg !415
  %141 = select <4 x i1> %140, <4 x float> zeroinitializer, <4 x float> %139, !dbg !416
  %142 = fcmp ugt <4 x float> %141, splat (float 6.000000e+00), !dbg !417
  %143 = select <4 x i1> %142, <4 x float> splat (float 6.000000e+00), <4 x float> %141, !dbg !418
  %144 = add i64 %39, %42, !dbg !418
  %145 = mul i64 %61, 196, !dbg !418
  %146 = mul i64 %144, 14, !dbg !418
  %147 = add i64 %145, %146, !dbg !418
  %148 = add i64 %147, %45, !dbg !418
  %149 = getelementptr float, ptr %24, i64 %148, !dbg !418
  call void @llvm.masked.store.v4f32.p0(<4 x float> %143, ptr align 4 %149, <4 x i1> %54), !dbg !418
  br label %150, !dbg !413

150:                                              ; preds = %131, %129
  %151 = add i64 %58, 1, !dbg !404
  br label %57, !dbg !404

152:                                              ; preds = %57
  %153 = add i64 %45, 4, !dbg !404
  br label %44, !dbg !404

154:                                              ; preds = %44
  %155 = add i64 %42, 1, !dbg !404
  br label %41, !dbg !404

156:                                              ; preds = %41
  ret i32 0, !dbg !419
}

define internal i32 @infer_dispatch_21_matmul_like_64x196x192_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !420 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !421
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !421
  %6 = load ptr, ptr %5, align 8, !dbg !421
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !421
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !422
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !422
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !422
  %10 = load ptr, ptr %9, align 8, !dbg !422
  %11 = getelementptr float, ptr %10, i64 2062336, !dbg !422
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !422
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !423
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !423
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !423
  %15 = load ptr, ptr %14, align 8, !dbg !423
  %16 = getelementptr float, ptr %15, i64 37632, !dbg !423
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !423
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !424
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !424
  %19 = zext i32 %18 to i64, !dbg !424
  %20 = sdiv i64 %19, 4, !dbg !424
  %21 = mul i64 %20, 4, !dbg !424
  %22 = icmp ne i64 %19, %21, !dbg !424
  %23 = icmp slt i64 %19, 0, !dbg !424
  %24 = and i1 %22, %23, !dbg !424
  %25 = add i64 %20, -1, !dbg !424
  %26 = select i1 %24, i64 %25, i64 %20, !dbg !424
  %27 = srem i64 %19, 4, !dbg !424
  %28 = icmp slt i64 %27, 0, !dbg !424
  %29 = add nsw i64 %27, 4, !dbg !424
  %30 = select i1 %28, i64 %29, i64 %27, !dbg !424
  %31 = mul nsw i64 %26, 16, !dbg !424
  %32 = mul nsw i64 %30, 49, !dbg !424
  br label %33, !dbg !424

33:                                               ; preds = %99, %3
  %34 = phi i64 [ %100, %99 ], [ 0, %3 ], !dbg !424
  %35 = icmp slt i64 %34, 16, !dbg !424
  br i1 %35, label %36, label %101, !dbg !424

36:                                               ; preds = %33
  %37 = add i64 %34, %31, !dbg !424
  %38 = getelementptr float, ptr @__constant_64xf32, i64 %37, !dbg !425
  %39 = load <1 x float>, ptr %38, align 4, !dbg !425
  br label %40, !dbg !424

40:                                               ; preds = %91, %36
  %41 = phi i64 [ %98, %91 ], [ 0, %36 ], !dbg !424
  %42 = icmp slt i64 %41, 49, !dbg !424
  br i1 %42, label %43, label %99, !dbg !424

43:                                               ; preds = %40
  %44 = add i64 %41, %32, !dbg !424
  br label %45, !dbg !424

45:                                               ; preds = %49, %43
  %46 = phi i64 [ %90, %49 ], [ 0, %43 ], !dbg !424
  %47 = phi <1 x float> [ %89, %49 ], [ zeroinitializer, %43 ], !dbg !424
  %48 = icmp slt i64 %46, 192, !dbg !424
  br i1 %48, label %49, label %91, !dbg !424

49:                                               ; preds = %45
  %50 = mul i64 %46, 196, !dbg !424
  %51 = add i64 %50, %44, !dbg !424
  %52 = getelementptr float, ptr %6, i64 %51, !dbg !424
  %53 = load <1 x float>, ptr %52, align 4, !dbg !424
  %54 = add i64 %46, 1, !dbg !424
  %55 = mul i64 %54, 196, !dbg !424
  %56 = add i64 %55, %44, !dbg !424
  %57 = getelementptr float, ptr %6, i64 %56, !dbg !424
  %58 = load <1 x float>, ptr %57, align 4, !dbg !424
  %59 = add i64 %46, 2, !dbg !424
  %60 = mul i64 %59, 196, !dbg !424
  %61 = add i64 %60, %44, !dbg !424
  %62 = getelementptr float, ptr %6, i64 %61, !dbg !424
  %63 = load <1 x float>, ptr %62, align 4, !dbg !424
  %64 = add i64 %46, 3, !dbg !424
  %65 = mul i64 %64, 196, !dbg !424
  %66 = add i64 %65, %44, !dbg !424
  %67 = getelementptr float, ptr %6, i64 %66, !dbg !424
  %68 = load <1 x float>, ptr %67, align 4, !dbg !424
  %69 = mul nuw nsw i64 %37, 192, !dbg !426
  %70 = add nuw nsw i64 %69, %46, !dbg !426
  %71 = getelementptr inbounds nuw float, ptr %11, i64 %70, !dbg !426
  %72 = load float, ptr %71, align 4, !dbg !426
  %73 = insertelement <1 x float> poison, float %72, i32 0, !dbg !426
  %74 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %53, <1 x float> %73, <1 x float> %47), !dbg !426
  %75 = add nuw nsw i64 %69, %54, !dbg !426
  %76 = getelementptr inbounds nuw float, ptr %11, i64 %75, !dbg !426
  %77 = load float, ptr %76, align 4, !dbg !426
  %78 = insertelement <1 x float> poison, float %77, i32 0, !dbg !426
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %58, <1 x float> %78, <1 x float> %74), !dbg !426
  %80 = add nuw nsw i64 %69, %59, !dbg !426
  %81 = getelementptr inbounds nuw float, ptr %11, i64 %80, !dbg !426
  %82 = load float, ptr %81, align 4, !dbg !426
  %83 = insertelement <1 x float> poison, float %82, i32 0, !dbg !426
  %84 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %83, <1 x float> %79), !dbg !426
  %85 = add nuw nsw i64 %69, %64, !dbg !426
  %86 = getelementptr inbounds nuw float, ptr %11, i64 %85, !dbg !426
  %87 = load float, ptr %86, align 4, !dbg !426
  %88 = insertelement <1 x float> poison, float %87, i32 0, !dbg !426
  %89 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %88, <1 x float> %84), !dbg !426
  %90 = add i64 %46, 4, !dbg !424
  br label %45, !dbg !424

91:                                               ; preds = %45
  %92 = extractelement <1 x float> %47, i64 0, !dbg !427
  %93 = extractelement <1 x float> %39, i64 0, !dbg !427
  %94 = fadd contract float %92, %93, !dbg !427
  %95 = mul nuw nsw i64 %37, 196, !dbg !424
  %96 = add nuw nsw i64 %95, %44, !dbg !424
  %97 = getelementptr inbounds nuw float, ptr %16, i64 %96, !dbg !424
  store float %94, ptr %97, align 4, !dbg !424
  %98 = add i64 %41, 1, !dbg !424
  br label %40, !dbg !424

99:                                               ; preds = %40
  %100 = add i64 %34, 1, !dbg !424
  br label %33, !dbg !424

101:                                              ; preds = %33
  ret i32 0, !dbg !428
}

define internal i32 @infer_dispatch_22_matmul_like_384x14x14x64_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !429 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !430
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !430
  %6 = load i32, ptr %5, align 4, !dbg !430
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !431
  %8 = load i32, ptr %7, align 4, !dbg !431
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !432
  %10 = load i32, ptr %9, align 4, !dbg !432
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !433
  %12 = load i32, ptr %11, align 4, !dbg !433
  %13 = zext i32 %6 to i64, !dbg !434
  %14 = zext i32 %8 to i64, !dbg !435
  %15 = zext i32 %10 to i64, !dbg !436
  %16 = zext i32 %12 to i64, !dbg !437
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !438
  %18 = load ptr, ptr %17, align 8, !dbg !438
  %19 = mul i64 %13, 8, !dbg !438
  %20 = udiv i64 %19, 32, !dbg !438
  %21 = getelementptr float, ptr %18, i64 %20, !dbg !438
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !438
  %22 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !439
  %23 = extractvalue %iree_hal_executable_dispatch_state_v0_t %22, 10, !dbg !439
  %24 = getelementptr ptr, ptr %23, i32 1, !dbg !439
  %25 = load ptr, ptr %24, align 8, !dbg !439
  %26 = mul i64 %14, 8, !dbg !439
  %27 = udiv i64 %26, 32, !dbg !439
  %28 = getelementptr float, ptr %25, i64 %27, !dbg !439
  call void @llvm.assume(i1 true) [ "align"(ptr %28, i64 64) ], !dbg !439
  %29 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !440
  %30 = extractvalue %iree_hal_executable_dispatch_state_v0_t %29, 10, !dbg !440
  %31 = getelementptr ptr, ptr %30, i32 1, !dbg !440
  %32 = load ptr, ptr %31, align 8, !dbg !440
  %33 = mul i64 %15, 8, !dbg !440
  %34 = udiv i64 %33, 32, !dbg !440
  %35 = getelementptr float, ptr %32, i64 %34, !dbg !440
  call void @llvm.assume(i1 true) [ "align"(ptr %35, i64 64) ], !dbg !440
  %36 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !441
  %37 = extractvalue %iree_hal_executable_dispatch_state_v0_t %36, 10, !dbg !441
  %38 = getelementptr ptr, ptr %37, i32 2, !dbg !441
  %39 = load ptr, ptr %38, align 8, !dbg !441
  %40 = mul i64 %16, 8, !dbg !441
  %41 = udiv i64 %40, 32, !dbg !441
  %42 = getelementptr float, ptr %39, i64 %41, !dbg !441
  call void @llvm.assume(i1 true) [ "align"(ptr %42, i64 64) ], !dbg !441
  %43 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !442
  %44 = extractvalue %iree_hal_executable_workgroup_state_v0_t %43, 0, !dbg !442
  %45 = zext i32 %44 to i64, !dbg !442
  %46 = sdiv i64 %45, 2, !dbg !442
  %47 = mul i64 %46, 2, !dbg !442
  %48 = icmp ne i64 %45, %47, !dbg !442
  %49 = icmp slt i64 %45, 0, !dbg !442
  %50 = and i1 %48, %49, !dbg !442
  %51 = add i64 %46, -1, !dbg !442
  %52 = select i1 %50, i64 %51, i64 %46, !dbg !442
  %53 = srem i64 %45, 2, !dbg !442
  %54 = icmp slt i64 %53, 0, !dbg !442
  %55 = add nsw i64 %53, 2, !dbg !442
  %56 = select i1 %54, i64 %55, i64 %53, !dbg !442
  %57 = mul nsw i64 %52, 48, !dbg !442
  %58 = mul nsw i64 %56, 7, !dbg !442
  br label %59, !dbg !442

59:                                               ; preds = %141, %3
  %60 = phi i64 [ %142, %141 ], [ 0, %3 ], !dbg !442
  %61 = icmp slt i64 %60, 48, !dbg !442
  br i1 %61, label %62, label %143, !dbg !442

62:                                               ; preds = %59
  %63 = add i64 %60, %57, !dbg !442
  %64 = getelementptr float, ptr %35, i64 %63, !dbg !443
  %65 = load <1 x float>, ptr %64, align 4, !dbg !443
  br label %66, !dbg !442

66:                                               ; preds = %139, %62
  %67 = phi i64 [ %140, %139 ], [ 0, %62 ], !dbg !442
  %68 = icmp slt i64 %67, 7, !dbg !442
  br i1 %68, label %69, label %141, !dbg !442

69:                                               ; preds = %124, %66
  %70 = phi i64 [ %133, %124 ], [ 0, %66 ], !dbg !442
  %71 = icmp slt i64 %70, 14, !dbg !442
  br i1 %71, label %72, label %139, !dbg !442

72:                                               ; preds = %76, %69
  %73 = phi i64 [ %123, %76 ], [ 0, %69 ], !dbg !442
  %74 = phi <1 x float> [ %122, %76 ], [ zeroinitializer, %69 ], !dbg !442
  %75 = icmp slt i64 %73, 64, !dbg !442
  br i1 %75, label %76, label %124, !dbg !442

76:                                               ; preds = %72
  %77 = add i64 %67, %58, !dbg !442
  %78 = mul i64 %73, 196, !dbg !442
  %79 = mul i64 %77, 14, !dbg !442
  %80 = add i64 %78, %79, !dbg !442
  %81 = add i64 %80, %70, !dbg !442
  %82 = getelementptr float, ptr %21, i64 %81, !dbg !442
  %83 = load <1 x float>, ptr %82, align 4, !dbg !442
  %84 = add i64 %73, 1, !dbg !442
  %85 = mul i64 %84, 196, !dbg !442
  %86 = add i64 %85, %79, !dbg !442
  %87 = add i64 %86, %70, !dbg !442
  %88 = getelementptr float, ptr %21, i64 %87, !dbg !442
  %89 = load <1 x float>, ptr %88, align 4, !dbg !442
  %90 = add i64 %73, 2, !dbg !442
  %91 = mul i64 %90, 196, !dbg !442
  %92 = add i64 %91, %79, !dbg !442
  %93 = add i64 %92, %70, !dbg !442
  %94 = getelementptr float, ptr %21, i64 %93, !dbg !442
  %95 = load <1 x float>, ptr %94, align 4, !dbg !442
  %96 = add i64 %73, 3, !dbg !442
  %97 = mul i64 %96, 196, !dbg !442
  %98 = add i64 %97, %79, !dbg !442
  %99 = add i64 %98, %70, !dbg !442
  %100 = getelementptr float, ptr %21, i64 %99, !dbg !442
  %101 = load <1 x float>, ptr %100, align 4, !dbg !442
  %102 = mul nuw nsw i64 %63, 64, !dbg !444
  %103 = add nuw nsw i64 %102, %73, !dbg !444
  %104 = getelementptr inbounds nuw float, ptr %28, i64 %103, !dbg !444
  %105 = load float, ptr %104, align 4, !dbg !444
  %106 = insertelement <1 x float> poison, float %105, i32 0, !dbg !444
  %107 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %83, <1 x float> %106, <1 x float> %74), !dbg !444
  %108 = add nuw nsw i64 %102, %84, !dbg !444
  %109 = getelementptr inbounds nuw float, ptr %28, i64 %108, !dbg !444
  %110 = load float, ptr %109, align 4, !dbg !444
  %111 = insertelement <1 x float> poison, float %110, i32 0, !dbg !444
  %112 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %89, <1 x float> %111, <1 x float> %107), !dbg !444
  %113 = add nuw nsw i64 %102, %90, !dbg !444
  %114 = getelementptr inbounds nuw float, ptr %28, i64 %113, !dbg !444
  %115 = load float, ptr %114, align 4, !dbg !444
  %116 = insertelement <1 x float> poison, float %115, i32 0, !dbg !444
  %117 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %95, <1 x float> %116, <1 x float> %112), !dbg !444
  %118 = add nuw nsw i64 %102, %96, !dbg !444
  %119 = getelementptr inbounds nuw float, ptr %28, i64 %118, !dbg !444
  %120 = load float, ptr %119, align 4, !dbg !444
  %121 = insertelement <1 x float> poison, float %120, i32 0, !dbg !444
  %122 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %101, <1 x float> %121, <1 x float> %117), !dbg !444
  %123 = add i64 %73, 4, !dbg !442
  br label %72, !dbg !442

124:                                              ; preds = %72
  %125 = fadd contract <1 x float> %74, %65, !dbg !445
  %126 = fcmp ult <1 x float> %125, zeroinitializer, !dbg !446
  %127 = select <1 x i1> %126, <1 x float> zeroinitializer, <1 x float> %125, !dbg !447
  %128 = fcmp ugt <1 x float> %127, splat (float 6.000000e+00), !dbg !448
  %129 = select <1 x i1> %128, <1 x float> splat (float 6.000000e+00), <1 x float> %127, !dbg !449
  %130 = extractelement <1 x float> %129, i64 0, !dbg !442
  %131 = add i64 %58, %67, !dbg !442
  %132 = add i64 %131, 1, !dbg !442
  %133 = add i64 %70, 1, !dbg !442
  %134 = mul nuw nsw i64 %63, 256, !dbg !442
  %135 = mul nuw nsw i64 %132, 16, !dbg !442
  %136 = add nuw nsw i64 %134, %135, !dbg !442
  %137 = add nuw nsw i64 %136, %133, !dbg !442
  %138 = getelementptr inbounds nuw float, ptr %42, i64 %137, !dbg !442
  store float %130, ptr %138, align 4, !dbg !442
  br label %69, !dbg !442

139:                                              ; preds = %69
  %140 = add i64 %67, 1, !dbg !442
  br label %66, !dbg !442

141:                                              ; preds = %66
  %142 = add i64 %60, 1, !dbg !442
  br label %59, !dbg !442

143:                                              ; preds = %59
  ret i32 0, !dbg !450
}

define internal i32 @infer_dispatch_23_conv_14x14x384x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !451 {
  %4 = alloca float, i64 4, align 64, !dbg !452
  %5 = alloca float, i64 4, align 64, !dbg !452
  %6 = alloca float, i64 4, align 64, !dbg !453
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !454
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 9, !dbg !454
  %9 = load i32, ptr %8, align 4, !dbg !454
  %10 = getelementptr i32, ptr %8, i32 1, !dbg !455
  %11 = load i32, ptr %10, align 4, !dbg !455
  %12 = getelementptr i32, ptr %8, i32 2, !dbg !456
  %13 = load i32, ptr %12, align 4, !dbg !456
  %14 = getelementptr i32, ptr %8, i32 3, !dbg !457
  %15 = load i32, ptr %14, align 4, !dbg !457
  %16 = zext i32 %9 to i64, !dbg !458
  %17 = zext i32 %11 to i64, !dbg !459
  %18 = zext i32 %13 to i64, !dbg !460
  %19 = zext i32 %15 to i64, !dbg !461
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !462
  %21 = load ptr, ptr %20, align 8, !dbg !462
  %22 = mul i64 %16, 8, !dbg !462
  %23 = udiv i64 %22, 32, !dbg !462
  %24 = getelementptr float, ptr %21, i64 %23, !dbg !462
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !462
  %25 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !463
  %26 = extractvalue %iree_hal_executable_dispatch_state_v0_t %25, 10, !dbg !463
  %27 = getelementptr ptr, ptr %26, i32 1, !dbg !463
  %28 = load ptr, ptr %27, align 8, !dbg !463
  %29 = mul i64 %17, 8, !dbg !463
  %30 = udiv i64 %29, 32, !dbg !463
  %31 = getelementptr float, ptr %28, i64 %30, !dbg !463
  call void @llvm.assume(i1 true) [ "align"(ptr %31, i64 64) ], !dbg !463
  %32 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !464
  %33 = extractvalue %iree_hal_executable_dispatch_state_v0_t %32, 10, !dbg !464
  %34 = getelementptr ptr, ptr %33, i32 1, !dbg !464
  %35 = load ptr, ptr %34, align 8, !dbg !464
  %36 = mul i64 %18, 8, !dbg !464
  %37 = udiv i64 %36, 32, !dbg !464
  %38 = getelementptr float, ptr %35, i64 %37, !dbg !464
  call void @llvm.assume(i1 true) [ "align"(ptr %38, i64 64) ], !dbg !464
  %39 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !465
  %40 = extractvalue %iree_hal_executable_dispatch_state_v0_t %39, 10, !dbg !465
  %41 = getelementptr ptr, ptr %40, i32 2, !dbg !465
  %42 = load ptr, ptr %41, align 8, !dbg !465
  %43 = mul i64 %19, 8, !dbg !465
  %44 = udiv i64 %43, 32, !dbg !465
  %45 = getelementptr float, ptr %42, i64 %44, !dbg !465
  call void @llvm.assume(i1 true) [ "align"(ptr %45, i64 64) ], !dbg !465
  %46 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !452
  %47 = extractvalue %iree_hal_executable_workgroup_state_v0_t %46, 0, !dbg !452
  %48 = zext i32 %47 to i64, !dbg !452
  %49 = mul nsw i64 %48, 32, !dbg !452
  br label %50, !dbg !452

50:                                               ; preds = %157, %3
  %51 = phi i64 [ %158, %157 ], [ 0, %3 ], !dbg !452
  %52 = icmp slt i64 %51, 14, !dbg !452
  br i1 %52, label %53, label %159, !dbg !452

53:                                               ; preds = %155, %50
  %54 = phi i64 [ %156, %155 ], [ 0, %50 ], !dbg !452
  %55 = icmp slt i64 %54, 14, !dbg !452
  br i1 %55, label %56, label %157, !dbg !452

56:                                               ; preds = %53
  %57 = sub i64 14, %54, !dbg !452
  %58 = icmp slt i64 %57, 4, !dbg !452
  %59 = select i1 %58, i64 %57, i64 4, !dbg !452
  %60 = trunc i64 %59 to i32, !dbg !466
  %61 = insertelement <4 x i32> poison, i32 %60, i32 0, !dbg !466
  %62 = shufflevector <4 x i32> %61, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !466
  %63 = icmp sgt <4 x i32> %62, <i32 0, i32 1, i32 2, i32 3>, !dbg !466
  %64 = getelementptr float, ptr %6, i64 0, !dbg !466
  call void @llvm.masked.store.v4f32.p0(<4 x float> zeroinitializer, ptr align 4 %64, <4 x i1> %63), !dbg !466
  br label %65, !dbg !452

65:                                               ; preds = %153, %56
  %66 = phi i64 [ %154, %153 ], [ 0, %56 ], !dbg !452
  %67 = icmp slt i64 %66, 32, !dbg !452
  br i1 %67, label %68, label %155, !dbg !452

68:                                               ; preds = %65
  %69 = add i64 %66, %49, !dbg !452
  br label %70, !dbg !452

70:                                               ; preds = %73, %68
  %71 = phi i64 [ %78, %73 ], [ 0, %68 ], !dbg !452
  %72 = icmp slt i64 %71, %59, !dbg !452
  br i1 %72, label %73, label %79, !dbg !452

73:                                               ; preds = %70
  %74 = add nuw nsw i64 0, %71, !dbg !452
  %75 = getelementptr inbounds nuw float, ptr %6, i64 %74, !dbg !452
  %76 = load float, ptr %75, align 4, !dbg !452
  %77 = getelementptr inbounds nuw float, ptr %5, i64 %74, !dbg !452
  store float %76, ptr %77, align 4, !dbg !452
  %78 = add i64 %71, 1, !dbg !452
  br label %70, !dbg !452

79:                                               ; preds = %113, %70
  %80 = phi i64 [ %114, %113 ], [ 0, %70 ], !dbg !452
  %81 = icmp slt i64 %80, 3, !dbg !452
  br i1 %81, label %82, label %115, !dbg !452

82:                                               ; preds = %79
  %83 = add i64 %80, %51, !dbg !452
  br label %84, !dbg !452

84:                                               ; preds = %111, %82
  %85 = phi i64 [ %112, %111 ], [ 0, %82 ], !dbg !452
  %86 = icmp slt i64 %85, %59, !dbg !452
  br i1 %86, label %87, label %113, !dbg !452

87:                                               ; preds = %90, %84
  %88 = phi i64 [ %110, %90 ], [ 0, %84 ], !dbg !452
  %89 = icmp slt i64 %88, 3, !dbg !452
  br i1 %89, label %90, label %111, !dbg !452

90:                                               ; preds = %87
  %91 = add i64 %54, %85, !dbg !452
  %92 = add i64 %91, %88, !dbg !452
  %93 = mul nuw nsw i64 %69, 256, !dbg !452
  %94 = mul nuw nsw i64 %83, 16, !dbg !452
  %95 = add nuw nsw i64 %93, %94, !dbg !452
  %96 = add nuw nsw i64 %95, %92, !dbg !452
  %97 = getelementptr inbounds nuw float, ptr %24, i64 %96, !dbg !452
  %98 = load float, ptr %97, align 4, !dbg !452
  %99 = mul nuw nsw i64 %69, 9, !dbg !452
  %100 = mul nuw nsw i64 %80, 3, !dbg !452
  %101 = add nuw nsw i64 %99, %100, !dbg !452
  %102 = add nuw nsw i64 %101, %88, !dbg !452
  %103 = getelementptr inbounds nuw float, ptr %31, i64 %102, !dbg !452
  %104 = load float, ptr %103, align 4, !dbg !452
  %105 = add nuw nsw i64 0, %85, !dbg !452
  %106 = getelementptr inbounds nuw float, ptr %5, i64 %105, !dbg !452
  %107 = load float, ptr %106, align 4, !dbg !452
  %108 = fmul contract float %98, %104, !dbg !467
  %109 = fadd contract float %107, %108, !dbg !468
  store float %109, ptr %106, align 4, !dbg !452
  %110 = add i64 %88, 1, !dbg !452
  br label %87, !dbg !452

111:                                              ; preds = %87
  %112 = add i64 %85, 1, !dbg !452
  br label %84, !dbg !452

113:                                              ; preds = %84
  %114 = add i64 %80, 1, !dbg !452
  br label %79, !dbg !452

115:                                              ; preds = %118, %79
  %116 = phi i64 [ %123, %118 ], [ 0, %79 ], !dbg !452
  %117 = icmp slt i64 %116, %59, !dbg !452
  br i1 %117, label %118, label %124, !dbg !452

118:                                              ; preds = %115
  %119 = add nuw nsw i64 0, %116, !dbg !452
  %120 = getelementptr inbounds nuw float, ptr %6, i64 %119, !dbg !452
  %121 = load float, ptr %120, align 4, !dbg !452
  %122 = getelementptr inbounds nuw float, ptr %4, i64 %119, !dbg !452
  store float %121, ptr %122, align 4, !dbg !452
  %123 = add i64 %116, 1, !dbg !452
  br label %115, !dbg !452

124:                                              ; preds = %127, %115
  %125 = phi i64 [ %132, %127 ], [ 0, %115 ], !dbg !452
  %126 = icmp slt i64 %125, %59, !dbg !452
  br i1 %126, label %127, label %133, !dbg !452

127:                                              ; preds = %124
  %128 = add nuw nsw i64 0, %125, !dbg !452
  %129 = getelementptr inbounds nuw float, ptr %5, i64 %128, !dbg !452
  %130 = load float, ptr %129, align 4, !dbg !452
  %131 = getelementptr inbounds nuw float, ptr %4, i64 %128, !dbg !452
  store float %130, ptr %131, align 4, !dbg !452
  %132 = add i64 %125, 1, !dbg !452
  br label %124, !dbg !452

133:                                              ; preds = %124
  %134 = icmp sgt i64 %59, 0, !dbg !469
  br i1 %134, label %135, label %153, !dbg !469

135:                                              ; preds = %133
  %136 = getelementptr float, ptr %4, i64 0, !dbg !469
  %137 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %136, <4 x i1> %63, <4 x float> poison), !dbg !469
  %138 = getelementptr float, ptr %38, i64 %69, !dbg !469
  %139 = load <1 x float>, ptr %138, align 4, !dbg !469
  %140 = extractelement <1 x float> %139, i64 0, !dbg !470
  %141 = insertelement <4 x float> poison, float %140, i32 0, !dbg !470
  %142 = shufflevector <4 x float> %141, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !470
  %143 = fadd contract <4 x float> %137, %142, !dbg !470
  %144 = fcmp ult <4 x float> %143, zeroinitializer, !dbg !471
  %145 = select <4 x i1> %144, <4 x float> zeroinitializer, <4 x float> %143, !dbg !472
  %146 = fcmp ugt <4 x float> %145, splat (float 6.000000e+00), !dbg !473
  %147 = select <4 x i1> %146, <4 x float> splat (float 6.000000e+00), <4 x float> %145, !dbg !474
  %148 = mul i64 %69, 196, !dbg !474
  %149 = mul i64 %51, 14, !dbg !474
  %150 = add i64 %148, %149, !dbg !474
  %151 = add i64 %150, %54, !dbg !474
  %152 = getelementptr float, ptr %45, i64 %151, !dbg !474
  call void @llvm.masked.store.v4f32.p0(<4 x float> %147, ptr align 4 %152, <4 x i1> %63), !dbg !474
  br label %153, !dbg !469

153:                                              ; preds = %135, %133
  %154 = add i64 %66, 1, !dbg !452
  br label %65, !dbg !452

155:                                              ; preds = %65
  %156 = add i64 %54, 4, !dbg !452
  br label %53, !dbg !452

157:                                              ; preds = %53
  %158 = add i64 %51, 1, !dbg !452
  br label %50, !dbg !452

159:                                              ; preds = %50
  ret i32 0, !dbg !475
}

define internal i32 @infer_dispatch_24_matmul_like_64x196x384_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !476 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !477
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !477
  %6 = load ptr, ptr %5, align 8, !dbg !477
  %7 = getelementptr float, ptr %6, i64 148480, !dbg !477
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !477
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !478
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !478
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !478
  %11 = load ptr, ptr %10, align 8, !dbg !478
  %12 = getelementptr float, ptr %11, i64 2013184, !dbg !478
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !478
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !479
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !479
  %15 = load ptr, ptr %14, align 8, !dbg !479
  %16 = getelementptr float, ptr %15, i64 37632, !dbg !479
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !479
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !480
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !480
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !480
  %20 = load ptr, ptr %19, align 8, !dbg !480
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !480
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !481
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !481
  %23 = zext i32 %22 to i64, !dbg !481
  %24 = sdiv i64 %23, 4, !dbg !481
  %25 = mul i64 %24, 4, !dbg !481
  %26 = icmp ne i64 %23, %25, !dbg !481
  %27 = icmp slt i64 %23, 0, !dbg !481
  %28 = and i1 %26, %27, !dbg !481
  %29 = add i64 %24, -1, !dbg !481
  %30 = select i1 %28, i64 %29, i64 %24, !dbg !481
  %31 = srem i64 %23, 4, !dbg !481
  %32 = icmp slt i64 %31, 0, !dbg !481
  %33 = add nsw i64 %31, 4, !dbg !481
  %34 = select i1 %32, i64 %33, i64 %31, !dbg !481
  %35 = mul nsw i64 %30, 16, !dbg !481
  %36 = mul nsw i64 %34, 49, !dbg !481
  br label %37, !dbg !481

37:                                               ; preds = %109, %3
  %38 = phi i64 [ %110, %109 ], [ 0, %3 ], !dbg !481
  %39 = icmp slt i64 %38, 16, !dbg !481
  br i1 %39, label %40, label %111, !dbg !481

40:                                               ; preds = %37
  %41 = add i64 %38, %35, !dbg !481
  %42 = getelementptr float, ptr @__constant_64xf32_0, i64 %41, !dbg !482
  %43 = load <1 x float>, ptr %42, align 4, !dbg !482
  br label %44, !dbg !481

44:                                               ; preds = %95, %40
  %45 = phi i64 [ %108, %95 ], [ 0, %40 ], !dbg !481
  %46 = icmp slt i64 %45, 49, !dbg !481
  br i1 %46, label %47, label %109, !dbg !481

47:                                               ; preds = %44
  %48 = add i64 %45, %36, !dbg !481
  br label %49, !dbg !481

49:                                               ; preds = %53, %47
  %50 = phi i64 [ %94, %53 ], [ 0, %47 ], !dbg !481
  %51 = phi <1 x float> [ %93, %53 ], [ zeroinitializer, %47 ], !dbg !481
  %52 = icmp slt i64 %50, 384, !dbg !481
  br i1 %52, label %53, label %95, !dbg !481

53:                                               ; preds = %49
  %54 = mul i64 %50, 196, !dbg !481
  %55 = add i64 %54, %48, !dbg !481
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !481
  %57 = load <1 x float>, ptr %56, align 4, !dbg !481
  %58 = add i64 %50, 1, !dbg !481
  %59 = mul i64 %58, 196, !dbg !481
  %60 = add i64 %59, %48, !dbg !481
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !481
  %62 = load <1 x float>, ptr %61, align 4, !dbg !481
  %63 = add i64 %50, 2, !dbg !481
  %64 = mul i64 %63, 196, !dbg !481
  %65 = add i64 %64, %48, !dbg !481
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !481
  %67 = load <1 x float>, ptr %66, align 4, !dbg !481
  %68 = add i64 %50, 3, !dbg !481
  %69 = mul i64 %68, 196, !dbg !481
  %70 = add i64 %69, %48, !dbg !481
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !481
  %72 = load <1 x float>, ptr %71, align 4, !dbg !481
  %73 = mul nuw nsw i64 %41, 384, !dbg !483
  %74 = add nuw nsw i64 %73, %50, !dbg !483
  %75 = getelementptr inbounds nuw float, ptr %12, i64 %74, !dbg !483
  %76 = load float, ptr %75, align 4, !dbg !483
  %77 = insertelement <1 x float> poison, float %76, i32 0, !dbg !483
  %78 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %57, <1 x float> %77, <1 x float> %51), !dbg !483
  %79 = add nuw nsw i64 %73, %58, !dbg !483
  %80 = getelementptr inbounds nuw float, ptr %12, i64 %79, !dbg !483
  %81 = load float, ptr %80, align 4, !dbg !483
  %82 = insertelement <1 x float> poison, float %81, i32 0, !dbg !483
  %83 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %82, <1 x float> %78), !dbg !483
  %84 = add nuw nsw i64 %73, %63, !dbg !483
  %85 = getelementptr inbounds nuw float, ptr %12, i64 %84, !dbg !483
  %86 = load float, ptr %85, align 4, !dbg !483
  %87 = insertelement <1 x float> poison, float %86, i32 0, !dbg !483
  %88 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %67, <1 x float> %87, <1 x float> %83), !dbg !483
  %89 = add nuw nsw i64 %73, %68, !dbg !483
  %90 = getelementptr inbounds nuw float, ptr %12, i64 %89, !dbg !483
  %91 = load float, ptr %90, align 4, !dbg !483
  %92 = insertelement <1 x float> poison, float %91, i32 0, !dbg !483
  %93 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %72, <1 x float> %92, <1 x float> %88), !dbg !483
  %94 = add i64 %50, 4, !dbg !481
  br label %49, !dbg !481

95:                                               ; preds = %49
  %96 = mul i64 %41, 196, !dbg !482
  %97 = add i64 %96, %48, !dbg !482
  %98 = getelementptr float, ptr %16, i64 %97, !dbg !482
  %99 = load <1 x float>, ptr %98, align 4, !dbg !482
  %100 = extractelement <1 x float> %51, i64 0, !dbg !484
  %101 = extractelement <1 x float> %43, i64 0, !dbg !484
  %102 = fadd contract float %100, %101, !dbg !484
  %103 = extractelement <1 x float> %99, i64 0, !dbg !485
  %104 = fadd contract float %102, %103, !dbg !485
  %105 = mul nuw nsw i64 %41, 196, !dbg !481
  %106 = add nuw nsw i64 %105, %48, !dbg !481
  %107 = getelementptr inbounds nuw float, ptr %20, i64 %106, !dbg !481
  store float %104, ptr %107, align 4, !dbg !481
  %108 = add i64 %45, 1, !dbg !481
  br label %44, !dbg !481

109:                                              ; preds = %44
  %110 = add i64 %38, 1, !dbg !481
  br label %37, !dbg !481

111:                                              ; preds = %37
  ret i32 0, !dbg !486
}

define internal i32 @infer_dispatch_27_matmul_like_64x196x384_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !487 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !488
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !488
  %6 = load ptr, ptr %5, align 8, !dbg !488
  %7 = getelementptr float, ptr %6, i64 148480, !dbg !488
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !488
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !489
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !489
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !489
  %11 = load ptr, ptr %10, align 8, !dbg !489
  %12 = getelementptr float, ptr %11, i64 1964032, !dbg !489
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !489
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !490
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !490
  %15 = load ptr, ptr %14, align 8, !dbg !490
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !490
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !491
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !491
  %18 = getelementptr ptr, ptr %17, i32 2, !dbg !491
  %19 = load ptr, ptr %18, align 8, !dbg !491
  %20 = getelementptr float, ptr %19, i64 12544, !dbg !491
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !491
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !492
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !492
  %23 = zext i32 %22 to i64, !dbg !492
  %24 = sdiv i64 %23, 4, !dbg !492
  %25 = mul i64 %24, 4, !dbg !492
  %26 = icmp ne i64 %23, %25, !dbg !492
  %27 = icmp slt i64 %23, 0, !dbg !492
  %28 = and i1 %26, %27, !dbg !492
  %29 = add i64 %24, -1, !dbg !492
  %30 = select i1 %28, i64 %29, i64 %24, !dbg !492
  %31 = srem i64 %23, 4, !dbg !492
  %32 = icmp slt i64 %31, 0, !dbg !492
  %33 = add nsw i64 %31, 4, !dbg !492
  %34 = select i1 %32, i64 %33, i64 %31, !dbg !492
  %35 = mul nsw i64 %30, 16, !dbg !492
  %36 = mul nsw i64 %34, 49, !dbg !492
  br label %37, !dbg !492

37:                                               ; preds = %109, %3
  %38 = phi i64 [ %110, %109 ], [ 0, %3 ], !dbg !492
  %39 = icmp slt i64 %38, 16, !dbg !492
  br i1 %39, label %40, label %111, !dbg !492

40:                                               ; preds = %37
  %41 = add i64 %38, %35, !dbg !492
  %42 = getelementptr float, ptr @__constant_64xf32_1, i64 %41, !dbg !493
  %43 = load <1 x float>, ptr %42, align 4, !dbg !493
  br label %44, !dbg !492

44:                                               ; preds = %95, %40
  %45 = phi i64 [ %108, %95 ], [ 0, %40 ], !dbg !492
  %46 = icmp slt i64 %45, 49, !dbg !492
  br i1 %46, label %47, label %109, !dbg !492

47:                                               ; preds = %44
  %48 = add i64 %45, %36, !dbg !492
  br label %49, !dbg !492

49:                                               ; preds = %53, %47
  %50 = phi i64 [ %94, %53 ], [ 0, %47 ], !dbg !492
  %51 = phi <1 x float> [ %93, %53 ], [ zeroinitializer, %47 ], !dbg !492
  %52 = icmp slt i64 %50, 384, !dbg !492
  br i1 %52, label %53, label %95, !dbg !492

53:                                               ; preds = %49
  %54 = mul i64 %50, 196, !dbg !492
  %55 = add i64 %54, %48, !dbg !492
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !492
  %57 = load <1 x float>, ptr %56, align 4, !dbg !492
  %58 = add i64 %50, 1, !dbg !492
  %59 = mul i64 %58, 196, !dbg !492
  %60 = add i64 %59, %48, !dbg !492
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !492
  %62 = load <1 x float>, ptr %61, align 4, !dbg !492
  %63 = add i64 %50, 2, !dbg !492
  %64 = mul i64 %63, 196, !dbg !492
  %65 = add i64 %64, %48, !dbg !492
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !492
  %67 = load <1 x float>, ptr %66, align 4, !dbg !492
  %68 = add i64 %50, 3, !dbg !492
  %69 = mul i64 %68, 196, !dbg !492
  %70 = add i64 %69, %48, !dbg !492
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !492
  %72 = load <1 x float>, ptr %71, align 4, !dbg !492
  %73 = mul nuw nsw i64 %41, 384, !dbg !494
  %74 = add nuw nsw i64 %73, %50, !dbg !494
  %75 = getelementptr inbounds nuw float, ptr %12, i64 %74, !dbg !494
  %76 = load float, ptr %75, align 4, !dbg !494
  %77 = insertelement <1 x float> poison, float %76, i32 0, !dbg !494
  %78 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %57, <1 x float> %77, <1 x float> %51), !dbg !494
  %79 = add nuw nsw i64 %73, %58, !dbg !494
  %80 = getelementptr inbounds nuw float, ptr %12, i64 %79, !dbg !494
  %81 = load float, ptr %80, align 4, !dbg !494
  %82 = insertelement <1 x float> poison, float %81, i32 0, !dbg !494
  %83 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %82, <1 x float> %78), !dbg !494
  %84 = add nuw nsw i64 %73, %63, !dbg !494
  %85 = getelementptr inbounds nuw float, ptr %12, i64 %84, !dbg !494
  %86 = load float, ptr %85, align 4, !dbg !494
  %87 = insertelement <1 x float> poison, float %86, i32 0, !dbg !494
  %88 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %67, <1 x float> %87, <1 x float> %83), !dbg !494
  %89 = add nuw nsw i64 %73, %68, !dbg !494
  %90 = getelementptr inbounds nuw float, ptr %12, i64 %89, !dbg !494
  %91 = load float, ptr %90, align 4, !dbg !494
  %92 = insertelement <1 x float> poison, float %91, i32 0, !dbg !494
  %93 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %72, <1 x float> %92, <1 x float> %88), !dbg !494
  %94 = add i64 %50, 4, !dbg !492
  br label %49, !dbg !492

95:                                               ; preds = %49
  %96 = mul i64 %41, 196, !dbg !493
  %97 = add i64 %96, %48, !dbg !493
  %98 = getelementptr float, ptr %15, i64 %97, !dbg !493
  %99 = load <1 x float>, ptr %98, align 4, !dbg !493
  %100 = extractelement <1 x float> %51, i64 0, !dbg !495
  %101 = extractelement <1 x float> %43, i64 0, !dbg !495
  %102 = fadd contract float %100, %101, !dbg !495
  %103 = extractelement <1 x float> %99, i64 0, !dbg !496
  %104 = fadd contract float %102, %103, !dbg !496
  %105 = mul nuw nsw i64 %41, 196, !dbg !492
  %106 = add nuw nsw i64 %105, %48, !dbg !492
  %107 = getelementptr inbounds nuw float, ptr %20, i64 %106, !dbg !492
  store float %104, ptr %107, align 4, !dbg !492
  %108 = add i64 %45, 1, !dbg !492
  br label %44, !dbg !492

109:                                              ; preds = %44
  %110 = add i64 %38, 1, !dbg !492
  br label %37, !dbg !492

111:                                              ; preds = %37
  ret i32 0, !dbg !497
}

define internal i32 @infer_dispatch_30_matmul_like_64x196x384_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !498 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !499
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !499
  %6 = load ptr, ptr %5, align 8, !dbg !499
  %7 = getelementptr float, ptr %6, i64 123392, !dbg !499
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !499
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !500
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !500
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !500
  %11 = load ptr, ptr %10, align 8, !dbg !500
  %12 = getelementptr float, ptr %11, i64 1914880, !dbg !500
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !500
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !501
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !501
  %15 = load ptr, ptr %14, align 8, !dbg !501
  %16 = getelementptr float, ptr %15, i64 12544, !dbg !501
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !501
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !502
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !502
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !502
  %20 = load ptr, ptr %19, align 8, !dbg !502
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !502
  %21 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !503
  %22 = extractvalue %iree_hal_executable_workgroup_state_v0_t %21, 0, !dbg !503
  %23 = zext i32 %22 to i64, !dbg !503
  %24 = sdiv i64 %23, 4, !dbg !503
  %25 = mul i64 %24, 4, !dbg !503
  %26 = icmp ne i64 %23, %25, !dbg !503
  %27 = icmp slt i64 %23, 0, !dbg !503
  %28 = and i1 %26, %27, !dbg !503
  %29 = add i64 %24, -1, !dbg !503
  %30 = select i1 %28, i64 %29, i64 %24, !dbg !503
  %31 = srem i64 %23, 4, !dbg !503
  %32 = icmp slt i64 %31, 0, !dbg !503
  %33 = add nsw i64 %31, 4, !dbg !503
  %34 = select i1 %32, i64 %33, i64 %31, !dbg !503
  %35 = mul nsw i64 %30, 16, !dbg !503
  %36 = mul nsw i64 %34, 49, !dbg !503
  br label %37, !dbg !503

37:                                               ; preds = %109, %3
  %38 = phi i64 [ %110, %109 ], [ 0, %3 ], !dbg !503
  %39 = icmp slt i64 %38, 16, !dbg !503
  br i1 %39, label %40, label %111, !dbg !503

40:                                               ; preds = %37
  %41 = add i64 %38, %35, !dbg !503
  %42 = getelementptr float, ptr @__constant_64xf32_2, i64 %41, !dbg !504
  %43 = load <1 x float>, ptr %42, align 4, !dbg !504
  br label %44, !dbg !503

44:                                               ; preds = %95, %40
  %45 = phi i64 [ %108, %95 ], [ 0, %40 ], !dbg !503
  %46 = icmp slt i64 %45, 49, !dbg !503
  br i1 %46, label %47, label %109, !dbg !503

47:                                               ; preds = %44
  %48 = add i64 %45, %36, !dbg !503
  br label %49, !dbg !503

49:                                               ; preds = %53, %47
  %50 = phi i64 [ %94, %53 ], [ 0, %47 ], !dbg !503
  %51 = phi <1 x float> [ %93, %53 ], [ zeroinitializer, %47 ], !dbg !503
  %52 = icmp slt i64 %50, 384, !dbg !503
  br i1 %52, label %53, label %95, !dbg !503

53:                                               ; preds = %49
  %54 = mul i64 %50, 196, !dbg !503
  %55 = add i64 %54, %48, !dbg !503
  %56 = getelementptr float, ptr %7, i64 %55, !dbg !503
  %57 = load <1 x float>, ptr %56, align 4, !dbg !503
  %58 = add i64 %50, 1, !dbg !503
  %59 = mul i64 %58, 196, !dbg !503
  %60 = add i64 %59, %48, !dbg !503
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !503
  %62 = load <1 x float>, ptr %61, align 4, !dbg !503
  %63 = add i64 %50, 2, !dbg !503
  %64 = mul i64 %63, 196, !dbg !503
  %65 = add i64 %64, %48, !dbg !503
  %66 = getelementptr float, ptr %7, i64 %65, !dbg !503
  %67 = load <1 x float>, ptr %66, align 4, !dbg !503
  %68 = add i64 %50, 3, !dbg !503
  %69 = mul i64 %68, 196, !dbg !503
  %70 = add i64 %69, %48, !dbg !503
  %71 = getelementptr float, ptr %7, i64 %70, !dbg !503
  %72 = load <1 x float>, ptr %71, align 4, !dbg !503
  %73 = mul nuw nsw i64 %41, 384, !dbg !505
  %74 = add nuw nsw i64 %73, %50, !dbg !505
  %75 = getelementptr inbounds nuw float, ptr %12, i64 %74, !dbg !505
  %76 = load float, ptr %75, align 4, !dbg !505
  %77 = insertelement <1 x float> poison, float %76, i32 0, !dbg !505
  %78 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %57, <1 x float> %77, <1 x float> %51), !dbg !505
  %79 = add nuw nsw i64 %73, %58, !dbg !505
  %80 = getelementptr inbounds nuw float, ptr %12, i64 %79, !dbg !505
  %81 = load float, ptr %80, align 4, !dbg !505
  %82 = insertelement <1 x float> poison, float %81, i32 0, !dbg !505
  %83 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %82, <1 x float> %78), !dbg !505
  %84 = add nuw nsw i64 %73, %63, !dbg !505
  %85 = getelementptr inbounds nuw float, ptr %12, i64 %84, !dbg !505
  %86 = load float, ptr %85, align 4, !dbg !505
  %87 = insertelement <1 x float> poison, float %86, i32 0, !dbg !505
  %88 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %67, <1 x float> %87, <1 x float> %83), !dbg !505
  %89 = add nuw nsw i64 %73, %68, !dbg !505
  %90 = getelementptr inbounds nuw float, ptr %12, i64 %89, !dbg !505
  %91 = load float, ptr %90, align 4, !dbg !505
  %92 = insertelement <1 x float> poison, float %91, i32 0, !dbg !505
  %93 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %72, <1 x float> %92, <1 x float> %88), !dbg !505
  %94 = add i64 %50, 4, !dbg !503
  br label %49, !dbg !503

95:                                               ; preds = %49
  %96 = mul i64 %41, 196, !dbg !504
  %97 = add i64 %96, %48, !dbg !504
  %98 = getelementptr float, ptr %16, i64 %97, !dbg !504
  %99 = load <1 x float>, ptr %98, align 4, !dbg !504
  %100 = extractelement <1 x float> %51, i64 0, !dbg !506
  %101 = extractelement <1 x float> %43, i64 0, !dbg !506
  %102 = fadd contract float %100, %101, !dbg !506
  %103 = extractelement <1 x float> %99, i64 0, !dbg !507
  %104 = fadd contract float %102, %103, !dbg !507
  %105 = mul nuw nsw i64 %41, 196, !dbg !503
  %106 = add nuw nsw i64 %105, %48, !dbg !503
  %107 = getelementptr inbounds nuw float, ptr %20, i64 %106, !dbg !503
  store float %104, ptr %107, align 4, !dbg !503
  %108 = add i64 %45, 1, !dbg !503
  br label %44, !dbg !503

109:                                              ; preds = %44
  %110 = add i64 %38, 1, !dbg !503
  br label %37, !dbg !503

111:                                              ; preds = %37
  ret i32 0, !dbg !508
}

define internal i32 @infer_dispatch_33_matmul_like_96x196x384_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !509 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !510
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !510
  %6 = load ptr, ptr %5, align 8, !dbg !510
  %7 = getelementptr float, ptr %6, i64 123392, !dbg !510
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !510
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !511
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !511
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !511
  %11 = load ptr, ptr %10, align 8, !dbg !511
  %12 = getelementptr float, ptr %11, i64 1853440, !dbg !511
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !511
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !512
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !512
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !512
  %16 = load ptr, ptr %15, align 8, !dbg !512
  %17 = getelementptr float, ptr %16, i64 2206976, !dbg !512
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !512
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !513
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !513
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !513
  %21 = load ptr, ptr %20, align 8, !dbg !513
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !513
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !514
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !514
  %24 = zext i32 %23 to i64, !dbg !514
  %25 = sdiv i64 %24, 4, !dbg !514
  %26 = mul i64 %25, 4, !dbg !514
  %27 = icmp ne i64 %24, %26, !dbg !514
  %28 = icmp slt i64 %24, 0, !dbg !514
  %29 = and i1 %27, %28, !dbg !514
  %30 = add i64 %25, -1, !dbg !514
  %31 = select i1 %29, i64 %30, i64 %25, !dbg !514
  %32 = srem i64 %24, 4, !dbg !514
  %33 = icmp slt i64 %32, 0, !dbg !514
  %34 = add nsw i64 %32, 4, !dbg !514
  %35 = select i1 %33, i64 %34, i64 %32, !dbg !514
  %36 = mul nsw i64 %31, 24, !dbg !514
  %37 = mul nsw i64 %35, 49, !dbg !514
  br label %38, !dbg !514

38:                                               ; preds = %104, %3
  %39 = phi i64 [ %105, %104 ], [ 0, %3 ], !dbg !514
  %40 = icmp slt i64 %39, 24, !dbg !514
  br i1 %40, label %41, label %106, !dbg !514

41:                                               ; preds = %38
  %42 = add i64 %39, %36, !dbg !514
  %43 = getelementptr float, ptr %17, i64 %42, !dbg !515
  %44 = load <1 x float>, ptr %43, align 4, !dbg !515
  br label %45, !dbg !514

45:                                               ; preds = %96, %41
  %46 = phi i64 [ %103, %96 ], [ 0, %41 ], !dbg !514
  %47 = icmp slt i64 %46, 49, !dbg !514
  br i1 %47, label %48, label %104, !dbg !514

48:                                               ; preds = %45
  %49 = add i64 %46, %37, !dbg !514
  br label %50, !dbg !514

50:                                               ; preds = %54, %48
  %51 = phi i64 [ %95, %54 ], [ 0, %48 ], !dbg !514
  %52 = phi <1 x float> [ %94, %54 ], [ zeroinitializer, %48 ], !dbg !514
  %53 = icmp slt i64 %51, 384, !dbg !514
  br i1 %53, label %54, label %96, !dbg !514

54:                                               ; preds = %50
  %55 = mul i64 %51, 196, !dbg !514
  %56 = add i64 %55, %49, !dbg !514
  %57 = getelementptr float, ptr %7, i64 %56, !dbg !514
  %58 = load <1 x float>, ptr %57, align 4, !dbg !514
  %59 = add i64 %51, 1, !dbg !514
  %60 = mul i64 %59, 196, !dbg !514
  %61 = add i64 %60, %49, !dbg !514
  %62 = getelementptr float, ptr %7, i64 %61, !dbg !514
  %63 = load <1 x float>, ptr %62, align 4, !dbg !514
  %64 = add i64 %51, 2, !dbg !514
  %65 = mul i64 %64, 196, !dbg !514
  %66 = add i64 %65, %49, !dbg !514
  %67 = getelementptr float, ptr %7, i64 %66, !dbg !514
  %68 = load <1 x float>, ptr %67, align 4, !dbg !514
  %69 = add i64 %51, 3, !dbg !514
  %70 = mul i64 %69, 196, !dbg !514
  %71 = add i64 %70, %49, !dbg !514
  %72 = getelementptr float, ptr %7, i64 %71, !dbg !514
  %73 = load <1 x float>, ptr %72, align 4, !dbg !514
  %74 = mul nuw nsw i64 %42, 384, !dbg !516
  %75 = add nuw nsw i64 %74, %51, !dbg !516
  %76 = getelementptr inbounds nuw float, ptr %12, i64 %75, !dbg !516
  %77 = load float, ptr %76, align 4, !dbg !516
  %78 = insertelement <1 x float> poison, float %77, i32 0, !dbg !516
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %58, <1 x float> %78, <1 x float> %52), !dbg !516
  %80 = add nuw nsw i64 %74, %59, !dbg !516
  %81 = getelementptr inbounds nuw float, ptr %12, i64 %80, !dbg !516
  %82 = load float, ptr %81, align 4, !dbg !516
  %83 = insertelement <1 x float> poison, float %82, i32 0, !dbg !516
  %84 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %63, <1 x float> %83, <1 x float> %79), !dbg !516
  %85 = add nuw nsw i64 %74, %64, !dbg !516
  %86 = getelementptr inbounds nuw float, ptr %12, i64 %85, !dbg !516
  %87 = load float, ptr %86, align 4, !dbg !516
  %88 = insertelement <1 x float> poison, float %87, i32 0, !dbg !516
  %89 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %88, <1 x float> %84), !dbg !516
  %90 = add nuw nsw i64 %74, %69, !dbg !516
  %91 = getelementptr inbounds nuw float, ptr %12, i64 %90, !dbg !516
  %92 = load float, ptr %91, align 4, !dbg !516
  %93 = insertelement <1 x float> poison, float %92, i32 0, !dbg !516
  %94 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %73, <1 x float> %93, <1 x float> %89), !dbg !516
  %95 = add i64 %51, 4, !dbg !514
  br label %50, !dbg !514

96:                                               ; preds = %50
  %97 = extractelement <1 x float> %52, i64 0, !dbg !517
  %98 = extractelement <1 x float> %44, i64 0, !dbg !517
  %99 = fadd contract float %97, %98, !dbg !517
  %100 = mul nuw nsw i64 %42, 196, !dbg !514
  %101 = add nuw nsw i64 %100, %49, !dbg !514
  %102 = getelementptr inbounds nuw float, ptr %21, i64 %101, !dbg !514
  store float %99, ptr %102, align 4, !dbg !514
  %103 = add i64 %46, 1, !dbg !514
  br label %45, !dbg !514

104:                                              ; preds = %45
  %105 = add i64 %39, 1, !dbg !514
  br label %38, !dbg !514

106:                                              ; preds = %38
  ret i32 0, !dbg !518
}

define internal i32 @infer_dispatch_34_matmul_like_576x14x14x96_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !519 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !520
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !520
  %6 = load i32, ptr %5, align 4, !dbg !520
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !521
  %8 = load i32, ptr %7, align 4, !dbg !521
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !522
  %10 = load i32, ptr %9, align 4, !dbg !522
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !523
  %12 = load i32, ptr %11, align 4, !dbg !523
  %13 = zext i32 %6 to i64, !dbg !524
  %14 = zext i32 %8 to i64, !dbg !525
  %15 = zext i32 %10 to i64, !dbg !526
  %16 = zext i32 %12 to i64, !dbg !527
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !528
  %18 = load ptr, ptr %17, align 8, !dbg !528
  %19 = mul i64 %13, 8, !dbg !528
  %20 = udiv i64 %19, 32, !dbg !528
  %21 = getelementptr float, ptr %18, i64 %20, !dbg !528
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !528
  %22 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !529
  %23 = extractvalue %iree_hal_executable_dispatch_state_v0_t %22, 10, !dbg !529
  %24 = getelementptr ptr, ptr %23, i32 1, !dbg !529
  %25 = load ptr, ptr %24, align 8, !dbg !529
  %26 = mul i64 %14, 8, !dbg !529
  %27 = udiv i64 %26, 32, !dbg !529
  %28 = getelementptr float, ptr %25, i64 %27, !dbg !529
  call void @llvm.assume(i1 true) [ "align"(ptr %28, i64 64) ], !dbg !529
  %29 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !530
  %30 = extractvalue %iree_hal_executable_dispatch_state_v0_t %29, 10, !dbg !530
  %31 = getelementptr ptr, ptr %30, i32 1, !dbg !530
  %32 = load ptr, ptr %31, align 8, !dbg !530
  %33 = mul i64 %15, 8, !dbg !530
  %34 = udiv i64 %33, 32, !dbg !530
  %35 = getelementptr float, ptr %32, i64 %34, !dbg !530
  call void @llvm.assume(i1 true) [ "align"(ptr %35, i64 64) ], !dbg !530
  %36 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !531
  %37 = extractvalue %iree_hal_executable_dispatch_state_v0_t %36, 10, !dbg !531
  %38 = getelementptr ptr, ptr %37, i32 2, !dbg !531
  %39 = load ptr, ptr %38, align 8, !dbg !531
  %40 = mul i64 %16, 8, !dbg !531
  %41 = udiv i64 %40, 32, !dbg !531
  %42 = getelementptr float, ptr %39, i64 %41, !dbg !531
  call void @llvm.assume(i1 true) [ "align"(ptr %42, i64 64) ], !dbg !531
  %43 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !532
  %44 = extractvalue %iree_hal_executable_workgroup_state_v0_t %43, 0, !dbg !532
  %45 = zext i32 %44 to i64, !dbg !532
  %46 = mul nsw i64 %45, 64, !dbg !532
  br label %47, !dbg !532

47:                                               ; preds = %127, %3
  %48 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !532
  %49 = icmp slt i64 %48, 64, !dbg !532
  br i1 %49, label %50, label %129, !dbg !532

50:                                               ; preds = %47
  %51 = add i64 %48, %46, !dbg !532
  %52 = getelementptr float, ptr %35, i64 %51, !dbg !533
  %53 = load <1 x float>, ptr %52, align 4, !dbg !533
  br label %54, !dbg !532

54:                                               ; preds = %125, %50
  %55 = phi i64 [ %126, %125 ], [ 0, %50 ], !dbg !532
  %56 = icmp slt i64 %55, 14, !dbg !532
  br i1 %56, label %57, label %127, !dbg !532

57:                                               ; preds = %111, %54
  %58 = phi i64 [ %119, %111 ], [ 0, %54 ], !dbg !532
  %59 = icmp slt i64 %58, 14, !dbg !532
  br i1 %59, label %60, label %125, !dbg !532

60:                                               ; preds = %64, %57
  %61 = phi i64 [ %110, %64 ], [ 0, %57 ], !dbg !532
  %62 = phi <1 x float> [ %109, %64 ], [ zeroinitializer, %57 ], !dbg !532
  %63 = icmp slt i64 %61, 96, !dbg !532
  br i1 %63, label %64, label %111, !dbg !532

64:                                               ; preds = %60
  %65 = mul i64 %61, 196, !dbg !532
  %66 = mul i64 %55, 14, !dbg !532
  %67 = add i64 %65, %66, !dbg !532
  %68 = add i64 %67, %58, !dbg !532
  %69 = getelementptr float, ptr %21, i64 %68, !dbg !532
  %70 = load <1 x float>, ptr %69, align 4, !dbg !532
  %71 = add i64 %61, 1, !dbg !532
  %72 = mul i64 %71, 196, !dbg !532
  %73 = add i64 %72, %66, !dbg !532
  %74 = add i64 %73, %58, !dbg !532
  %75 = getelementptr float, ptr %21, i64 %74, !dbg !532
  %76 = load <1 x float>, ptr %75, align 4, !dbg !532
  %77 = add i64 %61, 2, !dbg !532
  %78 = mul i64 %77, 196, !dbg !532
  %79 = add i64 %78, %66, !dbg !532
  %80 = add i64 %79, %58, !dbg !532
  %81 = getelementptr float, ptr %21, i64 %80, !dbg !532
  %82 = load <1 x float>, ptr %81, align 4, !dbg !532
  %83 = add i64 %61, 3, !dbg !532
  %84 = mul i64 %83, 196, !dbg !532
  %85 = add i64 %84, %66, !dbg !532
  %86 = add i64 %85, %58, !dbg !532
  %87 = getelementptr float, ptr %21, i64 %86, !dbg !532
  %88 = load <1 x float>, ptr %87, align 4, !dbg !532
  %89 = mul nuw nsw i64 %51, 96, !dbg !534
  %90 = add nuw nsw i64 %89, %61, !dbg !534
  %91 = getelementptr inbounds nuw float, ptr %28, i64 %90, !dbg !534
  %92 = load float, ptr %91, align 4, !dbg !534
  %93 = insertelement <1 x float> poison, float %92, i32 0, !dbg !534
  %94 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %70, <1 x float> %93, <1 x float> %62), !dbg !534
  %95 = add nuw nsw i64 %89, %71, !dbg !534
  %96 = getelementptr inbounds nuw float, ptr %28, i64 %95, !dbg !534
  %97 = load float, ptr %96, align 4, !dbg !534
  %98 = insertelement <1 x float> poison, float %97, i32 0, !dbg !534
  %99 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %76, <1 x float> %98, <1 x float> %94), !dbg !534
  %100 = add nuw nsw i64 %89, %77, !dbg !534
  %101 = getelementptr inbounds nuw float, ptr %28, i64 %100, !dbg !534
  %102 = load float, ptr %101, align 4, !dbg !534
  %103 = insertelement <1 x float> poison, float %102, i32 0, !dbg !534
  %104 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %82, <1 x float> %103, <1 x float> %99), !dbg !534
  %105 = add nuw nsw i64 %89, %83, !dbg !534
  %106 = getelementptr inbounds nuw float, ptr %28, i64 %105, !dbg !534
  %107 = load float, ptr %106, align 4, !dbg !534
  %108 = insertelement <1 x float> poison, float %107, i32 0, !dbg !534
  %109 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %88, <1 x float> %108, <1 x float> %104), !dbg !534
  %110 = add i64 %61, 4, !dbg !532
  br label %60, !dbg !532

111:                                              ; preds = %60
  %112 = fadd contract <1 x float> %62, %53, !dbg !535
  %113 = fcmp ult <1 x float> %112, zeroinitializer, !dbg !536
  %114 = select <1 x i1> %113, <1 x float> zeroinitializer, <1 x float> %112, !dbg !537
  %115 = fcmp ugt <1 x float> %114, splat (float 6.000000e+00), !dbg !538
  %116 = select <1 x i1> %115, <1 x float> splat (float 6.000000e+00), <1 x float> %114, !dbg !539
  %117 = extractelement <1 x float> %116, i64 0, !dbg !532
  %118 = add i64 %55, 1, !dbg !532
  %119 = add i64 %58, 1, !dbg !532
  %120 = mul nuw nsw i64 %51, 256, !dbg !532
  %121 = mul nuw nsw i64 %118, 16, !dbg !532
  %122 = add nuw nsw i64 %120, %121, !dbg !532
  %123 = add nuw nsw i64 %122, %119, !dbg !532
  %124 = getelementptr inbounds nuw float, ptr %42, i64 %123, !dbg !532
  store float %117, ptr %124, align 4, !dbg !532
  br label %57, !dbg !532

125:                                              ; preds = %57
  %126 = add i64 %55, 1, !dbg !532
  br label %54, !dbg !532

127:                                              ; preds = %54
  %128 = add i64 %48, 1, !dbg !532
  br label %47, !dbg !532

129:                                              ; preds = %47
  ret i32 0, !dbg !540
}

define internal i32 @infer_dispatch_35_conv_14x14x576x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !541 {
  %4 = alloca float, i64 4, align 64, !dbg !542
  %5 = alloca float, i64 4, align 64, !dbg !542
  %6 = alloca float, i64 4, align 64, !dbg !543
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !544
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 9, !dbg !544
  %9 = load i32, ptr %8, align 4, !dbg !544
  %10 = getelementptr i32, ptr %8, i32 1, !dbg !545
  %11 = load i32, ptr %10, align 4, !dbg !545
  %12 = getelementptr i32, ptr %8, i32 2, !dbg !546
  %13 = load i32, ptr %12, align 4, !dbg !546
  %14 = getelementptr i32, ptr %8, i32 3, !dbg !547
  %15 = load i32, ptr %14, align 4, !dbg !547
  %16 = zext i32 %9 to i64, !dbg !548
  %17 = zext i32 %11 to i64, !dbg !549
  %18 = zext i32 %13 to i64, !dbg !550
  %19 = zext i32 %15 to i64, !dbg !551
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !552
  %21 = load ptr, ptr %20, align 8, !dbg !552
  %22 = mul i64 %16, 8, !dbg !552
  %23 = udiv i64 %22, 32, !dbg !552
  %24 = getelementptr float, ptr %21, i64 %23, !dbg !552
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !552
  %25 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !553
  %26 = extractvalue %iree_hal_executable_dispatch_state_v0_t %25, 10, !dbg !553
  %27 = getelementptr ptr, ptr %26, i32 1, !dbg !553
  %28 = load ptr, ptr %27, align 8, !dbg !553
  %29 = mul i64 %17, 8, !dbg !553
  %30 = udiv i64 %29, 32, !dbg !553
  %31 = getelementptr float, ptr %28, i64 %30, !dbg !553
  call void @llvm.assume(i1 true) [ "align"(ptr %31, i64 64) ], !dbg !553
  %32 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !554
  %33 = extractvalue %iree_hal_executable_dispatch_state_v0_t %32, 10, !dbg !554
  %34 = getelementptr ptr, ptr %33, i32 1, !dbg !554
  %35 = load ptr, ptr %34, align 8, !dbg !554
  %36 = mul i64 %18, 8, !dbg !554
  %37 = udiv i64 %36, 32, !dbg !554
  %38 = getelementptr float, ptr %35, i64 %37, !dbg !554
  call void @llvm.assume(i1 true) [ "align"(ptr %38, i64 64) ], !dbg !554
  %39 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !555
  %40 = extractvalue %iree_hal_executable_dispatch_state_v0_t %39, 10, !dbg !555
  %41 = getelementptr ptr, ptr %40, i32 2, !dbg !555
  %42 = load ptr, ptr %41, align 8, !dbg !555
  %43 = mul i64 %19, 8, !dbg !555
  %44 = udiv i64 %43, 32, !dbg !555
  %45 = getelementptr float, ptr %42, i64 %44, !dbg !555
  call void @llvm.assume(i1 true) [ "align"(ptr %45, i64 64) ], !dbg !555
  %46 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !542
  %47 = extractvalue %iree_hal_executable_workgroup_state_v0_t %46, 0, !dbg !542
  %48 = zext i32 %47 to i64, !dbg !542
  %49 = mul nsw i64 %48, 32, !dbg !542
  br label %50, !dbg !542

50:                                               ; preds = %157, %3
  %51 = phi i64 [ %158, %157 ], [ 0, %3 ], !dbg !542
  %52 = icmp slt i64 %51, 14, !dbg !542
  br i1 %52, label %53, label %159, !dbg !542

53:                                               ; preds = %155, %50
  %54 = phi i64 [ %156, %155 ], [ 0, %50 ], !dbg !542
  %55 = icmp slt i64 %54, 14, !dbg !542
  br i1 %55, label %56, label %157, !dbg !542

56:                                               ; preds = %53
  %57 = sub i64 14, %54, !dbg !542
  %58 = icmp slt i64 %57, 4, !dbg !542
  %59 = select i1 %58, i64 %57, i64 4, !dbg !542
  %60 = trunc i64 %59 to i32, !dbg !556
  %61 = insertelement <4 x i32> poison, i32 %60, i32 0, !dbg !556
  %62 = shufflevector <4 x i32> %61, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !556
  %63 = icmp sgt <4 x i32> %62, <i32 0, i32 1, i32 2, i32 3>, !dbg !556
  %64 = getelementptr float, ptr %6, i64 0, !dbg !556
  call void @llvm.masked.store.v4f32.p0(<4 x float> zeroinitializer, ptr align 4 %64, <4 x i1> %63), !dbg !556
  br label %65, !dbg !542

65:                                               ; preds = %153, %56
  %66 = phi i64 [ %154, %153 ], [ 0, %56 ], !dbg !542
  %67 = icmp slt i64 %66, 32, !dbg !542
  br i1 %67, label %68, label %155, !dbg !542

68:                                               ; preds = %65
  %69 = add i64 %66, %49, !dbg !542
  br label %70, !dbg !542

70:                                               ; preds = %73, %68
  %71 = phi i64 [ %78, %73 ], [ 0, %68 ], !dbg !542
  %72 = icmp slt i64 %71, %59, !dbg !542
  br i1 %72, label %73, label %79, !dbg !542

73:                                               ; preds = %70
  %74 = add nuw nsw i64 0, %71, !dbg !542
  %75 = getelementptr inbounds nuw float, ptr %6, i64 %74, !dbg !542
  %76 = load float, ptr %75, align 4, !dbg !542
  %77 = getelementptr inbounds nuw float, ptr %5, i64 %74, !dbg !542
  store float %76, ptr %77, align 4, !dbg !542
  %78 = add i64 %71, 1, !dbg !542
  br label %70, !dbg !542

79:                                               ; preds = %113, %70
  %80 = phi i64 [ %114, %113 ], [ 0, %70 ], !dbg !542
  %81 = icmp slt i64 %80, 3, !dbg !542
  br i1 %81, label %82, label %115, !dbg !542

82:                                               ; preds = %79
  %83 = add i64 %80, %51, !dbg !542
  br label %84, !dbg !542

84:                                               ; preds = %111, %82
  %85 = phi i64 [ %112, %111 ], [ 0, %82 ], !dbg !542
  %86 = icmp slt i64 %85, %59, !dbg !542
  br i1 %86, label %87, label %113, !dbg !542

87:                                               ; preds = %90, %84
  %88 = phi i64 [ %110, %90 ], [ 0, %84 ], !dbg !542
  %89 = icmp slt i64 %88, 3, !dbg !542
  br i1 %89, label %90, label %111, !dbg !542

90:                                               ; preds = %87
  %91 = add i64 %54, %85, !dbg !542
  %92 = add i64 %91, %88, !dbg !542
  %93 = mul nuw nsw i64 %69, 256, !dbg !542
  %94 = mul nuw nsw i64 %83, 16, !dbg !542
  %95 = add nuw nsw i64 %93, %94, !dbg !542
  %96 = add nuw nsw i64 %95, %92, !dbg !542
  %97 = getelementptr inbounds nuw float, ptr %24, i64 %96, !dbg !542
  %98 = load float, ptr %97, align 4, !dbg !542
  %99 = mul nuw nsw i64 %69, 9, !dbg !542
  %100 = mul nuw nsw i64 %80, 3, !dbg !542
  %101 = add nuw nsw i64 %99, %100, !dbg !542
  %102 = add nuw nsw i64 %101, %88, !dbg !542
  %103 = getelementptr inbounds nuw float, ptr %31, i64 %102, !dbg !542
  %104 = load float, ptr %103, align 4, !dbg !542
  %105 = add nuw nsw i64 0, %85, !dbg !542
  %106 = getelementptr inbounds nuw float, ptr %5, i64 %105, !dbg !542
  %107 = load float, ptr %106, align 4, !dbg !542
  %108 = fmul contract float %98, %104, !dbg !557
  %109 = fadd contract float %107, %108, !dbg !558
  store float %109, ptr %106, align 4, !dbg !542
  %110 = add i64 %88, 1, !dbg !542
  br label %87, !dbg !542

111:                                              ; preds = %87
  %112 = add i64 %85, 1, !dbg !542
  br label %84, !dbg !542

113:                                              ; preds = %84
  %114 = add i64 %80, 1, !dbg !542
  br label %79, !dbg !542

115:                                              ; preds = %118, %79
  %116 = phi i64 [ %123, %118 ], [ 0, %79 ], !dbg !542
  %117 = icmp slt i64 %116, %59, !dbg !542
  br i1 %117, label %118, label %124, !dbg !542

118:                                              ; preds = %115
  %119 = add nuw nsw i64 0, %116, !dbg !542
  %120 = getelementptr inbounds nuw float, ptr %6, i64 %119, !dbg !542
  %121 = load float, ptr %120, align 4, !dbg !542
  %122 = getelementptr inbounds nuw float, ptr %4, i64 %119, !dbg !542
  store float %121, ptr %122, align 4, !dbg !542
  %123 = add i64 %116, 1, !dbg !542
  br label %115, !dbg !542

124:                                              ; preds = %127, %115
  %125 = phi i64 [ %132, %127 ], [ 0, %115 ], !dbg !542
  %126 = icmp slt i64 %125, %59, !dbg !542
  br i1 %126, label %127, label %133, !dbg !542

127:                                              ; preds = %124
  %128 = add nuw nsw i64 0, %125, !dbg !542
  %129 = getelementptr inbounds nuw float, ptr %5, i64 %128, !dbg !542
  %130 = load float, ptr %129, align 4, !dbg !542
  %131 = getelementptr inbounds nuw float, ptr %4, i64 %128, !dbg !542
  store float %130, ptr %131, align 4, !dbg !542
  %132 = add i64 %125, 1, !dbg !542
  br label %124, !dbg !542

133:                                              ; preds = %124
  %134 = icmp sgt i64 %59, 0, !dbg !559
  br i1 %134, label %135, label %153, !dbg !559

135:                                              ; preds = %133
  %136 = getelementptr float, ptr %4, i64 0, !dbg !559
  %137 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %136, <4 x i1> %63, <4 x float> poison), !dbg !559
  %138 = getelementptr float, ptr %38, i64 %69, !dbg !559
  %139 = load <1 x float>, ptr %138, align 4, !dbg !559
  %140 = extractelement <1 x float> %139, i64 0, !dbg !560
  %141 = insertelement <4 x float> poison, float %140, i32 0, !dbg !560
  %142 = shufflevector <4 x float> %141, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !560
  %143 = fadd contract <4 x float> %137, %142, !dbg !560
  %144 = fcmp ult <4 x float> %143, zeroinitializer, !dbg !561
  %145 = select <4 x i1> %144, <4 x float> zeroinitializer, <4 x float> %143, !dbg !562
  %146 = fcmp ugt <4 x float> %145, splat (float 6.000000e+00), !dbg !563
  %147 = select <4 x i1> %146, <4 x float> splat (float 6.000000e+00), <4 x float> %145, !dbg !564
  %148 = mul i64 %69, 196, !dbg !564
  %149 = mul i64 %51, 14, !dbg !564
  %150 = add i64 %148, %149, !dbg !564
  %151 = add i64 %150, %54, !dbg !564
  %152 = getelementptr float, ptr %45, i64 %151, !dbg !564
  call void @llvm.masked.store.v4f32.p0(<4 x float> %147, ptr align 4 %152, <4 x i1> %63), !dbg !564
  br label %153, !dbg !559

153:                                              ; preds = %135, %133
  %154 = add i64 %66, 1, !dbg !542
  br label %65, !dbg !542

155:                                              ; preds = %65
  %156 = add i64 %54, 4, !dbg !542
  br label %53, !dbg !542

157:                                              ; preds = %53
  %158 = add i64 %51, 1, !dbg !542
  br label %50, !dbg !542

159:                                              ; preds = %50
  ret i32 0, !dbg !565
}

define internal i32 @infer_dispatch_36_matmul_like_96x196x576_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !566 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !567
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !567
  %6 = load i32, ptr %5, align 4, !dbg !567
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !568
  %8 = load i32, ptr %7, align 4, !dbg !568
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !569
  %10 = load i32, ptr %9, align 4, !dbg !569
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !570
  %12 = load i32, ptr %11, align 4, !dbg !570
  %13 = getelementptr i32, ptr %5, i32 4, !dbg !571
  %14 = load i32, ptr %13, align 4, !dbg !571
  %15 = zext i32 %6 to i64, !dbg !572
  %16 = zext i32 %8 to i64, !dbg !573
  %17 = zext i32 %10 to i64, !dbg !574
  %18 = zext i32 %12 to i64, !dbg !575
  %19 = zext i32 %14 to i64, !dbg !576
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !577
  %21 = load ptr, ptr %20, align 8, !dbg !577
  %22 = mul i64 %15, 8, !dbg !577
  %23 = udiv i64 %22, 32, !dbg !577
  %24 = getelementptr float, ptr %21, i64 %23, !dbg !577
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !577
  %25 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !578
  %26 = extractvalue %iree_hal_executable_dispatch_state_v0_t %25, 10, !dbg !578
  %27 = getelementptr ptr, ptr %26, i32 1, !dbg !578
  %28 = load ptr, ptr %27, align 8, !dbg !578
  %29 = mul i64 %17, 8, !dbg !578
  %30 = udiv i64 %29, 32, !dbg !578
  %31 = getelementptr float, ptr %28, i64 %30, !dbg !578
  call void @llvm.assume(i1 true) [ "align"(ptr %31, i64 64) ], !dbg !578
  %32 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !579
  %33 = extractvalue %iree_hal_executable_dispatch_state_v0_t %32, 10, !dbg !579
  %34 = getelementptr ptr, ptr %33, i32 1, !dbg !579
  %35 = load ptr, ptr %34, align 8, !dbg !579
  %36 = mul i64 %18, 8, !dbg !579
  %37 = udiv i64 %36, 32, !dbg !579
  %38 = getelementptr float, ptr %35, i64 %37, !dbg !579
  call void @llvm.assume(i1 true) [ "align"(ptr %38, i64 64) ], !dbg !579
  %39 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !580
  %40 = extractvalue %iree_hal_executable_dispatch_state_v0_t %39, 10, !dbg !580
  %41 = load ptr, ptr %40, align 8, !dbg !580
  %42 = mul i64 %16, 8, !dbg !580
  %43 = udiv i64 %42, 32, !dbg !580
  %44 = getelementptr float, ptr %41, i64 %43, !dbg !580
  call void @llvm.assume(i1 true) [ "align"(ptr %44, i64 64) ], !dbg !580
  %45 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !581
  %46 = extractvalue %iree_hal_executable_dispatch_state_v0_t %45, 10, !dbg !581
  %47 = getelementptr ptr, ptr %46, i32 2, !dbg !581
  %48 = load ptr, ptr %47, align 8, !dbg !581
  %49 = mul i64 %19, 8, !dbg !581
  %50 = udiv i64 %49, 32, !dbg !581
  %51 = getelementptr float, ptr %48, i64 %50, !dbg !581
  call void @llvm.assume(i1 true) [ "align"(ptr %51, i64 64) ], !dbg !581
  %52 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !582
  %53 = extractvalue %iree_hal_executable_workgroup_state_v0_t %52, 0, !dbg !582
  %54 = zext i32 %53 to i64, !dbg !582
  %55 = sdiv i64 %54, 4, !dbg !582
  %56 = mul i64 %55, 4, !dbg !582
  %57 = icmp ne i64 %54, %56, !dbg !582
  %58 = icmp slt i64 %54, 0, !dbg !582
  %59 = and i1 %57, %58, !dbg !582
  %60 = add i64 %55, -1, !dbg !582
  %61 = select i1 %59, i64 %60, i64 %55, !dbg !582
  %62 = srem i64 %54, 4, !dbg !582
  %63 = icmp slt i64 %62, 0, !dbg !582
  %64 = add nsw i64 %62, 4, !dbg !582
  %65 = select i1 %63, i64 %64, i64 %62, !dbg !582
  %66 = mul nsw i64 %61, 24, !dbg !582
  %67 = mul nsw i64 %65, 49, !dbg !582
  br label %68, !dbg !582

68:                                               ; preds = %140, %3
  %69 = phi i64 [ %141, %140 ], [ 0, %3 ], !dbg !582
  %70 = icmp slt i64 %69, 24, !dbg !582
  br i1 %70, label %71, label %142, !dbg !582

71:                                               ; preds = %68
  %72 = add i64 %69, %66, !dbg !582
  %73 = getelementptr float, ptr %38, i64 %72, !dbg !583
  %74 = load <1 x float>, ptr %73, align 4, !dbg !583
  br label %75, !dbg !582

75:                                               ; preds = %126, %71
  %76 = phi i64 [ %139, %126 ], [ 0, %71 ], !dbg !582
  %77 = icmp slt i64 %76, 49, !dbg !582
  br i1 %77, label %78, label %140, !dbg !582

78:                                               ; preds = %75
  %79 = add i64 %76, %67, !dbg !582
  br label %80, !dbg !582

80:                                               ; preds = %84, %78
  %81 = phi i64 [ %125, %84 ], [ 0, %78 ], !dbg !582
  %82 = phi <1 x float> [ %124, %84 ], [ zeroinitializer, %78 ], !dbg !582
  %83 = icmp slt i64 %81, 576, !dbg !582
  br i1 %83, label %84, label %126, !dbg !582

84:                                               ; preds = %80
  %85 = mul i64 %81, 196, !dbg !582
  %86 = add i64 %85, %79, !dbg !582
  %87 = getelementptr float, ptr %24, i64 %86, !dbg !582
  %88 = load <1 x float>, ptr %87, align 4, !dbg !582
  %89 = add i64 %81, 1, !dbg !582
  %90 = mul i64 %89, 196, !dbg !582
  %91 = add i64 %90, %79, !dbg !582
  %92 = getelementptr float, ptr %24, i64 %91, !dbg !582
  %93 = load <1 x float>, ptr %92, align 4, !dbg !582
  %94 = add i64 %81, 2, !dbg !582
  %95 = mul i64 %94, 196, !dbg !582
  %96 = add i64 %95, %79, !dbg !582
  %97 = getelementptr float, ptr %24, i64 %96, !dbg !582
  %98 = load <1 x float>, ptr %97, align 4, !dbg !582
  %99 = add i64 %81, 3, !dbg !582
  %100 = mul i64 %99, 196, !dbg !582
  %101 = add i64 %100, %79, !dbg !582
  %102 = getelementptr float, ptr %24, i64 %101, !dbg !582
  %103 = load <1 x float>, ptr %102, align 4, !dbg !582
  %104 = mul nuw nsw i64 %72, 576, !dbg !584
  %105 = add nuw nsw i64 %104, %81, !dbg !584
  %106 = getelementptr inbounds nuw float, ptr %31, i64 %105, !dbg !584
  %107 = load float, ptr %106, align 4, !dbg !584
  %108 = insertelement <1 x float> poison, float %107, i32 0, !dbg !584
  %109 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %88, <1 x float> %108, <1 x float> %82), !dbg !584
  %110 = add nuw nsw i64 %104, %89, !dbg !584
  %111 = getelementptr inbounds nuw float, ptr %31, i64 %110, !dbg !584
  %112 = load float, ptr %111, align 4, !dbg !584
  %113 = insertelement <1 x float> poison, float %112, i32 0, !dbg !584
  %114 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %93, <1 x float> %113, <1 x float> %109), !dbg !584
  %115 = add nuw nsw i64 %104, %94, !dbg !584
  %116 = getelementptr inbounds nuw float, ptr %31, i64 %115, !dbg !584
  %117 = load float, ptr %116, align 4, !dbg !584
  %118 = insertelement <1 x float> poison, float %117, i32 0, !dbg !584
  %119 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %98, <1 x float> %118, <1 x float> %114), !dbg !584
  %120 = add nuw nsw i64 %104, %99, !dbg !584
  %121 = getelementptr inbounds nuw float, ptr %31, i64 %120, !dbg !584
  %122 = load float, ptr %121, align 4, !dbg !584
  %123 = insertelement <1 x float> poison, float %122, i32 0, !dbg !584
  %124 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %103, <1 x float> %123, <1 x float> %119), !dbg !584
  %125 = add i64 %81, 4, !dbg !582
  br label %80, !dbg !582

126:                                              ; preds = %80
  %127 = mul i64 %72, 196, !dbg !583
  %128 = add i64 %127, %79, !dbg !583
  %129 = getelementptr float, ptr %44, i64 %128, !dbg !583
  %130 = load <1 x float>, ptr %129, align 4, !dbg !583
  %131 = extractelement <1 x float> %82, i64 0, !dbg !585
  %132 = extractelement <1 x float> %74, i64 0, !dbg !585
  %133 = fadd contract float %131, %132, !dbg !585
  %134 = extractelement <1 x float> %130, i64 0, !dbg !586
  %135 = fadd contract float %133, %134, !dbg !586
  %136 = mul nuw nsw i64 %72, 196, !dbg !582
  %137 = add nuw nsw i64 %136, %79, !dbg !582
  %138 = getelementptr inbounds nuw float, ptr %51, i64 %137, !dbg !582
  store float %135, ptr %138, align 4, !dbg !582
  %139 = add i64 %76, 1, !dbg !582
  br label %75, !dbg !582

140:                                              ; preds = %75
  %141 = add i64 %69, 1, !dbg !582
  br label %68, !dbg !582

142:                                              ; preds = %68
  ret i32 0, !dbg !587
}

define internal i32 @infer_dispatch_40_matmul_like_576x14x14x96_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !588 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !589
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !589
  %6 = load ptr, ptr %5, align 8, !dbg !589
  %7 = getelementptr float, ptr %6, i64 112896, !dbg !589
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !589
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !590
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !590
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !590
  %11 = load ptr, ptr %10, align 8, !dbg !590
  %12 = getelementptr float, ptr %11, i64 1576960, !dbg !590
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !590
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !591
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !591
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !591
  %16 = load ptr, ptr %15, align 8, !dbg !591
  %17 = getelementptr float, ptr %16, i64 2203328, !dbg !591
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !591
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !592
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !592
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !592
  %21 = load ptr, ptr %20, align 8, !dbg !592
  %22 = getelementptr float, ptr %21, i64 150528, !dbg !592
  call void @llvm.assume(i1 true) [ "align"(ptr %22, i64 64) ], !dbg !592
  %23 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !593
  %24 = extractvalue %iree_hal_executable_workgroup_state_v0_t %23, 0, !dbg !593
  %25 = zext i32 %24 to i64, !dbg !593
  %26 = mul nsw i64 %25, 64, !dbg !593
  br label %27, !dbg !593

27:                                               ; preds = %106, %3
  %28 = phi i64 [ %107, %106 ], [ 0, %3 ], !dbg !593
  %29 = icmp slt i64 %28, 64, !dbg !593
  br i1 %29, label %30, label %108, !dbg !593

30:                                               ; preds = %27
  %31 = add i64 %28, %26, !dbg !593
  %32 = getelementptr float, ptr %17, i64 %31, !dbg !594
  %33 = load <1 x float>, ptr %32, align 4, !dbg !594
  br label %34, !dbg !593

34:                                               ; preds = %104, %30
  %35 = phi i64 [ %105, %104 ], [ 0, %30 ], !dbg !593
  %36 = icmp slt i64 %35, 14, !dbg !593
  br i1 %36, label %37, label %106, !dbg !593

37:                                               ; preds = %91, %34
  %38 = phi i64 [ %103, %91 ], [ 0, %34 ], !dbg !593
  %39 = icmp slt i64 %38, 14, !dbg !593
  br i1 %39, label %40, label %104, !dbg !593

40:                                               ; preds = %44, %37
  %41 = phi i64 [ %90, %44 ], [ 0, %37 ], !dbg !593
  %42 = phi <1 x float> [ %89, %44 ], [ zeroinitializer, %37 ], !dbg !593
  %43 = icmp slt i64 %41, 96, !dbg !593
  br i1 %43, label %44, label %91, !dbg !593

44:                                               ; preds = %40
  %45 = mul i64 %41, 196, !dbg !593
  %46 = mul i64 %35, 14, !dbg !593
  %47 = add i64 %45, %46, !dbg !593
  %48 = add i64 %47, %38, !dbg !593
  %49 = getelementptr float, ptr %7, i64 %48, !dbg !593
  %50 = load <1 x float>, ptr %49, align 4, !dbg !593
  %51 = add i64 %41, 1, !dbg !593
  %52 = mul i64 %51, 196, !dbg !593
  %53 = add i64 %52, %46, !dbg !593
  %54 = add i64 %53, %38, !dbg !593
  %55 = getelementptr float, ptr %7, i64 %54, !dbg !593
  %56 = load <1 x float>, ptr %55, align 4, !dbg !593
  %57 = add i64 %41, 2, !dbg !593
  %58 = mul i64 %57, 196, !dbg !593
  %59 = add i64 %58, %46, !dbg !593
  %60 = add i64 %59, %38, !dbg !593
  %61 = getelementptr float, ptr %7, i64 %60, !dbg !593
  %62 = load <1 x float>, ptr %61, align 4, !dbg !593
  %63 = add i64 %41, 3, !dbg !593
  %64 = mul i64 %63, 196, !dbg !593
  %65 = add i64 %64, %46, !dbg !593
  %66 = add i64 %65, %38, !dbg !593
  %67 = getelementptr float, ptr %7, i64 %66, !dbg !593
  %68 = load <1 x float>, ptr %67, align 4, !dbg !593
  %69 = mul nuw nsw i64 %31, 96, !dbg !595
  %70 = add nuw nsw i64 %69, %41, !dbg !595
  %71 = getelementptr inbounds nuw float, ptr %12, i64 %70, !dbg !595
  %72 = load float, ptr %71, align 4, !dbg !595
  %73 = insertelement <1 x float> poison, float %72, i32 0, !dbg !595
  %74 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %50, <1 x float> %73, <1 x float> %42), !dbg !595
  %75 = add nuw nsw i64 %69, %51, !dbg !595
  %76 = getelementptr inbounds nuw float, ptr %12, i64 %75, !dbg !595
  %77 = load float, ptr %76, align 4, !dbg !595
  %78 = insertelement <1 x float> poison, float %77, i32 0, !dbg !595
  %79 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %56, <1 x float> %78, <1 x float> %74), !dbg !595
  %80 = add nuw nsw i64 %69, %57, !dbg !595
  %81 = getelementptr inbounds nuw float, ptr %12, i64 %80, !dbg !595
  %82 = load float, ptr %81, align 4, !dbg !595
  %83 = insertelement <1 x float> poison, float %82, i32 0, !dbg !595
  %84 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %62, <1 x float> %83, <1 x float> %79), !dbg !595
  %85 = add nuw nsw i64 %69, %63, !dbg !595
  %86 = getelementptr inbounds nuw float, ptr %12, i64 %85, !dbg !595
  %87 = load float, ptr %86, align 4, !dbg !595
  %88 = insertelement <1 x float> poison, float %87, i32 0, !dbg !595
  %89 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %68, <1 x float> %88, <1 x float> %84), !dbg !595
  %90 = add i64 %41, 4, !dbg !593
  br label %40, !dbg !593

91:                                               ; preds = %40
  %92 = fadd contract <1 x float> %42, %33, !dbg !596
  %93 = fcmp ult <1 x float> %92, zeroinitializer, !dbg !597
  %94 = select <1 x i1> %93, <1 x float> zeroinitializer, <1 x float> %92, !dbg !598
  %95 = fcmp ugt <1 x float> %94, splat (float 6.000000e+00), !dbg !599
  %96 = select <1 x i1> %95, <1 x float> splat (float 6.000000e+00), <1 x float> %94, !dbg !600
  %97 = extractelement <1 x float> %96, i64 0, !dbg !593
  %98 = mul nuw nsw i64 %31, 225, !dbg !593
  %99 = mul nuw nsw i64 %35, 15, !dbg !593
  %100 = add nuw nsw i64 %98, %99, !dbg !593
  %101 = add nuw nsw i64 %100, %38, !dbg !593
  %102 = getelementptr inbounds nuw float, ptr %22, i64 %101, !dbg !593
  store float %97, ptr %102, align 4, !dbg !593
  %103 = add i64 %38, 1, !dbg !593
  br label %37, !dbg !593

104:                                              ; preds = %37
  %105 = add i64 %35, 1, !dbg !593
  br label %34, !dbg !593

106:                                              ; preds = %34
  %107 = add i64 %28, 1, !dbg !593
  br label %27, !dbg !593

108:                                              ; preds = %27
  ret i32 0, !dbg !601
}

define internal i32 @infer_dispatch_41_conv_7x7x576x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !602 {
  %4 = alloca float, i64 4, align 64, !dbg !603
  %5 = alloca float, i64 4, align 64, !dbg !603
  %6 = alloca float, i64 4, align 64, !dbg !604
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !605
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !605
  %9 = load ptr, ptr %8, align 8, !dbg !605
  %10 = getelementptr float, ptr %9, i64 150528, !dbg !605
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !605
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !606
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !606
  %13 = getelementptr ptr, ptr %12, i32 1, !dbg !606
  %14 = load ptr, ptr %13, align 8, !dbg !606
  %15 = getelementptr float, ptr %14, i64 2150592, !dbg !606
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !606
  %16 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !607
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %16, 10, !dbg !607
  %18 = getelementptr ptr, ptr %17, i32 1, !dbg !607
  %19 = load ptr, ptr %18, align 8, !dbg !607
  %20 = getelementptr float, ptr %19, i64 2203904, !dbg !607
  call void @llvm.assume(i1 true) [ "align"(ptr %20, i64 64) ], !dbg !607
  %21 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !608
  %22 = extractvalue %iree_hal_executable_dispatch_state_v0_t %21, 10, !dbg !608
  %23 = getelementptr ptr, ptr %22, i32 2, !dbg !608
  %24 = load ptr, ptr %23, align 8, !dbg !608
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !608
  %25 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !603
  %26 = extractvalue %iree_hal_executable_workgroup_state_v0_t %25, 0, !dbg !603
  %27 = zext i32 %26 to i64, !dbg !603
  %28 = mul nsw i64 %27, 32, !dbg !603
  br label %29, !dbg !603

29:                                               ; preds = %139, %3
  %30 = phi i64 [ %140, %139 ], [ 0, %3 ], !dbg !603
  %31 = icmp slt i64 %30, 7, !dbg !603
  br i1 %31, label %32, label %141, !dbg !603

32:                                               ; preds = %137, %29
  %33 = phi i64 [ %138, %137 ], [ 0, %29 ], !dbg !603
  %34 = icmp slt i64 %33, 7, !dbg !603
  br i1 %34, label %35, label %139, !dbg !603

35:                                               ; preds = %32
  %36 = sub i64 7, %33, !dbg !603
  %37 = icmp slt i64 %36, 4, !dbg !603
  %38 = select i1 %37, i64 %36, i64 4, !dbg !603
  %39 = trunc i64 %38 to i32, !dbg !609
  %40 = insertelement <4 x i32> poison, i32 %39, i32 0, !dbg !609
  %41 = shufflevector <4 x i32> %40, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !609
  %42 = icmp sgt <4 x i32> %41, <i32 0, i32 1, i32 2, i32 3>, !dbg !609
  %43 = getelementptr float, ptr %6, i64 0, !dbg !609
  call void @llvm.masked.store.v4f32.p0(<4 x float> zeroinitializer, ptr align 4 %43, <4 x i1> %42), !dbg !609
  %44 = mul nsw i64 %33, 2, !dbg !603
  br label %45, !dbg !603

45:                                               ; preds = %135, %35
  %46 = phi i64 [ %136, %135 ], [ 0, %35 ], !dbg !603
  %47 = icmp slt i64 %46, 32, !dbg !603
  br i1 %47, label %48, label %137, !dbg !603

48:                                               ; preds = %45
  %49 = add i64 %46, %28, !dbg !603
  br label %50, !dbg !603

50:                                               ; preds = %53, %48
  %51 = phi i64 [ %58, %53 ], [ 0, %48 ], !dbg !603
  %52 = icmp slt i64 %51, %38, !dbg !603
  br i1 %52, label %53, label %59, !dbg !603

53:                                               ; preds = %50
  %54 = add nuw nsw i64 0, %51, !dbg !603
  %55 = getelementptr inbounds nuw float, ptr %6, i64 %54, !dbg !603
  %56 = load float, ptr %55, align 4, !dbg !603
  %57 = getelementptr inbounds nuw float, ptr %5, i64 %54, !dbg !603
  store float %56, ptr %57, align 4, !dbg !603
  %58 = add i64 %51, 1, !dbg !603
  br label %50, !dbg !603

59:                                               ; preds = %95, %50
  %60 = phi i64 [ %96, %95 ], [ 0, %50 ], !dbg !603
  %61 = icmp slt i64 %60, 3, !dbg !603
  br i1 %61, label %62, label %97, !dbg !603

62:                                               ; preds = %59
  %63 = mul nsw i64 %30, 2, !dbg !603
  %64 = add i64 %63, %60, !dbg !603
  br label %65, !dbg !603

65:                                               ; preds = %93, %62
  %66 = phi i64 [ %94, %93 ], [ 0, %62 ], !dbg !603
  %67 = icmp slt i64 %66, %38, !dbg !603
  br i1 %67, label %68, label %95, !dbg !603

68:                                               ; preds = %71, %65
  %69 = phi i64 [ %92, %71 ], [ 0, %65 ], !dbg !603
  %70 = icmp slt i64 %69, 3, !dbg !603
  br i1 %70, label %71, label %93, !dbg !603

71:                                               ; preds = %68
  %72 = mul nsw i64 %66, 2, !dbg !603
  %73 = add i64 %44, %72, !dbg !603
  %74 = add i64 %73, %69, !dbg !603
  %75 = mul nuw nsw i64 %49, 225, !dbg !603
  %76 = mul nuw nsw i64 %64, 15, !dbg !603
  %77 = add nuw nsw i64 %75, %76, !dbg !603
  %78 = add nuw nsw i64 %77, %74, !dbg !603
  %79 = getelementptr inbounds nuw float, ptr %10, i64 %78, !dbg !603
  %80 = load float, ptr %79, align 4, !dbg !603
  %81 = mul nuw nsw i64 %49, 9, !dbg !603
  %82 = mul nuw nsw i64 %60, 3, !dbg !603
  %83 = add nuw nsw i64 %81, %82, !dbg !603
  %84 = add nuw nsw i64 %83, %69, !dbg !603
  %85 = getelementptr inbounds nuw float, ptr %15, i64 %84, !dbg !603
  %86 = load float, ptr %85, align 4, !dbg !603
  %87 = add nuw nsw i64 0, %66, !dbg !603
  %88 = getelementptr inbounds nuw float, ptr %5, i64 %87, !dbg !603
  %89 = load float, ptr %88, align 4, !dbg !603
  %90 = fmul contract float %80, %86, !dbg !610
  %91 = fadd contract float %89, %90, !dbg !611
  store float %91, ptr %88, align 4, !dbg !603
  %92 = add i64 %69, 1, !dbg !603
  br label %68, !dbg !603

93:                                               ; preds = %68
  %94 = add i64 %66, 1, !dbg !603
  br label %65, !dbg !603

95:                                               ; preds = %65
  %96 = add i64 %60, 1, !dbg !603
  br label %59, !dbg !603

97:                                               ; preds = %100, %59
  %98 = phi i64 [ %105, %100 ], [ 0, %59 ], !dbg !603
  %99 = icmp slt i64 %98, %38, !dbg !603
  br i1 %99, label %100, label %106, !dbg !603

100:                                              ; preds = %97
  %101 = add nuw nsw i64 0, %98, !dbg !603
  %102 = getelementptr inbounds nuw float, ptr %6, i64 %101, !dbg !603
  %103 = load float, ptr %102, align 4, !dbg !603
  %104 = getelementptr inbounds nuw float, ptr %4, i64 %101, !dbg !603
  store float %103, ptr %104, align 4, !dbg !603
  %105 = add i64 %98, 1, !dbg !603
  br label %97, !dbg !603

106:                                              ; preds = %109, %97
  %107 = phi i64 [ %114, %109 ], [ 0, %97 ], !dbg !603
  %108 = icmp slt i64 %107, %38, !dbg !603
  br i1 %108, label %109, label %115, !dbg !603

109:                                              ; preds = %106
  %110 = add nuw nsw i64 0, %107, !dbg !603
  %111 = getelementptr inbounds nuw float, ptr %5, i64 %110, !dbg !603
  %112 = load float, ptr %111, align 4, !dbg !603
  %113 = getelementptr inbounds nuw float, ptr %4, i64 %110, !dbg !603
  store float %112, ptr %113, align 4, !dbg !603
  %114 = add i64 %107, 1, !dbg !603
  br label %106, !dbg !603

115:                                              ; preds = %106
  %116 = icmp sgt i64 %38, 0, !dbg !612
  br i1 %116, label %117, label %135, !dbg !612

117:                                              ; preds = %115
  %118 = getelementptr float, ptr %4, i64 0, !dbg !612
  %119 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %118, <4 x i1> %42, <4 x float> poison), !dbg !612
  %120 = getelementptr float, ptr %20, i64 %49, !dbg !612
  %121 = load <1 x float>, ptr %120, align 4, !dbg !612
  %122 = extractelement <1 x float> %121, i64 0, !dbg !613
  %123 = insertelement <4 x float> poison, float %122, i32 0, !dbg !613
  %124 = shufflevector <4 x float> %123, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !613
  %125 = fadd contract <4 x float> %119, %124, !dbg !613
  %126 = fcmp ult <4 x float> %125, zeroinitializer, !dbg !614
  %127 = select <4 x i1> %126, <4 x float> zeroinitializer, <4 x float> %125, !dbg !615
  %128 = fcmp ugt <4 x float> %127, splat (float 6.000000e+00), !dbg !616
  %129 = select <4 x i1> %128, <4 x float> splat (float 6.000000e+00), <4 x float> %127, !dbg !617
  %130 = mul i64 %49, 49, !dbg !617
  %131 = mul i64 %30, 7, !dbg !617
  %132 = add i64 %130, %131, !dbg !617
  %133 = add i64 %132, %33, !dbg !617
  %134 = getelementptr float, ptr %24, i64 %133, !dbg !617
  call void @llvm.masked.store.v4f32.p0(<4 x float> %129, ptr align 4 %134, <4 x i1> %42), !dbg !617
  br label %135, !dbg !612

135:                                              ; preds = %117, %115
  %136 = add i64 %46, 1, !dbg !603
  br label %45, !dbg !603

137:                                              ; preds = %45
  %138 = add i64 %33, 4, !dbg !603
  br label %32, !dbg !603

139:                                              ; preds = %32
  %140 = add i64 %30, 1, !dbg !603
  br label %29, !dbg !603

141:                                              ; preds = %29
  ret i32 0, !dbg !618
}

define internal i32 @infer_dispatch_42_matmul_like_160x49x576_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !619 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !620
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !620
  %6 = load ptr, ptr %5, align 8, !dbg !620
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !620
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !621
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !621
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !621
  %10 = load ptr, ptr %9, align 8, !dbg !621
  %11 = getelementptr float, ptr %10, i64 1484800, !dbg !621
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !621
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !622
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !622
  %14 = getelementptr ptr, ptr %13, i32 1, !dbg !622
  %15 = load ptr, ptr %14, align 8, !dbg !622
  %16 = getelementptr float, ptr %15, i64 2203168, !dbg !622
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !622
  %17 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !623
  %18 = extractvalue %iree_hal_executable_dispatch_state_v0_t %17, 10, !dbg !623
  %19 = getelementptr ptr, ptr %18, i32 2, !dbg !623
  %20 = load ptr, ptr %19, align 8, !dbg !623
  %21 = getelementptr float, ptr %20, i64 28224, !dbg !623
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !623
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !624
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !624
  %24 = zext i32 %23 to i64, !dbg !624
  %25 = mul nsw i64 %24, 16, !dbg !624
  br label %26, !dbg !624

26:                                               ; preds = %90, %3
  %27 = phi i64 [ %91, %90 ], [ 0, %3 ], !dbg !624
  %28 = icmp slt i64 %27, 16, !dbg !624
  br i1 %28, label %29, label %92, !dbg !624

29:                                               ; preds = %26
  %30 = add i64 %27, %25, !dbg !624
  %31 = getelementptr float, ptr %16, i64 %30, !dbg !625
  %32 = load <1 x float>, ptr %31, align 4, !dbg !625
  br label %33, !dbg !624

33:                                               ; preds = %82, %29
  %34 = phi i64 [ %89, %82 ], [ 0, %29 ], !dbg !624
  %35 = icmp slt i64 %34, 49, !dbg !624
  br i1 %35, label %36, label %90, !dbg !624

36:                                               ; preds = %40, %33
  %37 = phi i64 [ %81, %40 ], [ 0, %33 ], !dbg !624
  %38 = phi <1 x float> [ %80, %40 ], [ zeroinitializer, %33 ], !dbg !624
  %39 = icmp slt i64 %37, 576, !dbg !624
  br i1 %39, label %40, label %82, !dbg !624

40:                                               ; preds = %36
  %41 = mul i64 %37, 49, !dbg !624
  %42 = add i64 %41, %34, !dbg !624
  %43 = getelementptr float, ptr %6, i64 %42, !dbg !624
  %44 = load <1 x float>, ptr %43, align 4, !dbg !624
  %45 = add i64 %37, 1, !dbg !624
  %46 = mul i64 %45, 49, !dbg !624
  %47 = add i64 %46, %34, !dbg !624
  %48 = getelementptr float, ptr %6, i64 %47, !dbg !624
  %49 = load <1 x float>, ptr %48, align 4, !dbg !624
  %50 = add i64 %37, 2, !dbg !624
  %51 = mul i64 %50, 49, !dbg !624
  %52 = add i64 %51, %34, !dbg !624
  %53 = getelementptr float, ptr %6, i64 %52, !dbg !624
  %54 = load <1 x float>, ptr %53, align 4, !dbg !624
  %55 = add i64 %37, 3, !dbg !624
  %56 = mul i64 %55, 49, !dbg !624
  %57 = add i64 %56, %34, !dbg !624
  %58 = getelementptr float, ptr %6, i64 %57, !dbg !624
  %59 = load <1 x float>, ptr %58, align 4, !dbg !624
  %60 = mul nuw nsw i64 %30, 576, !dbg !626
  %61 = add nuw nsw i64 %60, %37, !dbg !626
  %62 = getelementptr inbounds nuw float, ptr %11, i64 %61, !dbg !626
  %63 = load float, ptr %62, align 4, !dbg !626
  %64 = insertelement <1 x float> poison, float %63, i32 0, !dbg !626
  %65 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %64, <1 x float> %38), !dbg !626
  %66 = add nuw nsw i64 %60, %45, !dbg !626
  %67 = getelementptr inbounds nuw float, ptr %11, i64 %66, !dbg !626
  %68 = load float, ptr %67, align 4, !dbg !626
  %69 = insertelement <1 x float> poison, float %68, i32 0, !dbg !626
  %70 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %49, <1 x float> %69, <1 x float> %65), !dbg !626
  %71 = add nuw nsw i64 %60, %50, !dbg !626
  %72 = getelementptr inbounds nuw float, ptr %11, i64 %71, !dbg !626
  %73 = load float, ptr %72, align 4, !dbg !626
  %74 = insertelement <1 x float> poison, float %73, i32 0, !dbg !626
  %75 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %54, <1 x float> %74, <1 x float> %70), !dbg !626
  %76 = add nuw nsw i64 %60, %55, !dbg !626
  %77 = getelementptr inbounds nuw float, ptr %11, i64 %76, !dbg !626
  %78 = load float, ptr %77, align 4, !dbg !626
  %79 = insertelement <1 x float> poison, float %78, i32 0, !dbg !626
  %80 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %59, <1 x float> %79, <1 x float> %75), !dbg !626
  %81 = add i64 %37, 4, !dbg !624
  br label %36, !dbg !624

82:                                               ; preds = %36
  %83 = extractelement <1 x float> %38, i64 0, !dbg !627
  %84 = extractelement <1 x float> %32, i64 0, !dbg !627
  %85 = fadd contract float %83, %84, !dbg !627
  %86 = mul nuw nsw i64 %30, 49, !dbg !624
  %87 = add nuw nsw i64 %86, %34, !dbg !624
  %88 = getelementptr inbounds nuw float, ptr %21, i64 %87, !dbg !624
  store float %85, ptr %88, align 4, !dbg !624
  %89 = add i64 %34, 1, !dbg !624
  br label %33, !dbg !624

90:                                               ; preds = %33
  %91 = add i64 %27, 1, !dbg !624
  br label %26, !dbg !624

92:                                               ; preds = %26
  ret i32 0, !dbg !628
}

define internal i32 @infer_dispatch_43_matmul_like_960x7x7x160_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !629 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !630
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !630
  %6 = load i32, ptr %5, align 4, !dbg !630
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !631
  %8 = load i32, ptr %7, align 4, !dbg !631
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !632
  %10 = load i32, ptr %9, align 4, !dbg !632
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !633
  %12 = load i32, ptr %11, align 4, !dbg !633
  %13 = zext i32 %6 to i64, !dbg !634
  %14 = zext i32 %8 to i64, !dbg !635
  %15 = zext i32 %10 to i64, !dbg !636
  %16 = zext i32 %12 to i64, !dbg !637
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !638
  %18 = load ptr, ptr %17, align 8, !dbg !638
  %19 = mul i64 %13, 8, !dbg !638
  %20 = udiv i64 %19, 32, !dbg !638
  %21 = getelementptr float, ptr %18, i64 %20, !dbg !638
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !638
  %22 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !639
  %23 = extractvalue %iree_hal_executable_dispatch_state_v0_t %22, 10, !dbg !639
  %24 = getelementptr ptr, ptr %23, i32 1, !dbg !639
  %25 = load ptr, ptr %24, align 8, !dbg !639
  %26 = mul i64 %14, 8, !dbg !639
  %27 = udiv i64 %26, 32, !dbg !639
  %28 = getelementptr float, ptr %25, i64 %27, !dbg !639
  call void @llvm.assume(i1 true) [ "align"(ptr %28, i64 64) ], !dbg !639
  %29 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !640
  %30 = extractvalue %iree_hal_executable_dispatch_state_v0_t %29, 10, !dbg !640
  %31 = getelementptr ptr, ptr %30, i32 1, !dbg !640
  %32 = load ptr, ptr %31, align 8, !dbg !640
  %33 = mul i64 %15, 8, !dbg !640
  %34 = udiv i64 %33, 32, !dbg !640
  %35 = getelementptr float, ptr %32, i64 %34, !dbg !640
  call void @llvm.assume(i1 true) [ "align"(ptr %35, i64 64) ], !dbg !640
  %36 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !641
  %37 = extractvalue %iree_hal_executable_dispatch_state_v0_t %36, 10, !dbg !641
  %38 = getelementptr ptr, ptr %37, i32 2, !dbg !641
  %39 = load ptr, ptr %38, align 8, !dbg !641
  %40 = mul i64 %16, 8, !dbg !641
  %41 = udiv i64 %40, 32, !dbg !641
  %42 = getelementptr float, ptr %39, i64 %41, !dbg !641
  call void @llvm.assume(i1 true) [ "align"(ptr %42, i64 64) ], !dbg !641
  %43 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !642
  %44 = extractvalue %iree_hal_executable_workgroup_state_v0_t %43, 0, !dbg !642
  %45 = zext i32 %44 to i64, !dbg !642
  %46 = mul nsw i64 %45, 64, !dbg !642
  br label %47, !dbg !642

47:                                               ; preds = %127, %3
  %48 = phi i64 [ %128, %127 ], [ 0, %3 ], !dbg !642
  %49 = icmp slt i64 %48, 64, !dbg !642
  br i1 %49, label %50, label %129, !dbg !642

50:                                               ; preds = %47
  %51 = add i64 %48, %46, !dbg !642
  %52 = getelementptr float, ptr %35, i64 %51, !dbg !643
  %53 = load <1 x float>, ptr %52, align 4, !dbg !643
  br label %54, !dbg !642

54:                                               ; preds = %125, %50
  %55 = phi i64 [ %126, %125 ], [ 0, %50 ], !dbg !642
  %56 = icmp slt i64 %55, 7, !dbg !642
  br i1 %56, label %57, label %127, !dbg !642

57:                                               ; preds = %111, %54
  %58 = phi i64 [ %119, %111 ], [ 0, %54 ], !dbg !642
  %59 = icmp slt i64 %58, 7, !dbg !642
  br i1 %59, label %60, label %125, !dbg !642

60:                                               ; preds = %64, %57
  %61 = phi i64 [ %110, %64 ], [ 0, %57 ], !dbg !642
  %62 = phi <1 x float> [ %109, %64 ], [ zeroinitializer, %57 ], !dbg !642
  %63 = icmp slt i64 %61, 160, !dbg !642
  br i1 %63, label %64, label %111, !dbg !642

64:                                               ; preds = %60
  %65 = mul i64 %61, 49, !dbg !642
  %66 = mul i64 %55, 7, !dbg !642
  %67 = add i64 %65, %66, !dbg !642
  %68 = add i64 %67, %58, !dbg !642
  %69 = getelementptr float, ptr %21, i64 %68, !dbg !642
  %70 = load <1 x float>, ptr %69, align 4, !dbg !642
  %71 = add i64 %61, 1, !dbg !642
  %72 = mul i64 %71, 49, !dbg !642
  %73 = add i64 %72, %66, !dbg !642
  %74 = add i64 %73, %58, !dbg !642
  %75 = getelementptr float, ptr %21, i64 %74, !dbg !642
  %76 = load <1 x float>, ptr %75, align 4, !dbg !642
  %77 = add i64 %61, 2, !dbg !642
  %78 = mul i64 %77, 49, !dbg !642
  %79 = add i64 %78, %66, !dbg !642
  %80 = add i64 %79, %58, !dbg !642
  %81 = getelementptr float, ptr %21, i64 %80, !dbg !642
  %82 = load <1 x float>, ptr %81, align 4, !dbg !642
  %83 = add i64 %61, 3, !dbg !642
  %84 = mul i64 %83, 49, !dbg !642
  %85 = add i64 %84, %66, !dbg !642
  %86 = add i64 %85, %58, !dbg !642
  %87 = getelementptr float, ptr %21, i64 %86, !dbg !642
  %88 = load <1 x float>, ptr %87, align 4, !dbg !642
  %89 = mul nuw nsw i64 %51, 160, !dbg !644
  %90 = add nuw nsw i64 %89, %61, !dbg !644
  %91 = getelementptr inbounds nuw float, ptr %28, i64 %90, !dbg !644
  %92 = load float, ptr %91, align 4, !dbg !644
  %93 = insertelement <1 x float> poison, float %92, i32 0, !dbg !644
  %94 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %70, <1 x float> %93, <1 x float> %62), !dbg !644
  %95 = add nuw nsw i64 %89, %71, !dbg !644
  %96 = getelementptr inbounds nuw float, ptr %28, i64 %95, !dbg !644
  %97 = load float, ptr %96, align 4, !dbg !644
  %98 = insertelement <1 x float> poison, float %97, i32 0, !dbg !644
  %99 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %76, <1 x float> %98, <1 x float> %94), !dbg !644
  %100 = add nuw nsw i64 %89, %77, !dbg !644
  %101 = getelementptr inbounds nuw float, ptr %28, i64 %100, !dbg !644
  %102 = load float, ptr %101, align 4, !dbg !644
  %103 = insertelement <1 x float> poison, float %102, i32 0, !dbg !644
  %104 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %82, <1 x float> %103, <1 x float> %99), !dbg !644
  %105 = add nuw nsw i64 %89, %83, !dbg !644
  %106 = getelementptr inbounds nuw float, ptr %28, i64 %105, !dbg !644
  %107 = load float, ptr %106, align 4, !dbg !644
  %108 = insertelement <1 x float> poison, float %107, i32 0, !dbg !644
  %109 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %88, <1 x float> %108, <1 x float> %104), !dbg !644
  %110 = add i64 %61, 4, !dbg !642
  br label %60, !dbg !642

111:                                              ; preds = %60
  %112 = fadd contract <1 x float> %62, %53, !dbg !645
  %113 = fcmp ult <1 x float> %112, zeroinitializer, !dbg !646
  %114 = select <1 x i1> %113, <1 x float> zeroinitializer, <1 x float> %112, !dbg !647
  %115 = fcmp ugt <1 x float> %114, splat (float 6.000000e+00), !dbg !648
  %116 = select <1 x i1> %115, <1 x float> splat (float 6.000000e+00), <1 x float> %114, !dbg !649
  %117 = extractelement <1 x float> %116, i64 0, !dbg !642
  %118 = add i64 %55, 1, !dbg !642
  %119 = add i64 %58, 1, !dbg !642
  %120 = mul nuw nsw i64 %51, 81, !dbg !642
  %121 = mul nuw nsw i64 %118, 9, !dbg !642
  %122 = add nuw nsw i64 %120, %121, !dbg !642
  %123 = add nuw nsw i64 %122, %119, !dbg !642
  %124 = getelementptr inbounds nuw float, ptr %42, i64 %123, !dbg !642
  store float %117, ptr %124, align 4, !dbg !642
  br label %57, !dbg !642

125:                                              ; preds = %57
  %126 = add i64 %55, 1, !dbg !642
  br label %54, !dbg !642

127:                                              ; preds = %54
  %128 = add i64 %48, 1, !dbg !642
  br label %47, !dbg !642

129:                                              ; preds = %47
  ret i32 0, !dbg !650
}

define internal i32 @infer_dispatch_44_conv_7x7x960x3x3_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !651 {
  %4 = alloca float, i64 4, align 64, !dbg !652
  %5 = alloca float, i64 4, align 64, !dbg !652
  %6 = alloca float, i64 4, align 64, !dbg !653
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !654
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 9, !dbg !654
  %9 = load i32, ptr %8, align 4, !dbg !654
  %10 = getelementptr i32, ptr %8, i32 1, !dbg !655
  %11 = load i32, ptr %10, align 4, !dbg !655
  %12 = getelementptr i32, ptr %8, i32 2, !dbg !656
  %13 = load i32, ptr %12, align 4, !dbg !656
  %14 = getelementptr i32, ptr %8, i32 3, !dbg !657
  %15 = load i32, ptr %14, align 4, !dbg !657
  %16 = zext i32 %9 to i64, !dbg !658
  %17 = zext i32 %11 to i64, !dbg !659
  %18 = zext i32 %13 to i64, !dbg !660
  %19 = zext i32 %15 to i64, !dbg !661
  %20 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !662
  %21 = load ptr, ptr %20, align 8, !dbg !662
  %22 = mul i64 %16, 8, !dbg !662
  %23 = udiv i64 %22, 32, !dbg !662
  %24 = getelementptr float, ptr %21, i64 %23, !dbg !662
  call void @llvm.assume(i1 true) [ "align"(ptr %24, i64 64) ], !dbg !662
  %25 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !663
  %26 = extractvalue %iree_hal_executable_dispatch_state_v0_t %25, 10, !dbg !663
  %27 = getelementptr ptr, ptr %26, i32 1, !dbg !663
  %28 = load ptr, ptr %27, align 8, !dbg !663
  %29 = mul i64 %17, 8, !dbg !663
  %30 = udiv i64 %29, 32, !dbg !663
  %31 = getelementptr float, ptr %28, i64 %30, !dbg !663
  call void @llvm.assume(i1 true) [ "align"(ptr %31, i64 64) ], !dbg !663
  %32 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !664
  %33 = extractvalue %iree_hal_executable_dispatch_state_v0_t %32, 10, !dbg !664
  %34 = getelementptr ptr, ptr %33, i32 1, !dbg !664
  %35 = load ptr, ptr %34, align 8, !dbg !664
  %36 = mul i64 %18, 8, !dbg !664
  %37 = udiv i64 %36, 32, !dbg !664
  %38 = getelementptr float, ptr %35, i64 %37, !dbg !664
  call void @llvm.assume(i1 true) [ "align"(ptr %38, i64 64) ], !dbg !664
  %39 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !665
  %40 = extractvalue %iree_hal_executable_dispatch_state_v0_t %39, 10, !dbg !665
  %41 = getelementptr ptr, ptr %40, i32 2, !dbg !665
  %42 = load ptr, ptr %41, align 8, !dbg !665
  %43 = mul i64 %19, 8, !dbg !665
  %44 = udiv i64 %43, 32, !dbg !665
  %45 = getelementptr float, ptr %42, i64 %44, !dbg !665
  call void @llvm.assume(i1 true) [ "align"(ptr %45, i64 64) ], !dbg !665
  %46 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !652
  %47 = extractvalue %iree_hal_executable_workgroup_state_v0_t %46, 0, !dbg !652
  %48 = zext i32 %47 to i64, !dbg !652
  %49 = mul nsw i64 %48, 32, !dbg !652
  br label %50, !dbg !652

50:                                               ; preds = %157, %3
  %51 = phi i64 [ %158, %157 ], [ 0, %3 ], !dbg !652
  %52 = icmp slt i64 %51, 7, !dbg !652
  br i1 %52, label %53, label %159, !dbg !652

53:                                               ; preds = %155, %50
  %54 = phi i64 [ %156, %155 ], [ 0, %50 ], !dbg !652
  %55 = icmp slt i64 %54, 7, !dbg !652
  br i1 %55, label %56, label %157, !dbg !652

56:                                               ; preds = %53
  %57 = sub i64 7, %54, !dbg !652
  %58 = icmp slt i64 %57, 4, !dbg !652
  %59 = select i1 %58, i64 %57, i64 4, !dbg !652
  %60 = trunc i64 %59 to i32, !dbg !666
  %61 = insertelement <4 x i32> poison, i32 %60, i32 0, !dbg !666
  %62 = shufflevector <4 x i32> %61, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !666
  %63 = icmp sgt <4 x i32> %62, <i32 0, i32 1, i32 2, i32 3>, !dbg !666
  %64 = getelementptr float, ptr %6, i64 0, !dbg !666
  call void @llvm.masked.store.v4f32.p0(<4 x float> zeroinitializer, ptr align 4 %64, <4 x i1> %63), !dbg !666
  br label %65, !dbg !652

65:                                               ; preds = %153, %56
  %66 = phi i64 [ %154, %153 ], [ 0, %56 ], !dbg !652
  %67 = icmp slt i64 %66, 32, !dbg !652
  br i1 %67, label %68, label %155, !dbg !652

68:                                               ; preds = %65
  %69 = add i64 %66, %49, !dbg !652
  br label %70, !dbg !652

70:                                               ; preds = %73, %68
  %71 = phi i64 [ %78, %73 ], [ 0, %68 ], !dbg !652
  %72 = icmp slt i64 %71, %59, !dbg !652
  br i1 %72, label %73, label %79, !dbg !652

73:                                               ; preds = %70
  %74 = add nuw nsw i64 0, %71, !dbg !652
  %75 = getelementptr inbounds nuw float, ptr %6, i64 %74, !dbg !652
  %76 = load float, ptr %75, align 4, !dbg !652
  %77 = getelementptr inbounds nuw float, ptr %5, i64 %74, !dbg !652
  store float %76, ptr %77, align 4, !dbg !652
  %78 = add i64 %71, 1, !dbg !652
  br label %70, !dbg !652

79:                                               ; preds = %113, %70
  %80 = phi i64 [ %114, %113 ], [ 0, %70 ], !dbg !652
  %81 = icmp slt i64 %80, 3, !dbg !652
  br i1 %81, label %82, label %115, !dbg !652

82:                                               ; preds = %79
  %83 = add i64 %80, %51, !dbg !652
  br label %84, !dbg !652

84:                                               ; preds = %111, %82
  %85 = phi i64 [ %112, %111 ], [ 0, %82 ], !dbg !652
  %86 = icmp slt i64 %85, %59, !dbg !652
  br i1 %86, label %87, label %113, !dbg !652

87:                                               ; preds = %90, %84
  %88 = phi i64 [ %110, %90 ], [ 0, %84 ], !dbg !652
  %89 = icmp slt i64 %88, 3, !dbg !652
  br i1 %89, label %90, label %111, !dbg !652

90:                                               ; preds = %87
  %91 = add i64 %54, %85, !dbg !652
  %92 = add i64 %91, %88, !dbg !652
  %93 = mul nuw nsw i64 %69, 81, !dbg !652
  %94 = mul nuw nsw i64 %83, 9, !dbg !652
  %95 = add nuw nsw i64 %93, %94, !dbg !652
  %96 = add nuw nsw i64 %95, %92, !dbg !652
  %97 = getelementptr inbounds nuw float, ptr %24, i64 %96, !dbg !652
  %98 = load float, ptr %97, align 4, !dbg !652
  %99 = mul nuw nsw i64 %69, 9, !dbg !652
  %100 = mul nuw nsw i64 %80, 3, !dbg !652
  %101 = add nuw nsw i64 %99, %100, !dbg !652
  %102 = add nuw nsw i64 %101, %88, !dbg !652
  %103 = getelementptr inbounds nuw float, ptr %31, i64 %102, !dbg !652
  %104 = load float, ptr %103, align 4, !dbg !652
  %105 = add nuw nsw i64 0, %85, !dbg !652
  %106 = getelementptr inbounds nuw float, ptr %5, i64 %105, !dbg !652
  %107 = load float, ptr %106, align 4, !dbg !652
  %108 = fmul contract float %98, %104, !dbg !667
  %109 = fadd contract float %107, %108, !dbg !668
  store float %109, ptr %106, align 4, !dbg !652
  %110 = add i64 %88, 1, !dbg !652
  br label %87, !dbg !652

111:                                              ; preds = %87
  %112 = add i64 %85, 1, !dbg !652
  br label %84, !dbg !652

113:                                              ; preds = %84
  %114 = add i64 %80, 1, !dbg !652
  br label %79, !dbg !652

115:                                              ; preds = %118, %79
  %116 = phi i64 [ %123, %118 ], [ 0, %79 ], !dbg !652
  %117 = icmp slt i64 %116, %59, !dbg !652
  br i1 %117, label %118, label %124, !dbg !652

118:                                              ; preds = %115
  %119 = add nuw nsw i64 0, %116, !dbg !652
  %120 = getelementptr inbounds nuw float, ptr %6, i64 %119, !dbg !652
  %121 = load float, ptr %120, align 4, !dbg !652
  %122 = getelementptr inbounds nuw float, ptr %4, i64 %119, !dbg !652
  store float %121, ptr %122, align 4, !dbg !652
  %123 = add i64 %116, 1, !dbg !652
  br label %115, !dbg !652

124:                                              ; preds = %127, %115
  %125 = phi i64 [ %132, %127 ], [ 0, %115 ], !dbg !652
  %126 = icmp slt i64 %125, %59, !dbg !652
  br i1 %126, label %127, label %133, !dbg !652

127:                                              ; preds = %124
  %128 = add nuw nsw i64 0, %125, !dbg !652
  %129 = getelementptr inbounds nuw float, ptr %5, i64 %128, !dbg !652
  %130 = load float, ptr %129, align 4, !dbg !652
  %131 = getelementptr inbounds nuw float, ptr %4, i64 %128, !dbg !652
  store float %130, ptr %131, align 4, !dbg !652
  %132 = add i64 %125, 1, !dbg !652
  br label %124, !dbg !652

133:                                              ; preds = %124
  %134 = icmp sgt i64 %59, 0, !dbg !669
  br i1 %134, label %135, label %153, !dbg !669

135:                                              ; preds = %133
  %136 = getelementptr float, ptr %4, i64 0, !dbg !669
  %137 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %136, <4 x i1> %63, <4 x float> poison), !dbg !669
  %138 = getelementptr float, ptr %38, i64 %69, !dbg !669
  %139 = load <1 x float>, ptr %138, align 4, !dbg !669
  %140 = extractelement <1 x float> %139, i64 0, !dbg !670
  %141 = insertelement <4 x float> poison, float %140, i32 0, !dbg !670
  %142 = shufflevector <4 x float> %141, <4 x float> poison, <4 x i32> zeroinitializer, !dbg !670
  %143 = fadd contract <4 x float> %137, %142, !dbg !670
  %144 = fcmp ult <4 x float> %143, zeroinitializer, !dbg !671
  %145 = select <4 x i1> %144, <4 x float> zeroinitializer, <4 x float> %143, !dbg !672
  %146 = fcmp ugt <4 x float> %145, splat (float 6.000000e+00), !dbg !673
  %147 = select <4 x i1> %146, <4 x float> splat (float 6.000000e+00), <4 x float> %145, !dbg !674
  %148 = mul i64 %69, 49, !dbg !674
  %149 = mul i64 %51, 7, !dbg !674
  %150 = add i64 %148, %149, !dbg !674
  %151 = add i64 %150, %54, !dbg !674
  %152 = getelementptr float, ptr %45, i64 %151, !dbg !674
  call void @llvm.masked.store.v4f32.p0(<4 x float> %147, ptr align 4 %152, <4 x i1> %63), !dbg !674
  br label %153, !dbg !669

153:                                              ; preds = %135, %133
  %154 = add i64 %66, 1, !dbg !652
  br label %65, !dbg !652

155:                                              ; preds = %65
  %156 = add i64 %54, 4, !dbg !652
  br label %53, !dbg !652

157:                                              ; preds = %53
  %158 = add i64 %51, 1, !dbg !652
  br label %50, !dbg !652

159:                                              ; preds = %50
  ret i32 0, !dbg !675
}

define internal i32 @infer_dispatch_45_matmul_like_160x49x960_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !676 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !677
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 9, !dbg !677
  %6 = load i32, ptr %5, align 4, !dbg !677
  %7 = getelementptr i32, ptr %5, i32 1, !dbg !678
  %8 = load i32, ptr %7, align 4, !dbg !678
  %9 = getelementptr i32, ptr %5, i32 2, !dbg !679
  %10 = load i32, ptr %9, align 4, !dbg !679
  %11 = getelementptr i32, ptr %5, i32 3, !dbg !680
  %12 = load i32, ptr %11, align 4, !dbg !680
  %13 = zext i32 %6 to i64, !dbg !681
  %14 = zext i32 %8 to i64, !dbg !682
  %15 = zext i32 %10 to i64, !dbg !683
  %16 = zext i32 %12 to i64, !dbg !684
  %17 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !685
  %18 = load ptr, ptr %17, align 8, !dbg !685
  %19 = getelementptr float, ptr %18, i64 113824, !dbg !685
  call void @llvm.assume(i1 true) [ "align"(ptr %19, i64 64) ], !dbg !685
  %20 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !686
  %21 = extractvalue %iree_hal_executable_dispatch_state_v0_t %20, 10, !dbg !686
  %22 = getelementptr ptr, ptr %21, i32 1, !dbg !686
  %23 = load ptr, ptr %22, align 8, !dbg !686
  %24 = mul i64 %14, 8, !dbg !686
  %25 = udiv i64 %24, 32, !dbg !686
  %26 = getelementptr float, ptr %23, i64 %25, !dbg !686
  call void @llvm.assume(i1 true) [ "align"(ptr %26, i64 64) ], !dbg !686
  %27 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !687
  %28 = extractvalue %iree_hal_executable_dispatch_state_v0_t %27, 10, !dbg !687
  %29 = getelementptr ptr, ptr %28, i32 1, !dbg !687
  %30 = load ptr, ptr %29, align 8, !dbg !687
  %31 = mul i64 %15, 8, !dbg !687
  %32 = udiv i64 %31, 32, !dbg !687
  %33 = getelementptr float, ptr %30, i64 %32, !dbg !687
  call void @llvm.assume(i1 true) [ "align"(ptr %33, i64 64) ], !dbg !687
  %34 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !688
  %35 = extractvalue %iree_hal_executable_dispatch_state_v0_t %34, 10, !dbg !688
  %36 = load ptr, ptr %35, align 8, !dbg !688
  %37 = mul i64 %13, 8, !dbg !688
  %38 = udiv i64 %37, 32, !dbg !688
  %39 = getelementptr float, ptr %36, i64 %38, !dbg !688
  call void @llvm.assume(i1 true) [ "align"(ptr %39, i64 64) ], !dbg !688
  %40 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !689
  %41 = extractvalue %iree_hal_executable_dispatch_state_v0_t %40, 10, !dbg !689
  %42 = getelementptr ptr, ptr %41, i32 2, !dbg !689
  %43 = load ptr, ptr %42, align 8, !dbg !689
  %44 = mul i64 %16, 8, !dbg !689
  %45 = udiv i64 %44, 32, !dbg !689
  %46 = getelementptr float, ptr %43, i64 %45, !dbg !689
  call void @llvm.assume(i1 true) [ "align"(ptr %46, i64 64) ], !dbg !689
  %47 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !690
  %48 = extractvalue %iree_hal_executable_workgroup_state_v0_t %47, 0, !dbg !690
  %49 = zext i32 %48 to i64, !dbg !690
  %50 = mul nsw i64 %49, 16, !dbg !690
  br label %51, !dbg !690

51:                                               ; preds = %121, %3
  %52 = phi i64 [ %122, %121 ], [ 0, %3 ], !dbg !690
  %53 = icmp slt i64 %52, 16, !dbg !690
  br i1 %53, label %54, label %123, !dbg !690

54:                                               ; preds = %51
  %55 = add i64 %52, %50, !dbg !690
  %56 = getelementptr float, ptr %33, i64 %55, !dbg !691
  %57 = load <1 x float>, ptr %56, align 4, !dbg !691
  br label %58, !dbg !690

58:                                               ; preds = %107, %54
  %59 = phi i64 [ %120, %107 ], [ 0, %54 ], !dbg !690
  %60 = icmp slt i64 %59, 49, !dbg !690
  br i1 %60, label %61, label %121, !dbg !690

61:                                               ; preds = %65, %58
  %62 = phi i64 [ %106, %65 ], [ 0, %58 ], !dbg !690
  %63 = phi <1 x float> [ %105, %65 ], [ zeroinitializer, %58 ], !dbg !690
  %64 = icmp slt i64 %62, 960, !dbg !690
  br i1 %64, label %65, label %107, !dbg !690

65:                                               ; preds = %61
  %66 = mul i64 %62, 49, !dbg !690
  %67 = add i64 %66, %59, !dbg !690
  %68 = getelementptr float, ptr %19, i64 %67, !dbg !690
  %69 = load <1 x float>, ptr %68, align 4, !dbg !690
  %70 = add i64 %62, 1, !dbg !690
  %71 = mul i64 %70, 49, !dbg !690
  %72 = add i64 %71, %59, !dbg !690
  %73 = getelementptr float, ptr %19, i64 %72, !dbg !690
  %74 = load <1 x float>, ptr %73, align 4, !dbg !690
  %75 = add i64 %62, 2, !dbg !690
  %76 = mul i64 %75, 49, !dbg !690
  %77 = add i64 %76, %59, !dbg !690
  %78 = getelementptr float, ptr %19, i64 %77, !dbg !690
  %79 = load <1 x float>, ptr %78, align 4, !dbg !690
  %80 = add i64 %62, 3, !dbg !690
  %81 = mul i64 %80, 49, !dbg !690
  %82 = add i64 %81, %59, !dbg !690
  %83 = getelementptr float, ptr %19, i64 %82, !dbg !690
  %84 = load <1 x float>, ptr %83, align 4, !dbg !690
  %85 = mul nuw nsw i64 %55, 960, !dbg !692
  %86 = add nuw nsw i64 %85, %62, !dbg !692
  %87 = getelementptr inbounds nuw float, ptr %26, i64 %86, !dbg !692
  %88 = load float, ptr %87, align 4, !dbg !692
  %89 = insertelement <1 x float> poison, float %88, i32 0, !dbg !692
  %90 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %69, <1 x float> %89, <1 x float> %63), !dbg !692
  %91 = add nuw nsw i64 %85, %70, !dbg !692
  %92 = getelementptr inbounds nuw float, ptr %26, i64 %91, !dbg !692
  %93 = load float, ptr %92, align 4, !dbg !692
  %94 = insertelement <1 x float> poison, float %93, i32 0, !dbg !692
  %95 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %74, <1 x float> %94, <1 x float> %90), !dbg !692
  %96 = add nuw nsw i64 %85, %75, !dbg !692
  %97 = getelementptr inbounds nuw float, ptr %26, i64 %96, !dbg !692
  %98 = load float, ptr %97, align 4, !dbg !692
  %99 = insertelement <1 x float> poison, float %98, i32 0, !dbg !692
  %100 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %79, <1 x float> %99, <1 x float> %95), !dbg !692
  %101 = add nuw nsw i64 %85, %80, !dbg !692
  %102 = getelementptr inbounds nuw float, ptr %26, i64 %101, !dbg !692
  %103 = load float, ptr %102, align 4, !dbg !692
  %104 = insertelement <1 x float> poison, float %103, i32 0, !dbg !692
  %105 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %84, <1 x float> %104, <1 x float> %100), !dbg !692
  %106 = add i64 %62, 4, !dbg !690
  br label %61, !dbg !690

107:                                              ; preds = %61
  %108 = mul i64 %55, 49, !dbg !691
  %109 = add i64 %108, %59, !dbg !691
  %110 = getelementptr float, ptr %39, i64 %109, !dbg !691
  %111 = load <1 x float>, ptr %110, align 4, !dbg !691
  %112 = extractelement <1 x float> %63, i64 0, !dbg !693
  %113 = extractelement <1 x float> %57, i64 0, !dbg !693
  %114 = fadd contract float %112, %113, !dbg !693
  %115 = extractelement <1 x float> %111, i64 0, !dbg !694
  %116 = fadd contract float %114, %115, !dbg !694
  %117 = mul nuw nsw i64 %55, 49, !dbg !690
  %118 = add nuw nsw i64 %117, %59, !dbg !690
  %119 = getelementptr inbounds nuw float, ptr %46, i64 %118, !dbg !690
  store float %116, ptr %119, align 4, !dbg !690
  %120 = add i64 %59, 1, !dbg !690
  br label %58, !dbg !690

121:                                              ; preds = %58
  %122 = add i64 %52, 1, !dbg !690
  br label %51, !dbg !690

123:                                              ; preds = %51
  ret i32 0, !dbg !695
}

define internal i32 @infer_dispatch_51_matmul_like_320x49x960_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !696 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !697
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !697
  %6 = load ptr, ptr %5, align 8, !dbg !697
  %7 = getelementptr float, ptr %6, i64 93440, !dbg !697
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !697
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !698
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !698
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !698
  %11 = load ptr, ptr %10, align 8, !dbg !698
  %12 = getelementptr float, ptr %11, i64 409600, !dbg !698
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !698
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !699
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !699
  %15 = getelementptr ptr, ptr %14, i32 1, !dbg !699
  %16 = load ptr, ptr %15, align 8, !dbg !699
  %17 = getelementptr float, ptr %16, i64 2196768, !dbg !699
  call void @llvm.assume(i1 true) [ "align"(ptr %17, i64 64) ], !dbg !699
  %18 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !700
  %19 = extractvalue %iree_hal_executable_dispatch_state_v0_t %18, 10, !dbg !700
  %20 = getelementptr ptr, ptr %19, i32 2, !dbg !700
  %21 = load ptr, ptr %20, align 8, !dbg !700
  call void @llvm.assume(i1 true) [ "align"(ptr %21, i64 64) ], !dbg !700
  %22 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !701
  %23 = extractvalue %iree_hal_executable_workgroup_state_v0_t %22, 0, !dbg !701
  %24 = zext i32 %23 to i64, !dbg !701
  %25 = mul nsw i64 %24, 40, !dbg !701
  br label %26, !dbg !701

26:                                               ; preds = %90, %3
  %27 = phi i64 [ %91, %90 ], [ 0, %3 ], !dbg !701
  %28 = icmp slt i64 %27, 40, !dbg !701
  br i1 %28, label %29, label %92, !dbg !701

29:                                               ; preds = %26
  %30 = add i64 %27, %25, !dbg !701
  %31 = getelementptr float, ptr %17, i64 %30, !dbg !702
  %32 = load <1 x float>, ptr %31, align 4, !dbg !702
  br label %33, !dbg !701

33:                                               ; preds = %82, %29
  %34 = phi i64 [ %89, %82 ], [ 0, %29 ], !dbg !701
  %35 = icmp slt i64 %34, 49, !dbg !701
  br i1 %35, label %36, label %90, !dbg !701

36:                                               ; preds = %40, %33
  %37 = phi i64 [ %81, %40 ], [ 0, %33 ], !dbg !701
  %38 = phi <1 x float> [ %80, %40 ], [ zeroinitializer, %33 ], !dbg !701
  %39 = icmp slt i64 %37, 960, !dbg !701
  br i1 %39, label %40, label %82, !dbg !701

40:                                               ; preds = %36
  %41 = mul i64 %37, 49, !dbg !701
  %42 = add i64 %41, %34, !dbg !701
  %43 = getelementptr float, ptr %7, i64 %42, !dbg !701
  %44 = load <1 x float>, ptr %43, align 4, !dbg !701
  %45 = add i64 %37, 1, !dbg !701
  %46 = mul i64 %45, 49, !dbg !701
  %47 = add i64 %46, %34, !dbg !701
  %48 = getelementptr float, ptr %7, i64 %47, !dbg !701
  %49 = load <1 x float>, ptr %48, align 4, !dbg !701
  %50 = add i64 %37, 2, !dbg !701
  %51 = mul i64 %50, 49, !dbg !701
  %52 = add i64 %51, %34, !dbg !701
  %53 = getelementptr float, ptr %7, i64 %52, !dbg !701
  %54 = load <1 x float>, ptr %53, align 4, !dbg !701
  %55 = add i64 %37, 3, !dbg !701
  %56 = mul i64 %55, 49, !dbg !701
  %57 = add i64 %56, %34, !dbg !701
  %58 = getelementptr float, ptr %7, i64 %57, !dbg !701
  %59 = load <1 x float>, ptr %58, align 4, !dbg !701
  %60 = mul nuw nsw i64 %30, 960, !dbg !703
  %61 = add nuw nsw i64 %60, %37, !dbg !703
  %62 = getelementptr inbounds nuw float, ptr %12, i64 %61, !dbg !703
  %63 = load float, ptr %62, align 4, !dbg !703
  %64 = insertelement <1 x float> poison, float %63, i32 0, !dbg !703
  %65 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %44, <1 x float> %64, <1 x float> %38), !dbg !703
  %66 = add nuw nsw i64 %60, %45, !dbg !703
  %67 = getelementptr inbounds nuw float, ptr %12, i64 %66, !dbg !703
  %68 = load float, ptr %67, align 4, !dbg !703
  %69 = insertelement <1 x float> poison, float %68, i32 0, !dbg !703
  %70 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %49, <1 x float> %69, <1 x float> %65), !dbg !703
  %71 = add nuw nsw i64 %60, %50, !dbg !703
  %72 = getelementptr inbounds nuw float, ptr %12, i64 %71, !dbg !703
  %73 = load float, ptr %72, align 4, !dbg !703
  %74 = insertelement <1 x float> poison, float %73, i32 0, !dbg !703
  %75 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %54, <1 x float> %74, <1 x float> %70), !dbg !703
  %76 = add nuw nsw i64 %60, %55, !dbg !703
  %77 = getelementptr inbounds nuw float, ptr %12, i64 %76, !dbg !703
  %78 = load float, ptr %77, align 4, !dbg !703
  %79 = insertelement <1 x float> poison, float %78, i32 0, !dbg !703
  %80 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %59, <1 x float> %79, <1 x float> %75), !dbg !703
  %81 = add i64 %37, 4, !dbg !701
  br label %36, !dbg !701

82:                                               ; preds = %36
  %83 = extractelement <1 x float> %38, i64 0, !dbg !704
  %84 = extractelement <1 x float> %32, i64 0, !dbg !704
  %85 = fadd contract float %83, %84, !dbg !704
  %86 = mul nuw nsw i64 %30, 49, !dbg !701
  %87 = add nuw nsw i64 %86, %34, !dbg !701
  %88 = getelementptr inbounds nuw float, ptr %21, i64 %87, !dbg !701
  store float %85, ptr %88, align 4, !dbg !701
  %89 = add i64 %34, 1, !dbg !701
  br label %33, !dbg !701

90:                                               ; preds = %33
  %91 = add i64 %27, 1, !dbg !701
  br label %26, !dbg !701

92:                                               ; preds = %26
  ret i32 0, !dbg !705
}

define internal i32 @infer_dispatch_52_matmul_like_1280x49x320_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !706 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !707
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !707
  %6 = load ptr, ptr %5, align 8, !dbg !707
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !707
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !708
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !708
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !708
  %10 = load ptr, ptr %9, align 8, !dbg !708
  call void @llvm.assume(i1 true) [ "align"(ptr %10, i64 64) ], !dbg !708
  %11 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !709
  %12 = extractvalue %iree_hal_executable_dispatch_state_v0_t %11, 10, !dbg !709
  %13 = getelementptr ptr, ptr %12, i32 2, !dbg !709
  %14 = load ptr, ptr %13, align 8, !dbg !709
  %15 = getelementptr float, ptr %14, i64 15680, !dbg !709
  call void @llvm.assume(i1 true) [ "align"(ptr %15, i64 64) ], !dbg !709
  %16 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !710
  %17 = extractvalue %iree_hal_executable_workgroup_state_v0_t %16, 0, !dbg !710
  %18 = zext i32 %17 to i64, !dbg !710
  %19 = mul nsw i64 %18, 64, !dbg !710
  br label %20, !dbg !710

20:                                               ; preds = %80, %3
  %21 = phi i64 [ %81, %80 ], [ 0, %3 ], !dbg !710
  %22 = icmp slt i64 %21, 64, !dbg !710
  br i1 %22, label %23, label %82, !dbg !710

23:                                               ; preds = %20
  %24 = add i64 %21, %19, !dbg !710
  br label %25, !dbg !710

25:                                               ; preds = %74, %23
  %26 = phi i64 [ %79, %74 ], [ 0, %23 ], !dbg !710
  %27 = icmp slt i64 %26, 49, !dbg !710
  br i1 %27, label %28, label %80, !dbg !710

28:                                               ; preds = %32, %25
  %29 = phi i64 [ %73, %32 ], [ 0, %25 ], !dbg !710
  %30 = phi <1 x float> [ %72, %32 ], [ zeroinitializer, %25 ], !dbg !710
  %31 = icmp slt i64 %29, 320, !dbg !710
  br i1 %31, label %32, label %74, !dbg !710

32:                                               ; preds = %28
  %33 = mul i64 %29, 49, !dbg !710
  %34 = add i64 %33, %26, !dbg !710
  %35 = getelementptr float, ptr %6, i64 %34, !dbg !710
  %36 = load <1 x float>, ptr %35, align 4, !dbg !710
  %37 = add i64 %29, 1, !dbg !710
  %38 = mul i64 %37, 49, !dbg !710
  %39 = add i64 %38, %26, !dbg !710
  %40 = getelementptr float, ptr %6, i64 %39, !dbg !710
  %41 = load <1 x float>, ptr %40, align 4, !dbg !710
  %42 = add i64 %29, 2, !dbg !710
  %43 = mul i64 %42, 49, !dbg !710
  %44 = add i64 %43, %26, !dbg !710
  %45 = getelementptr float, ptr %6, i64 %44, !dbg !710
  %46 = load <1 x float>, ptr %45, align 4, !dbg !710
  %47 = add i64 %29, 3, !dbg !710
  %48 = mul i64 %47, 49, !dbg !710
  %49 = add i64 %48, %26, !dbg !710
  %50 = getelementptr float, ptr %6, i64 %49, !dbg !710
  %51 = load <1 x float>, ptr %50, align 4, !dbg !710
  %52 = mul nuw nsw i64 %24, 320, !dbg !711
  %53 = add nuw nsw i64 %52, %29, !dbg !711
  %54 = getelementptr inbounds nuw float, ptr %10, i64 %53, !dbg !711
  %55 = load float, ptr %54, align 4, !dbg !711
  %56 = insertelement <1 x float> poison, float %55, i32 0, !dbg !711
  %57 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %36, <1 x float> %56, <1 x float> %30), !dbg !711
  %58 = add nuw nsw i64 %52, %37, !dbg !711
  %59 = getelementptr inbounds nuw float, ptr %10, i64 %58, !dbg !711
  %60 = load float, ptr %59, align 4, !dbg !711
  %61 = insertelement <1 x float> poison, float %60, i32 0, !dbg !711
  %62 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %41, <1 x float> %61, <1 x float> %57), !dbg !711
  %63 = add nuw nsw i64 %52, %42, !dbg !711
  %64 = getelementptr inbounds nuw float, ptr %10, i64 %63, !dbg !711
  %65 = load float, ptr %64, align 4, !dbg !711
  %66 = insertelement <1 x float> poison, float %65, i32 0, !dbg !711
  %67 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %46, <1 x float> %66, <1 x float> %62), !dbg !711
  %68 = add nuw nsw i64 %52, %47, !dbg !711
  %69 = getelementptr inbounds nuw float, ptr %10, i64 %68, !dbg !711
  %70 = load float, ptr %69, align 4, !dbg !711
  %71 = insertelement <1 x float> poison, float %70, i32 0, !dbg !711
  %72 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %51, <1 x float> %71, <1 x float> %67), !dbg !711
  %73 = add i64 %29, 4, !dbg !710
  br label %28, !dbg !710

74:                                               ; preds = %28
  %75 = extractelement <1 x float> %30, i64 0, !dbg !710
  %76 = mul nuw nsw i64 %24, 49, !dbg !710
  %77 = add nuw nsw i64 %76, %26, !dbg !710
  %78 = getelementptr inbounds nuw float, ptr %15, i64 %77, !dbg !710
  store float %75, ptr %78, align 4, !dbg !710
  %79 = add i64 %26, 1, !dbg !710
  br label %25, !dbg !710

80:                                               ; preds = %25
  %81 = add i64 %21, 1, !dbg !710
  br label %20, !dbg !710

82:                                               ; preds = %20
  ret i32 0, !dbg !712
}

define internal i32 @infer_dispatch_53_reduction_1280x49_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !713 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !714
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !714
  %6 = load ptr, ptr %5, align 8, !dbg !714
  %7 = getelementptr float, ptr %6, i64 15680, !dbg !714
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !714
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !715
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !715
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !715
  %11 = load ptr, ptr %10, align 8, !dbg !715
  %12 = getelementptr float, ptr %11, i64 2208032, !dbg !715
  call void @llvm.assume(i1 true) [ "align"(ptr %12, i64 64) ], !dbg !715
  %13 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !716
  %14 = extractvalue %iree_hal_executable_dispatch_state_v0_t %13, 10, !dbg !716
  %15 = getelementptr ptr, ptr %14, i32 2, !dbg !716
  %16 = load ptr, ptr %15, align 8, !dbg !716
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !716
  %17 = load %iree_hal_executable_workgroup_state_v0_t, ptr %2, align 8, !dbg !717
  %18 = extractvalue %iree_hal_executable_workgroup_state_v0_t %17, 0, !dbg !717
  %19 = zext i32 %18 to i64, !dbg !717
  %20 = mul nsw i64 %19, 32, !dbg !717
  br label %21, !dbg !717

21:                                               ; preds = %102, %3
  %22 = phi i64 [ %105, %102 ], [ 0, %3 ], !dbg !717
  %23 = icmp slt i64 %22, 32, !dbg !717
  br i1 %23, label %24, label %106, !dbg !717

24:                                               ; preds = %21
  %25 = add i64 %22, %20, !dbg !717
  %26 = getelementptr float, ptr %12, i64 %25, !dbg !717
  %27 = load <4 x float>, ptr %26, align 4, !dbg !717
  %28 = shufflevector <4 x float> %27, <4 x float> %27, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, !dbg !717
  %29 = shufflevector <16 x float> %28, <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !717
  %30 = shufflevector <16 x float> %28, <16 x float> %29, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>, !dbg !717
  %31 = shufflevector <16 x float> %28, <16 x float> %30, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 28, i32 29, i32 30, i32 31>, !dbg !717
  %32 = shufflevector <16 x float> %28, <16 x float> %31, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 0, i32 1, i32 2, i32 3>, !dbg !717
  %33 = shufflevector <16 x float> %32, <16 x float> %32, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>, !dbg !717
  %34 = shufflevector <16 x float> %33, <16 x float> %33, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, !dbg !717
  %35 = shufflevector <16 x float> %33, <16 x float> %33, <4 x i32> <i32 4, i32 5, i32 6, i32 7>, !dbg !717
  %36 = shufflevector <16 x float> %33, <16 x float> %33, <4 x i32> <i32 8, i32 9, i32 10, i32 11>, !dbg !717
  %37 = shufflevector <16 x float> %33, <16 x float> %33, <4 x i32> <i32 12, i32 13, i32 14, i32 15>, !dbg !717
  br label %38, !dbg !717

38:                                               ; preds = %42, %24
  %39 = phi i64 [ %101, %42 ], [ 0, %24 ], !dbg !717
  %40 = phi <4 x float> [ %100, %42 ], [ zeroinitializer, %24 ], !dbg !717
  %41 = icmp slt i64 %39, 49, !dbg !717
  br i1 %41, label %42, label %102, !dbg !717

42:                                               ; preds = %38
  %43 = sub i64 49, %39, !dbg !717
  %44 = icmp slt i64 %43, 4, !dbg !717
  %45 = select i1 %44, i64 %43, i64 4, !dbg !717
  %46 = trunc i64 %45 to i32, !dbg !717
  %47 = insertelement <4 x i32> poison, i32 %46, i32 0, !dbg !717
  %48 = shufflevector <4 x i32> %47, <4 x i32> poison, <4 x i32> zeroinitializer, !dbg !717
  %49 = icmp sgt <4 x i32> %48, <i32 0, i32 1, i32 2, i32 3>, !dbg !717
  %50 = mul i64 %25, 49, !dbg !717
  %51 = add i64 %50, %39, !dbg !717
  %52 = getelementptr float, ptr %7, i64 %51, !dbg !717
  %53 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %52, <4 x i1> %49, <4 x float> poison), !dbg !717
  %54 = add i64 %25, 1, !dbg !717
  %55 = mul i64 %54, 49, !dbg !717
  %56 = add i64 %55, %39, !dbg !717
  %57 = getelementptr float, ptr %7, i64 %56, !dbg !717
  %58 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %57, <4 x i1> %49, <4 x float> poison), !dbg !717
  %59 = add i64 %25, 2, !dbg !717
  %60 = mul i64 %59, 49, !dbg !717
  %61 = add i64 %60, %39, !dbg !717
  %62 = getelementptr float, ptr %7, i64 %61, !dbg !717
  %63 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %62, <4 x i1> %49, <4 x float> poison), !dbg !717
  %64 = add i64 %25, 3, !dbg !717
  %65 = mul i64 %64, 49, !dbg !717
  %66 = add i64 %65, %39, !dbg !717
  %67 = getelementptr float, ptr %7, i64 %66, !dbg !717
  %68 = call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %67, <4 x i1> %49, <4 x float> poison), !dbg !717
  %69 = fadd contract <4 x float> %53, %34, !dbg !718
  %70 = fadd contract <4 x float> %58, %35, !dbg !718
  %71 = fadd contract <4 x float> %63, %36, !dbg !718
  %72 = fadd contract <4 x float> %68, %37, !dbg !718
  %73 = fcmp ult <4 x float> %69, zeroinitializer, !dbg !719
  %74 = fcmp ult <4 x float> %70, zeroinitializer, !dbg !719
  %75 = fcmp ult <4 x float> %71, zeroinitializer, !dbg !719
  %76 = fcmp ult <4 x float> %72, zeroinitializer, !dbg !719
  %77 = select <4 x i1> %73, <4 x float> zeroinitializer, <4 x float> %69, !dbg !720
  %78 = select <4 x i1> %74, <4 x float> zeroinitializer, <4 x float> %70, !dbg !720
  %79 = select <4 x i1> %75, <4 x float> zeroinitializer, <4 x float> %71, !dbg !720
  %80 = select <4 x i1> %76, <4 x float> zeroinitializer, <4 x float> %72, !dbg !720
  %81 = fcmp ugt <4 x float> %77, splat (float 6.000000e+00), !dbg !721
  %82 = fcmp ugt <4 x float> %78, splat (float 6.000000e+00), !dbg !721
  %83 = fcmp ugt <4 x float> %79, splat (float 6.000000e+00), !dbg !721
  %84 = fcmp ugt <4 x float> %80, splat (float 6.000000e+00), !dbg !721
  %85 = select <4 x i1> %81, <4 x float> splat (float 6.000000e+00), <4 x float> %77, !dbg !722
  %86 = select <4 x i1> %82, <4 x float> splat (float 6.000000e+00), <4 x float> %78, !dbg !722
  %87 = select <4 x i1> %83, <4 x float> splat (float 6.000000e+00), <4 x float> %79, !dbg !722
  %88 = select <4 x i1> %84, <4 x float> splat (float 6.000000e+00), <4 x float> %80, !dbg !722
  %89 = extractelement <4 x float> %40, i64 0, !dbg !723
  %90 = call float @llvm.vp.reduce.fadd.v4f32(float %89, <4 x float> %85, <4 x i1> %49, i32 4), !dbg !723
  %91 = extractelement <4 x float> %40, i64 1, !dbg !723
  %92 = call float @llvm.vp.reduce.fadd.v4f32(float %91, <4 x float> %86, <4 x i1> %49, i32 4), !dbg !723
  %93 = extractelement <4 x float> %40, i64 2, !dbg !723
  %94 = call float @llvm.vp.reduce.fadd.v4f32(float %93, <4 x float> %87, <4 x i1> %49, i32 4), !dbg !723
  %95 = extractelement <4 x float> %40, i64 3, !dbg !723
  %96 = call float @llvm.vp.reduce.fadd.v4f32(float %95, <4 x float> %88, <4 x i1> %49, i32 4), !dbg !723
  %97 = insertelement <4 x float> poison, float %90, i64 0, !dbg !723
  %98 = insertelement <4 x float> %97, float %92, i64 1, !dbg !723
  %99 = insertelement <4 x float> %98, float %94, i64 2, !dbg !723
  %100 = insertelement <4 x float> %99, float %96, i64 3, !dbg !723
  %101 = add i64 %39, 4, !dbg !717
  br label %38, !dbg !717

102:                                              ; preds = %38
  %103 = fdiv <4 x float> %40, splat (float 4.900000e+01), !dbg !724
  %104 = getelementptr float, ptr %16, i64 %25, !dbg !717
  store <4 x float> %103, ptr %104, align 4, !dbg !717
  %105 = add i64 %22, 4, !dbg !717
  br label %21, !dbg !717

106:                                              ; preds = %21
  ret i32 0, !dbg !725
}

define internal i32 @infer_dispatch_54_matmul_1x3x1280_f32(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !726 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !727
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !727
  %6 = load ptr, ptr %5, align 8, !dbg !727
  call void @llvm.assume(i1 true) [ "align"(ptr %6, i64 64) ], !dbg !727
  %7 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !728
  %8 = extractvalue %iree_hal_executable_dispatch_state_v0_t %7, 10, !dbg !728
  %9 = getelementptr ptr, ptr %8, i32 1, !dbg !728
  %10 = load ptr, ptr %9, align 8, !dbg !728
  %11 = getelementptr float, ptr %10, i64 2188896, !dbg !728
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !728
  %12 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !729
  %13 = extractvalue %iree_hal_executable_dispatch_state_v0_t %12, 10, !dbg !729
  %14 = getelementptr ptr, ptr %13, i32 2, !dbg !729
  %15 = load ptr, ptr %14, align 8, !dbg !729
  %16 = getelementptr float, ptr %15, i64 1280, !dbg !729
  call void @llvm.assume(i1 true) [ "align"(ptr %16, i64 64) ], !dbg !729
  br label %17, !dbg !730

17:                                               ; preds = %61, %3
  %18 = phi i64 [ %70, %61 ], [ 0, %3 ], !dbg !730
  %19 = icmp slt i64 %18, 3, !dbg !730
  br i1 %19, label %20, label %71, !dbg !730

20:                                               ; preds = %24, %17
  %21 = phi i64 [ %60, %24 ], [ 0, %17 ], !dbg !730
  %22 = phi <1 x float> [ %59, %24 ], [ zeroinitializer, %17 ], !dbg !730
  %23 = icmp slt i64 %21, 1280, !dbg !730
  br i1 %23, label %24, label %61, !dbg !730

24:                                               ; preds = %20
  %25 = mul i64 %18, 1280, !dbg !730
  %26 = add i64 %25, %21, !dbg !730
  %27 = getelementptr float, ptr %11, i64 %26, !dbg !730
  %28 = load <4 x float>, ptr %27, align 4, !dbg !730
  %29 = extractelement <4 x float> %28, i64 0
  %30 = insertelement <1 x float> poison, float %29, i64 0
  %31 = extractelement <4 x float> %28, i64 1
  %32 = insertelement <1 x float> poison, float %31, i64 0
  %33 = extractelement <4 x float> %28, i64 2
  %34 = insertelement <1 x float> poison, float %33, i64 0
  %35 = extractelement <4 x float> %28, i64 3
  %36 = insertelement <1 x float> poison, float %35, i64 0
  %37 = add nuw nsw i64 0, %21
  %38 = getelementptr inbounds nuw float, ptr %6, i64 %37
  %39 = load float, ptr %38, align 4
  %40 = insertelement <1 x float> poison, float %39, i32 0
  %41 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %30, <1 x float> %40, <1 x float> %22)
  %42 = add i64 %21, 1
  %43 = add nuw nsw i64 0, %42
  %44 = getelementptr inbounds nuw float, ptr %6, i64 %43
  %45 = load float, ptr %44, align 4
  %46 = insertelement <1 x float> poison, float %45, i32 0
  %47 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %32, <1 x float> %46, <1 x float> %41)
  %48 = add i64 %21, 2
  %49 = add nuw nsw i64 0, %48
  %50 = getelementptr inbounds nuw float, ptr %6, i64 %49
  %51 = load float, ptr %50, align 4
  %52 = insertelement <1 x float> poison, float %51, i32 0
  %53 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %34, <1 x float> %52, <1 x float> %47)
  %54 = add i64 %21, 3
  %55 = add nuw nsw i64 0, %54
  %56 = getelementptr inbounds nuw float, ptr %6, i64 %55
  %57 = load float, ptr %56, align 4
  %58 = insertelement <1 x float> poison, float %57, i32 0
  %59 = call <1 x float> @llvm.fmuladd.v1f32(<1 x float> %36, <1 x float> %58, <1 x float> %53)
  %60 = add i64 %21, 4, !dbg !730
  br label %20, !dbg !730

61:                                               ; preds = %20
  %62 = add i64 0, %18, !dbg !731
  %63 = getelementptr float, ptr @__constant_1x3xf32, i64 %62, !dbg !731
  %64 = load <1 x float>, ptr %63, align 4, !dbg !731
  %65 = extractelement <1 x float> %22, i64 0, !dbg !732
  %66 = extractelement <1 x float> %64, i64 0, !dbg !732
  %67 = fadd contract float %65, %66, !dbg !732
  %68 = add nuw nsw i64 0, %18, !dbg !730
  %69 = getelementptr inbounds nuw float, ptr %16, i64 %68, !dbg !730
  store float %67, ptr %69, align 4, !dbg !730
  %70 = add i64 %18, 1, !dbg !730
  br label %17, !dbg !730

71:                                               ; preds = %17
  ret i32 0, !dbg !733
}

define internal i32 @infer_dispatch_55_softmax_3xf32_dispatch_tensor_store(ptr noalias noundef nonnull align 16 %0, ptr noalias noundef nonnull align 16 %1, ptr noalias noundef nonnull align 16 %2) #0 !dbg !734 {
  %4 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !735
  %5 = extractvalue %iree_hal_executable_dispatch_state_v0_t %4, 10, !dbg !735
  %6 = load ptr, ptr %5, align 8, !dbg !735
  %7 = getelementptr float, ptr %6, i64 1280, !dbg !735
  call void @llvm.assume(i1 true) [ "align"(ptr %7, i64 64) ], !dbg !735
  %8 = load %iree_hal_executable_dispatch_state_v0_t, ptr %1, align 8, !dbg !736
  %9 = extractvalue %iree_hal_executable_dispatch_state_v0_t %8, 10, !dbg !736
  %10 = getelementptr ptr, ptr %9, i32 1, !dbg !736
  %11 = load ptr, ptr %10, align 8, !dbg !736
  call void @llvm.assume(i1 true) [ "align"(ptr %11, i64 64) ], !dbg !736
  %12 = load <3 x float>, ptr %7, align 4, !dbg !737
  %13 = call float @llvm.vector.reduce.fmax.v3f32(<3 x float> %12), !dbg !738
  %14 = call float @llvm.maxnum.f32(float %13, float 0xFFF8000000000000), !dbg !738
  %15 = insertelement <3 x float> poison, float %14, i32 0, !dbg !739
  %16 = shufflevector <3 x float> %15, <3 x float> poison, <3 x i32> zeroinitializer, !dbg !739
  %17 = fsub contract <3 x float> %12, %16, !dbg !740
  %18 = fcmp uge <3 x float> %17, splat (float 0xC055F33340000000), !dbg !741
  %19 = select <3 x i1> %18, <3 x float> %17, <3 x float> splat (float 0xC055F33340000000), !dbg !741
  %20 = fcmp ule <3 x float> %19, splat (float 0x4056333340000000), !dbg !741
  %21 = select <3 x i1> %20, <3 x float> %19, <3 x float> splat (float 0x4056333340000000), !dbg !741
  %22 = call <3 x float> @llvm.fma.v3f32(<3 x float> %21, <3 x float> splat (float 0x3FF7154760000000), <3 x float> splat (float 5.000000e-01)), !dbg !741
  %23 = call <3 x float> @llvm.floor.v3f32(<3 x float> %22), !dbg !741
  %24 = fcmp uge <3 x float> %23, splat (float -1.270000e+02), !dbg !741
  %25 = select <3 x i1> %24, <3 x float> %23, <3 x float> splat (float -1.270000e+02), !dbg !741
  %26 = fcmp ule <3 x float> %25, splat (float 1.270000e+02), !dbg !741
  %27 = select <3 x i1> %26, <3 x float> %25, <3 x float> splat (float 1.270000e+02), !dbg !741
  %28 = call <3 x float> @llvm.fma.v3f32(<3 x float> splat (float 0xBFE6300000000000), <3 x float> %27, <3 x float> %21), !dbg !741
  %29 = call <3 x float> @llvm.fma.v3f32(<3 x float> splat (float 0x3F2BD01060000000), <3 x float> %27, <3 x float> %28), !dbg !741
  %30 = call <3 x float> @llvm.fma.v3f32(<3 x float> %29, <3 x float> splat (float 0x3F2A0D2CE0000000), <3 x float> splat (float 0x3F56E879C0000000)), !dbg !741
  %31 = call <3 x float> @llvm.fma.v3f32(<3 x float> %30, <3 x float> %29, <3 x float> splat (float 0x3F81112100000000)), !dbg !741
  %32 = call <3 x float> @llvm.fma.v3f32(<3 x float> %31, <3 x float> %29, <3 x float> splat (float 0x3FA5553820000000)), !dbg !741
  %33 = call <3 x float> @llvm.fma.v3f32(<3 x float> %32, <3 x float> %29, <3 x float> splat (float 0x3FC5555540000000)), !dbg !741
  %34 = call <3 x float> @llvm.fma.v3f32(<3 x float> %33, <3 x float> %29, <3 x float> splat (float 5.000000e-01)), !dbg !741
  %35 = fmul contract <3 x float> %29, %29, !dbg !741
  %36 = call <3 x float> @llvm.fma.v3f32(<3 x float> %34, <3 x float> %35, <3 x float> %29), !dbg !741
  %37 = fadd contract <3 x float> %36, splat (float 1.000000e+00), !dbg !741
  %38 = fptosi <3 x float> %27 to <3 x i32>, !dbg !741
  %39 = add <3 x i32> %38, splat (i32 127), !dbg !741
  %40 = shl <3 x i32> %39, splat (i32 23), !dbg !741
  %41 = bitcast <3 x i32> %40 to <3 x float>, !dbg !741
  %42 = fmul contract <3 x float> %37, %41, !dbg !741
  %43 = call float @llvm.vector.reduce.fadd.v3f32(float 0.000000e+00, <3 x float> %42), !dbg !742
  %44 = insertelement <3 x float> poison, float %43, i32 0, !dbg !743
  %45 = shufflevector <3 x float> %44, <3 x float> poison, <3 x i32> zeroinitializer, !dbg !743
  %46 = fdiv <3 x float> %42, %45, !dbg !744
  store <3 x float> %46, ptr %11, align 4, !dbg !744
  ret i32 0, !dbg !745
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <1 x float> @llvm.fmuladd.v1f32(<1 x float>, <1 x float>, <1 x float>) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.masked.store.v4f32.p0(<4 x float>, ptr captures(none), <4 x i1>) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <4 x float> @llvm.masked.load.v4f32.p0(ptr captures(none), <4 x i1>, <4 x float>) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vp.reduce.fadd.v4f32(float, <4 x float>, <4 x i1>, i32) #5

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fmax.v3f32(<3 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.maxnum.f32(float, float) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <3 x float> @llvm.fma.v3f32(<3 x float>, <3 x float>, <3 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare <3 x float> @llvm.floor.v3f32(<3 x float>) #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v3f32(float, <3 x float>) #2

; Function Attrs: uwtable
define dso_local dllexport ptr @iree_hal_executable_library_query(i32 %0, ptr %1) #6 {
entry:
  %2 = icmp eq i32 %0, 6
  %3 = select i1 %2, ptr @iree_hal_executable_library_query_v0, ptr null
  ret ptr %3
}

attributes #0 = { "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) "frame-pointer"="all" "hot" "no-builtins" "nonlazybind" }
attributes #6 = { uwtable "nonlazybind" }

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22, !24, !26, !28, !30, !32, !34, !36, !38, !40, !42, !44, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78}
!llvm.module.flags = !{!80}

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
!32 = distinct !DICompileUnit(language: DW_LANG_C17, file: !33, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!33 = !DIFile(filename: "configured_module_infer_dispatch_18.mlir", directory: "dump")
!34 = distinct !DICompileUnit(language: DW_LANG_C17, file: !35, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!35 = !DIFile(filename: "configured_module_infer_dispatch_19.mlir", directory: "dump")
!36 = distinct !DICompileUnit(language: DW_LANG_C17, file: !37, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!37 = !DIFile(filename: "configured_module_infer_dispatch_20.mlir", directory: "dump")
!38 = distinct !DICompileUnit(language: DW_LANG_C17, file: !39, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!39 = !DIFile(filename: "configured_module_infer_dispatch_21.mlir", directory: "dump")
!40 = distinct !DICompileUnit(language: DW_LANG_C17, file: !41, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!41 = !DIFile(filename: "configured_module_infer_dispatch_22.mlir", directory: "dump")
!42 = distinct !DICompileUnit(language: DW_LANG_C17, file: !43, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!43 = !DIFile(filename: "configured_module_infer_dispatch_23.mlir", directory: "dump")
!44 = distinct !DICompileUnit(language: DW_LANG_C17, file: !45, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!45 = !DIFile(filename: "configured_module_infer_dispatch_24.mlir", directory: "dump")
!46 = distinct !DICompileUnit(language: DW_LANG_C17, file: !47, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!47 = !DIFile(filename: "configured_module_infer_dispatch_27.mlir", directory: "dump")
!48 = distinct !DICompileUnit(language: DW_LANG_C17, file: !49, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!49 = !DIFile(filename: "configured_module_infer_dispatch_30.mlir", directory: "dump")
!50 = distinct !DICompileUnit(language: DW_LANG_C17, file: !51, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!51 = !DIFile(filename: "configured_module_infer_dispatch_33.mlir", directory: "dump")
!52 = distinct !DICompileUnit(language: DW_LANG_C17, file: !53, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!53 = !DIFile(filename: "configured_module_infer_dispatch_34.mlir", directory: "dump")
!54 = distinct !DICompileUnit(language: DW_LANG_C17, file: !55, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!55 = !DIFile(filename: "configured_module_infer_dispatch_35.mlir", directory: "dump")
!56 = distinct !DICompileUnit(language: DW_LANG_C17, file: !57, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!57 = !DIFile(filename: "configured_module_infer_dispatch_36.mlir", directory: "dump")
!58 = distinct !DICompileUnit(language: DW_LANG_C17, file: !59, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!59 = !DIFile(filename: "configured_module_infer_dispatch_40.mlir", directory: "dump")
!60 = distinct !DICompileUnit(language: DW_LANG_C17, file: !61, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!61 = !DIFile(filename: "configured_module_infer_dispatch_41.mlir", directory: "dump")
!62 = distinct !DICompileUnit(language: DW_LANG_C17, file: !63, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!63 = !DIFile(filename: "configured_module_infer_dispatch_42.mlir", directory: "dump")
!64 = distinct !DICompileUnit(language: DW_LANG_C17, file: !65, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!65 = !DIFile(filename: "configured_module_infer_dispatch_43.mlir", directory: "dump")
!66 = distinct !DICompileUnit(language: DW_LANG_C17, file: !67, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!67 = !DIFile(filename: "configured_module_infer_dispatch_44.mlir", directory: "dump")
!68 = distinct !DICompileUnit(language: DW_LANG_C17, file: !69, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!69 = !DIFile(filename: "configured_module_infer_dispatch_45.mlir", directory: "dump")
!70 = distinct !DICompileUnit(language: DW_LANG_C17, file: !71, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!71 = !DIFile(filename: "configured_module_infer_dispatch_51.mlir", directory: "dump")
!72 = distinct !DICompileUnit(language: DW_LANG_C17, file: !73, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!73 = !DIFile(filename: "configured_module_infer_dispatch_52.mlir", directory: "dump")
!74 = distinct !DICompileUnit(language: DW_LANG_C17, file: !75, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!75 = !DIFile(filename: "configured_module_infer_dispatch_53.mlir", directory: "dump")
!76 = distinct !DICompileUnit(language: DW_LANG_C17, file: !77, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!77 = !DIFile(filename: "configured_module_infer_dispatch_54.mlir", directory: "dump")
!78 = distinct !DICompileUnit(language: DW_LANG_C17, file: !79, producer: "IREE", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!79 = !DIFile(filename: "configured_module_infer_dispatch_55.mlir", directory: "dump")
!80 = !{i32 2, !"Debug Info Version", i32 3}
!81 = distinct !DISubprogram(name: "infer_dispatch_0_elementwise_3x224x224_f32", linkageName: "infer_dispatch_0_elementwise_3x224x224_f32", scope: !1, file: !1, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!82 = !DISubroutineType(cc: DW_CC_normal, types: !83)
!83 = !{!84, !85, !116, !145}
!84 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !87)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_environment_v0_t", baseType: !88)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_environment_v0_t", scope: !89, file: !89, line: 246, size: 768, elements: !90)
!89 = !DIFile(filename: "runtime/src/iree/hal/local/executable_library.h", directory: ".")
!90 = !{!91, !99, !102, !105, !107}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !92, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !94)
!94 = !DICompositeType(tag: DW_TAG_array_type, scope: !89, file: !89, line: 227, baseType: !95, size: 2048, elements: !97)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", baseType: !96)
!96 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!97 = !{!98}
!98 = !DISubrange(count: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "import_thunk", baseType: !100, size: 64, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DIBasicType(name: "void", encoding: DW_ATE_address)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "import_funcs", baseType: !103, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !100)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "import_contexts", baseType: !106, size: 64, offset: 192)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "processor", baseType: !108, offset: 256)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_processor_v0_t", scope: !89, file: !89, line: 227, size: 512, elements: !109)
!109 = !{!110}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "data", baseType: !111)
!111 = !DICompositeType(tag: DW_TAG_array_type, scope: !89, file: !89, line: 227, baseType: !112, size: 512, elements: !114)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", baseType: !113)
!113 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!114 = !{!115}
!115 = !DISubrange(count: 8)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !118)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_dispatch_state_v0_t", baseType: !119)
!119 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_dispatch_state_v0_t", scope: !89, file: !89, line: 275, size: 384, elements: !120)
!120 = !{!121, !122, !123, !126, !127, !128, !129, !130, !133, !134, !135, !140}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_x", baseType: !95, size: 32)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_y", baseType: !95, size: 32, offset: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_size_z", baseType: !124, size: 16, offset: 64)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", baseType: !125)
!125 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "constant_count", baseType: !124, size: 16, offset: 80)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_x", baseType: !95, size: 32, offset: 96)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_y", baseType: !95, size: 32, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_count_z", baseType: !124, size: 16, offset: 160)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "max_concurrency", baseType: !131, size: 8, offset: 176)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", baseType: !132)
!132 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "binding_count", baseType: !131, size: 8, offset: 184)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "constants", baseType: !92, size: 64, offset: 192)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "binding_ptrs", baseType: !136, size: 64, offset: 256)
!136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!137 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !138)
!138 = !DICompositeType(tag: DW_TAG_array_type, scope: !89, file: !89, line: 227, baseType: !139, size: 4096, elements: !97)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "binding_lengths", baseType: !141, size: 64, offset: 320)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !143)
!143 = !DICompositeType(tag: DW_TAG_array_type, scope: !89, file: !89, line: 227, baseType: !144, size: 4096, elements: !97)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", baseType: !112)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !147)
!147 = !DIDerivedType(tag: DW_TAG_typedef, name: "iree_hal_executable_workgroup_state_v0_t", baseType: !148)
!148 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iree_hal_executable_workgroup_state_v0_t", scope: !89, file: !89, line: 321, size: 256, elements: !149)
!149 = !{!150, !151, !152, !153, !154, !155, !156}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_x", baseType: !95, size: 32)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_y", baseType: !95, size: 32, offset: 32)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "workgroup_id_z", baseType: !124, size: 16, offset: 64)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", baseType: !124, size: 16, offset: 80)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "processor_id", baseType: !95, size: 32, offset: 96)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory", baseType: !100, size: 64, offset: 128)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "local_memory_size", baseType: !95, size: 32, offset: 192)
!157 = !DILocation(line: 12, column: 8, scope: !81)
!158 = !DILocation(line: 13, column: 8, scope: !81)
!159 = !DILocation(line: 16, column: 8, scope: !81)
!160 = !DILocation(line: 18, column: 10, scope: !81)
!161 = !DILocation(line: 19, column: 10, scope: !81)
!162 = !DILocation(line: 23, column: 8, scope: !81)
!163 = distinct !DISubprogram(name: "infer_dispatch_1_conv_32x112x112x3x3x3_f32", linkageName: "infer_dispatch_1_conv_32x112x112x3x3x3_f32", scope: !3, file: !3, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!164 = !DILocation(line: 22, column: 8, scope: !163)
!165 = !DILocation(line: 21, column: 8, scope: !163)
!166 = !DILocation(line: 15, column: 8, scope: !163)
!167 = !DILocation(line: 16, column: 8, scope: !163)
!168 = !DILocation(line: 17, column: 8, scope: !163)
!169 = !DILocation(line: 9, column: 8, scope: !163)
!170 = !DILocation(line: 28, column: 8, scope: !163)
!171 = !DILocation(line: 24, column: 10, scope: !163)
!172 = !DILocation(line: 25, column: 10, scope: !163)
!173 = !DILocation(line: 30, column: 10, scope: !163)
!174 = !DILocation(line: 31, column: 10, scope: !163)
!175 = !DILocation(line: 32, column: 10, scope: !163)
!176 = !DILocation(line: 33, column: 10, scope: !163)
!177 = !DILocation(line: 34, column: 10, scope: !163)
!178 = !DILocation(line: 38, column: 8, scope: !163)
!179 = distinct !DISubprogram(name: "infer_dispatch_2_conv_112x112x32x3x3_f32", linkageName: "infer_dispatch_2_conv_112x112x32x3x3_f32", scope: !5, file: !5, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !4)
!180 = !DILocation(line: 22, column: 8, scope: !179)
!181 = !DILocation(line: 21, column: 8, scope: !179)
!182 = !DILocation(line: 15, column: 8, scope: !179)
!183 = !DILocation(line: 16, column: 8, scope: !179)
!184 = !DILocation(line: 17, column: 8, scope: !179)
!185 = !DILocation(line: 9, column: 8, scope: !179)
!186 = !DILocation(line: 24, column: 10, scope: !179)
!187 = !DILocation(line: 25, column: 10, scope: !179)
!188 = !DILocation(line: 28, column: 8, scope: !179)
!189 = !DILocation(line: 30, column: 10, scope: !179)
!190 = !DILocation(line: 31, column: 10, scope: !179)
!191 = !DILocation(line: 32, column: 10, scope: !179)
!192 = !DILocation(line: 33, column: 10, scope: !179)
!193 = !DILocation(line: 34, column: 10, scope: !179)
!194 = !DILocation(line: 38, column: 8, scope: !179)
!195 = distinct !DISubprogram(name: "infer_dispatch_3_matmul_like_16x12544x32_f32", linkageName: "infer_dispatch_3_matmul_like_16x12544x32_f32", scope: !7, file: !7, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !6)
!196 = !DILocation(line: 14, column: 8, scope: !195)
!197 = !DILocation(line: 15, column: 8, scope: !195)
!198 = !DILocation(line: 16, column: 8, scope: !195)
!199 = !DILocation(line: 21, column: 8, scope: !195)
!200 = !DILocation(line: 27, column: 8, scope: !195)
!201 = !DILocation(line: 24, column: 10, scope: !195)
!202 = !DILocation(line: 29, column: 10, scope: !195)
!203 = !DILocation(line: 33, column: 8, scope: !195)
!204 = distinct !DISubprogram(name: "infer_dispatch_4_matmul_like_96x112x112x16_f32", linkageName: "infer_dispatch_4_matmul_like_96x112x112x16_f32", scope: !9, file: !9, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8)
!205 = !DILocation(line: 15, column: 8, scope: !204)
!206 = !DILocation(line: 16, column: 8, scope: !204)
!207 = !DILocation(line: 17, column: 8, scope: !204)
!208 = !DILocation(line: 18, column: 8, scope: !204)
!209 = !DILocation(line: 24, column: 8, scope: !204)
!210 = !DILocation(line: 30, column: 8, scope: !204)
!211 = !DILocation(line: 27, column: 10, scope: !204)
!212 = !DILocation(line: 32, column: 10, scope: !204)
!213 = !DILocation(line: 33, column: 10, scope: !204)
!214 = !DILocation(line: 34, column: 10, scope: !204)
!215 = !DILocation(line: 35, column: 10, scope: !204)
!216 = !DILocation(line: 36, column: 10, scope: !204)
!217 = !DILocation(line: 40, column: 8, scope: !204)
!218 = distinct !DISubprogram(name: "infer_dispatch_5_conv_56x56x96x3x3_f32", linkageName: "infer_dispatch_5_conv_56x56x96x3x3_f32", scope: !11, file: !11, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !10)
!219 = !DILocation(line: 24, column: 8, scope: !218)
!220 = !DILocation(line: 23, column: 8, scope: !218)
!221 = !DILocation(line: 15, column: 8, scope: !218)
!222 = !DILocation(line: 16, column: 8, scope: !218)
!223 = !DILocation(line: 17, column: 8, scope: !218)
!224 = !DILocation(line: 18, column: 8, scope: !218)
!225 = !DILocation(line: 9, column: 8, scope: !218)
!226 = !DILocation(line: 26, column: 10, scope: !218)
!227 = !DILocation(line: 27, column: 10, scope: !218)
!228 = !DILocation(line: 30, column: 8, scope: !218)
!229 = !DILocation(line: 32, column: 10, scope: !218)
!230 = !DILocation(line: 33, column: 10, scope: !218)
!231 = !DILocation(line: 34, column: 10, scope: !218)
!232 = !DILocation(line: 35, column: 10, scope: !218)
!233 = !DILocation(line: 36, column: 10, scope: !218)
!234 = !DILocation(line: 40, column: 8, scope: !218)
!235 = distinct !DISubprogram(name: "infer_dispatch_6_matmul_like_24x3136x96_f32", linkageName: "infer_dispatch_6_matmul_like_24x3136x96_f32", scope: !13, file: !13, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !12)
!236 = !DILocation(line: 14, column: 8, scope: !235)
!237 = !DILocation(line: 15, column: 8, scope: !235)
!238 = !DILocation(line: 16, column: 8, scope: !235)
!239 = !DILocation(line: 21, column: 8, scope: !235)
!240 = !DILocation(line: 27, column: 8, scope: !235)
!241 = !DILocation(line: 24, column: 10, scope: !235)
!242 = !DILocation(line: 29, column: 10, scope: !235)
!243 = !DILocation(line: 33, column: 8, scope: !235)
!244 = distinct !DISubprogram(name: "infer_dispatch_7_matmul_like_144x56x56x24_f32", linkageName: "infer_dispatch_7_matmul_like_144x56x56x24_f32", scope: !15, file: !15, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14)
!245 = !DILocation(line: 15, column: 8, scope: !244)
!246 = !DILocation(line: 16, column: 8, scope: !244)
!247 = !DILocation(line: 17, column: 8, scope: !244)
!248 = !DILocation(line: 18, column: 8, scope: !244)
!249 = !DILocation(line: 24, column: 8, scope: !244)
!250 = !DILocation(line: 30, column: 8, scope: !244)
!251 = !DILocation(line: 27, column: 10, scope: !244)
!252 = !DILocation(line: 32, column: 10, scope: !244)
!253 = !DILocation(line: 33, column: 10, scope: !244)
!254 = !DILocation(line: 34, column: 10, scope: !244)
!255 = !DILocation(line: 35, column: 10, scope: !244)
!256 = !DILocation(line: 36, column: 10, scope: !244)
!257 = !DILocation(line: 40, column: 8, scope: !244)
!258 = distinct !DISubprogram(name: "infer_dispatch_8_conv_56x56x144x3x3_f32", linkageName: "infer_dispatch_8_conv_56x56x144x3x3_f32", scope: !17, file: !17, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !16)
!259 = !DILocation(line: 24, column: 8, scope: !258)
!260 = !DILocation(line: 23, column: 8, scope: !258)
!261 = !DILocation(line: 15, column: 8, scope: !258)
!262 = !DILocation(line: 16, column: 8, scope: !258)
!263 = !DILocation(line: 17, column: 8, scope: !258)
!264 = !DILocation(line: 18, column: 8, scope: !258)
!265 = !DILocation(line: 9, column: 8, scope: !258)
!266 = !DILocation(line: 26, column: 10, scope: !258)
!267 = !DILocation(line: 27, column: 10, scope: !258)
!268 = !DILocation(line: 30, column: 8, scope: !258)
!269 = !DILocation(line: 32, column: 10, scope: !258)
!270 = !DILocation(line: 33, column: 10, scope: !258)
!271 = !DILocation(line: 34, column: 10, scope: !258)
!272 = !DILocation(line: 35, column: 10, scope: !258)
!273 = !DILocation(line: 36, column: 10, scope: !258)
!274 = !DILocation(line: 40, column: 8, scope: !258)
!275 = distinct !DISubprogram(name: "infer_dispatch_9_matmul_like_24x3136x144_f32", linkageName: "infer_dispatch_9_matmul_like_24x3136x144_f32", scope: !19, file: !19, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !18)
!276 = !DILocation(line: 15, column: 8, scope: !275)
!277 = !DILocation(line: 16, column: 8, scope: !275)
!278 = !DILocation(line: 17, column: 8, scope: !275)
!279 = !DILocation(line: 18, column: 8, scope: !275)
!280 = !DILocation(line: 24, column: 8, scope: !275)
!281 = !DILocation(line: 30, column: 8, scope: !275)
!282 = !DILocation(line: 27, column: 10, scope: !275)
!283 = !DILocation(line: 32, column: 10, scope: !275)
!284 = !DILocation(line: 33, column: 10, scope: !275)
!285 = !DILocation(line: 37, column: 8, scope: !275)
!286 = distinct !DISubprogram(name: "infer_dispatch_10_matmul_like_144x56x56x24_f32", linkageName: "infer_dispatch_10_matmul_like_144x56x56x24_f32", scope: !21, file: !21, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!287 = !DILocation(line: 15, column: 8, scope: !286)
!288 = !DILocation(line: 16, column: 8, scope: !286)
!289 = !DILocation(line: 17, column: 8, scope: !286)
!290 = !DILocation(line: 18, column: 8, scope: !286)
!291 = !DILocation(line: 24, column: 8, scope: !286)
!292 = !DILocation(line: 30, column: 8, scope: !286)
!293 = !DILocation(line: 27, column: 10, scope: !286)
!294 = !DILocation(line: 32, column: 10, scope: !286)
!295 = !DILocation(line: 33, column: 10, scope: !286)
!296 = !DILocation(line: 34, column: 10, scope: !286)
!297 = !DILocation(line: 35, column: 10, scope: !286)
!298 = !DILocation(line: 36, column: 10, scope: !286)
!299 = !DILocation(line: 40, column: 8, scope: !286)
!300 = distinct !DISubprogram(name: "infer_dispatch_11_conv_28x28x144x3x3_f32", linkageName: "infer_dispatch_11_conv_28x28x144x3x3_f32", scope: !23, file: !23, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !22)
!301 = !DILocation(line: 24, column: 8, scope: !300)
!302 = !DILocation(line: 23, column: 8, scope: !300)
!303 = !DILocation(line: 15, column: 8, scope: !300)
!304 = !DILocation(line: 16, column: 8, scope: !300)
!305 = !DILocation(line: 17, column: 8, scope: !300)
!306 = !DILocation(line: 18, column: 8, scope: !300)
!307 = !DILocation(line: 9, column: 8, scope: !300)
!308 = !DILocation(line: 26, column: 10, scope: !300)
!309 = !DILocation(line: 27, column: 10, scope: !300)
!310 = !DILocation(line: 30, column: 8, scope: !300)
!311 = !DILocation(line: 32, column: 10, scope: !300)
!312 = !DILocation(line: 33, column: 10, scope: !300)
!313 = !DILocation(line: 34, column: 10, scope: !300)
!314 = !DILocation(line: 35, column: 10, scope: !300)
!315 = !DILocation(line: 36, column: 10, scope: !300)
!316 = !DILocation(line: 40, column: 8, scope: !300)
!317 = distinct !DISubprogram(name: "infer_dispatch_12_matmul_like_32x784x144_f32", linkageName: "infer_dispatch_12_matmul_like_32x784x144_f32", scope: !25, file: !25, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !24)
!318 = !DILocation(line: 14, column: 8, scope: !317)
!319 = !DILocation(line: 15, column: 8, scope: !317)
!320 = !DILocation(line: 16, column: 8, scope: !317)
!321 = !DILocation(line: 21, column: 8, scope: !317)
!322 = !DILocation(line: 27, column: 8, scope: !317)
!323 = !DILocation(line: 24, column: 10, scope: !317)
!324 = !DILocation(line: 29, column: 10, scope: !317)
!325 = !DILocation(line: 33, column: 8, scope: !317)
!326 = distinct !DISubprogram(name: "infer_dispatch_13_matmul_like_192x28x28x32_f32", linkageName: "infer_dispatch_13_matmul_like_192x28x28x32_f32", scope: !27, file: !27, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !26)
!327 = !DILocation(line: 12, column: 8, scope: !326)
!328 = !DILocation(line: 13, column: 8, scope: !326)
!329 = !DILocation(line: 14, column: 8, scope: !326)
!330 = !DILocation(line: 15, column: 8, scope: !326)
!331 = !DILocation(line: 16, column: 8, scope: !326)
!332 = !DILocation(line: 17, column: 8, scope: !326)
!333 = !DILocation(line: 23, column: 8, scope: !326)
!334 = !DILocation(line: 24, column: 8, scope: !326)
!335 = !DILocation(line: 25, column: 8, scope: !326)
!336 = !DILocation(line: 26, column: 8, scope: !326)
!337 = !DILocation(line: 32, column: 8, scope: !326)
!338 = !DILocation(line: 38, column: 8, scope: !326)
!339 = !DILocation(line: 35, column: 10, scope: !326)
!340 = !DILocation(line: 40, column: 10, scope: !326)
!341 = !DILocation(line: 41, column: 10, scope: !326)
!342 = !DILocation(line: 42, column: 10, scope: !326)
!343 = !DILocation(line: 43, column: 10, scope: !326)
!344 = !DILocation(line: 44, column: 10, scope: !326)
!345 = !DILocation(line: 48, column: 8, scope: !326)
!346 = distinct !DISubprogram(name: "infer_dispatch_14_conv_28x28x192x3x3_f32", linkageName: "infer_dispatch_14_conv_28x28x192x3x3_f32", scope: !29, file: !29, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !28)
!347 = !DILocation(line: 30, column: 8, scope: !346)
!348 = !DILocation(line: 29, column: 8, scope: !346)
!349 = !DILocation(line: 13, column: 8, scope: !346)
!350 = !DILocation(line: 14, column: 8, scope: !346)
!351 = !DILocation(line: 15, column: 8, scope: !346)
!352 = !DILocation(line: 16, column: 8, scope: !346)
!353 = !DILocation(line: 21, column: 8, scope: !346)
!354 = !DILocation(line: 22, column: 8, scope: !346)
!355 = !DILocation(line: 23, column: 8, scope: !346)
!356 = !DILocation(line: 24, column: 8, scope: !346)
!357 = !DILocation(line: 10, column: 8, scope: !346)
!358 = !DILocation(line: 32, column: 10, scope: !346)
!359 = !DILocation(line: 33, column: 10, scope: !346)
!360 = !DILocation(line: 36, column: 8, scope: !346)
!361 = !DILocation(line: 38, column: 10, scope: !346)
!362 = !DILocation(line: 39, column: 10, scope: !346)
!363 = !DILocation(line: 40, column: 10, scope: !346)
!364 = !DILocation(line: 41, column: 10, scope: !346)
!365 = !DILocation(line: 42, column: 10, scope: !346)
!366 = !DILocation(line: 46, column: 8, scope: !346)
!367 = distinct !DISubprogram(name: "infer_dispatch_15_matmul_like_32x784x192_f32", linkageName: "infer_dispatch_15_matmul_like_32x784x192_f32", scope: !31, file: !31, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !30)
!368 = !DILocation(line: 15, column: 8, scope: !367)
!369 = !DILocation(line: 16, column: 8, scope: !367)
!370 = !DILocation(line: 17, column: 8, scope: !367)
!371 = !DILocation(line: 18, column: 8, scope: !367)
!372 = !DILocation(line: 24, column: 8, scope: !367)
!373 = !DILocation(line: 30, column: 8, scope: !367)
!374 = !DILocation(line: 27, column: 10, scope: !367)
!375 = !DILocation(line: 32, column: 10, scope: !367)
!376 = !DILocation(line: 33, column: 10, scope: !367)
!377 = !DILocation(line: 37, column: 8, scope: !367)
!378 = distinct !DISubprogram(name: "infer_dispatch_18_matmul_like_32x784x192_f32", linkageName: "infer_dispatch_18_matmul_like_32x784x192_f32", scope: !33, file: !33, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32)
!379 = !DILocation(line: 15, column: 8, scope: !378)
!380 = !DILocation(line: 16, column: 8, scope: !378)
!381 = !DILocation(line: 17, column: 8, scope: !378)
!382 = !DILocation(line: 18, column: 8, scope: !378)
!383 = !DILocation(line: 24, column: 8, scope: !378)
!384 = !DILocation(line: 30, column: 8, scope: !378)
!385 = !DILocation(line: 27, column: 10, scope: !378)
!386 = !DILocation(line: 32, column: 10, scope: !378)
!387 = !DILocation(line: 33, column: 10, scope: !378)
!388 = !DILocation(line: 37, column: 8, scope: !378)
!389 = distinct !DISubprogram(name: "infer_dispatch_19_matmul_like_192x28x28x32_f32", linkageName: "infer_dispatch_19_matmul_like_192x28x28x32_f32", scope: !35, file: !35, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !34)
!390 = !DILocation(line: 15, column: 8, scope: !389)
!391 = !DILocation(line: 16, column: 8, scope: !389)
!392 = !DILocation(line: 17, column: 8, scope: !389)
!393 = !DILocation(line: 18, column: 8, scope: !389)
!394 = !DILocation(line: 24, column: 8, scope: !389)
!395 = !DILocation(line: 30, column: 8, scope: !389)
!396 = !DILocation(line: 27, column: 10, scope: !389)
!397 = !DILocation(line: 32, column: 10, scope: !389)
!398 = !DILocation(line: 33, column: 10, scope: !389)
!399 = !DILocation(line: 34, column: 10, scope: !389)
!400 = !DILocation(line: 35, column: 10, scope: !389)
!401 = !DILocation(line: 36, column: 10, scope: !389)
!402 = !DILocation(line: 40, column: 8, scope: !389)
!403 = distinct !DISubprogram(name: "infer_dispatch_20_conv_14x14x192x3x3_f32", linkageName: "infer_dispatch_20_conv_14x14x192x3x3_f32", scope: !37, file: !37, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !36)
!404 = !DILocation(line: 24, column: 8, scope: !403)
!405 = !DILocation(line: 23, column: 8, scope: !403)
!406 = !DILocation(line: 15, column: 8, scope: !403)
!407 = !DILocation(line: 16, column: 8, scope: !403)
!408 = !DILocation(line: 17, column: 8, scope: !403)
!409 = !DILocation(line: 18, column: 8, scope: !403)
!410 = !DILocation(line: 9, column: 8, scope: !403)
!411 = !DILocation(line: 26, column: 10, scope: !403)
!412 = !DILocation(line: 27, column: 10, scope: !403)
!413 = !DILocation(line: 30, column: 8, scope: !403)
!414 = !DILocation(line: 32, column: 10, scope: !403)
!415 = !DILocation(line: 33, column: 10, scope: !403)
!416 = !DILocation(line: 34, column: 10, scope: !403)
!417 = !DILocation(line: 35, column: 10, scope: !403)
!418 = !DILocation(line: 36, column: 10, scope: !403)
!419 = !DILocation(line: 40, column: 8, scope: !403)
!420 = distinct !DISubprogram(name: "infer_dispatch_21_matmul_like_64x196x192_f32", linkageName: "infer_dispatch_21_matmul_like_64x196x192_f32", scope: !39, file: !39, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !38)
!421 = !DILocation(line: 14, column: 8, scope: !420)
!422 = !DILocation(line: 15, column: 8, scope: !420)
!423 = !DILocation(line: 16, column: 8, scope: !420)
!424 = !DILocation(line: 21, column: 8, scope: !420)
!425 = !DILocation(line: 27, column: 8, scope: !420)
!426 = !DILocation(line: 24, column: 10, scope: !420)
!427 = !DILocation(line: 29, column: 10, scope: !420)
!428 = !DILocation(line: 33, column: 8, scope: !420)
!429 = distinct !DISubprogram(name: "infer_dispatch_22_matmul_like_384x14x14x64_f32", linkageName: "infer_dispatch_22_matmul_like_384x14x14x64_f32", scope: !41, file: !41, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !40)
!430 = !DILocation(line: 11, column: 8, scope: !429)
!431 = !DILocation(line: 12, column: 8, scope: !429)
!432 = !DILocation(line: 13, column: 8, scope: !429)
!433 = !DILocation(line: 14, column: 8, scope: !429)
!434 = !DILocation(line: 15, column: 8, scope: !429)
!435 = !DILocation(line: 16, column: 8, scope: !429)
!436 = !DILocation(line: 17, column: 8, scope: !429)
!437 = !DILocation(line: 18, column: 8, scope: !429)
!438 = !DILocation(line: 25, column: 8, scope: !429)
!439 = !DILocation(line: 26, column: 8, scope: !429)
!440 = !DILocation(line: 27, column: 8, scope: !429)
!441 = !DILocation(line: 28, column: 8, scope: !429)
!442 = !DILocation(line: 34, column: 8, scope: !429)
!443 = !DILocation(line: 40, column: 8, scope: !429)
!444 = !DILocation(line: 37, column: 10, scope: !429)
!445 = !DILocation(line: 42, column: 10, scope: !429)
!446 = !DILocation(line: 43, column: 10, scope: !429)
!447 = !DILocation(line: 44, column: 10, scope: !429)
!448 = !DILocation(line: 45, column: 10, scope: !429)
!449 = !DILocation(line: 46, column: 10, scope: !429)
!450 = !DILocation(line: 50, column: 8, scope: !429)
!451 = distinct !DISubprogram(name: "infer_dispatch_23_conv_14x14x384x3x3_f32", linkageName: "infer_dispatch_23_conv_14x14x384x3x3_f32", scope: !43, file: !43, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !42)
!452 = !DILocation(line: 34, column: 8, scope: !451)
!453 = !DILocation(line: 33, column: 8, scope: !451)
!454 = !DILocation(line: 11, column: 8, scope: !451)
!455 = !DILocation(line: 12, column: 8, scope: !451)
!456 = !DILocation(line: 13, column: 8, scope: !451)
!457 = !DILocation(line: 14, column: 8, scope: !451)
!458 = !DILocation(line: 15, column: 8, scope: !451)
!459 = !DILocation(line: 16, column: 8, scope: !451)
!460 = !DILocation(line: 17, column: 8, scope: !451)
!461 = !DILocation(line: 18, column: 8, scope: !451)
!462 = !DILocation(line: 25, column: 8, scope: !451)
!463 = !DILocation(line: 26, column: 8, scope: !451)
!464 = !DILocation(line: 27, column: 8, scope: !451)
!465 = !DILocation(line: 28, column: 8, scope: !451)
!466 = !DILocation(line: 10, column: 8, scope: !451)
!467 = !DILocation(line: 36, column: 10, scope: !451)
!468 = !DILocation(line: 37, column: 10, scope: !451)
!469 = !DILocation(line: 40, column: 8, scope: !451)
!470 = !DILocation(line: 42, column: 10, scope: !451)
!471 = !DILocation(line: 43, column: 10, scope: !451)
!472 = !DILocation(line: 44, column: 10, scope: !451)
!473 = !DILocation(line: 45, column: 10, scope: !451)
!474 = !DILocation(line: 46, column: 10, scope: !451)
!475 = !DILocation(line: 50, column: 8, scope: !451)
!476 = distinct !DISubprogram(name: "infer_dispatch_24_matmul_like_64x196x384_f32", linkageName: "infer_dispatch_24_matmul_like_64x196x384_f32", scope: !45, file: !45, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !44)
!477 = !DILocation(line: 15, column: 8, scope: !476)
!478 = !DILocation(line: 16, column: 8, scope: !476)
!479 = !DILocation(line: 17, column: 8, scope: !476)
!480 = !DILocation(line: 18, column: 8, scope: !476)
!481 = !DILocation(line: 24, column: 8, scope: !476)
!482 = !DILocation(line: 30, column: 8, scope: !476)
!483 = !DILocation(line: 27, column: 10, scope: !476)
!484 = !DILocation(line: 32, column: 10, scope: !476)
!485 = !DILocation(line: 33, column: 10, scope: !476)
!486 = !DILocation(line: 37, column: 8, scope: !476)
!487 = distinct !DISubprogram(name: "infer_dispatch_27_matmul_like_64x196x384_f32", linkageName: "infer_dispatch_27_matmul_like_64x196x384_f32", scope: !47, file: !47, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !46)
!488 = !DILocation(line: 15, column: 8, scope: !487)
!489 = !DILocation(line: 16, column: 8, scope: !487)
!490 = !DILocation(line: 17, column: 8, scope: !487)
!491 = !DILocation(line: 18, column: 8, scope: !487)
!492 = !DILocation(line: 24, column: 8, scope: !487)
!493 = !DILocation(line: 30, column: 8, scope: !487)
!494 = !DILocation(line: 27, column: 10, scope: !487)
!495 = !DILocation(line: 32, column: 10, scope: !487)
!496 = !DILocation(line: 33, column: 10, scope: !487)
!497 = !DILocation(line: 37, column: 8, scope: !487)
!498 = distinct !DISubprogram(name: "infer_dispatch_30_matmul_like_64x196x384_f32", linkageName: "infer_dispatch_30_matmul_like_64x196x384_f32", scope: !49, file: !49, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !48)
!499 = !DILocation(line: 15, column: 8, scope: !498)
!500 = !DILocation(line: 16, column: 8, scope: !498)
!501 = !DILocation(line: 17, column: 8, scope: !498)
!502 = !DILocation(line: 18, column: 8, scope: !498)
!503 = !DILocation(line: 24, column: 8, scope: !498)
!504 = !DILocation(line: 30, column: 8, scope: !498)
!505 = !DILocation(line: 27, column: 10, scope: !498)
!506 = !DILocation(line: 32, column: 10, scope: !498)
!507 = !DILocation(line: 33, column: 10, scope: !498)
!508 = !DILocation(line: 37, column: 8, scope: !498)
!509 = distinct !DISubprogram(name: "infer_dispatch_33_matmul_like_96x196x384_f32", linkageName: "infer_dispatch_33_matmul_like_96x196x384_f32", scope: !51, file: !51, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !50)
!510 = !DILocation(line: 14, column: 8, scope: !509)
!511 = !DILocation(line: 15, column: 8, scope: !509)
!512 = !DILocation(line: 16, column: 8, scope: !509)
!513 = !DILocation(line: 17, column: 8, scope: !509)
!514 = !DILocation(line: 23, column: 8, scope: !509)
!515 = !DILocation(line: 29, column: 8, scope: !509)
!516 = !DILocation(line: 26, column: 10, scope: !509)
!517 = !DILocation(line: 31, column: 10, scope: !509)
!518 = !DILocation(line: 35, column: 8, scope: !509)
!519 = distinct !DISubprogram(name: "infer_dispatch_34_matmul_like_576x14x14x96_f32", linkageName: "infer_dispatch_34_matmul_like_576x14x14x96_f32", scope: !53, file: !53, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !52)
!520 = !DILocation(line: 11, column: 8, scope: !519)
!521 = !DILocation(line: 12, column: 8, scope: !519)
!522 = !DILocation(line: 13, column: 8, scope: !519)
!523 = !DILocation(line: 14, column: 8, scope: !519)
!524 = !DILocation(line: 15, column: 8, scope: !519)
!525 = !DILocation(line: 16, column: 8, scope: !519)
!526 = !DILocation(line: 17, column: 8, scope: !519)
!527 = !DILocation(line: 18, column: 8, scope: !519)
!528 = !DILocation(line: 25, column: 8, scope: !519)
!529 = !DILocation(line: 26, column: 8, scope: !519)
!530 = !DILocation(line: 27, column: 8, scope: !519)
!531 = !DILocation(line: 28, column: 8, scope: !519)
!532 = !DILocation(line: 34, column: 8, scope: !519)
!533 = !DILocation(line: 40, column: 8, scope: !519)
!534 = !DILocation(line: 37, column: 10, scope: !519)
!535 = !DILocation(line: 42, column: 10, scope: !519)
!536 = !DILocation(line: 43, column: 10, scope: !519)
!537 = !DILocation(line: 44, column: 10, scope: !519)
!538 = !DILocation(line: 45, column: 10, scope: !519)
!539 = !DILocation(line: 46, column: 10, scope: !519)
!540 = !DILocation(line: 50, column: 8, scope: !519)
!541 = distinct !DISubprogram(name: "infer_dispatch_35_conv_14x14x576x3x3_f32", linkageName: "infer_dispatch_35_conv_14x14x576x3x3_f32", scope: !55, file: !55, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !54)
!542 = !DILocation(line: 34, column: 8, scope: !541)
!543 = !DILocation(line: 33, column: 8, scope: !541)
!544 = !DILocation(line: 11, column: 8, scope: !541)
!545 = !DILocation(line: 12, column: 8, scope: !541)
!546 = !DILocation(line: 13, column: 8, scope: !541)
!547 = !DILocation(line: 14, column: 8, scope: !541)
!548 = !DILocation(line: 15, column: 8, scope: !541)
!549 = !DILocation(line: 16, column: 8, scope: !541)
!550 = !DILocation(line: 17, column: 8, scope: !541)
!551 = !DILocation(line: 18, column: 8, scope: !541)
!552 = !DILocation(line: 25, column: 8, scope: !541)
!553 = !DILocation(line: 26, column: 8, scope: !541)
!554 = !DILocation(line: 27, column: 8, scope: !541)
!555 = !DILocation(line: 28, column: 8, scope: !541)
!556 = !DILocation(line: 10, column: 8, scope: !541)
!557 = !DILocation(line: 36, column: 10, scope: !541)
!558 = !DILocation(line: 37, column: 10, scope: !541)
!559 = !DILocation(line: 40, column: 8, scope: !541)
!560 = !DILocation(line: 42, column: 10, scope: !541)
!561 = !DILocation(line: 43, column: 10, scope: !541)
!562 = !DILocation(line: 44, column: 10, scope: !541)
!563 = !DILocation(line: 45, column: 10, scope: !541)
!564 = !DILocation(line: 46, column: 10, scope: !541)
!565 = !DILocation(line: 50, column: 8, scope: !541)
!566 = distinct !DISubprogram(name: "infer_dispatch_36_matmul_like_96x196x576_f32", linkageName: "infer_dispatch_36_matmul_like_96x196x576_f32", scope: !57, file: !57, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !56)
!567 = !DILocation(line: 10, column: 8, scope: !566)
!568 = !DILocation(line: 11, column: 8, scope: !566)
!569 = !DILocation(line: 12, column: 8, scope: !566)
!570 = !DILocation(line: 13, column: 8, scope: !566)
!571 = !DILocation(line: 14, column: 8, scope: !566)
!572 = !DILocation(line: 15, column: 8, scope: !566)
!573 = !DILocation(line: 16, column: 8, scope: !566)
!574 = !DILocation(line: 17, column: 8, scope: !566)
!575 = !DILocation(line: 18, column: 8, scope: !566)
!576 = !DILocation(line: 19, column: 8, scope: !566)
!577 = !DILocation(line: 27, column: 8, scope: !566)
!578 = !DILocation(line: 28, column: 8, scope: !566)
!579 = !DILocation(line: 29, column: 8, scope: !566)
!580 = !DILocation(line: 30, column: 8, scope: !566)
!581 = !DILocation(line: 31, column: 8, scope: !566)
!582 = !DILocation(line: 38, column: 8, scope: !566)
!583 = !DILocation(line: 44, column: 8, scope: !566)
!584 = !DILocation(line: 41, column: 10, scope: !566)
!585 = !DILocation(line: 46, column: 10, scope: !566)
!586 = !DILocation(line: 47, column: 10, scope: !566)
!587 = !DILocation(line: 51, column: 8, scope: !566)
!588 = distinct !DISubprogram(name: "infer_dispatch_40_matmul_like_576x14x14x96_f32", linkageName: "infer_dispatch_40_matmul_like_576x14x14x96_f32", scope: !59, file: !59, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !58)
!589 = !DILocation(line: 15, column: 8, scope: !588)
!590 = !DILocation(line: 16, column: 8, scope: !588)
!591 = !DILocation(line: 17, column: 8, scope: !588)
!592 = !DILocation(line: 18, column: 8, scope: !588)
!593 = !DILocation(line: 24, column: 8, scope: !588)
!594 = !DILocation(line: 30, column: 8, scope: !588)
!595 = !DILocation(line: 27, column: 10, scope: !588)
!596 = !DILocation(line: 32, column: 10, scope: !588)
!597 = !DILocation(line: 33, column: 10, scope: !588)
!598 = !DILocation(line: 34, column: 10, scope: !588)
!599 = !DILocation(line: 35, column: 10, scope: !588)
!600 = !DILocation(line: 36, column: 10, scope: !588)
!601 = !DILocation(line: 40, column: 8, scope: !588)
!602 = distinct !DISubprogram(name: "infer_dispatch_41_conv_7x7x576x3x3_f32", linkageName: "infer_dispatch_41_conv_7x7x576x3x3_f32", scope: !61, file: !61, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !60)
!603 = !DILocation(line: 24, column: 8, scope: !602)
!604 = !DILocation(line: 23, column: 8, scope: !602)
!605 = !DILocation(line: 15, column: 8, scope: !602)
!606 = !DILocation(line: 16, column: 8, scope: !602)
!607 = !DILocation(line: 17, column: 8, scope: !602)
!608 = !DILocation(line: 18, column: 8, scope: !602)
!609 = !DILocation(line: 9, column: 8, scope: !602)
!610 = !DILocation(line: 26, column: 10, scope: !602)
!611 = !DILocation(line: 27, column: 10, scope: !602)
!612 = !DILocation(line: 30, column: 8, scope: !602)
!613 = !DILocation(line: 32, column: 10, scope: !602)
!614 = !DILocation(line: 33, column: 10, scope: !602)
!615 = !DILocation(line: 34, column: 10, scope: !602)
!616 = !DILocation(line: 35, column: 10, scope: !602)
!617 = !DILocation(line: 36, column: 10, scope: !602)
!618 = !DILocation(line: 40, column: 8, scope: !602)
!619 = distinct !DISubprogram(name: "infer_dispatch_42_matmul_like_160x49x576_f32", linkageName: "infer_dispatch_42_matmul_like_160x49x576_f32", scope: !63, file: !63, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !62)
!620 = !DILocation(line: 14, column: 8, scope: !619)
!621 = !DILocation(line: 15, column: 8, scope: !619)
!622 = !DILocation(line: 16, column: 8, scope: !619)
!623 = !DILocation(line: 17, column: 8, scope: !619)
!624 = !DILocation(line: 23, column: 8, scope: !619)
!625 = !DILocation(line: 29, column: 8, scope: !619)
!626 = !DILocation(line: 26, column: 10, scope: !619)
!627 = !DILocation(line: 31, column: 10, scope: !619)
!628 = !DILocation(line: 35, column: 8, scope: !619)
!629 = distinct !DISubprogram(name: "infer_dispatch_43_matmul_like_960x7x7x160_f32", linkageName: "infer_dispatch_43_matmul_like_960x7x7x160_f32", scope: !65, file: !65, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !64)
!630 = !DILocation(line: 11, column: 8, scope: !629)
!631 = !DILocation(line: 12, column: 8, scope: !629)
!632 = !DILocation(line: 13, column: 8, scope: !629)
!633 = !DILocation(line: 14, column: 8, scope: !629)
!634 = !DILocation(line: 15, column: 8, scope: !629)
!635 = !DILocation(line: 16, column: 8, scope: !629)
!636 = !DILocation(line: 17, column: 8, scope: !629)
!637 = !DILocation(line: 18, column: 8, scope: !629)
!638 = !DILocation(line: 25, column: 8, scope: !629)
!639 = !DILocation(line: 26, column: 8, scope: !629)
!640 = !DILocation(line: 27, column: 8, scope: !629)
!641 = !DILocation(line: 28, column: 8, scope: !629)
!642 = !DILocation(line: 34, column: 8, scope: !629)
!643 = !DILocation(line: 40, column: 8, scope: !629)
!644 = !DILocation(line: 37, column: 10, scope: !629)
!645 = !DILocation(line: 42, column: 10, scope: !629)
!646 = !DILocation(line: 43, column: 10, scope: !629)
!647 = !DILocation(line: 44, column: 10, scope: !629)
!648 = !DILocation(line: 45, column: 10, scope: !629)
!649 = !DILocation(line: 46, column: 10, scope: !629)
!650 = !DILocation(line: 50, column: 8, scope: !629)
!651 = distinct !DISubprogram(name: "infer_dispatch_44_conv_7x7x960x3x3_f32", linkageName: "infer_dispatch_44_conv_7x7x960x3x3_f32", scope: !67, file: !67, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !66)
!652 = !DILocation(line: 34, column: 8, scope: !651)
!653 = !DILocation(line: 33, column: 8, scope: !651)
!654 = !DILocation(line: 11, column: 8, scope: !651)
!655 = !DILocation(line: 12, column: 8, scope: !651)
!656 = !DILocation(line: 13, column: 8, scope: !651)
!657 = !DILocation(line: 14, column: 8, scope: !651)
!658 = !DILocation(line: 15, column: 8, scope: !651)
!659 = !DILocation(line: 16, column: 8, scope: !651)
!660 = !DILocation(line: 17, column: 8, scope: !651)
!661 = !DILocation(line: 18, column: 8, scope: !651)
!662 = !DILocation(line: 25, column: 8, scope: !651)
!663 = !DILocation(line: 26, column: 8, scope: !651)
!664 = !DILocation(line: 27, column: 8, scope: !651)
!665 = !DILocation(line: 28, column: 8, scope: !651)
!666 = !DILocation(line: 10, column: 8, scope: !651)
!667 = !DILocation(line: 36, column: 10, scope: !651)
!668 = !DILocation(line: 37, column: 10, scope: !651)
!669 = !DILocation(line: 40, column: 8, scope: !651)
!670 = !DILocation(line: 42, column: 10, scope: !651)
!671 = !DILocation(line: 43, column: 10, scope: !651)
!672 = !DILocation(line: 44, column: 10, scope: !651)
!673 = !DILocation(line: 45, column: 10, scope: !651)
!674 = !DILocation(line: 46, column: 10, scope: !651)
!675 = !DILocation(line: 50, column: 8, scope: !651)
!676 = distinct !DISubprogram(name: "infer_dispatch_45_matmul_like_160x49x960_f32", linkageName: "infer_dispatch_45_matmul_like_160x49x960_f32", scope: !69, file: !69, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !68)
!677 = !DILocation(line: 11, column: 8, scope: !676)
!678 = !DILocation(line: 12, column: 8, scope: !676)
!679 = !DILocation(line: 13, column: 8, scope: !676)
!680 = !DILocation(line: 14, column: 8, scope: !676)
!681 = !DILocation(line: 15, column: 8, scope: !676)
!682 = !DILocation(line: 16, column: 8, scope: !676)
!683 = !DILocation(line: 17, column: 8, scope: !676)
!684 = !DILocation(line: 18, column: 8, scope: !676)
!685 = !DILocation(line: 25, column: 8, scope: !676)
!686 = !DILocation(line: 26, column: 8, scope: !676)
!687 = !DILocation(line: 27, column: 8, scope: !676)
!688 = !DILocation(line: 28, column: 8, scope: !676)
!689 = !DILocation(line: 29, column: 8, scope: !676)
!690 = !DILocation(line: 36, column: 8, scope: !676)
!691 = !DILocation(line: 42, column: 8, scope: !676)
!692 = !DILocation(line: 39, column: 10, scope: !676)
!693 = !DILocation(line: 44, column: 10, scope: !676)
!694 = !DILocation(line: 45, column: 10, scope: !676)
!695 = !DILocation(line: 49, column: 8, scope: !676)
!696 = distinct !DISubprogram(name: "infer_dispatch_51_matmul_like_320x49x960_f32", linkageName: "infer_dispatch_51_matmul_like_320x49x960_f32", scope: !71, file: !71, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !70)
!697 = !DILocation(line: 14, column: 8, scope: !696)
!698 = !DILocation(line: 15, column: 8, scope: !696)
!699 = !DILocation(line: 16, column: 8, scope: !696)
!700 = !DILocation(line: 17, column: 8, scope: !696)
!701 = !DILocation(line: 23, column: 8, scope: !696)
!702 = !DILocation(line: 29, column: 8, scope: !696)
!703 = !DILocation(line: 26, column: 10, scope: !696)
!704 = !DILocation(line: 31, column: 10, scope: !696)
!705 = !DILocation(line: 35, column: 8, scope: !696)
!706 = distinct !DISubprogram(name: "infer_dispatch_52_matmul_like_1280x49x320_f32", linkageName: "infer_dispatch_52_matmul_like_1280x49x320_f32", scope: !73, file: !73, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !72)
!707 = !DILocation(line: 12, column: 8, scope: !706)
!708 = !DILocation(line: 13, column: 8, scope: !706)
!709 = !DILocation(line: 14, column: 8, scope: !706)
!710 = !DILocation(line: 19, column: 8, scope: !706)
!711 = !DILocation(line: 22, column: 10, scope: !706)
!712 = !DILocation(line: 26, column: 8, scope: !706)
!713 = distinct !DISubprogram(name: "infer_dispatch_53_reduction_1280x49_f32", linkageName: "infer_dispatch_53_reduction_1280x49_f32", scope: !75, file: !75, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !74)
!714 = !DILocation(line: 15, column: 8, scope: !713)
!715 = !DILocation(line: 16, column: 8, scope: !713)
!716 = !DILocation(line: 17, column: 8, scope: !713)
!717 = !DILocation(line: 22, column: 8, scope: !713)
!718 = !DILocation(line: 24, column: 10, scope: !713)
!719 = !DILocation(line: 25, column: 10, scope: !713)
!720 = !DILocation(line: 26, column: 10, scope: !713)
!721 = !DILocation(line: 27, column: 10, scope: !713)
!722 = !DILocation(line: 28, column: 10, scope: !713)
!723 = !DILocation(line: 29, column: 10, scope: !713)
!724 = !DILocation(line: 34, column: 10, scope: !713)
!725 = !DILocation(line: 38, column: 8, scope: !713)
!726 = distinct !DISubprogram(name: "infer_dispatch_54_matmul_1x3x1280_f32", linkageName: "infer_dispatch_54_matmul_1x3x1280_f32", scope: !77, file: !77, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !76)
!727 = !DILocation(line: 14, column: 8, scope: !726)
!728 = !DILocation(line: 15, column: 8, scope: !726)
!729 = !DILocation(line: 16, column: 8, scope: !726)
!730 = !DILocation(line: 21, column: 8, scope: !726)
!731 = !DILocation(line: 22, column: 8, scope: !726)
!732 = !DILocation(line: 24, column: 10, scope: !726)
!733 = !DILocation(line: 28, column: 8, scope: !726)
!734 = distinct !DISubprogram(name: "infer_dispatch_55_softmax_3xf32_dispatch_tensor_store", linkageName: "infer_dispatch_55_softmax_3xf32_dispatch_tensor_store", scope: !79, file: !79, line: 1, type: !82, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !78)
!735 = !DILocation(line: 13, column: 8, scope: !734)
!736 = !DILocation(line: 14, column: 8, scope: !734)
!737 = !DILocation(line: 19, column: 8, scope: !734)
!738 = !DILocation(line: 21, column: 10, scope: !734)
!739 = !DILocation(line: 25, column: 8, scope: !734)
!740 = !DILocation(line: 27, column: 10, scope: !734)
!741 = !DILocation(line: 28, column: 10, scope: !734)
!742 = !DILocation(line: 29, column: 10, scope: !734)
!743 = !DILocation(line: 32, column: 8, scope: !734)
!744 = !DILocation(line: 36, column: 10, scope: !734)
!745 = !DILocation(line: 40, column: 8, scope: !734)
