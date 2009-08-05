function [x,w]=gauss_legendre_rule(p)
% GAUSS_LEGENDRE_RULE Get Gauss points and weights for quadrature over [-1,1].
%   [X,W]=GAUSS_LEGENDRE_RULE( P ) returns the Gauss-Hermite quadrature
%   rule of order 2*p (exact for polynomial for degree less or equal to
%   2p-1). X contains the quadrature points and W contains the weights of
%   the quadrature rule.
%
% Example (<a href="matlab:run_example gauss_legendre_rule">run</a>)
%   [x,w]=gauss_legendre_rule( 3 ); % can integrate exactly for d<=5
%   for d=0:7 % degree of polynomial
%     a=rand(1,d+1); % random coefficients
%     b=polyint(a);  % integrate
%     I=polyval(b,1)-polyval(b,-1);
%     Ip=w'*polyval(a,x);
%     fprintf( '%1d: err=%g\n', d, abs(I-Ip) );
%   end

% TODO: should work for arbitrary p

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



switch p
	case 1
		x=0;
		w=2.00000000000000;
	case 2
		x=[
			-0.577350269189626
			0.577350269189626
		];
		w=[
			1.00000000000000
			1.00000000000000		
		];
	case 3
		x=[
			-0.774596669241483
			0
			0.774596669241483
		];
		w=[
			0.555555555555556
			0.888888888888889
			0.555555555555556		
		];
	case 4
		x=[
			-0.861136311594053
			-0.339981043584856
			0.339981043584856
			0.861136311594053
		];
		w=[
			0.347854845137454
			0.652145154862546
			0.652145154862546
			0.347854845137454		
		];
	case 5
		x=[
			-0.906179845938664
			-0.538469310105683
			0
			0.538469310105683
			0.906179845938664
		];
		w=[
			0.236926885056189
			0.478628670499366
			0.568888888888889
			0.478628670499366
			0.236926885056189		
		];
	case 6
		x=[
			-0.932469514203152
			-0.661209386466265
			-0.238619186083197
			0.238619186083197
			0.661209386466265
			0.932469514203152
		];
		w=[
			0.171324492379170
			0.360761573048139
			0.467913934572691
			0.467913934572691
			0.360761573048139
			0.171324492379170		
		];
	case 7
		x=[
			-0.949107912342759
			-0.741531185599394
			-0.405845151377397
			0
			0.405845151377397
			0.741531185599394
			0.949107912342759
		];
		w=[
			0.129484966168870
			0.279705391489277
			0.381830050505119
			0.417959183673469
			0.381830050505119
			0.279705391489277
			0.129484966168870		
		];
	case 8
		x=[
			-0.960289856497536
			-0.796666477413627
			-0.525532409916329
			-0.183434642495650
			0.183434642495650
			0.525532409916329
			0.796666477413627
			0.960289856497536
		];
		w=[
			0.10122853629038
			0.2223810344534
			0.3137066458779
			0.3626837833784
			0.3626837833784
			0.3137066458779
			0.2223810344534
			0.10122853629038		
		];
	case 9
		x=[
			-0.968160239507626
			-0.836031107326636
			-0.613371432700590
			-0.324253423403809
			0
			0.324253423403809
			0.613371432700590
			0.836031107326636
			0.968160239507626
		];
		w=[
			0.081274388361574
			0.180648160694857
			0.260610696402935
			0.312347077040003
			0.330239355001260
			0.312347077040003
			0.260610696402935
			0.180648160694857
			0.081274388361574		
		];
    otherwise
        error('Unknown polynomial order (%d) for Gauss Points (max: 9)!', p );
end

