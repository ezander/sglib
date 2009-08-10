function test_apply_stochastic_operator

% TEST_APPLY_STOCHASTIC_OPERATOR Test apply_stochastic_operator function.
% Example (<a href="matlab:run_example test_apply_stochastic_operator">run</a>) 
%    test_apply_stochastic_operator
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id: test_apply_stochastic_operator.m 316 2009-07-16 12:05:58Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'apply_stochastic_operator' );

for i=1:2
    for j=1:2
        A{i,j}=rand(3,3);
        B{i,j}=zeros(2);
        B{i,j}(i,j)=1;
    end
    x{i,1}=rand(3,1);
    y{i,1}=zeros(3,1);
end
for i=1:2
    for j=1:2
        y{i}=y{i}+A{i,j}*x{j};
    end
end

% check that we've set up everysthing correctly
assert_equals( cell2mat(y), cell2mat(A)*cell2mat(x), 'prelim' );


apply_stochastic_operator( A, cell2mat(x') )
KC={A{1}, B{1}, A(2:end), B(2:end)}';
apply_stochastic_operator( KC, cell2mat(x') )


