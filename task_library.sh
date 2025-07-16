function read_file_data() {
	local data_file="$1"
	local content

	for content in `cat ${data_file}`
	do
		echo "${content}"
	done
}

function write_data_file() {
	local IFS=$'\n'

	local tasks_data=( $1 )
	local file_name="$2"
	local number_of_elements="${#tasks_data[@]}"
	local index=0
	> "${file_name}"

	while (( ${index} < ${number_of_elements} ))
	do
		echo "${tasks_data[$index]}" >> "${file_name}"
		index=$(( ${index} + 1 ))
	done
}

function include_task() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local task="$2"
	local tags="$3"

	local id=$(( ${tasks_data[0]} + 1 ))
	updated_data=( ${tasks_data[@]} )

	updated_data[0]=${id}
	updated_data+=( "${id}|pending|${task}|${tags}" )
	echo "${updated_data[*]}"
}

function get_tag_data() {
	local tags="$1"
	local tag_data=""
	local identifier=$( cut -d":" -f1  <<< ${tags} )

	if [[ "${identifier}" == "tags" ]]
	then
		tag_data=$( cut -d":" -f2- <<< ${tags} )
	fi
	echo "${tag_data}"
}

function add_task() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local task="$2"
	local file_name="$3"
	local tags="$4"
	local file_written_status

	local tag_data=$( get_tag_data "${tags}")

	local updated_data=( $( include_task "${tasks_data[*]}" "${task}" "${tag_data}") )
	write_data_file "${updated_data[*]}" "${file_name}"
	file_written_status=$?

	if [[ ${file_written_status} == 0 ]]
	then
		local id=${updated_data[0]}
		echo "Created task ${id}"
	fi
}

function get_index() {
	local IFS=$'\n'
	local data=( $1 )
	local pattern="$2"
	local index=0
	local pattern_index

	while [[ ${index} < ${#data[@]} ]]
	do
		if [[ "${pattern}" == "${data[${index}]}" ]]
		then
			pattern_index=${index}
			break
		fi
		index=$(( ${index} + 1 ))
	done
	echo "${pattern_index}"
}

function modify_task_status() {
	local tasks_data=( $1 )
	local index=$2
	local updated_data=( ${tasks_data[@]} )
	local prior_status=$( cut -d"|" -f2 <<< "${tasks_data[$index]}" )
	local exit_status=2

	if [[ "${prior_status}" == "pending" ]]
	then
		updated_data[${index}]=${updated_data[$index]/pending/done}
		exit_status=0
	fi

	echo "${updated_data[*]}"
	return ${exit_status}
}

function mark_task_as_done() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local id=$2
	local file_name="$3"
	local updated_data
	local modification_status

	local tasks_ids=( $( cut -d"|" -f1 <<< "${tasks_data[*]:1}" ) )
	local index=$( get_index "${tasks_ids[*]}" ${id} )

	if [[ $index == "" ]]
	then
		return 1
	fi

	index=$(( $index + 1 ))
	updated_data=( $( modify_task_status "${tasks_data[*]}" ${index} ) )
	modification_status=$?

	if [[ ${modification_status} == 0 ]]
	then
		write_data_file "${updated_data[*]}" "${file_name}"
		local task=$( cut -d"|" -f3 <<< "${updated_data[${index}]}" )
		echo "marked task ${id} ${task} as done"
	fi
}

function unset_index() {
	local data=( $1 )
	local index=$2

	local updated_data=( ${data[@]} )
	unset updated_data[${index}]
	echo "${updated_data[*]}"
}

function delete_task() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local id=$2
	local file_name="$3"

	local tasks_ids=( $( cut -d"|" -f1 <<< "${tasks_data[*]:1}" ) )
	local index=$( get_index "${tasks_ids[*]}" ${id} )

	if [[ ${index} == "" ]]
	then
		return 1
	fi

	index=$(( ${index} + 1 ))
	local updated_data=( $( unset_index "${tasks_data[*]}" ${index} ) )
	write_data_file "${updated_data[*]}" "${file_name}"

	local task=$( cut -d"|" -f3 <<< "${tasks_data[${index}]}" )
	echo "deleted task ${id} ${task}"
}

function sort_tags() {
	local tags="$1"

	local sorted_tags=$( tr "," "\n" <<< ${tags} | sort -n )
	sorted_tags=$( echo -n "${sorted_tags}" | tr "\n" " " )
	echo "${sorted_tags}"
}

function display_list() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local tags
	local sorted_tags

	local display_data=( "id|description|tags" "--|-----------|----" )
	local pending_tasks=( $( grep "|pending|" <<< "${tasks_data[*]}" ) )

	local id=( $( cut -d"|" -f1 <<< "${pending_tasks[*]}" ) )
	local description=( $( cut -d"|" -f3 <<< "${pending_tasks[*]}" ) )

	local index=0
	while [[ "${index}" < "${#pending_tasks[@]}" ]]
	do
		tags=$( cut -d"|" -f4 <<< "${pending_tasks[$index]}" )
		sorted_tags=$( sort_tags "${tags}" )
		display_data+=( "${id[$index]}.|${description[$index]}|[${sorted_tags}]" )
		index=$(( ${index} + 1 ))
	done

	column -ts"|" <<< "${display_data[*]}"
}

function convert_status_to_emoji() {
	local status="$1"

	if [[ ${status} == "pending" ]]
	then
		echo "⌛️"
	elif [[ ${status} == "done" ]]
	then
		echo "✔"
	fi
}

# review below function for naming
function filter_tasks_by_tags() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	IFS=,
	local tags=( $2 )
	IFS=$'\n'
	local filtered_data=( "${tasks_data[*]}" )

	for tag in ${tags[*]}
	do
		filtered_data=( $( grep "^.*|.*|.*|.*${tag}" <<< "${filtered_data[*]}" ) )
	done

	echo "${filtered_data[*]}"
}


