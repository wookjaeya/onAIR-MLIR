hal.executable public @infer_dispatch_0 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_0_matmul_like_32x50176x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_0_matmul_like_32x50176x3_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 2.000000e-01 : f32
        %cst_1 = arith.constant dense<[-0.0261213034, 0.0302125178, 0.019738609, 0.0293414257, -0.007788877, 0.110806756, 0.0222133212, 0.0681090652, 0.0136511121, -0.00614248216, 0.00781143364, -0.0130559849, -0.0136823226, 0.0262005404, 0.00950618647, 0.00863285735, -0.00953852757, 0.0587259047, -0.00930972583, 0.0529816523, 0.00975057482, 0.0187940858, 0.00321801961, 0.00200297218, 0.0197162293, -0.00127470889, 0.0150650898, 0.047169026, -7.20487966E-4, -0.00357915089, 0.138167739, 0.095627658]> : tensor<32xf32>
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x50176xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x50176xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [3, 50176], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x50176xf32>> -> tensor<3x50176xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [32, 3], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x3xf32>> -> tensor<32x3xf32>
        %5 = tensor.empty() : tensor<32x50176xf32>
        %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<32x50176xf32>) -> tensor<32x50176xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<3x50176xf32>, tensor<32x3xf32>) outs(%6 : tensor<32x50176xf32>) {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %9 = arith.mulf %in, %in_2 : f32
          %10 = arith.addf %out, %9 : f32
          linalg.yield %10 : f32
        } -> tensor<32x50176xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%7, %cst_1 : tensor<32x50176xf32>, tensor<32xf32>) outs(%5 : tensor<32x50176xf32>) {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %9 = arith.addf %in, %in_2 : f32
          %10 = arith.cmpf olt, %cst, %9 : f32
          %11 = arith.select %10, %cst, %9 : f32
          %12 = arith.mulf %11, %cst_0 : f32
          %13 = arith.cmpf ogt, %cst, %9 : f32
          %14 = arith.select %13, %cst, %9 : f32
          %15 = arith.addf %14, %12 : f32
          linalg.yield %15 : f32
        } -> tensor<32x50176xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0, 0], sizes = [32, 50176], strides = [1, 1] : tensor<32x50176xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x50176xf32>>
        return
      }
    }
  }
}
