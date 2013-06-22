function y=logscale( x, varargin )
% LOGSCALE Safely creates log scaling for logarithmic plots.
%   Y=LOGSCALE( X, OPTIONS ) computes the logarithm of (the absolute value
%   of) X but avoiding 'Log of zero' warnings by substituting a cutoff
%   value if X is below that cutoff. Further a base of the logarithm can be
%   specified. (For many numerical computations values below the machine
%   epsilon are meaningless anyway.)
%
% Options
%   cutoff : 1e-18
%     Defines at which point the logarithm is cut off. I.e. for x<cutoff
%     the result is equal to log(cutoff).
%   base : 10
%     Basis for the logarithm. Computation is y=log(x)/log(base);
%   relscale : true, {false}
%     Scale everything relative to the maximum; thus every plot begins at
%     zero and goes to the negative value -log(cutoff).
%
% Example (<a href="matlab:run_example logscale">run</a>)
%   % semilog plot with base 1000 cutoff at 1000^-4
%   x=1:20;
%   y=10.^(-x.*(1+0.08*rand(1,20)));
%   y(10)=0; % just see what it does here...
%   plot( x, logscale(y,'cutoff',1e-12, 'base', 1000), 'x-' );
%
% See also

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
[cutoff,options]=get_option( options, 'cutoff', 1e-18 );
[base,options]=get_option( options, 'base', 10 );
[relscale,options]=get_option( options, 'relscale', false );
check_unsupported_options( options, mfilename );

x=abs(x);
if max(x)==0
    y=x;
    return
end

if relscale
    y=abs(x/max(x));
else
    y=abs(x);
end
y(y<cutoff)=cutoff;
y=log(y)/log(base);
