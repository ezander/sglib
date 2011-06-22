function show_tex_table_2d(n)
global info_tp

infos=info_tp;
rfh=@(x)(x);
rfv=@(x)(x);
rfe=@(x)(x);
switch n
    case 1
        hfield='rank_K';
        vfield='descr';
        efield='time';
        maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )
    case 2
        hfield='abstol';
        rfh=@(x)(10000*x);
        vfield='descr';
        rfv=@(x)(['\kwf{', x, '}']);
        
        efield='time';
        maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )
        
        efield='relres';
        rfe=@(x)(10000*x);
        maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )
    otherwise
        error( 'foobar' );
end

function maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )
num=numel(infos);
hskip=num;
vskip=num;
for i=2:num;
    if iseq( infos{1}.(hfield), infos{i}.(hfield) )
        vskip=i-1;
        break;
    end
end
for i=2:num;
    if iseq( infos{1}.(vfield), infos{i}.(vfield) )
        hskip=i-1;
        break;
    end
end
if hskip==1
    hnum=vskip;
    vnum=num/hnum;
else
    hnum=num/hskip;
    vnum=num/hnum;
end

fprintf('\n\n');
curr=1;
for i=0:vnum
    for j=0:hnum
        if j>0
            if i>0
                entry=strvarexpand( '$rfe(infos{curr}.(efield))$' );
                if infos{curr}.flag~=0
                    entry=[entry strvarexpand( '($infos{curr}.flag$)' )];
                end
                curr=curr+hskip;
                if curr>num; curr=curr-num; end
            else
                entry=strvarexpand( '$rfh(infos{(j-1)*hskip+1}.(hfield))$' );
            end
        else
            if i>0
                entry=strvarexpand( '$rfv(infos{(i-1)*vskip+1}.(vfield))$' );
            else
                entry='';
            end
        end
        
        del='& ';
        if j==hnum
            del='\\';
        end
        fprintf( '%s %s', entry, del );
    end
    if i>0
        curr=curr+vskip;
        if curr>num; curr=curr-num; end
    end
    fprintf( '\n');
    if i==0
        fprintf( '\\hline\n');
    end
end


function eq=iseq( a, b )
if ischar(a)
    eq=strcmp(a,b);
else
    eq=a==b;
end

function printentry( infos, entries, i, j, atend, rft, rfm )
mode=entries{j,1};
if mode==-1
    if i==0; fprintf( '\\hline'); end
    return
end
if i==0
    entry=strvarexpand( entries{j,2} );
    if mode>0
        entry=sprintf( '\\hspace*{%dem}%s', mode, entry);
    end
else
    info=infos{i};
    t=info.timers;
    entry=strvarexpand( entries{j,3} );
end
del='& ';
if atend
    del='\\';
end
fprintf( '%s %s', entry, del );

