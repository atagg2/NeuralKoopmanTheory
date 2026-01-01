Consider the one dimensional dynamic system defined by

$$\frac{dx}{dt} = x^2 - x - 1$$

The function is plotted below

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/polynomial_projections/figures/system_dynamics.png)

The goal of this example will be to approximate a lifted space $\mathbf{z} = \boldsymbol{\phi}(x)$ where the dynamics are now linear instead of quadratic.  We need to find a Koopman operator $K$ such that $\mathbf{z}_{k+1} = K\mathbf{z}_k$.

Traditionally this is done using data driven methods that rely on learning $K$ from an exhaustive data set.  But there is another way that is more analytical and generalizable if the original nonlinear dynamics of the system are known.

Consider a known function $x_{k+1} = F(x)$ that advances the system state forward by one time step.  Given a set of lifting functions $\boldsymbol{\phi}(x)$, the lifted state at time $k+1$ is $\boldsymbol{\phi}(x_{k+1}) = \boldsymbol{\phi}(F(x))$

If the dynamics are linear in the lifted space, then $\boldsymbol{\phi}(F(x)) = K \boldsymbol{\phi}(x)$ 

The Koopman operator $K$ can be interpreted as a projection of $\boldsymbol{\phi}(F(x))$ onto $\boldsymbol{\phi}(x)$ and can be found by the following inner product

$$K_{ij} = \frac{\lang \phi_i(F(x)), \phi_j(x) \rang}{\lang \phi_j(x), \phi_j(x)\rang}$$

We will use Legendre polynomials for our lifting functions.  The projection coefficients are computed as follows

$$K_{ij} = \frac{2j+1}{2} \int_{-1}^1 P_i(F(x)) P_j(x) dx $$

In our example, $F(x) = x + (x^2 - 1)\Delta t$

Computing these projections for a $2 \times 2$ approximation of the Koopman operator,

$$K_{2 \times 2} = \begin{bmatrix} 1 & 0 \\ -0.00666 & 1 \end{bmatrix}$$

Simulating with this Koopman operator and comparing it to the true lifted trajectories

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/polynomial_projections/figures/lifted_trajectories_2x2.png)

We can improve upon this by taking a $5 \times 5$ approximation of the Koopman operator 


![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/polynomial_projections/figures/lifted_trajectories_5x5.png)


If we go to a $15 \times 15$ Koopman operator, the simiulation is getting better.  We see that the low order polynomials are captured very well, while the high order states are still seeing some error 

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/polynomial_projections/figures/lifted_trajectories_15x15.png)


This trend continues as we go to higher and higher order polynomials.  The lifted dynamics will never be exactly captured by a finite Koopman operator, and it seems that the error is always shifted to the highest order polynomials.  

This makes sense because we are essentially trying to approximate $P_{15}(x + (x^2 - 1)\Delta t)$ , which is an order $30$ polynomial, with linear combinations of $P_{15}$ or below.  

This the error can be quantified by the following metric

$$E_i = \frac{||\sum_{j=0}^N K_{ij} \phi_j(x)||^2}{||\phi_i(F(x))||^2}$$

This is the energy captured by the approximation divided by the total energy of the lifted dynamic equation.  This ratio of energies tells us how well the dynamics are captured by the Koopman operator 

If the basis is orthonormal, then this ratio actually simplifies to 

$$E_i = \frac{\sum_{j=0}^N K_{ij}^2}{||\phi_i(F(x))||^2}$$

For the $5 \times 5$ case, the computed energy ratios are

$$\begin{matrix} 
E_1 = 1.0000002009737752 \\
E_2 = 1.0000920287163837 \\
E_3 = 1.0002708729695853 \\
E_4 = 0.9991687089803921 \\
E_5 = 0.9556402361847003 \\
 \end{matrix}$$

These are all very close to $1$, which means that nearly all of the energy is captured by the linear approximation, but we do see that the higher the degree of the lifting polynomial, the more energy is lost by the approximation.  

This is evident when we plot the linear lifted dynamics $K\boldsymbol{\phi}(x)$ and compare them against the actual lifted dynamics $\boldsymbol{\phi}(F(x))$

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/polynomial_projections/figures/lifted_dynamic_equations_5x5.png)

Note that for computing the energy ratios and plotting these curves, the time step $\Delta t$ was increased from $0.01$ to $0.2$.  This was necessary in order to expose the differences in these curves.  For a very small time step, $\boldsymbol{\phi}(F(x)) \approx \boldsymbol{\phi}(x)$.  In the future, I may look at using either a continuous formulation of the projection approach, or use a higher order integration scheme in order to remedy this.



