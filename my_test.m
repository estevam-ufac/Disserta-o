function C = my_test(dir_base, myNetwork)
%%Testing Model:
%clc;close all;clear;

%dir_dataset  = fullfile('/home/roger/Documents/Cars Dataset/mydataset/test/')
my_group_test = 5;
dir_dataset  = fullfile(dir_base,'mydataset_K_5_5\test\');

dd = dir(dir_dataset);
dd = dd(3:end);        % apaga os primeiros dos elementos  .  e   ..
mycats     =[];
label_true =[];

%% pastas para ler
for index = 1:length(dd)
    FolderTest{index} = fullfile(dir_dataset, dd(index).name);
    mycats = [mycats, {dd(index).name}];
end


fileCNN  = ['my_net_K_5_5_vgg16.mat'];
load(fileCNN)
if strcmp(myNetwork,'alexnet')
    mysize = [227 227]; % alexnet 
elseif strcmp(myNetwork,'vgg16')
    mysize = [224 224];
else
    return
end
ind = 1;

for indexcat = 1:length(FolderTest)
    
    imgFolder = FolderTest{indexcat}
    imds      = imageDatastore(imgFolder); tic
   
    for index=1:numel(imds.Files)
         I   = readimage(imds,index);           
         I   = imresize(I,mysize);
         label_pred(ind) = classify(my_net,I);
         ind = ind +1;                          
    end
    
%    T{indexcat} = categorical(indexcat*ones(1,numel(imds.Files)),[1:length(FolderTest)],mycats);    
    T = categorical(indexcat*ones(1,numel(imds.Files)),[1:length(FolderTest)],mycats);    
    label_true = [label_true T];
    toc/length(imds.Files)
end

%figure; plotconfusion(label_true,label_pred)
%figure; confusionchart(label_true,label_pred)
f = figure; 
confusionchart(label_true,label_pred,'RowSummary','row-normalized','ColumnSummary','column-normalized');

load('confusionmatrix_vgg16.mat') % results prev
C{my_group_test} = confusionmat(label_true,label_pred);
save('confusionmatrix_vgg16.mat', 'C')

saveas(gcf,fileCNN(1:end-4))


