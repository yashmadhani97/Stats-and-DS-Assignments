
using Random
Random.seed!(0)

# with replacement 

# assigning number to the jacks
jack_list = [11, 24, 37, 50] 

for n in 1:5
    
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
    
    println("(b) with replacement: probability of selecting $n jack is ",global_count/(10^6) )

end

