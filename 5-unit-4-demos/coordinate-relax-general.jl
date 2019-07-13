## Coordinate relaxation  in general

""" Set x[j] s.t. we solve for row i in the
linear system Ax = b. This updates x
in place"""
function rowsolve!(A,b,x,i,j)
  rhs = b[i]
  for k=1:size(A,2)
    if k!=j
      rhs -= A[i,k]*x[k]
    end
  end
  x[j] = rhs/A[i,j]
end
""" Solve Ax=b with coordinate relaxation sweeps """
function solve_linsys_coord_relax(A,b,nsweeps)
  x = copy(b)
  for iter=1:nsweeps
    for j=1:size(A,1)
      rowsolve!(A,b,x,j,j)
    end
  end
  return x
end
A = [2 1; 1 2]
b = [1,1.5]
x = solve_linsys_coord_relax(A,b,5)
##
xtrue = A\b
norm(x-xtrue)
##
for nsteps = 1:10
  x = solve_linsys_coord_relax(A,b,nsteps)
  @show x
end
