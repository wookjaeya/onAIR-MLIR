hal.executable public @infer_dispatch_17 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_17_conv_3x224x224x32x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_17_conv_3x224x224x32x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant dense<[-0.0485754684, -0.0268937256, -0.0023565595]> : tensor<3xf32>
        %c22709248 = arith.constant 22709248 : index
        %c4132736 = arith.constant 4132736 : index
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c22709248) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x226x226xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c4132736) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x32x3x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x224x224xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(3) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<3x224x224xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [32, 226, 226], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x226x226xf32>> -> tensor<32x226x226xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [3, 32, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x32x3x3xf32>> -> tensor<3x32x3x3xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0, 0], sizes = [3, 224, 224], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x224x224xf32>> -> tensor<3x224x224xf32>
        %7 = tensor.empty() : tensor<3x224x224xf32>
        %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst : f32) outs(%7 : tensor<3x224x224xf32>) -> tensor<3x224x224xf32>
        %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%4, %5 : tensor<32x226x226xf32>, tensor<3x32x3x3xf32>) outs(%8 : tensor<3x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [3, 32, 32, 0, 0, 0], vector_common_parallel = [1, 1, 4, 0, 0, 0], vector_reduction = [0, 0, 0, 1, 1, 4]>} {
        ^bb0(%in: f32, %in_1: f32, %out: f32):
          %11 = arith.mulf %in, %in_1 : f32
          %12 = arith.addf %out, %11 : f32
          linalg.yield %12 : f32
        } -> tensor<3x224x224xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%6, %9, %cst_0 : tensor<3x224x224xf32>, tensor<3x224x224xf32>, tensor<3xf32>) outs(%7 : tensor<3x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
        ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
          %11 = arith.addf %in_1, %in_2 : f32
          %12 = math.tanh %11 : f32
          %13 = arith.addf %in, %12 : f32
          linalg.yield %13 : f32
        } -> tensor<3x224x224xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0, 0], sizes = [3, 224, 224], strides = [1, 1, 1] : tensor<3x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<3x224x224xf32>>
        return
      }
    }
  }
}
