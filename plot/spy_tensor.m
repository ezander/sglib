function tensor_spy( A, varargin )

options=varargin2options( varargin{:} );
[num_shown,options]=get_option( options, 'num_shown', 2 );
[show_all,options]=get_option( options, 'show_all', false );
check_unsupported_options( options, mfilename );

if show_all; num_shown=size(A,1); end

clf
for i=1:num_shown
    subplot(num_shown,2,2*(i-1)+1); spy( A{i,1} );
    subplot(num_shown,2,2*(i-1)+2); spy( A{i,2} );
end

