## Save the small wikipedia graph
using SparseArrays
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
A = sparse(A)
pages = ["PageRank", "Google", "Adjacency matrix",
"Markov chain", "Eigenvector", "Directed graph",
"Graph", "Linear system", "Vector space", "Multiset"]
ei,ej = findnz(A)
xy = [1.5 6.5;0 5.5; 0 2.25; -1.5 6.5; 0 4; -1.5 0.85; 1.5 0.85; -1 4.5; -1 3; 0 0.25]
##
using DelimitedFiles
writedlm("wiki-simple.edges", [ei ej])
writedlm("wiki-simple.xy", xy)
writedlm("wiki-simple.nodes", pages)
##
using GraphRecipes
#graphplot(ei,ej, x=xy[:,1], y=xy[:,2])
B = A.*A'
U = A - B # we need A' so that the ei, ej plots

graphplot(findnz(triu(B,1))[1:2]..., x = xy[:,1], y = xy[:,2],
  markercolor=nothing, markerstrokecolor=:white, curves=false,
  markersize=0,
  linecolor=1, linealpha=0.8, linewidth=0.7, arrow=:both, shorten=0.85,
  axis_buffer=0.5, background=nothing)

graphplot!(findnz(U)[1:2]..., x = xy[:,1], y = xy[:,2],
  markercolor=nothing, markerstrokecolor=:white, curves=false, curvature_scalar = -0.4,
  markersize=0,
   linecolor=2, linealpha=0.8, linewidth=0.7, arrow = :tail, shorten=0.85,
  axis_buffer=0.5, background=nothing)

xlims!(xlims().*1.2)
for i=1:10
  annotate!(xy[i,1],xy[i,2],text(pages[i],9,:white))
end
plot!(size=(300,300))
savefig("wiki-simple.pdf")

##
using GraphRecipes
#graphplot(ei,ej, x=xy[:,1], y=xy[:,2])
B = A.*A'
U = A - B # we need A' so that the ei, ej plots

graphplot(findnz(triu(B,1))[1:2]..., x = xy[:,1], y = xy[:,2],
  markercolor=nothing, markerstrokecolor=:white, curves=false,
  markersize=0, markerstrokewidth=0,
  linecolor=1, linealpha=0.8, linewidth=0.7, arrow=:both, shorten=0.85,
  axis_buffer=0.5, background=nothing)

graphplot!(findnz(U)[1:2]..., x = xy[:,1], y = xy[:,2],
  markercolor=nothing, markerstrokecolor=:white, curves=false, curvature_scalar = -0.4,
  markersize=0, markerstrokewidth=0,
   linecolor=2, linealpha=0.8, linewidth=0.7, arrow = :tail, shorten=0.85,
  axis_buffer=0.5, background=nothing)

xlims!(xlims().*1.2)
for i=1:10
  annotate!(xy[i,1],xy[i,2],text("$i",9,:white))
end
plot!(size=(300,300))
savefig("wiki-simple-numbers.pdf")


##
#= Tikz graph
\Vertex[L={PageRank},x=1.5,y=6.5]{1}
\Vertex[L={Google},x=0,y=5.5]{2}
\Vertex[L={Adjacency matrix},x=0,y=2.25]{3}
\Vertex[L={Markov chain},x=-1.5,y=6.5]{4}
\Vertex[L={Eigenvector},x=0,y=4]{5}
\Vertex[L={Directed graph},x=-1.5,y=0.85]{6}
\Vertex[L={Graph},x=1.5,y=0.85]{7}
\Vertex[L={Linear system},x=-1,y=4.5]{8}
\Vertex[L={Vector space},x=-1,y=3]{9}
\Vertex[L={Multiset},x=0,y=0.25]{10}

\Edge(4)(2)
\Edge(5)(2)
\Edge(4)(6)
\Edge(1)(7)
\Edge(3)(7)
\Edge(4)(8)
\Edge(5)(9)
\Edge(6)(9)
\Edge(6)(10)
\Edge(7)(10)
\Edge(2)(1)
\Edge(4)(1)
\Edge(5)(1)
\Edge(1)(2)
\Edge(5)(3)
\Edge(6)(3)
\Edge(1)(4)
\Edge(5)(4)
\Edge(1)(5)
\Edge(3)(5)
\Edge(4)(5)
\Edge(3)(6)
\Edge(7)(6)
\Edge(6)(7)
\Edge(9)(8)
\Edge(8)(9)
\Edge(1)(3)
=#
