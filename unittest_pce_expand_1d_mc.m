function unittest_pce_expand_1d
% UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion
%
% Example (<a href="matlab:run_example unittest_pce_expand_1d">run</a>)
%    unittest_pce_expand_1d
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


assert_set_function( 'pce_expand_1d_mc' );


%% Lognormal distribution: comparison between analytical and MC solution
N=10000;
h={@lognormal_stdnor,{3,0.5},{2,3}};
lognor_data=funcall(h,randn(N*10,1));
pcc_mc=pce_expand_1d_mc(lognor_data,5);

pcc_ex=exp(3.125)./factorial(0:5).*(0.5.^(0:5));
mc_options.abstol=1e-2;
mc_options.reltol=10/sqrt(N);
mc_options.fuzzy=true;
assert_equals( pcc_mc(1:3), pcc_ex(1:3), 'mc_data', mc_options );

