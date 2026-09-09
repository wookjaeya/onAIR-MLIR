hal.executable public @infer_dispatch_3 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_3_conv_16x32x32x16x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_3_conv_16x32x32x16x3x3_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant dense_resource<__elided__> : tensor<16xf32>
        %c79424 = arith.constant 79424 : index
        %c19456 = arith.constant 19456 : index
        %c153408 = arith.constant 153408 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c79424) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x34x34xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c19456) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x16x3x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c153408) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<16x34x34xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [16, 34, 34], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x34x34xf32>> -> tensor<16x34x34xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [16, 16, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x16x3x3xf32>> -> tensor<16x16x3x3xf32>
        %5 = tensor.empty() : tensor<16x32x32xf32>
        %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<16x32x32xf32>) -> tensor<16x32x32xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%3, %4 : tensor<16x34x34xf32>, tensor<16x16x3x3xf32>) outs(%6 : tensor<16x32x32xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %9 = arith.mulf %in, %in_1 : f32
          %10 = arith.addf %out, %9 : f32
          linalg.yield %10 : f32
        } -> tensor<16x32x32xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%7, %cst_0 : tensor<16x32x32xf32>, tensor<16xf32>) outs(%5 : tensor<16x32x32xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %9 = arith.addf %in, %in_1 : f32
          %10 = arith.cmpf ugt, %9, %cst : f32
          %11 = arith.select %10, %9, %cst : f32
          linalg.yield %11 : f32
        } -> tensor<16x32x32xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0, 1, 1], sizes = [16, 32, 32], strides = [1, 1, 1] : tensor<16x32x32xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<16x34x34xf32>>
        return
      }
    }
  }
}
