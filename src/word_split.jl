 

const DICT  = Dict("张杰" =>2 , "谢谢" =>3, "吃饭" =>2, "谢娜" => 2, "结婚" => 2)
const STOPWORD =  ("的", "，" , "," , "." , "。" , )

function seg(text::AbstractString)

	words = rsplit(text, "的")
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
	res = Vector{Number}(undef, num)
	@inbounds for i in 1:num 
				res[i] = get(DICT, a[i], 1)
			end 
	reduce(*, res)

end 


 
 

