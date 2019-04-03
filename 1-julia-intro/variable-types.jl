##
x = 5
##
typeof(x)


##
"""
`add5`
======

This adds the value of 5 to the input variable.

Returns: the same type as the input variable + the integer 5.

Example
-------
        add5(5.0)
        typeof(add5(5.0)) # returns Float64
        add5(5)
        typeof(add5(5)) # returns Int64
"""
function add5(x)
    return x+5
end
@show typeof(add5(5.0))
@show add5(5.0)

##
@show typeof(add5(5))
@show add5(5)
##

## Types of Matrices and Vectors
# a vector in Julia looks like:

x = [5,6,7]
@show typeof(x)

##
x = [5.0,6,7]
@show typeof(x)

##
A = [5 6 7]
##
A = [5.0 6 7; 1 2 3; 4 5 6]
##
B = A .+ 5

##
C = B' # this is the transpose
@show typeof(C)
##
D = copy(C)
##
E = D+B

##
