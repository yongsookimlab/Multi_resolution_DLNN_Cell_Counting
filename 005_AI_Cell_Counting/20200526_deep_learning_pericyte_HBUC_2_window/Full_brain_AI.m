function [] = Full_brain_AI(folder_name)


%clear; folder_name = 'G:\20200130_UC_U532_nNos-Ai14_M_p56';


ch1_folder_name = [folder_name '/stitchedImage_ch1/'];
ch2_folder_name = [folder_name '/stitchedImage_ch2/'];

dir_data =  [folder_name  '/deep_learning'];
mkdir(dir_data);


tiflist_ch1 = dir([ch1_folder_name '*.tif']);
tiflist_ch2 = dir([ch2_folder_name '*.tif']);

if length(tiflist_ch1)~=length(tiflist_ch2)
    error('ch1 and ch2 tif count missmatch');
end

threshhold = 500;
normalization = 170;

cap1 = 3000;
cap2 = 2000;
cap3 = 1000;
cap4 = 15000;

resize_1_finnal = 101;
resize_2 = 201;
chunck_size = 10000;


[~, reindex] = sort( str2double( regexp( {tiflist_ch1.name}, '\d+', 'match', 'once' )));
tiflist_ch1 = tiflist_ch1(reindex);
tiflist_ch2 = tiflist_ch2(reindex);

ch1_5p_name = dir([[folder_name '/warping/*ch1*']]);
ch2_5p_name = dir([[folder_name '/warping/*ch2*']]);

ch1_5p_name = [ch1_5p_name(1).folder, '/', ch1_5p_name(1).name];
ch2_5p_name = [ch2_5p_name(1).folder, '/', ch2_5p_name(1).name];

tiff_info = imfinfo(ch1_5p_name); % return tiff structure, one element per image
ch1_5p = imread(ch1_5p_name, 1) ; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(ch1_5p_name, ii);
    ch1_5p = cat(3 , ch1_5p, temp_tiff);
end

tiff_info = imfinfo(ch2_5p_name); % return tiff structure, one element per image
ch2_5p = imread(ch2_5p_name, 1) ; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(ch2_5p_name, ii);
    ch2_5p = cat(3 , ch2_5p, temp_tiff);
end

A = ch1_5p - ch2_5p;

C = A;

[~,ind] = ismember(C(:),sort(C(:),'ascend'));
cutting_mean  = mean(C(ind<max(ind).*0.9 & C(:)>50));

ad_ratio = 1.0;

while cutting_mean > normalization
    ad_ratio = ad_ratio.*0.95
    C = A.*ad_ratio;
    [~,ind] = ismember(C(:),sort(C(:),'ascend'));
    cutting_mean  = mean(C(ind<max(ind).*0.9 & C(:)>50));
    
end
clear A C




