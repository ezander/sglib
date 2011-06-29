function curr=fasttest(mode)

global fasttest_mode

if isempty(fasttest_mode)
    fasttest_mode=false;
end

if nargin<1
    mode=~fasttest_mode;
end

if ~ischar(mode) 
    fasttest_mode=mode;
end

if nargout>0
    curr=fasttest_mode;
elseif fasttest_mode
    fprintf( 'FASTTEST mode enabled!\n' );
else
    fprintf( 'FASTTEST mode disabled!\n' );
end
