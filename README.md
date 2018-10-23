```julia
a = @queue 1 2 3 4 
b = @stack 1 2 3 4
 
values(a)
values(b)
push!(a, 1000000)
push!(a, 1000000, true)

```
