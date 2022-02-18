
clear


folder_name = {'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56',
                'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56',
                'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56',
                'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56',
                'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56',
                'X:\STP_processed\2020\20200130_UC_U532_nNos-Ai14_M_p56'};

            
            
call_module_deep_learning_cell_typing = 1;

call_module_register_and_output = 1;



module_deep_learning_cell_typing = '20200303_deep_learning_nNOS_95p';

module_register_and_output = '20200916_register_and_output_allen_correction_2017_2020_v4';





for ii = 1:1:length(folder_name)

    new_folder_name = folder_name{ii};


    if call_module_deep_learning_cell_typing
        cd(module_deep_learning_cell_typing);
        Full_brain_AI(new_folder_name);
        cd('..');
    end

    if call_module_register_and_output
        cd(module_register_and_output);
        elastix_50(new_folder_name);
        cd('..');
    end



end