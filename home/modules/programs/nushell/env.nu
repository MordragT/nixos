# Nushell Environment Config File
#
# version = "0.99.1"

def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    let in_repo = (do { git rev-parse --abbrev-ref HEAD } | complete | get stdout | is-not-empty)
    let git_segment = if $in_repo {
        let status = git status --porcelain=2 --branch | lines

        let branch = ($status
            | where ($it | str starts-with "# branch.head")
            | first
            | split column ' '
            | get column3
        )
        let branch_prompt = [
            (char space)
            (ansi magenta)
            $branch
            (ansi reset)
        ] | str join

        let staging_worktree = ($status
            | where ($it | str starts-with '1') or ($it | str starts-with '2')
            | split column ' '
            | get column2
            | split column '' staging worktree --collapse-empty
        )

        let staging = {
            added: ($staging_worktree | where staging == 'A' | length),
            modified: ($staging_worktree | where staging in ['M', 'R'] | length),
            deleted: ($staging_worktree | where staging == 'D' | length),
        }
        let has_staging_changes = (
            $staging.added > 0 or
            $staging.modified > 0 or
            $staging.deleted > 0
        )
        let staging_prompt = if $has_staging_changes {
            [
                (char space)
                (ansi green)
                $"+($staging.added) ~($staging.modified) -($staging.deleted)"
                (ansi reset)
            ] | str join
        } else { "" }


        let worktree = {
            added: ($staging_worktree | where worktree == 'A' | length),
            modified: ($staging_worktree | where worktree in ['M', 'R'] | length),
            deleted: ($staging_worktree | where worktree == 'D' | length),
            untracked: ($status | where ($it | str starts-with '?') | length),
        }
        let has_worktree_changes = (
            $worktree.added > 0 or
            $worktree.modified > 0 or
            $worktree.deleted > 0 or
            $worktree.untracked > 0
        )
        let worktree_prompt = if $has_worktree_changes {
            [
                (char space)
                (ansi red)
                $"+($worktree.added) ~($worktree.modified) -($worktree.deleted) ?($worktree.untracked)"
                (ansi reset)
            ] | str join
        } else { "" }


        [
            $branch_prompt,
            $staging_prompt,
            $worktree_prompt,
        ] | str join
    } else { "" }

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
        [
            (ansi red_bold)
            ($env.LAST_EXIT_CODE)
            (ansi reset)
        ] | str join
    } else { "" }

    [$last_exit_code, $git_segment] | str join
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.XDG_STATE_HOME = "~/.local/state"
$env.XDG_DATA_HOME = "~/.local/share"
$env.XDG_CONFIG_HOME = "~/.config"
$env.XDG_CACHE_HOME = "~/.cache"

$env.VAGRANT_HOME = $env.HOME | path join ".local" "share" "vagrant"
