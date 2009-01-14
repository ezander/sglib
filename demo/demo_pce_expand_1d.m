% DEMO_PCE_EXPAND_1D

init_demos


% Test the univariate PCE expansion 

%% Lognormal distribution

N=10000;
h={@exp};
[pcc,pci,poc]=pce_expand_1d(h,7);
nor=randn(N,1);
lognor_pc=polyval(poc,nor);
lognor_ex=funcall(h,nor);

if 1
    p1=hermite_val(pcc,nor);
    fprintf( 'pce and rf match (1 means yes): %d\n', all(abs(p1-lognor_pc)<1e-8) );
    p2=hermite_val_multi(pcc,pci,nor);
    fprintf( 'pce and rf match (1 means yes): %d\n', all(abs(p2-lognor_pc)<1e-8) );
end

subplot(2,1,1)
hist(lognor_pc,40);
subplot(2,1,2)
hist(lognor_ex,40);
min(lognor_pc)
userwait;

%% Sometimes the approximated distribution is not strictly positive

N=10000;
disp('average number of negative values for a given approximation order');
neg=zeros(15,20);
minv=zeros(15,20);
for i=1:15
    [pcc,pci,poc]=pce_expand_1d(@exp,i); %#ok suppres mlint complaining about pci
    for k=1:20
        nor=randn(N,1);
        lognor_pc=hermite_val(pcc,nor);
        neg(i,k)=sum(lognor_pc<0);
        minv(i,k)=min(lognor_pc);
    end
    disp(sprintf('p=%2d: %6.1f+-%6.1f  (min:%6.3f)',i,mean(neg(i,:)),std(neg(i,:)),min(minv(i,k)) ));
    r=roots(poc);
    %disp(sprintf('roots of approx. poly: %6.3f %6.3f', r(find(r.*(imag(r)==0)))' ) );
    disp(sprintf('roots of approx. poly: %6.3f %6.3f', r(imag(r)==0)' ) ); %#ok 2 roots
end
% odd p seem to be preferable!
userwait;

%% Lognormal with mu=3; sig=.5

N=10000;
mu=3;sig=.5;
h=@(x)(exp(mu+sig*x));
pcc=pce_expand_1d(h,7);
nor=randn(N,1);
lognor_pc=hermite_val(pcc,nor);
lognor_ex=h(nor);

subplot(2,1,1)
hist(lognor_pc,40);
subplot(2,1,2)
hist(lognor_ex,40);
min(lognor_pc)
userwait;

%% Approximate the exponential distribution

N=10000;
lambda=1;
h=@(x)(log(2)-log(erfc(x/sqrt(2))));
pcc=pce_expand_1d(h,7);
nor=randn(N,1);
exp_pc=hermite_val(pcc,nor);
exp_ex=h(nor);

subplot(2,1,1)
hist(exp_pc,40);
subplot(2,1,2)
hist(exp_ex,40);
min(exp_pc)
userwait;

%% Check that the normal distribution is approximated correctly

[pcc,pci,poc]=pce_expand_1d(@(x)(x),7); clear pci;
% only the coefficient for H_1 should be 1, the rest zero
disp( sprintf( 'PCE Hermite coefficients, diff. from expected: %f ', norm(pcc-[0,1,0,0,0,0,0,0]) ) );
% only the coefficient for x should be 1, the rest zero
disp( sprintf( 'PCE polynomial coefficients, diff. from expected: %f ', norm(poc-[0,0,0,0,0,0,1,0]) ) );
userwait;

%% Lognormal distribution: comparison between analytical and MC solution

N=10000;
h=@(x)(exp(3+0.5*x));
[pcc1,pci1,poc1]=pce_expand_1d(h,7);
[pcc2,pci2,poc2]=pce_expand_1d_mc(h,7);
nor=randn(N,1);
lognor_data=h(randn(N*10,1));
[pcc3,pci3,poc3]=pce_expand_1d_mc(lognor_data,7);

lognor_pc1=polyval(poc1,nor);
lognor_pc2=polyval(poc2,nor);
lognor_pc3=polyval(poc3,nor);

subplot(2,1,1)
hist(lognor_pc1,40);
subplot(2,1,2)
hist(lognor_pc2,40);
disp('analytical approximation to lognormal distribution');
disp(pcc1');
disp('MC approximation to lognormal distribution');
disp(pcc2');
disp('MC2 approximation to lognormal distribution');
disp(pcc3');
userwait;

%% Check that mean and variance of pce transform are ok
% In the following the mean and variance of the lognormal distribution are
% calculated in four different ways. The first one are the exact formulae
% (see e.g. wikipedia). Then a MC simulation is made with 100000 exactly
% transformed gaussian random numbers and the mean and variance calculated 
% from there. Then pce expansions with increasing order are made and,
% again, mean and variance are calculated with two methods. The first one
% uses that the zeroth pce coefficient a_0 is the mean and sum_i=1^\infty
% a_i^2 i! is the variance. The second method is MC with the pce expansion.
% It can be seen that the mean is independent of the pce order (what a
% surprise...) and the variance converges quite fast to the exact and mc
% values respectively.
mu=2;
sigma=1;
h=@(x)(exp(mu+sigma*x));

ln_mean=exp(mu+sigma^2/2);
ln_var=(exp(sigma^2)-1)*exp(2*mu+sigma^2);

N=100000;
nor=randn(N,1);
lognor=h(nor);
ln_mean_mc=mean(lognor);
ln_var_mc=var(lognor);


clc;
for p=1:8
    [pcc,pci,poc]=pce_expand_1d(h,p);
    ln_mean_pce = pcc(1);
    ln_var_pce = sum(pcc(2:end).^2.*factorial(1:p));

    lognor_pce=hermite_val(pcc,nor);
    ln_mean_pce_mc=mean(lognor_pce);
    ln_var_pce_mc=var(lognor_pce);
    
    disp(sprintf( '\np=%2d      exact         pce        mc        pce->mc', p ) );
    disp(sprintf( 'mean: %10.5f  %10.5f  %10.5f  %10.5f', ln_mean, ln_mean_pce, ln_mean_mc, ln_mean_pce_mc ) );
    disp(sprintf( 'var:  %10.5f  %10.5f  %10.5f  %10.5f', ln_var, ln_var_pce, ln_var_mc, ln_var_pce_mc  ) );
end
userwait;
