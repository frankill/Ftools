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
