function recognized_places = performanceMeasurement(summary_graphs, places);

global FIRST_FRAME LAST_FRAME;

recognized_places = zeros(1,LAST_FRAME-FIRST_FRAME+1);

for i = FIRST_FRAME:LAST_FRAME
  disp(['Recognizing ', num2str(i-FIRST_FRAME+1), '. frame']);
  recognized_places(1,i-FIRST_FRAME+1) = recognizePlace(i,summary_graphs, places);
end