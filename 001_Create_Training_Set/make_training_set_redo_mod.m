clear

root_directory = 'Z:\Yongsoo_Kim_Lab\STP_processed\2020';
%data_set = {'20191119_UC_U458_nNosAi14_F_p57';
%    '20191031_UC_U436_nNosAi14_F_p68_nov2stitch';
%    '20191106_UC_U457_nNosAi14_F_p57_nov2stitch'};
data_set = {'20200106_SS_S240_AVP_PVH_500_Rabies';
    '20191211_SS_199_AVP_PVH_F_p123_Rabies';
    '20191227_SS_S196_AVP_PVH_F_p126_Rabies'};

threshhold = 1250;

%Z:\Yongsoo_Kim_Lab\STP_processed\2020\20200106_SS_S240_AVP_PVH_500_Rabies



%for ii = 1:length(data_set)
for ii = 1


    folder_name = [ root_directory '\', data_set{ii}];
    
    ch1_folder_name = [folder_name '/stitchedImage_ch1/'];
    ch2_folder_name = [folder_name '/stitchedImage_ch2/'];
    
    
    tiflist_ch1 = dir([ch1_folder_name '*.tif']);
    tiflist_ch2 = dir([ch2_folder_name '*.tif']);
    
    if length(tiflist_ch1)~=length(tiflist_ch2)
        error('ch1 and ch2 tif count missmatch');
    end
    clear A B C
    
    
    
    
    tiflist_ch1 = tiflist_ch1(132:151);
    
    
    
    parfor jj = 1:length(tiflist_ch1)
        A{jj} = imread([tiflist_ch1(jj).folder, '/',  tiflist_ch1(jj).name]) - imread([tiflist_ch2(jj).folder, '/',  tiflist_ch2(jj).name]);
        C{jj} = imresize(A{jj},[500 500]);
    end
    clear xxx yyy zzz
    parfor jj = 1:length(tiflist_ch1)
        [xxx{jj},yyy{jj}]=pre_AI_per_image_redo(A{jj},threshhold);
        zzz{jj} = ones(size(xxx{jj})).*jj;
    end
    
    xxx = cell2mat(xxx');
    yyy = cell2mat(yyy');
    zzz = cell2mat(zzz');
    
    %flag = (xxx > 250 & xxx <size(A{1},1)-250 & yyy > 250 & yyy <size(A{1},2)-250)    ;
    flag = (yyy > 1350 & yyy <3000 & xxx > 4840 & xxx <6710 );
    
    xxx_r = xxx(flag);
    yyy_r = yyy(flag);
    zzz_r = zzz(flag);
    
    r = randi([1 length(xxx_r)],1,1000);
    
    xxx_r = xxx_r(r);
    yyy_r = yyy_r(r);
    zzz_r = zzz_r(r);
    
    clear training_set
    for jj = 1:length(xxx_r)
        training_set(jj).image1 = A{zzz_r(jj)}(xxx_r(jj)-250:xxx_r(jj)+250, yyy_r(jj)-250:yyy_r(jj)+250);
        training_set(jj).image1_loc = [xxx_r(jj) yyy_r(jj)];
        training_set(jj).image3 = C{zzz_r(jj)};
        training_set(jj).image3_loc = [xxx_r(jj)./size(A{1},1).*500 yyy_r(jj)./size(A{1},2).*500];
        
    end
    
    save([data_set{ii} '.mat'],'training_set');
    
    
end

