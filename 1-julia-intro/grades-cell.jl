
# The "pound" symbol or "hash" symbol or "octothorp?" is the comment character
# in a julia file. So all of these commands are ignored!

##
grades = [
  30
  40
  30
  45
  50
  20
  35
  40
  50
  49
  55
]
avggrade = sum(grades)/length(grades)
##
println("The average grade is ", avggrade)

##
# Let's compute the standard deviation too!
# The formula for the standard deviation is
# sqrt(mean((x_i - mean(x)))^2)
# Julia has a built in stdev function, we'll use that in a second.

cgrades = grades .- avggrade
stdgrades = sqrt(sum(cgrades.^2)/length(cgrades))

##
using Statistics
##
mean(grades)
##
std(grades; corrected=false)
