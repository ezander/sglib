model_Y     = 'spherical';       % type of covariance function
model_Y     = 'gaussian';       % type of covariance function
model_Y     = 'exponential';       % type of covariance function
variance_Y  = 1;                % variance parameter for covariance function
lambda_Y    = [10 20];           % vector of correlation length scales in y,x,z-directino
lambda_Y=lambda_Y;
micro_Y     = 0.4;                % fine-scale smoothing parameter
beta_Y      = 1;               % expected value for mean value
Qbb_Y       = 0.25;             % variance of mean value
domain_len  = [100 100];        % vector of domain length in y,x,z-direction
n_el        = [500 500];      % vector of element numbers in y,x,z-direction
nel         = prod(n_el);       % total number of elements
el_len      = domain_len./n_el; % vector of element length in y,x,z-direction
flag_kit    = 1;                % spectrum allowed to be random
flag_zh     = 1;                % low-value inclusions, high-value conncetivity
periodicity = [1 1 0];          % non-periodic random field

clf

tic
Z = test_generate_y(model_Y,variance_Y,lambda_Y,micro_Y,beta_Y,Qbb_Y,domain_len,el_len,n_el,nel,flag_kit,flag_zh,periodicity);
Z = reshape(Z,n_el);
[X,Y]=meshgrid(linspace(0,domain_len(1),n_el(1)),linspace(0,domain_len(2),n_el(2)));
subplot(2,2,1);
surf(X,Y,Z), daspect([1 1 0.2])
zlim([mean(Z(:))-2*sqrt(variance_Y) mean(Z(:))+2*sqrt(variance_Y)])
shading flat, lighting flat %, material shiny, camlight head
view([0 0 1]);
subplot(2,2,3);
hist(Z(:),100);
toc

tic
flag_kit    = 1;                % spectrum allowed to be random
Z = test_generate_y(model_Y,variance_Y,lambda_Y,micro_Y,beta_Y,Qbb_Y,domain_len,el_len,n_el,nel,flag_kit,flag_zh,periodicity);
Z = reshape(Z,n_el);
[X,Y]=meshgrid(linspace(0,domain_len(1),n_el(1)),linspace(0,domain_len(2),n_el(2)));
subplot(2,2,2);
surf(X,Y,Z), daspect([1 1 0.2])
zlim([mean(Z(:))-2*sqrt(variance_Y) mean(Z(:))+2*sqrt(variance_Y)])
shading flat, lighting flat %, material shiny, camlight head
view([0 0 1]);
subplot(2,2,4);
hist(Z(:),100);
toc
