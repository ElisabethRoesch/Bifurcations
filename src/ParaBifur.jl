module ParaBifur

	using FiniteDiff, DifferentialEquations, Distributions
	include("pb.jl")
	include("bifurcations.jl")
	export
		#ana_input,
		my_dummy,
		fish_farm,
		fish,
		#add_noise,
		euclidean_distance_ode,
		analyse_one_combi,
		analyse_one_combi_2d,
		analyse_one_combi_codim_three,
		#analyse_complete_prior,
		#analyse_ll,
		#analyse_vary_noise,
		#analyse_vary_observations_and_noise,
		get_noisy_obs,
		analyse_vary_observations_and_noise_and_true_init_alpha,
		saddle,
		transcritical,
		pitchforksuper,
		pitchforksub,
		hopf,
		cusp,
		sde_wien_saddle,
		sde_wien_transcritical,
		sde_wien_pitchforksuper,
		sde_wien_pitchforksub,
		all_sde_ll;
	#using DifferentialEquations, Distributions;

end
