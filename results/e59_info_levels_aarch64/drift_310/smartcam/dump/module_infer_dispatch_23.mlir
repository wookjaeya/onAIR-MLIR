hal.executable public @infer_dispatch_23 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_23_conv_14x14x384x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_23_conv_14x14x384x3x3_f32() {
        %cst = arith.constant 6.000000e+00 : f32
        %cst_0 = arith.constant 0.000000e+00 : f32
        %0 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
        %3 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(3) : i32
        %4 = arith.index_castui %0 : i32 to index
        %5 = arith.index_castui %1 : i32 to index
        %6 = arith.index_castui %2 : i32 to index
        %7 = arith.index_castui %3 : i32 to index
        %8:4 = util.assume.int 
            %4[<umin = 200704, umax = 200704, udiv = 200704>, <umin = 200704, umax = 200704, udiv = 200704>, <umin = 100352, umax = 100352, udiv = 100352>, <umin = 100352, umax = 100352, udiv = 100352>], 
            %5[<umin = 8706048, umax = 8706048, udiv = 8706048>, <umin = 8692224, umax = 8692224, udiv = 8692224>, <umin = 8678400, umax = 8678400, udiv = 8678400>, <umin = 8664576, umax = 8664576, udiv = 8664576>], 
            %6[<umin = 8778624, umax = 8778624, udiv = 8778624>, <umin = 8775552, umax = 8775552, udiv = 8775552>, <umin = 8772480, umax = 8772480, udiv = 8772480>, <umin = 8829824, umax = 8829824, udiv = 8829824>], 
            %7[<umin = 593920, umax = 593920, udiv = 593920>, <umin = 593920, umax = 593920, udiv = 593920>, <umin = 493568, umax = 493568, udiv = 493568>, <umin = 493568, umax = 493568, udiv = 493568>]
          : index, index, index, index
        %9 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%8#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x16x16xf32>>
        %10 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x3x3xf32>>
        %11 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384xf32>>
        %12 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%8#3) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<384x14x14xf32>>
        %13 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0, 0], sizes = [384, 16, 16], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x16x16xf32>> -> tensor<384x16x16xf32>
        %14 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0, 0], sizes = [384, 3, 3], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x3x3xf32>> -> tensor<384x3x3xf32>
        %15 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0], sizes = [384], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384xf32>> -> tensor<384xf32>
        %16 = tensor.empty() : tensor<384x14x14xf32>
        %17 = linalg.fill ins(%cst_0 : f32) outs(%16 : tensor<384x14x14xf32>) -> tensor<384x14x14xf32>
        %18 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d2, d0 + d3, d1 + d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d3, d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d0, d1)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction"]} ins(%13, %14 : tensor<384x16x16xf32>, tensor<384x3x3xf32>) outs(%17 : tensor<384x14x14xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %20 = arith.mulf %in, %in_1 : f32
          %21 = arith.addf %out, %20 : f32
          linalg.yield %21 : f32
        } -> tensor<384x14x14xf32>
        %19 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%18, %15 : tensor<384x14x14xf32>, tensor<384xf32>) outs(%16 : tensor<384x14x14xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %20 = arith.addf %in, %in_1 : f32
          %21 = arith.cmpf ult, %20, %cst_0 : f32
          %22 = arith.select %21, %cst_0, %20 : f32
          %23 = arith.cmpf ugt, %22, %cst : f32
          %24 = arith.select %23, %cst, %22 : f32
          linalg.yield %24 : f32
        } -> tensor<384x14x14xf32>
        iree_tensor_ext.dispatch.tensor.store %19, %12, offsets = [0, 0, 0], sizes = [384, 14, 14], strides = [1, 1, 1] : tensor<384x14x14xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<384x14x14xf32>>
        return
      }
    }
  }
}
