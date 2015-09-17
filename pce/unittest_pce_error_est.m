function unittest_pce_error_est
% UNITTEST_PCE_ERROR_EST Test the PCE_ERROR_EST function.
%
% Example (<a href="matlab:run_example unittest_pce_error_est">run</a>)
%   unittest_pce_error_est
%
% See also PCE_ERROR_EST, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'pce_error_est' );

Ix=multiindex(4,2);
Iy=multiindex(4,3);
Mx=size(Ix,1);
My=size(Iy,1);
N=10;
x_i_alpha=rand(N,Mx);
d_i_alpha=rand(N,My-Mx);
y_i_alpha=[x_i_alpha, d_i_alpha];
[dummy,ex]=pce_moments( [zeros(N,Mx), d_i_alpha], Iy );
ex=sqrt(ex);
assert_equals( ex, pce_error_est( x_i_alpha, Ix, y_i_alpha, Iy ), 'xy' );
assert_equals( ex, pce_error_est( y_i_alpha, Iy, x_i_alpha, Ix ), 'yx' );

px=[1, randperm( Mx-1 )+1];
py=[1, randperm( My-1 )+1];
x_i_alpha=x_i_alpha(:,px);
Ix=Ix(px,:);
y_i_alpha=y_i_alpha(:,py);
Iy=Iy(py,:);
assert_equals( ex, pce_error_est( x_i_alpha, Ix, y_i_alpha, Iy ), 'pxpy' );







