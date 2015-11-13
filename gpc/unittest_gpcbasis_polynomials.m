function unittest_gpcbasis_polynomials(varargin)
% UNITTEST_GPCBASIS_POLYNOMIALS Test the GPCBASIS_POLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_polynomials">run</a>)
%   unittest_gpcbasis_polynomials
%
% See also GPCBASIS_POLYNOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcbasis_polynomials' );

% Test 1 with large basis and formatting
V = gpcbasis_create('HL', 'I', [0 0; 1 0; 2 0; 1 2; 2 1; 2 2]);
poly_str_act = gpcbasis_polynomials(V, 'symbols', 'xy', 'format_opts', ...
    {'tight', false, 'rats', true});
poly_str_exp = {
    '1';
    'x';
    'x^2 - 1';
    'x (1/2y^2 - 2y + 1)';
    '-(x^2 - 1) (y - 1)';
    '(x^2 - 1) (1/2y^2 - 2y + 1)'};
assert_equals(poly_str_act, poly_str_exp, 'match');

% Test with symbol splitting
V = gpcbasis_create('LLL', 'I', [1 1 1]);
poly_str_act = gpcbasis_polynomials(V, 'symbols', 'xi,eta,zeta');
poly_str_exp = {'-(xi-1) (eta-1) (zeta-1)'};
assert_equals(poly_str_act, poly_str_exp, 'comma_split');

% Test with symbol cell array
V = gpcbasis_create('LLL', 'I', [1 1 1]);
poly_str_act = gpcbasis_polynomials(V, 'symbols', {'xi', 'eta', 'zeta'});
poly_str_exp = {'-(xi-1) (eta-1) (zeta-1)'};
assert_equals(poly_str_act, poly_str_exp, 'cell_array');

% Test with not enough symbol
V = gpcbasis_create('P', 'I', [1 1 1]);
state=warning('off', 'sglib:gpcbasis_polynomials');
poly_str_act = gpcbasis_polynomials(V, 'symbols', 'ab');
poly_str_exp = {'a b x3'};
assert_equals(poly_str_act, poly_str_exp, 'not_enough');
warning(state);

% Test that type is checked correctly
assert_error(funcreate(@gpcbasis_polynomials, V, 'symbols', 123), 'sglib:', 'wrong_arg');
