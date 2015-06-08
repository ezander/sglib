function unittest_carleman_sum(varargin)
% UNITTEST_CARLEMAN_SUM Test the CARLEMAN_SUM function.
%
% Example (<a href="matlab:run_example unittest_carleman_sum">run</a>)
%   unittest_carleman_sum
%
% See also CARLEMAN_SUM, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'carleman_sum' );

%% Hamburger moment problem with normal distribution

n=2:2:20;
m=cumprod(1:2:19);
S_ex = cumsum(m .^ (-1./n));

dist=gendist_create('normal', {0, 1});
S=carleman_sum(dist, 20);
assert_equals(S, S_ex, 'cs_normal_dist');

m=normal_raw_moments(1:20);
S=carleman_sum(m, []);
assert_equals(S, S_ex, 'cs_normal_moments');

%% Stieltjes moment problem with uniform distribution
n=1:20;
m=1./(n+1);
S_ex = cumsum(m .^ (-0.5 ./ n));

dist=gendist_create('uniform', {0, 1});
S=carleman_sum(dist, 20, 'hamburger', false);
assert_equals(S, S_ex, 'cs_uniform_stieltjes');

