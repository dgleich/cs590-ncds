# Solving linear systems failing.
using LinearAlgebra
using Printf
using Random
Random.seed!(0)
function hilbert(n::Integer)
  A = zeros(n,n)
  for j=1:n
    for i=1:n
      A[i,j] = 1/(i+j-1)
    end
  end
  return A
end
hilbert(5)
for k in [2,5,10,20,50,100,200]
  A = hilbert(k)
  b = randn(k)
  c = A\b
  #@show k, norm(A*c-b)/norm(b)
  @printf("%3i  %.4e\n", k, norm(A*c-b)/norm(b))
end
