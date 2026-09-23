module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_45 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_45_matmul_like_160x49x960_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_45_matmul_like_160x49x960_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 0.000000e+00 : f32
          %c455296 = arith.constant 455296 : index
          %0 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
          %1 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
          %2 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
          %3 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(3) : i32
          %4 = arith.index_castui %0 : i32 to index
          %5 = arith.index_castui %1 : i32 to index
          %6 = arith.index_castui %2 : i32 to index
          %7 = arith.index_castui %3 : i32 to index
          %8:4 = util.assume.int 
              %4[<umin = 112896, umax = 112896, udiv = 112896>, <umin = 0, umax = 0>], 
              %5[<umin = 4710400, umax = 4710400, udiv = 4710400>, <umin = 3481600, umax = 3481600, udiv = 3481600>], 
              %6[<umin = 8804352, umax = 8804352, udiv = 8804352>, <umin = 8796032, umax = 8796032, udiv = 8796032>], 
              %7[<umin = 0, umax = 0>, <umin = 31360, umax = 31360, udiv = 31360>]
            : index, index, index, index
          %9 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c455296) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<960x49xf32>>
          %10 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x960xf32>>
          %11 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160xf32>>
          %12 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%8#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x49xf32>>
          %13 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%8#3) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<160x49xf32>>
          %14 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0], sizes = [960, 49], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<960x49xf32>> -> tensor<960x49xf32>
          %15 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0], sizes = [160, 960], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x960xf32>> -> tensor<160x960xf32>
          %16 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0], sizes = [160], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160xf32>> -> tensor<160xf32>
          %17 = iree_tensor_ext.dispatch.tensor.load %12, offsets = [0, 0], sizes = [160, 49], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<160x49xf32>> -> tensor<160x49xf32>
          %18 = tensor.empty() : tensor<160x49xf32>
          %19 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 32], vector_common_parallel = [8, 16]>} ins(%cst : f32) outs(%18 : tensor<160x49xf32>) -> tensor<160x49xf32>
          %20 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%14, %15 : tensor<960x49xf32>, tensor<160x960xf32>) outs(%19 : tensor<160x49xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 32, 0], distribution = [16, 32, 0], vector_common_parallel = [8, 16, 0], vector_reduction = [0, 0, 1]>} {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %22 = arith.mulf %in, %in_0 : f32
            %23 = arith.addf %out, %22 : f32
            linalg.yield %23 : f32
          } -> tensor<160x49xf32>
          %21 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%20, %16, %17 : tensor<160x49xf32>, tensor<160xf32>, tensor<160x49xf32>) outs(%18 : tensor<160x49xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [16, 32], vector_common_parallel = [8, 16]>} {
          ^bb0(%in: f32, %in_0: f32, %in_1: f32, %out: f32):
            %22 = arith.addf %in, %in_0 : f32
            %23 = arith.addf %22, %in_1 : f32
            linalg.yield %23 : f32
          } -> tensor<160x49xf32>
          iree_tensor_ext.dispatch.tensor.store %21, %13, offsets = [0, 0], sizes = [160, 49], strides = [1, 1] : tensor<160x49xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<160x49xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c26400768 = arith.constant 26400768 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c26400768}
    util.global.store %buffer, @infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %c0_i32 = arith.constant 0 : i32
    %c3481600_i32 = arith.constant 3481600 : i32
    %c8796032_i32 = arith.constant 8796032 : i32
    %c31360_i32 = arith.constant 31360 : i32
    %infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer = util.global.load @infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c8779968 = arith.constant 8779968 : index
    %c8780032 = arith.constant 8780032 : index
    %c8840704 = arith.constant 8840704 : index
    %c17620736 = arith.constant 17620736 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_45::@embedded_elf_arm_64::@infer_dispatch_45_matmul_like_160x49x960_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_45) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_45::@embedded_elf_arm_64::@infer_dispatch_45_matmul_like_160x49x960_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) constants([%c0_i32, %c3481600_i32, %c8796032_i32, %c31360_i32]) bindings([
        (%infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer)[%c0, %c8779968], 
        (%infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer)[%c8780032, %c8840704], 
        (%infer_dispatch_45_embedded_elf_arm_64_infer_dispatch_45_matmul_like_160x49x960_f32_buffer : !hal.buffer)[%c17620736, %c8779968]
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
