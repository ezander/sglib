function unittest_gpc_evaluate
% UNITTEST_GPC_EVALUATE Test the GPC_EVALUATE function.
%
% Example (<a href="matlab:run_example unittest_gpc_evaluate">run</a>)
%   unittest_gpc_evaluate
%
% See also GPC_EVALUATE, TESTSUITE 

%   <author>
%   Copyright 2012, <institution>
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_evaluate' );


I_a = multiindex(1, 5);
a_i_alpha = eye(6);

xi = linspace(-1,1,10000);
a=gpc_evaluate(a_i_alpha, {'Ln', I_a}, xi);
for i=1:6
    for j=1:6
        h = (xi(2)-xi(1));
        D(i,j) = h * sum(0.5 * a(i,:) .* a(j,:));
    end
end
D


xi = linspace(-4,4,100000);
a=gpc_evaluate(a_i_alpha, {'Hn', I_a}, xi);
for i=1:6
    for j=1:6
        h = (xi(2)-xi(1));
        D(i,j) = h * sum(1/sqrt(2*pi) * exp(-xi.^2/2) .* a(i,:) .* a(j,:));
    end
end
D

return 

I_a = multiindex(1, 5);
xi = linspace(-1,1,100);
a_i_alpha = eye(6);

a=gpc_evaluate(a_i_alpha, {'L', I_a}, xi);
subplot(2,2,1)
plot(xi,a)
grid on

a=gpc_evaluate(a_i_alpha, {'Ln', I_a}, xi);
subplot(2,2,2)
plot(xi,a)
grid on

a=gpc_evaluate(a_i_alpha, {'H', I_a}, xi);
subplot(2,2,3)
plot(xi,a)
grid on

a=gpc_evaluate(a_i_alpha, {'Hn', I_a}, xi);
subplot(2,2,4)
plot(xi,a)
grid on



return




I_a=multiindex( 2, 3 );
a_i_alpha=cumsum(ones( 5, 10 ));
xi=reshape( linspace( -1, 1, 14 ), 2, [] );

expect=[
   3.93263541192535   2.88757396449704   1.01228948566227  -0.99408284023669  -2.43240782885753  -2.60355029585799  -0.80837505689577
   7.86527082385071   5.77514792899408   2.02457897132453  -1.98816568047337  -4.86481565771507  -5.20710059171598  -1.61675011379153
  11.79790623577606   8.66272189349112   3.03686845698680  -2.98224852071006  -7.29722348657260  -7.81065088757396  -2.42512517068730
  15.73054164770141  11.55029585798816   4.04915794264907  -3.97633136094675  -9.72963131543013 -10.41420118343195  -3.23350022758306
  19.66317705962676  14.43786982248521   5.06144742831133  -4.97041420118343 -12.16203914428766 -13.01775147928994  -4.04187528447883];
actual=gpc_evaluate( a_i_alpha, {'L', I_a}, xi );
%actual=pce_evaluate( a_i_alpha, I_a, xi );
assert_equals( actual, expect, '' );

