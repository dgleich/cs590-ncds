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

## Make a figure for the label 1
# find the first 10 nodes labeled 1
using MLDatasets
train_x, train_y = MNIST.traindata()
nlabels = 10
S = findall(train_y .== 1)[1:nlabels]
## Show the labeled nodes.
scatter(xy[:,1],xy[:,2])
scatter!(xy[S,1], xy[S,2], markersize=25)
##
# Form the incidence matrix for the least squares problem
function incidence_matrix(A)
  ei,ej = findnz(triu(A,1))
  n = size(A,1)
  m = length(ei)
  return sparse(1:m,ei,1,m,n) - sparse(1:m,ej,1,m,n)
end
B = incidence_matrix(A)
IS = sparse(0.1*I, n,n)
IS[S,S] .*= 1/maximum(IS)
labels = zeros(n)
labels[S] .= 1.0
## solve the least squares problems
#x = [B; IS] \ [zeros(size(B,1)); 1]
AtA = [B; IS]'* [B; IS]
Atb = [B; IS]'* [zeros(size(B,1)); labels]
##
x = AtA\Atb
##
scatter(xy[:,1],xy[:,2], marker_z = log10.(x), markerstrokewidth=0)

## Show the labeled nodes.
scatter(xy[:,1],xy[:,2],background=nothing,framestyle=:none,markersize=2,
  size=(1200,1200),markerstrokewidth=0, alpha=0.5,dpi=300)
scatter!(xy[S,1], xy[S,2], markersize=12)
for i in S
  annotate!(xy[i,1],xy[i,2], "$(train_y[i])")
end
plot!(legend=false)
savefig("mnist-train-4-labels.png")
##
scatter(xy[:,1],xy[:,2],background=nothing,framestyle=:none,markersize=2,
  size=(1200,1200),markerstrokewidth=0, marker_z = log10.(x),
  colorbar=false, alpha=0.5,dpi=300,label="")
savefig("mnist-train-4-soln.png")
