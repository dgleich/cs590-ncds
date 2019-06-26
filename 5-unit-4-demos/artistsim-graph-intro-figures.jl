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
Asym = max.(A,A') # make the graph undirected
n = size(Asym,1)
#Acc = largest_component(Asym)[1] # fix a small technical issue.
# only these nodes are not connected, so we can just remove them.
# I found this with,
# @show findall(largest_component(Asym)[2] .== false)
notconnected = [ 39896, 39897, 42145, 42146, 44404, 44405]
connected = map(x -> !in(x,Set(notconnected)), 1:n)
Acc = Asym[connected,connected]
n = size(Acc,1)
##
using GraphRecipes
using LinearAlgebra
using Plots
ei, ej = findnz(triu(A,1))
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=300,
  markersize=2, linecolor=1, linealpha=0.01, linewidth=0.5,
  markeralpha=0.2,
  axis_buffer=0.02, background=nothing)
#savefig("artistsim-plot.png")
##
using MatrixNetworks
pr = pagerank(A,0.85)
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
