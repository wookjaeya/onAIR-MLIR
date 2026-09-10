module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_55 {
    hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_55_softmax_3xf32_dispatch_tensor_store ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_55_softmax_3xf32_dispatch_tensor_store() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert, {enable_loop_peeling}>} {
          %cst = arith.constant 0.000000e+00 : f32
          %cst_0 = arith.constant 0xFFC00000 : f32
          %c5120 = arith.constant 5120 : index
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c5120) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<3xf32>>
          %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0], sizes = [3], strides = [1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3xf32>> -> tensor<3xf32>
          %3 = tensor.empty() : tensor<3xf32>
          %4 = tensor.empty() : tensor<f32>
          %5 = linalg.fill ins(%cst_0 : f32) outs(%4 : tensor<f32>) -> tensor<f32>
          %6 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%2 : tensor<3xf32>) outs(%5 : tensor<f32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_reduction = [4]>} {
          ^bb0(%in: f32, %out: f32):
            %10 = arith.maxnumf %in, %out : f32
            linalg.yield %10 : f32
          } -> tensor<f32>
          %7 = linalg.fill ins(%cst : f32) outs(%4 : tensor<f32>) -> tensor<f32>
          %8 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%2, %6 : tensor<3xf32>, tensor<f32>) outs(%7 : tensor<f32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [0], vector_reduction = [4]>} {
          ^bb0(%in: f32, %in_1: f32, %out: f32):
            %10 = arith.subf %in, %in_1 : f32
            %11 = math.exp %10 : f32
            %12 = arith.addf %11, %out : f32
            linalg.yield %12 : f32
          } -> tensor<f32>
          %9 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%2, %6, %8 : tensor<3xf32>, tensor<f32>, tensor<f32>) outs(%3 : tensor<3xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_inner_parallel = [4]>} {
          ^bb0(%in: f32, %in_1: f32, %in_2: f32, %out: f32):
            %10 = arith.subf %in, %in_1 : f32
            %11 = math.exp %10 : f32
            %12 = arith.divf %11, %in_2 : f32
            linalg.yield %12 : f32
          } -> tensor<3xf32>
          iree_tensor_ext.dispatch.tensor.store %9, %1, offsets = [0], sizes = [3], strides = [1] : tensor<3xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<3xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c8780288 = arith.constant 8780288 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c8780288}
    util.global.store %buffer, @infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer = util.global.load @infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c8779968 = arith.constant 8779968 : index
    %c8780032 = arith.constant 8780032 : index
    %c12 = arith.constant 12 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_55::@embedded_elf_arm_64::@infer_dispatch_55_softmax_3xf32_dispatch_tensor_store) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_55) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_55::@embedded_elf_arm_64::@infer_dispatch_55_softmax_3xf32_dispatch_tensor_store) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer : !hal.buffer)[%c0, %c8779968], 
        (%infer_dispatch_55_embedded_elf_arm_64_infer_dispatch_55_softmax_3xf32_dispatch_tensor_store_buffer : !hal.buffer)[%c8780032, %c12]
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
