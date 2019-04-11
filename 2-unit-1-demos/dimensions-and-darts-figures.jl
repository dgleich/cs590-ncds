using LinearAlgebra

##
using Plots
theme(:dark)
N = 200
x = rand(N)
y = rand(N)
scatter(x,y,marker_z = x.^2 + y.^2 .<= 1,
  colorbar=false, color=:blues, legend=false, size=(300,300))
savefig("darts-2d.pdf")

##
using Plots

# Yanfei fit these, will post code at some point.
ps = [1.0000000000000007
1.9071251844719876
2.9163505597292922
4.022490241233555
5.216497321076429
6.489971145314907
7.835660661642428
9.247384556353152
10.719862319175242
12.248553044593804
13.829521448758406
15.459330401914192
17.134658253998534
18.853008360316284
20.61139369797272
22.406483457522032
24.2335290146664
26.084939572427672
27.538569418766958]

##
k = 2
p = ps[k-1]
thetas = range(0.0, stop=pi/2, length=100)
plot(cos.(thetas).^p, sin.(thetas).^p, label="")

for k=3:10
  p = ps[k-1]
  plot!(cos.(thetas).^p, sin.(thetas).^p, label="")
end
plot!(size=(200,200), xaxis=false, yaxis=false, aspect_ratio=:equal, background=:transparent)
savefig("darts-nd.pdf")
