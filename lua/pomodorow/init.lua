local config = require("pomodorow.config")
local utils = require("pomodorow.utils")

local M = {}

local timer = nil

M.work_time = config.work_time or (25 * 60)
M.break_time = config.break_time or (5 * 60)
M.in_break = false

M.remaining_time = M.work_time

function M.start_timer()
  if timer then
    vim.notify("Timer is running plever", vim.log.levels.INFO)
    return
  end

  M.remaining_time = M.in_break and M.break_time or M.work_time

  timer = vim.loop.new_timer()

  timer:start(0, 1000, vim.schedule_wrap(function()
    M.remaining_time = M.remaining_time - 1
    local mins, secs = utils.get_minutes_and_seconds(M.remaining_time)

    -- vim.notify("echo 'tempo restante: " .. string.format("%02d:%02d", mins, secs) .. "'")
    if timer and M.remaining_time <= 0 then
      timer:stop()
      timer:close()
      timer = nil

      M.in_break = not M.in_break
      if M.in_break then
        vim.notify("Break time!", vim.log.levels.INFO)
      else
        vim.notify("Work time!", vim.log.levels.INFO)
      end
    end
  end))
end

function M.stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
    vim.notify("Timer stopped", vim.log.levels.INFO)
  else
    vim.notify("Timer is not running", vim.log.levels.INFO)
  end
end

function M.show_timer()
  if timer then
    local mins, secs = utils.get_minutes_and_seconds(M.remaining_time)
    vim.notify("Remaining time: " .. mins .. ":" .. secs, vim.log.levels.INFO)
  else
    vim.notify("No timer is running", vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command('PomodoroStart',
  function()
    require('pomodorow').start_timer()
  end,
  {}
)

vim.api.nvim_create_user_command('PomodoroStop',
  function()
    require('pomodorow').stop_timer()
  end,
  {}
)

vim.api.nvim_create_user_command('PomodoroReamainingTime',
  function()
    require('pomodorow').show_timer()
  end,
  {}
)

return M
