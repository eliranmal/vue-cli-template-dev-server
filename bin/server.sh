#!/usr/bin/env bash


function usage {
	printf "%s" '
usage
-----

  [env SOURCE_DIR="$(npm prefix)" TARGET_INIT_COMMAND="dev"] vue-cli-template-dev-server.sh [-h] [<target-dir>] [<project-name>]

 ''
'
}

function info {
    printf "%s%s" "$(usage)" '
overview
--------

  watches source files of a vue-cli custom template project, and triggers the vue-cli init command to rebuild the project.
  to be used while developing custom templates.


flags
-----

  -h
    shows this help page, and quits.


operands
--------

  target-dir
    a path, relative to the custom template project root, of a directory to pour the generated files into.
    the generated project will be created as a child directory of that path.
    defaults to "${SOURCE_DIR}/out".

  project-name
    a name for the generated project directory, which will be nested inside the target directory.
    defaults to "awesome-vue-app".


environment
-----------

  SOURCE_DIR
    the local path of the custom template project to watch.
    defaults to "$(npm prefix)" (the host NPM project).

  TARGET_INIT_COMMAND
    the name of an NPM script command in the output project, to be run once it is generated, right after installing its dependencies.
    defaults to "dev".

 ''
'
}

function main {
	if [[ "$@" =~ '-h' ]]; then
		info
		exit 0
	fi
	validate_os
	setup_environment
	ensure_dependencies
	start "$@"
}

function start {
	local temp_dir
	local expect_file
	local target_dir="${1:-${SOURCE_DIR}/out}"
	local target_project_name="${2:-awesome-vue-app}"

	# we have to ensure the directory exists first, as abs_path() will fail on non-existing directories
	ensure_dir "$target_dir"

	target_dir="$(abs_path "$target_dir")"
	temp_dir="$(create_temp_dir)"
	expect_file="${temp_dir}/vue-init.exp"

	set_traps "$temp_dir"

	log 'hi :)'

	log 'starting vue init survey...'
	start_auto_survey ${target_dir} ${expect_file} ${SOURCE_DIR} "${target_project_name}"
	log 'output project generated using provided answers'
	log 'initializing output project...'
    initialize_target_project ${target_dir}/${target_project_name} "$TARGET_INIT_COMMAND"
    log 'output project initialized'

	log 'waiting for changes...'
	fswatch -o "${SOURCE_DIR}/template" | while read num; do
		log 'change detected'
		log 'auto-generating output project...'
		start_survey ${target_dir} ${expect_file}
		log 'output project regenerated using initial answers'
		log 'waiting for changes...'
	done
}

function setup_environment {
	validate_source_dir
	ensure_source_dir
	ensure_target_init_command
}

function ensure_dependencies {
	ensure_fswatch
	ensure_expect
}

function start_auto_survey {
	local work_dir="$1"
	local expect_file="$2"
	local source_dir="$3"
	local target_project_name="$4"

	# create a directory to force vue-init to ask about overwriting the directory on the first time
	ensure_dir "${work_dir}/$target_project_name"

	(
		cd ${work_dir} >/dev/null 2>&1
		# this will generate an expect file, all filled with answers to the vue-init survey questions
		autoexpect -quiet -f ${expect_file} vue init ${source_dir} "${target_project_name}"
	)

	search_line ${expect_file} 'expect -exact.*'
	if (( $? == 1 )); then
		quit 'initial questions were not answered'
	fi

	# update the generated expect file to suit our needs
	replace_line ${expect_file} 'set timeout -1' 'set timeout 5' # don't wait forever for an answer
	replace_line ${expect_file} 'expect eof' 'interact' # allow the dev server to keep the process running

	# restore execute permissions (they were ruined by the file copy in replace_line)
	chmod u+x ${expect_file}
}

function initialize_target_project {
	local project_dir="$1"
	local init_command="$2"

	if ! is_npm_repo "$project_dir"; then
		return 0
	fi

	(
		cd ${project_dir} >/dev/null 2>&1

		# install dependencies
		npm i >/dev/null 2>&1
		if (( $? == 1 )); then
			quit "failed installing the output project's npm dependencies"
		fi

		# launch dev server / whatever
		if is_npm_command_available "$init_command"; then
			npm run "$init_command" >/dev/null 2>&1
			if (( $? == 1 )); then
				quit "the output project's initialize command execution failed"
			fi
		fi
	)
}

