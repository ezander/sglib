function u_i_beta = gpc_projection(u_func, V_u, p_int)
% GPC_PROJECTION Compute a GPC expansion from a function by projection.
%   U_I_BETA = GPC_PROJECTION(U_FUNC, V_U, P_INT) computes the coefficients
%   U_I_BETA of the GPC expansion of U_FUNC with respect to the GPC basis
%   given by V_U. P_INT is the degree of the integration rule used (i.e. a
%   Smolyak rule based on one dimensional Gauss rules with respect to the
%   underlying measures as defined by V_U).
%
% Example (<a href="matlab:run_example gpc_projection">run</a>)
%   % Show comparison of GPC expansion of some function with the original
%   u_func = @(x)([0.5*sin(x(1,:)+0.1).*cos(3*x(2,:)); tan(0.3*(x(1,:)+x(2,:)))]);
%   V_u = gpcbasis_create('PU', 'p', 5);
%   u_i_alpha = gpc_projection(u_func, V_u, 6)
% 
%   [X,Y]=meshgrid(linspace(-1,1,30));
%   z = gpc_evaluate(u_i_alpha, V_u, [X(:), Y(:)]')
%   z_ex = funcall(u_func, [X(:), Y(:)]')
% 
%   mh=multiplot_init(2,2);
%   multiplot; surf(X,Y,reshape(z(1,:),size(X))); view(3)
%   multiplot; surf(X,Y,reshape(z_ex(1,:),size(X))); view(3)
%   multiplot; surf(X,Y,reshape(z(2,:),size(X))); view(3)
%   multiplot; surf(X,Y,reshape(z_ex(2,:),size(X))); view(3)
%   same_scaling(mh, 'z');
%
% See also GPC_EVALUATE, GPC_FUNCTION

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[xi_k,w_k] = gpc_integrate([], V_u, p_int);
Q = length(w_k);

for k = 1:Q
    u_i_j = funcall(u_func, xi_k(:,k));
    psi_j_beta_dual = gpcbasis_evaluate(V_u, xi_k(:,k), 'dual', true);
    du_i_beta = w_k(k) * u_i_j * psi_j_beta_dual;
    if k==1
        u_i_beta = du_i_beta;
    else
        u_i_beta = u_i_beta + du_i_beta;
    end
end
