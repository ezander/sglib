function unittest_pce_expand_1d_mc
% UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion
%
% Example (<a href="matlab:run_example unittest_pce_expand_1d">run</a>)
%    unittest_pce_expand_1d_mc
%
% See also PCE_EXPAND_1D_MC, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'pce_expand_1d_mc' );


%% Lognormal distribution: comparison between analytical and MC solution
N=10000;
Log_h={@lognormal_stdnor,{3,0.5},{2,3}};
Log_data=funcall(Log_h,randn(N*10,1));
Log_alpha_mc=pce_expand_1d_mc(Log_data,5);

Log_alpha_ex=exp(3.125)./factorial(0:5).*(0.5.^(0:5));
mc_options.abstol=1e-2;
mc_options.reltol=10/sqrt(N);
mc_options.fuzzy=true;
assert_equals( Log_alpha_mc(1:3), Log_alpha_ex(1:3), 'mc_data', mc_options );

