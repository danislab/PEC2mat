[![View PEC2mat on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://ch.mathworks.com/matlabcentral/fileexchange/81318-pec2mat)

# PEC2mat
#### Convert battery .csv exports from PEC LifeTest server to .mat files for MATLAB

PEC2mat can be used to convert .csv exports from PEC LifeTest battery test software into MATLAB structs and save them as .mat files. The converter enables the selection of single files, batch files and folders including subfolder (recursively) in a GUI. Optionally, the conversion function can be included in a customer script.
When exporting the data, it is necessary to always specify the cell ID, as it is used for the structure identifiers.

#### Features of PEC2mat
* Batch import enables fast conversion of data.
* Customizable variables format enables the specification of data format of your own defined variables e.g: counters, temperature sensors, digital and analog IOs, CAN messages.
* For discretely recorded data, the NaNs can be easily removed by specifying the variable names in the settings.
* The folder structure of the .csv files can be kept for saving the .mat files or all .mat files can be saved in a single folder.

#### Settings of PEC2mat
* The default input and output directory can be specified in the beginning of the function. Furthermore, it can be decided if the folder structure should be maintained for the converted .mat files.
* The format for each variable can be specified in the spreadsheet `Variables` in the file `PEC2mat_settings.xls`
* The variable names for which the NaNs should be removed can be specified in the spreadsheet `removeNaNs` in the file `PEC2mat_settings.xls`
