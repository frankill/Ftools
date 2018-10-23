macro queue(expr...)
	esc(genqueue(sort(collect(expr),rev=true)))
end 

function genqueue(e::Vector)
	q  = Expr(:new, :list , nothing  )
	num = length(e)
	for i in num:-1:1
		q = Expr(:new, :list , e[i] , q  )
	end
	return q 
end 
