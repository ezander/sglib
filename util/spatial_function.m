function u=spatial_function(func_str, pos, varargin)
% SPATIAL_FUNCTION Evaluate a function defined by a string using X, Y and Z.
%   U=SPATIAL_FUNCTION(FUNC_STR, POS) evaluates the spatial function given
%   the coordinates given in POS. The operations in FUNC_STR are
%   automatically vectorised and X is replaced by POS(1,:), Y by POS(2,:)
%   and Z by POS(3,:). 
%
% Example (<a href="matlab:run_example spatial_function">run</a>)
%   [X, Y] = meshgrid(linspace(-3,3,50));
%   pos = [X(:)'; Y(:)'];
%   z = spatial_function('x^2+y^2+sin(x*y)', pos);
%   Z = reshape(z, size(X));
%   surf(X,Y,Z)
%
% See also MAKE_SPATIAL_FUNC

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

options=varargin2options(varargin);
[mode,options]=get_option(options,'mode','zero');
check_unsupported_options(options,mfilename);

func_str=vectorize(func_str);
null=zeros(1,size(pos,2));  %#ok<NASGU>
xrepl='pos(1,:)';
yrepl='pos(2,:)';
zrepl='pos(3,:)';
[d,n]=size(pos);
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

func_str=regexprep( func_str, '\<x\>', xrepl );
func_str=regexprep( func_str, '\<y\>', yrepl );
func_str=regexprep( func_str, '\<z\>', zrepl );

func_str=strrep( func_str, 'XXX', 'x' );
func_str=strrep( func_str, 'YYY', 'y' );
func_str=strrep( func_str, 'ZZZ', 'z' );

u=eval(func_str)';
if isscalar(u)
    u=repmat(u,n,1);
end
