using Printf, LinearAlgebra,  Plots
theme(:dark)

vhuman=6.0
vraptor0=10.0 # the slow raptor velocity in m/s
vraptor=15.0 #

raptor_distance = 20.0

raptor_min_distance = 0.2; # a raptor within 20 cm can attack
tmax=10. # the maximum time in seconds
nsteps=1000

"""
This function will compute the derivatives of the
positions of the human and the raptors
"""
function compute_derivatives(angle,h,r0,r1,r2)
    dh = [cos(angle),sin(angle)]*vhuman
    dr0 = (h-r0)/norm(h-r0)*vraptor0
    dr1 = (h-r1)/norm(h-r1)*vraptor
    dr2 = (h-r2)/norm(h-r2)*vraptor
    return dh, dr0, dr1, dr2
end
"""
This function will use forward Euler to simulate the Raptors
"""
function simulate_raptors(angle; output::Bool = true)
    # initial positions
    h = [0.0,0.0]
    r0 = [1.0,0.0]*raptor_distance
    r1 = [-0.5,sqrt(3.)/2.]*raptor_distance
    r2 = [-0.5,-sqrt(3.)/2.]*raptor_distance

    # how much time el
    dt = tmax/nsteps
    t = 0.

    hhist = zeros(2,nsteps+1)
    r0hist = zeros(2,nsteps+1)
    r1hist = zeros(2,nsteps+2)
    r2hist = zeros(2,nsteps+2)

    hhist[:,1] = h
    r0hist[:,1] = r0
    r1hist[:,1] = r1
    r2hist[:,1] = r2

    for i=1:nsteps
        dh, dr0, dr1, dr2 = compute_derivatives(angle,h,r0,r1,r2)
        h += dh*dt
        r0 += dr0*dt
        r1 += dr1*dt
        r2 += dr2*dt
        t += dt

        hhist[:,i+1] = h
        r0hist[:,i+1] = r0
        r1hist[:,i+1] = r1
        r2hist[:,i+1] = r2

        if norm(r0-h) <= raptor_min_distance ||
            norm(r1-h) <= raptor_min_distance ||
            norm(r2-h) <= raptor_min_distance
            if output
                @printf("The raptors caught the human in %f seconds\n", t)
            end

            # truncate the history
            hhist = hhist[:,1:i+1]
            r0hist = r0hist[:,1:i+1]
            r1hist = r1hist[:,1:i+1]
            r2hist = r2hist[:,1:i+1]

            break
        end
    end
    return hhist, r0hist, r1hist, r2hist
end

angle = pi/4.
simulate_raptors(angle)

function show_raptors(angle; args...)
    hhist, r0hist, r1hist, r2hist = simulate_raptors(angle; args...)
    plot(vec(hhist[1,:]),vec(hhist[2,:]),linewidth=3)
    plot!(vec(r0hist[1,:]),vec(r0hist[2,:]),color=:red)
    plot!(vec(r1hist[1,:]),vec(r1hist[2,:]),color=:red)
    plot!(vec(r2hist[1,:]),vec(r2hist[2,:]),color=:red)
    #plot!(grid=false,xticks=false,yticks=false,legend=false,border=false)
    plot!(legend=false, framestyle=:none)
    plot!(xlim=[-20.,20.],ylim=[-20.,20.])
    annotate!(r0hist[1,1], r0hist[2,1]-1,text("Wounded Raptor",:right,:white))
    annotate!(r1hist[1,1], r1hist[2,1],text("Raptor 1",:right,:white))
    annotate!(r2hist[1,1], r2hist[2,1],text("Raptor 2",:right,:white))
    annotate!(hhist[1,end], hhist[2,end],text("C R U N C H",10,:left,:white))
    title!(@sprintf("Survival time = %f sec",(-1+length(hhist[2,:]))*tmax/nsteps))
end
angle = pi/4
show_raptors(angle)

##
using Interact
ui = button()
settheme!(:nativehtml)
display(ui)

##
mp = @manipulate for θ in 0.0:2π/100:2π
    show_raptors(θ)
end
