function [U,I]=combine_dimensions(T,I_1,I_2)
% COMBINE_DIMENSIONS Short description of combine_dimensions.
%   COMBINE_DIMENSIONS Long description of combine_dimensions.
%
% Example (<a href="matlab:run_example combine_dimensions">run</a>)
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

I_1=multiindex( 2, 2 )
I_2=multiindex( 3, 1 )

[A,B,C]=multiindex_combine( {I_1, I_2}, -1 )

1;

