module {
  util.global private @__device_0 = #hal.device.target<"local", [#hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>]> : !hal.device
  hal.executable private @infer_dispatch_0 {
    hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
      hal.executable.export public @infer_dispatch_0_elementwise_3x224x224_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @infer_dispatch_0_elementwise_3x224x224_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert>} {
          %cst = arith.constant 2.000000e+00 : f32
          %cst_0 = arith.constant 1.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x224x224xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<3x225x225xf32>>
          %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [3, 224, 224], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x224x224xf32>> -> tensor<3x224x224xf32>
          %3 = tensor.empty() : tensor<3x224x224xf32>
          %4 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%2 : tensor<3x224x224xf32>) outs(%3 : tensor<3x224x224xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<distribution = [3, 56, 56], vector_common_parallel = [1, 1, 4]>} {
          ^bb0(%in: f32, %out: f32):
            %5 = arith.mulf %in, %cst : f32
            %6 = arith.subf %5, %cst_0 : f32
            linalg.yield %6 : f32
          } -> tensor<3x224x224xf32>
          iree_tensor_ext.dispatch.tensor.store %4, %1, offsets = [0, 0, 0], sizes = [3, 224, 224], strides = [1, 1, 1] : tensor<3x224x224xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<3x225x225xf32>>
          return
        }
      }
    }
  }
  util.global private mutable @infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer : !hal.buffer
  util.initializer {
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %allocator = hal.device.allocator<%device : !hal.device> : !hal.allocator
    %memory_type = hal.memory_type<"DeviceVisible|DeviceLocal"> : i32
    %buffer_usage = hal.buffer_usage<"TransferSource|TransferTarget|Transfer|DispatchStorageRead|DispatchStorageWrite|DispatchStorage"> : i32
    %c9382144 = arith.constant 9382144 : index
    %buffer = hal.allocator.allocate<%allocator : !hal.allocator> affinity(%queue_affinity) type(%memory_type) usage(%buffer_usage) : !hal.buffer{%c9382144}
    util.global.store %buffer, @infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer : !hal.buffer
    util.return
  }
  util.func public @infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32(%arg0: i32) attributes {iree.abi.stub, iree.reflection = {iree.benchmark = "dispatch"}} {
    %0 = arith.index_cast %arg0 : i32 to index
    %device, %queue_affinity = hal.device.resolve on(#hal.device.affinity<@__device_0>) : !hal.device, i64
    %cmd = hal.command_buffer.create device(%device : !hal.device) mode("OneShot|AllowInlineExecution") categories(Dispatch) affinity(%queue_affinity) : !hal.command_buffer
    %infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer = util.global.load @infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer : !hal.buffer
    %c0 = arith.constant 0 : index
    %c602112 = arith.constant 602112 : index
    %c8779968 = arith.constant 8779968 : index
    %workgroup_x, %workgroup_y, %workgroup_z = hal.executable.calculate_workgroups device(%device : !hal.device) target(@infer_dispatch_0::@embedded_elf_x86_64::@infer_dispatch_0_elementwise_3x224x224_f32) : index, index, index
    %exe = hal.executable.lookup device(%device : !hal.device) executable(@infer_dispatch_0) : !hal.executable
    %ordinal = hal.executable.export.ordinal target(@infer_dispatch_0::@embedded_elf_x86_64::@infer_dispatch_0_elementwise_3x224x224_f32) : index
    %c1 = arith.constant 1 : index
    scf.for %arg1 = %c0 to %0 step %c1 {
      hal.command_buffer.dispatch<%cmd : !hal.command_buffer> target(%exe : !hal.executable)[%ordinal] workgroups([%workgroup_x, %workgroup_y, %workgroup_z]) bindings([
        (%infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer : !hal.buffer)[%c0, %c602112], 
        (%infer_dispatch_0_embedded_elf_x86_64_infer_dispatch_0_elementwise_3x224x224_f32_buffer : !hal.buffer)[%c602112, %c8779968]
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
