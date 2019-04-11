using LinearAlgebra

function count_darts(N::Int)
  num_inside = 0
  for i=1:N
    p = rand(2)
    num_inside += norm(p) <= 1
  end
  return num_inside
end

count_darts(10000)

## Now make this work in arbitrary dimensions
using LinearAlgebra
function count_darts(N::Int, k::Int)
  num_inside = 0
  for i=1:N
    p = rand(k)
    num_inside += norm(p) <= 1
  end
  return num_inside
end
count_darts(10000, 2) # check our estimate
##
for k=3:10
  n = count_darts(10000, k)
  println(k, " -> ", n)
end
##
