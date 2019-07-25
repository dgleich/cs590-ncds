## Bisection methods to find a root.

"""
    bisection(f,l,r)

Find the root of a function via a bisection approach. This is a
  pedagogical implementation that can be improved.
  ## Add link to "julia bisection floating point"
"""
function bisection(f::Function, l::Real, r::Real)
  if r < l
    l,r = r,l
  end
  fl = f(l)
  fr = f(r)
  if fl*fr == 0
    al = abs(fl)
    ar = abs(fr)
    if al < ar
      return l
    else
      return r
    end
  end

  @assert(fl*fr < 0) # make sure the signs are different
  while r-l >= max(min(eps(l),eps(r)),eps(1.0)) # while there is still floating point space left.
    m = l/2 + r/2
    fm = f(m)
        @show l, m, r, fl, fm, fr
    if abs(fm) <= eps(1.0)
      return m
    elseif sign(fl) == sign(fm)
      l = m
      fl = fm
    else
      @assert(fm*fl <= 0)
      r = m
      frm = fm
    end
  end
  return l
end
l = bisection(x -> x-5, 0.0, 12.0)
##
l = bisection(x -> x-5, 0.0, 10.0)
