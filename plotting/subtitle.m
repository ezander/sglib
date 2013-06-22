function subtitle( str, varargin )
% SUBTITLE Create a title over multiple subplots.
%   SUBTITLE(STR, VARARGIN) plots a title over all subplots generated with
%   the SUBPLOT command (in contrast the TITLE command only makes a title
%   for each subplot separately).
%
% Options:
%   position:  {0.97}
%     relative vertical position for the display of the title. 1.0 is
%     topmost, 0.0 bottommost, the default is hopefully a good compromise.
%   interpreter:  tex, {latex}, none
%     If set to tex or latex the title text is interpreted according to
%     tex/latex rules.
%
% Example (<a href="matlab:run_example subtitle">run</a>)
%     x=linspace(0,2*pi);
%     clf;
%     subplot(1,2,1); plot(x,sin(x)); title('Sin'); axis square;
%     subplot(1,2,2); plot(x,cos(x)); title('Cos'); axis square;
%     subtitle('Trigonometric functions');
%
% See also SUBPLOT, TITLE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[position,options]=get_option( options, 'position', 0.97 );
[interpreter,options]=get_option( options, 'interpreter', 'latex' );
check_unsupported_options( options, mfilename );

ha=findall( gcf, 'Tag', 'SubTitle' );
if ~isempty(ha)
    delete(ha);
end
axes('Position', [0, 0, 1, position], 'Xlim',[0, 1],'Ylim',[0, 1],'Box','off','Visible','off','Units', 'normalized', 'clipping', 'off', 'Tag', 'SubTitle');

text( 0.5, 1, str ,'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Interpreter', interpreter );
