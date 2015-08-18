function dist = calcN2NDistance(s1, s2)

global img_height img_width ...
       position_weight color_weight edge_weight area_weight ...
       missing_edge_weight use_edge_permutation;


%Note: all individual sums must be normalized to 1
dist = 0;

%difference between centers
max_dist = sqrt(img_width^2+img_height^2);  %for normalization purposes.  
                                            %must be diagonal distance 
                                            %of image = max distance
                                                
dist = dist + position_weight*(norm(s1{1,1}{1}'-s2{1,1}{1}')/max_dist)^2;

%difference between colors
color_dist = (abs(s1{1,1}{2}-s2{1,1}{2}) + ...
              abs(s1{1,1}{3}-s2{1,1}{3}) + ...
              abs(s1{1,1}{4}-s2{1,1}{4})   ) / 255 / 3;
         
dist = dist + color_weight*color_dist^2;


%difference between areas
area_dist = abs(s1{1,1}{5}-s2{1,1}{5}) / (img_width*img_height);
dist = dist + area_weight*area_dist^2;


%find edge differences
if(use_edge_permutation)
    % EDGE DIFF CALC. First method
    % FIND PERMUTATION MATRIX THAT OUTPUTS MINIMUM EDGE DIFFERENCE
    
    nr_edges1 = s1{1,2};
    nr_edges2 = s2{1,2};

    if(nr_edges1 >= nr_edges2)
        perm1 = perms(s1{1,3});
        perm1 = perm1(:,1:nr_edges2);
        diff = perm1 - ones(factorial(nr_edges1),1)*s2{1,3}';
        diff = edge_weight*diff / 255; %max edge value can be 255
        inrc = min(sum(diff.^2,2));
        inrc = inrc + (nr_edges1-nr_edges2)*missingEdgeWeight;
    else
        perm2 = perms(s2{1,3});
        perm2 = perm2(:,1:nr_edges1);
        diff = perm2 - ones(factorial(nr_edges2),1)*s1{1,3}';
        diff = edge_weight*diff / 255;
        inrc = min(sum(diff.^2,2));
        inrc = inrc + (nr_edges2-nr_edges1)*missing_edge_weight;
    end
    dist = dist + inrc;

else
    
    % EDGE DIFF CALC - 2nd Method
    % ORDER EDGE WEIGHTS AND FIND DIFFERENCE
    %
    %difference between edge weights
    e1 = sort(s1{1,3},'descend');
    e2 = sort(s2{1,3},'descend');
    maxSizeAttr = max(s1{1,2},s2{1,2});
    for i = 1 : maxSizeAttr
        if(s1{1,2} < i || s2{1,2} < i)
            dist = dist + missing_edge_weight;    %if one of the edges is missing.
        else
            diff = abs(e1(i) - e2(i)) / 255;
            dist = dist + edge_weight*diff^2;
        end
    end
end