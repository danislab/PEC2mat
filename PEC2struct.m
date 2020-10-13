function [Test] = PEC2struct(file)
%PEC Converts exported test files from PEC to matlab readable struct
% To increase the speed, the RAW files are read in in batches
%
% INPUT  file: path to .csv file from PEC export
%
% OUTPUT Test: a struct with tables for each Cell ID
%
% Examples:
% Test = convert_RAW_PEC_file('Test1234.csv')

bufferSize = 1e7;
eol = newline;

acctual_Line = 1;
first_cycle = true;
contains_first_line = true;
data = [];

% get numbers of lines in file
nbr_of_Lines = 0;
fid = fopen(file, 'r');
if fid == -1
   error('Cannot open file: %s', file);
end
while ~feof(fid)
    fgetl(fid);
    nbr_of_Lines = nbr_of_Lines + 1;
end
fclose(fid);

% read data from file
fid = fopen(file, 'r');
if fid == -1
   error('Cannot open file: %s', file);
end

while ~feof(fid)
    tline = fgetl(fid);
    rowData = regexp(tline, ',', 'split');
    nbr_of_Lines = nbr_of_Lines - 1;   % substract header lines
    if strfind(tline,'Cell ID') > 0    % header found
        % find index for all cells in test file
        idx_CellID = find(strcmp(rowData,'Cell ID'));
        first_Header_variable = rowData{1};
        idx_first_Header_variables = find(strcmp(rowData,first_Header_variable));
        idx_Header_variable_start = find(strcmp(rowData,first_Header_variable), 1, 'last');
        idx_Header_variable_stop = length(rowData)-1;

        % extract header names and convert in matlab compatible variable
        % names
        header_Names = rowData(idx_Header_variable_start:idx_Header_variable_stop);     
        header_Names_compatible = make_header_names_compatible(header_Names);
        header_Size = length(header_Names_compatible);
                 
        % creat new data pattern
        nbr_of_Cells_in_RAW_File = length(idx_first_Header_variables);
        data_pattern = repmat('%s', [1, idx_Header_variable_stop - idx_Header_variable_start + 1]);
        
        % replace the variable format according to the definition
        header_fomat = readtable('PEC2mat_settings.xlsx');        
        header_fomat.Variable = make_header_names_compatible(header_fomat.Variable);
        
        for i=1:header_Size 
            for n=1:height(header_fomat)
                if strcmp(header_Names_compatible{i}, header_fomat.Variable{n})
                    data_pattern(2*i - 1:2*i) = header_fomat.Format{n};
                end 
            end
        end
        
        % assemble the data pattern for all cells in the test file
        full_data_pattern = [repmat(data_pattern, 1, nbr_of_Cells_in_RAW_File) '%s'];      
                
        % loob through RAW data until eof
        while ~isempty(data) || first_cycle
            first_cycle = false;
            dataBatch = fread(fid,bufferSize,'uint8=>char')';
            dataIncrement = fread(fid,1,'uint8=>char');
            % read until end of line
            while ~isempty(dataIncrement) && (dataIncrement(end) ~= eol) && ~feof(fid)
                dataIncrement(end+1) = fread(fid,1,'uint8=>char'); %#ok<AGROW>
            end
            data = [dataBatch dataIncrement];    % merge data together
            
            if ~isempty(data)
                % parse the data
                scannedData = textscan(data,full_data_pattern,'Delimiter',',');
                
                % get cell names from first line
                if contains_first_line == true
                    Cell_Names = [scannedData{idx_CellID}];
                    Cell_Names = make_header_names_compatible(Cell_Names(1,:));
                    contains_first_line = false;
                end
                
                % get number of scanned lines
                [nbr_of_scanned_lines, ~] = size([scannedData{idx_CellID}]);
                
                % store data separated for each cell in a table
                for index = 1 : length(Cell_Names)
                    Individual_Cell_Data = scannedData(idx_first_Header_variables(index):idx_first_Header_variables(index) + header_Size - 1);
                    Individual_Cell_Data_Table = table(Individual_Cell_Data{:}, 'VariableNames', header_Names_compatible);
                    if ~isempty(Individual_Cell_Data_Table.Cell_ID{1})
                        Test.(Cell_Names{index})(acctual_Line:acctual_Line + nbr_of_scanned_lines - 1,:) = Individual_Cell_Data_Table;
                    end                    
                end
                
                % calculate new line in data file
                acctual_Line = acctual_Line + nbr_of_scanned_lines;
            end
        end
    end
end
fclose(fid);

% remove NaNs rows from table
for index = 1 : length(Cell_Names)
    Test.(Cell_Names{index}) = rmmissing(Test.(Cell_Names{index}),'DataVariables',{'Cell_ID'});
end

% function to make the header names compatible with Matlab variable names
function [header_Names_compatible] = make_header_names_compatible(header_Names)
    header_Names_compatible = regexprep(header_Names, ' ', '_');                        % replace space with underline
    header_Names_compatible = regexprep(header_Names_compatible, '-', '_');             % replace hyphen with underline
    header_Names_compatible = regexprep(header_Names_compatible, '[^A-Za-z0-9_]', '');  % only allow A-Z, a-z, 0-9 and _
    
    % add leading 'x' if name starts with one of the letters in the pattern
    pattern = ["_", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    TF = startsWith(header_Names_compatible,pattern);
    header_Names_compatible(TF) = strcat('x', header_Names_compatible(TF));
    
    header_Names_compatible = regexprep(header_Names_compatible, '_Var\w*', '');        % remove counter and unit for variables
end

end

