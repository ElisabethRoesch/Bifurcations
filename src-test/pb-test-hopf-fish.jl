using DifferentialEquations, ParaBifur, Plots

tester =  collect(2.:0.1:4.)
true_init = [1.,1.,1.]
noises = [0.]
observations = [0.01]
solving_options = [(10.0, 100.0),RK4(),0.1]
# testfish = fish(solving_options, 0., hopf, true_alpha, true_init)
testfish = Vector{Float64}(length(tester))
testfishlog = Vector{Float64}(length(tester))
for i in 1:length(tester)
    temp = fish(solving_options, 0., hopf, [tester[i]], true_init)
    testfish[i]=(temp)
    testfishlog[i]=log(temp)
end

println(testfish,testfishlog)


scatter(tester,testfish, label =" FI")
scatter(tester,testfishlog, label ="log FI")
