module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_14 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_14_conv_64x112x112x128x3x3_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_14_conv_64x112x112x128x3x3_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 0.000000e+00 : f32
          %cst_0 = arith.constant 2.000000e-01 : f32
          %cst_1 = arith.constant dense<[-0.0204688422, 0.014974514, 0.0250762329, -0.0338112898, 0.0307814572, 0.0177304875, -0.00381246209, -0.0345210284, 0.0312668271, -0.0144574735, -0.0168988351, -0.00599317299, 2.570600e-02, -0.0143792313, 0.0187748224, -0.0275256708, 0.0316802077, -0.00286264205, -0.0296279695, -0.0332766511, 0.0347204655, -0.00273521221, 0.0328069516, 0.0327777639, -0.0246059541, 0.00473266747, -0.0073906742, -0.00637623155, -0.0310352128, -0.00662144367, 0.0330383554, -0.00576886348, 0.0439299867, -0.0260454845, -0.0177291464, -0.0256508403, 0.0239830054, -0.0342720114, 0.00151570374, 2.69675395E-4, 9.251520e-03, 0.0308693014, 0.0205926448, 0.0220312811, 0.002720071, 0.0368088856, -0.0398026407, 0.0144332238, 0.0579894781, 0.0213159043, 0.00341498572, -0.00895917415, -0.0118188914, 0.0236670524, 0.027269043, -0.0364375934, 0.0141719123, 0.0287005901, -0.019393079, 0.0155755151, 0.00486577349, -0.0145964529, 0.0032385916, 0.0407731086]> : tensor<64xf32>
          %c83953664 = arith.constant 83953664 : index
          %c384 = arith.constant 384 : index
          %c6422528 = arith.constant 6422528 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c83953664) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x114x114xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c384) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x128x3x3xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c6422528) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x112x112xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [128, 114, 114], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x114x114xf32>> -> tensor<128x114x114xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [64, 128, 3, 3], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x128x3x3xf32>> -> tensor<64x128x3x3xf32>
          %5 = tensor.empty() : tensor<64x112x112xf32>
          %6 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} ins(%cst : f32) outs(%5 : tensor<64x112x112xf32>) -> tensor<64x112x112xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3, d4, d5) -> (d3, d1 + d4, d2 + d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d3, d4, d5)>, affine_map<(d0, d1, d2, d3, d4, d5) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction", "reduction", "reduction"]} ins(%3, %4 : tensor<128x114x114xf32>, tensor<64x128x3x3xf32>) outs(%6 : tensor<64x112x112xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [32, 28, 28, 0, 0, 0], vector_common_parallel = [1, 1, 4, 0, 0, 0], vector_reduction = [0, 0, 0, 1, 1, 4]>} {
          ^bb0(%in: f32, %in_2: f32, %out: f32):
            %9 = arith.mulf %in, %in_2 : f32
            %10 = arith.addf %out, %9 : f32
            linalg.yield %10 : f32
          } -> tensor<64x112x112xf32>
          %8 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%7, %cst_1 : tensor<64x112x112xf32>, tensor<64xf32>) outs(%5 : tensor<64x112x112xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %in_2: f32, %out: f32):
            %9 = arith.addf %in, %in_2 : f32
            %10 = arith.cmpf olt, %cst, %9 : f32
            %11 = arith.select %10, %cst, %9 : f32
            %12 = arith.mulf %11, %cst_0 : f32
            %13 = arith.cmpf ogt, %cst, %9 : f32
            %14 = arith.select %13, %cst, %9 : f32
            %15 = arith.addf %14, %12 : f32
            linalg.yield %15 : f32
          } -> tensor<64x112x112xf32>
          iree_tensor_ext.dispatch.tensor.store %8, %2, offsets = [0, 0, 0], sizes = [64, 112, 112], strides = [1, 1, 1] : tensor<64x112x112xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<64x112x112xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c264640768 = arith.constant 264640768 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c264640768}
    util.global.store %buffer, @infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer = util.global.load @infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c130178560 = arith.constant 130178560 : index
    %c4283648 = arith.constant 4283648 : index
    %c134462208 = arith.constant 134462208 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_14::@embedded_elf_arm_64::@infer_dispatch_14_conv_64x112x112x128x3x3_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_14) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_14::@embedded_elf_arm_64::@infer_dispatch_14_conv_64x112x112x128x3x3_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer)[%c0, %c130178560], 
        (%infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer)[%c130178560, %c4283648], 
        (%infer_dispatch_14_embedded_elf_arm_64_infer_dispatch_14_conv_64x112x112x128x3x3_f32_buffer : !hal.buffer)[%c134462208, %c130178560]
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
