function show_kl_decay_by_dimen

clf
for d=1:3
    N=ceil(500^(1/d));
    xd=repmat( linspace(0,1,N), d, 1);
    wd=repmat( ones(1,N), d, 1);
    x=tensor_mesh( num2cell(xd, 2 ), num2cell(wd, 2 ) );

    V_a={@gaussian_covariance, {1/sqrt(10),1}};
    V_a={@exponential_covariance, {1/sqrt(10),1}};
    V_a={@spherical_covariance, {1/sqrt(10),1}};
    C_a=covariance_matrix( x, V_a );

    [v, sigma]=kl_solve_evp( C_a, [], 200 );
    sigma_all=sigma;
    
    n=100;
    sigma=sigma_all(1:n);
    is=1:n;
    subplot( 3, 3, d); semilogy(is, sigma/sigma(1)); grid on
    %subplot( 3, 3, d+3); plot(log(is), log(-log(sigma/sigma(1)))); axis equal; grid on
    subplot( 3, 3, d+3); plot(log(is), log(sigma/sigma(1))); axis equal; grid on
    subplot( 3, 3, d+6); semilogy(is, kl_remainder(sigma_all,n)); grid on
    
    
    
    
%     is=1:10; N=size(v,1); n=length(is);
%     subplot( 3, 3, d+6); plot3( repmat((1:N)',1,n), repmat(1:n, N,1), 10*v(:,is)  )
%     view( -9.5, 80 );

end

function s=kl_remainder(sigma,n)
s=sum(sigma.^2)-[0 cumsum(sigma.^2)];
s=s(1:n)/sum(sigma.^2);

