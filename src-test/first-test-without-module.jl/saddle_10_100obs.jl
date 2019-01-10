using DifferentialEquations
using Distributions
using PyPlot
#using PyCall; @pyimport matplotlib
using PyCall; @pyimport numpy as np
using PyCall; @pyimport matplotlib.cm as cm
using PyCall; @pyimport matplotlib.mlab as mlab




function saddle_1d(t, x, dx, bifur_param)
    dx[1] = bifur_param[1]-x[1]*x[1]
end


function ode_simulator(bifur_param,x0)
    prob = ODEProblem((t, x, dx)->saddle_1d(t, x, dx, [bifur_param]), [x0], (0.0, 10.0))
    sol = solve(prob, RK4(), saveat=0.01)
    return sol.u
end

function add_noise(data, noise_sigma)
    data+= rand(Normal(0, noise_sigma), length(data))
    return data
end

function euclidean_distance_ode(x1::AbstractArray{<:AbstractArray, 1}, x2::AbstractArray{<:AbstractArray, 1})
    x1 = hcat(x1...)
    x2 = hcat(x2...)
    if (length(x1)==length(x2))
        sum([vecnorm(x1[i, :] - x2[i, :]) for i=1:size(x1, 1)])
    else
        100
    end

end


#observations
true_bifur_params =[1.,.2]
true_x0s = [0.5,1.]

#influences
noise = [0.01,0.1,1]
testing_precesions = [10,20]
start = -2.
stop = 2.
big_sol=nothing
steps = Array{Float64}(length(testing_precesions))
for t in 1:length(testing_precesions)
    step_size = abs(stop-start)/testing_precesions[t]
    steps[t] = step_size
    test_bifur_params = collect(start:step_size:stop)
    test_x0s = collect(start:step_size:stop)
    sols = Array{Float64}(length(true_bifur_params),length(true_x0s), length(noise),
                      length(test_bifur_params),length(test_x0s))

    #print(size(test_bifur_params))
    for a in 1:length(true_bifur_params)
        for b in 1:length(true_x0s)
            #this are temporary observed data
            temp_obs_sol_u = ode_simulator(true_bifur_params[a], true_x0s[b])
            for n in 1:length(noise)
                noisy_u = add_noise(temp_obs_sol_u, noise[n])
                for i in 1:length(test_bifur_params)
                    for j in 1:length(test_x0s)
                        #temp_sim_sol_u = ode_simulator(test_bifur_params[i], test_x0s[j])
                        temp_sim_sol_u = ode_simulator(test_bifur_params[i], test_x0s[j])
                        sols[a,b,n,i,j] = euclidean_distance_ode(temp_sim_sol_u, noisy_u)
                    end
                end
            end
        end
    end
    big_sol = big_sol, sols
end

PyPlot.figure()
for s in 1:length(steps)
    if (s==1)
        for n in 1:length(noise)
            step_size = steps[s]
            test_bifur_params = collect(start:step_size:stop)
            test_x0s = collect(start:step_size:stop)
            position_bifur_params = collect(0:1:length(test_bifur_params)-1)
            position_test_x0s = collect(0:1:length(test_x0s)-1)

            pp = big_sol[1][2][1,1,n,:,:]
            PyPlot.subplot(330+(n-1)*(length(noise))+s)
            #sns.heatmap(pp)

            PyPlot.contourf(position_bifur_params,position_test_x0s, pp, 20, origin="lower",
                   cmap="RdGy")
            PyPlot.colorbar();
            PyPlot.plt[:title]("noise level: "*string(noise[n])*" observations: "*string(testing_precesions[s]))
            PyPlot.plt[:ylabel]("Bifurcation Parameter")
            PyPlot.plt[:xlabel]("Initial Conditions")
            PyPlot.plt[:yticks](position_bifur_params,test_bifur_params)
            PyPlot.plt[:xticks](position_test_x0s,test_x0s)
        end
    else
        for n in 1:length(noise)
            step_size = steps[s]
            test_bifur_params = collect(start:step_size:stop)
            test_x0s = collect(start:step_size:stop)
            position_bifur_params = collect(0:1:length(test_bifur_params)-1)
            position_test_x0s = collect(0:1:length(test_x0s)-1)

            pp = big_sol[2][1,1,n,:,:]
            PyPlot.subplot(330+(n-1)*(length(noise))+s)
            #sns.heatmap(pp)

            PyPlot.contourf(position_bifur_params,position_test_x0s, pp, 20, origin="lower",
                   cmap="RdGy")
            PyPlot.colorbar();
            PyPlot.plt[:title]("noise level: "*string(noise[n])*" observations: "*string(testing_precesions[s]))
            PyPlot.plt[:ylabel]("Bifurcation Parameter")
            PyPlot.plt[:xlabel]("Initial Conditions")
            PyPlot.plt[:yticks](position_bifur_params[ind],test_bifur_params[ind])
            PyPlot.plt[:xticks](position_test_x0s[ind],test_x0s[ind])
        end
    end
end
PyPlot.plt[:suptitle]("Likelihood on Saddle bifurcation with increasing noise and observations")

all=collect(1:1:110)
ind=all[1:10:100]
