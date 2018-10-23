mutable struct list 
 		   first
           second::list
           list(first) = (x = new(first); x.second = x )
           list(first, second::list) = new(first,second)
       end

function Base.show( io::IO, x::list)
	x.first == nothing  && return 
	print(io, x.first, ",")
	show(io, x.second)
end 

function lextra(l::list, r::Array)
	if l.first == nothing 
		return r
	else 
	 	lextra(l.second, push!(r, l.first))
	end 
end 

function Base.values(l::list)
	res = [] 
	lextra(l, res)
end 

Base.keys( l::list ) = fieldnames( typeof(l) )
Base.length(l::list) = length(values(l))
 
macro stack(expr...)
	esc(genlist(collect(expr)))
end 

function genlist(e::Vector)
	q  = Expr(:new, :list , e[1]  )

	for i in e
		q = Expr(:new, :list , i , q  )
	end 

	return q 
end 
