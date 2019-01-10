using ABC_Emulation
using DExamples
using Distributions, DifferentialEquations, ABCDistances
using GaussProABC
import Distributions.length, Distributions._rand!, Distributions._pdf


#give the true parameters - this is only valid where the simulated ODE acts as the observed data.
params =  [0.5]

#arguments to be set by the user - best to set them as global arguments as many functions use them
Tspan = (0.0, 10.0)
x0 = [3.0; 2.0]
solver = RK4()
saveat = 0.01

#ODE_simulation is part of the module DExamples - which contains ODE and SDE examples
#the below is for simulating observations - in reality the Obs object will be observed data
Obs = saddle(params, Tspan, x0, solver, saveat)

n_design_points=200
#GetDesignPoints takes the number of design points you wish to create and an array specifying the distribution at which you draw each parameter
x = GetDesignPoints(n_design_points,[Uniform(0,5)])

#indices of parameters you want to vary
idx = [1]

#simulates the ODE for the chosen design points
y = ABC_Emulation.get_training_y(saddle,x, params, idx, Obs, Tspan, x0, solver, saveat)
sigma_n=0.01
y+= rand(Normal(0, sigma_n), n_design_points)

###Sets up the Multivariate Prior as the input for ABCDistances Package
type UniformPrior <: ContinuousMultivariateDistribution
end

function length(d::UniformPrior)
    3
end

function _rand!{T<:Real}(d::UniformPrior, x::AbstractVector{T})
    x=[rand(Uniform(0.0,5.0), 2);rand(Uniform(5.0,25.0), 1)]
end

function _pdf{T<:Real}(d::UniformPrior, x::AbstractVector{T})
    if all((0.0 .<= x[1:2] .<= 5.0)) && (5.0 .<= x[3] .<= 25.0)
        return (1.0/5.0^2)*(1.0/20.0)
    else
        return 0.0
    end
end

#training the emulator - takes the l2 summary statistic , sigma_n - the Gaussian noise you wish to add to the L2 and your design points.
gpem = GPModel(x, y)
gp_train(gpem)

###ABC SMC
using ABaCus

function generate_samples(p::AbstractVector)
    p=reshape(p,length(p),1)
    result=gp_regression(p',gpem)[1]
    return result
end

reference_samples = generate_samples([1.0]);

n_params = 1
n_particles = 200

threshold_schedule = [3.0, 0.6, 0.08]

priors = [Distributions.Uniform(0., 5.)]

using Distances

metric = euclidean

smc_input = ABaCus.ABCSMCInput(n_params,
                        n_particles,
                        threshold_schedule,
                        priors,
                        metric,
                        generate_samples,
                        )

@time result = ABaCus.ABCSMC(smc_input,
                      reference_samples)

using PyCall; @pyimport seaborn as sns

PyPlot.figure()
M = [result.population[1]';result.population[2]';result.population[3]']
for j in 1:1
   pp = M[:,j]'
   PyPlot.subplot(130+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("parameter $j")
end
PyPlot.plt[:suptitle]("ABaCus SMC Algorithm Result")
