function param_study_pcg(varargin)
% PARAM_STUDY_PCG Short description of param_study_pcg.
%   PARAM_STUDY_PCG Long description of param_study_pcg.
%
% Example (<a href="matlab:run_example param_study_pcg">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

clear

global ps_results

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
defaults.eps=1e-8;

%variable.trunc_mode={1,2,3};
%variable.orth_mode={'euc','klm'};
%variable.reltol={1e-4,1e-6,1e-7,1e-8};
%variable.eps={1e-6,1e-8,1e-10,1e-20};

%variable.reltol={1e-4,1e-5,1e-6,1e-7,1e-8};
%variable.eps={1e-6,1e-200};
%variable.eps={1e-200};
defaults.eps=0;
variable.reltol={1e-4,1e-5,1e-6,1e-7};
variable.dist_shift={0.1,0.2,0.3, 0.5,0.7, 1,2,3};

%variable.reltol={1e-4};
%variable.dist_shift={0.1};

assignin( 'base', 'NS_rebuild', false );

fields={'eps', 'reltol', 'relerr','relres', {'numiter', 'ifelse(flag==0,iter,inf)'}, {'rank', 'size(Ui2{1},2)'}};
ps_results=param_study( 'test_solver', variable, defaults, fields );
%clc

for i=1:length(fields)
    if iscell(fields{i})
        name=fields{i}{1}
    else
        name=fields{i};
    end
    
    fprintf('%s\n', name );
    disp( ps_results.(name) );
end
