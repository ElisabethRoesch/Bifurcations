include("../src/LNAfunction.jl")
using DifferentialEquations, ForwardDiff, LNA, Distributions, ParaBifur, PyPlot

start_init = -2.
stop_init = 2.
start_alpha = -2.
stop_alpha = 2.
# true_init = [ -1,-.6,-.4,-.1,0.,.1]
# true_alpha = [-1.5,-.8,-.5,-.2,0.,.2,.5]
# true_init = [ 1.]
# true_alpha = [1.5]
true_init = [ -1,-.6,-.4,-.1,0.,.1,.4,.6,1.]
true_alpha = [-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5]
# noises = [0.]
noises = [0.,0.01,0.1,1.]
# observations = [0.01,0.02,0.05,1.]
# observations = [10,20,50,100]
observations = [0.01]

#solving_options = [(0.0, 10.0),RK4(),0.01]
solving_options = [(0.0, 10.0),EM(),0.01]
#bifurcations = ["Saddle", "Transcritical", "Super-Pitchfork", "Sub-Pitrchfork"]
bifurcations = ["sde_wien_saddle", "sde_wien_transcritical", "sde_wien_pitchforksuper", "sde_wien_pitchforksub"]


# sde_noise = [0.1]
sde_noise = [0.0,0.01,0.1,1.0]
#testfish = ([fish_farm(solving_options,noises[1], i, true_alpha, true_init)for i in 1:4]...)
results_sde = ([all_sde_ll(solving_options, i, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations, sde_noise)for i in 5:8]...)
#print(length(testfish))
results_sde[1][1][1][1][1]
dd
#sol1= analyse_vary_observations_and_noise_and_true_init_alpha(solving_options, 5, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
# using Plots
# meantrajectory= collect(Compat.Iterators.flatten(result))
# sde2= reshape(meantrajectory,1,length(result))
# plot!(time,sde2[1,:],leg=false, c=:blue)
# plot!(time,sde2[2,:], c=:red)
# saveat=0.01
# solver= DifferentialEquations.ImplicitEuler()
# x0 = [diagm([100.0, 50.0]) ; ones(2,2)]
# Mean, Var, times = LNA.LNA_Mean_Var(params,Tspan,x0, solver,saveat,S,make_f,volume)
# trajectory= collect(Compat.Iterators.flatten(Mean))
# sde= reshape(trajectory,2,length(Mean))
# var=[]
# for elt in Var
#     push!(var,diag(elt))
# end
# vartrajectory= collect(Compat.Iterators.flatten(var))
# var= reshape(vartrajectory,2,length(Var))
# figure =plot(time,sde[1,:],ribbon=1.96*sqrt.((var[1,:])/2.0), c=:blue, leg=false)
# plot!(time,sde[2,:],ribbon=1.96*sqrt.((var[2,:])/2.0), c=:red)
##########################################################################################################################################################################################################
#plotting in one pdf: increasing noise and observation for same true values


for b in 1:length(bifurcations)
       # for s in 1:length(sde_noise)
       for o in 1:length(observations)
              for n in 1:length(noises)
                     for a in 1:length(true_alpha)
                            for i in 1:length(true_init)
                                   for s in 1:length(sde_noise)
                                          temp = results_sde[b][s][a][i][o][n]
                                          pp = temp'
                                          # println( "\n",a," and ",i,"\n")
                                          # println(temp)
                                          step_size_init = abs(stop_init-start_init)/10
                                          step_size_alpha = abs(stop_alpha-start_alpha)/10
                                          test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
                                          test_init = collect(start_init:step_size_init:stop_init)
                                          f = open("/project/home17/er4517/public_html/assets/js/ll/"*string(b)*"_"*"1"*"_"*string(n)*"_"*string(a)*"_"*string(i)*"_"*string(s)*".csv", "w")
                                          # print(string(b)*"_"*string(o)*"_"*string(n)*"_"*string(a)*"_"*string(i)*"_"*string(s))
                                          # f = open(string(b)*"_"*string(s)*"_"*string(s)*"_"*string(n)*"_"*string(a)*"_"*string(i)*".csv", "w")
                                          write(f, string(test_alpha)[2:end-1]*"\n")
                                          # println( "\n",a," and ",i,"\n")
                                          for x in 1:size(pp)[2]
                                                 for y in 1:size(pp)[1]
                                                        if y==size(pp)[1]
                                                               write(f, string(pp[x,y]))
                                                                # print(string(pp[x,y]))
                                                        else
                                                               # print(string(pp[x,y]))
                                                               write(f, string(pp[x,y])*",")
                                                        end
                                                 end
                                                 # print(string("\n"))
                                                 write(f,"\n")
                                          end
                                          close(f)
                                   end
                            end
                     end
              end
       end
end

#plotting in one pdf: increasing true_init and true_alpha for noise, obs
# for b in 1:length(bifurcations)
# #for b in 1:1
#        for s in 1:length(observations)
#        #for s in 1:1
#               for n in 1:length(noises)
#               #for n in 1:1
#                      step_size_init = abs(stop_init-start_init)/observations[s]
#                      step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
#                      test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
#                      test_init = collect(start_init:step_size_init:stop_init)
#                      #PyPlot.figure(figsize=(40, 30))
#                      for a in 1:length(true_alpha)
#                      #for a in 1:1
#                            for i in 1:length(true_init)
#                             #for i in 1:1
#                             print(test_init)
#                                  pp = results[b][a][i][s][n]'
#                                  json_string = json(pp)
#                                  #open("/project/home17/er4517/Project_2/Project_Bifur/data/"*string(b)*"_"*string(s)*"_"*string(n)*"_"*string(a)*"_"*string(i)*".json", "w") do f
#                                    #     write(f, json_string)
#                                     #  end
#                                  #subplot(nrows, ncols, index, **kwargs)
#                                  #PyPlot.subplot(length(true_init),length(true_alpha),(i-1)*(length(true_alpha))+a)
#                                  #PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
#                             #            cmap="Reds")
#                                         #vmin=0, vmax=100 (-50 und 0 are alternative values)
#                              #    PyPlot.colorbar();
#                               #   PyPlot.plt[:title]("True init: "*string(true_init[i])*" True alpha: "*string(true_alpha[a]))
#                                #  PyPlot.plt[:ylabel]("Initial conditions")
#                                 # PyPlot.plt[:xlabel]("Alpha")
#                                  #PyPlot.plot([true_alpha[a]], [true_init[i]],"x",markersize=12,color = "yellow")
#                              end
#                      end
#                      #PyPlot.plt[:suptitle]("Likelihood on Saddle bifurcation with increasing init and alpha. Obs:"*string(observations[s])*", noise:"*string(noises[n]))
#                      #PyPlot.plt[:tight_layout]()
#                      #PyPlot.savefig(bifurcations[b]*string(observations[s])*string(noises[n])*".pdf")
#               end
#        end
# end
##################################################################################################

#plot fisher
# PyPlot.figure(figsize=(40, 30))
# for b in 1:length(bifurcations)
#        PyPlot.subplot(440+b)
#        pp=testfish[b]'
#        PyPlot.contourf(true_alpha, true_init,  pp)
#        PyPlot.colorbar();
#        PyPlot.plt[:title](bifurcations[b])
#        PyPlot.plt[:ylabel]("Initial conditions")
#        PyPlot.plt[:xlabel]("Alpha")
# end
#
# PyPlot.savefig("fishtest.svg",transparent=true)
#
#
