 
function arraytodict(data::Vector)

	res = Dict()

	for i in data

		k, v = split(i, " ") 
		get!(res, k, parse(Float64, v))

	end 

	res 
end 

const DICT  = readlines("df.utf8") |> arraytodict
const STOPWORD =  readlines("stop_words.utf8") |> q -> join(q[1:900], "|") |> Regex 

function seg(text::AbstractString)

	words =  split( text , STOPWORD)
	res   = Vector(undef, length(words))

	@inbounds for i in 1:length(words)
		res[i] = length(words[i]) ==1 ? words[i] : segment(words[i])
	end 

	vcat(res...) 
end 

function segment(text::AbstractString)

	if isempty(text) return [] end 
	candidates = [ vcat( [fseg], segment(lseg)... ) for (fseg, lseg) in splits(text) ]
 	candidates[findmax( map(fmax, candidates))[2]] 

end 

function splits(text::AbstractString )

	num = length(text)
	res = Vector{Tuple}(undef, num )	
	@inbounds for i in 1:length(text)
		 res[i] = (first(text, i), last(text, length(text)-i) )
	end 
	res

end 

function fmax(a::Vector)

	num = length(a)
	res = Vector{Real}(undef, num)
	@inbounds for i in 1:num 
				res[i] = get(DICT, a[i], 1)
			end 
	reduce(*, res)

end 


 
 

