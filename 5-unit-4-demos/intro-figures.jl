## Intro figures
using Plots
using GraphRecipes
using NearestNeighbors
using Random
using SparseArrays
using LinearAlgebra
## Load the graph data
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
n = size(xy,2)
A = sparse(ei,ej,1,n,n)
A = A+A'
##
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=8, linecolor=3, linealpha=1.0, linewidth=1.0,
  axis_buffer=0.02, background=:transparent,dpi=300)
savefig("undir-graph-14.pdf")
##
Matrix(A)
##
using MatrixNetworks
f,lam = fiedler_vector(A)
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=1, linecolor=3, linealpha=1.0, linewidth=1.0,
  axis_buffer=0.02, background=:transparent,dpi=300)
scatter!(xy[1,:], xy[2,:], marker_z=f, markersize=8)

## Seeded PageRank vectors
# I tried Fiedler vectors on this graph, but they just pick off little
# pieces like usual :(
names = readlines("../2-unit-1-demos/artistsim.names")
data = readdlm("../2-unit-1-demos/artistsim.smat")
xy = readdlm("artistsim.xy")
##
A = sparse(Int.(data[2:end,1]).+1,
           Int.(data[2:end,2]).+1,
           Int.(data[2:end,3]),
           Int(data[1,1]),Int(data[1,1]))
Asym = max.(A,A') # make the graph undirected
##
Acc = largest_component(Asym)[1]
##
#f,lam = fiedler_vector(Acc)
##
scatter(xy[:,1],xy[:,2], marker_z=(f),colorbar=true,alpha=0.5,
  markerstrokecolor=nothing,markerstrokewidth=0)
##
ei,ej = findnz(triu(Asym,1))
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=2, linecolor=1, linealpha=0.01, linewidth=0.5,
  markeralpha=0.2,
  marker_z = f,
  axis_buffer=0.02, background=nothing)
##
f = seeded_pagerank(Asym, 0.85, 17998)
##
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=2, linecolor=1, linealpha=0.01, linewidth=0.5,
  markeralpha=0.2,
  marker_z = log10.(f.+eps(1.0)),
  axis_buffer=0.02, background=nothing)
##
#f2 = seeded_pagerank(Acc, 0.5, 17998)
f2 = seeded_pagerank(Acc, 0.85, 17998)
p = sortperm(f2) # this gets things to draw in the right z-order
scatter(xy[p,1],xy[p,2], marker_z=log10.(f2[p]),colorbar=false,alpha=0.5,
  markerstrokecolor=nothing,markerstrokewidth=0,label="",framestyle=:none,background=nothing)
##
f2 = seeded_pagerank(Acc, 0.85, 200)
p = sortperm(f2) # this gets things to draw in the right z-order
scatter(xy[p,1],xy[p,2], marker_z=-abs.(log10.(f2[p])).^0.5,colorbar=false,alpha=0.5,
  color=:magma,
  markerstrokecolor=nothing,markerstrokewidth=0,label="",framestyle=:none,background=nothing)
##
savefig("artistsim-spr-200.pdf")
