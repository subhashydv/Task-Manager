source ../task_library.sh
source read_write_file.sh
source add_task.sh
source mark_task_as_done.sh
source delete_task.sh
source display_list.sh
source display_longlist.sh
source display_view.sh
source display_taglist.sh
source add_tags.sh
source display_help.sh
source test_main.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'
TOTAL_TESTS=0


# ---------------- assert expectation ---------------------#

function assert_expectation() {

	local expected="$1"
	local actual="$2"
	local message="$3"
	TOTAL_TESTS=$(( $TOTAL_TESTS + 1 ))

	local test_result="${GREEN}✔"

	if [[ "${expected}" != "${actual}" ]]
	then
		test_result="${RED}✗"
		EXPECTED+=( "${expected}" )
		ACTUAL+=( "${actual}" )
		MESSAGE+=( "${message}" )
	fi

	echo -e "\t${test_result}${NOCOLOR} ${message}"
}


function generate_error_report() {
	TOTAL_FAILED="${#EXPECTED[@]}"
	local index_value=0

	while (( ${index_value} < ${TOTAL_FAILED} ))
	do
		echo -e "message  : ${MESSAGE[$index_value]}\n"
		echo -e "actual   : ${ACTUAL[$index_value]}\n"
		echo -e "expected : ${EXPECTED[$index_value]}\n\n"
		index_value=$(( $index_value + 1 ))
	done
}


function test_task_manager() {
	test_cases_read_file_data
	test_cases_write_data_file

	test_cases_include_task
	test_cases_get_tag_data
	test_cases_add_task

	test_cases_get_index
	test_cases_modify_task_status
	test_cases_mark_task_as_done

	test_cases_unset_index
	test_cases_delete_task

	test_cases_sort_tags
	test_cases_display_list

	test_cases_convert_status_to_emoji
	test_cases_filter_tasks_by_tags
	test_cases_display_longlist

	test_cases_display_view

	test_cases_get_unique_tags
	test_cases_display_taglist

	test_cases_display_help
	test_cases_main

	echo
	test_cases_append_tags
	test_cases_add_tags

	echo -e "\n\t\tFAILED TESTS : ${#EXPECTED[@]}/${TOTAL_TESTS}\n"
	generate_error_report
}

test_task_manager
