function D = odctndict_multi(n,L,p,c)

D = [];
for i = 1:c
    D_tmp = odctndict(n,L,p);
    D = [D; D_tmp];
end

