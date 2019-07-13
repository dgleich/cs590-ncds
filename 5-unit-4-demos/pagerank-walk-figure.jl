## Make an animation of a random walk
using Plots
using GraphRecipes
using SparseArrays
using DelimitedFiles
using LinearAlgebra
## Load the graph
ei,ej = copy.(eachcol(Int.(readdlm("undir-graph-14.edges"))))
xy = readdlm("undir-graph-14.xy")'
## A simple simulation
using Random
Random.seed!(1)
X = 1 # start on node 1
A = sparse(ei,ej,1,14,14) # make the sparse matrix
A = A+A' # make it symmetric (we only store half)
α = 0.85
for i=1:10
  global X
  if rand() <= α && length(findnz(A[:,X])[1]) >= 0
    Xn = rand(findnz(A[:,X])[1]) # random neighbor
    println("PageRank Walk moves from $X to $Xn")
  else
    Xn = rand(1:size(A,1)) # random node
    println("PageRank Walk jumps from $X to $Xn")
  end
  X = Xn
end

##
ei,ej = copy.(eachcol(Int.(readdlm("wiki-simple.edges"))))
xy = readdlm("wiki-simple.xy")'
pages = readlines("wiki-simple.nodes")
## A visual simulation of the random walk
gr(size=(300,300),dpi=300)
using Random
Random.seed!(1)
function prrw_on_graph(ei, ej, xy, alpha, start, nstep, nframes)
  n = size(xy,2)
  A = sparse(ei,ej,1,n,n)
  B = A.*A'
  U = A - B # we need A' so that the ei, ej plots

  p = graphplot(findnz(triu(B,1))[1:2]..., x = xy[1,:], y = xy[2,:],
    markercolor=:lightblue, markerstrokecolor=:white, curves=false,
    markersize=7, markerstrokewidth=1,
    linecolor=1, linealpha=0.8, linewidth=0.7, arrow=:both, shorten=0.85,
    axis_buffer=0.5, background=nothing)

  graphplot!(findnz(U)[1:2]..., x = xy[1,:], y = xy[2,:],
    markercolor=nothing, markerstrokecolor=:white, curves=false, curvature_scalar = -0.4,
    markersize=0, markerstrokewidth=0,
     linecolor=2, linealpha=0.8, linewidth=0.7, arrow = :tail, shorten=0.85,
    axis_buffer=0.5, background=:black)

  X = start
  # random walk step
  #p1 = scatter!([xy[1,X]],[xy[2,X]],markersize=4, color=1)
  p2 = scatter!([xy[1,X]],[xy[2,X]],markersize=10, color=:orange)

  xlims!(xlims().*1.2)
  ylims!((-0.5,7.5))
  for i=1:10
    annotate!(xy[1,i],xy[2,i],text("$i",9,:white))
  end

  Xn = X
  jump = false
  anim = @animate for i=0:(nframes*nstep)
    stepi = mod(i,nframes) # this is the frame number in the step
    if stepi == 0
      X = Xn
      # with prob alpha, follow a rand. neig
      if rand() <= alpha && length(ej[ei .== X]) > 0
        Xn = rand(ej[ei .== X])
        jump = false
      else # with prob. (1-alpha)
        Xn = rand(1:n) # pick a random node
        jump = true
        println("Jump")
      end
    end
    # interpolate between the two positions
    if jump
      pos = stepi/(nframes-2)
      if pos >= 1
        pos = 1
      else
        pos += 0.25*randn()
      end
      pos = min(max(pos,0),1) # cap in 0,1
    else
      pos = min(stepi/(nframes-2),1)
    end
    p[5] = [(1-pos)*xy[1,X] + pos*xy[1,Xn]],[(1-pos)*xy[2,X] + pos*xy[2,Xn]]
  end
  return anim
end
anim = prrw_on_graph(ei,ej,xy,0.85,1,100,20)
gif(anim, "pr-rw-on-wiki-simple.gif", fps=40)


## Make a simple convergence figure
gr()
theme(:dark)
n = max(maximum(ei),maximum(ej))
A = sparse(ei,ej,1,n,n)
d = vec(sum(A,dims=2 ))
P = A'*Diagonal(1.0./d)
v = ones(n)/n
α = 0.85
nsteps = 25
X = zeros(n,nsteps)
X[:,1] = v
for i=2:nsteps
  X[:,i] = α*(P*X[:,i-1]) + (1-α)*v
end
#plot(X',labels=pages,size=(300,300))
plot(X',size=(300,300),
  background_color_legend = nothing,foreground_color_legend = nothing,
  labels=pages,legend=:best)
xlabel!("Step")
ylabel!("Value")
savefig("pagerank-wiki-simple-convergence.pdf")

@show sum(X[:,end])
