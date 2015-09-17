function [x,w]=gauss_legendre_rule(p)
% GAUSS_LEGENDRE_RULE Get Gauss points and weights for quadrature over [-1,1].
%   [X,W]=GAUSS_LEGENDRE_RULE( P ) returns the Gauss-Legendre quadrature
%   rule of order 2*p (exact for polynomial for degree less or equal to
%   2p-1). X contains the quadrature points and W contains the weights of
%   the quadrature rule.
%
% Note: This method is pretty old and works with pre-computed nodes and
%   weights up to order 9. If you need arbitrary order, please take a look
%   at the GPC integration functions.
%
% Example (<a href="matlab:run_example gauss_legendre_rule">run</a>)
%   [x,w]=gauss_legendre_rule( 3 ); % can integrate exactly for d<=5
%   a=rand(1,d+1); % random coefficients
%   b=polyint(a);  % integrate polynomial
%   I=polyval(b,1)-polyval(b,-1);
%   for d=0:7 % degree of polynomial
%     Ip=polyval(a,x)*w;
%     fprintf( 'p=%1d: err=%6.4f exact=%d\n', d, abs(I-Ip), d<=5);
%   end
% 
% See also GAUSS_HERMITE_RULE, GPC_INTEGRATE

%   Elmar Zander
%   Copyright 2006-2014, Institute of Scientific Computing, TU Braunschweig.
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
        x= 0;
        w= 2.0000000000000000000;
    case 2
        x=[ -0.57735026918962576451, 0.57735026918962576451];
        w=[ 1.0000000000000000000; 1.0000000000000000000];
    case 3
        x=[ -0.77459666924148337704, 0, 0.77459666924148337704];
        w=[ 0.55555555555555555556; 0.88888888888888888889; ...
            0.55555555555555555556];
    case 4
        x=[ -0.86113631159405257522, -0.33998104358485626480, ...
            0.33998104358485626480, 0.86113631159405257522];
        w=[ 0.34785484513745385737; 0.65214515486254614263; ...
            0.65214515486254614263; 0.34785484513745385737];
    case 5
        x=[ -0.90617984593866399280, -0.53846931010568309104, 0, ...
            0.53846931010568309104, 0.90617984593866399280];
        w=[ 0.23692688505618908751; 0.47862867049936646804; ...
            0.56888888888888888889; 0.47862867049936646804; ...
            0.23692688505618908751];
    case 6
        x=[ -0.93246951420315202781, -0.66120938646626451366, ...
            -0.23861918608319690863, 0.23861918608319690863, ...
            0.66120938646626451366, 0.93246951420315202781];
        w=[ 0.17132449237917034504; 0.36076157304813860757; ...
            0.46791393457269104739; 0.46791393457269104739; ...
            0.36076157304813860757; 0.17132449237917034504];
    case 7
        x=[ -0.949107912342759, -0.741531185599394, -0.405845151377397, 0, ...
            0.405845151377397, 0.741531185599394, 0.949107912342759 ];
        w=[ 0.129484966168870; 0.279705391489277; 0.381830050505119; ...
            0.417959183673469; 0.381830050505119; 0.279705391489277; ...
            0.129484966168870 ];
    case 8
        x=[ -0.960289856497536, -0.796666477413627, -0.525532409916329, ...
            -0.183434642495650, 0.183434642495650, 0.525532409916329, ...
            0.796666477413627, 0.960289856497536 ];
        w=[ 0.10122853629038; 0.2223810344534; 0.3137066458779; ...
            0.3626837833784; 0.3626837833784; 0.3137066458779; ...
            0.2223810344534; 0.10122853629038 ];
    case 9
        x=[ -0.968160239507626, -0.836031107326636, -0.613371432700590, ...
            -0.324253423403809, 0, 0.324253423403809, 0.613371432700590, ...
            0.836031107326636, 0.968160239507626 ];
        w=[ 0.081274388361574; 0.180648160694857; 0.260610696402935; ...
            0.312347077040003; 0.330239355001260; 0.312347077040003; ...
            0.260610696402935; 0.180648160694857; 0.081274388361574 ];
    otherwise
        error('Unknown polynomial order (%d) for Gauss Points (max: 9)!', p );
end

