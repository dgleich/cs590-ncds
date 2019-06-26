## Seeded PageRank animation
# We are going to make an animation where we move from vertex to vertex
# following the nearest vertex in a seeded PageRank simulation

using MatrixNetworks
using Plots

function seeded_pagerank_animation(A,xy,seed,α,nsteps)
  curseed = seed
  started = Set{Int}() # this is the list of points we've started.
  @assert(nsteps <= size(A,1))
  @assert(is_connected((A)))
  anim = @animate for i=1:nsteps
    push!(started, curseed)
    f2 = seeded_pagerank(A, α, curseed)
    p = sortperm(f2) # this gets things to draw in the right z-order
    scatter(xy[p,1],xy[p,2], marker_z=-abs.(log10.(f2[p])).^0.5,colorbar=false,alpha=0.5,
      color=:magma,
      size=(1200,1200),
      markerstrokecolor=nothing,markerstrokewidth=0,label="",framestyle=:none,background=:black)
    curseed = -1
    for v in sortperm(f2,rev=true)
      if v in started
        continue
      else
        curseed = v
        break
      end
    end
  end
  return anim
end
A = load_matrix_network_all("geoclusters-example").A
xy = load_matrix_network_all("geoclusters-example").xy
anim = seeded_pagerank_animation(A,xy,1,0.5,100)
gif(anim,"geoclusters-animation.gif",fps=10)



## Now use the actual artistsim graph
names = readlines("../2-unit-1-demos/artistsim.names")
data = readdlm("../2-unit-1-demos/artistsim.smat")
xy = readdlm("artistsim.xy")
A = sparse(Int.(data[2:end,1]).+1,
           Int.(data[2:end,2]).+1,
           Int.(data[2:end,3]),
           Int(data[1,1]),Int(data[1,1]))
Asym = max.(A,A') # make the graph undirected
Acc,ccfilt = largest_component(Asym)
xycc = xy[ccfilt,:]

##
anim = seeded_pagerank_animation(Acc,xycc,200,0.5,200)
gif(anim,"artistsim-seeded-pagerank-animation.gif",fps=10)
