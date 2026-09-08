func.func @infer(%x: tensor<?x9xf32>, %w0: tensor<9x64xf32>, %w1: tensor<64x2xf32>) -> tensor<?x2xf32> {
  %c0 = arith.constant 0 : index
  %b = tensor.dim %x, %c0 : tensor<?x9xf32>
  %e0 = tensor.empty(%b) : tensor<?x64xf32>
  %cst = arith.constant 0.0 : f32
  %z0 = linalg.fill ins(%cst : f32) outs(%e0 : tensor<?x64xf32>) -> tensor<?x64xf32>
  %h = linalg.matmul ins(%x, %w0 : tensor<?x9xf32>, tensor<9x64xf32>) outs(%z0 : tensor<?x64xf32>) -> tensor<?x64xf32>
  %e1 = tensor.empty(%b) : tensor<?x2xf32>
  %z1 = linalg.fill ins(%cst : f32) outs(%e1 : tensor<?x2xf32>) -> tensor<?x2xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<?x64xf32>, tensor<64x2xf32>) outs(%z1 : tensor<?x2xf32>) -> tensor<?x2xf32>
  return %o : tensor<?x2xf32>
}
