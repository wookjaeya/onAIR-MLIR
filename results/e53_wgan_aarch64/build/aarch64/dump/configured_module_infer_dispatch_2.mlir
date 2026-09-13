hal.executable public @infer_dispatch_2 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_2_conv_64x224x224x32x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_2_conv_64x224x224x32x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 0.000000e+00 : f32
        %cst_0 = arith.constant 2.000000e-01 : f32
        %cst_1 = arith.constant dense<[0.0240956619, 0.0289248303, -8.057850e-03, 0.0222310834, -8.332260e-03, 0.0471110344, 0.0291783959, 0.00656772451, 0.00864097103, 0.00237553264, -0.00566549879, 0.0411150306, 0.0442913957, 0.00917244143, -0.00196599914, 3.792210e-02, 0.043524649, 0.00579891168, -0.00492627081, 0.0472257212, -0.025553897, -0.00645379722, 0.0163376462, -0.0214827023, 0.0139954202, -0.0173795521, 0.0374337584, 0.00834758765, 0.00108238193, -0.0239597559, 0.0114283497, 0.0138780531, -0.00938829965, -0.00313640619, 0.00195101672, 0.0177503042, 0.0350524709, 0.0337165259, 0.0184168927, -0.00144834863, 0.0171263739, 0.0064968504, 1.15408046E-4, 0.0024302206, 0.0257558953, -0.00545951352, 0.0342418775, -0.00321974186, -0.00254241982, 0.0142794922, 0.0177547857, 0.0256785788, 4.297530e-02, 0.00350902742, 0.0174968243, -0.0204878841, 0.0147746084, 0.0186701939, 0.0124293696, 0.0153432563, 0.0152481273, 0.00935191474, 0.0401507616, -3.597530e-03]> : tensor<64xf32>
        %c6422528 = arith.constant 6422528 : index
        %c4209920 = arith.constant 4209920 : index
        %c12960256 = arith.constant 12960256 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c6422528) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x226x226xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c4209920) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x32x3x3xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c12960256) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<64x226x226xf32>>
        %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [32, 226, 226], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x226x226xf32>> -> tensor<32x226x226xf32>
        %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [64, 32, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x32x3x3xf32>> -> tensor<64x32x3x3xf32>
        %5 = tensor.empty() : tensor<64x224x224xf32>
        %6 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst : f32) outs(%5 : tensor<64x224x224xf32>) -> tensor<64x224x224xf32>
        %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%3, %4 : tensor<32x226x226xf32>, tensor<64x32x3x3xf32>) outs(%6 : tensor<64x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [32, 32, 32, 0, 0, 0], vector_common_parallel = [1, 1, 4, 0, 0, 0], vector_reduction = [0, 0, 0, 1, 1, 4]>} {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %9 = arith.mulf %in, %in_2 : f32
          %10 = arith.addf %out, %9 : f32
          linalg.yield %10 : f32
        } -> tensor<64x224x224xf32>
        %8 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%7, %cst_1 : tensor<64x224x224xf32>, tensor<64xf32>) outs(%5 : tensor<64x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
        ^bb0(%in: f32, %in_2: f32, %out: f32):
          %9 = arith.addf %in, %in_2 : f32
          %10 = arith.cmpf olt, %cst, %9 : f32
          %11 = arith.select %10, %cst, %9 : f32
          %12 = arith.mulf %11, %cst_0 : f32
          %13 = arith.cmpf ogt, %cst, %9 : f32
          %14 = arith.select %13, %cst, %9 : f32
          %15 = arith.addf %14, %12 : f32
          linalg.yield %15 : f32
        } -> tensor<64x224x224xf32>
        iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0, 1, 1], sizes = [64, 224, 224], strides = [1, 1, 1] : tensor<64x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<64x226x226xf32>>
        return
      }
    }
  }
}
