function [f,sqrt_lambda]=kl_expand( pos, covar_func, M, m, varargin )

options=varargin2options( varargin{:} );
[N,options]=get_option( options, 'N', 32 );
check_unsupported_options( options, mfilename );


min_pos=min(pos, [], 1);
max_pos=max(pos, [], 1);
min_pos=min_pos-(max_pos-min_pos);

rays=repmat(min_pos,N,1)+(0:N-1)'*(max_pos-min_pos)/(N-1);

d=size( pos, 2 );

switch d
    case 1
        y=funcall( covar_func, rays, [] );
        yf=fft(y);
        yf=yf(1:N/2);
        [af,ind]=sort(abs(yf),'descend');
        sqrt_lambda=af(1:m);
        omega=2*pi*fix( ind/2+1);
        sincos=mod( ind, 2);
        for i=1:m
            if sincos(i)
                f(:,i)=sin( omega(i)*(pos-min_pos)/(max_pos-min_pos) );
            else
                f(:,i)=cos( omega(i)*(pos-min_pos)/(max_pos-min_pos) );
            end
            f(:,i)=f(:,i)/norm(f(:,i),2);
        end
        L=chol(M);
        f=L\f;
    case 2
        error( 'not yet implemented' );
    case 3
        error( 'not yet implemented' );
end




