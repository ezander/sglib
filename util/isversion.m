function ok=isversion( ge_version, lt_version )
% ISVERSION Check that running Matlab version fits into some range.
%   OK=ISVERSION( GE_VERSION, LT_VERSION ) checks that the current Matlab
%   version (VERSION) is greater than or equal to GE_VERSION and less than
%   (but not equal to) LT_VERSION.
%
%   In order to check which matlab version supports which features or
%   introduced which incompatibilities see the references [1-3].
%
% References:
%   [1] http://www.dynare.org/DynareWiki/MatlabVersionsCompatibility
%   [2] http://www.mathworks.de/de/help/matlab/release-notes.html
%   [3] http://www.mathworks.de/de/help/matlab/release-notes-older.html
%
% Example (<a href="matlab:run_example isversion">run</a>)
%   if isversion( '6.0', '7.0' )
%       % do version 6.x stuff
%   else
%       % do something different
%   end
%
% See also VERSION

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



% for m1=6:8
%     for m2=1:3
%         v2=[num2str(m1) '.' num2str(m2)];
%         ok1=is_larger_equal( '7.2', v2 );
%         ok2=is_larger( '7.2', v2 );
%         disp(sprintf('7.2>=%s: %d %d',v2,ok1,ok2));
%     end
% end
% return

%FIXME: doesn't work with two-digit version numbers
%FIXME: probably this function doesn't even work with old versions of matlab

ver=str2version( version );
ok=true;

if ~isempty(ge_version)
    minver=str2version(ge_version);
    ok=ok && is_larger_equal( ver, minver );
end

if nargin>1 && ~isempty(lt_version)
    maxver=str2version( lt_version );
    ok=ok && is_larger( maxver, ver );
end

function ver=str2version( v )
% STR2VERSION Extract the major and minor versions from a version string.
v=[v '.0.0'];
dot_pos=find( v=='.' );
ver.major=str2double( v(1:dot_pos(1)-1) );
ver.minor=str2double( v(dot_pos(1)+1:dot_pos(2)-1) );

function ok=is_larger_equal( v1, v2 )
% IS_LARGER_EQUAL Check whether one version is larger or equal than another.
ok=(v1.major>v2.major) || (v1.major==v2.major && v1.minor>=v2.minor);

function ok=is_larger( v1, v2 )
% IS_LARGER_EQUAL Check whether one version is strictly larger than another.
ok=(v1.major>v2.major) || (v1.major==v2.major && v1.minor>v2.minor);
