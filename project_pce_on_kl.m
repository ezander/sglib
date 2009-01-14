function [mu,pcc_kl,f]=project_pce_on_kl( pcc, pci, f, sqrt_lambda )
% PROJECT_PCE_ON_KL Project a spatially PC expanded field into a KL-PCE field.
%   [MU,PCC_KL,F]=PROJECT_PCE_ON_KL( PCC, PCI, F, SQRT_LAMBDA ) transforms
%   a field that is given by a pointwise PCE into a field given by a KL
%   with PCE for each KL random variable.

% TODO: why is sqrt_lambda not used???
% TODO: check this function, seems a bit weird


% We will have two possibilities to get the KL from a PCE. The first one is
% to projects on the KL, computed beforehand. Therefore we just have to
% build the scalar product with the KL eigenfunctions and (is they are not
% normalized) divide by their norm squared. The second one is to do an SVD
% directly on the PCE coefficients. If the PCE coefficients are given for
% normalized Hermite polynomials this should give about the same as the
% first method. For unnormalized coefficients we'll certainly get problems.

if size(f,1)~=size(pcc,1)
    error( 'project_pce_on_kl:wrong_args', 'Input arguments pcc and f must have the same spatial dimension (2)' );
end

% If the f's are unnormalized and no KL eigenvalues are given (i.e. they
% are included) we extract the eigenvalues and normalize the f's (maybe
% this is unnecessary... see TODO below)
if nargin<4
    sqrt_lambda=sqrt(sum( f.^2, 1 ));
    f=row_col_mult( f, 1./sqrt_lambda );
end

% In the following we transform from a pure PCE expansion to a KL expansion
% with PCE expanded random variables. I.e. first we have a field u(x,omega)
% given by:
%  u(x,omega)=Sum_alpha u_alpha(x) H_alpha(xi(omega))
% and want to transform it into 
%  u(x,omega)=mu_u(x) + Sum_u f_

% Extract the mean of the KL expansion (that's simply the coefficient in
% the PCE corresponding to the multiindex [0,0,0,...] )
mu=pcc(:,1);
pcc(:,1)=0;

% Now do the projection. Since the f are normalized this amounts to just a
% scalar product between the PCE coefficients and the f's.
pcc_kl=f'*pcc;

% Now the f's are normalized and the PCE coefficients of the KL random vars
% have non-unity variance. Here we shift the variance to the KL functions.
%TODO: check relation between 'v' and 'sqrt_lambda'; should be approx same 
% maybe in this case we should scale and rescale
[m,v]=pce_moments( pcc_kl, pci ); 
m; %#ok: m unused
pcc_kl=row_col_mult( pcc_kl, 1./sqrt(v) );
f=row_col_mult( f, sqrt(v)' );

