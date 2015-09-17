function unittest_rosenbrock
% UNITTEST_ROSENBROCK Test the ROSENBROCK function.
%
% Example (<a href="matlab:run_example unittest_rosenbrock">run</a>)
%   unittest_rosenbrock
%
% See also ROSENBROCK, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'rosenbrock' );

x = rand(2,1);
del = 1e-8;

test_dy(@rosenbrock, x, del)
test_ddy(@rosenbrock, x, del)


munit_set_function( 'rosenbrock_nd1' );

x = rand(3,1);
del = 1e-8;

test_dy(@rosenbrock_nd1, x, del)
test_ddy(@rosenbrock_nd1, x, del)


k=3;
x=13.45123;

% f1_func = @(x)(exp(-(x/k).^2));
% df1_func = @(x)(-2*x/k^2.*exp(-(x/k).^2));
% f2_func = @(x)(atan(x/k)*2/pi).^2;
% df2_func = @(x)(4/pi/k./(1+(x/k).^2).*(atan(x/k)*2/pi)); 
f_func = @(x)((exp(-(x/k).^2)) + (atan(x/k)*2/pi).^2);
df_func = @(x)(-2*x/k^2.*exp(-(x/k).^2) + 4/pi/k./(1+(x/k).^2).*(atan(x/k)*2/pi)); 
func = func_combine_f_df(f_func, df_func);
test_dy(func, x, del)


function test_dy(func, x, del)
[y1,dy1]=funcall(func, x);
d = size(x,1);

for i=1:d
    dx = del * unitvector(i, d);
    [y2, dy2] = funcall(func, x+dx);
    assert_equals((dy1(i)+dy2(i))*0.5, (y2-y1)/del, 'dy', 'reltol', 1e-5 )
end

function test_ddy(func, x, del)
[~,dy1,ddy1]=funcall(func, x);
d = size(x,1);

for i=1:d
    dx = del * unitvector(i, d);
    [~, dy2, ddy2] = funcall(func, x+dx);
    assert_equals((ddy1(:,i)+ddy2(:,i))*0.5, (dy2-dy1)/del, 'ddy', 'reltol', 1e-5 )
end

