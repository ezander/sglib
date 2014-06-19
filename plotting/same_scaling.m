function same_scaling( handles, axes, varargin )

options=varargin2options(varargin, mfilename);
[zl_def,options]=get_option(options, 'range', []);
check_unsupported_options(options);

if nargin<2
    axes='z';
end
handles=handles(:);

%%
for axis=axes
    if isempty(zl_def)
        for i=1:length(handles)
            z=get( handles(i), [axis 'lim'] );
            if i==1
                zl=z;
            else
                zl=[min([z zl]), max([z zl])];
            end
        end
    else
        zl = zl_def;
    end
    for i=1:length(handles)
        set( handles(i), [axis 'lim'], zl );
    end
end

