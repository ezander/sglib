function test_normalize_pce
% TEST_NORMALIZE_PCE Test the normalize_pce function.
%
% Example (<a href="matlab:run_example test_normalize_pce">run</a>) 
%    test_normalize_pce
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


assert_set_function( 'normalize_pce' );

[pcc,pci]=pce_expand_1d( @exp, 7 );
pcc_normed=normalize_pce( pcc, pci );
assert_equals( pcc_normed, pcc.*sqrt(factorial(0:7)), 'normed' );
pcc_normed=normalize_pce( pcc, pci, false );
assert_equals( pcc_normed, pcc.*sqrt(factorial(0:7)), 'normed' );

pcc_unnormed=normalize_pce( pcc_normed, pci, true );
assert_equals( pcc_unnormed, pcc, 'unnormed' );
