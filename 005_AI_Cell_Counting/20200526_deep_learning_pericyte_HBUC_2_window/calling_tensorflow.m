function [location_dub, prediction_sub] = calling_tensorflow(training_set_1, training_set_2, training_set_3, training_set_1_loc)



h5_file_name = 'current_slice.h5';

delete(h5_file_name);
h5create(h5_file_name,'/image1',size(training_set_1));
h5write(h5_file_name,'/image1',training_set_1);
h5create(h5_file_name,'/image2',size(training_set_2));
h5write(h5_file_name,'/image2',training_set_2);
h5create(h5_file_name,'/image3',size(training_set_3));
h5write(h5_file_name,'/image3',training_set_3);
%h5create(h5_file_name,'/image4',size(training_set_4));
%h5write(h5_file_name,'/image4',training_set_4);

h5create(h5_file_name,'/image1_loc',size(training_set_1_loc));
h5write(h5_file_name,'/image1_loc',training_set_1_loc);

delete('data_back.h5');
%dos([pwd '/test.bat']);
!python brain.py

location_dub = h5read('data_back.h5','/image1_loc');
prediction_sub = h5read('data_back.h5','/predictions_max');
