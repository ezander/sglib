function change_tick_mode( h, axis, fun )

if isempty(h)
    h=gca;
end
if isempty(fun)
    fun=@num2str;
end

tick_str=[axis 'Tick'];
mode_str=[axis 'TickMode'];
labelmode_str=[axis 'TickLabelMode'];
label_str=[axis 'TickLabel'];

%set(h,mode_str,'manual');
set(h,labelmode_str,'manual');

ticks=get(h,tick_str);
labels={};
for t=ticks
    labels(end+1)={fun(t)};
end
set(h,label_str,labels);



