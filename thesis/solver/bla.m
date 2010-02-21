function bla


% sum=7800*12
% days=108;
% 10 cent;
% 20-3500 eur


s=7800*12;
N=108;
lb=20;
ub=3500;
fak=1.1;
mu=s/N;


clc
v=rand_exp(N,mu);
v=rand_exp_limits(N,mu,lb,ub,fak);
v=round10(v);

min(v)
max(v)
sum(v<20)
sum(v>3500)
sum(v)

vs=num2str(v,'%e'); 
dig=double(vs(:,1)-'0');
pd=accumarray( dig, ones(N,1) );
d=1:9;
pe=round(N*(log10(d+1)-log10(d))');
[pd pe]

fid=fopen( 'a7.txt', 'w' );
fprintf( fid, 'Datensatz:\n' );
fprintf( fid, '%8.2f\n', v );
fprintf( fid, '\nStatistik (allgemein):\n' );
fprintf( fid, ' Anz: %9g\n', length(v) );
fprintf( fid, ' Sum: %9.2f\n', sum(v) );
fprintf( fid, ' Min: %9.2f\n', min(v) );
fprintf( fid, ' Max: %9.2f\n', max(v) );
fprintf( fid, '\nZiffern Statistik (Erwartungswert in Klammern):\n' );
fprintf( fid, '  %1d: %2d  (%2d)\n', [(1:9)' pd pe ]' );
fprintf( fid, ' \n' );
fclose(fid);




function x=round10(x)
x=round(x*10)/10;

function x=rand_exp_limits(N,mu,lb,ub,fak)
x=rand_exp(2*N, mu );
x(x<lb*fak)=[];
x(x>ub/fak)=[];
x=x(1:N);
x=x*mu/mean(x);


function x=rand_exp( N, mu )
lambda=1/mu;
x=randn(N,1);
x=(log(2)-log(erfc(x/sqrt(2))))/lambda;
