using Plots
using Random
Random.seed!(0)
A = randn(40,30)
heatmap(A)
