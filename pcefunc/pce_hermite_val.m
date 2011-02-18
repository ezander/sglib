function u_alpha=pce_hermite_val( a, x_alpha, I_x )

n=length(a);

H0=zeros(size(x_alpha));
H0(:,1)=1;
H1=x_alpha;

u_alpha=zeros(size(x_alpha));
if n==0; return; end

u_alpha=u_alpha+a(1)*H0;
if n==1; return; end

u_alpha=u_alpha+a(2)*H1;

HA=H0;
HB=H1;
for i=3:n
    % H_n = x H_{n-1} + (n-1) H_{n-2}
    HC=pce_multiply( x_alpha, I_x, HB, I_x, I_x ) - (n-2)*HA;
    
    u_alpha=u_alpha+a(i)*HC;
    
    HA=HB;
    HB=HC;
end

