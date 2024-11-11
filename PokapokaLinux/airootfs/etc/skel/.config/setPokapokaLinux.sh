#!/bin/bash
# PokapokaLinuxの初期設定スクリプト

# 実行確認用のファイルパス
SETUP_FLAG_FILE="$HOME/.config/.run_setPokapokalinux"
DEFAULT_BACKGROUND="/usr/share/backgrounds/PokapokaLinux.png"

sleep 1
until ps -C xfdesktop > /dev/null; do
    sleet 1
done

# 初回実行の場合のみ各種設定を実行
if [ ! -f "$SETUP_FLAG_FILE" ]; then
    # テーマ、アイコン、カーソル、フォントの設定
    xfconf-query -c xsettings -p /Net/ThemeName -s "Materia-light"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Light"
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "elementary"
    xfconf-query -c xsettings -p /Gtk/FontName -s "Noto Sans Mono CJK JP 10"
    # 実行確認用ファイルの作成
    xfconf-query -c xfwm4 -p /general/title_font -s "Sans Bold 9"

    # 画面とモニタのリストを取得
    mapfile -t SCREENS < <(xfconf-query -c xfce4-desktop -lv | grep last-image | awk -F'/' '{print $3}')
    mapfile -t MONITORS < <(xfconf-query -c xfce4-desktop -lv | grep last-image | awk -F'/' '{print $4}')

    # 画面とモニタごとにデフォルト背景画像を設定
    for i in "${!SCREENS[@]}"; do
        xfconf-query -c xfce4-desktop -p "/backdrop/${SCREENS[i]}/${MONITORS[i]}/workspace0/last-image" -s "$DEFAULT_BACKGROUND"
    done

    echo "初期設定を適用しました"  > "$SETUP_FLAG_FILE"
fi
