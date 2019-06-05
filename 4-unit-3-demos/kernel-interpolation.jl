## Kernel machines figures
using Plots
pyplot()
theme(:dark)

##
x1 = [1.0,5]
x2 = [2,-1.0]
y1 = 1.0
y2 = -1.0

v = [x1'; x2'] \ [y1,y2]

plot(framestyle=:origin,aspect_ratio=:equal,xlim=(-3,3),ylim=(-1.5,5.5))
scatter!([x1[1]],[x1[2]],label="")
annotate!([x1[1]],[x1[2]],text("+1 ",:white,:right,12))
scatter!([x2[1]],[x2[2]],label="")
annotate!([x2[1]],[x2[2]],text("-1 ",:white,:right,12))

##
plot!(size=(200,200))
savefig("kernel-interpolation-2d-setup.pdf")
##
scatter!([v[1]],[v[2]],label="")
plot!(v[1]*[-5,5], v[2]*[-5,5],label="")
annotate!([v[1]],[v[2]], text("v ",:white,:right,12))
savefig("kernel-interpolation-2d-soluiton.pdf")
##
x1 = [1.0,5,1]
x2 = [2,-1.0,-1]
y1 = 1.0
y2 = -1.0

v = [x1'; x2'] \ [y1,y2]

plot(aspect_ratio=:equal,xlim=(-3,3),ylim=(-1.5,5.5))
scatter!([x1[1]],[x1[2]],[x1[3]],label="")
annotate!([x1[1]],[x1[2]],[x1[3]],"+1 ")
scatter!([x2[1]],[x2[2]],[x2[3]],label="")
##
plot!(size=(200,200),dpi=300)
anim = @animate for i=1:180
  plot!(camera=(i,30))
end
gif(anim, "kernel-interpolation-3d-setup.gif")

##
#annotate!([x2[1]],[x2[2]],text("-1 ",:white,:right,12))
scatter!([v[1]],[v[2]],[v[3]], label="")
plot!(v[1]*[-5,5], v[2]*[-5,5], v[3]*[-5,5], label="",color=5)

## Other solutions
using LinearAlgebra
v = nullspace([x1'; x2'])
x1'*a
x1'*(a+v[:,1])

b = a+v[:,1]
scatter!([b[1]],[b[2]],[b[3]], label="")
plot!(b[1]*[-5,5], b[2]*[-5,5], b[3]*[-5,5], label="", color=8)

##
plot!(size=(200,200),dpi=300)
anim = @animate for i=1:180
  plot!(camera=(i,30))
end
gif(anim, "kernel-interpolation-3d-solution.gif")
