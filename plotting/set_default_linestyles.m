function old=set_default_linestyles( which )

lines={'-', '--', ':', '-.'};
%markers={'+', 'o', '*', 'x', 's', '^'};
markers={'o', '*', 'x', 's', '^'};


if iscell(which)
    clo=which{1};
    lso=which{2};
else
    switch which
        case 'default'
            clo=[0, 0, 4;
                0, 2, 0;
                4, 0, 0;
                0, 3, 3;
                3, 0, 3;
                3, 3, 0;
                1, 1, 1]*0.25;
            lso = '-';
        case 'factory'
            clo=get(0,'FactoryAxesColorOrder');
            lso=get(0,'FactoryAxesLineStyleOrder');
        case 'rgb'
            clo=[1 0 0;0 1 0;0 0 1];
            lso='-|--|:';
        case 'black'
            clo=[0 0 0];
            lso={};
            for i=1:length(lines)*length(markers);
                l=mod(i-1,length(lines))+1;
                m=mod(i-1,length(markers))+1;
                lso(end+1)={[lines{l} markers{m}]};
            end
        case 'blackl'
            clo=[0 0 0];
            lso={};
            for l=1:length(lines);
                for m=1:length(markers);
                    lso(end+1)={[lines{l} markers{m}]};
                end
            end
        case 'blackm'
            clo=[0 0 0];
            lso={};
            for m=1:length(markers);
                for l=1:length(lines);
                    lso(end+1)={[lines{l} markers{m}]};
                end
            end
        case 'black2'
            clo=[0 0 0];
            lso={'-o',':s','--+'};
        otherwise
            warning( 'SetDefaultLineStyleOrder:unknown', 'Unknown line style order name %s', which );
    end
end

if nargout>0
    old_clo=get(0,'DefaultAxesColorOrder');
    old_lso=get(0,'DefaultAxesLineStyleOrder');
    old={old_clo, old_lso };
end

set(0,'DefaultAxesColorOrder', clo);
set(0,'DefaultAxesLineStyleOrder', lso);
