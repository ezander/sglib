function u=spatial_function(func_str, pos, varargin)
% SPATIAL_FUNCTION Short description of spatial_function.
%   SPATIAL_FUNCTION Long description of spatial_function.
%
% Example (<a href="matlab:run_example spatial_function">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[mode,options]=get_option(options,'mode','zero');
check_unsupported_options(options,mfilename);

% Suppress alls warnings about unused variables because quite a few are
% used only by eval 
%% # o k< *NASGU>


func_str=vectorize(func_str);
null=zeros(1,size(pos,2));  %#ok<NASGU>
xrepl='pos(1,:)';
yrepl='pos(2,:)';
zrepl='pos(3,:)';
d=size(pos,1);
switch mode
    case 'zero'
        if d<2; yrepl='null'; end
        if d<3; zrepl='null'; end
    case 'last'
        if d<2; yrepl=xrepl; end
        if d<3; zrepl=yrepl; end
end

func_str=strrep( func_str, '\x', 'XXX' );
func_str=strrep( func_str, '\y', 'YYY' );
func_str=strrep( func_str, '\z', 'ZZZ' );

% func_str=strrep( func_str, 'x', xrepl );
% func_str=strrep( func_str, 'y', yrepl );
% func_str=strrep( func_str, 'z', zrepl );
func_str=regexprep( func_str, '\<x\>', xrepl );
func_str=regexprep( func_str, '\<y\>', yrepl );
func_str=regexprep( func_str, '\<z\>', zrepl );

func_str=strrep( func_str, 'XXX', 'x' );
func_str=strrep( func_str, 'YYY', 'y' );
func_str=strrep( func_str, 'ZZZ', 'z' );

u=eval(func_str)';
if any(size(u)~=size(null'))
    % then repmat!!!
    u=u+null';
end
