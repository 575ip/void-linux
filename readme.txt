1. Базовые пакеты

xbps-install -Su            # обновить систему
xbps-install sway seatd elogind dbus-x11 wayland-protocols xorg-server-xwayland foot alacritty grim slurp wl-clipboard

Эти пакеты дают сам Sway, управление сессией, dbus и базовые инструменты для работы в Wayland.
    
2. Сервисы для сессии
В Void используется runit, нужно включить несколько служб:
    
    ln -s /etc/sv/dbus   /var/service/
    ln -s /etc/sv/elogind /var/service/
    ln -s /etc/sv/seatd  /var/service/
    
3. Автозапуск Sway из tty
    Если хотите входить прямо в Sway после логина в консоли, добавьте в ~/.profile или ~/.bash_profile:
        

        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
          export XDG_RUNTIME_DIR=/run/user/$(id -u)
            mkdir -p "$XDG_RUNTIME_DIR"
              chmod 700 "$XDG_RUNTIME_DIR"
                exec sway
                   fi
                   
 4. Конфиг Sway
 Создайте локальный конфиг, скопировав дефолтный:
     
     
     mkdir -p ~/.config/sway
     cp /etc/sway/config ~/.config/sway/config
     Дальше редактируйте ~/.config/sway/config под себя (раскладка, терминал по умолчанию, мод‑клавиша и т.п.).
     
 5. Добавь себя в _seatd
 Сделай под root:
     
     
     usermod -aG _seatd $USER
     Проверь, что ты теперь в группе:
         
         text
         groups $USER    
         
 6. Проверь, что стоят нужные драйверы Mesa:
     
   
     xbps-install mesa-dri mesa-vulkan-radeon mesa-vulkan-intel mesa-vulkan-nouveau        
     
 7. Подключаем дефолтный конфиг
     Сделай в консоли (в другой tty, например Ctrl+Alt+F2) от своего пользователя:
         
   
         mkdir -p ~/.config/sway
         cp /etc/sway/config ~/.config/sway/config
         
 8. Убедись, что этот терминал установлен и стартует из tty:
     
    
     xbps-install alacritty        
     
 9. Поставь базовые TTF‑шрифты:
     
    
     xbps-install fontconfig dejavu-fonts-ttf    
     
10. Install  waybar nm-applet

    sudo xbps-install waybar
    sudo xbps-install -Su NetworkManager network-manager-applet
    
    sudo usermod -aG network $USER    

11. Включение NetworkManager

    sudo ln -s /etc/sv/NetworkManager /var/service/
    sudo sv status NetworkManager
    
12. Меню выключения (wlogout)
Установи:
    
    
    sudo xbps-install wlogout
    В конфиг Sway добавь:
        
    
        bindsym $mod+Shift+E exec wlogout    
    
13. Если хочешь нормальный Wayland‑лаунчер, можно, например, так:
     
     Поставить fuzzel:
         
   
         sudo xbps-install fuzzel
         В ~/.config/sway/config добавить/поменять:
             
   
             set $menu fuzzel --show drun
             bindsym $mod+d exec $menu     
             
14. Как расширить меню
Вариант 1: через конфиг fuzzel.ini:
    
    
    mkdir -p ~/.config
    nano ~/.config/fuzzel.ini
    Добавь:
        
        
        [main]
        width=60        # ширина в символах (по умолчанию 30)
        line-height=22  # по желанию, высота строки
        
15. Установи polkit и агент
В Void обычно делают так:
    
  
    sudo xbps-install polkit lxqt-policykit
    В конфиг Sway добавь автозапуск агента:
        
  
        exec_always lxqt-policykit-agent
  
        sudo ln -s /etc/sv/polkitd /var/service/
        sudo ln -s /etc/sv/dbus    /var/service/
        sudo sv status polkitd dbus
        
16.  Включить автологин на tty1 (agetty)
Открой конфиг службы agetty для первого tty:
    
    
    sudo nano /etc/sv/agetty-tty1/conf
    Найди строку GETTY_ARGS=... и замени её, подставив свой юзернейм (например, alex):
        
    
        GETTY_ARGS="--autologin alex --noclear"
        Перезапусти службу:
            
    
            sudo sv restart agetty-tty1        
            
17. Автостарт sway после автологина
Самый простой способ — в ~/.profile или ~/.bash_profile (в зависимости от оболочки) добавить:
    
    
    if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
        fi
    
            Тогда после автологина на tty1 сразу стартует sway; на других tty можно будет логиниться вручную без автозапуска sway.
                    
18. Звук: PipeWire, pactl и иконка
Поставь аудиостек и утилиты:
    
    
    sudo xbps-install pipewire wireplumber alsa-pipewire pulseaudio-utils pavucontrol
    
    
    pulseaudio-utils даёт pactl, а pipewire-pulse поднимает Pulse‑интерфейс поверх PipeWire.
    ​
    
    Включи сервисы runit (если ещё не включены):
        
    
        sudo ln -s /etc/sv/pipewire /var/service/
        sudo ln -s /etc/sv/pipewire-pulse /var/service/
        sudo ln -s /etc/sv/wireplumber /var/service/
        Перелогинься и проверь:
            
    
            pactl info                                   
            
19. Яркость: brightnessctl и Fn‑клавиши
Поставь:
    
    
    sudo xbps-install brightnessctl
    Добавь себя в группу video, чтобы можно было менять яркость без sudo:
        
    
        sudo usermod -aG video alex
        Потом выйти/зайти в сессию.
        
sudo xbps-install network-manager-applet lxqt-policykit

        
20. Thunar

sudo xbps-install -S Thunar gvfs

21. Сборка и права ddc-bright-helper

gcc -O2 -Wall ddc-bright-helper.c -o ddc-bright-helper

sudo mv ddc-bright-helper /usr/local/bin/ddc-bright-helper
sudo chown root:root /usr/local/bin/ddc-bright-helper
sudo chmod 4755 /usr/local/bin/ddc-bright-helper   # setuid root        ​            