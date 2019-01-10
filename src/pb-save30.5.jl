#mutable struct ana_input
#    bifurcation::function
#    start_init::Float64
#    stop_init::Float64
#    start_alpha::Float64
#    stop_alpha::Float64
##    true_init::Float64
#    true_alpha::Float64
#    noises::AbstractArray{Float64, 1}
#    observations::AbstractArray{Int64, 1}
#end

function add_noise(data, noise_sigma)
    if (noise_sigma>0)
        data+= rand(Normal(0, noise_sigma), length(data))
    end
    return data
end

function euclidean_distance_ode(x1::AbstractArray{<:AbstractArray, 1}, x2::AbstractArray{<:AbstractArray, 1})
    x1 = hcat(x1...)
    x2 = hcat(x2...)
    if (length(x1)==length(x2))
        sum([vecnorm(x1[i, :] - x2[i, :]) for i=1:size(x1, 1)])
    else
        Inf
    end
end



#one data point CHANGE HERE ^2
function analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, bifur_param, x0,sde_noise)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = solving_options[3]
    temp_simulated_data = simulating_function([bifur_param],tspan, [x0], solver,saveat,sde_noise)
    return (-0.5)*euclidean_distance_ode(temp_simulated_data, observed_data_with_noise)^2
end


#one data point CHANGE HERE ^2
function analyse_one_combi_codim_three(solving_options, simulating_function, observed_data, bifur_param, x0,sde_noise)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = solving_options[3]
    a_observed_data = Vector{Array{Float64,1}}(length(observed_data))
    b_observed_data = Vector{Array{Float64,1}}(length(observed_data))
    c_observed_data = Vector{Array{Float64,1}}(length(observed_data))
    for i in 1:length(observed_data)
        a_observed_data[i] = [observed_data[i][1]]
        b_observed_data[i] = [observed_data[i][2]]
        c_observed_data[i] = [observed_data[i][3]]
    end
    temp_simulated_data = simulating_function(bifur_param,tspan, x0, solver,saveat,sde_noise)
    a_temp_simulated_data = Vector{Array{Float64,1}}(length(temp_simulated_data))
    b_temp_simulated_data = Vector{Array{Float64,1}}(length(temp_simulated_data))
    c_temp_simulated_data = Vector{Array{Float64,1}}(length(temp_simulated_data))
    for i in 1:length(temp_simulated_data)
        a_temp_simulated_data[i] = [temp_simulated_data[i][1]]
        b_temp_simulated_data[i] = [temp_simulated_data[i][2]]
        c_temp_simulated_data[i] = [temp_simulated_data[i][3]]
    end
    # all_d = euclidean_distance_ode(a_temp_simulated_data, a_observed_data)+
    # euclidean_distance_ode(b_temp_simulated_data, b_observed_data)+
    # euclidean_distance_ode(c_temp_simulated_data, c_observed_data)

    all_d = euclidean_distance_ode(vcat(a_observed_data,b_observed_data,c_observed_data),
    vcat(a_temp_simulated_data,b_temp_simulated_data,c_temp_simulated_data))
    # return (-0.5)*all_d^2
    return (-0.5)*all_d^2
end


#data for one plot
function analyse_complete_prior(solving_options, simulating_function, observed_data_with_noise, test_bifur_params, test_x0s,sde_noise)
    sol_one_combi = Array{Float64}(length(test_bifur_params),length(test_x0s))

    for i in 1:length(test_bifur_params)
        for j in 1:length(test_x0s)
            sol_one_combi[i,j] = analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, test_bifur_params[i], test_x0s[j],sde_noise)
        end
    end
    return sol_one_combi
end

#give it a noise term, recieve data for one plot
function analyse_ll(solving_options, noise, simulating_function, temp_observed_data, test_bifur_params, test_x0s,sde_noise)
    observed_data_with_noise = add_noise(temp_observed_data, noise)
    one_logl = analyse_complete_prior(solving_options, simulating_function, observed_data_with_noise, test_bifur_params, test_x0s,sde_noise)
end


#give it observation, recieve data for noises.length plots
function analyse_vary_noise(solving_options, true_alpha, true_init, observation, noises, simulating_function, start_init, stop_init, start_alpha, stop_alpha,sde_noise)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = observation
    temp_true_init = [true_init]
    temp_true_alpha = [true_alpha]

    temp_observed_data = simulating_function(temp_true_alpha, tspan, temp_true_init, solver, saveat,sde_noise)

    println("observation ",observation," runs")
    step_size_bifur_param = abs(stop_alpha-start_alpha)/10
    step_size_x0 = abs(stop_init-start_init)/10
    test_bifur_params = collect(start_alpha:step_size_bifur_param:stop_alpha)
    test_x0s = collect(start_init:step_size_x0:stop_init)
    logl_varried_noise = ([analyse_ll(solving_options, noises[i], simulating_function, temp_observed_data, test_bifur_params, test_x0s,sde_noise) for i in 1:length(noises)]...)
end

