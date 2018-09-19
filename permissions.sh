function fix-perms {
    sudo find /home/fusion809 -exec chown fusion809:wheel {} +
}
