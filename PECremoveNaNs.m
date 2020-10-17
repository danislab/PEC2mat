function [Test] = PECremoveNaNs(Test)
%PECREMOVENANS Removes NaNs from variables specified in the settings
% After removing the NaNs from variables they can easily processed and
% plotted.
%
% INPUT  Test: a struct with tables for each Cell ID
%
% OUTPUT Test: a struct with tables for each Cell ID
%
% Examples:
% Test = PECremoveNaNs(Test)

% get variable names to replace NaNs from settings
variables_to_remove_NaNs = readtable('PEC2mat_settings.xlsx', ...
    'Sheet', 'removeNaNs');  

% get tested cells from Test
tested_cells = fieldnames(Test);

% loop trough cell IDs within Test structure
for i=1:length(tested_cells)

    % get names of exported variables
    variables_in_test = fieldnames(Test.(tested_cells{i}));
    
    % replace NaNs for selected variable
    for n=1:height(variables_to_remove_NaNs)
        idx = find(contains(variables_in_test, variables_to_remove_NaNs.Variable{n}));
        
        % replace NaNs if selected variable exists in the Test structure
        if ~isempty(idx)
            % first replace all NaNs by the previous values
            T = fillmissing(Test.(tested_cells{i})(:,idx),'previous');
            % and then by the closest values
            Test.(tested_cells{i})(:,idx) = fillmissing(T,'next');
        end

    end

end

end
