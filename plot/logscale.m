function y=logscale( x, varargin )

options=varargin2options( varargin{:} );
[cutoff,options]=get_option( options, 'cutoff', 1e-18 );
[logbase,options]=get_option( options, 'logbase', 10 );
check_unsupported_options( options, mfilename );

x=abs(x);
if max(x)==0
    y=x;
    return
end

y=abs(x/max(x));
y(y<cutoff)=cutoff;
y=log(y)/log(logbase); 
