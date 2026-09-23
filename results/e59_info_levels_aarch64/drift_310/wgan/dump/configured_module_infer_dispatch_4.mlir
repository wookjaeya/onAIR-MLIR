hal.executable public @infer_dispatch_4 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_4_slow_memcpy ordinal(0) layout(#hal.pipeline.layout<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_4_slow_memcpy() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUBufferOpsTileAndVectorize>} {
        %0 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = arith.index_castui %0 : i32 to index
        %3 = arith.index_castui %1 : i32 to index
        %4:2 = util.assume.int 
            %2[<umin = 26035712, umax = 26035712, udiv = 26035712>, <umin = 51725824, umax = 51725824, udiv = 51725824>, <umin = 6422528, umax = 6422528, udiv = 6422528>], 
            %3[<umin = 51725824, umax = 51725824, udiv = 51725824>, <umin = 104027648, umax = 104027648, udiv = 104027648>, <umin = 103566848, umax = 103566848, udiv = 103566848>]
          : index, index
        %5 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%4#0) flags("ReadOnly|Indirect") : memref<128x224x224xf32, strided<[50176, 224, 1], offset: ?>>
        %assume_align = memref.assume_alignment %5, 64 : memref<128x224x224xf32, strided<[50176, 224, 1], offset: ?>>
        %6 = hal.interface.binding.subspan layout(<constants = 2, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%4#1) flags(Indirect) : memref<128x226x226xf32, strided<[51076, 226, 1], offset: ?>>
        %assume_align_0 = memref.assume_alignment %6, 64 : memref<128x226x226xf32, strided<[51076, 226, 1], offset: ?>>
        %subview = memref.subview %assume_align_0[0, 1, 1] [128, 224, 224] [1, 1, 1] : memref<128x226x226xf32, strided<[51076, 226, 1], offset: ?>> to memref<128x224x224xf32, strided<[51076, 226, 1], offset: ?>>
        linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%assume_align : memref<128x224x224xf32, strided<[50176, 224, 1], offset: ?>>) outs(%subview : memref<128x224x224xf32, strided<[51076, 226, 1], offset: ?>>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [64, 56, 56], vector_common_parallel = [1, 1, 4]>} {
        ^bb0(%in: f32, %out: f32):
          linalg.yield %in : f32
        }
        return
      }
    }
  }
}
