function [B, H] = qn_matrix_update(mode, B, H, y, s)
% QN_MATRIX_UPDATE Update a Quasi Newton matrix and/or its inverse.
%   [B, H] = QN_MATRIX_UPDATE(MODE, B, H, Y, S) updates the matrices B and
%   H, returning the updated matrices in B and H. B is usually (except for
%   Broyden) an approximation of the Hessian and H its inverses. The MODE
%   parameter determines how the update is done. The following values for
%   mode are allowed:
%      'DFP': Davidon-Fletcher-Powell update formula
%      'BFGS': Broyden-Fletcher-Goldfarb-Shanno update formula
%      'SR1': Symmetric-Rank1 update formula
%      'Broyden': the good Broyden's update formula
%   The MODE parameter is case insensitive, so that also 'dfp' instead of
%   'DFP' can be specified. If one of the matrix parameters B or H is empty
%   this matrix is not updated and the empty matrix returned as is. This
%   can be used, if only one of the updated matrices is needed in the
%   algorithm.
%
% References
%   [1] Nocedal, J. and Wright, S.J. (1999): Numerical Optimization,
%       Springer-Verlag. ISBN 0-387-98793-2.
%   [2] http://en.wikipedia.org/wiki/Quasi-Newton_methods
%
% See also MINFIND_QUASI_NEWTON, QUASINEWTONOPERATOR

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

switch lower(mode)
    case 'dfp'
        [B, H] = update_dfp(B, H, y, s);
    case 'bfgs'
        [B, H] = update_bfgs(B, H, y, s);
    case 'sr1'
        [B, H] = update_sr1(B, H, y, s);
    case 'broyden'
        [B, H] = update_broyden(B, H, y, s);
    otherwise
        error('sglib:update_matrix', 'Unknown matrix update: mode');
end

function [B, H] = update_dfp(B, H, y, s)
% UPDATE_DFP Implements the Davidon-Fletcher-Powell update formula.
rho = 1/(y'*s);
if ~isempty(B)
    % I=eye(size(B));
    % B = (I-rho*y*s')*B*(I-rho*s*y') + rho*(y*y');
    % The naive formula above needs O(N^3) operations, while the formula
    % below needs only O(N^2) and can be performed in-place
    Bs = B*s;
    Bsy = Bs*y';
    B=B+rho*(1+rho*s'*Bs)*(y*y')-rho*(Bsy'+Bsy);
end
if ~isempty(H)
    Hy = H*y;
    H = H + rho*(s*s') - Hy*Hy'/(y'*H*y);
end


function [B, H] = update_bfgs(B, H, y, s)
% UPDATE_BFGS Implements the Broyden-Fletcher-Goldfarb-Shanno update formula.
rho = 1/(y'*s);
if ~isempty(B)
    Bs = B*s;
    B = B + rho*(y*y') - Bs*Bs'/(s'*Bs);
end
if ~isempty(H)
    % I=eye(size(H));
    % H = (I-rho*s*y')*H*(I - rho*y*s') + rho*(s*s');
    % The naive formula above needs O(N^3) operations, while the formula
    % below needs only O(N^2) and can be performed in-place
    Hy=H*y;
    Hys = Hy*s';
    H=H+rho*(1+rho*y'*Hy)*(s*s')-rho*(Hys'+Hys);
end

function [B, H] = update_sr1(B, H, y, s)
% UPDATE_SR1 Implements the symmetric rank 1 update formula.
if ~isempty(B)
    yBs = y - B * s;
    B = B + yBs*yBs'/(yBs'*s);
end
if ~isempty(H)
    sHy = s - H*y;
    H = H + sHy*sHy'/(sHy'*y);
end

function [B, H] = update_broyden(B, H, y, s)
% UPDATE_BROYDEN Implements the good Broyden's update formula.
if ~isempty(B)
    B = B + (y-B*s)/(s'*s)*s';
end
if ~isempty(H)
    Hy = H*y;
    H = H + (s-Hy)*s'*H/(s'*Hy);
end
