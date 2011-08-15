function dvi=showdvi(dvi,spc,verb)

if nargin<3
    v=whos( 'global', 'dvi_verbose' );
    if length(v)
        global dvi_verbose
        verb=dvi_verbose;
    else
        verb=false;
    end
end

if nargin<2
    s=whos( 'global', 'dvi_spacing' );
    if length(s)
        global dvi_spacing
        spc=dvi_spacing;
    else
        spc=100000;
    end
end


sgn=sign(spc); spc=abs(spc);
a1=uint8(mod(spc,256)); spc=floor(spc/256);
a2=uint8(mod(spc,256)); spc=floor(spc/256);
a3=uint8(mod(spc,256)); spc=floor(spc/256);
if sgn==-1
    % should be two's complement but that doesn't make a difference
    a3=255-a3;
    a2=255-a2;
    a1=255-a1;
end


p=1;
while p<length(dvi)
    [op,p]=readdvi(dvi,p,1);
    if verb
        fprintf( '%d: op: %d\n', p-1, op );
    end
    if op<128
        %0...127 	 set_char_i 		typeset a character and move right
        %disp(char(op));
        if verb
            fprintf( '%d: char "%s"\n', p-1, char(op) );
        end
        dvi=[dvi(1:p-1)' 150 a3 a2 a1 dvi(p:end)']';
    else
        switch op
            % 128 	set1 	c[1] 	typeset a character and move right
            % 129 	set2 	c[2]
            % 130 	set3 	c[3]
            % 131 	set4 	c[4]
            case {128,129,130,131}
                [c,p]=readdvi(dvi,p,op-127);
                
            % 132 	set_rule 	a[4], b[4] 	typeset a rule and move right
            case 132
                p=p+4+4;
                
            % 133 	put1 	c[1] 	typeset a character
            case 133
                p=p+1;
                
            % 134 	put2 	c[2]
            case 134
                p=p+2;
                
            % 135 	put3 	c[3]
            case 135
                p=p+3;
                
            % 136 	put4 	c[4]
            case 136
                p=p+4;
                
            % 137 	put_rule 	a[4], b[4] 	typeset a rule
            case 137
                p=p+4+4;
                
            % 138 	nop 		no operation
            case 138
                p=p;
                
            % 139 	bop 	c_0[4]..c_9[4], p[4] 	beginning of page
            case 139
                p=p+40+4;
                
            % 140 	eop 		ending of page
            case 140
                p=p;
                
            % 141 	push 		save the current positions
            case 141
                p=p;
                
            % 142 	pop 		restore previous positions
            case 142
                p=p;
                
            % 143 	right1 	b[1] 	move right
            case 143
                p=p+1;
                
            % 144 	right2 	b[2]
            case 144
                p=p+2;
                
            % 145 	right3 	b[3]
            case 145
                p=p+3;
                
            % 146 	right4 	b[4]
            case 146
                p=p+4;
                
            % 147 	w0 		move right by w
            case 147
                p=p;
                
            % 148 	w1 	b[1] 	move right and set w
            case 148
                p=p+1;
                
            % 149 	w2 	b[2]
            case 149
                p=p+2;
                
            % 150 	w3 	b[3]
            case 150
                p=p+3;
                
            % 151 	w4 	b[4]
            case 151
                p=p+4;
                
            % 152 	x0 		move right by x
            case 152
                p=p;
                
            % 153 	x1 	b[1] 	move right and set x
            case 153
                p=p+1;
                
            % 154 	x2 	b[2]
            case 154
                p=p+2;
                
            % 155 	x3 	b[3]
            case 155
                p=p+3;
                
            % 156 	x4 	b[4]
            case 156
                p=p+4;
                
            % 157 	down1 	a[1] 	move down
            case 157
                p=p+1;
                
            % 158 	down2 	a[2]
            case 158
                p=p+2;
                
            % 159 	down3 	a[3]
            case 159
                p=p+3;
                
            % 160 	down4 	a[4]
            case 160
                p=p+4;
                
            % 161 	y0 		move down by y
            case 161
                p=p;
                
            % 162 	y1 	a[1] 	move down and set y
            case 162
                p=p+1;
                
            % 163 	y2 	a[2]
            case 163
                p=p+2;
                
            % 164 	y3 	a[3]
            case 164
                p=p+3;
                
            % 165 	y4 	a[4]
            case 165
                p=p+4;
                
            % 166 	z0 		move down by z
            case 166
                p=p;
                
            % 167 	z1 	a[1] 	move down and set z
            case 167
                p=p+1;
                
            % 168 	z2 	a[2]
            case 168
                p=p+2;
                
            % 169 	z3 	a[3]
            case 169
                p=p+3;
                
            % 170 	z4 	a[4]
            case 170
                p=p+4;
                
            % 171...234 	fnt_num_i 		set current font to i
            case num2cell(171:234)
                p=p;
                
            % 235 	fnt1 	k[1] 	set current font
            case 235
                p=p+1;
                
            % 236 	fnt2 	k[2]
            case 236
                p=p+2;
                
            % 237 	fnt3 	k[3]
            case 237
                p=p+3;
                
            % 238 	fnt4 	k[4]
            case 238
                p=p+4;
                
            % 239 	xxx1 	k[1], x[k] 	extension to DVI primitives
            % 240 	xxx2 	k[2], x[k]
            % 241 	xxx3 	k[3], x[k]
            % 242 	xxx4 	k[4], x[k]
            case {239,240,241,242}
                [k,p]=readdvi(dvi,p,op-238);
                [x,p]=readdviarr(dvi,p,k);
                

            % 243 	fnt_def1 	k[1], c[4], s[4], d[4],
            %       a[1], l[1], n[a+l]	define the meaning of a font number
            % 244 	fnt_def2 	k[2], c[4], s[4], d[4],
            %       a[1], l[1], n[a+l]
            % 245 	fnt_def3 	k[3], c[4], s[4], d[4],
            %       a[1], l[1], n[a+l]
            % 246 	fnt_def4 	k[4], c[4], s[4], d[4],
            %        a[1], l[1], n[a+l]
            case {243,244,245,246}
                [k,p]=readdvi(dvi,p,op-242);
                [c,p]=readdvi(dvi,p,4);
                [s,p]=readdvi(dvi,p,4);
                [d,p]=readdvi(dvi,p,4);
                [a,p]=readdvi(dvi,p,1);
                [l,p]=readdvi(dvi,p,1);
                [n,p]=readdviarr(dvi,p,a+l);
                
                
            % 247 	pre 	i[1], num[4], den[4], mag[4],
            % k[1], x[k] 	preamble
            case 247
                [i,p]=readdvi(dvi,p,1);
                [num,p]=readdvi(dvi,p,4);
