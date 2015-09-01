function plotResults(continuity_map, coherency_scores, places, nodes_all_frames, inter_matches_all_frames)

global FIRST_FRAME DATASET_NO draw_cf_node_radius

fig = figure;
subplot(2,1,1);

imagesc(continuity_map);
colormap([1 1 1; 0 0 0]);

%coherency_scores = coherency_scores/norm(coherency_scores,inf);
%coherency_scores = coherency_scores*size(continuity_map,1);
%match_ratios = cell2mat(coherency_window(6,:)); 
hold on;
plot(coherency_scores,'color','g','LineWidth',2);
hold on;
stairs(places(2:end),'color','r','LineWidth',2);
%plot(match_ratios,'color','r','LineWidth',2);
axis xy;

dcm_obj = datacursormode(fig);
datacursormode on;


while(1)
    %pause
    waitforbuttonpress
    c_info = getCursorInfo(dcm_obj);
    
    selected_frame_id = c_info.Position(1);
    selected_unique_node_id = c_info.Position(2);
    
    [X1,map1]=imread(strcat('Datasets/',num2str(DATASET_NO),...
                            '/cam-',zeroPad(FIRST_FRAME+selected_frame_id),...
                            num2str(FIRST_FRAME+selected_frame_id),...
                            '.ppm'));
                          
    subplot(2,1,2);

    imshow(X1,map1);
                  
    if(continuity_map(selected_unique_node_id,selected_frame_id) == 1)
      inter_matches = inter_matches_all_frames{selected_frame_id};
      node_id = find(inter_matches == selected_unique_node_id);
      selected_node = nodes_all_frames{selected_frame_id}(node_id,:);


      nodeRadius = selected_node{1,2}(4)*draw_cf_node_radius;
      colorR = selected_node{1,2}(1)/255;
      colorG = selected_node{1,2}(2)/255;
      colorB = selected_node{1,2}(3)/255;
        
      hold on;
      rectangle('Position', [selected_node{1,1}-[nodeRadius/2.0, nodeRadius/2.0],nodeRadius,nodeRadius],...
                'Curvature', [1,1],...
                'FaceColor', [0,1,0]);
    end
    

end

end

