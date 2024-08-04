i = 18
figure; plot(groupdata(i).time, groupdata(i).raw_signal)
hold on
plot(groupdata(i).time, groupdata(i).raw_reference)
xlim([100, 300])
plot([groupdata(i).infusion, groupdata(i).infusion], [0, 1],'k')
xlim([100, 600])
if isempty(groupdata(i).front)
else
    plot([groupdata(i).front, groupdata(i).front], [0, 1],'c')
end
if isempty(groupdata(i).back)
else
    plot([groupdata(i).back, groupdata(i).back], [0, 1],'m')
end
plot([groupdata(i).leverInsertion, groupdata(i).leverInsertion], [0, 1],'r')
plot([groupdata(i).leverRetraction, groupdata(i).leverRetraction], [0, 1],'y')
plot([groupdata(i).infusion, groupdata(i).infusion], [0, 1],'k')
xlim([100, 200])
ylabel('Voltage (V)')
xlabel('Time (s)')

figure; plot(groupdata(i).time, groupdata(i).signal)
hold on
xlim([100, 300])
plot([groupdata(i).infusion, groupdata(i).infusion], [0, 1],'k')
xlim([100, 600])
if isempty(groupdata(i).front)
else
    plot([groupdata(i).front, groupdata(i).front], [0, 1],'c')
end
if isempty(groupdata(i).back)
else
    plot([groupdata(i).back, groupdata(i).back], [0, 1],'m')
end
plot([groupdata(i).leverInsertion, groupdata(i).leverInsertion], [0, 1],'r')
plot([groupdata(i).leverRetraction, groupdata(i).leverRetraction], [0, 1],'y')
plot([groupdata(i).infusion, groupdata(i).infusion], [0, 1],'k')
xlim([100, 200])
ylabel('Z-Score')
xlabel('Time (s)')
