## PCA vs LDA
## Height Weight data
# Grab data from https://www.kaggle.com/mustafaali96/weight-height
# https://opendata.stackexchange.com/questions/7793/age-weight-and-height-dataset
# https://www.reddit.com/r/datasets/comments/1dii3t/data_sets_for_heights_and_weights/

# https://vincentarelbundock.github.io/Rdatasets/datasets.html

# a related tutorial
# http://goelhardik.github.io/2016/10/04/fishers-lda/

##
using Plots
##
# https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv
using CSV
df = CSV.read(download("https://vincentarelbundock.github.io/Rdatasets/csv/carData/Davis.csv"))
X = Float64.([df[:weight] df[:height]])

##
g = df[:sex]

##
scatter(X[:,1],X[:,2])
xlabel!("Weight")
ylabel!("Height")

## Filter the data
goodpts = X[:,1] .<= 115
Xf = X[goodpts,:]
gf = g[goodpts]

##
theme(:dark)
scatter(Xf[:,1],Xf[:,2],color=2)
xlabel!("Weight")
ylabel!("Height")

## Save a picture
pyplot()
scatter(Xf[:,1],Xf[:,2],color=2,size=(300,300), legend=false)
xlabel!("Weight")
ylabel!("Height")
savefig("weight-height-1.pdf")

## Partition by classes
s1 = gf .== "F"
s2 = gf .== "M"
X1 = Xf[s1,:]
X2 = Xf[s2,:]
gr()
scatter(X1[:,1],X1[:,2])
scatter!(X2[:,1],X2[:,2])

## Save a picture
pyplot()
scatter(X1[:,1],X1[:,2],size=(300,300), legend=false)
scatter!(X2[:,1],X2[:,2])
savefig("weight-height-2.pdf")
##
using Statistics
m = mean(Xf,dims=1)
m1 = mean(X1,dims=1)
m2 = mean(X2,dims=1)
n1 = size(X1,1)
n2 = size(X2,1)

B = (m1-m)'*n1*(m1-m) + (m2-m)'*n2*(m2-m)
W = (X1.-m1)'*(X1.-m1) + (X2.-m2)'*(X2.-m2)

## The matrices B and W add up to the total covariance
using LinearAlgebra
C = (Xf.-m)'*(Xf.-m)
norm(B+W - C)

##
lams,V = eigen(B,W)

##
v = V[:,2]
p1 = histogram((X1)*v,nbins=10)
histogram!((X2)*v,nbins=10)
## Save
plot!(size=(300,300),legend=false)
savefig("weight-height-lda.pdf")
##

## Compare to PCA
lams,V = eigen(C)
v2 = V[:,2]
p2 = histogram(X1*v2,nbins=10)
histogram!(X2*v2,nbins=10)
plot(p1,p2)
##
## Save
plot(p2)
plot!(size=(300,300),legend=false)
savefig("weight-height-pca.pdf")
##
X1c = X1.-m
X2c = X2.-m
scatter(X1c[:,1],X1c[:,2], label="")
scatter!(X2c[:,1],X2c[:,2], label="")
Plots.abline!(v[2]/v[1],0,label="LDA")
Plots.abline!(v2[2]/v2[1],0,label="PCA")
##
plot!(size=(300,300),legend=false)
savefig("weight-height-lda-pca.pdf")
