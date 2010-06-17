function legend_add( s )
if isnumeric(s)
    s=sprintf( '%g', s );
end
[legend_h,object_h,plot_h,text_strings] = legend();
legend( legend_h, [text_strings, {s}] );


