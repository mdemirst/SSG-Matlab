function plotResults(continuity_map, coherency_scores, places, ...
  nodes_all_frames, inter_matches_all_frames, match_ratios, summary_graphs, ...
  recognized_places)

global FIRST_FRAME LAST_FRAME DATASET_NO draw_cf_node_radius FILE_HEADER FILE_SUFFIX ...
  NODE_PERCENT_THRES DO_PERF_MEASUREMENT SCALE_DOWN_RATIO;

fig = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(4,1,1);

%mahmut: experimental
% h = size(continuity_map,1);
% 
% for i=1:h
%   ind = findLongSeq(continuity_map(i,:));
%   continuity_map(i,:) = 0;
%   continuity_map(i,ind) = 1;
% end

%mahmut: experimental ends

%draw black-white continuity map
imagesc(continuity_map);
colormap([1 1 1; 0 0 0]);
axis xy;
hold on;

dcm_obj = datacursormode(fig);
datacursormode on;

subplot(4,1,2);

plot_height = size(continuity_map,1);


%plot coherency scores
% coherency_scores_normalized = normalize_var(coherency_scores,0,plot_height);
% plot(coherency_scores,'color','g','LineWidth',2);
% hold on;

%plot performance results
if(DO_PERF_MEASUREMENT && ~isempty(recognized_places))
  stairs(recognized_places(1,:), 'color','b','LineWidth',5);
  hold on;
end

%plot detected places
stairs(places(2:end),'color','r','LineWidth',2);
xlim([0,LAST_FRAME-FIRST_FRAME]);
hold on;

%plot consecutive frames match ratios
match_ratios = normalize_var(match_ratios,0,plot_height);
%plot(match_ratios,'color','b','LineWidth',2);

correctly_recognized = size(find(recognized_places(1,1:size(places,2)) == places(1,:) & places(1,:) ~= 0),2);
correctly_recognized = correctly_recognized / size( find(places(1,:) ~= 0),2);
disp(['Recognition rate is: ', num2str(correctly_recognized)]); 

while(1)
    %pause
    waitforbuttonpress
    c_info = getCursorInfo(dcm_obj);
    
    selected_frame_id = floor(c_info.Position(1));
    selected_unique_node_id = floor(c_info.Position(2));
    
    [X1,map1]=imread(strcat('Datasets/',num2str(DATASET_NO),...
                            '/',FILE_HEADER,zeroPad(FIRST_FRAME+selected_frame_id),...
                            num2str(FIRST_FRAME+selected_frame_id),...
                            FILE_SUFFIX));
    
    subplot(4,1,3);

    imshow(X1,map1);
    set(gca,'Ydir','reverse');
    hold on;
                  
    if(continuity_map(selected_unique_node_id,selected_frame_id) == 1)
      inter_matches = inter_matches_all_frames{selected_frame_id};
      node_id = find(inter_matches == selected_unique_node_id);
      selected_node = nodes_all_frames{selected_frame_id}(node_id,:);


      nodeRadius = selected_node{1,2}(4)*draw_cf_node_radius*6;
      colorR = selected_node{1,2}(1)/255;
      colorG = selected_node{1,2}(2)/255;
      colorB = selected_node{1,2}(3)/255;
        
      
      rectangle('Position', [selected_node{1,1}/SCALE_DOWN_RATIO-[nodeRadius/2.0, nodeRadius/2.0],nodeRadius,nodeRadius],...
                'Curvature', [1,1],...
                'FaceColor', [1,0,0]);
      hold on;
    end
    
    %plot corresponding summary graph
    h3 = subplot(4,1,4);
    axis equal;
    set(gcf,'Visible','off');
    set(gca,'Ydir','reverse');
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    set(gca,'XColor',[1,1,1]);
    set(gca,'YColor',[1,1,1]);
        
    if(size(places,2) < selected_frame_id || places(selected_frame_id) <= 0)
      cla(h3);
    else
      cla(h3);
      place_id = places(selected_frame_id); 
      place_length = size(find(places == place_id),2);
      if(place_id > 0)
        for i = 1:size(summary_graphs,1)
          avg_node = summary_graphs{i,place_id};

          if(~isempty(avg_node) && avg_node{1,1} > NODE_PERCENT_THRES*place_length)
            node_radius = avg_node{1,3}(4)*draw_cf_node_radius;
            colorR = avg_node{1,3}(3)/255;
            colorG = avg_node{1,3}(2)/255;
            colorB = avg_node{1,3}(1)/255;

            rectangle('Position', [avg_node{1,2}-[node_radius/2.0, node_radius/2.0],node_radius,node_radius],...
                      'Curvature', [1,1],...
                      'FaceColor', [colorR,colorG,colorB]);
            hold on;
          end
        end
      end
    end

end

end

