hal.executable public @infer_dispatch_20 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_20_conv_14x14x192x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_20_conv_14x14x192x3x3_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 6.000000e+00 : f32
        %c200704 = arith.constant 200704 : index
        %c8719872 = arith.constant 8719872 : index
        %c8780928 = arith.constant 8780928 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c200704) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x29x29xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8719872) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x3x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8780928) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<192x14x14xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [192, 29, 29], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x29x29xf32>> -> tensor<192x29x29xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0], sizes = [192, 3, 3], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x3x3xf32>> -> tensor<192x3x3xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0], sizes = [192], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>> -> tensor<192xf32>
        %7 = tensor.empty() : tensor<192x14x14xf32>
        %8 = linalg.fill ins(%cst : f32) outs(%7 : tensor<192x14x14xf32>) -> tensor<192x14x14xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d2, d0 * 2 + d3, d1 * 2 + d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d3, d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d0, d1)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction"]} ins(%4, %5 : tensor<192x29x29xf32>, tensor<192x3x3xf32>) outs(%8 : tensor<192x14x14xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<192x14x14xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%9, %6 : tensor<192x14x14xf32>, tensor<192xf32>) outs(%7 : tensor<192x14x14xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.addf %in, %in_1 : f32
          %12 = arith.cmpf ult, %11, %cst : f32
          %13 = arith.select %12, %cst, %11 : f32
          %14 = arith.cmpf ugt, %13, %cst_0 : f32
          %15 = arith.select %14, %cst_0, %13 : f32
          linalg.yield %15 : f32
        } -> tensor<192x14x14xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0, 0], sizes = [192, 14, 14], strides = [1, 1, 1] : tensor<192x14x14xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<192x14x14xf32>>
        return
      }
    }
  }
}
