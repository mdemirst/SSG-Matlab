function plotResultsFile()
clear;

% DATASET_NO_1 = 13;
% FIRST_FRAME_1 = 1220;
% LAST_FRAME_1 = 1580;

DATASET_NO_1 = 13;
FIRST_FRAME_1 = 280;
LAST_FRAME_1 = 1220;

% DATASET_NO_2 = 13;
% FIRST_FRAME_2 = 780;
% LAST_FRAME_2 = 1220;

% DATASET_NO_2 = 14;
% FIRST_FRAME_2 = 680;
% LAST_FRAME_2 = 1080;

DATASET_NO_2 = 14;
FIRST_FRAME_2 = 220;
LAST_FRAME_2 = 1100;

% DATASET_NO_2 = 17;
% FIRST_FRAME_2 = 350;
% LAST_FRAME_2 = 1350;

dum     = load(strcat('Results/places_',num2str(DATASET_NO_1),'_',...
               num2str(1),'_',num2str(1590),'.mat'));
places1 = dum.places(FIRST_FRAME_1:LAST_FRAME_1);
%places1 = dum.places(FIRST_FRAME_1:LAST_FRAME_1);

dum     = load(strcat('Results/places_',num2str(DATASET_NO_2),'_',...
               num2str(1),'_',num2str(1500),'.mat'));
places2 = dum.places(FIRST_FRAME_2:LAST_FRAME_2);
%places2 = dum.places(FIRST_FRAME_2:LAST_FRAME_2);

locs1 = readDatasetLocations(DATASET_NO_1);
locs2 = readDatasetLocations(DATASET_NO_2);

linear_locs1 = zeros(1,size(locs1,2));
for i = 2:size(locs1,2)
  linear_locs1(i) = linear_locs1(i-1) + norm(locs1(1:2,i-1)-locs1(1:2,i));
end

linear_locs2 = zeros(1,size(locs2,2));
for i = 2:size(locs2,2)
  linear_locs2(i) = linear_locs2(i-1) + norm(locs2(1:2,i-1)-locs2(1:2,i));
end

map_fig1 = figure;

% for i = 1:max(locs1(3,:))
%   base_points = locs1(:,locs1(3,:) == i);
%   plot(base_points(1,:),base_points(2,:),'LineWidth',20,'Color',[0,i/max(locs1(3,:)),0]);
%   hold on;
% end

%plot places
cplot(locs1(1,FIRST_FRAME_1:FIRST_FRAME_1+size(places1,2)-1),...
      locs1(2,FIRST_FRAME_1:FIRST_FRAME_1+size(places1,2)-1),...
      places1 > 0, 'LineWidth',5,...
      'markerfacecolor','flat',...
   'markeredgecolor','w');
colormap([0 0 1; 1 0 0 ]);

for i = FIRST_FRAME_1:30:LAST_FRAME_1
  %text('string',num2str(round(linear_locs1(i))),'position',locs1(:,i));
  text('string',num2str(i),'position',locs1(:,i));
end
axis equal;

map_fig2 = figure;

% for i = 1:max(locs2(3,:))
%   base_points = locs2(:,locs2(3,:) == i);
%   plot(base_points(1,:),base_points(2,:),'LineWidth',20,'Color',[0,i/max(locs2(3,:)),0]);
%   hold on;
% end

%plot places
cplot(locs2(1,FIRST_FRAME_2:FIRST_FRAME_2+size(places2,2)-1),...
      locs2(2,FIRST_FRAME_2:FIRST_FRAME_2+size(places2,2)-1),...
      places2 > 0, 'LineWidth',5,...
      'markerfacecolor','flat',...
      'markeredgecolor','w');
colormap([0 0 1; 1 0 0 ]);

for i = FIRST_FRAME_2:30:LAST_FRAME_2
  %text('string',num2str(round(linear_locs1(i))),'position',locs2(:,i));
  text('string',num2str(i),'position',locs2(:,i));
end
axis equal;

lin_fig = figure;
subplot(2,1,1);

for i = min(places1(places1>0)):max(places1)
  place_i1_start = linear_locs1(FIRST_FRAME_1 - 1 + find(places1 == i,1,'first'));
  place_i1_end   = linear_locs1(FIRST_FRAME_1 - 1 + find(places1 == i,1,'last'));
  
  if(i < max(places1))
    place_i2_start = linear_locs1(FIRST_FRAME_1 - 1 + find(places1 == i+1,1,'first'));
    place_i2_end   = linear_locs1(FIRST_FRAME_1 - 1 + find(places1 == i+1,1,'last'));

    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;

    %transitions
    p=patch([place_i1_end place_i2_start place_i2_start place_i1_end],[0 0 1 1],'b');
    set(p,'FaceAlpha',0.5);
    hold on;
  else
    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;
  end
  
end
%xlim([50 70]);

subplot(2,1,2);

for i = min(places2(places2>0)):max(places2)
  place_i1_start = linear_locs2(FIRST_FRAME_2 - 1 + find(places2 == i,1,'first'));
  place_i1_end   = linear_locs2(FIRST_FRAME_2 - 1 + find(places2 == i,1,'last'));
  
  if(i < max(places2))
    place_i2_start = linear_locs2(FIRST_FRAME_2 - 1 + find(places2 == i+1,1,'first'));
    place_i2_end   = linear_locs2(FIRST_FRAME_2 - 1 + find(places2 == i+1,1,'last'));

    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;

    %transitions
    p=patch([place_i1_end place_i2_start place_i2_start place_i1_end],[0 0 1 1],'b');
    set(p,'FaceAlpha',0.5);
    hold on;
  else
    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;
  end
  
end

%xlim([50 70]);
% figure;
% x1 = linspace(min(linear_locs1(FIRST_FRAME_1:LAST_FRAME_1)),max(linear_locs1(FIRST_FRAME_1:LAST_FRAME_1)),100);
% x2 = linspace(min(linear_locs2(FIRST_FRAME_2:LAST_FRAME_2)),max(linear_locs2(FIRST_FRAME_2:LAST_FRAME_2)),100);
% y1 = interp1(linear_locs1(FIRST_FRAME_1:LAST_FRAME_1),places1(1:LAST_FRAME_1-FIRST_FRAME_1+1),x1,'linear');
% y2 = interp1(linear_locs2(FIRST_FRAME_2:LAST_FRAME_2),places2(1:LAST_FRAME_2-FIRST_FRAME_2+1),x2,'linear');
% 
% x1 = x1 - min(x1);
% x2 = x2 - min(x2);
% y1 = y1 > 0;
% y2 = y2 > 0;
% plot(x1,y1,'*');
% hold on;
% plot(x2,y2,'*');
% overlap = (y1 == y2);
% disp(['Overlap ratio is: ', num2str(size(find(overlap),2) / size(overlap,2))]);


end