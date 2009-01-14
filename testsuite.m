function testsuite( debug )
% TESTSUITE Run all unit tests in this directory.
%   TESTSUITE( DEBUG ) runs all tests in this dir with debug settings to
%   DEBUG (i.e. true or false). If DEBUG is not specified the current
%   setting is retained.
%
% Example
%   testsuite( true );
%
% See also 

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_reset_options();
if nargin>0
    assert_set_debug( debug );
end

if isnativesglib
  disp( 'testsuite: using native sglib' );
else
  disp( 'testsuite: using m-files only ' );
end

assert_run_testsuite( 'ssfem', pwd );
