function unittest_gvector_error
% UNITTEST_GVECTOR_ERROR Test the GVECTOR_ERROR function.
%
% Example (<a href="matlab:run_example unittest_gvector_error">run</a>)
%   unittest_gvector_error
%
% See also GVECTOR_ERROR, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gvector_error' );


TA=rand(4,1);
TE=rand(4,1);
DT=TE-TA;
assert_equals( gvector_error(TA, TE), norm(DT,2), 'norm2' );
assert_equals( gvector_error(TA, TE, []), norm(DT,2), 'norm2b' );
assert_equals( gvector_error(TA, TE, [], true), norm(DT,2)/norm(TE,2), 'relnorm2' );


L=rand(4,4);
G=L*L';
assert_equals( gvector_error(TA, TE, G), sqrt(DT'*G*DT), 'normG' );
assert_equals( gvector_error(TA, TE, G, true), sqrt(DT'*G*DT)/sqrt(TE'*G*TE), 'relnormG' );

% Separated
TA={rand(4,2), rand(5,2)};
DT={rand(4,1), rand(5,1)};
TE=tensor_add( TA, DT );
L1=rand(4,4);
L2=rand(5,5);
G={L1*L1', L2*L2'};
assert_equals( gvector_error(TA, TE), tensor_norm(DT), 'canon' );
assert_equals( gvector_error(TA, TE, G), tensor_norm(DT, G), 'canonG' );
