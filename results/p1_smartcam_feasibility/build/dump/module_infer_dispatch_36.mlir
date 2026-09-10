hal.executable public @infer_dispatch_36 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_36_matmul_like_96x196x576_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_36_matmul_like_96x196x576_f32() {
        %cst = arith.constant 0.000000e+00 : f32
        %0 = hal.interface.constant.load layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = hal.interface.constant.load layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
        %3 = hal.interface.constant.load layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(3) : i32
        %4 = hal.interface.constant.load layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(4) : i32
        %5 = arith.index_castui %0 : i32 to index
        %6 = arith.index_castui %1 : i32 to index
        %7 = arith.index_castui %2 : i32 to index
        %8 = arith.index_castui %3 : i32 to index
        %9 = arith.index_castui %4 : i32 to index
        %10:5 = util.assume.int 
            %5[<umin = 75264, umax = 75264, udiv = 75264>, <umin = 0, umax = 0>], 
            %6[<umin = 0, umax = 0>, <umin = 526848, umax = 526848, udiv = 526848>], 
            %7[<umin = 6971392, umax = 6971392, udiv = 6971392>, <umin = 6529024, umax = 6529024, udiv = 6529024>], 
            %8[<umin = 8822912, umax = 8822912, udiv = 8822912>, <umin = 8817920, umax = 8817920, udiv = 8817920>], 
            %9[<umin = 526848, umax = 526848, udiv = 526848>, <umin = 451584, umax = 451584, udiv = 451584>]
          : index, index, index, index, index
        %11 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%10#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<576x196xf32>>
        %12 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%10#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x576xf32>>
        %13 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%10#3) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>>
        %14 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%10#1) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x196xf32>>
        %15 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%10#4) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<96x196xf32>>
        %16 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0, 0], sizes = [576, 196], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<576x196xf32>> -> tensor<576x196xf32>
        %17 = iree_tensor_ext.dispatch.tensor.load %12, offsets = [0, 0], sizes = [96, 576], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x576xf32>> -> tensor<96x576xf32>
        %18 = iree_tensor_ext.dispatch.tensor.load %13, offsets = [0], sizes = [96], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>> -> tensor<96xf32>
        %19 = iree_tensor_ext.dispatch.tensor.load %14, offsets = [0, 0], sizes = [96, 196], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x196xf32>> -> tensor<96x196xf32>
        %20 = tensor.empty() : tensor<96x196xf32>
        %21 = linalg.fill ins(%cst : f32) outs(%20 : tensor<96x196xf32>) -> tensor<96x196xf32>
        %22 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%16, %17 : tensor<576x196xf32>, tensor<96x576xf32>) outs(%21 : tensor<96x196xf32>) {
        ^bb0(%in: f32, %in_0: f32, %out: f32):
          %24 = arith.mulf %in, %in_0 : f32
          %25 = arith.addf %out, %24 : f32
          linalg.yield %25 : f32
        } -> tensor<96x196xf32>
        %23 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%22, %18, %19 : tensor<96x196xf32>, tensor<96xf32>, tensor<96x196xf32>) outs(%20 : tensor<96x196xf32>) {
        ^bb0(%in: f32, %in_0: f32, %in_1: f32, %out: f32):
          %24 = arith.addf %in, %in_0 : f32
          %25 = arith.addf %24, %in_1 : f32
          linalg.yield %25 : f32
        } -> tensor<96x196xf32>
        iree_tensor_ext.dispatch.tensor.store %23, %15, offsets = [0, 0], sizes = [96, 196], strides = [1, 1] : tensor<96x196xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<96x196xf32>>
        return
      }
    }
  }
}
