## We will start with vectors
v = [1; 2; 3; 4]
##
v = [1 2 3 4]
##
v = [1,2,3,4]
## If we want floats
v = [1.0,2,3,4]
## If you want to convert to Float64
w = map(Float64, [1,2,3,4]) # this will build an array, then convert to Float64
##
v[1]
##
v[3]
##
v[end]
##
v[end-1] # this is one before 3nd...
## This gives an error
v[0]
##
w = [1 2 3 4]
v = [1,2,3,4]
w+v
## Aside: This is an Atom thing
## Command enter shows the result of the current line
1+1
## If we run alt-enter then it runs the entire block
a = 5
a+1
##
v+w' # this should work
##
vec(v+w') # this gives a 1d vector
## This is as expected
v.+w'
## This is interesting ...
A = v.+w
## This gives a 4x4 array, not a 1x4 or 4x1 array of element-wise products.
A[3,4] == v[3] + w[4] # w becomes columns, v gets mapped to rows.
##
function vecsum(x::Vector)
    s = zero(eltype(x)) # this is a variable that is zero in the same
    # element type of as x.
    s = 0.0 # this only works for floats, not BigFloats, etc...
    for i=1:length(x)
        s += x[i]
    end
    return s
end
vecsum(v)
##
vecsum(vec(w))
## A word of warning about vec.
w[3]
##

z = vec(w)
z[3]
##
z[3] = 10
##
w[3]
## If you want to de-couple the memory ... just make a copy!
z = copy(vec(w))
z[3] = 50
w[3]

## Now on to Matrices.
A = [1 2 3; 4 5 6; 7 8 0]
##
b = [0; 1; 2] # this is a 3x1 vector, but really a 1d array

## We can solve linear systems of equations!
x = A\b # this computes x such that A*x = b
## It's always good to check solutions
A*x - b
## Other operations with matrices
using LinearAlgebra # adds lots of linear algebra routines to the Julia Session.
##
rank(A)
##
eigen(A)
##
##
svd(A)
##
qr(A)
##
F = qr(A)
F.Q # this is the matrix you get by doing Gram-Schmit

##
Q = F.Q
Q'*Q
##
Q'*Q - I
##
norm(Q'*Q - I) # this computes the Frobenius norm

##
F = lu(A) # this computes an LU factorization
##
F.L
##
F.U

##
# You can use F to solve systems with A
F\b - A\b
## A comment on Norms (this is for Matlab people)
norm(A) # Julia uses the element-wise matrix norms by default.
# you get this in Matlab with "norm(A,'fro')"
## This is another way to compute the norm.
sqrt(sum(A.^2))
## Matlab's default matrix norm is what Julia calls "opnorm"
# These are operator norms. A slightly different concept.
opnorm(A) #

## Let's chat about Comments!
# Comments start with a "#"
#= You can do multiline Comments
these keep going
until they end =#
1+1

##
s = """ These are not comments,
these are strings """
typeof(s)
## Let's chat about printing!
print(x)
##
println(x)
println("Hi")
##
using Printf
##
@printf("%.18e", x[1])
##
println(x[1])
## Ranges
z = 1:5
## This creates a range! It doesn't actually build a vector, but it acts like it does.
for i=z # this means i will range from 1 to 5
    println(i)
end

## Ranges have types
z = 1.0:5 # this is going to be a FLoat64 Ranges
for i=z # this means i will range from 1 to 5
    println(i)
end
##
for i=1.0:5
    println(i)
end
##
x
##
w = x .+ (1:3) # this will add elements to x

##
r = 1:3
x.+r

##
r = 3:-1:1
r[1]

##
r[end]
##
r
##
