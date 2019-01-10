using DifferentialEquations, ParaBifur, PyPlot
start_init = -2.
stop_init = 2.
start_alpha = -2.
stop_alpha = 2.
solving_options = [(0.0, 100.0),RK4(),0.1]
bifurcations = ["Saddle", "Transcritical", "Super-Pitchfork", "Sub-Pitrchfork"]
true_init = collect(-2:0.1:2)
true_alpha = collect(-3:0.1:3)
print(true_alpha)
testfish = ([fish_farm(solving_options,0., i, true_alpha, true_init)for i in 1:4]...)






for b in 1:length(bifurcations)
       f1 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_1.csv", "w")
       f2 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_2.csv", "w")
       f3 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_3.csv", "w")
       f4 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_4.csv", "w")
       f5 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_5.csv", "w")
       f6 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_6.csv", "w")
       f7 = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*"_7.csv", "w")
       write(f1, string(true_init)[2:end-1]*"\n")
       write(f2, string(true_init)[2:end-1]*"\n")
       write(f3, string(true_init)[2:end-1]*"\n")
       write(f4, string(true_init)[2:end-1]*"\n")
       write(f5, string(true_init)[2:end-1]*"\n")
       write(f6, string(true_init)[2:end-1]*"\n")
       write(f7, string(true_init)[2:end-1]*"\n")

       pp = testfish[b]
       alpha_var = Array{Float64}(size(pp)[1],size(pp)[2])
       init_var = Array{Float64}(size(pp)[1],size(pp)[2])
       co_var = Array{Float64}(size(pp)[1],size(pp)[2])
       dets = Array{Float64}(size(pp)[1],size(pp)[2])
       traces = Array{Float64}(size(pp)[1],size(pp)[2])
       eigen = Array{Float64}(size(pp)[1],size(pp)[2])
       jess = Array{Float64}(size(pp)[1],size(pp)[2])
       for x in 1:size(pp)[1]
              for y in 1:size(pp)[2]
                     temp_hess = pp[x,y]
                     alpha_var[x,y] = -(temp_hess[1,1])
                     init_var[x,y] = -(temp_hess[2,2])
                     co_var[x,y] = -(temp_hess[1,2])
                     dets[x,y] = -det(temp_hess)
                     traces[x,y] = -trace(temp_hess)
                     if any(isnan,temp_hess)==false
                            eigen[x,y] = maximum(eigvals(temp_hess))
                     else
                            eigen[x,y] = NaN
                     end
                     jess[x,y] = 0.5*abs(det(temp_hess))
                     if y==size(pp)[1]
                            write(f1, string(dets[x,y]))
                            write(f2, string(traces[x,y]))
                            write(f3, string(eigen[x,y]))
                            write(f4, string(jess[x,y]))
                            write(f5, string(alpha_var[x,y]))
                            write(f6, string(init_var[x,y]))
                            write(f7, string(co_var[x,y]))
                     else
                            write(f1, string(dets[x,y])*",")
                            write(f2, string(traces[x,y])*",")
                            write(f3, string(eigen[x,y])*",")
                            write(f4, string(jess[x,y])*",")
                            write(f5, string(alpha_var[x,y])*",")
                            write(f6, string(init_var[x,y])*",")
                            write(f7, string(co_var[x,y])*",")
                     end
              end
              # print(string("\n"))
              write(f1,"\n")
              write(f2,"\n")
              write(f3,"\n")
              write(f4,"\n")
              write(f5,"\n")
              write(f6,"\n")
              write(f7,"\n")
       end
       close(f1)
       close(f2)
       close(f3)
       close(f4)
       close(f5)
       close(f6)
       close(f7)
       # PyPlot.subplot(4,4,b)
       # PyPlot.contourf(true_alpha, true_init,  dets)
       # PyPlot.colorbar();
       # PyPlot.plt[:title](bifurcations[b])
       # PyPlot.plt[:ylabel]("Initial conditions")
       # PyPlot.plt[:xlabel]("Alpha")
end


# for b in 1:length(bifurcations)
#        pp = testfish[b]
#        f = open("/project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/fish_data/"*string(b)*".csv", "w")
#        write(f, string(true_init)[2:end-1]*"\n")
#        # print( string(test_alpha)*"\n")
#        for x in 1:size(pp)[2]
#               for y in 1:size(pp)[1]
#                      if y==size(pp)[1]
#                             write(f, string(pp[y,x]))
#                             # print(string(pp[x,y]))
#                      else
#                             # print(string(pp[x,y]))
#                             write(f, string(pp[y,x])*",")
#                      end
#               end
#               # print(string("\n"))
#               write(f,"\n")
#        end
#        close(f)
# end
