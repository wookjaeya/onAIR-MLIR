hal.executable public @infer_dispatch_4 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_4_matmul_like_96x112x112x16_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_4_matmul_like_96x112x112x16_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 6.000000e+00 : f32
        %c0 = arith.constant 0 : index
        %c8490496 = arith.constant 8490496 : index
        %c8831360 = arith.constant 8831360 : index
        %c3876672 = arith.constant 3876672 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x112x112xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8490496) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x16xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8831360) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c3876672) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<96x113x113xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [16, 112, 112], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x112x112xf32>> -> tensor<16x112x112xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [96, 16], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x16xf32>> -> tensor<96x16xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0], sizes = [96], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>> -> tensor<96xf32>
        %7 = tensor.empty() : tensor<96x112x112xf32>
        %8 = linalg.fill ins(%cst : f32) outs(%7 : tensor<96x112x112xf32>) -> tensor<96x112x112xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%4, %5 : tensor<16x112x112xf32>, tensor<96x16xf32>) outs(%8 : tensor<96x112x112xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<96x112x112xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%9, %6 : tensor<96x112x112xf32>, tensor<96xf32>) outs(%7 : tensor<96x112x112xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.addf %in, %in_1 : f32
          %12 = arith.cmpf ult, %11, %cst : f32
          %13 = arith.select %12, %cst, %11 : f32
          %14 = arith.cmpf ugt, %13, %cst_0 : f32
          %15 = arith.select %14, %cst_0, %13 : f32
          linalg.yield %15 : f32
        } -> tensor<96x112x112xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0, 0], sizes = [96, 112, 112], strides = [1, 1, 1] : tensor<96x112x112xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<96x113x113xf32>>
        return
      }
    }
  }
}
