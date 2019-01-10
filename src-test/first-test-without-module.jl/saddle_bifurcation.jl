using ABaCus
using Distances
using ABCDistances
using ABC_Emulation
using PyPlot
using PyCall; @pyimport seaborn as sns
using DifferentialEquations

saddle = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function saddle_1d(t, x, dx)
        dx[1] = params[1]-x[1]*x[1]
    end
    prob = ODEProblem(saddle_1d, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end
params =  [0.3]
subparams =  [-0.2]
Tspan = (0.0, 10.0)
x0 = [0.1]
solver = RK4()
saveat = 0.01
metric = euclidean
n_params = 1
n_particles = 200
threshold_schedule = [3.0, 0.6, 0.08]
#indices of parameters you want to vary
idx = [1]
#the below is for simulating observations - in reality the Obs object will be observed data
saddleObs = saddle(params, Tspan, x0, solver, saveat)
saddlePriors = [Distributions.Uniform(0., 5.)]
saddlex = GetDesignPoints(n_particles,saddlePriors)
function saddle_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(saddle,p', params, idx, saddleObs, Tspan, x0, solver, saveat)
    return result
end
saddle_reference_samples = saddle_generate_samples(params)
saddle_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,saddlePriors,metric,saddle_generate_samples)
@time saddle_result = ABaCus.ABCSMC(saddle_smc_input, saddle_reference_samples)

M03 = [saddle_result.population[1]';saddle_result.population[2]';saddle_result.population[3]']




PyPlot.figure()
M = M0,M01,M02,M03
true_values = [0.0,0.1,0.2,0.3]
for j in 1:4
   pp = M[j][:,1]'
   PyPlot.subplot(230+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("true value"*string(true_values[j]))
   PyPlot.plt[:xlim]([0,0.4])
   PyPlot.plt[:ylim]([0,160])
end
PyPlot.plt[:suptitle]("ABC SMC on Saddle bifurcation")


string(true_values[1])

c=("a"*"a")
