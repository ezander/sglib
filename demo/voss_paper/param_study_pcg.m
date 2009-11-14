%function param_study_pcg(varargin)
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
%variable.reltol={1e-4,1e-6,1e-8};
variable.reltol={1e-4};
variable.eps={1e-6,1e-8,1e-20};

s=param_study( 'test_solver', variable, defaults, {'relerr','relres', 'iter', 'flag', 'rank'} );
%clc
s.relerr
s.relres
s.iter
s.flag
s.rank
