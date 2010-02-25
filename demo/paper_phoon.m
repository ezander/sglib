function paper_phoon


%% Multivariate level incompatibility
% zeta -- u
% rho  -- gamma

C_u=[ 1,       0.1908, -0.8316;
      0.1908,  1,       0.1908;
     -0.8316,  0.1908,  1     ];

C_gam=[ 1.0, 0.3, -0.9;
        0.3, 1.0,  0.3;
       -0.9, 0.3,  1.0 ];

norm(C_u-1/5*C_gam.*(3+2*C_gam.^2))
C_u=1/5*C_gam.*(3+2*C_gam.^2);

eig(C_u)
eig(C_gam)

%%
% transfo: g:gam->u: G(gam)=F^-1(Phi(gam))
% now: F(y)=Phi(sign(y)abs(y)^1/3)
% => F(G(gam))=Phi(sign(G)abs(G)^1/3)=Phi(gam)
% => G=gam^3
G=@(gam)(gam^3);
pcc_u=pce_expand_1d( @(x)(x.^3), 10 );

% That's the prescribed covariance of the field (see Phoon 14)
C_u %#ok

% Transform to Gaussian (see Phoon 15 that this matches)
C_gam2=transform_covariance_pce( C_u, pcc_u );
C_gam %#ok

% The transformed covariance matrix is not positive definite (type II
% incompatibility)
min_eig=min(eig(C_gam));
min_eig %#ok
