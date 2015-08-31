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

continuity_map = [];
coherency_window = cell(7,coherency_window_lenght);
coherency_scores = [];
places = [];

for frame_id = FIRST_FRAME:LAST_FRAME-1
    
    %arg#1: sigma - smoothing before segmentation
    %arg#2: k - value for threshold function 
    %arg#3: min_size - minimum component size
         
    % camvid - already segmented dataset
    args1 = strcat(' 0.7 150 1000 Datasets/',num2str(DATASET_NO),...
                   '/cam-',zeroPad(frame_id),...
                   num2str(frame_id),...
                   '.ppm segment1');
    args2 = strcat(' 0.7 150 1000 Datasets/',num2str(DATASET_NO),...
                   '/cam-',zeroPad(frame_id+1),...
                   num2str(frame_id+1),...
                   '.ppm segment2');
               
    %run segmentation algorithm implemented on cpp
    %cpp file produces segment1_graph.txt and segment2_graph.txt
    %on the local directory
    system([exec_dir segmentation_app_filename args1]);
    system([exec_dir segmentation_app_filename args2]);
    
    %reads produced txt files and creates node signatures
    [N1, E1, S1] = readGraphFromFile([working_dir 'segment1_graph.txt']);
    [N2, E2, S2] = readGraphFromFile([working_dir 'segment2_graph.txt']);
    
    %calculates cost adjacency matrix and find permutation matrix P
    %that defines an optimal match between two graphs
    %P: Permutation matrix, C: Adjacency cost matrix
    [P,C,match_ratio] = findOptimalMatch(N1,E1,N2,E2,S1,S2);
    
    
    %fills - fixed size queue struct - coherency window 
    [coherency_window,continuity_map,coherency_scores] = fillCoherencyWindow(frame_id,N1,E1,S1,N2,E2,S2,P,C,match_ratio,coherency_window,continuity_map,coherency_scores);
    
    %draw two segmented region adjacency graph and node-to-node matches
    drawMatches(frame_id,coherency_window,N1,E1,N2,E2,P,C);
    
    places = detectPlace(coherency_window,places);
end

imagesc(continuity_map);
colormap([1 1 1; 0 0 0]);

%coherency_scores = coherency_scores/norm(coherency_scores,inf);
%coherency_scores = coherency_scores*size(continuity_map,1);
%match_ratios = cell2mat(coherency_window(6,:)); 
hold on;
plot(coherency_scores,'color','g','LineWidth',2);
hold on;
stairs(places(2:end),'color','r','LineWidth',2);
%plot(match_ratios,'color','r','LineWidth',2);
axis xy;

save('coherency_window.mat','coherency_window');
