
clear


folder_name = pwd;

call_module_deep_learning_cell_typing = 1;

call_module_register_and_output = 1;



module_deep_learning_cell_typing = '20200526_deep_learning_pericyte_HBUC_2_window';

module_register_and_output = '20200916_register_and_output_allen_correction_2017_2020_v4';



if call_module_deep_learning_cell_typing
    cd(module_deep_learning_cell_typing);
    Full_brain_AI(folder_name);
    cd('..');
end

if call_module_register_and_output
    cd(module_register_and_output);
    elastix_50(folder_name);
    cd('..');
end




data_name = '20200723_HB_HB203_Pdgfrb-Ai14-5xFAD_M_MUT_p117';

file_list = dir('elestix_temp/cell_count_*');


for ii = 1:length(file_list)
    %movefile( [file_list(ii).folder, '/', file_list(ii).name] , [file_list(ii).folder, '/', data_name, '_', module_deep_learning_cell_typing, '_', file_list(ii).name]);
    movefile( [file_list(ii).folder, '/', file_list(ii).name] , [file_list(ii).folder, '/', data_name, '_',  file_list(ii).name]);
end

[ret, name] = system('hostname');
fileID = fopen('elestix_temp/deep_learning_log.txt','w');
fprintf(fileID,[data_name, '\n']);
fprintf(fileID,[module_deep_learning_cell_typing, '\n']);
fprintf(fileID,[module_register_and_output, '\n']);
fprintf(fileID,[datestr(datetime), '\n']);
fprintf(fileID,[name, '\n']);
fclose(fileID);
