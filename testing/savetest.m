function savetest

format long g
format compact
clc
% a=100*rand(1)*10^(600*(rand(1)-0.5))
% b=100*rand(1)*10^(600*(rand(1)-0.5))
% x=[a b a b a b]
x=rand(60,70);
s=encode(x);
y=decode(s);
s
d=x-y;
all(d(:)==0)
numel(s{2})/numel(x)/8
% nabble2char( [0 12 63] )
% char2nabble( 'AM-' )



function s=encode(x)
arr=typecast(x(:),'uint8');
s={size(x), reshape( bytearr2str(arr), [], 80 ) };

function x=decode(s)
arr=str2bytearr(s{2}(:));
x=reshape( typecast(arr,'double'), s{1});



function c=nabble2char(b)
chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-';
c=chars(b+1);

function arr=str2bytearr(s)
arr=uint8([]);
b=uint16(0);
i=1;
n=0;
while true
    while n<8
        if i>length(s)
            if b~=0
                warning( 'wrong encoding' ); % bitlength must be multiple of 6
            end
            return
        else
            b6=char2nabble(s(i));
            b=bitor( b, bitshift(uint16(b6),n ) );
            n=n+6;
            i=i+1;
        end
    end
    b8=bitand(b,uint16(255));
    arr(end+1)=uint8(b8);
    n=n-8; 
    b=bitshift(b,-8);
end


function s=bytearr2str(arr)
b=uint16(0);
i=1;
n=0;
s='';
while true
    if n<6
        if i>length(arr)
            if n<=0
                return
            end
        else
            b=bitor( b, bitshift(uint16(arr(i)),n ) );
            n=n+8;
            i=i+1;
        end
    end
    b6=bitand(b,uint16(63));
    s(end+1)=nabble2char(b6);
    n=n-6; 
    b=bitshift(b,-6);
end



function b=char2nabble(c)
chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-';
b=[];
for cc=c
    b(end+1)=find( chars==cc, 1 )-1;
end

