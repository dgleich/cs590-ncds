##
function badvar1(x::Vector{Float64})
ex2 = 0.0
ex = 0.0
n = length(x)
for i=1:n
  ex2 = ex2 + x[i]^2
  ex = ex + x[i]
end
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
