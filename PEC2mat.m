%% Definitions

% define the path for the raw data export files file and converted mat
% files
prop.input_dir = './RAW_Data_Export';
prop.output_dir = './mat_Data';
prop.keep_folder_structure = false;

% Prepare the absolute path for the output folder
prop.output_full_dir = createabsolutepath(prop.output_dir);


%% Pick the .csv files from folders
% get the filepaths
fullpaths = uipickfiles('FilterSpec', [prop.input_dir '/*.csv'])';

% if selected some tests convert them to structs and save them as .mat file
if iscell(fullpaths)
    
    % get all picked files
    for i=1:length(fullpaths)
        
        % check if path is a folder or file
        if isfolder(fullpaths{i})
            % go trough folder and subfolders
            % get all .csv files recursively in folders and subfolders
            filelist = dir(fullfile(fullpaths{i}, '**\*.csv'));
            % remove folders from list
            filelist = filelist(~[filelist.isdir]); 
        else
            % get single file
            filelist = dir(fullpaths{i});
        end
        
        % create absolute path for input folder
        fullfilepath = createabsolutepath(fileparts(fullpaths{i}));
        
        % convert files in filelist, remove NaNs and save tests as .mat files
        for n=1:length(filelist)
            % show path for file which is currently converted
            disp(['Convert file: ' filelist(n).folder filesep filelist(n).name])
            
            % read the .csv files and convert data into structure
            Test = PEC2struct([filelist(n).folder filesep filelist(n).name]);
            
            % remove NaNs from specified variables in the settings
            Test = PECremoveNaNs(Test);
            
            % create output file name for .mat file
            if prop.keep_folder_structure
                output_file_name = strrep(strrep([filelist(n).folder filesep filelist(n).name],fullfilepath,prop.output_full_dir),'.csv','.mat');
            else
                output_file_name = strrep([prop.output_full_dir filesep filelist(n).name],'.csv','.mat');
            end
            disp(['Save file to: ' output_file_name])
            
            % create folders and subfolders if they do not exist
            if ~exist(fileparts(output_file_name), 'dir')
                mkdir(fileparts(output_file_name));
            end
            
            % save the converted test structure as .mat file
            save(output_file_name, 'Test');
        end
    end
end

