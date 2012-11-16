function norm_I=gpc_norm( V )
% GPC_NORM Compute the norm of the system of GPC polynomials.
%  NORM_I=GPC_NORM( V ) returns the norms of the GPC
%  polynomials specified by the V. The returned vector
%  is a column vector.
%
% Example (<a href="matlab:run_example gpc_norm">run</a>)
%  I_u=[0 0; 1 1; 2 2; 2 3; 3 3];
%  V_u={'H', I_u};
%  norm_I_u=gpc_norm(V_u);
%  fprintf('|H_{%1d,%1d}| => %g\n', [I_u norm_I_u]')
%  
%  V_u={'HP', I_u};
%  norm_I_u=gpc_norm(V_u);
%  fprintf('|H_{%1d}P_{%1d}| => %g\n', [I_u norm_I_u]')
%
% See also GPC

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

sys = V{1};
I = V{2};
m = size(I,2);
assert(length(sys)==1 || length(sys)==m)

if length(sys)==1
    N = max(max(I));
    nrm = polysys_sqnorm(sys, 0:N);
    % Note: the reshape in the next line is necessary, as otherwise, if I
    % is just a column vector it would be transformed into a row vector
    norm_I=sqrt(prod(reshape(nrm(I+1), size(I)), 2));
else
    norm2_I = ones(size(I,1), 1);
    for j = 1:m
        N = max(max(I(:,j)));
        nrm2 = polysys_sqnorm(sys(j), (0:N)');
        norm2_I=norm2_I .* nrm2(I(:,j)+1);
    end
    norm_I = sqrt(norm2_I);
end

