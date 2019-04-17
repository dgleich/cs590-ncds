##
using Plots
using LinearAlgebra
using CSV
using MultivariateStats
using DataFrames
theme(:dark)
##
df = CSV.read("wdbc.data",header=false)
## Filter to a matrix of only diagonstic information.
X = Float64.(Matrix(df[:,3:end]))'
X = df[:,3:end] |> Matrix |> (X -> Float64.(X)')


##
using Statistics
using LinearAlgebra
function mypca(X::AbstractMatrix, donormalize::Bool = false)
  means = vec(mean(X, dims=2)) # take the average of each coordinate
  C = X .- means # center each coordinate
  if donormalize
    for i=1:size(C,1)
      normalize!(@view C[i,:])
    end
  end
  U,S,V = svd(C)
end
U,S,V = mypca(X, true)
scatter(V[:,1], V[:,2], alpha=0.5, color=Int.(CategoricalVector(df[:,2]).refs),
    label="", colorbar=false, size=(400,400), xticks=[], yticks=[])
##
savefig("pca-breast-fig.pdf")
##
scatter(S, label="",size=(250,250))
##
savefig("pca-breast-fig-singvals.pdf")

## For fun, try TSNE too...
using TSne
using Random
Random.seed!(0)
rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())
Xr = rescale(X'; dims=1)
Y = tsne(Xr, 2, 50, 1000, 20.0)
scatter(Y[:,1], Y[:,2],color=Int.(CategoricalVector(df[:,2]).refs), label="")
