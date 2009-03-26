function tp=tp_mult( A, tp, m )

if iscell(a)
    n=length(a)/2;
    U=zeros(size(tp{1},1),n*size(tp{1},2));
    V=zeros(size(tp{2},1),n*size(tp{2},2));
    for i=1:n
        U(:,1+(i-1)*n:n+(i-1)*n)=A{1+2*(i-1)}*tp{1};
        V(:,1+(i-1)*n:n+(i-1)*n)=A{2+2*(i-1)}*tp{2};
    end
    tp={U,V};
else
    tp={ A*tp{1}, tp{2} };
end

if nargin>=2
    tp=tp_reduce( tp, m );
end
