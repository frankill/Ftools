function Base.findfirst(A::Vector{T}, name::AbstractString) where T <: Union{Dict, NamedTuple}
    seen = Set{String }()
    num = length(A)
    res = Vector{Int}()
    @inbounds for x in 1:num
        if A[x][name] ∉ seen
            push!(seen, A[x][name])
            push!(res, x)
        end
    end
    res
end

Base.unique(A::Vector{T}, name::AbstractString) where T <: Union{Dict, NamedTuple} = findfirst(A, name) |> q -> view(A, q)

Mytype = Union{Symbol , Expr}
extra(d::Expr) = d.head == :(::) ? d.args[1] : d
extra(d::Symbol) = d
extra(d::AbstractString) = d

function rep_func(a::Mytype , b::Mytype)

    tpe  = a.head == :(::) ? a.args[2] : :AbstractString
    ab ,aa = extra(b), extra(a)

    func = Expr(:call , :rep , a, b )
    b1   = Expr(:(=), :res , Expr(:call , Expr(:curly, :Vector , tpe) , :undef, ab) )
    b2   = Expr(:macrocall, Symbol("@inbounds"), "",
                    Expr(:for , Expr(:(=), :i , Expr(:call, :(:), 1, ab ) ),
                       Expr(:block, Expr(:(=) , Expr(:ref, :res, :i) , aa ) ) ))

    Expr(:function , func, Expr(:block,  b1, b2, :res) )

end

macro rep(a, b )
   esc(rep_func(a,b))
end

@rep(data::Dict, num::Integer)
@rep(data::Number, num::Integer)
@rep(data::Tuple, num::Integer)
@rep(data::AbstractString, num::Integer)
@rep(data::AbstractArray, num::Integer)
@rep(data::AbstractChar, num::Integer)

macro set(t...)
           collect_to_set(collect(t))
end

function collect_to_set(t::Vector)

        Expr(:call, :Set , Expr(:vect, t...))

end
