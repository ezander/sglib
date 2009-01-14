model_Y     = 'gaussian';       % type of covariance function
variance_Y  = 1;                % variance parameter for covariance function
lambda_Y    = [10 20];           % vector of correlation length scales in y,x,z-directino
micro_Y     = 1;                % fine-scale smoothing parameter
beta_Y      = 1;               % expected value for mean value
Qbb_Y       = 0.25;             % variance of mean value
domain_len  = [100 100];        % vector of domain length in y,x,z-direction
n_el        = [500 500];      % vector of element numbers in y,x,z-direction
nel         = prod(n_el);       % total number of elements
el_len      = domain_len./n_el; % vector of element length in y,x,z-direction
flag_kit    = 0;                % spectrum allowed to be random
flag_zh     = 1;                % low-value inclusions, high-value conncetivity
periodicity = [0 0 0];          % non-periodic random field

tic
Y = test_generate_y(model_Y,variance_Y,lambda_Y,micro_Y,beta_Y,Qbb_Y,domain_len,el_len,n_el,nel,flag_kit,flag_zh,periodicity);
toc

Y = reshape(Y,n_el);
surf(Y), daspect([1 1 0.05])
zlim([mean(Y(:))-2*sqrt(variance_Y) mean(Y(:))+2*sqrt(variance_Y)])
shading flat, lighting flat, material shiny, camlight head
colorbar
