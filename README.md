# Pomodoro App para Lunarvim!

**lvim-pomodorow** é um plugin para o [LunarVim](https://github.com/LunarVim/LunarVim) que integra a técnica Pomodoro ao seu fluxo de trabalho no Neovim. Este plugin permite iniciar, pausar e parar sessões Pomodoro diretamente do editor, auxiliando na gestão eficiente do tempo.

## Instalação

Para instalar o lvim-pomodorow, adicione o seguinte trecho ao seu arquivo de configuração do LunarVim:

```lua
lvim.plugins = {
  {
    "welli7ngton/lvim-pomodorow",
    config = function()
      require("pomodorow").setup()
    end,
  },
}
```
Após adicionar o plugin, reinicie o LunarVim e execute :Lazy e aperte Ctrl+U/I para atualizar e instalar o plugin.

## Configuração

O lvim-pomodorow pode ser configurado através da função setup. Abaixo está um exemplo de configuração com os valores padrão:
```lua
require("pomodorow").setup(
  30,  -- Duração do período de trabalho em minutos
  5,   -- Duração do intervalo em minutos
)
```
Você pode ajustar os tempos de trabalho e intervalo conforme suas preferências e definir funções personalizadas para serem executadas no início de cada período.

## Uso
O lvim-pomodorow fornece os seguintes comandos para gerenciar suas sessões Pomodoro:

- ´PomodoroStart´: Inicia uma nova sessão Pomodoro.
- ´PomodoroStop´: Encerra a sessão atual.
- ´PomodoroRemainingTime´: Mostra o tempo atual.
- ´PomodoroToggleTimeVisibility´: Alterna entre mostrar sempre e não mostrar o tempo atual.
- ´PomodoroSetWorkAndBreak´: Adiciona um tempo personalizado para pausa e trabalho.
- ´PomodoroStart´:

## Além disso, você pode mapear teclas para facilitar o uso dos comandos. Por exemplo:


```vim
vim.api.nvim_set_keymap("n", "<leader>ps", ":PomodoroStart<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>pe", ":PomodoroStop<CR>", { noremap = true, silent = true })
```














