# Nushell Config File
$env.config = {
    show_banner: false
    edit_mode: vi
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "plaintext"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
    }
    table: {
        mode: rounded
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
    }
}

# OSINT & Navigation Aliases
alias ll = ls -l
alias la = ls -la
alias v = nvim
alias py = uv run python
alias proxy = proxychains4 -q
alias ports = nmap -sV -p- -T4
alias scan = rustscan -a
