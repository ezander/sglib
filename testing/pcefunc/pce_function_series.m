function u_alpha=pce_function_series( x_alpha, I_a, func_name, varargin )

options=varargin2options( varargin{:} );
%[x0,options]=get_option( options, 'x0', [] );
[order,options]=get_option( options, 'order', 10 );
check_unsupported_options( options, mfilename );

N=order;
n=1:N;
switch func_name
    case 'exp'
        error(['not yet implemented: ' func_name ]);
    case {'ln', 'log' }
        error(['not yet implemented: ' func_name ]);
        
    case 'sqrt'
        % laguerre recurrence and coeffs
        a1=(2*n-1)./n;
        a2=1./n;
        a3=(n-1)./n;
        exp_coeffs=sqrt(pi)*[1/2, -1/4, -1/16, -1/32, -5/256, -7/512, -21/2048, -33/4096, ...
            -429/65536, -715/131072, -2431/524288, -4199/1048576, ...
            -29393/8388608, -52003/16777216, -185725/67108864, ...
            -334305/134217728, -9694845/4294967296, -17678835/8589934592, ...
            -64822395/34359738368, -119409675/68719476736, ...
            -883631595/549755813888];
        exp_coeffs2=[0.886226925452758014,-0.443113462726379007,... 
            -0.110778365681594752,-0.0553891828407973759,...
            -0.0346182392754983599,-0.0242327674928488519,...
            -0.018174575619636639,-0.0142800237011430735,...
            -0.0116025192571787472,-0.00966876604764895599,...
            -0.00821845114050161259,-0.00709775325770593815,...
            -0.00621053410049269588,-0.00549393401197430789,...
            -0.00490529822497706062,-0.00441476840247935456,...
            -0.00400088386474691507,-0.00364786470021042256,...
            -0.00334387597519288735,-0.00307988576662502782,...
            -0.00284889433412815073]; %#ok
        factor_x=1./x_alpha(:,1);
        factor_u=sqrt(x_alpha(:,1));
    otherwise
        error(['unknown function: ' func_name ]);
end

x_alpha=row_col_mult(x_alpha,factor_x);
pm1=zeros(size(x_alpha));
p0=pm1; p0(:,1)=1;

pa=pm1;
pb=p0;
u_alpha=exp_coeffs(1)*p0;
for i=n
    pc=a1(i)*pb-a2(i)*pce_multiply(x_alpha,I_a,pb,I_a,I_a)-a3(i)*pa;
    u_alpha=u_alpha+exp_coeffs(i+1)*pc;
    pa=pb;
    pb=pc;
end
u_alpha=row_col_mult(u_alpha,factor_u);
