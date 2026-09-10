hal.executable public @infer_dispatch_14 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_14_matmul_1x10x64_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_14_matmul_1x10x64_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant dense_resource<__elided__> : tensor<1x10xf32>
        %c0 = arith.constant 0 : index
        %c306880 = arith.constant 306880 : index
        %c256 = arith.constant 256 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c306880) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<10x64xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c256) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x10xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [1, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>> -> tensor<1x64xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [10, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<10x64xf32>> -> tensor<10x64xf32>
        %5 = tensor.empty() : tensor<1x10xf32>
        %6 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 5], vector_common_parallel = [1, 8]>} ins(%cst : f32) outs(%5 : tensor<1x10xf32>) -> tensor<1x10xf32>
        %7 = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 5, 0], distribution = [0, 5, 0], vector_common_parallel = [1, 8, 0], vector_reduction = [0, 0, 4]>} ins(%3, %4 : tensor<1x64xf32>, tensor<10x64xf32>) outs(%6 : tensor<1x10xf32>) -> tensor<1x10xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%7, %cst_0 : tensor<1x10xf32>, tensor<1x10xf32>) outs(%5 : tensor<1x10xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 5], vector_common_parallel = [1, 8]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %9 = arith.addf %in, %in_1 : f32
          linalg.yield %9 : f32
        } -> tensor<1x10xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0, 0], sizes = [1, 10], strides = [1, 1] : tensor<1x10xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x10xf32>>
        return
      }
    }
  }
}
