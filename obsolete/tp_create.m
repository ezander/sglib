function tp=tp_create( x, m )

if nargin>=2
    [U,S,V]=svds(sparse(x),m);
else
    [U,S,V]=svd(x,'econ');
end
tp={U*S,V};
