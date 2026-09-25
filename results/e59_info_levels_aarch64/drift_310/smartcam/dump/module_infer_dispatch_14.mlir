hal.executable public @infer_dispatch_14 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_14_conv_28x28x192x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_14_conv_28x28x192x3x3_f32() {
        %cst = arith.constant 6.000000e+00 : f32
        %cst_0 = arith.constant 0.000000e+00 : f32
        %c551936 = arith.constant 551936 : index
        %c1243136 = arith.constant 1243136 : index
        %0 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = arith.index_castui %0 : i32 to index
        %3 = arith.index_castui %1 : i32 to index
        %4:2 = util.assume.int 
            %2[<umin = 8733696, umax = 8733696, udiv = 8733696>, <umin = 8726784, umax = 8726784, udiv = 8726784>], 
            %3[<umin = 8784000, umax = 8784000, udiv = 8784000>, <umin = 8782464, umax = 8782464, udiv = 8782464>]
          : index, index
        %5 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c551936) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x30x30xf32>>
        %6 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%4#0) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x3x3xf32>>
        %7 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%4#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>>
        %8 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c1243136) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<192x28x28xf32>>
        %9 = iree_tensor_ext.dispatch.tensor.load %5, offsets = [0, 0, 0], sizes = [192, 30, 30], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x30x30xf32>> -> tensor<192x30x30xf32>
        %10 = iree_tensor_ext.dispatch.tensor.load %6, offsets = [0, 0, 0], sizes = [192, 3, 3], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192x3x3xf32>> -> tensor<192x3x3xf32>
        %11 = iree_tensor_ext.dispatch.tensor.load %7, offsets = [0], sizes = [192], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<192xf32>> -> tensor<192xf32>
        %12 = tensor.empty() : tensor<192x28x28xf32>
        %13 = linalg.fill ins(%cst_0 : f32) outs(%12 : tensor<192x28x28xf32>) -> tensor<192x28x28xf32>
        %14 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d2, d0 + d3, d1 + d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d3, d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d0, d1)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction"]} ins(%9, %10 : tensor<192x30x30xf32>, tensor<192x3x3xf32>) outs(%13 : tensor<192x28x28xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %16 = arith.mulf %in, %in_1 : f32
          %17 = arith.addf %out, %16 : f32
          linalg.yield %17 : f32
        } -> tensor<192x28x28xf32>
        %15 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%14, %11 : tensor<192x28x28xf32>, tensor<192xf32>) outs(%12 : tensor<192x28x28xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %16 = arith.addf %in, %in_1 : f32
          %17 = arith.cmpf ult, %16, %cst_0 : f32
          %18 = arith.select %17, %cst_0, %16 : f32
          %19 = arith.cmpf ugt, %18, %cst : f32
          %20 = arith.select %19, %cst, %18 : f32
          linalg.yield %20 : f32
        } -> tensor<192x28x28xf32>
        iree_tensor_ext.dispatch.tensor.store %15, %8, offsets = [0, 0, 0], sizes = [192, 28, 28], strides = [1, 1, 1] : tensor<192x28x28xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<192x28x28xf32>>
        return
      }
    }
  }
}
