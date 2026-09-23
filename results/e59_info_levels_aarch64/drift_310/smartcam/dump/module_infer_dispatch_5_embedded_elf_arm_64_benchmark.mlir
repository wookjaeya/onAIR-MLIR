module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_5 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_5_conv_56x56x96x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_5_conv_56x56x96x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 0.000000e+00 : f32
          %cst_0 = arith.constant 6.000000e+00 : f32
          %c3876672 = arith.constant 3876672 : index
          %c8750976 = arith.constant 8750976 : index
          %c8831744 = arith.constant 8831744 : index
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c3876672) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x113x113xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8750976) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x3x3xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c8831744) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>>
          %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<96x56x56xf32>>
          %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [96, 113, 113], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x113x113xf32>> -> tensor<96x113x113xf32>
          %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0], sizes = [96, 3, 3], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96x3x3xf32>> -> tensor<96x3x3xf32>
          %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0], sizes = [96], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<96xf32>> -> tensor<96xf32>
          %7 = tensor.empty() : tensor<96x56x56xf32>
          %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst : f32) outs(%7 : tensor<96x56x56xf32>) -> tensor<96x56x56xf32>
          %9 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d2, d0 * 2 + d3, d1 * 2 + d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d3, d4)>, affine_map<(d0, d1, d2, d3, d4) -> (d2, d0, d1)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction"]} ins(%4, %5 : tensor<96x113x113xf32>, tensor<96x3x3xf32>) outs(%8 : tensor<96x56x56xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [28, 28, 32, 0, 0], vector_common_parallel = [1, 4, 1, 0, 0], vector_reduction = [0, 0, 0, 1, 4]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %11 = arith.mulf %in, %in_1 : f32
            %12 = arith.addf %out, %11 : f32
            linalg.yield %12 : f32
          } -> tensor<96x56x56xf32>
          %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%9, %6 : tensor<96x56x56xf32>, tensor<96xf32>) outs(%7 : tensor<96x56x56xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %11 = arith.addf %in, %in_1 : f32
            %12 = arith.cmpf ult, %11, %cst : f32
            %13 = arith.select %12, %cst, %11 : f32
            %14 = arith.cmpf ugt, %13, %cst_0 : f32
            %15 = arith.select %14, %cst_0, %13 : f32
            linalg.yield %15 : f32
          } -> tensor<96x56x56xf32>
          iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0, 0], sizes = [96, 56, 56], strides = [1, 1, 1] : tensor<96x56x56xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<96x56x56xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c26400768 = arith.constant 26400768 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c26400768}
    util.global.store %buffer, @infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer = util.global.load @infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c8779968 = arith.constant 8779968 : index
    %c8780032 = arith.constant 8780032 : index
    %c8840704 = arith.constant 8840704 : index
    %c17620736 = arith.constant 17620736 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_5::@embedded_elf_arm_64::@infer_dispatch_5_conv_56x56x96x3x3_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_5) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_5::@embedded_elf_arm_64::@infer_dispatch_5_conv_56x56x96x3x3_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer)[%c0, %c8779968], 
        (%infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer)[%c8780032, %c8840704], 
        (%infer_dispatch_5_embedded_elf_arm_64_infer_dispatch_5_conv_56x56x96x3x3_f32_buffer : !hal.buffer)[%c17620736, %c8779968]
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
