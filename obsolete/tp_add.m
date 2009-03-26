function tp=tp_add( tp1, tp2, m )

tp={ [tp1{1}, tp2{1}], [tp1{2}, tp2{2}] };

if nargin>=2
    tp=tp_reduce( tp, m );
end
