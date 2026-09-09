hal.executable public @infer_dispatch_12 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_12_matmul_like_64x8x8x32_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_12_matmul_like_64x8x8x32_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %c74240 = arith.constant 74240 : index
        %c0 = arith.constant 0 : index
        %c41984 = arith.constant 41984 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c74240) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x16x16xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x32xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c41984) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x8x8xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [64, 32], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x32xf32>> -> tensor<64x32xf32>
        %4 = tensor.empty() : tensor<64x8x8xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [32, 8, 8], strides = [1, 2, 2] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x16x16xf32>> -> tensor<32x8x8xf32>
        %6 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [8, 8, 8], vector_common_parallel = [1, 1, 1]>} ins(%cst : f32) outs(%4 : tensor<64x8x8xf32>) -> tensor<64x8x8xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%5, %3 : tensor<32x8x8xf32>, tensor<64x32xf32>) outs(%6 : tensor<64x8x8xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [8, 8, 8, 0], distribution = [8, 8, 8, 0], vector_common_parallel = [1, 1, 1, 0], vector_reduction = [0, 0, 0, 4]>} {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %8 = arith.mulf %in, %in_0 : f32
          %9 = arith.addf %out, %8 : f32
          linalg.yield %9 : f32
        } -> tensor<64x8x8xf32>
        iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0], sizes = [64, 8, 8], strides = [1, 1, 1] : tensor<64x8x8xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x8x8xf32>>
        return
      }
    }
  }
}
