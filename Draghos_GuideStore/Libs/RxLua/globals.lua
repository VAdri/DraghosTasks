wipe = wipe or function(table) for key, _ in pairs(table) do table[key] = nil; end end

time = time or os.time;
