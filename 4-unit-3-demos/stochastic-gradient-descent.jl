## In this notebook, we'll look at stochastic gradient descent on a least squares
## system

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
using LinearAlgebra
""" Run stochastic gradient descent to solve a least squares problem. """
function stochastic_gradient_descent_leastsquares(A,b;
            step=0.0001, maxiter=10*size(A,1),tol=1e-6)
  x = zeros(size(A,2)) # start at 0
  for i=1:1000000
    si = rand(1:size(A,1))
    ai = A[si,:]
    bi = b[si]
    g = 2.0.*(ai'*x - bi)*ai
    x -= step*g
  end
  return x
end
stochastic_gradient_descent_leastsquares(A,b)
## Animate the algorithm
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)/size(A,1)
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
ezsurf(-3:0.1:3,-50:0.5:250,
  quadratic_leastsq(A,b))
plot!(colorbar=false,size=(450,450),dpi=300)
plot!(camera=(170,30))
x = zeros(size(A,2)) # initialize
p = plot3d!(1, label="", marker = 2)
step = 0.0001
anim = Animation()
for i=0:1000000
  global x
  g = (A'*A*x - A'*b)/size(A,1)
  x -= step*g
  if ((i <= 10) || ((i <= 30) & (rem(i,2) == 0)) || ((i <= 100) && rem(i,5) == 0) ||
      ((i <= 1000) && rem(i,10) == 0) || ((i <=10000) && rem(i,100)==0) ||
      ((i <= 100000) && rem(i,1000)==0) || rem(i,10000)==0)
    push!(p[1][2], x[1], x[2], quadratic_leastsq(A,b)(x))
    title!(@sprintf("Iteration %3i  Residual = %.3e", i, norm(g)))
    @printf("Iteration %3i  Residual = %.3e\n", i, norm(g))
    frame(anim)
  end
end
gif(anim, "stochatic-grad-descent-1.gif",fps=30)

##
## Animate the stochastic algorithm
using Random
Random.seed!(0)
quadratic_leastsq(A,b) = x-> (0.5*norm(A*x - b)^2)/size(A,1)
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
ezsurf(-3:0.1:3,-50:0.5:250,
  quadratic_leastsq(A,b))
plot!(colorbar=false,size=(450,450),dpi=300)
plot!(camera=(170,30))
x = zeros(size(A,2)) # initialize
xgd = zeros(size(A,2)) # initialize
p = plot3d!(1, label="", color=3)
p2 = plot3d!(1, label="", color=2)
step = 0.0001
anim = Animation()
for i=0:1000000
  global x, xgd
  si = rand(1:size(A,1))
  ai = A[si,:]
  bi = b[si]
  g = (ai'*x - bi)*ai
  x -= step*g

  xgd -= step*(A'*A*xgd - A'*b)/size(A,1)
  if ((i <= 10) || ((i <= 30) & (rem(i,2) == 0)) || ((i <= 100) && rem(i,5) == 0) ||
      ((i <= 1000) && rem(i,10) == 0) || ((i <=10000) && rem(i,100)==0) ||
      ((i <= 100000) && rem(i,1000)==0) || rem(i,10000)==0)
    push!(p[1][2], x[1], x[2], quadratic_leastsq(A,b)(x))
    push!(p[1][3], xgd[1], xgd[2], quadratic_leastsq(A,b)(xgd))
    title!(@sprintf("Iteration %3i  Residual = %.3e", i, norm(g)))
    @printf("Iteration %3i  Residual = %.3e\n", i, norm(g))
    frame(anim)
  end
end
gif(anim, "stochatic-grad-descent-2.gif",fps=30)


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
