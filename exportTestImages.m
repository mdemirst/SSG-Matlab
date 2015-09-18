function exportTestImages(folder_name)
% extracts test images from a given dataset folder
% test images then erased from dataset images
FREQ = 5;
TEST_FOLDER = 'TestImages';
FILE_PREFIX = 'Cold-';

cd(folder_name);
mkdir(TEST_FOLDER);

files = dir('*.jpg');

j = 1;
for i = 1:size(files,1)
  if(mod(i,FREQ)==0)
    movefile(files(i).name,strcat(TEST_FOLDER,'/',FILE_PREFIX,zeroPad(j-1),num2str(j-1),'t.jpg'));
  else
    if(i~=j)
      movefile(strcat(FILE_PREFIX,zeroPad(i),num2str(i),'.jpg'),...
               strcat(FILE_PREFIX,zeroPad(j),num2str(j),'.jpg'));
    end
    j = j+1;
  end
end