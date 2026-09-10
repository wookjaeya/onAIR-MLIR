module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_1 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_1_matmul_1x128x128_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_1_matmul_1x128x128_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 0.000000e+00 : f32
          %0 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
          %1 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
          %2 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
          %3 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(3) : i32
          %4 = arith.index_castui %0 : i32 to index
          %5 = arith.index_castui %1 : i32 to index
          %6 = arith.index_castui %2 : i32 to index
          %7 = arith.index_castui %3 : i32 to index
          %8:4 = util.assume.int 
              %4[<umin = 0, umax = 0>, <umin = 512, umax = 512, udiv = 512>, <umin = 0, umax = 0>, <umin = 64, umax = 64, udiv = 64>, <umin = 576, umax = 576, udiv = 576>, <umin = 0, umax = 0>], 
              %5[<umin = 141824, umax = 141824, udiv = 141824>, <umin = 6656, umax = 6656, udiv = 6656>, <umin = 72192, umax = 72192, udiv = 72192>, <umin = 211456, umax = 211456, udiv = 211456>, <umin = 276992, umax = 276992, udiv = 276992>, <umin = 342528, umax = 342528, udiv = 342528>], 
              %6[<umin = 5632, umax = 5632, udiv = 5632>, <umin = 5120, umax = 5120, udiv = 5120>, <umin = 4608, umax = 4608, udiv = 4608>, <umin = 3584, umax = 3584, udiv = 3584>, <umin = 3072, umax = 3072, udiv = 3072>, <umin = 2560, umax = 2560, udiv = 2560>], 
              %7[<umin = 512, umax = 512, udiv = 512>, <umin = 0, umax = 0>, <umin = 512, umax = 512, udiv = 512>, <umin = 576, umax = 576, udiv = 576>, <umin = 0, umax = 0>, <umin = 512, umax = 512, udiv = 512>]
            : index, index, index, index
          %9 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%8#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>>
          %10 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128xf32>>
          %11 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>>
          %12 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%8#3) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x128xf32>>
          %13 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0], sizes = [1, 128], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>> -> tensor<1x128xf32>
          %14 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0], sizes = [128, 128], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<128x128xf32>> -> tensor<128x128xf32>
          %15 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0, 0], sizes = [1, 128], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x128xf32>> -> tensor<1x128xf32>
          %16 = tensor.empty() : tensor<1x128xf32>
          %17 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 16], vector_common_parallel = [1, 8]>} ins(%cst : f32) outs(%16 : tensor<1x128xf32>) -> tensor<1x128xf32>
          %18 = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 16, 0], distribution = [0, 16, 0], vector_common_parallel = [1, 8, 0], vector_reduction = [0, 0, 4]>} ins(%13, %14 : tensor<1x128xf32>, tensor<128x128xf32>) outs(%17 : tensor<1x128xf32>) -> tensor<1x128xf32>
          %19 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%18, %15 : tensor<1x128xf32>, tensor<1x128xf32>) outs(%16 : tensor<1x128xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [0, 16], vector_common_parallel = [1, 8]>} {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %20 = arith.addf %in, %in_0 : f32
            %21 = arith.cmpf ugt, %20, %cst : f32
            %22 = arith.select %21, %20, %cst : f32
            linalg.yield %22 : f32
          } -> tensor<1x128xf32>
          iree_tensor_ext.dispatch.tensor.store %19, %12, offsets = [0, 0], sizes = [1, 128], strides = [1, 1] : tensor<1x128xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x128xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c1065984 = arith.constant 1065984 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c1065984}
    util.global.store %buffer, @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %c0_i32 = arith.constant 0 : i32
    %c342528_i32 = arith.constant 342528 : i32
    %c2560_i32 = arith.constant 2560 : i32
    %c512_i32 = arith.constant 512 : i32
    %infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer = util.global.load @infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c1088 = arith.constant 1088 : index
    %c1280 = arith.constant 1280 : index
    %c1063424 = arith.constant 1063424 : index
    %c1064704 = arith.constant 1064704 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_1::@embedded_elf_arm_64::@infer_dispatch_1_matmul_1x128x128_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_1) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_1::@embedded_elf_arm_64::@infer_dispatch_1_matmul_1x128x128_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) constants([%c0_i32, %c342528_i32, %c2560_i32, %c512_i32]) bindings([
        (%infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer)[%c0, %c1088], 
        (%infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer)[%c1280, %c1063424], 
        (%infer_dispatch_1_embedded_elf_arm_64_infer_dispatch_1_matmul_1x128x128_f32_buffer : !hal.buffer)[%c1064704, %c1088]
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
