##PLOTS L2!


using DifferentialEquations, ParaBifur, PyPlot

start_init = -3.
stop_init = 3.
start_alpha = -2.5
stop_alpha = 2.5
#true_init = [1.]
#true_alpha = [0.5]
true_init = [0.2,0.3,0.4,1.,2.]
true_alpha = [0.2,0.3,0.4,1.,2.]
#true_init = collect(-4:0.2:4)
#true_alpha = collect(-4:0.2:4)
noises = [0.01]
observations = [10]
solving_options = [(0.0, 10.0),RK4(),0.01]
bifurcations = ["Saddle", "Transcritical", "Super-Pitchfork", "Sub-Pitrchfork"]


tspan = solving_options[1]
solver = solving_options[2]
saveat = solving_options[3]


testfish = ([fish_farm(solving_options,noises[1], i, true_alpha, true_init)for i in 1:4]...)
results = ([analyse_vary_observations_and_noise_and_true_init_alpha(solving_options, i, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)for i in 1:4]...)
print(length(testfish))



###################################################################################################
#plotting in one pdf: increasing noise and observation for same true values
#for b in 1:length(bifurcations)
for b in 1:length(bifurcations)
       for a in 1:length(true_alpha)
              for i in 1:length(true_init)
                     PyPlot.figure(figsize=(40, 30))
                     for s in 1:length(observations)
                            for n in 1:length(noises)
                                 step_size_init = abs(stop_init-start_init)/observations[s]
                                 step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
                                 test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
                                 test_init = collect(start_init:step_size_init:stop_init)
                                 pp = results[b][a][i][s][n]'
                                 #subplot(nrows, ncols, index, **kwargs)
                                 PyPlot.subplot(length(observations),length(noises),(s-1)*(length(noises))+n)
                                 PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
                                        cmap="Reds_r",vmin=0, vmax=100)
                                 PyPlot.colorbar();
                                 PyPlot.plt[:title]("Noise level: "*string(noises[n])*" Observations: "*string(observations[s]))
                                 PyPlot.plt[:ylabel]("Initial conditions")
                                 PyPlot.plt[:xlabel]("Alpha")
                                 PyPlot.plot([true_alpha[a]], [true_init[i]],"x",markersize=12,color = "yellow")
                             end
                     end
                     #PyPlot.plt[:suptitle]("Likelihood on Saddle bifurcation with increasing noise and observations. True alpha:"*string(true_alpha[a])*", true init:"*string(true_init[i]))
                     PyPlot.savefig(bifurcations[b]*string(true_alpha[a])*string(true_init[i])*".pdf")
              end
       end
end
#plotting in one pdf: increasing true_init and true_alpha for noise, obs
for b in 1:length(bifurcations)
       for s in 1:length(observations)
              for n in 1:length(noises)
                     step_size_init = abs(stop_init-start_init)/observations[s]
                     step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
                     test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
                     test_init = collect(start_init:step_size_init:stop_init)
                     PyPlot.figure(figsize=(40, 30))
                     for a in 1:length(true_alpha)
                            for i in 1:length(true_init)
                                 pp = results[b][a][i][s][n]'
                                 #subplot(nrows, ncols, index, **kwargs)
                                 PyPlot.subplot(length(true_init),length(true_alpha),(i-1)*(length(true_alpha))+a)
                                 PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
                                        cmap="Reds_r",vmin=0, vmax=100)
                                 PyPlot.colorbar();
                                 PyPlot.plt[:title]("True init: "*string(true_init[i])*" True alpha: "*string(true_alpha[a]))
                                 PyPlot.plt[:ylabel]("Initial conditions")
                                 PyPlot.plt[:xlabel]("Alpha")
                                 PyPlot.plot([true_alpha[a]], [true_init[i]],"x",markersize=12,color = "yellow")
                             end
                     end
                     #PyPlot.plt[:suptitle]("Likelihood on Saddle bifurcation with increasing init and alpha. Obs:"*string(observations[s])*", noise:"*string(noises[n]))
                     PyPlot.plt[:tight_layout]()
                     PyPlot.savefig(bifurcations[b]*string(observations[s])*string(noises[n])*".pdf")
              end
       end
end
##################################################################################################

#plot fisher
PyPlot.figure(figsize=(40, 30))
for b in 1:length(bifurcations)
       PyPlot.subplot(440+b)
       pp=testfish[b]'
       PyPlot.contourf(true_alpha, true_init,  pp)
       PyPlot.colorbar();
       PyPlot.plt[:title](bifurcations[b])
       PyPlot.plt[:ylabel]("Initial conditions")
       PyPlot.plt[:xlabel]("Alpha")
end

PyPlot.savefig("fishtest.svg",transparent=true)


using JSON
for b in 1:length(bifurcations)
       json_string = json(testfish)
       open(string(b)*"fish.json", "w") do f
              write(f, json_string)
            end
end
