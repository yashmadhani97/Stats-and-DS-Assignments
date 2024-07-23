
for p in [a/10 for a in 1:10]
    sum_n = 0
    for a in 1:10
        sum_n += ( binomial(20, a) * (p^a) * ((1-p) ^ (20-a) ) )
    end
    println("Theoretical probability of having at least 10 rs when p = $p is ",sum_n)
end
