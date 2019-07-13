## Coordinate descent

x,y = [1;1.5]
for i=1:10
  global x,y
  x = (1-y)/2
  y = (1.5-x)/2
  @show [x,y]
end

## Animate the algorithm
using Plots
using LaTeXStrings
using Printf
pyplot() # nicer output
theme(:dark)

A = [2 1; 1 2]
b = [1,1.5]
quadratic_ls(A,b) = x-> 0.5*x'*A*x - x'*b
ezsurf(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
ezsurf(-1.6:0.05:1.6,-1.6:0.05:1.6,
  quadratic_ls(A,b))
plot!(colorbar=false,size=(500,450))
plot!(camera=(170,60))
p = plot3d!(1, label="", marker = 2)
x,y = [1;1.5]
anim = @animate for i=1:20
  global x, y
  if i > 1
    if mod(i,2)==0
      x = (1-y)/2
    else
      y = (1.5-x)/2
    end
  end
  push!(p[1][2], x, y, quadratic_ls(A,b)([x,y]))
  title!(@sprintf("Iteration %3i", i))
end
gif(anim, "coordinate-descent-example.gif")
##
ezsurf(-1.5:0.05:1.5,-1.5:0.05:1.5,
  quadratic_ls(A,b))
x,y = [1;1.5]
plot3d!([x, (1-y)/2],[y, (1.5-x)/2],[quadratic_ls(A,b)([x,y]),
  quadratic_ls(A,b)([(1-y)/2,(1.5-x)/2])],marker=2)
plot!(camera=(170,30))
