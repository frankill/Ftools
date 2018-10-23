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

function llength(l::List, r::Int==0)
	if l.first == nothing 
		return r
	else 
	 	lextra(l.second, r+1)
	end 
end 

Base.keys( l::List ) = fieldnames( typeof(l) )
Base.length(l::List) = llength(l)
Base.pop!(l::List) = (l.first,l.second) 
Base.copy(l::List) = List(l.first, l.second)

function Base.push!(l::List, a::Any)
	if l.second.first == nothing
	   l.second = List(a, List())
	else
		push!(l.second, a)
	end 
end 

function Base.push!(l::List, a::Any, top::Bool)
	tmp = List(a , List())
	tmp.second = copy(l) 
	l.second = tmp.second  
	l.first = tmp.first
end 
 
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
