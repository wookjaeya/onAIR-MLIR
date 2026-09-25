hal.executable public @infer_dispatch_18 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_18_matmul_like_32x784x192_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_18_matmul_like_32x784x192_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant dense_resource<__elided__> : tensor<32xf32>
        %c1243136 = arith.constant 1243136 : index
        %c0 = arith.constant 0 : index
        %c8323072 = arith.constant 8323072 : index
        %c100352 = arith.constant 100352 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c1243136) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x784xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8323072) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x192xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x784xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c100352) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x784xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [192, 784], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x784xf32>> -> tensor<192x784xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [32, 192], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x192xf32>> -> tensor<32x192xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0], sizes = [32, 784], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x784xf32>> -> tensor<32x784xf32>
        %7 = tensor.empty() : tensor<32x784xf32>
        %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 112], vector_common_parallel = [8, 16]>} ins(%cst : f32) outs(%7 : tensor<32x784xf32>) -> tensor<32x784xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%4, %5 : tensor<192x784xf32>, tensor<32x192xf32>) outs(%8 : tensor<32x784xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 112, 0], distribution = [16, 112, 0], vector_common_parallel = [8, 16, 0], vector_reduction = [0, 0, 1]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<32x784xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%9, %cst_0, %6 : tensor<32x784xf32>, tensor<32xf32>, tensor<32x784xf32>) outs(%7 : tensor<32x784xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 112], vector_common_parallel = [8, 16]>} {
        ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
          %11 = arith.addf %in, %in_1 : f32
          %12 = arith.addf %11, %in_2 : f32
          linalg.yield %12 : f32
        } -> tensor<32x784xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0], sizes = [32, 784], strides = [1, 1] : tensor<32x784xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x784xf32>>
        return
      }
    }
  }
}
