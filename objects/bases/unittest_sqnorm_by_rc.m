function unittest_sqnorm_by_rc(varargin)
% UNITTEST_SQNORM_BY_RC Test the SQNORM_BY_RC function.
%
% Example (<a href="matlab:run_example unittest_sqnorm_by_rc">run</a>)
%   unittest_sqnorm_by_rc
%
% See also SQNORM_BY_RC, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'sqnorm_by_rc' );

rc_P = [
    0, 1, 0;
    0, 3/2, 1/2;
    0, 5/3, 2/3;
    0, 7/4, 3/4;
    0, 9/5, 4/5];

assert_equals(sqnorm_by_rc(rc_P), 1./(1:2:9)', 'Legendre_P');

rc_H = [
    0, 1, 0;
    0, 1, 1;
    0, 1, 2;
    0, 1, 3];

assert_equals(sqnorm_by_rc(rc_H), factorial(0:3)', 'Hermite_H');
