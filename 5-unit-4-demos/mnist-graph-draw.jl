## Load the MNIST Graph and draw it

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
