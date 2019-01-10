using ParaBifur, DifferentialEquations, PyPlot

start_init = -3.
stop_init = 3.
start_alpha = -2.5
stop_alpha = 2.5
true_init = 2.0
true_alpha = 2.2
noises = [0.01,0.3,0.5,1.0]
observations = [10,20,50]

Saddle = runner([(0.0, 10.0),RK4(),0.01],1, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
Transcritical = runner([(0.0, 10.0),RK4(),0.01],2, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
Superpitchfork = runner([(0.0, 10.0),RK4(),0.01],3, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
Subpitchfork = runner([(0.0, 10.0),RK4(),0.01],4, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)

PyPlot.figure(figsize=(40, 30))
for s in 1:length(observations)
       for n in 1:length(noises)
            step_size_init = abs(stop_init-start_init)/observations[s]
            step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
            test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
            test_init = collect(start_init:step_size_init:stop_init)
            pp = Transcritical[s][n]'
            #subplot(nrows, ncols, index, **kwargs)
            PyPlot.subplot(length(observations),length(noises),(s-1)*(length(noises))+n)
            PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
                   cmap="RdGy",vmin=0, vmax=100)
            PyPlot.colorbar();
            PyPlot.plt[:title]("Noise level: "*string(noises[n])*" Observations: "*string(observations[s]))
            PyPlot.plt[:ylabel]("Initial conditions")
            PyPlot.plt[:xlabel]("Bifurcation parameter alpha")
            PyPlot.plot([true_alpha], [true_init],"x",markersize=12,color = "yellow")
        end
end
PyPlot.plt[:suptitle]("Likelihood on Transcritical bifurcation with increasing noise and observations. True alpha:"*string(true_alpha)*", true init:"*string(true_init))
# Saddle Transcritical Superpitchfork Subpitchfork Hopf
#alpha: 2.2 init: -1.7,0.02,2.0
PyPlot.savefig("2.2_2/Transcritical.pdf")
PyPlot.figure(figsize=(40, 30))
for s in 1:length(observations)
       for n in 1:length(noises)
            step_size_init = abs(stop_init-start_init)/observations[s]
            step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
            test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
            test_init = collect(start_init:step_size_init:stop_init)
            pp = Superpitchfork[s][n]'
            #subplot(nrows, ncols, index, **kwargs)
            PyPlot.subplot(length(observations),length(noises),(s-1)*(length(noises))+n)
            PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
                   cmap="RdGy",vmin=0, vmax=100)
            PyPlot.colorbar();
            PyPlot.plt[:title]("Noise level: "*string(noises[n])*" Observations: "*string(observations[s]))
            PyPlot.plt[:ylabel]("Initial conditions")
            PyPlot.plt[:xlabel]("Bifurcation parameter alpha")
            PyPlot.plot([true_alpha], [true_init],"x",markersize=12,color = "yellow")
        end
end
PyPlot.plt[:suptitle]("Likelihood on Superpitchfork bifurcation with increasing noise and observations. True alpha:"*string(true_alpha)*", true init:"*string(true_init))
PyPlot.savefig("2.2_2/Superpitchfork.pdf")
PyPlot.figure(figsize=(40, 30))
for s in 1:length(observations)
       for n in 1:length(noises)
            step_size_init = abs(stop_init-start_init)/observations[s]
            step_size_alpha = abs(stop_alpha-start_alpha)/observations[s]
            test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
            test_init = collect(start_init:step_size_init:stop_init)
            pp = Subpitchfork[s][n]'
            #subplot(nrows, ncols, index, **kwargs)
            PyPlot.subplot(length(observations),length(noises),(s-1)*(length(noises))+n)
            PyPlot.contourf(test_alpha, test_init, pp, 20, origin="lower",
                   cmap="RdGy",vmin=0, vmax=100)
            PyPlot.colorbar();
            PyPlot.plt[:title]("Noise level: "*string(noises[n])*" Observations: "*string(observations[s]))
            PyPlot.plt[:ylabel]("Initial conditions")
            PyPlot.plt[:xlabel]("Bifurcation parameter alpha")
            PyPlot.plot([true_alpha], [true_init],"x",markersize=12,color = "yellow")
        end
end
PyPlot.plt[:suptitle]("Likelihood on Subpitchfork bifurcation with increasing noise and observations. True alpha:"*string(true_alpha)*", true init:"*string(true_init))
PyPlot.savefig("2.2_2/Subpitchfork.pdf")