function start_survey {
	local work_dir="$1"
	local expect_file="$2"

	(
		cd ${work_dir} >/dev/null 2>&1
		${expect_file} >/dev/null 2>&1
	)
}

function validate_source_dir {
	if [[ -n "$SOURCE_DIR" ]]; then
		if [[ ! -d "$SOURCE_DIR" ]]; then
			quit '$SOURCE_DIR is not a directory'
		fi
		if ! is_npm_repo "${SOURCE_DIR}"; then
			quit '$SOURCE_DIR is not an npm project'
		fi
	else
		# we know that npm_host_path will be the default value in case $SOURCE_DIR is empty.
		if [[ -z "$(npm_host_path)" ]]; then
			quit 'could not resolve npm host'
		fi
	fi
}

function ensure_source_dir {
	SOURCE_DIR="${SOURCE_DIR:-$(npm_host_path)}"
	SOURCE_DIR="${SOURCE_DIR:+$(abs_path "$SOURCE_DIR")}"
}

function ensure_target_init_command {
	TARGET_INIT_COMMAND="${TARGET_INIT_COMMAND:-dev}"
}

function npm_host_path {
	local npm_prefix="$(npm prefix)"
	if is_npm_repo "$npm_prefix"; then
		printf "%s" "$npm_prefix"
	else
		printf "%s" ""
	fi
}

function is_npm_repo {
	local dir="$1"
	is_file "${dir}/package.json"
}

function is_npm_command_available {
	local cmd="$1"
	[[ -n "$cmd" && -n "$(npm run --parseable | grep '^'"$cmd"':')" ]]
}

function abs_path {
	local path="$1"
	if ! path_exist "$path"; then
		return 1
	fi
	printf "%s" "$(cd "$(dirname "$path")"; pwd)/$(basename "$path")"
}

function ensure_dir {
	local path="$1"
	if ! is_dir "$path"; then
		mkdir -p "$path"
	fi
}

function is_file {
	local path="$1"
	[[ -n "$path" && -f "$path" ]]
}

function is_dir {
	local path="$1"
	[[ -n "$path" && -d "$path" ]]
}

function path_exist {
	local path="$1"
	[[ -n "$path" && -e "$path" ]]
}

function remove_dir {
	rm -rf "$@" >/dev/null 2>&1
}

function create_temp_dir {
	mktemp -d 2>/dev/null || mktemp -d -t 'vue-cli-template-dev-server'
}

function search_line {
	local file="$1"
	local pattern="$2"
	local output
	output="$(grep '^'"$pattern"'$' ${file})"
	[[ -n "$output" ]]
}

function replace_line {
	local file="$1"
	local from="$2"
	local to="$3"
	# bsd/macos specific implementation
	sed -e 's/^'"$from"'$/'"$to"'/' "$file" >"${file}.new"
	mv -- "${file}.new" "$file"
	rm -f "${file}.new"
}

function ensure_fswatch {
	if ! hash fswatch 2>/dev/null; then
		log "fswatch is not installed. installing via brew..."
		# bsd/macos specific implementation
		brew install fswatch
	fi
}

function ensure_expect {
	if ! hash expect 2>/dev/null || ! hash autoexpect 2>/dev/null; then
		log "expect or autoexpect are not installed. installing via brew..."
		# bsd/macos specific implementation
		brew install expect
	fi
}

function validate_os {
	if [[ $OSTYPE = "darwin"* ]]; then # mac
		return 0
	elif [[ $OSTYPE = "linux-gnu" ]]; then # linux
		quit 'linux is not supported at the moment, sorry...'
	elif [[ $OSTYPE = "msys" ]]; then # windows (mingw/git-bash)
		quit 'windows is not supported, sorry...'
	fi
}

function set_traps {
	local temp_dir="$1"
	trap 'remove_dir '"$temp_dir"' ; log_exit ; do_exit' EXIT
}

function log {
	local msg="$1"
	printf "\n[dev-server] %s\n" "$msg"
}

function quit {
	local errMsg="$1"
	if [[ -n "$errMsg" ]]; then
		log "fatal: $errMsg"
	else
		usage
	fi
	exit 1
}

# activated on any 'exit' calls by the EXIT trap
function do_exit {
	# always exit with successful status to avoid the annoying npm error blob on the terminal
	exit 0
}

function log_exit {
	log 'bye!
'
}

# DOwn WInd from the SEwage TREatment PLAnt

main "$@"
