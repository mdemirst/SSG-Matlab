function places = detectPlace(coherency_window, places)

global tau_c tau_n coherency_window_lenght COHERENCY_SCORE;

if(size(coherency_window,2) == coherency_window_lenght)
  %first place/transition detection
  if(isempty(places))
    %first frame is place #1 if coherency score is below threshold else it is 
    %transition region.
    places(1) = cell2mat(coherency_window(COHERENCY_SCORE,2)) < tau_c;
  else
    coherency_scores = cell2mat(coherency_window(COHERENCY_SCORE,:));
    coherency_scores_thres = coherency_scores < tau_c;
    
    cur_region_len = size(coherency_scores_thres,2);
    for i=1:size(coherency_scores_thres,2)-1
      if(xor(coherency_scores_thres(i),coherency_scores_thres(i+1)))
        cur_region_len = i;
        break;
      end
    end
    cur_region_type = cell2mat(coherency_window(COHERENCY_SCORE,1)) < tau_c;
    
    last_place_type = places(end) > 0;
    next_place_type = -1;
    if(last_place_type == 0 && cur_region_type == 0)
      %transition
      next_place_type = 0;
    elseif(last_place_type == 0 && cur_region_type == 1 && cur_region_len <= tau_n)
      %transition
      next_place_type = 0;
    elseif(last_place_type == 1 && cur_region_type == 1)
      %place - cont
      next_place_type = max(places);
    elseif(last_place_type == 1 && cur_region_type == 0 && cur_region_len <= tau_n)
      %place - cont
      next_place_type = max(places);
    elseif(last_place_type == 0 && cur_region_type == 1 && cur_region_len > tau_n)
      %place - new
      next_place_type = max(places)+1;
    elseif(last_place_type == 1 && cur_region_type == 0 && cur_region_len > tau_n)
      %transition
      next_place_type = 0;
    else
      next_place_type = -1;
    end
    places(end+1) = next_place_type;
      
    
  end
end