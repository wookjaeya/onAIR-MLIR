hal.executable public @infer_dispatch_15 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_15_softmax_10xf32_dispatch_tensor_store() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert>} {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 0xFFC00000 : f32
        %c256 = arith.constant 256 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c256) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<10xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<10xf32>>
        %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0], sizes = [10], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<10xf32>> -> tensor<10xf32>
        %3 = tensor.empty() : tensor<10xf32>
        %4 = tensor.empty() : tensor<f32>
        %5 = linalg.fill ins(%cst_0 : f32) outs(%4 : tensor<f32>) -> tensor<f32>
        %6 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%2 : tensor<10xf32>) outs(%5 : tensor<f32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_reduction = [4]>} {
        ^bb0(%in: f32, %out: f32):
          %10 = arith.maxnumf %in, %out : f32
          linalg.yield %10 : f32
        } -> tensor<f32>
        %7 = linalg.fill ins(%cst : f32) outs(%4 : tensor<f32>) -> tensor<f32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%2, %6 : tensor<10xf32>, tensor<f32>) outs(%7 : tensor<f32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [0], vector_reduction = [4]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %10 = arith.subf %in, %in_1 : f32
          %11 = math.exp %10 : f32
          %12 = arith.addf %11, %out : f32
          linalg.yield %12 : f32
        } -> tensor<f32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%2, %6, %8 : tensor<10xf32>, tensor<f32>, tensor<f32>) outs(%3 : tensor<10xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_inner_parallel = [4]>} {
        ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
          %10 = arith.subf %in, %in_1 : f32
          %11 = math.exp %10 : f32
          %12 = arith.divf %11, %in_2 : f32
          linalg.yield %12 : f32
        } -> tensor<10xf32>
        iree_tensor_ext.dispatch.tensor.store %9, %1, offsets = [0], sizes = [10], strides = [1] : tensor<10xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<10xf32>>
        return
      }
    }
  }
}
