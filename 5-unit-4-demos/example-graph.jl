## This script makes the example graphs we'll use in subsequent studies

##
using Plots
using GraphRecipes
using NearestNeighbors
using Random
using SparseArrays
using LinearAlgebra
##
""" This function is weird because it only gets half of the knn, but it makes
a useful picture, so I'm keeping this bug. DO NOT USE FOR ANTYHING REAL. """
function gnk(n,k)
  xy = rand(2,n)
  T = KDTree(xy)
  idxs = knn(T, xy, k)[1]
  # form the edges for sparse
  ei = Int[]
  ej = Int[]
  for i=1:n
    for j=idxs[i]
      if i > j
        push!(ei,i)
        push!(ej,j)
      end
    end
  end
  return xy, ei, ej
end
#Random.seed!(3)
#xy, ei, ej = gnk(25,5)
Random.seed!(1)
xy, ei, ej = gnk(15,4)
gr(size=(300,300))
graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:black, markerstrokecolor=:white,
  markersize=4, linecolor=1, linealpha=0.8, linewidth=0.7,
  axis_buffer=0.02, background=nothing)

##
for i=1:size(xy,2)
  annotate!(xy[1,i],xy[2,i],"$i")
end
gui()
## We are going to remove edge 14,15 for simplicity
n = size(xy,2)
A = sparse(ei,ej,1,n,n)
A = A + A' # make it symmetric
A[14,15] = 0
A[15,14] = 0
A[6,7] = 1
A[7,6] = 1
dropzeros!(A)
## Remove vertex 4 as it's disconnected
verts = collect(1:15)
deleteat!(verts,4)
A = A[verts,verts]
xy = xy[:,verts]
##
ei,ej = findnz(triu(A))[1:2]
graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:black, markerstrokecolor=:white,
  markersize=4, linecolor=1, linealpha=0.8, linewidth=0.7,
  axis_buffer=0.02, background=nothing)
##
using DelimitedFiles
writedlm("undir-graph-14.xy", xy')
writedlm("undir-graph-14.edges", [ei ej])
## Save a few figures
pyplot(size=(300,300))
p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:white, markerstrokecolor=:black,
  markersize=8, linecolor=3, linealpha=1.0, linewidth=1.0,
  axis_buffer=0.02, background=:transparent,dpi=300)
savefig("undir-graph-14.pdf")
## Other, unused examples

#Random.seed!(3)
#xy, ei, ej = gnk(25,5)

##
function gnr(n,r)
  xy = rand(2,n)
  T = BallTree(xy)
  idxs = inrange(T, xy, r)
  # form the edges for sparse
  ei = Int[]
  ej = Int[]
  for i=1:n
    for j=idxs[i]
      if i > j
        push!(ei,i)
        push!(ej,j)
      end
    end
  end
  return xy, ei, ej
end


#Random.seed!(2)
#xy, ei, ej = gnr(25,0.23)

Random.seed!(3)
xy, ei, ej = gnr(25,0.25)

function spectral_order(ei,ej,xy)
  n = maximum(ei)
  A = sparse(ei,ej,1,n,n)
  A = A + A'
  L = Diagonal(vec(sum(A,dims=2))) - A
  lams,Vs = eigs(L,nev=2, which=:SR)
  v = Vs[:,2]
  p = sortperm(v)
  @show lams
  ip = Vector{Int}(undef,n)
  ip[p] = 1:n
  return p,ip
end
p,ip = spectral_order(ei, ej, xy)

gr(size=(300,300))
graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
  markercolor=:black, markerstrokecolor=:white,
  markersize=4, linecolor=1, linealpha=0.8, linewidth=0.7,
  axis_buffer=0.02, background=nothing)
for i=1:size(xy,2)
  annotate!(xy[1,i],xy[2,i],"$i")
end
gui()

##
srand(1)
pyplot(size=(400,300))
function rw_on_graph(ei, ej, xy, start, nstep)
  eirw = [ei; ej]
  ejrw = [ej; ei]
  N = maximum(ei)
  X = start
  # random walk step
  ## Simulate the random walk and show the distribution

  l = @layout([a{0.75w} b])
  x = ones(N)
  ps = plot(graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
    markercolor=:black, markerstrokecolor=:white,
    markersize=4, linecolor=2, linealpha=0.8, linewidth=0.7,
    axis_buffer=0.02, background=:white, framestyle=:none),
    scatter(x/N, 1:50, label="", framestyle=:none), layout=l)
  p1 = ps[1]
  p2 = ps[2]
  p1a = scatter!(p1, [xy[1,X]],[xy[2,X]],markersize=4, color=1)
  p1b = scatter!(p1, [xy[1,X]],[xy[2,X]],markersize=8, color=:orange)
  anim = @animate for i=1:nstep
    Xn = rand(ejrw[eirw .== X])
    x[Xn] += 1
    ps[4] = [xy[1,X]],[xy[2,X]]
    ps[5] = [xy[1,Xn]],[xy[2,Xn]]
    ps[3] = x/(N+i),collect(1:50)
    X = Xn
  end
  return anim
end
