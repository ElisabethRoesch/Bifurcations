using ABaCus
using Distances
using ABCDistances
using ABC_Emulation
using PyPlot
using PyCall; @pyimport seaborn as sns
using DifferentialEquations

transcritical = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("transcritical needs 1 parameter, $(size(params,1)) were provided"))
    end

    function tc(t, x, dx)
        dx[1] = params[1]*x[1]-x[1]*x[1]
    end
    prob = ODEProblem(tc, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end

params =  [-0.2]
Tspan = (0.0, 10.0)
x0 = [0.9]
solver = RK4()
saveat = 0.01
metric = euclidean
n_params = 1
n_particles = 100
threshold_schedule = [3.0, 0.6, 0.08]
#indices of parameters you want to vary
idx = [1]
#the below is for simulating observations - in reality the Obs object will be observed data
transcriticalObs = transcritical(params, Tspan, x0, solver, saveat)
transcriticalPriors = [Distributions.Uniform(0., 5.)]
transcriticalx = ABC_Emulation.GetDesignPoints(n_particles,transcriticalPriors)
function transcritical_generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(transcritical,p', params, idx, transcriticalObs, Tspan, x0, solver, saveat)
    return result
end
transcritical_reference_samples = transcritical_generate_samples(params)
transcritical_smc_input = ABaCus.ABCSMCInput(n_params, n_particles,threshold_schedule,transcriticalPriors,metric,transcritical_generate_samples)
transcritical_result = ABaCus.ABCSMC(transcritical_smc_input, transcritical_reference_samples)


tm02 = [transcritical_result.population[1]';transcritical_result.population[2]';transcritical_result.population[3]']



PyPlot.figure()
z = z01, z02,z03,z04
R=R02,R03,R04,R05
true_values = [0.1,0.2,0.3,0.4]
for j in 1:4
   pp = R[j][:,1]'
   PyPlot.subplot(230+j)
   sns.distplot(pp)
   #PyPlot.plt[:hist](pp,30)
   PyPlot.plt[:xlabel]("true value"*string(true_values[j]))
   #PyPlot.plt[:xlim]([0,0.4])
   #PyPlot.plt[:ylim]([0,160])
end
PyPlot.plt[:suptitle]("ABC SMC on Transcritical bifurcation")

E0=data

string(true_values[1])

c=("a"*"a")
R[2][:,1]'
