##PLOTS L2!
using DifferentialEquations, ParaBifur, PyPlot

start_init = -2.
stop_init = 2.
start_alpha = -2.
stop_alpha = 2.
# true_init = [0.5]
# true_alpha = [0.6]

true_init = [ -1.,-.6,-.4,-.1,0.,.1,.4,.6,1.]
true_alpha =[-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5]

#true_init = collect(-4:0.2:4)
#true_alpha = collect(-4:0.2:4)
noises = [0.,0.01,0.1,1.]
# noises = [0.0]

observations = [1.]
# observations = [0.01,0.02,0.05,1.0]
solving_options = [(0.0, 10.0),RK4(),0.01]
bifurcations = ["Saddle", "Transcritical", "Super-Pitchfork", "Sub-Pitrchfork"]

results = ([analyse_vary_observations_and_noise_and_true_init_alpha(solving_options,
i, start_init, stop_init, start_alpha, stop_alpha,
true_init, true_alpha, noises, observations,[0.0])for i in 1:4]...)
#
#
results[1][1][1][1][1]

# results = ([analyse_vary_observations_and_noise_and_true_init_alpha(solving_options, i, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations,[0.0])for i in 1:4]...)
#####################################generate ODE data######################################################

for b in 1:length(bifurcations)
       for o in 1:length(observations)
              for n in 1:length(noises)
                     step_size_init = abs(stop_init-start_init)/10
                     step_size_alpha = abs(stop_alpha-start_alpha)/10
                     test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
                     test_init = collect(start_init:step_size_init:stop_init)
                     #PyPlot.figure(figsize=(40, 30))
                     for a in 1:length(true_alpha)
                           for i in 1:length(true_init)
                            #print(test_init)
                            # step_size_init = abs(stop_init-start_init)/observations[o]
                            step_size_alpha = abs(stop_alpha-start_alpha)/10
                            test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
                            # test_init = collect(start_init:step_size_init:stop_init)
                                 pp = results[b][a][i][o][n]'
                                   #f = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/"*string(b)*"_"*string(o)*"_"*string(n)*"_"*string(a)*"_"*string(i)*".csv", "w")
                                   f = open("/project/home17/er4517/public_html/assets/js/ll/"*string(b)*"_"*"4"*"_"*string(n)*"_"*string(a)*"_"*string(i)*".csv", "w")
                                   write(f, string(test_alpha)[2:end-1]*"\n")
                                   # print( string(test_alpha)*"\n")
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
a=3
#############################################OLD STUFF######################################################
#plotting in one pdf: increasing noise and observation for same true values
#length(bifurcations)
# for b in 1:1
#        for a in 1:length(true_alpha)
#               for i in 1:length(true_init)
#                      PyPlot.figure(figsize=(40, 30))
#                      for s in 1:length(observations)
#                             for n in 1:length(noises)
#                                  step_size_init = abs(stop_init-start_init)/10
#                                  step_size_alpha = abs(stop_alpha-start_alpha)/10
#                                  test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
#                                  test_init = collect(start_init:step_size_init:stop_init)
#                                  pp = results[b][a][i][s][n]'
#                                  #subplot(nrows, ncols, index, **kw    step_size_init = abs(stop_init-start_init)/observations[s]
#
#                                  PyPlot.subplot(length(observations),length(noises),(s-1)*(length(noises))+n)
#                                  PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
#                                         cmap="Reds_r")
#                                         #,vmin=0, vmax=100
#                                  PyPlot.colorbar();
#                                  PyPlot.plt[:title]("Noise level: "*string(noises[n])*" Observations: "*string(observations[s]))
#                                  PyPlot.plt[:ylabel]("Initial conditions")
#                                  PyPlot.plt[:xlabel]("Alpha")
#                                  PyPlot.plot([true_alpha[a]], [true_init[i]],"x",markersize=12,color = "yellow")
#                              end
#                      end
#                      #PyPlot.plt[:suptitle]("Likelihood on Saddle bifurcation with increasing noise and observations. True alpha:"*string(true_alpha[a])*", true init:"*string(true_init[i]))
#                      # PyPlot.savefig(bifurcations[b]*string(true_alpha[a])*string(true_init[i])*".pdf")
#               end
#        end
# end




# pp=results[1][1][1][1][1]'
# for x in 1:size(pp)[2]
#        for y in 1:size(pp)[1]
#               if y==size(pp)[1]
#                  print( string(pp[x,y]))
#               else
#                  print( string(pp[x,y])*",")
#               end
#
#        end
#        print("\n")
# end
# size(pp)[1]
#                                  #json_string = json(pp)
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
#########################################################old stuff over#########################################

# #plot fisher
# true_init = collect(-2:.2:2)
# true_alpha = collect(-2:.2:2)
# testfish = ([fish_farm(solving_options,noises[1], i, true_alpha, true_init)for i in 1:4]...)
#
# for b in 1:length(bifurcations)
#        pp = testfish[b]
#        f = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*".csv", "w")
#        write(f, string(true_init)[2:end-1]*"\n")
#        # print( string(test_alpha)*"\n")
#        for x in 1:size(pp)[2]
#               for y in 1:size(pp)[1]
#                      if y==size(pp)[1]
#                             write(f, string(pp[y,x]))
#                             # print(string(pp[x,y]))
#                      else
#                             # print(string(pp[x,y]))
#                             write(f, string(pp[y,x])*",")
#                      end
#               end
#               # print(string("\n"))
#               write(f,"\n")
#        end
#        close(f)
# end
#




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
# using JSON
# for b in 1:length(bifurcations)
#        json_string = json(testfish[b])
#        open(string(b)*"fish.json", "w") do f
#               write(f, json_string)
#             end
# end
#
#
# print(true_init)
