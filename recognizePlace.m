function place_id = recognizePlace(frame_id, summary_graphs)

global exec_dir segmentation_app_filename working_dir ...
       PAR_SIGMA PAR_K PAR_MIN_SIZE DATASET_NO ...
       FILE_HEADER FILE_SUFFIX SCALE_DOWN_RATIO;

args = strcat({' '},PAR_SIGMA,{' '},PAR_K,{' '},PAR_MIN_SIZE,{' '},...
              'Datasets/',num2str(DATASET_NO),...
              '/',FILE_HEADER,zeroPad(frame_id+1),...
              num2str(frame_id+1),...
              FILE_SUFFIX, {' '}, 'segment1', {' '}, num2str(SCALE_DOWN_RATIO));

system([exec_dir segmentation_app_filename args{1}]);

[N1, E1, S1] = readGraphFromFile([working_dir 'segment1_graph.txt']);

score = 0;
place_id = -1;
for i = 1:size(summary_graphs,2)
  
  N2 = [];
  for j = 1:size(summary_graphs,1)
    if(~isempty(summary_graphs{j,i}))
      dum = summary_graphs{j,i}(1,2:3);
      N2 = [N2;dum];
    end
  end

  E2 = {};
  S2 = createSignature(N2,E2);
  
  [P,C,match_ratio] = findOptimalMatch(N1,E1,N2,E2,S1,S2);
    
  if(match_ratio > score)
      score = match_ratio;
      place_id = i;
  end

end