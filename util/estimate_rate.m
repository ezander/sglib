function [p,T,N]=estimate_rate( func, N, varargin )
% ESTIMATE_RATE Estimate rate exponent for algorithm runtime.
%   [P,T,N]=ESTIMATE_RATE(FUNC,N) estimates the exponent P of the runtime
%   of FUNC as a function of N given that the runtime T scales as T=C*N^P.
%   ESTIMATE_RATE therefore measures the time the function runs for each
%   element of the vector N and stores it in a vector T. Then the exponent
%   is estimated by fitting a straight line through log(T) over log(N). 
%
% Example (<a href="matlab:run_example estimate_rate">run</a>)
%   func=@(n)( rand(n,n)\rand(n,1));
%   estimate_rate( func, logspace2(100,2000,20), 'verbosity', 2, 'doplot', true )
%
% See also LOGSPACE2

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
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
[roundn,options]=get_option( options, 'roundn', true );
[doplot,options]=get_option( options, 'doplot', false );
[T,options]=get_option( options, 'T', [] );
check_unsupported_options( options, mfilename );

if roundn;
    N=round(N);
end

if isempty(T)
    T=zeros(size(N));
    for i=1:numel(N)
        n=N(i);
        th=tic;
        funcall( func(n) );
        T(i)=toc(th);
        if verbosity>0
            fprintf( 'n=%d: t=%g\n', n, T(i) );
        end
    end
end

a=polyfit( log(N(:)), log(T(:)), 1 );
p=a(1);

if doplot
    plot( log(N(:)), log(T(:)), 'x', ...
        log(N(:)), polyval(a,log(N(:))), '-' );
    xlabel('n');
    ylabel('t');
end
