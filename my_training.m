function r = my_training(index,dir_base, myNetwork,number_class)
tic
%% Training model:
if strcmp(myNetwork,'alexnet')
%deepNetworkDesigner(alexnet)
    my_net     = alexnet;              % deepNetworkDesigner
    layers     = alexnet('Weights','none');       % Layers
    layers(23) = fullyConnectedLayer(number_class);
    layers(25) = classificationLayer;
    param_MiniBatchSize = 32;
    outputSize = [227 227 3];
elseif strcmp(myNetwork,'inceptionv3')
     net = inceptionv3;         % deepNetworkDesigner    
     lgraph = inceptionv3('Weights','none');
    %lgraph = layerGraph(net);

% Remove the the last 3 layers
    layersToRemove = {
            'predictions',
            'ClassificationLayer_predictions',
            'predictions_softmax'   
    };
lgraph = removeLayers(lgraph, layersToRemove);

    % Specify the number of classes the network should classify.
    numClasses = number_class;
    % numClassesPlusBackground = numClasses + 1;

    % Define new classification layers.

    newLayers = [
    fullyConnectedLayer(number_class, 'Name', 'inceptionv3_fc')
    softmaxLayer('Name', 'inceptionv3_softmax')
    classificationLayer('Name', 'inceptionv3_classification')
    ];

    % Add new layers.
    lgraph = addLayers(lgraph, newLayers);

    % Connect the new layers to the network. 
    lgraph = connectLayers(lgraph,'avg_pool','inceptionv3_fc');

    layers =lgraph;

    lgraph = layerGraph(layers.Layers);

    outputSize = [299 299 3];

param_MiniBatchSize = 32;

else
    r = 0; return;
end

% K-fold

K = 5;
my_group_test = index; % group 1 ate K

dir_mydataset  = fullfile(dir_base,['mydataset_K_5_' num2str(index)],'train');


imds   = imageDatastore(dir_mydataset,'IncludeSubfolders',true, 'LabelSource','foldernames');


                                            % Data Augmentation
% Data augmentation is used during training to provide more examples to the network because it helps improve the accuracy
% of the network. Here, random left/right reflection and random X/Y translation of +/- 10 pixels is used for data augmentation. 
% Use the imageDataAugmenter (Deep Learning Toolbox) to specify these data augmentation parameters.
pixelRange = [-10 10]; 
imageAugmenter = imageDataAugmenter('RandXReflection' ,true       , ...
                                    'RandRotation'    ,[-45,45], ...
                                    'RandXTranslation',pixelRange, ...
                                    'RandYTranslation',pixelRange);

auimds = augmentedImageDatastore(outputSize,imds,"DataAugmentation",imageAugmenter);


opts   = trainingOptions('sgdm','InitialLearnRate',0.001,...
                         'ExecutionEnvironment','auto', ...
                         'LearnRateDropFactor',0.1, ...
                         'Shuffle','every-epoch', ...             
                         'ValidationPatience',4, ...
                         'Verbose',false, ...
                         'MaxEpochs'    ,15,...                         
                         'MiniBatchSize',param_MiniBatchSize,'Plots','training-progress');
                     %'ExecutionEnvironment', 'parallel', ... % multiple CPU
                    
my_net = trainNetwork(auimds,layers,opts);

save(['my_net_K_5_' num2str(index) '_' myNetwork '.mat'],'my_net');

toc