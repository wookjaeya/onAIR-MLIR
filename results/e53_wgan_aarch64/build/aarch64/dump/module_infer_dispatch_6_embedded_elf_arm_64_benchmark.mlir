module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_6 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_6_conv_128x224x224x128x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_6_conv_128x224x224x128x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 2.000000e-01 : f32
          %cst_0 = arith.constant 0.000000e+00 : f32
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
              %5[<umin = 77876736, umax = 77876736, udiv = 77876736>, <umin = 77415936, umax = 77415936, udiv = 77415936>, <umin = 32112640, umax = 32112640, udiv = 32112640>], 
              %6[<umin = 26035712, umax = 26035712, udiv = 26035712>, <umin = 51725824, umax = 51725824, udiv = 51725824>, <umin = 6422528, umax = 6422528, udiv = 6422528>], 
              %7[<umin = 2656640, umax = 2656640, udiv = 2656640>, <umin = 1475968, umax = 1475968, udiv = 1475968>, <umin = 295296, umax = 295296, udiv = 295296>], 
              %8[<umin = 3246464, umax = 3246464, udiv = 3246464>, <umin = 2065792, umax = 2065792, udiv = 2065792>, <umin = 885120, umax = 885120, udiv = 885120>], 
              %9[<umin = 51725824, umax = 51725824, udiv = 51725824>, <umin = 6422528, umax = 6422528, udiv = 6422528>, <umin = 58263552, umax = 58263552, udiv = 58263552>]
            : index, index, index, index, index
          %11 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%10#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x226x226xf32>>
          %12 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%10#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128x3x3xf32>>
          %13 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%10#1) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x224x224xf32>>
          %14 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%10#3) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128xf32>>
          %15 = hal.interface.binding.subspan layout(<constants = 5, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%10#4) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<128x224x224xf32>>
          %16 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0, 0, 0], sizes = [128, 226, 226], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x226x226xf32>> -> tensor<128x226x226xf32>
          %17 = iree_tensor_ext.dispatch.tensor.load %12, offsets = [0, 0, 0, 0], sizes = [128, 128, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128x3x3xf32>> -> tensor<128x128x3x3xf32>
          %18 = iree_tensor_ext.dispatch.tensor.load %13, offsets = [0, 0, 0], sizes = [128, 224, 224], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x224x224xf32>> -> tensor<128x224x224xf32>
          %19 = iree_tensor_ext.dispatch.tensor.load %14, offsets = [0], sizes = [128], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128xf32>> -> tensor<128xf32>
          %20 = tensor.empty() : tensor<128x224x224xf32>
          %21 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst_0 : f32) outs(%20 : tensor<128x224x224xf32>) -> tensor<128x224x224xf32>
          %22 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%16, %17 : tensor<128x226x226xf32>, tensor<128x128x3x3xf32>) outs(%21 : tensor<128x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [32, 32, 32, 0, 0, 0], vector_common_parallel = [1, 1, 4, 0, 0, 0], vector_reduction = [0, 0, 0, 1, 1, 4]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %24 = arith.mulf %in, %in_1 : f32
            %25 = arith.addf %out, %24 : f32
            linalg.yield %25 : f32
          } -> tensor<128x224x224xf32>
          %23 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%18, %22, %19 : tensor<128x224x224xf32>, tensor<128x224x224xf32>, tensor<128xf32>) outs(%20 : tensor<128x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
            %24 = arith.addf %in_1, %in_2 : f32
            %25 = arith.cmpf olt, %cst_0, %24 : f32
            %26 = arith.select %25, %cst_0, %24 : f32
            %27 = arith.mulf %26, %cst : f32
            %28 = arith.cmpf ogt, %cst_0, %24 : f32
            %29 = arith.select %28, %cst_0, %24 : f32
            %30 = arith.addf %29, %27 : f32
            %31 = arith.addf %in, %30 : f32
            linalg.yield %31 : f32
          } -> tensor<128x224x224xf32>
          iree_tensor_ext.dispatch.tensor.store %23, %15, offsets = [0, 0, 0], sizes = [128, 224, 224], strides = [1, 1, 1] : tensor<128x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<128x224x224xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c264640768 = arith.constant 264640768 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c264640768}
    util.global.store %buffer, @infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %c32112640_i32 = arith.constant 32112640 : i32
    %c6422528_i32 = arith.constant 6422528 : i32
    %c295296_i32 = arith.constant 295296 : i32
    %c885120_i32 = arith.constant 885120 : i32
    %c58263552_i32 = arith.constant 58263552 : i32
    %infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer = util.global.load @infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c130178560 = arith.constant 130178560 : index
    %c4283648 = arith.constant 4283648 : index
    %c134462208 = arith.constant 134462208 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_6::@embedded_elf_arm_64::@infer_dispatch_6_conv_128x224x224x128x3x3_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_6) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_6::@embedded_elf_arm_64::@infer_dispatch_6_conv_128x224x224x128x3x3_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) constants([%c32112640_i32, %c6422528_i32, %c295296_i32, %c885120_i32, %c58263552_i32]) bindings([
        (%infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer)[%c0, %c130178560], 
        (%infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer)[%c130178560, %c4283648], 
        (%infer_dispatch_6_embedded_elf_arm_64_infer_dispatch_6_conv_128x224x224x128x3x3_f32_buffer : !hal.buffer)[%c134462208, %c130178560]
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
