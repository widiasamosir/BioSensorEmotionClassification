function finalDecision = Test_PPG(filename)
    % Load the trained model
    load('modelPPG.mat', 'model');
    % Load the ECG data for testing
    % ppgData = load('/Users/user0329/Documents/Angel/Biometrics/Analysis/GSR/TrainingPPG/Happy/joy_1.txt'); 
    % ppgData = load(filename); 
    emotions = {'Happy','Normal', 'Sad', 'Stress'};
    ppgData = csvread(filename, 10, 0);
    ppg_signal_test = ppgData(:, 2);
    testFeatures = extractFeatures(ppg_signal_test);
    % Make predictions on the test features
    testPredictions = predict(model, testFeatures);
    
    % Convert the categorical predictions to numerical labels
    testPredictions = double(testPredictions);  % Subtract 1 to match the original label indices
    disp(emotions{testPredictions});
    finalDecision = emotions{testPredictions};
end


% Define the feature extraction function
function features = extractFeatures(signal)
    % Extract features from the ppg signal
    meanValue = mean(signal);
    stdValue = std(signal);
    
    % Store the features in a row vector
    features = [meanValue, stdValue];
end