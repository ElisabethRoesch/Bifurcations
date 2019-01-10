saddle = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise = .0)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function saddle_1d(dx, x, p, t)
        dx[1] = params[1]-x[1]*x[1]
    end
    prob = ODEProblem(saddle_1d, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs.u
end


transcritical = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise= .0)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function tc(dx, x, p, t)
        dx[1] = params[1]*x[1]-x[1]*x[1]
    end
    prob = ODEProblem(tc, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs.u
end

pitchforksuper = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise= .0)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end

    function pfsuper(dx, x, p, t)
        dx[1] = params[1]*x[1]-x[1]*x[1]*x[1]
    end
    prob = ODEProblem(pfsuper, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs.u
end

pitchforksub = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise= .0)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function pfsub(dx, x, p, t)
        dx[1] = params[1]*x[1]+x[1]*x[1]*x[1]
    end
    prob = ODEProblem(pfsub, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs.u
end

cusp = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise= .0)
    if size(params,1) != 2
        throw(ArgumentError("cusp needs 2 parameter, $(size(params,1)) were provided"))
    end
    print(params,x0)
    function cusp1d(dx, x, p, t)
        dx[1] = (-1)*x[1]*x[1]*x[1]+params[1]*x[1]+params[2]
    end
    prob = ODEProblem(cusp1d, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs.u
end



hopf = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::OrdinaryDiffEq.OrdinaryDiffEqAlgorithm, saveat::Float64,sde_noise= .0)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    k4 =1.
    k2 =1.
    k3=1.
    k5=1.

    function hopf(dx, x, p, t)
        dx[1] = (params[1]-k4)*x[1]    -k2*x[1]*x[2]
        dx[2] = -k3*x[2]+k5*x[3]
        dx[3] = k4*x[1]-k5*x[3]
    end
    prob = ODEProblem(hopf, x0 ,Tspan)
    Obs = solve(prob, solver, saveat=saveat)
    return Obs
end




sde_wien_saddle = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64,sde_noise)
    # println(params, Tspan, x0, solver, saveat, sde_noise)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function saddle_1d_f(dx, x, p, t)
        dx[1] = params[1]-x[1]*x[1]
    end
    function saddle_1d_g(dx, x, p, t)
        dx[1] =sqrt(abs(params[1]-x[1]*x[1]))*sde_noise
    end
    W = WienerProcess(0.0,0.0,0.0)
    prob = SDEProblem(saddle_1d_f, saddle_1d_g, x0, Tspan, noise = W)

    Obs = solve(prob, solver,dt=saveat)
    return Obs.u
end


sde_wien_transcritical = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64,sde_noise)

    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function tc_f(dx, x, p, t)
        dx[1] = params[1]*x[1]-x[1]*x[1]
    end
    function tc_g(dx, x, p, t)
        dx[1] = sqrt(abs(params[1]*x[1]-x[1]*x[1]))*sde_noise
    end
    W = WienerProcess(0.0,0.0,0.0)
    prob = SDEProblem(tc_f, tc_g, x0, Tspan, noise = W)
    Obs = solve(prob, solver, dt=saveat)
    return Obs.u
end

sde_wien_pitchforksuper = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64,sde_noise)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function pfsuper_f(dx, x, p, t)
        dx[1] = params[1]*x[1]-x[1]*x[1]*x[1]
    end
    function pfsuper_g(dx, x, p, t)
        dx[1] = sqrt(abs(params[1]*x[1]-x[1]*x[1]*x[1]))*sde_noise
    end
    W = WienerProcess(0.0,0.0,0.0)
    prob = SDEProblem(pfsuper_f, pfsuper_g, x0, Tspan, noise = W)
    Obs = solve(prob, solver, dt=saveat)
    return Obs.u
end

sde_wien_pitchforksub = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
    solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64,sde_noise)
    if size(params,1) != 1
        throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
    end
    function pfsub_f(dx, x, p, t)
        dx[1] = params[1]*x[1]+x[1]*x[1]*x[1]
    end
    function pfsub_g(dx, x, p, t)
        dx[1] = sqrt(abs(params[1]*x[1]+x[1]*x[1]*x[1]))*sde_noise
    end
    W = WienerProcess(0.0,0.0,0.0)
    prob = SDEProblem(pfsub_f, pfsub_g, x0, Tspan, noise = W)
    Obs = solve(prob, solver, dt=saveat)
    return Obs.u
end





sde_lna_saddle = function(params::AbstractArray{Float64,1},
    Tspan::Tuple{Float64,Float64}, x0_old::AbstractArray{Float64,1},
    solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64,stoch_noise_level=10000.0)
    #this is alpha
    #params = [2.0]
    x0 = [x0_old[1];1.]
    #Tspan = (0.0,10.0)
    volume = stoch_noise_level
    solver = DifferentialEquations.ImplicitEM()
    dt=saveat
    S=[1. -1.]
    make_f = function(x,p)
        f=[ p[1],
            x[1]*x[1]]
        return f
    end
    result,time=LNA.LNAdecomp(params,Tspan,x0, solver,dt,S,make_f, volume)
    x = Float64[]
    for j in result
        push!(x,j[1])
    end
    return x
end













# sde_diag_saddle = function(params::AbstractArray{Float64,1},
#     Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
#     solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64)
#     if size(params,1) != 1
#         throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
#     end
#     function saddle_1d_f(dx, x, p, t)
#         dx[1] = params[1]-x[1]*x[1]
#     end
#     function saddle_1d_g(dx, x, p, t)
#         dx[1] = 0.01
#     end
#     prob = SDEProblem(saddle_1d_f, saddle_1d_g, x0, Tspan)
#
#     Obs = solve(prob, solver)
#     return Obs.u
# end
#
#
# #takes ages
# sde_intu_saddle = function(params::AbstractArray{Float64,1},
#     Tspan::Tuple{Float64,Float64}, x0::AbstractArray{Float64,1},
#     solver::StochasticDiffEq.StochasticDiffEqAlgorithm, saveat::Float64)
#     if size(params,1) != 1
#         throw(ArgumentError("saddle needs 1 parameter, $(size(params,1)) were provided"))
#     end
#     wie = Normal(0,1)
#     function saddle_1d_f(dx, x, p, t)
#         dx[1] = params[1]-x[1]*x[1]
#     end
#     function saddle_1d_g(dx, x, p, t)
#         dx[1] = rand(wie)
#     end
#     prob = SDEProblem(saddle_1d_f, saddle_1d_g, x0, Tspan)
#     Obs = solve(prob, solver)
#     return Obs.u
# end
