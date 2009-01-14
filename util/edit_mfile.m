function edit_mfile( filename )
% EDIT_MFILE Edit a new or existing m-file in the editor.
%   EDIT_MFILE( FILENAME ) opens the m-file named by FILENAME in the Matlab
%   internal editor. If FILENAME doesn't end in '.m' it is appended. This
%   function also opens the editor for not-yet-existing files if they are
%   not in the current directory (which the internal EDIT command doesn't,
%   it issues an error in this case, very annoyingly...).
%
% Example
%   edit_mfile private/my_priv_func
%
% See also EDIT

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if ~strcmp( filename(end-1:end), '.m' )
    filename=[filename '.m'];
end

com.mathworks.mlservices.MLEditorServices.openDocument( filename );
