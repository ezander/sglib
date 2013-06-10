function test_fejer


cc_fejer(5, 1)
cc_fejer(5, 2)
cc_fejer(5, 3)
sum(cc_fejer(5, 1))
sum(cc_fejer(5, 2))
sum(cc_fejer(5, 3))

[w1,w2,wc]=fejer(16); 
wc(end+1)=wc(1);
sum(wc)
length(wc)


function w = cc_fejer(n, mode)
[wf1,wf2,wcc] = fejer(n);
switch mode
    case 1
        w = wf1';
    case 2
        w = wf2(2:end)';
    case 3
        w = [wcc; wcc(1)]';
    otherwise
        error('foo');
end




function [wf1,wf2,wcc] = fejer(n)
%BIT Numerical Mathematics
%March 2006, Volume 46, Issue 1, pp 195-202
%Fast Construction of the Fejér and Clenshaw–Curtis Quadrature Rules 
% doi: 10.1007/s10543-006-0045-4



% Weights of the Fejer2, Clenshaw-Curtis and Fejer1 quadratures
% by DFTs. Nodes: x_k = cos(k*pi/n), n>1
N=[1:2:n-1]'; l=length(N); m=n-l; K=[0:m-1]';
% Fejer2 nodes: k=0,1,...,n; weights: wf2, wf2_n=wf2_0=0
v0=[2./N./(N-2); 1/N(end); zeros(m,1)];
v2=-v0(1:end-1)-v0(end:-1:2); wf2=ifft(v2);
%Clenshaw-Curtis nodes: k=0,1,...,n; weights: wcc, wcc_n=wcc_0
g0=-ones(n,1); g0(1+l)=g0(1+l)+n; g0(1+m)=g0(1+m)+n;
g=g0/(n^2-1+mod(n,2)); wcc=ifft(v2+g);
% Fejer1 nodes: k=1/2,3/2,...,n-1/2; vector of weights: wf1
v0=[2*exp(i*pi*K/n)./(1-4*K.^2); zeros(l+1,1)];
v1=v0(1:end-1)+conj(v0(end:-1:2)); wf1=ifft(v1);
