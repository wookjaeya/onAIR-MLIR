module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_22 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_22_matmul_like_384x14x14x64_f32 ordinal(0) layout(#hal.pipeline.layout<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_22_matmul_like_384x14x14x64_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 6.000000e+00 : f32
          %cst_0 = arith.constant 0.000000e+00 : f32
          %0 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
          %1 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
          %2 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
          %3 = hal.interface.constant.load layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(3) : i32
          %4 = arith.index_castui %0 : i32 to index
          %5 = arith.index_castui %1 : i32 to index
          %6 = arith.index_castui %2 : i32 to index
          %7 = arith.index_castui %3 : i32 to index
          %8:4 = util.assume.int 
              %4[<umin = 150528, umax = 150528, udiv = 150528>, <umin = 0, umax = 0>, <umin = 50176, umax = 50176, udiv = 50176>, <umin = 0, umax = 0>], 
              %5[<umin = 8151040, umax = 8151040, udiv = 8151040>, <umin = 7954432, umax = 7954432, udiv = 7954432>, <umin = 7757824, umax = 7757824, udiv = 7757824>, <umin = 7561216, umax = 7561216, udiv = 7561216>], 
              %6[<umin = 8777088, umax = 8777088, udiv = 8777088>, <umin = 8774016, umax = 8774016, udiv = 8774016>, <umin = 8770944, umax = 8770944, udiv = 8770944>, <umin = 8828288, umax = 8828288, udiv = 8828288>], 
              %7[<umin = 200704, umax = 200704, udiv = 200704>, <umin = 200704, umax = 200704, udiv = 200704>, <umin = 100352, umax = 100352, udiv = 100352>, <umin = 100352, umax = 100352, udiv = 100352>]
            : index, index, index, index
          %9 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%8#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x14x14xf32>>
          %10 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#1) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x64xf32>>
          %11 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%8#2) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384xf32>>
          %12 = hal.interface.binding.subspan layout(<constants = 4, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%8#3) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<384x16x16xf32>>
          %13 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0, 0], sizes = [64, 14, 14], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x14x14xf32>> -> tensor<64x14x14xf32>
          %14 = iree_tensor_ext.dispatch.tensor.load %10, offsets = [0, 0], sizes = [384, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384x64xf32>> -> tensor<384x64xf32>
          %15 = iree_tensor_ext.dispatch.tensor.load %11, offsets = [0], sizes = [384], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<384xf32>> -> tensor<384xf32>
          %16 = tensor.empty() : tensor<384x14x14xf32>
          %17 = linalg.fill {lowering_config = #iree_cpu.lowering_config<cache_parallel = [48, 7, 14], vector_common_parallel = [1, 8, 16]>} ins(%cst_0 : f32) outs(%16 : tensor<384x14x14xf32>) -> tensor<384x14x14xf32>
          %18 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d3, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%13, %14 : tensor<64x14x14xf32>, tensor<384x64xf32>) outs(%17 : tensor<384x14x14xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [48, 7, 14, 0], distribution = [48, 7, 14, 0], vector_common_parallel = [1, 8, 16, 0], vector_reduction = [0, 0, 0, 1]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %20 = arith.mulf %in, %in_1 : f32
            %21 = arith.addf %out, %20 : f32
            linalg.yield %21 : f32
          } -> tensor<384x14x14xf32>
          %19 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%18, %15 : tensor<384x14x14xf32>, tensor<384xf32>) outs(%16 : tensor<384x14x14xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<cache_parallel = [48, 7, 14], vector_common_parallel = [1, 8, 16]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %20 = arith.addf %in, %in_1 : f32
            %21 = arith.cmpf ult, %20, %cst_0 : f32
            %22 = arith.select %21, %cst_0, %20 : f32
            %23 = arith.cmpf ugt, %22, %cst : f32
            %24 = arith.select %23, %cst, %22 : f32
            linalg.yield %24 : f32
          } -> tensor<384x14x14xf32>
          iree_tensor_ext.dispatch.tensor.store %19, %12, offsets = [0, 1, 1], sizes = [384, 14, 14], strides = [1, 1, 1] : tensor<384x14x14xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<384x16x16xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c26400768 = arith.constant 26400768 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c26400768}
    util.global.store %buffer, @infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %c0_i32 = arith.constant 0 : i32
    %c7561216_i32 = arith.constant 7561216 : i32
    %c8828288_i32 = arith.constant 8828288 : i32
    %c100352_i32 = arith.constant 100352 : i32
    %infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer = util.global.load @infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c8779968 = arith.constant 8779968 : index
    %c8780032 = arith.constant 8780032 : index
    %c8840704 = arith.constant 8840704 : index
    %c17620736 = arith.constant 17620736 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_22::@embedded_elf_arm_64::@infer_dispatch_22_matmul_like_384x14x14x64_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_22) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_22::@embedded_elf_arm_64::@infer_dispatch_22_matmul_like_384x14x14x64_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) constants([%c0_i32, %c7561216_i32, %c8828288_i32, %c100352_i32]) bindings([
        (%infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer)[%c0, %c8779968], 
        (%infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer)[%c8780032, %c8840704], 
        (%infer_dispatch_22_embedded_elf_arm_64_infer_dispatch_22_matmul_like_384x14x14x64_f32_buffer : !hal.buffer)[%c17620736, %c8779968]
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