#give it the truth values for alpha and x0 , recieve data for noise.length plots
function analyse_vary_observations_and_noise(solving_options, true_alpha, true_init, observations, noises, simulating_function, start_init, stop_init, start_alpha, stop_alpha,sde_noise)
    println("true_init ",true_init," runs")
        # print(simulating_function,temp_true_alpha, tspan, temp_true_init, solver, saveat,sde_noise)

    logl_varried_noise_and_obs = ([analyse_vary_noise(solving_options,  true_alpha, true_init, observations[i], noises, simulating_function, start_init, stop_init, start_alpha, stop_alpha,sde_noise) for i in 1:length(observations)]...)
end


#call this function
function analyse_vary_observations_and_noise_and_true_init(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations,sde_noise)
    println("true_alpha ",true_alpha," runs")
    simulating_function = ""
    if (bifurcation_id==1)
        simulating_function = saddle
    elseif(bifurcation_id==2)
        simulating_function = transcritical
    elseif(bifurcation_id==3)
        simulating_function = pitchforksuper
    elseif(bifurcation_id==4)
        simulating_function = pitchforksub
    elseif(bifurcation_id==5)
        simulating_function = sde_wien_saddle
    elseif(bifurcation_id==6)
        simulating_function = sde_wien_transcritical
    elseif(bifurcation_id==7)
        simulating_function = sde_wien_pitchforksuper
    elseif(bifurcation_id==8)
        simulating_function = sde_wien_pitchforksub
    else
        simulating_function = sde_lna_saddle
    end

    logl_varried_noise_and_obs_init = ([analyse_vary_observations_and_noise(solving_options, true_alpha, true_init[i], observations, noises, simulating_function, start_init, stop_init, start_alpha, stop_alpha,sde_noise)for i in 1:length(true_init)]...)
end


function analyse_vary_observations_and_noise_and_true_init_alpha(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations,sde_noise)
    #bifurcation = nothing
    logl_varried_noise_and_obs_init_alpha = ([analyse_vary_observations_and_noise_and_true_init(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha[i], noises, observations,sde_noise)for i in 1:length(true_alpha)]...)
end


function all_sde_ll(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations,sde_noise)
    all_ll = ([analyse_vary_observations_and_noise_and_true_init_alpha(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations,sde_noise[s])for s in 1:length(sde_noise)]...)
end


function get_noisy_obs(solving_options, noise, simulating_function, alpha, init)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = solving_options[3]
    # print(alpha,init,simulating_function)
    observed_data = simulating_function([alpha], tspan, [init], solver, saveat)
    observed_data_with_noise = add_noise(observed_data,noise)
    return observed_data_with_noise
end


function fish(solving_options, noise, simulating_function, alpha, init)
    res=0
    # println(solving_options, noise, simulating_function, alpha, init)
    if simulating_function == hopf
            tspan = solving_options[1]
            solver = solving_options[2]
            saveat = solving_options[3]
            observed_data = simulating_function(alpha, tspan, init, solver, saveat)
            g(x) = analyse_one_combi_codim_three(solving_options, simulating_function, observed_data, [x[1]], init,0.0)
            # res = (FiniteDiff.derivative(g, alpha[1]))^2
            res= -det(FiniteDiff.hessian(g, alpha))
    else
            # print( simulating_function)
            observed_data_with_noise = get_noisy_obs(solving_options, noise, simulating_function, alpha, init)
            f(x) =(1)*analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, x[1], x[2],0.0)
            # res = -det(FiniteDiff.hessian(f, [alpha,init]))
             res = -trace(FiniteDiff.hessian(f, [alpha,init]))
             # res = maximum(eigvals(FiniteDiff.hessian(f, [alpha,init])))
    end
    return res
end

# function fish2(solving_options, noise, simulating_function, alpha, init)
#     observed_data_with_noise = get_noisy_obs(solving_options, noise, simulating_function, alpha, init)
#     f(x) = -analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, x[1], x[2],0.0)
#     return det(FiniteDiff.hessian(f, [alpha,init]))
# end


function fish_farm(solving_options, noise, bifurcation_id, alphas, inits)
    if (bifurcation_id==1)
        bifurcation_id = saddle
    elseif (bifurcation_id==2)
        bifurcation_id = transcritical
    elseif (bifurcation_id==3)
        bifurcation_id = pitchforksuper
    elseif (bifurcation_id==4)
        bifurcation_id = pitchforksub
    elseif (bifurcation_id==5)
        bifurcation_id = sde_wien_saddle
    elseif (bifurcation_id==6)
        bifurcation_id = sde_wien_transcritical
    elseif (bifurcation_id==7)
        bifurcation_id = sde_wien_pitchforksuper
    elseif (bifurcation_id==8)
        bifurcation_id = sde_wien_pitchforksub
    end
    results = Array{Float64}(length(alphas),length(inits))
    for a in 1:length(alphas)
        for i in 1:length(inits)
            # println(solving_options, noise, bifurcation_id, alphas[a], inits[i])
            results[a,i] = fish(solving_options, noise, bifurcation_id, alphas[a], inits[i])
        end
    end
    return results
end

function my_dummy(DATA, urlParams)
    return "it worksssss"*urlParams["name"]
end
