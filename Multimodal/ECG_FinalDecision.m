function finalDecision = ECG_FinalDecision(filename)
    data=csvread(filename,4,0);
    x = data(:, 1);
    ecgLA_RA = data(:, 2);
    ecgHB = data(:,3);
    sdnnValue = getHRVECG(ecgLA_RA);
    % fprintf('Rhythm Value = %.3f \n', sdnnValue)
    if(sdnnValue < 0.13)
        rhythmValue = checkRhythm(ecgLA_RA);
        if(contains(rhythmValue, 'Regular'))
            % fprintf('Sad \n');
            finalDecision = 'Sad';
        else
            % fprintf('Stress \n');
            finalDecision = 'Stress';
        end
    else 
        heartbeatValue = checkHeartBeat(ecgHB);
        if(heartbeatValue>70)
            % fprintf('Happy \n');
            finalDecision = 'Happy';
        else
            % fprintf('Normal \n');
            finalDecision = 'Normal';
        end
    end
end
function valueSDNN = getHRVECG(ecgLA_RA)
    fs = 2000;

    % Pan-Tompkins R-wave detection algorithm
    [~,locs_Rwave] = findpeaks(ecgLA_RA, 'MinPeakHeight', mean(ecgLA_RA), 'MinPeakDistance', fs/2);
    
    % Calculate R-R intervals
    RR_intervals = diff(locs_Rwave) / fs;   % Convert peak indices to time intervals
    
    % Calculate HRV parameters
    valueSDNN = std(RR_intervals);                 % Standard deviation of normal-to-normal intervals
end

function rhythmValue = checkRhythm(ecgLA_RA)
    fs = 2000;
    % Apply a bandpass filter to remove noise and unwanted frequency components (optional but recommended)
    fcLow = 0.5;  % Lower cutoff frequency (in Hz)
    fcHigh = 40;  % Upper cutoff frequency (in Hz)
    [b, a] = butter(2, [fcLow fcHigh] / (fs/2), 'bandpass');
    filteredECG = filtfilt(b, a, ecgLA_RA);
    
    % Calculate the mean R-R interval
    [Rpeaks, ~] = findpeaks(filteredECG, 'MinPeakHeight', mean(filteredECG), 'MinPeakDistance', fs/2);
    RR_intervals = diff(Rpeaks) / fs;
    meanRR = mean(RR_intervals);
    
    % Set a threshold to determine the tolerance for irregularity
    tolerance = 0.0001;  % Adjust this value as per your requirements
    
    % Classify the rhythm as regular or abnormal
    if max(abs(RR_intervals - meanRR)) <= tolerance
        rhythmValue = 'Regular';
    else
        rhythmValue = 'Abnormal';
    end
end

function heartbeatValue = checkHeartBeat(ecgHB)
    average_HR = mean(ecgHB);
    heartbeatValue = average_HR;
end

