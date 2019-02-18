function printsum(a)
    println(summary(a), ": ",repr(a))
end

M = 3
N = 3

A = rand(1:10,M,N)
B = rand(1:10,M,N)

@time C = A*B

printsum(C)

