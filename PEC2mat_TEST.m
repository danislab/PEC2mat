close all; clear all; clc

%% Test PEC2struct with one cell
Test = PEC2struct('PEC2mat_TEST\test_case_1_automatic_export_one_cell.csv');
figure; hold on; grid minor;
plot(Test.LG111.Total_Time_Seconds, Test.LG111.Voltage_mV)

