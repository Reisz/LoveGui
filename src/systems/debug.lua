local debug = {}

function debug.info(m)
  print("INFO: " .. m)
end

function debug.warn(m)
  print("WARN: " .. m)
end

function debug.error(m)
  print("ERROR: " .. m)
end

function debug.fatal(m)
  print("FATAL: " .. m)
end

return debug
