using ForwardDiff

function numerical_integration(f)
    rs = range(0.0, 1.0, 500)
    thetas = range(0.0, 2*pi, 500)

    I = 0

    for i in 2:length(thetas)
        for j in 2:length(rs)
            r1 = rs[j-1]
            r2 = rs[j]
            θ1 = thetas[i-1]
            θ2 = thetas[i]

            # midpoint in polar coords
            r_mid = 0.5 * (r1 + r2)
            θ_mid = 0.5 * (θ1 + θ2)

            # convert midpoint to Cartesian
            x_mid = [r_mid * cos(θ_mid), r_mid * sin(θ_mid)]

            # exact area of annular sector
            dA = 0.5 * (r2^2 - r1^2) * (θ2 - θ1)

            I += f(x_mid) * dA
            
        end
    end
    return I
end

function partial(f, x::AbstractVector, i::Int)
   g(t) = begin
       x̃ = similar(x, typeof(t))   # ← element type adapts!
       copyto!(x̃, x)
       x̃[i] = t
       f(x̃)
   end
   ForwardDiff.derivative(g, x[i])
end

function laplacian(f, p)
   L = 0
   for i in eachindex(p)
       L += partial(x->partial(f, x, i), p, i)
   end
   return L
end

function laplacian_power(f, x, n)
   g = f
   for _ in 1:n
       g_old = g
       g = x -> laplacian(g_old, x)
   end
   return g(x)
end

function analytic_integral(f, m)

    x = zeros(2)

    I = 0

    for i in 2:2:m
        g = 1
        for j in 0:Int(i/2)
            g *= 2 + 2*j
        end
        I += 1/factorial(i)*2*pi/(2^(i/2) * factorial(Int(i/2)) * g) * laplacian_power(f, x, Int(i/2))        
    end
    return I
end

function analytic_integral2(f, m)

   x = zeros(2)

   g = 1
   for j in 0:Int(m/2)
       g *= 2 + 2*j
   end
   I = 2*pi/(2^(m/2) * factorial(Int(m/2)) * g) * laplacian_power(f, x, Int(m/2))
   return I
end
