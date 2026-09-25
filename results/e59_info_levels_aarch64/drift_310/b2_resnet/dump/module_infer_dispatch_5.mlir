hal.executable public @infer_dispatch_5 {
  hal.executable.variant public @embedded_elf_arm_64 target(<"llvm-cpu", "embedded-elf-arm_64", {cpu = "cortex-a53", cpu_features = "+v8a,+aes,+crc,+fp-armv8,+neon,+perfmon,+sha2,+reserve-x18", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 16 : i64, target_triple = "aarch64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_5_slow_memcpy ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_5_slow_memcpy() {
        %c79424 = arith.constant 79424 : index
        %c227392 = arith.constant 227392 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c79424) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x32x32xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c227392) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<16x33x33xf32>>
        %2 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [16, 32, 32], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<16x32x32xf32>> -> tensor<16x32x32xf32>
        iree_tensor_ext.dispatch.tensor.store %2, %1, offsets = [0, 0, 0], sizes = [16, 32, 32], strides = [1, 1, 1] : tensor<16x32x32xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<16x33x33xf32>>
        return
      }
    }
  }
}
