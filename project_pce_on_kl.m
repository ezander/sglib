function [mu_r_i,r_k_alpha,r_i_k]=project_pce_on_kl( r_i_alpha, I_r, r_i_k, sigma_k )
% PROJECT_PCE_ON_KL Project a spatially PC expanded field into a KL-PCE field.
%   [MU_R_I,R_K_ALPHA,R_I_K]=PROJECT_PCE_ON_KL( R_I_ALPHA, I_R, R_I_K, SIGMA_K ) transforms
%   a field that is given by a pointwise PCE into a field given by a KL
%   with PCE for each KL random variable.

% TODO: why is sigma_k not used???
% TODO: check this function, seems a bit weird


% We will have two possibilities to get the KL from a PCE. The first one is
% to projects on the KL, computed beforehand. Therefore we just have to
% build the scalar product with the KL eigenfunctions and (is they are not
% normalized) divide by their norm squared. The second one is to do an SVD
% directly on the PCE coefficients. If the PCE coefficients are given for
% normalized Hermite polynomials this should give about the same as the
% first method. For unnormalized coefficients we'll certainly get problems.

if size(r_i_k,1)~=size(r_i_alpha,1)
    error( 'project_pce_on_kl:wrong_args', 'Input arguments r_i_alpha and r_i_k must have the same spatial dimension (2)' );
end

% If the r_i_k's are unnormalized and no KL eigenvalues are given (i.e. they
% are included) we extract the eigenvalues and normalize the r_i_k's (maybe
% this is unnecessary... see TODO below)
if nargin<4
    sigma_k=sqrt(sum( r_i_k.^2, 1 ));
    r_i_k=row_col_mult( r_i_k, 1./sigma_k );
end

% In the following we transform from a pure PCE expansion to a KL expansion
% with PCE expanded random variables. I.e. first we have a field u(x,omega)
% given by:
%  u(x,omega)=Sum_alpha u_alpha(x) H_alpha(xi(omega))
% and want to transform it into
%  u(x,omega)=mu_u(x) + Sum_u f_

% Extract the mean of the KL expansion (that's simply the coefficient in
% the PCE corresponding to the multiindex [0,0,0,...] )
mu_r_i=r_i_alpha(:,1);
r_i_alpha(:,1)=0;

% Now do the projection. Since the r_i_k are normalized this amounts to just a
% scalar product between the PCE coefficients and the r_i_k's.
r_k_alpha=r_i_k'*r_i_alpha;

% Now the r_i_k's are normalized and the PCE coefficients of the KL random vars
% have non-unity variance. Here we shift the variance to the KL functions.
%TODO: check relation between 'v' and 'sigma_k'; should be approx same
% maybe in this case we should scale and rescale
[m,v]=pce_moments( r_k_alpha, I_r );
m; %#ok: m unused
r_k_alpha=row_col_mult( r_k_alpha, 1./sqrt(v) );
r_i_k=row_col_mult( r_i_k, sqrt(v)' );

