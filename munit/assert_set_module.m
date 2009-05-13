function assert_set_module( mod_name )
% ASSERT_SET_MODULE Sets the module name for the following assertions.
%   ASSERT_SET_MODULE( MOD_NAME ) sets the module name to MOD_NAME for the
%   following assertions. Module doesn't stand here for some well defined
%   syntactic entity, but rather for some programmer-defined grouping of
%   functions.
%
% Example (<a href="matlab:run_example assert_set_module">run</a>)
%   assert_set_module( 'ssfem' );
%
% See also ASSERT, ASSERT_SET_FUNCTION

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


options.module_name=mod_name;
assert_set_option( options );
