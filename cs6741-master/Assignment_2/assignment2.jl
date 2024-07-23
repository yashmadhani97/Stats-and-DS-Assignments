### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 82fa56c0-7c34-11eb-160f-f383d55d83e4
using DataFrames

# ╔═╡ 57de3b80-7d80-11eb-2bbe-ddcdcda1b0a9
begin
	using Dates
	df_3 = DataFrame(
		year = 2000 , 
		artist =  [ "2 Pac", 
			"2Ge+her", 
			"3 Doors Down",
			"98^0",
			"A*Teens",
			"Aaliyah",
			"Aaliyah",
			"Adams,Yolanda"] 

		,time = [
			 4:22, 
			 3:15,
			 3:53,
			 3:24, 
			 3:44, 
			 4:15, 
			 4:03,
			 5:30,  ],
		track = [ "Baby Don’t Cry", 
			"The Hardest Part Of", 
			"Kryptonite",
			"Give Me Just One Nig ",
			"Dancing Queen",
			"I Don’t Wanna",
			"Try Again",
			"Open My Heart"]
		, 
		 date  = [
			Date.("2000-02-26", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-09-02", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-04-08", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-08-19", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-07-08", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-01-29", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-03-18", Dates.DateFormat("yyyy-mm-dd")) , 
			Date.("2000-08-26", Dates.DateFormat("yyyy-mm-dd")) , 
			 ]
	)
	for w in 1:5
		df_3[:, string(w)] = [rand(60:90),rand(80:85),rand(60:80),rand(60:80),rand(80:99),rand(60:80),rand(60:80),rand(80:99)]	
	end
	df_3 = sort(rename!(stack(df_3, 6:10 ;variable_name = :week),:value=> :rank),:artist)
end

# ╔═╡ f17a9b10-7e36-11eb-3587-99fd32acb056
begin
	using HTTP
	using JSON
	r = HTTP.request("GET", "https://api.covid19india.org/data.json")
	json_str = String(r.body)
	a = JSON.Parser.parse(json_str)
	df_4 = reduce(vcat, DataFrame.(a["cases_time_series"]))
end

# ╔═╡ 758ef0e2-7e69-11eb-02de-4bf099b3d4de
begin
	using Statistics
	df_5 = DataFrame( 
		dateymd = df_4[:,:dateymd], 
		
		dailyconfirmed = df_4[:, :dailyconfirmed] , moving_avg_confirmed = zeros(size(df_4)[1]) , 
		
		dailydeceased = df_4[:, :dailydeceased] , moving_avg_deceased = zeros(size(df_4)[1]) , 
		
		dailyrecovered = df_4[:, :dailyrecovered] , moving_avg_recovered = zeros(size(df_4)[1]) 
	)
	
	cum_week_sum_confirmed = sum(df_4[1:6, :dailyconfirmed])
	cum_week_sum_confirmed += df_4[7, :dailyconfirmed]
	df_5[7, :moving_avg_confirmed ] = (cum_week_sum_confirmed/7)
	
	cum_week_sum_deceased = sum(df_4[1:6, :dailydeceased])
	cum_week_sum_deceased += df_4[7, :dailydeceased]
	df_5[7, :moving_avg_deceased ] = (cum_week_sum_deceased/7)
	
	cum_week_sum_recovered = sum(df_4[1:6, :dailyrecovered])
	cum_week_sum_recovered += df_4[7, :dailyrecovered]
	df_5[7, :moving_avg_recovered ] = (cum_week_sum_recovered /7)
	
	for i in 8:size(df_4)[1]
		global cum_week_sum_confirmed
		cum_week_sum_confirmed -= df_4[i-7, :dailyconfirmed]
		cum_week_sum_confirmed += df_4[i, :dailyconfirmed]
		df_5[i,:moving_avg_confirmed ] = (cum_week_sum_confirmed/7)
		
		global cum_week_sum_deceased
		cum_week_sum_deceased -= df_4[i-7, :dailydeceased]
		cum_week_sum_deceased += df_4[i, :dailydeceased]
		df_5[i,:moving_avg_deceased ] = (cum_week_sum_deceased/7)
		
		global cum_week_sum_recovered
		cum_week_sum_recovered -= df_4[i-7, :dailyrecovered]
		cum_week_sum_recovered += df_4[i, :dailyrecovered]
		df_5[i,:moving_avg_recovered ] = (cum_week_sum_recovered/7)
	end
end

# ╔═╡ 8aa90290-7e69-11eb-1212-994ac6a138e9
begin
	using Plots
	plot(1:401,df_5[!,:dailyconfirmed],line=2,label = "dailyconfirmed" ,title = "Plot of daily confirmed cases vs average confirmed cases over 7 days", xlabel = "day", ylabel = "confirmed cases" )
	plot!(1:401,df_5[!,:moving_avg_confirmed],line=3,c=:red, label = "moving_avg", xlabel = "day", ylabel = "confirmed cases")
