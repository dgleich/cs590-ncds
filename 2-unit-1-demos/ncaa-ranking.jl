## Look at the NCAA data using our simple rating system.

## Read the data
using CSV
using DataFrames
content = CSV.read("ncaa-2018.csv")


## Convert teams into numbers and also build our game table
m = size(content,1)
teams_dict = Dict{String,Int}()
teams = Vector{String}()
index = 1
data = Array{Int64}(undef, m, 4)
for i = 1 : m
    global index
    team = content[:Team][i]
    opponent = content[:Opponent][i]
    teamscore = content[Symbol("Team Score")][i]
    oppscore = content[Symbol("Opponent Score")][i]
    if !haskey(teams_dict, team)
        push!(teams, team)
        teams_dict[team] = index
        index = index + 1
    end

    if !haskey(teams_dict, opponent)
        push!(teams, opponent)
        teams_dict[opponent] = index
        index = index + 1
    end

    data[i, 1] = teams_dict[team]
    data[i, 2] = teams_dict[opponent]
    data[i, 3] = teamscore
    data[i, 4] = oppscore
end

## Build the least-squares model
B = zeros(m, length(teams))
p = zeros(m)
for i=1:m
    # form the model
    ti = data[i,1]
    tj = data[i,2]
    p[i] = data[i,3] - data[i,4]
    B[i,ti] = 1
    B[i,tj] = -1
end
## Solve the model
# This solves as a least squares problem.
s = B\p

##
rank = sortperm(s,rev=true)
##
teams[rank]
##
## Numerical Computing in Data Science top 10 in 2018 are ..
using Printf
for i=1:10
    @printf("%20s - %2i - %.3f\n ",
        teams[rank[i]], i, s[rank[i]])
end
