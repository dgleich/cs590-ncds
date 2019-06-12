## In this notebook, we'll look at least squares on biometric data
A = randn(10,5)
b = randn(10)
x = A\b # built in least-squares
## Solve via Normal equations
y = (A'*A) \ (A'*b)
@show norm(x-y)
## Solve via QR
Q,R = qr(A)
c = Q'*b
c1 = c[1:size(A,2)]
z = R\c1
@show norm(x-z)
