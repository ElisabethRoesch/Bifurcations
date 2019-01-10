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
    data+= rand(Normal(0, noise_sigma), length(data))
    return data
end

function euclidean_distance_ode(x1::AbstractArray{<:AbstractArray, 1}, x2::AbstractArray{<:AbstractArray, 1})
    x1 = hcat(x1...)
    x2 = hcat(x2...)
    if (length(x1)==length(x2))
        sum([vecnorm(x1[i, :] - x2[i, :]) for i=1:size(x1, 1)])
    else
        100
    end
end


#one data point
function analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, bifur_param, test_x0)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = solving_options[3]
    temp_simulated_data = simulating_function([bifur_param],tspan, [test_x0], solver,saveat)
    return euclidean_distance_ode(temp_simulated_data, observed_data_with_noise)
end

#data for one plot
function analyse_complete_prior(solving_options, simulating_function, observed_data_with_noise, test_bifur_params, test_x0s)
    sol_one_combi = Array{Float64}(length(test_bifur_params),length(test_x0s))
    for i in 1:length(test_bifur_params)
        for j in 1:length(test_x0s)
            sol_one_combi[i,j] = analyse_one_combi(solving_options, simulating_function, observed_data_with_noise, test_bifur_params[i], test_x0s[j])
        end
    end
    return sol_one_combi
end

#give it a noise term, recieve data for one plot
function analyse_ll(solving_options, noise, simulating_function, temp_observed_data, test_bifur_params, test_x0s)
    observed_data_with_noise = add_noise(temp_observed_data, noise)
    one_logl = analyse_complete_prior(solving_options, simulating_function, observed_data_with_noise, test_bifur_params, test_x0s)
end


#give it observation, recieve data for noises.length plots
function analyse_vary_noise(solving_options, observation, noises, simulating_function, temp_observed_data, start_init, stop_init, start_alpha, stop_alpha)
    step_size_bifur_param = abs(stop_alpha-start_alpha)/observation
    step_size_x0 = abs(stop_init-start_init)/observation
    test_bifur_params = collect(start_alpha:step_size_bifur_param:stop_alpha)
    test_x0s = collect(start_init:step_size_x0:stop_init)
    logl_varried_noise = ([analyse_ll(solving_options, noises[i], simulating_function, temp_observed_data, test_bifur_params, test_x0s) for i in 1:length(noises)]...)
end

#give it the truth values for alpha and x0 , recieve data for noise.length plots
function analyse_vary_observations_and_noise(solving_options, true_alpha, true_init, observations, noises, simulating_function, start_init, stop_init, start_alpha, stop_alpha)
    tspan = solving_options[1]
    solver = solving_options[2]
    saveat = solving_options[3]
    temp_observed_data = simulating_function([true_alpha],tspan, [true_init], solver, saveat)
    logl_varried_noise_and_obs = ([analyse_vary_noise(solving_options, observations[i], noises, simulating_function, temp_observed_data, start_init, stop_init, start_alpha, stop_alpha) for i in 1:length(observations)]...)
end


#call this function
function runner(solving_options, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
    #bifurcation = nothing
    if (bifurcation_id==1)
        bifurcation_id = saddle
    elseif(bifurcation_id==2)
        bifurcation_id = transcritical
    elseif(bifurcation_id==3)
        bifurcation_id = pitchforksuper
    elseif(bifurcation_id==4)
        print("ja")
        bifurcation_id = pitchforksub
    else(bifurcation_id==5)
        bifurcation_id = hopf
    end

    #ana_in = ana_input(saddle, start_init, stop_init, start_alpha, stop_alpha, true_init, true_alpha, noises, observations)
    logl_varried_noise_and_obs = analyse_vary_observations_and_noise(solving_options, true_alpha, true_init, observations, noises, bifurcation_id, start_init, stop_init, start_alpha, stop_alpha)
end
