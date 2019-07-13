## In this notebook, we'll look at least absolute deviation on biometric data

##
using Plots
pyplot()
theme(:dark)
##
# https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv
using CSV
df = CSV.read(download("https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv"))
X = Float64.([df[:weight] df[:height]])
# Filter the data
goodpts = X[:,1] .<= 115
Xf = X[goodpts,:]
##
scatter(Xf[:,1],Xf[:,2],label="",xlabel="weight (kg)", ylabel="height (cm)")
##
x = Xf[:,1]
A = [x ones(length(x))]
b = Xf[:,2]
ab_ls = A\b # solve the least squares problem

## Solve the Least Absolute Deviation version
using Convex, SCS
xvar = Variable(2)
problem = minimize(sum(abs(A * xvar - b)))
solve!(problem, SCSSolver(max_iters=20000))
ab_lad = xvar.value
##
using Printf
scatter(Xf[:,1],Xf[:,2],color=2,size=(300,300), label="")
plot!(x, x*ab_ls[1] .+ ab_ls[2], label="",color=5)
plot!(x, x*ab_lad[1] .+ ab_lad[2], label="",color=6)
title!(@sprintf("LS: height ≈ %.2f weight + %.2f\nLAD:  height ≈ %.2f weight + %.2f    ",
ab_ls[1],ab_ls[2],ab_lad[1],ab_lad[2]), titlefontsize=12)
xlabel!("Weight (kg)")
ylabel!("Height (cm)")
savefig("weight-height-fit-lad.pdf")
## Except, we actually filtered the data.
# to remove an outlier
scatter(X[:,1],X[:,2],color=2,size=(300,300), label="",xlabel="weight (kg)", ylabel="height (cm)")
savefig("weight-height-outliers.pdf")
##
x = X[:,1]
A = [x ones(length(x))]
b = X[:,2]
ab_ls = A\b # solve the least squares problem
xvar = Variable(2)
problem = minimize(sum(abs(A * xvar - b)))
solve!(problem, SCSSolver(max_iters=20000))
ab_lad = xvar.value
scatter(X[:,1],X[:,2],color=2,size=(300,300), label="")
plot!(x, x*ab_ls[1] .+ ab_ls[2], label="",color=5)
plot!(x, x*ab_lad[1] .+ ab_lad[2], label="",color=6)
title!(@sprintf("LS: height ≈ %.2f weight + %.2f\nLAD:  height ≈ %.2f weight + %.2f    ",
ab_ls[1],ab_ls[2],ab_lad[1],ab_lad[2]), titlefontsize=12)
xlabel!("Weight (kg)")
ylabel!("Height (cm)")
savefig("weight-height-outliers-fit-lad.pdf")
