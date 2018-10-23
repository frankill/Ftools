mutable struct List 
	   first::Any
           second::List
           List() = (x = new(nothing); x.second = x )
           List(first, second::List) = new(first,second)
       end

function Base.show( io::IO, x::List)
	x.first == nothing  && return 
	print(io, x.first, ",")
	show(io, x.second)
end 

function lextra(l::List, r::Array)
	if l.first == nothing 
		return r
	else 
	 	lextra(l.second, push!(r, l.first))
	end 
end 

function Base.values(l::List)
	res = [] 
	lextra(l, res)
end 

Base.keys( l::List ) = fieldnames( typeof(l) )
Base.length(l::List) = length(values(l))
Base.pop!(l::List) = l.first 
Base.push!(l::List, a::Any) = List(a, l)
 
macro stack(expr...)
	esc(genstack(collect(expr)))
end 

function genstack(e::Vector)
	q  = Expr(:new, :List , nothing  )
	for i in e
		q = Expr(:new, :List , i , q  )
	end
	return q 
end 
