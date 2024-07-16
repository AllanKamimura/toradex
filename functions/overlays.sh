overlays() {
    cmdline=$(cat /proc/cmdline)
    regex='ostree=\/ostree\/boot\.[0-1]\/torizon\/([a-f0-9]+)\/[0-9]+'

    if [[ $cmdline =~ $regex ]]; then
        ostree_id="${BASH_REMATCH[1]}"
        overlay_path="/sysroot/boot/ostree/torizon-$ostree_id/dtb"
        
        if [[ -d $overlay_path ]]; then
            cd "$overlay_path"
        else
            echo "Overlay path not found: $overlay_path"
        fi
    else
        echo "Ostree ID not found in /proc/cmdline"
    fi
}

