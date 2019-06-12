## MNIST data using Non-negative matrix Factorization
using MLDatasets
train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()

## Create the input for NMF
m = size(train_x,1)*size(train_x,2)
n = size(train_x,3)
X = Float64.(reshape(train_x, m, n))
A = copy(X') # input

## Show the average image
using Images
heatmap(Gray.(reshape(sum(A;dims=1)/size(A,1),28,28)'),
  framestyle=:none,yflip=true,colorbar=true)

## Show a random set of images
imgs = Gray.(reshape(A[1:25,:]',28,28,25))
p = plot([heatmap(imgs[:,:,i]') for i=1:25]...,framestyle=:none,yflip=true)
## Turn this into a function
myheatmap(X) = heatmap(Gray.(X'./maximum(X)),framestyle=:none,yflip=true)
plotimgs(X) = plot([myheatmap(X[:,:,i]) for i=1:size(X,3)]...)
plotimgs(reshape(A[1:25,:]',28,28,25))
## Use NMF to find structure
#using ImageMagick
using NMF
## Make a rank 5 factorization
k = 5
W, H = NMF.nndsvd(A, k; variant= :ar)
# alginst = NMF.MultUpdate{Float64}(obj=:mse, maxiter=1000, verbose=false)
alginst = NMF.ALSPGrad{Float64}(maxiter=100)
r = NMF.solve!(alginst, A, W, H)
## show the images
plotimgs(reshape(r.H',28,28,k))
## Turn this into a method
function nmf(A,k)
  W, H = NMF.nndsvd(A, k; variant= :ar)
  alginst = NMF.ALSPGrad{Float64}(maxiter=100)
  r = NMF.solve!(alginst, A, W, H)
  p = plotimgs(reshape(r.H',28,28,k))
  savefig("nmf-mnist-$k.pdf")
  return p, r
end
p5, r5 = nmf(A,5)
p5

## Run a set of these
p8, r8 = nmf(A,8)
p10, r10 = nmf(A,10)
p15, r15 = nmf(A,15)
p25, r25 = nmf(A,25)
p35, r35 = nmf(A,35)
p50, r50 = nmf(A,50)
p100, r100 = nmf(A,100)

## Use these to re-assemble digits
ndig = 60
Xs = reshape((r10.W*r10.H)[1:ndig,:]',28,28,ndig)
As = reshape(A[1:ndig,:]',28,28,ndig)
anim = @animate for i=1:60
  plot(myheatmap(Xs[:,:,i]),myheatmap(As[:,:,i]))
end
gif(anim, "nmf-mnist-10-approx.gif")

##
ndig = 60
Xs = reshape((r50.W*r50.H)[1:ndig,:]',28,28,ndig)
As = reshape(A[1:ndig,:]',28,28,ndig)
anim = @animate for i=1:60
  plot(myheatmap(Xs[:,:,i]),myheatmap(As[:,:,i]))
end
gif(anim, "nmf-mnist-50-approx.gif")
