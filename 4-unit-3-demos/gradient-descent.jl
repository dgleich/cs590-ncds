## Figures for the Quadratic Equation slides
using Plots
using LaTeXStrings
pyplot() # nicer output
theme(:dark)
# Need for 3d arrow
using PyPlot

##
A = [3 -1.5; -1.5 2]
b = [-1; 1]
quadratic_ls(A,b) = x-> 0.5*x'*A*x - x'*b
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
ezsurf(-3:0.1:3,-3:0.1:3,
  quadratic_ls(A,b))
plot!(colorbar=false,size=(500,450))
# Show the gradient at x = [1,1]
x = [-2,2]
g = A*x - b
g = 0.1.*g

plot!([x[1],x[1]+g[1]],[x[2],x[2]+g[2]],[quadratic_ls(A,b)(x), quadratic_ls(A,b)(x+g)],
  line=(arrow=:arrow),label="",color=2)
  plot!([x[1],x[1]-g[1]],[x[2],x[2]-g[2]],[quadratic_ls(A,b)(x), quadratic_ls(A,b)(x-g)],
    line=(arrow=:arrow),label="",color=3)
##
anim = @animate for i=1:360
  plot!(camera=(i,30))
end
gif(anim, "quadratic_ls1.gif")
##
using Printf
using LinearAlgebra
""" Run gradient descent to solve a linear system of equations.

This function assumes that A is symmetric positive definite. """
function gradient_descent_linsys(A,b;step=0.1, maxiter=10*size(A,1),tol=1e-6)
  x = zeros(size(A,1)) # start at 0
  for i=1:maxiter
    g = A*x - b
    @printf("iteration %4i  residual = %.3e\n", i, norm(g))
    if norm(g) <= tol
      break
    end
    x -= step*g
  end
  return x
end
gradient_descent_linsys(A,b)
## Animate the algorithm
ezsurf(-0.5:0.025:0.5,-0.5:0.025:0.5,
  quadratic_ls(A,b))
plot!(colorbar=false,size=(500,450))
plot!(camera=(170,30))
x = zeros(size(A,1)) # initialize
p = plot3d!(1, label="", marker = 2)
step = 0.1
anim = @animate for i=1:20
  global x
  g = A*x - b
  x -= step*g
  push!(p[1][2], x[1], x[2], quadratic_ls(A,b)(x))
  title!(@sprintf("Iteration %3i  Residual = %.3e", i, norm(g)))
end
gif(anim, "gradient_descent_ls1.gif")
