##
using Random
using Plots
using LinearAlgebra
theme(:dark)
##
Random.seed!(7)
X = randn(2,100)
A = randn(2,2)
Y = A*X
scatter(Y[1,:], Y[2,:], label="", size=(300,300),color=3)
xlabel!("x")
ylabel!("y")
##
savefig("pca-2d-fig.pdf")

##
using Interact
using Statistics
using Printf
settheme!(:nativehtml)
mp = @manipulate for θ in 0.0:2π/100:2π
    v = [cos(θ),sin(θ)]
    z = vec(v'*Y)
    p = plot(
      scatter(Y[1,:], Y[2,:], label="", size=(300,300),color=3, aspect_ratio=:equal),
      histogram(z,label="")
      )
    plot!(p[1],2*[0,v[1]],2*[0,v[2]],label="",linewidth=2)
    scatter!(p[1], v[1].*z, v[2].*z, color=2, label="",
      markerstrokewidth=0,alpha=0.3, markersize=4)
    xlims!(p[2],(-5,5))
    ylims!(p[2],(0,30))
    xlims!(p[1],(-4,4))
    ylims!(p[1],(-4.5,4.5))
    title!(p[1],@sprintf("Angle = %.2f", θ))
    title!(p[2],@sprintf("Variance = %.2f", var(z)))
end
##
θs = 0.0:π/1000:π
plot(collect(θs), map(x -> var(vec([cos(x),sin(x)]'*Y)), θs),
  label="", size=(500,250))
xlabel!("Angle")
ylabel!("Variance")
##
savefig("pca-2d-angle-variance.pdf")
## PCA is a way to get this angle automatically!
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
U,S,V = mypca(Y, false)
U[:,1]
##
θpca = atan(-U[2,1],-U[1,1])
##
plot(collect(θs), map(x -> var(vec([cos(x),sin(x)]'*Y)), θs),
label="", size=(500,250))
xlabel!("Angle")
ylabel!("Variance")
annotate!(θpca, var(vec([cos(θpca),sin(θpca)]'*Y)), text("*", 24, :red))
##
savefig("pca-2d-angle-variance-opt.pdf")
##
scatter(Y[1,:], Y[2,:], label="", size=(300,300),color=3)
plot!(2*[0,-U[1,1]],2*[0,-U[2,1]],label="",linewidth=2, color=5)
##
savefig("pca-2d-fig-PCA.pdf")
##
S
## Save a set of points
pyplot()
theme(:default)
scatter(Y[1,:], Y[2,:], label="", size=(300,300),color=3,
  framestyle=:none, background=:transparent)
savefig("pca-2d-data.pdf")
