%% Define functions as tests
function tests = PEC2struct_Test
tests = functiontests(localfunctions);
end

%% Test automatic PEC export for backups
function test_case_1_automatic_export_one_cell(testCase)
actSolution = PEC2struct('PEC2struct_TEST\test_case_1_automatic_export_one_cell.csv');
load('PEC2struct_TEST\test_case_1_automatic_export_one_cell.mat', 'expSolution');
verifyEqual(testCase,actSolution,expSolution)
end

%% Test manual PEC export for tests with three cells
function test_case_2_full_manual_export_three_cells(testCase)
actSolution = PEC2struct('PEC2struct_TEST\test_case_2_full_manual_export_three_cells.csv');
load('PEC2struct_TEST\test_case_2_full_manual_export_three_cells.mat', 'expSolution');
verifyEqual(testCase,actSolution,expSolution)
end