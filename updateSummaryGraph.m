function summary_graphs = updateSummaryGraph(places, coherency_window, summary_graphs)

global INDEX_I_CURRENT;

if(size(places,2) > 0 && places(end) > 0)
  place_id = max(places);
  
  I_current = coherency_window{INDEX_I_CURRENT,1};
  node = coherency_window{1,1};
  
  %allocate space for summary graph matrix
  if(isempty(summary_graphs))
    summary_graphs{max(I_current),1} = [];
  elseif(size(summary_graphs,2) < place_id)
    summary_graphs{max(I_current),place_id} = [];
  elseif(size(summary_graphs,1) < max(I_current))
    summary_graphs{max(I_current),place_id} = [];
  end
  
  for i = 1:size(I_current)
    if(isempty(summary_graphs{I_current(i),place_id}))
      avg_node{1,1} = 1;
      avg_node{1,2} = node{i,1};
      avg_node{1,3} = node{i,2};
      summary_graphs{I_current(i),place_id} = avg_node;
    else
      avg_node = summary_graphs{I_current(i),place_id};
      length = avg_node{1,1};
      avg_node{1,1} = length + 1;
      avg_node{1,2} = (length * avg_node{1,2} + node{i,1}) / (length + 1);
      avg_node{1,3} = (length * avg_node{1,3} + node{i,2}) / (length + 1);
      summary_graphs{I_current(i),place_id} = avg_node;
    end
  end
    
end