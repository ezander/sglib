function opts=combine_options(opts1, opts2)
% COMBINE_OPTIONS Combines options structs into one options struct.
%   OPTS=COMBINE_OPTIONS(OPTS1, OPTS2)  combines the options structs OPT1
%   and OPT2 into one struct OPT. If the option key appears in OPT1 and in
%   OPT2 the value from OPT2 is taken.
%
% Example
%   function test_function(x, y, varargin)
%     options = {'key1', true, 'key2', 1234};
%     options = combine_options(options, varargin);
%     z = test_function2( x, y, options);
%
% See also VARARGIN2OPTIONS, GET_OPTION

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isstruct(opts1);
    opts1 = struct2options(opts1);
end
opts1 = reshape(opts1, 1, []);

if isstruct(opts2);
    opts2 = struct2options(opts2);
end
opts2 = reshape(opts2, 1, []);

args = [opts1, opts2];
names=args(1:2:end);
values=args(2:2:end);

ind=unique_index(names);
opts=cell2struct( values(ind), names(ind), 2 );


function ind=unique_index(names)
% check which version we're using (i.e. whether unique reports the first
% element first when an element appears multiple times, or not).
[c,ind]=unique([1,1]); %#ok<*ASGLU>
if ind==1
    % new version, force legacy behaviour
    [c,ind]=unique(names, 'legacy');
else
    % old version
    [c,ind]=unique(names);
end
