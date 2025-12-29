# import packages
using Plots
using FLOWMath
using ClassicalOrthogonalPolynomials

# write continuous dynamic equation
function f(x)

    # return state derivative
    return x^2 - 1
end

# write discrete dynamic equation
function F(x)

    # define time step
    dt = 0.01

    # calculate state deritative
    dxdt = f(x)

    # return next state
    return x + dxdt*dt
end

# plot system dynamics
x = range(-1,1, 2000)
p = plot(x, f)
savefig(p, "/Users/atagg/Documents/research/NeuralKoopmanTheory/examples/small_quadratic/system_dynamics.png")

# Initialize Koopman operator
n = 6
K = zeros(n,n)

# populate Koopman operator
for i in 1:n
    for j in 1:n
        integrand = legendrep.(i-1, F.(x)) .* legendrep.(j-1, x) 
        K[i,j] = (2*(j-1) + 1)/2 * trapz(x, integrand)
    end
end

# define lifting function
function phi(z, x)

    # iterate over lifted dimensions
    for i in eachindex(z)
        z[i] = legendrep(i-1, x)
    end

    # return lifted state
    return z 
end

# allocate trajectory data
nt = 200
xs = zeros(nt)
zs = zeros(n, nt)
zs_true = zeros(n, nt)

# lift initial state
zs[:,1] = phi(zs[:,1], xs[1])
zs_true[:,1] = phi(zs_true[:,1], xs[1])

# simulate and lift trajectory 
for i in 2:nt
    
    # advance state
    xs[i] = F(xs[i-1])

    # lift state
    zs_true[:,i] = phi(zs_true[:,i], xs[i])
end

# simulate in lifted space
for i in 2:nt
    zs[:,i] = K*zs[:,i-1]
end

# define color palette 
colors = palette(:viridis, n)

# plot true lifted trajectories 
p = plot(legend=false)
for i in 1:n
    plot!(zs_true[i, :], color=colors[i], linestyle=:solid)
end

# plot predicted lifted trajectories 
for i in 1:n
    plot!(zs[i, :], color=colors[i], linestyle=:dash)
end

# show plot
display(p)

x = range(-1, 1, nt)

for i in 1:nt
   zs_true[:,i] = phi(zs_true[:,i], F(x[i]))
end

for i in 1:nt
   zs[:,i] = K*phi(zs_true[:,i], x[i])
end

# plot true lifted trajectories 
p2 = plot(legend=false)
for i in 1:n
    plot!(zs_true[i, :], color=colors[i], linestyle=:solid)
end

# plot predicted lifted trajectories 
for i in 1:n
    plot!(zs[i, :], color=colors[i], linestyle=:dash)
end

