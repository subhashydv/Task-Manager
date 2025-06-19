function test_get_index() {
	local data=( $1 )
	local element=$2
	local expected="$3"
	local message="$4"

	local actual=$( get_index "${data[*]}" ${element} )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_get_index() {
	local IFS=$'\n'
	echo -e "\nGet index"

	local message="Should give index value as 0 when it matches first element of the data"
	local data=( 1 2 3 4 )
	test_get_index "${data[*]}" 1 0 "${message}"

	message="Should not give index value when match not found in the data"
	data=( "1 hello" "2 world" "3 hi" )
	test_get_index "${data[*]}" "3" "" "${message}"
}


function test_modify_task_status() {
	local tasks_data=( $1 )
	local index=$2
	local expected=( $3 )
	local message="$4"

	local actual=( $( modify_task_status "${tasks_data[*]}" ${index} ) )
	assert_expectation "${expected[*]}" "${actual[*]}" "${message}"
}

function test_cases_modify_task_status() {
	local IFS=$'\n'
	echo -e "\nModify task status"

	local message="Should modify first task status pending to done when index is 1"
	local tasks_data=( 1 "1|pending|play" "2|pending|session" )
	local expected=( 1 "1|done|play" "2|pending|session" )
	test_modify_task_status "${tasks_data[*]}" 1 "${expected[*]}" "${message}"

	message="Should not modify task status if task status is not pending"
	tasks_data=( 1 "1|do|play" "2|pending|session")
	expected=( 1 "1|do|play" "2|pending|session")
	test_modify_task_status "${tasks_data[*]}" 1 "${expected[*]}" "${message}"
}

function test_mark_task_as_done() {
	local tasks_data=( $1 )
	local id=$2
	local file_name="$3"
	local expected="$4"
	local message="$5"

	local actual=$( mark_task_as_done "${tasks_data[*]}" ${id} "${file_name}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_mark_task_as_done() {
	local IFS=$'\n'
	echo -e "\nMark task as done"

	local message="Should mark first task as done when given id is 1"
	local tasks_data=( 2 "1|pending|play" "2|pending|pay" "3|pending|playing")
	test_mark_task_as_done "${tasks_data[*]}" 1 "testing_file.csv" "marked task 1 play as done" "${message}"

	message="Should not mark task as done when it is already done"
	tasks_data=( 2 "1|pending|play" "2|done|pay" )
	test_mark_task_as_done "${tasks_data[*]}" 2 "testing_file.csv" "" "${message}"

	message="Should not mark task as done when task doesn't exist"
	tasks_data=( 2 "1|pending|play" "2|pending|pay" )
	test_mark_task_as_done "${tasks_data[*]}" 3 "testing_file.csv" "" "${message}"
	rm "testing_file.csv"
}
