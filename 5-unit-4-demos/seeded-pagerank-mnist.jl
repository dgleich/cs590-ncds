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
## Simple PageRank
function simplepagerank(A,α,v)
  @assert(0 ≤ α < 1, "needs probably α")
  @assert(all(vi -> vi ≥ 0, v), "needs non-negative v")
  v = v ./ sum(v) # we can normalize for them.
  d = vec(sum(A,dims=2)) # compute the degrees
  x = copy(v) # start of with v
  nsteps = 2*ceil(Int,log(eps(1.0))/log(α)) # upper bound on steps
  for i=1:nsteps
    x = α*(A'*(x./d)) .+ (1-α).*v
  end
  return x/sum(x) # renormalize to probability
end

## Let's show global pagerank first
pr = simplepagerank(A,0.85,ones(n)./n)
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
## now show Seeded PageRank
v = zeros(n)
v[1] = 1
pr = simplepagerank(A,0.85,v)

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
savefig("seeded-pagerank-mnist.png")

##
## Try the same set of nodes labeled 1 as we used for the least squares exampmle.
using MLDatasets
train_x, train_y = MNIST.traindata()
nlabels = 10
S = findall(train_y .== 1)[1:nlabels]
##
v = zeros(n)
v[S] .= 1/length(S)
pr = simplepagerank(A,0.85,v)
ei, ej = findnz(A)
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=0, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.2,colorbar=false,
  axis_buffer=0.02, background=nothing)
p=sortperm(pr)
scatter!(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0,alpha=0.5)
savefig("seeded-pagerank-mnist-set-1.png")

##
v = zeros(n)
v[S] .= 1/length(S)
pr = simplepagerank(A,0.5,v)
ei, ej = findnz(A)
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=0, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.2,colorbar=false,
  axis_buffer=0.02, background=nothing)
p=sortperm(pr)
scatter!(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0,alpha=0.5)
savefig("seeded-pagerank-mnist-set-1-alpha-half.png")

##
v = zeros(n)
v[S] .= 1/length(S)
pr = simplepagerank(A,0.99,v)
ei, ej = findnz(A)
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=0, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.2,colorbar=false,
  axis_buffer=0.02, background=nothing)
p=sortperm(pr)
scatter!(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0,alpha=0.5)
savefig("seeded-pagerank-mnist-set-1-alpha-99.png")
