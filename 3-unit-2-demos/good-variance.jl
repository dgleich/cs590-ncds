##
function badvar1(x::Vector{Float64})
ex2 = 0.0
ex = 0.0
for i=1:length(x)
  ex2 = ex2 + x[i]^2
  ex = ex + x[i]
end
n = length(x)
return 1.0/(n-1)*(ex2 - (ex)^2/n)
end
@show badvar1([0.0,1,2])
@show badvar1([0.0,1,2].+1.0e8)
##
using Random
Random.seed!(2)
x = randn(100)
@show badvar1(x)
@show badvar1(x.+1.0e8)
##
function goodvar(x::Vector{Float64})
  n = length(x); mean = 0.0; m2 = 0.0; N = 0.0
  for i=1:n
    N = N + 1 # running length
    delta = x[i] - mean
    mean = mean + delta/N
    m2 = m2 + delta*(x[i]-mean)
  end
  return m2/(n-1)
end
@show goodvar([0.0,1,2])
@show goodvar([0.0,1,2].+1.0e8)
##
using Random
Random.seed!(2)
x = randn(100)
@show goodvar(x)
@show goodvar(x.+1.0e8)
