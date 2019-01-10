using DifferentialEquations, ParaBifur, Plots

tester =  collect(2.5:0.1:4.5)
true_init = [1.,1.,1.]
true_alpha =[2.77]
noises = [0.]
observations = [0.01]
solving_options = [(0.0, 10.0),RK4(),1.]
observed_data = hopf(true_alpha,solving_options[1],true_init, solving_options[2],solving_options[3])
ll = Vector{Float64}(length(tester))
for i in 1:length(tester)
    a =[tester[i]]
    temp = analyse_one_combi_codim_three(solving_options, hopf, observed_data, a, true_init, 0.0)
    # if (temp<  (-3.23772e12))
    #     ll[i] =  (-3.23772e12)
    # else
        ll[i]=temp
    # end
end
println("before")
println(ll)

println("after")
tester2 =  collect(2.55:0.1:4.55)
true_alpha2 =[3.77]
observed_data = hopf(true_alpha2,solving_options[1],true_init, solving_options[2],solving_options[3])
ll2 = Vector{Float64}(length(tester2))
for i in 1:length(tester2)
    a =[tester2[i]]
    temp = analyse_one_combi_codim_three(solving_options, hopf, observed_data, a, true_init, 0.0)
    # if (temp< (-3.23772e12))
    #     ll2[i] =  (-3.23772e12)
    # else
        ll2[i]=temp
    # end
end
print(ll2)


scatter(tester,ll,label = "before")
scatter!(tester2,ll2,label = "after")
scatter!(true_alpha,linetype = [:vline],label = "before true")
scatter!(true_alpha2,linetype = [:vline],label = "after true")

savefig("test.png")
