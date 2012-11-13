function err=pce_error_mc(pce_func1, pce_func2, m, varargin)
% PCE_ERROR_MC Evalutes the difference between two PCE reps .
%   PCE_ERROR_MC Long description of pce_error_mc.
%
% Example (<a href="matlab:run_example pce_error_mc">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[num_mc,options]=get_option(options,'num_mc',100);
[block,options]=get_option(options,'block',100);
[G,options]=get_option(options,'G',[]);
check_unsupported_options(options,mfilename);

err=0;
nblocks=ceil(num_mc/block);
xx=0;
for j=1:nblocks
    if j==nblocks
        block=num_mc-block*(nblocks-1);
    end
    xi=randn(m,block);
    u1=funcall( pce_func1, xi );
    u2=funcall( pce_func2, xi );
    du=u1-u2;
    if isempty( G )
        err=err+sum(sum(du.*du));
    else
        err=err+sum(sum(du.*(G*du)));
    end
    xx=xx+block;
end
if xx~=num_mc
    keyboard;
end
err=sqrt(err/num_mc);

