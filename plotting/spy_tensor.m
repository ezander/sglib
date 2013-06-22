function spy_tensor( A, varargin )

options=varargin2options( varargin );
[num_shown,options]=get_option( options, 'num_shown', 2 );
[show_all,options]=get_option( options, 'show_all', false );
[spy_func,options]=get_option( options, 'spy_func', @spy2 );
check_unsupported_options( options, mfilename );

if show_all; num_shown=size(A,1); end

clf
for i=1:num_shown
    subplot(num_shown,2,2*(i-1)+1); funcall( spy_func, A{i,1} );
    subplot(num_shown,2,2*(i-1)+2); funcall( spy_func, A{i,2} );
end

