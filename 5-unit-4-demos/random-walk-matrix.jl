## Make an animation of a random walk
using SparseArrays
using DelimitedFiles
## Load the graph
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
##
A = sparse(ei,ej,1,14,14) # make the sparse matrix
A = A+A' # make it symmetric (we only store half)
n = size(A,1)
##
d = vec(sum(A,dims=1)) # get the degrees
Di = Diagonal(1.0./d)
##
x = zeros(n)
x[1] = 1
A'*Di*x
##
P = Matrix(A'*Di)
vals,vecs = eigen(P)
vals
vecs[:,1]/sum(vecs[:,1]) # normalize to prob.
##
d/sum(d)
