function [] = elastix_50(dir_name)
%dir_name = 'Z:\Yongsoo_Kim_Lab\STP_processed\2020\20200108_UC_U516_nNos-Ai65-NPYflp_M_3TT';


index_id = 1;
index_parent_id = 8;
index_name = 2;
index_acronym = 3;
index_structure_order = 7;


csv_name = '16bit_allen_csv_20200916.csv';


dir_data =  [dir_name  '/deep_learning'];

mat_file_deep_learning = dir([dir_data, '/*.mat']);
data_file_deep_learning = [mat_file_deep_learning(1).folder, '/' mat_file_deep_learning(1).name];




dir_ch1 = [dir_name  '/stitchedImage_ch1'];
dir_ch2 = [dir_name  '/stitchedImage_ch2'];

dir_5_percent = [dir_name  '/warping'];
tif_list_5_percent = dir([dir_5_percent, '/*ch1_p05.tif']);
ch1_file = [tif_list_5_percent(1).folder, '/' tif_list_5_percent(1).name];

dir_elestix_working = [dir_name  '/elestix_temp'];

file_index = [pwd '/index.txt'];


mkdir(dir_elestix_working);



tiff_info = imfinfo(ch1_file);
tiff_stack = imread(ch1_file, 1);

for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(ch1_file, ii);
    tiff_stack = cat(3 , tiff_stack, temp_tiff);
end

tiff_stack = imadjustn(tiff_stack);


tiff_stack = permute(tiff_stack,[2,1,3]);

tiff_adjusted = [dir_elestix_working '/adjusted.nii'];

delete(tiff_adjusted) 

niftiwrite(tiff_stack,tiff_adjusted);

%{
tiff_stack = uint16(tiff_stack);

for ii = 1 : size(tiff_stack, 3)
    imwrite(tiff_stack(:,:,ii) , tiff_adjusted , 'WriteMode' , 'append') ;
end

%}


tiff_ref = [pwd '/Kim_ref_adult_v1_brain.tif'];

lib_pre = 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/projects/KimLab/pipeline/usr/local/elastix/lib/';
elastix_command = [lib_pre, '&', '/projects/KimLab/pipeline/usr/local/elastix/bin/elastix -m ', tiff_ref, ' -f ', tiff_adjusted, ' -p ', pwd, '/Par0000affine.txt', ' -p ', pwd, '/Par0000bspline.txt', ' -out ' dir_elestix_working ];


%dos(elastix_command);
system(elastix_command);



load(data_file_deep_learning);



total_length = 0;
for ii = 1:1:length(predictions)
    total_length = total_length + length(predictions{ii});
end

delete(file_index);
fileID = fopen(file_index,'w');
fprintf(fileID,'point\n');
fprintf(fileID,'%i\n', total_length);



for ii = 1:1:length(predictions)
    for jj = 1:1:length(predictions{ii})
        
        fprintf(fileID,'%i  %i  %i\n',location{ii}(2,1,jj)./20, location{ii}(1,1,jj)./20,ii);
    end
end
fclose(fileID);


file_trans_para = [dir_elestix_working, '/TransformParameters.1.txt'];
transform_command_line = [lib_pre, '&', '/projects/KimLab/pipeline/usr/local/elastix/bin/transformix -def ' file_index ' -out ' dir_elestix_working ' -tp ' file_trans_para];


%dos(transform_command_line);
system(transform_command_line);



output_points = readmatrix([dir_elestix_working, '/outputpoints.txt']);


B = output_points(:,23:25);




tiff_label = [pwd '/allen_20_anno_16bit.tif'];

tiff_info = imfinfo(tiff_label);
Label = imread(tiff_label, 1);

for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(tiff_label, ii);
    Label = cat(3 , Label, temp_tiff);
end




filter = B(:,2) > 0  &  B(:,2) < size(Label,1) ...
    & B(:,1) > 0  &  B(:,1) < size(Label,2) ...
    & B(:,3) > 0  &  B(:,3) < size(Label,3);

B = B(filter,:);
for ii = 1:1:length(predictions)
        predictions{ii} = int64(predictions{ii});
end

