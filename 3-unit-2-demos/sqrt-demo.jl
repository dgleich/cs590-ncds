
## Implement the Newton's method update to estimate sqrt(x)
""" the function we are using here is y^2 - x, for which
the Newton update step is y - (y^2 - x)/(2y) """
function mysqrt(x; err = max(1.0,x)*eps(typeof(x/x)), maxiter=100)
  y = one(typeof(x/x))
  iter = 0
  while abs(y^2 - x) >= err && iter <= maxiter
    y = y - (y^2 - x)/(2*y)
    iter += 1
  end
  return y
end
@show mysqrt(500)
##
@show mysqrt(0.25)
