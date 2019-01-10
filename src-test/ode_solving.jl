

using DifferentialEquations, Plots, ParaBifur

true_init = [ -1,-.6,-.4,-.1,0.,.1,.4,.6,1.]
true_alpha =  [-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5]


function get_trajectories(b,a,i)
    bifurcation_id=""
    if (b==1)
        bifurcation_id = saddle
    elseif(b==2)
        bifurcation_id = transcritical
    elseif(b==3)
        bifurcation_id = pitchforksuper
    else(b==4)
        bifurcation_id = pitchforksub
    end
    return go(bifurcation_id,a,i)
end

function go(fu,a,i)
    println(a,i)
    sol = fu([a],(0.,10.),[i],RK4(),1.)
    # print(sol)
    x = Float64[]
    for j in sol
        push!(x,j[1])
    end
    return x
end


for b in 1:4
    for a in 1:length(true_alpha)
        for i in 1:length(true_init)
            f = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/feel_data/"*string(b)*"_"*string(a)*"_"*string(i)*".csv", "w")
            write(f, string(collect(0:10))[2:end-1]*"\n")
            write(f, string(get_trajectories(b,true_alpha[a],true_init[i]))[2:end-1]*"\n")
            #println(string(collect(0:10))[2:end-1]*"\n")
            #println(string(get_trajectories(b,true_alpha[a],true_init[i]))[2:end-1]*"\n")
            close(f)
        end
    end
end
