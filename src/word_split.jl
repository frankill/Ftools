function arraytodict(data::Vector{AbstractString})

	res = Dict{String, Float64}()
	for i in data
		k, v = split(i, " ") 
		get!(res, k, parse(Float64, v))
	end 
	res 

end 

const DICT  = readlines("dict/df.utf8") |> arraytodict
const STOPWORD =  readlines("dict/stop_words.utf8") |> q -> join(q , "|\\" ) |> d -> string("\\", d) |> Regex


function seg(text::AbstractString) 

	words =  split( text , STOPWORD)
	res   = Vector{Vector{AbstractString}}(undef, length(words))
	num   = length(words)

	@inbounds for i in 1:num
		res[i] = length(words[i]) ==1 ? [words[i]] : segment(words[i])
	end 

	vcat(res...) 
end 

function segment(text::AbstractString)::Vector{String}

	if isempty(text) return String[] end 
	candidates = [ vcat( fseg, segment(lseg)... ) for (fseg, lseg) in splits(text) ]
 	candidates[findmax( map(fmax, candidates))[2]] 

end 

function splits(text::AbstractString )

	num = length(text)
	res = Vector{NTuple{2, String}}(undef, num )	
	@inbounds for i in 1:num
		 res[i] = (first(text, i), last(text, num-i) )
	end 
	res

end 

function fmax(a::Vector)::Float64

	num = length(a)
	res = Vector{Float64}(undef, num)
	@inbounds for i in 1:num 
				res[i] = get(DICT, a[i], 1)
			end 
	reduce(*, res)

end 
