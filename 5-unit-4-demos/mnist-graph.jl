## Make MNIST Graph
using MLDatasets
train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()
##
m = size(train_x,1)*size(train_x,2)
n = size(train_x,3)
X = Float64.(reshape(train_x, m, n))
## Build the 5-NN graph
using NearestNeighbors
@time T = KDTree(X)
##
k = 4
idxs = knn(T, X, k+1)[1]
##
ei = Int[]
ej = Int[]
for i=1:n
  for j=idxs[i]
    if i != j
      push!(ei,i)
      push!(ej,j)
    end
  end
end
##
using SparseArrays
A = sparse(ei,ej,1,n,n)
A = max.(A,A')
##
using DelimitedFiles
writedlm("mnist-train-4.edges", hcat(findnz(A)[1:2]...))