end

# ╔═╡ bda28360-7ea5-11eb-0859-677df0adab64
md"Question 1"

# ╔═╡ f62ae7d2-7c35-11eb-15b4-6fcf07ceb725
df_1 = DataFrame( 
	religion = ["Agnostic","Atheist","Buddhist","Catholic","Don’t know/refused","Evangelical Prot","Hindu","Historically Black Prot","Jehovah’s Witness", "Jewish"],
	
	less_than_10K = [27,12,27,418,15,575,1,228,20,19],
	
	twenty_thirty_k = [34,27,21,617,14,869,9,244,27,19],
	
	thirty_fourty_k = [60,37,30,732,15,1064,7,236,24,25],
	
	fourty_fiftyk = [81,52,34,670,11,982,9,238,24,25],
	
	fifty_75k = [76,35,33,638,10,881,11,197,21,30],
	
	seventy_100K = [137,70,58,1116,35,1486,34,223,30,95],
	
	hundred_150k = [159,75,60,735,25,898,68,225,37,60],
	
	grater_than_150K = [58,65,57,739,45,1210,22,236,45,85],
	
	Dont_Know_refused = [74,78,55,698,40,879,21,355,40,70]
)

# ╔═╡ 6eb8d880-7eaa-11eb-2c40-3774f4de957c
begin
	df_1_final = stack(df_1, 2:10;variable_name = :income)
	sort(rename!(df_1_final,:value => :freq),:religion)
end

# ╔═╡ 0e9181e0-7ea6-11eb-2d97-c18c40823577
md"Question 2"

# ╔═╡ 481c5ac0-7cfd-11eb-3b1b-b3b8c7d7dce4
begin
	
	df_2 = DataFrame(id = rand(["MX17004","MX17005","MX17006"]), year = rand(2010:2020) ,month = rand(1:12) , element = ["tmax","tmin"] )
	
	for d in 1:31
		df_2[:, "d" * string(d)] = [rand(20: 0.01 :40),rand(5: 0.01 :20)]	
	end
	
	allowmissing!(df_2)
	
	for i in 1:10
		id_no = rand(["MX17004","MX17005","MX17006"])
		year_no = rand(2010:2020)
		month_no = rand(1:12)
		push!(df_2,[ [ id_no , year_no , month_no , "tmax" ] ; [rand(20: 0.01 :40) for _ in 1:31] ])
		push!(df_2,[ [ id_no , year_no , month_no , "tmin" ] ; [rand(5: 0.01 :20) for _ in 1:31] ])
	end
end

# ╔═╡ 1d851360-7eab-11eb-2f2e-411410b74560
df_2

# ╔═╡ bd5873d2-7d6d-11eb-1126-9569963d25b8


# ╔═╡ 2968d7e0-7d73-11eb-25d5-ed873043ea2e
df_2_stacked = stack(df_2, 5:35 ;variable_name = :day)

# ╔═╡ 45ec3b40-7d74-11eb-2dcd-dd2b6d3ed840
df_2_unstacked = unstack(df_2_stacked,:element,:value,allowduplicates=true)

# ╔═╡ 7f0810a0-7d76-11eb-3233-110ab9c2bc8d
begin
	df_2_unstacked[!,:date] = map((x,y,z) -> string(x,"-",y,"-",z[2:end]), df_2_unstacked[!,:year], df_2_unstacked[!,:month], df_2_unstacked[!,:day])
	df_2_final = select(df_2_unstacked,Not( [:year,:month,:day] ) )[:, [:id, :date,:tmax,:tmin]]
end

# ╔═╡ d9f542e0-7d7f-11eb-16fa-2177881be9df
dropmissing!(df_2_final,[:tmax,:tmin])

# ╔═╡ 50a923c0-7d80-11eb-3c75-b7a646e4af8a
df_2_final

# ╔═╡ 707bbb02-7ea6-11eb-298a-573a4bc130a3
md"Question 3"

# ╔═╡ aa336900-7de9-11eb-2222-552b4116f3f5
begin
	transform!(df_3, :week => ByRow(x-> parse(Int64,x)) => :week  )
	transform!(df_3, [:date,:week] => ByRow((x,y)-> x + Dates.Day((y-1)*7) ) => :date  )
end

# ╔═╡ d3141b40-7df2-11eb-17b2-59a9a99929fc
begin
	df_3_1 = DataFrame(id=Int[],artist=String[],track=String[],time=[])
	df_3_2 = DataFrame(id=Int[],date=Date[],rank=Int[] )
	gdf = groupby(df_3,:track)
	counter=1
	for group in gdf
		push!(df_3_1,[ counter , group[1,:artist], group[1,:track], group[1,:time] ] )
		index =1
		for ele in 1:5
			push!(df_3_2, [ counter , group[index,:date], group[index ,:rank] ] )
			index+=1
		end
		counter += 1
	end	
