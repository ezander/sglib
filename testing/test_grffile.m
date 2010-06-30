function test_grffile

set( 0, 'defaulttextfontname', 'crm12' );
set( 0, 'defaultaxesfontname', 'cmbx12' );
set( 0, 'defaultaxesfontname', 'cmr12' );
set( 0, 'defaultaxesfontname', 'times' );
set( 0, 'defaultaxesfontsize', 12 );
close
tripeaks
set(gcf,'renderer','zbuffer');
set(gcf,'renderer','opengl');
shading faceted
colormap cool
% material metal
%lighting phong
%light

print -dpng -r72 low.png
print -dpng -r300 xxxx.png
print -djpeg -r300 xxxx.jpg
print -dtiff -r300 xxxx.tiff
set(gcf,'renderer','painters');
print -dpdf -r300 xxxx.pdf
print -depsc2 xxxx.eps
return

persistent xxx

if isempty(xxx)
    xxx=1;
    web( publish( 'test_grffile', struct( 'showCode', false) ) )
    xxx=[];
    return
end

close

renderers={'painters', 'zbuffer', 'opengl' };
drivers={'epsc', 'epsc2', 'pdf', 'tiff', 'jpeg', 'png';
    'eps', 'eps', 'pdf', 'tiff', 'jpg', 'png' };
shadings={'flat', 'faceted', 'interp' };
funs={'peaks', 'tripeaks'};

clc
fprintf( '<html><h1>Comparison</h1></html>\n');
for i=1:length(funs)
    fun=funs(i);
    for j=1:length(shadings)
        s=shadings(j);
        sz=[];
        sz2={};
        for k=1:length(renderers)
            r=renderers(k);
            for l=1:size(drivers,2)
                d=drivers(:,l);
                %clf;
                %evalc(fun{1});
                %shading( s{:} );
                %set( gcf, 'renderer', r{:} )
                filename=sprintf( 'testfig/%s_%s_%s_%s.%s', fun{1}, s{:}, r{:}, d{1}, d{2} );
                %disp( filename );
                fi=dir( filename );
                %print( filename, ['-d' d{1}], '-r300' );
                
                %fprintf( '<html>%s,\t %6.2f\n</html>', fi.name, round(fi.bytes/1024^2*100)/100 );
                sz(k,l)=round(fi.bytes/1024^2*100)/100;
                %sz2{k,l}=sprintf( '%4.2f', sz(k,l) );
                sz2{k,l}=sprintf( '<a href="../%s">%4.2f</a>', filename, sz(k,l) );
            end
        end
        fprintf( '<html><h2>%s  %s</h2></html>\n', fun{1}, s{1} );
        evalc(fun{1});
        shading( s{:} );
        colormap('jet');
        snapnow;
        %makeHtmlTable( sz, [], renderers, drivers(1,:), flipud(colormap('autumn')) );
        fprintf( '<html><h2>%s  %s</h2></html>\n', fun{1}, s{1} );
        makeHtmlTable( log(sz), sz2, renderers, drivers(1,:), flipud(colormap('autumn')) );
        
        
    end
end

function tripeaks
[X,Y,Z] = peaks;
tri = delaunay(X,Y);
trisurf(tri,X,Y,Z);
