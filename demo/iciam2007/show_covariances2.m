function show_covariances2( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k_func, cov_f_func )

subplot(4,3,1); show_pce_covariance( x, k_alpha, I_k, 'surf', 'corr_coeff', true );
subplot(4,3,4); show_pce_covariance( x, k_alpha, I_k, 'eigs' );
subplot(4,3,7); show_pce_covariance( x, k_alpha, I_k, 'eigfuns' );
subplot(4,3,10); show_pce_covariance( x, k_alpha, I_k, 'diff', 'cov_func', cov_k_func );

subplot(4,3,2); show_pce_covariance( x, f_alpha, I_f, 'surf', 'corr_coeff', true );
subplot(4,3,5); show_pce_covariance( x, f_alpha, I_f, 'eigs' );
subplot(4,3,8); show_pce_covariance( x, f_alpha, I_f, 'eigfuns' );
subplot(4,3,11); show_pce_covariance( x, f_alpha, I_f, 'diff', 'cov_func', cov_f_func );

subplot(4,3,3); show_pce_covariance( x, u_alpha, I_u, 'surf', 'corr_coeff', true );
subplot(4,3,6); show_pce_covariance( x, u_alpha, I_u, 'eigs' );
subplot(4,3,9); show_pce_covariance( x, u_alpha, I_u, 'eigfuns' );


function show_pce_covariance( x, r_alpha, I_r, type, varargin )
options=varargin2options( varargin );
[m,options]=get_option( options, 'numeigs', 6 );
[corr_coeff,options]=get_option( options, 'corr_coeff', false );
[cov_func,options]=get_option( options, 'cov_func', [] );
check_unsupported_options( options, mfilename );

C=pce_covariance( r_alpha, I_r );
if corr_coeff
    C=to_corr_coeff( C );
end

switch type
    case 'surf'
        [X,Y]=meshgrid(x);
        surf(X,Y,C);
        axis('tight');
    case 'eigs'
        [V,D]=eig(C);
        l=logscale(diag(D)); 
        plot(l,'x'); xlim([1,length(l)]);
    case 'eigfuns'
        [V,D]=eig(C);
        plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); 
        xlim([min(x),max(x)]);
    case 'analyt'
        [X,Y]=meshgrid(x);
        [mu_r,var_r]=pce_moments(r_alpha(2,:),I_r); %#ok
        surf( X, Y, var_r*covariance_matrix( x, cov_func ) )
    case 'diff'
        [X,Y]=meshgrid(x);
        [mu_r,var_r]=pce_moments(r_alpha(2,:),I_r); %#ok
        surf( X, Y, C-var_r*covariance_matrix( x, cov_func ) )
end


function Cn=to_corr_coeff( C )
s=sqrt(diag(C));
V=s*(s');
ind=V~=0;
Cn=ones(size(C));
Cn(ind)=C(ind)./V(ind);
