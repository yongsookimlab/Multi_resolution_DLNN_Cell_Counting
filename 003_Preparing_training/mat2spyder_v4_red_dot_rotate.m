
clear


cluster_folder = pwd;



file_names = {'20190910_UC_U450_nNos-Ai65-NPYflp_F_3TT_nov2stitch.mat';
    '20191017_UC_U470_nNos-Ai65-VIPflp_F_3TT_nov2stitch.mat';
    '20191101_UC_U454_nNos-Ai65-SSTflp_F_3TT_nov2stitch.mat';
    '20191108_UC_U464_nNos-Ai65-PVflp_F_3TT_nov2stitch.mat';
    '20191009_UC_U435_nNosAi14_F_p68.mat';
    '20190920_HB_U455_nNos-Ai14C-12-6_M_NH_P57_1TT.mat';
    '20191106_UC_U457_nNosAi14_F_p57_nov2stitch.mat';
    '20191119_UC_U458_nNosAi14_F_p57.mat';
    '20200106_SS_S240_AVP_PVH_500_Rabies.mat' };




ans_names = {'full_07-Jan-2020_UREE_20190910_UC_U450_nNos-Ai65-NPYflp_F_3TT_nov2stitch_1-330.mat';
    'full_07-Jan-2020_UREE_20191017_UC_U470_nNos-Ai65-VIPflp_F_3TT_nov2stitch1_279.mat';
    'full_07-Jan-2020_UREE_20191101_UC_U454_nNos-Ai65-SSTflp_F_3TT_nov2stitch_1-300.mat';
    'full_09-Jan-2020_UREE_20191108_UC_U464_nNos-Ai65-PVflp_F_3TT_nov2stitch_1-300.mat';
    'full_14-Nov-2019_UREE_20191009_UC_U435_nNosAi14_F_p68_1.mat';
    'full_15-Nov-2019_UREE_20190920_HB_U455_nNos-Ai14C-12-6_M_NH_P57_1TT_1.mat';
    'full_09-Jan-2020_UREE_20191106_UC_U457_nNosAi14_F_p57_nov2stitch_1-200.mat';
    'full_09-Jan-2020_UREE_20191119_UC_U458_nNosAi14_F_p57_1-400.mat';
    'full_26-Feb-2020_UREE_20200106_SS_S240_AVP_PVH_500_Rabies_1-200.mat'};

h5_file_name = '4brain.h5';




set_size= 1000;

rotate_multiplyer = 0;





cap1 = 3000;
cap2 = 2000;
cap3 = 1000;
cap4 = 15000;

resize_1_temp = 151;
resize_1_finnal = 101;
resize_2 = 201; 





full_training_set = [];
full_ans = [];

