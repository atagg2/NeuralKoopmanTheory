# import packages
using Plots
using FLOWMath
using ClassicalOrthogonalPolynomials
#import ForwardDiff as FD

# write continuous dynamic equation
function f(x)

    # return state derivative
    return -sin(3*x)#x^2 - x - 1
end

# write discrete dynamic equation
function F(dt, x)

    # calculate state deritative
    dxdt = f(x)

    # return next state
    return x + dxdt*dt
end

# plot system dynamics
nx = 2000
x = range(-1,1, nx)

# define time step
dt = 0.01

# Initialize Koopman operator
n = 5
K = zeros(n,n)

# populate Koopman operator
for i in 1:n
    for j in 1:n
        integrand = FD.derivative.(x->legendrep(i-1, x), x) .* f.(x) .* legendrep.(j-1, x) 
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
nt = 400
xs = zeros(nt)
zs = zeros(n, nt)
zs_true = zeros(n, nt)

# define initial state
xs[1] = 1

# lift initial state
zs[:,1] = phi(zs[:,1], xs[1])
zs_true[:,1] = phi(zs_true[:,1], xs[1])

# simulate and lift trajectory 
for i in 2:nt
    
    # advance state
    xs[i] = F(dt, xs[i-1])

    # lift state
    zs_true[:,i] = phi(zs_true[:,i], xs[i])
end

# simulate in lifted space
for i in 2:nt
    zs[:,i] = zs[:,i-1] + K*zs[:,i-1]*dt
end

# define color palette 
colors = palette(:tab10, n)

# plot true lifted trajectories 
p = plot(zs_true[1,:], color=colors[1], linestyle=:solid, label="Actual")
for i in 2:n
    plot!(zs_true[i, :], color=colors[i], linestyle=:solid, label=false)
end

# plot predicted lifted trajectories 
plot!(zs[1, :], color=colors[1], linestyle=:dash, label="Predicted")
for i in 2:n
    plot!(zs[i, :], color=colors[i], linestyle=:dash, label=false)
end

# show plot
display(p)

# save figure
#savefig(p, "/Users/atagg/Documents/research/NeuralKoopmanTheory/continuous_formulation/figures/lifted_trajectories_$(n)x$(n).png")

# Initialize new Koopman operator
n2 = n
K2 = zeros(n2,n2)

# create coarse time steps for energy evaluation
dt2 = 0.2

# discretize x space
nx2 = 5000
x2 = range(-1,1, nx2)

# populate Koopman operator
for i in 1:n2
    for j in 1:n2
        integrand = FD.derivative.(x->legendrep(i-1, x), x2) .* f.(x2) .* legendrep.(j-1, x2) 
        K2[i,j] = (2*(j-1) + 1)/2 * trapz(x2, integrand)
    end
end

# initialize actual and approximate lifted states
z_actual = zeros(n2, nx2)
z_approx = zeros(n2, nx2)

# populate actual and approximate lifted states
for i in 1:nx2
    for j in 1:n2
        z_actual[j,i] = FD.derivative(x->legendrep(j-1, x), x2[i])*f(x2[i])
    end
    z_approx[:,i] = K2*phi(z_approx[:,i], x2[i])
end

# compute system energy ratios
E = zeros(n2)
for i in 1:n2
    E[i] = trapz(x2, z_approx[i,:].^2)/trapz(x2, z_actual[i,:].^2) 
end

# print energy ratios
@show E

# define color palette 
colors = palette(:tab10, n2)

# plot true lifted dynamic equations 
pz = plot(x2, z_actual[1,:], color=colors[1], linestyle=:solid, label="Nonlinear")
for i in 2:n2
    plot!(x2, z_actual[i, :], color=colors[i], linestyle=:solid, label=false)
end

# plot predicted lifted dynamic equations 
is = Int.(round.(range(1, nx2, 200)))
plot!(x2[is], z_approx[1, is], color=colors[1], linestyle=:dash, label="Linear")
for i in 2:n2
    plot!(x2[is], z_approx[i, is], color=colors[i], linestyle=:dash, label=false)
end

# save figure
#savefig(pz, "/Users/atagg/Documents/research/NeuralKoopmanTheory/continuous_formulation/figures/lifted_dynamic_equations_$(n)x$(n).png")
