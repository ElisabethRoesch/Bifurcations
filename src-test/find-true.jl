alphas = [-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5]

inits = [ -1,-0.6,-.4,-.1,0.,.1,.4,.6,1]

fixpoints = []
fixpoints1 = []
fixpoints2 = []

for a in alphas
    s = sqrt(abs(a))
    #s1 = ((a))
    s2 = -sqrt(abs(a))
    s3 = 0
    push!(fixpoints,s)
    push!(fixpoints1,s3)
    #push!(fixpoints,s1)
    push!(fixpoints2,s2)
end

x1 = unique(sort!(fixpoints))
x1=x1.+0.01
x2 = unique(sort!(fixpoints1))
x2=x2.+0.01
x0 = unique(sort!(fixpoints2))
x0=x0.+0.01

using Plots
Plots.scatter(alphas,zeros(9))

Plots.scatter!(inits,zeros(9))

sqrt(0.4)
