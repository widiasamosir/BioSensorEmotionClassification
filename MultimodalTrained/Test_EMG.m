function finalDecision = Test_EMG(filename)
    % Load the trained model
    load('modelEMG.mat');
    
    % Read and preprocess the new EMG data from the CSV file
    % data_test = csvread('/Users/user0329/Documents/Angel/Biometrics/Analysis/EMG/Happy/emg_2_happy_Session6_Shimmer_69B4_Calibrated_PC.csv', 10, 0);
    data_test = csvread(filename, 10, 0);
    time_test = data_test(:, 1);
    emg_signal_test = data_test(:, 2);
    
    % Apply the feature extraction process to the new EMG data
    windowSize = 1000; % Define the window size (should match the training window size)
    numWindows_test = floor(length(emg_signal_test) / windowSize);
    features_test = zeros(numWindows_test, 2); % Placeholder for features (adjust as needed)
    for i = 1:numWindows_test
        segment_test = emg_signal_test((i-1)*windowSize+1:i*windowSize);
        features_test(i, 1) = mean(segment_test);
        features_test(i, 2) = var(segment_test);
        % Add more feature extraction steps as necessary
    end
    
    % Classify the emotions using the trained model
    predictions_test = predict(model, features_test);
    
    % Mapping predicted labels to corresponding emotions
    emotions = {'Happy', 'Sad', 'Stress', 'Normal'};
    predicted_emotions = emotions(predictions_test);
    
    emotion_counts = countcats(categorical(predicted_emotions));  % Count the occurrences of each emotion
    [~, idx] = max(emotion_counts);  % Find the index of the most frequent emotion
    most_frequent_emotion = predicted_emotions{idx};  % Set the most frequent emotion
    disp(most_frequent_emotion);

    finalDecision = most_frequent_emotion;

end


