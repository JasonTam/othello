
tok = 1;


    bb = [     1    -1    -1     0    -1     0     1     1
        -1     0     0     1     1    -1     1     0
        -1    -1     0    -1    -1     0     0    -1
        0     0     1     1     0     0    -1     1
        1     0    -1    -1     0     0     1     0
        0     0     0     0     1     0     0     0
        0    -1     1    -1    -1     0     1     0
        1     0     0    -1     1     1     1     0];
tic
for i = 1:100000
    [n,a] = getAllValid_c(bb,tok);
end
toc
%%
tic
for i = 1:10000
    b = randi([-1 1],8)
    getAllValid_c(b,tok);
end
toc