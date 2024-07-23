
using Random
Random.seed!(0)

actual_password = randstring(['A':'Z'; '0':'9';'a':'z'; '~'; '!' ;'@'; '#'; '$' ;'%'; '^'; '&'; '*'; '('; ')'; '_'; '+'; '='; '-'; '`' ], 8)

for matching_c in 2:8
    store_count = 0
    for _ in 1:10^6
        current_password = randstring(['A':'Z'; '0':'9';'a':'z'; '~'; '!' ;'@'; '#'; '$' ;'%'; '^'; '&'; '*'; '('; ')'; '_'; '+'; '='; '-'; '`' ], 8)

        count = 0
        for c in 1:8
            if actual_password[c] == current_password[c]
                count += 1
            end
        end

        if count >= matching_c
            store_count += 1
        end
    end
    println("Probability of password getting stored in the database when $matching_c matching_character is ",store_count/(10^6) )
    if store_count/(10^6) <= 0.001
        println("If we change the rule to store the password if $matching_c character matched then our final probability will fall under 0.001 which says no more than 1000 entries will be stored when million hits are there." )  
        break
    end  
end


