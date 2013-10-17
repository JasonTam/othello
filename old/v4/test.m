
b = initBoard;
coord=[5,3];
Tok = 1;
tic
for i = 1:1000
%     getAllValid(b,1);



% se = strel('square',3);
% se = ones(3);
% se = true(3);

% q = imdilate(b,ones(3));
% 
% m = q - abs(b);

% isValidMove2(b,coord,Tok);
getAllValid_c(b,Tok);


% 
% padarray(q,n-coord(2)-1,'post');
% [q; zeros([n-coord(2)-1 1])];
end

toc


%%

for i = 1:10
    for q = 1:20
        p = [i q];
        if q==4&&i ==3
            return
        end
    end
end



%%
n = 8;
coord = [3 5]
a = magic(n);
a = reshape(1:64,[8 8])'

% Emitting from the coord in question
% 2 horz, 2 vert, 2\diag, 2/diag
rays = cell(8,1);

% Vertical
rays{1} = flipud(a(1:coord(2)-1,coord(1)));
rays{2} = a(coord(2)+1:end,coord(1));
% Horizontal
rays{3} = flipud(a(coord(2),1:coord(1)-1)');
rays{4} = a(coord(2),coord(1)+1:end)';

% Diagonals
d1 = diag(a,coord(1)-coord(2));
d2 = diag(fliplr(a),(n-coord(1)+1)-coord(2));

dq = repmat(1:n,[n 1]);
dInds1 = tril(dq)'+tril(dq,-1);
dInds2 = fliplr(dInds1);
dI1 = dInds1(coord(2),coord(1));
dI2 = dInds2(coord(2),coord(1));

rays{5} = flipud(d1(1:dI1-1));
rays{6} = d1(dI1+1:end);

rays{7} = flipud(d2(1:dI2-1));
rays{8} = d2(dI2+1:end);

%%
pTok = 1j;

q = [1 1 1 1 1j 1]

d = diff(q)
ad = abs(d)

i = find(ad,1)

if q(i+1)==pTok
%    score_q += i 

% Do the actual flipping
q_next = q;
q_next(1:i) = pTok;

end

% % Test which one is faster, or more convenient
% % calculating the score change as you go
% % or just calculating the score change after making
% % all the appropriate flips


%%
pTok = 1j;

testRay = @(r) rayFlip(r,pTok);

newRays = cellfun(testRay,rays,'UniformOutput',0)


%%
pTok = 1j;
% Replacements
rV = [flipud(rays{1}); pTok; rays{2}]
rH = [flipud(rays{3}); pTok; rays{4}]
rD1 = [flipud(rays{5}); pTok; rays{6}]
rD2 = [flipud(rays{7}); pTok; rays{8}]

b = a ;

b(:,coord(1)) = rV;
b(coord(2),:) = rH;

drI1 = diag(ones([numel(rD1) 1]),coord(1)-coord(2));
drI2 = fliplr(diag(ones([numel(rD2) 1]),(n-coord(1)+1)-coord(2)));

b(drI1) = rD1;
b(drI2) = rD2;

%%
copyfile(fullfile(docroot, 'techdoc','creating_guis',...
'examples','lbox2*.*')), fileattrib('lbox2*.*', '+w')
guide lbox2.fig



%%
n = 8;

fileID = fopen('../sables/sampleOthello1.txt');

formatSpec = repmat('%d',[1 n]);

C = textscan(fileID, formatSpec,'CollectOutput',true);
fclose(fileID);


C = cell2mat(C);
C = C(1:n,:)
















































