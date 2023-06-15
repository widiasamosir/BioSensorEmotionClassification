
function finalDecision = GSR_PPG_FinalDecision(filename)
    data = csvread(filename,4,0);
    time = data(:, 1);
    gsr_conductance = data(:,2);
    pulse_amplitude = data(:, 3);
    heartbeat = data(:, 4);
    
    trendSkinConductance = classifyConductance(gsr_conductance);
    
    if(contains(trendSkinConductance, 'Decreased'))
        amplitudeTrend = checkPulseAmplitudeTrend(pulse_amplitude);
        if(contains(amplitudeTrend, 'Increased'))
            % fprintf('Happy \n');
            finalDecision = 'Happy';
        else
            % fprintf('Normal \n');
            finalDecision = 'Normal';
        end
    else 
        pulseRate = checkPulseRate(heartbeat);
        if(contains(pulseRate, 'Increased'))
            % fprintf('Stress \n');
            finalDecision = 'Stress';
        else
            % fprintf('Sad \n');
            finalDecision = 'Sad';
        end
    end

end


function amplitudeTrend = checkPulseAmplitudeTrend(pulse_amplitude)
    
    % Determine the change in pulse amplitude between consecutive samples
    pulse_amp_diff = diff(pulse_amplitude);
    
    % Calculate the average change in pulse amplitude
    average_change = mean(pulse_amp_diff);
    
    if average_change > -0.01
        amplitudeTrend = 'Increased';
    elseif average_change < -0.01
        amplitudeTrend = 'Decreased/Consistent';
    end
end

function isTrend = classifyConductance(gsr_conductance)
    % Determine the change in conductance between consecutive samples
    conductance_diff = diff(gsr_conductance);
    
    % Calculate the average change in conductance
    average_change = mean(conductance_diff);
    % disp(['The pulse amplitude trend is: ' num2str(average_change)]);
    % Classify the conductance trend
    if average_change > 0
        isTrend = 'Increased';
    elseif average_change < 0
        isTrend = 'Decreased';
    else
        isTrend = 'Stable';
    end
end

function pulseRate = checkPulseRate(heartBeat)
    % Determine the change in HR between consecutive samples
    HR_diff = diff(heartBeat);
    
    % Calculate the average change in HR
    average_change = mean(HR_diff);
    
    % Classify the HR trend
    if average_change > 0
        pulseRate = 'Increased';
    elseif average_change < 0
        pulseRate = 'Decreased';
    else
        pulseRate = 'Stable';
    end

end