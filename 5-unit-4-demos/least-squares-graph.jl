## Least squares
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
n = max(maximum(ei),maximum(ej))
A = sparse(ei,ej,1,n,n)
A = A+A'
D = Diagonal(vec(sum(A,dims=1)))
m = length(ei)
B = sparse(1:m,ei,1,m,n) - sparse(1:m,ej,1,m,n)
##
idmat = sparse(1.0I,n,n)
known = [4,9]
unknown = Set(1:n)
for v in known
  delete!(unknown, v)
end
unknown = collect(unknown)
IK = idmat[known,:]
IU = idmat[unknown,:]
labels = ones(length(known))
##
M = [B; IK; sqrt(0.1)*IU]
b = [zeros(m); labels; zeros(size(IU,1))]
##
x = M\b
##
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=14, linecolor=3, linealpha=1.0, linewidth=1.0,
  marker_z = x,
  axis_buffer=0.02, background=:transparent,dpi=300)
for i=1:size(A,1)
  annotate!(xy[1,i],xy[2,i],text("$i",9,:black))
end
plot!()
savefig("least-squares-undir.pdf")
