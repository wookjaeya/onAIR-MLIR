hal.executable public @infer_dispatch_16 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_16_conv_32x224x224x64x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_16_conv_32x224x224x64x3x3_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 2.000000e-01 : f32
        %cst_1 = arith.constant dense<[0.0128815658, 0.0484814271, 0.106115058, 0.0158049352, 0.0413180366, -0.0896534175, -0.0175028369, -0.00291653816, -0.00432292186, -0.00578885525, -0.0643918738, 0.0289345719, 0.0128257163, 0.011209961, 0.0112533253, 0.0215627104, -0.0608637482, 0.0211722888, -0.0227121674, -0.0769629627, 0.0271533187, -0.0795125216, 0.046691265, 0.0500875488, -0.0188633148, -0.0110325627, 0.0251000728, -0.0453642085, 0.028337542, -0.0441940539, -0.0235241316, 0.0305174273]> : tensor<32xf32>
        %c9633792 = arith.constant 9633792 : index
        %c0 = arith.constant 0 : index
        %c4136192 = arith.constant 4136192 : index
        %c22709248 = arith.constant 22709248 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c9633792) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x226x226xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c4136192) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x64x3x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x224x224xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c22709248) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<32x226x226xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [64, 226, 226], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x226x226xf32>> -> tensor<64x226x226xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [32, 64, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x64x3x3xf32>> -> tensor<32x64x3x3xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0, 0], sizes = [32, 224, 224], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x224x224xf32>> -> tensor<32x224x224xf32>
        %7 = tensor.empty() : tensor<32x224x224xf32>
        %8 = linalg.fill ins(%cst : f32) outs(%7 : tensor<32x224x224xf32>) -> tensor<32x224x224xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%4, %5 : tensor<64x226x226xf32>, tensor<32x64x3x3xf32>) outs(%8 : tensor<32x224x224xf32>) {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %11 = arith.mulf %in, %in_2 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<32x224x224xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%6, %9, %cst_1 : tensor<32x224x224xf32>, tensor<32x224x224xf32>, tensor<32xf32>) outs(%7 : tensor<32x224x224xf32>) {
        ^bb0(%in: f32, %in_2: f32, %in_3: f32, %out: f32):
          %11 = arith.addf %in_2, %in_3 : f32
          %12 = arith.cmpf olt, %cst, %11 : f32
          %13 = arith.select %12, %cst, %11 : f32
          %14 = arith.mulf %13, %cst_0 : f32
          %15 = arith.cmpf ogt, %cst, %11 : f32
          %16 = arith.select %15, %cst, %11 : f32
          %17 = arith.addf %16, %14 : f32
          %18 = arith.mulf %in, %17 : f32
          linalg.yield %18 : f32
        } -> tensor<32x224x224xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 1, 1], sizes = [32, 224, 224], strides = [1, 1, 1] : tensor<32x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<32x226x226xf32>>
        return
      }
    }
  }
}
