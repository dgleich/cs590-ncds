## Load the MNIST Graph and draw it
##
using DelimitedFiles
using SparseArrays
using LinearAlgebra
ei,ej = copy.(eachcol(Int.(readdlm("mnist-train-4.edges"))))
n = maximum(ei)
A = sparse(ei,ej,1,n,n)
@assert issymmetric(A)
##
using PyCall
using Conda
pyimport_conda("igraph","python-igraph","conda-forge")
##
using PyCall
igraph = pyimport("igraph")

function igraph_layout(A::SparseMatrixCSC{T}, layoutname::AbstractString="drl") where T
    ei,ej,ew = findnz(A)
    edgelist = [(ei[i]-1,ej[i]-1) for i = 1:length(ei)]
    nverts = size(A)
    G = igraph.Graph(nverts, edges=edgelist, directed=false)
    xy = G.layout(layoutname)
    xy = [Float64(xy[i][j]) for i in 1:length(xy),  j in 1:length(xy[1])]
end

xy = igraph_layout(A, "drl")
##
writedlm("mnist-train-4.xy", xy)
##
xy = readdlm("mnist-train-4.xy")
##
using GraphRecipes
using LinearAlgebra
using Plots
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=400,
  markersize=2, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.3,
  #colorbar=true,
  marker_z=train_y,
  axis_buffer=0.02, background=nothing)
for i=1:100
  annotate!(xy[i,1],xy[i,2],"$(train_y[i])",color=:white)
end
plot!()
##
savefig("mnist-train-4.png")
