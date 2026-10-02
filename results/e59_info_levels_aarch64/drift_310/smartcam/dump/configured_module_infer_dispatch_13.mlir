hal.executable public @infer_dispatch_13 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_13_matmul_like_192x28x28x32_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_13_matmul_like_192x28x28x32_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 6.000000e+00 : f32
        %cst_0 = arith.constant 0.000000e+00 : f32
        %c551936 = arith.constant 551936 : index
        %0 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
        %3 = arith.index_castui %0 : i32 to index
        %4 = arith.index_castui %1 : i32 to index
        %5 = arith.index_castui %2 : i32 to index
        %6:3 = util.assume.int 
            %3[<umin = 451584, umax = 451584, udiv = 451584>, <umin = 0, umax = 0>], 
            %4[<umin = 8396800, umax = 8396800, udiv = 8396800>, <umin = 8347648, umax = 8347648, udiv = 8347648>], 
            %5[<umin = 8783232, umax = 8783232, udiv = 8783232>, <umin = 8781696, umax = 8781696, udiv = 8781696>]
          : index, index, index
        %7 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x28x28xf32>>
        %8 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%6#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x32xf32>>
        %9 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%6#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>>
        %10 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c551936) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<192x30x30xf32>>
        %11 = iree_tensor_ext.dispatch.tensor.load %7, offsets = [0, 0, 0], sizes = [32, 28, 28], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x28x28xf32>> -> tensor<32x28x28xf32>
        %12 = iree_tensor_ext.dispatch.tensor.load %8, offsets = [0, 0], sizes = [192, 32], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x32xf32>> -> tensor<192x32xf32>
        %13 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0], sizes = [192], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>> -> tensor<192xf32>
        %14 = tensor.empty() : tensor<192x28x28xf32>
        %15 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [24, 14, 28], vector_common_parallel = [1, 8, 16]>} ins(%cst_0 : f32) outs(%14 : tensor<192x28x28xf32>) -> tensor<192x28x28xf32>
        %16 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%11, %12 : tensor<32x28x28xf32>, tensor<192x32xf32>) outs(%15 : tensor<192x28x28xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [24, 14, 28, 0], distribution = [24, 14, 28, 0], vector_common_parallel = [1, 8, 16, 0], vector_reduction = [0, 0, 0, 1]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %18 = arith.mulf %in, %in_1 : f32
          %19 = arith.addf %out, %18 : f32
          linalg.yield %19 : f32
        } -> tensor<192x28x28xf32>
        %17 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%16, %13 : tensor<192x28x28xf32>, tensor<192xf32>) outs(%14 : tensor<192x28x28xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [24, 14, 28], vector_common_parallel = [1, 8, 16]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %18 = arith.addf %in, %in_1 : f32
          %19 = arith.cmpf ult, %18, %cst_0 : f32
          %20 = arith.select %19, %cst_0, %18 : f32
          %21 = arith.cmpf ugt, %20, %cst : f32
          %22 = arith.select %21, %cst, %20 : f32
          linalg.yield %22 : f32
        } -> tensor<192x28x28xf32>
        iree_tensor_ext.dispatch.tensor.store %17, %10, offsets = [0, 1, 1], sizes = [192, 28, 28], strides = [1, 1, 1] : tensor<192x28x28xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<192x30x30xf32>>
        return
      }
    }
  }
}
