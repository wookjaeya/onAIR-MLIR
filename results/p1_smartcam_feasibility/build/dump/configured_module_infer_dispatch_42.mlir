hal.executable public @infer_dispatch_42 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_42_matmul_like_160x49x576_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_42_matmul_like_160x49x576_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %c0 = arith.constant 0 : index
        %c5939200 = arith.constant 5939200 : index
        %c8812672 = arith.constant 8812672 : index
        %c112896 = arith.constant 112896 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<576x49xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c5939200) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x576xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8812672) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c112896) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<160x49xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [576, 49], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<576x49xf32>> -> tensor<576x49xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [160, 576], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x576xf32>> -> tensor<160x576xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0], sizes = [160], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160xf32>> -> tensor<160xf32>
        %7 = tensor.empty() : tensor<160x49xf32>
        %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 49], vector_common_parallel = [1, 1]>} ins(%cst : f32) outs(%7 : tensor<160x49xf32>) -> tensor<160x49xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%4, %5 : tensor<576x49xf32>, tensor<160x576xf32>) outs(%8 : tensor<160x49xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 49, 0], distribution = [16, 49, 0], vector_common_parallel = [1, 1, 0], vector_reduction = [0, 0, 4]>} {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %11 = arith.mulf %in, %in_0 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<160x49xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%9, %6 : tensor<160x49xf32>, tensor<160xf32>) outs(%7 : tensor<160x49xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 49], vector_common_parallel = [1, 1]>} {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %11 = arith.addf %in, %in_0 : f32
          linalg.yield %11 : f32
        } -> tensor<160x49xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0], sizes = [160, 49], strides = [1, 1] : tensor<160x49xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<160x49xf32>>
        return
      }
    }
  }
}