end

# ╔═╡ 144c2980-7df4-11eb-1bbd-d581ef960393
df_3_1

# ╔═╡ 31bb4c70-7df5-11eb-25ba-6778084bbf5a
df_3_2

# ╔═╡ 7d4a8a00-7ea6-11eb-19ed-3de86065d6ab
md"Question 4"

# ╔═╡ 533d8a5e-7e69-11eb-24a9-e35cf19b3279
begin
	transform!(df_4, [:dailyconfirmed, :dailydeceased ,:dailyrecovered, :totalconfirmed, :totaldeceased, :totalrecovered] .=>  ByRow(x -> parse(Int,x)) .=> [:dailyconfirmed, :dailydeceased ,:dailyrecovered, :totalconfirmed, :totaldeceased, :totalrecovered])

	transform!(df_4,:dateymd => ByRow(x-> Date.(x, Dates.DateFormat("yyyy-mm-dd")) ) => :dateymd )
	
	transform!(df_4, :dateymd => ByRow(x -> Dates.year(x) ) => :year)
	
	transform!(df_4, :dateymd => ByRow(x -> Dates.month(x) ) => :month)
end

# ╔═╡ 68581140-7e69-11eb-128d-03e0e78667df
begin
	gdf_4 = groupby(df_4,[:year,:month])
	combine(gdf_4, :dailyconfirmed => sum => :confirmed , :dailydeceased => sum => :deceased ,:dailyrecovered => sum =>:recovered)
end

# ╔═╡ a3626e5e-7ea6-11eb-34bf-dd9948aa90ed
md"Question 5"

# ╔═╡ 90fedde0-7e69-11eb-0c2d-0fce7d63b173
begin
	plot(1:401,df_5[!,:dailydeceased],line=2,label = "dailydeceased" ,title = "Plot of daily deceased vs average deceased over 7 days", xlabel = "day", ylabel = "deceased" )
	plot!(1:401,df_5[!,:moving_avg_deceased],line=3,c=:red, label = "moving_avg", xlabel = "day", ylabel = "deceased")
end

# ╔═╡ a5c81070-7e69-11eb-3d0f-11232137242c
begin
	plot(1:401,df_5[!,:dailyrecovered],line=2,label = "dailyrecovered" ,title = "Plot of daily recovered cases vs average recovered cases of 7 days", xlabel = "day", ylabel = "number of cases" )
	plot!(1:401,df_5[!,:moving_avg_recovered],line=3,c=:red, label = "moving_avg", xlabel = "day", ylabel = "number of cases")
end

# ╔═╡ Cell order:
# ╠═82fa56c0-7c34-11eb-160f-f383d55d83e4
# ╟─bda28360-7ea5-11eb-0859-677df0adab64
# ╠═f62ae7d2-7c35-11eb-15b4-6fcf07ceb725
# ╠═6eb8d880-7eaa-11eb-2c40-3774f4de957c
# ╟─0e9181e0-7ea6-11eb-2d97-c18c40823577
# ╠═481c5ac0-7cfd-11eb-3b1b-b3b8c7d7dce4
# ╠═1d851360-7eab-11eb-2f2e-411410b74560
# ╟─bd5873d2-7d6d-11eb-1126-9569963d25b8
# ╠═2968d7e0-7d73-11eb-25d5-ed873043ea2e
# ╠═45ec3b40-7d74-11eb-2dcd-dd2b6d3ed840
# ╠═7f0810a0-7d76-11eb-3233-110ab9c2bc8d
# ╠═d9f542e0-7d7f-11eb-16fa-2177881be9df
# ╠═50a923c0-7d80-11eb-3c75-b7a646e4af8a
# ╟─707bbb02-7ea6-11eb-298a-573a4bc130a3
# ╠═57de3b80-7d80-11eb-2bbe-ddcdcda1b0a9
# ╠═aa336900-7de9-11eb-2222-552b4116f3f5
# ╠═d3141b40-7df2-11eb-17b2-59a9a99929fc
# ╠═144c2980-7df4-11eb-1bbd-d581ef960393
# ╠═31bb4c70-7df5-11eb-25ba-6778084bbf5a
# ╟─7d4a8a00-7ea6-11eb-19ed-3de86065d6ab
# ╠═f17a9b10-7e36-11eb-3587-99fd32acb056
# ╠═533d8a5e-7e69-11eb-24a9-e35cf19b3279
# ╠═68581140-7e69-11eb-128d-03e0e78667df
# ╟─a3626e5e-7ea6-11eb-34bf-dd9948aa90ed
# ╠═758ef0e2-7e69-11eb-02de-4bf099b3d4de
# ╠═8aa90290-7e69-11eb-1212-994ac6a138e9
# ╠═90fedde0-7e69-11eb-0c2d-0fce7d63b173
# ╠═a5c81070-7e69-11eb-3d0f-11232137242c
