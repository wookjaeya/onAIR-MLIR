hal.executable public @infer_dispatch_7 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_7_matmul_like_144x56x56x24_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_7_matmul_like_144x56x56x24_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 6.000000e+00 : f32
        %c1204224 = arith.constant 1204224 : index
        %c8467456 = arith.constant 8467456 : index
        %c8785920 = arith.constant 8785920 : index
        %c1505280 = arith.constant 1505280 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c1204224) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<24x56x56xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8467456) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<144x24xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8785920) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<144xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c1505280) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<144x58x58xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [24, 56, 56], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<24x56x56xf32>> -> tensor<24x56x56xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [144, 24], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<144x24xf32>> -> tensor<144x24xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0], sizes = [144], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<144xf32>> -> tensor<144xf32>
        %7 = tensor.empty() : tensor<144x56x56xf32>
        %8 = linalg.fill ins(%cst : f32) outs(%7 : tensor<144x56x56xf32>) -> tensor<144x56x56xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%4, %5 : tensor<24x56x56xf32>, tensor<144x24xf32>) outs(%8 : tensor<144x56x56xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<144x56x56xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%9, %6 : tensor<144x56x56xf32>, tensor<144xf32>) outs(%7 : tensor<144x56x56xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.addf %in, %in_1 : f32
          %12 = arith.cmpf ult, %11, %cst : f32
          %13 = arith.select %12, %cst, %11 : f32
          %14 = arith.cmpf ugt, %13, %cst_0 : f32
          %15 = arith.select %14, %cst_0, %13 : f32
          linalg.yield %15 : f32
        } -> tensor<144x56x56xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 1, 1], sizes = [144, 56, 56], strides = [1, 1, 1] : tensor<144x56x56xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<144x58x58xf32>>
        return
      }
    }
  }
}
