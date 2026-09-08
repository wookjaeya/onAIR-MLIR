hal.executable public @infer_dispatch_1 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_1_matmul_Dx2x64_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device, %arg1: index) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice(%arg1)
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_1_matmul_Dx2x64_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %c32_i64 = arith.constant 32 : i64
        %cst = arith.constant 0.000000e+00 : f32
        %c0 = arith.constant 0 : index
        %0 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = arith.extui %0 : i32 to i64
        %3 = arith.extui %1 : i32 to i64
        %4 = arith.shli %3, %c32_i64 : i64
        %5 = arith.ori %2, %4 : i64
        %6 = arith.index_castui %5 : i64 to index
        %7 = util.assume.int %6<umin = 0, umax = 9007199254740991> : index
        %8 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x2xf32>>
        %9 = iree_tensor_ext.dispatch.workload.ordinal %7, 0 : index
        %10 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x64xf32>>{%9}
        %11 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<?x2xf32>>{%9}
        %12 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0], sizes = [%9, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x64xf32>>{%9} -> tensor<?x64xf32>
        %13 = iree_tensor_ext.dispatch.tensor.load %8, offsets = [0, 0], sizes = [64, 2], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x2xf32>> -> tensor<64x2xf32>
        %14 = tensor.empty(%9) : tensor<?x2xf32>
        %15 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [64, 2], vector_common_parallel = [8, 8]>} ins(%cst : f32) outs(%14 : tensor<?x2xf32>) -> tensor<?x2xf32>
        %16 = linalg.matmul {lowering_config = #iree_cpu.lowering_config<cache_parallel = [64, 2, 0], distribution = [64, 2, 0], vector_common_parallel = [8, 8, 0], vector_reduction = [0, 0, 4]>} ins(%12, %13 : tensor<?x64xf32>, tensor<64x2xf32>) outs(%15 : tensor<?x2xf32>) -> tensor<?x2xf32>
        iree_tensor_ext.dispatch.tensor.store %16, %11, offsets = [0, 0], sizes = [%9, 2], strides = [1, 1] : tensor<?x2xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<?x2xf32>>{%9}
        return
      }
    }
  }
}
