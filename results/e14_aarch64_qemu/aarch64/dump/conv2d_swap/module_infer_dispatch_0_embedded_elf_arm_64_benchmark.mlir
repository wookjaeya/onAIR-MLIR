module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_0 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_0_conv_6x6x4x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_0_conv_6x6x4x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant dense_resource<__elided__> : tensor<3x3x4xf32>
          %cst_0 = arith.constant 0.000000e+00 : f32
          %cst_1 = arith.constant dense<[-0.0514006354, -0.164807513, 0.0167464744, 0.0109014092]> : tensor<4xf32>
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x8xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<6x6x4xf32>>
          %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [8, 8], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x8xf32>> -> tensor<8x8xf32>
          %3 = tensor.empty() : tensor<6x6x4xf32>
          %4 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst_0 : f32) outs(%3 : tensor<6x6x4xf32>) -> tensor<6x6x4xf32>
          %5 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0 + d3, d1 + d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d3, d4, d2)>, affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction"]} ins(%2, %cst : tensor<8x8xf32>, tensor<3x3x4xf32>) outs(%4 : tensor<6x6x4xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [1, 3, 4, 0, 0], vector_common_parallel = [1, 1, 4, 0, 0], vector_reduction = [0, 0, 0, 1, 1]>} {
          ^bb0(%in: f32, %in_2: f32, %out: f32):
            %7 = arith.mulf %in, %in_2 : f32
            %8 = arith.addf %out, %7 : f32
            linalg.yield %8 : f32
          } -> tensor<6x6x4xf32>
          %6 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%5, %cst_1 : tensor<6x6x4xf32>, tensor<4xf32>) outs(%3 : tensor<6x6x4xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %in_2: f32, %out: f32):
            %7 = arith.addf %in, %in_2 : f32
            %8 = arith.maximumf %7, %cst_0 : f32
            linalg.yield %8 : f32
          } -> tensor<6x6x4xf32>
          iree_tensor_ext.dispatch.tensor.store %6, %1, offsets = [0, 0, 0], sizes = [6, 6, 4], strides = [1, 1, 1] : tensor<6x6x4xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<6x6x4xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c1536 = arith.constant 1536 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c1536}
    util.global.store %buffer, @infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer = util.global.load @infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c256 = arith.constant 256 : index
    %c1088 = arith.constant 1088 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_0::@embedded_elf_arm_64::@infer_dispatch_0_conv_6x6x4x3x3_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_0) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_0::@embedded_elf_arm_64::@infer_dispatch_0_conv_6x6x4x3x3_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer : !hal.buffer)[%c0, %c256], 
        (%infer_dispatch_0_embedded_elf_arm_64_infer_dispatch_0_conv_6x6x4x3x3_f32_buffer : !hal.buffer)[%c256, %c1088]
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
