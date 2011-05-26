function test_kl_evs
c=1;
a=1;

N=100;

clc
fun1=@(w)(c-w.*tan(a*w));
w1=fsolve_mult( fun1, 0, N )

fun2=@(w)(w+c.*tan(a*w));
w2=fsolve_mult( fun2, 0, N )

w=sort( [w1 w2] )
sig=sqrt( 2*c./(w.^2+c^2) )
lam=sig.^2

plot(sig); hold all
plot(lam)
plot(cumsum(lam))
hold off
sum(sig.^2)
1

function w=fsolve_mult( fun, x0, x1 )
%%
wc=linspace(x0,x1,1000);
fv=abs(fun(wc));
fs=sign( fv(2:end)-fv(1:end-1));
mins=find(2*fs(2:end)+fs(1:end-1)==1)+1;

wcan=wc(mins);
for i=1:length(wcan)
    w0=wcan(i);
    opts=optimset( 'display', 'off', 'TolFun', 1e-10 );
    [x,fval,flag]=fsolve( fun, w0, opts );
    w(i)=x;
end
%%
plot( wc, fv ); hold on;
plot( wcan, 0, 'b*' )
plot( wcan, fun(wcan), 'ko' )
plot( w, fun(w), 'rx' )
ylim([-1,1])
hold off;


