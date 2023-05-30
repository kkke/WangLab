function [rising_time, falling_time] = detectEdges(signal, time)
    % Detect the rising and falling edges of a TTL signal
    % Initialize variables
    risingEdges = [];
    fallingEdges = [];
    prevValue = signal(1);
    
    % Loop through the signal
    for i = 2:length(signal)
        % Check for rising edge
        if signal(i) > prevValue
            risingEdges = [risingEdges i];
        end
        
        % Check for falling edge
        if signal(i) < prevValue
            fallingEdges = [fallingEdges i];
        end
        
        % Update previous value
        prevValue = signal(i);
    end
    rising_time = time(risingEdges);
    falling_time = time(fallingEdges);

end