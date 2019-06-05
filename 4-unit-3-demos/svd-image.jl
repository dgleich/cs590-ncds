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

## setup interact
using Interact
ui = button()
settheme!(:nativehtml)
display(ui)

## Show the best rank-k approximations
mp = @manipulate for k in 1:25
    X = U[:,1:k]*Diagonal(S[1:k])*V[:,1:k]'
    Gray.(X)
end
