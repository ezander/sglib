function deps=find_deps( funs, excludepath )
% FIND_DEPS Find dependencies of a file.
%   DEPS=FIND_DEPS(FUNS) finds all dependencies of the commands/function
%   specified in FUNS which are not below the MATLABROOT. FUNS may be also 
%   a single function.
%
% Example (<a href="matlab:run_example find_deps">run</a>)
%   % should only include 'find_deps.m'
%   find_deps( 'find_deps' )
%   % should not be empty
%   find_deps( 'unittest_cached_funcall' )
%
% See also DEPFUN, MATLABPATH

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isoctave
  % pretty primitive for octave
  deps={which(funs)};
  return
end


if nargin<2
    excludepath=matlabroot;
end

if ~iscell(funs) && ~ischar(funs) && isfunction(funs)
    f=functions(funs);
    funs=f.file;
end

deps={};
while ~isempty(funs)
    s = warning('off', 'MATLAB:DEPFUN:DeprecatedAPI');
    if isversion('8.6')
        imdeps = matlab.codetools.requiredFilesAndProducts(funs, 'toponly');
    else
        imdeps=depfun( funs, '-toponly', '-quiet' ); %#ok<DEPFUN>
    end
    warning(s);
    exclude=strmatch( excludepath, imdeps );
    imdeps(exclude)=[];
    funs=setdiff(imdeps,deps);
    deps=union(deps,imdeps);
end
