function test_pce_functions
% TEST_PCE_FUNCTIONS Test the PCE_FUNCTION function.
%
% Example 
%    test_pce_functions
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if 0
    b=[];
    X=linspace(0.1,2,20);
    for x=X
        a=pce_function_polyexp( x, 0, 'sqrt', 'order', 5 );
        disp([a,x]);
        b=[b,a];
    end
    subplot(2,2,[1 3])
    plot(X,b,'o-',X,sqrt(X))
    subplot(2,2,2)
    plot(X,(b-sqrt(X))./X)
    subplot(2,2,4)
    plot(X,(b-sqrt(X)))
    return
end

if 0
    a_alpha=[0.5, 0.2, 0.03]; 
    P=2;
    I_a=(0:P)';
    [x_alpha,I_x]=pce_multiply( a_alpha, I_a, a_alpha, I_a );

    fprintf('==========================\n');
    format=[repmat('% 9.6g ',1,P+1) '\n'];
    fprintf(format, a_alpha(1:P+1));
    
    a_alpha=pce_sqrt( x_alpha, I_x, 'show_stats', true );
    fprintf(format, a_alpha(1:P+1));

    a_alpha=pce_sqrt( x_alpha, I_x, 'reltol', 1e-2, 'show_stats', true );
    fprintf(format, a_alpha(1:P+1));

    a_alpha=pce_function_polyexp( x_alpha, I_x, 'sqrt', 'order', 4 );
    a_alpha=pce_sqrt( x_alpha, I_x, 'u0', a_alpha, 'show_stats', true );
    fprintf(format, a_alpha(1:P+1));

    a_alpha=pce_function_polyexp( x_alpha, I_x, 'sqrt', 'order', 9 );
    a_alpha=pce_sqrt( x_alpha, I_x, 'u0', a_alpha, 'show_stats', true );
    fprintf(format, a_alpha(1:P+1));

    a_alpha=pce_function( x_alpha, I_x, 'sqrt' );
    a_alpha=pce_sqrt( x_alpha, I_x, 'u0', a_alpha, 'show_stats', true );
    fprintf(format, a_alpha(1:P+1));
    
    return
end


if 1
    P=3-2;
    a_alpha=0.2.^(0:P).*rand(1,P+1);
    a_alpha=[0.5, 0.2, 0.03]; P=2;
    I_a=(0:P)';
    [x_alpha,I_x]=pce_multiply( a_alpha, I_a, a_alpha, I_a );

    fprintf('==========================\n');
    format=[repmat('% 9.6g ',1,P+1) '\n'];
    fprintf(format, a_alpha(1:P+1));
    
    a_alpha_2=pce_sqrt( x_alpha, I_x );
    fprintf(format, a_alpha_2(1:P+1));

    a_alpha_2=pce_sqrt( x_alpha, I_x, 'reltol', 1e-2 );
    fprintf(format, a_alpha_2(1:P+1));

    a_alpha_2=pce_function_polyexp( x_alpha, I_x, 'sqrt', 'order', 9 );
    a_alpha_2=pce_sqrt( x_alpha, I_x, 'u0', a_alpha_2 );
    fprintf(format, a_alpha_2(1:P+1));
    return

    %a_alpha_3=pce_function( x_alpha, I_x, 'sqrt', 'ode_solver', @ode15s );
    a_alpha_3=pce_function( x_alpha, I_x, 'sqrt', 'ode_solver', @ode45 );
    fprintf(format, a_alpha_3(1:P+1));

    a_alpha_4=pce_function_polyexp( x_alpha, I_x, 'sqrt', 'order', 20 );
    fprintf(format, a_alpha_4(1:P+1));

    return
end










xi0=.1;
xi1=.2;
pce_function( [xi0 xi1 0 0 0 0 0 0 0], (0:8)', 'exp' )
exp(xi0+xi1^2/2)*xi1.^[0,1,2,3,4]./factorial([0,1,2,3,4])
pcc=pce_expand_1d( @(x)(exp(xi0+x*xi1) ), 8 )




assert_set_function( 'pce_function' );

e=exp(1);
options.x0=0;
options.u0=1;
assert_equals( pce_function( 0, 0, 'exp', options ), 1, 'exp(0)' );
assert_equals( pce_function( 1, 0, 'exp', options ), e, 'exp(1)' );
assert_equals( pce_function( 2, 0, 'exp', options ), e^2, 'exp(2)', 'reltol', 1e-6 );
assert_equals( pce_function( 4.5, 0, 'exp', options ), e^4.5, 'exp(4.5)', 'reltol', 1e-5 );

options.x0=1;
options.u0=0;
assert_equals( pce_function( 1, 0, 'log', options ), 0, 'log(1)' );
assert_equals( pce_function( e, 0, 'log', options ), 1, 'log(e)' );
assert_equals( pce_function( e^2, 0, 'log', options ), 2, 'log(e^2)', 'reltol', 1e-5 );

options.x0=1;
options.u0=1;
assert_equals( pce_function( 4, 0, 'sqrt', options ), 2, 'sqrt(4)', 'reltol', 1e-5 );
assert_equals( pce_function( 16, 0, 'sqrt', options ), 4, 'sqrt(16)', 'reltol', 1e-5 );
assert_equals( pce_function( 100, 0, 'sqrt', options ), 10, 'sqrt(100)', 'reltol', 1e-4 );
assert_equals( pce_function( 10000, 0, 'sqrt', options ), 100, 'sqrt(10000)', 'reltol', 1e-4 );


%assert_equals( pce_function( [1;2], [0 1], 'exp' ), 1, 'exp(1;2)' );
%assert_equals( pce_function( 4, 0, 'sqrt' ), 2, 'sqrt(4)', 'reltol', 1e-5 );
%assert_equals( pce_function( 16, 0, 'sqrt' ), 4, 'sqrt(16)', 'reltol', 1e-5 );

%return
P=3-2;
a_alpha=0.2.^(0:P).*rand(1,P+1);
I_a=(0:P)';
[x_alpha,I_x]=pce_multiply( a_alpha, I_a, a_alpha, I_a );

a_alpha_2=pce_sqrt( x_alpha, I_x );
%a_alpha_3=pce_function( x_alpha, I_x, 'sqrt', 'ode_solver', @ode15s );
a_alpha_3=pce_function( x_alpha, I_x, 'sqrt', 'ode_solver', @ode45 );

disp(a_alpha(1:P+1));
disp(a_alpha_2(1:P+1));
disp(a_alpha_3(1:P+1));

return

a_alpha_3=pce_function( x_alpha, I_x, 'exp' );
a_alpha_3

a_alpha_3=pce_function( x_alpha, I_x, 'log' );
a_alpha_3


