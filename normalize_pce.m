function pcc_normed=normalize_pce( pcc_unnormed, pci, reverse )
% NORMALIZE_PCE Transforms a PCE in unnormed Hermite polys into a PCE in
% normed Hermite polys.
%   PCC_NORMED=NORMALIZE_PCE( PCC_UNNORMED, PCI ) returns the PC
%   coefficients of the PCE in terms of the normalized Hermite polynomials
%   from the the PCE in terms of the unnormalized Hermite polynomials. This
%   representation has the advantage that the covariance of two Gaussian
%   random variables given in normalized PCE is just the Euclidian product
%   of the coefficient vectors; and the variance of one Gaussian variable
%   is likewise the Euclidian norm. 
%   PCC_UNNORMED=NORMALIZE_PCE( PCC_NORMED, PCI, TRUE ) reverses the
%   normalization, i.e. converts to the coefficients of the unnormalized
%   Hermite polynomials again.
% Note
%   Most functions of this package currently expect the PCE to be given in
%   unnormalized Hermite polynomials. This has advantages in some areas but
%   disadvantages in others. In the future this might be changed. 
%
% Example (<a href="matlab:run_example normalize_pce">run</a>)
%   [pcc,pci]=pce_expand_1d( @(x)(lognorm_stdnor(x,0,1)), 4 );
%   pccn=normalize_pce( pcc, pci );
%   [mean1,var1]=pce_moments( pcc, pci );
%   mean2=pccn(1);
%   var2=sum(pccn(2:end).^2,1);
%   disp(mean1==mean2); % true
%   disp(var1==var2); %true
%
% See also PCE_EXPAND_1D

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


if nargin>2 && reverse
    % here the names are somehow reversed of course
    pcc_normed=row_col_mult( pcc_unnormed, 1./hermite_norm( pci )' );
else
    pcc_normed=row_col_mult( pcc_unnormed, hermite_norm( pci )' );
end
