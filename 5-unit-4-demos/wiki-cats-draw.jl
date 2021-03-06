## Show the wikipedia categories graph
using SparseArrays
using LinearAlgebra
using DelimitedFiles
ei,ej = copy.(eachcol(Int.(readdlm("wiki-cats.edges"))))
xy = readdlm("wiki-cats.xy")
n = size(xy,1)
A = sparse(ei,ej,1,n,n) # we only store half the edges here
A = max.(A,A')
dropzeros!(A)
##
issymmetric(A)
##
ei,ej = findnz(triu(A,1))
using GraphRecipes
using Plots
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=400,
  markersize=2, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.3,
  axis_buffer=0.02, background=nothing)
