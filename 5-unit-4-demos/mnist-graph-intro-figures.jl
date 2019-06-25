## Load the MNIST Graph and draw it
##
using DelimitedFiles
using SparseArrays
using LinearAlgebra
ei,ej = copy.(eachcol(Int.(readdlm("mnist-train-4.edges"))))
xy = readdlm("mnist-train-4.xy")
n = maximum(ei)
A = sparse(ei,ej,1,n,n)
@assert issymmetric(A)

##
using MatrixNetworks
f,lam = fiedler_vector(A)
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=400,
  markersize=2, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.3,
  #colorbar=true,
  marker_z=f,
  axis_buffer=0.02, background=nothing)
##
savefig("mnist-train-4-fiedler.png")

##
cut = spectral_cut(A)
x = zeros(n)
x[cut.set] .= 1
graphplot(ei, ej, x =xy[:,1], y=xy[:,2],
  markercolor=:black, markerstrokecolor=:white,
  size=(1200,1200),dpi=400,
  markersize=2, linecolor=1, linealpha=0.2, linewidth=0.5,
  markeralpha=0.3,
  #colorbar=true,
  marker_z=x,
  axis_buffer=0.02, background=nothing)
for i=1:100
  annotate!(xy[i,1],xy[i,2],"$(train_y[i])",color=:white)
end
##
savefig("mnist-train-4-spectral-cut.png")
