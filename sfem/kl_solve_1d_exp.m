function [r_i_k, sigma_k]=kl_solve_1d_exp(pos,sig_r,l_r,N)
% KL_SOLVE_1D_EXP Solve the 1D KL problem for the exponential covariance.
%   KL_SOLVE_1D_EXP Long description of kl_solve_1d_exp.
%
% Example (<a href="matlab:run_example kl_solve_1d_exp">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

x=pos(:);
x0 = min(x);
x1 = max(x);
mx=0.5*(x0+x1);


DX=(x1-x0);
b = l_r/DX;

w = compute_freqs(b, N);

% LeMaitre2010, Eq. (2.23)
% Note: sigma_k = sqrt(lambda_k)
sigma_k = sig_r * sqrt(2 * b ./ (1 + (w*b).^2));

% LeMaitre2010, Eq. (2.22)
% Note: the meaning of odd/even is reversed here, since
% indexing starts at 1 in matlab
w_k = w/DX;

ind_even = 1:2:N;
A_k(ind_even) = 1./sqrt(0.5 * DX * (1 + sin(w(ind_even))./w(ind_even)));
p_k(ind_even) = -mx*w(ind_even)/DX + pi/2;

ind_odd = 2:2:N;
A_k(ind_odd) = 1./sqrt(0.5 * DX * (1 - sin(w(ind_odd))./w(ind_odd)));
p_k(ind_odd) = -mx*w(ind_odd)/DX;

sin_rep_k = [A_k; w_k; p_k];
r_i_k = sin_eval(x, sin_rep_k);

function [y_i_k] = sin_eval(x_i, sin_rep_k)
A_k=sin_rep_k(1,:); 
w_k=sin_rep_k(2,:); 
p_k=sin_rep_k(3,:); 
y_i_k = binfun(@times, A_k, sin(binfun(@plus, x_i*w_k, p_k)));


function w=compute_freqs(b, N)
% LeMaitre2010, Eq. (2.24)
f1 = @(w)(1-b*w.*tan(w/2));
f2 = @(w)(b*w+tan(w/2));
delta=1e-10;

n=0; w=nan(1,N);
while true
    w(n+1)=fzero(f1, [n*pi+delta, (n+1)*pi-delta]);
    n=n+1;
    if n==N; break; end
    
    w(n+1)=fzero(f2, [n*pi+delta, (n+1)*pi-delta]);
    n=n+1;
    if n==N; break; end
end
