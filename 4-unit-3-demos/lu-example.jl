using LinearAlgebra
A = [0 1/2 1/4; 1 1 2; 2 1 1.5]
F = lu(A) # like "A^{-1}"
##
println("P = ")
display(F.P)
println("L = ")
display(F.L)
println("U = ")
display(F.U)
##
@show norm(F.P*A - F.L*F.U)
