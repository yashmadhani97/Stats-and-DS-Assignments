
using Random
Random.seed!(0)

# Event A : Not going bankrupt
# Event B : End up with Rs 10 or more

# calculating P(B/A) = P(A intersection B) / P(A) : probability of ending up with 10 Rs or more given that not going bankrupt

initial_money = 10

for p in [ a/10 for a in 1:10 ]
    count = 0
    curr_counter = 0

    for _ in 1:10^6
        flag = 0
        money = initial_money

        for d in 1:20
            if rand(1:10) <= (p*10)
                money -= 1
            else 
                money += 1
            end
        
            if money == 0
                flag = 1
                break
            end
        end
        if flag == 0
            count += 1
            if money>=10
                curr_counter += 1
            end
        end
    end
    p_A = count/10^6
    p_A_intersection_B = curr_counter/10^6
    println("Probability of ending up with 10 Rs or more given that not going bankrupt when p = $p is ", p_A_intersection_B/p_A )

end