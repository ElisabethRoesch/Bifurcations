using PyPlot
using PyCall; @pyimport numpy as np
using PyCall; @pyimport matplotlib.cm as cm
using PyCall; @pyimport matplotlib.mlab as mlab

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