function display_longlist() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local label="$2"

	local tags_data=$( get_tag_data "${label}" )
	local filtered_tasks_data=( $( filter_tasks_by_tags "${tasks_data[*]}" "${tags_data}" ) )
	local display_data=( "id|status|description|tags" "--|------|-----------|----" )

	local tags
	local id=( $( cut -d"|" -f1 <<< "${filtered_tasks_data[*]}" ) )
	local status=( $( cut -d"|" -f2 <<< "${filtered_tasks_data[*]}" ) )
	local description=( $( cut -d"|" -f3 <<< "${filtered_tasks_data[*]}" ) )

	local index=0
	while [[ "${index}" < "${#id[*]}" ]]
	do
		status_emoji=$( convert_status_to_emoji "${status[${index}]}" )
		tags=$( cut -d"|" -f4 <<< "${filtered_tasks_data[$index]}" )
		sorted_tags=$( sort_tags "${tags}" )
		display_data+=( "${id[${index}]}.|  ${status_emoji}|${description[${index}]}|[${sorted_tags}]" )
		index=$(( ${index} + 1 ))
	done

	column -ts"|" <<< "${display_data[*]}"
}


function display_view() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local id=$2

	local tasks_ids=( $( cut -d"|" -f1 <<< "${tasks_data[*]}" ) )
	local index=$( get_index "${tasks_ids[*]}" ${id} )

	if [[ ${index} == "" ]]
	then
		return 1
	fi

	local status=$( cut -d"|" -f2 <<< ${tasks_data[${index}]} )
	local description=$( cut -d"|" -f3 <<< ${tasks_data[${index}]} )
	local tags=$( cut -d"|" -f4 <<< ${tasks_data[${index}]} )
	local sorted_tags=$( sort_tags "${tags}" )

	status=$( convert_status_to_emoji "${status}" )

	local user_view=( "id:|${id}" "status:|${status}" "description:|${description}" "tags:|${sorted_tags}" )
	column -ts"|" <<< "${user_view[*]}"
}

function get_unique_tags() {
	local IFS=$'\n'
	local tags=( $1 )

	local unique_tags=( $( tr "," "\n" <<< "${tags[*]}" | sort | uniq ) )
	echo "${unique_tags[*]}"
}

function display_taglist() {
	local IFS=$'\n'
	local tasks_data=( $1 )

	local tags=( $( cut -d"|" -f4 <<< "${tasks_data[*]}" ) )
	local unique_tags=( $( get_unique_tags "${tags[*]}" ) )
	local tag_list=( "tag|task-ids" "---|--------" )

	for tag in "${unique_tags[@]}"
	do
		tag_ids=( $( grep "^.*|.*|.*|.*${tag}" <<< "${tasks_data[*]}" | cut -d"|" -f1 ) )
		tag_ids=$( echo -n "${tag_ids[*]}" | tr "\n" "," )
		tag_list+=( "${tag}|${tag_ids}" )
	done

	column -ts"|" <<< "${tag_list[*]}"
}

function append_tags() {
	local IFS=$'\n'
	local data=( $1 )
	local tags="$2"
	local index="$3"
	local updated_data=( ${data[*]} )
	local seperator=","

	if [[ ${updated_data[$index]:(-1)} == "|" ]]
	then
		seperator=""
	fi

	updated_data[$index]="${data[$index]}${seperator}${tags}"
	echo "${updated_data[*]}"
}

function add_tags() {
	local IFS=$'\n'
	local tasks_data=( $1 )
	local id=$2
	local label="$3"
	local data_file="$4"

	local tag_data=$( get_tag_data "${label}" )
	if [[ ${tag_data} == "" ]]
	then
		return 3
	fi

	local task_ids=$( cut -d"|" -f1 <<< "${tasks_data[*]:1}" )
	local index=$( get_index "${task_ids[*]}" "${id}" )

	if [[ ${index} == "" ]]
	then
		return 1
	fi
	index=$(( ${index} + 1 ))

	local updated_data=$( append_tags "${data[*]}" "${tag_data}" "${index}" )
	write_data_file "${updated_data[*]}" "${data_file}"

	local formatted_tag=$( sed "s/\(.*\),\(.*\)/\1 and \2/" <<< ${tag_data} )
	echo "task ${id} has been tagged with ${formatted_tag}."
}

function display_help() {
	cat "$PWD/database/task_manager_usage.txt"
}


function main() {
	local IFS=$'\n'
	local data_file="$1"
	local sub_command="$2"
	local user_data="$3"
	local tags="$4"

	local tasks_data=( $( read_file_data "${data_file}" 2> /dev/null ) )

	if [[ "${sub_command}" == "add" ]]
	then
		add_task "${tasks_data[*]}" "${user_data}" "${data_file}" "${tags}"
	elif [[ "${sub_command}" == "done" ]]
	then
		mark_task_as_done "${tasks_data[*]}" "${user_data}" "${data_file}"
	elif [[ "${sub_command}" == "delete" ]]
	then
		delete_task "${tasks_data[*]}" "${user_data}" "${data_file}"
	elif [[ "${sub_command}" == "list" ]]
	then
		display_list "${tasks_data[*]:1}"
	elif [[ "${sub_command}" == "longlist" ]]
	then
		display_longlist "${tasks_data[*]:1}" "${user_data}"
	elif [[ "${sub_command}" == "view" ]]
	then
		display_view "${tasks_data[*]:1}" "${user_data}"
	elif [[ "${sub_command}" == "taglist" ]]
	then
		display_taglist "${tasks_data[*]:1}"
	else
		display_help
	fi
}
