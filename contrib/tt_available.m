function [bool,path]=tt_available(error_if_not)
% TT_AVAILABLE Short description of tt_available.
%   TT_AVAILABLE Long description of tt_available.
%
% Example (<a href="matlab:run_example tt_available">run</a>)
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

currpath=fileparts( mfilename('fullpath') );
path=fullfile( currpath, 'tensor_toolbox');
bool=exist(path, 'dir' );

if ~bool && nargin>=1 && error_if_not
    error( 'contrib:tensor_toolbox', 'TensorToolbox not found. Please install or link to under: %s', path );
end
