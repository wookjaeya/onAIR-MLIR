hal.executable public @infer_dispatch_5 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_5_conv_128x224x224x128x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_5_conv_128x224x224x128x3x3_f32() {
        %cst = arith.constant 2.000000e-01 : f32
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
            %4[<umin = 51725824, umax = 51725824, udiv = 51725824>, <umin = 104027648, umax = 104027648, udiv = 104027648>, <umin = 103566848, umax = 103566848, udiv = 103566848>], 
            %5[<umin = 3246976, umax = 3246976, udiv = 3246976>, <umin = 2066304, umax = 2066304, udiv = 2066304>, <umin = 885632, umax = 885632, udiv = 885632>], 
            %6[<umin = 3836800, umax = 3836800, udiv = 3836800>, <umin = 2656128, umax = 2656128, udiv = 2656128>, <umin = 1475456, umax = 1475456, udiv = 1475456>], 
            %7[<umin = 77876736, umax = 77876736, udiv = 77876736>, <umin = 77415936, umax = 77415936, udiv = 77415936>, <umin = 32112640, umax = 32112640, udiv = 32112640>]
          : index, index, index, index
        %9 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%8#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x226x226xf32>>
        %10 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128x3x3xf32>>
        %11 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128xf32>>
        %12 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%8#3) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<128x226x226xf32>>
        %13 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0, 0], sizes = [128, 226, 226], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x226x226xf32>> -> tensor<128x226x226xf32>
        %14 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0, 0, 0], sizes = [128, 128, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128x3x3xf32>> -> tensor<128x128x3x3xf32>
        %15 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0], sizes = [128], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128xf32>> -> tensor<128xf32>
        %16 = tensor.empty() : tensor<128x224x224xf32>
        %17 = linalg.fill ins(%cst_0 : f32) outs(%16 : tensor<128x224x224xf32>) -> tensor<128x224x224xf32>
        %18 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%13, %14 : tensor<128x226x226xf32>, tensor<128x128x3x3xf32>) outs(%17 : tensor<128x224x224xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %20 = arith.mulf %in, %in_1 : f32
          %21 = arith.addf %out, %20 : f32
          linalg.yield %21 : f32
        } -> tensor<128x224x224xf32>
        %19 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%18, %15 : tensor<128x224x224xf32>, tensor<128xf32>) outs(%16 : tensor<128x224x224xf32>) {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %20 = arith.addf %in, %in_1 : f32
          %21 = arith.cmpf olt, %cst_0, %20 : f32
          %22 = arith.select %21, %cst_0, %20 : f32
          %23 = arith.mulf %22, %cst : f32
          %24 = arith.cmpf ogt, %cst_0, %20 : f32
          %25 = arith.select %24, %cst_0, %20 : f32
          %26 = arith.addf %25, %23 : f32
          linalg.yield %26 : f32
        } -> tensor<128x224x224xf32>
        iree_tensor_ext.dispatch.tensor.store %19, %12, offsets = [0, 1, 1], sizes = [128, 224, 224], strides = [1, 1, 1] : tensor<128x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<128x226x226xf32>>
        return
      }
    }
  }
}
