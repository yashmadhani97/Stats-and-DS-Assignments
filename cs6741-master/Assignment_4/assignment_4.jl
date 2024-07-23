### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ ef8d00ae-a9cc-11eb-067a-2dc7ae24481f
begin 
	using Plots
	plotly()
	using PlutoUI
	using StatsPlots
	using RDatasets
	using StatsBase
	using FreqTables
	using Distributions
	using QuadGK
	using CSV
	using DataFrames
	using Dates
	using Random
end

# ╔═╡ 705a8f7e-aa79-11eb-32c9-29f5cc9b905a
md"### Question 1"

# ╔═╡ 6588dc30-a9cd-11eb-34fb-418b7e3a67a6
monte_carlo_prob_1 = sum([ 1 for _ in 1:10^6 if sum( rand( Bernoulli(0.5),50 ) ) >= 30 ] ) / 10^6

# ╔═╡ 32a97f00-a9d1-11eb-3614-89452afd6bd7
binomial_prob_1 = sum( [ binomial( 50,x )*( (0.5)^x )*( (0.5)^(50-x) ) for x in 30:50 ] ) 

# ╔═╡ 29918100-a9d2-11eb-2dd3-1181f7437e3c
begin
	n_1 = 50
	p_1 = 0.5
	
	bernoulli_rv_mean_1 = p_1
	bernoulli_rv_deviation_1 = sqrt(p_1*(1-p_1))
	
	clt_mean_1 = n_1*bernoulli_rv_mean_1
	clt_deviation_1 = sqrt(n_1)*bernoulli_rv_deviation_1
	
	clt_distribution_1 = Normal(clt_mean_1, clt_deviation_1)
	
	prob_going_ahead_1 = quadgk(x -> pdf(clt_distribution_1,x), 29.5, 49.5 )[1]
end

# ╔═╡ 652636a0-aa79-11eb-1d99-a74c15678aaa
md"### Question 2"

# ╔═╡ 5418b712-aa7a-11eb-0eec-c3c396c7b17c
begin
	flag_2 = true
	n_2 = 50
	p_2 = 0.5
	prob_going_ahead_2 = 0
	
	while flag_2
		
		bernoulli_rv_mean_2 = p_2
		bernoulli_rv_deviation_2 = sqrt(p_2*(1-p_2))

		clt_mean_2 = n_2*bernoulli_rv_mean_2
		clt_deviation_2 = sqrt(n_2)*bernoulli_rv_deviation_2

		clt_distribution_2 = Normal(clt_mean_2, clt_deviation_2)

		prob_going_ahead_2 = quadgk(x -> pdf(clt_distribution_2,x), 29.5, 50.5 )[1]
		
		if prob_going_ahead_2 >= 0.5
			flag_2 = false
		else
			p_2 += 0.001
		end
	end
	p_2
end

# ╔═╡ 20ef9190-aa7c-11eb-075e-b1c6f2178808
monte_carlo_prob_2 = sum( [ 1 for _ in 1:10^6 if sum( rand( Bernoulli( 0.59 ), 50 ) ) >= 30 ] ) / 10^6

# ╔═╡ 2393d68e-aa7c-11eb-3c70-b3689654c4de
binomial_prob_2 = sum( [ binomial(50,x)*( (0.59)^x )*( (1-0.59)^(50-x) ) for x in 30:50 ] )

# ╔═╡ 557adf20-aa7a-11eb-0473-eb8c789fe812
md"### Question 3"

# ╔═╡ 27cada2e-b006-11eb-1747-11e17aa2a955
begin
	flag_3 = true
	
	n_3 = 1
	
	while flag_3
		
		clt_mean_3 = n_3 * 100
		clt_deviation_3 = sqrt(n_3)*30
	
		clt_distribution_3 = Normal(clt_mean_3, clt_deviation_3)
	
		prob_3 = quadgk(x -> pdf(clt_distribution_3 , x), 2999.5,  clt_mean_3 + 4*clt_deviation_3 )[1] 
		
		if prob_3 >= 0.95
			flag_3 = false
		else
			n_3 += 1
		end
	end
	n_3
end

# ╔═╡ 17349f02-aa8c-11eb-28c0-cbfb36d3cd15
md"### Question 4"

