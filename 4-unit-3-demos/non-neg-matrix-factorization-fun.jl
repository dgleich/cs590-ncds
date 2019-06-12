## MNIST data using Non-negative matrix Factorization
using MLDatasets
train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()

## Create the input for NMF
m = size(train_x,1)*size(train_x,2)
n = size(train_x,3)
X = Float64.(reshape(train_x, m, n))
A = copy(X') # input

##
#using ImageMagick
using NMF
using Images
## Make a rank 5 factorization
k = 5
W, H = NMF.nndsvd(A, k; variant= :ar)
# alginst = NMF.MultUpdate{Float64}(obj=:mse, maxiter=1000, verbose=false)
alginst = NMF.ALSPGrad{Float64}(maxiter=100)
r = NMF.solve!(alginst, A, W, H)
## show the images
imgs = Gray.(reshape(r.H',28,28,k))
p = plot([heatmap(imgs[:,:,i]) for i=1:k]...,framestyle=:none,yflip=true)
savefig("nmf-mnist-$k.pdf")

## Turn this into a method
function nmf(A,k)
  W, H = NMF.nndsvd(A, k; variant= :ar)
  alginst = NMF.ALSPGrad{Float64}(maxiter=100)
  r = NMF.solve!(alginst, A, W, H)
  imgs = Gray.(reshape(r.H',28,28,k))
  plot([heatmap(imgs[:,:,i]) for i=1:k]...,framestyle=:none,yflip=true), r
  savefig("nmf-mnist-$k.pdf")
end
nmf(A,8)

# alginst = NMF.MultUpdate{Float64}(obj=:mse, maxiter=1000, verbose=false)

##
nmf(A,15)

##
nmf(A,25)

##
nmf(A,50)


##
nmf(A,100)
