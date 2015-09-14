p1 = [0  1  0  1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   ;  
      1  30 75 105 115 120 140 155 175 180 183 185 195 205 230 235 260 275 285 310 315 320 340 375 385 400 ];
    
p2 = [0  1  0  1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   ;  
      1  20 28 32  65  68  90  115 135 145 155 165 185 195 200 205 250 265 290 310 345 350 355 375 385 400 ];
    
    
lin_fig = figure;
subplot(2,1,1);

for i = 1:size(p1,2)-1
  
  place_i1_start = p1(2,i);
  place_i1_end   = p1(2,i+1);
  
  if(p1(1,i) == 1)
    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;
  else
    %transitions
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'b');
    set(p,'FaceAlpha',0.5);
    hold on;
  end  
end

subplot(2,1,2);

for i = 1:size(p2,2)-1
  
  place_i1_start = p2(2,i);
  place_i1_end   = p2(2,i+1);
  
  if(p2(1,i) == 1)
    %places
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'r');
    set(p,'FaceAlpha',0.5);
    hold on;
  else
    %transitions
    p=patch([place_i1_start place_i1_end place_i1_end place_i1_start],[0 0 1 1],'b');
    set(p,'FaceAlpha',0.5);
    hold on;
  end  
end