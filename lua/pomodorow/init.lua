local utils = require("pomodorow.utils")
local commands = require("pomodorow.user_commands")
local kind = require("pomodorow.kind")

commands.setup()

local M = {}

local timer = nil

M.status = ''

M.in_break = false

M.visible_remaining_time = true

M.work_time = 25 * 60
M.break_time = 5 * 60
M.remaining_time = M.work_time

function M.setup(work_time, break_time)
  M.work_time = (work_time and work_time * 60) or M.work_time
  M.break_time = (break_time and break_time * 60) or M.break_time
  M.remaining_time = M.work_time
end

function M.start_timer()
  if timer then
    vim.notify("O timer está em execução" .. kind.icons.execution, vim.log.levels.INFO)
    return
  end

  timer = vim.loop.new_timer()

  timer:start(0, 1000, vim.schedule_wrap(function()
    M.remaining_time = M.remaining_time - 1
    local mins, secs = utils.get_minutes_and_seconds(M.remaining_time)

    if M.in_break then
      M.status = '(break)'
    else
      M.status = '(work)'
    end

    if M.visible_remaining_time then
      vim.notify("Tempo restante" .. M.status .. ":" .. mins .. ":" .. secs, vim.log.levels.INFO)
    end

    if M.remaining_time <= 0 then
      if M.in_break then
        vim.notify("Tempo de trabalho iniciado!" .. kind.icons.screen, vim.log.levels.INFO)
        M.in_break = false
        M.remaining_time = M.work_time
      else
        vim.notify("Tempo de descanso iniciado!" .. kind.icons.start, vim.log.levels.INFO)
        M.in_break = true
        M.remaining_time = M.break_time
      end
    end
  end))
end

function M.stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
    M.remaining_time = M.work_time
    M.in_break = false
    vim.notify("Timer parado" .. kind.icons.stop, vim.log.levels.INFO)
  else
    vim.notify("O timer não está em execução" .. kind.icons.pause, vim.log.levels.INFO)
  end
end

function M.show_timer()
  if timer then
    local mins, secs = utils.get_minutes_and_seconds(M.remaining_time)
    vim.notify("Tempo restante: " .. kind.icons.clock .. mins .. ":" .. secs, vim.log.levels.INFO)
  else
    vim.notify("Nenhum timer está em execução" .. kind.icons.execution, vim.log.levels.INFO)
  end
end

function M.toggle_time_visibility()
  M.visible_remaining_time = not M.visible_remaining_time
end

function M.set_work_and_break()
  M.stop_timer()
  vim.ui.input({ prompt = "Insira o tempo de trabalho (em minutos): " }, function(work_input)
    if work_input then
      M.work_time = tonumber(work_input) * 60
    end
    vim.ui.input({ prompt = "Insira o tempo de descanso (em minutos): " }, function(break_input)
      if break_input then
        M.break_time = tonumber(break_input) * 60
      end
      M.remaining_time = M.work_time
      M.start_timer()
    end)
  end)
end

return M
