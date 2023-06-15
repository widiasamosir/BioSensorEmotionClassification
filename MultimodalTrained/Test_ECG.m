function finalDecision = Test_ECG(filename)
    % Load the trained SVM model
    load('modelECG.mat'); % Replace 'trainedModel.mat' with the actual file name of your trained model
    
    % Load the ECG data for testing
    % ecgData = load('/Users/user0329/Documents/Angel/Biometrics/Analysis/ECG/Training_data/testingdata1/mm_1_stress_Session1_Shimmer_69B4_Calibrated_PC.dat'); % Replace 'LA_RA_test.dat' with the actual file name of your test data
    % ecgData = load(filename); % Replace 'LA_RA_test.dat' with the actual file name of your test data
    emotions = {'Happy','Normal', 'Sad', 'Stress'};
    ecgData = csvread(filename, 10, 0);
    ecg_signal_test = ecgData(:, 2);
    % Extract features from the preprocessed ECG data
    % Use the same feature extraction method as during training
    % features = calculateHRVFeatures(ecgData(:,2)'); % Replace 'extractFeatures' with your own feature extraction function
    features = calculateHRVFeatures(ecg_signal_test);
    % Use the trained model to predict emotion labels for the extracted features
    predictedLabels = predict(svmModel, features);
    
    % Display the predicted emotion labels
    
    disp(emotions{predictedLabels});
    finalDecision = emotions{predictedLabels};
end



% Function to calculate RR intervals from ECG signal
function rrIntervals = calculateRRIntervals(ecgSignal)
    % Implement your RR interval calculation algorithm here
    % This function should take the ECG signal as input and return the calculated RR intervals
    
    % Example code to calculate RR intervals from ECG signal using peak detection
    [~,locs] = findpeaks(ecgSignal);
    rrIntervals = diff(locs);
end

% Function to calculate HRV features
function hrvFeatures = calculateHRVFeatures(rrIntervals)
    % Implement your HRV feature extraction algorithm here
    % This function should take the RR intervals as input and return the extracted features
    
    % Example code to calculate HRV features using time-domain analysis
    hrvFeatures = [mean(rrIntervals), std(rrIntervals), rms(rrIntervals)];
end

