## Plotting intro

## Step 1, add the plotting package.
# at command line, if you press "]"
# If you want to do it not at the command line, you can also use
using Pkg # this adds the Package manager to your Julia session
Pkg.add("Plots") # this adds the Plots package
## Let's create some data to plot.
"""
`brownian_motion`
=================

Create a simple brownian motion trail. A discrete-time Brownian motion
is the value that increases by a random, normally distributed variable at
each time step. So

    \$ x_{t+1} = x_{t} + N(0,1) \$

Returns: A Vector{Float64} with n entries that describes
    a Brownian motion over n time steps .
"""
function brownian_motion(n::Int)
    x = 0.0 # start our Brownian motion at x = 0.0
    B = zeros(0) # this is an empty vector of Float64's (or length 0)
    for t=1:n # for n time-steps
        x = x+randn() # randn gives you a normally distributed random value.
        push!(B,x) # add x to the "end" of the vector B.
    end
    return B
end
brownian_motion(5)

## Questions to explore on your own.
# - Modify the brownian_motion function to start at a different place
# - Modify the brownian_motion function to pre-allocate a length n array

## Other ways to implement Brownian motion
A = randn(5)
cumsum(A)

## This works
cumsum(randn(5)) # this does everything in one line
## TODO, figure out how to use the cumsum! function to do this in one step.
# cumsum!
# slighlty more annoying than I expected
## There is another way of defining a function in Julia
# I usually try and be explicit and define functions with the word function
# like the brownian_motion function.
# But you can also, just give it a name, like in math.
bmotion(n) = cumsum(randn(n))
# This syntax is equivalent to
# function bmotion(n)
#   return cumsum(randn(n))
# end
# but is much shorter.

# Sometimes, we use this for very simple functions.

##
B = brownian_motion(100)

##
using Plots # this adds the plotting functions to Julia's session
##
using Plots
plot(B) # this will plot a vector.
##
plot(brownian_motion(1000))

## Let's see multiple Plots
plot(brownian_motion(1000))
plot!(brownian_motion(1000))
##
plot!(title="two Brownian trails")
##
plot!(xlabel="Time") # alternative xlabel!("Time")
ylabel!("Value") # alternative plot!(ylabel="Value")
##
# Let's get rid of the legend
plot!(legend=false)
##
annotate!(200,15,"Max value")
##
savefig("brownian-trails.pdf") # save as a pdf
##
savefig("brownian-trails.png") # save as a png
# savefig("brownian-trails.eps") # save as a eps
# this doesn't work with GR :(
## We can do this all at once too.
A = brownian_motion(10000)
B = brownian_motion(9000)
plot(A,B) # won't give you what you expect ...
##
plot([A,B], lab=["Trail 1", "Trail 2"],  # this gives it a pair... and labels
    xlabel="Time", ylabel="Value", xscale=:log10)
title!("Two Brownian Trails")
savefig("brownian-trails-log.pdf")

## Plotting scattered data
# Don't use syntax like this without a good reason.
A, B = brownian_motion(10000), brownian_motion(10000) # all in one linef
##
scatter(A,B,alpha=0.5, markersize=1,markerstrokewidth=0,) # plot A as a function of B
plot!(title="2D Brownian motion")
## Playing around with options
x = brownian_motion(50)
y = brownian_motion(50)
##
scatter(x,y,marker=:x)
plot!(x,y,markersize=0) # this makes the line connecting them
##
