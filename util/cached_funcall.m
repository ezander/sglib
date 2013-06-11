function varargout=cached_funcall( func, params, ndata, filename, version, varargin )
% CACHED_FUNCALL Store and retrieve the results of a function call from a file.
%   [DATA,VERSION,RECOMP]=CACHED_FUNCALL( FUNC, PARAMS, NDATA, FILENAME,
%   VERSION, VARARGIN ) first checks whether FILENAME exists. If yes, the file is
%   loaded and it is checked, whether the PARAMS used to create the DATA in
%   the file are the same as those which were passed in this call (compared
%   with ISEQUALWITHEQUALNANS). Then the VERSION field is compared, where
%   the DATA in the file is considered valid, if the match is exact. The
%   version should be increased, if there was a change in FUNC and the
%   computed DATA may be different even for the same PARAMS. If DATA is
%   considered valid, it is returned directly from the file, if not, it is
%   (re)computed by calling FUNC with PARAMS. NDATA is the number of return
%   values, which must be specified, since there is no way to get this
%   information in matlab, and furthermore, one function can have a
%   different number of output arguments, and even a different behaviour
%   depending on that number.
%
% Options:
%   verbosity: {0}, 1, 2, 
%     Show messages if recomputing.
%   show_timings: true, {false}
%     Show timings for computation. See also <a href="http://blogs.mathworks.com/loren/2009/01/06/nested-timing/">Nested Timing</a>.
%   message: {'Recomputing: %s( %s )'}
%     Message to display when recomputing and verbosity is non-zero. The
%     parameters are replaced by the function name and the stringified
%     parameters.
%   extra_params: {{}}
%     Parameters whose values should not affect recomputation because they
%     do not affect the result of the computation e.g. control parameters
%     for progress display.
%
% Example (<a href="matlab:run_example cached_funcall">run</a>)
%     % One comment to the following example: something indeterministic
%     % like RAND should never be cached - here it just serves the purpose
%     % of showing when cached results were used and when results were
%     % newly computed.
%     filename=[tempname, '.mat'];
%     ver=1;
%     options={'verbosity', 1};
%     % should compute new values only once
%     x=cached_funcall( @rand, {1,2}, 1, filename, ver, options ); disp(x);
%     x=cached_funcall( @rand, {1,2}, 1, filename, ver, options ); disp(x);
%     x=cached_funcall( @rand, {1,2}, 1, filename, ver, options ); disp(x);
%     % arguments changed => recompute, then reuse values
%     x=cached_funcall( @rand, {1,3}, 1, filename, ver, options ); disp(x);
%     x=cached_funcall( @rand, {1,3}, 1, filename, ver, options ); disp(x);
%     % version changed => recompute
%     ver=2;
%     x=cached_funcall( @rand, {1,3}, 1, filename, ver, options ); disp(x);
%     x=cached_funcall( @rand, {1,3}, 1, filename, ver, options ); disp(x);
%     % remove temp file
%     evalc( sprintf( 'delete %s.mat', filename ) );
%
% See also FUNCALL, NARGOUT, ISEQUALWITHEQUALNANS

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

options=varargin2options( varargin );
[verbosity,options]=get_option( options, 'verbosity', 0 );
[show_timings,options]=get_option( options, 'show_timings', false );
[message,options]=get_option( options, 'message', 'Recomputing: %s( %s )' );
[extra_params,options]=get_option( options, 'extra_params', {} );
[path,options]=get_option( options, 'path', cache_file_base() );
check_unsupported_options( options, mfilename );

% check that number output arguments match
if ndata<nargout
    warning( 'cached_funcall:nargout', 'Number of output arguments too large.' );
    ndata=nargout;
end 

% Setting the following to true shouldn't be necessary, since TIC with
% return value was introduced.
use_cputime=1==0;

% if path is given and filename is not absolute => create path
if ~isempty( path ) && filename(1)~=filesep
    if ~exist( path, 'dir' )
        mkdir( path );
    end
    filename=fullfile( path, filename);
end

% load saved structure from file if possible
%if exist( filename, 'file' )
%
try
    s=load( filename );
catch %#ok<CTCH>
    s=struct();
end

valid=true;
valid=valid && isfield(s,'version');
valid=valid && isequal(s.version,version);
valid=valid && isfield(s,'params');
valid=valid && isequalwithequalnans(s.params,params);
valid=valid && isfield(s,'data');
if valid
    varargout=s.data;
    return;
end

% no file or saved file didn't match (wrong version, diff parameters, ...),
% then recompute
data=cell(ndata,1);

if verbosity>0 && ~isempty(message)
    str_func=char(func);
    str_params=strtrim(evalc('disp({params{:},extra_params{:}})'));
    str=sprintf( message, str_func, str_params );
    fprintf( [str '\n'] );
end
if show_timings
    if use_cputime
        t1=cputime;
    else
        th=tic;
    end
end
[data{:}]=funcall( func, params{:}, extra_params{:} ); % Here's the action!
if show_timings
    if use_cputime
        t2=cputime;
        t=t2-t1;
    else
        t=toc(th);
    end
    fprintf( '(%g s) \n', t );
end

varargout=data;
makesavepath( filename );
if ismatlab()
    % in matlab version 7 use this (doesn't work with 6)
	save( filename, '-V6', 'data', 'params', 'version' );
else
    % in octave use this
	save( '-mat', filename, 'data', 'params', 'version' );
end
