## Show the effect of seeded PageRank on MNIST

## Load the MNIST Graph and draw it
##
using DelimitedFiles
using SparseArrays
using LinearAlgebra
ei,ej = copy.(eachcol(Int.(readdlm("mnist-train-4.edges"))))
xy = readdlm("mnist-train-4.xy")
n = maximum(ei)
A = sparse(ei,ej,1,n,n)
@assert issymmetric(A)

##
using Random
function simple_spectral_eigenvector(A,nsteps=500)
  @assert issymmetric(A) # expensive, but useful...
  Random.seed!(1)
  n = size(A,1)
  d = vec(sum(A,dims=1))
  nd2 = d'*d
  x = randn(n)
  # project x orthogonal to d
  x .-= ((d'*x)/(d'*d)).*d
  x ./= x'*(d.*x) # normalize
  for i=1:nsteps
    x = (A*x)./d          # matrix-vector
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
## why different? convergence is slow :(
f = simple_spectral_eigenvector(A,2500)
norm(f-f2)
## why different? convergence is slow :(
f = simple_spectral_eigenvector(A,4000)
norm(f-f2)
##
using Plots
x = f
p = sortperm(x) # this gets things to draw in the right z-order
scatter(xy[p,1],xy[p,2], marker_z=x[p],colorbar=false,alpha=0.5,
  color=:magma,
  size=(1200,1200),
  markerstrokecolor=:white,markerstrokewidth=0.0,label="",framestyle=:none,
  background=nothing,dpi=220)
savefig("spectral-mnist-500.png")
##
using Plots
x = f2
p = sortperm(x) # this gets things to draw in the right z-order
scatter(xy[p,1],xy[p,2], marker_z=x[p],colorbar=false,alpha=0.5,
  color=:magma,
  size=(1200,1200),
  markerstrokecolor=:white,markerstrokewidth=0.0,label="",framestyle=:none,
  background=nothing,dpi=220)
savefig("spectral-mnist-converged.png")  
## Let's watch spectra converge
using Plots
using GraphRecipes
Random.seed!(1)
function spectral_convergence_animation(A,xy,nsteps_per_frame,nframes)
  @assert issymmetric(A) # expensive, but useful...
  Random.seed!(1)
  n = size(A,1)
  d = vec(sum(A,dims=1))
  sumd = sum(d)
  x = randn(n)
  # project x orthogonal to d
  x .-= (d'*x)/sum(d)
  x ./= x'*(d.*x) # normalize

  anim = @animate for i=1:nframes

    f = zeros(n)
    for j=1:nsteps_per_frame
      x = (A*x)./d          # matrix-vector
      x .-= (d'*x)/sum(d)   # project out
      x ./= sqrt(x'*(d.*x)) # normalize
      # make sure the first component is positive
      #x .*= sign(x[1])
      f .+= x./nsteps_per_frame
    end

    p = sortperm(f) # this gets things to draw in the right z-order
    scatter(xy[p,1],xy[p,2], marker_z=f[p],colorbar=false,alpha=0.5,
      color=:magma,
      size=(1200,1200),dpi=100,
      markerstrokecolor=nothing,markerstrokewidth=0,label="",framestyle=:none,background=:black)
  end
  return anim
end
anim = spectral_convergence_animation(A,xy,10,500)
gif(anim,"spectral-convergence-mnist.gif",fps=30)
##
anim = spectral_convergence_animation(A,xy,1,500)
gif(anim,"spectral-convergence-mnist-1-500.gif",fps=30)

## Now show the entire graph
using GraphRecipes
using LinearAlgebra
using Plots

ei, ej = findnz(A)
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=0, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.2,colorbar=false,
  axis_buffer=0.02, background=nothing)
p=sortperm(pr)
scatter!(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0,alpha=0.5)
savefig("pagerank-mnist.png")
