hal.executable public @infer_dispatch_30 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_30_matmul_like_64x196x384_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_30_matmul_like_64x196x384_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant dense_resource<__elided__> : tensor<64xf32>
        %c493568 = arith.constant 493568 : index
        %c50176 = arith.constant 50176 : index
        %c7659520 = arith.constant 7659520 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c493568) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x196xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c7659520) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x384xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c50176) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x196xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x196xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [384, 196], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x196xf32>> -> tensor<384x196xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [64, 384], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x384xf32>> -> tensor<64x384xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0], sizes = [64, 196], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x196xf32>> -> tensor<64x196xf32>
        %7 = tensor.empty() : tensor<64x196xf32>
        %8 = linalg.fill ins(%cst : f32) outs(%7 : tensor<64x196xf32>) -> tensor<64x196xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%4, %5 : tensor<384x196xf32>, tensor<64x384xf32>) outs(%8 : tensor<64x196xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<64x196xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%9, %cst_0, %6 : tensor<64x196xf32>, tensor<64xf32>, tensor<64x196xf32>) outs(%7 : tensor<64x196xf32>) {
        ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
          %11 = arith.addf %in, %in_1 : f32
          %12 = arith.addf %11, %in_2 : f32
          linalg.yield %12 : f32
        } -> tensor<64x196xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0], sizes = [64, 196], strides = [1, 1] : tensor<64x196xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x196xf32>>
        return
      }
    }
  }
}
