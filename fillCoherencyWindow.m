function [coherency_window,continuity_map,coherency_scores, I_current] = fillCoherencyWindow(frame_id,N1,E1,S1,N2,E2,S2,P,C,...
  match_ratio,coherency_window,continuity_map,coherency_scores)
%add new frame attributions and matching results to window
%this window has fixed size queue structure.

global FIRST_FRAME BIG_NUMBER TAU_S coherency_window_lenght unique_nodes_count; 

if(frame_id == FIRST_FRAME)
    I_current = [1:size(N1,1)]';
    new_frame = {N1;E1;S1;0;0;0;0;I_current};
    coherency_window = new_frame;
    unique_nodes_count = size(N1,1);
end

I_current = P'*coherency_window{end,end};


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

    %mahmut: bunu yapinca listeyi tekrar guncelle
    if(smallest_dist < TAU_S) %save with matched node's id
        I_current(not_matched_nodes_indices(i)) = smallest_dist_id;
    else %save with new id
        unique_nodes_count = unique_nodes_count + 1;
        I_current(not_matched_nodes_indices(i)) = unique_nodes_count;
    end

end

continuity_map(I_current,frame_id-FIRST_FRAME+1) = 1;

coherency_score = 0;

for i = 1:size(continuity_map,1)
  %disappeared node
  if(size(continuity_map,2) > 1 && ...
     continuity_map(i,end) == 0 && continuity_map(i,end-1) == 1)
    visible_duration = size(find(continuity_map(i,:)),2)/size(continuity_map,2);
    coherency_score = coherency_score+visible_duration;
  end
end

coherency_scores(1,frame_id-FIRST_FRAME+1) = coherency_score;

if(size(coherency_window,2) < coherency_window_lenght)
    new_frame = {N2;E2;S2;P;C;match_ratio;coherency_score;I_current};
    coherency_window = [coherency_window new_frame];
else
    new_frame = {N2;E2;S2;P;C;match_ratio;coherency_score;I_current};
    coherency_window = [coherency_window(:,2:coherency_window_lenght) new_frame];
end

