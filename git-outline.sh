#!/bin/bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "$(basename "$0") requires Bash version 4 or later" >&2
	exit 1
fi

set -eu

# Constants
readonly SIGN_NONE=' '
readonly SIGN_LOOSE='L'
readonly SIGN_DIRTY='D'
readonly SIGN_REMOTE_UNAVAILABLE='U'
readonly SIGN_BEHIND='B'
readonly SIGN_AHEAD='A'
readonly SIGN_EMPTY='E'
readonly PORCELAIN_STATUS_LENGTH=6

# Command options
opt_fetch=false

function throw_invalid_option() {
	echo "$(basename "$0"): invalid option -- '$1'"
	echo "Try '$(basename "$0") -h' for more information."
	exit 2
}

function print_usage() {
	cat <<EOM
Usage: $(basename "$0") [OPTION]...

    -f, --fetch
        Fetch branches from remote repositories.
    -h, --help
        Lists usage instructions and available options.
EOM
}

function parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-f | --fetch)
			opt_fetch=true
			shift
			;;
		-h | --help)
			print_usage
			exit 3
			;;
		--)
			shift
			break
			;;
		*) throw_invalid_option "$@" ;;
		esac
	done
}

function check_status() {
	local repo="$1"
	local porcelain=() # result

	local local_branch=''
	local remote_branch=''

	local_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @\{u\} 2>/dev/null)

	# Remote unavailable
	if ${opt_fetch}; then
		if ! git fetch --quiet &>/dev/null; then
			porcelain+=("${SIGN_REMOTE_UNAVAILABLE}")
		fi
	fi

	# Loose repositories
	if [[ ! $(git remote 2>/dev/null) ]]; then
		porcelain+=("${SIGN_LOOSE}")
	fi

	# Empty or dirty repository
	if ! git rev-parse --quiet --verify HEAD >/dev/null; then
		porcelain+=("${SIGN_EMPTY}")
		if ! git diff --quiet --ignore-submodules --cached; then
			porcelain+=("${SIGN_DIRTY}")
		fi
	elif ! git diff --quiet --ignore-submodules HEAD; then
		porcelain+=("${SIGN_DIRTY}")
	fi

	# Remote ahead/behind
	if [[ "${remote_branch}" ]]; then
		if [ "$(git rev-list "${remote_branch}..${local_branch}" --count)" -gt '0' ]; then
			porcelain+=("${SIGN_AHEAD}")
		fi
		if [ "$(git rev-list "${local_branch}..${remote_branch}" --count)" -gt '0' ]; then
			porcelain+=("${SIGN_BEHIND}")
		fi
	fi

	# Padding and space for future extensions without breaking porcelain
	while [ "${#porcelain[@]}" -lt "${PORCELAIN_STATUS_LENGTH}" ]; do
		porcelain+=("${SIGN_NONE}")
	done

	printf '%s' "${porcelain[@]}"
}

function check_branch() {
	local repo="$1"
	local local_branch=''

	local_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	printf '%s' "${local_branch}"
}

function should_use_colors() {
	if [[ ! -t 1 ]]; then
		return 1 # not a terminal, for example pager
	fi

	case "${TERM}" in
	xterm-color | *-256color) return 0 ;;
	esac

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		return 0
	fi

	return 1
}

function main() {
	parse_args "$@"

	# Map (repo => porcelain) and (repo => branch)
	declare -A statuses
	declare -A branches
	while IFS= read -rd '' gitconfig; do
		repo=$(dirname "$(dirname "${gitconfig}")")
		statuses["${repo}"]="$(cd "${repo}" && check_status "${repo}")"
		branches["${repo}"]="$(cd "${repo}" && check_branch "${repo}")"
	done < <(find . -type f -path '*/.git/config' -print0)

	# Sorted repos for pretty and consistent output
	declare -a repos
	if [[ -v statuses[@] ]]; then
		while IFS= read -rd '' repo; do
			repos+=("${repo}")
		done < <(printf '%s\0' "${!statuses[@]}" | sort -z)
	fi

	# Print summary
	local red=''
	local green=''
	local reset=''

	if should_use_colors; then
		red='\e[0;31m'
		green='\e[0;32m'
		reset='\e[0m'
	fi

	for repo in "${repos[@]}"; do
		local status="${statuses[${repo}]}"
		local branch="${branches[${repo}]}"
		if [[ ! -z "${status// /}" ]]; then
			echo -e "${red}${status}${reset} ${repo} [${green}${branch}${reset}]"
		fi
	done
}

main "$@"
