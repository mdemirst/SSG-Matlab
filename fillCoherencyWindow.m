function [coherency_window,continuity_map,coherency_scores, I_current, unique_nodes] = fillCoherencyWindow(frame_id,N1,E1,S1,N2,E2,S2,P,C,...
  match_ratio,coherency_window,continuity_map,coherency_scores, unique_nodes)
%add new frame attributions and matching results to window
%this window has fixed size queue structure.

global FIRST_FRAME BIG_NUMBER coherency_window_lenght ...
       unique_nodes_count tau_m img_area ...
       TAU_D TAU_F TAU_A TAU_P test_data ...
       SIGMF_A SIGMF_C ...
       INDEX_MATCH_RATIO INDEX_DISSIM_SCORE INDEX_I_CURRENT; 
     


if(frame_id == FIRST_FRAME)
    I_current = [1:size(N1,1)]';
    new_frame = {N1;E1;S1;0;0;0;0;I_current};
    coherency_window = new_frame;
    unique_nodes_count = size(N1,1);
end

C_thres = C < tau_m; %only matches with low node-to-node match cost
P_thres = P & C_thres; 
I_current = P_thres'*coherency_window{end,end};


% check if not matched nodes have corresponding matches in any of 
% previous frames in coherency window 
% (we already know it does not have any match with the last but one)
% if coherency window is zero size, then I_current will not have any zero
% if coherency window has one element, then not matched elements of 
% I_current will be given increasing ids
% if coherency windows has more than one element than normal procedure
% applies
matched_nodes_ids = I_current(I_current > 0);
not_matched_nodes_indices = find(I_current == 0);

%find if there is a match for each not matched nodes
for i = 1:size(not_matched_nodes_indices,1)
    smallest_dist = BIG_NUMBER;
    smallest_dist_id = -1;
    % check for all previous frames except the last
    for j = 1:size(coherency_window,2)-1
        % find nodes in jth window frame whose ids
        % is not of the matched node ids of the last frame
        % that step is required because we don't want to match with nodes
        % that have already matched.
        candidate_nodes = find(ismember(coherency_window{end,j}, matched_nodes_ids) == 0);

        for k = 1:size(candidate_nodes,1)
            s1 = S2(not_matched_nodes_indices(i),:); %signature of not matched node
            s2 = coherency_window{3,j}(candidate_nodes(k),:);
            dist = calcN2NDistance(s1,s2);

            if(dist < smallest_dist)
                smallest_dist = dist;
                smallest_dist_id = coherency_window{end,j}(candidate_nodes(k));
            end
        end
    end

    if(smallest_dist < tau_m) %save with matched node's id
        I_current(not_matched_nodes_indices(i)) = smallest_dist_id;
        matched_nodes_ids(matched_nodes_ids==smallest_dist_id) = [];
    else %save with new id
        unique_nodes_count = unique_nodes_count + 1;
        I_current(not_matched_nodes_indices(i)) = unique_nodes_count;
    end

end
%              1       2           3              4             5         6
%unique_nodes: n | mean_area | mean_pos_x | pos_var_M2_x | pos_var_x | 
%              
%                  6              7            8          9
%              mean_pos_y | pos_var_M2_y | pos_var_y | pos_var
%resize to maximum unique node id
if(size(unique_nodes,1) < max(I_current))
  unique_nodes(max(I_current),9) = 0;
end

for i = 1:size(I_current,1)
  unique_nodes(I_current(i),2) = (unique_nodes(I_current(i),1).*unique_nodes(I_current(i),2) + ...
                                 N2{i,2}(4))/(unique_nodes(I_current(i),1)+1);
    
  [unique_nodes(I_current(i),3), ...
   unique_nodes(I_current(i),4), ...
   unique_nodes(I_current(i),5) ] = onlineVariance( N2{i,1}(1), ...
                                                    unique_nodes(I_current(i),1), ...
                                                    unique_nodes(I_current(i),3), ...
                                                    unique_nodes(I_current(i),4) );
                                                  
  [unique_nodes(I_current(i),6), ...
   unique_nodes(I_current(i),7), ...
   unique_nodes(I_current(i),8) ] = onlineVariance( N2{i,1}(2), ...
                                                    unique_nodes(I_current(i),1), ...
                                                    unique_nodes(I_current(i),6), ...
                                                    unique_nodes(I_current(i),7) );
                                                  
  unique_nodes(I_current(i),9) = norm([unique_nodes(I_current(i),5),unique_nodes(I_current(i),8)]);
                                                  
  unique_nodes(I_current(i),1) = unique_nodes(I_current(i),1) + 1; 
end

variances = unique_nodes(:,9);
variances = variances / norm(variances,inf);
variances(find(variances==0)) = 1;
variances = 1 - variances;
%unique_nodes(:,9) = variances;

continuity_map(I_current,frame_id-FIRST_FRAME+1) = 1;

dissimilarity_score = 0;
window_coherency_score = 0;

if(size(coherency_window,2) >= coherency_window_lenght) 
  for i = 1:size(continuity_map,1)
    half_win_len = floor(coherency_window_lenght/2);
    cursor = size(continuity_map,2)-half_win_len;
       
    %disappeared node
    if(continuity_map(i,cursor) == 0 && continuity_map(i,cursor-1) == 1)

      [s,e,dur] = findOnesIndices(continuity_map(i,1:cursor));
      visible_duration = dur(end);
      mean_segment_area = unique_nodes(i,2) / img_area;
      positional_variance = variances(i);
      if(visible_duration >= TAU_F)
        dissimilarity_score = dissimilarity_score + ...
                              TAU_D * visible_duration * ...
                                      mean_segment_area ;
      end
      %test_data = [test_data;visible_duration weight_cost(mean_segment_area) positional_variance];
    end
    
    %appeared node
    if(continuity_map(i,cursor) == 1 && continuity_map(i,cursor-1) == 0)
      [s,e,dur] = findOnesIndices(continuity_map(i,cursor:end));
      visible_duration = dur(end);
      mean_segment_area = unique_nodes(i,2) / img_area;
      positional_variance = variances(i);
      
      dissimilarity_score = dissimilarity_score + ...
                            TAU_D * visible_duration * ...
                                    mean_segment_area ;
    end
  end
  
  active_nodes = any(continuity_map(:,cursor-half_win_len:cursor+half_win_len),2);
  
  window_coherency_score = sum(sum(continuity_map(active_nodes,cursor-half_win_len:cursor+half_win_len)))/...
    numel(continuity_map(active_nodes,cursor-half_win_len:cursor+half_win_len));
  
  new_frame = {N2;E2;S2;P;C;match_ratio;dissimilarity_score;I_current};
  coherency_window = [coherency_window(:,2:coherency_window_lenght) new_frame];

  coherency_scores(1,cursor) = sum(cell2mat(coherency_window(INDEX_DISSIM_SCORE,:)))*...
                               (1-sigmf(window_coherency_score,[SIGMF_A,SIGMF_C]));
else
  new_frame = {N2;E2;S2;P;C;match_ratio;dissimilarity_score;I_current};
  coherency_window = [coherency_window new_frame];
end


