% DEMO_DISTRIBUTIONS Demonstrate usage and some properties of the probability distribution functions.

init_demos

clear;

%% Normal distribution
% The normal distribution blah blah...
subplot(1,1,1); clf;
mu=2;
var=0.5;
x=linspace(-1,5);
f=normal_pdf(x,mu,var);
F=normal_cdf(x,mu,var);
subplot(2,1,1);
plot(x,F,x,cumsum(f)*(x(2)-x(1)) );

f=normal_pdf(x,mu,var);
F=normal_cdf(x,mu,var);
subplot(2,1,2);
plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)));
disp( 'Normal distribution' );
userwait

%% Lognormal distribution
subplot(1,1,1); clf;
mu=2;
var=0.5;

x=linspace(0,30);
f=lognorm_pdf(x,mu,var);
F=lognorm_cdf(x,mu,var);
subplot(2,1,1);
plot(x,F,x,cumsum(f)*(x(2)-x(1)) )

x=linspace(-10,20);
f=lognorm_pdf(x,mu,var);
F=lognorm_cdf(x,mu,var);
subplot(2,1,2);
plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
disp( 'Lognormal distribution' );
userwait

%% Exponential distribution
subplot(1,1,1); clf;
lambda=1.5;
x=linspace(-.1,5);
f=exponential_pdf(x,lambda);
F=exponential_cdf(x,lambda);
subplot(2,1,1);
plot(x,F,x,cumsum(f)*(x(2)-x(1)) )

f=exponential_pdf(x,lambda);
F=exponential_cdf(x,lambda);
subplot(2,1,2);
plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
disp( 'Exponential distribution' );
userwait

%% Beta distribution

% First the cumulative distribution function
subplot(1,1,1); clf;
x=linspace(-.2,1.2);
a=2; b=4;
f=beta_pdf(x,a,b);
F=beta_cdf(x,a,b);
subplot(2,1,1);
plot(x,F,x,cumsum(f)*(x(2)-x(1)) )

% Then the probability distribution function
f=beta_pdf(x,a,b);
F=beta_cdf(x,a,b);
subplot(2,1,2);
plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
disp( 'Beta(4,2) distribution' );
userwait
