function study_results=ps_numiter_by_reltol_ratio( varargin )
% STUDY_NUMITER_BY_RELTOL_RATIO Study effect of reltol and mean/variance ratio on number of iterations.
%
% Example (<a href="matlab:run_example ps_numiter_by_reltol_ratio">run</a>)
%   study_numiter_by_reltol_ratio
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

% set default parameters
defaults=struct();

% set parameters to vary
variable.m={1,2,5,10,20,50};
variable.p={1,2,3,4,5};

% set return fields
fields={...
    {'M','M'}, ...
    {'numel', 'numel'}, ...
    {'nnz', 'nnz'}, ...
    {'sparsity', 'nnz/numel'}
    };

% run parameter study
ps_options={'cache', true, 'cache_file', mfilename };
ps_results=param_study( 'build_multiindex', variable, defaults, fields, ps_options{:}, varargin{:} );

print_results( variable, fields, ps_results );

write_tex_tabular( '', ps_results.M, 'row_values', variable.m, 'col_values', variable.p, 'table_format', '%d' )
%write_tex_tabular( 'tab.tex', ps_results.M, 'row_values', variable.m,
%'col_values', variable.p, 'table_format', '%d' )
write_tex_tabular( 'tab.tex', ps_results.M, 'col_values', variable.p, 'hline', true, 'table_format', '$a^{10}$ %d' )