for jj = 1:length(tiflist_ch1)
    %for jj = 50
    %for jj = 50
    tic
    A = imread([tiflist_ch1(jj).folder, '/',  tiflist_ch1(jj).name]) - imread([tiflist_ch2(jj).folder, '/',  tiflist_ch2(jj).name]);
    A = A.*ad_ratio;
    
    C = imresize(A,[201 201]);
    
    [xxx,yyy]=pre_AI_per_image_redo(A,threshhold);
    %zzz = ones(size(xxx)).*jj;
    
    flag = (xxx > 250 & xxx <size(A,1)-250 & yyy > 250 & yyy <size(A,2)-250)    ;
    if nnz(flag)>1
        xxx = xxx(flag);
        yyy = yyy(flag);
        %zzz = zzz(flag);
        
        clear training_set
        
        training_set_1 = zeros([length(xxx), 101, 101],'single');
        training_set_2 = zeros([length(xxx), 201, 201],'single');
        
        training_set_3_1 = zeros([length(xxx), 201, 201],'single');
        training_set_3_2 = zeros(size(training_set_3_1),'single');
        training_set_1_loc = zeros(length(xxx),1,2,'single');
        training_set_3_loc = zeros(length(xxx),1,2,'single');
        
        
        
        for kk = 1:length(xxx)
            training_set_1(kk,:,:) = A(xxx(kk)-50:xxx(kk)+50, yyy(kk)-50:yyy(kk)+50);
            training_set_2(kk,:,:) = imresize(A(xxx(kk)-250:xxx(kk)+250, yyy(kk)-250:yyy(kk)+250),[201,201]);
            training_set_3_1(kk,:,:) = C;
            training_set_1_loc(kk,:,:) = [xxx(kk) yyy(kk)];
            training_set_3_loc(kk,:,:) = [xxx(kk)./size(A,1).*201 yyy(kk)./size(A,2).*201];
            training_set_3_2(kk,ceil(training_set_3_loc(kk,1,1)),ceil(training_set_3_loc(kk,1,2)) )= 65535;
        end
        
        
        clear A C
        
        
        training_set_1 = permute(training_set_1,[3 2 1]);
        training_set_1_loc = permute(training_set_1_loc,[3 2 1]);
        %training_set_3_loc = permute(training_set_3_loc,[3 2 1]);
        
        training_set_2 = permute(training_set_2,[3 2 1]);
        
        training_set_3_1 = permute(training_set_3_1,[3 2 1]);
        training_set_3_2 = permute(training_set_3_2,[3 2 1]);
        
        
        training_set_3 = zeros([2, size(training_set_3_2)],'single');
        training_set_3(1,:,:,:) = training_set_3_1;
        training_set_3(2,:,:,:) = training_set_3_2;
        
        clear training_set_3_2 training_set_3_1
        
        
        
        full_training_set_1_red_dot = zeros([2, size(training_set_1)],'single');
        full_training_set_1_red_dot(1,:,:,:) = training_set_1;
        full_training_set_1_red_dot(2,ceil(resize_1_finnal./2),ceil(resize_1_finnal./2),:) = 65535;
        
        full_training_set_2_red_dot = zeros([2, size(training_set_2)],'single');
        full_training_set_2_red_dot(1,:,:,:) = training_set_2;
        full_training_set_2_red_dot(2,ceil(resize_2./2),ceil(resize_2./2),:) = 65535;
        
        
        %{
    full_training_set_1_red_dot = zeros([1, size(training_set_1)],'single');
    full_training_set_1_red_dot(1,:,:,:) = training_set_1;
    %full_training_set_1_red_dot(2,ceil(resize_1_finnal./2),ceil(resize_1_finnal./2),:) = 65535;
    
    full_training_set_2_red_dot = zeros([1, size(training_set_2)],'single');
    full_training_set_2_red_dot(1,:,:,:) = training_set_2;
    %full_training_set_2_red_dot(2,ceil(resize_2./2),ceil(resize_2./2),:) = 65535;
        %}
        
        %training_set_4 = training_set_1;
        training_set_1 = full_training_set_1_red_dot;
        training_set_1(training_set_1(:)>cap1) = cap1;
        training_set_1 = training_set_1./cap1;
        
        training_set_2 = full_training_set_2_red_dot;
        training_set_2(training_set_2(:)>cap2) = cap2;
        training_set_2 = training_set_2./cap2;
        
        clear full_training_set_1_red_dot full_training_set_2_red_dot
        training_set_3(training_set_3(:)>cap3) = cap3;
        training_set_3 = training_set_3./cap3;
        %training_set_4(training_set_4(:)>cap4) = cap4;
        %training_set_4 = training_set_4./cap4;
        
        %training_set_1 = reshape(training_set_1,1,size(training_set_1,1),size(training_set_1,2),size(training_set_1,3));
        %training_set_2 = reshape(training_set_2,1,size(training_set_2,1),size(training_set_2,2),size(training_set_2,3));
        %training_set_4 = reshape(training_set_4,1,size(training_set_4,1),size(training_set_4,2),size(training_set_4,3));
        
        location_dub_tot = [];
        prediction_sub_tot = [];
        
        training_set_1 = single(training_set_1);
        training_set_2 = single(training_set_2);
        training_set_3 = single(training_set_3);
        
        
        
        for ii = 1:ceil(size(training_set_1,4)./chunck_size)
            starting_pic = (ii-1).*chunck_size+1;
            if ii == ceil(size(training_set_1,4)./chunck_size)
                ending_pic = size(training_set_1,4);
            else
                ending_pic = (ii).*chunck_size;
            end
            
            training_set_1_temp = training_set_1(:,:,:,starting_pic:ending_pic);
            training_set_2_temp = training_set_2(:,:,:,starting_pic:ending_pic);
            training_set_3_temp = training_set_3(:,:,:,starting_pic:ending_pic);
            training_set_1_loc_temp = training_set_1_loc(:,:,starting_pic:ending_pic);
            
            
            [location_dub, prediction_sub] = calling_tensorflow(training_set_1_temp, training_set_2_temp, training_set_3_temp, training_set_1_loc_temp);
            
            location_dub_tot = cat(3,location_dub_tot, location_dub);
            prediction_sub_tot = cat(1,prediction_sub_tot, prediction_sub);
        end
        location{jj} =  location_dub_tot;
        predictions{jj} = prediction_sub_tot;
        %PLoting_AI_result_w_GUI
        
        save([dir_data, '/AI_result.mat'], 'location', 'predictions');
    end
    toc
end









