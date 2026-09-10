hal.executable public @infer_dispatch_5 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_5_slow_memcpy ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_5_slow_memcpy() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUBufferOpsTileAndVectorize>} {
        %c79424 = arith.constant 79424 : index
        %c227392 = arith.constant 227392 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c79424) flags("ReadOnly|Indirect") : memref<16x32x32xf32, strided<[1024, 32, 1], offset: ?>>
        %assume_align = memref.assume_alignment %0, 64 : memref<16x32x32xf32, strided<[1024, 32, 1], offset: ?>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c227392) flags(Indirect) : memref<16x33x33xf32, strided<[1089, 33, 1], offset: ?>>
        %assume_align_0 = memref.assume_alignment %1, 64 : memref<16x33x33xf32, strided<[1089, 33, 1], offset: ?>>
        %subview = memref.subview %assume_align_0[0, 0, 0] [16, 32, 32] [1, 1, 1] : memref<16x33x33xf32, strided<[1089, 33, 1], offset: ?>> to memref<16x32x32xf32, strided<[1089, 33, 1], offset: ?>>
        linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%assume_align : memref<16x32x32xf32, strided<[1024, 32, 1], offset: ?>>) outs(%subview : memref<16x32x32xf32, strided<[1089, 33, 1], offset: ?>>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [8, 16, 32], vector_common_parallel = [1, 1, 4]>} {
        ^bb0(%in: f32, %out: f32):
          linalg.yield %in : f32
        }
        return
      }
    }
  }
}
