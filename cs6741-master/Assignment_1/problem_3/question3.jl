
using Random
Random.seed!(0)

# without replacement

# assigning number to the jacks

println("Without replacement case")
println("\n")
jack_list = [11, 24, 37, 50] 

result = 1

favourable_outcomes = 4
total_outcomes = 52

for n in 1:5

    global result *= (favourable_outcomes/total_outcomes)

    # after selecting the jack we need to remove card form deck.
    global favourable_outcomes -= 1
    global total_outcomes -= 1
    
    Theoretical_probability = result
    println("Theoretical Probability of selecting n = $n jack is ",result )

    global_count = 0

    for _ in 1:10^6

        selected_card_list = []
        bag = [a for a in 1:52 ]
        for s in 1:n
            ball = rand(bag)
            deleteat!(bag, findfirst(x-> x == ball , bag))
            push!(selected_card_list, ball )
        end

        count = 0
        
        for e in selected_card_list
            if e in jack_list
                count += 1
            end
        end

        if count == n
            global_count += 1
        end
    end  
    Experimental_probability = global_count/(10^6)

    println("Experimental probability of selecting $n jack is ",global_count/(10^6) )
    println("Difference between Experimental probability and Theoretical probability ", abs(Experimental_probability - Theoretical_probability))
    println("\n")
end





# with replacement
println("With replacement case\n")

result = 1

favourable_outcomes = 4 
total_outcomes = 52

# assigning number to the jacks
jack_list = [11, 24, 37, 50] 

for n in 1:5
    
    global result *= (favourable_outcomes/total_outcomes)

    Theoretical_probability = result
    println("Theoretical Probability of selecting n = $n jack is ",result )

    global_count = 0

    for _ in 1:10^6

        selected_card_list = []

        for s in 1:n
            push!(selected_card_list, rand(1:52) )
        end

        count = 0
        
        for e in selected_card_list
            if e in jack_list
                count += 1
            end
        end

        if count == n
            global_count += 1
        end
    end  
    Experimental_probability = global_count/(10^6)
    println("Experimental Probability of selecting $n jack is ",global_count/(10^6) )
    println("Difference between Experimental probability and Theoretical probability ", abs(Experimental_probability - Theoretical_probability))
    println("\n")
end