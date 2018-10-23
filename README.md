```julia
a = @queue 1 2 3 4 
b = @stack 1 2 3 4
 
values(a)
push!(a, 1000000)
push!(0, a)
push!(a, 2,5, 2)

```
