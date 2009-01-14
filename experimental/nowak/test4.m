model_Y     = 'spherical';       % type of covariance function
model_Y     = 'exponential';       % type of covariance function
model_Y     = 'gaussian';       % type of covariance function
variance_Y  = 1;                % variance parameter for covariance function
lambda_Y    = [10 10];           % vector of correlation length scales in y,x,z-directino
micro_Y     = 0*0.5;                % fine-scale smoothing parameter
beta_Y      = 0;               % expected value for mean value
Qbb_Y       = 0;             % variance of mean value
domain_len  = [100 100];        % vector of domain length in y,x,z-direction
n_el        = [500 500];      % vector of element numbers in y,x,z-direction
nel         = prod(n_el);       % total number of elements
el_len      = domain_len./n_el; % vector of element length in y,x,z-direction
flag_kit    = 0;                % spectrum allowed to be random
flag_zh     = 1;                % low-value inclusions, high-value conncetivity
periodicity = [0 0 0];          % non-periodic random field

clf

tic
Y = test_generate_y(model_Y,variance_Y,lambda_Y,micro_Y,beta_Y,Qbb_Y,domain_len,el_len,n_el,nel,flag_kit,flag_zh,periodicity);
Y = reshape(Y,n_el);
toc
subplot(2,3,1);
surf(Y), daspect([1 1 0.05])
%zlim([mean(Y(:))-2*sqrt(variance_Y) mean(Y(:))+2*sqrt(variance_Y)])
zlim([min(Y(:)) max(Y(:))])
shading flat %, lighting flat, material shiny, camlight head
colorbar
view(2)
subplot(2,3,2);
surf(fftshift(log(abs(fft2(Y))))); view(2); shading flat; lighting flat
subplot(2,3,3);
surf(fftshift(ifft2(abs(fft2(Y)).^2))); view(2); shading flat; lighting flat


flag_zh=0;
tic
Y = test_generate_y(model_Y,variance_Y,lambda_Y,micro_Y,beta_Y,Qbb_Y,domain_len,el_len,n_el,nel,flag_kit,flag_zh,periodicity);
Y = reshape(Y,n_el);
toc
subplot(2,3,4);
surf(Y), daspect([1 1 0.05])
%zlim([mean(Y(:))-2*sqrt(variance_Y) mean(Y(:))+2*sqrt(variance_Y)])
zlim([min(Y(:)) max(Y(:))])
shading flat %, lighting flat, material shiny, camlight head
colorbar
view(2)
subplot(2,3,5);
surf(fftshift(log(abs(fft2(Y))))); view(2); shading flat; lighting flat
subplot(2,3,6);
surf(fftshift(ifft2(abs(fft2(Y)).^2))); view(2); shading flat; lighting flat