# ╔═╡ e0caf300-b0b8-11eb-1e8c-c1cc67d273b1
begin
	Random.seed!(1)
	
	function checking_similarity(Distribution)
		D_mean = mean(Distribution)
		D_sigma = std(Distribution)

		n = 1
			
		sample_sum_list = []

		flag_4 = true

		while flag_4
			
			empty!(sample_sum_list)
			
			for _ in 1:10^4
				sample = rand(Distribution, n)
				sample_sum = sum((sample .- D_mean) ./ D_sigma)
				push!(sample_sum_list, sample_sum)
			end
			
			sample_sum_list = sample_sum_list /sqrt(n)
			
			# Standard Normal distribution has first moment = 0 
			# Standard Normal distribution has second moment = 1 
			# Standard Normal distribution has third moment = 0 
			# Standard Normal distribution has fouth moment = 3 
			
			if abs(moment(sample_sum_list,1) - 0) < 0.1 
				if abs(moment(sample_sum_list,2) - 1) < 0.1 
					if abs(moment(sample_sum_list,3) - 0 ) < 0.1 
						if abs(moment(sample_sum_list,4) - 3) < 0.1
							flag_4 = false
						end
					end
				end
			end
			n += 1
		end
		
		return (n,sample_sum_list)
	
	end
end

# ╔═╡ 02924c80-b0ba-11eb-026f-391c43981cac
begin
	Distribution_4_a = Uniform(0,1)
	(n_a,sample_sum_list_a) = checking_similarity(Distribution_4_a)
	n_a
end

# ╔═╡ b7d9ec0e-b0ba-11eb-232d-59e626760cec
density(sample_sum_list_a, line=3)

# ╔═╡ afa20620-b0c1-11eb-11ef-bb51c200d4ff
begin
	Distribution_4_b = Binomial(60,0.01)
	(n_b,sample_sum_list_b) = checking_similarity(Distribution_4_b)
	n_b
end

# ╔═╡ b741c690-b0c1-11eb-2724-d3eef6ca79f1
density(sample_sum_list_b, line=3)

# ╔═╡ baa20890-b0c1-11eb-0db6-eb30e4506fee
begin
	Distribution_4_c = Binomial(60,0.5)
	(n_c,sample_sum_list_c) = checking_similarity(Distribution_4_c)
	n_c
end

# ╔═╡ b8a28f10-b0c1-11eb-384a-5bbf87349c91
density(sample_sum_list_c, line=3)

# ╔═╡ bde28d90-b0c1-11eb-3cc8-d504964c2fc7
begin
	Distribution_4_d = Chisq(3)
	(n_d,sample_sum_list_d) = checking_similarity(Distribution_4_d)
	n_d
end

# ╔═╡ b9b90820-b0c1-11eb-32c5-873396af2452
density(sample_sum_list_d, line=3)

# ╔═╡ 71a6b6b0-b09c-11eb-144b-25d5241468ad


# ╔═╡ Cell order:
# ╠═ef8d00ae-a9cc-11eb-067a-2dc7ae24481f
# ╟─705a8f7e-aa79-11eb-32c9-29f5cc9b905a
# ╠═6588dc30-a9cd-11eb-34fb-418b7e3a67a6
# ╠═32a97f00-a9d1-11eb-3614-89452afd6bd7
# ╠═29918100-a9d2-11eb-2dd3-1181f7437e3c
# ╟─652636a0-aa79-11eb-1d99-a74c15678aaa
# ╠═5418b712-aa7a-11eb-0eec-c3c396c7b17c
# ╠═20ef9190-aa7c-11eb-075e-b1c6f2178808
# ╠═2393d68e-aa7c-11eb-3c70-b3689654c4de
# ╟─557adf20-aa7a-11eb-0473-eb8c789fe812
# ╠═27cada2e-b006-11eb-1747-11e17aa2a955
# ╟─17349f02-aa8c-11eb-28c0-cbfb36d3cd15
# ╠═e0caf300-b0b8-11eb-1e8c-c1cc67d273b1
# ╠═02924c80-b0ba-11eb-026f-391c43981cac
# ╠═b7d9ec0e-b0ba-11eb-232d-59e626760cec
# ╠═afa20620-b0c1-11eb-11ef-bb51c200d4ff
# ╠═b741c690-b0c1-11eb-2724-d3eef6ca79f1
# ╠═baa20890-b0c1-11eb-0db6-eb30e4506fee
# ╠═b8a28f10-b0c1-11eb-384a-5bbf87349c91
# ╠═bde28d90-b0c1-11eb-3cc8-d504964c2fc7
# ╠═b9b90820-b0c1-11eb-32c5-873396af2452
# ╟─71a6b6b0-b09c-11eb-144b-25d5241468ad
