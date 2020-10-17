%% Definitions 

% define the path for the raw data export files file and converted mat
% files
prop.input_dir = './RAW_Data_Export';
prop.output_dir = './mat_Data';


%% Pick the .csv files from folders
% get the filepaths
fullpaths = uipickfiles('FilterSpec', [prop.input_dir '/*.csv'])';

% if selected some tests convert them to structs and save them as .mat file
if iscell(fullpaths)
    
    % define struct for all files
    all_files = [];
    
    % get all picked files
    for i=1:length(fullpaths)
        
        % if folder
        if isfolder(fullpaths{i})
            filelist = dir(fullfile(fullpaths{i}, '**\*.csv'));
            filelist = filelist(~[filelist.isdir]);  %remove folders from list
        else
            filelist = dir(fullpaths{i});
        end
        
        all_files = [all_files; filelist]; %#ok<AGROW>
        
    end
    
    % convert all files, remove NaNs and save tests as .mat files
    for i=1:length(all_files)
        
        file = [all_files(i).folder '\' all_files(i).name];
        [~,name,~] = fileparts(file);
        
        disp(['Convert file: ' file])
        
        % read the .csv files
        Test = PEC2struct(file);
        
        % remove NaNs from specified variables in the settings
        Test = PECremoveNaNs(Test);
        
        % save the converted test structure as .mat file
        save([prop.output_dir '/' name '.mat'], 'Test');
    end
end
