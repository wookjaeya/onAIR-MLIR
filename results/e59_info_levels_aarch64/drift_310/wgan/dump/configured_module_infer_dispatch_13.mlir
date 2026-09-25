hal.executable public @infer_dispatch_13 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_13_elementwise_broadcast_128x112x112_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_13_elementwise_broadcast_128x112x112_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
        %cst = arith.constant 5.000000e-01 : f32
        %cst_0 = arith.constant 0.000000e+00 : f32
        %cst_1 = arith.constant 2.230000e+02 : f32
        %cst_2 = arith.constant 1.000000e+00 : f32
        %c58263552 = arith.constant 58263552 : index
        %c83953664 = arith.constant 83953664 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c58263552) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x224x224xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c83953664) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<128x114x114xf32>>
        %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [128, 224, 224], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x224x224xf32>> -> tensor<128x224x224xf32>
        %3 = tensor.empty() : tensor<128x112x112xf32>
        %4 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} outs(%3 : tensor<128x112x112xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [32, 56, 56], vector_common_parallel = [1, 1, 4]>} {
        ^bb0(%out: f32):
          %5 = linalg.index 0 : index
          %6 = linalg.index 1 : index
          %7 = linalg.index 2 : index
          %8 = arith.index_cast %6 : index to i64
          %9 = arith.sitofp %8 : i64 to f32
          %10 = arith.addf %9, %cst : f32
          %11 = arith.divf %10, %cst : f32
          %12 = arith.subf %11, %cst : f32
          %13 = arith.maximumf %12, %cst_0 : f32
          %14 = arith.minimumf %13, %cst_1 : f32
          %15 = arith.index_cast %7 : index to i64
          %16 = arith.sitofp %15 : i64 to f32
          %17 = arith.addf %16, %cst : f32
          %18 = arith.divf %17, %cst : f32
          %19 = arith.subf %18, %cst : f32
          %20 = arith.maximumf %19, %cst_0 : f32
          %21 = arith.minimumf %20, %cst_1 : f32
          %22 = math.floor %14 : f32
          %23 = arith.addf %14, %cst_2 : f32
          %24 = math.floor %23 : f32
          %25 = arith.fptosi %22 : f32 to i64
          %26 = arith.index_cast %25 : i64 to index
          %27 = arith.minimumf %23, %cst_1 : f32
          %28 = arith.fptosi %27 : f32 to i64
          %29 = arith.index_cast %28 : i64 to index
          %30 = math.floor %21 : f32
          %31 = arith.addf %21, %cst_2 : f32
          %32 = math.floor %31 : f32
          %33 = arith.fptosi %30 : f32 to i64
          %34 = arith.index_cast %33 : i64 to index
          %35 = arith.minimumf %31, %cst_1 : f32
          %36 = arith.fptosi %35 : f32 to i64
          %37 = arith.index_cast %36 : i64 to index
          %extracted = tensor.extract %2[%5, %26, %34] : tensor<128x224x224xf32>
          %extracted_3 = tensor.extract %2[%5, %26, %37] : tensor<128x224x224xf32>
          %extracted_4 = tensor.extract %2[%5, %29, %34] : tensor<128x224x224xf32>
          %extracted_5 = tensor.extract %2[%5, %29, %37] : tensor<128x224x224xf32>
          %38 = arith.subf %24, %14 : f32
          %39 = arith.subf %14, %22 : f32
          %40 = arith.subf %32, %21 : f32
          %41 = arith.subf %21, %30 : f32
          %42 = arith.mulf %40, %extracted : f32
          %43 = arith.mulf %41, %extracted_3 : f32
          %44 = arith.addf %42, %43 : f32
          %45 = arith.mulf %38, %44 : f32
          %46 = arith.mulf %40, %extracted_4 : f32
          %47 = arith.mulf %41, %extracted_5 : f32
          %48 = arith.addf %46, %47 : f32
          %49 = arith.mulf %39, %48 : f32
          %50 = arith.addf %45, %49 : f32
          linalg.yield %50 : f32
        } -> tensor<128x112x112xf32>
        iree_tensor_ext.dispatch.tensor.store %4, %1, offsets = [0, 1, 1], sizes = [128, 112, 112], strides = [1, 1, 1] : tensor<128x112x112xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<128x114x114xf32>>
        return
      }
    }
  }
}
