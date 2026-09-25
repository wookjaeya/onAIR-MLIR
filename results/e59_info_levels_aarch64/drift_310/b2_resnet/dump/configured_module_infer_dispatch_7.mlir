hal.executable public @infer_dispatch_7 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_7_matmul_like_32x16x16x16_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_7_matmul_like_32x16x16x16_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %c79424 = arith.constant 79424 : index
        %c8192 = arith.constant 8192 : index
        %c41472 = arith.constant 41472 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c79424) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x32x32xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8192) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x16xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c41472) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x16x16xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [32, 16], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x16xf32>> -> tensor<32x16xf32>
        %4 = tensor.empty() : tensor<32x16x16xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [16, 16, 16], strides = [1, 2, 2] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x32x32xf32>> -> tensor<16x16x16xf32>
        %6 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [4, 8, 16], vector_common_parallel = [1, 8, 16]>} ins(%cst : f32) outs(%4 : tensor<32x16x16xf32>) -> tensor<32x16x16xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%5, %3 : tensor<16x16x16xf32>, tensor<32x16xf32>) outs(%6 : tensor<32x16x16xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [4, 8, 16, 0], distribution = [4, 8, 16, 0], vector_common_parallel = [1, 8, 16, 0], vector_reduction = [0, 0, 0, 1]>} {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %8 = arith.mulf %in, %in_0 : f32
          %9 = arith.addf %out, %8 : f32
          linalg.yield %9 : f32
        } -> tensor<32x16x16xf32>
        iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0], sizes = [32, 16, 16], strides = [1, 1, 1] : tensor<32x16x16xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x16x16xf32>>
        return
      }
    }
  }
}
