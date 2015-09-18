global working_dir exec_dir segmentation_app_filename ...
       DATASET_NO FIRST_FRAME LAST_FRAME TEST_FOLDER ...
       PAR_SIGMA PAR_K PAR_MIN_SIZE ...
       BIG_NUMBER SCALE_DOWN_RATIO ...
       img_height img_width img_area ...
       position_weight color_weight edge_weight area_weight ...
       missing_edge_weight use_edge_permutation missing_node_penalty ...
       draw_cf_node_radius draw_cf_match_line_width_a draw_cf_match_line_width_b ...
       tau_m draw_matches draw_match_lines save_drawn_matches draw_indv_node_match_cost ...
       coherency_window_lenght ...
       unique_nodes_count ...
       tau_c tau_n COHERENCY_SCORE ...
       TAU_D TAU_F TAU_A TAU_P ...
       SIGMF_A SIGMF_C ...
       INDEX_MATCH_RATIO INDEX_DISSIM_SCORE INDEX_I_CURRENT FILE_HEADER FILE_SUFFIX...
       NODE_PERCENT_THRES DO_PERF_MEASUREMENT ...
       GT_PLACES_FILE;

PAR_SIGMA = '0.7';
PAR_K = '150';
PAR_MIN_SIZE = '1000';

exec_dir = '/home/isl-mahmut-ubuntu/Code/GraphSegmentation/Release/';
working_dir = '/media/isl-mahmut-ubuntu/YEDEK/REPO/SegmentsSummaryGraphs/';
segmentation_app_filename = '"GraphSegmentation"';
TEST_FOLDER = '';
GT_PLACES_FILE = '';

BIG_NUMBER = 9999;

%DATASET_NO = 1;
%FIRST_FRAME = 20;LAST_FRAME = 40; %1
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

% DATASET_NO = 2;
% FIRST_FRAME = 100;LAST_FRAME = 120; %2
% FILE_HEADER = 'CamVid-';
% FILE_SUFFIX = '.ppm';

% DATASET_NO = 3;
% FIRST_FRAME = 175;LAST_FRAME = 205; %3
% FILE_HEADER = 'CamVid-';
% FILE_SUFFIX = '.ppm';

%DATASET_NO = 4;
%FIRST_FRAME = 648;LAST_FRAME = 660; %4
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

% DATASET_NO = 5;
% FIRST_FRAME = 1;LAST_FRAME = 150; %5
% FILE_HEADER = 'CamVid-';
% FILE_SUFFIX = '.ppm';

%DATASET_NO = 6;
%FIRST_FRAME = 70;LAST_FRAME = 90; %6
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

%DATASET_NO = 7;
%FIRST_FRAME = 103;LAST_FRAME = 116; %7
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

%DATASET_NO = 8;
%FIRST_FRAME = 180;LAST_FRAME = 205; %8
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

%DATASET_NO = 9;
%FIRST_FRAME = 363;LAST_FRAME = 380; %9
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

%DATASET_NO = 10;
%FIRST_FRAME = 644;LAST_FRAME = 654; %10
%FILE_HEADER = 'CamVid-';
%FILE_SUFFIX = '.ppm';

% DATASET_NO = 12;
% FIRST_FRAME = 300;LAST_FRAME = 400; %12
% FILE_HEADER = 'NewCollege-';
% FILE_SUFFIX = '.jpg';

% DATASET_NO = 13;
% FIRST_FRAME = 200;LAST_FRAME = 500; %13
% FILE_HEADER = 'Cold-';
% FILE_SUFFIX = '.jpg';
% GT_PLACES_FILE = 'places.lst';

% DATASET_NO = 14;
% FIRST_FRAME = 1030;LAST_FRAME = 1060; %14
% FILE_HEADER = 'Cold-';
% FILE_SUFFIX = '.jpg';
% GT_PLACES_FILE = 'places.lst';

DATASET_NO = 16;
FIRST_FRAME = 400;LAST_FRAME = 430; %16
FILE_HEADER = 'Cold-';
FILE_SUFFIX = '.jpg';
TEST_FOLDER = 'TestImages';
GT_PLACES_FILE = 'places.lst';

% DATASET_NO = 17;
% FIRST_FRAME = 1;LAST_FRAME = 1632; %14
% FILE_HEADER = 'Cold-';
% FILE_SUFFIX = '.jpg';
%GT_PLACES_FILE = 'places.lst';

SCALE_DOWN_RATIO = 0.5;

position_weight = 0.8;
color_weight = 0.5;
edge_weight = 0;
area_weight = 0.7;
missing_edge_weight = 0;
use_edge_permutation = 0;

missing_node_penalty = 0;

draw_cf_node_radius = 2*500/300000;
draw_cf_match_line_width_a = 1.3;
draw_cf_match_line_width_b = 5;
tau_m = 0.02;  %cost_thres - node-to-node match threshold in order to be
               %regarded as good match

draw_matches = 0;
draw_match_lines = 0;
save_drawn_matches = 0;
draw_indv_node_match_cost = 0;

coherency_window_lenght = 7;

unique_nodes_count = 0;

tau_n = 6;
tau_c = 1.2;
COHERENCY_SCORE = 7;

TAU_D = 1;
TAU_A = 1;
TAU_P = 1;
TAU_F = 3;

SIGMF_A = 5;
SIGMF_C = 0.5;

INDEX_MATCH_RATIO = 6;
INDEX_DISSIM_SCORE = 7;
INDEX_I_CURRENT = 8;

NODE_PERCENT_THRES = 0.2;

DO_PERF_MEASUREMENT = 1;