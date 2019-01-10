using ABaCus
using Distances
using ABCDistances
using ABC_Emulation
using PyPlot
using PyCall; @pyimport seaborn as sns
using DifferentialEquations

pitchforksuper = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function pfsuper(t, x, dx)
        dx[1] = params[1]*x[1]-x[1]*x[1]*x[1]
    end
    prob = ODEProblem(pfsuper, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end

params =  [0.4]
Tspan = (0.0, 10.0)
x0 = [0.2]
solver = RK4()
saveat = 0.01
metric = euclidean
n_params = 1
n_particles = 200
threshold_schedule = [3.0, 0.6, 0.08]
#indices of parameters you want to vary
idx = [1]
#the below is for simulating observations - in reality the Obs object will be observed data
pitchforksuperObs = saddle(params, Tspan, x0, solver, saveat)
pitchforksuperPriors = [Distributions.Uniform(0., 5.)]
pitchforksuperx = GetDesignPoints(n_particles,pitchforksuperPriors)
function pitchforksuper_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(pitchforksuper,p', params, idx, pitchforksuperObs, Tspan, x0, solver, saveat)
    return result
end
pitchforksuper_reference_samples = pitchforksuper_generate_samples(params)
pitchforksuper_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,pitchforksuperPriors,metric,pitchforksuper_generate_samples)
@time pitchforksuper_result = ABaCus.ABCSMC(pitchforksuper_smc_input, pitchforksuper_reference_samples)

M04 = [pitchforksuper_result.population[1]';pitchforksuper_result.population[2]';pitchforksuper_result.population[3]']




PyPlot.figure()
M = M0,M01,M02,M03,M04
true_values = [0.0,0.1,0.2,0.3,0.4]
for j in 1:5
   pp = M[j][:,1]'
   PyPlot.subplot(230+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("true value"*string(true_values[j]))
   PyPlot.plt[:xlim]([0,0.6])
   PyPlot.plt[:ylim]([0,70])
end
PyPlot.plt[:suptitle]("ABC SMC on Pitchfork (super) bifurcation")
