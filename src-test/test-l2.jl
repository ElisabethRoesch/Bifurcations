
#(2,3)
z=Vector{Array{Float64,1}}(2)
z[1]=[2]
z[2]=[3]
#(3,5)
y=Vector{Array{Float64,1}}(2)
y[1]=[3]
y[2]=[5]

#method
ParaBifur.euclidean_distance_ode(z,y)

#by hand:
d = 0
for i in 1:length(z)
    d=d+(z[i][1]-y[i][1])^2
end
sqrt(d)

trace([[1,2],[1,2]])
a= Array{Float64,2}(2,2)

a[1,1]=2
a[2,2]=2
a[1,2]=1
a[1,2]=1
a

det(FiniteDiff.hessian(a))

trace(a)

eigfact(a)

maximum(eigvals(a))

results = Array{Array{Float64}}(3,3)
for a in 1:3
    for i in 1:3
        # println(solving_options, noise, bifurcation_id, alphas[a], inits[i])
        results[a,i] = fish(solving_options, noise, bifurcation_id, alphas[a], inits[i])
    end
end

results[1,1] = [[2.,2.] [1,2.]]

results
