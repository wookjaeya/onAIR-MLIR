hal.executable public @infer_dispatch_53 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_53_reduction_1280x49_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_53_reduction_1280x49_f32() {
        %cst = arith.constant 6.000000e+00 : f32
        %cst_0 = arith.constant 0.000000e+00 : f32
        %cst_1 = arith.constant 4.900000e+01 : f32
        %c62720 = arith.constant 62720 : index
        %c8832128 = arith.constant 8832128 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c62720) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1280x49xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8832128) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1280xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1280xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [1280, 49], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1280x49xf32>> -> tensor<1280x49xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0], sizes = [1280], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1280xf32>> -> tensor<1280xf32>
        %5 = tensor.empty() : tensor<1280xf32>
        %6 = linalg.fill ins(%cst_0 : f32) outs(%5 : tensor<1280xf32>) -> tensor<1280xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%3, %4 : tensor<1280x49xf32>, tensor<1280xf32>) outs(%6 : tensor<1280xf32>) {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %9 = arith.addf %in, %in_2 : f32
          %10 = arith.cmpf ult, %9, %cst_0 : f32
          %11 = arith.select %10, %cst_0, %9 : f32
          %12 = arith.cmpf ugt, %11, %cst : f32
          %13 = arith.select %12, %cst, %11 : f32
          %14 = arith.addf %out, %13 : f32
          linalg.yield %14 : f32
        } -> tensor<1280xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%7 : tensor<1280xf32>) outs(%5 : tensor<1280xf32>) {
        ^bb0(%in: f32, %out: f32):
          %9 = arith.divf %in, %cst_1 : f32
          linalg.yield %9 : f32
        } -> tensor<1280xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0], sizes = [1280], strides = [1] : tensor<1280xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1280xf32>>
        return
      }
    }
  }
}
