
using Random
Random.seed!(0)

# without replacement

# assigning number to the jacks
jack_list = [11, 24, 37, 50] 

for n in 1:5
    
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

    
    println("(a) without replacement: probability of selecting $n jack is ",global_count/(10^6) )

end