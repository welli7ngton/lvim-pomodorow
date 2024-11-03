local config = require("src.config")

local M = {}

local timer = nil

local work_time = config.work_time or (25 * 60)
local break_time = config.break_time or (5 * 60)
local in_break = false

function M.start_timer()
  if timer then
    print("Timmer is running")
    return
  end

  timer = vim.loop.new_timer()
  local remaining_time = in_break or break_time or work_time

  timer:start(0, 1000, vim.schedule_wrap(function()
    remaining_time = remaining_time - 1
    local mins = math.floor(remaining_time / 60)
    local secs = remaining_time % 60

    vim.cmd("echo 'Tempo restante: " .. string.format("%02d:%02d", mins, secs) .. "'")

    if timer and remaining_time <= 0 then
      timer:stop()
      timer:close()
      timer = nil

      in_break = not in_break
      if in_break then
        vim.echo("Break time!")
        vim.notify("Break time!", vim.log.levels.INFO)
      else
        vim.echo("Work time!")
        vim.notify("Work time!", vim.log.levels.INFO)
      end
    end
    M.start_timer()
  end))
end

function M.stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
    print("Timmer stopped")
  else
    print("Timmer is not running")
  end
end

vim.api.nvim_create_user_command('StartPomodoro',
  function()
    require('src.init').start_timer()
  end,
  {}
)

vim.api.nvim_create_user_command('StopPomodoro',
  function()
    require('src.init').stop_timer()
  end,
  {}
)

return M
