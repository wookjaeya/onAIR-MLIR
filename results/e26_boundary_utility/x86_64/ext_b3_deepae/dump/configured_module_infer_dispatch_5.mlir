hal.executable public @infer_dispatch_5 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_5_matmul_1x128x8_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_5_matmul_1x128x8_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %c0 = arith.constant 0 : index
        %c207360 = arith.constant 207360 : index
        %c4096 = arith.constant 4096 : index
        %c64 = arith.constant 64 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x8xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c207360) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x8xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c4096) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c64) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x128xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [1, 8], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x8xf32>> -> tensor<1x8xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [128, 8], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x8xf32>> -> tensor<128x8xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0], sizes = [1, 128], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>> -> tensor<1x128xf32>
        %7 = tensor.empty() : tensor<1x128xf32>
        %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 64], vector_common_parallel = [1, 1]>} ins(%cst : f32) outs(%7 : tensor<1x128xf32>) -> tensor<1x128xf32>
        %9 = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 64, 0], distribution = [0, 64, 0], vector_common_parallel = [1, 1, 0], vector_reduction = [0, 0, 4]>} ins(%4, %5 : tensor<1x8xf32>, tensor<128x8xf32>) outs(%8 : tensor<1x128xf32>) -> tensor<1x128xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%9, %6 : tensor<1x128xf32>, tensor<1x128xf32>) outs(%7 : tensor<1x128xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 64], vector_common_parallel = [1, 1]>} {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %11 = arith.addf %in, %in_0 : f32
          %12 = arith.cmpf ugt, %11, %cst : f32
          %13 = arith.select %12, %11, %cst : f32
          linalg.yield %13 : f32
        } -> tensor<1x128xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0], sizes = [1, 128], strides = [1, 1] : tensor<1x128xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x128xf32>>
        return
      }
    }
  }
}
