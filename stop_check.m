function stop_check

global last_check
if isempty(last_check)
    last_check=tic;
end

if toc(last_check)>=1
    filename=fullfile( getenv('HOME'), 'sglib_stop' );
    if exist( filename, 'file' )
        disp('Stopping matlab, entering debugger, press F5 to continue' );
        keyboard;
        delete(filename);
    end
    last_check=tic;
end

