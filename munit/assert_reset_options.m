function options=assert_reset_options
% ASSERT_RESET_OPTIONS Resets the permanent options.
%   ASSERT_RESET_OPTIONS() resets the permanent options to their default
%   values.
%
%   OPTIONS=ASSERT_RESET_OPTIONS() returns the default options that would
%   be set by ASSERT_RESET_OPTIONS() without actually setting them.
%
% Example (<a href="matlab:run_example assert_reset_options">run</a>)
%   % Set options to some non standard values
%   assert_set_option( 'reltol', 1e-8 );
%   % Reset all options
%   assert_reset_options();
%   % ... or selectively
%   defopts=assert_reset_options();
%   assert_set_option( 'reltol', defopts.reltol );
%
% See also ASSERT, ASSERT_SET_OPTION

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


options.module_name='<not set>';
options.function_name='<not set>';
options.debug=false;
options.abstol=1e-8;
options.reltol=1e-8;
options.max_assertion_disp=10;
options.output_func=@display_func;

if nargout<1
    assert_set_option( options );
end


function display_func( s )
stdin=1;
fprintf( stdin, '%s\n', s );
