## Incidence matrix
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
n = max(maximum(ei),maximum(ej))
A = sparse(ei,ej,1,n,n)
A = A+A'
##
m = length(ei) # number of edges
B = sparse(1:m,ei,1,m,n) - sparse(1:m,ej,1,m,n)
## Output this for Latex
using Printf
@printf("\\left[ \\begin{array}{*{14}{c}} \n ")
for i=1:m
  for j=1:n
    if B[i,j] == 0
      @printf("\\textcolor{gray}{0} & ")
    else
      @printf("\\mathbf{%i} & ", B[i,j])
    end
  end
  println("\\\\")
end
@printf("\\end{array} \\right] \n ")
