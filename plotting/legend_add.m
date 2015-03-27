function legend_add( text )
% LEGEND_ADD Add entry to existing legend.
%   LEGEND_ADD(TEXT) adds legend entry TEXT to the exisiting legend for the
%   current plot. This way legends can be simply build up by calling
%   LEGEND_ADD after each call to PLOT (and after some HOLD ALL or HOLD
%   ON), instead of first storing each legend entry first into a cell array
%   and then calling LEGEND. 
%
% Note:
%   If TEXT is a number, it is first converted into a string using the '%g'
%   format.
%   If TEXT is a cell array, all entries are added sequentially.
%
% Example (<a href="matlab:run_example legend_add">run</a>)
%   clf; hold off;
%   x = linspace(0, 4*pi);
%   plot(x, sin(x)); legend_add('sin'); hold all;
%   plot(x, cos(x)); legend_add('cos');
%   plot(x, tan(x), x, cot(x)); legend_add({'tan', 'cotan'});
%   ylim([-10,10])
%
% See also LEGEND, LEGEND_PARAMETRIC

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if iscell(text)
    text = text(:);
    for i=1:length(text)
        legend_add(text{i});
    end
    return
end

if isnumeric(text)
    text=sprintf( '%g', text );
end
[legend_h,~,~,text_strings] = legend();
legend( legend_h, [text_strings, {text}] );
