function extractBestKeyframes(places,coherency_scores, summary_graphs)

global FIRST_FRAME DATASET_NO FILE_HEADER FILE_SUFFIX;

coherency_scores = coherency_scores(1:size(places,2));

min_place_nr = min(places(places ~= 0 & places ~= -1));
max_place_nr = max(places);

count = 1;
for place_nr = min_place_nr:max_place_nr
  
  if(place_nr == min_place_nr)
    x = coherency_scores(places == place_nr);
    x(1:5) = x(1:5)+1;
    [minimum,index] = min(x);
  else
    [minimum,index] = min(coherency_scores(places == place_nr));
  end
  
  
  frame_id = FIRST_FRAME + index + find(places==place_nr,1,'first') - 2;
  
  disp(num2str(frame_id));
  
  source = strcat('Datasets/',num2str(DATASET_NO),...
                  '/',FILE_HEADER,zeroPad(frame_id),...
                  num2str(frame_id),...
                  FILE_SUFFIX);
                
  dest = strcat('Results/',num2str(DATASET_NO),...
                '/',FILE_HEADER,zeroPad(frame_id),...
                num2str(frame_id),...
                FILE_SUFFIX);
  
  copyfile(source,dest);
  
  index = index + find(places==place_nr,1,'first') - 1;
  plot(index, coherency_scores(index), '-ob', 'color','b','markersize',12,'LineWidth',2, 'markerfacecolor','w');
  text(index, coherency_scores(index),num2str(count),'FontSize',8,...
         'HorizontalAlignment','center');
  count = count + 1;
  
  hold on;
  
end

