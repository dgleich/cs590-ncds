## Before we got started
# I added the CSV package via
# typing "]" then "add CSV"
# alternatively, we could use
# using Pkg; Pkg.add("CSV")

## Let's start by reading our house prices
using CSV
data = CSV.read("1-julia-intro/houses.csv")


## Let's get the first house info
data[1,:]'

## See the column names
names(data)

##
scatter(data[:latitude], data[:longitude])

## Let's add house prices
scatter(data[:latitude], data[:longitude], marker_z=Int.(data[:price]))

## Let's see zipcodes
# how many are there
@show unique(Int.(data[:zip]))


## TODO - show a true categorical vector plot of zipcodes.
## Plot by zip
scatter(data[:latitude], data[:longitude], marker_z=Int.(data[:zip]))

## Let's plot house-prices by sqft.
scatter(data[:latitude], data[:longitude],
    marker_z=Int.(data[:price])./Int.(data[:sq__ft]))

##
datar = data[data[:type] .== "Residential",:]
datar = datar[datar[:sq__ft] .> 0, :]
##
scatter(datar[:latitude], datar[:longitude],
    marker_z=Int.(datar[:price])./Int.(datar[:sq__ft]))

## Get the average price per sqft based on zipcodes.
# Let's use Julia's data frames first
using Statistics
using DataFrames
datar.price_per_sqft = Int.(datar[:price])./Int.(datar[:sq__ft])
by(datar, :zip, :price_per_sqft => mean)

##
"""
This takes in a set of data in terms of zipcodes
and price_per_sqrt data for a house sold in that zipcode.
    So the two vectors zipcodes, price_per_sqft should have
    the same length. Then we will return a Dictionary
    which is the average price per sqft in each zipcode.
"""
function avgprice_by_zip(zipcodes, price_per_sqft)
    zipprices = Dict{Int,Float64}()
    zipcounts = Dict{Int,Int}() # this counts the number of vals
    @assert length(zipcodes) == length(price_per_sqft)
    for i in 1:length(zipcodes)
        if !(haskey(zipprices, zipcodes[i]))
            # initialize
            zipprices[zipcodes[i]] = 0
            zipcounts[zipcodes[i]] = 0
        end
        zipprices[zipcodes[i]] += price_per_sqft[i]
        zipcounts[zipcodes[i]] += 1 # add one to our count
    end
    for k in keys(zipprices)
        zipprices[k] /= zipcounts[k]
    end
    return zipprices
end
avgs = avgprice_by_zip(Int.(datar[:zip]), datar[:price_per_sqft])

##
bar(collect(keys(avgs)), collect(values(avgs)))

## Our goal -- is there really a relationship between
## prices and zip codes?
## LEt's pick an arbitrary zipcode
using Random
testzip = 95690
# Here the avg prices
testavg = avgs[testzip]

function permtest_on_zip(N::Int)
    # note that this is going to use
    # global variables from outside,
    # you can just use them!
    zipcodes = Int.(datar[:zip])
    prices = datar[:price_per_sqft]
    rand_prices = zeros(N)
    for i=1:N
        p = randperm(length(zipcodes))
        zipcodes = zipcodes[p]
        randavgs = avgprice_by_zip(zipcodes, prices)
        rand_prices[i] = randavgs[testzip]
    end
    return rand_prices
end
rand_prices = permtest_on_zip(1000)
@show sum(rand_prices .>= testavg)
histogram(rand_prices)
vline!([testavg])

## Let's look at a max-vs-min price by zip
diffs = maximum(values(avgs)) - minimum(values(avgs))

## Differs under perm test
function permtest_diff_on_zip(N::Int)
    # note that this is going to use
    # global variables from outside,
    # you can just use them!
    zipcodes = Int.(datar[:zip])
    prices = datar[:price_per_sqft]
    rand_diffs = zeros(N)
    for i=1:N
        p = randperm(length(zipcodes))
        zipcodes = zipcodes[p]
        randavgs = avgprice_by_zip(zipcodes, prices)
        rand_diffs[i] = maximum(values(randavgs)) - minimum(values(randavgs))
    end
    return rand_diffs
end
rand_diffs = permtest_diff_on_zip(1000)
@show sum(rand_diffs .>= diffs)
histogram(rand_prices)
vline!([diffs])
