macro queue(expr...)
	esc(genqueue(collect(expr)))
end 

function genqueue(e::Vector)
	q  = Expr(:new, :List , nothing  )
	num = length(e)
	for i in num:-1:1
		q = Expr(:new, :List , e[i] , q  )
	end
	return q 
end 
