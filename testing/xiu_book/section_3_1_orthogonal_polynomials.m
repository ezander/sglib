%% Section 3.1 Orthogonal Polynomials
%
% In this file some properties and some examples systems of univariate
% orthogonal polynomials are demonstrated. In _sglib_ this is accomplished
% by the |polysys*| functions. The |polysys*| functions are usually not
% called explicitly by user code, but are rather used internally by the
% |gpc*| functions.




%% Legendre Polynomials
%
% The Legendre polynomials are defined by the recurrence relation (3.15):
% 
% $$P_{n+1}(x)=\frac{2n+1}{n+1}xP_n(x)-\frac{n}{n+1}P_{n-1}(x)$$
%
% In _sglib_ they can be specified by |polysys='P'| for the unnormalised
% and |polysys='p'| for the normalised Legendre polynomials. 
% In the following code we retrieve the recurrence coefficients for the
% polynomials up to degree 6 using |polysys_recur_coeff| and print a table
% of rational approximations using the builtin |rats| function. 

polysys = 'P';
rc = polysys_recur_coeff(polysys, 6);
disp(rats(rc));

%%
% Note that the order of the recurrence coefficients is different from that
% in (Xiu2010), but matches that in (NIST/DLMF). The first column in the
% expression for $P_{n+1}$ is the coefficient of $P_{n}$, the second column
% contains the coefficients of $xP_{n}$ and the last column the
% coefficients of $-P_{n-1}$. Note that for symmetric polynomials the first
% column is always zero, since only then the polynomials are alternatively
% of purely even or odd degree. 
%

%%
% We can get the coefficients of the polynomials using the
% |polysys_rc2coeffs| function and |format_poly| to get a nice screen
% representation of the polynomials.

p=format_poly(polysys_rc2coeffs(rc), 'twoline', true, 'tight', false, 'symbol', 'x', 'rats', true);
for i=1:length(p)
    fprintf('         %s\n',   p{i}(1,:));
    fprintf('%s_%d(x) = %s\n', polysys, i-1, p{i}(2,:));
end

%%
% Note that for evaluating the polynomials the coefficients are not used
% but rather the recurrence relation directly since this is numerically
% more stable. 
% For evaluating the polynomials there is currently no |polysys| function,
% but a |gpc| function must be used. First a |gpcspace| is created from
% this one Uniform/Legendre variable with polynomial degree up to 4.

V = gpcbasis_create(polysys, 'p', 4);

%%
% Then the gpc basis |V| is evaluated at a number of point |x| in the
% interval [-1, 1] and plotted. Note that |x| must be a row vector in this
% case (more to the rationale in the section on gpc).
x = linspace(-1, 1);
y = gpcbasis_evaluate(V, x);
plot(x,y)
title('Legendre polynomials of degree 0 to 4')


%%
% The orthogonality relation of the Legendre polynomials is given by (3.16)
%
% $$\int_{-1}^{1} P_n(x)P_m(x)dx = \gamma_n\delta_{nm} =
% \frac{2}{2n+1}\delta_{nm}$$
%
% The coefficients $\gamma_n$ can be computed by the |polysys_sqnorm|
% function:

disp(rats(polysys_sqnorm(polysys, 0:5)));

%%
% In the |gpc| functions that do integration (e.g. |gpc_integrate|) and
% projection correct usage of the norms is taken care of automatically.




%% Hermite Polynomials
%
% The unnormalised, stochastic Hermite polynomials are defined by the
% recurrence relation (3.18):
% 
% $$H_{n+1}(x)=xH_n(x)-nH_{n-1}(x)$$
%
% Hermite polynomials are specified by the symbol 'H' for the unnormalised
% and 'h' for the normalised polynomials. As the function calls are
% otherwise completely the same as for the Legendre polynomials a
% description of the code will be omitted in the following.

polysys = 'H';
rc = polysys_recur_coeff(polysys, 6);
disp(rats(rc));

%%
% Explicit representation of the Hermite polynomials:

p=format_poly(polysys_rc2coeffs(rc), 'twoline', true, 'tight', false, 'symbol', 'x', 'rats', true);
for i=1:length(p)
    fprintf('         %s\n',   p{i}(1,:));
    fprintf('%s_%d(x) = %s\n', polysys, i-1, p{i}(2,:));
end

%%
% Plot of the first 4 Hermite polynomials:

V = gpcbasis_create(polysys, 'p', 4);
x = linspace(-2, 2);
y = gpcbasis_evaluate(V, x);
plot(x,y)
title('Hermite polynomials of degree 0 to 4')

%%
% The orthogonality relation of the Hermite polynomials is given by (3.19)
%
% $$\int_{-1}^{1} P_n(x)P_m(x)dx = \gamma_n\delta_{nm} =
% n!\delta_{nm}$$
%
% The coefficients $\gamma_n$ can be computed by the |polysys_sqnorm|
% function:

disp(rats(polysys_sqnorm(polysys, 0:5)));




%% Laguerre Polynomials
%
% The Laguerre polynomials with parameter $\alpha=0$ are defined by the
% recurrence relation (3.20):
% 
% $$L_{n+1}(x)=\frac{-x+2n+1}{n+1}L_n(x)-\frac{n}{n+1}L_{n-1}(x)$$
%
% Laguerre polynomials are specified by the symbol 'L' or 'l' for the
% normalised polynomials, as both they are automatically normalised (at
% least in the case $\alpha=0$.)

polysys = 'L';
rc = polysys_recur_coeff(polysys, 6);
disp(rats(rc));

%%
% Explicit representation of the Laguerre polynomials:

p=format_poly(polysys_rc2coeffs(rc), 'twoline', true, 'tight', false, 'symbol', 'x', 'rats', true);
for i=1:length(p)
    fprintf('         %s\n',   p{i}(1,:));
    fprintf('%s_%d(x) = %s\n', polysys, i-1, p{i}(2,:));
end

%%
% Plot of the first 4 Laguerre polynomials:

V = gpcbasis_create(polysys, 'p', 4);
x = linspace(0, 4);
y = gpcbasis_evaluate(V, x);
plot(x,y)
title('Laguerre polynomials of degree 0 to 4')

%%
% The orthogonality relation of the Laguerre polynomials is given by (3.21)
%
% $$\int_{-1}^{1} L_n(x)L_m(x)dx = \gamma_n\delta_{nm} =
% 1\delta_{nm}$$
%
% The coefficients $\gamma_n$ can be computed by the |polysys_sqnorm|
% function:

disp(rats(polysys_sqnorm(polysys, 0:5)));
