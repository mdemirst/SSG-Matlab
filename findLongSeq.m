function indices = findLongSeq(sig)

tsig = (abs(sig) < 1);  %# Using eps as the threshold

dsig = diff([1 tsig 1]);
startIndex = find(dsig < 0);
endIndex = find(dsig > 0)-1;
duration = endIndex-startIndex+1;

stringIndex = (duration >= 5);
startIndex = startIndex(stringIndex);
endIndex = endIndex(stringIndex);

indices = zeros(1,max(endIndex)+1);
indices(startIndex) = 1;
indices(endIndex+1) = indices(endIndex+1)-1;
indices = find(cumsum(indices));
