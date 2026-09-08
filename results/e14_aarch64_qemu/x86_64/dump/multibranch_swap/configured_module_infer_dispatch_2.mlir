hal.executable public @infer_dispatch_2 {
  hal.executable.variant public @embedded_elf_x86_64 target(<"llvm-cpu", "embedded-elf-x86_64", {cpu = "cascadelake", cpu_features = "+64bit,+adx,+aes,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,+avx,-avx10.1,-avx10.2,+avx2,-avx512bf16,-avx512bitalg,+avx512bw,+avx512cd,+avx512dq,+avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,+avx512vl,+avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,+bmi,+bmi2,-ccmp,-cf,-cldemote,+clflushopt,+clwb,-clzero,+cmov,-cmpccxadd,+crc32,+cx16,+cx8,-egpr,-enqcmd,+f16c,+fma,-fma4,+fsgsbase,+fxsr,-gfni,-hreset,+invpcid,-kl,-lwp,+lzcnt,+mmx,+movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,+pclmul,-pconfig,-pku,+popcnt,-ppx,-prefetchi,+prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,+rdrnd,+rdseed,+rtm,+sahf,-serialize,-sgx,-sha,-sha512,-shstk,-sm3,-sm4,+sse,+sse2,+sse3,+sse4.1,+sse4.2,-sse4a,+ssse3,-tbm,-tsxldtrk,-uintr,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,+xsave,+xsavec,+xsaveopt,+xsaves,-zu", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", iree.encoding.resolver = #iree_cpu.cpu_encoding_resolver<>, max_stack_allocation_size = 32768 : i64, native_vector_size = 64 : i64, target_triple = "x86_64-unknown-unknown-eabi-elf"}>) {
    hal.executable.export public @infer_dispatch_2_matmul_1x64x64_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice()
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @infer_dispatch_2_matmul_1x64x64_f32() attributes {translation_info = #iree_codegen.translation_info<pipeline = CPUDoubleTilingExpert>} {
        %cst = arith.constant 0.000000e+00 : f32
        %c0 = arith.constant 0 : index
        %c256 = arith.constant 256 : index
        %c16896 = arith.constant 16896 : index
        %c512 = arith.constant 512 : index
        %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>>
        %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c16896) flags(ReadOnly) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>>
        %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c256) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>>
        %3 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, ReadOnly>, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c512) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x64xf32>>
        %4 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [1, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>> -> tensor<1x64xf32>
        %5 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [64, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<64x64xf32>> -> tensor<64x64xf32>
        %6 = iree_tensor_ext.dispatch.tensor.load %2, offsets = [0, 0], sizes = [1, 64], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<1x64xf32>> -> tensor<1x64xf32>
        %7 = tensor.empty() : tensor<1x64xf32>
        %8 = linalg.fill {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 16]>} ins(%cst : f32) outs(%7 : tensor<1x64xf32>) -> tensor<1x64xf32>
        %9 = linalg.matmul {lowering_config = #iree_cpu.lowering_config<distribution = [0, 64, 0], vector_common_parallel = [1, 16, 0], vector_reduction = [0, 0, 16]>} ins(%4, %5 : tensor<1x64xf32>, tensor<64x64xf32>) outs(%8 : tensor<1x64xf32>) -> tensor<1x64xf32>
        %10 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%9, %6, %4 : tensor<1x64xf32>, tensor<1x64xf32>, tensor<1x64xf32>) outs(%7 : tensor<1x64xf32>) attrs =  {lowering_config = #iree_cpu.lowering_config<vector_common_parallel = [1, 16]>} {
        ^bb0(%in: f32, %in_0: f32, %in_1: f32, %out: f32):
          %11 = arith.maximumf %in_0, %cst : f32
          %12 = arith.maximumf %in, %cst : f32
          %13 = arith.addf %12, %11 : f32
          %14 = arith.addf %13, %in_1 : f32
          linalg.yield %14 : f32
        } -> tensor<1x64xf32>
        iree_tensor_ext.dispatch.tensor.store %10, %3, offsets = [0, 0], sizes = [1, 64], strides = [1, 1] : tensor<1x64xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<1x64xf32>>
        return
      }
    }
  }
}
