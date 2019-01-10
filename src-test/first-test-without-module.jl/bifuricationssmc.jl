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
# 2λy(t) − y (t).
transcritical = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function tc(t, x, dx)
        dx[1] = params[1]*x[1]-x[1]*x[1]
    end
    prob = ODEProblem(tc, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end

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
pitchforksub = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function pfsub(t, x, dx)
        dx[1] = params[1]*x[1]+x[1]*x[1]*x[1]
    end
    prob = ODEProblem(pfsub, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end

#give the true parameters - this is only valid where the simulated ODE acts as the observed data.
params =  [0.1]
subparams =  [-0.2]
Tspan = (0.0, 10.0)
x0 = [0.9]
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
transcriticalObs = transcritical(params, Tspan, x0, solver, saveat)
pitchforksuperObs = pitchforksuper(params, Tspan, x0, solver, saveat)
pitchforksubObs = pitchforksub(subparams, Tspan, x0, solver, saveat)

saddlePriors = [Distributions.Uniform(0., 5.)]
transcriticalPriors = [Distributions.Uniform(-2.5, 2.5)]
pitchforksuperPriors = [Distributions.Uniform(-2.5, 2.5)]
pitchforksubPriors = [Distributions.Uniform(-5., 0.)]

saddlex = GetDesignPoints(n_particles,saddlePriors)
transcriticalx = GetDesignPoints(n_particles,transcriticalPriors)
pitchforksuperx = GetDesignPoints(n_particles,pitchforksuperPriors)
pitchforksubx = GetDesignPoints(n_particles,pitchforksubPriors)


#training the emulator - takes the l2 summary statistic , sigma_n - the Gaussian noise you wish to add to the L2 and your design points.
#y = ABC_Emulation.get_training_y(saddle,x, params, idx, Obs, Tspan, x0, solver, saveat)
#sigma_n=0.01
#y+= rand(Normal(0, sigma_n), n_particles)
#function generate_samples(p::AbstractVector)
#    p=reshape(p,length(p),1)
#    result=gp_regression(p',gpem)[1]
#    return result
#end
#gpem = GPModel(x, y)
#gp_train(gpem)

#Simulator
function saddle_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(saddle,p', params, idx, saddleObs, Tspan, x0, solver, saveat)
    return result
end
function transcritical_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(transcritical,p', params, idx, transcriticalObs, Tspan, x0, solver, saveat)
    return result
end
function pitchforksuper_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(pitchforksuper,p', params, idx, pitchforksuperObs, Tspan, x0, solver, saveat)
    return result
end
function pitchforksub_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(pitchforksub,p', subparams, idx, pitchforksubObs, Tspan, x0, solver, saveat)
    return result
end


saddle_reference_samples = saddle_generate_samples(params)
transcritical_reference_samples = saddle_generate_samples(params)
pitchforksuper_reference_samples = pitchforksuper_generate_samples(params)
pitchforksub_reference_samples = pitchforksub_generate_samples(subparams)

saddle_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,saddlePriors,metric,saddle_generate_samples)
transcritical_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,transcriticalPriors,metric,transcritical_generate_samples)
pitchforksuper_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,pitchforksuperPriors,metric,pitchforksuper_generate_samples)
pitchforksub_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,pitchforksubPriors,metric,pitchforksub_generate_samples)

@time saddle_result = ABaCus.ABCSMC(saddle_smc_input, saddle_reference_samples)
@time transcritical_result = ABaCus.ABCSMC(transcritical_smc_input, transcritical_reference_samples)
@time pitchforksuper_result = ABaCus.ABCSMC(pitchforksuper_smc_input, pitchforksuper_reference_samples)
@time pitchforksub_result = ABaCus.ABCSMC(pitchforksub_smc_input, pitchforksub_reference_samples)


PyPlot.figure()
M = [saddle_result.population[1]';saddle_result.population[2]';saddle_result.population[3]']
for j in 1:1
   pp = M[:,j]'
   PyPlot.subplot(130+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("parameter $j")
end
PyPlot.plt[:suptitle]("ABC SMC: Saddle")

PyPlot.figure()
M = [transcritical_result.population[1]';transcritical_result.population[2]';transcritical_result.population[3]']
for j in 1:1
   pp = M[:,j]'
   PyPlot.subplot(130+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("parameter $j")
end
PyPlot.plt[:suptitle]("ABC SMC: Transcritical")

PyPlot.figure()
M = [pitchforksuper_result.population[1]';pitchforksuper_result.population[2]';pitchforksuper_result.population[3]']
for j in 1:1
   pp = M[:,j]'
   PyPlot.subplot(130+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("parameter $j")
end
PyPlot.plt[:suptitle]("ABC SMC: Pitchfork Super")

PyPlot.figure()
M = [pitchforksub_result.population[1]';pitchforksub_result.population[2]';pitchforksub_result.population[3]']
for j in 1:1
   pp = M[:,j]'
   PyPlot.subplot(130+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("parameter $j")
end
PyPlot.plt[:suptitle]("ABC SMC: Pitchfork Sub")
