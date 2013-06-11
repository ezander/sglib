function erase_print( varargin )
% ERASE_PRINT Erase previous output and print new stuff.
%   ERASE_PRINT( VARARGIN ) prints VARARGIN in the same fashion as SPRINTF
%   and FPRINTF do. The size of the result is cached and in the next call
%   to ERASE_PRINT the last output is erased before the new output is
%   written on top of it. The last can be cleared by a call to ERASE_PRINT
%   with argument ''. If the last line should be conserved call ERASE_PRINT
%   without any argument (see example).
%
%   Note: any direct output (via DISP, FPRINTF etc.) will interfere with
%   the mechanism in ERASE_PRINT and produce garbled output.
%
% Example: (<a href="matlab:run_example erase_print">run</a>)
%     N=10;
%     for i=1:N
%         erase_print( 'Assemble: %d/%d', i, N );
%         % in reality we would do some useful stuff now
%         % but for demonstration we just wait .2 seconds
%         tic; while( toc<.2); end;
%     end
%     erase_print();
%
% See also SPRINTF, FPRINTF

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

persistent n
if isempty(n); n=0; end;
cl=repmat(sprintf('\b'), 1, n);
if ~isempty(varargin)
    s=sprintf( varargin{:} );
    fprintf( [cl s] );
    n=length(s);
else
    fprintf( '\n' );
    n=0;
end
