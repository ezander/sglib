function [a,b]=beta_find_ratio(std2mean,varargin)
% BETA_FIND_RATIO Find parameters for the beta distribution that have a specific stddev to mean ratio.
%   [A,B]=BETA_FIND_RATIO(STD2MEAN) returns parameters A and B such that 
%   for the beta distribution Beta(A,B) the ratio between standard
%   deviation and mean is STD2MEAN. A and B are chosen such that the
%   product is 1. 
%
% Options: 
%   prod_ab: {1}
%     The product of parameters A and B. Default is 1
%
% Example (<a href="matlab:run_example beta_find_ratio">run</a>)
%   [a,b]=beta_find_ratio( 5, 'prod_ab', 3 );
%   [m,v]=beta_moments(a,b);
%   fprintf( 'a=%g, b=%g\n', a, b );
%   fprintf( 'std/mean=%g, a*b=%g\n', sqrt(v)/m, a*b );
%  
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


options=varargin2options(varargin);
[prod_ab,options]=get_option(options,'prod_ab',1);
check_unsupported_options(options,mfilename);

r=1/std2mean;

a0=beta_start_val(r,prod_ab);
a1=a0; while beta_ratio(a1,prod_ab/a1)>r; a1=a1/2; end
a2=a0; while beta_ratio(a2,prod_ab/a2)<r; a2=a2*2; end
a=fzero( @(a)(beta_ratio(a,prod_ab/a)-r), [a1,a2] );
b=prod_ab/a;

function a0=beta_start_val( r, c )
% determine starting value based on asymptotic approximation of r(a,b) with
% b=c/a, with asymptotic ranges for a>>sqrt(c), a<<sqrt(c), plus something
% in between and the whole thing made continuous, then the function in the
% three ranges can be inverted easily
if r^2>(2*sqrt(c)+1)^3/c
    a0=(c*r^2)^(1/3);
elseif r^2<c/(2*sqrt(c)+1)
    a0=r^2;
else
    a0=r*c/(2*sqrt(c)+1);
end

function r=beta_ratio(a,b)
[mb,vb]=beta_moments(a,b);
r=mb/sqrt(vb);
