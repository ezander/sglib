function init_contrib
% INIT_CONTRIB Init third-party software.
%   INIT_CONTRIB Long description of init_contrib.
%
% Example (<a href="matlab:run_example init_contrib">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[available,tt_path]=tt_available();
if available
    fprintf( 'Contrib: Tensor toolbox found. Adding path\n' );
    addpath( tt_path );
    addpath( fullfile( tt_path, 'algorithms') );
else
    fprintf( 'Contrib: Tensor toolbox not found. Disabled.\n' );
end


p=toolboxdir('');
s=dir(p);
for i=3:length(s)
    switch s(i).name
        case {'matlab', 'pde', 'shared', 'local' }
            % pass
        otherwise
            state=warning( 'off', 'MATLAB:rmpath:DirNotFound' );
            rmpath( genpath( fullfile( p, s(i).name ) ) );
            warning(state);
    end
end


