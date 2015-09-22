function createSSGDescriptors(places, inter_matches_all_frames)

global FIRST_FRAME;
delete('merge.txt');
fileId = fopen('merge.txt','w');

for place_id = 1:max(places)
  selected_place_ids = find(places == place_id);
  
  I_place = [];
  count = 1;
  for i = selected_place_ids
    I_frame = inter_matches_all_frames{i};
    for j = 1:size(I_frame)
      I_place(j,count) = I_frame(j);
    end
    count = count + 1;
  end
  
  max_node_id = max(max(I_place));
  
  node_existence = [];
  for i = 1:max_node_id
    for j = 1:size(I_place,2)
      if(sum(ismember(I_place(:,j),i)))
        node_existence(i,j) = find(I_place(:,j)==i, 1, 'last' );
      else
        node_existence(i,j) = -1;
      end
    end
    if(size(find(node_existence(i,:)==-1),2) > size(I_place,2)*0.5)
      node_existence(i,:) = -1;
    end
  end
  node_existence(all(node_existence==-1,2),:) = [];
  
  dlmwrite('merge.txt',[FIRST_FRAME+min(selected_place_ids)-1,...
                        FIRST_FRAME+max(selected_place_ids)-1,...
                        size(node_existence,1)],...
                        'delimiter',':','-append');
  dlmwrite('merge.txt',node_existence,'delimiter',':','-append');
end

fclose(fileId);

end