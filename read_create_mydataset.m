function quant_class = read_create_mydataset(dir_base,myNetwork)
clc;clear;close all
%% K-fold
K = 5
my_group_test = 5 % group 1 ate K

%% Folders
dir_base      = fullfile('C:\Users\Estevam\Desktop\Pesquisa\data\');
%dir_dataset   = fullfile(dir_base,'dataset_pre1');
dir_dataset   = fullfile(dir_base,'dataset_original');

dir_mydataset = fullfile(dir_base,['mydataset_K_' num2str(K) '_' num2str(my_group_test)]);

dd = dir(dir_dataset);
dd = dd(3:end);
dd.name
%% Load  Images
for index = 1:numel(dd)
    imageFolder{index} = fullfile(dir_dataset,dd(index).name);
end

%% Folder save TRAIN
for index = 1:numel(dd)
    outFolderTrain{index} = fullfile(dir_mydataset,'train',dd(index).name);mkdir(outFolderTrain{index})
end

%% Folder save TEST
for index = 1:numel(dd)
    outFolderTest{index} = fullfile(dir_mydataset,'test',dd(index).name); mkdir(outFolderTest{index})
end

%% redimensionar (camada de entrada da CNN)
mysize = [299 299]; % alexnet (227); resnet (224); vgg16 (224); Inceptionv3 (299)

for index1 = 1:numel(dd)
    
    imageFolder_temp    = imageFolder{index1}
    outFolderTrain_temp = outFolderTrain{index1}
    outFolderTest_temp  = outFolderTest{index1}

    myfiles=dir([imageFolder_temp filesep '*.png']);
    % read and write images (random)
    rng(1); array_randomperm = randperm(length(myfiles));
   
    % K groups
    my_step = floor(length(myfiles)/K);
    files_sets = [1      :my_step:length(myfiles)-my_step;...
                  my_step:my_step:length(myfiles)         ];

    files_sets(end) = length(myfiles); % corrected error
    
    for counter=1:length(myfiles)
        
        index2 = array_randomperm(counter); % order random
        
        I = imread([imageFolder_temp filesep myfiles(index2).name]);      
        I2 = imresize(I,mysize);
        I2 = im2uint8(I2);
        if size(I2,3) ~= 3
            I3(:,:,1) = I2;I3(:,:,2) = I2;I3(:,:,3) = I2; % CAT
            I2 = I3;
            disp('error [M N *not 3*]')
        end       
        
        I2 = imresize(I2,mysize);
        
        %% group Test
        if  counter >= files_sets(1,my_group_test) && ...
            counter <= files_sets(2,my_group_test)   
            imwrite(I2,[outFolderTest_temp filesep myfiles(index2).name]);
        %% group Train
        else
            imwrite(I2,[outFolderTrain_temp filesep myfiles(index2).name]);
        end
        %imshow(I2); drawnow; pause(0.001)
    end
end