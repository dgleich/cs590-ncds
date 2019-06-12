## In this notebook, we'll look at least squares on biometric dataset
# with a stochastic gradient descent and least-squares angle.
##
using Plots
using ORCA
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
x = Xf[:,1]
A = [x ones(length(x))]
b = Xf[:,2]
ab = A\b # solve the least squares problem
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

## Show the same thing with a log10
quadratic_leastsq(A,b) = x-> log10(0.5*norm(A*x - b)^2)/size(A,1)

Random.seed!(0)
nsamp = 10
k = 25


anim = @animate for i=2:2:360
  plot(framestyle=:none,colorbar=false,size=(300,300),dpi=300)
  for j=1:k
    subset = randperm(size(A,1))[1:nsamp] # choose 25 of 200 samples.
    ezsurf!(-3:0.05:3,-50:0.25:250,
      quadratic_leastsq(A[subset,:],b[subset,:]))
  end
  if rem(i,20) == 0
    ORCA.restart_server()
  end
  plot!(colorbar=false,size=(900,900))
  plot!(camera=(i,30))
end
gif(anim, "leastsq-quadratic-samples-log-resample.gif")
