## Spectral clustering
using DelimitedFiles
using SparseArrays
using LinearAlgebra
using Random
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
n = max(maximum(ei),maximum(ej))
A = sparse(ei,ej,1,n,n)
A = A+A'
m = length(ei) # number of edges
B = sparse(1:m,ei,1,m,n) - sparse(1:m,ej,1,m,n)
L = B'*B
d = vec(sum(A,dims=2))
D = Diagonal(d)
Di = inv(D) # Julia does this efficiently...
Pt = Di*A
P = A*Di # A is symmetric ...
## Make a vector orthogonal to degrees
Random.seed!(1)
x = randn(n)
#x .-= ((d'*x)/(d'*d)).*d
x .-= (d'*x)/(sum(d))
x ./= x'*D*x

##

##
Random.seed!(1)
function simple_spectral_eigenvector(A,nsteps=500)
  @assert issymmetric(A) # expensive, but useful...
  n = size(A,1)
  d = vec(sum(A,dims=1))
  nd2 = d'*d
  x = randn(n)
  # project x orthogonal to d
  x .-= ((d'*x)/nd2).*d
  x ./= x'*(d.*x) # normalize
  for i=1:nsteps
    x = (A*x)./d + x       # matrix-vector
    x .-= ((d'*x)/nd2).*d
    x ./= sqrt(x'*(d.*x)) # normalize
    # make sure the first component is positive
    x .*= sign(x[1])
  end

  return x
end
f = simple_spectral_eigenvector(A)
##
using MatrixNetworks
f2 = fiedler_vector(A)[1]
# make sure the first component is positive
f2 .*= sign(f2[1])
##
norm(f-f2)

##
using Plots
using GraphRecipes
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=13, linecolor=3, linealpha=1.0, linewidth=1.0,
  marker_z = f,
  axis_buffer=0.5, background=:transparent,dpi=300)
xlims!(0,1)
ylims!(-0.05, 1.05)
for i=1:size(A,1)
  if f[i] >= 0
    annotate!(xy[1,i],xy[2,i],text("$i",9,:black))
  else
    annotate!(xy[1,i],xy[2,i],text("$i",9,:white))
  end
end
plot!()
savefig("spectral-clustering-undir.pdf")
