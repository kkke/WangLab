function Trial = sa_training_bpod(SessionData)
for i = 1:length(SessionData.RawEvents.Trial)
    Events = SessionData.RawEvents.Trial{i}.Events;
    Trial(i).audio_On = Events.HiFi1_1;
    
    if isfield(Events, 'Port2In')
        leftLever_on  = Events.Port2In;
        leftLever_off = Events.Port2Out;
        on_diff = diff(leftLever_on);
        notartifacts = find(on_diff > 0.1);
        realSig =[];
        if ~isempty(notartifacts)
            realSig = [leftLever_on(1), leftLever_on(notartifacts + 1)];
        else
            realSig = leftLever_on(1);
        end
        
        
%         leftLever_onReal = leftLever_on(notartifacts);
%         leftLever = [leftLever_on, leftLever_off];
%         [B, I] = sort(leftLever);
%         B_diff = diff(B);
%         transition = [];
%         iter = 1;
%         artifacts = find(B_diff< 0.020);
%         artifacts_real = I(artifacts + 1);
%         leftLever(artifacts_real) = [];
%         
%         if length(leftLever_on) > length(leftLever_off)
%             leftLever_on(end) = [];
%         elseif length(leftLever_on) < length(leftLever_off)
%             leftLever_off(end) = [];
%         end
%         left_lever_duraiton = leftLever_off-leftLever_on;
%         left_signal = find(left_lever_duraiton > 0.02);
        Trial(i).leftLever_on = realSig;
        if length(leftLever_on) == length(leftLever_off)
            Trial(i).leftPress_raw = [leftLever_on; leftLever_off];
        end
%         Trial(i).leftLever_off = leftLever_off(left_signal);
    else
        Trial(i).leftLever_on = [];
%         Trial(i).leftLever_off= [];
    end
    
    if isfield(Events, 'Port3In')
        rightLever_on  = Events.Port3In;
        rightLever_off = Events.Port3Out;
        on_diff = diff(rightLever_on);
        notartifacts = find(on_diff > 0.1);
        realSig =[];
        if ~isempty(notartifacts)
            realSig = [rightLever_on(1), rightLever_on(notartifacts + 1)];
        else
            realSig = rightLever_on(1);
        end
       Trial(i).rightLever_on = realSig;
       if length(rightLever_on) == length(rightLever_off)
           Trial(i).rightPress_raw = [rightLever_on; rightLever_off];
       end
%         right_lever_duraiton = rightLever_off-rightLever_on;
%         right_signal = find(right_lever_duraiton > 0.02);
%         Trial(i).rightLever_on = rightLever_on(right_signal);
%         Trial(i).rightLever_off = rightLever_off(right_signal);
    else
        Trial(i).rightLever_on = [];
%         Trial(i).rightLever_off= [];
    end    
    States = SessionData.RawEvents.Trial{i}.States;
    Trial(i).visual = States.WaitForLeverPress;
    Trial(i).leftCount = length(Trial(i).leftLever_on);
    Trial(i).rightCount = length(Trial(i).rightLever_on);
end