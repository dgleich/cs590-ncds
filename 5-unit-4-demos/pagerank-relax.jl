## Here is the code from unit 1

##
using DelimitedFiles
using SparseArrays
ei,ej = copy.(eachcol(Int.(readdlm("wiki-simple.edges"))))
xy = readdlm("wiki-simple.xy")
pages = readlines("wiki-simple.nodes")
n = size(xy,1)
A = sparse(ei,ej,1,n,n)

##  PageRank with coordinate relaxation
#
function relaxpagerank(A,α,v)
  @assert(0 ≤ α < 1, "needs probably α")
  @assert(all(vi -> vi ≥ 0, v), "needs non-negative v")
  v = v ./ sum(v) # we can normalize for them.
  d = vec(sum(A,dims=2)) # compute the degrees
  x = copy(v) # start of with v
  nsteps = 2*ceil(Int,log(eps(1.0))/log(α)) # upper bound on steps
  # we need row's of A', which are columns of A.
  # it's also easier to iterate over Di*x, instead of x
  d[d .== 0] .= 1 # switch 0's to 1's
  idx = x./d
  for i=1:nsteps
    for j=1:size(A,1)
      rhs = (1-α)*v[j]  + α*(A[:,j]'*idx)
      gamma = rhs/(1 - α*A[j,j])
      idx[j] = gamma/d[j]
    end
  end
  x =  (d.*idx)
  return x/sum(x) # renormalize to probability
end
x = relaxpagerank(A,0.85,ones(n)/n)

##
using MatrixNetworks
pr = pagerank(A,0.85)
norm(x-pr)
