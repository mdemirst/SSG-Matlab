function createSummaryGraphs()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROJECT-NAME: This program takes sequence of images, segments them and
%               detects places and creates segments summary graphs of
%               places.
%
% This project is licensed under the terms of the MIT license
% Copyright (c) 2015, Mahmut Demir
% All rights reserved.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILENAME:    createSummaryGraphs.m
% AUTHOR(S):   Mahmut Demir <mahmutdemir@gmail.com>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameters(); %load parameters

global img_height img_width img_dim img_area;

continuity_map = [];
coherency_window = cell(7,coherency_window_lenght);
coherency_scores = [];
places = [];
nodes_all_frames = cell(1,LAST_FRAME-FIRST_FRAME);
inter_matches_all_frames = cell(1,LAST_FRAME-FIRST_FRAME);
unique_nodes = [];
match_ratios = [];
summary_graphs = [];

args1 = strcat({' '},PAR_SIGMA,{' '},PAR_K,{' '},PAR_MIN_SIZE,{' '},...
               'Datasets/',num2str(DATASET_NO),...
               '/',FILE_HEADER,zeroPad(FIRST_FRAME),...
               num2str(FIRST_FRAME),...
               FILE_SUFFIX, {' '}, 'segment1', {' '}, SCALE_DOWN_RATIO);
system([exec_dir segmentation_app_filename args1{1}]);
sample_image = imread('segment1.jpg');
[img_height, img_width, img_dim] = size(sample_image);
img_area = img_height*img_width;


for frame_id = FIRST_FRAME:LAST_FRAME-1
    
    %arg#1: sigma - smoothing before segmentation
    %arg#2: k - value for threshold function 
    %arg#3: min_size - minimum component size
         
    % camvid - already segmented dataset
%     args1 = strcat(' 0.0 250 1000 Datasets/',num2str(DATASET_NO),...
%                    '/cam-',zeroPad(frame_id),...
%                    num2str(frame_id),...
%                    '.ppm segment1');
%     args2 = strcat(' 0.0 250 1000 Datasets/',num2str(DATASET_NO),...
%                    '/cam-',zeroPad(frame_id+1),...
%                    num2str(frame_id+1),...
%                    '.ppm segment2');

    % newcollege
      args2 = strcat({' '},PAR_SIGMA,{' '},PAR_K,{' '},PAR_MIN_SIZE,{' '},...
                     'Datasets/',num2str(DATASET_NO),...
                     '/',FILE_HEADER,zeroPad(frame_id+1),...
                     num2str(frame_id+1),...
                     FILE_SUFFIX, {' '}, 'segment2', {' '}, SCALE_DOWN_RATIO);
               
    %run segmentation algorithm implemented on cpp
    %cpp file produces segment1_graph.txt and segment2_graph.txt
    %on the local directory
    system([exec_dir segmentation_app_filename args2{1}]);
    
    %reads produced txt files and creates node signatures
    [N1, E1, S1] = readGraphFromFile([working_dir 'segment1_graph.txt']);
    [N2, E2, S2] = readGraphFromFile([working_dir 'segment2_graph.txt']);
    movefile('segment2_graph.txt','segment1_graph.txt');
    
    
    %calculates cost adjacency matrix and find permutation matrix P
    %that defines an optimal match between two graphs
    %P: Permutation matrix, C: Adjacency cost matrix
    [P,C,match_ratio] = findOptimalMatch(N1,E1,N2,E2,S1,S2);
    
    
    %fills - fixed size queue struct - coherency window 
    [coherency_window, ...
     continuity_map, ...
     coherency_scores, ...
     I_current, ...
     unique_nodes]     = fillCoherencyWindow(frame_id,N1,E1,S1,N2,E2,S2,P,C,...
                                             match_ratio,...
                                             coherency_window,...
                                             continuity_map,...
                                             coherency_scores,...
                                             unique_nodes);
    
    %draw two segmented region adjacency graph and node-to-node matches
    drawMatches(frame_id,coherency_window,N1,E1,N2,E2,P,C);
    movefile('segment2.jpg','segment1.jpg');
    
    places = detectPlace(coherency_scores,places);
    
    summary_graphs = updateSummaryGraph(places, coherency_window, summary_graphs);
    
    nodes_all_frames{frame_id-FIRST_FRAME+1} = N2;
    inter_matches_all_frames{frame_id-FIRST_FRAME+1} = I_current;
    match_ratios(1,frame_id-FIRST_FRAME+1) = match_ratio;
end

recognized_places = performanceMeasurement(summary_graphs);

plotResults(continuity_map, coherency_scores, places, nodes_all_frames, ...
            inter_matches_all_frames, match_ratios, summary_graphs, ...
            recognized_places);

save('coherency_window.mat','coherency_window');
