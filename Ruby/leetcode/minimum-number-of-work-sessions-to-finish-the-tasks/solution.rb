def min_sessions(tasks, session_time)
    n = tasks.length
    full = (1 << n) - 1
    inf = 1 << 30
    sessions = Array.new(1 << n, inf)
    used = Array.new(1 << n, 0)
    sessions[0] = 1
    (0..full).each do |mask|
        next if sessions[mask] == inf
        (0...n).each do |i|
            next if mask & (1 << i) != 0
            nm = mask | (1 << i)
            if used[mask] + tasks[i] <= session_time
                ns = sessions[mask]
                nu = used[mask] + tasks[i]
            else
                ns = sessions[mask] + 1
                nu = tasks[i]
            end
            if ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm])
                sessions[nm] = ns
                used[nm] = nu
            end
        end
    end
    sessions[full]
end
