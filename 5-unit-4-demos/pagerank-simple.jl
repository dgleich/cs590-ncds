## Here is the code from unit 1

# This treats everything as a dense matrix :(
A = [0 1 1 1 1 0 1 0 0 0
     1 0 0 0 0 0 0 0 0 0
     0 0 0 0 1 1 1 0 0 0
     1 1 0 0 1 1 0 1 0 0
     1 1 1 1 0 0 0 0 1 0
     0 0 1 0 0 0 1 0 1 1
     0 0 0 0 0 1 0 0 0 1
     0 0 0 0 0 0 0 0 1 0
     0 0 0 0 0 0 0 1 0 0
     0 0 0 0 0 0 0 0 0 0]
d = sum(A,dims=2)
##
using Printf
for i=1:10
  for j=1:10
    if i==j
      @printf("1 & ")
    elseif A[j,i] != 0
      @printf("-\\alpha/%i & ", d[j])
    else
      @printf("0 & ")
    end
  end
  println("\\\\")
end
## Build the I - alpha D^+ A'
alpha = 0.85
M = zeros(size(A)...)
for i=1:10
  for j=1:10
    if i==j
      M[i,j] = 1
    elseif A[j,i] != 0
      M[i,j] = -alpha*A[j,i]/d[j]
    else
      M[i,j] = 0
    end
  end
end
M[:,end] .= -alpha/10
M[end,end] += 1
M[:,1]
##
b = ones(size(A,1))/size(A,1)*(1-alpha)
x = M\b

##
using DelimitedFiles
using SparseArrays
ei,ej = copy.(eachcol(Int.(readdlm("wiki-simple.edges"))))
xy = readdlm("wiki-simple.xy")
pages = readlines("wiki-simple.nodes")
n = size(xy,1)
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
