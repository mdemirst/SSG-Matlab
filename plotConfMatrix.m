function plotConfMatrix(mat)
figure;
imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding


idx = find(strcmp(textStrings(:), '0.00'));
textStrings(idx) = {'   '};

[x,y] = meshgrid(1:size(mat,2));   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

tickLabels = cell(1,size(mat,2));
for i = 1:size(mat,2)
  tickLabels{i} = num2str(i);
end
set(gca,'XTick',1:size(mat,2),...                         %# Change the axes tick marks
        'XTickLabel',tickLabels,...  %#   and tick labels
        'YTick',1:size(mat,2),...
        'YTickLabel',tickLabels,...
        'TickLength',[0 0]);
title('Confusion Matrix');