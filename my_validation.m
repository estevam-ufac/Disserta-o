 %function my_validation


load('confusionmatrix_vgg16.mat')

K = size(C,2);

for index = 1:K
    T(:,:,index) = statsOfMeasure(C{index},1);
end

%my_class = 2

precision   = [reshape(T(5,1,:),K,1) reshape(T(5,2,:),K,1) reshape(T(5,3,:),K,1) reshape(T(5,4,:),K,1)  reshape(T(5,5,:),K,1)  reshape(T(5,6,:),K,1)  reshape(T(5,7,:),K,1) ]
sensitivity = [reshape(T(6,1,:),K,1) reshape(T(6,2,:),K,1) reshape(T(6,3,:),K,1) reshape(T(6,4,:),K,1)  reshape(T(6,5,:),K,1)  reshape(T(6,6,:),K,1)  reshape(T(6,7,:),K,1) ]
specificity = [reshape(T(7,1,:),K,1) reshape(T(7,2,:),K,1) reshape(T(7,3,:),K,1) reshape(T(7,4,:),K,1)  reshape(T(7,5,:),K,1)  reshape(T(7,6,:),K,1)  reshape(T(7,7,:),K,1) ]
accuracy    = [reshape(T(8,1,:),K,1) reshape(T(8,2,:),K,1) reshape(T(8,3,:),K,1) reshape(T(8,4,:),K,1)  reshape(T(8,5,:),K,1)  reshape(T(8,6,:),K,1)  reshape(T(8,7,:),K,1) ]
F           = [reshape(T(9,1,:),K,1) reshape(T(9,2,:),K,1) reshape(T(9,3,:),K,1) reshape(T(9,4,:),K,1)  reshape(T(9,5,:),K,1)  reshape(T(9,6,:),K,1)  reshape(T(9,7,:),K,1) ]

figure; boxchart([precision(:) sensitivity(:) accuracy(:) F(:)])
grid on