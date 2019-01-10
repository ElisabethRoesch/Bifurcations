module LNA

    using ForwardDiff, DifferentialEquations

    """
    LNAdecomp(params::AbstractArray{Float64,1},Tspan::Tuple{Float64,Float64},
        x0::AbstractArray{Float64}, solver::StochasticDiffEq.StochasticDiffEqAlgorithm,
        dt::Float64,S::AbstractArray{Float64,2},
        make_f::Function, volume::Float64)
    # Arguments
    - params: The parameters of the system/problem
    - Tspan: The time span for which you would like the LNA to be solved for
    - x0: The trajectories initial conditions and the initial conditions of the noise
    - solver: A Stochastic DifferentialEquations solver, for example EM() or ImplicitEM(). ImplicitEM() is slower.
    - dt: As in DifferentialEquations
    - S: Stochoimetry Matrix, to be written and passed by the user.
    - make_f: A function that returns the reaction rates of the problem.
    - volume: Float64 value, representing the volume of the reaction
    # Return
    - LNA: the trajecotries of the LNA. In the same format as the results.u from a DifferentialEquations problem
    - sols.t: time points of the trajectories as a seperate array.
    """
    LNAdecomp = function(params::AbstractArray{Float64,1},Tspan::Tuple{Float64,Float64},
        x0::AbstractArray{Float64}, solver::StochasticDiffEq.StochasticDiffEqAlgorithm,
        dt::Float64,S::AbstractArray{Float64,2},
        make_f::Function, volume::Float64)

        if volume <= 0.0
            throw(ArgumentError("To use LNA please provide a positive volume of the
                reactants"))
        end

        no_of_species, no_of_reactions=size(S)
        function ODE(dx, x, p, t)
            D=ForwardDiff.jacobian(y -> make_f(y, params),x)
            D=D[:,1:no_of_species]
            A=S*D
            dx[1:no_of_species]= S*make_f(x,params)
            dx[no_of_species+1:end]=  A*x[no_of_species+1:no_of_species*2]
        end
        E_null= zeros(no_of_species,no_of_reactions)
        E_full=vcat(E_null, S)
        function SDE(dx, x, p, t)
            for i in 1:no_of_species*2
                for j in 1:no_of_reactions
                    dx[i,j]=(E_full[i,j] * sqrt(abs.(make_f(x,params)[j])))
                end
            end
        end

        prob = SDEProblem(ODE,SDE,x0,Tspan,noise_rate_prototype=zeros(no_of_species*2, no_of_reactions))

        sols=solve(prob, solver,  dt=dt)

        LNA=[]
        for i in 1:length(sols)
            push!(LNA,sols[i][1:no_of_species] + (volume)^(-0.5)*sols[i][no_of_species+1:end])
        end

        return LNA, sols.t


    end

    """
    LNA_Mean_Var(params::AbstractArray{Float64,1},Tspan::Tuple{Float64,Float64},
            x0::AbstractArray{Float64}, solver::DEAlgorithm,
            saveat::Float64, S::AbstractArray{Float64,2},
            make_f::Function, volume::Float64)
    # Arguments
    - params: The parameters of the system/problem
    - Tspan: The time span for which you would like the LNA to be solved for
    - x0: The trajectories initial conditions and the initial conditions of the noise
    - solver: A Ordinary DifferentialEquations solver, for example RK4() or ImplicitEuler()
    - saveat: As in DifferentialEquations
    - S: Stochoimetry Matrix, to be written and passed by the user.
    - make_f: A function that returns the reaction rates of the problem.
    - volume: Float64 value, representing the volume of the reaction
    # Return
    - Mean: The mean trajecotries of the LNA. In the same format as the results.u from a DifferentialEquations problem
    - Var: The covariance of the trajectories at each time point.
    - mean_and_var.t: the array of time points of the Mean and Var (covariance) outputs.
    """

    LNA_Mean_Var = function(params::AbstractArray{Float64,1},Tspan::Tuple{Float64,Float64},
            x0::AbstractArray{Float64}, solver::DEAlgorithm,
            saveat::Float64, S::AbstractArray{Float64,2},
            make_f::Function, volume::Float64)

        if volume <= 0.0
            throw(ArgumentError("To use LNA please provide a positive volume of the
                reactants"))
        end

        no_of_species, no_of_reactions=size(S)

        function Mean_ODE(t,x,dx)
            D=ForwardDiff.jacobian(y -> make_f(y, params), diag(x))
            D=D[:,1:no_of_species]
            A=S*D
            dx[1:no_of_species, 1:no_of_species] = diagm(S*make_f(diag(x),params))
            dx[no_of_species+1:end,1:no_of_species]= A*x[no_of_species+1:no_of_species*2,1:no_of_species] + x[no_of_species+1:no_of_species*2,1:no_of_species]*(A') + (1/volume)*S* diagm(make_f(diag(x),params)) * S'
        end

        prob = ODEProblem(Mean_ODE, x0, Tspan)
        mean_and_var = solve(prob,solver,saveat=saveat)

        Mean=[]
        Var=[]
        for i in 1:length(mean_and_var)
            push!(Mean,diag(mean_and_var[i][1:no_of_species,1:no_of_species]))
            push!(Var,mean_and_var[i][no_of_species+1:end, 1:no_of_species])
        end

        return Mean, Var, mean_and_var.t

    end

    export LNAdecomp, LNA_Mean_Var


end
