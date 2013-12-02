function unittest_point_projector
% UNITTEST_POINT_PROJECTOR Test the POINT_PROJECTOR function.
%
% Example (<a href="matlab:run_example unittest_point_projector">run</a>)
%   unittest_point_projector
%
% See also POINT_PROJECTOR

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'point_projector' );

% check that linear function is reproduced and that P sums up to 1
[pos,els]=create_mesh_1d( 2, 5, 37, true );
P=point_projector( pos, els, 2.3 );
assert_equals( sum(P), 1, 'unity' );
assert_equals( P*pos', 2.3, 'single' );

% check that it works if the point is a grid point
P=point_projector( pos, els, pos(2) );
assert_equals( P*pos', pos(2), 'exact1' );
P=point_projector( pos, els, pos(3) );
assert_equals( P*pos', pos(3), 'exact2' );

% check that its the value at the point if the point is a grid point
[pos,els]=create_mesh_1d( 2, 5, 6, false );
P=point_projector( pos, els, pos(3) );
assert_equals( P, unitvector(3,6)', 'match1' );


% check for 2d
[pos,els]=create_mesh_2d_rect( 3 );
x=[0.55; 0.42];
P=point_projector( pos, els, x );
assert_equals( sum(P), 1, 'sum1' );
assert_equals( P*ones(size(pos,2),1), 1, 'const1' );
assert_equals( P*pos(1,:)', x(1), 'x' );
assert_equals( P*pos(2,:)', x(2), 'y' );

P1=point_projector( pos, els, pos(:,7) );
assert_equals( P1, unitvector(7,size(pos,2))', 'match7' );
P2=point_projector( pos, els, pos(:,17) );
assert_equals( P2, unitvector(17,size(pos,2))', 'match17' );
P12=point_projector( pos, els, [pos(:,7), pos(:,17)] );
assert_equals( P12, [P1; P2], 'twopoints' );



l=rand(1,3); l=l/sum(l);
x=pos(:,els(:,4))*l';
Pex=zeros(1,size(pos,2));
Pex(els(:,4))=l;
Pex=sparse(Pex);
P=point_projector( pos, els, x );
assert_equals( P, Pex, 'lincom' );

