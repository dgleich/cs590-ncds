## Solve the first linear system
x,y,z = [0 1/2 1/4; 1 1 2; 2 1 1.5] \ [ 2,6,7]
## Solve the reduced carbs linear system
x,y,z = [0 1/2 1/4; 1 1 2; 2 1 1.5] \ [ 2.5,6.5,5]
## Solve the LP
using JuMP
using Clp
##
model = Model(with_optimizer(Clp.Optimizer))
@variable(model, 0 <= x)
@variable(model, 0 <= y)
@variable(model, 0 <= z)
@objective(model, Min, x+y+z)
@constraint(model,
  [0 1/2 1/4; 1 1 2; 1 1 1.5]*[x,y,z] .>= [2.5,6.5,5])
optimize!(model)
##
value(x), value(y), value(z)
