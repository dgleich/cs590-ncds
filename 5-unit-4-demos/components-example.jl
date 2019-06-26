## Example of connected components in an algorithm
using SparseArrays
using LinearAlgebra
A = [0 1 1 1 1 0 1 0 0 0
     1 0 0 0 0 0 0 0 0 0
     0 0 0 0 1 1 1 0 0 0
     1 1 0 0 1 1 0 1 0 0
     1 1 1 1 0 0 0 0 1 0
     0 0 1 0 0 0 1 0 1 1
     0 0 0 0 0 1 0 0 0 1
     0 0 0 0 0 0 0 0 1 0
     0 0 0 0 0 0 0 1 0 0
     0 0 0 0 0 0 0 0 0 0]
n = size(A,1)
x = ones(n)
for i=1:20
  global x
  x = A*x
  x = x/norm(x)
end
x
##
x = zeros(n)
x[9] = 1
for i=1:20
  global x
  x = A'*x
  x = x/norm(x)
end
x
