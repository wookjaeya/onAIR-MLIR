module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_1 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_1_slow_memcpy ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_1_slow_memcpy() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUBufferOpsTileAndVectorize>} {
          %c0 = arith.constant 0 : index
          %c6422528 = arith.constant 6422528 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : memref<32x224x224xf32>
          %assume_align = memref.assume_alignment %0, 64 : memref<32x224x224xf32>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c6422528) flags(Indirect) : memref<32x226x226xf32, strided<[51076, 226, 1], offset: ?>>
          %assume_align_0 = memref.assume_alignment %1, 64 : memref<32x226x226xf32, strided<[51076, 226, 1], offset: ?>>
          %subview = memref.subview %assume_align_0[0, 1, 1] [32, 224, 224] [1, 1, 1] : memref<32x226x226xf32, strided<[51076, 226, 1], offset: ?>> to memref<32x224x224xf32, strided<[51076, 226, 1], offset: ?>>
          linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%assume_align : memref<32x224x224xf32>) outs(%subview : memref<32x224x224xf32, strided<[51076, 226, 1], offset: ?>>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [32, 56, 56], vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %out: f32):
            linalg.yield %in : f32
          }
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c260357120 = arith.constant 260357120 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c260357120}
    util.global.store %buffer, @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer = util.global.load @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c130178560 = arith.constant 130178560 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_1::@embedded_elf_arm_64::@infer_dispatch_1_slow_memcpy) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_1) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_1::@embedded_elf_arm_64::@infer_dispatch_1_slow_memcpy) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer : !hal.buffer)[%c0, %c130178560], 
        (%infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_slow_memcpy_buffer : !hal.buffer)[%c130178560, %c130178560]
      ]) flags("None")
      hal.command_buffer.execution_barrier<%cmd : !hal.command_buffer> source("Dispatch|CommandRetire") target("CommandIssue|Dispatch") flags("None")
    }
    hal.command_buffer.finalize<%cmd : !hal.command_buffer>
    %1 = util.null : !hal.fence
    %fence = hal.fence.create device(%device : !hal.device) flags("None") : !hal.fence
    hal.device.queue.execute<%device : !hal.device> affinity(%queue_affinity) wait(%1) signal(%fence) commands(%cmd) flags("None")
    %c-1_i32 = arith.constant -1 : i32
    %status = hal.fence.await until([%fence]) timeout_millis(%c-1_i32) flags("None") : i32
    util.status.check_ok %status, "failed to wait on timepoint"
    util.return
  }
}
