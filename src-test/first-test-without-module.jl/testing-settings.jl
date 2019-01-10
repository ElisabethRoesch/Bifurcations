using PyPlot

true_alphas = [-1.5,0.5,2.5,-1.5,0.5,2.5,-1.5,0.5,2.5]
true_inits = [-1.7,-1.7,-1.7,0.02,0.02,0.02,2.,2.,2.]
PyPlot.figure()
PyPlot.plot(true_alphas,true_inits,"x",markersize=12,color = "red")
PyPlot.plt[:ylabel]("Initial conditions")
PyPlot.plt[:xlabel]("Bifurcation parameter alpha")
PyPlot.plt[:title]("True parameters")
