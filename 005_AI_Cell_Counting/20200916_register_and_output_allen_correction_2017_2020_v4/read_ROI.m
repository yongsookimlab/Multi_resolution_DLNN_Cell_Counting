function [list_of_all_ROI_inside] = read_ROI(NNN,csv_name,id_location,parent_id_location)






T = readtable(csv_name);

ROI_table.id = table2array(T(:,id_location));
ROI_table.parent = table2array(T(:,parent_id_location));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1);
%plot(G)


list_of_all_ROI_inside = find(~isinf(distances(G,find(ROI_table.id == NNN))));

%fprintf(['self: ', ROI_table.name{find(ROI_table.id == NNN)}, '\n']);

%for ii = 1:length(list_of_all_ROI_inside)
%    fprintf(['ROI inside: ', ROI_table.name{list_of_all_ROI_inside(ii)}, '\n']);
%end

list_of_all_ROI_inside = ROI_table.id(list_of_all_ROI_inside);