% PARAM_STUDY_UNITTEST_SCRIPT Script used for unit-testing the PARAM_STUDY function.

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% inputs: a, b, x, y, str1, str2 (2*int, 2*double, 2*string)

% outputs: ab, z, res, info (int, double array, string, struct)

ab=a*b;
z=[x^a, y^b; x^b, y^a];
res=sprintf( '%s %d', str1, x );

info=struct();
info.u=x*y;
info.st=str2;
info.vals=[a,b,x,y];

