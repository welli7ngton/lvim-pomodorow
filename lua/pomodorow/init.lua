local utils = require("pomodorow.utils")
local commands = require("pomodorow.user_commands")

commands.setup()

local M = {}

local timer = nil

M.in_break = false

M.remaining_time = M.work_time

M.visible_remaining_time = false

function M.setup(work_time, break_time)
  M.work_time = (work_time * 60) or (25 * 60)
  M.break_time = (break_time * 60) or (5 * 60)
end

function M.start_timer()
  if timer then
    vim.notify("Timer is running", vim.log.levels.INFO)
    return
  end

  M.remaining_time = M.in_break and M.break_time or M.work_time

  timer = vim.loop.new_timer()

  timer:start(0, 1000, vim.schedule_wrap(function()
    M.remaining_time = M.remaining_time - 1
    local mins, secs = utils.get_minutes_and_seconds(M.remaining_time)

    if M.visible_remaining_time then
      vim.notify("Remaining time: " .. mins .. ":" .. secs, vim.log.levels.INFO)
    end

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

function M.toggle_time_visibility()
  M.visible_remaining_time = not M.visible_remaining_time
end

function M.set_work_and_break()
  M.stop_timer()
  vim.ui.input({ prompt = "Enter work time (in minutes): " }, function(input)
    M.work_time = tonumber(input) * 60
  end)
  vim.ui.input({ prompt = "Enter break time (in minutes): " }, function(input)
    M.break_time = tonumber(input) * 60
  end)
  M.start_timer()
end

return M
