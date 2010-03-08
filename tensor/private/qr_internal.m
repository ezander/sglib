function [Q,R]=qr_internal( A, G )
if isempty(G)
    [Q,R]=qr(A,0);
else
    [Q,R]=gram_schmidt(A,G,false,1);
end
