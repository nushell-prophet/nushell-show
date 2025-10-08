# Установка Nushell с нуля на MacOS Tahoe

## Установка VS Code

https://code.visualstudio.com

## Установка Homebrew

Открываем https://brew.sh, копируем команду установки.
Открываем Terminal, вставляем команду, нажимаем Enter.

После выполнения копируем команды, которые предоставил Homebrew (добавление в PATH), вставляем в терминал, выполняем.

```bash
# Проверяем корректность установки
brew doctor
```

## Установка Nushell

```bash
# Смотрим информацию о пакете
brew info nushell

# Устанавливаем nushell
brew install nushell

# Запускаем nushell
nu
```

## Подготовка к использованию XDG_CONFIG_HOME

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

# Проверяем, что у нас появилась папка
ls ~/.config/nushell

# Создаём символическую ссылку
ln -s ~/.config/nushell ($nu.default-config-dir | path split | drop | path join)

# Проверяем, что символическая ссылка работает
ls $nu.default-config-dir
```

Закрываем вкладку терминала, открываем новую вкладку с zsh.

## Настройка XDG_CONFIG_HOME

Добавляем переменную окружения в конфигурацию zsh (будет устанавливаться при каждом запуске терминала):

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

## Инициализация git-репозитория

```bash
# Переходим в директорию конфигурации
cd ~/.config/

# Инициализируем git
git init

# Добавляем файлы
git add nushell/config.nu nushell/env.nu

# Создаём первый коммит
git commit -m "Initial nushell configuration"

# Задаём имя пользователя и почту
git config --global user.name "Maxim Uvarov"
git config --global user.email "nushell-prophet-demo@users.noreply.github.com"

# Редактируем автора последнего коммита
git commit --amend --reset-author
```

## Базовые настройки

```nushell
# Открываем файл переменных окружения
config env
```

Если переменная `$env.EDITOR` не задана, добавляем в файл:

`$env.EDITOR = "code"`

Сохраняем и перезапускаем nushell:

```nushell
nu

# Открываем основной конфигурационный файл
config nu
```

Добавляем настройки истории и баннера:

```nushell
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.show_banner = false
```

Сохраняем, перезапускаем nushell и коммитим изменения:

```nushell
nu
cd ~/.config/

# Смотрим что изменилось
git status

# Добавляем наши изменения
git add nushell/config.nu nushell/env.nu
git commit -m "first settings"

# Проверяем ещё раз
git status
```

Видим, что остались файлы истории. Создаём `.gitignore`:

```bash
# Открываем .gitignore в редакторе
code .gitignore
```

Добавляем туда строку: `nushell/history*`

Сохраняем и коммитим:

```nushell
# Проверяем, что файлы истории больше не показываются
git status

# Добавляем .gitignore
git add .gitignore
git commit -m "Add history files to gitignore"
```
