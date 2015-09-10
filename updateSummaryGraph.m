function summary_graphs = updateSummaryGraph(places, coherency_window, summary_graphs)

global INDEX_I_CURRENT tau_m;

%if a new place detected refine previous summary graphs
if(size(places,2) > 1 && places(1,end) == 0 && places(1,end-1) ~=0)
  for i = 1:size(summary_graphs,1)
    if(isempty(summary_graphs{i,end}))
        continue;
    end
    avg_node = summary_graphs{i,end};
    for j = 1:size(summary_graphs,1)
      if(i == j || isempty(summary_graphs{j,end}))
        continue;
      end
      avg_node2 = summary_graphs{j,end};
            
      E = {};
      S1 = createSignature(avg_node(1,2:3),E);
      S2 = createSignature(avg_node2(1,2:3),E);
      
      dist = calcN2NDistance(S1,S2);
      
      if(dist < tau_m/2)
        avg_node{1,1} = (avg_node{1,1} + avg_node2{1,1});
        avg_node{1,2} = (avg_node{1,1} * avg_node{1,2} + avg_node2{1,1} * avg_node2{1,2}) / ...
                        (avg_node{1,1} + avg_node2{1,1});
        avg_node{1,3} = (avg_node{1,1} * avg_node{1,3} + avg_node2{1,1} * avg_node2{1,3}) / ...
                        (avg_node{1,1} + avg_node2{1,1});
        summary_graphs{i,end} = avg_node;
        summary_graphs{j,end} = [];
      end
    end
  end
end

%normal summary graph update function
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