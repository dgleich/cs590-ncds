## Figures for the Quadratic Equation slides
using Plots
using LaTeXStrings
pyplot() # nicer output
theme(:dark)

##
quadratic1(a,b,c) = x-> a*x^2 + b*x + c
plot(-10:0.01:5, quadratic1(0.5, 3, -2.0),
  linewidth=2,
  legend=false, framestyle = :origin,
  xlabel=L"$x$", ylabel=L"$f(x)$",
  title=L"f(x) = $0.5x^2 + 3x -2$",
  size=(350,350))e
savefig("quadratic1.pdf")

##
ezcontour(x, y, f) = begin
    X = repeat(x', length(y), 1)
    Y = repeat(y, 1, length(x))
    # Evaluate each f(x, y)
    Z = map((x,y) -> f([x,y]), X, Y)
    plot(x, y, Z, st=:surface)
end
quadratic2(A,b) = x -> x'*A*x + x'*b
ezcontour(-3:0.1:3,-3:0.1:3,
  quadratic2([1 0;0 1],[0,0]))
plot!(colorbar=false,size=(500,450))
##
anim = @animate for i=1:180
  plot!(camera=(i,30))
end
gif(anim, "quadratic2a.gif")
##
ezcontour(-4:0.1:4,-4:0.1:4,
  quadratic2([1 0.5;0.5 1],[-1,-1.5]))
plot!(colorbar=false)
##
anim = @animate for i=1:180
  plot!(camera=(i,30))
end
gif(anim, "quadratic2b.gif")
##
Q = [1 0.5; 0.5 1]
s = [-1,-1.5]
x = -Q\(s/2)
@show x
##
using LinearAlgebra
Q = [1 0.5; 0.5 1]
s = [-1,-1.5]
lam,V = eigen(Q)
p1 = ezcontour(-4:0.1:4,-4:0.1:4,
  quadratic2(Q,s))
title!(p1, L"$f(\mathbf{x})$")
p2 = ezcontour(-4:0.1:4,-4:0.1:4,
  quadratic2(Diagonal(lam),V'*s))
title!(p2, L"$g(\mathbf{y})$")
plot(p1,p2,layout=(2,1), colorbar=false)

##
plot(p1,p2,layout=(2,1), colorbar=false,size=(300,650))
savefig("quadratic2b-diag.pdf")

##
using LinearAlgebra
Q = [1 2; 2 1]
s = [-1,-1.5]
lam,V = eigen(Q)
p1 = ezcontour(-4:0.1:4,-4:0.1:4,
  quadratic2(Q,s))
title!(p1, L"$f(\mathbf{x})$")
p2 = ezcontour(-4:0.1:4,-4:0.1:4,
  quadratic2(Diagonal(lam),V'*s))
title!(p2, L"$g(\mathbf{y})$")
plot(p1,p2,layout=(2,1), colorbar=false)

##
