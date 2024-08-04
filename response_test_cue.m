function stats = response_test_cue(psth, baseline, post)

spike = psth.scmatrix;
baseWindows = find(psth.timepoint > baseline & psth.timepoint < 0); 
postWindows = find(psth.timepoint > 0 & psth.timepoint < post); % use two consecutive bins, each bin is 50 ms
n_consecutive = length(postWindows);
%stats parameter
alpha_value = 0.05;
adj_alpha = 1 - (1-alpha_value)^(1/n_consecutive);

baseline_activity = spike(:, baseWindows);

for i = 1:n_consecutive
    evoke_activity = spike(:, postWindows(i));
    [p(i), h(i)] = ranksum(baseline_activity(:), evoke_activity);
   
    if mean(evoke_activity)> mean(baseline_activity(:))
        sign(i) = 1;
    elseif mean(evoke_activity)< mean(baseline_activity(:))
        sign(i)   = -1;
    else
        sign(i) = 0;
        warning('Evoked responses are the same the spontaneous')
    end
end
significant = find(p < adj_alpha);
if isempty(significant)
    resp = 0;
    resp_sign = 0;
else
    resp = 1;
    resp_sign = sign(significant(1)); % choose the first significant response to define the sign
end
stats.p = p;
stats.sign = sign;
stats.resp = resp;
stats.resp_sign = resp_sign;