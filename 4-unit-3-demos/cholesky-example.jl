using LinearAlgebra
A = [5 -2 -2; -2 4 -1; -2 -1 3]
L = cholesky(A)
##
println("A = ")
display(A)
println("L = ")
display(L.L)
##
@show norm(A - L.L*L.L')
