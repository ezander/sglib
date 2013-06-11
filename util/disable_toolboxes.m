function disable_toolboxes(varargin)
% DISABLE_TOOLBOXES Disable unneccsary toolboxes.
%   DISABLE_TOOLBOXES Removes all toolboxes from the matlab path except
%   core matlab toolboxes, the pde toolbox and the statistics toolbox.
%   Avoids some hassle with undefined variables that are defined as
%   function in some toolbox one never meant to use. 
%
%   Sorry: this function is currently not changeable via preferences.
%   Shoudl be done soon.
%
% Example (<a href="matlab:run_example disable_toolboxes">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

p=toolboxdir('');
s=dir(p);
for i=3:length(s)
    switch s(i).name
        case {'matlab', 'pde', 'shared', 'local', 'stats' }
            % pass
        otherwise
            state=warning( 'off', 'MATLAB:rmpath:DirNotFound' );
            rmpath( genpath( fullfile( p, s(i).name ) ) );
            fprintf( 'Disabling toolbox: %s\n', s(i).name );
            warning(state);
    end
end
