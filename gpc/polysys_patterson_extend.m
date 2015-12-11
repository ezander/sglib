function [xn, wn]=polysys_patterson_extend(syschar, x, m)

% [1] An Algorithm for Generating Interpolatory Quadrature Rules of the
%     Highest Degree of Precision with Preassigned Nodes for General Weight
%     Functions
%     T. N. L. PATTERSON
%     The Queen’s University of Belfast



n = length(x);
if nargin<3 || isempty(m)
    m = n + 1;
end

% Generate the Hn polynomial, which has the fixed node x1 .. xn as zeros
% See sentence before (2.5) in [1]
% We do it currently via GPC functions, maybe a directer way would be
% preferable
Hn = fliplr(poly(x));
V_h = gpcbasis_create('M', 'p', n);

% We need to find a polynomial Em such that <Em Hn phi_k> for all k=0..m-1
% This reduces to solve a linear equation for the coefficients eps_j of Em
% where the matrix A_k_j is <Hn phi_j phi_k> and the eps_j are in the null
% space of A_k_j (which is hopefully one dimensionally).
% For the computation of the A_k_j we employ a Gauss rule, which since the
% max poly degree to integrate is 2m+n-1, must be of order ceil(m+n/2).
p_int = m + ceil(n/2)+2;
[xi_k, omega_k] = polysys_int_rule(syschar, p_int, 'gauss');
V = gpcbasis_create(syschar, 'p', m);

Hn_k = gpc_evaluate(Hn, V_h, xi_k); % MAYBE do this directly?
pi_i_k = gpcbasis_evaluate(V, xi_k);

A = pi_i_k(1:end-1,:) * diag(Hn_k' .* omega_k) * pi_i_k';
% Now we have the polynomial Em as the null space of A
Em_j = null(A)';

assert(size(Em_j, 1)>=1, 'Null space of matrix is empty.');
if false && size(Em_j,1)>=2
    %Em_j = Em_j(1,:);
    %Em_j = Em_j(2,:);
    a=Em_j(:,1);
    Em_j = a(2)*Em_j(1,:) + a(1)*Em_j(2,:);
    keyboard
end
assert(size(Em_j, 1)<=1, 'Null space contains more than one dimension.');

% Now find the zeros of the polynomial Em (currently we go via the matlab
% roots function, we should really go via some generalized companion matrix
% method)
% Currently: Get all the monomial coefficients of the orthogonal
% polynomials, and multiply by the coefficient from the last step. 
Pi_mono = polysys_rc2coeffs(polysys_recur_coeff(syschar, m));
Em_mono = Em_j * Pi_mono;
xn = roots(Em_mono);
xn = sort([x xn(:)']);

% Make sure the xn are (almost) real
assert(norm(imag(xn))<1e-10, 'Roots of the Stieltjes polynomial are not real'); 
xn=real(xn);


% Now get the weights
wn = weights_lagrange(syschar, xn);


function w=weights_lagrange(syschar, x)
%% WEIGHTS_LAGRANGE Compute weights via Lagrange polynomials
w = zeros(size(x'));
n=length(w);
m=polysys_raw_moments(syschar, n-1);
for k=1:n
    xk = x;
    xk(k)=[];
    p=poly(xk);
    w(k)=p*flipud(m)/polyval(p, x(k));
end

function m=polysys_raw_moments(syschar, n)
Pi_mono = fliplr(polysys_rc2coeffs(polysys_recur_coeff(syschar, n)));
A=inv(Pi_mono); 
m=A(:,1);
