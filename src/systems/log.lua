local log = {}
log.print = print

function log.info(m)
  log.print("INFO: " .. m)
end

function log.warn(m)
  log.print("WARN: " .. m)
end

function log.error(m)
  log.print("ERROR: " .. m)
end

function log.fatal(m)
  log.print("FATAL: " .. m)
end

return log
