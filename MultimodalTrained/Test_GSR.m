function finalDecision = Test_GSR(filename)
    % Load the trained SVM model
    load('modelGSR.mat'); % Replace 'trainedModel.mat' with the actual file name of your trained model
    
    % Load the GSR data for testing
    % gsrData = load('/Users/user0329/Documents/Angel/Biometrics/Analysis/GSR/SVM_Method_Training_data_GSR/Happy/GSRdata_s1p2v1.dat');
    % gsrData = load(filename);
    emotions = {'Happy','Normal', 'Sad', 'Stress'};
    gsrData = csvread(filename, 10, 0);
    gsr_signal_test = gsrData(:, 2);
    features = extractFeatures(gsr_signal_test); 
    
    % Use the trained model to predict emotion labels for the extracted features
    predictedLabels = predict(adaModel, features);
    
    % Display the predicted emotion labels
    disp(emotions{predictedLabels});
    finalDecision = emotions{predictedLabels};
end


% Define the feature extraction function
function features = extractFeatures(signal)
    % Extract features from the GSR signal
    meanValue = mean(signal);
    stdValue = std(signal);
    
    % Store the features in a row vector
    features = [meanValue, stdValue];
end