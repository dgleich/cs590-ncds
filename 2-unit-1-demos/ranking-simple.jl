## Simple PageRank
# This treats everything as a dense matrix :(
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
d = sum(A,dims=2)
##
using Printf
for i=1:10
  for j=1:10
    if i==j
      @printf("1 & ")
    elseif A[j,i] != 0
      @printf("-\\alpha/%i & ", d[j])
    else
      @printf("0 & ")
    end
  end
  println("\\\\")
end
## Build the I - alpha D^+ A'
alpha = 0.85
M = zeros(size(A)...)
for i=1:10
  for j=1:10
    if i==j
      M[i,j] = 1
    elseif A[j,i] != 0
      M[i,j] = -alpha*A[j,i]/d[j]
    else
      M[i,j] = 0
    end
  end
end
M[:,end] .= -alpha/10
M[end,end] += 1
M[:,1]
##
b = ones(size(A,1))/size(A,1)*(1-alpha)
x = M\b
