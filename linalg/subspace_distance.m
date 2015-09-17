function dist=subspace_distance(A, B, varargin)
% SUBSPACE_DISTANCE Compute distance between subspaces.
%   DIST=SUBSPACE_DISTANCE(A, B) computed the distance between the
%   subspaces A and B.
%
% Options
%   type: {'mlab'}, 'gv', 'wwf'
%       Compute the distance compatible to the matlab subspace functions
%       ('mlab', default), according to [1] section 2.6.3 ('gv'), or
%       according to 2 ('wwf'). Note, that the last method only works, if
%       the subspaces have the same size. Note further, that in that case
%       method 'mlab' and 'gv' coincide.
%  
% References
%   [1] G. Golub and C. F. Van Loan, Matrix Computations, 3rd ed. John
%       Hopkins University Press, 
%   [2] Xi-Chen Sun, Xiao Wang, Qiansheng Cheng, Jufu Feng: On Subspace
%       Distances, LMAM, School of Mathematical Sciences,Peking
%       www.math.pku.edu.cn:8000/var/preprint/620.pdf‎ 
% 
% Example (<a href="matlab:run_example subspace_distance">run</a>)
%   A=rand(10,3);
%   B=rand(10,5);
%   subspace_distance(A, B)
%   subspace_distance(A, B, 'type', 'gv')
%
%   B=rand(10,3);
%   subspace_distance(A, B)
%   subspace_distance(A, B, 'type', 'gv')
%   subspace_distance(A, B, 'type', 'wwf')
%
% See also SUBSPACE, SUBSPACE_ANGLES

%   Elmar Zander
%   Copyright 2010-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[type,options]=get_option(options, 'type', 'mlab');
check_unsupported_options(options, mfilename);

U=orth(A);
V=orth(B);
switch type
    case 'mlab'
        if size(U,2)<size(V,2)
            dist=norm(U-V*V'*U, 2);
        else
            dist=norm(V-U*U'*V, 2);
        end
    case 'gv'
        dist=norm(V*V'-U*U', 2);
    case 'wwf'
        [m, n]=size(U);
        check_boolean(all(size(V)==[m,n]), 'size error', mfilename);
        UV=U'*V;
        dist=sqrt(max(min(m,n)-frobenius_inner(UV,UV),0));
        %%
        % Note: probably there is an error in [2] and it should read
        % min(m,n) instead of max(m,n). Further, we need to clamp the value
        % to be always positive.
    otherwise
        error('sglib:subspace_distance', 'Unknown distance type: %s', type);
end
