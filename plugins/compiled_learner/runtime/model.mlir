func.func @infer(%x: tensor<1x9xf32>, %w0: tensor<9x65536xf32>,
                 %w1: tensor<65536x2xf32>) -> tensor<1x2xf32> {
  %z0 = arith.constant dense<0.0> : tensor<1x65536xf32>
  %h = linalg.matmul ins(%x, %w0 : tensor<1x9xf32>, tensor<9x65536xf32>)
                     outs(%z0 : tensor<1x65536xf32>) -> tensor<1x65536xf32>
  %z1 = arith.constant dense<0.0> : tensor<1x2xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<1x65536xf32>, tensor<65536x2xf32>)
                     outs(%z1 : tensor<1x2xf32>) -> tensor<1x2xf32>
  return %o : tensor<1x2xf32>
}
