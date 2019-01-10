
#concatitation of function works
using ForwardDiff, DifferentialEquations
h(x::Vector) = x+4
g(x::Vector) = h(x)*2
f(x::Vector) = sum(sin, (x[1])) + prod(tan, x[2]) * sum(sqrt, [1]);
x = [1,2]
hess = ForwardDiff.hessian(f, x)


#try structure like anonym works
function h2(s,p1, p2, p3)
    return s[1]*s[1]+p1
end
function g2(x,p1, p2, p3)
    f2(x)=h2(x,p1, p2, p3)
    ForwardDiff.hessian(f2, x)
end
g2([1,2],2,2,3)



#ode in h with one param vary

using ParaBifur
using DifferentialEquations


import FiniteDiff: derivative, second_derivative, gradient, hessian


params=[2.]
function saddle_1d(dx, x, p, t)
    dx[1] = params[1]-x[1]*x[1]
end
prob = ODEProblem(saddle_1d, [1.],(0.,10.))

Obs = solve(prob, RK4(), saveat=0.01).u


function h3(X)
    params =[X[1]]
    init =[X[2]]
    function saddle_temp(dx, x, p, t)
        dx[1] = params[1]-x[1]*x[1]
    end
    prob = ODEProblem(saddle_temp, init,(0.,10.))
    sol = solve(prob, RK4(), saveat=0.01).u
    return euclidean_distance_ode(sol,Obs)
end

p1 = [5.,2.]
f3(X)=h3(X)
det(FiniteDiff.hessian(f3, [2.,1.]))

h3(3.)
h3(2.5)
h3(2.1)
h3(2.0)
h3(1.9)
h3(1.5)
h3(1.0)




using DifferentialEquations
using Plots

function lorenz(du,u,p,t)
 du[1] = 10.0*(u[2]-u[1])
 du[2] = u[1]*(28.0-u[3]) - u[2]
 du[3] = u[1]*u[2] - (8/3)*u[3]
end

u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
prob = ODEProblem(lorenz,u0,tspan)
sol = solve(prob)


plot(sol,vars=(1,2,3))
