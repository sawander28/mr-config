# -*- mode: sh -*-


debug_skippers () {
    check_repo_name
    if [ -n "$MR_DEBUG_SKIP" ]; then
        echo "# SKIP $MR_NAME?  $*"
    fi
}

missing_exe () {
    if [ $# != 1 ]; then
	echo >&2 "BUG: missing_exe called with parameters: $*"
	exit 1
    fi
    if which "$1" >/dev/null 2>&1; then
        debug_skippers ". Found $1 in \$PATH"
        return 1 # false
    else
        debug_skippers "! Didn't find $1 in \$PATH"
        return 0 # true
    fi
}

missing_exes () {
    for i in "$@"; do
	if missing_exe "$i"; then
	    return 0 # true
	fi
    done
    return 1 # false
}

missing_file () {
    if [ -f "$1" ]; then
        debug_skippers ". Found file $1"
        return 1 # false
    else
        debug_skippers "! Didn't find file $1"
        return 0 # true
    fi
}

missing_dir () {
    if [ -d "$1" ]; then
        debug_skippers ". Found dir $1"
        return 1 # false
    else
        debug_skippers "! Didn't find dir $1"
        return 0 # true
    fi
}

missing_rpm () {
    if rpm -q "$1" >/dev/null; then
        debug_skippers ". Found rpm $1"
        return 1 # false
    else
        debug_skippers "! Didn't find rpm $1"
        return 0 # true
    fi
}
