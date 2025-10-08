# Установка Nushell с нуля на MacOS Tahoe

1. Установка VS Code

    https://code.visualstudio.com

1. Установка Homebrew

    Открываем https://brew.sh, копируем команду установки.
    Открываем Terminal, вставляем команду, нажимаем Enter.

    После выполнения копируем команды, которые предоставил Homebrew (добавление в PATH), вставляем в терминал, выполняем.

```bash
    # Проверяем корректность установки
    brew doctor
```

1. Установка Nushell

```bash
    # Смотрим информацию о пакете
    brew info nushell

    # Устанавливаем nushell
    brew install nushell

    # Запускаем nushell
    nu
```

1. Настройка XDG_CONFIG_HOME

    Проверяем текущий путь конфигурации:

```nushell
    # Показывает путь к директории конфигурации
    $nu.default-config-dir
```

    Если путь содержит пробелы, исправляем:

```nushell
    # Запускаем nu без сохранения истории
    nu --no-history

    # Создаём директорию .config
    mkdir ~/.config

    # Перемещаем конфигурацию в новое место
    mv $nu.default-config-dir ~/.config/

    # Создаём символическую ссылку
    ln -s ~/.config/nushell ($nu.default-config-dir | path split | drop | path join)

    # Выходим из nushell
    exit
```

    Добавляем переменную окружения XDG_CONFIG_HOME:

```bash
    # Открываем конфигурацию zsh в VS Code
    code ~/.zshrc
```

    Если команда `code` не найдена: открываем VS Code, нажимаем `Cmd+Shift+P`, вводим `install path`, выбираем команду установки, нажимаем Enter. Затем повторяем `code ~/.zshrc` в терминале.

    В открывшемся файле добавляем строку:

    `export XDG_CONFIG_HOME="$HOME/.config"`

```bash
    # Применяем изменения
    source ~/.zshrc

    # Проверяем, что переменная установлена
    echo $XDG_CONFIG_HOME
```

```nushell
    # Запускаем nushell снова
    nu

    # Проверяем, что новый путь не содержит пробелов
    $nu.default-config-dir
```

1. Базовые настройки

```nushell
    # Открываем конфигурационный файл
    config nu
```

1. Инициализация git-репозитория

```bash
    # Переходим в директорию конфигурации
    cd ~/.config/

    # Инициализируем git
    git init

    # Добавляем файлы
    git add nushell/config.nu nushell/env.nu

    # Создаём первый коммит
    git commit -m "Initial nushell configuration"
```
