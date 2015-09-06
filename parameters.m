global working_dir exec_dir segmentation_app_filename ...
       DATASET_NO FIRST_FRAME LAST_FRAME ...
       BIG_NUMBER ...
       img_height img_width img_area ...
       position_weight color_weight edge_weight area_weight ...
       missing_edge_weight use_edge_permutation missing_node_penalty ...
       draw_cf_node_radius draw_cf_match_line_width_a draw_cf_match_line_width_b ...
       tau_m draw_matches draw_match_lines save_drawn_matches draw_indv_node_match_cost ...
       coherency_window_lenght ...
       unique_nodes_count ...
       tau_c tau_n COHERENCY_SCORE ...
       TAU_D TAU_F TAU_A TAU_P test_data;

exec_dir = '/home/isl-mahmut-ubuntu/Code/GraphSegmentation/Release/';
working_dir = '/media/isl-mahmut-ubuntu/YEDEK/REPO/SegmentsSummaryGraphs/';
segmentation_app_filename = '"GraphSegmentation"';

BIG_NUMBER = 9999;

DATASET_NO = 5;
%FIRST_FRAME = 20;LAST_FRAME = 40; %1
%FIRST_FRAME = 85;LAST_FRAME = 124; %2
%FIRST_FRAME = 175;LAST_FRAME = 205; %3
%FIRST_FRAME = 648;LAST_FRAME = 660; %4
FIRST_FRAME = 1;LAST_FRAME = 200; %5
%FIRST_FRAME = 70;LAST_FRAME = 90; %6
%FIRST_FRAME = 103;LAST_FRAME = 116; %7
%FIRST_FRAME = 180;LAST_FRAME = 205; %8
%FIRST_FRAME = 363;LAST_FRAME = 380; %9
%FIRST_FRAME = 644;LAST_FRAME = 654; %10

img_height = 240;
img_width = 320;
img_area = img_height*img_width;

position_weight = 0.5;%100;
color_weight = 0.8;%500;
edge_weight = 0;%10;
area_weight = 0.5;%10;
missing_edge_weight = 0;%1;
use_edge_permutation = 0;

missing_node_penalty = 0;

draw_cf_node_radius = 2*500/300000;
draw_cf_match_line_width_a = 1.3;
draw_cf_match_line_width_b = 5;
tau_m = 0.015; %cost_thres - node-to-node match threshold in order to be
               %regarded as good match

draw_matches = 0;
draw_match_lines = 0;
save_drawn_matches = 0;
draw_indv_node_match_cost = 0;

coherency_window_lenght = 3;

unique_nodes_count = 0;

tau_n = 2;
tau_c = 10;
COHERENCY_SCORE = 7;

TAU_D = 1;
TAU_A = 1;
TAU_P = 1;
TAU_F = 3;