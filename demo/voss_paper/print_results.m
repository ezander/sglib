function print_results( variable, fields, ps_results )
% PRINT_RESULTS Short description of print_results.
%   PRINT_RESULTS Long description of print_results.
%
% Example (<a href="matlab:run_example print_results">run</a>)
%
% See also

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


% print the results
%fields=fieldnames(ps_results);
for i=1:length(fields)
    if ischar(fields{i})
        name=fields{i};
    else
        name=fields{i}{1};
    end
    fprintf('%s\n', name );
    disp( cell2mat(ps_results.(name)) );
end