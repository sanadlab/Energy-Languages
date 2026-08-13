def slowest_key(release_times, keys_pressed)
    best = keys_pressed[0]
    best_dur = release_times[0]
    (1...release_times.length).each do |i|
        dur = release_times[i] - release_times[i - 1]
        if dur > best_dur || (dur == best_dur && keys_pressed[i] > best)
            best_dur = dur
            best = keys_pressed[i]
        end
    end
    best
end
