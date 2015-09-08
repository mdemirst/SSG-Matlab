function signatures = createSignature(N, E)

nrNodes = size(N,1);

signatures = cell(nrNodes, 3);

for i = 1:nrNodes
    signature = cell(1,3);
    signature(1,1) = {{[N{i,1}],N{i,2}(1),N{i,2}(2),N{i,2}(3),N{i,2}(4)}};
    if(isempty(E))
      signature(1,2) = {0};
    else
      signature(1,2) = {size(find(E(:,1)==i),1)};
      signature(1,3) = {E(find(E(:,1)==i),3)};
    end
    signatures(i,:) = signature;
end