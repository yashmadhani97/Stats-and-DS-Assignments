
using Random
Random.seed!(0)

actual_password = randstring(['A':'Z'; '0':'9';'a':'z'; '~'; '!' ;'@'; '#'; '$' ;'%'; '^'; '&'; '*'; '('; ')'; '_'; '+'; '='; '-'; '`' ], 8)

store_count = 0

for _ in 1:10^6
    current_password = randstring(['A':'Z'; '0':'9';'a':'z'; '~'; '!' ;'@'; '#'; '$' ;'%'; '^'; '&'; '*'; '('; ')'; '_'; '+'; '='; '-'; '`' ], 8)

    count = 0
    for c in 1:8
        if actual_password[c] == current_password[c]
            count += 1
        end
    end

    if count >= 2
        global store_count += 1
    end
end

println("Probability of password getting stored in the database is ",store_count/(10^6) )Probability of password getting stored in the database is 0.004425