## Look at musical artists
using DelimitedFiles
using SparseArrays
names = readlines("artistsim.names")
data = readdlm("artistsim.smat")
##
data[2:end,1] .+= 1
data[2:end,2] .+= 1
##
A = sparse(Int.(data[2:end,1]),
           Int.(data[2:end,2]),
           Int.(data[2:end,3]),
           Int(data[1,1]),Int(data[1,1]))
## Show the data
using Random
p = randperm(size(data,1))
display(Int.(data[p,:]))
##
names[34261],names[14195]
##
names[11990],names[16868]
## The data is not symmetric.
sum(abs.(A-A'))
## Show the artists with most in-coming similarity
using Plots
plot(vec(sum(A,dims=2)))
##
using Printf
d = vec(sum(A,dims=1))
p = sortperm(d, rev=true)
for i=1:25
    @printf("%2i - %s\n", i, names[p[i]])
end
##
using MatrixNetworks
x = pagerank(A,0.85)
p = sortperm(x,rev=true)
##
for i=1:25
    @printf("%2i - %s\n", i, names[p[i]])
end
