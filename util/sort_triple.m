function [i,j,k]=sort_triple( i, j, k )
% SORT_TRIPLE Sorts an index triple (obsolete). 

%NOTE: This function is unused currently. Was used to speed up the
% computation of Hermite triple products.

if isscalar( i )
    if i>=j
        if j>=k
            [i,j,k]=deal(i,j,k);
        elseif i>=k
            [i,j,k]=deal(i,k,j);
        else
            [i,j,k]=deal(k,i,j);
        end
    else
        if i>=k
            [i,j,k]=deal(j,i,k);
        elseif j>=k
            [i,j,k]=deal(j,k,i);
        else
            [i,j,k]=deal(k,j,i);
        end
    end
else
    a=[i(:), j(:), k(:)];
    a=sort(a,2,'descend');
    i=a(:,1);
    j=a(:,2);
    k=a(:,3);
end
