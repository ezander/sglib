function gam=randn_sorted( Ns, unsort, correction )
% RANDN_SORTED Generate sorted, normally distributed numbers from the inverse CDF.
%   GAM=RANDN_SORTED( NS, UNSORT, CORRECTION ) generates a vector of NS
%   samples which are normally (i.e. N(0,1)) distributed. This vector is
%   usually sorted (by construction) and not really meant as "random
%   numbers", but rather for functions where a sample vector with normal
%   distribution is needed.
%
% Example (<a href="matlab:run_example randn_sorted">run</a>)
%   disp(randn_sorted( 30 )');
%   hist(randn_sorted(10000),100);
%
% See also RANDN

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


% we generate the normal distributed data by inverting the CDF of N(0,1) on
% sortedly distributed points in (0,1)

uni=linspace(0,1,Ns+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

% variance correction
if nargin<3
    correction=2;
end

switch correction
    case 0 % no correction
    case 1 % empirical correction
        p=[0.00108783445376  -0.25098458013272  -0.31386105173971];
        va=1-exp(polyval(p,(log(Ns).^1.5)));
        gam=gam/sqrt(va);
    case 2 % moment based correction
        if Ns>1
            [m,v]=data_moments(gam);
            gam=(gam-m)/sqrt(v);
        end
end

% sorting - gam is of course already sorted if we want so have a random
% vector we should "unsort" it...
if nargin>=2 && ~unsort
    gam=gam(randperm(Ns));
end


