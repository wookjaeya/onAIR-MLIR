hal.executable public @infer_dispatch_13 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_13_reduction_64x64_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_13_reduction_64x64_f32() {
        %cst = arith.constant dense_resource<__elided__> : tensor<64xf32>
        %cst_0 = arith.constant dense_resource<__elided__> : tensor<64xf32>
        %cst_1 = arith.constant 0.000000e+00 : f32
        %cst_2 = arith.constant 6.400000e+01 : f32
        %c41984 = arith.constant 41984 : index
        %c25600 = arith.constant 25600 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c41984) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c25600) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [64, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>> -> tensor<64x64xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [64, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>> -> tensor<64x64xf32>
        %5 = tensor.empty() : tensor<64xf32>
        %6 = linalg.fill ins(%cst_1 : f32) outs(%5 : tensor<64xf32>) -> tensor<64xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%3, %cst, %4, %cst_0 : tensor<64x64xf32>, tensor<64xf32>, tensor<64x64xf32>, tensor<64xf32>) outs(%6 : tensor<64xf32>) {
        ^bb0(%in: f32, %in_3: f32, %in_4: f32, %in_5: f32, %out: f32):
          %9 = arith.addf %in_4, %in_5 : f32
          %10 = arith.addf %in, %in_3 : f32
          %11 = arith.addf %10, %9 : f32
          %12 = arith.cmpf ugt, %11, %cst_1 : f32
          %13 = arith.select %12, %11, %cst_1 : f32
          %14 = arith.addf %out, %13 : f32
          linalg.yield %14 : f32
        } -> tensor<64xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%7 : tensor<64xf32>) outs(%5 : tensor<64xf32>) {
        ^bb0(%in: f32, %out: f32):
          %9 = arith.divf %in, %cst_2 : f32
          linalg.yield %9 : f32
        } -> tensor<64xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0], sizes = [64], strides = [1] : tensor<64xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64xf32>>
        return
      }
    }
  }
}
