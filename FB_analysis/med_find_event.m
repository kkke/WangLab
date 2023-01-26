function event = med_find_event(signal, time)
state = find(signal == 0); % the event of med associate is reverse; High (1) means off, and Low (0) means on.
if isempty(state)
    event = [];
else
    index = 1;
    for k = 2:length(state)
        if state(k)-state(k-1) > 1 % not consecutive means a new event. 
            index = [index, k];
        end
    end
    event = time(state(index));
end