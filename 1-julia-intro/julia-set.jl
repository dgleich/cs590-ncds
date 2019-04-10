## Before we got started
# I added the Images package via
# typing "]" then "add Images"
# alternatively, we could use
# using Pkg; Pkg.add("Images")

## Let's try and make Wikipedia's Julia set figure.
using Images
using Plots

## It says the seed coordinates are:
seeds = (-0.512511498387847167, 0.521295573094847167)

## Let's work with the Julia set.
# What we need to do is to check if, when starting
# from the complex number z=0, and iterating the map
# f(z) = z^2 + c
# for a large number of times (say 256)
# if the value of abs(f(z)) ever goes above 2,
# then we stop when that happens and return the value.
c = 0.25
# if we start at z = 0, then we test if z=0 is in the set.
z = 0.0+0.0im # this is how to make an imaginary number
f(z) = z^2 + c
@show f(z)
@show f(f(z))
@show f(f(f(z)))

##
zi = z
for i=1:10
    global zi
    zi = f(zi)
    @show zi
end
##
"""
`julia_check` is a subroutine useful for working with
the Julia set. We are going take as input two values:
z0 and c. The goal is to test whether or not the value
z0 seems to be in the Julia set for
    f(z) = z^2 + c
by starting from z0 = the input z0 and iterating
z1 = f(z0)
z2 = f(z1)
...
and so on.
Now, if at any point, we find abs(z) >= 2, then we know
that the point is NOT in the Julia set. In which case,
we return the iteration number where we detect this.
We run this for maxiter steps.
"""
function julia_check(z0, c; maxiter::Int=256)
    z = z0
    for i=1:maxiter
        z = z^2 + c
        if abs(z) >= 2
            return i
        end
    end
    return maxiter
end
julia_check(-1, 0.25)

## Let's look at starting positions z0 that range
## from [-1.75 to 1.75] in the real component
## and [-1.75 to 1.75] in the complex component
npts = 10
Z = zeros(npoints,npoints) # this will represent our Images
real_values = range(start=-1.75,stop=1.75,length=npts)
complex_values = range(start=-1.75,stop=1.75,length=npts)
for i=1:npts
    for j=1:npts
        z0 = real_values[i] + complex_values[j]*1.0im
        Z[j,i] = julia_check(z0, 0.25)
    end
end
heatmap(Z)

## The fix!
npts = 10
Z = zeros(npts,npts) # this will represent our Images
real_values = range(-1.75,stop=1.75,length=npts)
complex_values = range(-1.75,stop=1.75,length=npts)
for i=1:npts
    for j=1:npts
        z0 = real_values[i] + complex_values[j]*1.0im
        Z[j,i] = julia_check(z0, 0.25)
    end
end
heatmap(Z)

## Let's turn this into a function!
function julia_set(real_values, complex_values)
    Z = zeros(length(complex_values), length(real_values))
    for i=1:length(real_values)
        for j=1:length(complex_values)
            z0 = real_values[i] + complex_values[j]*1.0im
            Z[j,i] = julia_check(z0, 0.25)
        end
    end
    return Z
end
npts = 500
real_values = range(-1.75,stop=1.75,length=npts)
complex_values = range(-1.75,stop=1.75,length=npts)
heatmap(julia_set(real_values, complex_values))
##
function julia_set(real_values, complex_values; c=0.25)
    Z = zeros(length(complex_values), length(real_values))
    for i=1:length(real_values)
        for j=1:length(complex_values)
            z0 = real_values[i] + complex_values[j]*1.0im
            Z[j,i] = julia_check(z0, c)
        end
    end
    return Z
end
npts = 500
real_values = range(-1.75,stop=1.75,length=npts)
complex_values = range(-1.75,stop=1.75,length=npts)
heatmap(julia_set(real_values, complex_values; c = seeds[1] + seeds[2]*1.0im))
## Let's increase the resolution.
npts = 1000
real_values = range(-1.75,stop=1.75,length=npts)
complex_values = range(-1.75,stop=1.75,length=npts)
Z = julia_set(real_values, complex_values; c = seeds[1] + seeds[2]*1.0im)
## And then try and make our plot.
heatmap(log10.(Z))
## TODO or IDEA - Play around the with the colors to see if you find something you like better
## Show this like an image.
image = Gray.(Z/maximum(Z))
image

## to save this picture, we can use
using FileIO
using ImageMagick
save("juliaset.png", Gray.(Z/maximum(Z)))
