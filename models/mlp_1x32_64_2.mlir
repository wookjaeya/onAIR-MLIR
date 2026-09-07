func.func @infer(%input: tensor<1x32xf32>, %w0: tensor<32x64xf32>, %b0: tensor<64xf32>,
                 %w1: tensor<64x2xf32>, %b1: tensor<2xf32>) -> tensor<1x2xf32> {
  %z = arith.constant dense<0.0> : tensor<1x64xf32>
  %h = linalg.matmul ins(%input, %w0 : tensor<1x32xf32>, tensor<32x64xf32>)
                     outs(%z : tensor<1x64xf32>) -> tensor<1x64xf32>
  %z2 = arith.constant dense<0.0> : tensor<1x2xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<1x64xf32>, tensor<64x2xf32>)
                     outs(%z2 : tensor<1x2xf32>) -> tensor<1x2xf32>
  return %o : tensor<1x2xf32>
}
