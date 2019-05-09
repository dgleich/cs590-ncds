##
using FixedPointNumbers
using FixedPointDecimals
##
x = FixedDecimal{Int,2}(5)
## Emulate the Mario Kart system to rotate a dinosaur
MKFP = Fixed{Int16,8} # use 16 bits for a signed integer and 8 bits for fraction
val = MKFP(5.25)

## Get some data off the internet and plot it
data = [24,18, 24,17, 22,16, 20,11, 19,6, 19,2, 17,2, 17,6,
16,5, 15,2, 13,2, 14,5, 14,6, 12,6, 12,2, 10,2, 10,4,
9,2, 7,2, 9,6, 7,6, 4,4, 2,3, 0,2, 1,3, 3,5, 5,9,
9,11, 17,11, 21,17, 23,18, 24,18]
P = reshape(data,2,div(length(data),2))
x = P[1,:]
y = P[2,:]
using Plots
scatter(x,y,legend=false)

## Plot it in Mario Kart numbers and connect the dots
x = MKFP.(x)
y = MKFP.(y)
plot!(x,y,legend=false) # no change!
##
deg = 63
theta = deg/180*pi
R(theta) = [cos(theta) -sin(theta); sin(theta) cos(theta)]
Pp = R(theta)*P # True
plot(Pp[1,:],Pp[2,:],linestyle = :solid,marker = :circle,color=2,lab="Float64")
# Rotate in fixed Point
Pmk = MKFP.(R(MKFP(theta)))*MKFP.(P)
plot!(Pmk[1,:],Pmk[2,:],linestyle = :solid,marker = :circle,color=4,lab="Mario Kart")
##
theme(:dark)
plot!(size=(350,350))
savefig("dinofig-rotated.pdf")
##

## Save original fig
theme(:dark)
plot(x,y,legend=false,marker=:circle,color=2,size=(350,350)) # no change!
savefig("dinofig.pdf")
