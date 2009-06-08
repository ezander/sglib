% this file generates all the images for the oberseminar

addpath dummy/

%% Introductory images (2d)

clf; clear

if exist( 'ranfield.mat', 'file' ) 
    load( 'ranfield.mat' )
else
    s=load('mesh/rect_mesh.mat');
    els=s.nodes;
    pos=s.coords;
    [els,pos]=correct_mesh( els, pos );
    % [els,pos]=refine_mesh( els, pos );
    % [els,pos]=correct_mesh( els, pos );
    z=0*sum(pos,2);
    z=randn(size(z));

    % M=mass_matrix( els, pos );
    M=[]; %speye(size(pos,1));

    p_f=3;
    m_gam_f=10;
    m_f=15;
    lc_f=[0.1 0.2];
    h_f=@normal_stdnor;
    cov_f={@gaussian_covariance,{lc_f,1}};
    cov_gam={@gaussian_covariance,{lc_f,1}};
    options_expand_f.transform.correct_var=true;


    [f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, cov_gam, pos, M, p_f, m_gam_f, options_expand_f );
    [mu_f,f_i_alpha,v_f]=pce_to_kl( f_alpha, I_f, M, m_f );
    save( 'ranfield.mat', '-V6' );
end

for i=1:4
    subplot(2,2,i);
    f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f );
    plot_field( els, pos, zinn_harvey_connected_stdnor( f_ex, 0.03, true ) );
end

%% show $k(.,w_0)$ and $k(x_0,.)$
clf
subplot(1,2,1);
f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f );
plot_field( els, pos, f_ex );

subplot(1,2,2);
x=linspace(-4,4);
plot(x, normal_pdf(x), 'r' );
hold on
gam=randn(10000,m_gam_f);
kernel_density( hermite_val_multi( f_alpha(:,1), I_f, gam ),[], 0.1 );
axis square

% pce of log-normal variable
%% approximation of the exp function and of the pdf

clf; clear;
subplot(1,2,1)
h={@lognorm_stdnor, {2, 0.5} };
pcc=pce_expand_1d( h, 4 );
x=linspace(-5,6);
y=hermite_val( pcc, x );
plot(x,y,x,funcall(h,x));

subplot(1,2,2)
pcc=pce_expand_1d( h, 7 );
x=linspace(-5,20);
plot( x, lognorm_pdf( x, 2, 0.5 ), 'r' );
hold on;
kernel_density( hermite_val( pcc, randn(20000,1) ),200, 0.3 );
xlim( [-5,20] );
hold off;

%% approximation of beta distribution
x=linspace(-0.2,1.2);
params={4,2};
h={@beta_stdnor, params};
p=[0,1,2,3,5];
for i=1:4
    pcc=pce_expand_1d( h, p(i) );
    subplot(2,2,i);
    plot( x, beta_pdf( x, params{:} ), 'r' );
    hold on;
    kernel_density( hermite_val( pcc, randn_uniform(5000) ), 100, 0.006*(p(i)+1) );
    xlim( [min(x),max(x)] );
    hold off;
end

[md,vd,sd]=beta_moments( params{:} );
[mp,vp,sp]=pce_moments( pcc );
disp( [md mp; vd vp; sd sp] );

%% approximation of uniform distribution
x=linspace(1.8,3.2);
params={2,3};
h={@uniform_stdnor, params};
p=[1,3,5,7];
for i=1:4
    pcc=pce_expand_1d( h, p(i) );
    subplot(2,2,i);
    plot( x, uniform_pdf( x, params{:} ), 'r' );
    hold on;
    kernel_density( hermite_val( pcc, randn(20000,1) ), 100, 0.02 );
    xlim( [min(x),max(x)] );
    hold off;
end

[md,vd,sd]=uniform_moments( params{:} );
[mp,vp,sp]=pce_moments( pcc );
disp( [md mp; vd vp; sd sp] );


