
using Random
Random.seed!(0)

sum_n = 0
count = 0
mean = 0
mean_list = []

for _ in 1:10^6
    global sum_n += ( rand(Int16) )
    global count += 1
    global mean = ( sum_n )  / ( count )
    push!(mean_list, mean )

end

using Plots

plot( [a for a in 1:10^6] , mean_list  ,xlabel = "N", ylabel = "Mean", title = "N vs Mean",legend = false, line=3)
savefig("question1_plot.png")