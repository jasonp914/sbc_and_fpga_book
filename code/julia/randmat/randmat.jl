A = rand(1:10,10,3)
println(A)

B = rand!(MersenneTwister(1234),zeros(5))
println(B)



