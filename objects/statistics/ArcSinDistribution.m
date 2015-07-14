function dist=ArcSinDistribution(a, b)
    % SEMICIRCLEDISTRIBUTION Construct a BetaDistribution.
    %   DIST=ARCSINDISTRIBUTION() constructs a beta distribution returned in
    %   DIST representing a beta distribution with parameters A=3/2 and
    %   B=3/2 shifted to have bounds [a,b]
    %
    % Example (<a href="matlab:run_example SemiCircleDistribution">run</a>)
    %   dist = ArcSinDistribution();
    %   [var,mean,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION BETADISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Noemi Friedman
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
   dist=BetaDistribution(1/2, 1/2);
   if ~a==0 || ~b==1
       dist= fix_bounds(dist, a, b);
   end
end