%% approximation of bimodal distribution
N=10000;
bimod=[exp(1+0.2*randn_uniform(3*N));exp(3+0.2*randn_uniform(10*N))];
p=[4,6,8,11];
gam=randn_uniform(30000,true,true);
pcc_max=pce_expand_1d_mc( bimod, max(p) );
for i=1:4
    pcc=pcc_max(1:(p(i)+1));
    subplot(2,2,i);
    kernel_density( bimod, 100, 0.03, 'r' );
    hold on;
    kernel_density( hermite_val( pcc, gam ), 100, 0.03 );
    xlim( [-5,40] );
    hold off;
end

[md,vd,sd]=data_moments( bimod );
[mp,vp,sp]=pce_moments( pcc_max );
disp( [md mp; vd vp; sd sp] );

%% some correlation functions: gaussian, exponential, spherical
clear; clf
subplot(1,3,1);
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=gaussian_covariance( x', [], l(i), 1 ) ;
end
plot( x,  y);

subplot(1,3,2);
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=exponential_covariance( x', [], l(i), 1 ) ;
end
plot( x,  y);

subplot(1,3,3);
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=spherical_covariance( x', [], l(i), 1 ) ;
end
plot( x,  y);

%% some eigenfunctions using KL
s=load('mesh/rect_mesh.mat');
els=s.nodes;
pos=s.coords;
[els,pos]=correct_mesh( els, pos );
lc_f=[0.03 0.2];

cov_u=@(x1,x2)(gaussian_covariance(x1,x2,[0.7 0.3]));
C_u=covariance_matrix( pos, cov_u );

v_u=kl_expand( C_u, [], 4, 'correct_var', true );
subplot(2,2,1);
plot_field( els, pos, v_u(1,:) )
subplot(2,2,2);
plot_field( els, pos, v_u(2,:) )
subplot(2,2,3);
plot_field( els, pos, v_u(3,:) )
subplot(2,2,4);
plot_field( els, pos, v_u(4,:) )


%% some examples of kl-pce
load( 'ranfield.mat' )
for i=1:4
    subplot(2,2,i);
    f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f );
    plot_field( els, pos, f_ex );
end


%%
clf;
n=21;
p=5;
m=5;
lc=0.3;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

h=@(gamma)(beta_stdnor(gamma,4,2));
[mu,sig2]=beta_moments( 4, 2 ); %#ok

cov_u=@(x1,x2)(gaussian_covariance(x1,x2,lc,sqrt(sig2)));
cov_gam=[];

[u_alpha, I_u]=expand_field_pce_sg( h, cov_u, cov_gam, x, M, p, m );
xi=randn(3000,m);
y=pce_field_realization( x, u_alpha, I_u, xi );
subplot(1,2,1)
plot(x,y(1:200,:));

x=repmat(x',size(y,1),1);
x=x+rand(size(x))/(n-1);
subplot(1,2,2)
plot(x(:),y(:),'.');


%%
clf; %#ok
n=31;
lc=0.2*2;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

h=@(gamma)(beta_stdnor(gamma,4,2));
[mu,sig2]=beta_moments( 4, 2 );

cov_u=@(x1,x2)(gaussian_covariance(x1,x2,lc,sqrt(sig2)));
cov_gam=[];

p=4;
for m=2:4

[u_alpha, I_u]=expand_field_pce_sg( h, cov_u, cov_gam, x, M, p, m );
C_u1=covariance_matrix( x, cov_u );
C_u2=pce_covariance( u_alpha, I_u );
C_u1(end:-1:1,:)=C_u1;
C_u2(end:-1:1,:)=C_u2;
subplot(1,3,m-1)
plot( 1:n, diag(C_u1), 1:n, diag(C_u2) );
ylim([-0.01,0.035])
end

%%
clf;
subplot(1,2,1)
x=linspace(0,1);
plot( x, beta_pdf(x,4,2), 'r' );
hold on
kernel_density( hermite_val_multi( u_alpha(:,5), I_u, randn(10000,m) ),[], 0.03 );
subplot(1,2,2)
x=linspace(0,1);
plot( x, beta_pdf(x,4,2), 'r' );
hold on
kernel_density( hermite_val_multi( u_alpha(:,10), I_u, randn(10000,m) ),[], 0.03 );


% distributions of kl random vars
% regenerated marginal distributions
% regenerated correlation functions


% image generated with kl
% image generated with kl plus zinn-harvey


% outlook zh?
% bimodal?
% non-smooth?

