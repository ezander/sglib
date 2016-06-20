function [independ, N, polyrep]=check_independence(Y_func, V, p, N)

%{
    We want to check, whether there is a functional dependence between the
    measurements Y.
    Suppose there m measurements, i.e. we have Y_1 to Y_m.
    Suppose we have l germs xi_k, and M basis function Psi_i.
    The question is how many points xi_1 .. xi_N we'll need, in order to
    determine independence or dependence.

    Y_1 ... Y_m have a functional dependence if there is a g, such that for
    all xi, g(Y_1(xi), ..., Y_m(xi))=0. This functional dependence only
    matters here, if we can resolve it, i.e. we can represent g by the
    basis functions Psi_i, i.e. g = sum g_i Psi_i, i.e. we need
    for some g_i that for all xi: sum Psi_i(Y_1(xi), ..., Y_m(xi)) g_i = 0
    If we put the stuff into a matrix A, such that
    A_j_i = Psi_i(Y_1(xi_j), ..., Y_m(xi_j)), for enough points xi_j, this
    amounts to finding a gvec sucht that A*g=0, or g \in ker(A). Since we
    trivially always find some if N (the number of points) is less than M
    (the number of basis functions, which is the same as the size of gvec),
    we need to make sure that N>=M. I think a reasonal number should be
    something like N=2M, which would rule out accidental false positives.
%}


xi = gpcgerm_sample(V, 1);
y = funcall(Y_func, xi);
m = size(y, 1);

V_phi=gpcbasis_create('M', 'm', m, 'p', p);
M = gpcbasis_size(V_phi, 1);

if nargin<4 || isempty(N)
    N = 2 * M;
end
assert(N>=M);

xi = gpcgerm_sample(V, N);
y = funcall(Y_func, xi);
A = gpcbasis_evaluate(V_phi, y)';

plot3(y(1,:), y(2,:), linspace(0,1,size(y,2)), '.')

independ = rank(A)==M;
if nargout>=2
    N=chopabs(null(A));
    N=binfun(@times, N, 1./max(abs(N)));
    if nargout>=3
        polyrep = gpcbasis_polynomials(V_phi, 'symbols', 'xyzuvwst');
    end
end

function r=rank(A, varargin)
options=varargin2options(varargin);
[tol, options]=get_option(options, 'tol','default');
check_unsupported_options(options, mfilename);

s = svd(A);
if nargin==1
    tol = max(size(A)) * eps(max(s));
end
r = sum(s > tol);
