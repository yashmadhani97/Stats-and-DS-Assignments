
using Random
Random.seed!(0)

initial_money = 10

for p in [ a/10 for a in 1:10 ]
    count = 0
    for _ in 1:10^6
        money = initial_money
        for d in 1:20
            if rand(1:10) <= (p*10)
                money -= 1
            else 
                money += 1
            end
        
            if money == 0
                count += 1
                break
            end
        end
    end
    println("Probability of going bankrupt when p = $p is ", count/10^6 )
end
