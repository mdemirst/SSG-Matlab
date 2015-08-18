function drawMatches(frame_id, coherency_window, N1, E1, N2, E2, P, C)

global draw_cf_node_radius draw_cf_match_line_width_a draw_cf_match_line_width_b ...
       tau_m draw_matches save_drawn_matches...
       draw_indv_node_match_cost;

if(draw_matches == 0)
    return;
end

match_figure = figure;


%read images
img = imread('segment1.jpg');
img2 = imread('segment2.jpg');

% check for sizes and take longest width and longest height into
% account
if (size(img,1) > size(img2,1))
    longest_height = size(img,1);       
else
    longest_height = size(img2,1);
end

if (size(img,2) > size(img2,2))
    longest_width = size(img,2);
else
    longest_width = size(img2,2);
end

% create new matrices with longest width and longest height
new_img = uint8(zeros(longest_height, longest_width, 3)); %3 cuz image is RGB
new_img2 = uint8(zeros(longest_height, longest_width, 3));

% transfer both images to the new matrices respectively.
new_img(1:size(img,1), 1:size(img,2), 1:3) = img;
new_img2(1:size(img2,1), 1:size(img2,2), 1:3) = img2;

% with the same proportion and dimension, we can now show both
% images. Parts that are not used in the matrices will be black.

imshow([new_img new_img2]);

%{N2;E2;S2;P;C;match_ratio;I_current};
%draw the matches
[y, x] = find(P);
cost = 0;

%draw all nodes and their unique ids (N1)
N = coherency_window{1,end-1};
for i = 1:size(N,1)
    node_radius = N{i,2}(4)*draw_cf_node_radius;
    colorR = N{i,2}(1)/255;
    colorG = N{i,2}(2)/255;
    colorB = N{i,2}(3)/255;

    rectangle('Position', [N{i,1}-[node_radius/2.0, node_radius/2.0],node_radius,node_radius],...
              'Curvature', [1,1],...
              'FaceColor', [colorR,colorG,colorB]);
    text('color',[1,1,1],'position',[N{i,1}(1) N{i,1}(2)],'fontsize',15,'string',num2str(coherency_window{7,end-1}(i)));
        
    hold on;
end

%draw all nodes and their unique ids (N2)
N = coherency_window{1,end};
for i = 1:size(N,1)
    node_radius = N{i,2}(4)*draw_cf_node_radius;
    colorR = N{i,2}(1)/255;
    colorG = N{i,2}(2)/255;
    colorB = N{i,2}(3)/255;

    rectangle('Position', [N{i,1}-[node_radius/2.0-longest_width, node_radius/2.0],node_radius,node_radius],...
              'Curvature', [1,1],...
              'FaceColor', [colorR,colorG,colorB]);
    text('color',[1,1,1],'position',[N{i,1}(1)+longest_width N{i,1}(2)],'fontsize',15,'string',num2str(coherency_window{7,end}(i)));
    
    hold on;
end

%draw matching lines
for i = 1 : size(y,1)
    
    cost = C(y(i),x(i));
    if(cost < tau_m)
        cost = cost + cost;  
        
        %lines between matching nodes are weighted inversely prop to
        %cost
        matching_line_width = (draw_cf_match_line_width_a.^(-1*cost))*draw_cf_match_line_width_b;

        line([N1{y(i),1}(1),N2{x(i),1}(1)+longest_width],...
             [N1{y(i),1}(2),N2{x(i),1}(2)],...
             'Color',[rand,rand,rand],...
             'LineWidth',matching_line_width);

        %draw match costs
        %text('position',[N1{y(i),1}(1) N1{y(i),1}(2)-30],'fontsize',10,'string',num2str(C(y(i),x(i))))
        %text('position',[N2{x(i),1}(1)+longest_width N2{x(i),1}(2)-30],'fontsize',10,'string',num2str(C(y(i),x(i))))
        hold on;
        
    end
end
  
if(draw_indv_node_match_cost)
    indv_matches_figure = figure;
    costs = zeros(1,size(y,1));
    for i = 1:size(y,1)
        costs(i) = C(y(i),x(i));
    end
    plot(sort(costs),'*');
    waitforbuttonpress;
    delete(indv_matches_figure);
end


if(save_drawn_matches)
    saveas(gcf,[num2str(frame_id),'-',num2str(frame_id+1),'.png']);
end
waitforbuttonpress;
delete(match_figure);

  

