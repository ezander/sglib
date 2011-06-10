function show_tex_table_2d(n)
global info_tp

infos=info_tp;
switch n
    case 1
        hfield='rank_K';
        vfield='descr';
        efield='time';
        rfh=@(x)(x);
        rfv=@(x)(x);
        rfe=@(x)(roundat(x,1));
    otherwise
        error( 'foobar' );
end
maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )

function maketable( infos, hfield, vfield, efield, rfh, rfv, rfe )
hskip=0;
vskip=0;
num=numel(infos);
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
                curr=curr+hskip;
                if curr>num; curr=curr-num; end
            else
                entry=strvarexpand( '$rfv(infos{(j-1)*hskip+1}.(hfield))$' );
            end
        else
            if i>0
                entry=strvarexpand( '$rfh(infos{(i-1)*vskip+1}.(vfield))$' );
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
end


function eq=iseq( a, b )
if ischar(a)
    eq=strcmp(a,b);
else
    eq=a==b;
end
        

% fprintf( '\n');
% if trans
%     for j=1:length(entries)
%         for i=0:length(infos)
%             printentry( infos, entries, i, j, i==length(infos), rft, rfm );
%         end
%         fprintf( '\n');
%     end
% else
%     for i=0:length(infos)
%         for j=1:length(entries)
%             printentry( infos, entries, i, j, j==length(entries), rft, rfm );
%         end
%         fprintf( '\n');
%     end
% end

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

