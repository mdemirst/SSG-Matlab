global working_dir exec_dir segmentation_app_filename ...
       DATASET_NO FIRST_FRAME LAST_FRAME ...
       BIG_NUMBER ...
       img_height img_width ...
       position_weight color_weight edge_weight area_weight ...
       missing_edge_weight use_edge_permutation missing_node_penalty ...
       draw_cf_node_radius draw_cf_match_line_width_a draw_cf_match_line_width_b ...
       tau_m draw_matches save_drawn_matches draw_indv_node_match_cost ...
       coherency_window_lenght ...
       TAU_S unique_nodes_count ...
       tau_c tau_n COHERENCY_SCORE ...
       LONGEST_WIDTH;

exec_dir = '/home/isl-mahmut-ubuntu/Code/GraphSegmentation/Release/';
working_dir = '/media/isl-mahmut-ubuntu/YEDEK/REPO/SegmentsSummaryGraphs/';
segmentation_app_filename = '"GraphSegmentation"';

BIG_NUMBER = 9999;

DATASET_NO = 1;
FIRST_FRAME = 20;LAST_FRAME = 25;
% FIRST_FRAME = 85;LAST_FRAME = 124;
% FIRST_FRAME = 175;LAST_FRAME = 205;
% FIRST_FRAME = 648;LAST_FRAME = 660;

img_height = 240;
img_width = 320;

position_weight = 0.1;%100;
color_weight = 0.5;%500;
edge_weight = 0;%10;
area_weight = 0.5;%10;
missing_edge_weight = 0;%1;
use_edge_permutation = 0;

missing_node_penalty = 0;

draw_cf_node_radius = 2*500/300000;
draw_cf_match_line_width_a = 1.3;
draw_cf_match_line_width_b = 5;
tau_m = 0.9; %cost_thres

draw_matches = 0;
save_drawn_matches = 0;
draw_indv_node_match_cost = 0;

coherency_window_lenght = 5;

TAU_S = 0.1;

unique_nodes_count = 0;

tau_n = 1;
tau_c = 0.5;
COHERENCY_SCORE = 7;