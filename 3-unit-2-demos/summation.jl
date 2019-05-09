## Accurate Summation
# See what happens in two floatint Point
# precisions
using Printf
""" Run an example where we compute
a sum in a low-precision and compare with
a high-precision sum. You can use BigFloat
in case you need to check Float64. """
function sum_example_1(ns, Tlow, Thigh=Float64)
  for n in ns
    x = randn(Tlow, n)
    y = Thigh.(x) # convert to high-precision
    s1 = sum(x) # sum in low-precision
    s2 = sum(y) # sum in high-precision
    @printf("%10i - %20s - %20s\n", n, "$s1", "$s2")
  end
end
sum_example_1([10^3 10^4 10^5 10^6], Float16)
## Let's do the same example but where we control the sum
# and don't allocate vectors.
using Printf
function sum_example(ns, Tlow, Thigh=Float64)
  for n in ns
    s1 = zero(Tlow)
    s2 = zero(Thigh)
    for i =1:n
      x = randn(Tlow)
      s1 += x
      s2 += Thigh.(x)
      x = rand(Tlow)
      x *= 2*rand(Bool)-1 # random sign
      s1 += x
      s2 += Thigh.(x)
    end
    @printf("%10i - %20s - %20s\n", n, "$s1", "$s2")
  end
end
sum_example([10^3 10^4 10^5 10^6], Float16)

## Kahan Summation

"""
kahan_sum implements one step of the Kahan summation procedure.
function KahanSum(input)
  variables sum,c,y,t,i          // Local to the routine.
    sum = 0.0                    // Prepare the accumulator.
    c = 0.0                      // A running compensation for lost low-order bits.
    for i = 1 to input.length do // The array input has elements indexed input[1] to input[input.length].
        y = input[i] - c         // c is zero the first time around.
        t = sum + y              // Alas, sum is big, y small, so low-order digits of y are lost.
        c = (t - sum) - y        // (t - sum) cancels the high-order part of y; subtracting y recovers negative (low part of y)
        sum = t                  // Algebraically, c should always be zero. Beware overly-aggressive optimizing compilers!
    next i                       // Next time around, the lost low part will be added to y in a fresh attempt.
    return sum
"""
function kahan_sum(x,sum,c)
  y = x-c
  t = sum+y
  c = (t-sum)-y
  sum = t
  return sum,c
end

function ksum(xs::AbstractArray)
  sum = zero(eltype(xs))
  c = zero(eltype(xs))
  for x in xs
    sum,c = kahan_sum(x, sum, c)
  end
  return sum
end
ksum(randn(Float16,1000))

##
using Printf
function sum_example_kahan(ns, Tlow, Thigh=Float64)
  for n in ns
    s0 = zero(Tlow)
    s1 = zero(Tlow)
    c1 = zero(Tlow)
    s2 = zero(Thigh)
    for i =1:n
      x = randn(Tlow)
      s0 += x
      s1,c1 = kahan_sum(x, s1, c1)
      s2 += Thigh.(x)
      x = rand(Tlow)
      x *= 2*rand(Bool)-1 # random sign
      s0 += x
      s1,c1 = kahan_sum(x, s1, c1)
      s2 += Thigh.(x)
    end
    @printf("%10i - %8s - %8s - %20s\n", n, "$s0","$s1", "$s2")
  end
end
using Random
Random.seed!(0)
sum_example_kahan([10^3 10^4 10^5 10^6], Float16)
