clear; close all; clc
%% CNN
%myNetwork   = 'alexnet';
myNetwork   = 'vgg16';
%myNetwork = 'inceptionv3';
%myNetwork = 'resnet50';

%my_group_test = 5; % group 1 ate K
%% Ler o dataset original e criar um 'mydataset' temporario
for index=1:5
    dir_base    = fullfile('C:\Users\Estevam\Desktop\Pesquisa\data');
    quant_class = 7;
    %% treinar o CNN utilizando 'mydataset -->train'
    my_training(index, dir_base, myNetwork, quant_class);
end
%% teste da CNN utilizando 'mydataset -->test'
dir_base  = fullfile('C:\Users\Estevam\Desktop\Pesquisa\data');
C = my_test(dir_base, myNetwork);