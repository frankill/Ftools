__precompile__()

module Ftools

	export @stack, @queue, List ,list
	export rep, unique, findfirst
	export @set

	mutable struct List
		   first::Any
		   second::List
		   List() = (x = new(nothing); x.second = x )
		   List(first, second::List) = new(first,second)
	       end

	list(value::Any) = List(value, List())
	list() 		 = List()

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

	function llength(l::List, r::Int=0)
		if l.first == nothing
			return r
		else
			llength(l.second, r+1)
		end
	end

	Base.keys( l::List ) = fieldnames( typeof(l) )
	Base.length(l::List) = llength(l)
	Base.copy(l::List) = List(l.first, l.second)

	function Base.pop!(l::List)
		l.first == nothing && return nothing
		tmp = l.second.first == nothing ? List() : copy(l.second)
		res = l.first
		l.first =  tmp.first
		l.second = tmp.second
		res
	end

	function Base.push!(l::List, a::Any)

		if l.first == nothing
		   l.first, l.second =  a, List()
		else
			push!(l.second, a)
		end
	end

	function Base.push!(a::Any, l::List )
		l.second = copy(l)
		l.first = a
	end

	function Base.push!(l::List, a::Any , test::Any)
		if l.second.first == test
		   l.second.second = List(a, l.second.second)
		else
			push!(l.second, a, test)
		end
	end


	include("Stack.jl")
	include("Queue.jl")
	include("tools.jl")


end
