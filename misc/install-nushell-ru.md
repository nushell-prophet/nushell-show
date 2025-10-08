# Установка Nushell с 0 на MacOS Tahoe

Необходимые программы:

1. Установка VS Code

    https://code.visualstudio.com

1. Установка brew

    Открываем https://brew.sh, копируем команду
    Открываем terminal, вставляем команду, нажимаем enter

    После выполнения копируем команды, которые нам предоставил brew, вставляем в терминал, исполняем.

```bash
    # проверяем корректность установки
    brew doctor
```

1. Установка nushell

```bash
    brew info nushell
    brew install nushell
    nu
```

1. Настройка XDG_CONFIG_HOME

    Проверяем, что путь содержит пробел

```nushell
    $nu.default-config-dir
```

    Если содержит пробел то можно поправить следующим способом:

```nushell
    nu --no-history
    mkdir ~/.config
    mv $nu.default-config-dir ~/.config/
    ln -s ~/.config/nushell ($nu.default-config-dir | path split | drop | path join)
```

    Далее добавляем переменную окружения XDG_CONFIG_HOME 

```bash
    code ~/.zshrc
```

    Если мы видим ошибку, что команда `code` не найдена, то открываем VS Code, нажимаем `ctrl+shift+p`, вводим `install path`, находим команду, нажимаем enter, вводим пароль администратора. И потом в терминале повторяем команду `code ~/.zshrc`

    В открывшемся VS Code добавляем следующий код:

    `export XDG_CONFIG_HOME="$HOME/.config"`

```bash
    # применяем изменения
    source ~/.zshrc

    # проверяем что все применилось
    echo $XDG_CONFIG_HOME
```

```nushell
    # Запускаем nushell
    nu

    # Проверяем, что новый путь не содержит пробела
    $nu.default-config-dir
```
1. Базовые настройки
1. Инициализация git репозитория
