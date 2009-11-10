function save_figure( basename, topic, varargin )
% SAVE_FIGURE Short description of save_figure.
%   SAVE_FIGURE Long description of save_figure.
%
% Example (<a href="matlab:run_example save_figure">run</a>)
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

epsdir='eps';
filename=sprintf( './%s/%s-%s.png', epsdir, basename, topic );
print( filename, '-dpng' );



save_eps( basename, topic )
