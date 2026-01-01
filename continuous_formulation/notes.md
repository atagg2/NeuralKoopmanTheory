The discrete formulation of Koopman operator theory states that for some nonlinear discrete dynamic system $x_{k+1} = F(x)$, there exists a lifted space $\boldsymbol{\phi}(x)$ such that

$$\boldsymbol{\phi}(F(x)) = K \boldsymbol{\phi}(x)$$

However, this caused a small issue when trying to use projections to find the Koopman operator $K$ because $K$ is dependant on the time step of the discrete system, and therefore so is the evaluation of how good the approximation is.  

If the time step is small, then $\boldsymbol{\phi}(F(x)) \approx \boldsymbol{\phi}(x)$, and $K \approx I$.  Essentiually this suppresses the error of the Koopman approximation and it becomes harder to tell what is a good approximation and what is a bad one. 

We can use large time steps, and then the error is not suppressed, but then we will lose accuracy in simualtion.

Therefore, it may be desireable to use a continuous formulation formulation as follows

$$\frac{d \boldsymbol{\phi}(x)}{dt} = \frac{d \boldsymbol{\phi}}{dx} \frac{dx}{dt} = K \boldsymbol{\phi}(x)$$

Now to find the Koopman operator we take the following projections

$$K_{ij} = \frac{\lang \frac{d \phi_i}{dx} \frac{dx}{dt}, \phi_j(x) \rang}{\lang \phi_j(x), \phi_j(x)\rang}$$

With Legendre polynomials

$$K_{ij} = \frac{2j+1}{2} \int_{-1}^1 \frac{dP_i}{dx} \frac{dx}{dt} P_j(x) dx $$

Using the same example as before,

$$\frac{dx}{dt} = x^2 - x - 1$$

We take a $5 \times 5$ approximation of $K$, and get pretty good accuracy

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/continuous_formulation/figures/lifted_trajectories_5x5.png)

The energy ratios for this approximation are


$$\begin{matrix} 
   E_1 = 1.0 \\
   E_2 = 1.0000389493201884 \\
   E_3 = 1.0002448996184692 \\
   E_4 = 1.0008165425346534 \\
   E_5 = 0.9518407776510868 \\
 \end{matrix}$$

Which tell us that the linear approximation is capturing $100\%$ of the energy of the actual lifted dynamics for the first $4$ states, and $95\%$ of the energy of the final state dynamics


The plots of the actual lifted dynamics versus the linear lifted dynamics confirm this

![System Dynamics](/Users/atagg/Documents/research/NeuralKoopmanTheory/continuous_formulation/figures/lifted_dynamic_equations_5x5.png)

when we increase the lifted dimension to $10$, the energy ratios get even beter

$$\begin{matrix} 
   E_1 = 1.0 \\
   E_2 = 1.0000003863531841 \\
   E_3 = 1.0000024187044374 \\
   E_4 = 1.0000080942480363 \\
   E_5 = 1.0000205549642636 \\
   E_6 = 1.0000439579329437 \\
   E_7 = 1.0000833965575935 \\
   E_8 = 1.0001450601963133 \\ 
   E_9 = 1.000235989372411 \\
   E_10 = 0.9753195291731591
 \end{matrix}$$

The higher the lifted dimension, the better we can approximate that last lifted state.  At $30$ dimensions we see an energy ratio of $0.996$ 


