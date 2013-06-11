function unittest_pce_cdf_1d
% UNITTEST_PCE_CDF_1D Test the PCE_CDF_1D function.
%
% Example (<a href="matlab:run_example unittest_pce_cdf_1d">run</a>)
%   unittest_pce_cdf_1d
%
% See also PCE_CDF_1D, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'pce_cdf_1d' );

% X_alpha=[30, 12, 1];
% I_X=(0:2)';
% 
% y=pce_cdf( [-10 -8 -4 3]', X_alpha, I_X )
% x=linspace(-30,50);
% y=pce_cdf( x, X_alpha, I_X )
% plot(x,y)
% 
% X_alpha=[0 1 0];
% I_X=(0:2)';
% 
% clf
% hold on
% x=linspace(-3,3);
% y=pce_cdf( x, X_alpha, I_X, 'N', 1000000 );
% plot(x,y)
% 
% pce_cdf_1d( [-10 -8 -4 3]', X_alpha, I_X  )
