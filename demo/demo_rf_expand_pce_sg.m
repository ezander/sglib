% DEMO_RF_EXPAND_PCE_SG

init_demos


% show some realizations of a random field with marginal beta distribution
% and gaussian covariance function
clf;
n=21;
p=5;
m=5;
lc=0.3;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

h=@(gamma)(beta_stdnor(gamma,4,2));
[mu,sig2]=beta_moments( 4, 2 );

cov_u=@(x1,x2)(gaussian_covariance(x1,x2,lc,sqrt(sig2)));
cov_gam=[];

[u_alpha, I_u]=expand_field_pce_sg( h, cov_u, cov_gam, x, M, p, m );
xi=randn(100,m);
y=pce_field_realization( x, u_alpha, I_u, xi );
plot(x,y);
%plot(x(2:end),diff(y,1,1));
userwait

%% Dependence of autocovariance
% This code shows that the autocovariance function does not depend on p
% (i.e. the number of PCE terms), but only on m (i.e. the number of KL
% terms)

clf; %#ok
n=11;
lc=0.2*2;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

h=@(gamma)(beta_stdnor(gamma,4,2));
[mu,sig2]=beta_moments( 4, 2 );

cov_u=@(x1,x2)(gaussian_covariance(x1,x2,lc,sqrt(sig2)));
cov_gam=[];


matnorm='fro';
for m=[1 2 3 4]
    for p=[1 2 3]
        tic;
        [u_alpha, I_u]=expand_field_pce_sg( h, cov_u, cov_gam, x, M, p, m );
        t1(p,m)=toc; %#ok
        tic;
        [mu_1,var_1]=pce_moments( u_alpha, I_u );
        t2(p,m)=toc; %#ok
        [mu_2,var_2]=beta_moments( 4, 2 );
        fprintf( 'RF params: p: %1d m:%1d -', p, m );
        % fprintf( 'RF params: p: %1d m:%1d t1:%6.4f  t2:%6.4f', p, m, t1(p,m), t2(p,m) );
        C_u2=pce_covariance( u_alpha, I_u );
        C_u1=covariance_matrix( x, cov_u );
        fprintf( ' cov error:  %- 7.6f\n', norm(C_u2-C_u1,matnorm)/norm(C_u1,matnorm) );

        [X1,X2]=meshgrid(x);
        dx=abs(X1-X2);
        dx=round(dx(:)*1e8)/1e8;
        [dxu,i,j]=unique(dx);
        y2=C_u2(i);
        y1=C_u1(i);
        subplot(3,4,(p-1)*4+m);
        plot(dxu,y1,dxu,y2);
        drawnow;
    end
end
userwait;

% This code show how mean, variance and covariance change with the number
% of PCE and KL terms
%%
for m=[1,2,3,4,5]
    for p=[1,2,3,4,5]
        tic;
        [u_alpha, I_u]=expand_field_pce_sg( h, cov_u, cov_gam, x, M, p, m );
        t1(p,m)=toc; %#ok
        tic;
        [mu_1,var_1]=pce_moments( u_alpha, I_u );
        t2(p,m)=toc; %#ok
        [mu_2,var_2,sk_2]=beta_moments( 4, 2 );
        fprintf( 'p: %1d m:%1d - ', p, m );
        fprintf( 'u:[%2d,%3d]  I:[%3d,%d1]', size(u_alpha), size(I_u) );
        fprintf( ' E_mean: %- 10.4e', norm(mu_1-mu_2)/norm(mu_2) );
        fprintf( ' E_var: %- 10.4e', norm(var_1-var_2)/norm(var_2) );
        C_u2=pce_covariance( u_alpha, I_u );
        C_u1=covariance_matrix( x, cov_u );
        fprintf( ' E_cov: %- 7.5f \n', norm(C_u2-C_u1)/norm(C_u1) );

        [X1,X2]=meshgrid(x);
        dx=abs(X1-X2);
        dx=dx(:);
        dxu=unique(dx);
        
        mu_err(p,m)=norm(mu_1-mu_2)/norm(mu_2); %#ok
        var_err(p,m)=norm(var_1-var_2)/norm(var_2); %#ok
        cov_err(p,m)=norm(C_u2-C_u1,'fro')/norm(C_u1,'fro'); %#ok
    
    end
    
end
userwait;


%display results in table form
disp('t1 (expand)');
disp(t1);
disp('t2 (moments)');
disp(t2);
disp('log(mu_err)');
disp(log(mu_err));
disp('log(var_err)');
disp(log(var_err));
disp('log(cov_err)');
disp(log(cov_err));
userwait;
