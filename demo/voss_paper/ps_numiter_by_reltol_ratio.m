function ps_numiter_by_reltol_ratio
% PS_NUMITER_BY_RELTOL_RATIO Study effect of reltol and mean/variance ratio on number of iterations.
%
% Example (<a href="matlab:run_example ps_numiter_by_reltol_ratio">run</a>)
%   ps_numiter_by_reltol_ratio
%
% See also PARAM_STUDY

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

global ps_results

% set default parameters
defaults.N=51;
defaults.geom='1d';
defaults.dist='beta';
defaults.dist_params={4,2};
defaults.dist_shift=0.1;
defaults.dist_scale=1;
defaults.solver='cg';
defaults.reltol=1e-6;
defaults.trunc_mode=1;
defaults.orth_mode='euc';
defaults.eps_mode='fix';
defaults.eps=0;

% set parameters to vary
variable.reltol={1e-4,1e-5,1e-6,1e-7};
variable.dist_shift={0.1,0.2,0.3, 0.5,0.7, 1,2,3};

% set return fields
fields={'relerr', 'relres', {'numiter', 'ifelse(flag==0,iter,inf)'}, {'rank', 'size(Ui2{1},2)'}};

% run parameter study
ps_results=param_study( 'test_solver', variable, defaults, fields );

% print the results
fields=fieldnames(ps_results);
for i=1:length(fields)
    name=fields{i};
    fprintf('%s\n', name );
    disp( ps_results.(name) );
end
