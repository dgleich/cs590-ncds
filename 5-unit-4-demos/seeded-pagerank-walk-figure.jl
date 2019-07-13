##
using Plots
using GraphRecipes
using SparseArrays
using DelimitedFiles
using LinearAlgebra
##
ei,ej = copy.(eachcol(Int.(readdlm("wiki-simple.edges"))))
xy = readdlm("wiki-simple.xy")'
pages = readlines("wiki-simple.nodes")

## A visual simulation of the random walk with fixed restart
gr(size=(300,300),dpi=300)
using Random
Random.seed!(1)
function sprrw_on_graph(ei, ej, xy, alpha, start, nstep, nframes)
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
        Xn = start # go back to start
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
anim = sprrw_on_graph(ei,ej,xy,0.85,1,100,20)
gif(anim, "seeded-pr-rw-on-wiki-simple.gif", fps=40)