%                 p=p-4;
%                 dvi(p:p+3)=[2,131,146,192];
%                 [num,p]=readdvi(dvi,p,4);
                
                [den,p]=readdvi(dvi,p,4);
                [mag,p]=readdvi(dvi,p,4);
                p=p-4;
                %dvi(p:p+3)=[0,0,8,0];
                [mag,p]=readdvi(dvi,p,4);
                
                [k,p]=readdvi(dvi,p,1);
                [x,p]=readdviarr(dvi,p,k);
                
            % 248 	post 	p[4], num[4], den[4], mag[4],
            % l[4], u[4], s[2], t[2]
            % < font definitions > 	postamble beginning
            case 248
                [pp,p]=readdvi(dvi,p,4);
                [num,p]=readdvi(dvi,p,4);
                [den,p]=readdvi(dvi,p,4);
                [mag,p]=readdvi(dvi,p,4);
                p=p-4;
                %dvi(p:p+3)=[0,0,8,0];
                [mag,p]=readdvi(dvi,p,4);
                [l,p]=readdvi(dvi,p,4);
                [u,p]=readdvi(dvi,p,4);
                [s,p]=readdvi(dvi,p,2);
                [t,p]=readdvi(dvi,p,2);
                
            % 249 	post_post 	q[4], i[1]; 223's	postamble ending
            case 249
                [q,p]=readdvi(dvi,p,4);
                [i,p]=readdvi(dvi,p,1);
                [n223,p]=readdvi(dvi,p,4);
                break;
                
            % 250...255 	undefined 	        end
            otherwise
                keyboard;
        end
    end
end


function [val,p]=readdvi(dvi,p,num)
[arr,p]=readdviarr(dvi,p,num);
val=0;
for i=1:num
    val=256*val+arr(i);
end

function [arr,p]=readdviarr(dvi,p,num)
arr=double(dvi(p:(p+num-1)));
p=p+num;

