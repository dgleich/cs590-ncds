using LinearAlgebra
function powermethod(A;maxiter=100000, tol=1e-6)
  x = normalize!(randn(size(A,1)))
  y = A*x
  λ = x'*y
  for i=1:maxiter
    if norm(y - λ*x)/(abs(λ)+1) <= tol
      break
    end
    x = normalize!(y)
    y = A*x
    λ = x'*y
  end
  if norm(y - λ*x)/(abs(λ)+1) >= tol
    @warn("powermethod did not converge, relative residual is ",
      norm(y - λ*x)/(abs(lam)+1))
  end
  return x, λ
end
##
using Random
Random.seed!(2)
A = randn(3,3)
v, lam = powermethod(A)
##
Lams, V = eigen(A)
##
@show lam
@show Lams[1]
##
function powermethod_explain(A,V;maxiter=9)
  x = normalize!(randn(size(A,1)))
  y = A*x
  for i=1:9
    x = normalize!(y)
    y = A*x
    println(i, ", ", V'*x)
  end
end
using Random
Random.seed!(2)
A = randn(3,3)
A = A+A' # make it symmetric
Lams, V = eigen(A)
powermethod_explain(A,V)
## example on population growth matrix
G = [1.0215 0.0127; 0.0627 1.0667 ]
v, lam = powermethod(G)
@show  g = v / sum(v), lam
