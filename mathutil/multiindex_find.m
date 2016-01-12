function [ind_b, ind_a]=multiindex_find( I_a, I_b, varargin )
% MULTIINDEX_FIND Find a multiindex in a list of indices.
%   IND_B=MULTIINDEX_FIND( ALPHA, I_B ) tries to find the multiindex ALPHA
%   in the multiindex set I_B; if ALPHA cannot be found IND_B is zero,
%   otherwise ALPHA==I_B(IND_B,:) will hold.
%
%   IND_B=MULTIINDEX_FIND( I_A, I_B ) tries to find the multiindices in I_A
%   in the multiindex set given by I_B. Returned are the indices in I_B
%   where I_A was found and zero for each multiindex in I_A where no match
%   in I_B could be found.
%
%   [IND_B,IND_A]=MULTIINDEX_FIND( I_A, I_B ) tries to find the multiindices
%   in I_A in the multiindex set given by I_B. If a multiindex from I_A could
%   not be found no index is returned in IND_B; IND_A will contain all 
%   indices of I_A for which a matching multiindex could be found, such
%   that I_A(IND_A,:)==I_B(IND_B,:).
%
%   PR_AB=MULTIINDEX_FIND( I_A, I_B, 'as_operators', true ) returns a
%   prolongation operator PR_AB such that if R_I_ALPHA is a set of PCE
%   coefficients with respect to the basis I_A, then R_I_ALPHA*PR_AB are
%   the PCE coefficients w.r.t. the basis I_B (given that I_A is a subset
%   of I_B). Vice versa, PR_AB' is the restriction operator from I_B to
%   I_A.
%
% Example (<a href="matlab:run_example multiindex_find">run</a>)
%   I=multiindex(5,3);
%   I_a=[0 0 0 0 0; 0 1 0 0 2]; disp('indices to find:'); disp(I_a);
%   ind=multiindex_find( I_a, I );
%   disp('found at:'); disp(ind);
%   disp('check correctness:'); disp(I(ind,:));
%
% See also MULTIINDEX, ISMEMBER

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[as_operators, options]=get_option(options, 'as_operators', false);
check_unsupported_options(options);

if isoctave && size(I_a,2)==1
  I_a=[I_a, zeros(size(I_a,1),1)];
  I_b=[I_b, zeros(size(I_b,1),1)];
end

[found,ind]=ismember(I_a, I_b, 'rows'); 
if nargout>=2 || as_operators
    ind_b=ind(found);
    ind_a=find(found);
else
    ind_b=ind;
end

if as_operators
    Pr_ab = sparse(ind_a, ind_b, ones(size(ind_b)), size(I_a,1), size(I_b,1));
    ind_b = Pr_ab;
    if nargin>=2
        ind_a = Pr_ab';
    end
end
