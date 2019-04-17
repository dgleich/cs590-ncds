## Simple diet demo for real.

using DataFrames
using CSV
using JuMP
using Clp

## These are very simple codes
function from_csv(filename)
    #=
    Given the name of a csv file whose first line are headers,
    return a list of dictionaries, one for each row of the file,
    whose keys are the header for that column.
    =#
    content = CSV.read(filename)
    headers = names(content)

    m = size(content)[1]
    table = []
    for i = 1 : m
        line = content[i,:]
        push!(table, Dict(zip(headers, line)))
    end
    return table
end


function clean_up_dict(dict)
    #=
    Given dictionary, clean up the dict (set Missing data to be 0.0)
    =#
    for pair in dict
        if typeof(pair[2]) == Missing
            dict[pair[1]] = 0.0
        end
    end
    return dict
end
function clean_up_table(table)
    #=
    Given table, clean up the table (set Missing data to be 0.0)
    =#
    m = size(table)[1]
    for i = 1 : m
        clean_up_dict(table[i])
    end
end


function create_variable_dict(table)
    #=
    mapping the food_name with variables
    =#
    m = size(table)[1]
    variable_dict = Dict()
    @variable(myModel, 0 <= x[1:m] <= 10)
    for i = 1 : m
        variable_dict[table[i][:description]] = x[i]
    end
    return variable_dict
end


function foods_for_nutrient(nutrient_name)
    #=
    Get the nutrient_amount for variables
    =#
    nutrients_list = []
    var_list = []
    for row in nutrients_table
        var = variable_dict[row[:description]]
        nutrient_amount = row[Symbol(nutrient_name)]
        if nutrient_amount > 0
            push!(nutrients_list, nutrient_amount)
            push!(var_list, var)
        end
    end
    return nutrients_list, var_list
end


function create_percent_constraint(nutrient_name, lower, upper, calories_per_gram)
    #=
    Compute the constraint that says the total consumed nutrient
    must be between 'lower' and 'upper' percent of the total calories.
    =#
    calories_lower_list, var_calories_lower = foods_for_nutrient(calories_name)
    calories_upper_list, var_calories_upper = foods_for_nutrient(calories_name)
    nutrient_list, var_nutrient_list = foods_for_nutrient(nutrient_name)
    m = size(calories_lower_list)[1]
    n = size(calories_upper_list)[1]
    t = size(nutrient_list)[1]

    @constraint(myModel, sum(calories_lower_list[j] * var_calories_lower[j] * lower/100.0 for j = 1 : m ) <= sum(nutrient_list[i] * var_nutrient_list[i] * calories_per_gram for i = 1 : t))
    @constraint(myModel, sum(nutrient_list[i] * var_nutrient_list[i] * calories_per_gram for i = 1 : t) <= sum(calories_upper_list[j] * var_calories_upper[j] * upper/100.0 for j = 1 : n ))
end


function create_constraint(nutrient_name, lower, upper)
    #=
     Each constraint is a lower and upper bound on the
     sum of all food variables, scaled by how much of the
     relevant nutrient is in that food.
    =#
    if lower == 0.0
        return
    end
    if haskey(percent_constraints, nutrient_name)
        calories_per_gram = percent_constraints[nutrient_name]["calories_per_gram"]
        create_percent_constraint(nutrient_name, lower, upper, calories_per_gram)
        return
    end


    foods_list, var_foods = foods_for_nutrient(nutrient_name)
    m = size(foods_list)[1]
    @constraint(myModel, lower <= sum(foods_list[i] * var_foods[i] for i = 1:m))

    if upper == 0.0
        return
    end
    @constraint(myModel, sum(foods_list[i] * var_foods[i] for i = 1:m) <= upper)

end


function create_constraints(table)
    #=
    Create constraints
    =#
    constraint_bounds = Dict()
    for row in table
        nutrient = row[:nutrient]
        lower_bound = row[:lower_bound]
        upper_bound = row[:upper_bound]
        constraint_bounds[nutrient] = (lower_bound, upper_bound)
        create_constraint(nutrient, lower_bound, upper_bound)
    end
    return constraint_bounds
end


#MODEL CONSTRUCTION
#------------------------------------------------------------------------------------------

myModel = Model(with_optimizer(Clp.Optimizer))
# solver=GLPKsolverLP() means that to solve the optimization problem we will use GLPK solver.

calories_name = "energy (kcal)"

nutrients_table = from_csv("nutrients-kun.csv")
constraints_table = from_csv("diet-kun.csv")

clean_up_table(nutrients_table)
clean_up_table(constraints_table)

# next step is to create_variable_dict()
variable_dict = create_variable_dict(nutrients_table)

#next is to create constraints
percent_constraints = Dict("total fat (g)"=> Dict("calories_per_gram"=> 9))
constraint_bounds = create_constraints(constraints_table)

# now create objective
var_list = []
calories_list = []
for row in nutrients_table
    name = row[:description]
    var = variable_dict[name]
    push!(var_list, var)
    calories_in_food = row[Symbol(calories_name)]
    push!(calories_list, calories_in_food)
end
num = size(var_list)[1]
@objective(myModel, Min, sum(var_list[i] * calories_list[i] for i = 1:num))

# Solve it!
optimize!(myModel)

##
for item in keys(variable_dict)
    var = variable_dict[item]
    println(item, ";", value(var))
end
