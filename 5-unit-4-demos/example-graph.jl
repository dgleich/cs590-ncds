## This script makes the example graphs we'll use in subsequent studies

##
using Plots
using GraphRecipes
using NearestNeighbors
using Random
using SparseArrays
using LinearAlgebra
##
""" This function is weird because it only gets half of the knn, but it makes
a useful picture, so I'm keeping this bug. DO NOT USE FOR ANTYHING REAL. """
function gnk(n,k)
  xy = rand(2,n)
  T = KDTree(xy)
  idxs = knn(T, xy, k)[1]
  # form the edges for sparse
  ei = Int[]
  ej = Int[]
  for i=1:n
    for j=idxs[i]
      if i > j
        push!(ei,i)
        push!(ej,j)
      end
    end
  end
  return xy, ei, ej
end
#Random.seed!(3)
#xy, ei, ej = gnk(25,5)
Random.seed!(1)
xy, ei, ej = gnk(15,4)
gr(size=(300,300))
graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:black, markerstrokecolor=:white,
  markersize=4, linecolor=1, linealpha=0.8, linewidth=0.7,
  axis_buffer=0.02, background=nothing)

##
for i=1:size(xy,2)
  annotate!(xy[1,i],xy[2,i],"$i")
end
gui()
## We are going to remove edge 14,15 for simplicity
n = size(xy,2)
A = sparse(ei,ej,1,n,n)
A = A + A' # make it symmetric
A[14,15] = 0
A[15,14] = 0
A[6,7] = 1
A[7,6] = 1
dropzeros!(A)
## Remove vertex 4 as it's disconnected
verts = collect(1:15)
deleteat!(verts,4)
A = A[verts,verts]
xy = xy[:,verts]
##
ei,ej = findnz(triu(A))[1:2]
graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:black, markerstrokecolor=:white,
  markersize=4, linecolor=1, linealpha=0.8, linewidth=0.7,
  axis_buffer=0.02, background=nothing)
##
using DelimitedFiles
writedlm("undir-graph-14.xy", xy')
writedlm("undir-graph-14.edges", [ei ej])
## Save a few figures
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=8, linecolor=3, linealpha=1.0, linewidth=1.0,
  axis_buffer=0.02, background=:transparent,dpi=300)
savefig("undir-graph-14.pdf")

## Save a few figures
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=14, linecolor=3, linealpha=1.0, linewidth=1.0,
  axis_buffer=0.02, background=:transparent,dpi=300)
for i=1:size(A,1)
  annotate!(xy[1,i],xy[2,i],text("$i",9,:black))
end
savefig("undir-graph-14-labels.pdf")
