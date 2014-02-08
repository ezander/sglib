function unittest_ismatoct
% UNITTEST_ISMATOCT Test the IS_MATLAB/IS_OCTAVE functions.
%
% Example (<a href="matlab:run_example unittest_ismatoct">run</a>)
%    unittest_ismatoct
%
% See also IS_MATLAB, IS_OCTAVE, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'ismatlab' );

isml=ismatlab;
assert_true( isml==true || isml==false, 'function must return a boolean value' );

munit_set_function( 'isoctave' );

isoct=isoctave;
assert_true( isoct==true || isoct==false, 'function must return a boolean value' );

assert_true( isoct~=isml, 'is_matlab and is_octave must return different values' );
