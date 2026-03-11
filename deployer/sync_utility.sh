sync_folder_exact() {
    local rel_src="$1"
    local rel_dest="$2"
    local ssh_conn="$3"

    if [ -z "$rel_src" ] || [ -z "$rel_dest" ] || [ -z "$ssh_conn" ]; then
        echo "Usage: sync_folder_exact <relative_source_folder> <remote_base_dest> <user@host>"
        return 1
    fi

    if [ ! -d "$rel_src" ]; then
        echo "Error: source folder does not exist: $rel_src"
        return 1
    fi

    # Remove trailing slash so basename works consistently
    local src_no_slash="${rel_src%/}"
    local folder_name
    folder_name="$(basename "$src_no_slash")"

    # Remote target becomes: <rel_dest>/<folder_name>/
    local remote_target="${rel_dest%/}/$folder_name/"

    rsync -a --delete -e ssh "$src_no_slash/" "${ssh_conn}:${remote_target}"
}