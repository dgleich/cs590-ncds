## Show a quick example of how seeding changes the PageRank values

##
using SparseArrays
using DelimitedFiles
using LinearAlgebra
using Printf
##
ei,ej = copy.(eachcol(Int.(readdlm("wiki-simple.edges"))))
xy = readdlm("wiki-simple.xy")'
pages = readlines("wiki-simple.nodes")
n = length(pages)
A = sparse(ei,ej,1,n,n)
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
pr = simplepagerank(A,0.85,ones(n)./n)
v = zeros(n); v[1] = 1
spr = simplepagerank(A,0.85,v)

for i=1:10
  @printf("%20s  %.4f  %.4f\n", pages[i], pr[i], spr[i])
end
