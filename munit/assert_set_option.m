function assert_set_option( varargin )
% ASSERT_SET_OPTION Sets options for the following assertions.
%   ASSERT_SET_OPTION( OPTIONS ) sets the options specified in the
%   structure OPTIONS. 
%
%   ASSERT_SET_OPTION( OPTION1, VALUE1, ...  ) sets the options specified
%   in the options strings and corresponding values. 
%
% Example
%   % Set the absolute tolerance generally to 0.0001
%   assert_set_options( 'abstol', 1e-4 );
%
% See also ASSERT

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


%TODO: options should be checked for valid names

assert( [], [], [], varargin{:} );
