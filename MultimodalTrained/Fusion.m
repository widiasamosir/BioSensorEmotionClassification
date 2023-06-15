ecgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-14_18.24.43_ECG_LARA/Multimodal_Session1_Shimmer__Calibrated_PC.csv';
emgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-14_18.25.58_EMG/Multimodal_Session2_Shimmer_69B4_Calibrated_PC.csv';
gsr_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-08_10.27.24_GSR/default_exp_Session3_Shimmer_6295_Calibrated_PC.csv';
ppg_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-08_10.27.24_PPG/default_exp_Session3_Shimmer_6295_Calibrated_PC.csv';

% ecgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-14_18.24.43_ECG_LARA/Multimodal_Session2_Shimmer_69B4_Calibrated_PC.csv';
% emgFilename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-14_18.25.58_EMG/Multimodal_Session2_Shimmer__Calibrated_PC.csv';
% gsr_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-08_10.27.24_GSR/default_exp_Session2_Shimmer_6295_Calibrated_PC.csv';
% ppg_filename = '/Users/user0329/Documents/Angel/Biometrics/Analysis/MultimodalTrained/Testing_Data/2023-06-08_10.27.24_PPG/default_exp_Session2_Shimmer_6295_Calibrated_PC.csv';
ecgFinalDecision = Test_ECG(ecgFilename);
% fprintf('ECG Final Decision= %s \n', ecgFinalDecision);
emgFinalDecision = Test_EMG(emgFilename);
% fprintf('EMG Final Decision= %s \n', emgFinalDecision);

gsrFinalDecision = Test_GSR(gsr_filename);
ppgFinalDecision = Test_PPG(ppg_filename);

fusionDecision = ((1.5*convertStringToBioValue(ecgFinalDecision))+(1*convertStringToBioValue(emgFinalDecision))+(0.75*convertStringToBioValue(ppgFinalDecision))+(0.75*convertStringToBioValue(gsrFinalDecision)))/4;
fusionDecision = fusionDecision -0.5;
fprintf('Final Decision= %f \n', fusionDecision);

if(fusionDecision <= 1.5)
    fprintf('Emotion : Happy \n')
elseif fusionDecision > 1.5 &&  fusionDecision <= 2
    fprintf('Emotion : Normal \n')
elseif fusionDecision > 2 &&  fusionDecision <= 3
    fprintf('Emotion : Sad \n')
elseif fusionDecision > 3 &&  fusionDecision <= 4
    fprintf('Emotion : Stress \n')
end

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