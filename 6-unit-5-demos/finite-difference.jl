## Let's see how finite difference approximations work.

using Printf
myfun = x -> sin(x)
myderiv = x -> cos(x) # so we can get error
finitediff(f,x,h) = (f(x+h) - f(x))/h
x = pi/6
truederiv = myderiv(x)
for h = 10.0.^-(1:16)
  fdderiv = finitediff(myfun,x,h)
  @printf("h=%.1e approx=%.8e err=%.8e\n",
    h, fdderiv, abs(fdderiv-truederiv))
end

## Now try a multidim version
function finitediff_i(f,x,h,i)
  fx = f(x)
  xi = x[i] # make a copy
  x[i] += h
  fxh = f(x) # eval f(x+h)
  x[i] = xi # restore
  return (fxh-fx)/h
end
finitediffgrad(f,x,h) = map( i -> finitediff_i(f,x,h,i), 1:length(x) )
## validate our work on gradient of quadratics
using LinearAlgebra
Q = [1 0.5;0.5 1]
s = [-1,-1.5]
quadratic2(A,b) = x -> x'*A*x + x'*b
myfun = quadratic2(Q,s)
myderiv = x -> 2*Q*x + s
x = [3.5;-1.5]
truederiv = myderiv(x)
for h = 10.0.^-(1:16)
  fdderiv = finitediffgrad(myfun,x,h)
  @printf("h=%.1e  err=%.8e\n",
    h, norm(fdderiv-truederiv))
end
