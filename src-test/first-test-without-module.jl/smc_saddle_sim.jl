using ABaCus
using Distances

saddle = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function saddle_2d(t, x, dx)
        dx[1] = params[1]-x[1]*x[1]
        dx[2] = -x[2]
    end
    prob = ODEProblem(saddle_2d, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end





#give the true parameters - this is only valid where the simulated ODE acts as the observed data.
params =  [0.5]
Tspan = (0.0, 10.0)
x0 = [3.0; -10.0]
solver = RK4()
saveat = 0.01

#the below is for simulating observations - in reality the Obs object will be observed data
Obs = saddle(params, Tspan, x0, solver, saveat)
metric = euclidean
n_params = 1
n_particles = 200
threshold_schedule = [3.0, 0.6, 0.08]
priors = [Distributions.Uniform(-1., 5.)]
x = GetDesignPoints(n_particles,priors)

#indices of parameters you want to vary
idx = [1]

#simulates the ODE for the chosen design points
y = ABC_Emulation.get_training_y(saddle,x, params, idx, Obs, Tspan, x0, solver, saveat)


#####################################

sols = saddle([0.5],Tspan, [0.9,0.], solver, saveat)
sols2 = saddle([0.5],Tspan, [-0.6,0.], solver, saveat)
sols3 = saddle([0.5],Tspan, [-0.7,0.], solver, saveat)
sols4 = saddle([0.5],Tspan, [-0.71,0.], solver, saveat, force_dtmin=true)
plot(sols)
plot!(sols2)
plot!(sols3)
plot!(sols4)


#####################################
sigma_n=0.01
y+= rand(Normal(0, sigma_n), n_particles)


#training the emulator - takes the l2 summary statistic , sigma_n - the Gaussian noise you wish to add to the L2 and your design points.
#gpem = GPModel(x, y)
#gp_train(gpem)



function generate_samples(p::AbstractVector)
    result = ABC_Emulation.get_training_y(saddle,p', params, idx, Obs, Tspan, x0, solver, saveat)
    return result
end

#function generate_samples(p::AbstractVector)
#    p=reshape(p,length(p),1)
#    result=gp_regression(p',gpem)[1]
#    return result
#end

reference_samples = generate_samples(params);

smc_input = ABaCus.ABCSMCInput(n_params,
                        n_particles,
                        threshold_schedule,
                        priors,
                        metric,
                        generate_samples,
                        )

@time result = ABaCus.ABCSMC(smc_input,
                      reference_samples)
###
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