B_predictions = cell2mat(predictions') + 1;
B_predictions = B_predictions(filter);

B_ind = sub2ind([size(Label,1), size(Label,2), size(Label,3)], B(:,2),B(:,1),B(:,3));

B_Label = Label(B_ind);




T = readtable(csv_name);

ROI_table.id = table2array(T(:,index_id));
ROI_table.parent = table2array(T(:,index_parent_id));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);
ROI_table.name = table2array(T(:,index_name));
ROI_table.acronym = table2array(T(:, index_acronym));
ROI_table.structure_order = table2array(T(:, index_structure_order));

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1, ROI_table.name);


for NNN = 1:length(ROI_table.idx)
    
    list_of_all_ROI_inside{NNN} = find(~isinf(distances(G,NNN)));
    
end
cell_counted = zeros(length(ROI_table.idx),3);


for kk = 1: max(B_predictions)
    filter = B_predictions == kk;
    B_Label_temp = B_Label(filter);
    
    [~, loc] = ismember(B_Label_temp, ROI_table.id);
    loc = loc(loc~=0); 
    if ~isempty(loc)
        B_loc = accumarray(loc, 1,size(ROI_table.idx));
    
	    for NNN = 1:length(ROI_table.idx)
            cell_counted(NNN,kk) = sum(B_loc(ROI_table.idx(list_of_all_ROI_inside{NNN})));
    	end
    end

end







transform_command_line = [lib_pre, '&', '/projects/KimLab/pipeline/usr/local/elastix/bin/transformix -in ' tiff_label ' -out ' dir_elestix_working ' -tp ' file_trans_para];


%dos(transform_command_line);
system(transform_command_line);




transformed_lebal_file = [dir_elestix_working, '/result.nii'];


transformed_lebal = niftiread(transformed_lebal_file);
%transformed_lebal = permute(transformed_lebal,[2,1,3]);

[~, loc] = ismember(transformed_lebal(:), ROI_table.id);
loc = loc(loc~=0); 
transformed_label_loc = accumarray(loc, 1,size(ROI_table.idx));



for NNN = 1:length(ROI_table.idx)
    transformed_label_tot(NNN,1) = sum(transformed_label_loc(ROI_table.idx(list_of_all_ROI_inside{NNN})));
end
    

transformed_label_tot = transformed_label_tot.*20.*20.*50./1000000000;

finnal_table = cell2table([num2cell(ROI_table.id), ROI_table.name, ROI_table.acronym, num2cell(ROI_table.structure_order ), num2cell(transformed_label_tot), num2cell(cell_counted)]);
finnal_table.Properties.VariableNames = {'ROI_id', 'ROI_name', 'ROI_accronym', 'Structure_order', 'ROI_Volume_mm_3', 'cell_type_1', 'cell_type_2', 'cell_type_3'};

finnal_table_file = [dir_elestix_working, '/cell_count_out.csv'];
delete(finnal_table_file);
writetable(finnal_table, finnal_table_file, 'writevariablenames',1);


%writematrix(cell_counted,[dir_elestix_working, '/cell_count_out.csv'])




clear loc transformed_lebal tiff_stack


h1 = ceil(fspecial('disk',5));
h2 = ceil(fspecial('disk',4));
h3 = ceil(fspecial('disk',2));
h2 = padarray(h2,[1 1],0);
h3 = padarray(h3,[3 3],0);
h = cat(3,h3,h2,h1,h2,h3);


for kk = 1:max(B_predictions)

img_temp = zeros(size(Label),'uint16');
    
B_ind_temp = B_ind(B_predictions == kk);

[B_c, ~, ia] = unique(B_ind_temp);

temp_count = accumarray(ia,1);

img_temp(B_c) = temp_count;

img_temp = permute(img_temp,[2,1,3]);

img_file_name = [dir_elestix_working, '/cell_count_type_', num2str(kk), '.nii'];
delete(img_file_name) 
niftiwrite(img_temp,img_file_name);

img_temp = imfilter(img_temp,h);

img_file_name = [dir_elestix_working, '/cell_count_type_visual_', num2str(kk), '.nii'];
delete(img_file_name) 
niftiwrite(img_temp,img_file_name);


end





























