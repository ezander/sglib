function Cn=normalize_cov( C )
Cn=C-min(C(:));
Cn=Cn/max(Cn(:));

