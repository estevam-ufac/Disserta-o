%function r = read_write_data
clc;clear;close all
%% importar  csv para TABLE
load('my_dataset_metadata_csv.mat')
% datasetmetadata
mytable = datasetmetadata;

%% Read images relacionado ao formato

for indexrow = 1:size(mytable,1)
    
    fprintf('\n==================\nTABLE Row %i\n==================\n',indexrow)
    data_label                  = char(mytable{indexrow,5});
    data_consolidations         = num2str(mytable{indexrow,30});
    
    othersp = data_consolidations;  % aqui para trocar
    
    
    fprintf('LABEL \t\t\t consolidations\t \n %s\t\t\t %s \n',data_label, data_consolidations)

    %% read image or video
    myfolder = lower(char(mytable{indexrow,2}));
     if ~isequal(myfolder(1:4),'data')
         myfolder = ['data/' myfolder];
         fprintf('corrected folder ==> %s \n', myfolder)
     end

    myfile       = dir([myfolder '/' char(mytable{indexrow,3}) '.*' ]);
    img_filename = [myfolder '/' myfile.name];
    if length(myfile)>=1
        fprintf('FILE ==> %s \t FORMAT ==> %s \n', img_filename, img_filename(end-2:end))
    else
        fprintf('FILE ==> %s \t ERROR:  FILE NOT FOUND \n',char(mytable{indexrow,3}))
        continue
    end
    
    %% formato JPG PNG
    if isequal(img_filename(end-2:end),'jpg') ||...
       isequal(img_filename(end-2:end),'png')
       I = imread(img_filename);
       myframe = rgb2gray(I);
      
       frame_n = 1;
       save_data(myframe, indexrow, frame_n, myfile.name, data_label, othersp)
       %imshow(myframe)
    %% formato GIF
    elseif isequal(img_filename(end-2:end),'gif')

        [I, map]= imread(img_filename,'frames','all'); 
        lengthframes = size(I,4);
        
        for frame_n = 1:lengthframes
            myframe = I(:,:,:,frame_n);
            myframe = rgb2gray(ind2rgb(myframe,map));
        
            save_data(myframe, indexrow, frame_n, myfile.name, data_label, othersp)
            %imshow(myframe)
        end

    %% formato  video MP4 MOV AVI
    elseif isequal(img_filename(end-2:end),'mp4') || ...
           isequal(img_filename(end-2:end),'mov') || ...
           isequal(img_filename(end-2:end),'mpeg') || ...
           isequal(img_filename(end-2:end),'avi')
       
        v = VideoReader(img_filename);
        lengthframes = v.NumFrames;
        % frame especifico
        for frame_n = 1:lengthframes
            myframe = read(v,frame_n);
            save_data(myframe, indexrow,frame_n,myfile.name, data_label, othersp)
            %imshow(myframe)
        end
        
    else
        fprintf('ERROR: unrecognized format %s \n',upper(img_filename(end-2:end)))
    end
end