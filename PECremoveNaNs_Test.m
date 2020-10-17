%% Define functions as tests
function tests = PECremoveNaNs_Test
tests = functiontests(localfunctions);
end

%% Test remove NaNs for temperature sensor (PT_100)
function test_case_1_one_measurement_in_PT_100_variable(testCase)
load('PECremoveNaNs_Test\test_case_1_PT_100_with_one_measurement_input_test.mat', 'InputTest');
actSolution = PECremoveNaNs(InputTest);
load('PECremoveNaNs_Test\test_case_1_PT_100_with_one_measurement_expected_solution.mat', 'expSolution');
verifyEqual(testCase,actSolution,expSolution)
end

%% Test remove NaNs for temperature sensor (PT_100)
function test_case_2_only_NaNs_in_PT_100_variable(testCase)
load('PECremoveNaNs_Test\test_case_1_PT_100_without_measurement_input_test.mat', 'InputTest');
actSolution = PECremoveNaNs(InputTest);
load('PECremoveNaNs_Test\test_case_1_PT_100_without_measurement_expected_solution.mat', 'expSolution');
verifyEqual(testCase,actSolution,expSolution)
end

%% Test remove NaNs for temperature sensor (PT_100) for multiple cells
function test_case_3_only_NaNs_in_PT_100_variable_and_3_cells(testCase)
load('PECremoveNaNs_Test\test_case_1_PT_100_with_multiple_measurement_and_3_cells_input_test.mat', 'InputTest');
actSolution = PECremoveNaNs(InputTest);
load('PECremoveNaNs_Test\test_case_1_PT_100_with_multiple_measurement_and_3_cells_expected_solution.mat', 'expSolution');
verifyEqual(testCase,actSolution,expSolution)
end