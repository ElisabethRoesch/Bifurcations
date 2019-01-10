using DifferentialEquations
using ParaBifur
using PyPlot
using PyCall; @pyimport numpy as np
using PyCall; @pyimport matplotlib.cm as cm
using PyCall; @pyimport matplotlib.mlab as mlab

#analyse_complete_prior(saddle, obs, [0.7], [1.])
#obs = saddle([0.7],(0.0, 10.0), [1.], RK4(),0.01)
#analyse_complete_prior(saddle, obs, [0.7], [1.])
#sols = Array{Float64}(length(test_bifur_params),length(test_x0s))

bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations =
1,1.,2.,1.,2.,1.5,1.5,[0.5],[10]

x=runner([(0.0, 10.0),RK4(),0.01],bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)

step_size_init = abs(stop_init-start_init)/observations[1]
step_size_alpha = abs(stop_alpha-start_alpha)/observations[1]

test_alpha = collect(start_alpha:step_size_alpha:stop_alpha)
test_init = collect(start_init:step_size_init:stop_init)

PyPlot.figure()
PyPlot.contourf(test_alpha,test_init, x[1][1], 20, origin="lower",cmap="RdGy")
PyPlot.plt[:title]("noise level: "*string(noises[1])*" observations: "*string(observations[1]))
PyPlot.plt[:ylabel]("Bifurcation Parameter")
PyPlot.plt[:xlabel]("Initial Conditions")

to_add=Array{Float64,1}(12)
to_add=[-5.0,-4,-3,-2,-1,-0.5,0.5,1,2,3,4,5]
to_add2=[-1,-0.7,-0.5,-0.2,0.2,0.5,0.7,1]
res = Array{Float64,1}(12)
res2 = Array{Float64,1}(8)
for i in 1:length(to_add)
         if (to_add[i]>0)
                  res[i]= log(to_add[i]+1)
             else
                  res[i]= -log(abs(to_add[i]-1))
         end
end

using Plots
Plots.plot(to_add2, res2)
Plots.plot(to_add, res)
a=2




g(x)=1


using Distributions
using Plots
rand(4)


wie = Normal(0,1)
f(du,u,p,t) = (du .= u)
g(du,u,p,t) = (du .= rand(wie))

prob = SDEProblem(f,g,u0,(0.0,1.0))
sol = solve(prob,SRIW1())
plot(sol)







function lorenz(du,u,p,t)
  du[1] = 10.0(u[2]-u[1])
  du[2] = u[1]*(28.0-u[3]) - u[2]
  du[3] = u[1]*u[2] - (8/3)*u[3]
end

function σ_lorenz(du,u,p,t)
  du[1] = 3.0
  du[2] = 3.0
  du[3] = 3.0
end

prob_sde_lorenz = SDEProblem(lorenz,σ_lorenz,[1.0,0.0,0.0],(0.0,10.0))
sol = solve(prob_sde_lorenz)
plot(sol)
