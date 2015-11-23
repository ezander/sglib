function inds=gpcbasis_poly_ind(V)
% GPCBASIS_POLY_IND Extract information about equal 1d bases from GPC basis.
%   INDS=GPCBASIS_POLY_IND(V) returns information about equal 1D orthogonal
%   polynomial bases that occur in the GPC basis. This is used internally
%   to speed up certain computations.
%
% Example (<a href="matlab:run_example gpcbasis_poly_ind">run</a>)
%   V = gpcbasis_create('hlhlh');
%   inds=gpcbasis_poly_ind(V);
%   strvarexpand('$inds$');
%
% See also GPC

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

syschars = V{1};
m=gpcbasis_size(V,2);

if length(syschars)==1
    inds = {{syschars, true(1,m)}};
else
    inds = {};
    done = false(m,1);
    for i=1:m
        if done(i);
            continue;
        end
        syschar = syschars(i);
        syschar_ind = (syschars==syschar);
        inds{end+1} = {syschar, syschar_ind}; %#ok<AGROW>
        done(syschar_ind) = true;
    end
end
