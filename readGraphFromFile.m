function [N, E, S] = readGraphFromFile(filename)
fid = fopen(filename);
nrNodes = fscanf(fid,'%d',1);

S = cell(nrNodes, 3);
N = cell(nrNodes, 2);
E = [];

count = 1;
for i = 1:nrNodes
    nodeId = fscanf(fid,'%d',1);
    x = fscanf(fid,'%d',1);
    y = fscanf(fid,'%d',1);
    colorR = fscanf(fid,'%f',1);
    colorG = fscanf(fid,'%f',1);
    colorB = fscanf(fid,'%f',1);
    area = fscanf(fid,'%d',1);
    nrEdges = fscanf(fid,'%d',1);
    edges = zeros(nrEdges,2);
    for j = 1:nrEdges
        edges(j,:) = fscanf(fid,'%d %f',2)';
        E(count,:) = [i edges(j,:)];
        count = count + 1;
    end
    
    %fill into signature
    signature = cell(1,3);
    signature(1,1) = {{[x y],colorR,colorG,colorB,area}};
    signature(1,2) = {nrEdges};
    signature(1,3) = {edges(:,2)};
    S(i,:) = signature;
    
    node = cell(1,2);
    node(1,1) = {[x,y]};
    node(1,2) = {[colorR,colorG,colorB,area]};
    N(i,:) = node;

end
fclose(fid);
