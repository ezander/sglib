function [Q,R]=qr_internal( A, G, orth_columns )

timers( 'start', 'qr_internal' );

if nargin<2
    G=[];
end
if nargin<3
    orth_columns=0;
end

if isdiag(G)
    % if G is diagonal this is way faster than using the conjugate Gram
    % Schmidt algorithm
    S=sqrt(diag(G));
    SA=diag(S)*A;
    [SQ,R]=qr_internal( SA, [], orth_columns );
    %Q=diags(1./S)*SQ;
    Q=row_col_mult(SQ,1./S);
    timers( 'stop', 'qr_internal' );
    return
end


if isempty(G)
    if orth_columns>0
        n=orth_columns;
        % extract orthogonal columns and normalize
        Q1=A(:,1:n);
        s1=sqrt(sum(Q1.^2,1));
        Q1=Q1*spdiags(1./s1(:),0,n,n);
        
        % extract non-orthogonal columns and subtract components
        % from span(Q1) (two times)
        B=A(:,n+1:end);
        RB=Q1'*B;
        P=B-Q1*RB;
        P=P-Q1*(Q1'*P);
        
        % select only columns from B that are above the noise level and
        % orthogonalize
        ind=sqrt(sum(P.^2,1)./sum(B.^2,1))>1e-14;
        [Q2,Rdummy]=qr(P(:,ind),0); %#ok<NASGU>
        
        % reorthogonalize after subtracting components from span(Q1) that
        % are still left over (sometimes destroying orthogonality)
        % Note: this time we use orth due to its higher accuracy and
        % killing of non-essential components)
        Q2=Q2-Q1*(Q1'*Q2);
        Q2=orth(Q2);

        % combine Q matrix
        Q=[Q1, Q2];
        
        % combine R matrix
        R2=Q2'*P;
        R=[diag(s1), RB; zeros(size(R2,1),n), R2 ];
    else
        [Q,R]=qr(A,0);
    end
else
    [Q,R]=gram_schmidt(A,G,false,1);
end
timers( 'stop', 'qr_internal' );


function bool=isdiag(G)
[r,c]=find( G );
bool=all(r==c) && ~isempty(G);
