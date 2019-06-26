## Make an animation of a random walk

using Plots
using GraphRecipes
using SparseArrays
using DelimitedFiles
## Load the graph
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
## A simple simulation
using Random
Random.seed!(1)
X = 1 # start on node 1
A = sparse(ei,ej,1,14,14) # make the sparse matrix
A = A+A' # make it symmetric (we only store half)
for i=1:10
  global X
  Xn = rand(findnz(A[:,X])[1])
  println("Walk moves from $X to $Xn")
  X = Xn
end
## A simple simulation of where it spends it's time.
Random.seed!(1)
function rw_time(A, start, nsteps)
  x = zeros(size(A,1))
  X = start
  x[X] += 1
  for i=1:(nsteps-1) # to account for start
    X = rand(findnz(A[:,X])[1])
    x[X] += 1
  end
  x ./= nsteps
end
x1000 = rw_time(A,1,1000)
## A visual simulation of the random walk
gr(size=(300,300))
using Random
Random.seed!(1)
function rw_on_graph(ei, ej, xy, start, nstep, nframes)
  eirw = [ei; ej]
  ejrw = [ej; ei]

  X = start
  # random walk step
  p = graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
    markercolor=:white, markerstrokecolor=:black,
    markersize=4, linecolor=3, linealpha=1.0, linewidth=1.0,
    axis_buffer=0.02, background=:black,dpi=300)
  #p1 = scatter!([xy[1,X]],[xy[2,X]],markersize=4, color=1)
  p2 = scatter!([xy[1,X]],[xy[2,X]],markersize=8, color=:orange)

  Xn = X
  anim = @animate for i=0:(nframes*nstep)
    stepi = mod(i,nframes) # this is the frame number in the step
    if stepi == 0
      X = Xn
      Xn = rand(ejrw[eirw .== X])
    end
    # interpolate between the two positions
    pos = min(stepi/(nframes-2),1)
    p[3] = [(1-pos)*xy[1,X] + pos*xy[1,Xn]],[(1-pos)*xy[2,X] + pos*xy[2,Xn]]
    ##p[4] = [xy[1,Xn]],[xy[2,Xn]]
    title!("$i $stepi", textcolor=:white)
  end
  return anim
end
anim = rw_on_graph(ei,ej,xy,1,100,20)
gif(anim, "rw-on-undir-14.gif", fps=40)

## Next we want to show the frequency that we visit places.
gr(size=(400,300),dpi=300)
using Random
Random.seed!(1)
function rw_on_graph_with_dist(ei, ej, xy, start, nstep)
  eirw = [ei; ej]
  ejrw = [ej; ei]
  N = maximum(eirw)
  X = start
  # random walk step
  ## Simulate the random walk and show the distribution

  l = @layout([a{0.75w} b])
  x = ones(N)
  ps = plot(graphplot(ei, ej, x =xy[1,:], y=xy[2,:],
    markercolor=:white, markerstrokecolor=:black,
    markersize=4, linecolor=3, linealpha=1.0, linewidth=1.0,
    axis_buffer=0.02, background=:black,dpi=300),
    scatter(x/N, 1:N, label="", framestyle=:none,background=:black), layout=l)
  p1 = ps[1]
  p2 = ps[2]
  xlims!(ps[2], (-0.1, 1.1))
  p1a = scatter!(p1, [xy[1,X]],[xy[2,X]],markersize=4, color=1)
  p1b = scatter!(p1, [xy[1,X]],[xy[2,X]],markersize=8, color=:orange)
  Xn = X # initialize
  nframes = 3
  anim = @animate for i=0:nframes*nstep
    stepi = mod(i,3)
    if stepi == 0
      X = Xn
      Xn = rand(ejrw[eirw .== X])
    end
    x[Xn] += 1/nframes

    pos = stepi/nframes

    ps[4] = [xy[1,X]],[xy[2,X]]
    ps[5] = [pos*xy[1,Xn] + (1-pos)*xy[1,X]],[pos*xy[2,Xn]+ (1-pos)*xy[2,X]]
    ps[3] = x/(N+i/nframes),collect(1:N)
  end
  return anim
end

anim = rw_on_graph_with_dist(ei, ej, xy, 1, 500)
gif(anim, "rw-on-undir-with-dist.gif", fps=25)
