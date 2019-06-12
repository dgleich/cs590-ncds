## In this notebook, we'll look at least squares on biometric data

##
using Plots
pyplot()
theme(:dark)
##
# https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv
using CSV
df = CSV.read(download("https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv"))
X = Float64.([df[:weight] df[:height]])
# Filter the data
goodpts = X[:,1] .<= 115
Xf = X[goodpts,:]
##
scatter(Xf[:,1],Xf[:,2],label="",xlabel="weight (kg)", ylabel="height (cm)")
##
x = Xf[:,1]
A = [x ones(length(x))]
b = Xf[:,2]
ab = A\b # solve the least squares problem

##
using Printf
scatter(Xf[:,1],Xf[:,2],color=2,size=(300,300), label="")
plot!(x, x*ab[1] .+ ab[2], label="",color=5)
title!(@sprintf("height ≈ %.2f weight + %.2f    ",ab[1],ab[2]))
xlabel!("Weight (kg)")
ylabel!("Height (cm)")
savefig("weight-height-fit.pdf")
## Show the

## Show the quadratic surface
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
ezsurf(-3:0.1:3,-50:0.5:250,
  quadratic_leastsq(A,b))
##
plot!(colorbar=false,size=(300,300),dpi=300)
anim = @animate for i=1:360
  plot!(camera=(i,30))
end
gif(anim, "leastsq-quadratic.gif")

##
## Show the quadratic surface with alpha-blending
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot()
    plot!(x, y, Z, st=:surface)
end
ezsurf(-3:0.1:3,-50:0.5:250,
  quadratic_leastsq(A,b))

##
## Show k random samples of the quadratic surface
plotlyjs()
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)/size(A,1)
ezsurf!(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot!(x, y, Z, st=:surface, alpha=0.1)
end
orig = ezsurf(-3:0.25:3,-50:1:250,
  quadratic_leastsq(A,b))
nsamp = 25
k = 25
for i=1:k
  subset = randperm(size(A,1))[1:25] # choose 25 of 200 samples.
  ezsurf!(-3:0.1:3,-50:0.5:250,
    quadratic_leastsq(A[subset,:],b[subset,:]))
end
plot!() # get the plot to show
## Show k random samples of the quadratic surface
using Random
using LinearAlgebra
plotlyjs()
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)/size(A,1)
ezsurf!(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot!(x, y, Z, st=:surface, alpha=0.4)
end
plot(framestyle=:none,colorbar=false,size=(300,300),dpi=300)
nsamp = 10
k = 25
for i=1:k
  subset = randperm(size(A,1))[1:nsamp] # choose 25 of 200 samples.
  ezsurf!(-3:0.25:3,-50:2:250,
    quadratic_leastsq(A[subset,:],b[subset,:]))
end
plot!() # get the plot to show
##
#plot!(colorbar=false,size=(300,300),dpi=300)
plot!(colorbar=false,size=(900,900))
anim = @animate for i=2:2:360
  plot!(camera=(i,30))
end
gif(anim, "leastsq-quadratic-samples.gif")


## Show the same thing with a log10
using Random
using LinearAlgebra
plotlyjs()
quadratic_leastsq(A,b) = x-> log10(0.5*norm(A*x - b)^2)/size(A,1)
plot(framestyle=:none,colorbar=false,size=(300,300),dpi=300)
nsamp = 10
k = 25
for i=1:k
  subset = randperm(size(A,1))[1:nsamp] # choose 25 of 200 samples.
  ezsurf!(-3:0.1:3,-50:0.5:250,
    quadratic_leastsq(A[subset,:],b[subset,:]))
end
plot!() # get the plot to show
##
#plot!(colorbar=false,size=(300,300),dpi=300)
plot!(colorbar=false,size=(900,900))
anim = @animate for i=2:2:360
  plot!(camera=(i,30))
end
gif(anim, "leastsq-quadratic-samples-log.gif")
##
