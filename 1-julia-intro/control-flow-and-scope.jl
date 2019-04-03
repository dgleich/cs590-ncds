## We'll learn about control flow!

## Simple stuff
x = Inf # we can use Infinity as a number !
        # this makes a Float64
typeof(x)
##
if x < 1
    println("x is smaller than 1")
end
##
if x < 1
    println("x is smaller than 1")
else
    println("x is larger than or equal to 1")
end

##
x = -5
if x < 1
    println("x is smaller than 1")
elseif x < 0
    println("x is smaller than 0")
else
    println("x is larger than or equal to 1")
end

##
if x < 0
    println("x is smaller than 0")
elseif x < 1
    println("x is smaller than 1")
else
    println("x is larger than or equal to 1")
end

##
x = [1.0, 2.0]
if all(x >= 0) && all( x <= 5)
    println("all elements between 0 and 5")
end


##
x = [1.0, 2.0]
if all(x .>= 0) && all(x .<= 5)
    println("all elements between 0 and 5")
end
##
x = 0
y = 5
if x+y > 10 || x < 0
    y = 0
else
    y = 10
end

## That block returned something,  you can "save"
# the result of a comparison
z = if x+y > 10 || x < 0
    y = 0
else
    y = 10
end

## That's it for "if, elseif, else"

## On to for floops

for i=1:10 # for i = 1 to 10, starting a 1 , ending at 10
    @show i
    println("end loop iteration")
end

##
v = -5:5
for i=v # for i = 1 to 10, starting a 1 , ending at 10
    @show i
    println("end loop iteration")
end

##
for i in v
    @show i
    println("end loop iteration")
end
##
v = [1.0,Inf,-Inf,π]
for i in v
    @show i
    println("end loop iteration")
end
##
v = [1 2 3 4]
for i in v
    @show i
    println("end loop iteration")
end
## Julia iterates over matrices by columns
@show [v' v'.+1]
for i=[v' v'.+1]
    @show i
end
##
x = 1:5
x[3] = -3
##
x = collect(1:5)
x[3] = -3

##
x = copy(1:5)
x[3] = -3
## We want to turn this into a real array
x = collect(1:5)
x[3] = -3


##
@show A = [x' x'.+1]
for i in A
    @show i
end

##
##
@show A = [x x.+1]
for i in A
    @show i
end

##While loops
i = 0
while i < 10
    global i
    if i == 5
        break # this works in for loops too!
    end
    if i==4
        i = i+5
    end
    @show i
    i = i+1
end
@show i

##
function example_while()
    i = 0
    while i < 10
        if i == 5
            break # this works in for loops too!
        end
        if i==4
            i = i+5
        end
        @show i
        i = i+1
    end
    @show i
end
example_while()

## The place I usually run into that issue.
# Let's say I want to compute the number of random variables
# that are bigger than pi.
numsuccess = 0
numtrials = 10000
for i=1:numtrials
    numsuccess += randn() > pi
end

# This case hits that scoping issue :(
# In IJulia/Jupyter, they include a patch
# And working out something else is an active area of
# development for Julia, so this may change in the
# future.


##
numsuccess = 0
numtrials = 10000
for i=1:numtrials
    global numsuccess
    numsuccess += randn() > pi
end
