function same_scaling( handles, axis )

if nargin<2
    axis='z';
end
handles=handles(:);

%%
for i=1:length(handles)
    z=get( handles(i), [axis 'lim'] );
    if i==1
        zl=z;
    else
        zl=[min([z zl]), max([z zl])];
    end
end
for i=1:length(handles)
    set( handles(i), [axis 'lim'], zl );
end


