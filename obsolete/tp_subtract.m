function tp=tp_subtract( tp1, tp2, m )

tp={ [tp1{1}, -tp2{1}], [tp1{2}, tp2{2}] };

if nargin>=2
    tp=tp_truncate( tp, m );
end
