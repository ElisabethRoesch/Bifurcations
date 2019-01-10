using DifferentialEquations, ParaBifur, Plots

tester_1 =  collect(-10:0.5:10)
tester_2 =  collect(-10:0.5:10)
x0 = [3.]
true_params_before =[1.0,1.0]
true_params_after =[5.0,5.0]
observations = [0.01]
solving_options = [(0.0, 100.0),RK4(),0.1]
observed_data = cusp(true_params_after,solving_options[1],true_init, solving_options[2],solving_options[3])
plot(observed_data)
ll = Array{Float64}(length(tester_1),length(tester_2))
for i in 1:length(tester_1)
    for j in 1:length(tester_1)
        temp = analyse_one_combi_2d(solving_options, cusp, observed_data, [tester_1[i],tester_2[j]], x0, 0.)
        ll[i,j]=temp
        print(temp)
    end
end



using PyPlot
PyPlot.figure()
PyPlot.contourf(tester_1, tester_2, ll, 20, origin="lower",cmap="Reds")
PyPlot.colorbar()
PyPlot.plt[:xlabel]("α 1")
PyPlot.plt[:ylabel]("α 2")
PyPlot.plot([true_params_after[1]], [true_params_after[2]],"x",markersize=12,color = "yellow")

println("before")
println(ll)

println("after")
tester2 =  collect(2.55:0.1:4.55)
true_params2 =[3.77,1.0]
observed_data = hopf(true_params2,solving_options[1],true_init, solving_options[2],solving_options[3])
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
scatter!(true_params,linetype = [:vline],label = "before true")
scatter!(true_params2,linetype = [:vline],label = "after true")
