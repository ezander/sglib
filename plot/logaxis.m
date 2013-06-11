function logaxis( ha, which, logscale )
% LOGAXIS Set axis type from linear to logarithmic or vice versa.
%   LOGAXIS( HA, WHICH ) sets the scaling type of all axes specified why
%   the string WHICH of axis object HA (must be specified, for the current
%   one use GCA) to logarithmic. Which can contain any sequence of the
%   characters 'x', 'y' and 'z' (upper- and lowercase), e.g. 'xy'.
%   LOGAXIS( HA, WHICH, LOGSCALE ) sets the axes scaling to logarithmic if
%   LOGSCALE is TRUE or to linear if LOGSCALE is FALSE.
%
% Example (<a href="matlab:run_example logaxis">run</a>)
%    x=linspace(0.1,3); y=x.^3;
%    plot( x, y ); legend( 'y=x^3' );
%    disp( 'Both axes linear. Press enter to continue...' ); pause;
%    logaxis( gca, 'y' );
%    disp( 'Y now logarithmic. Press enter to continue...' ); pause;
%    logaxis( gca, 'xy', true );
%    disp( 'Both now logarithmic. Press enter to continue...' ); pause;
%    logaxis( gca, 'y', false );
%    disp( 'Y back to linear. Press enter to continue...' ); pause;
%    
%
% See also SET, SEMILOGX, SEMILOGY, LOGLOG

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


if nargin<3 || logscale 
    scaling='log';
else
    scaling='linear';
end    

if isempty(ha)
    ha=gca;
end

for i=1:length(which)
    c=which(i);
    switch lower(c)
        case {'x', 'y', 'z'}
            set( ha, [c 'scale'], scaling );
        otherwise
            error( 'logaxis:evalin', 'wrong axis spec: %s', which );
    end
end
