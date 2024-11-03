local M = {}

function M.get_minutes_and_seconds(remaining_time)
  local mins = math.floor(remaining_time / 60)
  local secs = remaining_time % 60
  return mins, secs
end

return M
