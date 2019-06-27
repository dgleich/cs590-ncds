## Spectral clustering on artists
using DelimitedFiles
using SparseArrays
names = readlines("../2-unit-1-demos/artistsim.names")
data = readdlm("../2-unit-1-demos/artistsim.smat")
xy = readdlm("artistsim.xy")
A = sparse(Int.(data[2:end,1]).+1,
           Int.(data[2:end,2]).+1,
           Int.(data[2:end,3]),
           Int(data[1,1]),Int(data[1,1]))
n = size(A,1)
##
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
  return x./sum(x) # renormalize to probability
end
##
using MatrixNetworks
pr = MatrixNetworks.pagerank(A,0.85)
##
x = simplepagerank(A,0.85,ones(n)./n)
##
using LinearAlgebra
@show norm(x-pr)

##
@time pr = MatrixNetworks.pagerank(A,0.85)
@time x = simplepagerank(A,0.85,ones(n)./n)
@show norm(x-pr)
## Let's watch PageRank converge
using Plots
function pagerank_converence_animation(A,xy,α,nsteps)
  n = size(A,1)
  v = ones(n)/n
  @assert(0 ≤ α < 1, "needs probably α")
  @assert(all(vi -> vi ≥ 0, v), "needs non-negative v")
  v = v ./ sum(v) # we can normalize for them.
  d = vec(sum(A,dims=2)) # compute the degrees
  x = copy(v) # start of with v

  @assert(nsteps <= size(A,1))
  anim = @animate for i=1:nsteps
    x = α*(A'*(x./d)) .+ (1-α).*v
    f2 = copy(x)
    p = sortperm(f2) # this gets things to draw in the right z-order
    scatter(xy[p,1],xy[p,2], marker_z=-abs.(log10.(f2[p])).^0.5,colorbar=false,alpha=0.5,
      color=:magma,
      size=(1200,1200),
      markerstrokecolor=nothing,markerstrokewidth=0,label="",framestyle=:none,background=:black)
  end
  return anim
end
anim = pagerank_converence_animation(A,xy,0.85,25)
gif(anim,"pagerank-convergence-artistsim.gif",fps=5)

##
p=sortperm(pr)
scatter(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0)
## Now show the entire graph
p=sortperm(pr)
ei, ej = findnz(triu(A,1))
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=0, linecolor=1, linealpha=0.01, linewidth=0.5,
  markeralpha=0.2,colorbar=false,
  axis_buffer=0.02, background=nothing)
scatter!(xy[p,1],xy[p,2],marker_z=-abs.(log10.(pr[p])).^0.5,markerstrokewidth=0)
##
savefig("artistsim-pagerank.png")