for ii = 1:length(file_names)
    load([cluster_folder '/' file_names{ii} ]);
    load([cluster_folder '/' ans_names{ii} ]);
    
    full_training_set = [full_training_set; training_set'];
    full_ans = [ full_ans; yes_no_ansers];
    
    clear training_set yes_no_ansers
end

total_size = length(full_ans);
validation_size = round(total_size./10);



r_index = randperm(length(full_training_set));
full_training_set = full_training_set(r_index);
full_ans = full_ans(r_index);
size_data_image = size(full_training_set(1).image1);

set_1_range = (ceil(size_data_image./2)' + [-floor(resize_1_temp./2),  floor(resize_1_temp./2)]);


full_training_set_1 = zeros([length(full_training_set), resize_1_temp, resize_1_temp]);
full_training_set_2 = zeros([length(full_training_set), resize_2, resize_2]);

full_training_set_3_1 = zeros([length(full_training_set), 201, 201]);
full_training_set_3_2 = zeros(size(full_training_set_3_1));


for ii = 1:length(full_training_set)
    full_training_set_1(ii,:,:) = full_training_set(ii).image1(set_1_range(1,1):set_1_range(1,2),set_1_range(2,1):set_1_range(2,2));
    full_training_set_2(ii,:,:) = imresize(full_training_set(ii).image1,[resize_2,resize_2]);
    full_training_set_3_1(ii,:,:) = imresize(full_training_set(ii).image3,[201,201]);
end

for ii = 1:length(full_training_set)
    full_training_set_3_2(ii,ceil(full_training_set(ii).image3_loc(1).*201./501),ceil(full_training_set(ii).image3_loc(2).*201./501)) = 65535;
end





full_training_set_1 = permute(full_training_set_1,[3 2 1]);
full_training_set_2 = permute(full_training_set_2,[3 2 1]);

full_training_set_3_1 = permute(full_training_set_3_1,[3 2 1]);
full_training_set_3_2 = permute(full_training_set_3_2,[3 2 1]);




rot_training_set_1 = full_training_set_1(:,:,(validation_size+1):end);
rot_training_set_2 = full_training_set_2(:,:,(validation_size+1):end);
rot_training_set_3_1 = full_training_set_3_1(:,:,(validation_size+1):end);
rot_training_set_3_2 = full_training_set_3_2(:,:,(validation_size+1):end);
rot_full_ans = full_ans((validation_size+1):end);




for ii = 1:1:rotate_multiplyer
    
    
    rot_degree = rand(1).*360;
    
    full_training_set_1 = cat(3,full_training_set_1,imrotate(rot_training_set_1,rot_degree,'crop'));
    full_training_set_2 = cat(3,full_training_set_2,imrotate(rot_training_set_2,rot_degree,'crop'));
    
    full_training_set_3_1 = cat(3,full_training_set_3_1,rot_training_set_3_1);
    full_training_set_3_2 = cat(3,full_training_set_3_2,rot_training_set_3_2);
    
    full_ans = cat(1,full_ans,rot_full_ans);
    
    
end



size_data_image = [size(full_training_set_1,1), size(full_training_set_1,2)];

set_1_range = (ceil(size_data_image./2)' + [-floor(resize_1_finnal./2),  floor(resize_1_finnal./2)]);

full_training_set_1 = full_training_set_1(set_1_range(1,1):set_1_range(1,2),set_1_range(2,1):set_1_range(2,2),:);






clear rot_training_set_1 rot_training_set_2 rot_training_set_3_1 rot_training_set_3_2 rot_full_ans


full_training_set_3 = zeros([2, size(full_training_set_3_2)]);
full_training_set_3(1,:,:,:) = full_training_set_3_1;
full_training_set_3(2,:,:,:) = full_training_set_3_2;

full_training_set_1_red_dot = zeros([2, size(full_training_set_1)]);
full_training_set_1_red_dot(1,:,:,:) = full_training_set_1;
full_training_set_1_red_dot(2,ceil(resize_1_finnal./2),ceil(resize_1_finnal./2),:) = 65535;

full_training_set_2_red_dot = zeros([2, size(full_training_set_2)]);
full_training_set_2_red_dot(1,:,:,:) = full_training_set_2;
full_training_set_2_red_dot(2,ceil(resize_2./2),ceil(resize_2./2),:) = 65535;






%full_training_set_4 = full_training_set_1_red_dot;
full_training_set_1 = full_training_set_1_red_dot;
full_training_set_1(full_training_set_1(:)>cap1) = cap1;
full_training_set_1 = full_training_set_1./cap1;
full_training_set_2 = full_training_set_2_red_dot;
full_training_set_2(full_training_set_2(:)>cap2) = cap2;
full_training_set_2 = full_training_set_2./cap2;
full_training_set_3(full_training_set_3(:)>cap3) = cap3;
full_training_set_3 = full_training_set_3./cap3;
%full_training_set_4(full_training_set_4(:)>cap4) = cap4;
%full_training_set_4 = full_training_set_4./cap4;

%full_training_set_1 = reshape(full_training_set_1,2,size(full_training_set_1,1),size(full_training_set_1,2),size(full_training_set_1,3));
%full_training_set_2 = reshape(full_training_set_2,2,size(full_training_set_2,1),size(full_training_set_2,2),size(full_training_set_2,3));
%full_training_set_4 = reshape(full_training_set_4,2,size(full_training_set_4,1),size(full_training_set_4,2),size(full_training_set_4,3));





delete(h5_file_name);
h5create(h5_file_name,'/image1',size(full_training_set_1(:,:,:,(validation_size+1):end)));
h5write(h5_file_name,'/image1',full_training_set_1(:,:,:,(validation_size+1):end));
h5create(h5_file_name,'/image2',size(full_training_set_2(:,:,:,(validation_size+1):end)));
h5write(h5_file_name,'/image2',full_training_set_2(:,:,:,(validation_size+1):end));
h5create(h5_file_name,'/image3',size(full_training_set_3(:,:,:,(validation_size+1):end)));
h5write(h5_file_name,'/image3',full_training_set_3(:,:,:,(validation_size+1):end));
%h5create(h5_file_name,'/image4',size(full_training_set_4(:,:,:,(validation_size+1):end)));
%h5write(h5_file_name,'/image4',full_training_set_4(:,:,:,(validation_size+1):end));


h5create(h5_file_name,'/validate1',size(full_training_set_1(:,:,:,1:validation_size)));
h5write(h5_file_name,'/validate1',full_training_set_1(:,:,:,1:validation_size));
h5create(h5_file_name,'/validate2',size(full_training_set_2(:,:,:,1:validation_size)));
h5write(h5_file_name,'/validate2',full_training_set_2(:,:,:,1:validation_size));
h5create(h5_file_name,'/validate3',size(full_training_set_3(:,:,:,1:validation_size)));
h5write(h5_file_name,'/validate3',full_training_set_3(:,:,:,1:validation_size));
%h5create(h5_file_name,'/validate4',size(full_training_set_4(:,:,:,1:validation_size)));
%h5write(h5_file_name,'/validate4',full_training_set_4(:,:,:,1:validation_size));


full_ans = full_ans - 1;

h5create(h5_file_name,'/ans_train',size(full_ans((validation_size+1):end)'));
h5write(h5_file_name,'/ans_train',full_ans((validation_size+1):end)');
h5create(h5_file_name,'/ans_validate',size(full_ans(1:validation_size)'));
h5write(h5_file_name,'/ans_validate',full_ans(1:validation_size)');


























