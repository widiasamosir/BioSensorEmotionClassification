ecgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/ECG_1/Multimodal_Session2_Shimmer_69B4_Calibrated_PC.csv';
emgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/EMG_1/Multimodal_Session2_Shimmer__Calibrated_PC.csv';
gsr_ppg_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/GSRPPG_1/default_exp_Session2_Shimmer_6295_Calibrated_PC.csv';

% ecgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/ECG_2/Multimodal_Session1_Shimmer__Calibrated_PC.csv';
% emgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/EMG_2/Multimodal_Session2_Shimmer_69B4_Calibrated_PC.csv';
% gsr_ppg_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/Multimodal/TestingData/GSRPPG_2/default_exp_Session3_Shimmer_6295_Calibrated_PC.csv';

ecgFinalDecision = ECG_FinalDecision(ecgFilename);
fprintf('ECG Final Decision= %s \n', ecgFinalDecision);

emgFinalDecision = EMG_FinalDecision(emgFilename);
fprintf('EMG Final Decision= %s \n', emgFinalDecision);

gsrPpgFinalDecision = GSR_PPG_FinalDecision(gsr_ppg_filename);
fprintf('GSR and PPG Final Decision= %s \n', gsrPpgFinalDecision);

fusionDecision = ((1.5*convertStringToBioValue(ecgFinalDecision))+(0.5*convertStringToBioValue(emgFinalDecision))+(1.5*convertStringToBioValue(gsrPpgFinalDecision)))/3;
fprintf('Final Decision= %f \n', fusionDecision);
fprintf('Based on weighted average= ')
if(fusionDecision > 0 &&  fusionDecision <= 1.5)
    fprintf('Emotion : Happy \n');
elseif fusionDecision > 1.5 &&  fusionDecision <= 2
    fprintf('Emotion : Normal \n');
elseif fusionDecision > 2 &&  fusionDecision <= 3
    fprintf('Emotion : Sad \n');
elseif fusionDecision > 3 &&  fusionDecision <= 4
    fprintf('Emotion : Stress \n');
end

fprintf('Based on Arousal Valence Mapping= ')
finalDes = setAverage(ecgFinalDecision,emgFinalDecision,gsrPpgFinalDecision);

function converted = convertStringToBioValue(value)
    if(contains(value, 'Happy'))
        converted = 1;
    elseif(contains(value, 'Normal'))
        converted = 2;
    elseif(contains(value, 'Sad'))
        converted = 3;
    else contains(value, 'Stress')
        converted = 4;
    end
end

function response = mappingByArousalValence(response)
    % array = [1, 1; 0, 1; 0, 0; 1, 0];
    result = [];
    happy = [1,1];
    normal = [0,1];
    sad = [0,0];
    stress = [1,0];
    if(contains(response,'Happy'))
        response = happy;
    elseif(contains(response,'Normal'))
        response = normal;
    elseif(contains(response,'Sad'))
        response = sad;
    elseif(contains(response,'Stress'))
        response = stress;
    end
end

function finalDes = setAverage(ecg,emg,gsrppg)
    ecgRes = mappingByArousalValence(ecg);
    emgRes = mappingByArousalValence(emg);
    gsrppgRes = mappingByArousalValence(gsrppg);

    % Extracting the Arousal column
    arousal = [ecgRes(:, 1),emgRes(:, 1),gsrppgRes(:, 1)];
    valence = [ecgRes(:, 2),emgRes(:, 2),gsrppgRes(:, 2)];
    % Finding the most frequent value
    mostA = mode(arousal);
    mostV = mode(valence);
    if(mostA == 1 && mostV == 1)
        finalDes = 'Happy'
    elseif(mostA == 0 && mostV == 1)
        finalDes = 'Normal'
    elseif(mostA == 0 && mostV == 0)
        finalDes = 'Sad'
    else
        finalDes = 'Stress'
    end

end