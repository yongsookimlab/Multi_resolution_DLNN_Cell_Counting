

image1_loc = location{jj};

predictions_max = predictions{jj};

display_intensity_cap = 3000;



clear A B C


%parfor jj = 1:length(tiflist_ch1)
A = imread([tiflist_ch1(jj).folder, '/',  tiflist_ch1(jj).name]) - imread([tiflist_ch2(jj).folder, '/',  tiflist_ch2(jj).name]);
%C = imresize(A,[201 201]);
%end
clear xxx yyy
xxx(:) = image1_loc(1,1,:);
yyy(:) = image1_loc(2,1,:);


figure()
imshow(A',[0 display_intensity_cap]);
hold

%plot(yyy(predictions_max == 0),xxx(predictions_max == 0),'r+');
%plot(yyy(predictions_max == 1),xxx(predictions_max == 1),'g+');
%plot(yyy(predictions_max == 2),xxx(predictions_max == 2),'b+');
%plot(yyy(predictions_max == 3),xxx(predictions_max == 3),'c+');
%plot(yyy(predictions_max == 4),xxx(predictions_max == 4),'k+');
%plot(yyy(predictions_max == 5),xxx(predictions_max == 5),'y+');


plot(xxx(predictions_max == 0),yyy(predictions_max == 0),'r+');
plot(xxx(predictions_max == 1),yyy(predictions_max == 1),'g+');
plot(xxx(predictions_max == 2),yyy(predictions_max == 2),'b+');
%plot(xxx(predictions_max == 3),yyy(predictions_max == 3),'c+');
%plot(xxx(predictions_max == 4),yyy(predictions_max == 4),'k+');
