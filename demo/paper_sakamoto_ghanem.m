function paper_sakamoto_ghanem
% PAPER_SAKAMOTO_GHANEM Test the ideas in a paper of Sakamoto and Ghanem.
%
% [1] S. Sakamoto and R. Ghanem "Simulation of multi-dimensional non-
%     gaussian non-stationary random fields", Prog. Eng. Mech. 17
%     (2002) 167-176

no_cell_mode=true; %#ok

%% Part 1: Stochastic process with beta marginal distribution
% Section 3.1

% Get the PCE coefficients for the (4,2) beta distribution

% this transforms a gaussian rv to a beta distributed rv
do_expand=0;
if do_expand
    h=@(x)(beta_stdnor(x,4,2));
    [pcc,pci]=pce_expand_1d(h,7);
else
    pcc=[
        0.66666666667635
        0.17597895719950
        -0.01663563405422
        -0.00582598998822
        0.00081249359076
        0.00017949740991
        -0.00002547291497
        -0.00000453044796];
    pci=0:7;
end

disp('Compare to [1] table 1: Coefficients for H_i for beta (4,2) distribution');
for i=1:8
    disp( sprintf( '%1d %12.5e', pci(i), pcc(i) ) );
end

% Synthesize beta distribution
clf;
N=10000;
xn=randn(N,1);
for i=1:4
    p=i+(i==4);
    bn=hermite_val( pcc(1:(p+1)), xn );
    subplot(2,2,i);
    [x,f_pce]=kernel_density( bn, 100, 0.03 );
    f_ex=beta_pdf( x, 4, 2 );
    plot(x,f_pce,x,f_ex);
    xlim([0,1]);
end
disp('Compare to [1] fig 1: Synthesized beta distribution');

%if( exist('no_cell_mode') ) return; end


%%
n=11;
p=5;
m=3;
lc=1;

[pos,els]=create_mesh_1d(0,1,n);

%h=@(gamma)(4+0.3*gamma);
% Step 1: calculate the U_i(x) numerically
% here the U_i are in pcc
h=@(gamma)(beta_stdnor(gamma,4,0.4)); %#ok for testing
h=@(gamma)(lognormal_stdnor(gamma,2,0.1)); %#ok for testing
h=@(gamma)(beta_stdnor(gamma,4,2));
pcc=pce_expand_1d(h,p);
[mu,sig2,skew]=beta_moments( 4, 2 );
disp(sprintf('Orig: Mean: %8.5f  Var: %8.5f  Skew: %8.5f  ', mu, sig2, skew ) );
[mu,sig2,skew]=pce_moments( pcc );
disp(sprintf('PCE:  Mean: %8.5f  Var: %8.5f  Skew: %8.5f  ', mu, sig2, skew ) );

% Step 2: calculate <gam_i gam_j> from <u_i u_j>
Cu=covariance_matrix( pos, {@gaussian_covariance, {lc, sqrt(sig2)}} );
Cgam=transform_covariance_pce( Cu, pcc );
disp(['<u_1 u_i>:    ' sprintf('%9.5f',Cu(1,:))] );
disp(['<gam_1 gam_i>:' sprintf('%9.5f',Cgam(1,:))] );

% Step 3: Calculate lamda_i and f_i (i.e. do KL expansion)
M=mass_matrix( pos, els );
W=M*Cgam*M; W=0.5*(W+W');
[V,D]=eigs(W,M,m,'lm',struct('disp',0));
%sqrt_lambda=sqrt(diag(D)/sum(diag(D)));
sqrt_lambda=sqrt(diag(D));
F=V';
plot( V );

% F should be orthogonal with respect to M
%disp(F*M*F');

Fs=row_col_mult( F, sqrt_lambda );
disp(norm(Fs*M*Fs'-D));

I_gam=full(multiindex(m,1));
pcc_gam=[zeros(1,n); Fs];

[mu,sig2]=pce_moments( pcc_gam, I_gam );
disp([mu;sig2]);

%%

% Step 4: generate gam(x)
% In my view unnecessary, we directly generate the u_\alpha

I_u=multiindex(m,p);
u=zeros(size(I_u,1),n);
for alpha=1:size(I_u,1)
    ind=I_u(alpha,:);
    ord=multiindex_order( ind );
    factor=factorial( ord )/multiindex_factorial( ind )...
        *pcc(ord+1);
    fun=ones(1,n);
    for j=1:m
        alpha_j=ind(j);
        if alpha_j~=0
            fun=fun .* (sqrt_lambda(j)*F(j,:)).^alpha_j;
        end
    end
    u(alpha,:)=factor*fun;
end

%disp(u);
%[mu,sig2]=pce_moments( u, I_u );
%disp([mu;sig2]);
%[mu,sig2,skew]=pce_moments( u, I_u );
[mu,sig2]=pce_moments( u, I_u );
skew=NaN*sig2;
for i=1:n; disp(sprintf('PCE:  Mean: %8.5f  Var: %8.5f  Skew: %8.5f  ', mu(i), sig2(i), skew(i) ) ); end;
%omu=mu;
%osig2=sig2;
[mu,sig2,skew]=pce_moments( pcc );
disp(sprintf('PCE:  Mean: %8.5f  Var: %8.5f  Skew: %8.5f  ', mu, sig2, skew ) );
%[omu(:)/mu osig2(:)/sig2]



% Step 5:




%%

%%
% Mathematica
pce_mathematica=[ %#ok
   0.66666666666643792
   0.17597895710694766
  -0.016635634219117415
  -0.0058259898651137777
   0.00081249419099748788
   0.00017949783502176872
  -0.000025473119273459329
  -0.0000045307289665041565];
%Matlab1 (quad)
pce_matlab_quad=[ %#ok
   0.66666876168583
   0.17597940090541
  -0.01663500797442
  -0.00582673133358
   0.00080811018293
   0.00017949690535
  -0.00002547328343
  -0.00000453084030];
%Matlab2 (gh8)
pce_matlab_gh8=[ %#ok
   0.66666666476944
   0.17597895435364
  -0.01663563579098
  -0.00582616137836
   0.00081234869169
   0.00018015036106
  -0.00002494738434
  -0.00000532251452];
% Matlab (gh12)
pce_matlab_gh12=[ %#ok
   0.66666666667635
   0.17597895719950
  -0.01663563405422
  -0.00582598998822
   0.00081249359076
   0.00017949740991
  -0.00002547291497
  -0.00000453044796];



%%

