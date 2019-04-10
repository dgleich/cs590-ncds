## The birthday paradox in theory and in practice.

## Let's simulate the classic birthday paradox.
# In this simulation, we will draw birthdays at random for a group
# of N people, and see if there are any two birthdays that
# are the same.

"""
N is the number of people

This function returns true if two people had the same birthday.
"""
function simple_birthday_simulation(N::Int)
    birthdays = rand(1:365, N)
    # so each birthday is an integer from 1 to 365.
    # we need to check if all of the birthdays are unique
    return !allunique(birthdays) # ! reverses true -> false, false -> true
end

simple_birthday_simulation(20)

## Let's look at what happens as we vary the number of people.
ntrials = 100
prob_dup_birthday = zeros(0) # this is an empty array
for people=5:40
    numdup = 0
    for t=1:ntrials
        numdup += simple_birthday_simulation(people)
    end
    push!(prob_dup_birthday, numdup/ntrials)
end
# make a quick people - by - prob table
display([5:40 prob_dup_birthday])
# but also make a plot
using Plots
plot(5:40, prob_dup_birthday)
xlabel!("People")
ylabel!("Prob. of shared birthday")

## Some ideas to improve
# IDEA -- add confidence intervals
# IDEA -- add "exact" curve based on prob.

## Let's use real data.
using DelimitedFiles
birthdays = readdlm("1-julia-intro/birthday.txt")
plot(birthdays[:,2])

## First step, let's simulate a random birthday from data.
using StatsBase
bday_weights = fweights(Int.(birthdays[:,2]))
sample(bday_weights)

## Let's do the same demo
sample_bdays = [sample(fweights([2,4,3,1])) for i=1:1000]
sum(sample_bdays .== 4)

## Let's implement the sampling ourselves too...
"""
N is the number of people
data is an array of length number of days with the number of people
that were born on that day.

Internally, what this does is convert data to a cum. prob. distribution
and then we use a random [0,1] sample to find where in the CDF we fall.

The idea of how this works is:
give probs [0.2 0.4 0.3 0.1] (i.e. we have 4 birthdays)
then we are going to make an array
[0.2, 0.6, 0.9, 1.0]
and then we are going to guess a random [0,1] variable
and see which bin it falls into.
if the rv. is less than 0.2, we will call it birthday 1
if the rv. is less between 0.2, 0.6, we will call it birthday 2
if the rv. is less between 0.6, 0.9, we will call it birthday 3
if the rv. is less between 0.9, 1, we will call it birthday 4
but this will work for even larger lists too.
"""
function sample_birthdays(N::Int, data)
    probs = data/sum(data)
    cumdist = cumsum(probs)
    bdays = zeros(Int, N)
    for i=1:N
        rv = rand()
        for j=1:length(cumdist)
            if rv <= cumdist[j]
                bdays[i] = j
                break # need to stop when we find the birthday
            end
        end
    end
    return bdays
end
bdays = sample_birthdays(1000, [2,4,3,1])
# Let's check their frequency
sum(bdays .== 3) # count the number of "2" birthdays in our test
## IDEA - use binary search to find the right birthday faster.

## Let's simulate the data-based shared birthday probability
function data_birthday_simulation(N::Int, data)
    birthdays = sample_birthdays(N, data)
    # so each birthday is an integer from 1 to 365.
    # we need to check if all of the birthdays are unique
    return !allunique(birthdays) # ! reverses true -> false, false -> true
end

data_birthday_simulation(20, Int.(birthdays[:,2]))

ntrials = 100
prob_dup_birthday = zeros(0) # this is an empty array
for people=5:40
    numdup = 0
    for t=1:ntrials
        numdup += data_birthday_simulation(people, Int.(birthdays[:,2]))
    end
    push!(prob_dup_birthday, numdup/ntrials)
end
# make a quick people - by - prob table
display([5:40 prob_dup_birthday])
# but also make a plot
using Plots
plot(5:40, prob_dup_birthday)
xlabel!("People")
ylabel!("Prob. of shared birthday based on data")

## TODO Do a test to show that this curve is higher than the uniform
# case.


## Use Julia's sampler
function data_birthday_simulation_julia(N::Int, data)
    w = fweights(data)
    birthdays = [sample(w) for i=1:N]
    # so each birthday is an integer from 1 to 365.
    # we need to check if all of the birthdays are unique
    return !allunique(birthdays) # ! reverses true -> false, false -> true
end
ntrials = 100
prob_dup_birthday = zeros(0) # this is an empty array
for people=5:40
    numdup = 0
    for t=1:ntrials
        numdup += data_birthday_simulation_julia(people, Int.(birthdays[:,2]))
    end
    push!(prob_dup_birthday, numdup/ntrials)
end
# make a quick people - by - prob table
display([5:40 prob_dup_birthday])
# but also make a plot
using Plots
plot(5:40, prob_dup_birthday)
xlabel!("People")
ylabel!("Prob. of shared birthday based on data")
