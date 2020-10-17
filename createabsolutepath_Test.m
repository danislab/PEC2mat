%% Define functions as tests
function tests = createabsolutepath_Test
tests = functiontests(localfunctions);
end

%% Test function for relative path
function test_case_1_relative_path(testCase)
actSolution = createabsolutepath('./Testfolder');
expSolution = fullfile(pwd, 'Testfolder');
verifyEqual(testCase,actSolution,expSolution)
end

%% Test function for absolute path
function test_case_2_absolute_path(testCase)
actSolution = createabsolutepath(fullfile(pwd, 'Testfolder'));
expSolution = fullfile(pwd, 'Testfolder');
verifyEqual(testCase,actSolution,expSolution)
end