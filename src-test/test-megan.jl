using Plots

results = rand(10,10)
bool_results =zeros(10,10)


for i in 1:size(results)[1]
    for j in 1:size(results)[2]
        if results[i,j] <.5
            bool_results[i,j] = 1.
        end
    end
end

x=collect(1.:1.:10)
y=collect(1.:1.:10)
Plots.scatter(x,y,bool_results)
