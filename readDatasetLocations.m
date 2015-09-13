function locs = readDatasetLocations(dataset_no)

locs = [];
fid = fopen(strcat(['Datasets/',num2str(dataset_no),'/places.lst']));

nr_places = 0;

if(fid ~= -1)
  line = fgets(fid);
end

while ischar(line)
  a = strfind(line,'_x');
  b = strfind(line,'_y');
  c = strfind(line,'_a');
  d = strfind(line,'.jpeg ');
  nr_places = nr_places + 1;
  x = str2num(line(a+2:b-1));
  y = str2num(line(b+2:c-1));
  z = line(d+6:d+9);
  
  if(strcmp(z,'CR-A'))
    locs(:,nr_places) = [x;y;1];
  elseif(strcmp(z,'PA-A'))
    locs(:,nr_places) = [x;y;2];
  elseif(strcmp(z,'2PO1'))
    locs(:,nr_places) = [x;y;3];
  elseif(strcmp(z,'ST-A'))
    locs(:,nr_places) = [x;y;4];
  elseif(strcmp(z,'TL-A'))
    locs(:,nr_places) = [x;y;5];
  end

  line = fgets(fid);
end

fclose(fid);