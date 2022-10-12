function save_data(I, row, frame, filename, label, othersp)

%my_resize = [227 227]; 

%myFolder = ['data/dataset_pre1/' label];
%myFolder = ['data/dataset_pre2_Blines/' othersp];
myFolder = ['data\dataset_original\' label '_' othersp]; %


if ~exist(myFolder, 'dir')
    mkdir(myFolder);
end
filename_write = [myFolder '/' num2str(row) '_' num2str(frame)  '_' filename(1:end-4) '.png'];
%I = imresize(I, my_resize);
imwrite(I,filename_write)

end 