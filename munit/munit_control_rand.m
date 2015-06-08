function sprev = munit_control_rand(what, arg)
% MUNIT_CONTROL_RAND Control the random number generation for munit.
%   MUNIT_CONTROL_RAND('seed') Sets the RNG to a default seed to have
%   always the same random numbers in a unittest.
%
%   MUNIT_CONTROL_RAND('seed', SEED) Sets the RNG to seed SEED to have
%   always the same random numbers in a unittest.
%
%   MUNIT_CONTROL_RAND('get_state') returns the current state of the RNG.
%   This is (I think) only used inside the MUNIT framework to store the
%   state before running each unittest.
%
%   MUNIT_CONTROL_RAND('set_state', STATE) sets the state of the RNG. This
%   is (I think) only used inside the MUNIT framework to restore the state
%   after running each unittest.
%
% Example (<a href="matlab:run_example munit_control_rand">run</a>)
%   % Inside a unittest that needs repeatable random numbers
%   munit_control_rand('seed', 1234);
%
% See also MUNIT_RUN_TESTSUITE, RNG, RAND, RANDN

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

switch(what)
    case 'seed'
        if nargin<2
            seed = 1234;
        else
            seed = arg;
        end
        sprev = rng(seed, 'v5uniform');
    case 'get_state'
        sprev = rng;
    case 'set_state'
        sprev = rng(arg);
    otherwise
        error('sglib:munit_control_rand', 'Unknown command: %s', what);
end
