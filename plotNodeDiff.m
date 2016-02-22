fileID = fopen('diff.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec)
fclose(fileID);