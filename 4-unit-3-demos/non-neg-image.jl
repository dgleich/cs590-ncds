## SVD on an image
using LinearAlgebra
using Images
im = load("low-rank-image.png")
A = Float64.(Gray.(im))
A = 1.0.-A # invert the colors
## Show the image inverted
Gray.(A)
## Compute the SVD
U,S,V = svd(A)

##
k = 5
X = U[:,1:k]*Diagonal(S[1:k])*V[:,1:k]'
minimum(X)

##
minimum(A)
