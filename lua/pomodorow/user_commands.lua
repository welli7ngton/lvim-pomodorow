local M = {}

M.setup = function()
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

  vim.api.nvim_create_user_command('PomodoroToggleTimeVisibility',
    function()
      require('pomodorow').toggle_time_visibility()
    end,
    {}
  )

  vim.api.nvim_create_user_command('PomodoroSetWorkAndBreak',
    function()
      require('pomodorow').set_work_and_break()
    end,
    {}
  )
end

return M
