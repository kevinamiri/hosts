#!/bin/bash

# Constants: Predefined excluded directories
declare -a EXCLUDE_DIRS=(
    "venv"
    "node_modules"
    ".git"
    "build"
    "dist"
    ".github"
    "target"
    "out"
    "bin"
    "lib"
    ".idea"
    ".vscode"
    ".settings"
)

# Constants: File extensions to search for
declare -a FILE_EXTENSIONS=(
    "php"
    "yml"
    "yaml"
    "Dockerfile"
    "ts"
    "py"
)

# Constants: Directories to explicitly include in the search
declare -a INCLUDE_DIRS=(
    "."
)

# Function to construct exclude parameters for the find command
construct_exclude_params() {
    local -a params=()
    for dir in "${EXCLUDE_DIRS[@]}"; do
        params+=(! -path "*/$dir/*")
    done
    echo "${params[@]}"
}

# Function to search files, focusing on included directories
search_files() {
    local ext="$1"
    local -a exclude_params=($(construct_exclude_params))
    local find_command="find"

    # If include directories contain a single dot, search in the current directory and its subdirectories
    if [ "${INCLUDE_DIRS[*]}" == "." ]; then
        $find_command . "${exclude_params[@]}" -type f -name "*.$ext" -print
    # If include directories are not empty and do not contain a single dot, modify the search to focus on these directories
    elif [ ${#INCLUDE_DIRS[@]} -ne 0 ]; then
        # Search within each specified include directory
        for include_dir in "${INCLUDE_DIRS[@]}"; do
            if [ -n "$include_dir" ]; then
                $find_command "$include_dir" "${exclude_params[@]}" -type f -name "*.$ext" -print
            fi
        done
    else
        # Search in all directories except the excluded ones
        $find_command . "${exclude_params[@]}" -type f -name "*.$ext" -print
    fi
}

# Determines the programming language based on file extension
get_language() {
    case "$1" in
        *php) echo "PHP" ;;
        *yml|*yaml) echo "YAML" ;;
        Dockerfile) echo "Dockerfile" ;;
        *ts) echo "TypeScript" ;;
        *py) echo "Python" ;;
        *) echo "Plain Text" ;;
    esac
}

# Generate a Markdown file summarizing project files
generate_markdown() {
    local markdown_path="$1"
    {
        echo 'You will be provided with files and its contexts inside ``` code blocks ```. Your Task is to provide assistant base on these files context and given defined Goals'
        echo -e '\n\n'

        for ext in "${FILE_EXTENSIONS[@]}"; do
            while IFS= read -r file; do
                local language=$(get_language "$file")
                echo "## File: $(basename "$file")"
                echo "\`\`\`$language"
                cat "$file"
                echo "\`\`\`"
                echo "---"
            done < <(search_files "$ext")
        done
        echo 'Goal: Given codes and contexts, please create a readme.me for describing what this project will do.'
    } > "$markdown_path"
}

generate_markdown "prompt.md"
echo "Markdown generation completed."
