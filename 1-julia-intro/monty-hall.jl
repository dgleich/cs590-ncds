## Let's look at the Monte Hall Problem.
# The first thing we'll do is to build a function to simulate
# a Monty Hall experiment. That is, we will have three doors.
# Behind one is a car. Behind the other two are goats.
# You will pick one door (at random).
# -- Work for yourself -- try picking just one specific door,
# -- say door 1.
# Then Monty Hall will show you one door that has a goat.
# And this is a door that you didn't pick...
# Then we have two strategies, stay and switch. Switch will
# will go to the door that isn't revealed.

"""
`monty_hall`
============

Input
-----
- `switch` a boolean (true/false) that says if we switch or not.

Returns:
- return true if we won the car or return false otherwise
"""
function monty_hall(switch::Bool)
    cardoor = rand(1:3) # this picks a random number from the range 1:3
    yourdoor = rand(1:3) # this picks a random door

    alldoors = Set(1:3)  # this creates a set
    delete!(alldoors, cardoor) # monty can't show you this door
    delete!(alldoors, yourdoor) # monty can't show you this door
    montydoor = rand(alldoors) # monty can show you this door or doors
    delete!(alldoors, montydoor)
    if length(alldoors) == 0
        switchdoor = cardoor
    else
        @assert(length(alldoors) == 1)
        switchdoor = first(alldoors) # gets the first thing in the set.
    end
    if switch
        yourdoor = switchdoor
    end
    return yourdoor == cardoor
end
monty_hall(false)

###
""" Run multiple trials and show the overall average success. """
function monty_trials(n::Int, switch::Bool)
    ncars = 0
    for i=1:n
        ncars += monty_hall(switch)
    end
    return ncars/n
end
monty_trials(10000, false)

## What happens if we DO switch?
monty_trials(10000, true)
