function unittest_pce_hermite_val
% UNITTEST_PCE_HERMITE_VAL Test the PCE_HERMITE_VAL function.
%
% Example (<a href="matlab:run_example unittest_pce_hermite_val">run</a>)
%   unittest_pce_hermite_val
%
% See also PCE_HERMITE_VAL, TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'pce_hermite_val' );

x=10i;
for i=3:6
    a=zeros(1,8);
    a(i)=1;
    assert_equals( hermite_val(a,x), pce_hermite_val(a,x,0), 'e' );
end

a=rand(1,8);
x=rand(7,1);
assert_equals( hermite_val(a,x), pce_hermite_val(a,x,0), 'rnd' );
