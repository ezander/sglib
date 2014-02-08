function unittest_gpcgerm_pdf
% UNITTEST_GPCGERM_PDF Test the GPCGERM_PDF function.
%
% Example (<a href="matlab:run_example unittest_gpcgerm_pdf">run</a>)
%   unittest_gpcgerm_pdf
%
% See also GPCGERM_PDF, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcgerm_pdf' );

x = linspace(-3,3);
y = rand(size(x));

V=gpcbasis_create('h');
assert_equals(gpcgerm_pdf(V,x), normal_pdf(x), 'h');

V=gpcbasis_create('pl');
assert_equals(gpcgerm_pdf(V,[x;y]), uniform_pdf(x,-1,1).*exponential_pdf(y,1), 'pl');

V=gpcbasis_create('h', 'm', 2);
assert_equals(gpcgerm_pdf(V,[x;y]), normal_pdf(x).*normal_pdf(y), 'h2');

