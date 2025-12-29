For the following example, we will consider the one dimensional dynamic system defined by

$$\frac{dx}{dt} = x^2 - 1$$

The function is plotted below

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/examples/small_quadratic/system_dynamics.png)

For $x < 1$ this system will converge to the stable equilibrium $x=-1$

The goal of this example will be to approximate a lifted space $\mathbf{z} = \boldsymbol{\phi}(x)$ where the dynamics are now linear instead of quadratic.  We need to find a Koopman operator $K$ such that $\mathbf{z}_{k+1} = K\mathbf{z}_k$.

Traditionally this is done using data driven methods that rely on learning $K$ from an exhaustive data set.  But there is another way that is more analytical and generalizable if the original nonlinear dynamics of the system are known.

Consider a known function $x_{k+1} = F(x)$ that advances the system state forward by one time step.  Given a set of lifting functions $\boldsymbol{\phi}(x)$, the lifted state at time $k+1$ is $\boldsymbol{\phi}(x_{k+1}) = \boldsymbol{\phi}(F(x))$

If the dynamics are linear in the lifted space, then $\boldsymbol{\phi}(F(x)) = K \boldsymbol{\phi}(x)$ 

The Koopman operator $K$ can be interpreted as a projection of $\boldsymbol{\phi}(F(x))$ onto $\boldsymbol{\phi}(x)$ and can be found by the following inner product

$$K_{ij} = \frac{\lang \phi_i(F(x)), \phi_j(x) \rang}{\lang \phi_j(x), \phi_j(x)\rang}$$

For this example, we will use Legendre polynomials for our lifting functions.  The projection coefficients are computed as follows

$$K_{ij} = \frac{2j+1}{2} \int_{-1}^1 P_i(F(x)) P_j(x) dx $$

In our example, $F(x) = x + (x^2 - 1)\Delta t$

for the first few entries in the Koopman Operator,

$$K_{00} = \frac{1}{2} \int_{-1}^1 dx = 1$$
$$K_{01} = \frac{1}{2} \int_{-1}^1 x dx = 0$$
$$K_{02} = \frac{1}{4} \int_{-1}^1 (3x^2 - 1) dx = 0$$
$$K_{10} = \frac{3}{2} \int_{-1}^1 (x + (x^2 - 1)\Delta t) dx = -2 \Delta t$$
$$K_{11} = \frac{3}{2} \int_{-1}^1 (x + (x^2 - 1)\Delta t)x dx = 1$$
$$K_{12} = \frac{3}{4} \int_{-1}^1 (x + (x^2 - 1)\Delta t)(3x^2 - 1) dx = \frac{2}{5} \Delta t$$




